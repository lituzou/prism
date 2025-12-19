cmake_minimum_required (VERSION 3.22)

project(prism
    LANGUAGES CXX C
    VERSION 4.9
)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_JAVA_COMPILE_FLAGS "--release" "11")

find_package(Java REQUIRED)
find_package(JNI REQUIRED)
include(UseJava)
include(ExternalProject)
include(GNUInstallDirs)
include(CheckCXXSourceCompiles)
include(CheckCSourceCompiles)

set(PRISM_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include")

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/ext)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src)
