//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

enum PGramInviteRequestScreenViewModelAction {
    case dismiss
    case finished // user tapped "На главную" after successful submission
}

struct PGramInviteRequestScreenViewState: BindableState {
    let homeserver: String
    let serverDisplayName: String
    var isSubmitting = false
    var didSubmit = false
    var emailError: String?
    var messageError: String?

    var bindings = PGramInviteRequestScreenViewStateBindings()

    static let messageMinLength = 20
    static let messageMaxLength = 1000

    var canSubmit: Bool {
        !isSubmitting
            && !bindings.email.trimmingCharacters(in: .whitespaces).isEmpty
            && (Self.messageMinLength...Self.messageMaxLength).contains(bindings.message.count)
    }

    var messageLengthLabel: String {
        "\(bindings.message.count) / \(Self.messageMaxLength)"
    }
}

struct PGramInviteRequestScreenViewStateBindings {
    var email = ""
    var message = ""
    var alertInfo: AlertInfo<PGramInviteRequestScreenAlertType>?
}

enum PGramInviteRequestScreenAlertType: Hashable {
    case networkError
    case rateLimited
    case notAccepting
}

enum PGramInviteRequestScreenViewAction {
    case submit
    case dismiss
    case acknowledgeSuccess
}
