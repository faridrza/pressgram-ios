//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import SwiftUI

struct PGramInviteRequestScreenCoordinatorParameters {
    let registryService: PGramRegistryServicing
    let homeserver: String
    let serverDisplayName: String
}

enum PGramInviteRequestScreenCoordinatorAction {
    case dismiss
    case finished
}

final class PGramInviteRequestScreenCoordinator: CoordinatorProtocol {
    private let viewModel: PGramInviteRequestScreenViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    private let actionsSubject: PassthroughSubject<PGramInviteRequestScreenCoordinatorAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramInviteRequestScreenCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(parameters: PGramInviteRequestScreenCoordinatorParameters) {
        viewModel = PGramInviteRequestScreenViewModel(registryService: parameters.registryService,
                                                      homeserver: parameters.homeserver,
                                                      serverDisplayName: parameters.serverDisplayName)
    }

    func start() {
        viewModel.actionsPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .dismiss:
                actionsSubject.send(.dismiss)
            case .finished:
                actionsSubject.send(.finished)
            }
        }
        .store(in: &cancellables)
    }

    func toPresentable() -> AnyView {
        AnyView(PGramInviteRequestScreen(context: viewModel.context))
    }
}
