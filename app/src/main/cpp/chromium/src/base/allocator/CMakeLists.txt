cmake_minimum_required(VERSION 3.6)

if(CMAKE_SYSTEM_NAME MATCHES "Android")

  set(LIB_NAME allocator_extension_thunks)
  set(ALLOCATOR_EXTENSION_THUNKS_SRC allocator_extension_thunks.cc)
  add_library(${LIB_NAME} STATIC ${ALLOCATOR_EXTENSION_THUNKS_SRC})

  target_include_directories(${LIB_NAME} PRIVATE "../..")

  target_compile_options(${LIB_NAME} PRIVATE
                         -fstack-protector --param=ssp-buffer-size=4 -fno-exceptions
                         -fno-strict-aliasing -Wno-unused-parameter -Wno-missing-field-initializers
                         -fvisibility=hidden -pipe -fPIC -Wno-unused-local-typedefs -Wno-format
                         -march=armv7-a -mtune=generic-armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp
                         -mthumb -fno-tree-sra -fno-partial-inlining -fno-early-inlining
                         -fno-tree-copy-prop -fno-tree-loop-optimize -fno-move-loop-invariants
                         -fno-caller-saves -Wno-psabi -mthumb-interwork -ffunction-sections
                         -funwind-tables -g -fstack-protector -fno-short-enums
                         -finline-limit=64 -Wa,--noexecstack -fdata-sections
                         -ffunction-sections -fomit-frame-pointer -funwind-tables
                         -fno-rtti -fno-threadsafe-statics -fvisibility-inlines-hidden
                         -Wno-deprecated -Wno-abi -Wno-narrowing -Wno-literal-suffix)

  string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "release")
    target_compile_options(${LIB_NAME} PRIVATE -Os -fno-ident)
  else()
    target_compile_options(${LIB_NAME} PRIVATE -O2 -g)
  endif()

endif()
