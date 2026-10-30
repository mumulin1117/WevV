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
        sugarHandle: String = "".wevVPastryCrumbBloomRestored,
        crumbBio: String = "".wevVPastryCrumbBloomRestored,
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

    enum CredentialStoreError: LocalizedError {
        case environmentUnavailable
        case environmentMismatch
        case invalidCredentials
        case unreadablePacket

        var errorDescription: String? {
            switch self {
            case .environmentUnavailable: return "Tvhkew sc/o?nyn?eccRt:ijownx |iPs; !ncoot0 Sr=exaNdUy6.4 pP?l2ewaysuev EtTr#yl laMgJari@n!.|".wevVPastryCrumbBloomRestored
            case .environmentMismatch: return "Tfhse3 9aDc@cwopucnKtZ Hb!eElzo^n2goso 6tyo/ 1aLnFoEtVhGeTrO :c!opnWnNebcSt,iPo.n^.= $PHlXejadsBe# :sGi:gen@ 0ijnR ;a6gza*i@nD.a".wevVPastryCrumbBloomRestored
            case .invalidCredentials: return "YaoDuUrP =s/eQsisRiSo^n+ Xi~sD 4uqnvaOvDawi3lYaobilueM.h /PVlsedays$eS RspiggHno diRn: +aigIatiZn~.E".wevVPastryCrumbBloomRestored
            case .unreadablePacket: return "Y9o1u?rv @sgeysVsSi2oNnn 5cIoBu7lkd? ongoOtF |b3e* &sIa;vNe*d,.A qP=l7e*aEske~ htUr|yE 8a3gzajiqnP.F".wevVPastryCrumbBloomRestored
            }
        }
    }

    private(set) var activeEnvironmentID: String?
    private(set) var sessionEpoch = 0
    private let glazeSessionLock = NSRecursiveLock()

    private let pastryPacketDivider = "|g".wevVPastryCrumbBloomRestored
    private let wevvSignedInKey = "w:eEv=vB_&gnlyaozTeS_HsIimgwn%e:de_riznv".wevVPastryCrumbBloomRestored
    private let wevvShopShelfKey = "wee~vtv%_kgalmaEzreb_Zsbh.olpS_%s&hpeHlEfn".wevVPastryCrumbBloomRestored
    private let wevvCrumbNoteKey = "wbe;vCvq_kgflQaXz*eB_wcZrwu;mXby_EnhoBtge+s.".wevVPastryCrumbBloomRestored
    private let wevvDailyStampKey = "wte~vGv;_kg=laaCzie;_rdWaZiQl#ys_rs^tOaSmop!".wevVPastryCrumbBloomRestored

    private let wevvJoinedQuestKey = "wnesvyvq_VgOlPabzgeo_wjbooi!nWepd#_CqXuKe@sxt/sp".wevVPastryCrumbBloomRestored

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
        donutFrameAsset: "wQe!vEvN_gpBr^oQfSiKl*eo_ja:v6a0tca0r|_@pvi%a/ncou_6dVo~nxu;tb".wevVPastryCrumbBloomRestored,
        glazeTrailCount: 0,
        sprinkleTasterCount: 0,
        bakeryShelfTotal: 0,
        glazeVaultCount: 0
    )

    var isTasterReady: Bool {
        guard let credentials = currentGlazeCredentials else { return false }
        return hasRestorableGlazeCredentials(credentials)
    }

    var needsGlazeRenewal: Bool {
        guard let credentials = currentGlazeCredentials, isTasterReady else { return false }
        return credentials.citrusZestShell <= Date().addingTimeInterval(glazeFreshnessLeeway)
    }

    var currentTasterEmail: String {
        currentGlazeCredentials?.saltedCaramelFinish ?? "".wevVPastryCrumbBloomRestored
    }

    var currentDoughRingTasterProfile: WevVDoughRingTasterProfile {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        if let glazeServerProfile { return glazeServerProfile }
        guard let credentials = currentGlazeCredentials else { return defaultDoughRingProfile }
        let emailName = credentials.saltedCaramelFinish.split(separator: Character("@.".wevVPastryCrumbBloomRestored)).first.map(String.init) ?? "Wzeov2V|".wevVPastryCrumbBloomRestored
        return WevVDoughRingTasterProfile(
            ringCutterKey: String(credentials.vanillaBeanIcing),
            powderedAtlas: credentials.saltedCaramelFinish,
            glazeNickname: emailName,
            sugarHandle: "\("@z".wevVPastryCrumbBloomRestored)\(credentials.vanillaBeanIcing)",
            crumbBio: "".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "w;eVvcvD_ZpUrxoFfbi!lze^_TaCvLaat^airo_=puiia,n@o+_7dTo3nduitR".wevVPastryCrumbBloomRestored,
            glazeTrailCount: 0,
            sprinkleTasterCount: 0,
            bakeryShelfTotal: 0,
            glazeVaultCount: 0
        )
    }

    var currentGlazeCredentials: almondPralineGlaze? {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        guard let scope = activeEnvironmentID,
              let packet = glazeGalleryGuide.sweetKeepsakeEntry(scope: scope),
              let data = packet.data(using: .utf8),
              let credentials = try? JSONDecoder().decode(almondPralineGlaze.self, from: data),
              credentials.cinnamonSugarFinish == scope else { return nil }
        return credentials
    }

    func selectGlazeEnvironment(_ scope: String) {
        let cleanScope = scope.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanScope.isEmpty else { return }
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        guard activeEnvironmentID != cleanScope else { return }
        activeEnvironmentID = cleanScope
        glazeServerProfile = nil
        sessionEpoch &+= 1
        _ = prepareGlazeJournal()
        notifyGlazeProfileChanged()
    }

    @discardableResult
    func prepareGlazeJournal() -> Bool {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        guard let scope = activeEnvironmentID,
              let packet = glazeGalleryGuide.sweetKeepsakeEntry(scope: scope), !packet.isEmpty else {
            glazeServerProfile = nil
            updateGlazeCompatibilityState(nil)
            return false
        }
        guard let credentials = currentGlazeCredentials,
              hasRestorableGlazeCredentials(credentials) else {
            restGlazeTaster()
            return false
        }
        updateGlazeCompatibilityState(credentials)
        return true
    }

    var glazeShelfCount: Int {
        glazeShelfKeys.count
    }

    var glazeShelfPacketKeys: [String] {
        Array(glazeShelfKeys).sorted()
    }

    var crumbNotePackets: [WevVCrumbNotePacket] {
        (frostingDefaults.stringArray(forKey: wevvCrumbNoteKey) ?? []).compactMap { rawPacket in
            unwrapCrumbNotePacket(rawPacket)
        }
    }

    func restGlazeTaster() {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        glazeServerProfile = nil
        if let scope = activeEnvironmentID {
            glazeGalleryGuide.cocoaRaspberryMedley(scope: scope)
        }
        glazeGalleryGuide.cocoaRaspberryMedley()
        sessionEpoch &+= 1
        updateGlazeCompatibilityState(nil)
        notifyGlazeProfileChanged()
    }

    func persistGlazeCredentials(_ credentials: almondPralineGlaze, startingNewSession: Bool = false) throws {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        guard let scope = activeEnvironmentID else { throw CredentialStoreError.environmentUnavailable }
        guard credentials.cinnamonSugarFinish == scope else { throw CredentialStoreError.environmentMismatch }
        guard hasRestorableGlazeCredentials(credentials) else { throw CredentialStoreError.invalidCredentials }
        let data = try JSONEncoder().encode(credentials)
        guard let packet = String(data: data, encoding: .utf8) else { throw CredentialStoreError.unreadablePacket }
        let previousAccount = currentGlazeCredentials?.vanillaBeanIcing
        try glazeGalleryGuide.pastryDiaryCollection(packet, scope: scope)
        guard glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == packet else {
            throw CredentialStoreError.unreadablePacket
        }
        if startingNewSession || previousAccount != credentials.vanillaBeanIcing {
            glazeServerProfile = nil
            sessionEpoch &+= 1
        }
        updateGlazeCompatibilityState(credentials)
        notifyGlazeProfileChanged()
    }

    func storeDoughRingTasterProfile(_ profile: WevVDoughRingTasterProfile) {
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        guard let credentials = currentGlazeCredentials,
              profile.ringCutterKey == String(credentials.vanillaBeanIcing) else { return }
        glazeServerProfile = profile
        notifyGlazeProfileChanged()
    }

    private func hasRestorableGlazeCredentials(_ credentials: almondPralineGlaze) -> Bool {
        credentials.vanillaBeanIcing > 0
            && !credentials.brownButterGlaze.isEmpty
            && !credentials.maplePecanCoating.isEmpty
            && credentials.darkCocoaDrizzle > Date().addingTimeInterval(glazeFreshnessLeeway)
    }

    private func updateGlazeCompatibilityState(_ credentials: almondPralineGlaze?) {
        if let credentials {
            frostingDefaults.set(true, forKey: wevvSignedInKey)
            frostingDefaults.set(true, forKey: wevvLegacyReadyKey)
            frostingDefaults.set(credentials.saltedCaramelFinish, forKey: wevvCurrentEmailKey)
        } else {
            [wevvSignedInKey, wevvLegacyReadyKey, wevvCurrentEmailKey, wevvTokenKey, wevvProfileKey]
                .forEach { frostingDefaults.removeObject(forKey: $0) }
        }
    }

    private func notifyGlazeProfileChanged() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .bakeryTrailMap, object: nil)
        }
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

    func placeSprinkleQuest(title: String, text: String, timeText: String, placeText: String, sprinkleDensityValue: Int, coverAsset: String) -> WevVSprinkleQuestPacket {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTime = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPlace = placeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCover = coverAsset.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugarDustKey = "\("sap|rhionRkyl&e*Qiu5etssti".wevVPastryCrumbBloomRestored)\(Int(Date().timeIntervalSince1970))"
        let packet = WevVSprinkleQuestPacket(
            sugarDustKey: sugarDustKey,
            citrusCounter: cleanTitle,
            almondDuster: cleanText,
            citrusParlor: cleanTime,
            placeText: cleanPlace,
            sprinkleDensityValue: sprinkleDensityValue,
            coverAsset: cleanCover.isEmpty ? "w0eLvQvK_Vc=h2aPl8lmevnHgDef_LsptArqabwcbWeurUr1yO_:wle*eIkl".wevVPastryCrumbBloomRestored : cleanCover
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
        dailyGlazeStampKeys.contains { $0.hasPrefix("\(dayKey)\("|%".wevVPastryCrumbBloomRestored)") }
    }

    @discardableResult
    func placeDailyGlazeStamp(dayKey: String, mood: String) -> Bool {
        var stampKeys = dailyGlazeStampKeys
        let inserted = stampKeys.insert("\(dayKey)\("|m".wevVPastryCrumbBloomRestored)\(mood)")
        guard inserted.inserted else { return false }
        frostingDefaults.set(Array(stampKeys).sorted(), forKey: wevvDailyStampKey)
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
