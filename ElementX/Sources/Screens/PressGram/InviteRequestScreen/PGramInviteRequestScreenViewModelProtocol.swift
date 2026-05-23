//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine

@MainActor
protocol PGramInviteRequestScreenViewModelProtocol {
    var actionsPublisher: AnyPublisher<PGramInviteRequestScreenViewModelAction, Never> { get }
    var context: PGramInviteRequestScreenViewModelType.Context { get }
}
