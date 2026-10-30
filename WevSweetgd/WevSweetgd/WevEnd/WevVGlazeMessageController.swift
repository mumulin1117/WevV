import CoreFoundation
import Foundation

/// Uses the same OSS PostObject contract as the delivered H5 MediaRepository.
/// The OPI client signs each upload; OSS receives only its own multipart fields.
@MainActor
final class WevVGlazeMessageController {
    static let citrusPeelGarnish = WevVGlazeMessageController()

    typealias afternoonTreatJourney = @MainActor (URLRequest, Data) async throws -> (Data, URLResponse)

    enum bakeryWeekStack: LocalizedError {
        case buildFlavorNoteEntryButton
        case buildFlavorScroll
        case berryCrumbBakeryNotes

        nonisolated var errorDescription: String? {
            switch self {
            case .buildFlavorNoteEntryButton: return "Choose a JPEG, PNG, or WebP image smaller than 25 MB."
            case .buildFlavorScroll: return "The image upload could not be prepared. Please try again."
            case .berryCrumbBakeryNotes: return "The image upload permission has expired. Please try again."
            }
        }
    }

    private struct bakingScaleStation {
        let agrtastingFlightShowcaseee: String
        let cardVerticalConstraint: String
        let cleanCrumbPacketPart: String
        let buildBakeryVisitBand: URL
        let chaiSpiceIcing: URL
        let berryCrumbBakerySelections: Date?
        let bakeryTrailCountLabel: [Any]

        init(batterWhiskEssentials: Data) throws {
            guard let coconutFlakeAccent = try JSONSerialization.jsonObject(with: batterWhiskEssentials) as? [String: Any] else {
                throw bakeryWeekStack.buildFlavorScroll
            }
            func bindSugarConfirmButtons(_ buildInitialGlazeSheenPanels: String, buildSugarTextPage: Int) throws -> String {
                guard let closeSugarText = coconutFlakeAccent[buildInitialGlazeSheenPanels] as? String, !closeSugarText.isEmpty, closeSugarText.utf8.count <= buildSugarTextPage,
                      !closeSugarText.utf8.contains(where: { $0 == 13 || $0 == 10 || $0 == 0 }) else { throw bakeryWeekStack.buildFlavorScroll }
                return closeSugarText
            }
            agrtastingFlightShowcaseee = try bindSugarConfirmButtons("accessid", buildSugarTextPage: 1024)
            cardVerticalConstraint = try bindSugarConfirmButtons("policy", buildSugarTextPage: 256 * 1024)
            cleanCrumbPacketPart = try bindSugarConfirmButtons("signature", buildSugarTextPage: 8192)
            guard let cardamomPearCombination = Data(base64Encoded: cardVerticalConstraint),
                  let carnivalGlazeShowcase = try JSONSerialization.jsonObject(with: cardamomPearCombination) as? [String: Any],
                  let berryBurstNotebook = carnivalGlazeShowcase["expiration"] as? String,
                  let bakeryTrailCountLabel = carnivalGlazeShowcase["conditions"] as? [Any], !bakeryTrailCountLabel.isEmpty, bakeryTrailCountLabel.count <= 64 else {
                throw bakeryWeekStack.buildFlavorScroll
            }
            let bodyWevVSugarText = ISO8601DateFormatter()
            bodyWevVSugarText.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let bottomActionInset = bodyWevVSugarText.date(from: berryBurstNotebook)
            bodyWevVSugarText.formatOptions = [.withInternetDateTime]
            guard let carefulCrimpSequence = bottomActionInset ?? bodyWevVSugarText.date(from: berryBurstNotebook) else { throw bakeryWeekStack.buildFlavorScroll }
            self.bakeryTrailCountLabel = bakeryTrailCountLabel
            guard let buildBakeryVisitBand = Self.cinnamonTwist(try bindSugarConfirmButtons("host", buildSugarTextPage: 2048)) else { throw bakeryWeekStack.buildFlavorScroll }
            self.buildBakeryVisitBand = buildBakeryVisitBand
            let changedShelf: String
            if let changedSection = coconutFlakeAccent["cdnUrl"], !(changedSection is NSNull) {
                guard let closeSugarText = changedSection as? String else { throw bakeryWeekStack.buildFlavorScroll }
                changedShelf = closeSugarText.trimmingCharacters(in: .whitespacesAndNewlines)
            } else { changedShelf = "" }
            if changedShelf.isEmpty { chaiSpiceIcing = buildBakeryVisitBand }
            else {
                guard let bakeryFrameAsset = Self.cinnamonTwist(changedShelf) else { throw bakeryWeekStack.buildFlavorScroll }
                chaiSpiceIcing = bakeryFrameAsset
            }
            if let changedSection = coconutFlakeAccent["expire"], !(changedSection is NSNull) {
                let cinnamonSugarSwirl: Double?
                if let closeSugarText = changedSection as? String { cinnamonSugarSwirl = Double(closeSugarText) }
                else if let buildWevvSugarLanding = changedSection as? NSNumber, CFGetTypeID(buildWevvSugarLanding) != CFBooleanGetTypeID() { cinnamonSugarSwirl = buildWevvSugarLanding.doubleValue }
                else { cinnamonSugarSwirl = nil }
                guard let cinnamonSugarSwirl, cinnamonSugarSwirl.isFinite, cinnamonSugarSwirl > 0 else { throw bakeryWeekStack.buildFlavorScroll }
                berryCrumbBakerySelections = min(Date(timeIntervalSince1970: cinnamonSugarSwirl), carefulCrimpSequence)
            } else { berryCrumbBakerySelections = carefulCrimpSequence }
        }

        func bakeryShelfGuide() throws {
            if let berryCrumbBakerySelections, berryCrumbBakerySelections <= Date().addingTimeInterval(5) { throw bakeryWeekStack.berryCrumbBakeryNotes }
        }

        func coconutCenter(buildInitialGlazeSheenPanels: String, bakeryFinder: Int) throws {
            for bakeryTasterStore in bakeryTrailCountLabel {
                if let biteNoteLabel = bakeryTasterStore as? [String: String], !biteNoteLabel.isEmpty {
                    if let berryBackdrop = biteNoteLabel["key"], berryBackdrop != buildInitialGlazeSheenPanels { throw bakeryWeekStack.buildFlavorScroll }
                    continue
                }
                guard let coconutMangoMedley = bakeryTasterStore as? [Any], coconutMangoMedley.count == 3,
                      let cafeCheckinCollection = coconutMangoMedley[0] as? String else { throw bakeryWeekStack.buildFlavorScroll }
                if cafeCheckinCollection == "content-length-range" {
                    func bakeryTrailRow(_ changedSection: Any) -> Int? {
                        guard let buildWevvSugarLanding = changedSection as? NSNumber, CFGetTypeID(buildWevvSugarLanding) != CFBooleanGetTypeID(),
                              buildWevvSugarLanding.doubleValue.isFinite, buildWevvSugarLanding.doubleValue.rounded() == buildWevvSugarLanding.doubleValue,
                              buildWevvSugarLanding.doubleValue >= 0, buildWevvSugarLanding.doubleValue < Double(Int.max) else { return nil }
                        return buildWevvSugarLanding.intValue
                    }
                    guard let buildTastingQuestBand = bakeryTrailRow(coconutMangoMedley[1]), let buildSugarTextPage = bakeryTrailRow(coconutMangoMedley[2]),
                          buildTastingQuestBand <= bakeryFinder, bakeryFinder <= buildSugarTextPage else { throw bakeryWeekStack.buildFlavorScroll }
                } else {
                    guard let bindSugarConfirmButtons = coconutMangoMedley[1] as? String, bindSugarConfirmButtons.hasPrefix("$") else { throw bakeryWeekStack.buildFlavorScroll }
                    guard bindSugarConfirmButtons == "$key" else { continue } // OSS enforces any other signed form constraints.
                    guard let berryBackdrop = coconutMangoMedley[2] as? String else { throw bakeryWeekStack.buildFlavorScroll }
                    if cafeCheckinCollection == "eq", buildInitialGlazeSheenPanels == berryBackdrop { continue }
                    if cafeCheckinCollection == "starts-with", buildInitialGlazeSheenPanels.hasPrefix(berryBackdrop) { continue }
                    // Do not invent a different directory or ignore a key restriction.
                    throw bakeryWeekStack.buildFlavorScroll
                }
            }
        }

        private static func cinnamonTwist(_ closeSugarText: String) -> URL? {
            guard closeSugarText.utf8.count <= 2048, let canonicalFolder = URLComponents(string: closeSugarText),
                  canonicalFolder.scheme?.lowercased() == "https", let buildBakeryVisitBand = canonicalFolder.host, !buildBakeryVisitBand.isEmpty,
                  canonicalFolder.user == nil, canonicalFolder.password == nil, canonicalFolder.query == nil, canonicalFolder.fragment == nil,
                  let cocoaVelvetMotif = canonicalFolder.url else { return nil }
            return cocoaVelvetMotif
        }
    }

    private final class crumbBioLabel: NSObject, URLSessionTaskDelegate {
        nonisolated func urlSession(_ citrusBergamotFinish: URLSession, task closeSugarSettings: URLSessionTask,
                                    willPerformHTTPRedirection cherryBlossomCalendar: HTTPURLResponse, newRequest cherryAlmondFusion: URLRequest,
                                    completionHandler bakeryTagRow: @escaping (URLRequest?) -> Void) {
            bakeryTagRow(nil)
        }
    }

    private let citrusBergamotFinish: URLSession
    private let citrusBergamotEssence: afternoonTreatJourney?
    private let chocolateCurlDust = BrostingmellowCoconutEssence.listenForGlazeTrades
    private let clearSugarCrumbLayer = WevVGlazeSessionStore.shared
    private static let buildTastingJournalPanel = 25 * 1024 * 1024

    /// An injected sender is used only by offline tests; production uses an isolated URLSession.
    init(citrusBergamotEssence: afternoonTreatJourney? = nil) {
        self.citrusBergamotEssence = citrusBergamotEssence
        let bakeryTrailLabel = URLSessionConfiguration.ephemeral
        bakeryTrailLabel.urlCache = nil
        bakeryTrailLabel.httpCookieStorage = nil
        bakeryTrailLabel.httpShouldSetCookies = false
        bakeryTrailLabel.httpCookieAcceptPolicy = .never
        bakeryTrailLabel.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        citrusBergamotFinish = URLSession(configuration: bakeryTrailLabel, delegate: crumbBioLabel(), delegateQueue: nil)
    }

    func cocoaRaspberryMedley(batterWhiskEssentials: Data, blackberryCream: String, buildTastingParlorPanel: String) async throws -> String {
        let blushDrizzleDetail = try Self.buildDonutStampContent(batterWhiskEssentials: batterWhiskEssentials, buildTastingParlorPanel: buildTastingParlorPanel)
        guard !blackberryCream.isEmpty, blackberryCream.utf8.count <= 255,
              !blackberryCream.utf8.contains(where: { $0 == 13 || $0 == 10 || $0 == 0 }) else { throw bakeryWeekStack.buildFlavorNoteEntryButton }
        try await chocolateCurlDust.glazeCounterBakery()
        let benchRestDetail = clearSugarCrumbLayer.sessionEpoch, chosenFlavor = chocolateCurlDust.closeCreamRingEdit
        let allBakeryAtlasDetails = try await chocolateCurlDust.makePackCard()
        try bakeryShelfKeys(allBakeryAtlasDetails.vanillaBeanIcing, benchRestDetail: benchRestDetail, chosenFlavor: chosenFlavor)
        let cleanDonutAvatar = try await chocolateCurlDust.frostedWinterAssortment(glazeCatalogRefresh: "/_v2/user/ossParam", autumnPecanSelection: JSONSerialization.data(withJSONObject: [:]), applyRemoteTrailButton: true)
        try bakeryShelfKeys(allBakeryAtlasDetails.vanillaBeanIcing, benchRestDetail: benchRestDetail, chosenFlavor: chosenFlavor)
        let caramelLatteCompanion = try bakingScaleStation(batterWhiskEssentials: cleanDonutAvatar)
        try caramelLatteCompanion.bakeryShelfGuide()
        let buildInitialGlazeSheenPanels = Self.butterAromaNotes(almondCutter: allBakeryAtlasDetails.vanillaBeanIcing, bindFlavorKeyboard: blushDrizzleDetail.bindFlavorKeyboard)
        try caramelLatteCompanion.coconutCenter(buildInitialGlazeSheenPanels: buildInitialGlazeSheenPanels, bakeryFinder: batterWhiskEssentials.count)
        let backgroundPath = "WevVBoundary" + UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let biteNoteLabel = [("key", buildInitialGlazeSheenPanels), ("policy", caramelLatteCompanion.cardVerticalConstraint), ("OSSAccessKeyId", caramelLatteCompanion.agrtastingFlightShowcaseee),
                      ("Signature", caramelLatteCompanion.cleanCrumbPacketPart), ("success_action_status", "200")]
        let buildWevvBakeryGateCanvas = Self.buildWevvBakeryGateCanvas(batterWhiskEssentials: batterWhiskEssentials, biteNoteLabel: biteNoteLabel, backgroundPath: backgroundPath, blushDrizzleDetail: blushDrizzleDetail)
        var cherryAlmondFusion = URLRequest(url: caramelLatteCompanion.buildBakeryVisitBand, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        cherryAlmondFusion.httpMethod = "POST"
        cherryAlmondFusion.httpShouldHandleCookies = false
        cherryAlmondFusion.setValue("multipart/form-data; boundary=" + backgroundPath, forHTTPHeaderField: "Content-Type")
        cherryAlmondFusion.setValue("no-store", forHTTPHeaderField: "Cache-Control")
        try bakeryShelfKeys(allBakeryAtlasDetails.vanillaBeanIcing, benchRestDetail: benchRestDetail, chosenFlavor: chosenFlavor)
        try caramelLatteCompanion.bakeryShelfGuide()
        let cherryBlossomCalendar: URLResponse
        if let citrusBergamotEssence { (_, cherryBlossomCalendar) = try await citrusBergamotEssence(cherryAlmondFusion, buildWevvBakeryGateCanvas) }
        else { (_, cherryBlossomCalendar) = try await citrusBergamotFinish.upload(for: cherryAlmondFusion, from: buildWevvBakeryGateCanvas) }
        try bakeryShelfKeys(allBakeryAtlasDetails.vanillaBeanIcing, benchRestDetail: benchRestDetail, chosenFlavor: chosenFlavor)
        guard let buildDonutParlorBackdrop = cherryBlossomCalendar as? HTTPURLResponse, buildDonutParlorBackdrop.url == caramelLatteCompanion.buildBakeryVisitBand else { throw bakeryWeekStack.buildFlavorScroll }
        guard (200..<300).contains(buildDonutParlorBackdrop.statusCode) else { throw accountGroup.brownButterPecanCombination(buildDonutParlorBackdrop.statusCode) }
        return caramelLatteCompanion.chaiSpiceIcing.appendingPathComponent(buildInitialGlazeSheenPanels).absoluteString
    }

    private func bakeryShelfKeys(_ almondCutter: Int64, benchRestDetail: Int, chosenFlavor: String) throws {
        try chocolateCurlDust.applyPortraitAsset(closeVideoDial: benchRestDetail, liftPastryEditCanvas: chosenFlavor)
        guard clearSugarCrumbLayer.currentGlazeCredentials?.vanillaBeanIcing == almondCutter else { throw CancellationError() }
    }

    private struct bakingSceneFrame {
        let buildTastingParlorPanel: String
        let bindFlavorKeyboard: String
    }

    private static func buildDonutStampContent(batterWhiskEssentials: Data, buildTastingParlorPanel: String) throws -> bakingSceneFrame {
        guard !batterWhiskEssentials.isEmpty, batterWhiskEssentials.count <= buildTastingJournalPanel else { throw bakeryWeekStack.buildFlavorNoteEntryButton }
        let carouselAsset = Array(batterWhiskEssentials.prefix(12))
        switch buildTastingParlorPanel.lowercased() {
        case "image/jpeg" where carouselAsset.count >= 4 && carouselAsset.starts(with: [0xff, 0xd8, 0xff]):
            return bakingSceneFrame(buildTastingParlorPanel: "image/jpeg", bindFlavorKeyboard: "jpg")
        case "image/png" where carouselAsset.starts(with: [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]):
            return bakingSceneFrame(buildTastingParlorPanel: "image/png", bindFlavorKeyboard: "png")
        case "image/webp" where carouselAsset.count == 12 && Array(carouselAsset.prefix(4)) == Array("RIFF".utf8) && Array(carouselAsset.suffix(4)) == Array("WEBP".utf8):
            return bakingSceneFrame(buildTastingParlorPanel: "image/webp", bindFlavorKeyboard: "webp")
        default: throw bakeryWeekStack.buildFlavorNoteEntryButton
        }
    }

    private static func butterAromaNotes(almondCutter: Int64, bindFlavorKeyboard closeDailyDonut: String) -> String {
        let bodyWevVSugarText = DateFormatter()
        bodyWevVSugarText.calendar = Calendar(identifier: .gregorian)
        bodyWevVSugarText.locale = Locale(identifier: "en_US_POSIX")
        bodyWevVSugarText.timeZone = .current
        bodyWevVSugarText.dateFormat = "yyyyMMdd"
        let buildDonutParlorFoot = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        return "\(almondCutter)/\(bodyWevVSugarText.string(from: Date()))/\(buildDonutParlorFoot).\(closeDailyDonut)"
    }

    private static func buildWevvBakeryGateCanvas(batterWhiskEssentials: Data, biteNoteLabel: [(String, String)], backgroundPath: String, blushDrizzleDetail: bakingSceneFrame) -> Data {
        var backgroundImage = Data()
        backgroundImage.reserveCapacity(batterWhiskEssentials.count + biteNoteLabel.reduce(1024) { $0 + $1.1.utf8.count })
        func apricotCenter(_ closeSugarText: String) { backgroundImage.append(Data(closeSugarText.utf8)) }
        for (buildWevvBakeryShelfPage, coconutFlakeAccent) in biteNoteLabel {
            apricotCenter("--\(backgroundPath)\r\nContent-Disposition: form-data; name=\"\(buildWevvBakeryShelfPage)\"\r\n\r\n\(coconutFlakeAccent)\r\n")
        }
        apricotCenter("--\(backgroundPath)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"upload.\(blushDrizzleDetail.bindFlavorKeyboard)\"\r\nContent-Type: \(blushDrizzleDetail.buildTastingParlorPanel)\r\n\r\n")
        backgroundImage.append(batterWhiskEssentials)
        apricotCenter("\r\n--\(backgroundPath)--\r\n")
        return backgroundImage
    }
}
