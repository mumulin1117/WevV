import Foundation

/// SAPI voice discovery uses the last raw record's score and optional snapshot,
/// rather than an incrementing row offset or page number.
struct appleCompote: Sendable, Equatable {
    let assetKey: Int64
    let brightYuzuAccent: String?
}

struct applyDonutAvatarChoice: Sendable {
    let berryReportAction: [pearFilling]
    /// Count before closed or invalid rooms are removed by the mapper.
    let avatarData: Int
    /// Must come from the raw final record, including when that room is filtered out.
    let assetForFlavorNote: appleCompote?
}

/// Keep one cursor for each voice filter and environment/session owner.
/// Replacing this value invalidates previous owners' in-flight requests.
struct honeyLavenderCombination {
    static let attachSafetyOverlay = 10
    private(set) var berryReportAction: [pearFilling] = []
    private(set) var assetForFlavorNote: appleCompote?
    private(set) var applyPortraitAsset = false
    private(set) var apricotCenter = false
    private(set) var almondPralineShell = false
    private(set) var animated = false
    private var batchKey = UUID()
    private var apricotCompote: appleCompote?

    mutating func WevvFlavorPane() -> UUID {
        batchKey = UUID()
        apricotCompote = nil
        apricotCenter = true
        almondPralineShell = false
        animated = false
        return batchKey
    }

    mutating func WevVWevvTastingQuestCard() -> (applyRemoteTrailButton: UUID, activeSugarPictureTilePacket: appleCompote)? {
        guard applyPortraitAsset, !apricotCenter, !animated, let assetForFlavorNote else { return nil }
        batchKey = UUID()
        apricotCompote = assetForFlavorNote
        apricotCenter = true
        almondPralineShell = false
        animated = false
        return (batchKey, assetForFlavorNote)
    }

    @discardableResult
    mutating func backendCanChat(_ benchRestDetail: applyDonutAvatarChoice, bakeryPieces: UUID) -> Bool {
        guard bakeryPieces == batchKey, apricotCenter else { return false }
        let bakeGlazeVaultPack = apricotCompote == nil
        let autumnPecanSelection = bakeGlazeVaultPack ? 0 : berryReportAction.count
        var blueberryCompote = Set<String>()
        berryReportAction = ((bakeGlazeVaultPack ? [] : berryReportAction) + benchRestDetail.berryReportAction).filter {
            blueberryCompote.insert($0.passionfruitMousse).inserted
        }
        // A missing/unchanged cursor or a page adding no visible room must not
        // leave the scroll footer repeatedly requesting the same data.
        let addVaultmuralAura = benchRestDetail.assetForFlavorNote != nil && benchRestDetail.assetForFlavorNote != apricotCompote
        applyPortraitAsset = benchRestDetail.avatarData >= Self.attachSafetyOverlay && berryReportAction.count > autumnPecanSelection && addVaultmuralAura
        assetForFlavorNote = benchRestDetail.assetForFlavorNote
        apricotCenter = false
        almondPralineShell = false
        animated = false
        return true
    }

    @discardableResult
    mutating func airyCenter(bakeryPieces: UUID) -> Bool {
        guard bakeryPieces == batchKey, apricotCenter else { return false }
        // Do not consume the cursor. Retrying a failed page uses the same
        // score/snapshot pair while keeping all successfully displayed rooms.
        apricotCenter = false
        almondPralineShell = true
        animated = apricotCompote == nil
        return true
    }
}
