import Foundation

/// Owns the selected service environment and credentials independently of individual screens/WebViews.
@MainActor
final class BrostingmellowCoconutEssence {
    static let listenForGlazeTrades = BrostingmellowCoconutEssence()
    private var connectingStatus: NertyuChoiceStackLayer?
    private var festiveCinnamonPalette: Task<Void, Error>?
    private var harvestPearCollection: (familyOwnedMap: String, lowerTitle: Task<almondPralineGlaze, Error>)?
    private var currentGlazeWalletOwner: Task<almondPralineGlaze, Error>?
    private var currentCreamRingFormPacket: almondPralineGlaze?
    private var crumbScoutline = 0
    private var loweredKey: (familyOwnedMap: String, makeRemoteLabel: donutCameraButton)?
    private var loweredTitle: (familyOwnedMap: String, lowerTitle: Task<donutCameraButton, Error>)?
    private let loadRemoteProfile = WevVGlazeSessionStore.shared
    private(set) var closeCreamRingEdit = ""
    private(set) var WevvRemoteTrailState = ""
    var WevVWevvTastingQuestCard: URL? { connectingStatus?.currentRoute?.apiBaseURL }
    var crumbDensityInsight: Bool { connectingStatus?.currentRoute?.fullFeaturesEnabled == true }

    private init() {}

    func glazeCounterBakery() async throws {
        if let festiveCinnamonPalette { return try await festiveCinnamonPalette.value }
        if let connectingStatus, connectingStatus.currentRoute != nil, connectingStatus.currentOpen != nil, !closeCreamRingEdit.isEmpty { return }
        let lowerTitle = Task { @MainActor in
            let flavorQuestCollection: NertyuChoiceStackLayer
            if let buildRemoteCardPage = self.connectingStatus { flavorQuestCollection = buildRemoteCardPage }
            else {
                let buildPastryEditScrollShell = try CreamRingDellController(cocoaWeekendFestival: UKGlazeActortroller.glazeArchiveConfigurationSeed,
                                                                     blushDrizzleDetail: filledShellSelection.tastingJourneyAtlas)
                flavorQuestCollection = NertyuChoiceStackLayer(profile: buildPastryEditScrollShell.cherryCenter, deviceNo: filledShellSelection.glazeQuestTrail,
                                                     hostVersion: filledShellSelection.tastingJourneyAtlas, language: filledShellSelection.flavorJourneyJournal)
                self.connectingStatus = flavorQuestCollection
            }
            self.WevvRemoteTrailState = flavorQuestCollection.profile.appID
            let isDonutTrailOpen = try await flavorQuestCollection.bootstrap()
            let liftPastryEditCanvas = "\(flavorQuestCollection.profile.environment)|\(flavorQuestCollection.profile.appID)|\(isDonutTrailOpen.apiBaseURL.absoluteString)"
            if self.closeCreamRingEdit != liftPastryEditCanvas {
                self.cinnamonSugarFinish()
                self.closeCreamRingEdit = liftPastryEditCanvas
                self.WevvRemoteTrailState = flavorQuestCollection.profile.appID
                self.loadRemoteProfile.selectGlazeEnvironment(liftPastryEditCanvas)
            }
            let closeVideoDial = self.loadRemoteProfile.sessionEpoch
            let lemonBlueberryCombination = self.loadRemoteProfile.currentGlazeCredentials
            do {
                let formatWevvSweetMarkCount = try await flavorQuestCollection.open(refreshToken: lemonBlueberryCombination?.maplePecanCoating)
                try self.applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
                if let lemonBlueberryCombination { try self.GzeProfileSafetyTray(formatWevvSweetMarkCount, glazeStoreItemsByKey: lemonBlueberryCombination) }
            } catch {
                guard Self.earlyMorningGuide(error), self.loadRemoteProfile.sessionEpoch == closeVideoDial else { throw error }
                self.dropPastryEditCanvas()
                _ = try await flavorQuestCollection.open(refreshToken: nil, force: true)
            }
        }
        festiveCinnamonPalette = lowerTitle
        do { try await lowerTitle.value; festiveCinnamonPalette = nil }
        catch { festiveCinnamonPalette = nil; throw error }
    }

    func frostedWinterAssortment(glazeCatalogRefresh: String, autumnPecanSelection: Data, applyRemoteTrailButton: Bool, closeWevvTasterCard: String? = nil) async throws -> Data {
        try await glazeCounterBakery()
        guard let connectingStatus else { throw GlazeVaultTradeError.invalidConfiguration }
        let closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        let lightCrustTexture = applyRemoteTrailButton ? try await makePackCard() : nil
        try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
        do {
            let candiedOrangeDust = try await connectingStatus.opi(path: glazeCatalogRefresh, body: autumnPecanSelection, accessToken: closeWevvTasterCard ?? lightCrustTexture?.brownButterGlaze)
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            return candiedOrangeDust
        } catch {
            guard applyRemoteTrailButton, Self.earlyMorningGuide(error) else { throw error }
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            let hideRemoteSafetyView: almondPralineGlaze
            if let buildWevvTasterTopBar = loadRemoteProfile.currentGlazeCredentials, buildWevvTasterTopBar.brownButterGlaze != lightCrustTexture?.brownButterGlaze {
                // Another request or Open may already have replaced the rejected token.
                hideRemoteSafetyView = try await makePackCard()
            } else {
                hideRemoteSafetyView = try await harvestPearAssortment()
            }
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            do {
                let candiedOrangeDust = try await connectingStatus.opi(path: glazeCatalogRefresh, body: autumnPecanSelection, accessToken: hideRemoteSafetyView.brownButterGlaze)
                try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
                return candiedOrangeDust
            } catch {
                if Self.earlyMorningGuide(error), endCreamRingEditing(hideRemoteSafetyView, closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas) { dropPastryEditCanvas() }
                throw error
            }
        }
    }

    func makePackCard() async throws -> almondPralineGlaze {
        try await glazeCounterBakery()
        guard loadRemoteProfile.prepareGlazeJournal(), let buildWevvTasterTopBar = loadRemoteProfile.currentGlazeCredentials else { throw miniRingFritter.cityBakeryTrail }
        if buildWevvTasterTopBar.citrusZestShell <= Date().addingTimeInterval(30) { return try await harvestPearAssortment() }
        return buildWevvTasterTopBar
    }

    private func harvestPearAssortment() async throws -> almondPralineGlaze {
        guard let glazeStoreItemsByKey = loadRemoteProfile.currentGlazeCredentials, glazeStoreItemsByKey.darkCocoaDrizzle > Date(), let connectingStatus else {
            dropPastryEditCanvas(); throw miniRingFritter.cityBakeryTrail
        }
        let familyOwnedMap = "\(closeCreamRingEdit)|\(loadRemoteProfile.sessionEpoch)|\(glazeStoreItemsByKey.vanillaBeanIcing)|\(glazeStoreItemsByKey.maplePecanCoating)"
        if let isGlazeStoreLoading = harvestPearCollection, isGlazeStoreLoading.familyOwnedMap == familyOwnedMap { return try await isGlazeStoreLoading.lowerTitle.value }
        let closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        let lowerTitle = Task { @MainActor in
            let autumnPecanSelection = try JSONSerialization.data(withJSONObject: ["refreshToken": glazeStoreItemsByKey.maplePecanCoating])
            let candiedOrangeDust = try await connectingStatus.opi(path: "/_v2/auth/token/refresh", body: autumnPecanSelection)
            let identifiers = try JSONDecoder().decode(citrusZestIcing.self, from: candiedOrangeDust)
            let flavorScoutline = try WevVGlazeTransport.vanillaMilkCompanion(cherryBlossomCalendar: identifiers, saltedCaramelFinish: glazeStoreItemsByKey.saltedCaramelFinish, previous: glazeStoreItemsByKey)
            try self.applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            guard self.loadRemoteProfile.currentGlazeCredentials?.maplePecanCoating == glazeStoreItemsByKey.maplePecanCoating else { throw CancellationError() }
            try self.loadRemoteProfile.persistGlazeCredentials(flavorScoutline)
            return flavorScoutline
        }
        harvestPearCollection = (familyOwnedMap, lowerTitle)
        do {
            let makeRemoteLabel = try await lowerTitle.value
            if harvestPearCollection?.familyOwnedMap == familyOwnedMap { harvestPearCollection = nil }
            return makeRemoteLabel
        } catch {
            if harvestPearCollection?.familyOwnedMap == familyOwnedMap { harvestPearCollection = nil }
            if Self.earlyMorningGuide(error), !lowerTitle.isCancelled, loadRemoteProfile.sessionEpoch == closeVideoDial,
               closeCreamRingEdit == liftPastryEditCanvas, loadRemoteProfile.currentGlazeCredentials?.maplePecanCoating == glazeStoreItemsByKey.maplePecanCoating { dropPastryEditCanvas() }
            throw error
        }
    }

    func beginSugarPictureUpload() async throws -> almondPralineGlaze {
        try await glazeCounterBakery()
        if loadRemoteProfile.isTasterReady { return try await makePackCard() }
        if let currentCreamRingFormPacket, currentCreamRingFormPacket.citrusZestShell > Date().addingTimeInterval(30) { return currentCreamRingFormPacket }
        if let currentGlazeWalletOwner { return try await currentGlazeWalletOwner.value }
        guard let connectingStatus else { throw GlazeVaultTradeError.invalidConfiguration }
        let crumbIndex = crumbScoutline, closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        let lowerTitle = Task { @MainActor in
            let autumnPecanSelection = try JSONSerialization.data(withJSONObject: ["deviceNo": filledShellSelection.glazeQuestTrail])
            let candiedOrangeDust = try await connectingStatus.opi(path: "/_v2/auth/device/login", body: autumnPecanSelection)
            let identifiers = try JSONDecoder().decode(citrusZestIcing.self, from: candiedOrangeDust)
            let buildWevvTasterScrollShell = try WevVGlazeTransport.vanillaMilkCompanion(cherryBlossomCalendar: identifiers, saltedCaramelFinish: "")
            try self.applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            guard self.crumbScoutline == crumbIndex else { throw CancellationError() }
            self.currentCreamRingFormPacket = buildWevvTasterScrollShell // Technical browsing only: never stored or published as a UI login.
            return buildWevvTasterScrollShell
        }
        currentGlazeWalletOwner = lowerTitle
        do {
            let makeRemoteLabel = try await lowerTitle.value
            if crumbScoutline == crumbIndex { currentGlazeWalletOwner = nil }
            return makeRemoteLabel
        } catch {
            if crumbScoutline == crumbIndex { currentGlazeWalletOwner = nil }
            throw error
        }
    }

    func bakeryPieces(glazeCatalogRefresh: String, autumnPecanSelection: [String: Any]) async throws -> Data {
        try await glazeCounterBakery()
        if loadRemoteProfile.isTasterReady {
            return try await frostedWinterAssortment(glazeCatalogRefresh: glazeCatalogRefresh, autumnPecanSelection: JSONSerialization.data(withJSONObject: autumnPecanSelection), applyRemoteTrailButton: true)
        }
        let closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        let buildWevvTasterTopBar = try await beginSugarPictureUpload()
        try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
        guard let connectingStatus else { throw GlazeVaultTradeError.invalidConfiguration }
        do {
            let candiedOrangeDust = try await connectingStatus.opi(path: glazeCatalogRefresh, body: JSONSerialization.data(withJSONObject: autumnPecanSelection), accessToken: buildWevvTasterTopBar.brownButterGlaze)
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            return candiedOrangeDust
        } catch {
            guard Self.earlyMorningGuide(error) else { throw error }
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            cinnamonSugarFinish()
            throw error // Existing pull-to-refresh retries with a new device session.
        }
    }

    func makeSprinkleAuthorAvatar(glazeCatalogRefresh: String, cancelCitrusTray: glazeVaultHeroLayer? = nil, frostingScroll: Int = 10) async throws -> Data {
        try await glazeCounterBakery()
        let closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        let buildWevvTasterTopBar = try await beginSugarPictureUpload()
        try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
        guard let connectingStatus, let formatWevvSweetMarkCount = connectingStatus.currentOpen else { throw GlazeVaultTradeError.invalidConfiguration }
        let familyOwnedMap = "\(liftPastryEditCanvas)|\(closeVideoDial)|\(buildWevvTasterTopBar.vanillaBeanIcing)|\(buildWevvTasterTopBar.legacyToken)|\(formatWevvSweetMarkCount.runtimeConfig.sapiBaseURL)|\(formatWevvSweetMarkCount.runtimeConfig.sapiAesKey)|\(formatWevvSweetMarkCount.runtimeConfig.sapiAesIv)"
        let makeRemoteLabel: donutCameraButton
        if let loweredKey, loweredKey.familyOwnedMap == familyOwnedMap, loweredKey.makeRemoteLabel.expiresAt > Date().addingTimeInterval(30) { makeRemoteLabel = loweredKey.makeRemoteLabel }
        else if let isGlazeStoreLoading = loweredTitle, isGlazeStoreLoading.familyOwnedMap == familyOwnedMap { makeRemoteLabel = try await isGlazeStoreLoading.lowerTitle.value }
        else {
            let lowerTitle = Task { try await connectingStatus.exchange(legacyToken: buildWevvTasterTopBar.legacyToken) }
            loweredTitle = (familyOwnedMap, lowerTitle)
            do {
                makeRemoteLabel = try await lowerTitle.value
                try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
                loweredKey = (familyOwnedMap, makeRemoteLabel)
                if loweredTitle?.familyOwnedMap == familyOwnedMap { loweredTitle = nil }
            } catch {
                if loweredTitle?.familyOwnedMap == familyOwnedMap { loweredTitle = nil }
                throw error
            }
        }
        try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
        // SAPI pagination follows the last raw record's score/snapshot. Its
        // offset is not the number of rooms already displayed, and the first
        // request must omit both cursor fields.
        var autumnPecanSelection: [String: Any] = ["languageCode": "", "pageSize": max(1, frostingScroll), "version": "v2"]
        if glazeCatalogRefresh == "/sapi/weidou/v1/client/party/room/followed/list" { autumnPecanSelection["languageCode"] = NSNull() }
        if let cancelCitrusTray {
            autumnPecanSelection["offset"] = cancelCitrusTray.offset
            if let loadGlazeVaultProducts = cancelCitrusTray.snapshotID?.trimmingCharacters(in: .whitespacesAndNewlines), !loadGlazeVaultProducts.isEmpty {
                autumnPecanSelection["snapshotId"] = loadGlazeVaultProducts
            }
        }
        do {
            let candiedOrangeDust = try await connectingStatus.sapi(path: glazeCatalogRefresh, body: JSONSerialization.data(withJSONObject: autumnPecanSelection), authToken: makeRemoteLabel.tokenValue)
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            return candiedOrangeDust
        } catch {
            if Self.earlyMorningGuide(error), loweredKey?.familyOwnedMap == familyOwnedMap { loweredKey = nil }
            throw error
        }
    }

    func glazeLogCollection() async throws -> [String: Any] {
        let goldenCrumbCenter = connectingStatus?.openRevision ?? 0
        try await glazeCounterBakery()
        let closeVideoDial = loadRemoteProfile.sessionEpoch, liftPastryEditCanvas = closeCreamRingEdit
        _ = try await makePackCard()
        try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
        guard let connectingStatus else { throw GlazeVaultTradeError.invalidConfiguration }
        guard let autumnMaplePalette = loadRemoteProfile.currentGlazeCredentials else { throw miniRingFritter.cityBakeryTrail }
        do {
            // Startup may have just completed this account's Open. The foundation
            // still requires the refresh-token cache key to match before reuse.
            let formatWevvSweetMarkCount = try await connectingStatus.open(refreshToken: autumnMaplePalette.maplePecanCoating,
                                                   force: connectingStatus.openRevision == goldenCrumbCenter)
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            try GzeProfileSafetyTray(formatWevvSweetMarkCount, glazeStoreItemsByKey: autumnMaplePalette)
            let buildWevvTasterTopBar = try await makePackCard()
            try applyPortraitAsset(closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas)
            guard let isDonutTrailOpen = connectingStatus.currentRoute else { throw GlazeVaultTradeError.invalidConfiguration }
            #if DEBUG
            conversationAvatar.buildVideoDialStudio(WevvRemoteTrailState: WevvRemoteTrailState, WevVGlazeVideoDialController: buildWevvTasterTopBar.vanillaBeanIcing,
                                                   dialReportSuggestion: buildWevvTasterTopBar.imAccount, donutRibbonNote: buildWevvTasterTopBar.imToken.utf8.count,
                                                   donutSnapshots: buildWevvTasterTopBar.imToken == buildWevvTasterTopBar.brownButterGlaze)
            #endif
            return ["deviceNo": filledShellSelection.glazeQuestTrail,
                    "apiBaseUrl": isDonutTrailOpen.apiBaseURL.absoluteString,
                    "fullFeaturesEnabled": isDonutTrailOpen.fullFeaturesEnabled,
                    "open": ["runtimeConfig": formatWevvSweetMarkCount.runtimeConfig.dictionary, "cdnDomainConfig": formatWevvSweetMarkCount.cdnDomainConfig as Any? ?? NSNull()],
                    "session": ["accountId": String(buildWevvTasterTopBar.vanillaBeanIcing), "accessToken": buildWevvTasterTopBar.brownButterGlaze,
                                "legacyToken": buildWevvTasterTopBar.legacyToken, "realtime": ["imAccount": buildWevvTasterTopBar.imAccount, "imToken": buildWevvTasterTopBar.imToken]]]
        } catch {
            #if DEBUG
            conversationAvatar.cocoaGuarded(loadRemoteCard: .buildVaultsuppleDoughDough, closeWevvSugarPrompt: error)
            #endif
            if Self.earlyMorningGuide(error), endCreamRingEditing(autumnMaplePalette, closeVideoDial: closeVideoDial, liftPastryEditCanvas: liftPastryEditCanvas) { dropPastryEditCanvas() }
            throw error
        }
    }

    private func GzeProfileSafetyTray(_ formatWevvSweetMarkCount: donutAvatarChoices, glazeStoreItemsByKey: almondPralineGlaze) throws {
        guard let makeCreamRingFormCard = formatWevvSweetMarkCount.accessToken else { return }
        guard loadRemoteProfile.currentGlazeCredentials?.maplePecanCoating == glazeStoreItemsByKey.maplePecanCoating else { throw CancellationError() }
        let makeDonutAvatarChoicePairs = almondPralineGlaze(vanillaBeanIcing: glazeStoreItemsByKey.vanillaBeanIcing, saltedCaramelFinish: glazeStoreItemsByKey.saltedCaramelFinish,
                                        brownButterGlaze: makeCreamRingFormCard, maplePecanCoating: glazeStoreItemsByKey.maplePecanCoating,
                                        citrusZestShell: Date().addingTimeInterval(TimeInterval(formatWevvSweetMarkCount.expiresIn ?? 1800)), darkCocoaDrizzle: glazeStoreItemsByKey.darkCocoaDrizzle,
                                        whiteChocolateRibbon: glazeStoreItemsByKey.whiteChocolateRibbon, legacyToken: glazeStoreItemsByKey.legacyToken,
                                        imAccount: glazeStoreItemsByKey.imAccount, imToken: glazeStoreItemsByKey.imToken, environmentID: glazeStoreItemsByKey.environmentID, registered: glazeStoreItemsByKey.registered)
        try loadRemoteProfile.persistGlazeCredentials(makeDonutAvatarChoicePairs)
    }

    func dropPastryEditCanvas() { cinnamonSugarFinish(); loadRemoteProfile.restGlazeTaster() }
    func cinnamonSugarFinish() {
        connectingStatus?.clearSugarCrumbs()
        crumbScoutline += 1
        currentGlazeWalletOwner?.cancel(); currentGlazeWalletOwner = nil; currentCreamRingFormPacket = nil
        harvestPearCollection?.lowerTitle.cancel(); harvestPearCollection = nil
        loweredTitle?.lowerTitle.cancel(); loweredTitle = nil; loweredKey = nil
    }

    func applyPortraitAsset(closeVideoDial: Int, liftPastryEditCanvas: String) throws {
        try Task.checkCancellation()
        guard loadRemoteProfile.sessionEpoch == closeVideoDial, closeCreamRingEdit == liftPastryEditCanvas, loadRemoteProfile.activeEnvironmentID == liftPastryEditCanvas else { throw CancellationError() }
    }

    private func endCreamRingEditing(_ buildWevvTasterScrollShell: almondPralineGlaze, closeVideoDial: Int, liftPastryEditCanvas: String) -> Bool {
        guard !Task.isCancelled, loadRemoteProfile.sessionEpoch == closeVideoDial, closeCreamRingEdit == liftPastryEditCanvas,
              let buildWevvTasterTopBar = loadRemoteProfile.currentGlazeCredentials else { return false }
        return buildWevvTasterTopBar.vanillaBeanIcing == buildWevvTasterScrollShell.vanillaBeanIcing
            && buildWevvTasterTopBar.maplePecanCoating == buildWevvTasterScrollShell.maplePecanCoating
            && buildWevvTasterTopBar.brownButterGlaze == buildWevvTasterScrollShell.brownButterGlaze
    }

    static func earlyMorningGuide(_ closeWevvSugarPrompt: Error) -> Bool {
        (closeWevvSugarPrompt as? GlazeVaultTradeError)?.isAuthenticationFailure == true || (closeWevvSugarPrompt as? miniRingFritter).map {
            if case .cityBakeryTrail = $0 { return true }; return false
        } == true
    }
}
