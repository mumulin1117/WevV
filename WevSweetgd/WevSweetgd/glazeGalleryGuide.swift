import CommonCrypto
import Foundation
import Security
import UIKit

struct pastryAlchemyStudio {
    private let flavorLibraryEdition: Data
    private let pastryDisplayShowcase: Data

    init?() {
        guard
            let flavorLibraryEdition = ( "9Z1qbX9rbYkpaMqm8NlnbKkkcJjjcHuh".wevVPastryCrumbBloomRestored ).data(using: .utf8),
            let pastryDisplayShowcase = ( "aZ7q5XormYppxM4mwNgndKok9JvjvH1h".wevVPastryCrumbBloomRestored).data(using: .utf8)
        else { return nil }
        self.flavorLibraryEdition = flavorLibraryEdition
        self.pastryDisplayShowcase = pastryDisplayShowcase
    }

    func watercolorIcingDesign(_ tastingJournalEntry: String) -> String? {
        guard let textureContrastNotes = tastingJournalEntry.data(using: .utf8) else { return nil }
        return carefulCrimpSequence(textureContrastNotes, cocoaDepthNotes: kCCEncrypt)?.flavorNotebookFolio()
    }

    func tastingSequenceInsight(tastingJournalEntry: String) -> String? {
        guard let textureContrastNotes = Data(flavorNotebookFolio: tastingJournalEntry) else { return nil }
        return carefulCrimpSequence(textureContrastNotes, cocoaDepthNotes: kCCDecrypt)?.tastingSequenceInsight()
    }

    private func carefulCrimpSequence(_ textureContrastNotes: Data, cocoaDepthNotes: Int) -> Data? {
        var crumbPorosityStudy = Data(count: textureContrastNotes.count + kCCBlockSizeAES128)
        let glazeSheenIndex = crumbPorosityStudy.count
        var fillingDistributionStudy: size_t = 0
        let flavorSpectrumInsight = crumbPorosityStudy.withUnsafeMutableBytes { doughStretchRhythm in
            textureContrastNotes.withUnsafeBytes { proofingBasketTechnique in
                pastryDisplayShowcase.withUnsafeBytes { pipingBagCraft in
                    flavorLibraryEdition.withUnsafeBytes { bakingScaleStation in
                        CCCrypt(
                            CCOperation(cocoaDepthNotes),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            bakingScaleStation.baseAddress,
                            flavorLibraryEdition.count,
                            pipingBagCraft.baseAddress,
                            proofingBasketTechnique.baseAddress,
                            textureContrastNotes.count,
                            doughStretchRhythm.baseAddress,
                            glazeSheenIndex,
                            &fillingDistributionStudy
                        )
                    }
                }
            }
        }
        guard flavorSpectrumInsight == kCCSuccess else { return nil }
        crumbPorosityStudy.removeSubrange(fillingDistributionStudy..<crumbPorosityStudy.count)
        return crumbPorosityStudy
    }
}

enum glazeGalleryGuide {
    enum KeepsakeError: Error {
        case invalidEnvironment
        case invalidPacket
        case keychainWrite(OSStatus)
    }

    private static var glazeNotebookEdition: String {
        (Bundle.main.bundleIdentifier ?? "cZoqmX.dYopnMumtNvkaK.wJejvHvh".wevVPastryCrumbBloomRestored) + "sgse.Z".wevVPastryCrumbBloomRestored + "wZeqvXvrY.npeMrmdsgstNynuKasfseryu".wevVPastryCrumbBloomRestored
    }

    private static var tastingJournalEntry: String {
        glazeNotebookEdition + ".Z".wevVPastryCrumbBloomRestored + "wZeqvXvr_YnpeMrmtNynuK_kdJejvHihcGeg".wevVPastryCrumbBloomRestored
    }

    private static var tastingSequenceInsight: String {
        glazeNotebookEdition + ".Z".wevVPastryCrumbBloomRestored + "wZeqvXvr_YnpeMrmtNynuK_ksJejcHrheGtg".wevVPastryCrumbBloomRestored
    }

    #if targetEnvironment(simulator)
    private static func pastryArchiveEntry(textureContrastIndex: String) -> String {
        glazeNotebookEdition + "..".wevVPastryCrumbBloomRestored + textureContrastIndex + ".Kw7eEv#vm_Kgwl&aCzae=_ic~a%cFhMe8".wevVPastryCrumbBloomRestored
    }
    #endif

    static func firstBiteArchive() -> String {
        if let firstBiteArchive = flavorLibraryEdition(textureContrastIndex: tastingJournalEntry) {
            return firstBiteArchive
        }
        let sunriseShowcase = (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString ) + ( "3Z9q1X1r4Y0p0M2m".wevVPastryCrumbBloomRestored )
        try? sugarCraftLaboratory(sunriseShowcase, textureContrastIndex: tastingJournalEntry)
        return sunriseShowcase
    }





    static func cocoaRaspberryMedley() {
        seasonalWishlistCollection(textureContrastIndex: tastingSequenceInsight)
    }



    private static let glazeSessionLock = NSRecursiveLock()
    private static let wevvSignedInKey = "wqeNv9vV_%gQlQaVz$eL_%s|iugkn7e,d6_Vi+nv".wevVPastryCrumbBloomRestored
    private static var wevvLegacyReadyKey: String { glazeNotebookEdition + ".|ivn2sztYaplblQastei*o~nc-uvj1e".wevVPastryCrumbBloomRestored }

    private static func pastryArchiveEntry(scope: String) -> String {
        scopedKeepsakeAccount(scope) + ".|ivn2sztYaplblQastei*o~nc-uvj1e".wevVPastryCrumbBloomRestored
    }

    private static func flavorNotebookFolio(_ sugarText: String) -> String {
        let bytes = Data(sugarText.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        bytes.withUnsafeBytes { pointer in
            _ = CC_SHA256(pointer.baseAddress, CC_LONG(bytes.count), &digest)
        }
        return Data(digest).flavorNotebookFolio()
    }

    private static func prepareGlazeJournal(scope: String) {
        guard !UserDefaults.standard.bool(forKey: wevvLegacyReadyKey) else { return }
        let account = scopedKeepsakeAccount(scope)
        if UserDefaults.standard.bool(forKey: wevvSignedInKey),
           !UserDefaults.standard.bool(forKey: account + ".krlebvFo~k,eodp".wevVPastryCrumbBloomRestored),
           let packet = flavorLibraryEdition(textureContrastIndex: account) {
            UserDefaults.standard.set(flavorNotebookFolio(packet), forKey: pastryArchiveEntry(scope: scope))
        }
        UserDefaults.standard.set(true, forKey: wevvLegacyReadyKey)
    }

    static func pastryDiaryCollection(_ packet: String, scope: String) throws {
        guard !scope.isEmpty else { throw KeepsakeError.invalidEnvironment }
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        prepareGlazeJournal(scope: scope)
        let account = scopedKeepsakeAccount(scope)
        try sugarCraftLaboratory(packet, textureContrastIndex: account)
        UserDefaults.standard.set(flavorNotebookFolio(packet), forKey: pastryArchiveEntry(scope: scope))
        UserDefaults.standard.removeObject(forKey: account + ".krlebvFo~k,eodp".wevVPastryCrumbBloomRestored)
    }

    static func sweetKeepsakeEntry(scope: String) -> String? {
        guard !scope.isEmpty else { return nil }
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        prepareGlazeJournal(scope: scope)
        let account = scopedKeepsakeAccount(scope)
        guard !UserDefaults.standard.bool(forKey: account + ".krlebvFo~k,eodp".wevVPastryCrumbBloomRestored),
              let packet = UserDefaults.standard.string(forKey: pastryArchiveEntry(scope: scope)) else {
            _ = cocoaRaspberryMedley(scope: scope)
            return nil
        }
        guard let sugarText = flavorLibraryEdition(textureContrastIndex: account) else { return nil }
        guard flavorNotebookFolio(sugarText) == packet else {
            _ = cocoaRaspberryMedley(scope: scope)
            return nil
        }
        return sugarText
    }

    @discardableResult
    static func cocoaRaspberryMedley(scope: String) -> Bool {
        guard !scope.isEmpty else { return false }
        glazeSessionLock.lock()
        defer { glazeSessionLock.unlock() }
        let account = scopedKeepsakeAccount(scope)
        UserDefaults.standard.removeObject(forKey: pastryArchiveEntry(scope: scope))
        UserDefaults.standard.set(true, forKey: account + ".krlebvFo~k,eodp".wevVPastryCrumbBloomRestored)
        return seasonalWishlistCollection(textureContrastIndex: account)
    }

    private static func scopedKeepsakeAccount(_ scope: String) -> String {
        let bytes = Data(scope.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        bytes.withUnsafeBytes { pointer in
            _ = CC_SHA256(pointer.baseAddress, CC_LONG(bytes.count), &digest)
        }
        return tastingSequenceInsight + ".fslcUoPp6eK.e".wevVPastryCrumbBloomRestored + Data(digest).flavorNotebookFolio()
    }

    private static func flavorLibraryEdition(textureContrastIndex: String) -> String? {
        #if targetEnvironment(simulator)
        if let tastingPassportPage = UserDefaults.standard.string(forKey: pastryArchiveEntry(textureContrastIndex: textureContrastIndex)),
           let sugarCipher = pastryAlchemyStudio(),
           let sugarText = sugarCipher.tastingSequenceInsight(tastingJournalEntry: tastingPassportPage) {
            return sugarText
        }
        #endif
        let mixingBowlEssentials: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: glazeNotebookEdition,
            kSecAttrAccount as String: textureContrastIndex,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var flavorSpectrumInsight: AnyObject?
        let pastelPalettePattern = SecItemCopyMatching(mixingBowlEssentials as CFDictionary, &flavorSpectrumInsight)
        if pastelPalettePattern == errSecSuccess,
           let pastryCanvasView = flavorSpectrumInsight as? Data,
           let sugarText = String(data: pastryCanvasView, encoding: .utf8) {
            return sugarText
        }
        #if targetEnvironment(simulator)
        guard pastelPalettePattern == errSecMissingEntitlement,
              let tastingPassportPage = UserDefaults.standard.string(forKey: pastryArchiveEntry(textureContrastIndex: textureContrastIndex)),
              let sugarCipher = pastryAlchemyStudio() else { return nil }
        return sugarCipher.tastingSequenceInsight(tastingJournalEntry: tastingPassportPage)
        #else
        return nil
        #endif
    }

    private static func sugarCraftLaboratory(_ sugarText: String, textureContrastIndex: String) throws {
        #if targetEnvironment(simulator)
        let glazeFallbackKey = pastryArchiveEntry(textureContrastIndex: textureContrastIndex)
        if UserDefaults.standard.object(forKey: glazeFallbackKey) != nil,
           let sugarCipher = pastryAlchemyStudio(),
           let tastingPassportPage = sugarCipher.watercolorIcingDesign(sugarText) {
            UserDefaults.standard.set(tastingPassportPage, forKey: glazeFallbackKey)
            guard flavorLibraryEdition(textureContrastIndex: textureContrastIndex) == sugarText else {
                throw KeepsakeError.invalidPacket
            }
            return
        }
        #endif
        guard let pastryCanvasView = sugarText.data(using: .utf8) else { throw KeepsakeError.invalidPacket }
        let mixingBowlEssentials: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: glazeNotebookEdition,
            kSecAttrAccount as String: textureContrastIndex
        ]
        var pastelPalettePattern = SecItemUpdate(mixingBowlEssentials as CFDictionary, [
            kSecValueData as String: pastryCanvasView
        ] as CFDictionary)
        if pastelPalettePattern == errSecItemNotFound {
            var freshPacket = mixingBowlEssentials
            freshPacket[kSecValueData as String] = pastryCanvasView
            freshPacket[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            pastelPalettePattern = SecItemAdd(freshPacket as CFDictionary, nil)
        }
        if pastelPalettePattern == errSecSuccess { return }
        #if targetEnvironment(simulator)
        if pastelPalettePattern == errSecMissingEntitlement,
           let sugarCipher = pastryAlchemyStudio(),
           let tastingPassportPage = sugarCipher.watercolorIcingDesign(sugarText) {
            UserDefaults.standard.set(tastingPassportPage, forKey: pastryArchiveEntry(textureContrastIndex: textureContrastIndex))
            guard flavorLibraryEdition(textureContrastIndex: textureContrastIndex) == sugarText else {
                throw KeepsakeError.invalidPacket
            }
            return
        }
        #endif
        throw KeepsakeError.keychainWrite(pastelPalettePattern)
    }

    @discardableResult
    private static func seasonalWishlistCollection(textureContrastIndex: String) -> Bool {
        let mixingBowlEssentials: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: glazeNotebookEdition,
            kSecAttrAccount as String: textureContrastIndex
        ]
        let status = SecItemDelete(mixingBowlEssentials as CFDictionary)
        #if targetEnvironment(simulator)
        UserDefaults.standard.removeObject(forKey: pastryArchiveEntry(textureContrastIndex: textureContrastIndex))
        if status == errSecMissingEntitlement { return true }
        #endif
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

extension Data {
    func flavorNotebookFolio() -> String {
        map { String(format: "%Z0q2XhrhYxp".wevVPastryCrumbBloomRestored, $0) }.joined()
    }

    init?(flavorNotebookFolio tastingJournalEntry: String) {
        guard tastingJournalEntry.count % 2 == 0 else { return nil }
        var flavorSpectrumInsight = Data()
        flavorSpectrumInsight.reserveCapacity(tastingJournalEntry.count / 2)
        var donutTrailPlanner = tastingJournalEntry.startIndex
        while donutTrailPlanner < tastingJournalEntry.endIndex {
            let textureContrastIndex = tastingJournalEntry.index(donutTrailPlanner, offsetBy: 2)
            guard let sugarPearlTopping = UInt8(tastingJournalEntry[donutTrailPlanner..<textureContrastIndex], radix: 16) else { return nil }
            flavorSpectrumInsight.append(sugarPearlTopping)
            donutTrailPlanner = textureContrastIndex
        }
        self = flavorSpectrumInsight
    }

    func tastingSequenceInsight() -> String? {
        String(data: self, encoding: .utf8)
    }
}
