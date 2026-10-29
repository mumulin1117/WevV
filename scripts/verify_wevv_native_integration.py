#!/usr/bin/env python3
"""Compile real repository/controller data methods with offline service/UI boundaries.

This checks migration wiring, independent loading, stale-response isolation, and
unavailable contracts. It does not reconstruct layouts or contact any service.
"""
from pathlib import Path
import re
import runpy
import subprocess
import tempfile
from wevv_archive_source import read_archive

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WevSweetgd/WevSweetgd"
declaration = runpy.run_path(str(ROOT / "scripts/verify_wevv_session_runtime.py"))["declaration"]

MOCKS = r'''
import Foundation
enum GlazeVaultTradeError: Error { case invalidResponse, http(Int) }
struct OfflineAccount { let vanillaBeanIcing: Int64 }
@MainActor final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()
    var activeEnvironmentID: String? = "test"
    var sessionEpoch = 1
    var isTasterReady = true
    var currentGlazeCredentials: OfflineAccount? = OfflineAccount(vanillaBeanIcing: 7)
}
@MainActor final class BrostingmellowCoconutEssence {
    static let listenForGlazeTrades = BrostingmellowCoconutEssence()
    var closeCreamRingEdit = "test"
    var paths: [String] = []
    var requestBodies: [[String: Any]] = []
    var browsingResponse = Data("{\"total\":0,\"rows\":[]}".utf8)
    var prepareHook: (() async throws -> Void)?
    func glazeCounterBakery() async throws { try await prepareHook?() }
    func applyPortraitAsset(closeVideoDial: Int, liftPastryEditCanvas: String) throws {
        try Task.checkCancellation()
        guard closeVideoDial == WevVGlazeSessionStore.shared.sessionEpoch, liftPastryEditCanvas == closeCreamRingEdit else { throw CancellationError() }
    }
    func bakeryPieces(glazeCatalogRefresh: String, autumnPecanSelection: [String: Any]) async throws -> Data {
        paths.append(glazeCatalogRefresh); requestBodies.append(autumnPecanSelection); return browsingResponse
    }
    func makeSprinkleAuthorAvatar(glazeCatalogRefresh: String, cancelCitrusTray: glazeVaultHeroLayer? = nil, frostingScroll: Int = 10) async throws -> Data {
        paths.append(glazeCatalogRefresh); return Data("[]".utf8)
    }
}
@MainActor final class WevVGlazeMessageController {
    static let shared = WevVGlazeMessageController()
    var calls: [(Data, String, String)] = []
    func upload(data: Data, fileName: String, mimeType: String) async throws -> String {
        calls.append((data, fileName, mimeType)); return "https://synthetic.invalid/image.jpg"
    }
}
@MainActor final class LisenNoticepoplater {
    struct caramelPecanMedley { let card: butteryTexture; var allowsInteraction = true }
    struct choiceStackPacket { let posts: [caramelPecanMedley]; let nextCursor: Int64?; let isLastPage: Bool }
    struct Comments { let comments: [featherlightBite] }
    struct Configuration { let publishEnabled: Bool; let imageUploadEnabled: Bool }
    enum chosenAssetPacket { case published(Int64), pendingReview }
    enum chosenDonutAvatarAsset: Error { case publicationRejected(currentLevel: Int?, targetLevel: Int?, validImageURLs: [String]?) }
    static let shared = LisenNoticepoplater()
    var calls: [String] = []
    var posts: [caramelPecanMedley] = []
    var outcome: chosenAssetPacket = .pendingReview
    var enabled = true
    var configHook: (() -> Void)?
    var imageHook: (() -> Void)?
    var momentHook: (() -> Void)?
    var commentsHook: (() -> Void)?
    func timeline(followedOnly: Bool = false, maxPages: Int = 5) async throws -> [caramelPecanMedley] {
        calls.append(followedOnly ? "followed" : "feed"); return posts
    }
    func feed(cursorID: Int64 = 0, size: Int = 20) async throws -> choiceStackPacket {
        choiceStackPacket(posts: posts, nextCursor: nil, isLastPage: true)
    }
    func publishConfig() async throws -> Configuration {
        calls.append("config"); configHook?(); return Configuration(publishEnabled: enabled, imageUploadEnabled: enabled)
    }
    func imageCheck(urls: [String]) async throws { calls.append("images"); imageHook?() }
    func create(content: String, imageURLs: [String]) async throws -> chosenAssetPacket { calls.append("create"); return outcome }
    func moment(id: Int64) async throws -> caramelPecanMedley { calls.append("moment"); momentHook?(); return caramelPecanMedley(card: postValue(id)) }
    func comments(momentID: Int64) async throws -> Comments { calls.append("comments"); commentsHook?(); return Comments(comments: []) }
}
@MainActor final class WevVGlazeRosterCell {
    static let shared = WevVGlazeRosterCell()
    var reportCalls = 0
    var reportHook: (() -> Void)?
    func report(userID: Int64, type: String, detail: String?, momentID: Int64) async throws { reportCalls += 1; reportHook?() }
}
@MainActor final class OfflineRepository {
    var live: () async throws -> [pearFilling] = { [] }
    var paginatedLive: ((Int, Int) async throws -> glazeMarkLabel)?
    var voice: (mascarponeFilling) async throws -> [pearFilling] = { _ in [] }
    var paginatedVoice: ((mascarponeFilling, glazeVaultHeroLayer?, Int) async throws -> glazeVaultHeroView)?
    var paginatedMoments: ((Int64, Int) async throws -> LisenNoticepoplater.choiceStackPacket)?
    var moments: (goldenCrumbDough) async throws -> [butteryTexture] = { _ in [] }
    var profile: (Int64) async throws -> meltawayCrumb = { profileValue($0) }
    var userMoments: (Int64) async throws -> [butteryTexture] = { _ in [] }
    var follow: (Int64, Bool) async throws -> Void = { _, _ in }
    func steamExpansionStudy() async throws -> [pearFilling] { try await live() }
    func livePage(currentPage: Int, pageSize: Int = 10) async throws -> glazeMarkLabel {
        if let paginatedLive { return try await paginatedLive(currentPage, pageSize) }
        let rooms = try await live()
        return glazeMarkLabel(formatter: rooms, gingerHoneyDrizzle: rooms.count, followingList: rooms.count)
    }
    func batterConsistencyDetail(carnivalGlazeShowcase: mascarponeFilling) async throws -> [pearFilling] { try await voice(carnivalGlazeShowcase) }
    func voicePage(carnivalGlazeShowcase: mascarponeFilling, cursor: glazeVaultHeroLayer? = nil,
                   pageSize: Int = 10) async throws -> glazeVaultHeroView {
        if let paginatedVoice { return try await paginatedVoice(carnivalGlazeShowcase, cursor, pageSize) }
        let rooms = try await voice(carnivalGlazeShowcase)
        return glazeVaultHeroView(rooms: rooms, rawCount: rooms.count, nextCursor: nil)
    }
    func starchGelatinizationStudy(carnivalGlazeShowcase: goldenCrumbDough) async throws -> [butteryTexture] { try await moments(carnivalGlazeShowcase) }
    func tastingPassportPage(cursor: Int64 = 0, pageSize: Int = 20) async throws -> LisenNoticepoplater.choiceStackPacket {
        if let paginatedMoments { return try await paginatedMoments(cursor, pageSize) }
        return LisenNoticepoplater.choiceStackPacket(posts: try await moments(.artisanFrySequence).map { .init(card: $0) }, nextCursor: nil, isLastPage: true)
    }
    func smallBatchKitchen(vanillaBeanIcing: Int64) async throws -> meltawayCrumb { try await profile(vanillaBeanIcing) }
    func heritageMap(vanillaBeanIcing: Int64) async throws -> [butteryTexture] { try await userMoments(vanillaBeanIcing) }
    func riversideBakery(vanillaBeanIcing: Int64, autumnPecanCollection: Bool) async throws { try await follow(vanillaBeanIcing, autumnPecanCollection) }
}
@MainActor final class WevVGlazeSessionRepository {
    static let pastryTrailDiary = WevVGlazeSessionRepository()
    var fetchProfile: () async throws -> Void = {}
    private(set) var profileCalls = 0
    func coldBrewTasting() async throws {
        profileCalls += 1
        try await fetchProfile()
    }
}
@MainActor enum WevVGlazeSocialRepository {
    static let pastryTrailDiary = OfflineRepository()
}
struct UIColor {
    static let white = UIColor(), black = UIColor()
    init() {}
    init(red: Double, green: Double, blue: Double, alpha: Double) {}
}
@MainActor final class UIButton {
    enum State { case normal }
    enum ButtonType { case custom }
    enum Event { case touchUpInside }
    struct Font {
        enum Weight { case medium }
        static func systemFont(ofSize: CGFloat, weight: Weight) -> Font { Font() }
    }
    final class TitleLabel { var font: Font? }
    final class Layer { var cornerRadius: CGFloat = 0 }
    var translatesAutoresizingMaskIntoConstraints = true, clipsToBounds = false
    let titleLabel: TitleLabel? = TitleLabel()
    let layer = Layer()
    var accessibilityIdentifier: String?, accessibilityLabel: String?, title: String?
    var isEnabled = true
    var backgroundColor: UIColor?
    init() {}
    init(type: ButtonType) {}
    func setTitle(_ value: String?, for state: State) { title = value }
    func setTitleColor(_ value: UIColor, for state: State) {}
    func addTarget(_ target: Any, action: String, for event: Event) {}
}
typealias UIControl = UIButton
@MainActor final class KipoDonutMomentController {
    enum Style { case fullScreen }
    let momentID: Int64
    var cocoaKissExperience: (() -> Void)?
    var modalPresentationStyle: Style = .fullScreen
    init(richCocoaFlavor: butteryTexture) { momentID = richCocoaFlavor.coconutCenter }
}
@MainActor final class Label {
    var text: String?
    var isHidden = true
    var accessibilityElementsHidden = false
    var isAccessibilityElement = true
}
@MainActor final class Refresh {
    var ended = false, isRefreshing = false
    var endCount = 0
    func beginRefreshing() { ended = false; isRefreshing = true }
    func endRefreshing() { ended = true; isRefreshing = false; endCount += 1 }
}
enum WevVDonutParlorSection: Hashable { case donutCounter, tastingParlor, tastingJournal, zestyOrangeHarmony }
@MainActor final class WevVGlazeMessageCell {
    var isLoadingVisible = false
    var visibilityChanges: [(Bool, Bool)] = []
    func setLoadingVisible(_ visible: Bool, animated: Bool) {
        isLoadingVisible = visible
        visibilityChanges.append((visible, animated))
    }
}
@MainActor enum TinGlazePromptStyler {
    static var messages: [String] = []
    static func showSugarToast(in view: Int, text: String) { messages.append(text) }
}
@MainActor final class Gate {
    var entered = false
    private var continuations: [CheckedContinuation<Void, Never>] = []
    func wait() async { entered = true; await withCheckedContinuation { continuations.append($0) } }
    func release() { let pending = continuations; continuations = []; pending.forEach { $0.resume() } }
}
func postValue(_ id: Int64 = 1, owner: Int64 = 7, followed: Bool = false) -> butteryTexture {
    butteryTexture(coconutCenter: id, vanillaBeanIcing: owner, gingerHoneyDrizzle: "Synthetic", cheesecakeMousse: nil,
                   caramelCurd: "A real text-only post", passionfruitFilling: [], limeCream: 0, apricotCenter: 0,
                   figCustard: "", mascarponeCream: followed, cherryCompote: false, custardMousse: false, peachFilling: nil, pearJam: nil)
}
func profileValue(_ id: Int64 = 42, mutual: Bool? = nil, chat: Bool? = nil, followed: Bool = false) -> meltawayCrumb {
    var value = meltawayCrumb(vanillaBeanIcing: id, gingerHoneyDrizzle: "Synthetic", cheesecakeMousse: nil,
        yuzuHoneySwirl: "", fluffyTexture: "", chewyCrust: [], tenderFinish: 0, crispyBite: 0, crunchyDough: 0,
        flakyLayer: followed, velvetyCrumb: mutual ?? false, silkyCenter: false, delicateCrust: false, springyFinish: nil, softCloudDough: [])
    value.backendMutualFollow = mutual; value.backendCanChat = chat; return value
}
func roomValue(_ id: Int = 1) -> pearFilling {
    pearFilling(passionfruitMousse: String(id), lemonCurd: .blueberryCustard, limeJam: "Room", yuzuCustard: "7",
                peachCream: "Synthetic", pearCenter: nil, appleCompote: nil, figFilling: 0,
                custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false)
}
func voiceRoomValue(_ id: Int) -> pearFilling {
    pearFilling(passionfruitMousse: String(id), lemonCurd: .blackberryCream, limeJam: "Voice room", yuzuCustard: "7",
                peachCream: "Synthetic", pearCenter: nil, appleCompote: nil, figFilling: 0,
                custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false)
}
'''

MAIN_STATE = r'''
@MainActor final class MainPage {
    let donutJournalStore = WevVGlazeSessionStore.shared
    let glazeContentRepository = OfflineRepository()
    let glazeSocialRepository = OfflineRepository()
    var glazeContentTask: Task<Void, Never>?
    var glazeContentRequestID = UUID()
    var glazeContentRefreshOwner: (requestID: UUID, section: WevVDonutParlorSection)?
    var homeLivePageTask: Task<Void, Never>?
    var homeLivePagination = creamPacket()
    var cocoaWeekendFestival = LisenNoticepoplater.honeyScout()
    var strawberryMilkSwirl: Task<Void, Never>?
    var voicePageTasks: [mascarponeFilling: Task<Void, Never>] = [:]
    var voicePaginations: [mascarponeFilling: honeyLavenderCombination] = [
        .cherryCenter: honeyLavenderCombination(), .apricotCompote: honeyLavenderCombination()
    ]
    var tastingParlorShelf = mascarponeFilling.apricotCompote
    var tastingJournalShelf = goldenCrumbDough.artisanFrySequence
    var activeDonutParlorSection: WevVDonutParlorSection = .donutCounter
    var pendingInitialGlazeSections: Set<WevVDonutParlorSection> = [.donutCounter, .tastingParlor, .tastingJournal]
    var isGlazeContentVisible = true
    let donutCounterGlazeSheen = WevVGlazeMessageCell()
    let tastingParlorGlazeSheen = WevVGlazeMessageCell()
    let tastingJournalGlazeSheen = WevVGlazeMessageCell()
    let pastryTrailScroll = Label(), flavorNoteEntryButton = Label(), glazePinnedHeaders = Label()
    var visibleInitialGlazeSections: Set<WevVDonutParlorSection> {
        var visible = Set<WevVDonutParlorSection>()
        if donutCounterGlazeSheen.isLoadingVisible { visible.insert(.donutCounter) }
        if tastingParlorGlazeSheen.isLoadingVisible { visible.insert(.tastingParlor) }
        if tastingJournalGlazeSheen.isLoadingVisible { visible.insert(.tastingJournal) }
        return visible
    }
    var glazeProfileTask: Task<Void, Never>?
    var glazeProfileRequestID = UUID()
    var glazeJournalFollowTask: Task<Void, Never>?
    var glazeJournalFollowRequestID = UUID()
    var glazeContentOwnerKey: String?
    var deadline: [String: TimeInterval] = [:]
    var glazeOwnerNameTasks: [Int64: Task<Void, Never>] = [:]
    var glazeOwnerNameRequestID = UUID()
    var glazeOwnerNameAttempts = Set<Int64>()
    var glazeOwnerNames: [Int64: String] = [:]
    var glazeOwnerNameLabels: [Int64: Label] = [:]
    var glazeRoomItems: [pearFilling] = []
    var glazeRecommendedVoiceRooms: [pearFilling] = []
    var glazeFollowedVoiceRooms: [pearFilling] = []
    var glazeTrendingMomentItems: [butteryTexture] = []
    var glazeFollowedMomentItems: [butteryTexture] = []
    var glazeProfileMomentItems: [butteryTexture] = []
    let homeLiveStatusLabel = Label(), tastingParlorStatusLabel = Label(), tastingJournalStatusLabel = Label()
    let sprinkleRefresh = Refresh()
    var hints: [String] = []
    func showRootSugarHint(_ text: String) { hints.append(text) }
    var protectedGates = 0
    func presentProtectedGate() { protectedGates += 1 }
    var presentedMomentIDs: [Int64] = []
    func present(_ controller: KipoDonutMomentController, animated: Bool) { presentedMomentIDs.append(controller.momentID) }
    var renderedLiveRoomIDs: [String] = []
    var footerUpdates = 0
    var voiceFooterUpdates = 0
    var renderedVoiceRoomIDs: [mascarponeFilling: [String]] = [:]
    func updateHomeLiveLoadMoreFooter() { footerUpdates += 1 }
    func updateVoiceRoomLoadMoreFooter() { voiceFooterUpdates += 1 }
    func updateVoiceRoomPagerHeight() {}
    func refreshTastingRow() {}
    func rebuildVoiceRoomStacks() {
        renderedVoiceRoomIDs[.apricotCompote] = glazeRecommendedVoiceRooms.map(\.passionfruitMousse)
        renderedVoiceRoomIDs[.cherryCenter] = glazeFollowedVoiceRooms.map(\.passionfruitMousse)
        updateTastingParlorStatus()
        updateVoiceRoomLoadMoreFooter()
    }
    func rebuildHomeLiveRoomStack() {
        renderedLiveRoomIDs = glazeRoomItems.filter { $0.lemonCurd == .blueberryCustard }.map(\.passionfruitMousse)
    }
    func rebuildGlazeRoomStacks(error: Error?) {
        rebuildHomeLiveRoomStack()
        rebuildVoiceRoomStacks()
        updateHomeLiveStatus(error: error)
        updateHomeLiveLoadMoreFooter()
    }
    func rebuildTastingJournalMomentPages() {}
    func rebuildDonutSnapshotStack() {}
    var profileRenderCount = 0
    var renderedProfileMomentIDs: [Int64] = []
    func refreshDonutDiaryPanel() {
        profileRenderCount += 1
        renderedProfileMomentIDs = glazeProfileMomentItems.map(\.coconutCenter)
    }
'''

REMOTE_STATE = r'''
@MainActor final class RemotePage {
    let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    let remoteRepository = OfflineRepository()
    let remoteUserID: Int64? = 42
    let view = 0
    let remoteStatus = Label()
    var remoteCard: meltawayCrumb?
    var remoteMoments: [butteryTexture] = []
    var remoteTask: Task<Void, Never>?
    var remoteRequestID = UUID()
    var remoteActionTask: Task<Void, Never>?
    var remoteActionRequestID = UUID()
    var remoteOwnerKey: String?
    var remoteMomentError: Error?
    var placeholderVisible = false
    var wevvSelectedPane: WevvFlavorPane = .tastingQuestPane
    func showRemoteSheenPlaceholder() { placeholderVisible = true }
    func hideRemoteSheenPlaceholder() { placeholderVisible = false }
    func refreshWevvTasterCardPage() {}
    func rebuildRemoteCard() {}
'''

TESTS = r'''
@main struct NativeIntegrationVerification {
    @MainActor static func main() async throws {
        let store = WevVGlazeSessionStore.shared, runtime = BrostingmellowCoconutEssence.listenForGlazeTrades
        let community = LisenNoticepoplater.shared
        var cases = 0
        func check(_ value: Bool, _ label: String) throws {
            if !value { throw NSError(domain: "NativeIntegrationRegression", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
        }
        func entered(_ gate: Gate) async throws {
            for _ in 0..<10000 { if gate.entered { return }; await Task.yield() }
            throw NSError(domain: "NativeIntegrationRegression", code: 2)
        }
        func reached(_ condition: () -> Bool, _ label: String) async throws {
            for _ in 0..<10000 { if condition() { return }; await Task.yield() }
            throw NSError(domain: "NativeIntegrationRegression", code: 10, userInfo: [NSLocalizedDescriptionKey: label])
        }
        func owner() -> String { (store.activeEnvironmentID ?? "unprepared") + "|" + String(store.sessionEpoch) }
        func seedLive(_ page: MainPage, ids: [Int], total: Int? = nil) {
            let request = page.homeLivePagination.artisanSelectionShowcase()
            page.homeLivePagination.cleanCrumbPacketPart(glazeMarkLabel(formatter: ids.map(roomValue), gingerHoneyDrizzle: total ?? ids.count, followingList: ids.count), closeFlavorNoteForm: request)
            page.mergeGlazeRoomContent(live: page.homeLivePagination.closeWevvBakeryShelf)
        }
        func voicePage(_ ids: [Int], offset: Int64, snapshot: String = "synthetic-snapshot") -> glazeVaultHeroView {
            glazeVaultHeroView(rooms: ids.map(voiceRoomValue), rawCount: ids.count,
                              nextCursor: glazeVaultHeroLayer(offset: offset, snapshotID: snapshot))
        }
        func seedVoice(_ page: MainPage, shelf: mascarponeFilling = .apricotCompote,
                       ids: [Int], offset: Int64) {
            var state = page.voicePaginations[shelf] ?? honeyLavenderCombination()
            let request = state.beginRefresh()
            state.receive(voicePage(ids, offset: offset), request: request)
            page.voicePaginations[shelf] = state
            page.applyVoiceRoomPages()
        }
        let content = ContentFacade(), social = SocialFacade()
        runtime.browsingResponse = Data("{\"total\":1,\"rows\":[{\"id\":101,\"userId\":7,\"nickname\":\"Synthetic\",\"backgroundImgUrl\":\"https://synthetic.invalid/room.jpg\",\"joinNum\":4,\"followFlag\":1}]}".utf8)
        let livePool = try await content.steamExpansionStudy()
        _ = try await content.batterConsistencyDetail(carnivalGlazeShowcase: .apricotCompote)
        _ = try await content.batterConsistencyDetail(carnivalGlazeShowcase: .cherryCenter)
        try check(runtime.paths == ["/_v2/discover/live/pool", "/sapi/weidou/v1/client/party/room/list", "/sapi/weidou/v1/client/party/room/followed/list"], "native room entry points use exact new semantic contracts")
        let poolRequest = runtime.requestBodies[0]
        try check(poolRequest.count == 5 && poolRequest["countryIds"] as? String == "" && poolRequest["currentPage"] as? Int == 1
            && poolRequest["ids"] is NSNull && poolRequest["isMiddleEast"] as? Bool == false && poolRequest["pageSize"] as? Int == 10,
            "native live pool sends the same default filters and pagination as dist")
        try check(livePool.count == 1 && livePool[0].passionfruitMousse == "101" && livePool[0].glazeHostID == "7",
            "real flat live pool fields reach native room cards with separate room and business IDs")
        cases += 1
        community.posts = [.init(card: postValue()), .init(card: postValue(2, owner: 8))]
        let posts = try await content.starchGelatinizationStudy(carnivalGlazeShowcase: .artisanFrySequence)
        try check(posts.count == 2 && posts[0].passionfruitFilling.isEmpty, "text-only feed records survive native facade")
        let own = try await social.heritageMap(vanillaBeanIcing: 7)
        try check(own.count == 1 && own[0].vanillaBeanIcing == 7, "user timeline filters real owners without inventing a user-feed route")
        cases += 1
        _ = try await social.boutiqueStudio(Data([1, 2, 3]), pastryCompendiumSeries: "original.jpg")
        let media = WevVGlazeMessageController.shared.calls
        try check(media.count == 1 && media[0].0 == Data([1, 2, 3]) && media[0].1 == "original.jpg" && media[0].2 == "image/jpeg", "unchanged composer upload facade reaches new native media service")
        cases += 1
        community.calls = []
        let outcome = try await social.cornerBakery(caramelCurd: "Post", passionfruitFilling: ["https://synthetic.invalid/image.jpg"])
        if case .pendingReview = outcome {} else { throw NSError(domain: "LostPendingReview", code: 3) }
        try check(community.calls == ["config", "images", "create"], "accepted review propagates once without resubmission")
        cases += 1
        for mutateAtImages in [false, true] {
            community.calls = []
            if mutateAtImages { community.imageHook = { store.sessionEpoch += 1 } }
            else { community.configHook = { store.sessionEpoch += 1 } }
            do { _ = try await social.cornerBakery(caramelCurd: "Post", passionfruitFilling: ["https://synthetic.invalid/image.jpg"]); throw NSError(domain: "CrossOwnerPublish", code: 4) }
            catch is CancellationError { cases += 1 }
            try check(!community.calls.contains("create"), "publication pipeline checks account after every asynchronous phase")
            community.configHook = nil; community.imageHook = nil
        }

        for reporting in [false, true] {
            community.calls = []; WevVGlazeRosterCell.shared.reportCalls = 0
            community.momentHook = { store.sessionEpoch += 1 }
            do {
                if reporting { try await social.crustSnapIndex(yeastBloomSequence: 1, roseTintDesign: "SPAM") }
                else { _ = try await social.glazeSheenNotes(yeastBloomSequence: 1) }
                throw NSError(domain: "OldOwnerContinuedSecondStep", code: 8)
            } catch is CancellationError {}
            try check(community.calls == ["moment"] && WevVGlazeRosterCell.shared.reportCalls == 0, "account change after detail prevents comments/report from running as the next account")
            community.momentHook = nil
            cases += 1
        }
        for reporting in [false, true] {
            community.commentsHook = reporting ? nil : { store.sessionEpoch += 1 }
            WevVGlazeRosterCell.shared.reportHook = reporting ? { store.sessionEpoch += 1 } : nil
            do {
                if reporting { try await social.crustSnapIndex(yeastBloomSequence: 1, roseTintDesign: "SPAM") }
                else { _ = try await social.glazeSheenNotes(yeastBloomSequence: 1) }
                throw NSError(domain: "OldOwnerReturnedCompositeResponse", code: 9)
            } catch is CancellationError {}
            community.commentsHook = nil; WevVGlazeRosterCell.shared.reportHook = nil
            cases += 1
        }
        for operation in [
            { () async throws -> Void in _ = try await content.aromaSpectrumNotes() },
            { _ = try await social.familyOwnedCounter() },
            { _ = try await social.nuttyFinishMatrix(yeastBloomSequence: 1, glutenStructureDetail: true) },
            { _ = try await social.doughKitchenBakery() },
            { _ = try await social.confectionStudioCounter(vanillaBeanIcing: 7) },
            { _ = try await social.tastingCounterKitchen(smoothShellBite: "thread") },
            { _ = try await social.smallBatchStudio("message", smoothShellBite: "thread") },
            { try await social.familyOwnedMap("thread") }
        ] {
            let before = runtime.paths.count
            do { try await operation(); throw NSError(domain: "UnavailableReportedSuccess", code: 5) }
            catch is glazeNameField { cases += 1 }
            try check(runtime.paths.count == before, "unavailable contract never sends a legacy request")
        }

        let initialSections: Set<WevVDonutParlorSection> = [.donutCounter, .tastingParlor, .tastingJournal]
        let initial = MainPage(), initialLiveGate = Gate(), initialVoiceGate = Gate(), initialFollowedVoiceGate = Gate()
        let initialFeedGate = Gate(), initialFollowedFeedGate = Gate()
        initial.resetGlazeContentOwner(owner())
        initial.glazeContentRepository.live = { await initialLiveGate.wait(); return [roomValue(201)] }
        initial.glazeContentRepository.voice = { kind in
            if kind == .apricotCompote { await initialVoiceGate.wait() }
            else { await initialFollowedVoiceGate.wait() }
            return []
        }
        initial.glazeContentRepository.moments = { kind in
            if kind == .artisanFrySequence { await initialFeedGate.wait() }
            else { await initialFollowedFeedGate.wait() }
            return []
        }
        initial.loadGlazeContent(showsLoading: false)
        try await entered(initialLiveGate); try await entered(initialFeedGate)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        try check(initial.pendingInitialGlazeSections == initialSections && initial.visibleInitialGlazeSections == [.donutCounter],
            "initial skeleton stays visible beyond the previous fixed delay while real data is still pending")
        try check(initial.pastryTrailScroll.accessibilityElementsHidden && initial.glazePinnedHeaders.accessibilityElementsHidden && initial.flavorNoteEntryButton.accessibilityElementsHidden && !initial.flavorNoteEntryButton.isAccessibilityElement,
            "visible initial skeleton prevents VoiceOver from entering covered content or the floating action")
        initial.activeDonutParlorSection = .tastingParlor
        initial.updateInitialGlazeLoadingVisibility(animated: false)
        try check(initial.visibleInitialGlazeSections == [.tastingParlor], "switching tabs shows only the active page's pending skeleton")
        initial.isGlazeContentVisible = false
        initial.updateInitialGlazeLoadingVisibility(animated: false)
        try check(initial.visibleInitialGlazeSections.isEmpty, "leaving the main page stops every hidden page's loading animation")
        try check(!initial.pastryTrailScroll.accessibilityElementsHidden && !initial.glazePinnedHeaders.accessibilityElementsHidden && !initial.flavorNoteEntryButton.accessibilityElementsHidden && initial.flavorNoteEntryButton.isAccessibilityElement,
            "leaving the main page releases the skeleton accessibility boundary")
        initial.isGlazeContentVisible = true
        initial.updateInitialGlazeLoadingVisibility(animated: false)
        try check(initial.visibleInitialGlazeSections == [.tastingParlor], "returning to a pending page resumes its own skeleton")
        try check(initial.pastryTrailScroll.accessibilityElementsHidden && initial.glazePinnedHeaders.accessibilityElementsHidden && initial.flavorNoteEntryButton.accessibilityElementsHidden && !initial.flavorNoteEntryButton.isAccessibilityElement,
            "returning to a pending page restores the skeleton accessibility boundary")
        cases += 1

        initialLiveGate.release()
        try await reached({ initial.renderedLiveRoomIDs == ["201"] && !initial.pendingInitialGlazeSections.contains(.donutCounter) },
            "live completion did not independently render Home or finish its skeleton")
        try await entered(initialVoiceGate)
        try check(initial.pendingInitialGlazeSections == [.tastingParlor, .tastingJournal]
            && initial.renderedLiveRoomIDs == ["201"], "live completion ends only the home skeleton before slow voice and feed requests finish")
        initial.activeDonutParlorSection = .donutCounter
        initial.updateInitialGlazeLoadingVisibility(animated: false)
        try check(initial.visibleInitialGlazeSections.isEmpty, "a completed prefetched page opens directly without replaying a skeleton")
        try check(!initial.pastryTrailScroll.accessibilityElementsHidden && !initial.glazePinnedHeaders.accessibilityElementsHidden && !initial.flavorNoteEntryButton.accessibilityElementsHidden && initial.flavorNoteEntryButton.isAccessibilityElement,
            "a completed page exposes its real content and floating action to VoiceOver")
        initialFeedGate.release(); try await entered(initialFollowedFeedGate)
        try check(initial.pendingInitialGlazeSections.contains(.tastingJournal), "feed skeleton covers both required first-load feed requests")
        initialFollowedFeedGate.release()
        try await reached({ !initial.pendingInitialGlazeSections.contains(.tastingJournal) }, "feed completion did not end its skeleton")
        try check(initial.pendingInitialGlazeSections == [.tastingParlor], "empty successful feed ends independently while voice remains pending")
        initialVoiceGate.release(); try await entered(initialFollowedVoiceGate)
        try check(initial.pendingInitialGlazeSections == [.tastingParlor], "voice skeleton waits for the followed list as well as the recommended list")
        initialFollowedVoiceGate.release(); await initial.glazeContentTask?.value
        try check(initial.pendingInitialGlazeSections.isEmpty && initial.visibleInitialGlazeSections.isEmpty,
            "all independent first-load sections stop after their actual requests complete")
        cases += 1

        let previousInitialUpdates = initial.donutCounterGlazeSheen.visibilityChanges.count
        initial.glazeContentRepository.live = { [] }
        initial.glazeContentRepository.voice = { _ in [] }
        initial.glazeContentRepository.moments = { _ in [] }
        initial.loadGlazeContent(); await initial.glazeContentTask?.value
        initial.activeDonutParlorSection = .tastingJournal
        initial.updateInitialGlazeLoadingVisibility(animated: false)
        try check(initial.pendingInitialGlazeSections.isEmpty && initial.visibleInitialGlazeSections.isEmpty
            && initial.donutCounterGlazeSheen.visibilityChanges.dropFirst(previousInitialUpdates).allSatisfy { !$0.0 },
            "refreshing or opening already loaded pages never replays initial skeletons over existing content")
        let completedUpdateCount = initial.donutCounterGlazeSheen.visibilityChanges.count
        initial.finishInitialGlazeLoading(for: .donutCounter)
        try check(initial.donutCounterGlazeSheen.visibilityChanges.count == completedUpdateCount,
            "repeated initial completion is idempotent and does not schedule more visibility transitions")
        cases += 1

        for fail in [false, true] {
            let terminal = MainPage()
            terminal.resetGlazeContentOwner(owner())
            terminal.glazeContentRepository.live = {
                if fail { throw GlazeVaultTradeError.http(503) }; return []
            }
            terminal.glazeContentRepository.voice = { _ in
                if fail { throw GlazeVaultTradeError.http(503) }; return []
            }
            terminal.glazeContentRepository.moments = { _ in
                if fail { throw GlazeVaultTradeError.http(503) }; return []
            }
            terminal.loadGlazeContent(); await terminal.glazeContentTask?.value
            try check(terminal.pendingInitialGlazeSections.isEmpty && terminal.visibleInitialGlazeSections.isEmpty,
                "both empty success and request failure finish all three initial skeletons")
            try check(terminal.homeLiveStatusLabel.text == (fail ? "Rooms could not be loaded. Pull down to retry." : "No live rooms are open right now."),
                "initial skeleton completion exposes the corresponding live empty or retry message")
            cases += 1
        }

        let prepareFailure = MainPage()
        runtime.prepareHook = { throw GlazeVaultTradeError.http(503) }
        prepareFailure.resetGlazeContentOwner(owner())
        prepareFailure.sprinkleRefresh.beginRefreshing()
        prepareFailure.loadGlazeContent(); await prepareFailure.glazeContentTask?.value
        runtime.prepareHook = nil
        try check(prepareFailure.pendingInitialGlazeSections.isEmpty && prepareFailure.visibleInitialGlazeSections.isEmpty
            && prepareFailure.sprinkleRefresh.ended, "bootstrap failure stops all initial skeletons and releases pull-down refresh for retry")
        cases += 1

        let loadingOwner = MainPage(), oldInitialLiveGate = Gate(), oldInitialFeedGate = Gate()
        loadingOwner.resetGlazeContentOwner(owner())
        loadingOwner.glazeContentRepository.live = { await oldInitialLiveGate.wait(); return [roomValue(301)] }
        loadingOwner.glazeContentRepository.moments = { _ in await oldInitialFeedGate.wait(); return [postValue(301)] }
        loadingOwner.loadGlazeContent(showsLoading: false)
        let oldInitialTask = loadingOwner.glazeContentTask
        try await entered(oldInitialLiveGate); try await entered(oldInitialFeedGate)
        let newInitialLiveGate = Gate(), newInitialFeedGate = Gate()
        loadingOwner.glazeContentRepository.live = { await newInitialLiveGate.wait(); return [] }
        loadingOwner.glazeContentRepository.moments = { kind in
            if kind == .artisanFrySequence { await newInitialFeedGate.wait() }
            return []
        }
        store.sessionEpoch += 1
        loadingOwner.refreshGlazeServerProfile()
        try await entered(newInitialLiveGate); try await entered(newInitialFeedGate)
        try await reached({ !loadingOwner.pendingInitialGlazeSections.contains(.tastingParlor) },
            "new account voice requests did not finish independently of pending live/feed requests")
        try check(oldInitialTask?.isCancelled == true && loadingOwner.pendingInitialGlazeSections == [.donutCounter, .tastingJournal]
            && loadingOwner.visibleInitialGlazeSections == [.donutCounter], "account change resets all first-load sections and replaces cancelled loading work")
        oldInitialLiveGate.release(); oldInitialFeedGate.release(); await oldInitialTask?.value
        try check(loadingOwner.pendingInitialGlazeSections == [.donutCounter, .tastingJournal] && loadingOwner.glazeRoomItems.isEmpty
            && loadingOwner.glazeTrendingMomentItems.isEmpty, "late previous-account responses cannot finish the new account's pending skeletons")
        newInitialLiveGate.release(); newInitialFeedGate.release(); await loadingOwner.glazeContentTask?.value
        try check(loadingOwner.pendingInitialGlazeSections.isEmpty, "current account responses finish their own reset skeletons normally")
        cases += 1

        let preparingOwner = MainPage(), oldPrepareGate = Gate(), currentPrepareLiveGate = Gate()
        preparingOwner.resetGlazeContentOwner(owner())
        runtime.prepareHook = { await oldPrepareGate.wait(); throw GlazeVaultTradeError.http(503) }
        preparingOwner.loadGlazeContent(showsLoading: false)
        let oldPreparingTask = preparingOwner.glazeContentTask
        try await entered(oldPrepareGate)
        runtime.prepareHook = nil
        preparingOwner.glazeContentRepository.live = { await currentPrepareLiveGate.wait(); return [] }
        store.sessionEpoch += 1
        preparingOwner.refreshGlazeServerProfile()
        try await entered(currentPrepareLiveGate)
        try await reached({ !preparingOwner.pendingInitialGlazeSections.contains(.tastingJournal)
            && !preparingOwner.pendingInitialGlazeSections.contains(.tastingParlor) }, "current account feed/voice did not finish")
        try check(preparingOwner.pendingInitialGlazeSections == [.donutCounter],
            "a new account can independently complete its feed and voice lists while its live loading stays pending")
        oldPrepareGate.release(); await oldPreparingTask?.value
        try check(oldPreparingTask?.isCancelled == true && preparingOwner.pendingInitialGlazeSections == [.donutCounter],
            "cancelled previous-account prepare failure cannot finish the new account's skeletons")
        currentPrepareLiveGate.release(); await preparingOwner.glazeContentTask?.value
        try check(preparingOwner.pendingInitialGlazeSections.isEmpty, "current account finishes normally after a late cancelled bootstrap failure")
        cases += 1

        let page = MainPage(), roomGate = Gate()
        page.glazeOwnerNames[21] = "User nickname"
        page.glazeOwnerNameAttempts.insert(21)
        page.glazeOwnerNameLabels[21] = Label()
        let oldNameRequestID = page.glazeOwnerNameRequestID
        page.resetTastingParlorOwnerNames(keepingCachedNames: true)
        try check(page.glazeOwnerNames[21] == "User nickname" && page.glazeOwnerNameAttempts.isEmpty
            && page.glazeOwnerNameRequestID != oldNameRequestID,
            "explicit refresh retains visible usernames but allows a fresh request generation")
        page.resetGlazeContentOwner(owner())
        try check(page.glazeOwnerNames.isEmpty && page.glazeOwnerNameLabels.isEmpty,
            "changing content owner clears cached usernames and previous account label bindings")
        cases += 1
        page.glazeContentRepository.live = { await roomGate.wait(); return [] }
        page.glazeContentRepository.moments = { _ in [postValue()] }
        page.loadGlazeContent(); try await entered(roomGate)
        for _ in 0..<10000 { if !page.glazeTrendingMomentItems.isEmpty { break }; await Task.yield() }
        try check(page.glazeTrendingMomentItems.count == 1, "feed renders while rooms are still pending")
        roomGate.release(); await page.glazeContentTask?.value; cases += 1

        let voiceGate = Gate()
        page.glazeContentRepository.live = { [roomValue()] }
        page.glazeContentRepository.voice = { kind in
            if kind == .apricotCompote { await voiceGate.wait() }
            return []
        }
        page.loadGlazeContent(); try await entered(voiceGate)
        try await reached({ page.renderedLiveRoomIDs == ["1"] }, "live cards did not render while voice was pending")
        try check(page.renderedLiveRoomIDs == ["1"] && page.homeLiveStatusLabel.isHidden,
            "successful live cards render before the independent voice requests finish")
        voiceGate.release(); await page.glazeContentTask?.value; cases += 1

        page.glazeContentRepository.live = { [] }
        page.glazeContentRepository.voice = { _ in throw GlazeVaultTradeError.http(503) }
        page.loadGlazeContent(showsLoading: false); await page.glazeContentTask?.value
        try check(!page.homeLiveStatusLabel.isHidden && page.homeLiveStatusLabel.text == "No live rooms are open right now.",
            "a real empty live pool shows its empty state even when voice requests fail")
        try check(!page.tastingParlorStatusLabel.isHidden && page.tastingParlorStatusLabel.text == "Rooms could not be loaded. Pull down to retry.",
            "independent voice failures keep their original failure feedback")
        cases += 1

        page.glazeContentRepository.live = { throw GlazeVaultTradeError.http(503) }
        page.glazeContentRepository.voice = { _ in [] }
        page.loadGlazeContent(showsLoading: false); await page.glazeContentTask?.value
        try check(!page.homeLiveStatusLabel.isHidden && page.homeLiveStatusLabel.text == "Rooms could not be loaded. Pull down to retry.",
            "a failed live pool remains a live error after successful voice requests")
        cases += 1

        seedLive(page, ids: [1]); page.glazeTrendingMomentItems = [postValue()]
        page.glazeContentRepository.live = { throw GlazeVaultTradeError.http(503) }
        page.glazeContentRepository.voice = { _ in throw GlazeVaultTradeError.http(503) }
        page.glazeContentRepository.moments = { _ in throw GlazeVaultTradeError.http(503) }
        page.loadGlazeContent(showsLoading: false); await page.glazeContentTask?.value
        try check(page.glazeRoomItems.count == 1 && page.glazeTrendingMomentItems.count == 1, "failed same-owner refresh preserves successful sections")
        try check(page.renderedLiveRoomIDs == ["1"] && page.homeLiveStatusLabel.isHidden && page.homeLiveStatusLabel.text == nil,
            "failed same-owner live refresh retains cached cards instead of replacing them with an empty or error label")
        cases += 1
        page.glazeContentRepository.live = { [] }; page.glazeContentRepository.voice = { _ in [] }; page.glazeContentRepository.moments = { _ in [] }
        page.loadGlazeContent(showsLoading: false); await page.glazeContentTask?.value
        try check(page.glazeRoomItems.isEmpty && page.glazeTrendingMomentItems.isEmpty, "real empty success clears old records")
        try check(page.renderedLiveRoomIDs.isEmpty && !page.homeLiveStatusLabel.isHidden && page.homeLiveStatusLabel.text == "No live rooms are open right now.",
            "successful empty refresh clears old live cards and explains the absence of live rooms")
        cases += 1
        seedLive(page, ids: [1]); page.glazeTrendingMomentItems = [postValue()]
        store.sessionEpoch += 1
        page.glazeContentRepository.live = { throw GlazeVaultTradeError.http(503) }; page.glazeContentRepository.moments = { _ in throw GlazeVaultTradeError.http(503) }
        page.loadGlazeContent(showsLoading: false); await page.glazeContentTask?.value
        try check(page.glazeRoomItems.isEmpty && page.glazeTrendingMomentItems.isEmpty, "account change clears old owner data even when new loading fails")
        cases += 1

        let staleLiveGate = Gate()
        page.glazeContentRepository.live = { await staleLiveGate.wait(); return [roomValue()] }
        page.loadGlazeContent(showsLoading: false)
        let staleLiveTask = page.glazeContentTask
        try await entered(staleLiveGate)
        store.sessionEpoch += 1
        staleLiveGate.release(); await staleLiveTask?.value
        try check(page.glazeRoomItems.isEmpty && page.renderedLiveRoomIDs.isEmpty,
            "live response from the previous account cannot render after the owner changes")
        cases += 1

        let paginated = MainPage(), slowVoice = Gate()
        var requestedPages: [(Int, Int)] = []
        paginated.glazeContentRepository.paginatedLive = { number, size in
            requestedPages.append((number, size))
            let ids = number == 1 ? Array(1...10) : Array(11...20)
            return glazeMarkLabel(formatter: ids.map(roomValue), gingerHoneyDrizzle: 25, followingList: ids.count)
        }
        paginated.glazeContentRepository.voice = { kind in
            if kind == .apricotCompote { await slowVoice.wait() }
            return []
        }
        paginated.loadGlazeContent(showsLoading: false); try await entered(slowVoice)
        try await reached({ paginated.renderedLiveRoomIDs == (1...10).map(String.init) }, "live first page did not render independently of pending voice")
        try check(paginated.renderedLiveRoomIDs == (1...10).map(String.init),
            "first page displays every room rather than truncating to four")
        paginated.loadMoreHomeLiveRooms(); await paginated.homeLivePageTask?.value
        try check(requestedPages.map { $0.0 } == [1, 2] && requestedPages.allSatisfy { $0.1 == 10 }
            && paginated.renderedLiveRoomIDs == (1...20).map(String.init),
            "load more requests page two with the standard size and appends it")
        slowVoice.release(); await paginated.glazeContentTask?.value
        try check(paginated.renderedLiveRoomIDs == (1...20).map(String.init),
            "late first-page voice completion preserves rooms already appended by load more")
        cases += 1

        let nextGate = Gate()
        paginated.glazeContentRepository.paginatedLive = { number, size in
            requestedPages.append((number, size)); await nextGate.wait()
            throw GlazeVaultTradeError.http(503)
        }
        paginated.loadMoreHomeLiveRooms(); let failedMore = paginated.homeLivePageTask
        try await entered(nextGate)
        paginated.loadMoreHomeLiveRooms()
        try check(requestedPages.map { $0.0 } == [1, 2, 3],
            "repeated gestures while loading cannot start duplicate page requests")
        nextGate.release(); await failedMore?.value
        try check(paginated.homeLivePagination.berryCrumbBakerySelections && paginated.homeLivePagination.cancelGlazeEntryPreparation == 3
            && paginated.homeLivePageTask == nil && paginated.renderedLiveRoomIDs.count == 20,
            "failed later page releases the task and retains the visible list and retry cursor")
        paginated.glazeContentRepository.paginatedLive = { number, size in
            requestedPages.append((number, size))
            return glazeMarkLabel(formatter: Array(21...25).map(roomValue), gingerHoneyDrizzle: 25, followingList: 5)
        }
        paginated.loadMoreHomeLiveRooms(); await paginated.homeLivePageTask?.value
        paginated.loadMoreHomeLiveRooms()
        try check(requestedPages.map { $0.0 } == [1, 2, 3, 3]
            && paginated.renderedLiveRoomIDs == (1...25).map(String.init) && !paginated.homeLivePagination.blueberryCustard,
            "retry repeats the failed page and total exhaustion blocks further loading")
        cases += 1

        seedLive(paginated, ids: Array(1...10), total: 30)
        let beforeBlocked = requestedPages.count
        paginated.activeDonutParlorSection = .tastingParlor
        paginated.loadMoreHomeLiveRooms()
        paginated.activeDonutParlorSection = .donutCounter
        paginated.sprinkleRefresh.isRefreshing = true
        paginated.loadMoreHomeLiveRooms()
        paginated.sprinkleRefresh.isRefreshing = false
        try check(requestedPages.count == beforeBlocked && !paginated.homeLivePagination.brownButterIcing,
            "other tabs and an active pull-down refresh cannot start load more")
        cases += 1

        let replacedGate = Gate()
        paginated.glazeContentRepository.paginatedLive = { number, _ in
            await replacedGate.wait()
            return glazeMarkLabel(formatter: Array(11...20).map(roomValue), gingerHoneyDrizzle: 30, followingList: 10)
        }
        paginated.loadMoreHomeLiveRooms(); let replacedMore = paginated.homeLivePageTask
        try await entered(replacedGate)
        paginated.glazeContentRepository.paginatedLive = { _, _ in
            glazeMarkLabel(formatter: Array(100...109).map(roomValue), gingerHoneyDrizzle: 30, followingList: 10)
        }
        paginated.glazeContentRepository.voice = { _ in [] }
        paginated.loadGlazeContent(showsLoading: false); await paginated.glazeContentTask?.value
        try check(replacedMore?.isCancelled == true && paginated.renderedLiveRoomIDs == (100...109).map(String.init),
            "refresh cancels a pending later page and replaces the list with its new first page")
        let currentMoreGate = Gate()
        paginated.glazeContentRepository.paginatedLive = { _, _ in
            await currentMoreGate.wait()
            return glazeMarkLabel(formatter: Array(110...119).map(roomValue), gingerHoneyDrizzle: 30, followingList: 10)
        }
        paginated.loadMoreHomeLiveRooms(); let currentMore = paginated.homeLivePageTask
        try await entered(currentMoreGate)
        replacedGate.release(); await replacedMore?.value
        try check(paginated.renderedLiveRoomIDs == (100...109).map(String.init)
            && paginated.homeLivePageTask != nil && paginated.homeLivePagination.brownButterIcing,
            "cancelled late page cannot append old rows or clear a newer pagination task")
        currentMoreGate.release(); await currentMore?.value
        try check(paginated.renderedLiveRoomIDs == (100...119).map(String.init),
            "current page continues normally after a cancelled previous generation completes")
        cases += 1

        let changedOwnerGate = Gate()
        paginated.glazeContentRepository.paginatedLive = { _, _ in
            await changedOwnerGate.wait()
            return glazeMarkLabel(formatter: Array(120...129).map(roomValue), gingerHoneyDrizzle: 30, followingList: 10)
        }
        paginated.loadMoreHomeLiveRooms(); let changedOwnerMore = paginated.homeLivePageTask
        try await entered(changedOwnerGate)
        store.sessionEpoch += 1
        paginated.resetGlazeContentOwner(owner())
        try check(changedOwnerMore?.isCancelled == true && paginated.homeLivePageTask == nil
            && paginated.homeLivePagination.closeWevvBakeryShelf.isEmpty && paginated.renderedLiveRoomIDs.isEmpty,
            "account change immediately cancels pagination and clears old room rows")
        changedOwnerGate.release(); await changedOwnerMore?.value
        try check(paginated.renderedLiveRoomIDs.isEmpty && paginated.homeLivePagination.closeWevvBakeryShelf.isEmpty,
            "a late old-account page cannot restore previous-account room rows")
        cases += 1

        let unnotified = MainPage(), unnotifiedGate = Gate()
        unnotified.resetGlazeContentOwner(owner()); seedLive(unnotified, ids: Array(1...10), total: 30)
        unnotified.glazeContentRepository.paginatedLive = { _, _ in
            await unnotifiedGate.wait()
            return glazeMarkLabel(formatter: Array(11...20).map(roomValue), gingerHoneyDrizzle: 30, followingList: 10)
        }
        unnotified.loadMoreHomeLiveRooms(); let unnotifiedMore = unnotified.homeLivePageTask
        try await entered(unnotifiedGate)
        store.sessionEpoch += 1
        unnotifiedGate.release(); await unnotifiedMore?.value
        try check(unnotified.homeLivePagination.closeWevvBakeryShelf.map(\.passionfruitMousse) == (1...10).map(String.init),
            "owner guard rejects late pagination even before the session notification resets the controller")
        cases += 1

        let voicePages = MainPage()
        voicePages.resetGlazeContentOwner(owner())
        voicePages.activeDonutParlorSection = .tastingParlor
        var voiceRequests: [(mascarponeFilling, glazeVaultHeroLayer?, Int)] = []
        voicePages.glazeContentRepository.paginatedVoice = { shelf, cursor, size in
            voiceRequests.append((shelf, cursor, size))
            let following = shelf == .cherryCenter
            let start = following ? (cursor == nil ? 101 : 111) : (cursor == nil ? 1 : 11)
            return voicePage(Array(start..<(start + 10)), offset: following ? (cursor == nil ? 2_000 : 1_900) : (cursor == nil ? 900 : 800),
                             snapshot: following ? "follow-snapshot" : "recommend-snapshot")
        }
        voicePages.loadGlazeContent(showsLoading: false); await voicePages.glazeContentTask?.value
        voicePages.loadMoreVoiceRooms(); await voicePages.voicePageTasks[.apricotCompote]?.value
        voicePages.tastingParlorShelf = .cherryCenter
        voicePages.loadMoreVoiceRooms(); await voicePages.voicePageTasks[.cherryCenter]?.value
        let requestedRecommend = voiceRequests.filter { $0.0 == .apricotCompote }
        let requestedFollow = voiceRequests.filter { $0.0 == .cherryCenter }
        try check(requestedRecommend.map { $0.1?.offset } == [nil, 900]
            && requestedFollow.map { $0.1?.offset } == [nil, 2_000]
            && requestedRecommend.last?.1?.snapshotID == "recommend-snapshot"
            && requestedFollow.last?.1?.snapshotID == "follow-snapshot"
            && voiceRequests.allSatisfy { $0.2 == 10 },
            "Recommend and Follow use independent last-score/snapshot cursors with the standard ten-room page size")
        try check(voicePages.renderedVoiceRoomIDs[.apricotCompote] == (1...20).map(String.init)
            && voicePages.renderedVoiceRoomIDs[.cherryCenter] == (101...120).map(String.init),
            "voice load more appends within its selected filter without replacing either successful list")
        cases += 1

        voicePages.tastingParlorShelf = .apricotCompote
        let voiceFailureGate = Gate()
        voicePages.glazeContentRepository.paginatedVoice = { shelf, cursor, size in
            voiceRequests.append((shelf, cursor, size)); await voiceFailureGate.wait()
            throw GlazeVaultTradeError.http(503)
        }
        voicePages.loadMoreVoiceRooms(); let failedVoiceMore = voicePages.voicePageTasks[.apricotCompote]
        try await entered(voiceFailureGate)
        let pendingVoiceRequestCount = voiceRequests.count
        voicePages.loadMoreVoiceRooms()
        try check(voiceRequests.count == pendingVoiceRequestCount,
            "repeated voice pull-up gestures cannot duplicate an in-flight page request")
        voiceFailureGate.release(); await failedVoiceMore?.value
        try check(voicePages.voicePaginations[.apricotCompote]?.failed == true
            && voicePages.voicePaginations[.apricotCompote]?.nextCursor?.offset == 800
            && voicePages.voicePageTasks[.apricotCompote] == nil
            && voicePages.renderedVoiceRoomIDs[.apricotCompote]?.count == 20,
            "a failed voice page keeps visible rooms and its score cursor while releasing the task for retry")
        voicePages.glazeContentRepository.paginatedVoice = { shelf, cursor, size in
            voiceRequests.append((shelf, cursor, size))
            return voicePage(Array(21...23), offset: 700, snapshot: "recommend-snapshot")
        }
        voicePages.loadMoreVoiceRooms(); await voicePages.voicePageTasks[.apricotCompote]?.value
        let exhaustedVoiceRequestCount = voiceRequests.count
        voicePages.loadMoreVoiceRooms()
        try check(voiceRequests.suffix(2).allSatisfy { $0.1?.offset == 800 }
            && voicePages.renderedVoiceRoomIDs[.apricotCompote] == (1...23).map(String.init)
            && voicePages.voicePaginations[.apricotCompote]?.hasMore == false
            && voiceRequests.count == exhaustedVoiceRequestCount,
            "voice retry repeats the exact failed cursor, and a short page ends further loading")
        cases += 1

        seedVoice(voicePages, ids: Array(1...10), offset: 900)
        let voiceGuardedRequestCount = voiceRequests.count
        voicePages.activeDonutParlorSection = .donutCounter
        voicePages.loadMoreVoiceRooms()
        voicePages.activeDonutParlorSection = .tastingParlor
        voicePages.sprinkleRefresh.isRefreshing = true
        voicePages.loadMoreVoiceRooms()
        voicePages.sprinkleRefresh.isRefreshing = false
        try check(voiceRequests.count == voiceGuardedRequestCount
            && voicePages.voicePaginations[.apricotCompote]?.isLoading == false,
            "other tabs and active pull-down refresh cannot start voice load more")
        cases += 1

        let replacedVoiceGate = Gate()
        voicePages.glazeContentRepository.paginatedVoice = { shelf, cursor, size in
            await replacedVoiceGate.wait(); return voicePage(Array(11...20), offset: 800)
        }
        voicePages.loadMoreVoiceRooms(); let replacedVoiceMore = voicePages.voicePageTasks[.apricotCompote]
        try await entered(replacedVoiceGate)
        voicePages.glazeContentRepository.paginatedVoice = { shelf, _, _ in
            voicePage(Array((shelf == .apricotCompote ? 201 : 301)...(shelf == .apricotCompote ? 210 : 310)), offset: 500)
        }
        voicePages.loadGlazeContent(showsLoading: false); await voicePages.glazeContentTask?.value
        try check(replacedVoiceMore?.isCancelled == true
            && voicePages.renderedVoiceRoomIDs[.apricotCompote] == (201...210).map(String.init),
            "pull-down refresh cancels a pending voice page and replaces it with its new first page")
        let currentVoiceGate = Gate()
        voicePages.glazeContentRepository.paginatedVoice = { _, _, _ in
            await currentVoiceGate.wait(); return voicePage(Array(211...220), offset: 400)
        }
        voicePages.loadMoreVoiceRooms(); let currentVoiceMore = voicePages.voicePageTasks[.apricotCompote]
        try await entered(currentVoiceGate)
        replacedVoiceGate.release(); await replacedVoiceMore?.value
        try check(voicePages.renderedVoiceRoomIDs[.apricotCompote] == (201...210).map(String.init)
            && voicePages.voicePageTasks[.apricotCompote] != nil
            && voicePages.voicePaginations[.apricotCompote]?.isLoading == true,
            "a cancelled voice response cannot append stale rooms or clear the newer filter task")
        currentVoiceGate.release(); await currentVoiceMore?.value
        try check(voicePages.renderedVoiceRoomIDs[.apricotCompote] == (201...220).map(String.init),
            "the current voice page completes after an older cancelled generation returns")
        cases += 1

        let changedVoiceOwnerGate = Gate()
        voicePages.glazeContentRepository.paginatedVoice = { _, _, _ in
            await changedVoiceOwnerGate.wait(); return voicePage(Array(221...230), offset: 300)
        }
        voicePages.loadMoreVoiceRooms(); let changedVoiceOwnerMore = voicePages.voicePageTasks[.apricotCompote]
        try await entered(changedVoiceOwnerGate)
        store.sessionEpoch += 1; voicePages.resetGlazeContentOwner(owner())
        try check(changedVoiceOwnerMore?.isCancelled == true && voicePages.voicePageTasks.isEmpty
            && voicePages.voicePaginations.values.allSatisfy { $0.rooms.isEmpty }
            && voicePages.glazeRecommendedVoiceRooms.isEmpty && voicePages.glazeFollowedVoiceRooms.isEmpty,
            "account changes immediately cancel both voice filters and clear their account-specific cards")
        changedVoiceOwnerGate.release(); await changedVoiceOwnerMore?.value
        try check(voicePages.glazeRecommendedVoiceRooms.isEmpty && voicePages.glazeFollowedVoiceRooms.isEmpty,
            "late previous-account voice pages cannot restore the cleared room lists")
        cases += 1

        let unnotifiedVoice = MainPage(), unnotifiedVoiceGate = Gate()
        unnotifiedVoice.resetGlazeContentOwner(owner()); unnotifiedVoice.activeDonutParlorSection = .tastingParlor
        seedVoice(unnotifiedVoice, ids: Array(1...10), offset: 900)
        unnotifiedVoice.glazeContentRepository.paginatedVoice = { _, _, _ in
            await unnotifiedVoiceGate.wait(); return voicePage(Array(11...20), offset: 800)
        }
        unnotifiedVoice.loadMoreVoiceRooms(); let unnotifiedVoiceMore = unnotifiedVoice.voicePageTasks[.apricotCompote]
        try await entered(unnotifiedVoiceGate)
        store.sessionEpoch += 1
        unnotifiedVoiceGate.release(); await unnotifiedVoiceMore?.value
        try check(unnotifiedVoice.voicePaginations[.apricotCompote]?.rooms.map(\.passionfruitMousse) == (1...10).map(String.init),
            "the voice owner guard rejects a late page before account-change notifications reach the controller")
        cases += 1

        let initialVoicePaging = MainPage(), pendingInitialFollow = Gate()
        initialVoicePaging.resetGlazeContentOwner(owner()); initialVoicePaging.activeDonutParlorSection = .tastingParlor
        initialVoicePaging.glazeContentRepository.paginatedVoice = { shelf, cursor, _ in
            if shelf == .cherryCenter { await pendingInitialFollow.wait(); return voicePage([], offset: 0) }
            return voicePage(Array((cursor == nil ? 1 : 11)...(cursor == nil ? 10 : 20)), offset: cursor == nil ? 900 : 800)
        }
        initialVoicePaging.loadGlazeContent(showsLoading: false); try await entered(pendingInitialFollow)
        initialVoicePaging.loadMoreVoiceRooms(); await initialVoicePaging.voicePageTasks[.apricotCompote]?.value
        try check(initialVoicePaging.pendingInitialGlazeSections.contains(.tastingParlor)
            && initialVoicePaging.tastingParlorGlazeSheen.isLoadingVisible
            && initialVoicePaging.renderedVoiceRoomIDs[.apricotCompote] == (1...20).map(String.init),
            "later-page completion cannot dismiss the initial voice skeleton while the independent Follow request is pending")
        pendingInitialFollow.release(); await initialVoicePaging.glazeContentTask?.value
        try check(!initialVoicePaging.pendingInitialGlazeSections.contains(.tastingParlor)
            && initialVoicePaging.renderedVoiceRoomIDs[.apricotCompote] == (1...20).map(String.init),
            "late initial Follow completion ends its skeleton without overwriting appended Recommend rooms")
        cases += 1

        let independentVoiceStatus = MainPage()
        independentVoiceStatus.resetGlazeContentOwner(owner()); independentVoiceStatus.tastingParlorShelf = .cherryCenter
        independentVoiceStatus.glazeContentRepository.paginatedVoice = { shelf, _, _ in
            if shelf == .apricotCompote { throw GlazeVaultTradeError.http(503) }
            return voicePage(Array(401...410), offset: 1_000)
        }
        independentVoiceStatus.loadGlazeContent(showsLoading: false); await independentVoiceStatus.glazeContentTask?.value
        try check(independentVoiceStatus.tastingParlorStatusLabel.isHidden
            && independentVoiceStatus.glazeFollowedVoiceRooms.count == 10,
            "a failed Recommend request cannot overlay an error on a successful Follow list")
        independentVoiceStatus.tastingParlorShelf = .apricotCompote
        independentVoiceStatus.updateTastingParlorStatus()
        try check(!independentVoiceStatus.tastingParlorStatusLabel.isHidden
            && independentVoiceStatus.tastingParlorStatusLabel.text == "Rooms could not be loaded. Pull down to retry.",
            "switching to the failed voice filter reveals only that filter's retry feedback")
        cases += 1

        seedVoice(independentVoiceStatus, ids: Array(1...10), offset: 900)
        independentVoiceStatus.activeDonutParlorSection = .tastingParlor
        var failedRefreshCalls = 0
        independentVoiceStatus.glazeContentRepository.paginatedVoice = { _, _, _ in
            failedRefreshCalls += 1; throw GlazeVaultTradeError.http(503)
        }
        independentVoiceStatus.loadGlazeContent(showsLoading: false); await independentVoiceStatus.glazeContentTask?.value
        let failedRefreshCallCount = failedRefreshCalls
        independentVoiceStatus.loadMoreVoiceRooms()
        try check(independentVoiceStatus.voicePaginations[.apricotCompote]?.failedRefresh == true
            && independentVoiceStatus.renderedVoiceRoomIDs[.apricotCompote] == (1...10).map(String.init)
            && failedRefreshCalls == failedRefreshCallCount,
            "a failed first-page refresh preserves cards but blocks pagination through the previous snapshot")
        independentVoiceStatus.glazeContentRepository.paginatedVoice = { _, cursor, _ in
            voicePage(Array((cursor == nil ? 501 : 511)...(cursor == nil ? 510 : 520)), offset: cursor == nil ? 500 : 400)
        }
        independentVoiceStatus.loadGlazeContent(showsLoading: false); await independentVoiceStatus.glazeContentTask?.value
        independentVoiceStatus.loadMoreVoiceRooms(); await independentVoiceStatus.voicePageTasks[.apricotCompote]?.value
        try check(independentVoiceStatus.voicePaginations[.apricotCompote]?.failedRefresh == false
            && independentVoiceStatus.renderedVoiceRoomIDs[.apricotCompote] == (501...520).map(String.init),
            "a successful retry refresh establishes a fresh snapshot before voice pagination resumes")
        cases += 1

        let oldFollowGate = Gate(), newFollowGate = Gate(), oldFollowButton = UIButton(), newFollowButton = UIButton()
        page.glazeTrendingMomentItems = [postValue()]
        oldFollowButton.accessibilityIdentifier = "7"
        page.glazeSocialRepository.follow = { _, _ in await oldFollowGate.wait(); throw GlazeVaultTradeError.http(503) }
        page.toggleTastingJournalFollow(oldFollowButton)
        let oldFollow = page.glazeJournalFollowTask
        try await entered(oldFollowGate)
        store.sessionEpoch += 1
        page.glazeContentRepository.live = { [] }; page.glazeContentRepository.voice = { _ in [] }
        page.glazeContentRepository.moments = { _ in [postValue()] }
        page.refreshGlazeServerProfile()
        try check(page.glazeJournalFollowTask == nil, "account change releases the previous owner's pending follow task immediately")
        await page.glazeContentTask?.value
        newFollowButton.accessibilityIdentifier = "7"
        page.glazeSocialRepository.follow = { _, _ in await newFollowGate.wait() }
        page.toggleTastingJournalFollow(newFollowButton)
        let newFollow = page.glazeJournalFollowTask
        try await entered(newFollowGate)
        page.hints = []
        oldFollowGate.release(); await oldFollow?.value
        try check(page.hints.isEmpty && !oldFollowButton.isEnabled && oldFollowButton.title == "✓", "cancelled old follow failure cannot restore old controls or toast in the new account")
        try check(page.glazeJournalFollowTask != nil, "late old follow cleanup cannot clear a newer account's active task")
        newFollowGate.release(); await newFollow?.value
        await page.glazeContentTask?.value
        try check(page.glazeJournalFollowTask == nil, "current follow success releases its own task and refreshes")
        cases += 1

        let lateFollowGate = Gate(), lateFollowButton = UIButton()
        page.glazeTrendingMomentItems = [postValue()]; lateFollowButton.accessibilityIdentifier = "7"
        page.glazeSocialRepository.follow = { _, _ in await lateFollowGate.wait() }
        page.toggleTastingJournalFollow(lateFollowButton)
        let lateFollow = page.glazeJournalFollowTask
        try await entered(lateFollowGate)
        store.sessionEpoch += 1
        var unwantedReloads = 0
        page.glazeContentRepository.live = { unwantedReloads += 1; return [] }
        lateFollowGate.release(); await lateFollow?.value
        try check(unwantedReloads == 0 && page.glazeJournalFollowTask == nil, "old owner success cannot trigger content refresh even before a session notification is handled")
        cases += 1

        let remote = RemotePage()
        remote.remoteRepository.userMoments = { _ in throw GlazeVaultTradeError.http(503) }
        TinGlazePromptStyler.messages = []
        remote.loadRemoteCard(); await remote.remoteTask?.value
        try check(remote.remoteCard?.vanillaBeanIcing == 42 && remote.remoteStatus.isHidden && !remote.placeholderVisible, "feed failure does not hide successful remote profile")
        try check(!TinGlazePromptStyler.messages.isEmpty, "partial failure remains visible as feedback")
        cases += 1
        remote.remoteMoments = [postValue()]
        remote.remoteRepository.profile = { _ in throw GlazeVaultTradeError.http(503) }
        remote.loadRemoteCard(showsLoading: false); await remote.remoteTask?.value
        try check(remote.remoteCard != nil && remote.remoteMoments.count == 1 && remote.remoteStatus.isHidden, "same-owner remote refresh keeps prior card and feed")
        cases += 1
        let oldGate = Gate()
        remote.remoteRepository.profile = { _ in await oldGate.wait(); throw GlazeVaultTradeError.http(503) }
        remote.loadRemoteCard(); let stale = remote.remoteTask; try await entered(oldGate)
        remote.remoteRepository.profile = { profileValue($0, mutual: true, chat: true) }
        remote.remoteRepository.userMoments = { _ in [] }
        remote.loadRemoteCard(); await remote.remoteTask?.value
        TinGlazePromptStyler.messages = []; oldGate.release(); await stale?.value
        try check(remote.remoteCard?.backendMutualFollow == true && TinGlazePromptStyler.messages.isEmpty && remote.remoteStatus.isHidden, "late old profile errors do not cover newer successful request")
        cases += 1
        remote.remoteCard = profileValue(42, mutual: nil, chat: nil)
        try check(remote.remoteTrailState == .unknown, "missing mutual permission remains unknown")
        remote.remoteCard = profileValue(42, mutual: true); try check(remote.remoteTrailState == .mutual, "true backend mutual relation is preserved")
        remote.remoteCard = profileValue(42, mutual: false, followed: true); try check(remote.remoteTrailState == .waitingForFollowBack, "known false mutual relation uses actual follow state")
        cases += 1
        let actionGate = Gate(); var completed = false
        remote.performRemoteAction({ await actionGate.wait(); throw GlazeVaultTradeError.http(503) }, success: { (_: Void) in completed = true })
        let oldAction = remote.remoteActionTask; try await entered(actionGate)
        remote.remoteActionRequestID = UUID(); TinGlazePromptStyler.messages = []
        actionGate.release(); await oldAction?.value
        try check(!completed && TinGlazePromptStyler.messages.isEmpty, "late action error cannot mutate new request state")
        remote.remoteActionTask = nil
        cases += 1
        store.sessionEpoch += 1
        remote.loadRemoteCard(showsLoading: false); await remote.remoteTask?.value
        try check(remote.remoteOwnerKey == owner() && remote.remoteMoments.isEmpty, "remote page resets to current owner")
        cases += 1

        let slowFeedGate = Gate()
        remote.remoteCard = nil
        remote.remoteRepository.profile = { profileValue($0, mutual: false, followed: false) }
        remote.remoteRepository.userMoments = { _ in await slowFeedGate.wait(); return [postValue()] }
        remote.loadRemoteCard(); try await entered(slowFeedGate)
        for _ in 0..<10000 { if remote.remoteCard != nil && !remote.placeholderVisible { break }; await Task.yield() }
        let readRequestID = remote.remoteRequestID
        var actionRan = false
        remote.performRemoteAction({ actionRan = true }, success: { (_: Void) in })
        await remote.remoteActionTask?.value
        try check(actionRan && remote.remoteTask != nil && remote.remoteRequestID == readRequestID, "rendered remote profile accepts actions without waiting for its slow independent feed")
        slowFeedGate.release(); await remote.remoteTask?.value
        try check(remote.remoteMoments.count == 1, "independent action does not discard the pending successful feed")
        cases += 1

        let staleOwnerActionGate = Gate()
        remote.performRemoteAction({ await staleOwnerActionGate.wait(); throw GlazeVaultTradeError.http(503) }, success: { (_: Void) in })
        let staleOwnerAction = remote.remoteActionTask
        try await entered(staleOwnerActionGate)
        store.sessionEpoch += 1
        remote.remoteRepository.userMoments = { _ in [] }
        remote.remoteSessionChanged()
        try check(remote.remoteActionTask == nil, "owner change cancels and releases the independent action immediately")
        TinGlazePromptStyler.messages = []
        staleOwnerActionGate.release(); await staleOwnerAction?.value
        await remote.remoteTask?.value
        try check(TinGlazePromptStyler.messages.isEmpty, "old account action cannot toast after the new profile starts loading")
        cases += 1

        // Execute the real Profile refresh entry and task lifecycle. Only the
        // service and UIKit boundaries are controlled; task cleanup stays in
        // the extracted production methods below.
        let sessionRepository = WevVGlazeSessionRepository.pastryTrailDiary
        let profileSocialRepository = WevVGlazeSocialRepository.pastryTrailDiary
        func profileRefreshPage() -> MainPage {
            store.isTasterReady = true
            store.currentGlazeCredentials = OfflineAccount(vanillaBeanIcing: 7)
            runtime.prepareHook = nil
            sessionRepository.fetchProfile = {}
            profileSocialRepository.userMoments = { _ in [] }
            let page = MainPage()
            page.resetGlazeContentOwner(owner())
            page.activeDonutParlorSection = .zestyOrangeHarmony
            page.profileRenderCount = 0
            return page
        }
        let refreshedProfile = profileRefreshPage(), profileInfoGate = Gate(), profilePostsGate = Gate()
        let profileFetchesBefore = sessionRepository.profileCalls
        var profileUsers: [Int64] = []
        sessionRepository.fetchProfile = { await profileInfoGate.wait() }
        profileSocialRepository.userMoments = { user in
            profileUsers.append(user); await profilePostsGate.wait(); return [postValue(901)]
        }
        refreshedProfile.sprinkleRefresh.beginRefreshing()
        refreshedProfile.refreshSprinkleMoments()
        let successfulProfileTask = refreshedProfile.glazeProfileTask
        try await entered(profileInfoGate); try await entered(profilePostsGate)
        try check(refreshedProfile.glazeContentTask == nil && sessionRepository.profileCalls == profileFetchesBefore + 1
            && profileUsers == [7], "Profile pull-down refresh requests the signed-in profile and its own posts without reloading unrelated tabs")
        profileInfoGate.release()
        for _ in 0..<50 { await Task.yield() }
        try check(refreshedProfile.sprinkleRefresh.isRefreshing && refreshedProfile.sprinkleRefresh.endCount == 0,
            "Profile refresh remains active while its posts request is still pending")
        profilePostsGate.release(); await successfulProfileTask?.value
        try check(!refreshedProfile.sprinkleRefresh.isRefreshing && refreshedProfile.sprinkleRefresh.endCount == 1
            && refreshedProfile.glazeProfileTask == nil && refreshedProfile.renderedProfileMomentIDs == [901],
            "successful Profile refresh updates the visible posts and finishes its refresh exactly once")
        cases += 1

        for profileFails in [true, false] {
            let failedProfile = profileRefreshPage(), infoGate = Gate(), postsGate = Gate()
            failedProfile.glazeProfileMomentItems = [postValue(902)]
            sessionRepository.fetchProfile = {
                await infoGate.wait()
                if profileFails { throw GlazeVaultTradeError.http(503) }
            }
            profileSocialRepository.userMoments = { _ in
                await postsGate.wait()
                if !profileFails { throw GlazeVaultTradeError.http(503) }
                return []
            }
            failedProfile.sprinkleRefresh.beginRefreshing()
            failedProfile.refreshSprinkleMoments()
            let task = failedProfile.glazeProfileTask
            try await entered(infoGate); try await entered(postsGate)
            infoGate.release(); postsGate.release(); await task?.value
            try check(!failedProfile.sprinkleRefresh.isRefreshing && failedProfile.sprinkleRefresh.endCount == 1
                && failedProfile.glazeProfileTask == nil && failedProfile.hints.count == 1
                && failedProfile.glazeProfileMomentItems.map(\.coconutCenter) == [902],
                "failure of either Profile request ends refreshing, keeps prior posts, and allows a later retry")
            cases += 1
        }

        for signedInWithoutID in [false, true] {
            let unavailableProfile = profileRefreshPage()
            store.isTasterReady = signedInWithoutID
            store.currentGlazeCredentials = nil
            let callsBefore = sessionRepository.profileCalls
            var postsCalls = 0
            profileSocialRepository.userMoments = { _ in postsCalls += 1; return [] }
            unavailableProfile.sprinkleRefresh.beginRefreshing()
            unavailableProfile.refreshSprinkleMoments()
            try check(!unavailableProfile.sprinkleRefresh.isRefreshing && unavailableProfile.sprinkleRefresh.endCount == 1
                && unavailableProfile.glazeProfileTask == nil && unavailableProfile.glazeContentTask == nil
                && sessionRepository.profileCalls == callsBefore && postsCalls == 0,
                "guest or missing-user Profile refresh releases the control without starting account or unrelated requests")
            cases += 1
        }

        let existingProfile = profileRefreshPage(), existingInfoGate = Gate(), existingPostsGate = Gate()
        let existingFetchesBefore = sessionRepository.profileCalls
        var existingPostsCalls = 0
        sessionRepository.fetchProfile = { await existingInfoGate.wait() }
        profileSocialRepository.userMoments = { _ in
            existingPostsCalls += 1; await existingPostsGate.wait(); return [postValue(903)]
        }
        existingProfile.loadGlazeProfileMoments()
        let existingTask = existingProfile.glazeProfileTask, existingRequest = existingProfile.glazeProfileRequestID
        try await entered(existingInfoGate); try await entered(existingPostsGate)
        existingProfile.sprinkleRefresh.beginRefreshing()
        existingProfile.refreshSprinkleMoments(); existingProfile.refreshSprinkleMoments()
        try check(existingProfile.glazeProfileRequestID == existingRequest && existingProfile.glazeProfileTask != nil
            && sessionRepository.profileCalls == existingFetchesBefore + 1 && existingPostsCalls == 1
            && existingProfile.sprinkleRefresh.isRefreshing && existingProfile.sprinkleRefresh.endCount == 0,
            "pulling during an existing Profile request reuses that request without ending the new indicator early")
        existingInfoGate.release(); existingPostsGate.release(); await existingTask?.value
        try check(existingProfile.sprinkleRefresh.endCount == 1 && existingProfile.glazeProfileTask == nil,
            "the reused Profile request owns completion of the pull-down refresh")
        cases += 1

        for nextTab: WevVDonutParlorSection in [.donutCounter, .tastingParlor, .tastingJournal] {
            let away = profileRefreshPage(), infoGate = Gate(), postsGate = Gate(), homeGate = Gate()
            sessionRepository.fetchProfile = { await infoGate.wait() }
            profileSocialRepository.userMoments = { _ in await postsGate.wait(); return [postValue(904)] }
            away.sprinkleRefresh.beginRefreshing(); away.refreshSprinkleMoments()
            let profileTask = away.glazeProfileTask
            try await entered(infoGate); try await entered(postsGate)
            // Current tab and the next user gesture are UIKit input boundaries.
            // The task completion logic is still the shipping controller code.
            away.activeDonutParlorSection = nextTab
            away.glazeContentRepository.live = {
                if nextTab == .donutCounter { await homeGate.wait() }; return []
            }
            away.glazeContentRepository.voice = { shelf in
                if nextTab == .tastingParlor && shelf == .apricotCompote { await homeGate.wait() }; return []
            }
            away.glazeContentRepository.moments = { shelf in
                if nextTab == .tastingJournal && shelf == .artisanFrySequence { await homeGate.wait() }; return []
            }
            away.sprinkleRefresh.beginRefreshing(); away.refreshSprinkleMoments()
            let otherTask = away.glazeContentTask
            try await entered(homeGate)
            let endsBeforeProfile = away.sprinkleRefresh.endCount
            infoGate.release(); postsGate.release(); await profileTask?.value
            try check(away.glazeProfileTask == nil && away.sprinkleRefresh.isRefreshing
                && away.sprinkleRefresh.endCount == endsBeforeProfile,
                "late Profile completion cannot stop a Home, Voice, or Discover refresh after switching tabs")
            homeGate.release(); await otherTask?.value
            try check(!away.sprinkleRefresh.isRefreshing && away.sprinkleRefresh.endCount == endsBeforeProfile + 1,
                "the selected content tab ends its own refresh when its requests finish")
            cases += 1
        }

        let backgroundHome = profileRefreshPage(), backgroundHomeGate = Gate()
        let currentProfileInfo = Gate(), currentProfilePosts = Gate()
        backgroundHome.activeDonutParlorSection = .donutCounter
        backgroundHome.glazeContentRepository.live = { await backgroundHomeGate.wait(); return [] }
        backgroundHome.sprinkleRefresh.beginRefreshing(); backgroundHome.refreshSprinkleMoments()
        let backgroundHomeTask = backgroundHome.glazeContentTask
        try await entered(backgroundHomeGate)
        backgroundHome.activeDonutParlorSection = .zestyOrangeHarmony
        sessionRepository.fetchProfile = { await currentProfileInfo.wait() }
        profileSocialRepository.userMoments = { _ in await currentProfilePosts.wait(); return [postValue(905)] }
        backgroundHome.sprinkleRefresh.beginRefreshing(); backgroundHome.refreshSprinkleMoments()
        let currentProfileTask = backgroundHome.glazeProfileTask
        try await entered(currentProfileInfo); try await entered(currentProfilePosts)
        let endsBeforeHome = backgroundHome.sprinkleRefresh.endCount
        backgroundHomeGate.release(); await backgroundHomeTask?.value
        try check(backgroundHome.sprinkleRefresh.isRefreshing && backgroundHome.sprinkleRefresh.endCount == endsBeforeHome,
            "a background Home load finishing cannot stop the active Profile refresh")
        currentProfileInfo.release(); currentProfilePosts.release(); await currentProfileTask?.value
        try check(!backgroundHome.sprinkleRefresh.isRefreshing && backgroundHome.sprinkleRefresh.endCount == endsBeforeHome + 1,
            "Profile completion still releases its indicator after background content finishes")
        cases += 1

        let backgroundFailure = profileRefreshPage(), prepareGate = Gate(), failureInfoGate = Gate(), failurePostsGate = Gate()
        backgroundFailure.activeDonutParlorSection = .donutCounter
        runtime.prepareHook = { await prepareGate.wait(); throw GlazeVaultTradeError.http(503) }
        backgroundFailure.sprinkleRefresh.beginRefreshing(); backgroundFailure.refreshSprinkleMoments()
        let failedHomeTask = backgroundFailure.glazeContentTask
        try await entered(prepareGate)
        backgroundFailure.activeDonutParlorSection = .zestyOrangeHarmony
        sessionRepository.fetchProfile = { await failureInfoGate.wait() }
        profileSocialRepository.userMoments = { _ in await failurePostsGate.wait(); return [] }
        backgroundFailure.sprinkleRefresh.beginRefreshing(); backgroundFailure.refreshSprinkleMoments()
        let unaffectedProfileTask = backgroundFailure.glazeProfileTask
        try await entered(failureInfoGate); try await entered(failurePostsGate)
        let endsBeforeFailure = backgroundFailure.sprinkleRefresh.endCount
        prepareGate.release(); await failedHomeTask?.value
        try check(backgroundFailure.sprinkleRefresh.isRefreshing && backgroundFailure.sprinkleRefresh.endCount == endsBeforeFailure,
            "a background startup failure cannot end a Profile refresh owned by independent account requests")
        runtime.prepareHook = nil
        failureInfoGate.release(); failurePostsGate.release(); await unaffectedProfileTask?.value
        try check(backgroundFailure.sprinkleRefresh.endCount == endsBeforeFailure + 1,
            "Profile refresh finishes normally after an unrelated startup failure")
        cases += 1

        for oldRequestFails in [false, true] {
            let changedProfile = profileRefreshPage(), oldInfo = Gate(), oldPosts = Gate(), newInfo = Gate(), newPosts = Gate()
            sessionRepository.fetchProfile = {
                await oldInfo.wait()
                if oldRequestFails { throw GlazeVaultTradeError.http(503) }
            }
            profileSocialRepository.userMoments = { _ in await oldPosts.wait(); return [postValue(906)] }
            changedProfile.sprinkleRefresh.beginRefreshing(); changedProfile.refreshSprinkleMoments()
            let oldTask = changedProfile.glazeProfileTask
            try await entered(oldInfo); try await entered(oldPosts)
            store.sessionEpoch += 1
            store.currentGlazeCredentials = OfflineAccount(vanillaBeanIcing: 99)
            let endsBeforeOwnerChange = changedProfile.sprinkleRefresh.endCount
            changedProfile.refreshGlazeServerProfile()
            try check(oldTask?.isCancelled == true && changedProfile.glazeProfileTask == nil
                && !changedProfile.sprinkleRefresh.isRefreshing
                && changedProfile.sprinkleRefresh.endCount == endsBeforeOwnerChange + 1,
                "account change cancels the prior Profile task and immediately releases its pull-down indicator")
            await changedProfile.glazeContentTask?.value
            sessionRepository.fetchProfile = { await newInfo.wait() }
            var requestedUsers: [Int64] = []
            profileSocialRepository.userMoments = { user in
                requestedUsers.append(user); await newPosts.wait(); return [postValue(907, owner: user)]
            }
            changedProfile.sprinkleRefresh.beginRefreshing(); changedProfile.refreshSprinkleMoments()
            let newTask = changedProfile.glazeProfileTask, newRequest = changedProfile.glazeProfileRequestID
            try await entered(newInfo); try await entered(newPosts)
            let endsBeforeOldReply = changedProfile.sprinkleRefresh.endCount
            oldInfo.release(); oldPosts.release(); await oldTask?.value
            try check(changedProfile.glazeProfileTask != nil && changedProfile.glazeProfileRequestID == newRequest
                && changedProfile.sprinkleRefresh.isRefreshing && changedProfile.sprinkleRefresh.endCount == endsBeforeOldReply
                && changedProfile.glazeProfileMomentItems.isEmpty && changedProfile.hints.isEmpty,
                "late success or failure from a cancelled account cannot replace data, show an error, or stop the new account's refresh")
            newInfo.release(); newPosts.release(); await newTask?.value
            try check(requestedUsers == [99] && changedProfile.renderedProfileMomentIDs == [907]
                && changedProfile.glazeProfileMomentItems.first?.vanillaBeanIcing == 99
                && !changedProfile.sprinkleRefresh.isRefreshing && changedProfile.sprinkleRefresh.endCount == endsBeforeOldReply + 1,
                "the new account alone renders its posts and finishes its own refresh")
            cases += 1
        }

        let cancelledProfile = profileRefreshPage(), cancelInfo = Gate(), cancelPosts = Gate()
        sessionRepository.fetchProfile = { await cancelInfo.wait() }
        profileSocialRepository.userMoments = { _ in await cancelPosts.wait(); return [postValue(908)] }
        cancelledProfile.sprinkleRefresh.beginRefreshing(); cancelledProfile.refreshSprinkleMoments()
        let cancelledTask = cancelledProfile.glazeProfileTask
        try await entered(cancelInfo); try await entered(cancelPosts)
        cancelledTask?.cancel(); cancelInfo.release(); cancelPosts.release(); await cancelledTask?.value
        try check(cancelledProfile.glazeProfileTask == nil && !cancelledProfile.sprinkleRefresh.isRefreshing
            && cancelledProfile.sprinkleRefresh.endCount == 1 && cancelledProfile.glazeProfileMomentItems.isEmpty
            && cancelledProfile.hints.isEmpty,
            "actual task cancellation cleans up the current Profile refresh without publishing late posts or an error")
        cases += 1
        sessionRepository.fetchProfile = {}; profileSocialRepository.userMoments = { _ in [] }

        func contentRefreshPage(_ section: WevVDonutParlorSection) -> MainPage {
            let page = profileRefreshPage()
            page.activeDonutParlorSection = section
            page.pendingInitialGlazeSections = []
            return page
        }
        for section: WevVDonutParlorSection in [.donutCounter, .tastingParlor, .tastingJournal] {
            for fails in [false, true] {
                let scoped = contentRefreshPage(section)
                let liveGate = Gate(), voiceGate = Gate(), feedGate = Gate()
                let hiddenVoiceGate = Gate(), hiddenFeedGate = Gate()
                seedLive(scoped, ids: [910])
                seedVoice(scoped, ids: [910], offset: 900)
                scoped.glazeTrendingMomentItems = [postValue(910)]
                var livePages: [Int] = []
                scoped.glazeContentRepository.paginatedLive = { number, _ in
                    livePages.append(number)
                    if number == 1 {
                        await liveGate.wait()
                        if section == .donutCounter && fails { throw GlazeVaultTradeError.http(503) }
                    }
                    let ids = number == 1 ? Array(1...10) : Array(11...20)
                    return glazeMarkLabel(formatter: ids.map(roomValue), gingerHoneyDrizzle: 30, followingList: ids.count)
                }
                scoped.glazeContentRepository.paginatedVoice = { shelf, _, _ in
                    if shelf == .apricotCompote {
                        await voiceGate.wait()
                        if section == .tastingParlor && fails { throw GlazeVaultTradeError.http(503) }
                        return voicePage(Array(1...10), offset: 800)
                    }
                    await hiddenVoiceGate.wait(); return voicePage([], offset: 0)
                }
                scoped.glazeContentRepository.moments = { shelf in
                    if shelf == .artisanFrySequence {
                        await feedGate.wait()
                        if section == .tastingJournal && fails { throw GlazeVaultTradeError.http(503) }
                        return [postValue(911)]
                    }
                    await hiddenFeedGate.wait(); return []
                }
                scoped.sprinkleRefresh.beginRefreshing(); scoped.refreshSprinkleMoments()
                let task = scoped.glazeContentTask
                try await entered(liveGate); try await entered(voiceGate); try await entered(feedGate)
                switch section {
                case .donutCounter: liveGate.release()
                case .tastingParlor: voiceGate.release()
                case .tastingJournal: feedGate.release()
                case .zestyOrangeHarmony: fatalError("Unexpected Profile case")
                }
                try await reached({ !scoped.sprinkleRefresh.isRefreshing },
                    "the visible section did not finish refreshing independently of other pending sections")
                try check(scoped.sprinkleRefresh.endCount == 1 && scoped.glazeContentRefreshOwner == nil,
                    "each visible section owns exactly one refresh completion on success or failure")
                if section == .donutCounter {
                    try check(scoped.renderedLiveRoomIDs == (fails ? ["910"] : (1...10).map(String.init)),
                        "Home renders its own result or keeps cached rooms while voice/feed remain blocked")
                    if !fails {
                        scoped.loadMoreHomeLiveRooms(); await scoped.homeLivePageTask?.value
                        try check(livePages == [1, 2] && scoped.renderedLiveRoomIDs == (1...20).map(String.init),
                            "finishing the Home refresh re-enables pagination before unrelated requests finish")
                    }
                } else if section == .tastingParlor {
                    try check(scoped.renderedVoiceRoomIDs[.apricotCompote] == (fails ? ["910"] : (1...10).map(String.init)),
                        "Voice renders its current filter or keeps cached rooms before Home and hidden Follow complete")
                } else {
                    try check(scoped.glazeTrendingMomentItems.map(\.coconutCenter) == (fails ? [910] : [911]),
                        "Explore publishes its current filter or preserves cached posts before hidden Follow and rooms complete")
                }
                liveGate.release(); voiceGate.release(); feedGate.release()
                try await entered(hiddenVoiceGate); try await entered(hiddenFeedGate)
                hiddenVoiceGate.release(); hiddenFeedGate.release(); await task?.value
                try check(scoped.sprinkleRefresh.endCount == 1,
                    "late background sections never finish the same refresh a second time")
                cases += 1
            }
        }

        let followVoice = contentRefreshPage(.tastingParlor)
        followVoice.tastingParlorShelf = .cherryCenter
        let followVoiceGate = Gate(), hiddenRecommendGate = Gate(), voiceHomeGate = Gate(), voiceFeedGate = Gate()
        var requestedVoiceShelves: [mascarponeFilling] = []
        followVoice.glazeContentRepository.live = { await voiceHomeGate.wait(); return [] }
        followVoice.glazeContentRepository.moments = { shelf in
            if shelf == .artisanFrySequence { await voiceFeedGate.wait() }; return []
        }
        followVoice.glazeContentRepository.paginatedVoice = { shelf, cursor, _ in
            requestedVoiceShelves.append(shelf)
            if cursor != nil { return voicePage(Array(11...20), offset: 700) }
            if shelf == .cherryCenter { await followVoiceGate.wait(); return voicePage(Array(1...10), offset: 800) }
            await hiddenRecommendGate.wait(); return voicePage([], offset: 0)
        }
        followVoice.sprinkleRefresh.beginRefreshing(); followVoice.refreshSprinkleMoments()
        let followVoiceTask = followVoice.glazeContentTask
        try await entered(followVoiceGate); try await entered(voiceHomeGate); try await entered(voiceFeedGate)
        try check(requestedVoiceShelves == [.cherryCenter], "the visible Follow voice filter starts before hidden Recommend and without waiting for Home")
        followVoiceGate.release(); try await entered(hiddenRecommendGate)
        try check(!followVoice.sprinkleRefresh.isRefreshing && followVoice.sprinkleRefresh.endCount == 1
            && followVoice.renderedVoiceRoomIDs[.cherryCenter] == (1...10).map(String.init),
            "the Follow voice result releases refresh while hidden Recommend and other modules remain pending")
        followVoice.loadMoreVoiceRooms(); await followVoice.voicePageTasks[.cherryCenter]?.value
        try check(followVoice.renderedVoiceRoomIDs[.cherryCenter] == (1...20).map(String.init),
            "the current voice filter can paginate while hidden Recommend still loads")
        hiddenRecommendGate.release(); voiceHomeGate.release(); voiceFeedGate.release(); await followVoiceTask?.value
        try check(followVoice.sprinkleRefresh.endCount == 1 && followVoice.renderedVoiceRoomIDs[.cherryCenter] == (1...20).map(String.init),
            "hidden voice completion preserves appended Follow rooms without ending refresh again")
        cases += 1

        let followFeed = contentRefreshPage(.tastingJournal)
        followFeed.tastingJournalShelf = .cherryCenter
        let followFeedGate = Gate(), hiddenTrendingGate = Gate(), feedHomeGate = Gate(), feedVoiceGate = Gate()
        var requestedFeedShelves: [goldenCrumbDough] = []
        followFeed.glazeContentRepository.live = { await feedHomeGate.wait(); return [] }
        followFeed.glazeContentRepository.voice = { shelf in
            if shelf == .apricotCompote { await feedVoiceGate.wait() }; return []
        }
        followFeed.glazeContentRepository.moments = { shelf in
            requestedFeedShelves.append(shelf)
            if shelf == .cherryCenter { await followFeedGate.wait(); return [postValue(912)] }
            await hiddenTrendingGate.wait(); return [postValue(913)]
        }
        followFeed.sprinkleRefresh.beginRefreshing(); followFeed.refreshSprinkleMoments()
        let followFeedTask = followFeed.glazeContentTask
        try await entered(followFeedGate); try await entered(feedHomeGate); try await entered(feedVoiceGate)
        try check(requestedFeedShelves == [.cherryCenter], "the visible Follow feed starts before hidden Trending")
        followFeedGate.release(); try await entered(hiddenTrendingGate)
        try check(!followFeed.sprinkleRefresh.isRefreshing && followFeed.sprinkleRefresh.endCount == 1
            && followFeed.glazeFollowedMomentItems.map(\.coconutCenter) == [912] && followFeed.glazeTrendingMomentItems.isEmpty,
            "Follow posts render and end refreshing without waiting for hidden Trending or room requests")
        hiddenTrendingGate.release(); feedHomeGate.release(); feedVoiceGate.release(); await followFeedTask?.value
        try check(followFeed.sprinkleRefresh.endCount == 1 && followFeed.glazeTrendingMomentItems.map(\.coconutCenter) == [913],
            "late hidden Trending still updates its cache without ending the completed Follow refresh")
        cases += 1

        for followFails in [false, true] {
            let trendingStatus = contentRefreshPage(.tastingJournal)
            trendingStatus.tastingJournalShelf = .cherryCenter
            let pendingTrending = Gate()
            trendingStatus.tastingJournalStatusLabel.text = "Existing Trending status"
            trendingStatus.glazeContentRepository.moments = { shelf in
                if shelf == .cherryCenter {
                    if followFails { throw GlazeVaultTradeError.http(503) }
                    return []
                }
                await pendingTrending.wait(); return [postValue(917)]
            }
            trendingStatus.sprinkleRefresh.beginRefreshing(); trendingStatus.refreshSprinkleMoments()
            let pendingTrendingStatus = trendingStatus.tastingJournalStatusLabel.text
            let statusTask = trendingStatus.glazeContentTask
            try await entered(pendingTrending)
            try check(!trendingStatus.sprinkleRefresh.isRefreshing && trendingStatus.sprinkleRefresh.endCount == 1
                && trendingStatus.tastingJournalStatusLabel.text == pendingTrendingStatus,
                "empty or failed Follow ends its refresh without replacing the Trending-owned New Post status")
            pendingTrending.release(); await statusTask?.value
            try check(trendingStatus.tastingJournalStatusLabel.isHidden
                && trendingStatus.glazeTrendingMomentItems.map(\.coconutCenter) == [917]
                && trendingStatus.sprinkleRefresh.endCount == 1,
                "successful Trending hides its own New Post status despite an empty or failed visible Follow response")
            cases += 1
        }

        let generations = contentRefreshPage(.donutCounter), oldContentGate = Gate(), currentContentGate = Gate()
        generations.glazeContentRepository.live = { await oldContentGate.wait(); return [roomValue(914)] }
        generations.sprinkleRefresh.beginRefreshing(); generations.refreshSprinkleMoments()
        let oldContentTask = generations.glazeContentTask, oldContentID = generations.glazeContentRequestID
        try await entered(oldContentGate)
        generations.glazeContentRepository.live = { await currentContentGate.wait(); return [roomValue(915)] }
        generations.sprinkleRefresh.beginRefreshing(); generations.refreshSprinkleMoments()
        let currentContentTask = generations.glazeContentTask, currentContentID = generations.glazeContentRequestID
        try await entered(currentContentGate)
        oldContentGate.release(); await oldContentTask?.value
        generations.finishGlazeContentRefresh(for: .donutCounter, requestID: oldContentID)
        generations.finishGlazeContentRefresh(for: .tastingParlor, requestID: currentContentID)
        try check(oldContentTask?.isCancelled == true && generations.sprinkleRefresh.isRefreshing
            && generations.sprinkleRefresh.endCount == 0 && generations.glazeContentRefreshOwner?.requestID == currentContentID
            && generations.renderedLiveRoomIDs.isEmpty,
            "cancelled generations and mismatched sections cannot stop the newest refresh or render an older response")
        currentContentGate.release(); await currentContentTask?.value
        generations.finishGlazeContentRefresh(for: .donutCounter, requestID: currentContentID)
        try check(!generations.sprinkleRefresh.isRefreshing && generations.sprinkleRefresh.endCount == 1
            && generations.glazeContentRefreshOwner == nil && generations.renderedLiveRoomIDs == ["915"],
            "the current generation renders its data and owns idempotent refresh completion")
        cases += 1

        for accountChanges in [false, true] {
            let interrupted = contentRefreshPage(.donutCounter), interruptedGate = Gate()
            interrupted.glazeContentRepository.live = { await interruptedGate.wait(); return [roomValue(916)] }
            interrupted.sprinkleRefresh.beginRefreshing(); interrupted.refreshSprinkleMoments()
            let interruptedTask = interrupted.glazeContentTask
            try await entered(interruptedGate)
            if accountChanges { store.sessionEpoch += 1 }
            else { interruptedTask?.cancel() }
            interruptedGate.release(); await interruptedTask?.value
            try check(!interrupted.sprinkleRefresh.isRefreshing && interrupted.sprinkleRefresh.endCount == 1
                && interrupted.glazeContentRefreshOwner == nil && interrupted.renderedLiveRoomIDs.isEmpty,
                "cancellation or an owner-mismatch return releases only its own outstanding refresh and rejects late data")
            cases += 1
        }

        let prefetched = contentRefreshPage(.tastingJournal)
        prefetched.loadGlazeContent(showsLoading: false); await prefetched.glazeContentTask?.value
        try check(prefetched.sprinkleRefresh.endCount == 0 && prefetched.glazeContentRefreshOwner == nil,
            "background prefetch without a user refresh never claims or ends the shared control")
        cases += 1
        func momentPage(_ ids: [Int64], next: Int64? = nil) -> LisenNoticepoplater.choiceStackPacket {
            .init(posts: ids.map { .init(card: postValue($0)) }, nextCursor: next, isLastPage: next == nil)
        }
        let journal = contentRefreshPage(.tastingJournal)
        var feedRequests: [(Int64, Int)] = []
        journal.glazeContentRepository.paginatedMoments = { cursor, size in
            feedRequests.append((cursor, size)); return momentPage(Array(1...20), next: 20)
        }
        journal.loadGlazeContent(showsLoading: false); await journal.glazeContentTask?.value
        try check(feedRequests.count == 1 && feedRequests[0].0 == 0 && feedRequests[0].1 == 20
            && journal.glazeTrendingMomentItems.count == 20 && journal.cocoaWeekendFestival.hasMore,
            "Discover starts with one twenty-post feed page and retains its server cursor")
        cases += 1
        let morePostsGate = Gate()
        journal.glazeContentRepository.paginatedMoments = { cursor, size in
            feedRequests.append((cursor, size)); await morePostsGate.wait()
            return momentPage(Array(20...39), next: 39)
        }
        journal.loadGlazeMomentContent(); let morePostsTask = journal.strawberryMilkSwirl
        try await entered(morePostsGate)
        journal.loadGlazeMomentContent()
        try check(feedRequests.count == 2 && feedRequests.last?.0 == 20 && journal.cocoaWeekendFestival.isLoading,
            "repeated pulls cannot duplicate an in-flight cursor request")
        morePostsGate.release(); await morePostsTask?.value
        try check(journal.glazeTrendingMomentItems.map(\.coconutCenter) == Array(1...39),
            "next-page append deduplicates overlap without discarding existing posts")
        cases += 1
        journal.glazeContentRepository.paginatedMoments = { cursor, size in
            feedRequests.append((cursor, size)); throw GlazeVaultTradeError.http(503)
        }
        journal.loadGlazeMomentContent(); await journal.strawberryMilkSwirl?.value
        try check(journal.cocoaWeekendFestival.failed && !journal.cocoaWeekendFestival.isLoading
            && journal.cocoaWeekendFestival.cursor == 39 && journal.glazeTrendingMomentItems.count == 39,
            "a failed next page releases loading and retains visible posts and retry cursor")
        journal.glazeContentRepository.paginatedMoments = { cursor, size in
            feedRequests.append((cursor, size)); return momentPage(Array(40...44))
        }
        journal.loadGlazeMomentContent(); await journal.strawberryMilkSwirl?.value
        let endedFeedCalls = feedRequests.count
        journal.loadGlazeMomentContent()
        try check(feedRequests.suffix(2).allSatisfy { $0.0 == 39 } && journal.glazeTrendingMomentItems.count == 44
            && !journal.cocoaWeekendFestival.hasMore && feedRequests.count == endedFeedCalls,
            "retry uses the same cursor and the final page blocks subsequent requests")
        cases += 1
        journal.glazeContentRepository.paginatedMoments = { _, _ in throw GlazeVaultTradeError.http(503) }
        journal.loadGlazeContent(showsLoading: false); await journal.glazeContentTask?.value
        try check(journal.glazeTrendingMomentItems.count == 44 && journal.cocoaWeekendFestival.failed
            && journal.cocoaWeekendFestival.start() == nil,
            "failed refresh preserves cards while blocking pagination through the previous feed snapshot")
        cases += 1
        journal.glazeContentRepository.paginatedMoments = { _, _ in momentPage(Array(201...220), next: 220) }
        journal.loadGlazeContent(showsLoading: false); await journal.glazeContentTask?.value
        let stalePostsGate = Gate()
        journal.glazeContentRepository.paginatedMoments = { _, _ in
            await stalePostsGate.wait(); return momentPage(Array(221...240), next: 240)
        }
        journal.loadGlazeMomentContent(); let stalePostsTask = journal.strawberryMilkSwirl
        try await entered(stalePostsGate)
        journal.glazeContentRepository.paginatedMoments = { _, _ in momentPage(Array(901...920), next: 920) }
        journal.loadGlazeContent(showsLoading: false); await journal.glazeContentTask?.value
        stalePostsGate.release(); await stalePostsTask?.value
        try check(journal.glazeTrendingMomentItems.map(\.coconutCenter) == Array(901...920)
            && journal.cocoaWeekendFestival.cursor == 920 && !journal.cocoaWeekendFestival.isLoading,
            "refresh cancels and invalidates the previous pending page even if its transport returns late")
        cases += 1
        let switchedPostsGate = Gate()
        journal.glazeContentRepository.paginatedMoments = { _, _ in
            await switchedPostsGate.wait(); return momentPage(Array(921...940), next: 940)
        }
        journal.loadGlazeMomentContent(); let switchedPostsTask = journal.strawberryMilkSwirl
        try await entered(switchedPostsGate)
        store.sessionEpoch += 1
        journal.resetGlazeContentOwner(owner())
        switchedPostsGate.release(); await switchedPostsTask?.value
        try check(journal.glazeTrendingMomentItems.isEmpty && journal.cocoaWeekendFestival.posts.isEmpty
            && journal.strawberryMilkSwirl == nil,
            "account changes clear feed cursor/cards and reject previous-account page replies")
        cases += 1
        var cyclic = LisenNoticepoplater.honeyScout()
        let firstCursor = cyclic.refresh()
        cyclic.completeGlaze(momentPage(Array(1...20), next: 20), requestID: firstCursor)
        let secondCursor = cyclic.start()!
        cyclic.completeGlaze(momentPage(Array(21...40), next: 40), requestID: secondCursor.id)
        let thirdCursor = cyclic.start()!
        cyclic.completeGlaze(momentPage(Array(41...60), next: 20), requestID: thirdCursor.id)
        try check(!cyclic.hasMore && cyclic.start() == nil, "cursor cycles cannot trigger an endless feed loop")
        let currentCursor = cyclic.refresh()
        try check(!cyclic.completeGlaze(momentPage([999]), requestID: firstCursor), "late generations are rejected")
        cyclic.completeGlaze(momentPage([]), requestID: currentCursor)
        try check(cyclic.posts.isEmpty && !cyclic.hasMore, "a real empty refresh clears previous posts")
        cases += 1
        let detailPage = MainPage(), detailButton = UIControl()
        detailPage.glazeTrendingMomentItems = [postValue(0), postValue(101)]
        detailPage.glazeFollowedMomentItems = [postValue(202)]
        detailPage.glazeProfileMomentItems = [postValue(303)]
        for id in [101, 202, 303] {
            detailButton.accessibilityIdentifier = String(id)
            detailPage.openDonutSnapshotDetail(detailButton)
        }
        try check(detailPage.presentedMomentIDs == [101, 202, 303],
            "valid feed, followed and profile records open their exact API-backed detail")
        for id: String? in [nil, "abc", "0", "-1", "999", "9223372036854775808"] {
            detailButton.accessibilityIdentifier = id
            detailPage.openDonutSnapshotDetail(detailButton)
        }
        try check(detailPage.presentedMomentIDs == [101, 202, 303] && detailPage.hints.count == 6
            && detailPage.hints.allSatisfy { $0 == "This content is no longer available." },
            "invalid, missing or stale IDs show unavailable and never open a sample or another post")
        cases += 2
        // Server/device-session follow flags never imply a signed-in UI state.
        let guestJournal = contentRefreshPage(.tastingJournal)
        let followed = postValue(1701, followed: true)
        store.isTasterReady = false
        let guestButton = guestJournal.makeTastingJournalFollowControl(followed, diameter: 24, fontSize: 14)
        try check(guestButton.title == "+" && guestButton.accessibilityLabel == "Follow Synthetic",
            "guest cards ignore a true server follow flag visually and for accessibility")
        guestJournal.toggleTastingJournalFollow(guestButton)
        try check(guestJournal.protectedGates == 1 && guestJournal.glazeJournalFollowTask == nil,
            "guest follow taps open login without starting a follow request")
        guestJournal.glazeContentRepository.moments = { _ in [followed] }
        guestJournal.glazeContentRepository.paginatedMoments = { cursor, _ in
            .init(posts: [.init(card: followed)], nextCursor: cursor == 0 ? 1701 : nil, isLastPage: cursor != 0)
        }
        guestJournal.loadGlazeContent(showsLoading: false); await guestJournal.glazeContentTask?.value
        try check(guestJournal.glazeTrendingMomentItems.count == 1 && guestJournal.glazeFollowedMomentItems.isEmpty,
            "guest refresh keeps public posts but ignores personalized followed feed data")
        guestJournal.loadGlazeMomentContent(); await guestJournal.strawberryMilkSwirl?.value
        try check(guestJournal.glazeFollowedMomentItems.isEmpty && !guestJournal.cocoaWeekendFestival.hasMore,
            "guest pagination cannot repopulate followed posts")
        store.isTasterReady = true
        let signedInButton = guestJournal.makeTastingJournalFollowControl(followed, diameter: 24, fontSize: 14)
        try check(signedInButton.title == "✓" && signedInButton.accessibilityLabel == "Unfollow Synthetic",
            "signed-in rendering preserves the real server follow state")
        guestJournal.loadGlazeContent(showsLoading: false); await guestJournal.glazeContentTask?.value
        try check(guestJournal.glazeFollowedMomentItems.map(\.coconutCenter) == [1701],
            "sign-in restores the account's followed posts on refresh")
        cases += 6
        print("Native integration source cases passed: \(cases)")
    }
}
'''


def methods(text, names):
    return "\n\n".join(declaration(text, name).replace("private ", "").replace(
        "#selector(toggleTastingJournalFollow(_:))", '"toggleTastingJournalFollow"') for name in names)


def main():
    kettle = (SOURCE / "kettleGlazeSequence.swift").read_text()
    main_page = (SOURCE / "TvVDonutcreamapricotFillinger.swift").read_text()
    remote = read_archive(ROOT / "WevSweetgd/WeeNo/Sources/LmnTasterCardController.swift")
    # Deprecated controller/facade cases remain historical offline checks only.
    historical_kettle = kettle + "\n" + read_archive(ROOT / "WevSweetgd/WeeNo/Sources/kettleGlazeSequence.legacy-models.swift")
    historical_kettle += "\n" + read_archive(ROOT / "WevSweetgd/WeeNo/Sources/kettleGlazeSequence.legacy-social.swift")
    live_stack = declaration(main_page, "private func rebuildHomeLiveRoomStack")
    assert ".prefix(" not in live_stack and "steamExpansionStudy.count" in live_stack
    assert "pastryTrailScroll.delegate = self" in declaration(main_page, "private func buildPastryTrailScroll")
    drag = declaration(main_page, "func scrollViewDidEndDragging")
    assert "scrollView === pastryTrailScroll" in drag and "homeLivePullDistance() >= 52" in drag
    assert "loadMoreHomeLiveRooms()" in drag
    assert "loadMoreVoiceRooms()" in drag and "activeDonutParlorSection == .tastingParlor" in drag
    assert "updateVoiceRoomLoadMoreFooter()" in declaration(main_page, "func scrollViewDidScroll")
    voice_layout = declaration(main_page, "private func buildTastingParlorPanel")
    assert "#selector(loadMoreVoiceRooms)" in voice_layout and "voiceLoadMoreFooter.bottomAnchor" in voice_layout
    # Initial placeholders follow the real independent requests and visible tab.
    assert "buildInitialGlazeSheenPanels()" in declaration(main_page, "override func viewDidLoad")
    for lifecycle, visible in (("viewDidAppear", "true"), ("viewWillDisappear", "false")):
        action = declaration(main_page, "override func " + lifecycle)
        assert "isGlazeContentVisible = " + visible in action
        assert "updateInitialGlazeLoadingVisibility(animated: false)" in action
    assert "updateInitialGlazeLoadingVisibility(animated: false)" in declaration(main_page, "private func switchDonutParlorSection")
    # Loading must follow request completion; the footer's two-second dismissal is independent.
    for name in ("private func loadGlazeContent", "private func finishInitialGlazeLoading"):
        assert "DispatchQueue.main.asyncAfter" not in declaration(main_page, name)
    assert "pendingInitialGlazeSections =" not in declaration(main_page, "private func loadGlazeContent")
    print("Initial skeleton lifecycle source guards passed: 6", flush=True)
    # Compatibility aliases may remain declarations, but no active call may use Cover.
    for path in re.findall(r'cafeDirectorySelection:\s*"([^"]+)"', kettle):
        if not path.startswith("/_v2/"):
            raise AssertionError("Active legacy native call remains")
    chat = declaration(remote, "private func openRemoteChat")
    assert ".conversation(userID:" in chat and "card.springyFinish" in chat
    assert ".user(userID:" in chat and 'GDonutdenCrumbCenterler.present' in chat
    assert "backendCanChat" not in chat and "confectionStudioCounter(" not in chat
    video = declaration(remote, "private func openRemoteVideo")
    assert "backendCanChat" in video and 'glazeNameField.messaging' in video and "card.silkyCenter" not in video
    composer = (SOURCE / "SugarMomentEbuController.swift").read_text()
    assert ".pendingReview = outcome" in composer and "Your post has been submitted for review." in composer
    detail = (SOURCE / "KipoDonutMomentController.swift").read_text()
    assert "localAuthorKey" not in detail and "init(vanillaStrawberryDuet:" not in detail
    assert ".buildWevvTasterScrollLayer(makeLargeFlavorNote:" in declaration(detail, "private func worldDoughnutNotebook")
    assert "donutSnapshots" not in main_page and "makeDonutSnapshotEntry" not in main_page
    # Archived native wallet/profile checks retain historical regression coverage only.
    wallet = (ROOT / "WevSweetgd/WeeNo/Sources/GDonutdenCrumbCenterler.swift").read_text()
    recharge_path = ROOT / "WevSweetgd/WeeNo/Sources/WevEnd/WevVGlazeNativeRechargeService.swift"
    recharge = recharge_path.read_text() if recharge_path.exists() else None
    catalog = declaration(wallet, "private func loadGlazeVaultProducts")
    assert "WevVGlazeNativeRechargeService.shared.packages()" in catalog
    assert "batchKey: package.productID" in catalog and "Product.products(for: catalog.map(\\.productID))" in catalog
    if recharge is not None:
        assert 'row["batchNo"]' in recharge and "productID: product" in recharge
    else:
        print("Historical recharge archive source is absent; active StoreKit checks remain independent", flush=True)
    assert re.search(r"smoothShellBite:\s*\[WevVGlazeVaultPack\]\s*=\s*\[\]", wallet)
    assert "loadGlazeVaultProducts()" in declaration(wallet, "override func viewDidLoad")
    purchase = declaration(wallet, "private func bakeGlazeVaultPack")
    recovery = declaration(wallet, "private func listenForGlazeTrades")
    assert "WevVGlazeNativeRechargeService.shared.purchase(productID: storeItem.id)" in purchase
    assert "WevVGlazeNativeRechargeService.shared.recoverPending()" in recovery
    assert "storeItem.id == sugarPack.batchKey" in purchase
    for forbidden in ("Transaction.updates", "Transaction.unfinished", "storeItem.purchase(", ".finish(", "addGlazeGold(", "flourBlendDetail("):
        assert forbidden not in wallet, "Wallet view must not own settlement or quantity crediting"
    profile_save = declaration((ROOT / "WevSweetgd/WeeNo/Sources/CreamRingDellController.swift").read_text(), "private func saveCreamRingProfile")
    publish = declaration(composer, "private func figCustard")
    for pipeline, first, second in ((profile_save, ".boutiqueStudio(", ".senchaTasting("),
                                     (publish, ".boutiqueStudio(", ".cornerBakery(")):
        first_position, second_position = pipeline.index(first), pipeline.index(second)
        guard_name = "applyPortraitAsset" if pipeline == publish else "assertCurrent"
        assert first_position < second_position and guard_name in pipeline[first_position:second_position]
        assert guard_name in pipeline[second_position:pipeline.index("await MainActor.run")]
        assert pipeline.count(guard_name) >= 3
    assert "backendCanChat == nil" in declaration(remote, "private func showWevvSugarGuardPrompt")
    retry = declaration(wallet, "private func addVaultmuralAura")
    missing_product = retry[retry.index("guard let product ="):retry.index("bakeGlazeVaultPack(")]
    assert "loadGlazeVaultProducts()" in missing_product and "return" in missing_product
    marks = declaration(wallet, "private func refreshVaultMarks")
    assert "card.isEnabled = glazeCatalogOwner == currentGlazeWalletOwner()" in marks
    assert "glazeStoreItemsByKey[package.batchKey] != nil && card.isEnabled ? 1 : 0.62" in marks
    scroll = declaration(wallet, "private func crispEdgeDough")
    assert "frostingScroll.alwaysBounceVertical = true" in scroll and "#selector(retryGlazeVaultProducts)" in scroll
    assert "frostingScroll.refreshControl = glazeCatalogRefresh" in scroll
    assert "loadGlazeVaultProducts()" in declaration(wallet, "private func retryGlazeVaultProducts")
    assert catalog.count("glazeCatalogRefresh.endRefreshing()") >= 2 and "guard !catalog.isEmpty else" in catalog
    for name in ("toggleRemoteFollow", "openRemoteChat", "openRemoteVideo", "submitRemoteReport", "toggleRemoteSugarGuard"):
        action = declaration(remote, "private func " + name)
        assert "remoteActionTask == nil" in action and "remoteTask == nil" not in action
    print("Archived wallet/profile and active composer source guards passed: 11", flush=True)
    models = methods(historical_kettle, ["enum chocolateCompote", "enum mascarponeFilling", "enum goldenCrumbDough", "struct pearFilling",
                              "struct butteryTexture", "struct featherlightBite", "struct cloudlikeLayer", "struct coldProofRhythm", "struct meltawayCrumb", "struct goldenCrumbCenter",
                              "struct lightCrustTexture", "struct suppleDoughDough"])
    transport = "@MainActor final class TransportFacade {\n" + methods(kettle, ["func oolongComplement"]) + "\n}\n"
    content = "@MainActor final class ContentFacade { let pastryCatalogEntry = WevVGlazeSessionStore.shared\n" + methods(kettle, [
        "func steamExpansionStudy", "func livePage", "func tastingPassportPage", "func batterConsistencyDetail", "func voicePage", "func starchGelatinizationStudy", "func aromaSpectrumNotes"]) + "\n}\n"
    social = "@MainActor final class SocialFacade { let pastryCatalogEntry = WevVGlazeSessionStore.shared; let brunchRouteRoute = TransportFacade()\n" + methods(historical_kettle, [
        "func cornerBakery", "func boutiqueStudio", "func heritageMap", "func glazeSheenNotes", "func crustSnapIndex", "func familyOwnedCounter", "func nuttyFinishMatrix",
        "func doughKitchenBakery", "func confectionStudioCounter", "func tastingCounterKitchen", "func smallBatchStudio", "func familyOwnedMap"]) + "\n}\n"
    main_state = MAIN_STATE + methods(main_page, ["private func refreshGlazeServerProfile", "private func currentGlazeContentOwnerKey", "private func resetGlazeContentOwner", "private func resetTastingParlorOwnerNames", "private func refreshSprinkleMoments", "private func loadGlazeProfileMoments", "private func loadGlazeContent",
        "private func loadGlazeRoomContent", "private func loadGlazeLiveContent", "private func loadGlazeVoiceContent", "private func finishGlazeContentRefresh",
        "private func beginVoiceRoomRefresh", "private func loadMoreVoiceRooms", "private func applyVoiceRoomPages",
        "private func tastingParlorRooms", "private func updateTastingParlorStatus", "private func loadMoreHomeLiveRooms", "private func mergeGlazeRoomContent", "private func updateHomeLiveStatus", "private func openDonutSnapshotDetail", "private func loadGlazeMomentContent(owner:", "private func loadGlazeMomentContent()", "private func uniqueTastingJournalMoments", "private func toggleTastingJournalFollow",
        "private func makeTastingJournalFollowControl", "private func finishInitialGlazeLoading", "private func updateInitialGlazeLoadingVisibility"]) + "\n}\n"
    remote_state = REMOTE_STATE + methods(remote, ["private enum WevvFlavorPane", "private enum WevvRemoteTrailState",
        "private var remoteTrailState", "private func loadRemoteCard", "private func loadRemoteProfile", "private func loadRemoteMoments",
        "private func currentRemoteOwnerKey", "private func isCurrentRemoteRequest", "private func isCurrentRemoteAction", "private func clearRemoteOwnerData", "private func remoteSessionChanged", "private func performRemoteAction"]) + "\n}\n"
    with tempfile.TemporaryDirectory(prefix="wevv-native-integration-") as temporary:
        folder = Path(temporary)
        source = folder / "Verification.swift"
        source.write_text(MOCKS + models + "\n" + (SOURCE / 'WevEnd/glazeNameField.swift').read_text() +
                          (SOURCE / 'WevEnd/glazeMarkLabel.swift').read_text() +
                          (SOURCE / 'WevEnd/creamPacket.swift').read_text() +
                          (SOURCE / 'WevEnd/honeyLavenderCombination.swift').read_text() +
                          (SOURCE / 'WevEnd/honeyScout.swift').read_text() + transport + content + social + main_state + remote_state.replace("BrostingmellowCoconutEssence.shared.prepare()", "BrostingmellowCoconutEssence.listenForGlazeTrades.glazeCounterBakery()") + TESTS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5", "-default-isolation", "MainActor",
                        "-module-cache-path", str(folder / "modules"), str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()
