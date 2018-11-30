LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../ndk_build_config.mk
include $(LOCAL_PATH)/ashmem_config.mk

LOCAL_MODULE := libashmem

LOCAL_CFLAGS := $(ashmem_DEFS_$(BUILD_TYPE)) $(ashmem_CFLAGS_$(BUILD_TYPE))
LOCAL_CPPFLAGS := $(ashmem_CFLAGS_CC_$(BUILD_TYPE))

LOCAL_SRC_FILES := ashmem-dev.c

include $(BUILD_STATIC_LIBRARY)
