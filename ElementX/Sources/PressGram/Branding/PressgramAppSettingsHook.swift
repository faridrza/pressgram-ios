//
// Copyright 2026 PREX.
//
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

/// Configures `AppSettings` with Pressgram defaults at app startup.
///
/// Registered in `AppCoordinator.init` via `appHooks.registerAppSettingsHook(_:)`.
struct PressgramAppSettingsHook: AppSettingsHookProtocol {
    func configure(_ appSettings: AppSettings) -> AppSettings {
        MXLog.info("PGRAM: PressgramAppSettingsHook.configure() called — applying Pressgram defaults")
        appSettings.override(accountProviders: ["pgram.im"],
                             allowOtherAccountProviders: false,
                             hideBrandChrome: false,
                             pushGatewayBaseURL: "https://matrix.org",
                             // Phase 1 demo workaround. Pressgram MAS enforces same-domain match
                             // between `client_uri` and `redirect_uri` AND rejects custom schemes.
                             // The only domain Apple has already verified for bundle id
                             // `io.element.elementx` is `element.io`, so both `clientURI` and
                             // `oidcRedirectURL` must temporarily live there.
                             // Phase 2 fix (depends on open Q6): server team hosts an
                             // `apple-app-site-association` on `pgram.im` → switch to
                             // `https://pgram.im/oidc/callback` and update `websiteURL` back.
                             oidcRedirectURL: "https://element.io/oidc/login",
                             websiteURL: "https://element.io",
                             // Phase 1 demo: logo / tos / privacy must share the OIDC client_uri host
                             // (Pressgram MAS rejects cross-host metadata with `invalid_client_metadata`).
                             // These three URLs only surface during OIDC dynamic registration and on
                             // settings-screen "About / Privacy" — they swap back to pgram.im once
                             // the MAS allowlist or a pre-registered static client_id lands (Phase 2).
                             logoURL: "https://element.io/mobile-icon.png",
                             copyrightURL: "https://pgram.im/copyright",
                             acceptableUseURL: "https://element.io/acceptable-use-policy-terms",
                             privacyURL: "https://element.io/privacy",
                             encryptionURL: "https://pgram.im/help#encryption",
                             deviceVerificationURL: "https://pgram.im/help#device-verification",
                             chatBackupDetailsURL: "https://pgram.im/help#chat-backup",
                             identityPinningViolationDetailsURL: "https://pgram.im/help#identity-pinning",
                             historySharingDetailsURL: "https://pgram.im/help#history-sharing",
                             elementWebHosts: ["pgram.im"],
                             accountProvisioningHost: "pgram.im",
                             bugReportApplicationID: "pressgram-ios",
                             analyticsTermsURL: nil,
                             mapTilerConfiguration: appSettings.mapTilerConfiguration)
        MXLog.info("PGRAM: After override → websiteURL=\(appSettings.websiteURL) logoURL=\(appSettings.logoURL) tosURI=\(appSettings.acceptableUseURL) policyURI=\(appSettings.privacyURL)")
        return appSettings
    }
}
