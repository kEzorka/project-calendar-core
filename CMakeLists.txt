cmake_minimum_required(VERSION 3.10)
project(project-calendar)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Drogon CONFIG REQUIRED)

file(GLOB_RECURSE PROJECT_SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/test_examples/*.cpp
    ${CMAKE_SOURCE_DIR}/headers/*.hpp
)

add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})

target_link_libraries(${PROJECT_NAME} PRIVATE Drogon::Drogon)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/examples
    ${CMAKE_SOURCE_DIR}/headers
)