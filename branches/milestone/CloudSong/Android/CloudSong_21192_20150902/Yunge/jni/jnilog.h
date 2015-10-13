#ifndef ETHANK_JNI_LOG_H
#define ETHANK_JNI_LOG_H

#include <android/log.h>

//#define DEBUG

#define LOG_TAG "ETHANK_JNI"

#ifdef DEBUG

#define LOGI(fmt, args...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, fmt, ##args)
#define LOGD(fmt, args...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, fmt, ##args)
#define LOGE(fmt, args...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, fmt, ##args)

#else

#define LOGI(fmt, args...)
#define LOGD(fmt, args...)
#define LOGE(fmt, args...)

#endif

#endif
