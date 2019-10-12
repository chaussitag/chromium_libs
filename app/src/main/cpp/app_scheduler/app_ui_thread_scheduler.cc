// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "app_scheduler/app_ui_thread_scheduler.h"

#include <utility>

#include "base/feature_list.h"
#include "base/logging.h"
#include "base/memory/ptr_util.h"
#include "base/message_loop/message_pump.h"
#include "base/process/process.h"
#include "base/run_loop.h"
#include "base/task/sequence_manager/sequence_manager.h"
#include "base/task/sequence_manager/sequence_manager_impl.h"
#include "base/task/sequence_manager/task_queue.h"
#include "base/task/sequence_manager/time_domain.h"
#include "base/threading/platform_thread.h"
#include "build/build_config.h"

namespace app {

AppUIThreadScheduler::~AppUIThreadScheduler() = default;

// static
std::unique_ptr<AppUIThreadScheduler>
AppUIThreadScheduler::CreateForTesting(
    base::sequence_manager::SequenceManager* sequence_manager,
    base::sequence_manager::TimeDomain* time_domain) {
  return base::WrapUnique(
      new AppUIThreadScheduler(sequence_manager, time_domain));
}

AppUIThreadScheduler::AppUIThreadScheduler()
    : owned_sequence_manager_(
          base::sequence_manager::CreateUnboundSequenceManager(
              base::sequence_manager::SequenceManager::Settings::Builder()
                  .SetMessagePumpType(base::MessageLoop::TYPE_UI)
                  .Build())),
      task_queues_(WellKnownThreadID::UI,
                   owned_sequence_manager_.get(),
                   owned_sequence_manager_->GetRealTimeDomain()),
      handle_(task_queues_.CreateHandle()) {
  CommonSequenceManagerSetup(owned_sequence_manager_.get());
  owned_sequence_manager_->SetDefaultTaskRunner(handle_.GetDefaultTaskRunner());

  owned_sequence_manager_->BindToMessagePump(
      base::MessagePump::Create(base::MessagePump::Type::UI));
}

AppUIThreadScheduler::AppUIThreadScheduler(
    base::sequence_manager::SequenceManager* sequence_manager,
    base::sequence_manager::TimeDomain* time_domain)
    : task_queues_(WellKnownThreadID::UI, sequence_manager, time_domain),
      handle_(task_queues_.CreateHandle()) {
  CommonSequenceManagerSetup(sequence_manager);
}

void AppUIThreadScheduler::CommonSequenceManagerSetup(
    base::sequence_manager::SequenceManager* sequence_manager) {
  sequence_manager->EnableCrashKeys("ui_scheduler_async_stack");
}

}  // namespace app
