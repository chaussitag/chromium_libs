//
// Created by dagger on 19-9-6.
//

#ifndef CHROMIUM_LIBS_GIT_APP_LIBRARY_LOADER_HOOKS_H
#define CHROMIUM_LIBS_GIT_APP_LIBRARY_LOADER_HOOKS_H

#include <jni.h>
#include "base/android/library_loader/library_loader_hooks.h"

namespace app {

bool AppLibraryLoaded(JNIEnv *env, jclass clazz,
                      base::android::LibraryProcessType library_process_type);

}

#endif //CHROMIUM_LIBS_GIT_APP_LIBRARY_LOADER_HOOKS_H
