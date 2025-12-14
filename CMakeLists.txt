cmake_minimum_required(VERSION 3.10)
project(project-calendar)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# =========== БИБЛИОТЕКИ ===========
find_package(Drogon CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)

find_path(BCRYPT_INCLUDE_DIR bcrypt.h
    PATHS /usr/include /usr/local/include
    NO_DEFAULT_PATH
)

if(NOT BCRYPT_INCLUDE_DIR)
    find_path(BCRYPT_INCLUDE_DIR_ALT bcrypt/bcrypt.h
        PATHS /usr/include /usr/local/include
    )
    if(BCRYPT_INCLUDE_DIR_ALT)
        set(BCRYPT_INCLUDE_DIR ${BCRYPT_INCLUDE_DIR_ALT})
    endif()
endif()

find_library(BCRYPT_LIBRARY NAMES bcrypt
    PATHS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu
)

if(BCRYPT_INCLUDE_DIR AND BCRYPT_LIBRARY)
    message(STATUS "✅ Found bcrypt: ${BCRYPT_LIBRARY}")
    message(STATUS "   Include dir: ${BCRYPT_INCLUDE_DIR}")
    
    add_library(bcrypt_lib INTERFACE)
    target_include_directories(bcrypt_lib INTERFACE ${BCRYPT_INCLUDE_DIR})
    target_link_libraries(bcrypt_lib INTERFACE ${BCRYPT_LIBRARY})
    
    add_compile_definitions(HAVE_BCRYPT=1)
else()
    message(FATAL_ERROR "❌ BCrypt not found!
    Установи: sudo apt-get install libbcrypt-dev
    Или создай симлинк: sudo ln -s /usr/local/include/bcrypt/bcrypt.h /usr/include/bcrypt.h")
endif()

# jwt-cpp
find_path(JWT_INCLUDE_DIR jwt-cpp/jwt.h PATHS /usr/local/include /usr/include)
if(JWT_INCLUDE_DIR)
    add_library(jwt-cpp INTERFACE)
    target_include_directories(jwt-cpp INTERFACE ${JWT_INCLUDE_DIR})
    target_link_libraries(jwt-cpp INTERFACE OpenSSL::SSL OpenSSL::Crypto)
else()
    message(FATAL_ERROR "jwt-cpp headers not found!")
endif()

# =========== ОСНОВНОЕ ПРИЛОЖЕНИЕ ===========
file(GLOB_RECURSE SRC_FILES 
    ${CMAKE_SOURCE_DIR}/src/*.cc 
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/src/models/*.cc
    ${CMAKE_SOURCE_DIR}/src/controllers/*.cc
    ${CMAKE_SOURCE_DIR}/src/filters/*.cc
    ${CMAKE_SOURCE_DIR}/src/services/*.cc
)
list(FILTER SRC_FILES EXCLUDE REGEX ".*test_examples.*")

add_executable(${PROJECT_NAME} ${SRC_FILES})
target_link_libraries(${PROJECT_NAME} PRIVATE 
    Drogon::Drogon 
    jwt-cpp 
    bcrypt_lib
)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/src)

# =========== ТЕСТЫ ===========
# 1. Тест JWT
add_executable(test_jwt 
    test_examples/test_jwt.cc 
    src/services/JwtService.cc
)
target_link_libraries(test_jwt PRIVATE 
    Drogon::Drogon 
    jwt-cpp
)
target_include_directories(test_jwt PRIVATE ${CMAKE_SOURCE_DIR}/src)

# 2. Тест AuthFilter
add_executable(test_auth_filter 
    test_examples/test_auth_filter.cc 
    src/filters/AuthFilter.cc              
    src/services/JwtService.cc             
)
target_link_libraries(test_auth_filter PRIVATE 
    Drogon::Drogon 
    jwt-cpp 
)
target_include_directories(test_auth_filter PRIVATE ${CMAKE_SOURCE_DIR}/src)

# 3. РЕАЛЬНЫЙ тест AuthController
add_executable(test_auth_controller 
    test_examples/test_auth_controller_unit.cc
    src/controllers/AuthController.cc           
    src/filters/AuthFilter.cc
    src/services/JwtService.cc
    src/models/AppUser.cc
    src/models/UserWorkSchedule.cc
)
target_link_libraries(test_auth_controller PRIVATE 
    Drogon::Drogon 
    jwt-cpp
    bcrypt_lib
)
target_include_directories(test_auth_controller PRIVATE 
    ${CMAKE_SOURCE_DIR}/src
    ${BCRYPT_INCLUDE_DIR}
)

# =========== КОМПИЛЯЦИЯ ===========
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    foreach(target ${PROJECT_NAME} test_jwt test_auth_filter test_auth_controller)
        target_compile_options(${target} PRIVATE -Wall -Wextra -Wno-unused-parameter)
    endforeach()
endif()

message(STATUS "Build targets: ${PROJECT_NAME}")
message(STATUS "Test targets: test_jwt, test_auth_filter, test_auth_controller")
