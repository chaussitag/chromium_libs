LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := hello-jni
LOCAL_SRC_FILES := jni_onload.cpp app_jni_registrar.cpp hello_jni_application.cpp hello.cpp

LOCAL_LDLIBS := -llog

##################################################################################################
## generate jni headers ##
LOCAL_SRC_FILES := jni_header_deps.cpp $(LOCAL_SRC_FILES)
JNI_HEADER_OUTPUT_DIR := $(LOCAL_PATH)/jni_gen

JNI_HEADERS := \
	$(JNI_HEADER_OUTPUT_DIR)/HelloJni_jni.h \
	$(JNI_HEADER_OUTPUT_DIR)/HelloJniApplication_jni.h

.PHONY : $(JNI_HEADERS)

$(LOCAL_PATH)/jni_header_deps.cpp : $(JNI_HEADERS)
	@touch $@

JNI_GENERATOR := $(LOCAL_PATH)/chromium/src/base/android/jni_generator/jni_generator.py
JAVA_SRC_PATH := $(LOCAL_PATH)/../src/com/example/hellojni
$(JNI_HEADERS): $(JNI_HEADER_OUTPUT_DIR)/%_jni.h : $(JAVA_SRC_PATH)/%.java $(JNI_GENERATOR)
	@ if [ ! -d $(JNI_HEADER_OUTPUT_DIR) ]; then \
		mkdir -p "$(JNI_HEADER_OUTPUT_DIR)"; \
	fi
	@$(JNI_GENERATOR) --input_file "$(abspath $<)" --output_dir "$(JNI_HEADER_OUTPUT_DIR)" \
	--includes base/android/jni_generator/jni_generator_helper.h --optimize_generation 0 \
	--ptr_type long
	@echo "$@ <= $<"

LOCAL_C_INCLUDES := $(LOCAL_C_INCLUDES) $(JNI_HEADER_OUTPUT_DIR)

LOCAL_SHARED_LIBRARIES := $(LOCAL_SHARED_LIBRARIES) libbase.so
##################################################################################################

include $(BUILD_SHARED_LIBRARY)

##################################################################################################
## import libbase
$(call import-add-path,$(LOCAL_PATH))
$(call import-module,chromium)
##################################################################################################
