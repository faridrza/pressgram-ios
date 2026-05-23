//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import SwiftUI
import SwiftUIIntrospect

/// Pressgram Welcome screen — Figma `13:410` (and `13:453`, `13:539` variants).
///
/// Layout:
/// - Background: dark base (`#010308`) + two soft blue ellipse decorations.
/// - Logo + "Pressgram" wordmark + tagline.
/// - Server widget (`Сервер: <name>` + `Сменить >`).
/// - Primary button (`Войти с паролем`) and secondary button (`Вход по QR-коду`).
/// - Text links at the bottom (`Регистрация`, `Запросить приглашение`).
///
/// Phase 1 uses a placeholder logo and the system serif font. The real logo SVG and
/// the Fraunces wordmark ship as separate tasks (#13 and #14).
struct PGramWelcomeScreen: View {
    @Bindable var context: PGramWelcomeScreenViewModel.Context

    var body: some View {
        ZStack {
            PressgramColors.welcomeBackground
                .ignoresSafeArea()

            backgroundDecoration
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                logoAndTitle
                Spacer()
                serverWidget
                    .padding(.horizontal, 24)
                    .padding(.bottom, 51)
                primaryButtons
                    .padding(.horizontal, 24)
                Spacer().frame(height: 32)
                textLinks
                Spacer().frame(height: 60)
            }
        }
        .preferredColorScheme(.dark)
        .alert(item: $context.alertInfo)
        .introspect(.window, on: .supportedVersions) { window in
            context.send(viewAction: .updateWindow(window))
        }
    }

    // MARK: - Background

    private var backgroundDecoration: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(PressgramColors.brandPrimary.opacity(0.35))
                    .frame(width: 368, height: 368)
                    .blur(radius: 120)
                    .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.35)
                Circle()
                    .fill(PressgramColors.brandPrimary.opacity(0.35))
                    .frame(width: 368, height: 368)
                    .blur(radius: 120)
                    .position(x: geometry.size.width * 0.85, y: geometry.size.height * 0.22)
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Logo + title

    private var logoAndTitle: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(PressgramColors.brandPrimary)
                .frame(width: 96, height: 96)
                .overlay {
                    Text("P")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .shadow(color: PressgramColors.brandPrimary.opacity(0.5), radius: 30, y: 8)

            Text(PGramStrings.appName)
                .font(.system(size: 28, weight: .semibold, design: .serif))
                .tracking(1.12)
                .foregroundStyle(.white)

            Text(PGramStrings.welcomeTagline)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.horizontal, 56)
                .padding(.top, -8)
        }
    }

    // MARK: - Server widget

    private var serverWidget: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(PressgramColors.brandPrimary)
                .frame(width: 36, height: 36)
                .overlay {
                    Text("P")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(PGramStrings.welcomeServerLabel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
                Text(context.viewState.currentServerDisplayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }

            Spacer()

            Button { context.send(viewAction: .changeServer) } label: {
                HStack(spacing: 4) {
                    Text(PGramStrings.welcomeChangeServer)
                        .font(.system(size: 14, weight: .semibold))
                        .underline()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Primary buttons

    private var primaryButtons: some View {
        VStack(spacing: 16) {
            Button { context.send(viewAction: .loginWithPassword) } label: {
                Text(PGramStrings.welcomeLoginWithPassword)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(PressgramColors.brandPrimary, in: .capsule)
            }
            .buttonStyle(.plain)

            // Phase 1: QR login is visually disabled. Cancelling the QR sheet triggers
            // an unexpected state-machine transition in Element X (qrCodeLoginScreen →
            // signInManually → confirmServer) that crashes when the PGramWelcome owns
            // startScreen. Wire properly in Phase 1.5 with a Pressgram-flavoured QR flow.
            if context.viewState.showQRCodeLoginButton {
                Text(PGramStrings.welcomeLoginWithQR)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(PressgramColors.brandPrimary.opacity(0.35))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white.opacity(0.35), in: .capsule)
            }
        }
    }

    // MARK: - Text links

    private var textLinks: some View {
        // Phase 1: register + invite-request are disabled. They light up once the catalog
        // screen (Phase 1.5) and the invite-request flow (Phase 2) land.
        VStack(spacing: 16) {
            Text(PGramStrings.welcomeRegister)
                .font(.system(size: 16, weight: .semibold))
                .underline()
                .foregroundStyle(.white.opacity(0.35))

            Text(PGramStrings.welcomeRequestInvite)
                .font(.system(size: 16, weight: .semibold))
                .underline()
                .foregroundStyle(.white.opacity(0.35))
        }
    }
}

// MARK: - Previews

struct PGramWelcomeScreen_Previews: PreviewProvider, TestablePreview {
    static let defaultViewModel = PGramWelcomeScreenViewModel(currentHomeserver: "pgram.im",
                                                              currentServerDisplayName: "Центральный (pgram.im)",
                                                              showQRCodeLoginButton: true)

    static let customViewModel = PGramWelcomeScreenViewModel(currentHomeserver: "newsroom.pgram.im",
                                                             currentServerDisplayName: "Редакция №1 (newsroom.pgram.im)",
                                                             showQRCodeLoginButton: true)

    static var previews: some View {
        PGramWelcomeScreen(context: defaultViewModel.context)
            .previewDisplayName("Default — pgram.im")

        PGramWelcomeScreen(context: customViewModel.context)
            .previewDisplayName("Custom server")
    }
}
