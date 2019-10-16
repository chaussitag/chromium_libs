set(CHROMIUM_JNI_GENERATOR ${CMAKE_CURRENT_LIST_DIR}/android/jni_generator/jni_generator.py)
message(STATUS "CHROMIUM_JNI_GENERATOR: ${CHROMIUM_JNI_GENERATOR}")

set(BASE_JAVA_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/android/java/src/org/chromium/base)
message(STATUS "BASE_JAVA_SRC_DIR: ${BASE_JAVA_SRC_DIR}")

add_custom_command(OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}
                   COMMAND ${CMAKE_COMMAND} -E make_directory ${BASE_JNI_HEADER_OUTPUT_DIR}
                   COMMENT "create the jni headers output directory: ${BASE_JNI_HEADER_OUTPUT_DIR}"
)

# add --use_proxy_hash to jni_generator.py for release build
set(CHROMIUM_JNI_GENERATOR_USE_PROXY "")
if(NOT "${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "release")
    set(CHROMIUM_JNI_GENERATOR_USE_PROXY "--use_proxy_hash")
endif()

list(APPEND BASE_JAVA_NAMES
            AnimationFrameTimeHistogram
            ApkAssets
            ApplicationStatus
            BuildInfo
            BundleUtils
            Callback
            CommandLine
            ContentUriUtils
            CpuFeatures
            EarlyTraceEvent
            EventLog
            FieldTrialList
            ImportantFileWriterAndroid
            IntStringCallback
            JNIUtils
            JavaExceptionReporter
            JavaHandlerThread
            LocaleUtils
            MemoryPressureListener
            PathService
            PathUtils
            PowerMonitor
            SysUtils
            ThreadUtils
            TimeUtils
            TimezoneUtils
            TraceEvent
            UnguessableToken
)

foreach(JAVA_NAME ${BASE_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${CHROMIUM_JNI_GENERATOR} ${CHROMIUM_JNI_GENERATOR_USE_PROXY}
                    --ptr_type=long
                    --includes base/android/jni_generator/jni_generator_helper.h
                    --input_file ${BASE_JAVA_SRC_DIR}/${JAVA_NAME}.java
                    --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
                    ${BASE_JAVA_SRC_DIR}/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= ${JAVA_NAME}.java"
    )
    list(APPEND GENERATED_BASE_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)


list(APPEND BASE_LIBRARYLOADER_JAVA_NAMES
            LibraryLoader
            LibraryPrefetcher
)
foreach(JAVA_NAME ${BASE_LIBRARYLOADER_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${CHROMIUM_JNI_GENERATOR} ${CHROMIUM_JNI_GENERATOR_USE_PROXY}
                    --ptr_type=long
                    --includes base/android/jni_generator/jni_generator_helper.h
                    --input_file ${BASE_JAVA_SRC_DIR}/library_loader/${JAVA_NAME}.java
                    --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
                    ${BASE_JAVA_SRC_DIR}/library_loader/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= library_loader/${JAVA_NAME}.java"
    )
    list(APPEND GENERATED_BASE_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)


list(APPEND BASE_METRICS_JAVA_NAMES
            RecordHistogram
            RecordUserAction
            StatisticsRecorderAndroid
)
foreach(JAVA_NAME ${BASE_METRICS_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${CHROMIUM_JNI_GENERATOR} ${CHROMIUM_JNI_GENERATOR_USE_PROXY}
                    --ptr_type=long
                    --includes base/android/jni_generator/jni_generator_helper.h
                    --input_file ${BASE_JAVA_SRC_DIR}/metrics/${JAVA_NAME}.java
                    --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
                    ${BASE_JAVA_SRC_DIR}/metrics/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= metrics/${JAVA_NAME}.java"
    )
    list(APPEND GENERATED_BASE_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)


list(APPEND BASE_PROCESS_LAUNCHER_JAVA_NAMES
            ChildProcessService
)
foreach(JAVA_NAME ${BASE_PROCESS_LAUNCHER_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${CHROMIUM_JNI_GENERATOR} ${CHROMIUM_JNI_GENERATOR_USE_PROXY}
                    --ptr_type=long
                    --includes base/android/jni_generator/jni_generator_helper.h
                    --input_file ${BASE_JAVA_SRC_DIR}/process_launcher/${JAVA_NAME}.java
                    --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
                    ${BASE_JAVA_SRC_DIR}/process_launcher/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= process_launcher/${JAVA_NAME}.java"
    )
    list(APPEND GENERATED_BASE_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)


list(APPEND BASE_TASK_JAVA_NAMES
            PostTask
            TaskRunnerImpl
)
foreach(JAVA_NAME ${BASE_TASK_JAVA_NAMES})
    add_custom_command(
            OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            COMMAND ${CHROMIUM_JNI_GENERATOR} ${CHROMIUM_JNI_GENERATOR_USE_PROXY}
                    --ptr_type=long
                    --includes base/android/jni_generator/jni_generator_helper.h
                    --input_file ${BASE_JAVA_SRC_DIR}/task/${JAVA_NAME}.java
                    --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h
            DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
                    ${BASE_JAVA_SRC_DIR}/task/${JAVA_NAME}.java
            COMMENT "[jni_generator]: ${JAVA_NAME}_jni.h <= task/${JAVA_NAME}.java"
    )
    list(APPEND GENERATED_BASE_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JAVA_NAME}_jni.h)
endforeach(JAVA_NAME)

#
#
#list(APPEND BASE_JNI_HEADERS
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/AnimationFrameTimeHistogram_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ApkAssets_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ApplicationStatus_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/BuildInfo_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/BundleUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/Callback_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/CommandLine_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ContentUriUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/CpuFeatures_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/EarlyTraceEvent_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/EventLog_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/FieldTrialList_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ImportantFileWriterAndroid_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/IntStringCallback_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/JNIUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/JavaExceptionReporter_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/JavaHandlerThread_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/LocaleUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/MemoryPressureListener_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/PathService_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/PathUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/PowerMonitor_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/SysUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ThreadUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/TimeUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/TimezoneUtils_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/TraceEvent_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/UnguessableToken_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryLoader_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryPrefetcher_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/RecordHistogram_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/RecordUserAction_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/StatisticsRecorderAndroid_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/ChildProcessService_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/PostTask_jni.h
#            ${BASE_JNI_HEADER_OUTPUT_DIR}/TaskRunnerImpl_jni.h
#           )
#
## generate jni headers for java files in android/java/src/org/chromium/base
#add_custom_command(OUTPUT ${BASE_JNI_HEADERS}
#                   COMMAND ${CHROMIUM_JNI_GENERATOR} --ptr_type=long
#                                                     --includes base/android/jni_generator/jni_generator_helper.h
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/AnimationFrameTimeHistogram.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/ApkAssets.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/ApplicationStatus.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/BuildInfo.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/BundleUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/Callback.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/CommandLine.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/ContentUriUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/CpuFeatures.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/EarlyTraceEvent.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/EventLog.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/FieldTrialList.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/ImportantFileWriterAndroid.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/IntStringCallback.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/JNIUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/JavaExceptionReporter.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/JavaHandlerThread.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/LocaleUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/MemoryPressureListener.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/PathService.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/PathUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/PowerMonitor.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/SysUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/ThreadUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/TimeUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/TimezoneUtils.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/TraceEvent.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/UnguessableToken.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/library_loader/LibraryLoader.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/library_loader/LibraryPrefetcher.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/metrics/RecordHistogram.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/metrics/RecordUserAction.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/metrics/StatisticsRecorderAndroid.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/process_launcher/ChildProcessService.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/task/PostTask.java
#                                                     --input_file=${BASE_JAVA_SRC_DIR}/task/TaskRunnerImpl.java
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/AnimationFrameTimeHistogram_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ApkAssets_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ApplicationStatus_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/BuildInfo_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/BundleUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/Callback_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/CommandLine_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ContentUriUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/CpuFeatures_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/EarlyTraceEvent_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/EventLog_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/FieldTrialList_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ImportantFileWriterAndroid_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/IntStringCallback_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/JNIUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/JavaExceptionReporter_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/JavaHandlerThread_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/LocaleUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/MemoryPressureListener_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/PathService_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/PathUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/PowerMonitor_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/SysUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ThreadUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/TimeUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/TimezoneUtils_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/TraceEvent_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/UnguessableToken_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryLoader_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryPrefetcher_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/RecordHistogram_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/RecordUserAction_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/StatisticsRecorderAndroid_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/ChildProcessService_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/PostTask_jni.h
#                                                     --output_file ${BASE_JNI_HEADER_OUTPUT_DIR}/TaskRunnerImpl_jni.h
#                   DEPENDS ${CHROMIUM_JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR}
#        )
#