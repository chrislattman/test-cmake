cmake_minimum_required(VERSION 3.22)
project(test-cmake VERSION 0.1.0 LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

function(libfraction)
    add_library(fraction SHARED fraction.c)
    target_compile_definitions(fraction PRIVATE -DMYLIB_BUILD)
endfunction()

if(LIB_MODE STREQUAL lib)
    message("lib")
elseif(LIB_MODE STREQUAL dl)
    message("dl")
else()
    message("unused")
endif()

libfraction()

add_executable(driver driver.c fraction.c)
target_compile_definitions(driver PRIVATE -DMYLIB_STATIC)

add_executable(driversl driver.c)
target_link_libraries(driversl fraction)

add_executable(driverdl driverdl.c)

add_custom_target(run-driver
    COMMAND driver
    DEPENDS driver
)

add_custom_target(run-driversl
    COMMAND driversl
    DEPENDS driversl
)

add_custom_target(run-driverdl
    COMMAND driverdl
    DEPENDS driverdl
)

add_library(asan_options INTERFACE)
if(MSVC)
    target_compile_options(asan_options INTERFACE /fsanitize=address /Zi)
    if(CMAKE_C_COMPILER_ID MATCHES "Clang")
        execute_process(
            COMMAND ${CMAKE_C_COMPILER} /clang:-print-file-name=clang_rt.asan_dynamic-x86_64.lib
            OUTPUT_VARIABLE ASAN_DLL_LIB
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        execute_process(
            COMMAND ${CMAKE_C_COMPILER} /clang:-print-file-name=clang_rt.asan_dynamic_runtime_thunk-x86_64.lib
            OUTPUT_VARIABLE ASAN_THUNK_LIB
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(EXISTS "${ASAN_DLL_LIB}" AND EXISTS ${ASAN_THUNK_LIB})
            target_link_libraries(asan_options INTERFACE "${ASAN_DLL_LIB}" "-wholearchive:${ASAN_THUNK_LIB}")
        endif()
    else()
        target_link_options(asan_options INTERFACE /INCREMENTAL:NO)
    endif()
else()
    target_compile_options(asan_options INTERFACE -fsanitize=address -fno-omit-frame-pointer -g)
    target_link_options(asan_options INTERFACE -fsanitize=address)
endif()

enable_testing()
add_executable(my_test_bin driver.c frac_tester.c fraction.c)
target_link_libraries(my_test_bin asan_options)
target_compile_definitions(my_test_bin PRIVATE -DTEST -DMYLIB_STATIC)
if(MSVC AND CMAKE_C_COMPILER_ID MATCHES "Clang")
    set_property(TARGET my_test_bin PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
endif()
# If my_test_bin were a library, the visibility identifier would be more important:
# PRIVATE: specified compiler definitions are only enabled in this library
# PUBLIC: specified compiler definitions are enabled in this library and anything that links this library
# INTERFACE: specified compiler definitions are not enabled in this library, but enabled in anything that links this library
#
# If an entire dependency is only needed if some compiler definition is enabled (add -DMY_FEATURE=ON when generating the build system files):
# option(MY_FEATURE "Enable my feature" OFF)
# if(MY_FEATURE)
#     target_link_libraries(my_app my_test_bin)
#     target_compile_definitions(my_app PRIVATE -DMY_FEATURE)
# endif()
add_test(NAME testcase0 COMMAND my_test_bin)

if(LINUX)
    set(CPACK_GENERATOR "DEB")
    set(CPACK_PACKAGE_NAME "driver")
    set(CPACK_PACKAGE_VERSION "0.1.0")
    set(CPACK_PACKAGE_CONTACT "Chris Lattman <developer@example.com>")
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    # set(CPACK_DEBIAN_PACKAGE_DEPENDS "libssl-dev (>= 3.0.0)")
    include(CPack)
endif()

# other helpful functions include:
# target_include_directories()
# target_link_directories()
