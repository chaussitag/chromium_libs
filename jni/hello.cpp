/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
#include "HelloJni_jni.h"

#include "base/android/build_info.h"
#include "base/android/jni_string.h"

#include <android/log.h>
#define LOG_TAG "hello_jni"

namespace app {

static jstring GetString(JNIEnv* env, jclass jcaller) {
    return base::android::ConvertUTF8ToJavaString(env,
            "[[从jni传回的字符串]]").Release();
}

static void LogVendor(JNIEnv* env, jclass jcaller) {
    base::android::BuildInfo* buildInfo = base::android::BuildInfo::GetInstance();
    __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG,
            "build-info: device %s, model %s, brand %s, android_build_id %s, package_name %s, build_type %s",
            buildInfo->device(), buildInfo->model(), buildInfo->brand(),
            buildInfo->android_build_id(), buildInfo->package_name(), buildInfo->build_type());
}

bool RegisterHelloJni(JNIEnv* env) {
  return RegisterNativesImpl(env);
}


} // namespace app
