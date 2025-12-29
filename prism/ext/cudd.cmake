set(CUDD_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../cudd")
set(CUDD_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/cudd")
set(CUDD_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/cudd-build")

find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)

set(CUDD_LIB "${CUDD_INSTALL_DIR}/lib/libcudd.a")

ExternalProject_Add(cudd_src
    PREFIX ${CUDD_INSTALL_DIR}
    SOURCE_DIR ${CUDD_ROOT}
    BINARY_DIR ${CUDD_BINARY_DIR}
    # Avoid autoconf issue by changing time-stamp
    PATCH_COMMAND sleep 1
    COMMAND touch ${CUDD_ROOT}/aclocal.m4
    COMMAND sleep 1
    COMMAND touch ${CUDD_ROOT}/configure ${CUDD_ROOT}/config.h.in ${CUDD_ROOT}/Makefile.in
    CONFIGURE_HANDLED_BY_BUILD true
    CONFIGURE_COMMAND
        ${CUDD_ROOT}/configure
        --with-pic=yes
        --prefix=${CUDD_INSTALL_DIR}
    BUILD_COMMAND ${MAKE_EXECUTABLE} -j1
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    COMMAND cp ${CUDD_ROOT}/cudd/cuddInt.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/st/st.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/mtr/mtr.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/epd/epd.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/util/util.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_BINARY_DIR}/config.h ${CUDD_INSTALL_DIR}/include # generated header
    BUILD_IN_SOURCE OFF
    BUILD_BYPRODUCTS ${CUDD_LIB}
)

# Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/15052
file(MAKE_DIRECTORY "${CUDD_INSTALL_DIR}/include")

add_library(cudd STATIC IMPORTED GLOBAL)
set_target_properties(cudd PROPERTIES
    IMPORTED_LOCATION ${CUDD_LIB}
    INTERFACE_INCLUDE_DIRECTORIES "${CUDD_INSTALL_DIR}/include"
)
add_dependencies(cudd cudd_src)
