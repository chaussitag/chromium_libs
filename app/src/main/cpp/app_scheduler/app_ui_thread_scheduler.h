// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef CONTENT_BROWSER_SCHEDULER_BROWSER_UI_THREAD_SCHEDULER_H_
#define CONTENT_BROWSER_SCHEDULER_BROWSER_UI_THREAD_SCHEDULER_H_

#include <memory>

#include "base/containers/flat_map.h"
#include "base/message_loop/message_loop.h"
#include "base/task/sequence_manager/task_queue.h"
#include "base/base_export.h"

#include "app_scheduler/app_task_queues.h"

namespace base {
namespace sequence_manager {
class SequenceManager;
class TimeDomain;
}  // namespace sequence_manager
}  // namespace base

namespace app {
class AppTaskExecutor;

// The BrowserUIThreadScheduler vends TaskQueues and manipulates them to
// implement scheduling policy. This class is never deleted in production.
class BASE_EXPORT AppUIThreadScheduler {
 public:
  using Handle = AppTaskQueues::Handle;

 AppUIThreadScheduler();
  ~AppUIThreadScheduler();

  // Setting the DefaultTaskRunner is up to the caller.
  static std::unique_ptr<AppUIThreadScheduler> CreateForTesting(
      base::sequence_manager::SequenceManager* sequence_manager,
      base::sequence_manager::TimeDomain* time_domain);

  using QueueType = AppTaskQueues::QueueType;

  Handle GetHandle() const { return handle_; }

 private:
  friend class AppTaskExecutor;

 AppUIThreadScheduler(
      base::sequence_manager::SequenceManager* sequence_manager,
      base::sequence_manager::TimeDomain* time_domain);

  void CommonSequenceManagerSetup(
      base::sequence_manager::SequenceManager* sequence_manager);

  // In production the BrowserUIThreadScheduler will own its SequenceManager,
  // but in tests it may not.
  std::unique_ptr<base::sequence_manager::SequenceManager>
      owned_sequence_manager_;

  AppTaskQueues task_queues_;
  Handle handle_;

  DISALLOW_COPY_AND_ASSIGN(AppUIThreadScheduler);
};

}  // namespace app

#endif  // CONTENT_BROWSER_SCHEDULER_BROWSER_UI_THREAD_SCHEDULER_H_
