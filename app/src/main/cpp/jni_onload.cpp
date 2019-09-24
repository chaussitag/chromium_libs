#include "app_library_loader_hooks.h"

#include "base/android/base_jni_onload.h"
#include "base/android/jni_android.h"
#include "base/android/library_loader/library_loader_hooks.h"
#include "base/logging.h"

#ifdef __cplusplus
extern "C" {
#endif

jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    base::android::InitVM(vm);
    if (!base::android::OnJNIOnLoadInit())
        return -1;

    base::android::SetLibraryLoadedHook(&app::AppLibraryLoaded);

    return JNI_VERSION_1_4;
}

#ifdef __cplusplus
}
#endif
