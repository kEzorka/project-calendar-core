"""
Integration tests for Project Calendar API
Tests cover authentication, task management, and calendar functionality
"""

import pytest
import requests
import time
from typing import Dict, Optional
import os

# Configuration
BASE_URL = os.getenv("TEST_BASE_URL", "http://localhost:8081")
API_PREFIX = "/api"


class APIClient:
    """Helper class for API requests"""
    
    def __init__(self, base_url: str = BASE_URL):
        self.base_url = base_url
        self.token: Optional[str] = None
        self.user_id: Optional[str] = None
    
    def set_token(self, token: str, user_id: str):
        """Set authentication token"""
        self.token = token
        self.user_id = user_id
    
    def headers(self) -> Dict[str, str]:
        """Get headers with authentication"""
        headers = {"Content-Type": "application/json"}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        return headers
    
    def post(self, endpoint: str, data: dict, auth: bool = False):
        """POST request"""
        url = f"{self.base_url}{API_PREFIX}{endpoint}"
        headers = self.headers() if auth else {"Content-Type": "application/json"}
        response = requests.post(url, json=data, headers=headers)
        return response
    
    def get(self, endpoint: str, params: dict = None, auth: bool = True):
        """GET request"""
        url = f"{self.base_url}{API_PREFIX}{endpoint}"
        response = requests.get(url, params=params, headers=self.headers() if auth else {})
        return response
    
    def put(self, endpoint: str, data: dict, auth: bool = True):
        """PUT request"""
        url = f"{self.base_url}{API_PREFIX}{endpoint}"
        response = requests.put(url, json=data, headers=self.headers() if auth else {})
        return response
    
    def delete(self, endpoint: str, auth: bool = True):
        """DELETE request"""
        url = f"{self.base_url}{API_PREFIX}{endpoint}"
        response = requests.delete(url, headers=self.headers() if auth else {})
        return response


@pytest.fixture(scope="session")
def wait_for_backend():
    """Wait for backend to be ready"""
    max_retries = 30
    retry_delay = 2
    
    for i in range(max_retries):
        try:
            response = requests.get(f"{BASE_URL}/", timeout=5)
            if response.status_code in [200, 404]:  # Either works, just need connection
                print(f"Backend is ready after {i+1} attempts")
                return True
        except requests.exceptions.RequestException:
            if i < max_retries - 1:
                time.sleep(retry_delay)
            else:
                raise
    
    raise Exception("Backend did not start in time")


@pytest.fixture
def client(wait_for_backend):
    """Create API client"""
    return APIClient()


@pytest.fixture
def registered_user(client):
    """Register a test user and return authenticated client"""
    import uuid
    email = f"test_{uuid.uuid4().hex[:8]}@example.com"
    
    user_data = {
        "email": email,
        "password": "TestPassword123!",
        "display_name": "Test User",
        "name": "Test",
        "surname": "User",
        "work_schedule": [
            {"weekday": 0, "start_time": "09:00:00", "end_time": "18:00:00"},
            {"weekday": 1, "start_time": "09:00:00", "end_time": "18:00:00"},
            {"weekday": 2, "start_time": "09:00:00", "end_time": "18:00:00"},
            {"weekday": 3, "start_time": "09:00:00", "end_time": "18:00:00"},
            {"weekday": 4, "start_time": "09:00:00", "end_time": "18:00:00"}
        ]
    }
    
    response = client.post("/auth/register", user_data)
    assert response.status_code == 201, f"Registration failed: {response.text}"
    
    data = response.json()
    assert "token" in data
    assert "user" in data
    
    client.set_token(data["token"], data["user"]["id"])
    return client


class TestAuthentication:
    """Test authentication endpoints"""
    
    def test_register_user_success(self, client):
        """Test successful user registration"""
        import uuid
        email = f"newuser_{uuid.uuid4().hex[:8]}@example.com"
        
        user_data = {
            "email": email,
            "password": "SecurePass123!",
            "display_name": "New User",
            "work_schedule": [
                {"weekday": 0, "start_time": "09:00:00", "end_time": "17:00:00"}
            ]
        }
        
        response = client.post("/auth/register", user_data)
        assert response.status_code == 201
        
        data = response.json()
        assert data["success"] == True
        assert "token" in data
        assert data["user"]["email"] == email
        assert data["user"]["display_name"] == "New User"
    
    def test_register_duplicate_email(self, registered_user):
        """Test registration with duplicate email"""
        # Get the email from first user
        response = registered_user.get("/auth/me", auth=True)
        email = response.json()["email"]
        
        # Try to register with same email
        user_data = {
            "email": email,
            "password": "AnotherPass123!",
            "display_name": "Duplicate User",
            "work_schedule": [
                {"weekday": 0, "start_time": "09:00:00", "end_time": "17:00:00"}
            ]
        }
        
        response = registered_user.post("/auth/register", user_data)
        assert response.status_code == 409  # Conflict
    
    def test_register_invalid_password(self, client):
        """Test registration with short password"""
        import uuid
        user_data = {
            "email": f"test_{uuid.uuid4().hex[:8]}@example.com",
            "password": "short",
            "display_name": "Test",
            "work_schedule": [
                {"weekday": 0, "start_time": "09:00:00", "end_time": "17:00:00"}
            ]
        }
        
        response = client.post("/auth/register", user_data)
        assert response.status_code == 400
    
    def test_login_success(self, client):
        """Test successful login"""
        import uuid
        email = f"login_{uuid.uuid4().hex[:8]}@example.com"
        password = "LoginPass123!"
        
        # Register user first
        user_data = {
            "email": email,
            "password": password,
            "display_name": "Login User",
            "work_schedule": [
                {"weekday": 0, "start_time": "09:00:00", "end_time": "17:00:00"}
            ]
        }
        client.post("/auth/register", user_data)
        
        # Now login
        login_data = {"email": email, "password": password}
        response = client.post("/auth/login", login_data)
        
        assert response.status_code == 200
        data = response.json()
        assert "token" in data
        assert "user" in data
    
    def test_me_endpoint(self, registered_user):
        """Test /auth/me endpoint"""
        response = registered_user.get("/auth/me", auth=True)
        
        assert response.status_code == 200
        data = response.json()
        assert "id" in data
        assert "email" in data
        assert "display_name" in data
    
    def test_me_without_token(self, client):
        """Test /auth/me without authentication"""
        response = client.get("/auth/me", auth=False)
        assert response.status_code == 401


class TestTaskManagement:
    """Test task-related endpoints"""
    
    def test_create_task(self, registered_user):
        """Test creating a new task"""
        task_data = {
            "title": "Test Task",
            "description": "This is a test task",
            "priority": "high",
            "status": "open",
            "estimated_hours": 10.5
        }
        
        response = registered_user.post("/tasks", task_data, auth=True)
        assert response.status_code == 201
        
        data = response.json()
        assert data["title"] == "Test Task"
        assert data["description"] == "This is a test task"
        assert data["priority"] == "high"
        assert "id" in data
    
    def test_create_task_minimal(self, registered_user):
        """Test creating task with minimal data"""
        task_data = {"title": "Minimal Task"}
        
        response = registered_user.post("/tasks", task_data, auth=True)
        assert response.status_code == 201
        
        data = response.json()
        assert data["title"] == "Minimal Task"
    
    def test_get_tasks(self, registered_user):
        """Test getting tasks list"""
        # Create a task first
        task_data = {"title": "Task for List"}
        registered_user.post("/tasks", task_data, auth=True)
        
        # Get tasks
        response = registered_user.get("/tasks", auth=True)
        assert response.status_code == 200
        
        data = response.json()
        assert isinstance(data, list)
        assert len(data) > 0
    
    def test_create_subtask(self, registered_user):
        """Test creating a subtask"""
        # Create parent task
        parent_data = {"title": "Parent Task"}
        parent_response = registered_user.post("/tasks", parent_data, auth=True)
        parent_id = parent_response.json()["id"]
        
        # Create subtask
        subtask_data = {
            "title": "Subtask",
            "parent_task_id": parent_id
        }
        response = registered_user.post("/tasks", subtask_data, auth=True)
        assert response.status_code == 201
        
        data = response.json()
        assert data["title"] == "Subtask"
        assert data["parent_task_id"] == parent_id
    
    def test_update_task(self, registered_user):
        """Test updating a task"""
        # Create task
        task_data = {"title": "Original Title"}
        create_response = registered_user.post("/tasks", task_data, auth=True)
        task_id = create_response.json()["id"]
        
        # Update task
        update_data = {
            "title": "Updated Title",
            "status": "in_progress"
        }
        response = registered_user.put(f"/tasks/{task_id}", update_data, auth=True)
        assert response.status_code == 200
        
        data = response.json()
        assert data["title"] == "Updated Title"
        assert data["status"] == "in_progress"
    
    def test_delete_task(self, registered_user):
        """Test deleting a task"""
        # Create task
        task_data = {"title": "Task to Delete"}
        create_response = registered_user.post("/tasks", task_data, auth=True)
        task_id = create_response.json()["id"]
        
        # Delete task
        response = registered_user.delete(f"/tasks/{task_id}", auth=True)
        assert response.status_code == 200


class TestTaskAssignments:
    """Test task assignment functionality"""
    
    def test_create_assignment(self, registered_user):
        """Test creating a task assignment"""
        # Create a task
        task_data = {"title": "Task with Assignment"}
        task_response = registered_user.post("/tasks", task_data, auth=True)
        task_id = task_response.json()["id"]
        
        # Try to create assignment for the same user (already exists as owner)
        assignment_data = {"assigned_hours": 5.0}
        response = registered_user.post(
            f"/tasks/{task_id}/assignments",
            assignment_data,
            auth=True
        )
        # Should get 409 Conflict because owner is already assigned
        assert response.status_code == 409
    
    def test_list_assignments(self, registered_user):
        """Test listing task assignments"""
        # Create a task with assignment
        task_data = {"title": "Task for Assignment List"}
        task_response = registered_user.post("/tasks", task_data, auth=True)
        task_id = task_response.json()["id"]
        
        # List assignments
        response = registered_user.get(f"/tasks/{task_id}/assignments", auth=True)
        assert response.status_code == 200
        
        data = response.json()
        assert isinstance(data, list)


class TestCalendar:
    """Test calendar endpoints"""
    
    def test_get_calendar_tasks(self, registered_user):
        """Test getting calendar view of tasks"""
        # Create some tasks
        for i in range(3):
            task_data = {
                "title": f"Calendar Task {i}",
                "start_date": "2024-01-10",
                "due_date": "2024-01-15"
            }
            registered_user.post("/tasks", task_data, auth=True)
        
        # Get calendar tasks
        params = {
            "start_date": "2024-01-01",
            "end_date": "2024-01-31"
        }
        response = registered_user.get("/calendar/tasks", params=params, auth=True)
        assert response.status_code == 200
        
        data = response.json()
        assert isinstance(data, list)


class TestAuthorization:
    """Test authorization and permissions"""
    
    def test_unauthorized_access(self, client):
        """Test accessing protected endpoint without token"""
        response = client.get("/tasks", auth=False)
        assert response.status_code == 401
    
    def test_invalid_token(self, client):
        """Test with invalid token"""
        client.set_token("invalid.token.here", "fake-user-id")
        response = client.get("/tasks", auth=True)
        assert response.status_code == 401


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--tb=short"])
