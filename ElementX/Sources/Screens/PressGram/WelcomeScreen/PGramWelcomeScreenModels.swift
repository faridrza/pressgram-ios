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
    /// The catalog entry for `currentHomeserver`, if known. Drives the conditional
    /// visibility of the register / invite-request links per Figma `67:100` and
    /// `docs/pressgram/registration-flow.md`. `nil` when the server isn't in our
    /// local catalog (manual entry, deep-link to unlisted server, offline).
    var selectedServer: PGramServer?
    /// Window captured from the view via SwiftUIIntrospect for OIDC presentation.
    var window: UIWindow?

    var bindings = PGramWelcomeScreenViewStateBindings()

    // MARK: - Registration affordances

    /// Per spec: hidden when the server's registration is closed, or when we
    /// don't know enough about the server to make a safe call.
    var showRegisterLink: Bool {
        guard let mode = selectedServer?.registration.mode else { return false }
        return mode != .closed
    }

    /// `Регистрация` for open servers, `Регистрация (требуется код)` for token mode.
    var registerLabel: String {
        selectedServer?.registration.mode == .token
            ? PGramStrings.welcomeRegisterTokenRequired
            : PGramStrings.welcomeRegisterOpen
    }

    /// Only token-mode public servers accept invite requests through `dl.pgram.im/api/invite-request`.
    /// Unlisted servers can't be advertised, open servers don't need invites,
    /// closed servers aren't accepting anyone.
    var showInviteRequestLink: Bool {
        guard let server = selectedServer else { return false }
        return server.registration.mode == .token && server.visibility == .public
    }
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
