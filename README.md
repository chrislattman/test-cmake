# Example CMake project

To generate the build system files, run

```
cmake [-DCMAKE_BUILD_TYPE=Debug] [-DLIB_MODE=lib/dl] -S . -B build
```

- Set `CMAKE_BUILD_TYPE` to `Debug` if you want the project compiled for debugging purposes
- Set `LIB_MODE` to `lib` if you want to test the if-else-if-else statement
- Set `LIB_MODE` to `dl` if you want to test the if-else-if-else statement

To build the project, run

```
cmake --build build --target driver/driversl/driverdl
```

- Set `--target` to `driver` if you don't want a separate shared library
- Set `--target` to `driversl` if you want the shared library to be compiled with the project
- Set `--target` to `driverdl` if you want the shared library to be loaded at runtime
- If `--target` is not set, all targets will be built
- For MSVC, add `--config Release` to compile the project without debugging symbols (by default, debug builds are built)

To run the executable:

```
cd build
./driver
```

- For MSVC, you may have to run `cd Debug` or `cd Release` after `cd build`
