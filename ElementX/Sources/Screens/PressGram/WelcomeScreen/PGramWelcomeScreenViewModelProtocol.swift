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
    func updateServer(homeserver: String, displayName: String)
}
