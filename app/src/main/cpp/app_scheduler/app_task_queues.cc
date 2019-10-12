// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "app_scheduler/app_task_queues.h"

#include <iterator>

#include "base/bind.h"
#include "base/callback_helpers.h"
#include "base/feature_list.h"
#include "base/memory/scoped_refptr.h"
#include "base/sequenced_task_runner.h"
#include "base/task/sequence_manager/sequence_manager.h"
#include "base/threading/sequenced_task_runner_handle.h"

namespace app {
namespace {

using QueuePriority = ::base::sequence_manager::TaskQueue::QueuePriority;
using InsertFencePosition =
    ::base::sequence_manager::TaskQueue::InsertFencePosition;

const char* GetControlTaskQueueName(WellKnownThreadID thread_id) {
  switch (thread_id) {
    case WellKnownThreadID::UI:
      return "ui_control_tq";
    //case WellKnownThreadID::IO:
    //  return "io_control_tq";
    case WellKnownThreadID::ID_COUNT:
      break;
  }
  NOTREACHED();
  return "";
}

const char* GetRunAllPendingTaskQueueName(WellKnownThreadID thread_id) {
  switch (thread_id) {
    case WellKnownThreadID::UI:
      return "ui_run_all_pending_tq";
    //case WellKnownThreadID::IO:
    //  return "io_run_all_pending_tq";
    case WellKnownThreadID::ID_COUNT:
      break;
  }
  NOTREACHED();
  return "";
}

const char* GetUITaskQueueName(AppTaskQueues::QueueType queue_type) {
  switch (queue_type) {
    case AppTaskQueues::QueueType::kBestEffort:
      return "ui_best_effort_tq";
    //case AppTaskQueues::QueueType::kBootstrap:
    //  return "ui_bootstrap_tq";
    //case AppTaskQueues::QueueType::kNavigationAndPreconnection:
    //  return "ui_navigation_and_preconnection_tq";
    case AppTaskQueues::QueueType::kDefault:
      return "ui_default_tq";
    case AppTaskQueues::QueueType::kUserBlocking:
      return "ui_user_blocking_tq";
    case AppTaskQueues::QueueType::kMaxValue:
      break;
  }

  NOTREACHED();
  return "";
}

//const char* GetIOTaskQueueName(AppTaskQueues::QueueType queue_type) {
//  switch (queue_type) {
//    case AppTaskQueues::QueueType::kBestEffort:
//      return "io_best_effort_tq";
//    //case AppTaskQueues::QueueType::kBootstrap:
//    //  return "io_bootstrap_tq";
//    //case AppTaskQueues::QueueType::kNavigationAndPreconnection:
//    //  return "io_navigation_and_preconnection_tq";
//    case AppTaskQueues::QueueType::kDefault:
//      return "io_default_tq";
//    case AppTaskQueues::QueueType::kUserBlocking:
//      return "io_user_blocking_tq";
//  }
//}

const char* GetTaskQueueName(WellKnownThreadID thread_id,
                             AppTaskQueues::QueueType queue_type) {
  switch (thread_id) {
    case WellKnownThreadID::UI:
      return GetUITaskQueueName(queue_type);
    //case WellKnownThreadID::IO:
    //  return GetIOTaskQueueName(queue_type);
    case WellKnownThreadID::ID_COUNT:
      break;
  }
  NOTREACHED();
  return "";
}

const char* GetDefaultQueueName(WellKnownThreadID thread_id) {
  switch (thread_id) {
    case WellKnownThreadID::UI:
      return "ui_thread_tq";
    //case WellKnownThreadID::IO:
    //  return "io_thread_tq";
    case WellKnownThreadID::ID_COUNT:
      break;
  }
  NOTREACHED();
  return "";
}

}  // namespace

AppTaskQueues::Handle::Handle(Handle&&) noexcept = default;
AppTaskQueues::Handle::Handle(const Handle&) = default;
AppTaskQueues::Handle::~Handle() = default;
AppTaskQueues::Handle& AppTaskQueues::Handle::operator=(Handle&&) noexcept =
    default;
AppTaskQueues::Handle& AppTaskQueues::Handle::operator=(const Handle&) =
    default;

AppTaskQueues::Handle::Handle(AppTaskQueues* outer)
    : outer_(outer),
      control_task_runner_(outer_->control_queue_->task_runner()),
      default_task_runner_(outer_->default_task_queue_->task_runner()),
      app_task_runners_(outer_->CreateAppTaskRunners()) {}

void AppTaskQueues::Handle::EnableAllQueues() {
  control_task_runner_->PostTask(
      FROM_HERE, base::BindOnce(&AppTaskQueues::EnableAllQueues,
                                base::Unretained(outer_)));
}

void AppTaskQueues::Handle::EnableAllExceptBestEffortQueues() {
  control_task_runner_->PostTask(
      FROM_HERE,
      base::BindOnce(&AppTaskQueues::EnableAllExceptBestEffortQueues,
                     base::Unretained(outer_)));
}

//void AppTaskQueues::Handle::ScheduleRunAllPendingTasksForTesting(

//void AppTaskQueues::Handle::PostFeatureListInitializationSetup() {
//  control_task_runner_->PostTask(
//      FROM_HERE,
//      base::BindOnce(&AppTaskQueues::PostFeatureListInitializationSetup,
//                     base::Unretained(outer_)));
//}
//    base::OnceClosure on_pending_task_ran) {
//  control_task_runner_->PostTask(
//      FROM_HERE,
//      base::BindOnce(
//          &AppTaskQueues::StartRunAllPendingTasksForTesting,
//          base::Unretained(outer_),
//          base::ScopedClosureRunner(std::move(on_pending_task_ran))));
//}

AppTaskQueues::AppTaskQueues(
    WellKnownThreadID thread_id,
    base::sequence_manager::SequenceManager* sequence_manager,
    base::sequence_manager::TimeDomain* time_domain) {
  for (size_t i = 0; i < app_queues_and_voters_.size(); ++i) {
    app_queues_and_voters_[i].first = sequence_manager->CreateTaskQueue(
        base::sequence_manager::TaskQueue::Spec(
            GetTaskQueueName(thread_id, static_cast<QueueType>(i)))
            .SetTimeDomain(time_domain));
    app_queues_and_voters_[i].second =
        app_queues_and_voters_[i].first->CreateQueueEnabledVoter();
    app_queues_and_voters_[i].second->SetVoteToEnable(false);
  }

  // Default task queue
  default_task_queue_ = sequence_manager->CreateTaskQueue(
      base::sequence_manager::TaskQueue::Spec(GetDefaultQueueName(thread_id))
          .SetTimeDomain(time_domain));

  // Best effort queue
  GetAppTaskQueue(QueueType::kBestEffort)
      ->SetQueuePriority(QueuePriority::kBestEffortPriority);

  // Control queue
  control_queue_ =
      sequence_manager->CreateTaskQueue(base::sequence_manager::TaskQueue::Spec(
                                            GetControlTaskQueueName(thread_id))
                                            .SetTimeDomain(time_domain));
  control_queue_->SetQueuePriority(QueuePriority::kControlPriority);

  // Run all pending queue
  run_all_pending_tasks_queue_ = sequence_manager->CreateTaskQueue(
      base::sequence_manager::TaskQueue::Spec(
          GetRunAllPendingTaskQueueName(thread_id))
          .SetTimeDomain(time_domain));
  run_all_pending_tasks_queue_->SetQueuePriority(
      QueuePriority::kBestEffortPriority);
}

AppTaskQueues::~AppTaskQueues() {
  for (auto& queue : app_queues_and_voters_) {
    queue.first->ShutdownTaskQueue();
  }
  control_queue_->ShutdownTaskQueue();
  default_task_queue_->ShutdownTaskQueue();
  run_all_pending_tasks_queue_->ShutdownTaskQueue();
}

std::array<scoped_refptr<base::SingleThreadTaskRunner>,
           AppTaskQueues::kNumQueueTypes>
AppTaskQueues::CreateAppTaskRunners() const {
  std::array<scoped_refptr<base::SingleThreadTaskRunner>, kNumQueueTypes>
      task_runners;
  for (size_t i = 0; i < app_queues_and_voters_.size(); ++i) {
    task_runners[i] = app_queues_and_voters_[i].first->task_runner();
  }
  return task_runners;
}

//void AppTaskQueues::PostFeatureListInitializationSetup() {
//  if (base::FeatureList::IsEnabled(features::kPrioritizeBootstrapTasks)) {
//    GetAppTaskQueue(QueueType::kBootstrap)
//        ->SetQueuePriority(QueuePriority::kHighestPriority);
//
//     Navigation and preconnection tasks are also important during startup so
//     prioritize them too.
//    GetAppTaskQueue(QueueType::kNavigationAndPreconnection)
//        ->SetQueuePriority(QueuePriority::kHighPriority);
//  }
//}

void AppTaskQueues::EnableAllQueues() {
  for (size_t i = 0; i < app_queues_and_voters_.size(); ++i) {
    app_queues_and_voters_[i].second->SetVoteToEnable(true);
  }
}

void AppTaskQueues::EnableAllExceptBestEffortQueues() {
  for (size_t i = 0; i < app_queues_and_voters_.size(); ++i) {
    if (i != static_cast<size_t>(QueueType::kBestEffort))
      app_queues_and_voters_[i].second->SetVoteToEnable(true);
  }
}

// To run all pending tasks we do the following. We insert a fence in all queues
// and post a task to the |run_all_pending_queue_| which has the lowest priority
// possible. That makes sure that all tasks up to the fences will have run
// before this posted task runs. Note that among tasks with the same priority
// ties are broken by using the enqueue order, so all prior best effort tasks
// will have run before this one does. This task will then remove all the fences
// and call the user provided callback to signal that all pending tasks have
// run. This method is "reentrant" as in we can call it multiple times as the
// fences will just be moved back, but we need to make sure that only the last
// call removes the fences, for that we keep track of "nesting" with
// |run_all_pending_nesting_level_|
//void AppTaskQueues::StartRunAllPendingTasksForTesting(
//    base::ScopedClosureRunner on_pending_task_ran) {
//  ++run_all_pending_nesting_level_;
//  for (const auto& queue : app_queues_and_voters_) {
//    queue.first->InsertFence(InsertFencePosition::kNow);
//  }
//  default_task_queue_->InsertFence(InsertFencePosition::kNow);
//  run_all_pending_tasks_queue_->task_runner()->PostTask(
//      FROM_HERE,
//      base::BindOnce(&AppTaskQueues::EndRunAllPendingTasksForTesting,
//                     base::Unretained(this), std::move(on_pending_task_ran)));
//}

//void AppTaskQueues::EndRunAllPendingTasksForTesting(
//    base::ScopedClosureRunner on_pending_task_ran) {
//  --run_all_pending_nesting_level_;
//  if (run_all_pending_nesting_level_ == 0) {
//    for (const auto& queue : app_queues_and_voters_) {
//      queue.first->RemoveFence();
//    }
//    default_task_queue_->RemoveFence();
//  }
//}

}  // namespace app