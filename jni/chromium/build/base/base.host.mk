# This file is generated by gyp; do not edit.

TOOLSET := host
TARGET := base
DEFS_Debug := \
	'-DV8_DEPRECATION_WARNINGS' \
	'-D_FILE_OFFSET_BITS=64' \
	'-DNO_TCMALLOC' \
	'-DDISABLE_NACL' \
	'-DCHROMIUM_BUILD' \
	'-DCOMPONENT_BUILD' \
	'-DUSE_LIBJPEG_TURBO=1' \
	'-DENABLE_WEBRTC=1' \
	'-DUSE_PROPRIETARY_CODECS' \
	'-DENABLE_BROWSER_CDMS' \
	'-DENABLE_CONFIGURATION_POLICY' \
	'-DDISCARDABLE_MEMORY_ALWAYS_SUPPORTED_NATIVELY' \
	'-DSYSTEM_NATIVELY_SIGNALS_MEMORY_PRESSURE' \
	'-DENABLE_EGLIMAGE=1' \
	'-DENABLE_AUTOFILL_DIALOG=1' \
	'-DCLD_VERSION=1' \
	'-DENABLE_PRINTING=1' \
	'-DENABLE_MANAGED_USERS=1' \
	'-DVIDEO_HOLE=1' \
	'-DUSE_OPENSSL=1' \
	'-DUSE_OPENSSL_CERTS=1' \
	'-D__STDC_CONSTANT_MACROS' \
	'-D__STDC_FORMAT_MACROS' \
	'-DBASE_IMPLEMENTATION' \
	'-DOS_ANDROID_HOST=Linux' \
	'-DDYNAMIC_ANNOTATIONS_ENABLED=1' \
	'-DWTF_USE_DYNAMIC_ANNOTATIONS=1' \
	'-D_DEBUG'

# Flags passed to all source files.
CFLAGS_Debug := \
	-fstack-protector \
	--param=ssp-buffer-size=4 \
	-Werror \
	-pthread \
	-fno-exceptions \
	-fno-strict-aliasing \
	-Wall \
	-Wno-unused-parameter \
	-Wno-missing-field-initializers \
	-fvisibility=hidden \
	-pipe \
	-fPIC \
	-Wheader-hygiene \
	-Wno-char-subscripts \
	-Wno-unneeded-internal-declaration \
	-Wno-covered-switch-default \
	-Wstring-conversion \
	-Wno-c++11-narrowing \
	-Wno-deprecated-register \
	-Wexit-time-destructors \
	-Os \
	-g \
	-fdata-sections \
	-ffunction-sections \
	-fomit-frame-pointer \
	-funwind-tables

# Flags passed to only C files.
CFLAGS_C_Debug :=

# Flags passed to only C++ files.
CFLAGS_CC_Debug := \
	-fno-rtti \
	-fno-threadsafe-statics \
	-fvisibility-inlines-hidden \
	-Wsign-compare \
	-std=gnu++11

INCS_Debug := \
	-I$(obj)/gen \
	-I$(srcdir)/.

DEFS_Release := \
	'-DV8_DEPRECATION_WARNINGS' \
	'-D_FILE_OFFSET_BITS=64' \
	'-DNO_TCMALLOC' \
	'-DDISABLE_NACL' \
	'-DCHROMIUM_BUILD' \
	'-DCOMPONENT_BUILD' \
	'-DUSE_LIBJPEG_TURBO=1' \
	'-DENABLE_WEBRTC=1' \
	'-DUSE_PROPRIETARY_CODECS' \
	'-DENABLE_BROWSER_CDMS' \
	'-DENABLE_CONFIGURATION_POLICY' \
	'-DDISCARDABLE_MEMORY_ALWAYS_SUPPORTED_NATIVELY' \
	'-DSYSTEM_NATIVELY_SIGNALS_MEMORY_PRESSURE' \
	'-DENABLE_EGLIMAGE=1' \
	'-DENABLE_AUTOFILL_DIALOG=1' \
	'-DCLD_VERSION=1' \
	'-DENABLE_PRINTING=1' \
	'-DENABLE_MANAGED_USERS=1' \
	'-DVIDEO_HOLE=1' \
	'-DUSE_OPENSSL=1' \
	'-DUSE_OPENSSL_CERTS=1' \
	'-D__STDC_CONSTANT_MACROS' \
	'-D__STDC_FORMAT_MACROS' \
	'-DBASE_IMPLEMENTATION' \
	'-DOS_ANDROID_HOST=Linux' \
	'-DNDEBUG' \
	'-DNVALGRIND' \
	'-DDYNAMIC_ANNOTATIONS_ENABLED=0' \
	'-D_FORTIFY_SOURCE=2'

# Flags passed to all source files.
CFLAGS_Release := \
	-fstack-protector \
	--param=ssp-buffer-size=4 \
	-Werror \
	-pthread \
	-fno-exceptions \
	-fno-strict-aliasing \
	-Wall \
	-Wno-unused-parameter \
	-Wno-missing-field-initializers \
	-fvisibility=hidden \
	-pipe \
	-fPIC \
	-Wheader-hygiene \
	-Wno-char-subscripts \
	-Wno-unneeded-internal-declaration \
	-Wno-covered-switch-default \
	-Wstring-conversion \
	-Wno-c++11-narrowing \
	-Wno-deprecated-register \
	-Wexit-time-destructors \
	-Os \
	-fno-ident \
	-fdata-sections \
	-ffunction-sections \
	-fomit-frame-pointer \
	-funwind-tables

# Flags passed to only C files.
CFLAGS_C_Release :=

# Flags passed to only C++ files.
CFLAGS_CC_Release := \
	-fno-rtti \
	-fno-threadsafe-statics \
	-fvisibility-inlines-hidden \
	-Wsign-compare \
	-std=gnu++11

INCS_Release := \
	-I$(obj)/gen \
	-I$(srcdir)/.

OBJS := \
	$(obj).host/$(TARGET)/base/async_socket_io_handler_posix.o \
	$(obj).host/$(TARGET)/base/event_recorder_stubs.o \
	$(obj).host/$(TARGET)/base/linux_util.o \
	$(obj).host/$(TARGET)/base/message_loop/message_pump_libevent.o \
	$(obj).host/$(TARGET)/base/metrics/field_trial.o \
	$(obj).host/$(TARGET)/base/posix/file_descriptor_shuffle.o \
	$(obj).host/$(TARGET)/base/sync_socket_posix.o \
	$(obj).host/$(TARGET)/base/third_party/dmg_fp/g_fmt.o \
	$(obj).host/$(TARGET)/base/third_party/dmg_fp/dtoa_wrapper.o \
	$(obj).host/$(TARGET)/base/third_party/icu/icu_utf.o \
	$(obj).host/$(TARGET)/base/third_party/nspr/prtime.o \
	$(obj).host/$(TARGET)/base/third_party/superfasthash/superfasthash.o \
	$(obj).host/$(TARGET)/base/allocator/allocator_extension.o \
	$(obj).host/$(TARGET)/base/allocator/type_profiler_control.o \
	$(obj).host/$(TARGET)/base/at_exit.o \
	$(obj).host/$(TARGET)/base/atomicops_internals_x86_gcc.o \
	$(obj).host/$(TARGET)/base/barrier_closure.o \
	$(obj).host/$(TARGET)/base/base64.o \
	$(obj).host/$(TARGET)/base/base_paths.o \
	$(obj).host/$(TARGET)/base/big_endian.o \
	$(obj).host/$(TARGET)/base/bind_helpers.o \
	$(obj).host/$(TARGET)/base/build_time.o \
	$(obj).host/$(TARGET)/base/callback_helpers.o \
	$(obj).host/$(TARGET)/base/callback_internal.o \
	$(obj).host/$(TARGET)/base/command_line.o \
	$(obj).host/$(TARGET)/base/cpu.o \
	$(obj).host/$(TARGET)/base/debug/alias.o \
	$(obj).host/$(TARGET)/base/debug/asan_invalid_access.o \
	$(obj).host/$(TARGET)/base/debug/crash_logging.o \
	$(obj).host/$(TARGET)/base/debug/debugger.o \
	$(obj).host/$(TARGET)/base/debug/debugger_posix.o \
	$(obj).host/$(TARGET)/base/debug/dump_without_crashing.o \
	$(obj).host/$(TARGET)/base/debug/proc_maps_linux.o \
	$(obj).host/$(TARGET)/base/debug/profiler.o \
	$(obj).host/$(TARGET)/base/debug/stack_trace.o \
	$(obj).host/$(TARGET)/base/debug/stack_trace_posix.o \
	$(obj).host/$(TARGET)/base/debug/task_annotator.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_argument.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_impl.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_impl_constants.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_synthetic_delay.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_system_stats_monitor.o \
	$(obj).host/$(TARGET)/base/debug/trace_event_memory.o \
	$(obj).host/$(TARGET)/base/deferred_sequenced_task_runner.o \
	$(obj).host/$(TARGET)/base/environment.o \
	$(obj).host/$(TARGET)/base/files/file.o \
	$(obj).host/$(TARGET)/base/files/file_enumerator.o \
	$(obj).host/$(TARGET)/base/files/file_enumerator_posix.o \
	$(obj).host/$(TARGET)/base/files/file_path.o \
	$(obj).host/$(TARGET)/base/files/file_path_constants.o \
	$(obj).host/$(TARGET)/base/files/file_path_watcher.o \
	$(obj).host/$(TARGET)/base/files/file_path_watcher_linux.o \
	$(obj).host/$(TARGET)/base/files/file_posix.o \
	$(obj).host/$(TARGET)/base/files/file_proxy.o \
	$(obj).host/$(TARGET)/base/files/file_util.o \
	$(obj).host/$(TARGET)/base/files/file_util_posix.o \
	$(obj).host/$(TARGET)/base/files/file_util_proxy.o \
	$(obj).host/$(TARGET)/base/files/important_file_writer.o \
	$(obj).host/$(TARGET)/base/files/memory_mapped_file.o \
	$(obj).host/$(TARGET)/base/files/memory_mapped_file_posix.o \
	$(obj).host/$(TARGET)/base/files/scoped_file.o \
	$(obj).host/$(TARGET)/base/files/scoped_temp_dir.o \
	$(obj).host/$(TARGET)/base/guid.o \
	$(obj).host/$(TARGET)/base/guid_posix.o \
	$(obj).host/$(TARGET)/base/hash.o \
	$(obj).host/$(TARGET)/base/json/json_file_value_serializer.o \
	$(obj).host/$(TARGET)/base/json/json_parser.o \
	$(obj).host/$(TARGET)/base/json/json_reader.o \
	$(obj).host/$(TARGET)/base/json/json_string_value_serializer.o \
	$(obj).host/$(TARGET)/base/json/json_writer.o \
	$(obj).host/$(TARGET)/base/json/string_escape.o \
	$(obj).host/$(TARGET)/base/lazy_instance.o \
	$(obj).host/$(TARGET)/base/location.o \
	$(obj).host/$(TARGET)/base/logging.o \
	$(obj).host/$(TARGET)/base/md5.o \
	$(obj).host/$(TARGET)/base/memory/aligned_memory.o \
	$(obj).host/$(TARGET)/base/memory/discardable_memory.o \
	$(obj).host/$(TARGET)/base/memory/discardable_memory_emulated.o \
	$(obj).host/$(TARGET)/base/memory/discardable_memory_malloc.o \
	$(obj).host/$(TARGET)/base/memory/discardable_memory_manager.o \
	$(obj).host/$(TARGET)/base/memory/memory_pressure_listener.o \
	$(obj).host/$(TARGET)/base/memory/ref_counted.o \
	$(obj).host/$(TARGET)/base/memory/ref_counted_memory.o \
	$(obj).host/$(TARGET)/base/memory/shared_memory_posix.o \
	$(obj).host/$(TARGET)/base/memory/singleton.o \
	$(obj).host/$(TARGET)/base/memory/weak_ptr.o \
	$(obj).host/$(TARGET)/base/message_loop/incoming_task_queue.o \
	$(obj).host/$(TARGET)/base/message_loop/message_loop.o \
	$(obj).host/$(TARGET)/base/message_loop/message_loop_proxy.o \
	$(obj).host/$(TARGET)/base/message_loop/message_loop_proxy_impl.o \
	$(obj).host/$(TARGET)/base/message_loop/message_pump.o \
	$(obj).host/$(TARGET)/base/message_loop/message_pump_default.o \
	$(obj).host/$(TARGET)/base/metrics/sample_map.o \
	$(obj).host/$(TARGET)/base/metrics/sample_vector.o \
	$(obj).host/$(TARGET)/base/metrics/bucket_ranges.o \
	$(obj).host/$(TARGET)/base/metrics/histogram.o \
	$(obj).host/$(TARGET)/base/metrics/histogram_base.o \
	$(obj).host/$(TARGET)/base/metrics/histogram_delta_serialization.o \
	$(obj).host/$(TARGET)/base/metrics/histogram_samples.o \
	$(obj).host/$(TARGET)/base/metrics/histogram_snapshot_manager.o \
	$(obj).host/$(TARGET)/base/metrics/sparse_histogram.o \
	$(obj).host/$(TARGET)/base/metrics/statistics_recorder.o \
	$(obj).host/$(TARGET)/base/metrics/stats_counters.o \
	$(obj).host/$(TARGET)/base/metrics/stats_table.o \
	$(obj).host/$(TARGET)/base/metrics/user_metrics.o \
	$(obj).host/$(TARGET)/base/native_library_posix.o \
	$(obj).host/$(TARGET)/base/path_service.o \
	$(obj).host/$(TARGET)/base/pending_task.o \
	$(obj).host/$(TARGET)/base/pickle.o \
	$(obj).host/$(TARGET)/base/posix/global_descriptors.o \
	$(obj).host/$(TARGET)/base/posix/unix_domain_socket_linux.o \
	$(obj).host/$(TARGET)/base/power_monitor/power_monitor.o \
	$(obj).host/$(TARGET)/base/power_monitor/power_monitor_device_source.o \
	$(obj).host/$(TARGET)/base/power_monitor/power_monitor_source.o \
	$(obj).host/$(TARGET)/base/process/internal_linux.o \
	$(obj).host/$(TARGET)/base/process/kill.o \
	$(obj).host/$(TARGET)/base/process/kill_posix.o \
	$(obj).host/$(TARGET)/base/process/launch.o \
	$(obj).host/$(TARGET)/base/process/launch_posix.o \
	$(obj).host/$(TARGET)/base/process/memory.o \
	$(obj).host/$(TARGET)/base/process/memory_linux.o \
	$(obj).host/$(TARGET)/base/process/process_handle_linux.o \
	$(obj).host/$(TARGET)/base/process/process_handle_posix.o \
	$(obj).host/$(TARGET)/base/process/process_iterator.o \
	$(obj).host/$(TARGET)/base/process/process_iterator_linux.o \
	$(obj).host/$(TARGET)/base/process/process_metrics.o \
	$(obj).host/$(TARGET)/base/process/process_metrics_linux.o \
	$(obj).host/$(TARGET)/base/process/process_metrics_posix.o \
	$(obj).host/$(TARGET)/base/process/process_posix.o \
	$(obj).host/$(TARGET)/base/profiler/scoped_profile.o \
	$(obj).host/$(TARGET)/base/profiler/alternate_timer.o \
	$(obj).host/$(TARGET)/base/profiler/tracked_time.o \
	$(obj).host/$(TARGET)/base/rand_util.o \
	$(obj).host/$(TARGET)/base/rand_util_posix.o \
	$(obj).host/$(TARGET)/base/run_loop.o \
	$(obj).host/$(TARGET)/base/safe_strerror_posix.o \
	$(obj).host/$(TARGET)/base/scoped_native_library.o \
	$(obj).host/$(TARGET)/base/sequence_checker_impl.o \
	$(obj).host/$(TARGET)/base/sequenced_task_runner.o \
	$(obj).host/$(TARGET)/base/sha1_portable.o \
	$(obj).host/$(TARGET)/base/strings/latin1_string_conversions.o \
	$(obj).host/$(TARGET)/base/strings/nullable_string16.o \
	$(obj).host/$(TARGET)/base/strings/safe_sprintf.o \
	$(obj).host/$(TARGET)/base/strings/string16.o \
	$(obj).host/$(TARGET)/base/strings/string_number_conversions.o \
	$(obj).host/$(TARGET)/base/strings/string_split.o \
	$(obj).host/$(TARGET)/base/strings/string_piece.o \
	$(obj).host/$(TARGET)/base/strings/string_util.o \
	$(obj).host/$(TARGET)/base/strings/string_util_constants.o \
	$(obj).host/$(TARGET)/base/strings/stringprintf.o \
	$(obj).host/$(TARGET)/base/strings/sys_string_conversions_posix.o \
	$(obj).host/$(TARGET)/base/strings/utf_offset_string_conversions.o \
	$(obj).host/$(TARGET)/base/strings/utf_string_conversion_utils.o \
	$(obj).host/$(TARGET)/base/strings/utf_string_conversions.o \
	$(obj).host/$(TARGET)/base/supports_user_data.o \
	$(obj).host/$(TARGET)/base/synchronization/cancellation_flag.o \
	$(obj).host/$(TARGET)/base/synchronization/condition_variable_posix.o \
	$(obj).host/$(TARGET)/base/synchronization/lock.o \
	$(obj).host/$(TARGET)/base/synchronization/lock_impl_posix.o \
	$(obj).host/$(TARGET)/base/synchronization/waitable_event_posix.o \
	$(obj).host/$(TARGET)/base/synchronization/waitable_event_watcher_posix.o \
	$(obj).host/$(TARGET)/base/system_monitor/system_monitor.o \
	$(obj).host/$(TARGET)/base/sys_info.o \
	$(obj).host/$(TARGET)/base/sys_info_linux.o \
	$(obj).host/$(TARGET)/base/sys_info_posix.o \
	$(obj).host/$(TARGET)/base/task/cancelable_task_tracker.o \
	$(obj).host/$(TARGET)/base/task_runner.o \
	$(obj).host/$(TARGET)/base/thread_task_runner_handle.o \
	$(obj).host/$(TARGET)/base/threading/non_thread_safe_impl.o \
	$(obj).host/$(TARGET)/base/threading/platform_thread_linux.o \
	$(obj).host/$(TARGET)/base/threading/platform_thread_posix.o \
	$(obj).host/$(TARGET)/base/threading/post_task_and_reply_impl.o \
	$(obj).host/$(TARGET)/base/threading/sequenced_worker_pool.o \
	$(obj).host/$(TARGET)/base/threading/simple_thread.o \
	$(obj).host/$(TARGET)/base/threading/thread.o \
	$(obj).host/$(TARGET)/base/threading/thread_checker_impl.o \
	$(obj).host/$(TARGET)/base/threading/thread_collision_warner.o \
	$(obj).host/$(TARGET)/base/threading/thread_id_name_manager.o \
	$(obj).host/$(TARGET)/base/threading/thread_local_posix.o \
	$(obj).host/$(TARGET)/base/threading/thread_local_storage.o \
	$(obj).host/$(TARGET)/base/threading/thread_local_storage_posix.o \
	$(obj).host/$(TARGET)/base/threading/thread_restrictions.o \
	$(obj).host/$(TARGET)/base/threading/watchdog.o \
	$(obj).host/$(TARGET)/base/threading/worker_pool.o \
	$(obj).host/$(TARGET)/base/threading/worker_pool_posix.o \
	$(obj).host/$(TARGET)/base/time/clock.o \
	$(obj).host/$(TARGET)/base/time/default_clock.o \
	$(obj).host/$(TARGET)/base/time/default_tick_clock.o \
	$(obj).host/$(TARGET)/base/time/tick_clock.o \
	$(obj).host/$(TARGET)/base/time/time.o \
	$(obj).host/$(TARGET)/base/time/time_posix.o \
	$(obj).host/$(TARGET)/base/timer/elapsed_timer.o \
	$(obj).host/$(TARGET)/base/timer/hi_res_timer_manager_posix.o \
	$(obj).host/$(TARGET)/base/timer/mock_timer.o \
	$(obj).host/$(TARGET)/base/timer/timer.o \
	$(obj).host/$(TARGET)/base/tracked_objects.o \
	$(obj).host/$(TARGET)/base/tracking_info.o \
	$(obj).host/$(TARGET)/base/values.o \
	$(obj).host/$(TARGET)/base/value_conversions.o \
	$(obj).host/$(TARGET)/base/version.o \
	$(obj).host/$(TARGET)/base/vlog.o

# Add to the list of files we specially track dependencies for.
all_deps += $(OBJS)

# Make sure our dependencies are built before any of us.
$(OBJS): | $(obj).host/testing/gtest_prod.stamp

# CFLAGS et al overrides must be target-local.
# See "Target-specific Variable Values" in the GNU Make manual.
$(OBJS): TOOLSET := $(TOOLSET)
$(OBJS): GYP_CFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_C_$(BUILDTYPE))
$(OBJS): GYP_CXXFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_CC_$(BUILDTYPE))

# Suffix rules, putting all outputs into $(obj).

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(srcdir)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(srcdir)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# Try building from generated source, too.

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj).$(TOOLSET)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj).$(TOOLSET)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# End of this set of suffix rules
### Rules for final target.
LDFLAGS_Debug := \
	-Wl,-z,now \
	-Wl,-z,relro \
	-pthread \
	-fPIC

LDFLAGS_Release := \
	-Wl,-z,now \
	-Wl,-z,relro \
	-pthread \
	-fPIC

LIBS := \
	

$(obj).host/base/libbase.a: GYP_LDFLAGS := $(LDFLAGS_$(BUILDTYPE))
$(obj).host/base/libbase.a: LIBS := $(LIBS)
$(obj).host/base/libbase.a: TOOLSET := $(TOOLSET)
$(obj).host/base/libbase.a: $(OBJS) FORCE_DO_CMD
	$(call do_cmd,alink_thin)

all_deps += $(obj).host/base/libbase.a
# Add target alias
.PHONY: base
base: $(obj).host/base/libbase.a

# Add target alias to "all" target.
.PHONY: all
all: base
