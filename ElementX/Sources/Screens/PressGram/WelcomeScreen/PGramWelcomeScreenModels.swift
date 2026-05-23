//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import UIKit

enum PGramWelcomeScreenViewModelAction {
    /// Dispatched when the user taps "Войти с паролем". The flow coordinator
    /// then funnels into the vanilla `.confirmServer(.login)` path, which is
    /// the only OIDC dispatch confirmed to work on the simulator today.
    case loginWithPassword
    case loginWithQR
    case register
    case requestInvite
    case changeServer
}

struct PGramWelcomeScreenViewState: BindableState {
    /// The homeserver shown in the server widget — e.g. `pgram.im`.
    var currentHomeserver: String
    /// Pretty display name — e.g. `Центральный (pgram.im)`.
    var currentServerDisplayName: String
    /// QR-code login isn't supported when running as an iOS app on macOS.
    var showQRCodeLoginButton: Bool
    /// Window captured from the view via SwiftUIIntrospect for OIDC presentation.
    var window: UIWindow?

    var bindings = PGramWelcomeScreenViewStateBindings()
}

struct PGramWelcomeScreenViewStateBindings {
    var alertInfo: AlertInfo<PGramWelcomeScreenAlertType>?
}

enum PGramWelcomeScreenAlertType: Hashable {
    case genericError
}

enum PGramWelcomeScreenViewAction {
    case loginWithPassword
    case loginWithQR
    case register
    case requestInvite
    case changeServer
    case updateWindow(UIWindow?)
}
