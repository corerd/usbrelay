@echo off
echo ***************************************************************************
echo ** Configure CMake build system for Windows
echo ** using Microsoft Visual C++ tools chain
echo ***************************************************************************

rem Goto the project root directory where the top CMakeLists.txt file exists
rem that is the CMake working directory
cd %~dp0

rem Launch CMake with the following arguments:
rem     - Generator choice: Microsoft Visual C++ Makefiles
rem     - Source (-S) and build (-B) tree root paths relative to the working directory
rem     - Executable output path relative to build tree root
rem     - CMAKE_BUILD_TYPE defines the executable output sub directory of build tree root
cmake -G "NMake Makefiles" -S. -Bplatforms/Windows/build-msvc -DCMAKE_BUILD_TYPE=Release
pause
