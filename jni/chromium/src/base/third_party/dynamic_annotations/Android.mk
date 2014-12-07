LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../../ndk_build_config.mk
include $(LOCAL_PATH)/dynamic_annotations_config.mk

LOCAL_MODULE := libdynamic_annotations

LOCAL_CFLAGS := $(dynamic_annotations_DEFS_$(BUILD_TYPE)) $(dynamic_annotations_CFLAGS_$(BUILD_TYPE))
LOCAL_CPPFLAGS := $(dynamic_annotations_CFLAGS_CC_$(BUILD_TYPE))
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../..

LOCAL_SRC_FILES := dynamic_annotations.c

include $(BUILD_STATIC_LIBRARY)
