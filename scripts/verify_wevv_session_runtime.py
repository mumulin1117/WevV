#!/usr/bin/env python3
"""Offline session regressions using production Swift sources and controlled I/O.

No application defaults, Keychain, network endpoint or real credentials are used.
Each scenario runs in a fresh process so production singleton lifetime is preserved.
"""
from wevv_swift_source import STRING_HELPER, SUPPORT_SOURCES
from pathlib import Path
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "WevSweetgd/WevSweetgd"


def declaration(text, marker):
    first = text.index(marker)
    opening = text.index("{", first)
    depth = 0
    for offset in range(opening, len(text)):
        if text[offset] == "{":
            depth += 1
        elif text[offset] == "}":
            depth -= 1
            if depth == 0:
                return text[first:offset + 1]
    raise ValueError("Missing Swift declaration boundary: " + marker)


MOCK_IO = r'''
import Foundation
extension Notification.Name { static let bakeryTrailMap = Notification.Name("OfflineProfileChanged") }
struct tastingPassportEdition {
    let glazeNotebookEdition: String; let rainbowSprinkleDesign: String
    let flavorMenuGuide: String; let tastingTrayNotes: String; let glazeSheenIndex: TimeInterval
}
final class TestDefaults {
    static let shared = TestDefaults()
    var values: [String: Any] = [:]
    func set(_ value: Any, forKey key: String) { values[key] = value }
    func bool(forKey key: String) -> Bool { values[key] as? Bool ?? false }
    func removeObject(forKey key: String) { values.removeValue(forKey: key) }
    func stringArray(forKey key: String) -> [String]? { values[key] as? [String] }
}
enum glazeGalleryGuide {
    static var packets: [String: String] = [:]
    static var legacyPacket: String?
    static func cocoaRaspberryMedley() { legacyPacket = nil }
    static var refuseWrite = false
    static func firstBiteArchive() -> String { "offline-device" }
    static func sweetKeepsakeEntry(scope: String) -> String? { packets[scope] }
    static func pastryDiaryCollection(_ packet: String, scope: String) throws {
        if refuseWrite { throw accountGroup.buildPastryBackdrop }
        packets[scope] = packet
    }
    @discardableResult static func cocoaRaspberryMedley(scope: String) -> Bool {
        packets.removeValue(forKey: scope)
        return true
    }
}
@MainActor enum OfflineProfileSelection {
    static var environment = "test"
    static var appID = "12211334"
    static var bootstrapAppID = "12211334"
    static var apiBaseURL = URL(string: "https://test.invalid")!
    static var selectedAPIBaseURL: URL?
}
@MainActor struct activeDonutParlorSection {
    let almondFlavor = OfflineProfileSelection.appID
    let armGlazeLoadingTimeout = OfflineProfileSelection.bootstrapAppID
    let berryCrumbBakeryNotes = OfflineProfileSelection.environment
    let buildFlavorBackdrop = OfflineProfileSelection.apiBaseURL
}
@MainActor struct CreamRingDellController {
    let cherryCenter = activeDonutParlorSection()
    init(cocoaWeekendFestival: String, blushDrizzleDetail: String) throws {}
}
enum UKGlazeActortroller { static let glazeArchiveConfigurationSeed = "offline-seed" }
@MainActor final class WevVpastelBackdropGalleryler {
    static let citrusPeelGarnish = WevVpastelBackdropGalleryler()
    func cocoaRaspberryMedley(batterWhiskEssentials: Data, blackberryCream: String, buildTastingParlorPanel: String) async throws -> String {
        throw accountGroup.cancelTastingReport("offline media boundary")
    }
}
@MainActor struct bakeryShelfDetails {
    let almondCutter: URL
    let bottomOffset = true
}
@MainActor struct basefillingSample {
    let configureTastingParlorShelfButton = URL(string: "https://test.invalid/sapi")!
    let configureTastingJournalShelfButton = "offline-only-key"
    let configureTastingButton = "offline-only-iv"
    let bakingSceneFrame: [String: Any]
    init(bakingSceneFrame: [String: Any]) throws { self.bakingSceneFrame = bakingSceneFrame }
}
@MainActor struct batterConsistencyDetail {
    let configureProfileCardCountLabel: basefillingSample
    let bakeryAtlasCarousel: String?
    let activeEnvironmentID: String?
    let biteNoteLabel: Int?
}
@MainActor struct batterConsistencyStudy { let crumbScoreValue: String; let bindSugarConfirmButtons: Date }
@MainActor final class Gate {
    private var continuation: CheckedContinuation<Data, Error>?
    private(set) var entered = false
    func wait() async throws -> Data {
        entered = true
        return try await withCheckedThrowingContinuation { continuation = $0 }
    }
    func succeed(_ data: Data) { continuation!.resume(returning: data); continuation = nil }
    func fail(_ error: Error) { continuation!.resume(throwing: error); continuation = nil }
}
@MainActor final class NertyuChoiceStackLayer {
    struct Call { let chocolateCurlDust: String; let crumbScoreRow: String?; let applyVoiceRoomPages: Data }
    static var handler: ((String, Data, String?) async throws -> Data)?
    static var calls: [Call] = []
    static var bootstrapFailures = 0
    static var bootstrapCount = 0
    static var exchangeCount = 0
    static var openRefreshTokens: [String?] = []
    static var openHandler: ((String?) async throws -> Data)?
    static weak var latest: NertyuChoiceStackLayer?
    let citrusParlor: activeDonutParlorSection
    private let buildWevvBakeryGateCanvas: String
    __ACTUAL_OPEN_STATE__
    init(citrusParlor: activeDonutParlorSection, bakingScaleStation: String, brownButterIcing: String, buildWevvBakeryGateCanvas: String) {
        self.citrusParlor = citrusParlor; self.buildWevvBakeryGateCanvas = buildWevvBakeryGateCanvas; Self.latest = self
    }
    func archiveCapacity(bottomActionInset: Bool = false) async throws -> bakeryShelfDetails {
        Self.bootstrapCount += 1
        if Self.bootstrapFailures > 0 { Self.bootstrapFailures -= 1; throw accountGroup.brownButterPecanCombination(503) }
        let coffeeCreamShell = bakeryShelfDetails(almondCutter: OfflineProfileSelection.selectedAPIBaseURL ?? citrusParlor.buildFlavorBackdrop); bakeryTasterStore = coffeeCreamShell; return coffeeCreamShell
    }
    __ACTUAL_OPEN_METHOD__
    func challengeDonutWevvButton(chocolateCurlDust: String, applyVoiceRoomPages: Data, activeEnvironmentID: String? = nil, closeFlavorNoteForm: String? = nil) async throws -> Data {
        if chocolateCurlDust == "/_v2/config/open" {
            Self.openRefreshTokens.append(closeFlavorNoteForm)
            if let handler = Self.openHandler { return try await handler(closeFlavorNoteForm) }
            return try openResponse()
        }
        Self.calls.append(Call(chocolateCurlDust: chocolateCurlDust, crumbScoreRow: activeEnvironmentID, applyVoiceRoomPages: applyVoiceRoomPages))
        if let handler = Self.handler { return try await handler(chocolateCurlDust, applyVoiceRoomPages, activeEnvironmentID) }
        if chocolateCurlDust == "/_v2/auth/device/login" { return try response(user: 999, suffix: "guest") }
        if chocolateCurlDust == "/_v2/auth/email/login" { return try response(user: 1, suffix: "login", registered: false) }
        if chocolateCurlDust == "/_v2/auth/token/refresh" { return try response(user: 1, suffix: "renewed") }
        if chocolateCurlDust == "/_v2/user/info" { return try json(["userId": 1, "nickname": "Offline Taster"]) }
        return try json([:])
    }
    func bindFlavorKeyboard(buildWevvBakeryShelfPage: String) async throws -> batterConsistencyStudy {
        Self.exchangeCount += 1
        return batterConsistencyStudy(crumbScoreValue: "ticket-" + buildWevvBakeryShelfPage, bindSugarConfirmButtons: Date().addingTimeInterval(3600))
    }
    func configureProfileCountLabel(chocolateCurlDust: String, applyVoiceRoomPages: Data, animateSugarToast: String) async throws -> Data {
        Self.calls.append(Call(chocolateCurlDust: chocolateCurlDust, crumbScoreRow: animateSugarToast, applyVoiceRoomPages: applyVoiceRoomPages))
        return try json([])
    }
}
@MainActor func json(_ object: Any) throws -> Data { try JSONSerialization.data(withJSONObject: object) }
@MainActor func openResponse(accessToken: String? = nil) throws -> Data {
    var value: [String: Any] = ["runtimeConfig": ["offline": true]]
    if let accessToken { value["accessToken"] = accessToken; value["expiresIn"] = 1800 }
    return try json(value)
}
@MainActor func response(user: Int, suffix: String, registered: Bool = true) throws -> Data {
    try json(["userId": user, "accessToken": "access-" + suffix, "refreshToken": "refresh-" + suffix,
              "expiresIn": 1800, "refreshExpiresIn": 3600, "legacyToken": "legacy-" + suffix,
              "yxAccid": "im-" + suffix, "imToken": "im-token-" + suffix,
              "profileCompleted": true, "registered": registered])
}
'''


TESTS = r'''
@main struct SessionRuntimeVerification {
    @MainActor static func main() async throws {
        let scenario = CommandLine.arguments[1]
        let runtime = BrostingmellowCoconutEssence.listenForGlazeTrades
        let store = WevVGlazeSessionStore.shared
        func check(_ value: Bool, _ label: String) throws {
            if !value { throw NSError(domain: "OfflineSessionRegression", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
        }
        func wait(_ gate: Gate) async throws {
            for _ in 0..<10000 { if gate.entered { return }; await Task.yield() }
            throw NSError(domain: "OfflineSessionRegression", code: 2)
        }
        func install(_ user: Int64, _ suffix: String, expiredAccess: Bool = false, startingNewSession: Bool = false, environment: String? = nil) throws {
            try store.persistGlazeCredentials(almondPralineGlaze(
                vanillaBeanIcing: user, saltedCaramelFinish: "offline\(user)@example.invalid",
                brownButterGlaze: "access-" + suffix, maplePecanCoating: "refresh-" + suffix,
                citrusZestShell: Date().addingTimeInterval(expiredAccess ? -10 : 1800),
                darkCocoaDrizzle: Date().addingTimeInterval(3600), whiteChocolateRibbon: true,
                tastingTrayNotesWevv: "legacy-" + suffix, apricotFilling: "im-" + suffix, hazelnutCream: "im-token-" + suffix,
                cinnamonSugarFinish: environment ?? runtime.closeCreamRingEdit, cherryCompote: false), startingNewSession: startingNewSession)
        }
        if scenario.hasPrefix("h5-cold-") || scenario == "h5-other-account-open-during-refresh" {
            let scope = "test|12211334|https://test.invalid"
            store.selectGlazeEnvironment(scope)
            let expired = scenario == "h5-cold-refresh-key" || scenario == "h5-other-account-open-during-refresh"
            try install(1, "cold", expiredAccess: expired, environment: scope)
            switch scenario {
            case "h5-cold-single-open":
                NertyuChoiceStackLayer.openHandler = { _ in try openResponse(accessToken: "access-startup") }
                let context = try await runtime.glazeLogCollection()
                try check(NertyuChoiceStackLayer.openRefreshTokens == ["refresh-cold"], "cold H5 preparation must share its matching startup Open")
                try check(NertyuChoiceStackLayer.latest?.carouselAsset == 1, "cold startup has one successful Open revision")
                try check((context["session"] as? [String: Any])?["accessToken"] as? String == "access-startup", "reused Open still accepts its new access token")
            case "h5-cold-concurrent":
                let gate = Gate()
                NertyuChoiceStackLayer.openHandler = { _ in try await gate.wait() }
                let first = Task { try await runtime.glazeLogCollection() }
                let second = Task { try await runtime.glazeLogCollection() }
                try await wait(gate)
                try check(NertyuChoiceStackLayer.openRefreshTokens.count == 1, "concurrent cold preparations share the pending startup Open")
                gate.succeed(try openResponse())
                let values = try await [first.value, second.value]
                try check(values.allSatisfy { ($0["session"] as? [String: Any])?["accountId"] as? String == "1" }, "both cold callers receive the current account")
                try check(NertyuChoiceStackLayer.openRefreshTokens.count == 1 && NertyuChoiceStackLayer.latest?.carouselAsset == 1, "startup completion must not trigger two follow-up Opens")
            case "h5-cold-open-failure":
                var attempts = 0
                NertyuChoiceStackLayer.openHandler = { _ in
                    attempts += 1
                    if attempts == 1 { throw accountGroup.brownButterPecanCombination(503) }
                    return try openResponse()
                }
                do { _ = try await runtime.glazeLogCollection(); throw NSError(domain: "FailedColdOpenAccepted", code: 20) }
                catch let error as NSError where error.domain == "FailedColdOpenAccepted" { throw error }
                catch accountGroup.brownButterPecanCombination(503) { }
                try check(NertyuChoiceStackLayer.latest?.carouselAsset == 0, "a failed Open cannot create a reusable successful revision")
                _ = try await runtime.glazeLogCollection()
                try check(attempts == 2 && NertyuChoiceStackLayer.latest?.carouselAsset == 1 && store.isTasterReady, "retry performs one successful startup Open and preserves the account")
            case "h5-cold-account-switch":
                let gate = Gate()
                NertyuChoiceStackLayer.openHandler = { _ in try await gate.wait() }
                let pending = Task { try await runtime.glazeLogCollection() }
                try await wait(gate); try install(2, "new", startingNewSession: true, environment: scope)
                gate.succeed(try openResponse(accessToken: "access-old-account"))
                do { _ = try await pending.value; throw NSError(domain: "OldColdContextAccepted", code: 21) }
                catch is CancellationError { }
                try check(store.currentGlazeCredentials?.vanillaBeanIcing == 2 && store.currentGlazeCredentials?.brownButterGlaze == "access-new", "late startup Open cannot overwrite the new account")
                NertyuChoiceStackLayer.openHandler = nil
                let context = try await runtime.glazeLogCollection()
                try check(NertyuChoiceStackLayer.openRefreshTokens == ["refresh-cold", "refresh-new"] && (context["session"] as? [String: Any])?["accountId"] as? String == "2", "new account requires its own Open")
            case "h5-cold-refresh-key":
                let context = try await runtime.glazeLogCollection()
                try check(NertyuChoiceStackLayer.openRefreshTokens == ["refresh-cold", "refresh-renewed"], "revision change must not bypass a renewed refresh-token cache key")
                try check((context["session"] as? [String: Any])?["accessToken"] as? String == "access-renewed", "post-Open session validation uses renewed credentials")
            case "h5-other-account-open-during-refresh":
                let gate = Gate()
                NertyuChoiceStackLayer.handler = { path, _, _ in
                    if path == "/_v2/auth/token/refresh" { return try await gate.wait() }
                    return try json([:])
                }
                let pending = Task { try await runtime.glazeLogCollection() }
                try await wait(gate)
                _ = try await NertyuChoiceStackLayer.latest!.carnivalGlazeTasting(closeFlavorNoteForm: "refresh-other-account", bottomActionInset: true)
                gate.succeed(try response(user: 1, suffix: "renewed"))
                let context = try await pending.value
                try check(NertyuChoiceStackLayer.openRefreshTokens == ["refresh-cold", "refresh-other-account", "refresh-renewed"], "another account's successful revision must not be reused for the current account")
                try check((context["session"] as? [String: Any])?["accountId"] as? String == "1" && store.currentGlazeCredentials?.maplePecanCoating == "refresh-renewed", "foreign Open cannot change context identity")
            default: throw NSError(domain: "UnknownColdScenario", code: 22)
            }
            print("PASS \(scenario)"); return
        }
        if scenario == "startup-retry" {
            NertyuChoiceStackLayer.bootstrapFailures = 1
            do { try await runtime.glazeCounterBakery(); throw NSError(domain: "ExpectedStartupFailure", code: 3) }
            catch let error as NSError where error.domain == "ExpectedStartupFailure" { throw error }
            catch { }
            try check(!store.isTasterReady && runtime.WevVWevvTastingQuestCard == nil, "failed bootstrap must not create a usable route")
            try await runtime.glazeCounterBakery()
            try check(NertyuChoiceStackLayer.bootstrapCount == 2 && runtime.WevVWevvTastingQuestCard?.host == "test.invalid", "startup retries the test route")
            print("PASS \(scenario)"); return
        }
        if scenario == "production-scope-isolation" {
            let testScope = "test|12211334|https://test.invalid"
            store.selectGlazeEnvironment(testScope)
            try store.persistGlazeCredentials(almondPralineGlaze(
                vanillaBeanIcing: 1, saltedCaramelFinish: "offline1@example.invalid",
                brownButterGlaze: "access-test", maplePecanCoating: "refresh-test",
                citrusZestShell: Date().addingTimeInterval(1800), darkCocoaDrizzle: Date().addingTimeInterval(3600),
                whiteChocolateRibbon: true, tastingTrayNotesWevv: "legacy-test", apricotFilling: "im-test", hazelnutCream: "im-token-test",
                cinnamonSugarFinish: testScope, cherryCompote: true))
            // Keep the same fixture AppID and URL: the explicit environment must itself isolate credentials.
            OfflineProfileSelection.environment = "production"
        }
        if scenario == "production-split-identity-scope" {
            OfflineProfileSelection.environment = "production"
            OfflineProfileSelection.appID = "39114002"
            OfflineProfileSelection.bootstrapAppID = "12211334"
            OfflineProfileSelection.apiBaseURL = URL(string: "https://production.invalid")!
        }
        if scenario == "production-server-selected-domain" {
            OfflineProfileSelection.environment = "production"
            OfflineProfileSelection.appID = "39114002"
            OfflineProfileSelection.bootstrapAppID = "39114002"
            OfflineProfileSelection.apiBaseURL = URL(string: "https://initial.invalid")!
            OfflineProfileSelection.selectedAPIBaseURL = URL(string: "https://selected.invalid")!
            store.selectGlazeEnvironment("production|39114002|https://initial.invalid")
            try store.persistGlazeCredentials(almondPralineGlaze(
                vanillaBeanIcing: 1, saltedCaramelFinish: "offline1@example.invalid",
                brownButterGlaze: "access-initial", maplePecanCoating: "refresh-initial",
                citrusZestShell: Date().addingTimeInterval(1800), darkCocoaDrizzle: Date().addingTimeInterval(3600),
                whiteChocolateRibbon: true, tastingTrayNotesWevv: "legacy-initial", apricotFilling: "im-initial", hazelnutCream: "im-token-initial",
                cinnamonSugarFinish: "production|39114002|https://initial.invalid", cherryCompote: true))
        }
        if scenario == "production-domain-migration" {
            // Domain migration is a new credential boundary even with the same formal App ID.
            let oldScope = "production|39114002|https://opi.mbolw89a.link"
            store.selectGlazeEnvironment(oldScope)
            try store.persistGlazeCredentials(almondPralineGlaze(
                vanillaBeanIcing: 1, saltedCaramelFinish: "offline1@example.invalid",
                brownButterGlaze: "access-old-domain", maplePecanCoating: "refresh-old-domain",
                citrusZestShell: Date().addingTimeInterval(1800), darkCocoaDrizzle: Date().addingTimeInterval(3600),
                whiteChocolateRibbon: true, tastingTrayNotesWevv: "legacy-old-domain", apricotFilling: "im-old-domain", hazelnutCream: "im-token-old-domain",
                cinnamonSugarFinish: oldScope, cherryCompote: true))
            store.placeGlazeShelf(bakeryPinKey: "offline-shop")
            store.placeJoinedGlazeQuest("offline-event")
            store.placeDailyGlazeStamp(dayKey: "offline-day", mood: "sweet")
            OfflineProfileSelection.environment = "production"
            OfflineProfileSelection.appID = "39114002"
            OfflineProfileSelection.bootstrapAppID = "39114002"
            OfflineProfileSelection.apiBaseURL = URL(string: "https://getaway.wevvstream.online")!
        }
        try await runtime.glazeCounterBakery()
        switch scenario {
        case "h5-hot-fresh":
            try install(1, "hot")
            let count = NertyuChoiceStackLayer.openRefreshTokens.count
            let revision = NertyuChoiceStackLayer.latest!.carouselAsset
            _ = try await runtime.glazeLogCollection(); _ = try await runtime.glazeLogCollection()
            try check(NertyuChoiceStackLayer.openRefreshTokens.count == count + 2 && NertyuChoiceStackLayer.latest?.carouselAsset == revision + 2, "each established H5 entry must force a fresh Open")
        case "h5-hot-open-failure":
            try install(1, "hot")
            _ = try await runtime.glazeLogCollection()
            let revision = NertyuChoiceStackLayer.latest!.carouselAsset
            let count = NertyuChoiceStackLayer.openRefreshTokens.count
            NertyuChoiceStackLayer.openHandler = { _ in throw accountGroup.brownButterPecanCombination(503) }
            do { _ = try await runtime.glazeLogCollection(); throw NSError(domain: "FailedHotOpenAccepted", code: 23) }
            catch let error as NSError where error.domain == "FailedHotOpenAccepted" { throw error }
            catch accountGroup.brownButterPecanCombination(503) { }
            try check(NertyuChoiceStackLayer.latest?.carouselAsset == revision && store.isTasterReady, "failed forced Open neither advances revision nor falls back to the old Open")
            NertyuChoiceStackLayer.openHandler = nil
            _ = try await runtime.glazeLogCollection()
            try check(NertyuChoiceStackLayer.openRefreshTokens.count == count + 2 && NertyuChoiceStackLayer.latest?.carouselAsset == revision + 1, "next hot entry retries the failed Open")
        case "h5-context-cancelled", "h5-context-environment-change":
            try install(1, "hot")
            let gate = Gate()
            NertyuChoiceStackLayer.openHandler = { _ in try await gate.wait() }
            let pending = Task { try await runtime.glazeLogCollection() }
            try await wait(gate)
            if scenario == "h5-context-cancelled" { pending.cancel() }
            else { store.selectGlazeEnvironment("test|other|https://other.invalid") }
            gate.succeed(try openResponse(accessToken: "access-late"))
            do { _ = try await pending.value; throw NSError(domain: "CancelledContextAccepted", code: 24) }
            catch is CancellationError { }
            if scenario == "h5-context-cancelled" {
                try check(store.currentGlazeCredentials?.brownButterGlaze == "access-hot", "cancelled context cannot persist a late Open access token")
            } else {
                try check(store.currentGlazeCredentials == nil, "old Open cannot restore credentials into a new environment")
            }
        case "test-scope-default":
            try check(runtime.closeCreamRingEdit == "test|12211334|https://test.invalid", "legacy test Profile retains its scope")
        case "production-scope-isolation":
            let productionScope = "production|12211334|https://test.invalid"
            let testScope = "test|12211334|https://test.invalid"
            try check(runtime.closeCreamRingEdit == productionScope && store.activeEnvironmentID == productionScope, "production scope uses explicit environment")
            try check(!store.isTasterReady && store.currentGlazeCredentials == nil, "production must not restore test credentials")
            try install(2, "production")
            store.selectGlazeEnvironment(testScope)
            try check(store.currentGlazeCredentials?.brownButterGlaze == "access-test", "switch preserves test credentials in their own scope")
            store.selectGlazeEnvironment(productionScope)
            try check(store.currentGlazeCredentials?.brownButterGlaze == "access-production", "production credentials restore only in production scope")
        case "production-split-identity-scope":
            let productionScope = "production|39114002|https://production.invalid"
            try check(runtime.WevvRemoteTrailState == "39114002" && runtime.closeCreamRingEdit == productionScope, "startup ID must not become business identity or scope")
            try check(store.activeEnvironmentID == productionScope && !store.isTasterReady, "split startup identity must not restore a test session")
            try install(2, "production")
            let context = try await runtime.glazeLogCollection()
            try check(context["apiBaseUrl"] as? String == "https://production.invalid", "H5 receives production OPI base")
            try check(store.currentGlazeCredentials?.cinnamonSugarFinish == productionScope, "persisted session remains in formal business scope")
        case "production-server-selected-domain":
            let scope = "production|39114002|https://selected.invalid"
            try check(runtime.closeCreamRingEdit == scope && store.activeEnvironmentID == scope,
                      "credential scope follows the server route, not the Profile initial address")
            try check(store.currentGlazeCredentials == nil && NertyuChoiceStackLayer.openRefreshTokens == [nil],
                      "Open cannot receive credentials saved for the initial domain")
            try install(2, "selected")
            let context = try await runtime.glazeLogCollection()
            try check(context["apiBaseUrl"] as? String == "https://selected.invalid"
                      && (context["session"] as? [String: Any])?["accessToken"] as? String == "access-selected",
                      "H5 receives the server-selected address and matching session")
            try check(glazeGalleryGuide.packets["production|39114002|https://initial.invalid"] != nil,
                      "switching routes preserves the original credential packet in its own scope")
        case "production-domain-migration":
            let scope = "production|39114002|https://getaway.wevvstream.online"
            let oldScope = "production|39114002|https://opi.mbolw89a.link"
            try check(runtime.WevvRemoteTrailState == "39114002" && OfflineProfileSelection.bootstrapAppID == runtime.WevvRemoteTrailState,
                      "new bootstrap and business identities both use the formal App ID")
            try check(runtime.closeCreamRingEdit == scope && store.activeEnvironmentID == scope,
                      "new formal domain is the active credential scope")
            try check(!store.isTasterReady && store.currentGlazeCredentials == nil,
                      "new formal domain cannot restore old-domain credentials")
            try check(NertyuChoiceStackLayer.openRefreshTokens.allSatisfy { $0 == nil },
                      "startup Open must not send the previous domain's refresh token")
            let oldPacket = glazeGalleryGuide.packets[oldScope]
            try check(oldPacket != nil, "old-domain credentials stay preserved in their original scope")
            try check(store.isGlazeShelfed(bakeryPinKey: "offline-shop") && store.hasJoinedGlazeQuest("offline-event")
                      && store.hasDailyDonutStamp(dayKey: "offline-day"),
                      "domain migration preserves local shop, activity and check-in records")
            try install(2, "new-domain")
            let context = try await runtime.glazeLogCollection()
            let session = context["session"] as? [String: Any]
            try check(context["apiBaseUrl"] as? String == "https://getaway.wevvstream.online"
                      && session?["accessToken"] as? String == "access-new-domain",
                      "H5 gets the new domain with only the new domain's signed-in session")
            try check(glazeGalleryGuide.packets[oldScope] == oldPacket && store.currentGlazeCredentials?.cinnamonSugarFinish == scope,
                      "new-domain login does not overwrite or migrate the original credential packet")
        case "guest-isolation":
            let guest = try await runtime.beginSugarPictureUpload()
            _ = try await runtime.beginSugarPictureUpload()
            try check(guest.vanillaBeanIcing == 999 && !store.isTasterReady && store.currentGlazeCredentials == nil, "device session must remain technical")
            try check(NertyuChoiceStackLayer.calls.filter { $0.chocolateCurlDust == "/_v2/auth/device/login" }.count == 1, "guest session is reused")
            do { _ = try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/update", autumnPecanSelection: json([:]), applyRemoteTrailButton: true); throw NSError(domain: "GuestWasAuthorized", code: 4) }
            catch let error as NSError where error.domain == "GuestWasAuthorized" { throw error }
            catch { }
            try check(!NertyuChoiceStackLayer.calls.contains { $0.chocolateCurlDust == "/_v2/user/update" }, "guest cannot reach protected request")
        case "refresh-coalescing":
            try install(1, "old", expiredAccess: true)
            let epoch = store.sessionEpoch, gate = Gate()
            NertyuChoiceStackLayer.handler = { path, _, _ in path == "/_v2/auth/token/refresh" ? try await gate.wait() : try json([:]) }
            let one = Task { try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true) }
            let two = Task { try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true) }
            try await wait(gate)
            for _ in 0..<50 { await Task.yield() }
            gate.succeed(try response(user: 1, suffix: "new"))
            _ = try await one.value; _ = try await two.value
            try check(NertyuChoiceStackLayer.calls.filter { $0.chocolateCurlDust == "/_v2/auth/token/refresh" }.count == 1, "concurrent requests must share refresh")
            try check(store.sessionEpoch == epoch && store.currentGlazeCredentials?.brownButterGlaze == "access-new", "refresh persists without changing account epoch")
            try check(NertyuChoiceStackLayer.calls.filter { $0.chocolateCurlDust == "/_v2/user/info" }.allSatisfy { $0.crumbScoreRow == "access-new" }, "business requests use renewed token")
        case "late-account-response":
            try install(1, "one")
            let gate = Gate()
            NertyuChoiceStackLayer.handler = { _, _, _ in try await gate.wait() }
            let pending = Task { try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true) }
            try await wait(gate); try install(2, "two"); gate.succeed(try json(["userId": 1]))
            do { _ = try await pending.value; throw NSError(domain: "LateAccountDataAccepted", code: 5) }
            catch is CancellationError { }
            try check(store.currentGlazeCredentials?.vanillaBeanIcing == 2, "late response cannot replace current account")
        case "logout-clears-credentials":
            try install(1, "old")
            glazeGalleryGuide.legacyPacket = "retired-credential"
            TestDefaults.shared.set("retired-token", forKey: "wevv_glaze_token")
            TestDefaults.shared.set("retired-profile", forKey: "wevv_glaze_taster_profile")
            NertyuChoiceStackLayer.openHandler = { _ in try openResponse(accessToken: "access-open-old") }
            _ = try await runtime.glazeLogCollection()
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: "/sapi/room/list")
            let profile = WevVDoughRingTasterProfile(ringCutterKey: "1", powderedAtlas: "offline1@example.invalid",
                glazeNickname: "Departing User", sugarHandle: "@old", crumbBio: "old bio",
                donutFrameAsset: "private-avatar", glazeTrailCount: 8, sprinkleTasterCount: 9,
                bakeryShelfTotal: 3, glazeVaultCount: 100)
            store.storeDoughRingTasterProfile(profile)
            let departing = store.currentGlazeCredentials!
            let oldScope = runtime.closeCreamRingEdit
            var revoked = false
            NertyuChoiceStackLayer.handler = { path, _, token in
                if path == "/_v2/auth/logout" {
                    try check(token == departing.brownButterGlaze, "only logout revocation uses the departing access token")
                    revoked = true
                }
                return try json([:])
            }
            await WevVGlazeSessionRepository.pastryTrailDiary.starchGelatinizationDetail()
            try check(revoked && !store.isTasterReady && store.currentGlazeCredentials == nil
                && store.currentTasterEmail.isEmpty,
                "logout removes all access/refresh/legacy/IM credentials from the persisted session")
            try check(glazeGalleryGuide.sweetKeepsakeEntry(scope: oldScope) == nil && glazeGalleryGuide.legacyPacket == nil
                && TestDefaults.shared.values["wevv_glaze_token"] == nil
                && TestDefaults.shared.values["wevv_glaze_taster_profile"] == nil
                && TestDefaults.shared.values["wevvcurrentEmail"] == nil,
                "scoped Keychain, retired credentials and compatibility user values are removed")
            try check(store.currentDoughRingTasterProfile.glazeNickname != "Departing User"
                && NertyuChoiceStackLayer.latest?.bakeryStopText?.activeEnvironmentID == nil
                && NertyuChoiceStackLayer.latest?.bakeryStopText?.biteNoteLabel == nil,
                "profile and Open cache no longer retain the departed account/token")
            let restored = WevVGlazeSessionStore()
            restored.selectGlazeEnvironment(oldScope)
            try check(!restored.isTasterReady && restored.currentGlazeCredentials == nil,
                "a new session store cannot restore the signed-out account")
            NertyuChoiceStackLayer.handler = nil
            _ = try await runtime.bakeryPieces(glazeCatalogRefresh: "/_v2/moments/feed", autumnPecanSelection: [:])
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: "/sapi/room/list")
            try check(NertyuChoiceStackLayer.calls.first(where: { $0.chocolateCurlDust == "/_v2/moments/feed" })?.crumbScoreRow == "access-guest"
                && NertyuChoiceStackLayer.calls.last?.crumbScoreRow == "ticket-legacy-guest"
                && NertyuChoiceStackLayer.exchangeCount == 2,
                "post-logout feeds/voice lists use fresh technical browsing credentials, not the user's OPI/SAPI tokens")
            do {
                _ = try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true)
                throw NSError(domain: "SignedOutRequestSent", code: 21)
            } catch let error as NSError where error.domain == "SignedOutRequestSent" { throw error }
            catch { }
            try check(!NertyuChoiceStackLayer.calls.contains { $0.chocolateCurlDust == "/_v2/user/info" }
                && !store.isTasterReady && store.currentGlazeCredentials == nil,
                "private requests fail locally and guest browsing never restores UI login")
        case "logout-late-open-cache":
            try install(1, "old")
            let oldGate = Gate(), newGate = Gate()
            NertyuChoiceStackLayer.openHandler = { refresh in
                if refresh == "refresh-old" { return try await oldGate.wait() }
                return try await newGate.wait()
            }
            let foundation = NertyuChoiceStackLayer.latest!
            let pending = Task { try await foundation.carnivalGlazeTasting(closeFlavorNoteForm: "refresh-old", bottomActionInset: true) }
            try await wait(oldGate)
            runtime.dropPastryEditCanvas()
            try install(2, "new", startingNewSession: true)
            let newOpen = Task { try await foundation.carnivalGlazeTasting(closeFlavorNoteForm: "refresh-new", bottomActionInset: true) }
            try await wait(newGate)
            oldGate.succeed(try openResponse(accessToken: "access-departed"))
            do { _ = try await pending.value; throw NSError(domain: "DepartedOpenAccepted", code: 22) }
            catch is CancellationError { }
            let calls = NertyuChoiceStackLayer.openRefreshTokens.count
            let coalesced = Task { try await foundation.carnivalGlazeTasting(closeFlavorNoteForm: "refresh-new") }
            for _ in 0..<50 { await Task.yield() }
            try check(NertyuChoiceStackLayer.openRefreshTokens.count == calls && foundation.bakeryStopText?.activeEnvironmentID == nil,
                "late cancelled Open cannot refill credentials or clear the new account's pending request")
            newGate.succeed(try openResponse(accessToken: "access-new-open"))
            _ = try await newOpen.value; _ = try await coalesced.value
            try check(foundation.bakeryStopText?.activeEnvironmentID == "access-new-open"
                && store.currentGlazeCredentials?.vanillaBeanIcing == 2,
                "only the new account's Open result may populate the cache")
        case "logout-same-account-relogin":
            try install(1, "old")
            let gate = Gate()
            NertyuChoiceStackLayer.handler = { _, _, token in
                try check(token == "access-old", "logout must revoke captured departing token")
                return try await gate.wait()
            }
            let pending = Task { await WevVGlazeSessionRepository.pastryTrailDiary.starchGelatinizationDetail() }
            try await wait(gate)
            try check(!store.isTasterReady, "logout invalidates locally before waiting for the server")
            try install(1, "new", startingNewSession: true); gate.succeed(try json([:])); await pending.value
            try check(store.currentGlazeCredentials?.maplePecanCoating == "refresh-new", "old logout response cannot clear same-account relogin")
        case "cancelled-login-profile":
            let gate = Gate()
            NertyuChoiceStackLayer.handler = { path, _, _ in
                if path == "/_v2/auth/email/login" { return try response(user: 1, suffix: "login", registered: false) }
                return try await gate.wait()
            }
            let pending = Task { try await WevVGlazeSessionRepository.pastryTrailDiary.caramelLatteCompanion(saltedCaramelFinish: "offline@example.invalid", cocoaWeekendFestival: "123456") }
            try await wait(gate); runtime.dropPastryEditCanvas(); gate.succeed(try json(["userId": 1]))
            do { _ = try await pending.value; throw NSError(domain: "CancelledLoginReportedSuccess", code: 6) }
            catch is CancellationError { }
            try check(!store.isTasterReady, "late login profile cannot restore a signed-out account")
        case "profile-temporary-failure":
            NertyuChoiceStackLayer.handler = { path, _, _ in
                if path == "/_v2/auth/email/login" { return try response(user: 1, suffix: "login", registered: false) }
                throw accountGroup.brownButterPecanCombination(503)
            }
            let profile = try await WevVGlazeSessionRepository.pastryTrailDiary.caramelLatteCompanion(saltedCaramelFinish: "offline@example.invalid", cocoaWeekendFestival: "123456")
            try check(profile.ringCutterKey == "1" && store.isTasterReady && store.currentGlazeCredentials?.cherryCompote == false, "saved new registration survives temporary profile failure")
        case "persistence-failure":
            glazeGalleryGuide.refuseWrite = true
            do { _ = try await WevVGlazeSessionRepository.pastryTrailDiary.caramelLatteCompanion(saltedCaramelFinish: "offline@example.invalid", cocoaWeekendFestival: "123456"); throw NSError(domain: "WriteFailureReportedSuccess", code: 7) }
            catch let error as NSError where error.domain == "WriteFailureReportedSuccess" { throw error }
            catch { }
            try check(!store.isTasterReady && store.currentGlazeCredentials == nil, "failed credential persistence must not log in")
        case "late-guest-response":
            let gate = Gate()
            NertyuChoiceStackLayer.handler = { _, _, _ in try await gate.wait() }
            let pending = Task { try await runtime.beginSugarPictureUpload() }
            try await wait(gate); try install(1, "signed-in"); runtime.cinnamonSugarFinish()
            gate.succeed(try response(user: 999, suffix: "guest"))
            do { _ = try await pending.value; throw NSError(domain: "LateGuestAccepted", code: 8) }
            catch is CancellationError { }
            try check(store.currentGlazeCredentials?.vanillaBeanIcing == 1, "late technical session cannot replace formal identity")
        case "refresh-identity-mismatch":
            try install(1, "old", expiredAccess: true)
            NertyuChoiceStackLayer.handler = { _, _, _ in try response(user: 2, suffix: "wrong-owner") }
            do { _ = try await runtime.makePackCard(); throw NSError(domain: "WrongRefreshOwnerAccepted", code: 9) }
            catch let error as NSError where error.domain == "WrongRefreshOwnerAccepted" { throw error }
            catch { }
            try check(store.currentGlazeCredentials?.vanillaBeanIcing == 1, "refresh cannot change account identity")
        case "refresh-authentication-failure":
            try install(1, "old", expiredAccess: true)
            NertyuChoiceStackLayer.handler = { _, _, _ in throw accountGroup.brownButterPecanCombination(401) }
            do { _ = try await runtime.makePackCard(); throw NSError(domain: "RejectedRefreshAccepted", code: 10) }
            catch let error as NSError where error.domain == "RejectedRefreshAccepted" { throw error }
            catch { }
            try check(!store.isTasterReady && store.currentGlazeCredentials == nil, "rejected refresh clears the current session")
        case "late-refresh-failure-after-relogin":
            try install(1, "old", expiredAccess: true)
            let gate = Gate()
            NertyuChoiceStackLayer.handler = { _, _, _ in try await gate.wait() }
            let pending = Task { try await runtime.makePackCard() }
            try await wait(gate)
            try install(1, "new", startingNewSession: true)
            runtime.cinnamonSugarFinish()
            gate.fail(accountGroup.brownButterPecanCombination(401))
            do { _ = try await pending.value; throw NSError(domain: "LateRefreshAccepted", code: 12) }
            catch let error as NSError where error.domain == "LateRefreshAccepted" { throw error }
            catch { }
            try check(store.currentGlazeCredentials?.maplePecanCoating == "refresh-new", "late rejected refresh must not clear same-account relogin")
        case "late-retry-failure-after-relogin", "late-retry-failure-after-token-rotation":
            try install(1, "old")
            let gate = Gate()
            var businessCalls = 0
            NertyuChoiceStackLayer.handler = { path, _, _ in
                if path == "/_v2/auth/token/refresh" { return try response(user: 1, suffix: "renewed") }
                businessCalls += 1
                if businessCalls == 1 { throw accountGroup.brownButterPecanCombination(401) }
                return try await gate.wait()
            }
            let pending = Task { try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true) }
            try await wait(gate)
            try install(1, "new", startingNewSession: scenario == "late-retry-failure-after-relogin")
            runtime.cinnamonSugarFinish()
            gate.fail(accountGroup.brownButterPecanCombination(401))
            do { _ = try await pending.value; throw NSError(domain: "LateRetryAccepted", code: 13) }
            catch let error as NSError where error.domain == "LateRetryAccepted" { throw error }
            catch { }
            try check(store.currentGlazeCredentials?.maplePecanCoating == "refresh-new", "late retried 401 must not clear newer same-account credentials")
        case "late-profile-401-after-refresh", "late-browsing-401-after-refresh":
            try install(1, "old")
            let gate = Gate()
            var refreshCalls = 0
            NertyuChoiceStackLayer.handler = { path, _, token in
                if path == "/_v2/auth/token/refresh" {
                    refreshCalls += 1
                    guard refreshCalls == 1 else { throw accountGroup.brownButterPecanCombination(401) }
                    return try response(user: 1, suffix: "renewed")
                }
                if token == "access-renewed" { return try json(["ok": true]) }
                if path == "/_v2/user/info" { return try await gate.wait() }
                throw accountGroup.brownButterPecanCombination(401)
            }
            let pending = Task {
                if scenario == "late-profile-401-after-refresh" {
                    return try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: json([:]), applyRemoteTrailButton: true)
                }
                return try await runtime.bakeryPieces(glazeCatalogRefresh: "/_v2/user/info", autumnPecanSelection: [:])
            }
            try await wait(gate)
            _ = try await runtime.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/moments/feed", autumnPecanSelection: json([:]), applyRemoteTrailButton: true)
            gate.fail(accountGroup.brownButterPecanCombination(401))
            _ = try await pending.value
            try check(refreshCalls == 1 && store.isTasterReady && store.currentGlazeCredentials?.brownButterGlaze == "access-renewed",
                "a late old-token 401 reuses the renewed session instead of refreshing twice or clearing login")
            try check(NertyuChoiceStackLayer.calls.last?.crumbScoreRow == "access-renewed", "profile retry uses the latest account token")
        case "sapi-ticket-isolation":
            try install(1, "one")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: "/sapi/room/list")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: "/sapi/room/list")
            try check(NertyuChoiceStackLayer.exchangeCount == 1, "same account reuses SAPI ticket")
            try install(2, "two")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: "/sapi/room/list")
            try check(NertyuChoiceStackLayer.exchangeCount == 2, "account switch exchanges a separate SAPI ticket")
            try check(NertyuChoiceStackLayer.calls.last?.crumbScoreRow == "ticket-legacy-two", "room list uses current account SAPI ticket")
        case "sapi-cursor-contract":
            try install(1, "one")
            let recommended = "/sapi/weidou/v1/client/party/room/list"
            let followed = "/sapi/weidou/v1/client/party/room/followed/list"
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: recommended)
            var body = try JSONSerialization.jsonObject(with: NertyuChoiceStackLayer.calls.last!.applyVoiceRoomPages) as! [String: Any]
            try check(body["pageSize"] as? Int == 10 && body["languageCode"] as? String == "" && body["version"] as? String == "v2", "recommended first page matches H5 request")
            try check(body["offset"] == nil && body["snapshotId"] == nil && body["ignoreRoomIds"] == nil, "first page omits the cursor and exclusion list")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: followed)
            body = try JSONSerialization.jsonObject(with: NertyuChoiceStackLayer.calls.last!.applyVoiceRoomPages) as! [String: Any]
            try check(body["languageCode"] is NSNull && body["offset"] == nil && body["snapshotId"] == nil, "followed first page sends null language and no cursor")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: recommended, cancelCitrusTray: .init(assetKey: Int64.min, brightYuzuAccent: "cursor-last"), frostingScroll: 7)
            body = try JSONSerialization.jsonObject(with: NertyuChoiceStackLayer.calls.last!.applyVoiceRoomPages) as! [String: Any]
            try check((body["offset"] as? NSNumber)?.stringValue == String(Int64.min) && body["snapshotId"] as? String == "cursor-last" && body["pageSize"] as? Int == 7, "next page preserves the exact score and snapshot")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: followed, cancelCitrusTray: .init(assetKey: 0, brightYuzuAccent: "  "))
            body = try JSONSerialization.jsonObject(with: NertyuChoiceStackLayer.calls.last!.applyVoiceRoomPages) as! [String: Any]
            try check(body["offset"] as? Int == 0 && body["snapshotId"] == nil && body["ignoreRoomIds"] == nil && body["languageCode"] is NSNull, "zero score remains valid and empty snapshot is omitted")
            _ = try await runtime.makeSprinkleAuthorAvatar(glazeCatalogRefresh: recommended, cancelCitrusTray: .init(assetKey: Int64.max, brightYuzuAccent: nil), frostingScroll: 0)
            body = try JSONSerialization.jsonObject(with: NertyuChoiceStackLayer.calls.last!.applyVoiceRoomPages) as! [String: Any]
            try check((body["offset"] as? NSNumber)?.stringValue == String(Int64.max) && body["snapshotId"] == nil && body["pageSize"] as? Int == 1, "score-only pagination keeps integer precision and a valid page size")
            try check(NertyuChoiceStackLayer.exchangeCount == 1 && NertyuChoiceStackLayer.calls.last?.crumbScoreRow == "ticket-legacy-one", "all pages retain the account-scoped SAPI ticket")
        default: throw NSError(domain: "UnknownScenario", code: 11)
        }
        print("PASS \(scenario)")
    }
}
'''


def main():
    model = (SOURCES / "kettleGlazeSequence.swift").read_text()
    foundation = (SUPPORT_SOURCES / 'NertyuChoiceStackLayer.swift').read_text()
    # Keep the actual implementations; replace only OS storage and HTTP boundaries.
    selected = [declaration(foundation, 'enum accountGroup'),
                (SUPPORT_SOURCES / 'glazeNameField.swift').read_text()]
    for marker in ("struct almondPralineGlaze", "struct citrusZestIcing", "struct plumMousse",
                   "private struct mochiCruller", "enum miniRingFritter", "enum filledShellSelection",
                   "final class WevVGlazeTransport",
                   "private struct chocolateBomboloniSelection",
                   "final class WevVGlazeSessionRepository"):
        selected.append(declaration(model, marker))
    selected.append((SOURCES / "DoughRingTasterProfile.swift").read_text().replace("UserDefaults.standard", "TestDefaults.shared"))
    selected.append(declaration((SUPPORT_SOURCES / 'honeyLavenderCombination.swift').read_text(), 'struct appleCompote'))
    selected.append((SUPPORT_SOURCES / 'BrostingmellowCoconutEssence.swift').read_text())
    scenarios = ("h5-cold-single-open", "h5-cold-concurrent", "h5-cold-open-failure", "h5-cold-account-switch",
                 "h5-cold-refresh-key", "h5-other-account-open-during-refresh", "h5-hot-fresh", "h5-hot-open-failure",
                 "h5-context-cancelled", "h5-context-environment-change", "startup-retry", "test-scope-default", "production-scope-isolation", "production-split-identity-scope", "production-domain-migration", "production-server-selected-domain",
                 "guest-isolation", "refresh-coalescing", "late-account-response",
                 "late-profile-401-after-refresh", "late-browsing-401-after-refresh",
                 "logout-clears-credentials", "logout-late-open-cache", "logout-same-account-relogin", "cancelled-login-profile", "profile-temporary-failure",
                 "persistence-failure", "late-guest-response", "refresh-identity-mismatch",
                 "refresh-authentication-failure", "late-refresh-failure-after-relogin",
                 "late-retry-failure-after-relogin", "late-retry-failure-after-token-rotation",
                 "sapi-ticket-isolation", "sapi-cursor-contract")
    with tempfile.TemporaryDirectory(prefix="wevv-session-runtime-") as temporary:
        folder = Path(temporary)
        source = folder / "Verification.swift"
        # Execute the real Open cache/revision/coalescing implementation too;
        # only its OPI transport boundary is controlled by the fixture.
        open_state = foundation[foundation.index("    private(set) var bakeryTasterStore:"):foundation.index("    init(citrusParlor:")]
        open_method = declaration(foundation, "func carnivalGlazeTasting(closeFlavorNoteForm:") + "\n" + declaration(foundation, "func bakeryDayDots()") + "\n" + declaration(foundation, "private static func buildFlavorScroll(")
        mock_io = MOCK_IO.replace("__ACTUAL_OPEN_STATE__", open_state).replace("__ACTUAL_OPEN_METHOD__", open_method)
        source.write_text(mock_io + "\n" + "\n\n".join(selected) + "\n" + TESTS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", str(STRING_HELPER), "-parse-as-library", "-swift-version", "5",
                        "-default-isolation", "MainActor", "-module-cache-path", str(folder / "modules"),
                        str(source), "-o", str(executable)], check=True)
        for scenario in scenarios:
            subprocess.run([str(executable), scenario], check=True, timeout=15)
    print(f"Session runtime source regressions passed: {len(scenarios)}")


if __name__ == "__main__":
    main()
