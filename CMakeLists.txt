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
if(WIN32)
    target_compile_options(asan_options INTERFACE /fsanitize=address /Zi)
    target_link_options(asan_options INTERFACE /fsanitize=address)
else()
    target_compile_options(asan_options INTERFACE -fsanitize=address -fno-omit-frame-pointer -g)
    target_link_options(asan_options INTERFACE -fsanitize=address)
endif()

enable_testing()
add_library(tester frac_tester.c)
target_link_libraries(tester PRIVATE asan_options)
add_library(fraction_asan fraction.c)
target_compile_definitions(fraction_asan PRIVATE -DMYLIB_STATIC)
target_link_libraries(fraction_asan PRIVATE asan_options)
add_executable(my_test_bin driver.c)
target_link_libraries(my_test_bin fraction_asan tester asan_options)
target_compile_definitions(my_test_bin PRIVATE -DTEST)
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

# other helpful functions include:
# target_include_directories()
# target_link_directories()
