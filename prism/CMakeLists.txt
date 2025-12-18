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

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/ext)

set(PRISM_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include")

file(GLOB DD_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/dd/*.cc")
add_library(dd SHARED ${DD_SOURCES})
target_include_directories(dd PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(dd PUBLIC cudd)

file(GLOB JDD_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/jdd/*.cc")
add_library(jdd SHARED ${JDD_SOURCES})
target_include_directories(jdd PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(jdd PUBLIC dd JNI::JNI)

file(GLOB ODD_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/odd/*.cc")
add_library(odd SHARED ${ODD_SOURCES})
target_include_directories(odd PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(odd PUBLIC dd JNI::JNI)

file(GLOB DV_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/dv/*.cc")
add_library(dv SHARED ${DV_SOURCES})
target_include_directories(dv PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(dv PUBLIC odd dd JNI::JNI)

file(GLOB PRISM_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/prism/*.cc")
add_library(prism SHARED ${PRISM_SOURCES})
target_include_directories(prism PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(prism PUBLIC JNI::JNI)

add_executable(ngprism "${CMAKE_CURRENT_SOURCE_DIR}/src/prism/ngprism.c")
if(WIN32)
    message(STATUS "Windows detected: ngprism will link winsocket ws2_32 library")
    target_link_libraries(ngprism PRIVATE ws2_32)
endif()

file(GLOB PRISMMTBDD_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/mtbdd/*.cc")
add_library(prismmtbdd SHARED ${PRISMMTBDD_SOURCES})
target_include_directories(prismmtbdd PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(prismmtbdd PUBLIC prism dv odd dd JNI::JNI)

file(GLOB PRISMSPARSE_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/sparse/*.cc")
add_library(prismsparse SHARED ${PRISMSPARSE_SOURCES})
target_include_directories(prismsparse PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(prismsparse PUBLIC lpsolve55 prism dv odd dd JNI::JNI)

file(GLOB PRISMHYBRID_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/hybrid/*.cc")
add_library(prismhybrid SHARED ${PRISMHYBRID_SOURCES})
target_include_directories(prismhybrid PUBLIC ${PRISM_INCLUDE_DIRS})
target_link_libraries(prismhybrid PUBLIC prismsparse prism dv odd dd JNI::JNI)

install(TARGETS dd jdd odd dv prism prismmtbdd prismsparse prismhybrid ngprism)
