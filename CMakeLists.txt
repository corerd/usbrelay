# CMAKE BUILD SYSTEM FOR usbrelay
# ===============================
#
# Working tree:
#
#   usbrelay
#   |   CMakeLists.txt
#   +---hidapi
#   +---platforms
#   |   \---Windows
#   |       +---build-mingw
#   |       |   |   Makefile
#   |       |   +---CMakeFiles
#   |       |   \---Release
#   |       +---build-msvc
#   |       |   |   Makefile
#   |       |   +---CMakeFiles
#   |       |   \---Release
#   |       \---src
#   \---src

# cmake minimum required version is 3.13 because of the -B and -S options
cmake_minimum_required(VERSION 3.13.0)
project(usbrelay)

# Check operating system platform:
# Linux, Windows, and Darwin for MacOS are the values of CMAKE_SYSTEM_NAME
set (PLATFORM_DIR platforms/${CMAKE_SYSTEM_NAME})
if(NOT EXISTS ${PLATFORM_DIR})
    message(FATAL_ERROR "NOT EXISTS PLATFORM_DIR: ${PLATFORM_DIR}")
endif()
if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    if (MSVC)
        add_compile_options(/D _CRT_SECURE_NO_WARNINGS)
    endif()
    set(EXTRA_LIBS setupapi)
else()
    message(FATAL_ERROR "Operating System not supported")
endif()

# The paths to the includes and sources files directories are relative to
# the source tree root.
# By default, the source tree root is the same as the current working directory,
# that is where cmake is called.
# Otherwise the path to the root source tree may be entered in the -S command
# line option (available from cmake version 3.13).
include_directories(
    hidapi
    src 
    ${PLATFORM_DIR}/src
)

file(
    GLOB_RECURSE
    SOURCES
    src/*
    ${PLATFORM_DIR}/src/*
)

# By default, the current working directory, that is where cmake is called,
# is used as build tree root.
# Otherwise the path to the root build tree may be entered in the -B command
# line option (available from cmake version 3.13).
#
# The executable will be in the build tree sub directory whose
# name is taken from ${CMAKE_BUILD_TYPE} variable (usually Release or Debug).
set(EXECUTABLE_OUTPUT_PATH ./${CMAKE_BUILD_TYPE})


add_executable (${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} ${EXTRA_LIBS})