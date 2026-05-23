//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import SwiftUI

/// Pressgram catalog screen — Figma `67:441` (with manual-entry link) and `67:101` (basic).
struct PGramCatalogScreen: View {
    @Bindable var context: PGramCatalogScreenViewModel.Context

    var body: some View {
        ZStack {
            PressgramColors.welcomeBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                searchBar
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                if context.viewState.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white.opacity(0.6))
                    Spacer()
                } else {
                    serverList
                }

                continueButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .alert(item: $context.alertInfo)
        .onAppear { context.send(viewAction: .onAppear) }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 16) {
            Button { context.send(viewAction: .dismiss) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 32)
            }
            .buttonStyle(.plain)

            Text(PGramStrings.catalogTitle)
                .font(.system(size: 26, weight: .bold))
                .tracking(1.04)
                .foregroundStyle(.white)

            Spacer()
        }
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack(spacing: 18) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.leading, 16)

            TextField("", text: $context.searchText, prompt: Text(PGramStrings.catalogSearchPlaceholder)
                .foregroundColor(.white.opacity(0.5)))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
        }
        .frame(height: 44)
        .background(Color(red: 0.114, green: 0.114, blue: 0.114), in: .capsule) // #1d1d1d
    }

    // MARK: - Server list

    private var serverList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(context.viewState.filteredServers) { server in
                    serverCard(for: server)
                        .padding(.horizontal, 24)
                }

                if context.viewState.showManualEntryLink {
                    Button { context.send(viewAction: .manualEntryTapped) } label: {
                        Text(PGramStrings.catalogManualEntry)
                            .font(.system(size: 16, weight: .semibold))
                            .underline()
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func serverCard(for server: PGramServer) -> some View {
        let isSelected = server.homeserver == context.viewState.selectedHomeserver

        Button { context.send(viewAction: .selectServer(server)) } label: {
            HStack(spacing: 16) {
                // Phase 1.5: Pressgram logo for every server. Phase 2 will switch to
                // server.logoURL via async image loading with a placeholder fallback.
                Image(asset: Asset.PressGram.pressgramLogo)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text(server.name)
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(0.64)
                        .foregroundStyle(Color(white: 0.95))
                        .lineLimit(1)

                    Text(server.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    modeBadge(for: server.registration.mode)
                        .padding(.top, 2)
                }

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(PressgramColors.brandPrimary)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.114, green: 0.114, blue: 0.114), in: .rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func modeBadge(for mode: PGramRegistrationMode) -> some View {
        let (title, color): (String, Color) = switch mode {
        case .open: (PGramStrings.catalogBadgeOpen, Color.green)
        case .token: (PGramStrings.catalogBadgeToken, PressgramColors.brandPrimary)
        case .closed: (PGramStrings.catalogBadgeClosed, Color.gray)
        }

        Text(title)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .overlay(Capsule().stroke(color.opacity(0.45), lineWidth: 1))
            .clipShape(Capsule())
    }

    // MARK: - Continue button

    private var continueButton: some View {
        let canContinue = context.viewState.selectedHomeserver != nil && !context.viewState.isLoading

        return Button { context.send(viewAction: .continueTapped) } label: {
            Text(PGramStrings.catalogContinue)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(PressgramColors.brandPrimary.opacity(canContinue ? 1.0 : 0.35), in: .capsule)
        }
        .buttonStyle(.plain)
        .disabled(!canContinue)
    }
}

// MARK: - Previews

struct PGramCatalogScreen_Previews: PreviewProvider, TestablePreview {
    static let viewModel = PGramCatalogScreenViewModel(registryService: PGramRegistryService(),
                                                       currentHomeserver: "pgram.im",
                                                       showManualEntryLink: true)

    static var previews: some View {
        ElementNavigationStack {
            PGramCatalogScreen(context: viewModel.context)
        }
        .previewDisplayName("Catalog")
    }
}
