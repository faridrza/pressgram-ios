//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Pressgram UI strings.
///
/// Temporary single source of truth for Pressgram-specific copy during Phase 1.
/// To be migrated to `Untranslated.strings` + `L10n.*` once the Localazy workflow
/// is set up for the Pressgram fork.
enum PGramStrings {
    // MARK: - Welcome screen

    static let welcomeTagline = "Децентрализованный мессенджер медиасообщества"
    static let welcomeServerLabel = "Сервер:"
    static let welcomeChangeServer = "Сменить"
    static let welcomeLoginWithPassword = "Войти с паролем"
    static let welcomeLoginWithQR = "Вход по QR-коду"
    static let welcomeRegister = "Регистрация (требуется код)"
    static let welcomeRequestInvite = "Запросить приглашение"
    static let appName = "Pressgram"

    // MARK: - Catalog screen

    static let catalogTitle = "Выбор сервера"
    static let catalogSearchPlaceholder = "Поиск"
    static let catalogContinue = "Продолжить"
    static let catalogManualEntry = "Указать сервер вручную"
    static let catalogBadgeOpen = "Свободная регистрация"
    static let catalogBadgeToken = "По приглашениям"
    static let catalogBadgeClosed = "Регистрация закрыта"
}
