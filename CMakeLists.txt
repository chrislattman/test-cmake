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
    add_executable(driver driver.c frac_tester.c)
    libfraction()
    target_link_libraries(driver fraction)
elseif(LIB_MODE STREQUAL dl)
    add_executable(driver driverdl.c)
    libfraction()
else()
    add_executable(driver driver.c fraction.c frac_tester.c)
endif()

# another helpful function is target_include_headers()
