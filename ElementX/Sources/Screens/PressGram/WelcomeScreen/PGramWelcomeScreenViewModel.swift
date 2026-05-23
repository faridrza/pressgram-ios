//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import SwiftUI

typealias PGramWelcomeScreenViewModelType = StateStoreViewModelV2<PGramWelcomeScreenViewState, PGramWelcomeScreenViewAction>

/// Pressgram welcome screen view model.
///
/// Phase 1: a thin dispatcher. The actual OIDC / password flow lives in
/// `AuthenticationFlowCoordinator` — the welcome only emits coarse actions
/// (login / QR / change-server / register / invite-request).
final class PGramWelcomeScreenViewModel: PGramWelcomeScreenViewModelType, PGramWelcomeScreenViewModelProtocol {
    private let actionsSubject: PassthroughSubject<PGramWelcomeScreenViewModelAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramWelcomeScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(currentHomeserver: String,
         currentServerDisplayName: String,
         showQRCodeLoginButton: Bool) {
        super.init(initialViewState: PGramWelcomeScreenViewState(currentHomeserver: currentHomeserver,
                                                                 currentServerDisplayName: currentServerDisplayName,
                                                                 showQRCodeLoginButton: showQRCodeLoginButton))
    }

    func updateServer(homeserver: String, displayName: String) {
        state.currentHomeserver = homeserver
        state.currentServerDisplayName = displayName
    }

    override func process(viewAction: PGramWelcomeScreenViewAction) {
        switch viewAction {
        case .loginWithPassword:
            actionsSubject.send(.loginWithPassword)
        case .loginWithQR:
            actionsSubject.send(.loginWithQR)
        case .register:
            actionsSubject.send(.register)
        case .requestInvite:
            actionsSubject.send(.requestInvite)
        case .changeServer:
            actionsSubject.send(.changeServer)
        case .updateWindow(let window):
            guard state.window != window else { return }
            state.window = window
        }
    }
}
