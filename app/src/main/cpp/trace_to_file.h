//
// Created by dagger on 19-9-12.
//

#ifndef CHROMIUM_LIBS_GIT_TRACE_TO_FILE_H
#define CHROMIUM_LIBS_GIT_TRACE_TO_FILE_H

#include "base/android/jni_weak_ref.h"
#include "base/android/scoped_java_ref.h"
#include "base/files/file_path.h"
#include "base/macros.h"

namespace app {

class TraceToFile {
public:
    TraceToFile();

    ~TraceToFile();

    void Destroy(JNIEnv *env, const base::android::JavaParamRef <jobject> &obj);

    void StartTracing(JNIEnv *env,
                      const base::android::JavaParamRef <jobject> &obj,
                      const base::android::JavaParamRef <jstring> &trace_file_path,
                      const base::android::JavaParamRef <jstring> &trace_categories);

    void StopTracing(JNIEnv *env,
                     const base::android::JavaParamRef <jobject> &obj);

private:
    void WriteFileHeader();

    void AppendFileFooter();

    void TraceOutputCallback(const std::string &data);
private:
    base::FilePath path_;
    bool started_ = false;

    DISALLOW_COPY_AND_ASSIGN(TraceToFile);
};

} // namespace app

#endif //CHROMIUM_LIBS_GIT_TRACE_TO_FILE_H
