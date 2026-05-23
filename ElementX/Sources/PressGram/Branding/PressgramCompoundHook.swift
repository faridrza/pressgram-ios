//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Compound
import SwiftUI
import UIKit

/// Overrides Compound semantic colour tokens with the Pressgram blue palette.
///
/// Compound uses `green-*` tokens for success/accent across the UI. Without this
/// remap the Pressgram accent leaks — half the UI ends up Element green.
/// Runtime override via `CompoundColors.override(_:with:)` keeps the change
/// out of the vendored `compound-design-tokens` SPM dependency.
///
/// Phase 1 ships with the conservative two-keypath override (the ones we
/// confirmed exist via `grep` in `compound-ios`). The remaining green→blue
/// remapping (`bgAccent*`, `textActionAccent`, `textSuccessPrimary`, …) lands
/// once a build run confirms the exact token names from
/// `compound-design-tokens` 10.1.1.
struct PressgramCompoundHook: CompoundHookProtocol {
    @MainActor func override(colors: CompoundColors, uiColors: CompoundUIColors) {
        let brand = PressgramColors.brandPrimary
        let brandUI = PressgramColors.brandPrimaryUI

        colors.override(\.iconAccentPrimary, with: brand)
        colors.override(\.iconAccentTertiary, with: brand)
        uiColors.override(\.iconAccentPrimary, with: brandUI)
        uiColors.override(\.iconAccentTertiary, with: brandUI)
    }
}
