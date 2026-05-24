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
    let selectedServer: PGramServer?
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
                                                showQRCodeLoginButton: parameters.showQRCodeLoginButton,
                                                selectedServer: parameters.selectedServer)
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

    func updateCurrentServer(homeserver: String, displayName: String, selectedServer: PGramServer?) {
        viewModel.updateServer(homeserver: homeserver, displayName: displayName, selectedServer: selectedServer)
    }

    /// The window captured by `SwiftUIIntrospect` once the welcome view has been
    /// laid out. `nil` until the first layout pass — callers should fall back to
    /// the vanilla server-confirmation path when this isn't ready yet.
    var presentationWindow: UIWindow? {
        viewModel.context.viewState.window
    }

    func toPresentable() -> AnyView {
        AnyView(PGramWelcomeScreen(context: viewModel.context))
    }
}
