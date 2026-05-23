//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import SwiftUI

struct PGramCatalogScreenCoordinatorParameters {
    let registryService: PGramRegistryServicing
    let currentHomeserver: String
    let showManualEntryLink: Bool
}

enum PGramCatalogScreenCoordinatorAction {
    case dismiss
    case serverSelected(PGramServer)
    case manualEntryRequested
}

final class PGramCatalogScreenCoordinator: CoordinatorProtocol {
    private let viewModel: PGramCatalogScreenViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    private let actionsSubject: PassthroughSubject<PGramCatalogScreenCoordinatorAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramCatalogScreenCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(parameters: PGramCatalogScreenCoordinatorParameters) {
        viewModel = PGramCatalogScreenViewModel(registryService: parameters.registryService,
                                                currentHomeserver: parameters.currentHomeserver,
                                                showManualEntryLink: parameters.showManualEntryLink)
    }

    func start() {
        viewModel.actionsPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .dismiss:
                actionsSubject.send(.dismiss)
            case .serverSelected(let server):
                actionsSubject.send(.serverSelected(server))
            case .manualEntryRequested:
                actionsSubject.send(.manualEntryRequested)
            }
        }
        .store(in: &cancellables)
    }

    func toPresentable() -> AnyView {
        AnyView(PGramCatalogScreen(context: viewModel.context))
    }
}
