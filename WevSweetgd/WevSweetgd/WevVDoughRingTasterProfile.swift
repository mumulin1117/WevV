import Foundation

struct WevVDoughRingTasterProfile {
    let ringCutterKey: String
    let email: String
    let glazeNickname: String
    let sugarHandle: String
    let crumbBio: String
    let donutFrameAsset: String
    let glazeTrailCount: Int
    let sprinkleTasterCount: Int
    let bakeryShelfTotal: Int
    let glazeVaultCount: Int

    init(
        ringCutterKey: String,
        powderedAtlas: String,
        glazeNickname: String,
        sugarHandle: String = "",
        crumbBio: String = "",
        donutFrameAsset: String,
        glazeTrailCount: Int,
        sprinkleTasterCount: Int,
        bakeryShelfTotal: Int,
        glazeVaultCount: Int
    ) {
        self.ringCutterKey = ringCutterKey
        self.email = powderedAtlas
        self.glazeNickname = glazeNickname
        self.sugarHandle = sugarHandle
        self.crumbBio = crumbBio
        self.donutFrameAsset = donutFrameAsset
        self.glazeTrailCount = glazeTrailCount
        self.sprinkleTasterCount = sprinkleTasterCount
        self.bakeryShelfTotal = bakeryShelfTotal
        self.glazeVaultCount = glazeVaultCount
    }
}

struct WevVSugarMomentPacket {
    let sugarDustKey: String
    let donutBackdropAsset: String
    let lemonCutter: String
    let citrusParlor: String
}

struct WevVSprinkleQuestPacket {
    let sugarDustKey: String
    let citrusCounter: String
    let almondDuster: String
    let citrusParlor: String
    let placeText: String
    let sprinkleDensityValue: Int
    let coverAsset: String
}

struct WevVCrumbNotePacket {
    let bakeryPinKey: String
    let powderedSampler: Int
    let timeInterval: TimeInterval
    let powderedFinder: String
    let ringCutterKey: String
    let glazeNickname: String
    let donutFrameAsset: String
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
    private let glazeFreshnessLeeway: TimeInterval = 30
    private var glazeServerProfile: WevVDoughRingTasterProfile?

    private let defaultDoughRingProfile = WevVDoughRingTasterProfile(
        ringCutterKey: "wVevvmvcS%usgMasrgTqa@sUtleWrK".wevVPastryCrumbBloomRestored,
        powderedAtlas: "w.ecv%vn@ZgTm;aSi#lP.Gc@o.mJ".wevVPastryCrumbBloomRestored,
        glazeNickname: "GFlDadzVef vTdajs;tHeTrv".wevVPastryCrumbBloomRestored,
        sugarHandle: "g;l.arzSeIT+a?s*txewrA".wevVPastryCrumbBloomRestored,
        crumbBio: "DooNn&uStq GtWafsEtCi;nJglse,^ obvehrhrhyN MgFlWaIz#e+ En;oTtAehsG,p RawnCd@ gcWo%zsyb KslhcoZpj xf!iynyd*st.G".wevVPastryCrumbBloomRestored,
        donutFrameAsset: "wevv_profile_avatar_piano_donut",
        glazeTrailCount: 0,
        sprinkleTasterCount: 0,
        bakeryShelfTotal: 0,
        glazeVaultCount: 0
    )

    var isTasterReady: Bool {
        guard let credentials = currentGlazeCredentials else { return false }
        return !credentials.brownButterGlaze.isEmpty
            && !credentials.maplePecanCoating.isEmpty
            && credentials.darkCocoaDrizzle > Date().addingTimeInterval(glazeFreshnessLeeway)
    }

    var needsGlazeRenewal: Bool {
        guard let credentials = currentGlazeCredentials, isTasterReady else { return false }
        return credentials.citrusZestShell <= Date().addingTimeInterval(glazeFreshnessLeeway)
    }

    var currentTasterEmail: String {
        currentGlazeCredentials?.saltedCaramelFinish ?? ""
    }

    var currentGlazeToken: String {
        currentGlazeCredentials?.brownButterGlaze ?? ""
    }

    var currentDoughRingTasterProfile: WevVDoughRingTasterProfile {
        if let glazeServerProfile { return glazeServerProfile }
        guard let credentials = currentGlazeCredentials else { return defaultDoughRingProfile }
        let emailName = credentials.saltedCaramelFinish.split(separator: "@").first.map(String.init) ?? "WevV"
        return WevVDoughRingTasterProfile(
            ringCutterKey: String(credentials.vanillaBeanIcing),
            powderedAtlas: credentials.saltedCaramelFinish,
            glazeNickname: emailName,
            sugarHandle: "@\(credentials.vanillaBeanIcing)",
            crumbBio: "",
            donutFrameAsset: "wevv_profile_avatar_piano_donut",
            glazeTrailCount: 0,
            sprinkleTasterCount: 0,
            bakeryShelfTotal: 0,
            glazeVaultCount: 0
        )
    }

    var currentGlazeCredentials: almondPralineGlaze? {
        guard let packet = glazeGalleryGuide.sweetKeepsakeEntry(),
              let data = packet.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(almondPralineGlaze.self, from: data)
    }

    @discardableResult
    func prepareGlazeJournal() -> Bool {
        guard let packet = glazeGalleryGuide.sweetKeepsakeEntry(), !packet.isEmpty else { return false }
        guard let credentials = currentGlazeCredentials,
              !credentials.brownButterGlaze.isEmpty,
              !credentials.maplePecanCoating.isEmpty,
              credentials.darkCocoaDrizzle > Date().addingTimeInterval(glazeFreshnessLeeway) else {
            restGlazeTaster()
            return false
        }
        return true
    }

    var glazeShelfCount: Int {
        glazeShelfKeys.count
    }

    var glazeShelfPacketKeys: [String] {
        Array(glazeShelfKeys).sorted()
    }

    var glazeGoldCount: Int {
        currentDoughRingTasterProfile.glazeVaultCount
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

    func markDoughRingTasterReady(profile doughProfile: WevVDoughRingTasterProfile, startsFresh: Bool = false) {
        glazeServerProfile = doughProfile
    }

    func refreshDoughRingTasterProfile(glazeNickname: String, sugarHandle: String, crumbBio: String, donutFrameAsset: String) {
        let oldDoughProfile = currentDoughRingTasterProfile
        let cleanName = glazeNickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanSugarHandle = sugarHandle.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCrumbBio = crumbBio.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDonutAvatar = donutFrameAsset.trimmingCharacters(in: .whitespacesAndNewlines)
        let doughPacket = WevVDoughRingTasterProfile(
            ringCutterKey: oldDoughProfile.ringCutterKey,
            powderedAtlas: oldDoughProfile.email,
            glazeNickname: cleanName.isEmpty ? oldDoughProfile.glazeNickname : cleanName,
            sugarHandle: cleanSugarHandle.isEmpty ? defaultSugarHandle(from: cleanName.isEmpty ? oldDoughProfile.glazeNickname : cleanName) : cleanSugarHandle,
            crumbBio: cleanCrumbBio.isEmpty ? oldDoughProfile.crumbBio : cleanCrumbBio,
            donutFrameAsset: cleanDonutAvatar.isEmpty ? oldDoughProfile.donutFrameAsset : cleanDonutAvatar,
            glazeTrailCount: oldDoughProfile.glazeTrailCount,
            sprinkleTasterCount: oldDoughProfile.sprinkleTasterCount,
            bakeryShelfTotal: oldDoughProfile.bakeryShelfTotal,
            glazeVaultCount: glazeGoldCount
        )
        glazeServerProfile = doughPacket
    }

    func restGlazeTaster() {
        glazeServerProfile = nil
        glazeGalleryGuide.cocoaRaspberryMedley()
        [wevvSignedInKey, wevvLegacyReadyKey, wevvCurrentEmailKey, wevvTokenKey, wevvProfileKey]
            .forEach { frostingDefaults.removeObject(forKey: $0) }
        notifyGlazeProfileChanged()
    }

    func clearSugarCrumbs() {
        frostingDefaults.removeObject(forKey: wevvCrumbNoteKey)
        frostingDefaults.removeObject(forKey: wevvDailyStampKey)
        frostingDefaults.removeObject(forKey: wevvSafetyCrumbKey)
    }

    func dissolveGlazeTasterPacket() {
        glazeServerProfile = nil
        glazeGalleryGuide.cocoaRaspberryMedley()
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
        notifyGlazeProfileChanged()
    }

    func storeGlazeCredentials(_ credentials: almondPralineGlaze) {
        guard let data = try? JSONEncoder().encode(credentials),
              let packet = String(data: data, encoding: .utf8) else { return }
        glazeGalleryGuide.pastryDiaryCollection(packet)
    }

    func storeDoughRingTasterProfile(_ profile: WevVDoughRingTasterProfile) {
        glazeServerProfile = profile
        notifyGlazeProfileChanged()
    }

    private func notifyGlazeProfileChanged() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .bakeryTrailMap, object: nil)
        }
    }

    func markCreamMicGrant() {
        frostingDefaults.set(true, forKey: wevvCreamMicGrantKey)
    }

    func isGlazeShelfed(bakeryPinKey: String) -> Bool {
        glazeShelfKeys.contains(bakeryPinKey)
    }

    @discardableResult
    func placeGlazeShelf(bakeryPinKey: String) -> Bool {
        var shelfKeys = glazeShelfKeys
        let inserted = shelfKeys.insert(bakeryPinKey).inserted
        guard inserted else { return false }
        frostingDefaults.set(Array(shelfKeys).sorted(), forKey: wevvShopShelfKey)
        return true
    }

    func placeCrumbNote(bakeryPinKey: String, rating: Int, text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let creamProfile = currentDoughRingTasterProfile
        let crumbPacket = makePastryPacket([
            bakeryPinKey,
            "\(rating)",
            "\(Date().timeIntervalSince1970)",
            cleanCrumbPacketPart(creamProfile.ringCutterKey),
            cleanCrumbPacketPart(creamProfile.glazeNickname),
            cleanCrumbPacketPart(creamProfile.donutFrameAsset),
            cleanCrumbPacketPart(cleanText)
        ])
        var crumbNotes = frostingDefaults.stringArray(forKey: wevvCrumbNoteKey) ?? []
        crumbNotes.append(crumbPacket)
        frostingDefaults.set(crumbNotes, forKey: wevvCrumbNoteKey)
    }

    func crumbNotePackets(for bakeryPinKey: String) -> [WevVCrumbNotePacket] {
        crumbNotePackets
            .filter { $0.bakeryPinKey == bakeryPinKey }
            .sorted { $0.timeInterval > $1.timeInterval }
    }

    func placeGlazeSafetyCrumb(_ packet: tastingPassportEdition) {
        let cleanText = packet.tastingTrayNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        let safePacket = makePastryPacket([
            packet.glazeNotebookEdition,
            packet.rainbowSprinkleDesign,
            packet.flavorMenuGuide,
            cleanText,
            "\(packet.glazeSheenIndex)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvSafetyCrumbKey)
    }

    func placeRoomSafetyCrumb(donutPinKey: String, hostKey: String, reasonText: String) {
        let creamProfile = currentDoughRingTasterProfile
        let safePacket = makePastryPacket([
            cleanCrumbPacketPart(donutPinKey),
            cleanCrumbPacketPart(hostKey),
            cleanCrumbPacketPart(creamProfile.ringCutterKey),
            cleanCrumbPacketPart(reasonText),
            "\(Date().timeIntervalSince1970)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvRoomSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvRoomSafetyCrumbKey)
    }

    func placeGuestSafetyCrumb(tasterBadgeKey: String, reasonText: String) {
        let creamProfile = currentDoughRingTasterProfile
        let safePacket = makePastryPacket([
            cleanCrumbPacketPart(tasterBadgeKey),
            cleanCrumbPacketPart(creamProfile.ringCutterKey),
            cleanCrumbPacketPart(reasonText),
            "\(Date().timeIntervalSince1970)"
        ])
        var safetyCrumbs = frostingDefaults.stringArray(forKey: wevvGuestSafetyCrumbKey) ?? []
        safetyCrumbs.append(safePacket)
        frostingDefaults.set(safetyCrumbs, forKey: wevvGuestSafetyCrumbKey)
    }

    func placeSugarMoment(donutBackdropAsset: String, text: String) -> WevVSugarMomentPacket {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarDustKey = "sugarMoment\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSugarMomentPacket(sugarDustKey: sugarDustKey, donutBackdropAsset: donutBackdropAsset, lemonCutter: cleanText, citrusParlor: "Just now")
        let rawPacket = makePastryPacket([packet.sugarDustKey, packet.donutBackdropAsset, packet.citrusParlor, packet.lemonCutter])
        var packets = frostingDefaults.stringArray(forKey: wevvSugarMomentKey) ?? []
        packets.insert(rawPacket, at: 0)
        frostingDefaults.set(packets, forKey: wevvSugarMomentKey)
        return packet
    }

    func placeSprinkleQuest(title: String, text: String, timeText: String, placeText: String, sprinkleDensityValue: Int, coverAsset: String) -> WevVSprinkleQuestPacket {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTime = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPlace = placeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCover = coverAsset.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarDustKey = "sprinkleQuest\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSprinkleQuestPacket(
            sugarDustKey: sugarDustKey,
            citrusCounter: cleanTitle,
            almondDuster: cleanText,
            citrusParlor: cleanTime,
            placeText: cleanPlace,
            sprinkleDensityValue: sprinkleDensityValue,
            coverAsset: cleanCover.isEmpty ? "wevv_challenge_strawberry_week" : cleanCover
        )
        let rawPacket = makePastryPacket([packet.sugarDustKey, packet.citrusCounter, packet.almondDuster, packet.citrusParlor, packet.placeText, "\(packet.sprinkleDensityValue)", packet.coverAsset])
        var packets = (frostingDefaults.stringArray(forKey: wevvSprinkleQuestKey) ?? []).filter { rawQuest in
            let parts = pastryParts(from: rawQuest)
            guard parts.count >= 6 else { return true }
            let sameTitle = parts[1].caseInsensitiveCompare(packet.citrusCounter) == .orderedSame
            let sameTime = parts[3].caseInsensitiveCompare(packet.citrusParlor) == .orderedSame
            let samePlace = parts[4].caseInsensitiveCompare(packet.placeText) == .orderedSame
            let sameCost = parts[5] == "\(packet.sprinkleDensityValue)"
            return !(sameTitle && sameTime && samePlace && sameCost)
        }
        packets.insert(rawPacket, at: 0)
        frostingDefaults.set(packets, forKey: wevvSprinkleQuestKey)
        return packet
    }

    func hasDailyDonutStamp(dayKey: String) -> Bool {
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
    func flourBlendDetail(_ amount: Int) -> Bool {
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
        let doughProfile = currentDoughRingTasterProfile
        let doughPacket = WevVDoughRingTasterProfile(
            ringCutterKey: doughProfile.ringCutterKey,
            powderedAtlas: doughProfile.email,
            glazeNickname: doughProfile.glazeNickname,
            sugarHandle: doughProfile.sugarHandle,
            crumbBio: doughProfile.crumbBio,
            donutFrameAsset: doughProfile.donutFrameAsset,
            glazeTrailCount: doughProfile.glazeTrailCount,
            sprinkleTasterCount: doughProfile.sprinkleTasterCount,
            bakeryShelfTotal: doughProfile.bakeryShelfTotal,
            glazeVaultCount: safeCount
        )
        glazeServerProfile = doughPacket
    }

    private func packDoughRingProfile(_ doughProfile: WevVDoughRingTasterProfile) -> String {
        makePastryPacket([
            cleanCrumbPacketPart(doughProfile.ringCutterKey),
            cleanCrumbPacketPart(doughProfile.email),
            cleanCrumbPacketPart(doughProfile.glazeNickname),
            cleanCrumbPacketPart(doughProfile.sugarHandle),
            cleanCrumbPacketPart(doughProfile.crumbBio),
            cleanCrumbPacketPart(doughProfile.donutFrameAsset),
            "\(doughProfile.glazeTrailCount)",
            "\(doughProfile.sprinkleTasterCount)",
            "\(doughProfile.bakeryShelfTotal)",
            "\(doughProfile.glazeVaultCount)"
        ])
    }

    private func unwrapDoughRingProfile(from rawDoughPacket: String) -> WevVDoughRingTasterProfile? {
        let parts = pastryParts(from: rawDoughPacket)
        guard parts.count == 8 || parts.count >= 10 else { return nil }
        if parts.count >= 10 {
            return WevVDoughRingTasterProfile(
                ringCutterKey: parts[0],
                powderedAtlas: parts[1],
                glazeNickname: parts[2],
                sugarHandle: parts[3],
                crumbBio: parts[4],
                donutFrameAsset: parts[5],
                glazeTrailCount: Int(parts[6]) ?? defaultDoughRingProfile.glazeTrailCount,
                sprinkleTasterCount: Int(parts[7]) ?? defaultDoughRingProfile.sprinkleTasterCount,
                bakeryShelfTotal: Int(parts[8]) ?? defaultDoughRingProfile.bakeryShelfTotal,
                glazeVaultCount: Int(parts[9]) ?? defaultDoughRingProfile.glazeVaultCount
            )
        }
        return WevVDoughRingTasterProfile(
            ringCutterKey: parts[0],
            powderedAtlas: parts[1],
            glazeNickname: parts[2],
            sugarHandle: defaultSugarHandle(from: parts[2]),
            crumbBio: defaultDoughRingProfile.crumbBio,
            donutFrameAsset: parts[3],
            glazeTrailCount: Int(parts[4]) ?? defaultDoughRingProfile.glazeTrailCount,
            sprinkleTasterCount: Int(parts[5]) ?? defaultDoughRingProfile.sprinkleTasterCount,
            bakeryShelfTotal: Int(parts[6]) ?? defaultDoughRingProfile.bakeryShelfTotal,
            glazeVaultCount: Int(parts[7]) ?? defaultDoughRingProfile.glazeVaultCount
        )
    }

    private func unwrapSugarMomentPacket(_ rawPacket: String) -> WevVSugarMomentPacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 4 else { return nil }
        let sugarText = parts.dropFirst(3).joined(separator: pastryPacketDivider)
        return WevVSugarMomentPacket(sugarDustKey: parts[0], donutBackdropAsset: parts[1], lemonCutter: sugarText, citrusParlor: parts[2])
    }

    private func unwrapSprinkleQuestPacket(_ rawPacket: String) -> WevVSprinkleQuestPacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 6, let cost = Int(parts[5]) else { return nil }
        return WevVSprinkleQuestPacket(
            sugarDustKey: parts[0],
            citrusCounter: parts[1],
            almondDuster: parts[2],
            citrusParlor: parts[3],
            placeText: parts[4],
            sprinkleDensityValue: cost,
            coverAsset: parts.count >= 7 ? parts[6] : "wevv_challenge_strawberry_week"
        )
    }

    private func unwrapCrumbNotePacket(_ rawPacket: String) -> WevVCrumbNotePacket? {
        let parts = pastryParts(from: rawPacket)
        guard parts.count >= 4, let rating = Int(parts[1]), let sugarMoment = TimeInterval(parts[2]) else { return nil }
        if parts.count >= 7 {
            return WevVCrumbNotePacket(
                bakeryPinKey: parts[0],
                powderedSampler: rating,
                timeInterval: sugarMoment,
                powderedFinder: parts.dropFirst(6).joined(separator: pastryPacketDivider),
                ringCutterKey: parts[3],
                glazeNickname: parts[4],
                donutFrameAsset: parts[5]
            )
        }
        let fallbackDoughProfile = currentDoughRingTasterProfile
        return WevVCrumbNotePacket(
            bakeryPinKey: parts[0],
            powderedSampler: rating,
            timeInterval: sugarMoment,
            powderedFinder: parts.dropFirst(3).joined(separator: pastryPacketDivider),
            ringCutterKey: fallbackDoughProfile.ringCutterKey,
            glazeNickname: fallbackDoughProfile.glazeNickname,
            donutFrameAsset: fallbackDoughProfile.donutFrameAsset
        )
    }

    private func makeGlazeToken(email: String) -> String {
        let cleanedMail = email.replacingOccurrences(of: "@q".wevVPastryCrumbBloomRestored, with: "_^".wevVPastryCrumbBloomRestored).replacingOccurrences(of: ".!".wevVPastryCrumbBloomRestored, with: "_#".wevVPastryCrumbBloomRestored)
        return "wevv_token_\(cleanedMail)_\(Int(Date().timeIntervalSince1970))"
    }

    private func glazeGoldVaultKey(for email: String) -> String {
        let glazeScope = Data(email.lowercased().utf8).base64EncodedString()
        return "\(wevvGoldVaultKey).\(glazeScope)"
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
