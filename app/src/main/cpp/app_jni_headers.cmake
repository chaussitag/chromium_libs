set(JNI_GENERATOR
        ${CMAKE_CURRENT_LIST_DIR}/chromium/src/base/android/jni_generator/jni_generator.py)
message(STATUS "JNI_GENERATOR: ${JNI_GENERATOR}")

#set(APP_JNI_HEADER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/app_jni_header_gen)
#message(STATUS "APP_JNI_HEADER_OUTPUT_DIR: ${APP_JNI_HEADER_OUTPUT_DIR}")

set(APP_JAVA_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/../java/example/com/hello_chromium_libs)
message(STATUS "APP_JAVA_SRC_DIR: ${APP_JAVA_SRC_DIR}")

add_custom_command(OUTPUT ${APP_JNI_HEADER_OUTPUT_DIR}
                   COMMAND ${CMAKE_COMMAND} -E make_directory ${APP_JNI_HEADER_OUTPUT_DIR}
                   COMMENT "create the app jni headers output directory: ${APP_JNI_HEADER_OUTPUT_DIR}"
)

list(APPEND APP_JAVA_NAMES
            MainActivity
            TraceToFile
)
foreach(JAVA_NAME ${APP_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${APP_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${JNI_GENERATOR}
            --ptr_type=long
            --includes base/android/jni_generator/jni_generator_helper.h
            --input_file ${APP_JAVA_SRC_DIR}/${JAVA_NAME}.java
            --output_file ${APP_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${JNI_GENERATOR} ${APP_JNI_HEADER_OUTPUT_DIR}
                    ${APP_JAVA_SRC_DIR}/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= ${JAVA_NAME}.java")
    list(APPEND GENERATED_APP_JNI_HEADERS ${APP_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)