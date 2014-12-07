LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../ndk_build_config.mk
include $(LOCAL_PATH)/modp_b64_config.mk

LOCAL_MODULE := libmodp_b64

LOCAL_CFLAGS := $(modp_b64_DEFS_$(BUILD_TYPE)) $(modp_b64_CFLAGS_$(BUILD_TYPE))
LOCAL_CPPFLAGS := $(modp_b64_CFLAGS_CC_$(BUILD_TYPE))

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../..

LOCAL_CPP_EXTENSION := .cc

LOCAL_SRC_FILES := modp_b64.cc

include $(BUILD_STATIC_LIBRARY)


