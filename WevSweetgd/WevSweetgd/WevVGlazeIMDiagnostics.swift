import Foundation
import OSLog

/// Native preparation diagnostics only. H5 owns the NIM instance and its connection state.
/// The public API deliberately accepts credential lengths/flags instead of tokens or keys.
@MainActor
enum WevVGlazeIMDiagnostics {
    enum Stage: String {
        case open, context, bridge
    }

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "WevV", category: "H5IM")

    static func openSucceeded(appID: String, imAppKeyLength: Int, imAppKeyValid: Bool, cached: Bool) {
        #if DEBUG
        let app = safeIdentifier(appID)
        logger.notice("native.open succeeded appId=\(app, privacy: .public) imAppKeyPresent=\(imAppKeyLength > 0) imAppKeyLength=\(max(0, imAppKeyLength)) imAppKeyValid=\(imAppKeyValid) cached=\(cached)")
        #endif
    }

    static func contextPrepared(appID: String, accountID: Int64, imAccount: String, imTokenLength: Int,
                                imTokenMatchesAccessToken: Bool) {
        #if DEBUG
        let app = safeIdentifier(appID)
        let account = safeIdentifier(imAccount)
        let version = safeIdentifier(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown")
        let build = safeIdentifier(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown")
        let system = ProcessInfo.processInfo.operatingSystemVersion
        logger.notice("native.context prepared appId=\(app, privacy: .public) accountId=\(accountID) yxAccid=\(account, privacy: .public) imTokenPresent=\(imTokenLength > 0) imTokenLength=\(max(0, imTokenLength)) imTokenMatchesAccessToken=\(imTokenMatchesAccessToken) clientVersion=\(version, privacy: .public) build=\(build, privacy: .public) system=\(system.majorVersion).\(system.minorVersion).\(system.patchVersion)")
        #endif
    }

    static func bridgeContextDelivered(generation: UUID, succeeded: Bool) {
        #if DEBUG
        let identifier = generation.uuidString
        logger.notice("native.bridge contextDelivered=\(succeeded) generation=\(identifier, privacy: .public)")
        #endif
    }

    static func failure(stage: Stage, error: Error) {
        #if DEBUG
        let metadata = failureMetadata(error)
        logger.error("native.\(stage.rawValue, privacy: .public) failed category=\(metadata.category, privacy: .public) code=\(metadata.code, privacy: .public)")
        #endif
    }

    /// Rejects arbitrary messages, URLs, whitespace and overlong values before they reach logging.
    static func safeIdentifier(_ raw: String) -> String {
        guard (1...64).contains(raw.utf8.count), raw.utf8.allSatisfy({ byte in
            (48...57).contains(byte) || (65...90).contains(byte) || (97...122).contains(byte)
                || [45, 46, 64, 95].contains(byte)
        }) else { return "redacted" }
        return raw
    }

    static func safeBusinessCode(_ raw: String) -> String {
        // OPI's envelope code is numeric. Do not accept arbitrary server strings here.
        guard (1...12).contains(raw.utf8.count), raw.utf8.allSatisfy({ (48...57).contains($0) }) else { return "redacted" }
        return raw
    }

    /// Never uses an error's description, response body, URL or userInfo.
    static func failureMetadata(_ error: Error) -> (category: String, code: String) {
        if error is CancellationError { return ("cancelled", "none") }
        if let network = error as? WevVGlazeNetworkError {
            switch network {
            case .http(let status): return ("http", String(status))
            case .business(let code, _): return ("business", safeBusinessCode(code))
            case .invalidConfiguration: return ("invalid-configuration", "none")
            case .invalidResponse: return ("invalid-response", "none")
            case .missingContract: return ("missing-contract", "none")
            }
        }
        if let urlError = error as? URLError { return ("url", String(urlError.code.rawValue)) }
        let native = error as NSError
        switch native.domain {
        case NSURLErrorDomain: return ("url", String(native.code))
        case NSCocoaErrorDomain: return ("cocoa", String(native.code))
        case "WKErrorDomain": return ("webkit", String(native.code))
        default: return ("other", "none")
        }
    }
}
