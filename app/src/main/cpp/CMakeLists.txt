cmake_minimum_required(VERSION 3.6.0)

set(LIB_NAME hello-chromium-base)

set(HELLO_CHROMIUM_BASE_SRC
    jni_onload.cpp
    hello.cpp
    app_library_loader_hooks.cpp
    trace_to_file.cpp
    app_library_loader_hooks.h
    trace_to_file.h
)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
set(APP_JNI_HEADER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/app_jni_header_gen)
message(STATUS "APP_JNI_HEADER_OUTPUT_DIR: ${APP_JNI_HEADER_OUTPUT_DIR}")

# generate jni headers for app java files,
# generated file list stored in GENERATED_APP_JNI_HEADERS
include(app_jni_headers.cmake)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

add_library(${LIB_NAME} SHARED ${HELLO_CHROMIUM_BASE_SRC} ${GENERATED_APP_JNI_HEADERS})
target_include_directories(${LIB_NAME} PRIVATE chromium/src ${APP_JNI_HEADER_OUTPUT_DIR})

find_library(log-lib log)
target_link_libraries(${LIB_NAME} ${log-lib} chromium_base)

add_subdirectory(chromium)