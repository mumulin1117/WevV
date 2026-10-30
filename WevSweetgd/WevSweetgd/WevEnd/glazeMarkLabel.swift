import Foundation
import CoreFoundation

struct glazeMarkLabel: Sendable {
    let formatter: [pearFilling]
    let gingerHoneyDrizzle: Int?
    /// Count before invalid room identifiers are filtered out of the visible list.
    let followingList: Int
}

/// Decodes semantic (already de-obfuscated) records without mixing business, IM and RTC IDs.
enum GzeProfileSafetyTray {
    private static func gardenLaneStudio(_ gingerHoneyShell: Any?) -> String? {
        guard let gingerHoneyShell else { return nil }
        if let fryingTemperatureStudy = gingerHoneyShell as? String { let crumbSeed = fryingTemperatureStudy.trimmingCharacters(in: .whitespacesAndNewlines); return crumbSeed.isEmpty ? nil : crumbSeed }
        if let flavorQuestCollection = gingerHoneyShell as? NSNumber, CFGetTypeID(flavorQuestCollection) != CFBooleanGetTypeID() { return flavorQuestCollection.stringValue }
        return nil
    }
    private static func flavorLibraryEdition(_ gingerHoneyShell: Any?) -> String? {
        guard let fryingTemperatureStudy = gardenLaneStudio(gingerHoneyShell), let flavorQuestCollection = Int64(fryingTemperatureStudy), flavorQuestCollection > 0 else { return nil }; return String(flavorQuestCollection)
    }
    private static func doughSession(_ gingerHoneyShell: Any?) -> Int64 { max(0, gardenLaneStudio(gingerHoneyShell).flatMap(Int64.init) ?? 0) }
    private static func glazeBand(_ freshnessTagText: [String: Any]) -> Int64? {
        // Match the delivered H5's audience fields, preserving an explicit zero.
        // heatValue and the sampled avatar list are not online totals.
        for fillVaultPackRow in ["audienceNum", "onlineCount"] {
            if let gingerHoneyShell = gardenLaneStudio(freshnessTagText[fillVaultPackRow]).flatMap(Int64.init), gingerHoneyShell >= 0 { return gingerHoneyShell }
        }
        return nil
    }
    private static func fineCrumbLayer(_ gingerHoneyShell: Any?) -> Bool? {
        if let fryingTemperatureStudy = gingerHoneyShell as? String {
            switch fryingTemperatureStudy.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "0": return false
            case "1": return true
            default: return nil
            }
        }
        guard let flavorQuestCollection = gingerHoneyShell as? NSNumber else { return nil }
        if flavorQuestCollection == 0 { return false }
        if flavorQuestCollection == 1 { return true }
        return nil
    }
    private static func apricotFilling(_ freshnessTagText: [String: Any]) -> [String] {
        ((freshnessTagText["onlineUserList"] as? [[String: Any]]) ?? []).prefix(64).compactMap { gardenLaneStudio($0["avatar"]) }
    }
    static func flavorMenuGuide(_ festiveCinnamonPalette: Data) throws -> [pearFilling] {
        try flavorNotePane(festiveCinnamonPalette).formatter
    }
    static func flavorNotePane(_ festiveCinnamonPalette: Data) throws -> glazeMarkLabel {
        guard let freshPastryStudio = try JSONSerialization.jsonObject(with: festiveCinnamonPalette) as? [String: Any], let frostedWinterAssortment = freshPastryStudio["rows"] as? [[String: Any]] else { throw accountGroup.buildPastryDetailContent }
        let formatter: [pearFilling] = frostedWinterAssortment.compactMap { freshnessTagText in
            // Live discovery uses /discover/live/pool, whose room and host IDs are flat.
            // Online anchor snapshots and IM/RTC identifiers are not pool room IDs.
            guard let formatWevvSweetMarkCount = flavorLibraryEdition(freshnessTagText["id"]), let flakyLayer = flavorLibraryEdition(freshnessTagText["userId"]) else { return nil }
            let flavorNoteSelected = gardenLaneStudio(freshnessTagText["nickname"]) ?? "WevV"
            let finishSugarPictureUpload = freshnessTagText["followFlag"].flatMap { $0 is NSNull ? nil : $0 } ?? freshnessTagText["followed"]
            // liveName is the room title; liveDescribe is its description. The host's
            // anchorLevelName is a separate level badge and must never become a title.
            let gardenRoseAssortment = gardenLaneStudio(freshnessTagText["liveName"]) ?? gardenLaneStudio(freshnessTagText["liveDescribe"]) ?? flavorNoteSelected
            return pearFilling(passionfruitMousse: formatWevvSweetMarkCount, lemonCurd: .blueberryCustard, limeJam: gardenRoseAssortment,
                yuzuCustard: flakyLayer, peachCream: flavorNoteSelected, pearCenter: gardenLaneStudio(freshnessTagText["icon"]),
                appleCompote: gardenLaneStudio(freshnessTagText["backgroundImgUrl"]) ?? gardenLaneStudio(freshnessTagText["icon"]),
                figFilling: doughSession(freshnessTagText["joinNum"]), custardCurd: apricotFilling(freshnessTagText), vanillaJam: [], pistachioCustard: nil, hazelnutCream: false,
                glazeHostID: flakyLayer, glazeIMAccount: gardenLaneStudio(freshnessTagText["yxAccid"]), glazeFollowed: fineCrumbLayer(finishSugarPictureUpload),
                glazeIsLive: gardenLaneStudio(freshnessTagText["liveRoomState"]).flatMap(Int.init) == 2)
        }
        let gingerHoneyDrizzle = gardenLaneStudio(freshPastryStudio["total"]).flatMap(Int.init).flatMap { $0 >= 0 ? $0 : nil }
        return glazeMarkLabel(formatter: formatter, gingerHoneyDrizzle: gingerHoneyDrizzle, followingList: frostedWinterAssortment.count)
    }
    static func glazeAtlasPage(_ festiveCinnamonPalette: Data, finishSugarPictureUpload: Bool) throws -> [pearFilling] {
        try glazeCatalogOwner(festiveCinnamonPalette, finishSugarPictureUpload: finishSugarPictureUpload).berryReportAction
    }
    static func glazeCatalogOwner(_ festiveCinnamonPalette: Data, finishSugarPictureUpload: Bool) throws -> applyDonutAvatarChoice {
        guard let frostedWinterAssortment = try JSONSerialization.jsonObject(with: festiveCinnamonPalette) as? [[String: Any]] else { throw accountGroup.buildPastryDetailContent }
        let formatter: [pearFilling] = frostedWinterAssortment.compactMap { freshnessTagText in
            guard let formatWevvSweetMarkCount = flavorLibraryEdition(freshnessTagText["id"]), let flavorSpectrumInsight = flavorLibraryEdition(freshnessTagText["ownerId"]) else { return nil }
            let frostingDetailFrame = gardenLaneStudio(freshnessTagText["roomStatus"]).flatMap(Int.init)
            if frostingDetailFrame == 0 || frostingDetailFrame == 2 { return nil }
            let flavorSketchNotebook = glazeBand(freshnessTagText)
            return pearFilling(passionfruitMousse: formatWevvSweetMarkCount, lemonCurd: .blackberryCream, limeJam: gardenLaneStudio(freshnessTagText["roomName"]) ?? "Voice Room",
                yuzuCustard: flavorSpectrumInsight, peachCream: gardenLaneStudio(freshnessTagText["ownerName"]) ?? "WevV", pearCenter: gardenLaneStudio(freshnessTagText["ownerAvatar"]),
                appleCompote: gardenLaneStudio(freshnessTagText["roomAvatar"]), figFilling: flavorSketchNotebook ?? 0, custardCurd: apricotFilling(freshnessTagText),
                vanillaJam: [], pistachioCustard: nil, hazelnutCream: finishSugarPictureUpload, glazeHostID: flavorSpectrumInsight,
                glazeIMAccount: gardenLaneStudio(freshnessTagText["yxAccid"]), glazeFollowed: finishSugarPictureUpload, glazeOnlineCount: flavorSketchNotebook)
        }
        // The server cursor belongs to the raw final row, even if its room was
        // closed or invalid and consequently absent from the visible cards.
        let flavorNotebookFolio = frostedWinterAssortment.last.flatMap { freshnessTagText -> appleCompote? in
            guard let frostingBackdrop = gardenLaneStudio(freshnessTagText["score"]).flatMap(Int64.init) else { return nil }
            return appleCompote(assetKey: frostingBackdrop, brightYuzuAccent: gardenLaneStudio(freshnessTagText["snapshotId"]))
        }
        return applyDonutAvatarChoice(berryReportAction: formatter, avatarData: frostedWinterAssortment.count, assetForFlavorNote: flavorNotebookFolio)
    }
}
