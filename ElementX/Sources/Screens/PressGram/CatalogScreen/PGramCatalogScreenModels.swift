//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

enum PGramCatalogScreenViewModelAction {
    case dismiss
    case serverSelected(PGramServer)
    case manualEntryRequested
}

struct PGramCatalogScreenViewState: BindableState {
    var servers: [PGramServer] = []
    /// The currently highlighted server (defaults to the first one once the catalog loads).
    var selectedHomeserver: String?
    var isLoading = true
    var loadError: String?
    /// Whether to show the "Указать сервер вручную" link (Phase 2 — disabled by default).
    var showManualEntryLink = false

    var bindings = PGramCatalogScreenViewStateBindings()

    var filteredServers: [PGramServer] {
        let query = bindings.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return servers }
        return servers.filter { server in
            server.name.lowercased().contains(query)
                || server.description.lowercased().contains(query)
                || server.homeserver.lowercased().contains(query)
        }
    }
}

struct PGramCatalogScreenViewStateBindings {
    var searchText = ""
    var alertInfo: AlertInfo<PGramCatalogScreenAlertType>?
}

enum PGramCatalogScreenAlertType: Hashable {
    case loadFailed
}

enum PGramCatalogScreenViewAction {
    case onAppear
    case selectServer(PGramServer)
    case continueTapped
    case manualEntryTapped
    case dismiss
    case retry
}
