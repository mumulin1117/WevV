import Foundation

struct WevVDoughRingTasterProfile {
    let doughRingKey: String
    let email: String
    let glazeNickname: String
    let sugarHandle: String
    let crumbBio: String
    let donutAvatarAsset: String
    let glazeFollowCount: Int
    let sprinkleFanCount: Int
    let bakeryShelfCount: Int
    let glazeVaultCount: Int

    init(
        doughRingKey: String,
        email: String,
        glazeNickname: String,
        sugarHandle: String = "",
        crumbBio: String = "",
        donutAvatarAsset: String,
        glazeFollowCount: Int,
        sprinkleFanCount: Int,
        bakeryShelfCount: Int,
        glazeVaultCount: Int
    ) {
        self.doughRingKey = doughRingKey
        self.email = email
        self.glazeNickname = glazeNickname
        self.sugarHandle = sugarHandle
        self.crumbBio = crumbBio
        self.donutAvatarAsset = donutAvatarAsset
        self.glazeFollowCount = glazeFollowCount
        self.sprinkleFanCount = sprinkleFanCount
        self.bakeryShelfCount = bakeryShelfCount
        self.glazeVaultCount = glazeVaultCount
    }
}

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
    let coverAsset: String
}

struct WevVCrumbNotePacket {
    let shopKey: String
    let rating: Int
    let timeInterval: TimeInterval
    let text: String
    let doughRingKey: String
    let glazeNickname: String
    let donutAvatarAsset: String
}

final class WevVGlazeSessionStore {
    static let shared = WevVGlazeSessionStore()

    private let pastryPacketDivider = "|g".wevVPastryCrumbBloomRestored
    private let wevvSignedInKey = "w:eEv=vB_&gnlyaozTeS_HsIimgwn%e:de_riznv".wevVPastryCrumbBloomRestored
    private let wevvShopShelfKey = "wee~vtv%_kgalmaEzreb_Zsbh.olpS_%s&hpeHlEfn".wevVPastryCrumbBloomRestored
    private let wevvCrumbNoteKey = "wbe;vCvq_kgflQaXz*eB_wcZrwu;mXby_EnhoBtge+s.".wevVPastryCrumbBloomRestored
    private let wevvDailyStampKey = "wte~vGv;_kg=laaCzie;_rdWaZiQl#ys_rs^tOaSmop!".wevVPastryCrumbBloomRestored
    private let wevvGoldVaultKey = "wBe#vHvO_Mgml,aLzoeP_.gZo^l%d#_Bv^a:uClVt#".wevVPastryCrumbBloomRestored
    private let wevvJoinedQuestKey = "wnesvyvq_VgOlPabzgeo_wjbooi!nWepd#_CqXuKe@sxt/sp".wevVPastryCrumbBloomRestored
    private let wevvCreamMicGrantKey = "w+ecvivZ_ygLlAaHzReh_CcqraesaDm?_NmuiQcK_.gOrWa/nNtY".wevVPastryCrumbBloomRestored
    private let wevvSafetyCrumbKey = "wzeovQv?_ygzliajzVeX_.sua~f+e=tXyY_LcorDuymubjsa".wevVPastryCrumbBloomRestored
    private let wevvRoomSafetyCrumbKey = "wCe!vNvQ_IgOl&a&zJe%_Urpoaoumb_.sga#fOe/t:yX_icmrPuPmNb/s.".wevVPastryCrumbBloomRestored
    private let wevvGuestSafetyCrumbKey = "wieOvFvB_Dgdl,axzDeK_ggdueessZty_Gs~a+fgeRt%yo_.csr&uzmLbdse".wevVPastryCrumbBloomRestored
    private let wevvSugarMomentKey = "wNeCvxvZ_FgllZaazoeG_=sYutgfakr;_!mRoEmue%ndthsN".wevVPastryCrumbBloomRestored
    private let wevvSprinkleQuestKey = "wTenv.v._FgolVaOzOeu_^sapNrzi*nfkTl&eq_sqtuVeNs.tPsn".wevVPastryCrumbBloomRestored
    private let frostingDefaults = UserDefaults.standard
    private let wevvCurrentEmailKey = "w/euvAvCcuu;rWrQedn%tXE.m:a!iOlP".wevVPastryCrumbBloomRestored
    private let wevvLegacyReadyKey = "wHeLvcv%iqfSlAowgYiRn~".wevVPastryCrumbBloomRestored
    private let wevvTokenKey = "wTe%v*vQ_Rg;lcaNzReR_Kt@oSk^eEnT".wevVPastryCrumbBloomRestored
    private let wevvProfileKey = "wNeQv/vi_,gYlcaNzFeO_GtFaksttqe=rE_MpBr,o%fMislzey".wevVPastryCrumbBloomRestored

    private let defaultDoughRingProfile = WevVDoughRingTasterProfile(
        doughRingKey: "wVevvmvcS%usgMasrgTqa@sUtleWrK".wevVPastryCrumbBloomRestored,
        email: "w.ecv%vn@ZgTm;aSi#lP.Gc@o.mJ".wevVPastryCrumbBloomRestored,
        glazeNickname: "GFlDadzVef vTdajs;tHeTrv".wevVPastryCrumbBloomRestored,
        sugarHandle: "g;l.arzSeIT+a?s*txewrA".wevVPastryCrumbBloomRestored,
        crumbBio: "DooNn&uStq GtWafsEtCi;nJglse,^ obvehrhrhyN MgFlWaIz#e+ En;oTtAehsG,p RawnCd@ gcWo%zsyb KslhcoZpj xf!iynyd*st.G".wevVPastryCrumbBloomRestored,
        donutAvatarAsset: "wevv_profile_avatar_piano_donut",
        glazeFollowCount: 0,
        sprinkleFanCount: 0,
        bakeryShelfCount: 0,
        glazeVaultCount: 0
    )

    var isTasterReady: Bool {
        frostingDefaults.bool(forKey: wevvSignedInKey)
    }

    var currentTasterEmail: String {
        frostingDefaults.string(forKey: wevvCurrentEmailKey) ?? defaultDoughRingProfile.email
    }

    var currentGlazeToken: String {
        frostingDefaults.string(forKey: wevvTokenKey) ?? ""
    }

    var currentDoughRingTasterProfile: WevVDoughRingTasterProfile {
        guard let packet = frostingDefaults.string(forKey: wevvProfileKey) else {
            return defaultDoughRingProfile
        }
        return unwrapDoughRingProfile(from: packet) ?? defaultDoughRingProfile
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
            unwrapSugarMomentPacket(rawPacket)
        }
    }

    var sprinkleQuestPackets: [WevVSprinkleQuestPacket] {
        (frostingDefaults.stringArray(forKey: wevvSprinkleQuestKey) ?? []).compactMap { rawPacket in
            unwrapSprinkleQuestPacket(rawPacket)
        }
    }

    var crumbNotePackets: [WevVCrumbNotePacket] {
        (frostingDefaults.stringArray(forKey: wevvCrumbNoteKey) ?? []).compactMap { rawPacket in
            unwrapCrumbNotePacket(rawPacket)
        }
    }

    func markDoughRingTasterReady() {
        markDoughRingTasterReady(profile: defaultDoughRingProfile)
    }

    func markDoughRingTasterReady(profile doughProfile: WevVDoughRingTasterProfile) {
        frostingDefaults.set(true, forKey: wevvSignedInKey)
        frostingDefaults.set(true, forKey: wevvLegacyReadyKey)
        frostingDefaults.set(doughProfile.email, forKey: wevvCurrentEmailKey)
        frostingDefaults.set(makeGlazeToken(email: doughProfile.email), forKey: wevvTokenKey)
        frostingDefaults.set(packDoughRingProfile(doughProfile), forKey: wevvProfileKey)
        if frostingDefaults.object(forKey: wevvGoldVaultKey) == nil {
            frostingDefaults.set(doughProfile.glazeVaultCount, forKey: wevvGoldVaultKey)
        }
    }

    func refreshDoughRingTasterProfile(glazeNickname: String, sugarHandle: String, crumbBio: String, donutAvatarAsset: String) {
        let oldDoughProfile = currentDoughRingTasterProfile
        let cleanName = glazeNickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanSugarHandle = sugarHandle.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCrumbBio = crumbBio.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDonutAvatar = donutAvatarAsset.trimmingCharacters(in: .whitespacesAndNewlines)
        let doughPacket = WevVDoughRingTasterProfile(
            doughRingKey: oldDoughProfile.doughRingKey,
            email: oldDoughProfile.email,
            glazeNickname: cleanName.isEmpty ? oldDoughProfile.glazeNickname : cleanName,
            sugarHandle: cleanSugarHandle.isEmpty ? defaultSugarHandle(from: cleanName.isEmpty ? oldDoughProfile.glazeNickname : cleanName) : cleanSugarHandle,
            crumbBio: cleanCrumbBio.isEmpty ? oldDoughProfile.crumbBio : cleanCrumbBio,
            donutAvatarAsset: cleanDonutAvatar.isEmpty ? oldDoughProfile.donutAvatarAsset : cleanDonutAvatar,
            glazeFollowCount: oldDoughProfile.glazeFollowCount,
            sprinkleFanCount: oldDoughProfile.sprinkleFanCount,
            bakeryShelfCount: oldDoughProfile.bakeryShelfCount,
            glazeVaultCount: glazeGoldCount
        )
        frostingDefaults.set(packDoughRingProfile(doughPacket), forKey: wevvProfileKey)
    }

    func restGlazeTaster() {
        frostingDefaults.set(false, forKey: wevvSignedInKey)
        frostingDefaults.set(false, forKey: wevvLegacyReadyKey)
    }

    func clearSugarCrumbs() {
        frostingDefaults.removeObject(forKey: wevvCrumbNoteKey)
        frostingDefaults.removeObject(forKey: wevvDailyStampKey)
        frostingDefaults.removeObject(forKey: wevvSafetyCrumbKey)
    }

    func dissolveGlazeTasterPacket() {
        [
            wevvSignedInKey,
            wevvLegacyReadyKey,
            wevvCurrentEmailKey,
            wevvTokenKey,
            wevvProfileKey,
            wevvShopShelfKey,
            wevvCrumbNoteKey,
            wevvDailyStampKey,
            wevvGoldVaultKey,
            wevvJoinedQuestKey,
            wevvCreamMicGrantKey,
            wevvSafetyCrumbKey,
            wevvRoomSafetyCrumbKey,
            wevvGuestSafetyCrumbKey,
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
        let creamProfile = currentDoughRingTasterProfile
        let crumbPacket = makePastryPacket([
            shopKey,
            "\(rating)",
            "\(Date().timeIntervalSince1970)",
            cleanCrumbPacketPart(creamProfile.doughRingKey),
            cleanCrumbPacketPart(creamProfile.glazeNickname),
            cleanCrumbPacketPart(creamProfile.donutAvatarAsset),
            cleanCrumbPacketPart(cleanText)
        ])
        var crumbNotes = frostingDefaults.stringArray(forKey: wevvCrumbNoteKey) ?? []
        crumbNotes.append(crumbPacket)
        frostingDefaults.set(crumbNotes, forKey: wevvCrumbNoteKey)
    }

    func crumbNotePackets(for shopKey: String) -> [WevVCrumbNotePacket] {
        crumbNotePackets
            .filter { $0.shopKey == shopKey }
            .sorted { $0.timeInterval > $1.timeInterval }
    }

    func placeGlazeSafetyCrumb(_ packet: WevVGlazeSafetyPacket) {
        let cleanText = packet.creamText.trimmingCharacters(in: .whitespacesAndNewlines)
        let safePacket = makePastryPacket([
            packet.shopDonuWeYeKey,
            packet.choiceKey,
            packet.choiceTitle,
            cleanText,
            "\(packet.sugarMoment)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvSafetyCrumbKey)
    }

    func placeRoomSafetyCrumb(roomKey: String, hostKey: String, reasonText: String) {
        let creamProfile = currentDoughRingTasterProfile
        let safePacket = makePastryPacket([
            cleanCrumbPacketPart(roomKey),
            cleanCrumbPacketPart(hostKey),
            cleanCrumbPacketPart(creamProfile.doughRingKey),
            cleanCrumbPacketPart(reasonText),
            "\(Date().timeIntervalSince1970)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvRoomSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvRoomSafetyCrumbKey)
    }

    func placeGuestSafetyCrumb(guestKey: String, reasonText: String) {
        let creamProfile = currentDoughRingTasterProfile
        let safePacket = makePastryPacket([
            cleanCrumbPacketPart(guestKey),
            cleanCrumbPacketPart(creamProfile.doughRingKey),
            cleanCrumbPacketPart(reasonText),
            "\(Date().timeIntervalSince1970)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvGuestSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvGuestSafetyCrumbKey)
    }

    func placeSugarMoment(heroAsset: String, text: String) -> WevVSugarMomentPacket {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarKey = "sugarMoment\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSugarMomentPacket(sugarKey: sugarKey, heroAsset: heroAsset, text: cleanText, timeText: "Just now")
        let rawPacket = makePastryPacket([packet.sugarKey, packet.heroAsset, packet.timeText, packet.text])
        var packets = frostingDefaults.stringArray(forKey: wevvSugarMomentKey) ?? []
        packets.insert(rawPacket, at: 0)
        frostingDefaults.set(packets, forKey: wevvSugarMomentKey)
        return packet
    }

    func placeSprinkleQuest(title: String, text: String, timeText: String, placeText: String, sugarCost: Int, coverAsset: String) -> WevVSprinkleQuestPacket {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTime = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPlace = placeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCover = coverAsset.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarKey = "sprinkleQuest\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSprinkleQuestPacket(
            sugarKey: sugarKey,
            title: cleanTitle,
            text: cleanText,
            timeText: cleanTime,
            placeText: cleanPlace,
            sugarCost: sugarCost,
            coverAsset: cleanCover.isEmpty ? "wevv_challenge_strawberry_week" : cleanCover
        )
        let rawPacket = makePastryPacket([packet.sugarKey, packet.title, packet.text, packet.timeText, packet.placeText, "\(packet.sugarCost)", packet.coverAsset])
        var packets = (frostingDefaults.stringArray(forKey: wevvSprinkleQuestKey) ?? []).filter { rawQuest in
            let parts = pastryParts(from: rawQuest)
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
        updateGlazeGoldCount(glazeGoldCount + max(0, amount))
    }

    @discardableResult
    func spendGlazeGold(_ amount: Int) -> Bool {
        let safeAmount = max(0, amount)
        guard glazeGoldCount >= safeAmount else { return false }
        updateGlazeGoldCount(glazeGoldCount - safeAmount)
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

    private func updateGlazeGoldCount(_ count: Int) {
        let safeCount = max(0, count)
        frostingDefaults.set(safeCount, forKey: wevvGoldVaultKey)
        guard frostingDefaults.string(forKey: wevvProfileKey) != nil else { return }
        let doughProfile = currentDoughRingTasterProfile
        let doughPacket = WevVDoughRingTasterProfile(
            doughRingKey: doughProfile.doughRingKey,
            email: doughProfile.email,
            glazeNickname: doughProfile.glazeNickname,
            sugarHandle: doughProfile.sugarHandle,
            crumbBio: doughProfile.crumbBio,
            donutAvatarAsset: doughProfile.donutAvatarAsset,
            glazeFollowCount: doughProfile.glazeFollowCount,
            sprinkleFanCount: doughProfile.sprinkleFanCount,
            bakeryShelfCount: doughProfile.bakeryShelfCount,
            glazeVaultCount: safeCount
        )
        frostingDefaults.set(packDoughRingProfile(doughPacket), forKey: wevvProfileKey)
    }

    private func packDoughRingProfile(_ doughProfile: WevVDoughRingTasterProfile) -> String {
        makePastryPacket([
            cleanCrumbPacketPart(doughProfile.doughRingKey),
            cleanCrumbPacketPart(doughProfile.email),
            cleanCrumbPacketPart(doughProfile.glazeNickname),
            cleanCrumbPacketPart(doughProfile.sugarHandle),
            cleanCrumbPacketPart(doughProfile.crumbBio),
            cleanCrumbPacketPart(doughProfile.donutAvatarAsset),
            "\(doughProfile.glazeFollowCount)",
            "\(doughProfile.sprinkleFanCount)",
            "\(doughProfile.bakeryShelfCount)",
            "\(doughProfile.glazeVaultCount)"
        ])
    }

    private func unwrapDoughRingProfile(from rawDoughPacket: String) -> WevVDoughRingTasterProfile? {
        let parts = pastryParts(from: rawDoughPacket)
        guard parts.count == 8 || parts.count >= 10 else { return nil }
        if parts.count >= 10 {
            return WevVDoughRingTasterProfile(
                doughRingKey: parts[0],
                email: parts[1],
                glazeNickname: parts[2],
                sugarHandle: parts[3],
                crumbBio: parts[4],
                donutAvatarAsset: parts[5],
                glazeFollowCount: Int(parts[6]) ?? defaultDoughRingProfile.glazeFollowCount,
                sprinkleFanCount: Int(parts[7]) ?? defaultDoughRingProfile.sprinkleFanCount,
                bakeryShelfCount: Int(parts[8]) ?? defaultDoughRingProfile.bakeryShelfCount,
                glazeVaultCount: Int(parts[9]) ?? defaultDoughRingProfile.glazeVaultCount
            )
        }
        return WevVDoughRingTasterProfile(
            doughRingKey: parts[0],
            email: parts[1],
            glazeNickname: parts[2],
            sugarHandle: defaultSugarHandle(from: parts[2]),
            crumbBio: defaultDoughRingProfile.crumbBio,
            donutAvatarAsset: parts[3],
            glazeFollowCount: Int(parts[4]) ?? defaultDoughRingProfile.glazeFollowCount,
            sprinkleFanCount: Int(parts[5]) ?? defaultDoughRingProfile.sprinkleFanCount,
            bakeryShelfCount: Int(parts[6]) ?? defaultDoughRingProfile.bakeryShelfCount,
            glazeVaultCount: Int(parts[7]) ?? defaultDoughRingProfile.glazeVaultCount
        )
    }

    private func unwrapSugarMomentPacket(_ rawPacket: String) -> WevVSugarMomentPacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 4 else { return nil }
        let sugarText = parts.dropFirst(3).joined(separator: pastryPacketDivider)
        return WevVSugarMomentPacket(sugarKey: parts[0], heroAsset: parts[1], text: sugarText, timeText: parts[2])
    }

    private func unwrapSprinkleQuestPacket(_ rawPacket: String) -> WevVSprinkleQuestPacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 6, let cost = Int(parts[5]) else { return nil }
        return WevVSprinkleQuestPacket(
            sugarKey: parts[0],
            title: parts[1],
            text: parts[2],
            timeText: parts[3],
            placeText: parts[4],
            sugarCost: cost,
            coverAsset: parts.count >= 7 ? parts[6] : "wevv_challenge_strawberry_week"
        )
    }

    private func unwrapCrumbNotePacket(_ rawPacket: String) -> WevVCrumbNotePacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 4, let rating = Int(parts[1]), let sugarMoment = TimeInterval(parts[2]) else { return nil }
        if parts.count >= 7 {
            return WevVCrumbNotePacket(
                shopKey: parts[0],
                rating: rating,
                timeInterval: sugarMoment,
                text: parts.dropFirst(6).joined(separator: pastryPacketDivider),
                doughRingKey: parts[3],
                glazeNickname: parts[4],
                donutAvatarAsset: parts[5]
            )
        }
        let fallbackDoughProfile = currentDoughRingTasterProfile
        return WevVCrumbNotePacket(
            shopKey: parts[0],
            rating: rating,
            timeInterval: sugarMoment,
            text: parts.dropFirst(3).joined(separator: pastryPacketDivider),
            doughRingKey: fallbackDoughProfile.doughRingKey,
            glazeNickname: fallbackDoughProfile.glazeNickname,
            donutAvatarAsset: fallbackDoughProfile.donutAvatarAsset
        )
    }

    private func makeGlazeToken(email: String) -> String {
        let cleanedMail = email.replacingOccurrences(of: "@q".wevVPastryCrumbBloomRestored, with: "_^".wevVPastryCrumbBloomRestored).replacingOccurrences(of: ".!".wevVPastryCrumbBloomRestored, with: "_#".wevVPastryCrumbBloomRestored)
        return "wevv_token_\(cleanedMail)_\(Int(Date().timeIntervalSince1970))"
    }

    private func defaultSugarHandle(from glazeNickname: String) -> String {
        let letters = glazeNickname
            .lowercased()
            .filter { $0.isLetter || $0.isNumber }
        return letters.isEmpty ? "glazeTaster" : String(letters)
    }

    private func cleanCrumbPacketPart(_ value: String) -> String {
        value
            .replacingOccurrences(of: pastryPacketDivider, with: " w".wevVPastryCrumbBloomRestored)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func pastryParts(from packet: String) -> [String] {
        packet.components(separatedBy: pastryPacketDivider)
    }

    private func makePastryPacket(_ parts: [String]) -> String {
        parts.joined(separator: pastryPacketDivider)
    }
}
