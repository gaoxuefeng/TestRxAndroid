LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)


LOCAL_C_INCLUDES := \
	$(JNI_H_INCLUDE)


#LOCAL_LDLIBS := -lssl -lcrypto

LOCAL_LDLIBS := -lm -llog -lz
LOCAL_MODULE :=ETHANKENCRYPT
LOCAL_SRC_FILES :=  encrypt.c\

LOCAL_SHARED_LIBRARIES := \
	libandroid_runtime \
	libnativehelper \
	libcutils \
	libutils \
	zlib \
	libz

LOCAL_CFLAGS += -Wall -Wextra  -DNDEBUG -DOS_LINUX

include  $(BUILD_SHARED_LIBRARY)