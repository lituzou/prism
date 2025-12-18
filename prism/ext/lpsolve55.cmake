set(LPSOLVE55_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lpsolve55/src/lp_solve_5.5")

set(LPSOLVE55_SOURCES
    "${LPSOLVE55_ROOT}/lp_MDO.c"
    "${LPSOLVE55_ROOT}/shared/commonlib.c"
    "${LPSOLVE55_ROOT}/shared/mmio.c"
    "${LPSOLVE55_ROOT}/shared/myblas.c"
    "${LPSOLVE55_ROOT}/ini.c"
    "${LPSOLVE55_ROOT}/fortify.c"
    "${LPSOLVE55_ROOT}/colamd/colamd.c"
    "${LPSOLVE55_ROOT}/lp_rlp.c"
    "${LPSOLVE55_ROOT}/lp_crash.c"
    "${LPSOLVE55_ROOT}/bfp/bfp_LUSOL/lp_LUSOL.c"
    "${LPSOLVE55_ROOT}/bfp/bfp_LUSOL/LUSOL/lusol.c"
    "${LPSOLVE55_ROOT}/lp_Hash.c"
    "${LPSOLVE55_ROOT}/lp_lib.c"
    "${LPSOLVE55_ROOT}/lp_wlp.c"
    "${LPSOLVE55_ROOT}/lp_matrix.c"
    "${LPSOLVE55_ROOT}/lp_mipbb.c"
    "${LPSOLVE55_ROOT}/lp_MPS.c"
    "${LPSOLVE55_ROOT}/lp_params.c"
    "${LPSOLVE55_ROOT}/lp_presolve.c"
    "${LPSOLVE55_ROOT}/lp_price.c"
    "${LPSOLVE55_ROOT}/lp_pricePSE.c"
    "${LPSOLVE55_ROOT}/lp_report.c"
    "${LPSOLVE55_ROOT}/lp_scale.c"
    "${LPSOLVE55_ROOT}/lp_simplex.c"
    "${LPSOLVE55_ROOT}/lp_SOS.c"
    "${LPSOLVE55_ROOT}/lp_utils.c"
    "${LPSOLVE55_ROOT}/yacc_read.c"
)

set(LPSOLVE55_INTERNAL_INCLUDE_DIRS
    "${LPSOLVE55_ROOT}"
    "${LPSOLVE55_ROOT}/shared"
    "${LPSOLVE55_ROOT}/bfp"
    "${LPSOLVE55_ROOT}/bfp/bfp_LUSOL"
    "${LPSOLVE55_ROOT}/bfp/bfp_LUSOL/LUSOL"
    "${LPSOLVE55_ROOT}/colamd"
)

set(LPSOLVE55_INCLUDE_DIRS "${LPSOLVE55_ROOT}")

set(LPSOLVE55_PUBLIC_HEADERS
    "${LPSOLVE55_ROOT}/lp_lib.h"
)

check_c_source_compiles("
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    int main(){isnan(0.0);return 0;}"
    HAS_ISNAN
)

set(LPSOLVE55_DEFINE
    PIC
    YY_NEVER_INTERACTIVE
    PARSER_LP
    INVERSE_ACTIVE=INVERSE_LUSOL
    RoleIsExternalInvEngine
)
if(HAS_ISNAN)
    message(STATUS "Has isnan() function")
else()
    message(STATUS "Does not have isnan() function, setting NOISNAN")
    list(APPEND LPSOLVE55_DEFINE NOISNAN)
endif()


add_library(lpsolve55 SHARED ${LPSOLVE55_SOURCES})
target_include_directories(lpsolve55
    PRIVATE ${LPSOLVE55_INTERNAL_INCLUDE_DIRS}
    INTERFACE ${LPSOLVE55_INCLUDE_DIRS}
)
target_compile_definitions(lpsolve55 PRIVATE ${LPSOLVE55_DEFINE})

install(TARGETS lpsolve55)
