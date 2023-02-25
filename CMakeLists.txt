cmake_minimum_required(VERSION 3.1)

project(Scheduler)

set(CMAKE_CXX_STANDARD 11)

# Add the source files
set(SOURCE_FILES scheduler_main.cpp scheduler_utils.cpp)

# Add the header file
set(HEADER_FILES scheduler_main.hpp)

# Create an executable from the source files
add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

# Add a custom target for cleaning the build
add_custom_target(clean-build COMMAND ${CMAKE_BUILD_TOOL} clean)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR})

# Set the output directories for the compiled binary, libraries, and archives
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
