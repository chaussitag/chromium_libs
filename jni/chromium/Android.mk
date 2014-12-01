LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libbase.so
LOCAL_MODULE_FILE_NAME := libbase.so
LOCAL_SRC_FILES := build/out/Debug/lib.target/libbase.cr.so


LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src
#$(info "LOCAL_EXPORT_C_INCLUDES $(LOCAL_EXPORT_C_INCLUDES)")

include $(PREBUILT_SHARED_LIBRARY)
