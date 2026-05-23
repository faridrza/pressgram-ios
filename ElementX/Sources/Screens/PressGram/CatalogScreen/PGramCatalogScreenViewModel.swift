//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Combine
import SwiftUI

typealias PGramCatalogScreenViewModelType = StateStoreViewModelV2<PGramCatalogScreenViewState, PGramCatalogScreenViewAction>

final class PGramCatalogScreenViewModel: PGramCatalogScreenViewModelType, PGramCatalogScreenViewModelProtocol {
    private let registryService: PGramRegistryServicing
    private let currentHomeserver: String

    private let actionsSubject: PassthroughSubject<PGramCatalogScreenViewModelAction, Never> = .init()
    var actionsPublisher: AnyPublisher<PGramCatalogScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(registryService: PGramRegistryServicing,
         currentHomeserver: String,
         showManualEntryLink: Bool = false) {
        self.registryService = registryService
        self.currentHomeserver = currentHomeserver

        var initial = PGramCatalogScreenViewState()
        initial.selectedHomeserver = currentHomeserver
        initial.showManualEntryLink = showManualEntryLink
        super.init(initialViewState: initial)
    }

    override func process(viewAction: PGramCatalogScreenViewAction) {
        switch viewAction {
        case .onAppear:
            Task { await loadCatalog() }
        case .selectServer(let server):
            state.selectedHomeserver = server.homeserver
        case .continueTapped:
            guard let selected = state.servers.first(where: { $0.homeserver == state.selectedHomeserver }) else {
                return
            }
            actionsSubject.send(.serverSelected(selected))
        case .manualEntryTapped:
            actionsSubject.send(.manualEntryRequested)
        case .dismiss:
            actionsSubject.send(.dismiss)
        case .retry:
            Task { await loadCatalog() }
        }
    }

    // MARK: - Private

    private func loadCatalog() async {
        state.isLoading = true
        state.loadError = nil
        do {
            let response = try await registryService.fetchCatalog()
            state.servers = response.servers
            // Keep current selection if still in the catalog, otherwise pick the first one.
            if !response.servers.contains(where: { $0.homeserver == state.selectedHomeserver }) {
                state.selectedHomeserver = response.servers.first?.homeserver
            }
            state.isLoading = false
        } catch {
            state.isLoading = false
            state.loadError = error.localizedDescription
            state.bindings.alertInfo = AlertInfo(id: .loadFailed)
        }
    }
}
