#include "HelloJniApplication_jni.h"

#include "base/android/jni_android.h"
#include "base/android/scoped_java_ref.h"

namespace app {

static void InitApplicationContext(JNIEnv* env, jobject jcaller,
    jobject context) {
    base::android::ScopedJavaLocalRef<jobject> scoped_context(env, context);
    base::android::InitApplicationContext(env, scoped_context);
}

bool RegisterHelloJniApplication(JNIEnv* env) {
  return RegisterNativesImpl(env);
}

}

