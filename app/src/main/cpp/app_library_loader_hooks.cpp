//
// Created by dagger on 19-9-6.
//

#include "app_library_loader_hooks.h"

#include "base/logging.h"
#include "base/task/thread_pool/thread_pool.h"
#include "base/trace_event/trace_event.h"

namespace app {

bool AppLibraryLoaded(JNIEnv* env, jclass clazz,
                      base::android::LibraryProcessType library_process_type) {
    base::trace_event::TraceLog::GetInstance()->set_process_name("hello-chromium-libs");

    // Can only use event tracing after setting up the command line.
    TRACE_EVENT0("jni", "JNI_OnLoad continuation");


    logging::LoggingSettings settings;
    settings.logging_dest =
            logging::LOG_TO_SYSTEM_DEBUG_LOG | logging::LOG_TO_STDERR;
    logging::InitLogging(settings);
    // To view log output with IDs and timestamps use "adb logcat -v threadtime"
    logging::SetLogItems(true,    // Process ID
                         true,    // Thread ID
                         true,    // Timestamp
                         false);   // Tick count
    VLOG(0) << "AppLibraryLoaded: log level = " << logging::GetMinLogLevel()
            << ", default verbosity = " << logging::GetVlogVerbosity();


    base::ThreadPoolInstance::CreateAndStartWithDefaultParams("hello_chromium_libs");

    return true;
}

}