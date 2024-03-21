# Example CMake project

To generate the build system files, run

```
cmake [-DCMAKE_BUILD_TYPE=Debug] [-DLIB_MODE=lib/dl] -S . -B build
```

- Set `CMAKE_BUILD_TYPE` to `Debug` if you want the project compiled for debugging purposes
- Set `LIB_MODE` to `lib` if you want the shared library to be compiled with the project
- Set `LIB_MODE` to `dl` if you want the shared library to be loaded at runtime
- Otherwise, don't set `LIB_MODE` if you don't want a separate shared library

To build the project, run

```
cmake --build build
```

- For MSVC, add `--config Release` to compile the project without debugging symbols (by default, debug builds are built)

To run the executable:

```
cd build
./driver
```

- For MSVC, you may have to run `cd Debug` or `cd Release` after `cd build`
