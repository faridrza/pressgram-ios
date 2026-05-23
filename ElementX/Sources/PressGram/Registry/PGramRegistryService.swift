//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Pressgram registry service.
///
/// Phase 1.5: returns hard-coded mock catalog data with a small artificial
/// delay so the catalog screen exercises its loading state. Phase 2 swaps
/// this implementation for one that hits `dl.pgram.im/api/community-servers`
/// (with ETag/304 caching, version check, rate-limit handling — see
/// `docs/pressgram/api-reference.md`).
final class PGramRegistryService: PGramRegistryServicing {
    func fetchCatalog() async throws -> PGramCatalogResponse {
        try await Task.sleep(for: .milliseconds(300))
        return PGramMockCatalog.response
    }

    func requestInvite(homeserver: String, email: String, message: String) async throws {
        // Phase 1.5: mock. Phase 2 will POST to dl.pgram.im/api/invite-request
        // with proper rate-limit handling (429 / Retry-After) and the error
        // taxonomy from docs/COMMUNITY-REGISTRY.md §3.4.
        try await Task.sleep(for: .milliseconds(600))
        MXLog.info("PGramRegistry mock: invite-request accepted for homeserver=\(homeserver) email=\(email) message.length=\(message.count)")
    }
}
