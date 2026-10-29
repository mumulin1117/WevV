import Foundation
import CoreFoundation
import CommonCrypto

/// Failures retain only contract/error metadata. Request bodies, credentials and keys are never logged.
enum GlazeVaultTradeError: Error, LocalizedError, Sendable {
    case http(Int)
    case business(code: String, message: String)
    case invalidConfiguration
    case invalidResponse
    case missingContract(String)

    nonisolated var isAuthenticationFailure: Bool {
        switch self {
        case .http(let status): return status == 401
        case .business(let code, _): return code == "401" || ["40101", "40102", "40103", "40104", "40105"].contains(code)
        default: return false
        }
    }

    nonisolated var errorDescription: String? {
        switch self {
        case .http(let status): return "The service could not complete the request (HTTP \(status)). Please retry."
        case .business(_, let message): return message.isEmpty ? "The service could not complete the request. Please retry." : message
        case .invalidConfiguration: return "The service configuration is unavailable. Please retry."
        case .invalidResponse: return "The service returned an invalid response. Please retry."
        case .missingContract: return "This feature is not available on the current service. Please try again later."
        }
    }
}

@MainActor
struct WevVGlazeVaultPack {
    let appID: String
    let bootstrapAppID: String
    let environment: String
    let initialBaseURL: URL
    let bootstrapBaseURL: URL
    let appVersion: String
    private(set) var protocolName: String
    fileprivate let encryptionKey: Data
    fileprivate let encryptionIV: Data
    fileprivate let paths: [String: String]
    fileprivate let fields: [String: String]
    fileprivate let reverseFields: [String: String]
    fileprivate let headers: [String: String]
    fileprivate let responseArrayEnvelopeFields: [String]

    /// Native launch routing belongs to the native bundle manifest. The H5
    /// Profile has a strict services schema and cannot carry these extra keys.
    /// Older standalone native fixtures may still use their original inline
    /// routing when no manifest metadata is supplied.
    init(javaScript: Data, nativeRouting: [String: Any]? = nil) throws {
        guard let source = String(data: javaScript, encoding: .utf8),
              let start = source.range(of: "/*__OPI_PROFILE_START__*/"),
              let end = source.range(of: "/*__OPI_PROFILE_END__*/", range: start.upperBound..<source.endIndex),
              let json = String(source[start.upperBound..<end.lowerBound]).data(using: .utf8),
              let root = try JSONSerialization.jsonObject(with: json) as? [String: Any],
              let services = root["services"] as? [String: Any],
              let client = services["apiClient"] as? [String: Any],
              let appID = client["appId"] as? String, !appID.isEmpty,
              let version = client["appVersion"] as? String, !version.isEmpty,
              let initialURL = Self.secureURL(services["apiBaseUrl"], scheme: "https"),
              let protocolName = client["protocol"] as? String,
              ["opi-v2-aes", "opi-v2-aes-semantic"].contains(protocolName),
              let key = (client["encryptionKey"] as? String)?.data(using: .utf8), key.count == kCCKeySizeAES128,
              let iv = (client["encryptionIv"] as? String)?.data(using: .utf8), iv.count == kCCBlockSizeAES128,
              let aliases = root["aliases"] as? [String: Any],
              let paths = aliases["path"] as? [String: String], !paths.isEmpty,
              let fields = aliases["field"] as? [String: String], !fields.isEmpty,
              let headers = aliases["header"] as? [String: String] else {
            throw GlazeVaultTradeError.invalidConfiguration
        }
        let routing: [String: Any]
        if let nativeRouting {
            guard Set(nativeRouting.keys) == Set(["environment", "bootstrapBaseUrl", "bootstrapAppId"]),
                  Set(services.keys) == Set(["apiBaseUrl", "apiClient"]),
                  let bootstrapID = nativeRouting["bootstrapAppId"] as? String,
                  !bootstrapID.isEmpty,
                  bootstrapID.utf8.allSatisfy({ (48...57).contains($0) }),
                  Self.secureURL(nativeRouting["bootstrapBaseUrl"], scheme: "https") != nil else {
                throw GlazeVaultTradeError.invalidConfiguration
            }
            routing = nativeRouting
        } else { routing = services }
        let environment: String
        if let rawEnvironment = routing["environment"] {
            guard let value = rawEnvironment as? String, ["test", "production"].contains(value) else {
                throw GlazeVaultTradeError.invalidConfiguration
            }
            environment = value
        } else { environment = "test" }
        let bootstrapAppID: String
        if let rawBootstrapAppID = routing["bootstrapAppId"] {
            guard let value = rawBootstrapAppID as? String,
                  !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw GlazeVaultTradeError.invalidConfiguration
            }
            bootstrapAppID = value
        } else { bootstrapAppID = appID }
        let bootstrapURL: URL
        if let rawBootstrapURL = routing["bootstrapBaseUrl"] {
            guard let value = Self.secureURL(rawBootstrapURL, scheme: "https") else {
                throw GlazeVaultTradeError.invalidConfiguration
            }
            bootstrapURL = value
        } else { bootstrapURL = initialURL }
        var reverseFields: [String: String] = [:]
        for (original, alias) in fields {
            guard !original.isEmpty, !alias.isEmpty, reverseFields[alias] == nil else {
                throw GlazeVaultTradeError.invalidConfiguration
            }
            reverseFields[alias] = original
        }
        for required in ["appId", "appVersion", "deviceNo", "language", "refreshToken"] {
            guard let value = headers[required], !value.isEmpty else {
                throw GlazeVaultTradeError.missingContract("Profile header \(required)")
            }
        }
        guard paths["/_v2/config/open"] != nil else { throw GlazeVaultTradeError.missingContract("config/open") }
        self.appID = appID
        self.bootstrapAppID = bootstrapAppID
        self.environment = environment
        initialBaseURL = initialURL
        bootstrapBaseURL = bootstrapURL
        appVersion = version
        self.protocolName = protocolName
        encryptionKey = key
        encryptionIV = iv
        self.paths = paths
        self.fields = fields
        self.reverseFields = reverseFields
        self.headers = headers
        responseArrayEnvelopeFields = (root["compatibility"] as? [String: Any])?["responseArrayEnvelopeFields"] as? [String] ?? []
    }

    fileprivate static func secureURL(_ raw: Any?, scheme: String) -> URL? {
        guard let text = raw as? String, let parts = URLComponents(string: text),
              parts.scheme?.lowercased() == scheme, let host = parts.host, !host.isEmpty,
              parts.user == nil, parts.password == nil, parts.query == nil, parts.fragment == nil,
              let url = parts.url else { return nil }
        return url
    }
}

@MainActor
struct crumbBioView {
    let apiBaseURL: URL
    let fullFeaturesEnabled: Bool
    let revision: Int
    let target: String
}

@MainActor
struct donutAvatarChoiceTitles {
    let imAppKey: String
    let noticeAccount: String
    let rtcAppId: String
    let sapiBaseURL: URL
    let socketURL: URL
    let sapiAesKey: String
    let sapiAesIv: String
    /// Preserves additional current-Open fields for the SDK context, without merging older configuration.
    let dictionary: [String: Any]

    init(dictionary: [String: Any]) throws {
        func required(_ name: String) throws -> String {
            guard let value = dictionary[name] as? String, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw GlazeVaultTradeError.missingContract("runtimeConfig.\(name)")
            }
            return value
        }
        let imKey = try required("imAppKey")
        let rtcID = try required("rtcAppId")
        let notice = try required("noticeAccount")
        let key = try required("sapiAesKey")
        let iv = try required("sapiAesIv")
        let hex = CharacterSet(charactersIn: "0123456789abcdefABCDEF")
        guard imKey.count == 32, imKey.unicodeScalars.allSatisfy({ hex.contains($0) }),
              rtcID.count == 32, rtcID.unicodeScalars.allSatisfy({ hex.contains($0) }),
              notice.count <= 64, key.utf8.count == kCCKeySizeAES128, iv.utf8.count == kCCBlockSizeAES128,
              let sapi = WevVGlazeVaultPack.secureURL(dictionary["sapiBaseUrl"], scheme: "https"),
              let socket = WevVGlazeVaultPack.secureURL(dictionary["socketUrl"], scheme: "wss") else {
            throw GlazeVaultTradeError.invalidConfiguration
        }
        imAppKey = imKey
        noticeAccount = notice
        rtcAppId = rtcID
        sapiBaseURL = sapi
        socketURL = socket
        sapiAesKey = key
        sapiAesIv = iv
        self.dictionary = dictionary
    }
}

@MainActor
struct donutAvatarChoices {
    let runtimeConfig: donutAvatarChoiceTitles
    let cdnDomainConfig: String?
    let accessToken: String?
    let expiresIn: Int?
}

@MainActor
struct donutCameraButton {
    let tokenValue: String
    let expiresAt: Date
}

/// OPI and SAPI deliberately have separate codecs and credentials. Session renewal belongs to the caller.
@MainActor
final class NertyuChoiceStackLayer {
    let profile: WevVGlazeVaultPack
    private let deviceNo: String
    private let hostVersion: String
    private let language: String
    private let session: URLSession
    private(set) var currentRoute: crumbBioView?
    private(set) var currentOpen: donutAvatarChoices?
    private(set) var openRevision = 0
    private var routeTask: Task<crumbBioView, Error>?
    private var openTask: Task<donutAvatarChoices, Error>?
    private var openTaskRefreshToken: String?
    private var currentOpenRefreshToken: String?
    private var sessionEpoch = 0

    init(profile: WevVGlazeVaultPack, deviceNo: String, hostVersion: String, language: String, session: URLSession = .shared) {
        self.profile = profile
        self.deviceNo = deviceNo
        self.hostVersion = hostVersion
        self.language = language
        self.session = session
    }

    /// The startup contract prohibits disk/HTTP caching. A completed route is reused only in this process.
    func bootstrap(force: Bool = false) async throws -> crumbBioView {
        if let routeTask { return try await routeTask.value }
        if !force, let currentRoute { return currentRoute }
        let task = Task { @MainActor in
            let route = try await self.fetchLaunchRoute()
            if self.currentRoute?.apiBaseURL != route.apiBaseURL || self.currentRoute?.revision != route.revision {
                self.currentOpen = nil
                self.currentOpenRefreshToken = nil
            }
            self.currentRoute = route
            return route
        }
        routeTask = task
        defer { routeTask = nil }
        return try await task.value
    }

    /// Established H5 entries force a fresh Open; startup may reuse one completed during preparation.
    /// Concurrent calls for the same credential share one request.
    func open(refreshToken: String? = nil, force: Bool = false) async throws -> donutAvatarChoices {
        if let openTask {
            if openTaskRefreshToken == refreshToken { return try await openTask.value }
            // A different account must never receive an older account's Open result.
            _ = try? await openTask.value
            return try await open(refreshToken: refreshToken, force: true)
        }
        if !force, currentOpenRefreshToken == refreshToken, let currentOpen {
            #if DEBUG
            conversationAvatar.openSucceeded(appID: profile.appID, imAppKeyLength: currentOpen.runtimeConfig.imAppKey.utf8.count,
                                                imAppKeyValid: true, cached: true)
            #endif
            return currentOpen
        }
        let epoch = sessionEpoch
        let task = Task { @MainActor in
            defer {
                if self.sessionEpoch == epoch { self.openTask = nil; self.openTaskRefreshToken = nil }
            }
            do {
                let body = try JSONSerialization.data(withJSONObject: ["language": [self.language], "timezone": TimeZone.current.identifier])
                let response = try await self.opi(path: "/_v2/config/open", body: body, refreshToken: refreshToken)
                try Task.checkCancellation()
                guard self.sessionEpoch == epoch else { throw CancellationError() }
                guard let object = try JSONSerialization.jsonObject(with: response) as? [String: Any],
                      let runtime = object["runtimeConfig"] as? [String: Any] else {
                    throw GlazeVaultTradeError.missingContract("runtimeConfig")
                }
                let cdn: String?
                if let raw = object["cdnDomainConfig"], !(raw is NSNull) {
                    guard let string = raw as? String else { throw GlazeVaultTradeError.invalidResponse }
                    cdn = string
                } else { cdn = nil }
                let context = donutAvatarChoices(runtimeConfig: try donutAvatarChoiceTitles(dictionary: runtime),
                                                  cdnDomainConfig: cdn, accessToken: object["accessToken"] as? String,
                                                  expiresIn: Self.integer(object["expiresIn"]))
                self.currentOpen = context
                self.currentOpenRefreshToken = refreshToken
                self.openRevision &+= 1
                #if DEBUG
                conversationAvatar.openSucceeded(appID: self.profile.appID, imAppKeyLength: context.runtimeConfig.imAppKey.utf8.count,
                                                    imAppKeyValid: true, cached: false)
                #endif
                return context
            } catch {
                #if DEBUG
                conversationAvatar.failure(stage: .open, error: error)
                #endif
                throw error
            }
        }
        openTask = task
        openTaskRefreshToken = refreshToken
        return try await task.value
    }

    func clearSugarCrumbs() {
        sessionEpoch &+= 1
        openTask?.cancel()
        openTask = nil
        openTaskRefreshToken = nil
        currentOpenRefreshToken = nil
        // App-level routing/configuration remains usable for browsing; account tokens do not.
        if let currentOpen {
            self.currentOpen = donutAvatarChoices(runtimeConfig: currentOpen.runtimeConfig,
                cdnDomainConfig: currentOpen.cdnDomainConfig, accessToken: nil, expiresIn: nil)
        }
    }

    func opi(path: String, body: Data, accessToken: String? = nil, refreshToken: String? = nil) async throws -> Data {
        let epoch = sessionEpoch
        guard let mappedPath = profile.paths[path], mappedPath.hasPrefix("/"), !mappedPath.hasPrefix("//") else {
            throw GlazeVaultTradeError.missingContract("OPI path \(path)")
        }
        let route = try await bootstrap()
        try Task.checkCancellation()
        guard sessionEpoch == epoch else { throw CancellationError() }
        let semantic = profile.protocolName == "opi-v2-aes-semantic"
        let original = try JSONSerialization.jsonObject(with: body, options: [.fragmentsAllowed])
        let encoded = try Self.jsonData(semantic ? original : Self.mapFields(original, mapping: profile.fields))
        let ciphertext = try Self.crypt(encoded, key: profile.encryptionKey, iv: profile.encryptionIV, encrypt: true)
        var request = URLRequest(url: try Self.endpoint(base: route.apiBaseURL, path: semantic ? path : mappedPath), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        request.httpBody = Data(Self.hex(ciphertext).utf8)
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("no-store", forHTTPHeaderField: "Cache-Control")
        request.httpShouldHandleCookies = false
        func header(_ name: String, _ value: String) throws {
            guard !value.isEmpty else { throw GlazeVaultTradeError.invalidConfiguration }
            let actual = semantic ? name : profile.headers[name]
            guard let actual, !actual.isEmpty else { throw GlazeVaultTradeError.missingContract("Profile header \(name)") }
            request.setValue(value, forHTTPHeaderField: actual)
        }
        // SDK 2.0 compatibility: preserve the plain appId in addition to its published alias.
        request.setValue(profile.appID, forHTTPHeaderField: "appId")
        try header("appId", profile.appID)
        try header("deviceNo", deviceNo)
        try header("appVersion", hostVersion)
        try header("language", language)
        if let token = accessToken, !token.isEmpty { request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        if let token = refreshToken, !token.isEmpty { try header("refreshToken", token) }
        let envelope = try await send(request)
        try Task.checkCancellation()
        guard sessionEpoch == epoch else { throw CancellationError() }
        guard let code = envelope["code"] as? NSNumber, CFGetTypeID(code) != CFBooleanGetTypeID() else { throw GlazeVaultTradeError.invalidResponse }
        guard code.doubleValue == 0 else { throw Self.business(envelope, code: code.stringValue) }
        let decoded = try Self.payload(envelope, key: profile.encryptionKey, iv: profile.encryptionIV)
        #if DEBUG
        if path == "/_v2/discover/live/pool", let object = decoded as? [String: Any] {
            let rowsField = semantic ? "rows" : (profile.fields["rows"] ?? "rows")
            let idField = semantic ? "id" : (profile.fields["id"] ?? "id")
            let stateField = semantic ? "liveRoomState" : (profile.fields["liveRoomState"] ?? "liveRoomState")
            let rows = object[rowsField] as? [[String: Any]] ?? []
            let page = Self.integer((original as? [String: Any])?["currentPage"]) ?? 1
            print("[WevV.LivePool] page=\(page) rows=\(rows.count) stateField=\(stateField)")
            for (index, row) in rows.enumerated() {
                let roomID = Self.integer(row[idField]).map(String.init) ?? "<unknown>"
                let state: String
                switch row[stateField] {
                case let value as NSNumber: state = value.stringValue
                case let value as String: state = String(reflecting: value)
                case is NSNull: state = "null"
                case nil: state = "<missing>"
                default: state = "<invalid>"
                }
                print("[WevV.LivePool] row=\(index + 1) roomId=\(roomID) \(stateField)=\(state)")
            }
        }
        #endif
        let restored = semantic ? decoded : Self.mapFields(decoded, mapping: profile.reverseFields)
        // Retained for older Profile compatibility. The supplied Revision 2 list is empty.
        if let object = restored as? [String: Any] {
            for name in profile.responseArrayEnvelopeFields {
                if let array = object[name] as? [Any] { return try Self.jsonData(array) }
            }
        }
        return try Self.jsonData(restored)
    }

    func sapi(path: String, body: Data, authToken: String) async throws -> Data {
        guard path.hasPrefix("/sapi/"), !path.contains("?"), !path.contains("#"),
              let runtime = currentOpen?.runtimeConfig else { throw GlazeVaultTradeError.missingContract("current Open / SAPI path") }
        _ = try JSONSerialization.jsonObject(with: body, options: [.fragmentsAllowed])
        let key = Data(runtime.sapiAesKey.utf8)
        let iv = Data(runtime.sapiAesIv.utf8)
        var request = URLRequest(url: try Self.endpoint(base: runtime.sapiBaseURL, path: path, sapi: true), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        request.httpBody = Data(try Self.crypt(body, key: key, iv: iv, encrypt: true).base64EncodedString().utf8)
        request.httpShouldHandleCookies = false
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("no-store", forHTTPHeaderField: "Cache-Control")
        request.setValue(profile.appID, forHTTPHeaderField: "appid")
        request.setValue(deviceNo, forHTTPHeaderField: "deviceNo")
        request.setValue(hostVersion, forHTTPHeaderField: "appVersion")
        request.setValue(authToken, forHTTPHeaderField: "auth_token")
        request.setValue(language, forHTTPHeaderField: "Accept-Language")
        let envelope = try await send(request)
        guard let code = envelope["code"] as? String else { throw GlazeVaultTradeError.invalidResponse }
        guard code == "200" else { throw Self.business(envelope, code: code) }
        return try Self.jsonData(Self.payload(envelope, key: key, iv: iv))
    }

    /// No ticket is cached here: the session owner keys its cache by account, service and environment.
    func exchange(legacyToken: String) async throws -> donutCameraButton {
        guard !legacyToken.isEmpty else { throw GlazeVaultTradeError.missingContract("legacyToken") }
        let body = try JSONSerialization.data(withJSONObject: ["token": legacyToken])
        let result = try await sapi(path: "/sapi/auth/v1/client/auth/exchangeToken", body: body, authToken: "")
        guard let object = try JSONSerialization.jsonObject(with: result) as? [String: Any],
              let value = object["tokenValue"] as? String, !value.isEmpty else { throw GlazeVaultTradeError.missingContract("tokenValue") }
        let suppliedTimeout = Self.integer(object["tokenTimeout"]) ?? 0
        let timeout = suppliedTimeout > 0 ? suppliedTimeout : 1800
        return donutCameraButton(tokenValue: value, expiresAt: Date().addingTimeInterval(TimeInterval(timeout)))
    }

    private func fetchLaunchRoute() async throws -> crumbBioView {
        var components = URLComponents(url: try Self.endpoint(base: profile.bootstrapBaseURL, path: "/sugary9/crumb/voice"), resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "treatWarmDelight", value: profile.bootstrapAppID)]
        guard let url = components?.url else { throw GlazeVaultTradeError.invalidConfiguration }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 3)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = false
        request.setValue("no-cache, no-store, max-age=0", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        let response = try await send(request)
        // The deployed infrastructure endpoint may omit the business envelope entirely.
        if let rawCode = response["treatRecommendationPhoto"] {
            guard let code = rawCode as? NSNumber, CFGetTypeID(code) != CFBooleanGetTypeID() else { throw GlazeVaultTradeError.invalidResponse }
            guard code.doubleValue == 0 else {
                throw GlazeVaultTradeError.business(code: code.stringValue, message: response["sweetnessVisitRing"] as? String ?? "Startup failed. Please retry.")
            }
        }
        let routeAppID: String?
        if let text = response["treatWarmDelight"] as? String { routeAppID = text }
        else if let number = response["treatWarmDelight"] as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID() { routeAppID = number.stringValue }
        else { routeAppID = nil }
        // The bootstrap service selects the business address. The Profile address
        // is only the initial configuration, not an allowlist for returned routes.
        // Preserve target as metadata; feature availability comes from its own flag.
        guard routeAppID == profile.bootstrapAppID,
              let target = response["seasonalRingPhoto"] as? String,
              !target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let revision = Self.integer(response["visitFillingCheckin"]), revision > 0,
              let enabled = response["conversationTastingVisit"] as? NSNumber, CFGetTypeID(enabled) == CFBooleanGetTypeID(),
              let apiURL = WevVGlazeVaultPack.secureURL(response["cozySeasonalGlaze"], scheme: "https") else {
            throw GlazeVaultTradeError.invalidConfiguration
        }
        return crumbBioView(apiBaseURL: apiURL,
                                   fullFeaturesEnabled: enabled.boolValue, revision: revision, target: target)
    }

    private func send(_ request: URLRequest) async throws -> [String: Any] {
        try Task.checkCancellation()
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw GlazeVaultTradeError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw GlazeVaultTradeError.http(http.statusCode) }
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw GlazeVaultTradeError.invalidResponse }
        return object
    }

    private static func endpoint(base: URL, path: String, sapi: Bool = false) throws -> URL {
        guard path.hasPrefix("/"), !path.hasPrefix("//"), !path.contains("?"), !path.contains("#"),
              !path.split(separator: "/").contains(".."),
              var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else { throw GlazeVaultTradeError.invalidConfiguration }
        var prefix = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if sapi, path.hasPrefix("/sapi/") {
            let parts = prefix.split(separator: "/")
            if let index = parts.firstIndex(of: "sapi") { prefix = parts[..<index].joined(separator: "/") }
        }
        components.path = (prefix.isEmpty ? "" : "/" + prefix) + path
        components.query = nil
        components.fragment = nil
        guard let url = components.url else { throw GlazeVaultTradeError.invalidConfiguration }
        return url
    }

    private static func business(_ envelope: [String: Any], code: String) -> GlazeVaultTradeError {
        .business(code: code, message: envelope["message"] as? String ?? "The service could not complete the request.")
    }

    private static func integer(_ value: Any?) -> Int? {
        if let number = value as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID(), number.doubleValue.isFinite,
           number.doubleValue.rounded() == number.doubleValue,
           number.doubleValue >= Double(Int.min), number.doubleValue < Double(Int.max) { return number.intValue }
        if let string = value as? String { return Int(string) }
        return nil
    }

    private static func mapFields(_ value: Any, mapping: [String: String]) -> Any {
        if let object = value as? [String: Any] {
            var mapped: [String: Any] = [:]
            for (key, value) in object { mapped[mapping[key] ?? key] = mapFields(value, mapping: mapping) }
            return mapped
        }
        if let array = value as? [Any] { return array.map { mapFields($0, mapping: mapping) } }
        return value
    }

    private static func jsonData(_ value: Any) throws -> Data {
        do { return try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed, .sortedKeys]) }
        catch { throw GlazeVaultTradeError.invalidResponse }
    }

    private static func payload(_ envelope: [String: Any], key: Data, iv: Data) throws -> Any {
        guard let result = envelope["result"] else { throw GlazeVaultTradeError.invalidResponse }
        if let ciphertext = result as? String {
            let plain = try crypt(try unhex(ciphertext), key: key, iv: iv, encrypt: false)
            do { return try JSONSerialization.jsonObject(with: plain, options: [.fragmentsAllowed]) }
            catch { throw GlazeVaultTradeError.invalidResponse }
        }
        // Some endpoints return a structured result directly; never interpret a failure result here.
        return result
    }

    private static func hex(_ data: Data) -> String { data.map { String(format: "%02x", $0) }.joined() }

    private static func unhex(_ string: String) throws -> Data {
        let bytes = Array(string.utf8)
        guard !bytes.isEmpty, bytes.count.isMultiple(of: 2), bytes.count.isMultiple(of: kCCBlockSizeAES128 * 2) else { throw GlazeVaultTradeError.invalidResponse }
        func nibble(_ value: UInt8) -> UInt8? {
            switch value {
            case 48...57: return value - 48
            case 65...70: return value - 55
            case 97...102: return value - 87
            default: return nil
            }
        }
        var data = Data(capacity: bytes.count / 2)
        for i in stride(from: 0, to: bytes.count, by: 2) {
            guard let high = nibble(bytes[i]), let low = nibble(bytes[i + 1]) else { throw GlazeVaultTradeError.invalidResponse }
            data.append(high << 4 | low)
        }
        return data
    }

    private static func crypt(_ input: Data, key: Data, iv: Data, encrypt: Bool) throws -> Data {
        guard key.count == kCCKeySizeAES128, iv.count == kCCBlockSizeAES128 else { throw GlazeVaultTradeError.invalidConfiguration }
        let capacity = input.count + kCCBlockSizeAES128
        var output = Data(count: capacity)
        var count = 0
        let status = output.withUnsafeMutableBytes { outputBuffer in
            input.withUnsafeBytes { inputBuffer in
                key.withUnsafeBytes { keyBuffer in
                    iv.withUnsafeBytes { ivBuffer in
                        CCCrypt(CCOperation(encrypt ? kCCEncrypt : kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding),
                                keyBuffer.baseAddress, key.count, ivBuffer.baseAddress, inputBuffer.baseAddress, input.count,
                                outputBuffer.baseAddress, capacity, &count)
                    }
                }
            }
        }
        guard status == kCCSuccess else { throw GlazeVaultTradeError.invalidResponse }
        output.count = count
        return output
    }
}
