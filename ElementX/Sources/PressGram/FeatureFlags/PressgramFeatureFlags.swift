//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Compile-time Pressgram feature flags.
///
/// During Phase 1 these are simple `let` constants. As the fork stabilises
/// they may move into `AppSettings` `@UserPreference` for remote toggling.
enum PressgramFeatureFlags {
    /// When `true`, the Pressgram welcome screen is shown in place of
    /// `AuthenticationStartScreen` at the start of the unauthenticated flow.
    ///
    /// Re-enabled. Confirmed (2026-05-23) that the vanilla path works end-to-end
    /// on the simulator, so we now keep the Pressgram Welcome UI and delegate
    /// "Войти с паролем" to the vanilla AuthenticationFlowCoordinator path
    /// (`.confirmServer(.login)` → ServerConfirmation → OIDC). That adds one
    /// extra screen but works 100%. Direct OIDC dispatch from PGramWelcome will
    /// land in Phase 1.5 after we trace the window-injection race condition.
    static let usePGramWelcomeScreen = true

    /// When `true`, the Pressgram server catalog is shown when the user taps
    /// "Сменить" on the welcome screen. When `false`, the change-server button
    /// is a no-op. Catalog screen lands in Phase 1.5.
    static let usePGramCatalogScreen = false

    /// When `true`, hides E2EE-specific UI (badges, shields, encryption toggles,
    /// cross-signing onboarding) regardless of room state. Pressgram-default for
    /// Phase 1.5 — the server-side `matrix_e2ee_filter` module already prevents
    /// encryption being enabled on `pgram.im` rooms, so the "Not encrypted"
    /// indicators just add noise. Once E2EE-capable satellites (e.g. x.pgram.im)
    /// ship, this becomes per-server (driven by `.well-known` capability).
    static let hideE2EEUIWhenServerDisabled = true

    /// When `true`, `ServerConfirmationScreen` auto-fires its `.confirm` view
    /// action the first time it captures a presentation window — the screen
    /// renders for a single layout pass before the loading overlay appears,
    /// so visually the user goes Welcome → loading → OIDC web view with no
    /// intermediate "Choose account provider" tap. Pressgram already shows
    /// the selected server on Welcome, so this screen has no information value
    /// for the user.
    static let autoContinueServerConfirmation = true
}
