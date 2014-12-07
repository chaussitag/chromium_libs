LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src

include $(LOCAL_PATH)/src/Android.mk
