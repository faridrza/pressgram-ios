//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine

@MainActor
protocol PGramWelcomeScreenViewModelProtocol {
    var actionsPublisher: AnyPublisher<PGramWelcomeScreenViewModelAction, Never> { get }
    var context: PGramWelcomeScreenViewModelType.Context { get }

    /// Called by the flow coordinator after the user picks a different server in the catalog.
    /// `selectedServer` is nil when the server isn't in our local catalog (manual entry,
    /// deep-link to unlisted server, offline) — in that case the welcome screen hides
    /// the register / invite-request links until we can resolve the entry.
    func updateServer(homeserver: String, displayName: String, selectedServer: PGramServer?)
}
