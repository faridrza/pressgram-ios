//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

// sourcery: AutoMockable
@MainActor
protocol PGramRegistryServicing {
    /// `GET /api/community-servers` — Phase 1.5 returns mock data.
    func fetchCatalog() async throws -> PGramCatalogResponse

    /// `POST /api/invite-request` — submit a "request invitation" form for a public
    /// homeserver with `registration.mode == "token"`. Phase 1.5 is mocked.
    func requestInvite(homeserver: String, email: String, message: String) async throws
}
