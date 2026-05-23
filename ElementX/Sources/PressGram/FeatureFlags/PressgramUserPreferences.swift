//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Pressgram-specific user preferences (not yet plumbed through `AppSettings` to
/// keep the upstream file untouched).
///
/// Phase 1.5 only stores `lastSelectedHomeserver` so the welcome screen can
/// open on the most recently chosen server. Wider settings (E2EE UI gating,
/// remote feature flags) will land in Phase 2 as `@UserPreference` properties
/// inside `AppSettings`.
final class PressgramUserPreferences {
    static let shared = PressgramUserPreferences()

    private enum Key: String {
        case lastSelectedHomeserver = "pgram.lastSelectedHomeserver"
    }

    private let store: UserDefaults

    init(store: UserDefaults = .standard) {
        self.store = store
    }

    /// Persisted across app launches so re-opening the app skips the catalog
    /// when the user has already picked a server.
    var lastSelectedHomeserver: String? {
        get { store.string(forKey: Key.lastSelectedHomeserver.rawValue) }
        set { store.setValue(newValue, forKey: Key.lastSelectedHomeserver.rawValue) }
    }
}
