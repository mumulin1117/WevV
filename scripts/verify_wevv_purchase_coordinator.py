#!/usr/bin/env python3
"""Offline tests for the production SDK2 purchase ledger; never contacts StoreKit."""
from wevv_swift_source import STRING_HELPER
from pathlib import Path
import argparse
import os
import plistlib
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/WevEnd/DrawcreamScoutSugarStyle.swift'

SWIFT_TESTS = r'''
@main
struct PurchaseLedgerVerification {
    @MainActor
    static func main() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("wevv-payment-check-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        var passed = 0
        func check(_ value: @autoclosure () throws -> Bool, _ label: String) throws {
            guard try value() else { throw NSError(domain: "Verification", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
            passed += 1
        }
        func rejects(_ label: String, _ operation: () throws -> Void) throws {
            do { try operation() } catch { passed += 1; return }
            throw NSError(domain: "Verification", code: 2, userInfo: [NSLocalizedDescriptionKey: label])
        }
        let directory = root.appendingPathComponent("ledger")
        var ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        let scope = berryTone(boundary: "https://test.invalid|REPLICA", applyDonutAvatarChoice: "test-app", cocoaWeekendFestival: "account-one")
        let otherOwner = berryTone(boundary: scope.boundary, applyDonutAvatarChoice: scope.applyDonutAvatarChoice, cocoaWeekendFestival: "account-two")
        let otherApp = berryTone(boundary: scope.boundary, applyDonutAvatarChoice: "other-app", cocoaWeekendFestival: scope.cocoaWeekendFestival)
        let otherEnvironment = berryTone(boundary: "https://other.invalid|REPLICA", applyDonutAvatarChoice: scope.applyDonutAvatarChoice, cocoaWeekendFestival: scope.cocoaWeekendFestival)
        let receipt = Data("offline-receipt-fixture".utf8).base64EncodedString()
        let purchaseParams: [String: Any] = ["ownerId": scope.cocoaWeekendFestival, "orderCode": "order-one", "productId": "gems-one", "purpose": "diamonds"]
        try check(try bindCurrentDoughRingProfile.donutBackdropAsset(coffeeCreamShell: purchaseParams, cocoaWeekendFestival: scope.cocoaWeekendFestival, applyDonutAvatarChoice: scope.applyDonutAvatarChoice, boundary: scope.boundary) == scope, "trusted native identity accepted")
        try rejects("H5 cannot choose another native account") { _ = try bindCurrentDoughRingProfile.donutBackdropAsset(coffeeCreamShell: purchaseParams, cocoaWeekendFestival: otherOwner.cocoaWeekendFestival, applyDonutAvatarChoice: scope.applyDonutAvatarChoice, boundary: scope.boundary) }
        try rejects("guest cannot authorize purchase") { _ = try bindCurrentDoughRingProfile.donutBackdropAsset(coffeeCreamShell: purchaseParams, cocoaWeekendFestival: "", applyDonutAvatarChoice: scope.applyDonutAvatarChoice, boundary: scope.boundary) }
        try check(try bindCurrentDoughRingProfile.crispEdgeDough(purchaseParams).connectingStatus == "gems-one", "valid business order accepted")
        var invalidParams = purchaseParams
        invalidParams["purpose"] = "subscription"
        try rejects("only diamonds purpose allowed") { _ = try bindCurrentDoughRingProfile.crispEdgeDough(invalidParams) }
        invalidParams = purchaseParams
        invalidParams["ownerId"] = 1
        try rejects("numeric owner cannot bypass string identity") { _ = try bindCurrentDoughRingProfile.donutBackdropAsset(coffeeCreamShell: invalidParams, cocoaWeekendFestival: "1", applyDonutAvatarChoice: scope.applyDonutAvatarChoice, boundary: scope.boundary) }
        try check(try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival]).WevVWevvTastingQuestCard.isEmpty, "sync optional arrays default empty")
        try check(try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival, "acknowledgedTransactionIds": (0..<100).map(String.init)]).WevVWevvTastingQuestCard.count == 100, "100 ACK entries accepted")
        try rejects("101 ACK entries rejected") { _ = try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival, "acknowledgedTransactionIds": (0..<101).map(String.init)]) }
        try rejects("101 excluded entries rejected") { _ = try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival, "excludeTransactionIds": (0..<101).map(String.init)]) }
        try rejects("null array is not omitted") { _ = try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival, "acknowledgedTransactionIds": NSNull()]) }
        try rejects("mixed transaction array rejected") { _ = try bindCurrentDoughRingProfile.donutSnapshot(["ownerId": scope.cocoaWeekendFestival, "excludeTransactionIds": ["1", 2]]) }
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).isEmpty, "initial empty queue")
        let token = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "gems-one")
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        try check(ledger.donutBackdropAsset(buildVaultsuppleDoughDough: token) == scope, "purchase context survives relaunch")
        try rejects("legacy submitted is unresolved, not fabricated Ask to Buy") { _ = try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "gems-one") }
        try rejects("same order cannot change product") { _ = try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "different") }
        try ledger.clearRemoteOwnerData(token, configureSugarTextField: "pending")
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "gems-one")?["status"] as? String == "pending", "actual Ask to Buy remains pending")
        _ = try ledger.assetName(doughMaturationStudy: token, connectingStatus: "gems-one", doughStretchRhythm: "trade-one", crumbScoutline: receipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date(timeIntervalSince1970: 1))
        try ledger.clearRemoteOwnerData(token, configureSugarTextField: "failed")
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "gems-one")?["status"] as? String == "purchased", "error result cannot downgrade an earlier verified update")
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        let recovered = try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: [])
        try check(recovered.count == 1 && recovered[0]["receipt"] as? String == receipt && recovered[0]["orderCode"] as? String == "order-one", "late purchase materials survive restart")
        try check(try ledger.configurePastryButton(donutBackdropAsset: otherOwner, brownButterShell: []).isEmpty && ledger.configurePastryButton(donutBackdropAsset: otherApp, brownButterShell: []).isEmpty && ledger.configurePastryButton(donutBackdropAsset: otherEnvironment, brownButterShell: []).isEmpty, "account App service isolation")
        try ledger.WevVGlazeVideoDialController(donutBackdropAsset: otherOwner, doughmeltawayCrust: ["trade-one"])
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).count == 1, "other owner cannot acknowledge")
        _ = try ledger.assetName(doughMaturationStudy: token, connectingStatus: "gems-one", doughStretchRhythm: "trade-one", crumbScoutline: receipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date())
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).count == 1, "transaction replay is idempotent")
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: ["trade-one"]).isEmpty && ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).count == 1, "exclude is temporary")
        let alienToken = try ledger.apricotCenter(donutBackdropAsset: otherOwner, cocoaRaspberryMedley: "alien-order", connectingStatus: "gems-one")
        try rejects("transaction cannot be reassigned across accounts") { _ = try ledger.assetName(doughMaturationStudy: alienToken, connectingStatus: "gems-one", doughStretchRhythm: "trade-one", crumbScoutline: receipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date()) }
        try ledger.WevVGlazeVideoDialController(donutBackdropAsset: scope, doughmeltawayCrust: ["trade-one", "unknown"])
        try ledger.WevVGlazeVideoDialController(donutBackdropAsset: scope, doughmeltawayCrust: ["trade-one"])
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).isEmpty && ledger.candiedOrangeDust(doughMaturationStudy: token, doughStretchRhythm: "trade-one"), "ACK removes material and survives relaunch")
        try rejects("ACKed transaction cannot reappear") { _ = try ledger.assetName(doughMaturationStudy: token, connectingStatus: "gems-one", doughStretchRhythm: "trade-one", crumbScoutline: receipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date()) }
        try rejects("delivered order cannot charge again") { _ = try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "order-one", connectingStatus: "gems-one") }
        let cancelled = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "cancel-order", connectingStatus: "gems-one")
        try ledger.clearRemoteOwnerData(cancelled, configureSugarTextField: "cancelled")
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "cancel-order", connectingStatus: "gems-one") == nil, "cancelled purchase can retry")
        try rejects("invalid receipt is not saved") { _ = try ledger.assetName(doughMaturationStudy: cancelled, connectingStatus: "gems-one", doughStretchRhythm: "broken", crumbScoutline: "!invalid", donutNoteCalendar: "purchased", crumbDensityInsight: Date()) }
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).isEmpty, "invalid capture leaves queue intact")
        let failed = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "failed-order", connectingStatus: "gems-one")
        try ledger.clearRemoteOwnerData(failed, configureSugarTextField: "failed")
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "failed-order", connectingStatus: "gems-one") == nil, "explicit rejected attempt can retry after restart")
        _ = try ledger.assetName(doughMaturationStudy: failed, connectingStatus: "gems-one", doughStretchRhythm: "late-failed-trade", crumbScoutline: receipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date())
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "failed-order", connectingStatus: "gems-one")?["status"] as? String == "purchased", "late transaction keeps original rejected token ownership")
        try ledger.WevVGlazeVideoDialController(donutBackdropAsset: scope, doughmeltawayCrust: ["late-failed-trade"])
        try ledger.clearRemoteOwnerData(failed, configureSugarTextField: "failed")
        try rejects("error result cannot downgrade durable ACK") { _ = try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "failed-order", connectingStatus: "gems-one") }
        let uncertain = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "uncertain-order", connectingStatus: "gems-one")
        try ledger.clearRemoteOwnerData(uncertain, configureSugarTextField: "uncertain")
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        try rejects("ambiguous outcome remains blocked after restart") { _ = try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "uncertain-order", connectingStatus: "gems-one") }
        for index in 0..<25 {
            let context = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "batch-\(index)", connectingStatus: "gems-one")
            _ = try ledger.assetName(doughMaturationStudy: context, connectingStatus: "gems-one", doughStretchRhythm: "batch-trade-\(index)", crumbScoutline: receipt, donutNoteCalendar: index == 0 ? "restored" : "purchased", crumbDensityInsight: Date(timeIntervalSince1970: Double(index)))
        }
        let batch = try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: [])
        try check(batch.count == 20 && batch[0]["state"] as? String == "restored", "maximum batch size and exact stored state")
        let exclusion = (0..<20).map { "batch-trade-\($0)" }
        try check(try ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: exclusion).count == 5, "exclude permits pagination without deletion")
        let largeScope = berryTone(boundary: scope.boundary, applyDonutAvatarChoice: scope.applyDonutAvatarChoice, cocoaWeekendFestival: "large-receipts")
        let largeReceipt = Data(repeating: 42, count: 1_100_000).base64EncodedString()
        for index in 0..<2 {
            let context = try ledger.apricotCenter(donutBackdropAsset: largeScope, cocoaRaspberryMedley: "large-\(index)", connectingStatus: "gems-one")
            _ = try ledger.assetName(doughMaturationStudy: context, connectingStatus: "gems-one", doughStretchRhythm: "large-trade-\(index)", crumbScoutline: largeReceipt, donutNoteCalendar: "purchased", crumbDensityInsight: Date(timeIntervalSince1970: Double(index)))
        }
        try check(try ledger.configurePastryButton(donutBackdropAsset: largeScope, brownButterShell: []).count == 1, "aggregate receipt character bound")
        let hugeScope = berryTone(boundary: scope.boundary, applyDonutAvatarChoice: scope.applyDonutAvatarChoice, cocoaWeekendFestival: "oversize-receipt")
        let hugeToken = try ledger.apricotCenter(donutBackdropAsset: hugeScope, cocoaRaspberryMedley: "huge-order", connectingStatus: "gems-one")
        _ = try ledger.assetName(doughMaturationStudy: hugeToken, connectingStatus: "gems-one", doughStretchRhythm: "huge-trade", crumbScoutline: Data(repeating: 7, count: 2_100_000).base64EncodedString(), donutNoteCalendar: "purchased", crumbDensityInsight: Date())
        try rejects("oversize receipt fails instead of pretending queue empty") { _ = try ledger.configurePastryButton(donutBackdropAsset: hugeScope, brownButterShell: []) }
        let backupDirectory = root.appendingPathComponent("saved-ledger")
        try FileManager.default.moveItem(at: directory, to: backupDirectory)
        try Data("not-a-directory".utf8).write(to: directory)
        try rejects("failed persistence is surfaced") { _ = try ledger.apricotCenter(donutBackdropAsset: scope, cocoaRaspberryMedley: "disk-failure", connectingStatus: "gems-one") }
        try FileManager.default.removeItem(at: directory)
        try FileManager.default.moveItem(at: backupDirectory, to: directory)
        ledger = try expectedGlazeProductID(beginSugarPictureUpload: directory)
        try check(try ledger.buildPastryEditScrollShell(donutBackdropAsset: scope, cocoaRaspberryMedley: "disk-failure", connectingStatus: "gems-one") == nil && ledger.configurePastryButton(donutBackdropAsset: scope, brownButterShell: []).count == 20, "failed write preserves prior durable state")
        let file = directory.appendingPathComponent(scope.donutPinKey + ".json")
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: file.path)
        let directoryAttributes = try FileManager.default.attributesOfItem(atPath: directory.path)
        try check((fileAttributes[.posixPermissions] as? NSNumber)?.intValue == 0o600 && (directoryAttributes[.posixPermissions] as? NSNumber)?.intValue == 0o700, "private file and directory permissions")
        #if os(iOS)
        let protectionValue = fileAttributes[.protectionKey]
        #if targetEnvironment(simulator)
        if protectionValue == nil {
            print("Simulator does not expose Data Protection metadata; requested protection cannot be verified without a physical device.")
        } else {
            try check((protectionValue as? FileProtectionType)?.rawValue == FileProtectionType.completeUntilFirstUserAuthentication.rawValue || protectionValue as? String == FileProtectionType.completeUntilFirstUserAuthentication.rawValue, "iOS file protection before first unlock")
        }
        #else
        try check((protectionValue as? FileProtectionType)?.rawValue == FileProtectionType.completeUntilFirstUserAuthentication.rawValue || protectionValue as? String == FileProtectionType.completeUntilFirstUserAuthentication.rawValue, "iOS file protection before first unlock")
        #endif
        #endif
        if try file.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup == true && directory.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup == true {
            try check(true, "backup exclusion on directory and journal")
        } else {
            print("Host filesystem does not expose Foundation backup-exclusion metadata; the iOS path checks this and refuses writes if exclusion fails.")
        }
        try check(try FileManager.default.contentsOfDirectory(atPath: directory.path).allSatisfy { $0.hasSuffix(".json") && !$0.contains("account-one") }, "opaque paths and no leftover staging files")
        let corruptDirectory = root.appendingPathComponent("corrupt")
        try FileManager.default.createDirectory(at: corruptDirectory, withIntermediateDirectories: true)
        try Data("broken".utf8).write(to: corruptDirectory.appendingPathComponent(scope.donutPinKey + ".json"))
        try rejects("corrupt persistent data is not an empty queue") { _ = try expectedGlazeProductID(beginSugarPictureUpload: corruptDirectory) }
        let symlink = root.appendingPathComponent("symlink-ledger")
        try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: directory)
        try rejects("symlink store rejected") { _ = try expectedGlazeProductID(beginSugarPictureUpload: symlink) }
        print("SDK2 purchase ledger: \(passed) offline checks passed; no StoreKit purchase or server request performed.")
    }
}
'''


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--simulator", help="Run the same ledger in an isolated temporary iOS app on this booted UDID")
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="wevv-purchase-test-") as temporary:
        directory = Path(temporary)
        source = directory / "PurchaseVerification.swift"
        source.write_text(SOURCE.read_text() + "\n" + SWIFT_TESTS)
        command = ["xcrun", "swiftc", str(STRING_HELPER), "-parse-as-library", "-swift-version", "5",
                   "-D", "WEVV_PURCHASE_TESTING", "-module-cache-path", str(directory / "modules")]
        if args.simulator:
            app = directory / "WevVPurchaseLedgerProbe.app"
            app.mkdir()
            bundle_id = "org.wevv.sdk2-ledger-probe"
            binary = app / "WevVPurchaseLedgerProbe"
            sdk = subprocess.check_output(["xcrun", "--sdk", "iphonesimulator", "--show-sdk-path"], text=True).strip()
            command.extend(["-target", "arm64-apple-ios15.6-simulator", "-sdk", sdk])
            (app / "Info.plist").write_bytes(plistlib.dumps({
                "CFBundleIdentifier": bundle_id, "CFBundleExecutable": binary.name,
                "CFBundleName": "WevV Purchase Ledger Probe", "CFBundlePackageType": "APPL",
                "CFBundleVersion": "1", "CFBundleShortVersionString": "1.0", "MinimumOSVersion": "15.6",
                "UIDeviceFamily": [1], "LSRequiresIPhoneOS": True,
            }))
            build_environment = dict(os.environ, SDKROOT=sdk)
            subprocess.run(command + [str(source), "-o", str(binary)], check=True, env=build_environment)
            subprocess.run(["codesign", "--force", "--sign", "-", "--timestamp=none", str(app)], check=True)
            subprocess.run(["xcrun", "simctl", "install", args.simulator, str(app)], check=True)
            try:
                result = subprocess.run(["xcrun", "simctl", "launch", "--console", "--terminate-running-process", args.simulator, bundle_id], text=True, capture_output=True, timeout=60)
                print(result.stdout, end="")
                print(result.stderr, end="")
                if result.returncode or "offline checks passed" not in result.stdout:
                    raise RuntimeError("iOS purchase ledger validation failed")
            finally:
                subprocess.run(["xcrun", "simctl", "uninstall", args.simulator, bundle_id], check=False)
        else:
            binary = directory / "verify-purchases"
            subprocess.run(command + [str(source), "-o", str(binary)], check=True)
            subprocess.run([str(binary)], check=True)


if __name__ == "__main__":
    main()
