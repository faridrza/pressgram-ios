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
    static let welcomeRegisterOpen = "Регистрация"
    static let welcomeRegisterTokenRequired = "Регистрация (требуется код)"
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

    // MARK: - Invite request screen

    static let inviteRequestTitle = "Заявка на приглашение"
    static let inviteRequestEmailLabel = "Email для связи"
    static let inviteRequestEmailPlaceholder = "ivan@example.com"
    static let inviteRequestMessageLabel = "Расскажите кратко о себе (от 20 до 1000 символов)"
    static let inviteRequestSubmit = "Отправить заявку"
    static let inviteRequestErrorEmail = "Проверьте формат email"
    static let inviteRequestErrorMessage = "От 20 до 1000 символов"
    static let inviteRequestErrorNetwork = "Сервер недоступен"
    static let inviteRequestErrorRateLimited = "Слишком много заявок. Попробуйте через час."

    // MARK: - Invite request success popup

    static let inviteRequestSuccessTitle = "Заявка отправлена"
    static func inviteRequestSuccessMessage(email: String) -> String {
        "Ваша заявка отправлена администратору сервера. Ответ придёт на email \(email)."
    }

    static let inviteRequestSuccessHint = "Когда вы получите код приглашения, вернитесь сюда и нажмите «У меня есть код»."
    static let inviteRequestSuccessButton = "На главную"
}
