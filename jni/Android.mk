LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := hello-jni
LOCAL_SRC_FILES := jni_onload.cpp app_jni_registrar.cpp hello_jni_application.cpp hello.cpp

LOCAL_LDLIBS := -llog

##################################################################################################
## add the include path
LOCAL_C_INCLUDES := $(LOCAL_C_INCLUDES) $(LOCAL_PATH)/chromium/src
## link to libchromium_base.so
LOCAL_SHARED_LIBRARIES := $(LOCAL_SHARED_LIBRARIES) libchromium_base

## generate jni headers ##
LOCAL_SRC_FILES := jni_header_deps.cpp $(LOCAL_SRC_FILES)

APP_JNI_HEADER_OUTPUT_DIR := $(LOCAL_PATH)/jni_header_gen
APP_JNI_HEADERS := \
	$(APP_JNI_HEADER_OUTPUT_DIR)/HelloJni_jni.h \
	$(APP_JNI_HEADER_OUTPUT_DIR)/HelloJniApplication_jni.h

$(LOCAL_PATH)/jni_header_deps.cpp : $(APP_JNI_HEADERS)
	@touch $@

APP_JAVA_SRC_PATH := $(LOCAL_PATH)/../src/com/example/hellojni
$(APP_JNI_HEADERS): PRIVATE_JNI_GENERATOR := $(LOCAL_PATH)/chromium/src/base/android/jni_generator/jni_generator.py
$(APP_JNI_HEADERS): $(APP_JNI_HEADER_OUTPUT_DIR)/%_jni.h : $(APP_JAVA_SRC_PATH)/%.java
	@ if [ ! -d $(APP_JNI_HEADER_OUTPUT_DIR) ]; then \
		mkdir -p "$(APP_JNI_HEADER_OUTPUT_DIR)"; \
	fi
	@$(PRIVATE_JNI_GENERATOR) --input_file "$(abspath $<)" --output_dir "$(APP_JNI_HEADER_OUTPUT_DIR)" \
	--includes base/android/jni_generator/jni_generator_helper.h --optimize_generation 0 \
	--ptr_type long
	@echo "[jni_generator]          : $(notdir $@) <= $(notdir $<)"

LOCAL_C_INCLUDES := $(LOCAL_C_INCLUDES) $(APP_JNI_HEADER_OUTPUT_DIR)

##################################################################################################

include $(BUILD_SHARED_LIBRARY)

##################################################################################################
## include libchromium_base.so
include $(LOCAL_PATH)/chromium/Android.mk
##################################################################################################
