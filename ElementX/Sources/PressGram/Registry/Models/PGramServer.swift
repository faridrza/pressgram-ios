//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

// MARK: - Server entry

/// A Pressgram community server entry, as returned by `GET /api/community-servers`
/// or `POST /api/check-invite`.
struct PGramServer: Codable, Hashable, Identifiable {
    var id: String {
        homeserver
    }

    let homeserver: String
    let name: String
    let description: String
    let type: PGramServerType
    let logoURL: URL?
    let visibility: PGramVisibility
    let registration: PGramRegistration
    let owner: String?
    let country: String?
    let language: String?
    let since: String?
    let tags: [String]?
    let active: Bool
    let lastSeen: Date

    enum CodingKeys: String, CodingKey {
        case homeserver, name, description, type
        case logoURL = "logo_url"
        case visibility, registration, owner, country, language, since, tags, active
        case lastSeen = "last_seen"
    }
}

enum PGramServerType: String, Codable, Hashable {
    case community
    case media
    case other
}

enum PGramVisibility: String, Codable, Hashable {
    case `public`
    case unlisted
}

struct PGramRegistration: Codable, Hashable {
    let mode: PGramRegistrationMode
    let instructions: String?
    let contact: String?
}

enum PGramRegistrationMode: String, Codable, Hashable {
    case open
    case token
    case closed
}

// MARK: - API responses

struct PGramCatalogResponse: Codable {
    let version: Int
    let updatedAt: Date
    let servers: [PGramServer]

    enum CodingKeys: String, CodingKey {
        case version
        case updatedAt = "updated_at"
        case servers
    }
}

struct PGramWhitelistResponse: Codable {
    let version: Int
    let updatedAt: Date
    let servers: [String]

    enum CodingKeys: String, CodingKey {
        case version
        case updatedAt = "updated_at"
        case servers
    }
}

// MARK: - Errors

enum PGramRegistryError: Error, Equatable {
    /// Returned when the JSON `version` field is higher than what the client supports.
    case versionTooNew(serverVersion: Int)
    /// `429 RATE_LIMITED` — the `retryAfter` is in seconds.
    case rateLimited(retryAfter: TimeInterval)
    /// `404 INVALID_INVITE` from `/api/check-invite`.
    case invalidInvite
    /// `404 NOT_ACCEPTING` from `/api/invite-request`.
    case notAccepting
    /// No network connectivity.
    case offline
    /// Server returned a 5xx or unknown status.
    case server(statusCode: Int)
    /// JSON decoding failed.
    case decoding
}
