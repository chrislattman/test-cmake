# CMakeLists.txt : CMake project for test-project, include source and define
# project specific logic here.
#
cmake_minimum_required(VERSION 3.22)

project(test-cmake)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED TRUE)

function(libfraction)
    add_library(fraction SHARED fraction.c)
endfunction()

if(LIB_MODE STREQUAL lib)
    message("lib")
elseif(LIB_MODE STREQUAL dl)
    message("dl")
else()
    message("unused")
endif()

libfraction()

add_executable(driver driver.c fraction.c frac_tester.c)

add_executable(driversl driver.c frac_tester.c)
target_link_libraries(driversl fraction)

add_executable(driverdl driverdl.c)

# other helpful functions include:
# target_include_directories()
# target_link_directories()
# target_compile_definitions()
