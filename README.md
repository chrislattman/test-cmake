# Example CMake project

To generate the build system files, run

```
cmake [-DCMAKE_BUILD_TYPE=Debug] \
    [-DCMAKE_C_COMPILER=clang | -T ClangCL] \
    [-DLIB_MODE=lib/dl] \
    -S . -B build
```

- Set `CMAKE_BUILD_TYPE` to `Debug` if you want the project compiled for debugging purposes (doesn't apply to MSVC)
- Set `CMAKE_C_COMPILER` to `clang` if you want to use Clang/LLVM instead of GCC (doesn't apply to MSVC)
- For MSVC, add `-T ClangCL` if you want to use Clang/LLVM instead of MSVC
- Set `LIB_MODE` to `lib` if you want to test the if-else-if-else statement
- Set `LIB_MODE` to `dl` if you want to test the if-else-if-else statement

To build the project, run

```
cmake --build build [--target <driver|driversl|driverdl>]
```

- If `--target` is not set, all targets will be built
- Set `--target` to `driver` if you don't want a separate shared library
- Set `--target` to `driversl` if you want the shared library to be compiled with the project
- Set `--target` to `driverdl` if you want the shared library to be loaded at runtime
- For MSVC, add `--config Release` to compile the project without debugging symbols (by default, debug builds are built)

To run the executable:

```
cmake --build build --target run-<driver|driversl|driverdl>
```

To run the tests:

```
ctest --test-dir build [-C Debug]
```

- Add `-C` flag if using MSVC

To create a distributable .deb file:

```
cd build
cpack
```

- This method also work for .rpm files (but requires extra tools installed)
- On Linux, you'll also see .AppImage files distributed, which are run directly and not installed on the system
- On macOS, .dmg files are used to distribute installable software (in the form of .app applications)
- On Windows, .exe files built with NSIS come with install wizards
