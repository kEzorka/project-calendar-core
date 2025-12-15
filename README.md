# Project Calendar - Backend

Backend API for Project Calendar application built with Drogon C++ framework.

## 🚀 Features

- **RESTful API** with JWT authentication
- **Database**: PostgreSQL with comprehensive schema
- **ORM Models**: Auto-generated Drogon ORM models
- **Docker Support**: Full containerization with docker-compose
- **API Controllers**:
  - Authentication (register, login, user profile)
  - Task Management (CRUD, subtasks, assignments)
  - Calendar views
  - User management
- **Integration Tests**: Comprehensive test suite with pytest

## 📋 Prerequisites

- **Docker** and **Docker Compose** (for containerized deployment)
- **OR** for local development:
  - C++20 compiler (g++, clang++)
  - CMake 3.10+
  - PostgreSQL 16
  - Drogon Framework v1.9.8+
  - jwt-cpp library
  - bcrypt library

## ⚙️ Quick Start with Docker

### 1. Start the application

```bash
docker-compose up -d --build
```

This will:
- Start PostgreSQL database with schema and test data
- Build and start the backend API server
- Expose API on `http://localhost:8080`

### 2. Verify it's running

```bash
curl http://localhost:8080/api/auth/register -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test12345","display_name":"Test","work_schedule":[{"weekday":0,"start_time":"09:00:00","end_time":"18:00:00"}]}'
```

### 3. Stop the application

```bash
docker-compose down -v
```

## 🧪 Running Tests

```bash
cd tests
./run_tests.sh
```

Tests cover:
- Authentication flows
- Task CRUD operations
- Subtasks and assignments
- Calendar views
- Authorization checks

See [tests/README.md](tests/README.md) for detailed test documentation.

## 🏗️ Project Structure

```
project-calendar-core/
├── src/
│   ├── main.cpp              # Application entry point
│   ├── models/               # ORM models (auto-generated)
│   └── API/                  # API controllers
│       ├── AuthController.*  # Authentication endpoints
│       ├── TaskController.*  # Task management
│       ├── CalendarController.* # Calendar views
│       ├── UserController.*  # User management
│       └── AuthFilter.*      # JWT authentication filter
├── migrations/               # Database schema and seed data
│   ├── 001_schema.sql        # Database schema
│   └── 002_test_data.sql     # Test data
├── tests/                    # Integration tests
├── CMakeLists.txt            # Build configuration
├── Dockerfile.               # Docker image definition
└── docker-compose.yml        # Docker orchestration
```

## 🔧 Development Setup

### Installing Dependencies (Ubuntu/Debian)

```bash
cd setup
bash setup-drogon.sh
```

See [setup/SETUP.md](setup/SETUP.md) for detailed installation instructions.

### Building Locally

```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### Running Locally

```bash
# Set environment variables
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=project_calendar
export DB_USER=pc_admin
export DB_PASSWORD=pc_password
export JWT_SECRET=your_secret_key

# Run the application
./build/project-calendar
```

## 📡 API Endpoints

### Authentication

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Get current user profile (requires auth)

### Tasks

- `POST /api/tasks` - Create task
- `GET /api/tasks` - List tasks (with filters)
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `GET /api/tasks/{id}/subtasks` - Get subtasks

### Task Assignments

- `POST /api/tasks/{id}/assignments` - Create assignment
- `GET /api/tasks/{id}/assignments` - List assignments
- `DELETE /api/assignments/{id}` - Delete assignment

### Calendar

- `GET /api/calendar/tasks` - Get calendar view of tasks

## 🗄️ Database Schema

The database includes tables for:
- Users (`app_user`)
- Tasks with hierarchy support (`task`)
- Task dependencies (`task_dependency`)
- Role-based assignments (`task_role_assignment`)
- Work hours assignments (`task_assignment`)
- Permissions and roles (`permission`, `role_permission`, `global_role_grant`)
- Delegations (`delegation`, `delegation_permission`)
- Schedules (`user_work_schedule`, `task_schedule`, `project_allocation`)
- Super projects (`super_project`, `super_project_link`)
- Audit logging (`audit_log`)
- Conflict resolution (`conflict_resolution`)

See [migrations/001_schema.sql](migrations/001_schema.sql) for complete schema.

## 🔐 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | Database host | `localhost` |
| `DB_PORT` | Database port | `5432` |
| `DB_NAME` | Database name | `project_calendar` |
| `DB_USER` | Database user | `pc_admin` |
| `DB_PASSWORD` | Database password | `pc_password` |
| `JWT_SECRET` | JWT signing secret | `secret_key` (change in production!) |

## 🐛 Troubleshooting

### Database connection issues

```bash
# Check database is running
docker-compose ps

# View database logs
docker-compose logs db

# Connect to database
docker exec -it project-calendar-db psql -U pc_admin -d project_calendar
```

### Backend issues

```bash
# View backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend
```

### Build issues

```bash
# Clean build
rm -rf build
mkdir build && cd build
cmake .. && make
```

## 📚 References

- [Drogon Framework Documentation](https://drogon.docsforge.com/)
- [Drogon GitHub](https://github.com/drogonframework/drogon)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [jwt-cpp](https://github.com/Thalhammer/jwt-cpp)

## 📝 License

See [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Add tests if applicable
4. Run tests: `cd tests && ./run_tests.sh`
5. Submit a pull request

---

**Status**: ✅ Backend is production-ready with comprehensive test coverage
