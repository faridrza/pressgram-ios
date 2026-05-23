//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import SwiftUI

/// Pressgram invite-request form — Figma `67:221` (form) + `67:249` (success popup).
struct PGramInviteRequestScreen: View {
    @Bindable var context: PGramInviteRequestScreenViewModel.Context

    var body: some View {
        ZStack {
            PressgramColors.welcomeBackground
                .ignoresSafeArea()

            formContent
                .disabled(context.viewState.didSubmit)

            if context.viewState.didSubmit {
                successOverlay
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: context.viewState.didSubmit)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .alert(item: $context.alertInfo)
    }

    // MARK: - Form

    private var formContent: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 24)
                .padding(.top, 8)

            serverWidget
                .padding(.horizontal, 24)
                .padding(.top, 24)

            emailField
                .padding(.horizontal, 24)
                .padding(.top, 32)

            messageField
                .padding(.horizontal, 24)
                .padding(.top, 24)

            Spacer()

            submitButton
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            Button { context.send(viewAction: .dismiss) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 32)
            }
            .buttonStyle(.plain)

            Text(PGramStrings.inviteRequestTitle)
                .font(.system(size: 22, weight: .bold))
                .tracking(0.88)
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()
        }
    }

    private var serverWidget: some View {
        HStack(spacing: 10) {
            Image(asset: Asset.PressGram.pressgramLogo)
                .resizable()
                .renderingMode(.original)
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            Text(context.viewState.serverDisplayName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(PGramStrings.inviteRequestEmailLabel)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))

            TextField("", text: $context.email, prompt: Text(PGramStrings.inviteRequestEmailPlaceholder)
                .foregroundColor(.white.opacity(0.35)))
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Color(red: 0.114, green: 0.114, blue: 0.114), in: .rect(cornerRadius: 12))

            if let error = context.viewState.emailError {
                Text(error)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.red.opacity(0.85))
            }
        }
    }

    private var messageField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(PGramStrings.inviteRequestMessageLabel)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
                .lineLimit(2)

            TextEditor(text: $context.message)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 180)
                .background(Color(red: 0.114, green: 0.114, blue: 0.114), in: .rect(cornerRadius: 12))

            HStack {
                if let error = context.viewState.messageError {
                    Text(error)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.red.opacity(0.85))
                }
                Spacer()
                Text(context.viewState.messageLengthLabel)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    private var submitButton: some View {
        Button { context.send(viewAction: .submit) } label: {
            ZStack {
                Text(PGramStrings.inviteRequestSubmit)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .opacity(context.viewState.isSubmitting ? 0 : 1)

                if context.viewState.isSubmitting {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(PressgramColors.brandPrimary.opacity(context.viewState.canSubmit ? 1.0 : 0.35),
                        in: .capsule)
        }
        .buttonStyle(.plain)
        .disabled(!context.viewState.canSubmit)
    }

    // MARK: - Success overlay

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .onTapGesture { /* swallow taps */ }

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 64, height: 64)
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.green)
                }

                VStack(spacing: 12) {
                    Text(PGramStrings.inviteRequestSuccessTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(PGramStrings.inviteRequestSuccessMessage(email: context.viewState.bindings.email))
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }

                Text(PGramStrings.inviteRequestSuccessHint)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Button { context.send(viewAction: .acknowledgeSuccess) } label: {
                    Text(PGramStrings.inviteRequestSuccessButton)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(PressgramColors.brandPrimary, in: .capsule)
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .background(Color(red: 0.114, green: 0.114, blue: 0.114), in: .rect(cornerRadius: 20))
            .padding(.horizontal, 32)
        }
    }
}

// MARK: - Previews

struct PGramInviteRequestScreen_Previews: PreviewProvider, TestablePreview {
    static let formViewModel = PGramInviteRequestScreenViewModel(registryService: PGramRegistryService(),
                                                                 homeserver: "newsroom.pgram.im",
                                                                 serverDisplayName: "Редакция Pressgram")

    static var previews: some View {
        PGramInviteRequestScreen(context: formViewModel.context)
            .previewDisplayName("Form")
    }
}
