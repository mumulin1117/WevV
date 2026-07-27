import Foundation

struct WevVSugarMomentPacket {
    let sugarKey: String
    let heroAsset: String
    let text: String
    let timeText: String
}

struct WevVSprinkleQuestPacket {
    let sugarKey: String
    let title: String
    let text: String
    let timeText: String
    let placeText: String
    let sugarCost: Int
}

final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()

    private let wevvSignedInKey = "wevv_glaze_signed_in"
    private let wevvShopShelfKey = "wevv_glaze_shop_shelf"
    private let wevvCrumbNoteKey = "wevv_glaze_crumb_notes"
    private let wevvDailyStampKey = "wevv_glaze_daily_stamp"
    private let wevvGoldVaultKey = "wevv_glaze_gold_vault"
    private let wevvJoinedQuestKey = "wevv_glaze_joined_quests"
    private let wevvCreamMicGrantKey = "wevv_glaze_cream_mic_grant"
    private let wevvSafetyCrumbKey = "wevv_glaze_safety_crumbs"
    private let wevvSugarMomentKey = "wevv_glaze_sugar_moments"
    private let wevvSprinkleQuestKey = "wevv_glaze_sprinkle_quests"
    private let frostingDefaults = UserDefaults.standard

    var isTasterReady: Bool {
        frostingDefaults.bool(forKey: wevvSignedInKey)
    }

    var glazeShelfCount: Int {
        glazeShelfKeys.count
    }

    var glazeShelfPacketKeys: [String] {
        Array(glazeShelfKeys).sorted()
    }

    var glazeGoldCount: Int {
        return frostingDefaults.integer(forKey: wevvGoldVaultKey)
    }

    var hasCreamMicGrant: Bool {
        frostingDefaults.bool(forKey: wevvCreamMicGrantKey)
    }

    var sugarMomentPackets: [WevVSugarMomentPacket] {
        (frostingDefaults.stringArray(forKey: wevvSugarMomentKey) ?? []).compactMap { rawPacket in
            let parts = rawPacket.components(separatedBy: "|")
            guard parts.count >= 4 else { return nil }
            let text = parts.dropFirst(3).joined(separator: "|")
            return WevVSugarMomentPacket(sugarKey: parts[0], heroAsset: parts[1], text: text, timeText: parts[2])
        }
    }

    var sprinkleQuestPackets: [WevVSprinkleQuestPacket] {
        (frostingDefaults.stringArray(forKey: wevvSprinkleQuestKey) ?? []).compactMap { rawPacket in
            let parts = rawPacket.components(separatedBy: "|")
            guard parts.count >= 6, let cost = Int(parts[5]) else { return nil }
            return WevVSprinkleQuestPacket(
                sugarKey: parts[0],
                title: parts[1],
                text: parts[2],
                timeText: parts[3],
                placeText: parts[4],
                sugarCost: cost
            )
        }
    }

    func markGlazeTasterReady() {
        frostingDefaults.set(true, forKey: wevvSignedInKey)
        if frostingDefaults.object(forKey: wevvGoldVaultKey) == nil {
            frostingDefaults.set(0, forKey: wevvGoldVaultKey)
        }
    }

    func restGlazeTaster() {
        frostingDefaults.set(false, forKey: wevvSignedInKey)
    }

    func clearSugarCrumbs() {
        frostingDefaults.removeObject(forKey: wevvCrumbNoteKey)
        frostingDefaults.removeObject(forKey: wevvDailyStampKey)
        frostingDefaults.removeObject(forKey: wevvSafetyCrumbKey)
    }

    func dissolveGlazeTasterPacket() {
        [
            wevvSignedInKey,
            wevvShopShelfKey,
            wevvCrumbNoteKey,
            wevvDailyStampKey,
            wevvGoldVaultKey,
            wevvJoinedQuestKey,
            wevvCreamMicGrantKey,
            wevvSafetyCrumbKey,
            wevvSugarMomentKey,
            wevvSprinkleQuestKey
        ].forEach { frostingDefaults.removeObject(forKey: $0) }
    }

    func markCreamMicGrant() {
        frostingDefaults.set(true, forKey: wevvCreamMicGrantKey)
    }

    func isGlazeShelfed(shopKey: String) -> Bool {
        glazeShelfKeys.contains(shopKey)
    }

    @discardableResult
    func placeGlazeShelf(shopKey: String) -> Bool {
        var shelfKeys = glazeShelfKeys
        let inserted = shelfKeys.insert(shopKey).inserted
        guard inserted else { return false }
        frostingDefaults.set(Array(shelfKeys).sorted(), forKey: wevvShopShelfKey)
        return true
    }

    func placeCrumbNote(shopKey: String, rating: Int, text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let crumbPacket = "\(shopKey)|\(rating)|\(Date().timeIntervalSince1970)|\(cleanText)"
        var crumbNotes = frostingDefaults.stringArray(forKey: wevvCrumbNoteKey) ?? []
        crumbNotes.append(crumbPacket)
        frostingDefaults.set(crumbNotes, forKey: wevvCrumbNoteKey)
    }

    func placeGlazeSafetyCrumb(_ packet: WevVGlazeSafetyPacket) {
        let cleanText = packet.creamText.trimmingCharacters(in: .whitespacesAndNewlines)
        let safePacket = [
            packet.shopKey,
            packet.choiceKey,
            packet.choiceTitle,
            cleanText,
            "\(packet.sugarMoment)"
        ].joined(separator: "|")
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvSafetyCrumbKey)
    }

    func placeSugarMoment(heroAsset: String, text: String) -> WevVSugarMomentPacket {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarKey = "sugarMoment\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSugarMomentPacket(sugarKey: sugarKey, heroAsset: heroAsset, text: cleanText, timeText: "Just now")
        let rawPacket = [packet.sugarKey, packet.heroAsset, packet.timeText, packet.text].joined(separator: "|")
        var packets = frostingDefaults.stringArray(forKey: wevvSugarMomentKey) ?? []
        packets.insert(rawPacket, at: 0)
        frostingDefaults.set(packets, forKey: wevvSugarMomentKey)
        return packet
    }

    func placeSprinkleQuest(title: String, text: String, timeText: String, placeText: String, sugarCost: Int) -> WevVSprinkleQuestPacket {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTime = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPlace = placeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarKey = "sprinkleQuest\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSprinkleQuestPacket(
            sugarKey: sugarKey,
            title: cleanTitle,
            text: cleanText,
            timeText: cleanTime,
            placeText: cleanPlace,
            sugarCost: sugarCost
        )
        let rawPacket = [packet.sugarKey, packet.title, packet.text, packet.timeText, packet.placeText, "\(packet.sugarCost)"].joined(separator: "|")
        var packets = (frostingDefaults.stringArray(forKey: wevvSprinkleQuestKey) ?? []).filter { rawQuest in
            let parts = rawQuest.components(separatedBy: "|")
            guard parts.count >= 6 else { return true }
            let sameTitle = parts[1].caseInsensitiveCompare(packet.title) == .orderedSame
            let sameTime = parts[3].caseInsensitiveCompare(packet.timeText) == .orderedSame
            let samePlace = parts[4].caseInsensitiveCompare(packet.placeText) == .orderedSame
            let sameCost = parts[5] == "\(packet.sugarCost)"
            return !(sameTitle && sameTime && samePlace && sameCost)
        }
        packets.insert(rawPacket, at: 0)
        frostingDefaults.set(packets, forKey: wevvSprinkleQuestKey)
        return packet
    }

    func hasDailyGlazeStamp(dayKey: String) -> Bool {
        dailyGlazeStampKeys.contains { $0.hasPrefix("\(dayKey)|") }
    }

    @discardableResult
    func placeDailyGlazeStamp(dayKey: String, mood: String) -> Bool {
        var stampKeys = dailyGlazeStampKeys
        let inserted = stampKeys.insert("\(dayKey)|\(mood)")
        guard inserted.inserted else { return false }
        frostingDefaults.set(Array(stampKeys).sorted(), forKey: wevvDailyStampKey)
        return true
    }

    func addGlazeGold(_ amount: Int) {
        frostingDefaults.set(glazeGoldCount + max(0, amount), forKey: wevvGoldVaultKey)
    }

    @discardableResult
    func spendGlazeGold(_ amount: Int) -> Bool {
        let safeAmount = max(0, amount)
        guard glazeGoldCount >= safeAmount else { return false }
        frostingDefaults.set(glazeGoldCount - safeAmount, forKey: wevvGoldVaultKey)
        return true
    }

    func hasJoinedGlazeQuest(_ questKey: String) -> Bool {
        joinedGlazeQuestKeys.contains(questKey)
    }

    @discardableResult
    func placeJoinedGlazeQuest(_ questKey: String) -> Bool {
        var joinedKeys = joinedGlazeQuestKeys
        let inserted = joinedKeys.insert(questKey).inserted
        guard inserted else { return false }
        frostingDefaults.set(Array(joinedKeys).sorted(), forKey: wevvJoinedQuestKey)
        return true
    }

    private var glazeShelfKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: wevvShopShelfKey) ?? [])
    }

    private var dailyGlazeStampKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: wevvDailyStampKey) ?? [])
    }

    private var joinedGlazeQuestKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: wevvJoinedQuestKey) ?? [])
    }
}
