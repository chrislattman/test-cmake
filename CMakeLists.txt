# CMakeLists.txt : CMake project for test-project, include source and define
# project specific logic here.
#
cmake_minimum_required(VERSION 3.22)

project(test-cmake)

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

enable_testing()
add_library(tester frac_tester.c)
add_executable(my_test_bin driver.c)
target_link_libraries(my_test_bin fraction tester)
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
