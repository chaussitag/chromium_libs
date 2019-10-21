cmake_minimum_required(VERSION 3.6)
project(modp_b64)

string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  set(LIB_NAME modp_b64)
  set(MODP_B64_SRC modp_b64.cc modp_b64.h modp_b64_data.h)
  add_library(${LIB_NAME} STATIC ${MODP_B64_SRC})
  target_include_directories(${LIB_NAME} PRIVATE ../..)
  target_compile_options(${LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                         -fno-strict-aliasing
                         --param=ssp-buffer-size=4
                         -fstack-protector
                         -funwind-tables
                         -fPIC
                         -fcolor-diagnostics
                         -fmerge-all-constants
                         #-fcrash-diagnostics-dir=../../tools/clang/crashreports
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
                         -Oz
                         -fno-ident
                         -fdata-sections
                         -ffunction-sections
                         #-fno-omit-frame-pointer
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
                       >)

  if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    target_compile_options(${LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
                           -mno-outline
                           -fno-omit-frame-pointer
                         >)
  elseif("${ANDROID_ABI}" STREQUAL "armeabi-v7a")
    target_compile_options(${LIB_NAME} PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
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

  # flags for debug build
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    target_compile_options(${LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:
                           -Wno-undefined-bool-conversion
                           -Wno-tautological-undefined-compare
                          >)
    target_compile_definitions(${LIB_NAME} PRIVATE _DEBUG)
  else()
    target_compile_definitions(${LIB_NAME} PRIVATE NDEBUG)
  endif()

  target_compile_options(${LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:
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
endif()
