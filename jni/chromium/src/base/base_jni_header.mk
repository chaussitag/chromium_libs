##################################################################################################
## generate jni headers ##
LOCAL_SRC_FILES := base_jni_header_deps.cc $(LOCAL_SRC_FILES)

CHROMIUM_SRC_DIR := $(LOCAL_PATH)/..
BASE_JNI_HEADER_OUTPUT_DIR := $(CHROMIUM_SRC_DIR)/jni_header_gen/base/jni
BASE_JAVA_SRC_PATH := $(LOCAL_PATH)/android/java/src/org/chromium/base

BASE_JNI_HEADERS_1 := \
	    $(BASE_JNI_HEADER_OUTPUT_DIR)/ApplicationStatus_jni.h \
	    $(BASE_JNI_HEADER_OUTPUT_DIR)/BuildInfo_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/CommandLine_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/ContentUriUtils_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/CpuFeatures_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/EventLog_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/FieldTrialList_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/ImportantFileWriterAndroid_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/JNIUtils_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/MemoryPressureListener_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/JavaHandlerThread_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/PathService_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/PathUtils_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/PowerMonitor_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/SystemMessageHandler_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/SysUtils_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/ThreadUtils_jni.h \
		$(BASE_JNI_HEADER_OUTPUT_DIR)/TraceEvent_jni.h

BASE_JNI_HEADERS_2 := $(BASE_JNI_HEADER_OUTPUT_DIR)/LibraryLoader_jni.h

BASE_JNI_HEADERS := $(BASE_JNI_HEADERS_1) $(BASE_JNI_HEADERS_2)

## guard the jni header related targets to suppress ndk build warnings,
## because this file may be included several times during ndk build
ifndef BASE_JNI_HEADERS_TARGETS_GUARD
BASE_JNI_HEADERS_TARGETS_GUARD := ""

$(LOCAL_PATH)/base_jni_header_deps.cc : $(BASE_JNI_HEADERS)
	@touch $@

$(BASE_JNI_HEADERS_1): PRIVATE_JNI_GENERATOR := $(CHROMIUM_SRC_DIR)/base/android/jni_generator/jni_generator.py
$(BASE_JNI_HEADERS_1): $(BASE_JNI_HEADER_OUTPUT_DIR)/%_jni.h : $(BASE_JAVA_SRC_PATH)/%.java
	@ if [ ! -d $(BASE_JNI_HEADER_OUTPUT_DIR) ]; then \
		mkdir -p "$(BASE_JNI_HEADER_OUTPUT_DIR)"; \
	fi
	@$(PRIVATE_JNI_GENERATOR) --input_file "$(abspath $<)" --output_dir "$(BASE_JNI_HEADER_OUTPUT_DIR)" \
		--includes base/android/jni_generator/jni_generator_helper.h --optimize_generation 0 \
		--ptr_type long
	@echo "[jni_generator]          : $(notdir $@) <= $(notdir $<)"

$(BASE_JNI_HEADERS_2): PRIVATE_JNI_GENERATOR := $(CHROMIUM_SRC_DIR)/base/android/jni_generator/jni_generator.py
$(BASE_JNI_HEADERS_2): $(BASE_JNI_HEADER_OUTPUT_DIR)/%_jni.h : $(BASE_JAVA_SRC_PATH)/library_loader/%.java
	@ if [ ! -d $(BASE_JNI_HEADER_OUTPUT_DIR) ]; then \
		mkdir -p "$(BASE_JNI_HEADER_OUTPUT_DIR)"; \
	fi
	@$(PRIVATE_JNI_GENERATOR) --input_file "$(abspath $<)" --output_dir "$(BASE_JNI_HEADER_OUTPUT_DIR)" \
		--includes base/android/jni_generator/jni_generator_helper.h --optimize_generation 0 \
		--ptr_type long
	@echo "[jni_generator]          : $(notdir $@) <= $(notdir $<)"

clean: clean_base_jni_headers
.PHONY: clean_base_jni_headers
clean_base_jni_headers: PRIVATE_JNI_HEADER_OUTPUT_DIR := $(BASE_JNI_HEADER_OUTPUT_DIR)
clean_base_jni_headers:
	@ if [ -d $(PRIVATE_JNI_HEADER_OUTPUT_DIR) ]; then \
		rm -fr $(PRIVATE_JNI_HEADER_OUTPUT_DIR); \
	fi
	@echo "auto-generated jni headers for libchromium_base cleaned"

endif ## BASE_JNI_HEADERS_TARGETS_GUARD

LOCAL_C_INCLUDES := $(LOCAL_C_INCLUDES) $(BASE_JNI_HEADER_OUTPUT_DIR)/..

##################################################################################################
