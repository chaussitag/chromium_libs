LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../ndk_build_config.mk
include $(LOCAL_PATH)/libevent_config.mk

LOCAL_MODULE := libevent

LOCAL_CFLAGS := $(libevent_DEFS_$(BUILD_TYPE)) $(libevent_CFLAGS_$(BUILD_TYPE))
LOCAL_CPPFLAGS := $(libevent_CFLAGS_CC_$(BUILD_TYPE))
LOCAL_C_INCLUDES := $(LOCAL_PATH)/android

LOCAL_SRC_FILES := \
	buffer.c \
	evbuffer.c \
	evdns.c \
	event.c \
	event_tagging.c \
	evrpc.c \
	evutil.c \
	http.c \
	log.c \
	poll.c \
	select.c \
	signal.c \
	strlcpy.c \
	epoll.c


include $(BUILD_STATIC_LIBRARY)
