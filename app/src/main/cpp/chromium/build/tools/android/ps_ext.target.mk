# This file is generated by gyp; do not edit.

TOOLSET := target
TARGET := ps_ext
### Rules for final target.
$(obj).target/tools/android/ps_ext.stamp: TOOLSET := $(TOOLSET)
$(obj).target/tools/android/ps_ext.stamp: $(obj).target/tools/android/ps_ext/ps_ext.stamp FORCE_DO_CMD
	$(call do_cmd,touch)

all_deps += $(obj).target/tools/android/ps_ext.stamp
# Add target alias
.PHONY: ps_ext
ps_ext: $(obj).target/tools/android/ps_ext.stamp
