import CommonCrypto
import Foundation
import Security
import UIKit

struct WevvNertyuCreampistachioFlight {
    private let sugarBasicTitleData: Data
    private let pastryCanvasViewData: Data

    init?() {
        guard
            let sugarBasicTitleData = WevvNertyuclassicBadge.shared.aesKey.data(using: .utf8),
            let pastryCanvasViewData = WevvNertyuclassicBadge.shared.aesIV.data(using: .utf8)
        else { return nil }
        self.sugarBasicTitleData = sugarBasicTitleData
        self.pastryCanvasViewData = pastryCanvasViewData
    }

    func tuneSugarSaveButton(_ sugarTitle: String) -> String? {
        guard let crumbBioViewData = sugarTitle.data(using: .utf8) else { return nil }
        return bindPastryEditDismissTap(crumbBioViewData, sugarInk: kCCEncrypt)?.wevvCreamRingHexText()
    }

    func openSugarText(sugarTitle: String) -> String? {
        guard let crumbBioViewData = Data(wevvCreamRingHexText: sugarTitle) else { return nil }
        return bindPastryEditDismissTap(crumbBioViewData, sugarInk: kCCDecrypt)?.wevvCreamRingUTF8Text()
    }

    private func bindPastryEditDismissTap(_ crumbBioViewData: Data, sugarInk: Int) -> Data? {
        var sugarContentViewData = Data(count: crumbBioViewData.count + kCCBlockSizeAES128)
        let sugarCacheCount = sugarContentViewData.count
        var crumbEraseButtonCount: size_t = 0
        let tastingScoutline = sugarContentViewData.withUnsafeMutableBytes { sugarRowsStackBytes in
            crumbBioViewData.withUnsafeBytes { doughScrollBytes in
                pastryCanvasViewData.withUnsafeBytes { pastryCanvasBytes in
                    sugarBasicTitleData.withUnsafeBytes { sugarBasicBytes in
                        CCCrypt(
                            CCOperation(sugarInk),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            sugarBasicBytes.baseAddress,
                            sugarBasicTitleData.count,
                            pastryCanvasBytes.baseAddress,
                            doughScrollBytes.baseAddress,
                            crumbBioViewData.count,
                            sugarRowsStackBytes.baseAddress,
                            sugarCacheCount,
                            &crumbEraseButtonCount
                        )
                    }
                }
            }
        }
        guard tastingScoutline == kCCSuccess else { return nil }
        sugarContentViewData.removeSubrange(crumbEraseButtonCount..<sugarContentViewData.count)
        return sugarContentViewData
    }
}

enum WevvNertyuDoughSession {
    private static var sugarCacheCountKey: String {
        "\(Bundle.main.bundleIdentifier ?? "com.donutva.wevv").wevv.nertyu"
    }

    private static var sugarTitle: String {
        sugarCacheCountKey + "." + WevvmarshmallowFlight.deviceStorageTail
    }

    private static var sugarValue: String {
        sugarCacheCountKey + "." + WevvmarshmallowFlight.secretStorageTail
    }

    static func currentSugarCacheCountText() -> String {
        if let tastingVisit = makeSettingRow(crumbSpec: sugarTitle) {
            return tastingVisit
        }
        let filledScout = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString + WevvNertyuclassicBadge.shared.appCode
        makeSugarBottomButton(filledScout, crumbSpec: sugarTitle)
        return filledScout
    }

    static func saveCreamRingProfile(_ sugarTitle: String) {
        makeSugarBottomButton(sugarTitle, crumbSpec: sugarValue)
    }

    static func bindCurrentDoughRingProfile() -> String? {
        makeSettingRow(crumbSpec: sugarValue)
    }

    private static func makeSettingRow(crumbSpec: String) -> String? {
        let glazeBowl: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: sugarCacheCountKey,
            kSecAttrAccount as String: crumbSpec,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var tastingScoutline: AnyObject?
        let inkTone = SecItemCopyMatching(glazeBowl as CFDictionary, &tastingScoutline)
        guard
            inkTone == errSecSuccess,
            let pastryCanvasView = tastingScoutline as? Data,
            let sugarText = String(data: pastryCanvasView, encoding: .utf8)
        else { return nil }
        return sugarText
    }

    private static func makeSugarBottomButton(_ sugarText: String, crumbSpec: String) {
        clearSugarCache(crumbSpec: crumbSpec)
        guard let pastryCanvasView = sugarText.data(using: .utf8) else { return }
        let glazeBowl: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: sugarCacheCountKey,
            kSecAttrAccount as String: crumbSpec,
            kSecValueData as String: pastryCanvasView,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(glazeBowl as CFDictionary, nil)
    }

    private static func clearSugarCache(crumbSpec: String) {
        let glazeBowl: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: sugarCacheCountKey,
            kSecAttrAccount as String: crumbSpec
        ]
        SecItemDelete(glazeBowl as CFDictionary)
    }
}

extension Data {
    func wevvCreamRingHexText() -> String {
        map { String(format: WevvmarshmallowFlight.compactByteFormat, $0) }.joined()
    }

    init?(wevvCreamRingHexText sugarTitle: String) {
        guard sugarTitle.count % 2 == 0 else { return nil }
        var tastingScoutline = Data()
        tastingScoutline.reserveCapacity(sugarTitle.count / 2)
        var donutRow = sugarTitle.startIndex
        while donutRow < sugarTitle.endIndex {
            let crumbSpec = sugarTitle.index(donutRow, offsetBy: 2)
            guard let sprinkleButton = UInt8(sugarTitle[donutRow..<crumbSpec], radix: 16) else { return nil }
            tastingScoutline.append(sprinkleButton)
            donutRow = crumbSpec
        }
        self = tastingScoutline
    }

    func wevvCreamRingUTF8Text() -> String? {
        String(data: self, encoding: .utf8)
    }
}
