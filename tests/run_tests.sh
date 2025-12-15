#!/bin/bash

# Integration tests runner for Project Calendar
set -e

echo "=== Project Calendar Integration Tests ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to tests directory
cd "$(dirname "$0")"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python3 is not installed${NC}"
    exit 1
fi

# Install test dependencies
echo -e "${YELLOW}Installing test dependencies...${NC}"
pip3 install -q -r requirements.txt

# Start test environment
echo -e "${YELLOW}Starting test environment with Docker Compose...${NC}"
docker-compose -f docker-compose.test.yml down -v 2>/dev/null || true
docker-compose -f docker-compose.test.yml up -d --build

# Wait for services to be healthy
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 5

# Check if backend is healthy
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8081/ > /dev/null 2>&1; then
        echo -e "${GREEN}Backend is ready!${NC}"
        break
    fi
    attempt=$((attempt + 1))
    echo "Waiting for backend... (attempt $attempt/$max_attempts)"
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}Backend failed to start${NC}"
    docker-compose -f docker-compose.test.yml logs backend-test
    docker-compose -f docker-compose.test.yml down -v
    exit 1
fi

# Run tests
echo -e "${YELLOW}Running integration tests...${NC}"
echo ""

if python3 -m pytest test_api.py -v --tb=short --color=yes; then
    echo ""
    echo -e "${GREEN}✓ All tests passed!${NC}"
    TEST_RESULT=0
else
    echo ""
    echo -e "${RED}✗ Some tests failed${NC}"
    TEST_RESULT=1
fi

# Cleanup
echo ""
echo -e "${YELLOW}Cleaning up test environment...${NC}"
docker-compose -f docker-compose.test.yml down -v

exit $TEST_RESULT
