import Foundation
import CommonCrypto

nonisolated func cipher(_ input: Data, encrypt: Bool) throws -> Data {
    let key = Data("0123456789abcdef".utf8), iv = Data("fedcba9876543210".utf8)
    var out = Data(count: input.count + 16), n = 0
    let capacity = out.count
    let status = out.withUnsafeMutableBytes { o in input.withUnsafeBytes { d in key.withUnsafeBytes { k in iv.withUnsafeBytes { v in
        CCCrypt(CCOperation(encrypt ? kCCEncrypt : kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), k.baseAddress, 16, v.baseAddress, d.baseAddress, input.count, o.baseAddress, capacity, &n)
    } } } }
    guard status == kCCSuccess else { throw NSError(domain: "test", code: 1) }
    out.count = n; return out
}
nonisolated func json(_ value: Any) throws -> Data { try JSONSerialization.data(withJSONObject: value) }
nonisolated func envelope(_ value: Any, code: Any = 0) throws -> Data {
    let encrypted = try cipher(json(value), encrypt: true)
    return try json(["code": code, "result": encrypted.map { String(format: "%02x", $0) }.joined()])
}
nonisolated func decodeRequest(_ request: URLRequest, base64: Bool) throws -> [String: Any] {
    let text = String(data: request.httpBody!, encoding: .utf8)!
    let encrypted: Data
    if base64 { encrypted = Data(base64Encoded: text)! }
    else {
        let bytes = Array(text); encrypted = Data(stride(from: 0, to: bytes.count, by: 2).map { UInt8(String(bytes[$0...$0+1]), radix: 16)! })
    }
    return try JSONSerialization.jsonObject(with: cipher(encrypted, encrypt: false)) as! [String: Any]
}
final class Probe: @unchecked Sendable {
    let lock = NSLock()
    nonisolated(unsafe) var requests: [URLRequest] = []
    nonisolated(unsafe) var failBootstrap = false
    nonisolated(unsafe) var failOpen = false
    nonisolated(unsafe) var malformedOpen = false
    nonisolated(unsafe) var openHTTPStatus: Int?
    nonisolated(unsafe) var routeAPIBaseURL = "https://unit.example"
    nonisolated(unsafe) var routeAppID = "fixture"
    nonisolated(unsafe) var routeTarget = "REPLICA"
    nonisolated(unsafe) var routeOverrides: [String: Any] = [:]
    nonisolated(unsafe) var bootstrapHTTPStatus: Int?
    nonisolated func statusCode(_ request: URLRequest) -> Int {
        lock.lock(); defer { lock.unlock() }
        if request.url?.path == "/sugary9/crumb/voice", let status = bootstrapHTTPStatus {
            bootstrapHTTPStatus = nil
            return status
        }
        if let path = request.url?.path, ["/mapped/open", "/production/open"].contains(path), let status = openHTTPStatus {
            openHTTPStatus = nil
            return status
        }
        return 200
    }
    nonisolated func respond(_ request: URLRequest) throws -> Data {
        lock.lock(); requests.append(request)
        let routeFailure = failBootstrap; failBootstrap = false
        let openFailure = failOpen, invalidOpen = malformedOpen
        if ["/mapped/open", "/production/open"].contains(request.url!.path) { failOpen = false; malformedOpen = false }
        let apiBaseURL = routeAPIBaseURL, target = routeTarget, appID = routeAppID, overrides = routeOverrides
        lock.unlock()
        switch request.url!.path {
        case "/sugary9/crumb/voice":
            if routeFailure { return try json(["treatRecommendationPhoto": 5]) }
            var value: [String: Any] = ["treatWarmDelight": appID, "seasonalRingPhoto": target, "visitFillingCheckin": 3, "cozySeasonalGlaze": apiBaseURL, "conversationTastingVisit": true]
            value.merge(overrides) { _, replacement in replacement }
            return try json(value)
        case "/mapped/open", "/production/open":
            if openFailure { return try json(["code": 503, "message": "retry"]) }
            if invalidOpen { return try envelope(["runtimeConfig": [:]]) }
            Thread.sleep(forTimeInterval: 0.04)
            return try envelope(["runtimeConfig": ["imAppKey": String(repeating: "a", count: 32), "rtcAppId": String(repeating: "b", count: 32), "noticeAccount": "notice", "sapiBaseUrl": "https://unit.example/sapi", "socketUrl": "wss://unit.example", "sapiAesKey": "0123456789abcdef", "sapiAesIv": "fedcba9876543210"], "cdnDomainConfig": "{}"])
        case "/mapped/business": return try envelope(["maskedValue": [["maskedValue": 7]]])
        case "/production/business": return try envelope(["productionValue": 7])
        case "/mapped/string-code": return try envelope([:], code: "0")
        case "/mapped/auth": return try json(["code": 40101, "message": "expired", "result": "not-hex"])
        case "/sapi/auth/v1/client/auth/exchangeToken":
            return try envelope(["tokenValue": "ticket", "tokenTimeout": 0], code: "200")
        case "/sapi/weidou/v1/client/party/room/list": return try envelope(["list": [["roomId": 1]]], code: "200")
        case "/sapi/numeric": return try envelope([:], code: 200)
        default: throw NSError(domain: "unexpected endpoint", code: 2)
        }
    }
    nonisolated func count(_ path: String) -> Int { lock.lock(); defer { lock.unlock() }; return requests.filter { $0.url?.path == path }.count }
    nonisolated func last(_ path: String) -> URLRequest { lock.lock(); defer { lock.unlock() }; return requests.last { $0.url?.path == path }! }
    nonisolated func snapshot() -> [URLRequest] { lock.lock(); defer { lock.unlock() }; return requests }
}
final class MockProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var probe: Probe!
    nonisolated override class func canInit(with request: URLRequest) -> Bool { true }
    nonisolated override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    nonisolated override func startLoading() {
        do {
            var captured = request
            if captured.httpBody == nil, let stream = captured.httpBodyStream {
                stream.open(); defer { stream.close() }
                var body = Data(); var bytes = [UInt8](repeating: 0, count: 4096)
                while stream.hasBytesAvailable { let count = stream.read(&bytes, maxLength: bytes.count); if count <= 0 { break }; body.append(contentsOf: bytes.prefix(count)) }
                captured.httpBody = body
            }
            let statusCode = Self.probe.statusCode(captured)
            let data = try Self.probe.respond(captured)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch { client?.urlProtocol(self, didFailWithError: error) }
    }
    nonisolated override func stopLoading() {}
}
@main struct NetworkVerification {
    @MainActor static func main() async throws {
        let fixture: [String: Any] = ["services": ["apiBaseUrl": "https://unit.example", "apiClient": ["appId": "fixture", "appVersion": "1.3", "protocol": "opi-v2-aes", "encryptionKey": "0123456789abcdef", "encryptionIv": "fedcba9876543210"]], "aliases": ["path": ["/_v2/config/open": "/mapped/open", "/_v2/business": "/mapped/business", "/_v2/string-code": "/mapped/string-code", "/_v2/auth": "/mapped/auth"], "field": ["value": "maskedValue"], "header": ["appId": "X-App", "deviceNo": "X-Device", "appVersion": "X-Version", "language": "X-Language", "refreshToken": "X-Refresh"]]]
        func parseProfile(_ value: [String: Any]) throws -> WevVGlazeOPIProfile {
            try WevVGlazeOPIProfile(javaScript: Data(("/*__OPI_PROFILE_START__*/" + String(data: json(value), encoding: .utf8)! + "/*__OPI_PROFILE_END__*/").utf8))
        }
        let profile = try parseProfile(fixture)
        precondition(profile.environment == "test" && profile.bootstrapBaseURL == profile.initialBaseURL && profile.bootstrapAppID == profile.appID)
        let config = URLSessionConfiguration.ephemeral; config.protocolClasses = [MockProtocol.self]
        let session = URLSession(configuration: config)
        let probe = Probe(); MockProtocol.probe = probe
        func fresh(_ selectedProfile: WevVGlazeOPIProfile? = nil) -> WevVGlazeNetworkFoundation { WevVGlazeNetworkFoundation(profile: selectedProfile ?? profile, deviceNo: "device", hostVersion: "1.3", language: "en-US", session: session) }
        let network = fresh()
        precondition(network.openRevision == 0)
        async let a = network.bootstrap(); async let b = network.bootstrap()
        let routes = try await (a, b)
        precondition(routes.0.revision == 3 && routes.1.fullFeaturesEnabled)
        precondition(probe.count("/sugary9/crumb/voice") == 1)
        precondition(network.openRevision == 0, "Bootstrap cannot create a successful Open revision")
        let routeRequest = probe.last("/sugary9/crumb/voice")
        precondition(routeRequest.timeoutInterval == 3 && routeRequest.value(forHTTPHeaderField: "Authorization") == nil && routeRequest.httpBody == nil && routeRequest.httpShouldHandleCookies == false)
        precondition(routeRequest.httpMethod == "GET" && URLComponents(url: routeRequest.url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: profile.appID)])
        async let first = network.open(force: true); async let second = network.open(force: true)
        _ = try await (first, second)
        precondition(probe.count("/mapped/open") == 1 && network.openRevision == 1, "Concurrent Open completion advances revision once")
        _ = try await network.open()
        precondition(probe.count("/mapped/open") == 1 && network.openRevision == 1, "Cached Open cannot advance revision")
        _ = try await network.open(force: true)
        precondition(probe.count("/mapped/open") == 2 && network.openRevision == 2, "Forced Open performs a new request and revision")
        _ = try await network.open(refreshToken: "account-a")
        precondition(probe.count("/mapped/open") == 3 && network.openRevision == 3)
        precondition(probe.last("/mapped/open").value(forHTTPHeaderField: "X-Refresh") == "account-a")
        _ = try await network.open(refreshToken: "account-a")
        precondition(probe.count("/mapped/open") == 3 && network.openRevision == 3)
        _ = try await network.open(refreshToken: "account-b")
        precondition(probe.count("/mapped/open") == 4 && network.openRevision == 4, "Another account cannot reuse a successful Open revision")
        precondition(probe.last("/mapped/open").value(forHTTPHeaderField: "X-Refresh") == "account-b")
        let result = try await network.opi(path: "/_v2/business", body: json(["value": [["value": 9]]]), accessToken: "credential")
        let restored = try JSONSerialization.jsonObject(with: result) as! [String: [[String: Int]]]
        precondition(restored["value"]?.first?["value"] == 7)
        let opiRequest = probe.last("/mapped/business")
        precondition(opiRequest.value(forHTTPHeaderField: "appId") == "fixture" && opiRequest.value(forHTTPHeaderField: "X-App") == "fixture")
        let opiBody = try decodeRequest(opiRequest, base64: false)
        precondition((opiBody["maskedValue"] as? [[String: Int]])?.first?["maskedValue"] == 9)
        do { _ = try await network.opi(path: "/unknown", body: json([:])); fatalError("unmapped accepted") } catch WevVGlazeNetworkError.missingContract(_) {}
        do { _ = try await network.opi(path: "/_v2/string-code", body: json([:])); fatalError("string OPI code accepted") } catch WevVGlazeNetworkError.invalidResponse {}
        do { _ = try await network.opi(path: "/_v2/auth", body: json([:])); fatalError("auth failure accepted") } catch let error as WevVGlazeNetworkError { precondition(error.isAuthenticationFailure) }
        let ticket = try await network.exchange(legacyToken: "legacy")
        precondition(ticket.tokenValue == "ticket" && ticket.expiresAt.timeIntervalSinceNow > 1790)
        let exchangeRequest = probe.last("/sapi/auth/v1/client/auth/exchangeToken")
        precondition(exchangeRequest.value(forHTTPHeaderField: "auth_token") == "" && exchangeRequest.value(forHTTPHeaderField: "appid") == "fixture")
        let exchangeBody = try decodeRequest(exchangeRequest, base64: true)
        precondition(exchangeBody["token"] as? String == "legacy")
        _ = try await network.sapi(path: "/sapi/weidou/v1/client/party/room/list", body: json([:]), authToken: ticket.tokenValue)
        do { _ = try await network.sapi(path: "/sapi/numeric", body: json([:]), authToken: "ticket"); fatalError("numeric SAPI code accepted") } catch WevVGlazeNetworkError.invalidResponse {}
        let retryNetwork = fresh(); probe.failBootstrap = true
        do { _ = try await retryNetwork.bootstrap(); fatalError("failed bootstrap accepted") } catch {}
        _ = try await retryNetwork.bootstrap()
        probe.failOpen = true
        do { _ = try await retryNetwork.open(force: true); fatalError("failed Open accepted") } catch {}
        precondition(retryNetwork.openRevision == 0 && retryNetwork.currentOpen == nil, "Business failure cannot advance Open revision")
        _ = try await retryNetwork.open(force: true)
        precondition(retryNetwork.openRevision == 1)
        probe.openHTTPStatus = 503
        do { _ = try await retryNetwork.open(force: true); fatalError("HTTP failure accepted") }
        catch WevVGlazeNetworkError.http(503) {}
        precondition(retryNetwork.openRevision == 1, "HTTP failure cannot advance Open revision")
        probe.malformedOpen = true
        do { _ = try await retryNetwork.open(force: true); fatalError("Malformed Open accepted") }
        catch {}
        precondition(retryNetwork.openRevision == 1, "Invalid runtime configuration cannot advance Open revision")
        let beforeAccountOpens = probe.count("/mapped/open")
        async let accountA = retryNetwork.open(refreshToken: "account-a", force: true)
        async let accountB = retryNetwork.open(refreshToken: "account-b", force: true)
        _ = try await (accountA, accountB)
        precondition(retryNetwork.openRevision == 3 && probe.count("/mapped/open") == beforeAccountOpens + 2,
                     "Concurrent different accounts require distinct successful Opens")
        var productionFixture = fixture
        var productionServices = fixture["services"] as! [String: Any]
        productionServices["environment"] = "production"
        productionServices["apiBaseUrl"] = "https://production.unit.example"
        productionServices["bootstrapBaseUrl"] = "https://gateway.unit.example"
        var productionClient = productionServices["apiClient"] as! [String: Any]
        productionClient["appId"] = "39114002"
        productionServices["apiClient"] = productionClient
        productionFixture["services"] = productionServices
        let productionProfile = try parseProfile(productionFixture)
        precondition(productionProfile.environment == "production" && productionProfile.appID == "39114002" && productionProfile.bootstrapAppID == "39114002")
        probe.routeAppID = "39114002"
        let requestsBefore404 = probe.snapshot().count
        probe.bootstrapHTTPStatus = 404
        let unavailableProductionNetwork = fresh(productionProfile)
        do { _ = try await unavailableProductionNetwork.open(force: true); fatalError("production bootstrap HTTP 404 was bypassed") }
        catch WevVGlazeNetworkError.http(404) {}
        let failedStartupRequests = Array(probe.snapshot().dropFirst(requestsBefore404))
        precondition(unavailableProductionNetwork.currentRoute == nil && unavailableProductionNetwork.currentOpen == nil)
        precondition(failedStartupRequests.count == 1)
        precondition(failedStartupRequests[0].httpMethod == "GET" && failedStartupRequests[0].url?.host == "gateway.unit.example")
        precondition(failedStartupRequests[0].url?.path == "/sugary9/crumb/voice")
        precondition(URLComponents(url: failedStartupRequests[0].url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: productionProfile.appID)])
        probe.routeAPIBaseURL = "https://production.unit.example:443/"
        let productionNetwork = fresh(productionProfile)
        _ = try await productionNetwork.opi(path: "/_v2/business", body: json([:]))
        precondition(probe.last("/sugary9/crumb/voice").url?.host == "gateway.unit.example")
        precondition(probe.last("/mapped/business").url?.host == "production.unit.example")
        let businessCount = probe.count("/mapped/business")
        for invalidURL in ["https://unit.example", "https://production.unit.example:9443", "https://production.unit.example/other"] {
            probe.routeAPIBaseURL = invalidURL
            let rejectedNetwork = fresh(productionProfile)
            do { _ = try await rejectedNetwork.opi(path: "/_v2/business", body: json([:])); fatalError("production accepted an unconfigured API base") }
            catch WevVGlazeNetworkError.invalidConfiguration {}
            precondition(rejectedNetwork.currentRoute == nil && probe.count("/mapped/business") == businessCount)
        }
        probe.routeAPIBaseURL = "https://production.unit.example"
        probe.routeTarget = "PRODUCTION"
        do { _ = try await fresh(productionProfile).bootstrap(); fatalError("undocumented startup target accepted") }
        catch WevVGlazeNetworkError.invalidConfiguration {}
        probe.routeTarget = "REPLICA"
        let productionOpenCount = probe.count("/mapped/open")
        probe.routeOverrides = ["treatRecommendationPhoto": 17, "sweetnessVisitRing": "route temporarily unavailable"]
        let businessRejected = fresh(productionProfile)
        do { _ = try await businessRejected.open(force: true); fatalError("startup business failure accepted") }
        catch WevVGlazeNetworkError.business(let code, let message) {
            precondition(code == "17" && message == "route temporarily unavailable")
        }
        precondition(businessRejected.currentRoute == nil && businessRejected.currentOpen == nil && probe.count("/mapped/open") == productionOpenCount)
        for invalidCode: Any in ["0", true, NSNull()] {
            probe.routeOverrides = ["treatRecommendationPhoto": invalidCode]
            let rejectedNetwork = fresh(productionProfile)
            do { _ = try await rejectedNetwork.open(force: true); fatalError("invalid startup code type accepted") }
            catch WevVGlazeNetworkError.invalidResponse {}
            precondition(rejectedNetwork.currentRoute == nil && rejectedNetwork.currentOpen == nil && probe.count("/mapped/open") == productionOpenCount)
        }
        let invalidRoutes: [[String: Any]] = [
            ["treatWarmDelight": "12211334"], ["treatWarmDelight": true],
            ["visitFillingCheckin": 0], ["visitFillingCheckin": false],
            ["conversationTastingVisit": 1], ["conversationTastingVisit": "true"],
            ["cozySeasonalGlaze": "http://production.unit.example"],
            ["seasonalRingPhoto": NSNull(), "profileIdentityGentle": "REPLICA"]
        ]
        for overrides in invalidRoutes {
            probe.routeOverrides = overrides
            let rejectedNetwork = fresh(productionProfile)
            do { _ = try await rejectedNetwork.open(force: true); fatalError("invalid startup route accepted") }
            catch WevVGlazeNetworkError.invalidConfiguration {}
            precondition(rejectedNetwork.currentRoute == nil && rejectedNetwork.currentOpen == nil && probe.count("/mapped/open") == productionOpenCount)
        }
        probe.routeOverrides = ["treatRecommendationPhoto": 0, "conversationTastingVisit": false]
        let limitedRoute = try await fresh(productionProfile).bootstrap()
        precondition(!limitedRoute.fullFeaturesEnabled && limitedRoute.apiBaseURL == productionProfile.initialBaseURL)
        probe.routeOverrides = [:]
        for invalidEnvironment: Any in ["staging", 1, NSNull()] {
            var invalidFixture = productionFixture
            var invalidServices = productionServices
            invalidServices["environment"] = invalidEnvironment
            invalidFixture["services"] = invalidServices
            do { _ = try parseProfile(invalidFixture); fatalError("invalid environment accepted") }
            catch WevVGlazeNetworkError.invalidConfiguration {}
        }
        var invalidBootstrapFixture = productionFixture
        var invalidBootstrapServices = productionServices
        invalidBootstrapServices["bootstrapBaseUrl"] = "http://gateway.unit.example"
        invalidBootstrapFixture["services"] = invalidBootstrapServices
        do { _ = try parseProfile(invalidBootstrapFixture); fatalError("insecure explicit bootstrap silently fell back") }
        catch WevVGlazeNetworkError.invalidConfiguration {}
        var splitFixture = productionFixture
        var splitServices = productionServices
        var splitClient = splitServices["apiClient"] as! [String: Any]
        splitClient["appId"] = "production-fixture"
        splitServices["apiClient"] = splitClient
        splitServices["bootstrapAppId"] = "fixture"
        splitFixture["services"] = splitServices
        var splitAliases = fixture["aliases"] as! [String: Any]
        splitAliases["path"] = ["/_v2/config/open": "/production/open", "/_v2/business": "/production/business"]
        splitAliases["field"] = ["value": "productionValue"]
        var splitHeaders = splitAliases["header"] as! [String: String]
        splitHeaders["appId"] = "X-Production-App"
        splitAliases["header"] = splitHeaders
        splitFixture["aliases"] = splitAliases
        let splitProfile = try parseProfile(splitFixture)
        precondition(splitProfile.appID == "production-fixture" && splitProfile.bootstrapAppID == "fixture")
        probe.routeAppID = "fixture"
        probe.routeAPIBaseURL = "https://unit.example"
        let splitRequestStart = probe.snapshot().count
        let splitNetwork = fresh(splitProfile)
        _ = try await splitNetwork.open(force: true)
        let splitResult = try await splitNetwork.opi(path: "/_v2/business", body: json(["value": 9]))
        let splitRestored = try JSONSerialization.jsonObject(with: splitResult) as! [String: Int]
        precondition(splitRestored["value"] == 7 && splitNetwork.currentRoute?.apiBaseURL == splitProfile.initialBaseURL)
        let splitRequests = Array(probe.snapshot().dropFirst(splitRequestStart))
        precondition(splitRequests.count == 3 && splitRequests[0].url?.host == "gateway.unit.example")
        precondition(URLComponents(url: splitRequests[0].url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: "fixture")])
        precondition(splitRequests.dropFirst().allSatisfy {
            $0.url?.host == "production.unit.example"
                && $0.value(forHTTPHeaderField: "appId") == "production-fixture"
                && $0.value(forHTTPHeaderField: "X-Production-App") == "production-fixture"
        })
        precondition(splitRequests[1].url?.path == "/production/open" && splitRequests[2].url?.path == "/production/business")
        let splitBusinessBody = try decodeRequest(splitRequests[2], base64: false)
        precondition(splitBusinessBody["productionValue"] as? Int == 9)
        probe.routeAppID = "production-fixture"
        let splitRejected = fresh(splitProfile)
        do { _ = try await splitRejected.open(force: true); fatalError("startup response matched business ID instead of configured startup ID") }
        catch WevVGlazeNetworkError.invalidConfiguration {}
        precondition(splitRejected.currentRoute == nil && splitRejected.currentOpen == nil)
        for invalidID: Any in ["", " ", 1, NSNull()] {
            var invalidFixture = splitFixture
            var invalidServices = splitServices
            invalidServices["bootstrapAppId"] = invalidID
            invalidFixture["services"] = invalidServices
            do { _ = try parseProfile(invalidFixture); fatalError("invalid bootstrap identity accepted") }
            catch WevVGlazeNetworkError.invalidConfiguration {}
        }
        print("PASS: new obfuscated bootstrap contract, formal 39114002 startup/business identity, request isolation, concurrency, recursive aliases, Hex/Base64 separation, strict code/flag types, auth failures, SAPI prefix/default expiry, retry, account-separated Open, production bootstrap separation/API pinning, HTTP/business/invalid route failures without Open/fallback, split startup/business compatibility, environment validation")
        session.invalidateAndCancel()
    }
}
