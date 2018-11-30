#include "hello.h"
#include "hello_jni_application.h"

#include "base/android/jni_android.h"
#include "base/android/jni_registrar.h"
#include "base/debug/trace_event.h"

namespace app {
static base::android::RegistrationMethod kAppRegisteredMethods[] = {

  { "HelloJni", app::RegisterHelloJni },
  { "HelloJniApplication", app::RegisterHelloJniApplication },

};

bool RegisterJni(JNIEnv* env) {
    TRACE_EVENT0("startup", "base_android::RegisterJni");
    return base::android::RegisterNativeMethods(env, kAppRegisteredMethods,
                                 arraysize(kAppRegisteredMethods));

}

}
