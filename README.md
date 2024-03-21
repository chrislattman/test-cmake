# Example CMake project

To build the project, run

```
cmake [-DCMAKE_BUILD_TYPE=Debug] [-DLIB_MODE=lib/dl] -S . -B build
cmake --build build
```

- Set `CMAKE_BUILD_TYPE` to `Debug` if you want the project compiled for debugging purposes
- Set `LIB_MODE` to `lib` if you want the shared library to be compiled with the project
- Set `LIB_MODE` to `dl` if you want the shared library to be loaded at runtime
- Otherwise, don't set `LIB_MODE` if you don't want a separate shared library

To run the executable:

```
cd build
./driver
```
