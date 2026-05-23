//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine

@MainActor
protocol PGramCatalogScreenViewModelProtocol {
    var actionsPublisher: AnyPublisher<PGramCatalogScreenViewModelAction, Never> { get }
    var context: PGramCatalogScreenViewModelType.Context { get }
}
