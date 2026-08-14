cmake_minimum_required(VERSION 4.2)

project(wolf_c_test
    VERSION 1.0
    LANGUAGES C
)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(wolf-c-test
    src/main.c
)

target_compile_options(wolf-c-test PRIVATE
    -Wall
    -Wextra
    -Wpedantic
)
