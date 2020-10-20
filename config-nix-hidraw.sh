#!/bin/bash
echo "*************************************************************************"
echo "** Configure CMake build system for Linux"
echo "** using hidraw HIDAPI back-end"
echo "*************************************************************************"

# Goto the project root directory where the top CMakeLists.txt file exists
# that is the CMake working directory
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $PROJECT_ROOT

# Launch CMake with the following arguments:
#     - HIDAPI back-end
#     - Generator choice: MinGW Makefiles
#     - Source (-S) and build (-B) tree root paths relative to the working directory
#     - Executable output path relative to build tree root
#     - CMAKE_BUILD_TYPE defines the executable output sub directory of build tree root
cmake -DHIDAPI_BACKEND=hidraw -G "Unix Makefiles" -S. -Bplatforms/Linux/build-hidraw -DCMAKE_BUILD_TYPE=Release

read -p "Press [Enter] key to continue ..."
