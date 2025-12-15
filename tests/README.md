# Integration Tests for Project Calendar Backend

This directory contains comprehensive integration tests for the Project Calendar backend API.

## Overview

The tests verify:
- **Authentication**: User registration, login, JWT token validation
- **Task Management**: CRUD operations for tasks and subtasks
- **Task Assignments**: Creating and managing task assignments
- **Calendar**: Calendar view of tasks
- **Authorization**: Access control and permissions

## Prerequisites

- Docker and Docker Compose
- Python 3.8+
- pip3

## Running Tests

### Quick Start

```bash
cd tests
./run_tests.sh
```

This script will:
1. Install Python test dependencies
2. Start test database and backend in Docker
3. Wait for services to be ready
4. Run all integration tests
5. Clean up Docker containers

### Manual Testing

If you want to run tests manually:

```bash
# Start test environment
cd tests
docker-compose -f docker-compose.test.yml up -d --build

# Install dependencies
pip3 install -r requirements.txt

# Run tests
python3 -m pytest test_api.py -v

# Cleanup
docker-compose -f docker-compose.test.yml down -v
```

## Test Structure

### Test Classes

- **TestAuthentication**: Tests for `/api/auth/*` endpoints
  - User registration
  - Login
  - Token validation
  - User profile retrieval

- **TestTaskManagement**: Tests for `/api/tasks` endpoints
  - Create task
  - Get tasks list
  - Update task
  - Delete task
  - Create subtasks

- **TestTaskAssignments**: Tests for task assignment endpoints
  - Create assignments
  - List assignments
  - Delete assignments

- **TestCalendar**: Tests for `/api/calendar/*` endpoints
  - Calendar tasks view
  - Date filtering

- **TestAuthorization**: Tests for access control
  - Unauthorized access
  - Invalid tokens
  - Permission checks

## Test Configuration

The tests use the following configuration:

- **Backend URL**: `http://localhost:8081` (configurable via `TEST_BASE_URL` environment variable)
- **Test Database**: PostgreSQL on port 5433
- **JWT Secret**: `test_secret_key_for_testing_only`

## Database

Each test run uses a fresh database:
- Database is initialized from `../migrations/*.sql`
- Test data is created programmatically by tests
- Database is destroyed after tests complete

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

```bash
# Example GitHub Actions workflow
- name: Run Integration Tests
  run: |
    cd project-calendar-core/tests
    ./run_tests.sh
```

## Troubleshooting

### Backend fails to start

Check backend logs:
```bash
docker-compose -f tests/docker-compose.test.yml logs backend-test
```

### Database connection issues

Verify database is healthy:
```bash
docker-compose -f tests/docker-compose.test.yml ps
```

### Tests timeout

Increase wait time in `run_tests.sh` or check backend performance

## Adding New Tests

To add new tests:

1. Add test methods to appropriate class in `test_api.py`
2. Use `registered_user` fixture for authenticated requests
3. Follow naming convention: `test_<functionality>`
4. Include assertions for status codes and response data

Example:
```python
def test_new_feature(self, registered_user):
    """Test description"""
    response = registered_user.get("/new/endpoint", auth=True)
    assert response.status_code == 200
    assert "expected_field" in response.json()
```

## Coverage

Current test coverage:
- ✅ Authentication (registration, login, me)
- ✅ Task CRUD operations
- ✅ Subtask creation
- ✅ Task assignments
- ✅ Calendar view
- ✅ Authorization checks

Future coverage:
- ⬜ Task dependencies
- ⬜ Task schedules
- ⬜ Delegations
- ⬜ Permissions
- ⬜ Super projects
- ⬜ Conflict resolution
