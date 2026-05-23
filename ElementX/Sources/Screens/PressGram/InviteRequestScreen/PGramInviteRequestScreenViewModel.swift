//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import Foundation
import SwiftUI

typealias PGramInviteRequestScreenViewModelType = StateStoreViewModelV2<PGramInviteRequestScreenViewState, PGramInviteRequestScreenViewAction>

final class PGramInviteRequestScreenViewModel: PGramInviteRequestScreenViewModelType, PGramInviteRequestScreenViewModelProtocol {
    private let registryService: PGramRegistryServicing

    private let actionsSubject: PassthroughSubject<PGramInviteRequestScreenViewModelAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramInviteRequestScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(registryService: PGramRegistryServicing,
         homeserver: String,
         serverDisplayName: String) {
        self.registryService = registryService
        super.init(initialViewState: PGramInviteRequestScreenViewState(homeserver: homeserver,
                                                                       serverDisplayName: serverDisplayName))
    }

    override func process(viewAction: PGramInviteRequestScreenViewAction) {
        switch viewAction {
        case .submit:
            Task { await submit() }
        case .dismiss:
            actionsSubject.send(.dismiss)
        case .acknowledgeSuccess:
            actionsSubject.send(.finished)
        }
    }

    // MARK: - Private

    private func submit() async {
        let email = state.bindings.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = state.bindings.message

        state.emailError = Self.isValidEmail(email) ? nil : PGramStrings.inviteRequestErrorEmail
        let messageOK = (PGramInviteRequestScreenViewState.messageMinLength...PGramInviteRequestScreenViewState.messageMaxLength).contains(message.count)
        state.messageError = messageOK ? nil : PGramStrings.inviteRequestErrorMessage

        guard state.emailError == nil, state.messageError == nil else { return }

        state.isSubmitting = true
        defer { state.isSubmitting = false }

        do {
            try await registryService.requestInvite(homeserver: state.homeserver, email: email, message: message)
            state.didSubmit = true
        } catch {
            state.bindings.alertInfo = AlertInfo(id: .networkError)
        }
    }

    private static func isValidEmail(_ value: String) -> Bool {
        // Lightweight RFC 5321-ish check: local@domain.tld with no internal '@'.
        guard let atIndex = value.firstIndex(of: "@") else { return false }
        let local = value[value.startIndex..<atIndex]
        let domain = value[value.index(after: atIndex)..<value.endIndex]
        guard !local.isEmpty,
              !domain.isEmpty,
              !domain.contains("@"),
              domain.contains("."),
              let lastDot = domain.lastIndex(of: "."),
              domain.distance(from: lastDot, to: domain.endIndex) >= 3
        else {
            return false
        }
        return true
    }
}
