cmake_minimum_required(VERSION 3.6.0)

project(chromium)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  message(STATUS "ANDROID_NDK: ${ANDROID_NDK}")
  message(STATUS "ANDROID_ABI: ${ANDROID_ABI}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
endif()

add_subdirectory(src)
