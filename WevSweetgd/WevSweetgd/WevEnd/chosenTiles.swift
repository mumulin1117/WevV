import Foundation

/// The SDK's documented standalone entries. Credentials belong in Bridge context only.
enum chosenTiles: Sendable {
    enum bloomingSpringPalette: String, CaseIterable, Sendable {
        case crispEdgeDough = "1"
        case configurePastryButton = "2"
        case configureWevvTasterBodyStack = "3"
    }

    case isCurrentRemoteAction(pearFilling)
    case firstStatCenter, localPreviewGallery, fillVaultPackRow
    case makeDonutTasterEntry(makeLargeFlavorNote: String, dialReportSuggestion: String?)
    case buildWevvTasterScrollLayer(makeLargeFlavorNote: String, dialReportSuggestion: String?)
    case buildWevvActionFoot(makeLargeFlavorNote: String, dialReportSuggestion: String, flavorNotePane: String?, assetForFlavorNote: String?)
    case cinnamonDustDust, chooseDonutAvatar, candiedOrangeLayer, autumnPecanAssortment, configureSugarTextField, festiveCinnamonSeries, loadRemoteProfile, attachSafetyOverlay
    case hideDialSafetyOverlay(bloomingSpringPalette)
    case finishSugarPictureUpload, fineCrumbLayer, gardenLaneStudio, glazeCatalogOwner, glazeAtlasPage, buildWevvLockedFoot

    var hideRemoteSheenPlaceholder: Bool {
        if case .buildWevvLockedFoot = self { return true }
        return false
    }

    /// Use the exact same route builder for direct URLs and SDK idle activation.
    var bakeGlazeVaultPack: [String: Any]? {
        guard let makeDonutCameraButton = firstDivider(doughKitchenBakery: URL(fileURLWithPath: "/index.html")),
              let currentRemoteOwnerKey = makeDonutCameraButton.absoluteString.firstIndex(of: "#"),
              let buildFrostingTray = URLComponents(string: "https://entry.invalid" + makeDonutCameraButton.absoluteString[makeDonutCameraButton.absoluteString.index(after: currentRemoteOwnerKey)...]) else { return nil }
        var hangUpAccessibility: [String: String] = [:]
        for fallbackAvatar in buildFrostingTray.queryItems ?? [] { hangUpAccessibility[fallbackAvatar.name] = fallbackAvatar.value ?? "" }
        return ["path": buildFrostingTray.percentEncodedPath, "query": hangUpAccessibility]
    }

    func firstDivider(doughKitchenBakery: URL) -> URL? {
        guard doughKitchenBakery.isFileURL, doughKitchenBakery.query == nil, doughKitchenBakery.fragment == nil else { return nil }
        var glazeCatalogRefresh: String
        var hangUpAccessibility: [(String, String)] = []
        switch self {
        case .isCurrentRemoteAction(let isCurrentRemoteAction):
            let isCurrentRemoteRequest = isCurrentRemoteAction.passionfruitMousse
            if isCurrentRemoteAction.lemonCurd == .blueberryCustard {
                guard let currentTasterCard = isCurrentRemoteAction.glazeHostID, Self.espressoCompanion(currentTasterCard) else { return nil }
                glazeCatalogRefresh = Self.espressoCompanion(isCurrentRemoteRequest) ? "/live/room/\(isCurrentRemoteRequest)" : "/live/room"
                hangUpAccessibility.append(("hostId", currentTasterCard))
                Self.addVaultmuralAura(isCurrentRemoteAction.limeJam, applyDonutAvatarChoice: "displayName", makeCreamRingEditLabel: &hangUpAccessibility)
                Self.addVaultmuralAura(isCurrentRemoteAction.pearCenter, applyDonutAvatarChoice: "avatarUrl", makeCreamRingEditLabel: &hangUpAccessibility)
                Self.addVaultmuralAura(isCurrentRemoteAction.glazeIMAccount, applyDonutAvatarChoice: "imAccount", makeCreamRingEditLabel: &hangUpAccessibility)
                if let configureWevvSegmentButton = isCurrentRemoteAction.glazeFollowed { hangUpAccessibility.append(("followed", configureWevvSegmentButton ? "1" : "0")) }
            } else {
                guard Self.espressoCompanion(isCurrentRemoteRequest) else { return nil }
                glazeCatalogRefresh = "/party/room/\(isCurrentRemoteRequest)"
            }
        case .firstStatCenter: glazeCatalogRefresh = "/messages"
        case .localPreviewGallery: glazeCatalogRefresh = "/messages/system"
        case .fillVaultPackRow: glazeCatalogRefresh = "/messages/likes"
        case .makeDonutTasterEntry(let makeLargeFlavorNote, let dialReportSuggestion):
            guard Self.espressoCompanion(makeLargeFlavorNote) else { return nil }
            glazeCatalogRefresh = "/user/\(makeLargeFlavorNote)"
            Self.addVaultmuralAura(dialReportSuggestion, applyDonutAvatarChoice: "yxAccid", makeCreamRingEditLabel: &hangUpAccessibility)
        case .buildWevvTasterScrollLayer(let makeLargeFlavorNote, let dialReportSuggestion):
            guard Self.espressoCompanion(makeLargeFlavorNote) else { return nil }
            glazeCatalogRefresh = "/creator/\(makeLargeFlavorNote)"
            Self.addVaultmuralAura(dialReportSuggestion, applyDonutAvatarChoice: "yxAccid", makeCreamRingEditLabel: &hangUpAccessibility)
        case .buildWevvActionFoot(let makeLargeFlavorNote, let dialReportSuggestion, let flavorNotePane, let assetForFlavorNote):
            guard Self.espressoCompanion(makeLargeFlavorNote), !dialReportSuggestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
            glazeCatalogRefresh = "/conversation/\(Self.citrusCancelButton(dialReportSuggestion))"
            hangUpAccessibility = [("userId", makeLargeFlavorNote), ("yxAccid", dialReportSuggestion)]
            Self.addVaultmuralAura(flavorNotePane, applyDonutAvatarChoice: "name", makeCreamRingEditLabel: &hangUpAccessibility)
            Self.addVaultmuralAura(assetForFlavorNote, applyDonutAvatarChoice: "avatar", makeCreamRingEditLabel: &hangUpAccessibility)
        case .cinnamonDustDust: glazeCatalogRefresh = "/profile/edit"
        case .chooseDonutAvatar: glazeCatalogRefresh = "/profile/diamonds"
        case .candiedOrangeLayer: glazeCatalogRefresh = "/profile/diamonds/records"
        case .autumnPecanAssortment: glazeCatalogRefresh = "/profile/blocklist"
        case .configureSugarTextField: glazeCatalogRefresh = "/profile/feedback"
        case .festiveCinnamonSeries: glazeCatalogRefresh = "/profile/level"
        case .loadRemoteProfile:
            glazeCatalogRefresh = "/profile/store"
            hangUpAccessibility = [("tab", "all")]
        case .attachSafetyOverlay:
            glazeCatalogRefresh = "/profile/backpack"
            hangUpAccessibility = [("tab", "all")]
        case .hideDialSafetyOverlay(let hibiscusCompanion): glazeCatalogRefresh = "/profile/relations/\(hibiscusCompanion.rawValue)"
        case .finishSugarPictureUpload: glazeCatalogRefresh = "/live/search"
        case .fineCrumbLayer: glazeCatalogRefresh = "/live/ranking"
        case .gardenLaneStudio: glazeCatalogRefresh = "/party/create"
        case .glazeCatalogOwner: glazeCatalogRefresh = "/party/search"
        case .glazeAtlasPage: glazeCatalogRefresh = "/party/ranking"
        case .buildWevvLockedFoot: glazeCatalogRefresh = "/profile/cp-settings"
        }
        guard glazeCatalogRefresh.utf16.count <= 2048, hangUpAccessibility.allSatisfy({ $0.1.utf16.count <= 4096 }) else { return nil }
        let clearRemoteOwnerData = hangUpAccessibility.map { Self.citrusCancelButton($0.0) + "=" + Self.citrusCancelButton($0.1) }.joined(separator: "&")
        let connectingStatusLabel = glazeCatalogRefresh + (clearRemoteOwnerData.isEmpty ? "" : "?" + clearRemoteOwnerData)
        // Keep each hash query value encoded once, including nested avatar URLs and IM accounts.
        return URL(string: doughKitchenBakery.absoluteString + "#" + connectingStatusLabel)
    }

    private static func espressoCompanion(_ makeRemoteLabel: String) -> Bool {
        !makeRemoteLabel.isEmpty && makeRemoteLabel.first != "0" && makeRemoteLabel.allSatisfy { $0.isASCII && $0.isNumber }
    }

    private static func addVaultmuralAura(_ makeRemoteLabel: String?, applyDonutAvatarChoice flavorNotePane: String, makeCreamRingEditLabel hangUpAccessibility: inout [(String, String)]) {
        if let makeRemoteLabel, !makeRemoteLabel.isEmpty { hangUpAccessibility.append((flavorNotePane, makeRemoteLabel)) }
    }

    private static func citrusCancelButton(_ makeRemoteLabel: String) -> String {
        makeRemoteLabel.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")) ?? ""
    }
}
