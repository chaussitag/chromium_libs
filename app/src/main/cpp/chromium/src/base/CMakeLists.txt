cmake_minimum_required(VERSION 3.6.0)

project(chromium_base)

if(CMAKE_SYSTEM_NAME MATCHES "Android")
  message(STATUS "ANDROID_NDK: ${ANDROID_NDK}")
  message(STATUS "ANDROID_ABI: ${ANDROID_ABI}")

  set(LIB_NAME chromium_base)
  set(CHROMIUM_BASE_SRC async_socket_io_handler_posix.cc
                        event_recorder_stubs.cc
                        linux_util.cc
                        message_loop/message_pump_android.cc
                        message_loop/message_pump_libevent.cc
                        metrics/field_trial.cc
                        posix/file_descriptor_shuffle.cc
                        sync_socket_posix.cc
                        third_party/dmg_fp/g_fmt.cc
                        third_party/dmg_fp/dtoa_wrapper.cc
                        third_party/icu/icu_utf.cc
                        third_party/nspr/prtime.cc
                        third_party/superfasthash/superfasthash.c
                        allocator/allocator_extension.cc
                        allocator/type_profiler_control.cc
                        android/application_status_listener.cc
                        android/base_jni_registrar.cc
                        android/build_info.cc
                        android/command_line_android.cc
                        android/content_uri_utils.cc
                        android/cpu_features.cc
                        android/event_log.cc
                        android/field_trial_list.cc
                        android/fifo_utils.cc
                        android/important_file_writer_android.cc
                        android/scoped_java_ref.cc
                        android/jni_android.cc
                        android/jni_array.cc
                        android/jni_registrar.cc
                        android/jni_string.cc
                        android/jni_utils.cc
                        android/jni_weak_ref.cc
                        android/library_loader/library_loader_hooks.cc
                        android/memory_pressure_listener_android.cc
                        android/java_handler_thread.cc
                        android/path_service_android.cc
                        android/path_utils.cc
                        android/sys_utils.cc
                        android/trace_event_binding.cc
                        at_exit.cc
                        barrier_closure.cc
                        base64.cc
                        base_paths.cc
                        base_paths_android.cc
                        base_switches.cc
                        big_endian.cc
                        bind_helpers.cc
                        build_time.cc
                        callback_helpers.cc
                        callback_internal.cc
                        command_line.cc
                        cpu.cc
                        debug/alias.cc
                        debug/asan_invalid_access.cc
                        debug/crash_logging.cc
                        debug/debugger.cc
                        debug/debugger_posix.cc
                        debug/dump_without_crashing.cc
                        debug/proc_maps_linux.cc
                        debug/profiler.cc
                        debug/stack_trace.cc
                        debug/stack_trace_android.cc
                        debug/task_annotator.cc
                        debug/trace_event_android.cc
                        debug/trace_event_argument.cc
                        debug/trace_event_impl.cc
                        debug/trace_event_impl_constants.cc
                        debug/trace_event_synthetic_delay.cc
                        debug/trace_event_system_stats_monitor.cc
                        debug/trace_event_memory.cc
                        deferred_sequenced_task_runner.cc
                        environment.cc
                        files/file.cc
                        files/file_enumerator.cc
                        files/file_enumerator_posix.cc
                        files/file_path.cc
                        files/file_path_constants.cc
                        files/file_path_watcher.cc
                        files/file_path_watcher_linux.cc
                        files/file_posix.cc
                        files/file_proxy.cc
                        files/file_util.cc
                        files/file_util_android.cc
                        files/file_util_posix.cc
                        files/file_util_proxy.cc
                        files/important_file_writer.cc
                        files/memory_mapped_file.cc
                        files/memory_mapped_file_posix.cc
                        files/scoped_file.cc
                        files/scoped_temp_dir.cc
                        guid.cc
                        guid_posix.cc
                        hash.cc
                        json/json_file_value_serializer.cc
                        json/json_parser.cc
                        json/json_reader.cc
                        json/json_string_value_serializer.cc
                        json/json_writer.cc
                        json/string_escape.cc
                        lazy_instance.cc
                        location.cc
                        logging.cc
                        md5.cc
                        memory/aligned_memory.cc
                        memory/discardable_memory.cc
                        memory/discardable_memory_android.cc
                        memory/discardable_memory_emulated.cc
                        memory/discardable_memory_malloc.cc
                        memory/discardable_memory_manager.cc
                        memory/memory_pressure_listener.cc
                        memory/ref_counted.cc
                        memory/ref_counted_memory.cc
                        memory/shared_memory_android.cc
                        memory/shared_memory_posix.cc
                        memory/singleton.cc
                        memory/weak_ptr.cc
                        message_loop/incoming_task_queue.cc
                        message_loop/message_loop.cc
                        message_loop/message_loop_proxy.cc
                        message_loop/message_loop_proxy_impl.cc
                        message_loop/message_pump.cc
                        message_loop/message_pump_default.cc
                        metrics/sample_map.cc
                        metrics/sample_vector.cc
                        metrics/bucket_ranges.cc
                        metrics/histogram.cc
                        metrics/histogram_base.cc
                        metrics/histogram_delta_serialization.cc
                        metrics/histogram_samples.cc
                        metrics/histogram_snapshot_manager.cc
                        metrics/sparse_histogram.cc
                        metrics/statistics_recorder.cc
                        metrics/stats_counters.cc
                        metrics/stats_table.cc
                        metrics/user_metrics.cc
                        native_library_posix.cc
                        os_compat_android.cc
                        path_service.cc
                        pending_task.cc
                        pickle.cc
                        posix/global_descriptors.cc
                        posix/unix_domain_socket_linux.cc
                        power_monitor/power_monitor.cc
                        power_monitor/power_monitor_device_source_android.cc
                        power_monitor/power_monitor_device_source.cc
                        power_monitor/power_monitor_source.cc
                        process/internal_linux.cc
                        process/kill.cc
                        process/kill_posix.cc
                        process/launch.cc
                        process/launch_posix.cc
                        process/memory.cc
                        process/memory_linux.cc
                        process/process_handle_linux.cc
                        process/process_handle_posix.cc
                        process/process_iterator.cc
                        process/process_iterator_linux.cc
                        process/process_metrics.cc
                        process/process_metrics_linux.cc
                        process/process_metrics_posix.cc
                        process/process_posix.cc
                        profiler/scoped_profile.cc
                        profiler/alternate_timer.cc
                        profiler/tracked_time.cc
                        rand_util.cc
                        rand_util_posix.cc
                        run_loop.cc
                        safe_strerror_posix.cc
                        scoped_native_library.cc
                        sequence_checker_impl.cc
                        sequenced_task_runner.cc
                        sha1_portable.cc
                        strings/latin1_string_conversions.cc
                        strings/nullable_string16.cc
                        strings/safe_sprintf.cc
                        strings/string16.cc
                        strings/string_number_conversions.cc
                        strings/string_split.cc
                        strings/string_piece.cc
                        strings/string_util.cc
                        strings/string_util_constants.cc
                        strings/stringprintf.cc
                        strings/sys_string_conversions_posix.cc
                        strings/utf_offset_string_conversions.cc
                        strings/utf_string_conversion_utils.cc
                        strings/utf_string_conversions.cc
                        supports_user_data.cc
                        synchronization/cancellation_flag.cc
                        synchronization/condition_variable_posix.cc
                        synchronization/lock.cc
                        synchronization/lock_impl_posix.cc
                        synchronization/waitable_event_posix.cc
                        synchronization/waitable_event_watcher_posix.cc
                        system_monitor/system_monitor.cc
                        sys_info.cc
                        sys_info_android.cc
                        sys_info_linux.cc
                        sys_info_posix.cc
                        task/cancelable_task_tracker.cc
                        task_runner.cc
                        thread_task_runner_handle.cc
                        threading/non_thread_safe_impl.cc
                        threading/platform_thread_android.cc
                        threading/platform_thread_posix.cc
                        threading/post_task_and_reply_impl.cc
                        threading/sequenced_worker_pool.cc
                        threading/simple_thread.cc
                        threading/thread.cc
                        threading/thread_checker_impl.cc
                        threading/thread_collision_warner.cc
                        threading/thread_id_name_manager.cc
                        threading/thread_local_android.cc
                        threading/thread_local_posix.cc
                        threading/thread_local_storage.cc
                        threading/thread_local_storage_posix.cc
                        threading/thread_restrictions.cc
                        threading/watchdog.cc
                        threading/worker_pool.cc
                        threading/worker_pool_posix.cc
                        time/clock.cc
                        time/default_clock.cc
                        time/default_tick_clock.cc
                        time/tick_clock.cc
                        time/time.cc
                        time/time_posix.cc
                        timer/elapsed_timer.cc
                        timer/hi_res_timer_manager_posix.cc
                        timer/mock_timer.cc
                        timer/timer.cc
                        tracked_objects.cc
                        tracking_info.cc
                        values.cc
                        value_conversions.cc
                        version.cc
                        vlog.cc
                        memory/discardable_memory_ashmem_allocator.cc
                        memory/discardable_memory_ashmem.cc)

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  # generate jni headers
  set(JNI_GENERATOR ${CMAKE_CURRENT_LIST_DIR}/android/jni_generator/jni_generator.py)
  message(STATUS "JNI_GENERATOR: ${JNI_GENERATOR}")

  set(BASE_JNI_HEADER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/chromium_jni_header_gen/base/jni)
  message(STATUS "BASE_JNI_HEADER_OUTPUT_DIR: ${BASE_JNI_HEADER_OUTPUT_DIR}")

  set(BASE_JAVA_SRC_PATH ${CMAKE_CURRENT_LIST_DIR}/android/java/src/org/chromium/base)
  message(STATUS "BASE_JAVA_SRC_PATH: ${BASE_JAVA_SRC_PATH}")

  add_custom_command(OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}
                     COMMAND ${CMAKE_COMMAND} -E make_directory ${BASE_JNI_HEADER_OUTPUT_DIR}
                     COMMENT "create the jni headers output directory: ${BASE_JNI_HEADER_OUTPUT_DIR}")

  add_custom_command(OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryLoader_jni.h
                     COMMAND ${JNI_GENERATOR} --input_file ${BASE_JAVA_SRC_PATH}/library_loader/LibraryLoader.java
                                              --output_dir ${BASE_JNI_HEADER_OUTPUT_DIR}
                                              --includes base/android/jni_generator/jni_generator_helper.h
                                              --optimize_generation 0 --ptr_type long
                     DEPENDS ${JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR} ${BASE_JAVA_SRC_PATH}/library_loader/LibraryLoader.java
                     COMMENT "[jni_generator]: LibraryLoader_jni.h <= LibraryLoader.java")
  list(APPEND GENERATED_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/LibraryLoader_jni.h)

  list(APPEND BASE_JNI_HEADERS_1 ApplicationStatus
                                 BuildInfo
                                 CommandLine
                                 ContentUriUtils
                                 CpuFeatures
                                 EventLog
                                 FieldTrialList
                                 ImportantFileWriterAndroid
                                 JNIUtils
                                 MemoryPressureListener
                                 JavaHandlerThread
                                 PathService
                                 PathUtils
                                 PowerMonitor
                                 SystemMessageHandler
                                 SysUtils
                                 ThreadUtils
                                 TraceEvent)
  foreach(JNI_NAME ${BASE_JNI_HEADERS_1})
    add_custom_command(OUTPUT ${BASE_JNI_HEADER_OUTPUT_DIR}/${JNI_NAME}_jni.h
                       COMMAND ${JNI_GENERATOR} --input_file ${BASE_JAVA_SRC_PATH}/${JNI_NAME}.java
                                                --output_dir ${BASE_JNI_HEADER_OUTPUT_DIR}
                                                --includes base/android/jni_generator/jni_generator_helper.h
                                                --optimize_generation 0 --ptr_type long
                      DEPENDS ${JNI_GENERATOR} ${BASE_JNI_HEADER_OUTPUT_DIR} ${BASE_JAVA_SRC_PATH}/${JNI_NAME}.java
                      COMMENT "[jni_generator]: ${JNI_NAME}_jni.h <= ${JNI_NAME}.java")
    list(APPEND GENERATED_JNI_HEADERS ${BASE_JNI_HEADER_OUTPUT_DIR}/${JNI_NAME}_jni.h)
  endforeach(JNI_NAME)
  # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  add_library(${LIB_NAME} SHARED ${GENERATED_JNI_HEADERS} ${CHROMIUM_BASE_SRC})

  target_include_directories(${LIB_NAME} PUBLIC ${ANDROID_NDK}/sources/android/cpufeatures ../)
  target_include_directories(${LIB_NAME} PUBLIC ${BASE_JNI_HEADER_OUTPUT_DIR}/..)
  target_compile_definitions(${LIB_NAME} PRIVATE
                             ANDROID NO_TCMALLOC COMPONENT_BUILD __STDC_FORMAT_MACROS BASE_IMPLEMENTATION)
  # flags for c and c++
  target_compile_options(${LIB_NAME} PRIVATE
                         -fstack-protector --param=ssp-buffer-size=4 -Werror -fno-exceptions
                         -fno-strict-aliasing -Wall -Wno-unused-parameter -Wno-missing-field-initializers
                         -fvisibility=hidden -pipe -fPIC -Wno-unused-local-typedefs -march=armv7-a
                         -mtune=generic-armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb
                         -fno-tree-sra -fno-partial-inlining -fno-early-inlining -fno-tree-copy-prop
                         -fno-tree-loop-optimize -fno-move-loop-invariants -fno-caller-saves
                         -Wno-psabi -mthumb-interwork -ffunction-sections -funwind-tables
                         -fstack-protector -fno-short-enums -finline-limit=64 -Wa,--noexecstack
                         -Os -g -fdata-sections -ffunction-sections -fomit-frame-pointer
                         -funwind-tables)
  # flags for only c++
  target_compile_options(${LIB_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:
                         -fno-rtti -fno-threadsafe-statics -fvisibility-inlines-hidden
                         -Wsign-compare -Wno-abi -Wno-narrowing -Wno-literal-suffix>)

  set(${MY_LINK_FLAGS} "${MY_LINK_FLAGS} \
                       -Wl,-z,now \
                       -Wl,-z,relro \
                       -Wl,--fatal-warnings \
                       -Wl,-z,noexecstack \
                       -fPIC \
                       -Wl,-z,relro \
                       -Wl,-z,now \
                       -fuse-ld=gold \
                       -nostdlib \
                       -Wl,--no-undefined \
                       -Wl,--icf=safe \
                       -Wl,-shared,-Bsymbolic \
                       -Wl,--warn-shared-textrel \
                       -Wl,-O1 \
                       -Wl,--as-needed")

  string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)
  message("CMAKE_BUILD_TYPE_LOWER: ${CMAKE_BUILD_TYPE_LOWER}")
  if("${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "release")
    message(STATUS "release build")
    target_compile_definitions(${LIB_NAME} PUBLIC
                               NDEBUG _FORTIFY_SOURCE=2)
    target_compile_options(${LIB_NAME} PRIVATE -fno-ident)
    set(MY_LINK_FLAGS "${MY_LINK_FLAGS} -Wl,--gc-sections")
  else()
    message(STATUS "debug build")
    target_compile_definitions(${LIB_NAME} PUBLIC _DEBUG)
  endif()
  set_target_properties(${LIB_NAME} PROPERTIES LINK_FLAGS "${MY_LINK_FLAGS}")

  find_library(log-lib log)
  find_library(dl-lib dl)
  find_library(android-lib android)
  message(STATUS "log-lib: ${log-lib}")
  message(STATUS "android-lib: ${android-lib}")
  target_link_libraries(${LIB_NAME}
                        allocator_extension_thunks modp_b64 dynamic_annotations ashmem event
                        cpufeatures
                        ${android-lib} ${log-lib} ${dl-lib})

  # build cpufeatures as a static lib
  add_library(cpufeatures STATIC
              ${ANDROID_NDK}/sources/android/cpufeatures/cpu-features.c)

  add_subdirectory(allocator)
  add_subdirectory(third_party/dynamic_annotations)
  add_subdirectory(../third_party/ashmem ${CMAKE_BINARY_DIR}/third_party/ashmem)
  add_subdirectory(../third_party/modp_b64 ${CMAKE_BINARY_DIR}/third_party/modp_b64)
  add_subdirectory(../third_party/libevent ${CMAKE_BINARY_DIR}/third_party/libevent)
endif()
