# This file is generated by gyp; do not edit.

TOOLSET := host
TARGET := copy_icudtl_dat
### Generated for copy rule.
$(builddir)/icudtl.dat: TOOLSET := $(TOOLSET)
$(builddir)/icudtl.dat: $(srcdir)/third_party/icu/android/icudtl.dat FORCE_DO_CMD
	$(call do_cmd,copy)

all_deps += $(builddir)/icudtl.dat
third_party_icu_icu_gyp_copy_icudtl_dat_host_copies = $(builddir)/icudtl.dat

### Rules for final target.
# Build our special outputs first.
$(obj).host/third_party/icu/copy_icudtl_dat.stamp: | $(third_party_icu_icu_gyp_copy_icudtl_dat_host_copies)

# Preserve order dependency of special output on deps.
$(third_party_icu_icu_gyp_copy_icudtl_dat_host_copies): | 

$(obj).host/third_party/icu/copy_icudtl_dat.stamp: TOOLSET := $(TOOLSET)
$(obj).host/third_party/icu/copy_icudtl_dat.stamp:  FORCE_DO_CMD
	$(call do_cmd,touch)

all_deps += $(obj).host/third_party/icu/copy_icudtl_dat.stamp
# Add target alias
.PHONY: copy_icudtl_dat
copy_icudtl_dat: $(obj).host/third_party/icu/copy_icudtl_dat.stamp

# Add target alias to "all" target.
.PHONY: all
all: copy_icudtl_dat
