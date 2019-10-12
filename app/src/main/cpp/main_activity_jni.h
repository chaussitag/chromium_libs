//
// Created by dagger on 19-10-12.
//

#ifndef __MAIN_ACTIVITY_JNI_H__
#define __MAIN_ACTIVITY_JNI_H__

#include "base/android/jni_weak_ref.h"
#include "base/android/scoped_java_ref.h"
#include "base/macros.h"
#include "base/timer/timer.h"

namespace app {

class MainActivityJni {
public:
  MainActivityJni(JNIEnv* env, const base::android::JavaParamRef<jobject> &obj);
  void StartUpdateTextViewRepeatedly(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj);
  void StopUpdateTextView(JNIEnv *env, const base::android::JavaParamRef <jobject> &obj);
  void Destroy(JNIEnv *env, const base::android::JavaParamRef <jobject> &obj);
private:
  void StartTimerFromNonUIThread();
  void DoStartTimer();
  void DoUpdateUIText();
private:
  base::RepeatingTimer timer_;
  base::android::ScopedJavaGlobalRef<jobject> java_counter_part_;
  JNIEnv* jni_env_;
  int count_ = 0;
}; // class MainActivityJni

} // namespace app

#endif //__MAIN_ACTIVITY_JNI_H__
