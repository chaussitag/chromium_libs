cmake_minimum_required(VERSION 3.6.0)
project(base)

string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  set(CHROMIUM_BASE_LIB_NAME chromium_base)

  # load source files into variable BASE_SRC
  include(base_sources.cmake)

  set(BASE_STATIC_SRC
      base_switches.cc
      base_switches.h
     )
  set(ASHMEM_SRC
      ../third_party/ashmem/ashmem-dev.c
      ../third_party/ashmem/ashmem.h
     )
  set(BASE_NUMERICS_SRC
      numerics/checked_math_impl.h
      numerics/clamped_math_impl.h
      numerics/safe_conversions_arm_impl.h
      numerics/safe_conversions_impl.h
      numerics/safe_math_arm_impl.h
      numerics/safe_math_clang_gcc_impl.h
      numerics/safe_math_shared_impl.h
      numerics/checked_math.h
      numerics/clamped_math.h
      numerics/math_constants.h
      numerics/ranges.h
      numerics/safe_conversions.h
      numerics/safe_math.h
     )

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  set(CAN_UNWIND_WITH_FRAME_POINTERS 0)
  if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    set(CAN_UNWIND_WITH_FRAME_POINTERS 1)
  endif()

  set(ENABLE_GDBINIT_WARNING 0)
  # for release build only
  if(NOT "${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    set(ENABLE_GDBINIT_WARNING 1)
  endif()

  set(CHROMIUM_HEADER_GEN_DIR ${CMAKE_BINARY_DIR}/chromium_header_gen)

  set(BASE_BUILDFLAGS_GEN_DIR ${CHROMIUM_HEADER_GEN_DIR}/buildflags_header_gen)
  configure_file(../chromium_header_gen/buildflags_template/base/debug/debugging_buildflags.h.in
                 ${BASE_BUILDFLAGS_GEN_DIR}/base/debug/debugging_buildflags.h
                )

  set(BASE_GENERATED_BUILDFLAGS
      ${BASE_BUILDFLAGS_GEN_DIR}/base/debug/debugging_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/cfi_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/clang_coverage_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/memory/protected_memory_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/sanitizer_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/android/orderfile/orderfile_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/android/library_loader/anchor_functions_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/partition_alloc_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/allocator/buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/generated_build_date.h
      ../chromium_header_gen/buildflags_header_gen/base/logging_buildflags.h
      ../chromium_header_gen/buildflags_header_gen/base/synchronization/synchronization_buildflags.h
     )
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  set(BASE_JNI_HEADER_OUTPUT_DIR
      ${CHROMIUM_HEADER_GEN_DIR}/jni_header_gen/base/base_jni_headers/base/jni)
  message(STATUS "BASE_JNI_HEADER_OUTPUT_DIR: ${BASE_JNI_HEADER_OUTPUT_DIR}")

  # generate jni headers for java file under base/android/java,
  # generated file list stored in GENERATED_BASE_JNI_HEADERS
  include(base_jni_headers.cmake)

  list(APPEND GENERATED_CHROMIUM_JNI_HEADERS
       ${GENERATED_BASE_JNI_HEADERS}
       ../chromium_header_gen/jni_header_gen/base/android_runtime_jni_headers/base/jni/Runnable_jni.h
       ../chromium_header_gen/jni_header_gen/base/android_runtime_jni_headers/base/jni/Runtime_jni.h
      )
  # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  add_library(${CHROMIUM_BASE_LIB_NAME} SHARED
              ${BASE_SRC}
              ${BASE_STATIC_SRC}
              ${ASHMEM_SRC}
              ${BASE_NUMERIC_SRC}
              ${BASE_GENERATED_BUILDFLAGS}
              ${GENERATED_CHROMIUM_JNI_HEADERS}
             )

  target_include_directories(${CHROMIUM_BASE_LIB_NAME} PUBLIC
                             ..
                             ../chromium_header_gen/jni_header_gen/base/android_runtime_jni_headers/base
                             ../chromium_header_gen/buildflags_header_gen
                             ../chromium_header_gen/buildflags_header_gen/base/base_jni_headers
                             ../chromium_header_gen/buildflags_header_gen/base/base_jni_headers/base
                             ../chromium_header_gen/buildflags_header_gen/base/android_runtime_jni_headers
                             ../chromium_header_gen/buildflags_header_gen/base/android_runtime_jni_headers/base
                             ${BASE_JNI_HEADER_OUTPUT_DIR}/..
                             ${BASE_BUILDFLAGS_GEN_DIR}
                             ${ANDROID_NDK}/sources/android/cpufeatures
                            )
  target_compile_definitions(${CHROMIUM_BASE_LIB_NAME} PUBLIC COMPONENT_BUILD BASE_IMPLEMENTATION)
  # flags for debug build
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    target_compile_definitions(${CHROMIUM_BASE_LIB_NAME} PUBLIC _DEBUG)
  else()
    target_compile_definitions(${CHROMIUM_BASE_LIB_NAME} PUBLIC NDEBUG)
  endif()

  target_compile_definitions(${CHROMIUM_BASE_LIB_NAME} PRIVATE NO_TCMALLOC)

  target_compile_options(${CHROMIUM_BASE_LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                         -fno-strict-aliasing
                         --param=ssp-buffer-size=4
                         -fstack-protector
                         -funwind-tables
                         -fPIC
                         -fcolor-diagnostics
                         -fmerge-all-constants
                         -fcrash-diagnostics-dir=../../tools/clang/crashreports
                         #-Xclang -mllvm
                         #-Xclang -instcombine-lower-dbg-declare=0
                         -fcomplete-member-pointers
                         -ffunction-sections
                         -fno-short-enums
                         #--target=aarch64-linux-android
                         #-isystem../../third_party/android_ndk/sysroot/usr/include/aarch64-linux-android
                         #-D__ANDROID_API__=21
                         #-mno-outline
                         -Wno-builtin-macro-redefined
                         -D__DATE__=
                         -D__TIME__=
                         -D__TIMESTAMP__=
                         #-Xclang -fdebug-compilation-dir
                         #-Xclang .
                         -no-canonical-prefixes
                         -Wall
                         -Werror
                         -Wextra
                         -Wimplicit-fallthrough
                         -Wthread-safety
                         -Wextra-semi
                         -Wno-missing-field-initializers
                         -Wno-unused-parameter
                         -Wno-c++11-narrowing
                         -Wno-unneeded-internal-declaration
                         -Wno-undefined-var-template
                         -Wno-ignored-pragma-optimize
                         -fno-ident
                         -fdata-sections
                         -ffunction-sections
                         -fno-omit-frame-pointer
                         -g2
                         -ggnu-pubnames
                         -fvisibility=hidden
                         #-Xclang -add-plugin
                         #-Xclang find-bad-constructs
                         #-Xclang -plugin-arg-find-bad-constructs
                         #-Xclang check-ipc
                         -Wheader-hygiene
                         -Wstring-conversion
                         -Wtautological-overlap-compare
                         -Wno-char-subscripts
                         -Wglobal-constructors
                         -Wexit-time-destructors
                         -Wshadow
                         -Wexit-time-destructors
                       >)

  if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    target_compile_options(${CHROMIUM_BASE_LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                           -mno-outline
                           -fno-omit-frame-pointer
                         >)
  elseif("${ANDROID_ABI}" STREQUAL "armeabi-v7a")
    target_compile_options(${CHROMIUM_BASE_LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                           -DHAVE_PTHREAD_COND_TIMEDWAIT_MONOTONIC=1
                           -march=armv7-a
                           -mfloat-abi=softfp
                           -mtune=generic-armv7-a
                           -mfpu=neon
                           -mthumb
                           -fomit-frame-pointer
                           -gdwarf-3
                         >)
  endif()

  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    # build flags for debug build only
    target_compile_options(${LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                           -Oz
                         >)
  else()
    # build flags for release build only
    target_compile_options(${LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                           -O2
                         >)
  endif()

  target_compile_options(${CHROMIUM_BASE_LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)

  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    target_compile_options(${LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:
                           -Wno-undefined-bool-conversion
                           -Wno-tautological-undefined-compare
                         >)
  endif()

  target_compile_options(${CHROMIUM_BASE_LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:
                         -std=c++14
                         -fno-exceptions
                         -fno-rtti
                         #-nostdinc++
                         #-isystem../../buildtools/third_party/libc++/trunk/include
                         #-isystem../../buildtools/third_party/libc++abi/trunk/include
                         #--sysroot=../../third_party/android_ndk/sysroot
                         #-isystem../../third_party/android_ndk/sources/android/support/include
                         -fvisibility-inlines-hidden
                       >)

  # linker flags
  set_property(TARGET ${CHROMIUM_BASE_LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
"-Wl,--fatal-warnings \
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
-Wl,-wrap,valloc"
#--gcc-toolchain=../../third_party/android_ndk/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64 \
#-Wl,-z,max-page-size=4096 \
#-Wl,-mllvm,-enable-machine-outliner=never \
#--target=aarch64-linux-android \
#-nostdlib \
#--sysroot=../../third_party/android_ndk/platforms/android-21/arch-arm64 \
)

  if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    # linker flags for arm64-v8a only
    set_property(TARGET ${CHROMIUM_BASE_LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
"-Wl,-z,max-page-size=4096 \
-Wl,-mllvm,-enable-machine-outliner=never"
)
  endif()


  # linker flags for release build only
  if(NOT "${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    set_property(TARGET ${CHROMIUM_BASE_LIB_NAME} APPEND_STRING PROPERTY LINK_FLAGS
"-Wl,--warn-shared-textrel \
-Wl,-O2"
#-Wl,--gc-sections"
)
  endif()

  find_library(log log)
  find_library(dl dl)
  find_library(android android)
  message(STATUS "log: ${log}")
  message(STATUS "android: ${android}")
  target_link_libraries(${CHROMIUM_BASE_LIB_NAME} PRIVATE
                        ${CMAKE_CURRENT_LIST_DIR}/android/library_loader/anchor_functions.lds
                        dynamic_annotations
                        event
                        modp_b64
                        boringssl
                        cpufeatures
                        ${android} ${log} ${dl}
                       )

  add_subdirectory(third_party/dynamic_annotations)
  add_subdirectory(third_party/libevent)
  add_subdirectory(../third_party/modp_b64 ${CMAKE_BINARY_DIR}/third_party/modp_b64)
  add_subdirectory(../third_party/boringssl ${CMAKE_BINARY_DIR}/third_party/boringssl)

  # build cpufeatures as a static lib
  add_library(cpufeatures STATIC
              ${ANDROID_NDK}/sources/android/cpufeatures/cpu-features.c
             )
endif()
