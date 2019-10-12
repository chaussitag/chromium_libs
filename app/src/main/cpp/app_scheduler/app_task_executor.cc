// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "app_scheduler/app_task_executor.h"

#include <atomic>

#include "base/bind.h"
#include "base/deferred_sequenced_task_runner.h"
#include "base/no_destructor.h"
#include "base/task/post_task.h"
#include "base/threading/thread_task_runner_handle.h"
#include "base/trace_event/trace_event.h"

#if defined(OS_ANDROID)
#include "base/android/task_scheduler/post_task_android.h"
#endif

namespace app {
namespace {

using QueueType = ::app::AppTaskQueues::QueueType;

// |g_browser_task_executor| is intentionally leaked on shutdown.
AppTaskExecutor* g_browser_task_executor = nullptr;

QueueType GetQueueType(const base::TaskTraits& traits,
                       AppTaskType task_type) {
  switch (task_type) {
//    case AppTaskType::kBootstrap:
//      // Note we currently ignore the priority for bootstrap tasks.
//      return QueueType::kBootstrap;
//
//    case AppTaskType::kNavigation:
//    case AppTaskType::kPreconnect:
//      // Note we currently ignore the priority for navigation and preconnection
//      // tasks.
//      return QueueType::kNavigationAndPreconnection;

    case AppTaskType::kDefault:
      // Defer to traits.priority() below.
      break;

    case AppTaskType::kAppTaskType_Last:
      NOTREACHED();
  }

  switch (traits.priority()) {
    case base::TaskPriority::BEST_EFFORT:
      return QueueType::kBestEffort;

    case base::TaskPriority::USER_VISIBLE:
      return QueueType::kDefault;

    case base::TaskPriority::USER_BLOCKING:
      return QueueType::kUserBlocking;
  }
}

}  // namespace

AppTaskExecutor::AppTaskExecutor(
    std::unique_ptr<AppUIThreadScheduler> app_ui_thread_scheduler)
    : app_ui_thread_scheduler_(std::move(app_ui_thread_scheduler)),
      app_ui_thread_handle_(app_ui_thread_scheduler_->GetHandle()) {}

AppTaskExecutor::~AppTaskExecutor() = default;

// static
void AppTaskExecutor::Create() {
  DCHECK(!base::ThreadTaskRunnerHandle::IsSet());
  CreateInternal(std::make_unique<AppUIThreadScheduler>());
}

// static
//void AppTaskExecutor::CreateForTesting(
//    std::unique_ptr<BrowserUIThreadScheduler> browser_ui_thread_scheduler,
//    std::unique_ptr<BrowserIOTaskEnvironment> browser_io_task_environment) {
//  CreateInternal(std::move(browser_ui_thread_scheduler),
//                 std::move(browser_io_task_environment));
//}

// static
void AppTaskExecutor::CreateInternal(
    std::unique_ptr<AppUIThreadScheduler> app_ui_thread_scheduler) {
  DCHECK(!g_browser_task_executor);
  g_browser_task_executor =
      new AppTaskExecutor(std::move(app_ui_thread_scheduler));
  base::RegisterTaskExecutor(AppTaskTraitsExtension::kExtensionId,
                             g_browser_task_executor);
  g_browser_task_executor->app_ui_thread_handle_
      .EnableAllExceptBestEffortQueues();

#if defined(OS_ANDROID)
  base::PostTaskAndroid::SignalNativeSchedulerReady();
#endif
}

// static
//void AppTaskExecutor::ResetForTesting() {
//#if defined(OS_ANDROID)
//  base::PostTaskAndroid::SignalNativeSchedulerShutdown();
//#endif
//
//  if (g_browser_task_executor) {
//    base::UnregisterTaskExecutorForTesting(
//        BrowserTaskTraitsExtension::kExtensionId);
//    delete g_browser_task_executor;
//    g_browser_task_executor = nullptr;
//  }
//}

// static
//void AppTaskExecutor::PostFeatureListSetup() {
//  DCHECK(g_browser_task_executor);
//  DCHECK(g_browser_task_executor->browser_ui_thread_scheduler_);
//  DCHECK(g_browser_task_executor->browser_io_task_environment_);
//  g_browser_task_executor->browser_ui_thread_handle_
//      .PostFeatureListInitializationSetup();
//  g_browser_task_executor->browser_io_thread_handle_
//      .PostFeatureListInitializationSetup();
//}

// static
void AppTaskExecutor::Shutdown() {
  if (!g_browser_task_executor)
    return;

  DCHECK(g_browser_task_executor->app_ui_thread_scheduler_);
  // We don't delete |g_browser_task_executor| because other threads may
  // PostTask or call BrowserTaskExecutor::GetTaskRunner while we're tearing
  // things down. We don't want to add locks so we just leak instead of dealing
  // with that. For similar reasons we don't need to call
  // PostTaskAndroid::SignalNativeSchedulerShutdown on Android. In tests however
  // we need to clean up, so BrowserTaskExecutor::ResetForTesting should be
  // called.
  g_browser_task_executor->app_ui_thread_scheduler_.reset();
  //g_browser_task_executor->browser_io_task_environment_.reset();
}

// static
//void AppTaskExecutor::RunAllPendingTasksOnThreadForTesting(
//    BrowserThread::ID identifier) {
//  DCHECK(g_browser_task_executor);
//
//  base::RunLoop run_loop(base::RunLoop::Type::kNestableTasksAllowed);
//
//  switch (identifier) {
//    case BrowserThread::UI:
//      g_browser_task_executor->browser_ui_thread_handle_
//          .ScheduleRunAllPendingTasksForTesting(run_loop.QuitClosure());
//      break;
//    case BrowserThread::IO: {
//      g_browser_task_executor->browser_io_thread_handle_
//          .ScheduleRunAllPendingTasksForTesting(run_loop.QuitClosure());
//      break;
//    }
//    case BrowserThread::ID_COUNT:
//      NOTREACHED();
//  }
//
//  run_loop.Run();
//}

bool AppTaskExecutor::PostDelayedTaskWithTraits(
    const base::Location& from_here,
    const base::TaskTraits& traits,
    base::OnceClosure task,
    base::TimeDelta delay) {
  DCHECK_EQ(AppTaskTraitsExtension::kExtensionId, traits.extension_id());
  const AppTaskTraitsExtension& extension =
      traits.GetExtension<AppTaskTraitsExtension>();
  if (extension.nestable()) {
    return GetTaskRunner(traits)->PostDelayedTask(from_here, std::move(task),
                                                  delay);
  } else {
    return GetTaskRunner(traits)->PostNonNestableDelayedTask(
        from_here, std::move(task), delay);
  }
}

scoped_refptr<base::TaskRunner> AppTaskExecutor::CreateTaskRunnerWithTraits(
    const base::TaskTraits& traits) {
  return GetTaskRunner(traits);
}

scoped_refptr<base::SequencedTaskRunner>
AppTaskExecutor::CreateSequencedTaskRunnerWithTraits(
    const base::TaskTraits& traits) {
  return GetTaskRunner(traits);
}

scoped_refptr<base::SingleThreadTaskRunner>
AppTaskExecutor::CreateSingleThreadTaskRunnerWithTraits(
    const base::TaskTraits& traits,
    base::SingleThreadTaskRunnerThreadMode thread_mode) {
  return GetTaskRunner(traits);
}

#if defined(OS_WIN)
scoped_refptr<base::SingleThreadTaskRunner>
AppTaskExecutor::CreateCOMSTATaskRunnerWithTraits(
    const base::TaskTraits& traits,
    base::SingleThreadTaskRunnerThreadMode thread_mode) {
  return GetTaskRunner(traits);
}
#endif  // defined(OS_WIN)

scoped_refptr<base::SingleThreadTaskRunner> AppTaskExecutor::GetTaskRunner(
    const base::TaskTraits& traits) const {
  auto id_and_queue = GetThreadIdAndQueueType(traits);

  switch (id_and_queue.thread_id) {
    case WellKnownThreadID::UI: {
      return app_ui_thread_handle_.GetAppTaskRunner(
          id_and_queue.queue_type);
    }
//    case WellKnownThreadID::IO:
//      return browser_io_thread_handle_.GetBrowserTaskRunner(
//          id_and_queue.queue_type);
    case WellKnownThreadID::ID_COUNT:
      NOTREACHED();
  }
  return nullptr;
}

// static
AppTaskExecutor::ThreadIdAndQueueType
AppTaskExecutor::GetThreadIdAndQueueType(const base::TaskTraits& traits) {
  DCHECK_EQ(AppTaskTraitsExtension::kExtensionId, traits.extension_id());
  AppTaskTraitsExtension extension =
      traits.GetExtension<AppTaskTraitsExtension>();

  WellKnownThreadID thread_id = extension.browser_thread();
  DCHECK_GE(thread_id, 0);

  AppTaskType task_type = extension.task_type();
  DCHECK_LT(task_type, AppTaskType::kAppTaskType_Last);

  return {thread_id, GetQueueType(traits, task_type)};
}

// static
void AppTaskExecutor::EnableAllQueues() {
  DCHECK(g_browser_task_executor);
  g_browser_task_executor->app_ui_thread_handle_.EnableAllQueues();
  //g_browser_task_executor->browser_io_thread_handle_.EnableAllQueues();
}

// static
//void AppTaskExecutor::InitializeIOThread() {
//  DCHECK(g_browser_task_executor);
//  g_browser_task_executor->browser_io_thread_handle_
//      .EnableAllExceptBestEffortQueues();
//}

//std::unique_ptr<BrowserProcessSubThread> AppTaskExecutor::CreateIOThread() {
//  DCHECK(g_browser_task_executor);
//  DCHECK(g_browser_task_executor->browser_io_task_environment_);
//  TRACE_EVENT0("startup", "BrowserTaskExecutor::CreateIOThread");
//
//  auto io_thread = std::make_unique<BrowserProcessSubThread>(BrowserThread::IO);
//
//  if (g_browser_task_executor->browser_io_task_environment_
//          ->allow_blocking_for_testing()) {
//    io_thread->AllowBlockingForTesting();
//  }
//
//  base::Thread::Options options;
//  options.message_loop_type = base::MessageLoop::TYPE_IO;
//  options.task_environment =
//      g_browser_task_executor->browser_io_task_environment_.release();
//#if defined(OS_ANDROID) || defined(OS_CHROMEOS) || defined(USE_OZONE)
//  // Up the priority of the |io_thread_| as some of its IPCs relate to
//  // display tasks.
//  options.priority = base::ThreadPriority::DISPLAY;
//#endif
//  if (!io_thread->StartWithOptions(options))
//    LOG(FATAL) << "Failed to start BrowserThread:IO";
//  return io_thread;
//}

}  // namespace content
