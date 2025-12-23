set(CUDD_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../cudd")
set(CUDD_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/cudd")

ExternalProject_Add(cudd_src
    PREFIX ${CUDD_INSTALL_DIR}
    SOURCE_DIR ${CUDD_ROOT}
    # Avoid autoconf issue by changing time-stamp
    PATCH_COMMAND sleep 1
    COMMAND touch ${CUDD_ROOT}/aclocal.m4
    COMMAND sleep 1
    COMMAND touch ${CUDD_ROOT}/configure ${CUDD_ROOT}/config.h.in ${CUDD_ROOT}/Makefile.in
    CONFIGURE_COMMAND
        ${CUDD_ROOT}/configure
        --with-pic=yes
        --prefix=${CUDD_INSTALL_DIR}
        CC=${CMAKE_C_COMPILER}
        CXX=${CMAKE_CXX_COMPILER}
        CFLAGS=${CMAKE_C_FLAGS}
        CXXFLAGS=${CMAKE_CXX_FLAGS}
    BUILD_COMMAND make -j1
    INSTALL_COMMAND make -j1 install
    COMMAND cp ${CUDD_ROOT}/cudd/cuddInt.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/st/st.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/mtr/mtr.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/epd/epd.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/util/util.h ${CUDD_INSTALL_DIR}/include
    COMMAND cp ${CUDD_ROOT}/config.h ${CUDD_INSTALL_DIR}/include # generated header
    BUILD_IN_SOURCE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
    LOG_OUTPUT_ON_FAILURE ON
)

# Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/15052
file(MAKE_DIRECTORY "${CUDD_INSTALL_DIR}/include")

add_library(cudd STATIC IMPORTED GLOBAL)
set_target_properties(cudd PROPERTIES
    IMPORTED_LOCATION "${CUDD_INSTALL_DIR}/lib/libcudd.a"
    INTERFACE_INCLUDE_DIRECTORIES "${CUDD_INSTALL_DIR}/include"
)
add_dependencies(cudd cudd_src)
