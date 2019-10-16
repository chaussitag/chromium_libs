cmake_minimum_required(VERSION 3.6)
project(libevent)

string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  set(LIB_NAME event)
  set(LIBEVENT_SRC
      buffer.c
      evbuffer.c
      evdns.c
      evdns.h
      event-config.h
      event-internal.h
      event.c
      event.h
      event_tagging.c
      evhttp.h
      evrpc-internal.h
      evrpc.c
      evrpc.h
      evsignal.h
      evutil.c
      evutil.h
      http-internal.h
      http.c
      log.c
      log.h
      min_heap.h
      poll.c
      select.c
      signal.c
      strlcpy-internal.h
      strlcpy.c
      android/config.h
      android/event-config.h
      epoll.c
     )
  add_library(${LIB_NAME} STATIC ${LIBEVENT_SRC})
  target_include_directories(${LIB_NAME} PRIVATE ../../.. android)
  target_compile_definitions(${LIB_NAME} PRIVATE HAVE_CONFIG_H)

  # flags for debug build
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
    target_compile_definitions(${LIB_NAME} PRIVATE _DEBUG)
  else()
    target_compile_definitions(${LIB_NAME} PRIVATE NDEBUG)
  endif()

  target_compile_options(${LIB_NAME} PRIVATE PRIVATE $<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:
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
                         -mno-outline
                         -Wno-builtin-macro-redefined
                         -D__DATE__=
                         -D__TIME__=
                         -D__TIMESTAMP__=
                         #-Xclang -fdebug-compilation-dir
                         #-Xclang .
                         -no-canonical-prefixes
                         -Oz
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
                         -Werror
                         -Wall
                         -Wno-unused-variable
                         -Wno-missing-field-initializers
                         -Wno-unused-parameter
                         -Wno-c++11-narrowing
                         -Wno-unneeded-internal-declaration
                         -Wno-undefined-var-template
                         -Wno-ignored-pragma-optimize
                         >)

  target_compile_options(${LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:C>:
                         -std=c11
                         #--sysroot=../../third_party/android_ndk/sysroot
                         >)

endif()
