# We borrow heavily from the kernel build setup, though we are simpler since
# we don't have Kconfig tweaking settings on us.

# The implicit make rules have it looking for RCS files, among other things.
# We instead explicitly write all the rules we care about.
# It's even quicker (saves ~200ms) to pass -r on the command line.
MAKEFLAGS=-r

# The source directory tree.
srcdir := ../src
abs_srcdir := $(abspath $(srcdir))

# The name of the builddir.
builddir_name ?= out

# The V=1 flag on command line makes us verbosely print command lines.
ifdef V
  quiet=
else
  quiet=quiet_
endif

# Specify BUILDTYPE=Release on the command line for a release build.
BUILDTYPE ?= Debug

# Directory all our build output goes into.
# Note that this must be two directories beneath src/ for unit tests to pass,
# as they reach into the src/ directory for data with relative paths.
builddir ?= $(builddir_name)/$(BUILDTYPE)
abs_builddir := $(abspath $(builddir))
depsdir := $(builddir)/.deps

# Object output directory.
obj := $(builddir)/obj
abs_obj := $(abspath $(obj))

# We build up a list of every single one of the targets so we can slurp in the
# generated dependency rule Makefiles in one pass.
all_deps :=

#######################################################################################################
## daiguozhou added
$(info "NDK_ROOT $(NDK_ROOT)")
$(info "CC $(CC)")
$(info "CXX $(CXX)")

ifneq (,$(filter $(origin NDK_ROOT), undefined default))
	NDK_ROOT := /home/xxx/xxx/ndk/android-ndk-r9d
endif
toolchain_path := $(NDK_ROOT)/toolchains
#######################################################################################################

ifneq (,$(filter $(origin CC), undefined default))
  CC = $(abspath $(toolchain_path)/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc)
endif
ifneq (,$(filter $(origin CXX), undefined default))
  CXX = $(abspath $(toolchain_path)/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-g++)
endif
ifneq (,$(filter $(origin CC.host), undefined default))
  CC.host = $(abspath third_party/llvm-build/Release+Asserts/bin/clang)
endif
ifneq (,$(filter $(origin CXX.host), undefined default))
  CXX.host = $(abspath third_party/llvm-build/Release+Asserts/bin/clang++)
endif


CC.target ?= $(CC)
CFLAGS.target ?= $(CFLAGS)
CXX.target ?= $(CXX)
CXXFLAGS.target ?= $(CXXFLAGS)
LINK.target ?= $(LINK)
LDFLAGS.target ?= $(LDFLAGS)
AR.target ?= $(AR)

# C++ apps need to be linked with g++.
#
# Note: flock is used to seralize linking. Linking is a memory-intensive
# process so running parallel links can often lead to thrashing.  To disable
# the serialization, override LINK via an envrionment variable as follows:
#
#   export LINK=g++
#
# This will allow make to invoke N linker processes as specified in -jN.
LINK ?= flock $(builddir)/linker.lock $(CXX.target)

# TODO(evan): move all cross-compilation logic to gyp-time so we don't need
# to replicate this environment fallback in make as well.
CC.host ?= gcc
CFLAGS.host ?=
CXX.host ?= g++
CXXFLAGS.host ?=
LINK.host ?= $(CXX.host)
LDFLAGS.host ?=
AR.host ?= ar

# Define a dir function that can handle spaces.
# http://www.gnu.org/software/make/manual/make.html#Syntax-of-Functions
# "leading spaces cannot appear in the text of the first argument as written.
# These characters can be put into the argument value by variable substitution."
empty :=
space := $(empty) $(empty)

# http://stackoverflow.com/questions/1189781/using-make-dir-or-notdir-on-a-path-with-spaces
replace_spaces = $(subst $(space),?,$1)
unreplace_spaces = $(subst ?,$(space),$1)
dirx = $(call unreplace_spaces,$(dir $(call replace_spaces,$1)))

# Flags to make gcc output dependency info.  Note that you need to be
# careful here to use the flags that ccache and distcc can understand.
# We write to a dep file on the side first and then rename at the end
# so we can't end up with a broken dep file.
depfile = $(depsdir)/$(call replace_spaces,$@).d
DEPFLAGS = -MMD -MF $(depfile).raw

# We have to fixup the deps output in a few ways.
# (1) the file output should mention the proper .o file.
# ccache or distcc lose the path to the target, so we convert a rule of
# the form:
#   foobar.o: DEP1 DEP2
# into
#   path/to/foobar.o: DEP1 DEP2
# (2) we want missing files not to cause us to fail to build.
# We want to rewrite
#   foobar.o: DEP1 DEP2 \
#               DEP3
# to
#   DEP1:
#   DEP2:
#   DEP3:
# so if the files are missing, they're just considered phony rules.
# We have to do some pretty insane escaping to get those backslashes
# and dollar signs past make, the shell, and sed at the same time.
# Doesn't work with spaces, but that's fine: .d files have spaces in
# their names replaced with other characters.
define fixup_dep
# The depfile may not exist if the input file didn't have any #includes.
touch $(depfile).raw
# Fixup path as in (1).
sed -e "s|^$(notdir $@)|$@|" $(depfile).raw >> $(depfile)
# Add extra rules as in (2).
# We remove slashes and replace spaces with new lines;
# remove blank lines;
# delete the first line and append a colon to the remaining lines.
sed -e 's|\\||' -e 'y| |\n|' $(depfile).raw |\
  grep -v '^$$'                             |\
  sed -e 1d -e 's|$$|:|'                     \
    >> $(depfile)
rm $(depfile).raw
endef

# Command definitions:
# - cmd_foo is the actual command to run;
# - quiet_cmd_foo is the brief-output summary of the command.

quiet_cmd_cc = CC($(TOOLSET)) $@
cmd_cc = $(CC.$(TOOLSET)) $(GYP_CFLAGS) $(DEPFLAGS) $(CFLAGS.$(TOOLSET)) -c -o $@ $<

quiet_cmd_cxx = CXX($(TOOLSET)) $@
cmd_cxx = $(CXX.$(TOOLSET)) $(GYP_CXXFLAGS) $(DEPFLAGS) $(CXXFLAGS.$(TOOLSET)) -c -o $@ $<

quiet_cmd_touch = TOUCH $@
cmd_touch = touch $@

quiet_cmd_copy = COPY $@
# send stderr to /dev/null to ignore messages when linking directories.
cmd_copy = ln -f "$<" "$@" 2>/dev/null || (rm -rf "$@" && cp -af "$<" "$@")

quiet_cmd_alink = AR($(TOOLSET)) $@
cmd_alink = rm -f $@ && $(AR.$(TOOLSET)) crs $@ $(filter %.o,$^)

quiet_cmd_alink_thin = AR($(TOOLSET)) $@
cmd_alink_thin = rm -f $@ && $(AR.$(TOOLSET)) crsT $@ $(filter %.o,$^)

# Due to circular dependencies between libraries :(, we wrap the
# special "figure out circular dependencies" flags around the entire
# input list during linking.
quiet_cmd_link = LINK($(TOOLSET)) $@
cmd_link = $(LINK.$(TOOLSET)) $(GYP_LDFLAGS) $(LDFLAGS.$(TOOLSET)) -o $@ -Wl,--start-group $(LD_INPUTS) -Wl,--end-group $(LIBS)

# We support two kinds of shared objects (.so):
# 1) shared_library, which is just bundling together many dependent libraries
# into a link line.
# 2) loadable_module, which is generating a module intended for dlopen().
#
# They differ only slightly:
# In the former case, we want to package all dependent code into the .so.
# In the latter case, we want to package just the API exposed by the
# outermost module.
# This means shared_library uses --whole-archive, while loadable_module doesn't.
# (Note that --whole-archive is incompatible with the --start-group used in
# normal linking.)

# Other shared-object link notes:
# - Set SONAME to the library filename so our binaries don't reference
# the local, absolute paths used on the link command-line.
quiet_cmd_solink = SOLINK($(TOOLSET)) $@
cmd_solink = $(LINK.$(TOOLSET)) -shared $(GYP_LDFLAGS) $(LDFLAGS.$(TOOLSET)) -Wl,-soname=$(@F) -o $@ -Wl,--whole-archive $(LD_INPUTS) -Wl,--no-whole-archive $(LIBS)

quiet_cmd_solink_module = SOLINK_MODULE($(TOOLSET)) $@
cmd_solink_module = $(LINK.$(TOOLSET)) -shared $(GYP_LDFLAGS) $(LDFLAGS.$(TOOLSET)) -Wl,-soname=$(@F) -o $@ -Wl,--start-group $(filter-out FORCE_DO_CMD, $^) -Wl,--end-group $(LIBS)


# Define an escape_quotes function to escape single quotes.
# This allows us to handle quotes properly as long as we always use
# use single quotes and escape_quotes.
escape_quotes = $(subst ','\'',$(1))
# This comment is here just to include a ' to unconfuse syntax highlighting.
# Define an escape_vars function to escape '$' variable syntax.
# This allows us to read/write command lines with shell variables (e.g.
# $LD_LIBRARY_PATH), without triggering make substitution.
escape_vars = $(subst $$,$$$$,$(1))
# Helper that expands to a shell command to echo a string exactly as it is in
# make. This uses printf instead of echo because printf's behaviour with respect
# to escape sequences is more portable than echo's across different shells
# (e.g., dash, bash).
exact_echo = printf '%s\n' '$(call escape_quotes,$(1))'

# Helper to compare the command we're about to run against the command
# we logged the last time we ran the command.  Produces an empty
# string (false) when the commands match.
# Tricky point: Make has no string-equality test function.
# The kernel uses the following, but it seems like it would have false
# positives, where one string reordered its arguments.
#   arg_check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
#                       $(filter-out $(cmd_$@), $(cmd_$(1))))
# We instead substitute each for the empty string into the other, and
# say they're equal if both substitutions produce the empty string.
# .d files contain ? instead of spaces, take that into account.
command_changed = $(or $(subst $(cmd_$(1)),,$(cmd_$(call replace_spaces,$@))),\
                       $(subst $(cmd_$(call replace_spaces,$@)),,$(cmd_$(1))))

# Helper that is non-empty when a prerequisite changes.
# Normally make does this implicitly, but we force rules to always run
# so we can check their command lines.
#   $? -- new prerequisites
#   $| -- order-only dependencies
prereq_changed = $(filter-out FORCE_DO_CMD,$(filter-out $|,$?))

# Helper that executes all postbuilds until one fails.
define do_postbuilds
  @E=0;\
  for p in $(POSTBUILDS); do\
    eval $$p;\
    E=$$?;\
    if [ $$E -ne 0 ]; then\
      break;\
    fi;\
  done;\
  if [ $$E -ne 0 ]; then\
    rm -rf "$@";\
    exit $$E;\
  fi
endef

# do_cmd: run a command via the above cmd_foo names, if necessary.
# Should always run for a given target to handle command-line changes.
# Second argument, if non-zero, makes it do asm/C/C++ dependency munging.
# Third argument, if non-zero, makes it do POSTBUILDS processing.
# Note: We intentionally do NOT call dirx for depfile, since it contains ? for
# spaces already and dirx strips the ? characters.
define do_cmd
$(if $(or $(command_changed),$(prereq_changed)),
  @$(call exact_echo,  $($(quiet)cmd_$(1)))
  @mkdir -p "$(call dirx,$@)" "$(dir $(depfile))"
  $(if $(findstring flock,$(word 1,$(cmd_$1))),
    @$(cmd_$(1))
    @echo "  $(quiet_cmd_$(1)): Finished",
    @$(cmd_$(1))
  )
  @$(call exact_echo,$(call escape_vars,cmd_$(call replace_spaces,$@) := $(cmd_$(1)))) > $(depfile)
  @$(if $(2),$(fixup_dep))
  $(if $(and $(3), $(POSTBUILDS)),
    $(call do_postbuilds)
  )
)
endef

# Declare the "all" target first so it is the default,
# even though we don't have the deps yet.
.PHONY: all
all:

# make looks for ways to re-generate included makefiles, but in our case, we
# don't have a direct way. Explicitly telling make that it has nothing to do
# for them makes it go faster.
%.d: ;

# Use FORCE_DO_CMD to force a target to run.  Should be coupled with
# do_cmd.
.PHONY: FORCE_DO_CMD
FORCE_DO_CMD:

TOOLSET := host
# Suffix rules, putting all outputs into $(obj).
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# Try building from generated source, too.
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)

$(obj).$(TOOLSET)/%.o: $(obj)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)

TOOLSET := target
# Suffix rules, putting all outputs into $(obj).
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(srcdir)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# Try building from generated source, too.
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj).$(TOOLSET)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)

$(obj).$(TOOLSET)/%.o: $(obj)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cpp FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.cxx FORCE_DO_CMD
	@$(call do_cmd,cxx,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.S FORCE_DO_CMD
	@$(call do_cmd,cc,1)
$(obj).$(TOOLSET)/%.o: $(obj)/%.s FORCE_DO_CMD
	@$(call do_cmd,cc,1)


ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/allocator/allocator.target.mk)))),)
  include base/allocator/allocator.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/allocator/allocator_extension_thunks.host.mk)))),)
  include base/allocator/allocator_extension_thunks.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/allocator/allocator_extension_thunks.target.mk)))),)
  include base/allocator/allocator_extension_thunks.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/android/jni_generator/jni_generator_py_tests.target.mk)))),)
  include base/android/jni_generator/jni_generator_py_tests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/android/jni_generator/jni_generator_tests.target.mk)))),)
  include base/android/jni_generator/jni_generator_tests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/android/jni_generator/jni_sample_header.target.mk)))),)
  include base/android/jni_generator/jni_sample_header.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/android/jni_generator/jni_sample_java.target.mk)))),)
  include base/android/jni_generator/jni_sample_java.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base.host.mk)))),)
  include base/base.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base.target.mk)))),)
  include base/base.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_i18n.target.mk)))),)
  include base/base_i18n.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_i18n_perftests.target.mk)))),)
  include base/base_i18n_perftests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_java.target.mk)))),)
  include base/base_java.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_java_application_state.target.mk)))),)
  include base/base_java_application_state.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_java_memory_pressure_level_list.target.mk)))),)
  include base/base_java_memory_pressure_level_list.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_java_test_support.target.mk)))),)
  include base/base_java_test_support.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_java_unittest_support.target.mk)))),)
  include base/base_java_unittest_support.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_javatests.target.mk)))),)
  include base/base_javatests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_jni_headers.target.mk)))),)
  include base/base_jni_headers.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_message_loop_tests.target.mk)))),)
  include base/base_message_loop_tests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_native_libraries_gen.target.mk)))),)
  include base/base_native_libraries_gen.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_perftests.target.mk)))),)
  include base/base_perftests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_perftests_apk.target.mk)))),)
  include base/base_perftests_apk.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_prefs.target.mk)))),)
  include base/base_prefs.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_prefs_test_support.target.mk)))),)
  include base/base_prefs_test_support.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_static.host.mk)))),)
  include base/base_static.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_static.target.mk)))),)
  include base/base_static.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_unittests.target.mk)))),)
  include base/base_unittests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_unittests_apk.target.mk)))),)
  include base/base_unittests_apk.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/base_unittests_jni_headers.target.mk)))),)
  include base/base_unittests_jni_headers.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/build_utf8_validator_tables.host.mk)))),)
  include base/build_utf8_validator_tables.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/check_example.target.mk)))),)
  include base/check_example.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/chromium_android_linker.target.mk)))),)
  include base/chromium_android_linker.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/run_all_unittests.target.mk)))),)
  include base/run_all_unittests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/sanitizer_options.host.mk)))),)
  include base/sanitizer_options.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/sanitizer_options.target.mk)))),)
  include base/sanitizer_options.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/symbolize.host.mk)))),)
  include base/symbolize.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/symbolize.target.mk)))),)
  include base/symbolize.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/test_support_base.target.mk)))),)
  include base/test_support_base.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/test_support_perf.target.mk)))),)
  include base/test_support_perf.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/third_party/dynamic_annotations/dynamic_annotations.host.mk)))),)
  include base/third_party/dynamic_annotations/dynamic_annotations.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/third_party/dynamic_annotations/dynamic_annotations.target.mk)))),)
  include base/third_party/dynamic_annotations/dynamic_annotations.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/xdg_mime.host.mk)))),)
  include base/xdg_mime.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,base/xdg_mime.target.mk)))),)
  include base/xdg_mime.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,build/android/build_output_dirs.target.mk)))),)
  include build/android/build_output_dirs.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,build/android/copy_system_libraries.target.mk)))),)
  include build/android/copy_system_libraries.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,build/android/get_build_device_configurations.target.mk)))),)
  include build/android/get_build_device_configurations.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,build/android/rezip.host.mk)))),)
  include build/android/rezip.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/android/native_test_jni_headers.target.mk)))),)
  include testing/android/native_test_jni_headers.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/android/native_test_native_code.target.mk)))),)
  include testing/android/native_test_native_code.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/android/native_test_util.target.mk)))),)
  include testing/android/native_test_util.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gmock.target.mk)))),)
  include testing/gmock.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gmock_main.target.mk)))),)
  include testing/gmock_main.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gtest.host.mk)))),)
  include testing/gtest.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gtest.target.mk)))),)
  include testing/gtest.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gtest_main.target.mk)))),)
  include testing/gtest_main.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gtest_prod.host.mk)))),)
  include testing/gtest_prod.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,testing/gtest_prod.target.mk)))),)
  include testing/gtest_prod.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/android_crazy_linker/crazy_linker.target.mk)))),)
  include third_party/android_crazy_linker/crazy_linker.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/android_tools/ndk/cpu_features.target.mk)))),)
  include third_party/android_tools/ndk/cpu_features.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/ashmem/ashmem.target.mk)))),)
  include third_party/ashmem/ashmem.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/copy_icudtl_dat.host.mk)))),)
  include third_party/icu/copy_icudtl_dat.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icudata.host.mk)))),)
  include third_party/icu/icudata.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icudata.target.mk)))),)
  include third_party/icu/icudata.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icui18n.host.mk)))),)
  include third_party/icu/icui18n.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icui18n.target.mk)))),)
  include third_party/icu/icui18n.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icuuc.host.mk)))),)
  include third_party/icu/icuuc.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/icu/icuuc.target.mk)))),)
  include third_party/icu/icuuc.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/libevent/libevent.host.mk)))),)
  include third_party/libevent/libevent.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/libevent/libevent.target.mk)))),)
  include third_party/libevent/libevent.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/libxml/libxml.target.mk)))),)
  include third_party/libxml/libxml.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/modp_b64/modp_b64.host.mk)))),)
  include third_party/modp_b64/modp_b64.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/modp_b64/modp_b64.target.mk)))),)
  include third_party/modp_b64/modp_b64.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/zlib/minizip.host.mk)))),)
  include third_party/zlib/minizip.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/zlib/minizip.target.mk)))),)
  include third_party/zlib/minizip.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/zlib/zlib.host.mk)))),)
  include third_party/zlib/zlib.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,third_party/zlib/zlib.target.mk)))),)
  include third_party/zlib/zlib.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/adb_reboot/adb_reboot.target.mk)))),)
  include tools/android/adb_reboot/adb_reboot.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/android_tools.target.mk)))),)
  include tools/android/android_tools.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/common/android_tools_common.host.mk)))),)
  include tools/android/common/android_tools_common.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/common/android_tools_common.target.mk)))),)
  include tools/android/common/android_tools_common.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/file_poller/file_poller.target.mk)))),)
  include tools/android/file_poller/file_poller.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/forwarder2/device_forwarder.target.mk)))),)
  include tools/android/forwarder2/device_forwarder.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/forwarder2/forwarder2.target.mk)))),)
  include tools/android/forwarder2/forwarder2.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/forwarder2/host_forwarder.host.mk)))),)
  include tools/android/forwarder2/host_forwarder.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler.target.mk)))),)
  include tools/android/heap_profiler.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_dump.target.mk)))),)
  include tools/android/heap_profiler/heap_dump.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler_core.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler_core.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler_integrationtest.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler_integrationtest.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler_integrationtest_stripped.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler_integrationtest_stripped.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler_unittests.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler_unittests.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/heap_profiler/heap_profiler_unittests_stripped.target.mk)))),)
  include tools/android/heap_profiler/heap_profiler_unittests_stripped.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/md5sum/md5sum.target.mk)))),)
  include tools/android/md5sum/md5sum.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/md5sum/md5sum_bin_host.host.mk)))),)
  include tools/android/md5sum/md5sum_bin_host.host.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/md5sum/md5sum_device_bin.target.mk)))),)
  include tools/android/md5sum/md5sum_device_bin.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/md5sum/md5sum_stripped_device_bin.target.mk)))),)
  include tools/android/md5sum/md5sum_stripped_device_bin.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memconsumer.target.mk)))),)
  include tools/android/memconsumer.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memconsumer/libmemconsumer.target.mk)))),)
  include tools/android/memconsumer/libmemconsumer.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memconsumer/memconsumer.target.mk)))),)
  include tools/android/memconsumer/memconsumer.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memconsumer/memconsumer_apk.target.mk)))),)
  include tools/android/memconsumer/memconsumer_apk.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memdump.target.mk)))),)
  include tools/android/memdump.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memdump/memdump-unstripped.target.mk)))),)
  include tools/android/memdump/memdump-unstripped.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/memdump/memdump.target.mk)))),)
  include tools/android/memdump/memdump.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/ps_ext.target.mk)))),)
  include tools/android/ps_ext.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/ps_ext/ps_ext-unstripped.target.mk)))),)
  include tools/android/ps_ext/ps_ext-unstripped.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/ps_ext/ps_ext.target.mk)))),)
  include tools/android/ps_ext/ps_ext.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/purge_ashmem/purge_ashmem.target.mk)))),)
  include tools/android/purge_ashmem/purge_ashmem.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/run_pie/run_pie-unstripped.target.mk)))),)
  include tools/android/run_pie/run_pie-unstripped.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/android/run_pie/run_pie.target.mk)))),)
  include tools/android/run_pie/run_pie.target.mk
endif
ifeq ($(strip $(foreach prefix,$(NO_LOAD),\
    $(findstring $(join ^,$(prefix)),\
                 $(join ^,tools/telemetry/bitmaptools.host.mk)))),)
  include tools/telemetry/bitmaptools.host.mk
endif

#quiet_cmd_regen_makefile = ACTION Regenerating $@
#cmd_regen_makefile = cd $(srcdir); ./build/gyp_chromium -fmake --ignore-environment "--toplevel-dir=/home/daiguozhou/sda6/code/chromium/src" -I/home/daiguozhou/sda6/code/chromium/src/build/common.gypi "--depth=/home/daiguozhou/sda6/code/chromium/src" "--generator-output=../../xxxx/build" --check "-DOS=android" "-Dcomponent=shared_library" "-Dgyp_output_dir=out" base/base.gyp
#Makefile: $(srcdir)/tools/android/ps_ext/ps_ext.gyp $(srcdir)/third_party/icu/icu.gyp $(srcdir)/build/nocompile.gypi $(srcdir)/tools/android/memconsumer/memconsumer.gyp $(srcdir)/build/filename_rules.gypi $(srcdir)/third_party/android_tools/ndk/android_tools_ndk.gyp $(srcdir)/build/android/java_cpp_template.gypi $(srcdir)/build/android/push_libraries.gypi $(srcdir)/build/android/finalize_apk_action.gypi $(srcdir)/third_party/zlib/zlib.gyp $(srcdir)/tools/android/android_tools.gyp $(srcdir)/build/android/pack_arm_relocations.gypi $(srcdir)/tools/android/run_pie/run_pie.gyp $(srcdir)/base/base_unittests.isolate $(srcdir)/build/android/rezip.gyp $(srcdir)/build/copy_test_data_ios.gypi $(srcdir)/build/android/write_ordered_libraries.gypi $(srcdir)/testing/android/native_test.gyp $(srcdir)/build/internal/release_impl.gypi $(srcdir)/tools/android/memdump/memdump.gyp $(srcdir)/base/third_party/dynamic_annotations/dynamic_annotations.gyp $(srcdir)/build/android/strip_native_libraries.gypi $(srcdir)/build/jni_generator.gypi $(srcdir)/tools/android/purge_ashmem/purge_ashmem.gyp $(srcdir)/base/allocator/allocator.gyp $(srcdir)/tools/android/heap_profiler/heap_profiler.gyp $(srcdir)/third_party/modp_b64/modp_b64.gyp $(srcdir)/tools/android/md5sum/md5sum.gyp $(srcdir)/build/internal/release_impl_official.gypi $(srcdir)/build/internal/release_defaults.gypi $(srcdir)/build/android/cpufeatures.gypi $(srcdir)/build/shim_headers.gypi $(srcdir)/base/base.gypi $(srcdir)/third_party/ashmem/ashmem.gyp $(srcdir)/build/android/create_standalone_apk_action.gypi $(srcdir)/build/java.gypi $(srcdir)/build/apk_test.gypi $(srcdir)/testing/gmock.gyp $(srcdir)/build/isolate.gypi $(srcdir)/build/android/instr_action.gypi $(srcdir)/base/android/jni_generator/jni_generator.gyp $(srcdir)/tools/android/common/common.gyp $(srcdir)/build/util/version.gypi $(srcdir)/third_party/icu/icu.gypi $(srcdir)/tools/telemetry/telemetry.gyp $(srcdir)/build/release.gypi $(srcdir)/build/java_apk.gypi $(srcdir)/testing/gtest.gyp $(srcdir)/build/common.gypi $(srcdir)/base/base.gyp $(srcdir)/build/android/setup.gyp $(srcdir)/build/set_clang_warning_flags.gypi $(srcdir)/third_party/android_crazy_linker/crazy_linker.gyp $(srcdir)/build/android/native_app_dependencies.gypi $(srcdir)/tools/android/forwarder2/forwarder.gyp $(srcdir)/testing/gtest.gypi $(srcdir)/tools/android/adb_reboot/adb_reboot.gyp $(srcdir)/third_party/libevent/libevent.gyp $(srcdir)/tools/android/file_poller/file_poller.gyp $(srcdir)/build/android/dex_action.gypi $(srcdir)/third_party/icu/icu.isolate $(srcdir)/base/base.isolate $(srcdir)/build/win_precompile.gypi $(srcdir)/third_party/libxml/libxml.gyp $(srcdir)/build/android/lint_action.gypi
#	$(call do_cmd,regen_makefile)

# "all" is a concatenation of the "all" targets from all the included
# sub-makefiles. This is just here to clarify.
all:

# Add in dependency-tracking rules.  $(all_deps) is the list of every single
# target in our tree. Only consider the ones with .d (dependency) info:
d_files := $(wildcard $(foreach f,$(all_deps),$(depsdir)/$(f).d))
ifneq ($(d_files),)
  include $(d_files)
endif
