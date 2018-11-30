#include "app_jni_registrar.h"

#include "base/android/base_jni_registrar.h"
#include "base/android/jni_android.h"

#ifdef __cplusplus
extern "C" {
#endif

jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    //Get new JNIEnv
    JNIEnv* env;
    if (JNI_OK != vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_4)) {
        return -1;
    }

    base::android::InitVM(vm);

    if (!base::android::RegisterJni(env)) {
      return -1;
    }

    if (!app::RegisterJni(env)) {
        return -1;
    }

    return JNI_VERSION_1_4;
}

#ifdef __cplusplus
}
#endif
