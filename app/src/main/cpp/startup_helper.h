// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef ___STARTUP_HELPER_H__
#define ___STARTUP_HELPER_H__

#include "base/base_export.h"
#include "base/strings/string_piece.h"

namespace app {

// Setups fields trials and the FeatureList, and returns the unique pointer of
// the field trials.
//std::unique_ptr<base::FieldTrialList> CONTENT_EXPORT
//SetUpFieldTrialsAndFeatureList();

// Starts the ThreadPool.
void BASE_EXPORT CreateAndStartThreadPool(base::StringPiece name);

}  // namespace app

#endif  // ___STARTUP_HELPER_H__
