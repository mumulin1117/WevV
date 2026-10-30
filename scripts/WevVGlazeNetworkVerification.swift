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
    nonisolated(unsafe) var bootstrapGate: DispatchSemaphore?
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
        let gate = bootstrapGate
        lock.unlock()
        switch request.url!.path {
        case "/sugary9/crumb/voice":
            if let gate { precondition(gate.wait(timeout: .now() + 5) == .success) }
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
        func parseProfile(_ value: [String: Any]) throws -> activeDonutParlorSection {
            try activeDonutParlorSection(buildTastingJournalPanel: Data(("/*__OPI_PROFILE_START__*/" + String(data: json(value), encoding: .utf8)! + "/*__OPI_PROFILE_END__*/").utf8))
        }
        let profile = try parseProfile(fixture)
        precondition(profile.berryCrumbBakeryNotes == "test" && profile.aromaSpectrumNotes == profile.buildFlavorBackdrop && profile.armGlazeLoadingTimeout == profile.almondFlavor)
        let config = URLSessionConfiguration.ephemeral; config.protocolClasses = [MockProtocol.self]
        let session = URLSession(configuration: config)
        let probe = Probe(); MockProtocol.probe = probe
        func fresh(_ selectedProfile: activeDonutParlorSection? = nil) -> NertyuChoiceStackLayer { NertyuChoiceStackLayer(citrusParlor: selectedProfile ?? profile, bakingScaleStation: "device", brownButterIcing: "1.3", buildWevvBakeryGateCanvas: "en-US", continuation: session) }
        let network = fresh()
        precondition(network.carouselAsset == 0)
        async let a = network.archiveCapacity(); async let b = network.archiveCapacity()
        let routes = try await (a, b)
        precondition(routes.0.cocoaWeekendFestival == 3 && routes.1.bottomOffset)
        precondition(probe.count("/sugary9/crumb/voice") == 1)
        precondition(network.carouselAsset == 0, "Bootstrap cannot create a successful Open revision")
        let routeRequest = probe.last("/sugary9/crumb/voice")
        precondition(routeRequest.timeoutInterval == 3 && routeRequest.value(forHTTPHeaderField: "Authorization") == nil && routeRequest.httpBody == nil && routeRequest.httpShouldHandleCookies == false)
        precondition(routeRequest.httpMethod == "GET" && URLComponents(url: routeRequest.url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: profile.almondFlavor)])
        async let first = network.carnivalGlazeTasting(bottomActionInset: true); async let second = network.carnivalGlazeTasting(bottomActionInset: true)
        _ = try await (first, second)
        precondition(probe.count("/mapped/open") == 1 && network.carouselAsset == 1, "Concurrent Open completion advances revision once")
        _ = try await network.carnivalGlazeTasting()
        precondition(probe.count("/mapped/open") == 1 && network.carouselAsset == 1, "Cached Open cannot advance revision")
        _ = try await network.carnivalGlazeTasting(bottomActionInset: true)
        precondition(probe.count("/mapped/open") == 2 && network.carouselAsset == 2, "Forced Open performs a new request and revision")
        _ = try await network.carnivalGlazeTasting(closeFlavorNoteForm: "account-a")
        precondition(probe.count("/mapped/open") == 3 && network.carouselAsset == 3)
        precondition(probe.last("/mapped/open").value(forHTTPHeaderField: "X-Refresh") == "account-a")
        _ = try await network.carnivalGlazeTasting(closeFlavorNoteForm: "account-a")
        precondition(probe.count("/mapped/open") == 3 && network.carouselAsset == 3)
        _ = try await network.carnivalGlazeTasting(closeFlavorNoteForm: "account-b")
        precondition(probe.count("/mapped/open") == 4 && network.carouselAsset == 4, "Another account cannot reuse a successful Open revision")
        precondition(probe.last("/mapped/open").value(forHTTPHeaderField: "X-Refresh") == "account-b")
        let result = try await network.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json(["value": [["value": 9]]]), activeEnvironmentID: "credential")
        let restored = try JSONSerialization.jsonObject(with: result) as! [String: [[String: Int]]]
        precondition(restored["value"]?.first?["value"] == 7)
        let opiRequest = probe.last("/mapped/business")
        precondition(opiRequest.value(forHTTPHeaderField: "appId") == "fixture" && opiRequest.value(forHTTPHeaderField: "X-App") == "fixture")
        let opiBody = try decodeRequest(opiRequest, base64: false)
        precondition((opiBody["maskedValue"] as? [[String: Int]])?.first?["maskedValue"] == 9)
        do { _ = try await network.challengeDonutWevvButton(chocolateCurlDust: "/unknown", applyVoiceRoomPages: json([:])); fatalError("unmapped accepted") } catch accountGroup.cancelTastingReport(_) {}
        do { _ = try await network.challengeDonutWevvButton(chocolateCurlDust: "/_v2/string-code", applyVoiceRoomPages: json([:])); fatalError("string OPI code accepted") } catch accountGroup.buildPastryDetailContent {}
        do { _ = try await network.challengeDonutWevvButton(chocolateCurlDust: "/_v2/auth", applyVoiceRoomPages: json([:])); fatalError("auth failure accepted") } catch let error as accountGroup { precondition(error.buildPastryScroll) }
        let ticket = try await network.bindFlavorKeyboard(buildWevvBakeryShelfPage: "legacy")
        precondition(ticket.crumbScoreValue == "ticket" && ticket.bindSugarConfirmButtons.timeIntervalSinceNow > 1790)
        let exchangeRequest = probe.last("/sapi/auth/v1/client/auth/exchangeToken")
        precondition(exchangeRequest.value(forHTTPHeaderField: "auth_token") == "" && exchangeRequest.value(forHTTPHeaderField: "appid") == "fixture")
        let exchangeBody = try decodeRequest(exchangeRequest, base64: true)
        precondition(exchangeBody["token"] as? String == "legacy")
        _ = try await network.configureProfileCountLabel(chocolateCurlDust: "/sapi/weidou/v1/client/party/room/list", applyVoiceRoomPages: json([:]), animateSugarToast: ticket.crumbScoreValue)
        do { _ = try await network.configureProfileCountLabel(chocolateCurlDust: "/sapi/numeric", applyVoiceRoomPages: json([:]), animateSugarToast: "ticket"); fatalError("numeric SAPI code accepted") } catch accountGroup.buildPastryDetailContent {}
        let retryNetwork = fresh(); probe.failBootstrap = true
        do { _ = try await retryNetwork.archiveCapacity(); fatalError("failed bootstrap accepted") } catch {}
        _ = try await retryNetwork.archiveCapacity()
        probe.failOpen = true
        do { _ = try await retryNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("failed Open accepted") } catch {}
        precondition(retryNetwork.carouselAsset == 0 && retryNetwork.bakeryStopText == nil, "Business failure cannot advance Open revision")
        _ = try await retryNetwork.carnivalGlazeTasting(bottomActionInset: true)
        precondition(retryNetwork.carouselAsset == 1)
        probe.openHTTPStatus = 503
        do { _ = try await retryNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("HTTP failure accepted") }
        catch accountGroup.brownButterPecanCombination(503) {}
        precondition(retryNetwork.carouselAsset == 1, "HTTP failure cannot advance Open revision")
        probe.malformedOpen = true
        do { _ = try await retryNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("Malformed Open accepted") }
        catch {}
        precondition(retryNetwork.carouselAsset == 1, "Invalid runtime configuration cannot advance Open revision")
        let beforeAccountOpens = probe.count("/mapped/open")
        async let accountA = retryNetwork.carnivalGlazeTasting(closeFlavorNoteForm: "account-a", bottomActionInset: true)
        async let accountB = retryNetwork.carnivalGlazeTasting(closeFlavorNoteForm: "account-b", bottomActionInset: true)
        _ = try await (accountA, accountB)
        precondition(retryNetwork.carouselAsset == 3 && probe.count("/mapped/open") == beforeAccountOpens + 2,
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
        precondition(productionProfile.berryCrumbBakeryNotes == "production" && productionProfile.almondFlavor == "39114002" && productionProfile.armGlazeLoadingTimeout == "39114002")
        probe.routeAppID = "39114002"
        let requestsBefore404 = probe.snapshot().count
        probe.bootstrapHTTPStatus = 404
        let unavailableProductionNetwork = fresh(productionProfile)
        do { _ = try await unavailableProductionNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("production bootstrap HTTP 404 was bypassed") }
        catch accountGroup.brownButterPecanCombination(404) {}
        let failedStartupRequests = Array(probe.snapshot().dropFirst(requestsBefore404))
        precondition(unavailableProductionNetwork.bakeryTasterStore == nil && unavailableProductionNetwork.bakeryStopText == nil)
        precondition(failedStartupRequests.count == 1)
        precondition(failedStartupRequests[0].httpMethod == "GET" && failedStartupRequests[0].url?.host == "gateway.unit.example")
        precondition(failedStartupRequests[0].url?.path == "/sugary9/crumb/voice")
        precondition(URLComponents(url: failedStartupRequests[0].url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: productionProfile.almondFlavor)])
        probe.routeAPIBaseURL = "https://production.unit.example:443/"
        let productionNetwork = fresh(productionProfile)
        _ = try await productionNetwork.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json([:]))
        precondition(probe.last("/sugary9/crumb/voice").url?.host == "gateway.unit.example")
        precondition(probe.last("/mapped/business").url?.host == "production.unit.example")
        for selectedURL in ["https://selected.unit.example", "https://production.unit.example:9443"] {
            probe.routeAPIBaseURL = selectedURL
            let selectedNetwork = fresh(productionProfile)
            _ = try await selectedNetwork.carnivalGlazeTasting(bottomActionInset: true)
            _ = try await selectedNetwork.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json([:]))
            precondition(selectedNetwork.bakeryTasterStore?.almondCutter.absoluteString == selectedURL)
            for path in ["/mapped/open", "/mapped/business"] {
                precondition(probe.last(path).url?.absoluteString == selectedURL + path,
                             "Open and business requests must use the server-selected base")
            }
        }
        probe.routeAPIBaseURL = "https://selected.unit.example/edge"
        let prefixedRoute = try await fresh(productionProfile).archiveCapacity()
        precondition(prefixedRoute.almondCutter.absoluteString == probe.routeAPIBaseURL,
                     "The route may select a business base path as well as a host")
        probe.routeAPIBaseURL = "https://production.unit.example"
        for target in ["SOURCE", "REPLICA", "FUTURE_TARGET"] {
            probe.routeTarget = target
            probe.routeOverrides = ["conversationTastingVisit": false]
            let selectedNetwork = fresh(productionProfile)
            _ = try await selectedNetwork.carnivalGlazeTasting(bottomActionInset: true)
            precondition(selectedNetwork.bakeryTasterStore?.crumbEmptyImage == target && selectedNetwork.bakeryTasterStore?.bottomOffset == false,
                         "Target metadata must not reject a route or override its feature flag")
        }
        probe.routeOverrides = [:]
        probe.routeTarget = "REPLICA"
        let productionOpenCount = probe.count("/mapped/open")
        probe.routeOverrides = ["treatRecommendationPhoto": 17, "sweetnessVisitRing": "route temporarily unavailable"]
        let businessRejected = fresh(productionProfile)
        do { _ = try await businessRejected.carnivalGlazeTasting(bottomActionInset: true); fatalError("startup business failure accepted") }
        catch accountGroup.artisanSelectionShowcase(let code, let message) {
            precondition(code == "17" && message == "route temporarily unavailable")
        }
        precondition(businessRejected.bakeryTasterStore == nil && businessRejected.bakeryStopText == nil && probe.count("/mapped/open") == productionOpenCount)
        for invalidCode: Any in ["0", true, NSNull()] {
            probe.routeOverrides = ["treatRecommendationPhoto": invalidCode]
            let rejectedNetwork = fresh(productionProfile)
            do { _ = try await rejectedNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("invalid startup code type accepted") }
            catch accountGroup.buildPastryDetailContent {}
            precondition(rejectedNetwork.bakeryTasterStore == nil && rejectedNetwork.bakeryStopText == nil && probe.count("/mapped/open") == productionOpenCount)
        }
        let invalidRoutes: [[String: Any]] = [
            ["treatWarmDelight": "12211334"], ["treatWarmDelight": true],
            ["visitFillingCheckin": 0], ["visitFillingCheckin": false],
            ["conversationTastingVisit": 1], ["conversationTastingVisit": "true"],
            ["cozySeasonalGlaze": "http://production.unit.example"],
            ["cozySeasonalGlaze": "https://user:password@production.unit.example"],
            ["cozySeasonalGlaze": "https://production.unit.example?token=invalid"],
            ["cozySeasonalGlaze": "https://production.unit.example#invalid"],
            ["cozySeasonalGlaze": ""], ["cozySeasonalGlaze": NSNull()],
            ["seasonalRingPhoto": ""], ["seasonalRingPhoto": " \n "], ["seasonalRingPhoto": 1],
            ["seasonalRingPhoto": NSNull(), "profileIdentityGentle": "REPLICA"]
        ]
        for overrides in invalidRoutes {
            probe.routeOverrides = overrides
            let rejectedNetwork = fresh(productionProfile)
            do { _ = try await rejectedNetwork.carnivalGlazeTasting(bottomActionInset: true); fatalError("invalid startup route accepted") }
            catch accountGroup.buildPastryBackdrop {}
            precondition(rejectedNetwork.bakeryTasterStore == nil && rejectedNetwork.bakeryStopText == nil && probe.count("/mapped/open") == productionOpenCount)
        }
        probe.routeOverrides = ["treatRecommendationPhoto": 0, "conversationTastingVisit": false]
        let limitedRoute = try await fresh(productionProfile).archiveCapacity()
        precondition(!limitedRoute.bottomOffset && limitedRoute.almondCutter == productionProfile.buildFlavorBackdrop)
        probe.routeOverrides = [:]
        let changingRouteNetwork = fresh(productionProfile)
        _ = try await changingRouteNetwork.carnivalGlazeTasting(bottomActionInset: true)
        probe.routeAPIBaseURL = "https://changed.unit.example"
        probe.routeOverrides = ["visitFillingCheckin": 4]
        _ = try await changingRouteNetwork.archiveCapacity(bottomActionInset: true)
        precondition(changingRouteNetwork.bakeryStopText == nil, "A new route invalidates the previous Open")
        _ = try await changingRouteNetwork.carnivalGlazeTasting()
        precondition(probe.last("/mapped/open").url?.host == "changed.unit.example")
        let opensBeforeRevision = probe.count("/mapped/open")
        probe.routeOverrides = ["visitFillingCheckin": 5]
        _ = try await changingRouteNetwork.archiveCapacity(bottomActionInset: true)
        precondition(changingRouteNetwork.bakeryStopText == nil, "A new revision invalidates Open even at the same address")
        _ = try await changingRouteNetwork.carnivalGlazeTasting()
        precondition(probe.count("/mapped/open") == opensBeforeRevision + 1)
        probe.routeOverrides = [:]
        for invalidEnvironment: Any in ["staging", 1, NSNull()] {
            var invalidFixture = productionFixture
            var invalidServices = productionServices
            invalidServices["environment"] = invalidEnvironment
            invalidFixture["services"] = invalidServices
            do { _ = try parseProfile(invalidFixture); fatalError("invalid environment accepted") }
            catch accountGroup.buildPastryBackdrop {}
        }
        var invalidBootstrapFixture = productionFixture
        var invalidBootstrapServices = productionServices
        invalidBootstrapServices["bootstrapBaseUrl"] = "http://gateway.unit.example"
        invalidBootstrapFixture["services"] = invalidBootstrapServices
        do { _ = try parseProfile(invalidBootstrapFixture); fatalError("insecure explicit bootstrap silently fell back") }
        catch accountGroup.buildPastryBackdrop {}
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
        precondition(splitProfile.almondFlavor == "production-fixture" && splitProfile.armGlazeLoadingTimeout == "fixture")
        probe.routeAppID = "fixture"
        probe.routeAPIBaseURL = "https://unit.example"
        let splitRequestStart = probe.snapshot().count
        let splitNetwork = fresh(splitProfile)
        _ = try await splitNetwork.carnivalGlazeTasting(bottomActionInset: true)
        let splitResult = try await splitNetwork.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json(["value": 9]))
        let splitRestored = try JSONSerialization.jsonObject(with: splitResult) as! [String: Int]
        precondition(splitRestored["value"] == 7 && splitNetwork.bakeryTasterStore?.almondCutter.absoluteString == probe.routeAPIBaseURL)
        let splitRequests = Array(probe.snapshot().dropFirst(splitRequestStart))
        precondition(splitRequests.count == 3 && splitRequests[0].url?.host == "gateway.unit.example")
        precondition(URLComponents(url: splitRequests[0].url!, resolvingAgainstBaseURL: false)?.queryItems == [URLQueryItem(name: "treatWarmDelight", value: "fixture")])
        precondition(splitRequests.dropFirst().allSatisfy {
            $0.url?.host == "unit.example"
                && $0.value(forHTTPHeaderField: "appId") == "production-fixture"
                && $0.value(forHTTPHeaderField: "X-Production-App") == "production-fixture"
        })
        precondition(splitRequests[1].url?.path == "/production/open" && splitRequests[2].url?.path == "/production/business")
        let splitBusinessBody = try decodeRequest(splitRequests[2], base64: false)
        precondition(splitBusinessBody["productionValue"] as? Int == 9)
        probe.routeAppID = "production-fixture"
        let splitRejected = fresh(splitProfile)
        do { _ = try await splitRejected.carnivalGlazeTasting(bottomActionInset: true); fatalError("startup response matched business ID instead of configured startup ID") }
        catch accountGroup.buildPastryBackdrop {}
        precondition(splitRejected.bakeryTasterStore == nil && splitRejected.bakeryStopText == nil)
        for invalidID: Any in ["", " ", 1, NSNull()] {
            var invalidFixture = splitFixture
            var invalidServices = splitServices
            invalidServices["bootstrapAppId"] = invalidID
            invalidFixture["services"] = invalidServices
            do { _ = try parseProfile(invalidFixture); fatalError("invalid bootstrap identity accepted") }
            catch accountGroup.buildPastryBackdrop {}
        }
        probe.routeAppID = "fixture"
        probe.routeAPIBaseURL = "https://unit.example"
        probe.routeOverrides = [:]
        let waitingNetwork = fresh()
        let gate = DispatchSemaphore(value: 0)
        probe.bootstrapGate = gate
        let initialRouteCalls = probe.count("/sugary9/crumb/voice")
        let initialBusinessCalls = probe.count("/mapped/business")
        let pending = Task { try await waitingNetwork.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json([:]), activeEnvironmentID: "departing-token") }
        for _ in 0..<10000 {
            if probe.count("/sugary9/crumb/voice") > initialRouteCalls { break }
            await Task.yield()
        }
        precondition(probe.count("/sugary9/crumb/voice") == initialRouteCalls + 1)
        waitingNetwork.bakeryDayDots()
        gate.signal()
        do { _ = try await pending.value; fatalError("departing token was sent after session cleanup") }
        catch is CancellationError {}
        precondition(probe.count("/mapped/business") == initialBusinessCalls,
                     "a request waiting for startup cannot send its old Authorization after logout")
        probe.bootstrapGate = nil
        _ = try await waitingNetwork.challengeDonutWevvButton(chocolateCurlDust: "/_v2/business", applyVoiceRoomPages: json([:]))
        precondition(probe.last("/mapped/business").value(forHTTPHeaderField: "Authorization") == nil
                     && probe.last("/mapped/business").value(forHTTPHeaderField: "X-Refresh") == nil,
                     "new anonymous requests cannot inherit the departing user's credentials")
        print("PASS: obfuscated bootstrap contract, server-selected HTTPS business routes, independent startup/business identity, SOURCE/REPLICA metadata, preserved false feature flag, route/revision Open invalidation, request isolation, concurrency, recursive aliases, Hex/Base64 separation, strict code/flag types, auth failures, SAPI prefix/default expiry, retry, account-separated Open, HTTP/business/invalid route failures without Open/fallback, split startup/business compatibility, environment validation, logout pre-send credential isolation")
        session.invalidateAndCancel()
    }
}
