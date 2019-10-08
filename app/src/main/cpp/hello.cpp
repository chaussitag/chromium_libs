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
#include "HelloChromiumLibs_jni.h"

#include "base/android/build_info.h"
#include "base/android/jni_string.h"
#include "base/logging.h"
#include "base/task/post_task.h"
#include "base/trace_event/trace_event.h"

#include <android/log.h>

#define LOG_TAG "hello_jni"

namespace app {

base::android::ScopedJavaLocalRef<jstring> JNI_HelloChromiumLibs_GetString(JNIEnv *env,
                                                                           const base::android::JavaParamRef<jobject> &jcaller) {

    TRACE_EVENT0("jni", "JNI_HelloChromiumLibs_GetString");

    // demonstrate calling java method from native code
    Java_HelloChromiumLibs_someJavaMethod(env, jcaller,
                                          base::android::ConvertUTF8ToJavaString(env,
                                                                                 "[[hello from native]]"));

    return base::android::ConvertUTF8ToJavaString(env,
                                                  "[[从jni传回的字符串]]");
}

void JNI_HelloChromiumLibs_LogVendor(JNIEnv *env) {
    TRACE_EVENT0("jni", "JNI_HelloChromiumLibs_LogVendor");

    base::android::BuildInfo *build_info = base::android::BuildInfo::GetInstance();
    LOG(INFO) << "build-info: device: " << build_info->device()
              << ", model: " << build_info->model()
              << ", brand: " << build_info->brand()
              << ", android_build_id: " << build_info->android_build_id()
              << ", package_name: " << build_info->package_name()
              << ", build_type: " << build_info->build_type()
              << ", abi_name: " << build_info->abi_name();

    VLOG(0) << "JNI_HelloChromiumLibs_LogVendor: log level = " << logging::GetMinLogLevel()
            << ", default verbosity = " << logging::GetVlogVerbosity();
}

void JNI_HelloChromiumLibs_PostTask(JNIEnv *env) {
    auto task_runner = base::CreateSingleThreadTaskRunnerWithTraits(
            {base::TaskPriority::USER_VISIBLE});
    task_runner->PostTask(FROM_HERE, base::BindOnce([] () -> void {
        LOG(INFO) << "single-thread-task1, thread id: " << base::PlatformThread::CurrentId();
        base::PlatformThread::Sleep(base::TimeDelta::FromSeconds(1));
    }));

    task_runner->PostTask(FROM_HERE, base::BindOnce([] () -> void {
        LOG(INFO) << "single-thread-task2, thread id: " << base::PlatformThread::CurrentId();
        base::PlatformThread::Sleep(base::TimeDelta::FromSeconds(1));
    }));

    base::PostTask(FROM_HERE, base::BindOnce([] () -> void {
        LOG(INFO) << "thread-pool-task, thread id: " << base::PlatformThread::CurrentId();
    }));
}

} // namespace app
