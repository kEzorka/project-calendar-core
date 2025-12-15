#!/bin/bash

# Script to fix all includes in source files

cd "$(dirname "$0")"

echo "Fixing includes in source files..."

# Fix includes in all cpp and hpp files
find src -type f \( -name "*.cpp" -o -name "*.hpp" \) | while read file; do
    # Replace model includes
    sed -i 's|#include "../models/\(.*\)\.h"|#include "models/\1.hpp"|g' "$file"
    sed -i 's|#include "\.\./models/\(.*\)\.hpp"|#include "models/\1.hpp"|g' "$file"
    
    # Replace API includes (for files in API directory)
    if [[ $file == *"/API/"* ]]; then
        sed -i 's|#include "\(AuthController\|AuthFilter\|TaskController\|CalendarController\|UsersController\|UserController\)\.h"|#include "API/\1.hpp"|g' "$file"
    fi
    
    # Fix any remaining .h to .hpp in local includes
    sed -i 's|#include "\([^/]*\)\.h"|#include "API/\1.hpp"|g' "$file"
done

# Fix main.cpp separately
sed -i 's|#include "|#include "API/|g' src/main.cpp 2>/dev/null || true

echo "Done!"
