//
// Created by dagger on 19-10-9.
//

#ifndef __APP_TASK_TRAITS_H__
#define __APP_TASK_TRAITS_H__

#include "base/task/task_traits.h"
#include "base/task/task_traits_extension.h"
#include "base/base_export.h"

namespace app {

// Tasks with this trait will not be executed inside a nested RunLoop.
//
// Note: This should rarely be required. Drivers of nested loops should instead
// make sure to be reentrant when allowing nested application tasks (also rare).
//
// TODO(https://crbug.com/876272): Investigate removing this trait -- and any
// logic for deferred tasks in MessageLoop.
struct NonNestable {
};

// Semantic annotations which tell the scheduler what type of task it's dealing
// with. This will be used by the scheduler for dynamic prioritization and for
// attribution in traces, etc...
// GENERATED_JAVA_ENUM_PACKAGE: org.chromium.content_public.browser
enum class AppTaskType {
  // A catch all tasks that don't fit the types below.
  kDefault,

  // Critical startup tasks.
  //kBootstrap,

  // Navigation related tasks.
  //kNavigation,

  // A subset of network tasks related to preconnection.
  //kPreconnect,

  // Used to validate values in Java
  kAppTaskType_Last
};

enum WellKnownThreadID {
  // The main thread in the browser.
  UI,

  // This is the thread that processes non-blocking IO, i.e. IPC and network.
  // Blocking I/O should happen in ThreadPool.
  //IO,

  // NOTE: do not add new threads here. Instead you should just use
  // base::Create*TaskRunnerWithTraits to run tasks on the ThreadPool.

  // This identifier does not represent a thread.  Instead it counts the
  // number of well-known threads.  Insert new well-known threads before this
  // identifier.
  ID_COUNT
};

// TaskTraits for running tasks on the browser threads.
//
// These traits enable the use of the //base/task/post_task.h APIs to post tasks
// to a BrowserThread.
//
// To post a task to the UI thread (analogous for IO thread):
//     base::PostTaskWithTraits(FROM_HERE, {BrowserThread::UI}, task);
//
// To obtain a TaskRunner for the UI thread (analogous for the IO thread):
//     base::CreateSingleThreadTaskRunnerWithTraits({BrowserThread::UI});
//
// Tasks posted to the same BrowserThread with the same traits will be executed
// in the order they were posted, regardless of the TaskRunners they were
// posted via.
//
// See //base/task/post_task.h for more detailed documentation.
//
// Posting to a BrowserThread must only be done after it was initialized (ref.
// BrowserMainLoop::CreateThreads() phase).
class BASE_EXPORT AppTaskTraitsExtension{
public:
  static constexpr uint8_t kExtensionId =
      base::TaskTraitsExtensionStorage::kFirstEmbedderExtensionId;

  struct ValidTrait : public base::TaskTraits::ValidTrait {
    using base::TaskTraits::ValidTrait::ValidTrait;

    ValidTrait(WellKnownThreadID);
    ValidTrait(AppTaskType);
    ValidTrait(NonNestable);
  };

  template <
      class... ArgTypes,
      class CheckArgumentsAreValid = std::enable_if_t<
          base::trait_helpers::AreValidTraits<ValidTrait, ArgTypes...>::value>>
  constexpr AppTaskTraitsExtension(ArgTypes... args)
      : browser_thread_(
            base::trait_helpers::GetEnum<WellKnownThreadID>(args...)),
        task_type_(
            base::trait_helpers::GetEnum<AppTaskType,
                                         AppTaskType::kDefault>(args...)),
        nestable_(!base::trait_helpers::HasTrait<NonNestable>(args...)) {}

  // Keep in sync with UiThreadTaskTraits.java
  constexpr base::TaskTraitsExtensionStorage Serialize() const {
    static_assert(12 == sizeof(AppTaskTraitsExtension),
                  "Update Serialize() and Parse() when changing "
                  "AppTaskTraitsExtension");
    return {
        kExtensionId,
        {static_cast<uint8_t>(browser_thread_),
         static_cast<uint8_t>(task_type_), static_cast<uint8_t>(nestable_)}};
  }

  static const AppTaskTraitsExtension Parse(
      const base::TaskTraitsExtensionStorage& extension) {
    return AppTaskTraitsExtension(
        static_cast<WellKnownThreadID>(extension.data[0]),
        static_cast<AppTaskType>(extension.data[1]),
        static_cast<bool>(extension.data[2]));
  }

  constexpr WellKnownThreadID browser_thread() const { return browser_thread_; }
  constexpr AppTaskType task_type() const { return task_type_; }

  // Returns true if tasks with these traits may run in a nested RunLoop.
  constexpr bool nestable() const { return nestable_; }

private:
  AppTaskTraitsExtension(WellKnownThreadID browser_thread,
                         AppTaskType task_type,
                         bool nestable)
      : browser_thread_(browser_thread),
        task_type_(task_type),
        nestable_(nestable) {}

  WellKnownThreadID browser_thread_;
  AppTaskType task_type_;
  bool nestable_;
};

template<class... ArgTypes,
         class = std::enable_if_t <base::trait_helpers::AreValidTraits<
             AppTaskTraitsExtension::ValidTrait,
             ArgTypes...>::value>>
constexpr base::TaskTraitsExtensionStorage MakeTaskTraitsExtension(
    ArgTypes &&... args) {
  return AppTaskTraitsExtension(std::forward<ArgTypes>(args)...)
      .Serialize();
}

}  // namespace app

#endif // __APP_TASK_TRAITS_H__
