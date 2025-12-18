set(LPSOLVE55J_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lp_solve_5.5_java")

set(LPSOLVE55J_INCLUDE_DIRS
    "${LPSOLVE55J_ROOT}/src/c"
)

add_library(lpsolve55j SHARED "${LPSOLVE55J_ROOT}/src/c/lpsolve5j.cpp")
target_include_directories(lpsolve55 PRIVATE ${LPSOLVE55J_INCLUDE_DIRS})
target_link_libraries(lpsolve55j PRIVATE lpsolve55 JNI::JNI)

file(GLOB LPSOLVE55J_JAVA_SOURCES "${LPSOLVE55J_ROOT}/src/java/lpsolve/*.java")
add_jar(lpsolve55j_jar ${LPSOLVE55J_JAVA_SOURCES}
    OUTPUT_NAME "lpsolve55j"
)

install(TARGETS lpsolve55j)
install_jar(lpsolve55j_jar ${CMAKE_INSTALL_LIBDIR})
