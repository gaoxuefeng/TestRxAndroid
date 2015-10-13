/*
 * coded by longdw 2015.5.21
 * http://www.longdw.com
 */
#include "aes256.h"
#include "base64.h"

#ifndef LOGE
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,"jni---get---key",__VA_ARGS__)
#endif

jstring getImportInfo(JNIEnv *, jstring);
jstring charToJstring(JNIEnv* envPtr, char *src);

jstring JNICALL Java_com_ldw_aes_utils_AESUtils_getImportantInfoByJNI(
		JNIEnv *env, jobject thiz, jstring mingwen) {

	return getImportInfo(env, mingwen);
}

jstring getImportInfo(JNIEnv* envPtr, jstring mingwen) {
	JNIEnv env = *envPtr;

	//0123456789ABCDEFGHIJKLMNOPQRSTUV
	unsigned char key[32] = { 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
			0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
			0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50, 0x51, 0x52, 0x53, 0x54,
			0x55, 0x56 }; //密钥

	//****************************************开始加密******************************************************
	//1.初始化数据
	//初始化向量
	uint8_t iv[16] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

	//初始化加密参数
	aes256_context ctx;
	aes256_init(&ctx, key);

	//2.将jstring转为char
	const char *mwChar = env->GetStringUTFChars(envPtr, mingwen, JNI_FALSE);

	//3.分组填充加密
	int i;
	int mwSize = strlen(mwChar);
	int remainder = mwSize % 16;
	jstring entryptString;
	if (mwSize < 16) {	//小于16字节，填充16字节，后面填充几个几 比方说10个字节 就要补齐6个6 11个字节就补齐5个5
		uint8_t input[16];
		for (i = 0; i < 16; i++) {
			if (i < mwSize) {
				input[i] = mwChar[i];
			} else {
				input[i] = 16 - mwSize;
			}
		}
		//加密
		uint8_t output[16];
		aes256_encrypt_cbc(&ctx, input, iv, output);
		//base64加密后然后jstring格式输出
		char *enc = base64_encode(output, sizeof(output));
		entryptString = charToJstring(envPtr, enc);

		free(enc);
	} else {	//如果是16的倍数，填充16字节，后面填充0x10
		int group = mwSize / 16;
		int size = 16 * (group + 1);
		uint8_t input[size];
		for (i = 0; i < size; i++) {
			if (i < mwSize) {
				input[i] = mwChar[i];
			} else {
				if (remainder == 0) {
					input[i] = 0x10;
				} else {	//如果不足16位 少多少位就补几个几  如：少4为就补4个4 以此类推
					int dif = size - mwSize;
					input[i] = dif;
				}
			}
		}
		//加密
		uint8_t output[size];
		aes256_encrypt_cbc(&ctx, input, iv, output);
		//base64加密后然后jstring格式输出
		char *enc = base64_encode(output, sizeof(output));
		entryptString = charToJstring(envPtr, enc);

		free(enc);
	}

	//释放mwChar
	env->ReleaseStringUTFChars(envPtr, mingwen, mwChar);

	return entryptString;

///////////////////////////*********************************************************************************
//	//0123456789ABCDEF
//	unsigned char input[64] = {
//			0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
//			0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46,
//			0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
//			0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46,
//			0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
//			0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46,
//			0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
//			0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10
//	}; //明文
//
//
//	//初始化向量
//	uint8_t iv[16] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
//
//	int i;
//	aes256_context ctx;
//	uint8_t enc_out[64];
//	aes256_init(&ctx, key);
//
//	aes256_encrypt_cbc(&ctx, input, iv, enc_out);
//	for(i = 0;i < 64;i++) {
//		LOGE("================%i", enc_out[i]);
//	}
///////////////////////////**********************************************************************************

//	return packageName;
//	if (hashCode == -1739821499) {
//		return retval;
//	} else {
//		return env->NewStringUTF(env, "error");
//	}
}

jstring charToJstring(JNIEnv* envPtr, char *src) {
	JNIEnv env = *envPtr;

	jsize len = strlen(src);
	jclass clsstring = env->FindClass(envPtr, "java/lang/String");
	jstring strencode = env->NewStringUTF(envPtr, "UTF-8");
	jmethodID mid = env->GetMethodID(envPtr, clsstring, "<init>",
			"([BLjava/lang/String;)V");
	jbyteArray barr = env->NewByteArray(envPtr, len);
	env->SetByteArrayRegion(envPtr, barr, 0, len, (jbyte*) src);

	return (jstring) env->NewObject(envPtr, clsstring, mid, barr, strencode);
}
