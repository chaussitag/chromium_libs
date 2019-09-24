//
// Created by dagger on 19-9-12.
//

#include "trace_to_file.h"

#include "TraceToFile_jni.h"

#include "base/android/jni_string.h"
#include "base/bind.h"
#include "base/files/file_util.h"
#include "base/memory/ref_counted_memory.h"
#include "base/message_loop/message_loop.h"
#include "base/run_loop.h"
#include "base/threading/thread_task_runner_handle.h"
#include "base/trace_event/trace_buffer.h"
#include "base/trace_event/trace_log.h"

#include <string>

using namespace base;

namespace app {

static jlong
JNI_TraceToFile_Init(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj) {
    return reinterpret_cast<intptr_t>(new TraceToFile());
}

TraceToFile::TraceToFile() = default;

TraceToFile::~TraceToFile() = default;

void TraceToFile::Destroy(JNIEnv *env, const base::android::JavaParamRef<jobject> &obj) {
    delete this;
}

void TraceToFile::StartTracing(JNIEnv *env,
                               const base::android::JavaParamRef<jobject> &obj,
                               const base::android::JavaParamRef<jstring> &trace_file_path,
                               const base::android::JavaParamRef<jstring> &trace_categories) {
    DCHECK(!started_);

    std::string path =
            base::android::ConvertJavaStringToUTF8(env, trace_file_path);
    std::string categories =
            base::android::ConvertJavaStringToUTF8(env, trace_categories);

    started_ = true;
    path_ = base::FilePath(path);

    WriteFileHeader();

    trace_event::TraceLog::GetInstance()->SetEnabled(
            trace_event::TraceConfig(categories, trace_event::RECORD_UNTIL_FULL),
            trace_event::TraceLog::RECORDING_MODE);
}

void TraceToFile::WriteFileHeader() {
    const char str[] = "{\"traceEvents\": [";
    WriteFile(path_, str, static_cast<int>(strlen(str)));
}

void TraceToFile::AppendFileFooter() {
    const char str[] = "]}";
    AppendToFile(path_, str, static_cast<int>(strlen(str)));
}

void TraceToFile::TraceOutputCallback(const std::string &data) {
    bool ret = AppendToFile(path_, data.c_str(), static_cast<int>(data.size()));
    DCHECK(ret);
}

static void OnTraceDataCollected(
        OnceClosure quit_closure,
        trace_event::TraceResultBuffer *buffer,
        const scoped_refptr<RefCountedString> &json_events_str,
        bool has_more_events) {
    buffer->AddFragment(json_events_str->data());
    if (!has_more_events)
        std::move(quit_closure).Run();
}

void TraceToFile::StopTracing(JNIEnv *env,
                              const base::android::JavaParamRef<jobject> &obj) {
    if (!started_)
        return;
    started_ = false;

    trace_event::TraceLog::GetInstance()->SetDisabled();

    trace_event::TraceResultBuffer buffer;
    buffer.SetOutputCallback(
            BindRepeating(&TraceToFile::TraceOutputCallback, Unretained(this)));

    // In tests we might not have a MessageLoop, create one if needed.
    std::unique_ptr<MessageLoop> message_loop;
    if (!ThreadTaskRunnerHandle::IsSet())
        message_loop = std::make_unique<MessageLoop>();

    RunLoop run_loop;
    trace_event::TraceLog::GetInstance()->Flush(BindRepeating(
            &OnTraceDataCollected, run_loop.QuitClosure(), Unretained(&buffer)));
    run_loop.Run();

    AppendFileFooter();
}

}