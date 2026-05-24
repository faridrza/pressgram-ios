//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import SwiftUI

/// Pressgram brand colour palette.
///
/// Single source of truth — change values here to update the brand everywhere.
/// Source: Figma `Brand/Brand/Primary` (file `cpSCzqpEVO2AtwWZPQdbCM/Pressgram`).
enum PressgramColors {
    /// Pressgram brand primary blue — `#2e5bff` (Figma `Brand/Brand/Primary`).
    static let brandPrimary = Color(red: 46.0 / 255.0, green: 91.0 / 255.0, blue: 1.0)

    /// `UIColor` variant for UIKit interop.
    static let brandPrimaryUI = UIColor(red: 46.0 / 255.0, green: 91.0 / 255.0, blue: 1.0, alpha: 1.0)

    /// Welcome screen background base — `#010308`.
    static let welcomeBackground = Color(red: 1.0 / 255.0, green: 3.0 / 255.0, blue: 8.0 / 255.0)

    /// Welcome screen aurora ellipses (Figma `67:404` / `67:405`). Two soft blurred
    /// blobs of different blues layered over `welcomeBackground` to produce the
    /// Pressgram brand glow. Deep royal blue sits lower-left, sky cyan upper-right.
    static let welcomeAuroraDeep = Color(red: 0x07 / 255.0, green: 0x3F / 255.0, blue: 0xE9 / 255.0)
    static let welcomeAuroraLight = Color(red: 0x38 / 255.0, green: 0xC1 / 255.0, blue: 0xFC / 255.0)
}
