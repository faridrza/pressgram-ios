//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Mock catalog data for Phase 1 (before `dl.pgram.im/api/community-servers` is wired up).
///
/// Mirrors `docs/COMMUNITY-REGISTRY.md` §10.1 mock-каталог.
enum PGramMockCatalog {
    static let response = PGramCatalogResponse(version: 1,
                                               updatedAt: Date(timeIntervalSince1970: 1_745_835_000), // 2026-04-28T10:30:00Z
                                               servers: servers)

    static let servers: [PGramServer] = [
        PGramServer(homeserver: "pgram.im",
                    name: "Pressgram",
                    description: "Главный сервер сети. Открытая регистрация для всех журналистов и медиапрофессионалов.",
                    type: .community,
                    logoURL: URL(string: "https://pgram.im/pressgram-logo-blue.png"),
                    visibility: .public,
                    registration: PGramRegistration(mode: .open, instructions: nil, contact: nil),
                    owner: "PREX",
                    country: "RU",
                    language: "ru",
                    since: "2026-03-25",
                    tags: nil,
                    active: true,
                    lastSeen: Date(timeIntervalSince1970: 1_745_835_000)),

        PGramServer(homeserver: "newsroom.pgram.im",
                    name: "Редакция «Новости»",
                    description: "Внутренний сервер редакции газеты «Новости». Журналисты, редакторы, корреспонденты.",
                    type: .media,
                    logoURL: URL(string: "https://newsroom.pgram.im/logo.png"),
                    visibility: .public,
                    registration: PGramRegistration(mode: .token,
                                                    instructions: "Приглашения выдаются штатным сотрудникам редакции.",
                                                    contact: "invites@newsroom.example.com"),
                    owner: "ООО «Новости»",
                    country: "RU",
                    language: "ru",
                    since: "2026-04-15",
                    tags: ["редакция", "новости"],
                    active: true,
                    lastSeen: Date(timeIntervalSince1970: 1_745_830_800)),

        PGramServer(homeserver: "prexplore.pgram.im",
                    name: "Прексплоре",
                    description: "Сообщество вокруг проекта Прексплоре. Журналисты, медиаэксперты, аналитики отрасли.",
                    type: .community,
                    logoURL: nil,
                    visibility: .public,
                    registration: PGramRegistration(mode: .token,
                                                    instructions: "Сообщество для практикующих журналистов и медиаэкспертов.",
                                                    contact: "@admin:prexplore.pgram.im"),
                    owner: nil,
                    country: "RU",
                    language: "ru",
                    since: "2026-04-20",
                    tags: nil,
                    active: true,
                    lastSeen: Date(timeIntervalSince1970: 1_745_834_400)),

        PGramServer(homeserver: "archive.pgram.im",
                    name: "Архив",
                    description: "Закрытый архивный сервер.",
                    type: .other,
                    logoURL: nil,
                    visibility: .public,
                    registration: PGramRegistration(mode: .closed, instructions: nil, contact: nil),
                    owner: nil,
                    country: "RU",
                    language: "ru",
                    since: "2026-04-01",
                    tags: nil,
                    active: true,
                    lastSeen: Date(timeIntervalSince1970: 1_745_827_200))
    ]
}
