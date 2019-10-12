//
// Created by dagger on 19-10-12.
//
#include "main_activity_jni.h"

#include "MainActivity_jni.h"

#include "app_scheduler/app_task_traits.h"

#include "base/android/build_info.h"
#include "base/android/jni_string.h"
#include "base/logging.h"
#include "base/strings/stringprintf.h"
#include "base/task/post_task.h"
#include "base/trace_event/trace_event.h"

namespace app {

base::android::ScopedJavaLocalRef<jstring> JNI_MainActivity_GetString(JNIEnv *env,
                                                                      const base::android::JavaParamRef<jobject> &jcaller) {
  TRACE_EVENT0("jni",
               "JNI_HelloChromiumLibs_GetString");

  // demonstrate calling java method from native code
  Java_MainActivity_someJavaMethod(env,
                                   jcaller,
                                   base::android::ConvertUTF8ToJavaString(env,
                                                                          "[[hello from native]]"));

  return base::android::ConvertUTF8ToJavaString(env,
                                                "[[从jni传回的字符串]]");
}

void JNI_MainActivity_LogVendor(JNIEnv *env) {
  TRACE_EVENT0("jni",
               "JNI_HelloChromiumLibs_LogVendor");

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

void JNI_MainActivity_PostTaskExamples(JNIEnv *env) {
  auto task_runner =
      base::CreateSingleThreadTaskRunnerWithTraits({base::TaskPriority::USER_VISIBLE});
  task_runner->PostTask(FROM_HERE,
                        base::BindOnce([]() -> void {
                          LOG(INFO) << "single-thread-task1, thread id: " << base::PlatformThread::CurrentId();
                          base::PlatformThread::Sleep(base::TimeDelta::FromSeconds(1));
                        }));

  task_runner->PostTask(FROM_HERE,
                        base::BindOnce([]() -> void {
                          LOG(INFO) << "single-thread-task2, thread id: " << base::PlatformThread::CurrentId();
                          base::PlatformThread::Sleep(base::TimeDelta::FromSeconds(1));
                        }));

  base::PostTask(FROM_HERE,
                 base::BindOnce([]() -> void {
                   LOG(INFO) << "thread-pool-task, thread id: " << base::PlatformThread::CurrentId();
                 }));

  base::PostTaskWithTraits(FROM_HERE,
                           {WellKnownThreadID::UI},
                           base::BindOnce([]() -> void {
                             LOG(INFO) << "ui-thread-task, thread id: " << base::PlatformThread::CurrentId();
                           }));
}

static jlong JNI_MainActivity_Init(JNIEnv *env, const base::android::JavaParamRef<jobject> &jcaller) {
  return reinterpret_cast<intptr_t>(new MainActivityJni(env, jcaller));
}

MainActivityJni::MainActivityJni(JNIEnv *env,
                                 const base::android::JavaParamRef<jobject> &obj) : jni_env_(env),
                                                                                    java_counter_part_(obj) {
}

void MainActivityJni::DoUpdateUIText() {
  std::string text = base::StringPrintf("native string: %d", count_);
  ++count_;
  Java_MainActivity_updateTextView(jni_env_, java_counter_part_,
                                   base::android::ConvertUTF8ToJavaString(jni_env_, text));
}

void MainActivityJni::DoStartTimer() {
  timer_.Start(FROM_HERE, base::TimeDelta::FromSeconds(1), this, &MainActivityJni::DoUpdateUIText);
}

void MainActivityJni::StartTimerFromNonUIThread() {
  // post a task that starts the timer to the ui thread
  base::PostTaskWithTraits(FROM_HERE, {WellKnownThreadID::UI},
                           base::BindOnce(&MainActivityJni::DoStartTimer, base::Unretained(this)));
}

void MainActivityJni::StartUpdateTextViewRepeatedly(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj) {
  // don't blame, it's just to demonstrate how to post a ui task,
  // first post a task to some pooled thread, then from that thread post the real task to ui thread
  base::PostTask(FROM_HERE, base::BindOnce(&MainActivityJni::StartTimerFromNonUIThread, base::Unretained(this)));
}

void MainActivityJni::StopUpdateTextView(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj) {
  timer_.AbandonAndStop();
}

void MainActivityJni::Destroy(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj) {
  delete this;
}

} // namespace app