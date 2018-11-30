# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)

set(LIB_NAME hello-chromium-base)
set(HELLO_CHROMIUM_BASE_SRC
        jni_onload.cpp
        app_jni_registrar.cpp
        hello_jni_application.cpp
        hello.cpp)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# generate jni headers
set(JNI_GENERATOR
        ${CMAKE_CURRENT_LIST_DIR}/chromium/src/base/android/jni_generator/jni_generator.py)
message(STATUS "JNI_GENERATOR: ${JNI_GENERATOR}")

set(APP_JNI_HEADER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/jni_header_gen)
message(STATUS "APP_JNI_HEADER_OUTPUT_DIR: ${APP_JNI_HEADER_OUTPUT_DIR}")

set(APP_JAVA_SRC_PATH ${CMAKE_CURRENT_LIST_DIR}/../java/example/com/hello_chromium_libs)
message(STATUS "APP_JAVA_SRC_PATH: ${APP_JAVA_SRC_PATH}")

add_custom_command(OUTPUT ${APP_JNI_HEADER_OUTPUT_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${APP_JNI_HEADER_OUTPUT_DIR}
        COMMENT "create the app jni headers output directory: ${APP_JNI_HEADER_OUTPUT_DIR}")

list(APPEND APP_JNI_HEADER_NAMES HelloJniApplication HelloChromiumLibs)
foreach(JNI_HEADER_NAME ${APP_JNI_HEADER_NAMES})
    add_custom_command(OUTPUT ${APP_JNI_HEADER_OUTPUT_DIR}/${JNI_HEADER_NAME}_jni.h
            COMMAND ${JNI_GENERATOR} --input_file ${APP_JAVA_SRC_PATH}/${JNI_HEADER_NAME}.java
            --output_dir ${APP_JNI_HEADER_OUTPUT_DIR}
            --includes base/android/jni_generator/jni_generator_helper.h
            --optimize_generation 0 --ptr_type long
            DEPENDS ${JNI_GENERATOR} ${APP_JNI_HEADER_OUTPUT_DIR} ${APP_JAVA_SRC_PATH}/${JNI_HEADER_NAME}.java
            COMMENT "[jni_generator]: ${JNI_HEADER_NAME}_jni.h <= ${JNI_HEADER_NAME}.java")
    list(APPEND APP_JNI_HEADERS ${APP_JNI_HEADER_OUTPUT_DIR}/${JNI_HEADER_NAME}_jni.h)
endforeach(JNI_HEADER_NAME)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

add_library(${LIB_NAME} SHARED ${HELLO_CHROMIUM_BASE_SRC} ${APP_JNI_HEADERS})
target_include_directories(${LIB_NAME} PRIVATE chromium/src ${APP_JNI_HEADER_OUTPUT_DIR})

find_library(log-lib log)
target_link_libraries(${LIB_NAME} ${log-lib} chromium_base)

add_subdirectory(chromium)