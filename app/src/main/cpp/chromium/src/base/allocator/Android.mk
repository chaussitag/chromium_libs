LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../ndk_build_config.mk
include $(LOCAL_PATH)/allocator_extension_thunks_config.mk

LOCAL_MODULE := liballocator_extension_thunks

LOCAL_CFLAGS := $(allocation_extension_thunks_DEFS_$(BUILD_TYPE)) $(allocation_extension_thunks_CFLAGS_$(BUILD_TYPE))
LOCAL_CPPFLAGS := $(allocation_extension_thunks_CFLAGS_CC_$(BUILD_TYPE))

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../..

LOCAL_CPP_EXTENSION := .cc

LOCAL_SRC_FILES := allocator_extension_thunks.cc

include $(BUILD_STATIC_LIBRARY)
