cmake_minimum_required(VERSION 3.6.0)
project(chromium-libs)

message(STATUS "CMAKE_VERBOSE_MAKEFILE: ${CMAKE_VERBOSE_MAKEFILE}")

string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

set(LIB_NAME hello-chromium-base)

set(HELLO_CHROMIUM_BASE_SRC
    jni_onload.cpp
    main_activity_jni.cpp
    app_library_loader_hooks.cpp
    startup_helper.cc
    trace_to_file.cpp
    app_scheduler/app_task_traits.cc
    app_scheduler/app_task_queues.cc
    app_scheduler/app_ui_thread_scheduler.cc
    app_scheduler/app_task_executor.cc
    main_activity_jni.h
    app_library_loader_hooks.h
    startup_helper.h
    trace_to_file.h
    app_scheduler/app_task_traits.h
    app_scheduler/app_task_queues.h
    app_scheduler/app_ui_thread_scheduler.h
    app_scheduler/app_task_executor.h
)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
set(APP_JNI_HEADER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/app_jni_header_gen)
message(STATUS "APP_JNI_HEADER_OUTPUT_DIR: ${APP_JNI_HEADER_OUTPUT_DIR}")

# generate jni headers for app java files,
# generated file list stored in GENERATED_APP_JNI_HEADERS
include(app_jni_headers.cmake)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

add_library(${LIB_NAME} SHARED ${HELLO_CHROMIUM_BASE_SRC} ${GENERATED_APP_JNI_HEADERS})
target_include_directories(${LIB_NAME} PRIVATE ./ chromium/src ${APP_JNI_HEADER_OUTPUT_DIR})

find_library(log-lib log)
target_link_libraries(${LIB_NAME} ${log-lib} chromium_base)

# linker flags
set_property(TARGET ${LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
" -Wl,--fatal-warnings \
-fPIC \
-Wl,-z,noexecstack \
-Wl,-z,relro \
-Wl,-z,defs \
-Wl,--as-needed \
-fuse-ld=lld \
-Wl,--color-diagnostics \
-Wl,--no-rosegment \
-Wl,--exclude-libs=libgcc.a \
-Wl,--exclude-libs=libvpx_assembly_arm.a \
-Werror \
-Wl,--gdb-index \
-Wl,--warn-shared-textrel \
-Wl,-wrap,calloc \
-Wl,-wrap,free \
-Wl,-wrap,malloc \
-Wl,-wrap,memalign \
-Wl,-wrap,posix_memalign \
-Wl,-wrap,pvalloc \
-Wl,-wrap,realloc \
-Wl,-wrap,valloc "
#--gcc-toolchain=../../third_party/android_ndk/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64 \
#-Wl,-z,max-page-size=4096 \
#-Wl,-mllvm,-enable-machine-outliner=never \
#--target=aarch64-linux-android \
#-nostdlib \
#--sysroot=../../third_party/android_ndk/platforms/android-21/arch-arm64 \
)

if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
  # linker flags for arm64-v8a only
  set_property(TARGET ${LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
" -Wl,-z,max-page-size=4096 \
-Wl,-mllvm,-enable-machine-outliner=never "
)
endif()

# linker flags for release build only
if(NOT "${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
  set_property(TARGET ${LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
" -Wl,--icf=all \
-Wl,--warn-shared-textrel \
-Wl,-O2 \
-Wl,--gc-sections "
)
endif()

add_subdirectory(chromium)
