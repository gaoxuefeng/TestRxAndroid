#include "ethank.h"

std::string jstring2string(JNIEnv *env, jobject, jstring j_str) {
    int len = env->GetStringLength(j_str);
    char* w_str = new char[len + 1];
    
    w_str[len] = NULL;
    
    const jchar *c_str = env->GetStringChars(j_str, NULL);
    
    for (int i = 0; i < len; i++) {
        w_str[i] = c_str[i];
    }
    env->ReleaseStringChars(j_str, c_str);
    c_str = NULL;
    
    std::string wstr_ret(w_str, len);
    
    delete w_str;
    w_str = NULL;
    return wstr_ret;
}

jstring c2js(JNIEnv* env, jobject, const char * str, int len) {
    jchar* str2 = (jchar *) malloc(sizeof(jchar) * (len + 1));
    
    for (int i = 0; i < len; i++) {
        str2[i] = str[i];
    }
    
    str2[len] = 0;
    jstring js = env->NewString(str2, len);
    free(str2);
    return js;
}


static jstring jni_ethankencrypt(JNIEnv *env, jobject obj, jstring clear) {
    string password = "mypassword123$!"
    string cclear ＝jstring2string(env, clear);
    RNEncryptor *encryptor = new RNEncryptor();
    string cipher = encryptor->encrypt(cclear, password);
    return c2js(env, cipher.c_str(), cipher.length());
}

static jstring jni_ethankdecrypt(JNIEnv *env, jobject obj, jstring cipher) {
    string password = "mypassword123$!"
    string ccipher = jstring2string(env, cipher);
    RNDecryptor *decryptor = new RNDecryptor();
    string clear = encryptor->encrypt(cipher, password);
    return c2js(env, clear.c_str(), clear.length());
}


static JNINativeMethod gMethods[] = {
    /*Name , Si2gnature , Function Pointer*/
    {"ethankencrypt", "(Ljava/lang/String;)Ljava/lang/String;", (void *) jni_ethankencrypt},
    {"ethankdecrypt", "(Ljava/lang/String;)Ljava/lang/String;", (void *) jni_ethankdecrypt}
};

static int register_sogouencrypt(JNIEnv* env) {
    //	char const * const kClassPathName = "com/coyotelib/core/jni/Native";
    
    char const * const kClassPathName = "cn/com/ethank/yunge/app/crypt/Native";
    jclass clazz;
    clazz = env->FindClass(kClassPathName);
    
    if (NULL == clazz) {
        return JNI_FALSE;
    }
    
    if (env->RegisterNatives(clazz, gMethods,
                                sizeof(gMethods) / sizeof(gMethods[0])) < 0) {
        return JNI_FALSE;
    }
    
    return JNI_TRUE;
}

jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    (void) reserved;
    JNIEnv* env = NULL;
    jint result = -1;
    
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_6) != JNI_OK) {
        return result;
    }
    
    assert(env != NULL);
    
    if (register_sogouencrypt(env) < 0) {
        return result;
    }
    
    result = JNI_VERSION_1_6;
    return result;
}