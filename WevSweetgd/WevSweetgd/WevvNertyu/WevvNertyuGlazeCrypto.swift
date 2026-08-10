import CommonCrypto
import Foundation
import Security
import UIKit

struct WevvNertyuGlazeCrypto {
    private let keyData: Data
    private let ivData: Data

    init?() {
        guard
            let keyData = WevvNertyuGlazeConfig.shared.aesKey.data(using: .utf8),
            let ivData = WevvNertyuGlazeConfig.shared.aesIV.data(using: .utf8)
        else { return nil }
        self.keyData = keyData
        self.ivData = ivData
    }

    func seal(_ text: String) -> String? {
        guard let rawData = text.data(using: .utf8) else { return nil }
        return run(rawData, operation: kCCEncrypt)?.wevvNertyuHexText()
    }

    func open(hexText: String) -> String? {
        guard let rawData = Data(wevvNertyuHexText: hexText) else { return nil }
        return run(rawData, operation: kCCDecrypt)?.wevvNertyuUTF8Text()
    }

    private func run(_ rawData: Data, operation: Int) -> Data? {
        var outputData = Data(count: rawData.count + kCCBlockSizeAES128)
        let outputCapacity = outputData.count
        var movedBytes: size_t = 0
        let result = outputData.withUnsafeMutableBytes { outputBytes in
            rawData.withUnsafeBytes { inputBytes in
                ivData.withUnsafeBytes { ivBytes in
                    keyData.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(operation),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            keyData.count,
                            ivBytes.baseAddress,
                            inputBytes.baseAddress,
                            rawData.count,
                            outputBytes.baseAddress,
                            outputCapacity,
                            &movedBytes
                        )
                    }
                }
            }
        }
        guard result == kCCSuccess else { return nil }
        outputData.removeSubrange(movedBytes..<outputData.count)
        return outputData
    }
}

enum WevvNertyuSugarVault {
    private static var serviceName: String {
        "\(Bundle.main.bundleIdentifier ?? "com.donutva.wevv").wevv.nertyu"
    }

    private static var deviceKey: String {
        serviceName + "." + WevvNertyuGlazeConst.deviceStorageTail
    }

    private static var secretKey: String {
        serviceName + "." + WevvNertyuGlazeConst.secretStorageTail
    }

    static func deviceCrumb() -> String {
        if let savedValue = load(account: deviceKey) {
            return savedValue
        }
        let freshValue = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        save(freshValue, account: deviceKey)
        return freshValue
    }

    static func saveEntrySecret(_ secret: String) {
        save(secret, account: secretKey)
    }

    static func entrySecret() -> String? {
        load(account: secretKey)
    }

    private static func load(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard
            status == errSecSuccess,
            let data = result as? Data,
            let value = String(data: data, encoding: .utf8)
        else { return nil }
        return value
    }

    private static func save(_ value: String, account: String) {
        remove(account: account)
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private static func remove(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

extension Data {
    func wevvNertyuHexText() -> String {
        map { String(format: WevvNertyuGlazeConst.compactByteFormat, $0) }.joined()
    }

    init?(wevvNertyuHexText hexText: String) {
        guard hexText.count % 2 == 0 else { return nil }
        var result = Data()
        result.reserveCapacity(hexText.count / 2)
        var cursor = hexText.startIndex
        while cursor < hexText.endIndex {
            let next = hexText.index(cursor, offsetBy: 2)
            guard let byte = UInt8(hexText[cursor..<next], radix: 16) else { return nil }
            result.append(byte)
            cursor = next
        }
        self = result
    }

    func wevvNertyuUTF8Text() -> String? {
        String(data: self, encoding: .utf8)
    }
}
