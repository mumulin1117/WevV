#!/usr/bin/env python3
"""Run the actual credential storage with isolated defaults and an in-memory Security boundary."""
from pathlib import Path
import subprocess
import tempfile
from wevv_swift_source import STRING_HELPER

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/glazeGalleryGuide.swift'

BOUNDARIES = r'''
import Foundation
import CoreFoundation
import Security
final class TestDefaults {
    static let shared = TestDefaults()
    var values: [String: Any] = [:]
    func set(_ value: Any, forKey key: String) { values[key] = value }
    func string(forKey key: String) -> String? { values[key] as? String }
    func bool(forKey key: String) -> Bool { values[key] as? Bool ?? false }
    func object(forKey key: String) -> Any? { values[key] }
    func removeObject(forKey key: String) { values.removeValue(forKey: key) }
}
struct UIDevice {
    static let current = UIDevice()
    let identifierForVendor = UUID(uuidString: "00000000-0000-0000-0000-000000000001")
}
enum SecurityFixture {
    static var packets: [String: Data] = [:]
    static var writes: OSStatus = errSecSuccess
    static var reads: OSStatus = errSecSuccess
    static var deletes: OSStatus = errSecSuccess
    static var lastAccount = ""
    static var readCount = 0
    static var deleteCount = 0
    static func values(_ query: CFDictionary) -> [String: Any] {
        unsafeBitCast(query, to: NSDictionary.self) as! [String: Any]
    }
    static func account(_ query: CFDictionary) -> String {
        let value = values(query)
        return (value[kSecAttrService as String] as! String) + "|" + (value[kSecAttrAccount as String] as! String)
    }
}
func SecItemCopyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
    SecurityFixture.readCount += 1
    guard SecurityFixture.reads == errSecSuccess else { return SecurityFixture.reads }
    guard let data = SecurityFixture.packets[SecurityFixture.account(query)] else { return errSecItemNotFound }
    result?.pointee = data as NSData
    return errSecSuccess
}
func SecItemUpdate(_ query: CFDictionary, _ attributes: CFDictionary) -> OSStatus {
    guard SecurityFixture.writes == errSecSuccess else { return SecurityFixture.writes }
    let key = SecurityFixture.account(query)
    guard SecurityFixture.packets[key] != nil else { return errSecItemNotFound }
    SecurityFixture.packets[key] = SecurityFixture.values(attributes)[kSecValueData as String] as? Data
    SecurityFixture.lastAccount = key
    return errSecSuccess
}
func SecItemAdd(_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
    guard SecurityFixture.writes == errSecSuccess else { return SecurityFixture.writes }
    let key = SecurityFixture.account(query)
    SecurityFixture.packets[key] = SecurityFixture.values(query)[kSecValueData as String] as? Data
    SecurityFixture.lastAccount = key
    return errSecSuccess
}
func SecItemDelete(_ query: CFDictionary) -> OSStatus {
    SecurityFixture.deleteCount += 1
    guard SecurityFixture.deletes == errSecSuccess else { return SecurityFixture.deletes }
    let removed = SecurityFixture.packets.removeValue(forKey: SecurityFixture.account(query))
    return removed == nil ? errSecItemNotFound : errSecSuccess
}
'''

TESTS = r'''
@main enum Probe {
    static func main() throws {
        let scope = "production|fixture-app|fixture-api"
        let other = "test|fixture-app|fixture-api"
        let defaults = TestDefaults.shared
        let scenario = CommandLine.arguments[1]
        func persist(_ packet: String = "synthetic-session-A", _ selected: String? = nil) throws {
            try glazeGalleryGuide.pastryDiaryCollection(packet, scope: selected ?? scope)
        }
        func removeBindings() {
            defaults.values = defaults.values.filter { !$0.key.hasSuffix(".installation-v1") }
        }
        switch scenario {
        case "restart-save":
            try persist()
            defaults.set(true, forKey: "wevv_glaze_signed_in")
            let snapshot: [String: Any] = ["defaults": defaults.values,
                "keychain": SecurityFixture.packets.mapValues { $0.base64EncodedString() }]
            try JSONSerialization.data(withJSONObject: snapshot).write(to: URL(fileURLWithPath: CommandLine.arguments[2]))
        case "restart-load", "reinstall-load":
            let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[2]))
            let snapshot = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            SecurityFixture.packets = (snapshot["keychain"] as! [String: String]).mapValues { Data(base64Encoded: $0)! }
            if scenario == "restart-load" {
                defaults.values = snapshot["defaults"] as! [String: Any]
                precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
            } else {
                precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
            }
        case "restart":
            try persist()
            let reads = SecurityFixture.readCount
            for _ in 0..<5 { precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A") }
            precondition(SecurityFixture.readCount > reads)
        case "reinstall":
            let device = glazeGalleryGuide.firstBiteArchive()
            try persist()
            defaults.set(true, forKey: "wevv_glaze_signed_in")
            let account = SecurityFixture.lastAccount
            defaults.values.removeAll()
            let reads = SecurityFixture.readCount
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
            precondition(SecurityFixture.readCount == reads, "A new install must not read the old credential")
            precondition(SecurityFixture.packets[account] == nil)
            precondition(glazeGalleryGuide.firstBiteArchive() == device, "Technical identity must remain separate")
        case "reinstall-other-scope":
            try persist(); try persist("synthetic-session-B", other)
            defaults.values.removeAll()
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
            try persist("new-install-session")
            defaults.set(true, forKey: "wevv_glaze_signed_in")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: other) == nil)
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "new-install-session")
        case "upgrade":
            try persist(); try persist("synthetic-session-B", other)
            removeBindings()
            defaults.set(true, forKey: "wevv_glaze_signed_in")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: other) == nil, "Only the active signed-in legacy scope may migrate")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
        case "upgrade-guest":
            try persist(); removeBindings()
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
        case "rotation-and-mismatch":
            try persist(); try persist("rotated-session")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "rotated-session")
            SecurityFixture.packets[SecurityFixture.lastAccount] = Data("synthetic-session-A".utf8)
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
        case "logout-delete-failure":
            try persist()
            let account = SecurityFixture.lastAccount
            SecurityFixture.deletes = errSecAuthFailed
            precondition(!glazeGalleryGuide.cocoaRaspberryMedley(scope: scope))
            precondition(SecurityFixture.packets[account] != nil)
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
            try persist("explicit-new-login")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "explicit-new-login")
        case "write-failure":
            try persist()
            SecurityFixture.writes = errSecAuthFailed
            do { try persist("failed-rotation"); fatalError("write failure accepted") } catch { }
            SecurityFixture.writes = errSecSuccess
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
        case "temporarily-unavailable":
            try persist()
            let deletes = SecurityFixture.deleteCount
            SecurityFixture.reads = errSecInteractionNotAllowed
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
            precondition(SecurityFixture.deleteCount == deletes, "Temporary unavailability must not erase a valid bound session")
            SecurityFixture.reads = errSecSuccess
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
        case "revoked-upgrade":
            try persist()
            SecurityFixture.deletes = errSecAuthFailed
            _ = glazeGalleryGuide.cocoaRaspberryMedley(scope: scope)
            removeBindings(); defaults.set(true, forKey: "wevv_glaze_signed_in")
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
        case "simulator-fallback":
            SecurityFixture.writes = errSecMissingEntitlement
            SecurityFixture.reads = errSecMissingEntitlement
            SecurityFixture.deletes = errSecMissingEntitlement
            try persist()
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == "synthetic-session-A")
            defaults.values.removeAll()
            precondition(glazeGalleryGuide.sweetKeepsakeEntry(scope: scope) == nil)
        default: fatalError("Unknown isolated scenario")
        }
        print("PASS " + scenario)
    }
}
'''


def main():
    shipping = SOURCE.read_text().replace('import UIKit', '').replace('UserDefaults.standard', 'TestDefaults.shared')
    # The second runner enables only the existing simulator fallback in this macOS fixture.
    shipping = shipping.replace('#if targetEnvironment(simulator)', '#if WEVV_DONUT_TESTING')
    scenarios = ['restart', 'reinstall', 'reinstall-other-scope', 'upgrade', 'upgrade-guest',
                 'rotation-and-mismatch', 'logout-delete-failure', 'write-failure',
                 'temporarily-unavailable', 'revoked-upgrade']
    with tempfile.TemporaryDirectory(prefix='wevv-installation-check-', dir='/private/tmp') as directory:
        root = Path(directory)
        source = root / 'Verification.swift'
        source.write_text(BOUNDARIES + '\n' + shipping + '\n' + TESTS)
        for simulator in (False, True):
            binary = root / ('simulator' if simulator else 'keychain')
            command = ['xcrun', 'swiftc', str(STRING_HELPER), '-swift-version', '5', '-default-isolation', 'MainActor',
                       '-parse-as-library', '-module-cache-path', str(root / 'modules')]
            if simulator:
                command += ['-D', 'WEVV_DONUT_TESTING']
            subprocess.run(command + [str(source), '-o', str(binary)], check=True)
            for scenario in scenarios + (['simulator-fallback'] if simulator else []):
                subprocess.run([str(binary), scenario], check=True, timeout=15)
            snapshot = root / ('simulator-installation.json' if simulator else 'keychain-installation.json')
            for scenario in ['restart-save', 'restart-load', 'reinstall-load']:
                subprocess.run([str(binary), scenario, str(snapshot)], check=True, timeout=15)
    print('PASS: 27 shipping credential storage scenarios; isolated defaults/Security only, no real credentials or device state')


if __name__ == '__main__':
    main()
