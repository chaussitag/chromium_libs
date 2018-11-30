#include <jni.h>
#include <string>

extern "C" JNIEXPORT jstring JNICALL
Java_example_com_hello_1chromium_1libs_HelloChromiumLibs_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}
