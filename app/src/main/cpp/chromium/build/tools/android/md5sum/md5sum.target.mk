# This file is generated by gyp; do not edit.

TOOLSET := target
TARGET := md5sum
### Rules for action "ordered_libraries_md5sum":
quiet_cmd_tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum = ACTION Writing dependency ordered libraries for md5sum $@
cmd_tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum = LD_LIBRARY_PATH=$(builddir)/lib.host:$(builddir)/lib.target:$$LD_LIBRARY_PATH; export LD_LIBRARY_PATH; cd $(srcdir)/tools/android/md5sum; mkdir -p $(builddir)/md5sum; python ../../../build/android/gyp/write_ordered_libraries.py "--input-libraries=\"$(builddir)/md5sum_bin\"" "--libraries-dir=$(builddir)/lib.$(TOOLSET),$(builddir)" "--readelf=$(NDK_ROOT)//toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-readelf" "--output=$(builddir)/md5sum/native_libraries.json"

$(builddir)/md5sum/native_libraries.json: obj := $(abs_obj)
$(builddir)/md5sum/native_libraries.json: builddir := $(abs_builddir)
$(builddir)/md5sum/native_libraries.json: TOOLSET := $(TOOLSET)
$(builddir)/md5sum/native_libraries.json: $(srcdir)/build/android/gyp/util/build_utils.py $(srcdir)/build/android/gyp/write_ordered_libraries.py $(builddir)/md5sum_bin FORCE_DO_CMD
	$(call do_cmd,tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum)

all_deps += $(builddir)/md5sum/native_libraries.json
action_tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum_outputs := $(builddir)/md5sum/native_libraries.json

### Rules for action "stripping native libraries":
quiet_cmd_tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries = ACTION Stripping libraries for md5sum $@
cmd_tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries = LD_LIBRARY_PATH=$(builddir)/lib.host:$(builddir)/lib.target:$$LD_LIBRARY_PATH; export LD_LIBRARY_PATH; cd $(srcdir)/tools/android/md5sum; mkdir -p $(builddir)/md5sum; python ../../../build/android/gyp/strip_library_for_device.py "--android-strip=$(NDK_ROOT)//toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-strip" "--android-strip-arg=--strip-unneeded" "--stripped-libraries-dir=$(builddir)/md5sum_dist/" "--libraries-dir=$(builddir)/lib.$(TOOLSET),$(builddir)" "--libraries-file=$(builddir)/md5sum/native_libraries.json" "--stamp=$(builddir)/md5sum/strip.stamp"

$(builddir)/md5sum/strip.stamp: obj := $(abs_obj)
$(builddir)/md5sum/strip.stamp: builddir := $(abs_builddir)
$(builddir)/md5sum/strip.stamp: TOOLSET := $(TOOLSET)
$(builddir)/md5sum/strip.stamp: $(srcdir)/build/android/gyp/util/build_utils.py $(srcdir)/build/android/gyp/strip_library_for_device.py $(builddir)/md5sum/native_libraries.json $(builddir)/md5sum_bin FORCE_DO_CMD
	$(call do_cmd,tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries)
$(builddir)/md5sum/strip.stamp.fake: $(builddir)/md5sum/strip.stamp
$(builddir)/md5sum/strip.stamp.fake: ;

all_deps += $(builddir)/md5sum/strip.stamp $(builddir)/md5sum/strip.stamp.fake
action_tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries_outputs := $(builddir)/md5sum/strip.stamp $(builddir)/md5sum/strip.stamp.fake


### Generated for copy rule.
$(builddir)/md5sum_dist/md5sum_bin: TOOLSET := $(TOOLSET)
$(builddir)/md5sum_dist/md5sum_bin: $(builddir)/md5sum_bin FORCE_DO_CMD
	$(call do_cmd,copy)

all_deps += $(builddir)/md5sum_dist/md5sum_bin
tools_android_md5sum_md5sum_gyp_md5sum_target_copies = $(builddir)/md5sum_dist/md5sum_bin

### Rules for final target.
# Build our special outputs first.
$(obj).target/tools/android/md5sum/md5sum.stamp: | $(action_tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum_outputs) $(action_tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries_outputs) $(tools_android_md5sum_md5sum_gyp_md5sum_target_copies)

# Preserve order dependency of special output on deps.
$(action_tools_android_md5sum_md5sum_gyp_md5sum_target_ordered_libraries_md5sum_outputs) $(action_tools_android_md5sum_md5sum_gyp_md5sum_target_stripping_native_libraries_outputs) $(tools_android_md5sum_md5sum_gyp_md5sum_target_copies): | $(obj).target/tools/android/md5sum/md5sum_stripped_device_bin.stamp $(builddir)/md5sum_bin_host $(obj).target/build/android/copy_system_libraries.stamp

$(obj).target/tools/android/md5sum/md5sum.stamp: TOOLSET := $(TOOLSET)
$(obj).target/tools/android/md5sum/md5sum.stamp: $(obj).target/tools/android/md5sum/md5sum_stripped_device_bin.stamp $(builddir)/md5sum_bin_host $(obj).target/build/android/copy_system_libraries.stamp FORCE_DO_CMD
	$(call do_cmd,touch)

all_deps += $(obj).target/tools/android/md5sum/md5sum.stamp
# Add target alias
.PHONY: md5sum
md5sum: $(obj).target/tools/android/md5sum/md5sum.stamp

# Add target alias to "all" target.
.PHONY: all
all: md5sum
