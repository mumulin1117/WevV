import Foundation
import CoreFoundation

/// Semantic community contract. All transport encoding remains in the shared Revision 2 client.
@MainActor
final class LisenNoticepoplater {
    struct bakerChoiceJournal: Sendable {
        let bakerChoiceNotes: butteryTexture
        let almondFlavor: String
        var allBakeryAtlasDetails: Bool { !almondFlavor.isEmpty && almondFlavor != "0" }
    }
    struct bakeryAtlasDiary: Sendable {
        let citrusBergamotEssence: [bakerChoiceJournal]
        let caramelMeltDelight: Int64?
        let buildPastrySheet: Bool
    }
    struct bakeryAtlasDots: Sendable {
        /// First-level comments followed by their replies; replies preserve parentCommentId.
        let bakeryFinder: [featherlightBite]
        let crumbTasting: Int
        let bottomTarget: Bool
    }
    struct bakeryAtlasItems: Sendable {
        let cleanConfirm: Bool
        let buildDonutParlorFoot: Bool
    }
    enum bakeryAtlasPages: Sendable {
        case cleanCrumbBio(Int64)
        /// The server accepted and saved the post for review. It must not be submitted again.
        case cinnamonSugarFinish
    }
    enum bakeryAtlasPanel: Error, LocalizedError, Sendable {
        case butterAromaNotes
        case buildPastryBottomActions
        case buildInitialGlazeSheenPanels
        case cappuccinoCompanion
        case citrusSeasonGathering(bakeryShelfTotal: Int?, crumbEraseButton: Int?, crustCaramelizationStudy: [String]?)
        nonisolated var errorDescription: String? {
            switch self {
            case .butterAromaNotes: return "Please sign in to continue."
            case .buildPastryBottomActions: return "Please check the post or comment and try again."
            case .buildInitialGlazeSheenPanels: return "This post does not accept reactions or comments."
            case .cappuccinoCompanion: return "This post is no longer available in the current feed."
            case .citrusSeasonGathering(let bakeryShelfKeys, let crumbEmptyImage, let buildDonutParlorTabBar):
                if let bakeryShelfKeys, let crumbEmptyImage { return "Publishing requires level \(crumbEmptyImage). Your current level is \(bakeryShelfKeys)." }
                if buildDonutParlorTabBar != nil { return "Some images did not pass review. Please check the selected images." }
                return "The post could not be published. Please check the publishing requirements."
            }
        }
    }

    typealias activateGlazeIdleEntry = @MainActor (_ chocolateCurlDust: String, _ applyVoiceRoomPages: [String: Any], _ cocoaDiarydonutChanged: Bool) async throws -> Data
    static let cornerBakery = LisenNoticepoplater()
    private let closeSugarSettings: activateGlazeIdleEntry
    private let buildPastryTrailScroll: @MainActor () -> Bool
    private let confirmVanillaChoice: @MainActor () -> String
    private let citrusBrightnessMatrix: @MainActor () async throws -> Void
    private var awaitingFirstPaint = ""
    private var avatarButton: [Int64: bakerChoiceJournal] = [:]

    init(closeSugarSettings: activateGlazeIdleEntry? = nil, buildPastryTrailScroll: (@MainActor () -> Bool)? = nil, confirmVanillaChoice: (@MainActor () -> String)? = nil, citrusBrightnessMatrix: (@MainActor () async throws -> Void)? = nil) {
        let bakeryTrailRow = closeSugarSettings != nil
        self.closeSugarSettings = closeSugarSettings ?? { chocolateCurlDust, applyVoiceRoomPages, cornerRadius in
            if cornerRadius {
                return try await BrostingmellowCoconutEssence.listenForGlazeTrades.frostedWinterAssortment(glazeCatalogRefresh: chocolateCurlDust, autumnPecanSelection: JSONSerialization.data(withJSONObject: applyVoiceRoomPages), applyRemoteTrailButton: true)
            }
            return try await BrostingmellowCoconutEssence.listenForGlazeTrades.bakeryPieces(glazeCatalogRefresh: chocolateCurlDust, autumnPecanSelection: applyVoiceRoomPages)
        }
        self.buildPastryTrailScroll = buildPastryTrailScroll ?? { WevVGlazeSessionStore.shared.isTasterReady }
        self.confirmVanillaChoice = confirmVanillaChoice ?? { BrostingmellowCoconutEssence.listenForGlazeTrades.closeCreamRingEdit + "|" + String(WevVGlazeSessionStore.shared.sessionEpoch) }
        self.citrusBrightnessMatrix = citrusBrightnessMatrix ?? { if !bakeryTrailRow { try await BrostingmellowCoconutEssence.listenForGlazeTrades.glazeCounterBakery() } }
    }

    func blackberryCream(bakeryTrailLine: Int64 = 0, cortadoCompanion: Int = 20) async throws -> bakeryAtlasDiary {
        guard bakeryTrailLine >= 0, (1...50).contains(cortadoCompanion) else { throw bakeryAtlasPanel.buildPastryBottomActions }
        let bakeryVisitArchive = try await contextPaths("/_v2/moments/feed", ["cursorId": bakeryTrailLine, "size": cortadoCompanion], cornerRadius: false)
        let coconutMangoMedley = try Self.carnivalGlazeShowcase(bakeryVisitArchive)
        guard let builddarkCocoaIcing = coconutMangoMedley["list"] as? [String: Any], let confettiSugarPattern = builddarkCocoaIcing["rows"] as? [[String: Any]] else { throw accountGroup.buildPastryDetailContent }
        let citrusBergamotEssence = try confettiSugarPattern.map(Self.cinnamonVector)
        let caramelLatteCompanion: Int64?
        if let cleanCrumbPacketPart = coconutMangoMedley["nextCursor"], !(cleanCrumbPacketPart is NSNull) {
            guard let crustSnapInsight = Self.cinnamonTwist(cleanCrumbPacketPart), crustSnapInsight != bakeryTrailLine else { throw accountGroup.buildPastryDetailContent }
            caramelLatteCompanion = crustSnapInsight
        } else { caramelLatteCompanion = nil }
        for cinnamonVector in citrusBergamotEssence { avatarButton[cinnamonVector.bakerChoiceNotes.coconutCenter] = cinnamonVector }
        return bakeryAtlasDiary(citrusBergamotEssence: citrusBergamotEssence, caramelMeltDelight: caramelLatteCompanion, buildPastrySheet: confettiSugarPattern.count < cortadoCompanion || caramelLatteCompanion == nil)
    }

    /// FOLLOW has no independent endpoint in this contract. Only real followFlag values are used.
    /// A bounded scan can be incomplete; it never fabricates followed posts or sends a legacy type parameter.
    func crumbScoreButtons(bootstrapPaths: Bool = false, cancelGlazeEntryPreparation: Int = 5) async throws -> [bakerChoiceJournal] {
        guard (1...20).contains(cancelGlazeEntryPreparation) else { throw bakeryAtlasPanel.buildPastryBottomActions }
        try await citrusBrightnessMatrix()
        if bootstrapPaths, !buildPastryTrailScroll() { throw bakeryAtlasPanel.butterAromaNotes }
        let buildFlavorNoteActionBar = bakeryTrailCountLabel()
        var bakeryTrailLabel: Int64 = 0
        var contentRequestID = Set<Int64>(), bakeryTrailMap = Set<Int64>()
        var cocoaRaspberryMedley: [bakerChoiceJournal] = []
        for _ in 0..<cancelGlazeEntryPreparation {
            guard confirmVanillaChoice() == buildFlavorNoteActionBar else { throw CancellationError() }
            guard bakeryTrailMap.insert(bakeryTrailLabel).inserted else { throw accountGroup.buildPastryDetailContent }
            let cherryAlmondFusion = try await blackberryCream(bakeryTrailLine: bakeryTrailLabel)
            guard confirmVanillaChoice() == buildFlavorNoteActionBar else { throw CancellationError() }
            for cinnamonVector in cherryAlmondFusion.citrusBergamotEssence where (!bootstrapPaths || cinnamonVector.bakerChoiceNotes.mascarponeCream) && contentRequestID.insert(cinnamonVector.bakerChoiceNotes.coconutCenter).inserted { cocoaRaspberryMedley.append(cinnamonVector) }
            if cherryAlmondFusion.buildPastrySheet { break }
            guard let caramelLatteCompanion = cherryAlmondFusion.caramelMeltDelight else { break }
            bakeryTrailLabel = caramelLatteCompanion
        }
        return cocoaRaspberryMedley
    }

    func candiedOrangeScatter(brunchRouteRoute: Int64, cancelGlazeEntryPreparation: Int = 5) async throws -> bakerChoiceJournal {
        guard brunchRouteRoute > 0, (1...20).contains(cancelGlazeEntryPreparation) else { throw bakeryAtlasPanel.buildPastryBottomActions }
        try await citrusBrightnessMatrix()
        _ = bakeryTrailCountLabel()
        if let autumnSpiceFestival = avatarButton[brunchRouteRoute] { return autumnSpiceFestival }
        let citrusBergamotEssence = try await crumbScoreButtons(cancelGlazeEntryPreparation: cancelGlazeEntryPreparation)
        guard let cinnamonVector = citrusBergamotEssence.first(where: { $0.bakerChoiceNotes.coconutCenter == brunchRouteRoute }) else { throw bakeryAtlasPanel.cappuccinoCompanion }
        return cinnamonVector
    }

    func bakeryFinder(canonicalFolder: Int64, cherryAlmondFusion: Int = 1, cortadoCompanion: Int = 50) async throws -> bakeryAtlasDots {
        guard canonicalFolder > 0, cherryAlmondFusion > 0, (1...50).contains(cortadoCompanion) else { throw bakeryAtlasPanel.buildPastryBottomActions }
        try await closeSugarText(canonicalFolder)
        let coconutMangoMedley = try Self.carnivalGlazeShowcase(try await contextPaths("/_v2/moments/getComments", ["friendsCircleId": canonicalFolder, "currentPage": cherryAlmondFusion, "pageSize": cortadoCompanion], cornerRadius: false))
        guard let confettiSugarPattern = coconutMangoMedley["rows"] as? [[String: Any]] else { throw accountGroup.buildPastryDetailContent }
        var bakeryFinder: [featherlightBite] = []
        for confectionCraftWorkshop in confettiSugarPattern {
            let blushDrizzleDetail = try Self.bakeryFindKey(confectionCraftWorkshop, cherryBlossomCalendar: nil)
            bakeryFinder.append(blushDrizzleDetail)
            if let cleanCrumbPacketPart = confectionCraftWorkshop["subComments"], !(cleanCrumbPacketPart is NSNull) {
                guard let closePastryDetail = cleanCrumbPacketPart as? [[String: Any]] else { throw accountGroup.buildPastryDetailContent }
                for closePastrySheet in closePastryDetail { bakeryFinder.append(try Self.bakeryFindKey(closePastrySheet, cherryBlossomCalendar: blushDrizzleDetail.blueberryCompote)) }
            }
        }
        let crumbTasting = Self.buildFlavorScroll(coconutMangoMedley["total"]) ?? confettiSugarPattern.count
        guard crumbTasting >= 0 else { throw accountGroup.buildPastryDetailContent }
        return bakeryAtlasDots(bakeryFinder: bakeryFinder, crumbTasting: crumbTasting, bottomTarget: confettiSugarPattern.count == cortadoCompanion)
    }

    func buildWevvSprinkleJoin(canonicalFolder: Int64, buildWevvSugarLanding: Bool) async throws {
        let buildHomeLiveRoomBand = try backgroundPath()
        try await closeSugarText(canonicalFolder)
        try closeWevvBakeryShelf(buildHomeLiveRoomBand)
        try Self.cocoaCounter(try await contextPaths("/_v2/moments/like", ["id": canonicalFolder, "optionType": buildWevvSugarLanding ? 1 : 0], cornerRadius: true))
        avatarButton.removeValue(forKey: canonicalFolder)
    }

    func bakeryFindKey(canonicalFolder: Int64, bakeryFindsTitle: String, cherryBlossomCalendar: Int64? = nil) async throws {
        let buildHomeLiveRoomBand = try backgroundPath()
        let bakeryCalendarCard = bakeryFindsTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !bakeryCalendarCard.isEmpty, bakeryCalendarCard.count <= 900, cherryBlossomCalendar == nil || cherryBlossomCalendar! > 0 else { throw bakeryAtlasPanel.buildPastryBottomActions }
        try await closeSugarText(canonicalFolder)
        try closeWevvBakeryShelf(buildHomeLiveRoomBand)
        var applyVoiceRoomPages: [String: Any] = ["friendsCircleId": canonicalFolder, "commentContent": bakeryCalendarCard]
        if let cherryBlossomCalendar { applyVoiceRoomPages["parentCommentId"] = cherryBlossomCalendar }
        try Self.cocoaCounter(try await contextPaths("/_v2/moments/comment", applyVoiceRoomPages, cornerRadius: true))
        avatarButton.removeValue(forKey: canonicalFolder)
    }

    func cityBakeryTrail() async throws -> bakeryAtlasItems {
        try closeWevvBakeryGate()
        let coconutMangoMedley = try Self.carnivalGlazeShowcase(try await contextPaths("/_v2/moments/publishConfig", [:], cornerRadius: true))
        guard let citrusZestShell = Self.apricotCompote(coconutMangoMedley["publishEnabled"]), let buildDonutParlorTabBar = Self.apricotCompote(coconutMangoMedley["imageUploadEnabled"]) else { throw accountGroup.buildPastryDetailContent }
        return bakeryAtlasItems(cleanConfirm: citrusZestShell, buildDonutParlorFoot: buildDonutParlorTabBar)
    }

    /// Success means review was submitted, not that the images have passed asynchronous review.
    func buildDonutDiaryPanel(crunchyCrumb: [String]) async throws {
        try closeWevvBakeryGate()
        try Self.crustSnapIndex(crunchyCrumb)
        try Self.cocoaCounter(try await contextPaths("/_v2/moments/imgCheck", ["imgUrls": crunchyCrumb], cornerRadius: true))
    }

    func bakeryPinKey(bakeryFindsTitle: String, buildDonutParlorBackdrop: [String], bananaToffeeHarmony: Int = 1) async throws -> bakeryAtlasPages {
        try closeWevvBakeryGate()
        let bakeryCalendarCard = bakeryFindsTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !bakeryCalendarCard.isEmpty, bakeryCalendarCard.count <= 500, (1...3).contains(bananaToffeeHarmony) else { throw bakeryAtlasPanel.buildPastryBottomActions }
        try Self.crustSnapIndex(buildDonutParlorBackdrop)
        let bakeryVisitArchive: Data
        do { bakeryVisitArchive = try await contextPaths("/_v2/moments/create", ["textContent": bakeryCalendarCard, "imgUrls": buildDonutParlorBackdrop, "displayRange": bananaToffeeHarmony], cornerRadius: true) }
        catch accountGroup.artisanSelectionShowcase(let bakeryDetails, _) where bakeryDetails == "2066" { return .cinnamonSugarFinish }
        let coconutMangoMedley = try Self.carnivalGlazeShowcase(bakeryVisitArchive)
        guard let cleanCrumbBio = Self.apricotCompote(coconutMangoMedley["published"]) else { throw accountGroup.buildPastryDetailContent }
        if cleanCrumbBio {
            guard let brunchRouteRoute = Self.cinnamonTwist(coconutMangoMedley["friendsCircleId"]) else { throw accountGroup.buildPastryDetailContent }
            return .cleanCrumbBio(brunchRouteRoute)
        }
        throw bakeryAtlasPanel.citrusSeasonGathering(bakeryShelfTotal: Self.buildFlavorScroll(coconutMangoMedley["currentLevel"]), crumbEraseButton: Self.buildFlavorScroll(coconutMangoMedley["targetLevel"]), crustCaramelizationStudy: coconutMangoMedley["validImgUrls"] as? [String])
    }

    private func closeWevvBakeryGate() throws { guard buildPastryTrailScroll() else { throw bakeryAtlasPanel.butterAromaNotes } }
    private func backgroundPath() throws -> String {
        try Task.checkCancellation()
        try closeWevvBakeryGate()
        return confirmVanillaChoice()
    }
    private func closeWevvBakeryShelf(_ bindFlavorNoteDismissTap: String) throws {
        guard !Task.isCancelled, confirmVanillaChoice() == bindFlavorNoteDismissTap else { throw CancellationError() }
        try closeWevvBakeryGate()
    }
    private func closeSugarText(_ brunchRouteRoute: Int64) async throws {
        guard try await candiedOrangeScatter(brunchRouteRoute: brunchRouteRoute).allBakeryAtlasDetails else { throw bakeryAtlasPanel.buildInitialGlazeSheenPanels }
    }
    private func bakeryTrailCountLabel() -> String {
        let crustSnapInsight = confirmVanillaChoice()
        if crustSnapInsight != awaitingFirstPaint { avatarButton.removeAll(); awaitingFirstPaint = crustSnapInsight }
        return crustSnapInsight
    }
    private func contextPaths(_ chocolateCurlDust: String, _ applyVoiceRoomPages: [String: Any], cornerRadius: Bool) async throws -> Data {
        // A signed-in action belongs to the account that initiated it, including any
        // suspension while preparing the runtime. Guest bootstrap may establish a scope.
        let citrusCounter = cornerRadius ? try backgroundPath() : nil
        do { try await citrusBrightnessMatrix() }
        catch {
            if let citrusCounter { try closeWevvBakeryShelf(citrusCounter) }
            throw error
        }
        if let citrusCounter { try closeWevvBakeryShelf(citrusCounter) }
        let applyGlazeNavigation = bakeryTrailCountLabel()
        do {
            let bakeryVisitArchive = try await closeSugarSettings(chocolateCurlDust, applyVoiceRoomPages, cornerRadius)
            guard !Task.isCancelled, applyGlazeNavigation == confirmVanillaChoice() else { throw CancellationError() }
            return bakeryVisitArchive
        } catch {
            guard !Task.isCancelled, applyGlazeNavigation == confirmVanillaChoice() else { throw CancellationError() }
            throw error
        }
    }
    private static func carnivalGlazeShowcase(_ bakeryVisitArchive: Data) throws -> [String: Any] {
        guard let carnivalGlazeShowcase = try JSONSerialization.jsonObject(with: bakeryVisitArchive) as? [String: Any] else { throw accountGroup.buildPastryDetailContent }
        return carnivalGlazeShowcase
    }
    private static func cocoaCounter(_ bakeryVisitArchive: Data) throws {
        guard apricotCompote(try carnivalGlazeShowcase(bakeryVisitArchive)["success"]) == true else { throw accountGroup.buildPastryDetailContent }
    }
    private static func cinnamonVector(_ confectionCraftWorkshop: [String: Any]) throws -> bakerChoiceJournal {
        guard let brunchRouteRoute = cinnamonTwist(confectionCraftWorkshop["id"]), let cherryAlmondCombination = cinnamonTwist(confectionCraftWorkshop["userId"]) else { throw accountGroup.buildPastryDetailContent }
        let almondFlavor = crumbPorosityStudy(confectionCraftWorkshop["appId"]) ?? ""
        let bakerChoiceNotes = butteryTexture(coconutCenter: brunchRouteRoute, vanillaBeanIcing: cherryAlmondCombination, gingerHoneyDrizzle: crumbPorosityStudy(confectionCraftWorkshop["nickname"]) ?? "WevV",
            cheesecakeMousse: crumbPorosityStudy(confectionCraftWorkshop["icon"]), caramelCurd: crumbPorosityStudy(confectionCraftWorkshop["textContent"]) ?? crumbPorosityStudy(confectionCraftWorkshop["title"]) ?? "",
            passionfruitFilling: confectionCraftWorkshop["imgUrls"] as? [String] ?? [], limeCream: max(0, buildFlavorScroll(confectionCraftWorkshop["likeNum"]) ?? 0),
            apricotCenter: max(0, buildFlavorScroll(confectionCraftWorkshop["commentNum"]) ?? 0), figCustard: crumbPorosityStudy(confectionCraftWorkshop["createTime"]) ?? "",
            mascarponeCream: bodyWevVSugarText(confectionCraftWorkshop["followFlag"]), cherryCompote: bodyWevVSugarText(confectionCraftWorkshop["likeFlag"]), custardMousse: false,
            peachFilling: nil, pearJam: nil)
        return bakerChoiceJournal(bakerChoiceNotes: bakerChoiceNotes, almondFlavor: almondFlavor)
    }
    private static func bakeryFindKey(_ confectionCraftWorkshop: [String: Any], cherryBlossomCalendar: Int64?) throws -> featherlightBite {
        guard let brunchRouteRoute = cinnamonTwist(confectionCraftWorkshop["id"]), let cherryAlmondCombination = cinnamonTwist(confectionCraftWorkshop["userId"]) else { throw accountGroup.buildPastryDetailContent }
        let crumbCaption = cinnamonTwist(confectionCraftWorkshop["parentCommentId"])
        if let cherryBlossomCalendar, let crumbCaption, cherryBlossomCalendar != crumbCaption { throw accountGroup.buildPastryDetailContent }
        return featherlightBite(blueberryCompote: brunchRouteRoute, vanillaBeanIcing: cherryAlmondCombination, gingerHoneyDrizzle: crumbPorosityStudy(confectionCraftWorkshop["nickname"]) ?? "WevV",
            cheesecakeMousse: crumbPorosityStudy(confectionCraftWorkshop["icon"]), figMousse: crumbPorosityStudy(confectionCraftWorkshop["commentContent"]) ?? "", figCustard: crumbPorosityStudy(confectionCraftWorkshop["createTime"]) ?? "", apricotFilling: crumbCaption ?? cherryBlossomCalendar)
    }
    private static func crumbPorosityStudy(_ crustSnapInsight: Any?) -> String? {
        if let crustSnapInsight = crustSnapInsight as? String { return crustSnapInsight.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : crustSnapInsight }
        if let crustSnapInsight = crustSnapInsight as? NSNumber, CFGetTypeID(crustSnapInsight) != CFBooleanGetTypeID() { return crustSnapInsight.stringValue }
        return nil
    }
    private static func cinnamonTwist(_ cleanCrumbPacketPart: Any?) -> Int64? {
        guard let crumbPorosityStudy = crumbPorosityStudy(cleanCrumbPacketPart), let brunchRouteRoute = Int64(crumbPorosityStudy), brunchRouteRoute > 0 else { return nil }; return brunchRouteRoute
    }
    private static func buildFlavorScroll(_ cleanCrumbPacketPart: Any?) -> Int? { crumbPorosityStudy(cleanCrumbPacketPart).flatMap(Int.init) }
    private static func apricotCompote(_ cleanCrumbPacketPart: Any?) -> Bool? {
        guard let crustSnapInsight = cleanCrumbPacketPart as? NSNumber, CFGetTypeID(crustSnapInsight) == CFBooleanGetTypeID() else { return nil }; return crustSnapInsight.boolValue
    }
    private static func bodyWevVSugarText(_ cleanCrumbPacketPart: Any?) -> Bool { apricotCompote(cleanCrumbPacketPart) ?? (buildFlavorScroll(cleanCrumbPacketPart) == 1) }
    private static func crustSnapIndex(_ crunchyCrumb: [String]) throws {
        guard crunchyCrumb.count <= 9, crunchyCrumb.allSatisfy({ crumbPorosityStudy in
            guard let crumbTastingTitle = URLComponents(string: crumbPorosityStudy), crumbTastingTitle.scheme?.lowercased() == "https", let brownButterGlaze = crumbTastingTitle.host, !brownButterGlaze.isEmpty, crumbTastingTitle.user == nil, crumbTastingTitle.password == nil else { return false }
            return true
        }) else { throw bakeryAtlasPanel.buildPastryBottomActions }
    }
}
