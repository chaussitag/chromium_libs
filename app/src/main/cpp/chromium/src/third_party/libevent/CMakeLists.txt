cmake_minimum_required(VERSION 3.6)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  set(LIB_NAME event)
  set(EVENT_SRC
      buffer.c
      evbuffer.c
      evdns.c
      event.c
      event_tagging.c
      evrpc.c
      evutil.c
      http.c
      log.c
      poll.c
      select.c
      signal.c
      strlcpy.c
      epoll.c)

  add_library(${LIB_NAME} STATIC ${EVENT_SRC})
  target_include_directories(${LIB_NAME} PUBLIC "./android")
  target_compile_definitions(${LIB_NAME} PUBLIC ANDROID HAVE_CONFIG_H)
  target_compile_options(${LIB_NAME} PRIVATE
                         -fstack-protector --param=ssp-buffer-size=4 -fno-exceptions
                         -fno-strict-aliasing -Wno-unused-parameter -Wno-missing-field-initializers
                         -fvisibility=hidden -pipe -fPIC -Wno-unused-local-typedefs
                         -Wno-format -march=armv7-a -mtune=generic-armv7-a -mfpu=vfpv3-d16
                         -mfloat-abi=softfp -mthumb -fno-tree-sra -fno-partial-inlining
                         -fno-early-inlining -fno-tree-copy-prop -fno-tree-loop-optimize
                         -fno-move-loop-invariants -fno-caller-saves -Wno-psabi
                         -mthumb-interwork -ffunction-sections -funwind-tables -g
                         -fstack-protector -fno-short-enums -finline-limit=64
                         -Wa,--noexecstack -Os -fdata-sections -ffunction-sections
                         -fomit-frame-pointer -funwind-tables)

  string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "release")
    tart_comile_options(${LIB_NAME} PRIVATE -fno-ident)
  endif()

endif()
