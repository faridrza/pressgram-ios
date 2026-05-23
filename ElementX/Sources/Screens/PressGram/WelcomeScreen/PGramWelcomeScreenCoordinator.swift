//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import SwiftUI

struct PGramWelcomeScreenCoordinatorParameters {
    let currentHomeserver: String
    let currentServerDisplayName: String
    let showQRCodeLoginButton: Bool
}

enum PGramWelcomeScreenCoordinatorAction {
    case loginWithPassword(homeserver: String)
    case loginWithQR
    case register(homeserver: String)
    case requestInvite(homeserver: String)
    case changeServer
}

final class PGramWelcomeScreenCoordinator: CoordinatorProtocol {
    private let parameters: PGramWelcomeScreenCoordinatorParameters
    private let viewModel: PGramWelcomeScreenViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    private let actionsSubject: PassthroughSubject<PGramWelcomeScreenCoordinatorAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramWelcomeScreenCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(parameters: PGramWelcomeScreenCoordinatorParameters) {
        self.parameters = parameters
        viewModel = PGramWelcomeScreenViewModel(currentHomeserver: parameters.currentHomeserver,
                                                currentServerDisplayName: parameters.currentServerDisplayName,
                                                showQRCodeLoginButton: parameters.showQRCodeLoginButton)
    }

    func start() {
        viewModel.actionsPublisher.sink { [weak self] action in
            guard let self else { return }
            let homeserver = parameters.currentHomeserver

            switch action {
            case .loginWithPassword:
                actionsSubject.send(.loginWithPassword(homeserver: homeserver))
            case .loginWithQR:
                actionsSubject.send(.loginWithQR)
            case .register:
                actionsSubject.send(.register(homeserver: homeserver))
            case .requestInvite:
                actionsSubject.send(.requestInvite(homeserver: homeserver))
            case .changeServer:
                actionsSubject.send(.changeServer)
            }
        }
        .store(in: &cancellables)
    }

    func toPresentable() -> AnyView {
        AnyView(PGramWelcomeScreen(context: viewModel.context))
    }
}
