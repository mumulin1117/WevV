#!/usr/bin/env python3
"""Offline tests for the production SDK2 purchase ledger; never contacts StoreKit."""
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
        var ledger = try expectedGlazeProductID(directory: directory)
        let scope = donutSnapshot(environmentID: "https://test.invalid|REPLICA", appID: "test-app", ownerID: "account-one")
        let otherOwner = donutSnapshot(environmentID: scope.environmentID, appID: scope.appID, ownerID: "account-two")
        let otherApp = donutSnapshot(environmentID: scope.environmentID, appID: "other-app", ownerID: scope.ownerID)
        let otherEnvironment = donutSnapshot(environmentID: "https://other.invalid|REPLICA", appID: scope.appID, ownerID: scope.ownerID)
        let receipt = Data("offline-receipt-fixture".utf8).base64EncodedString()
        let purchaseParams: [String: Any] = ["ownerId": scope.ownerID, "orderCode": "order-one", "productId": "gems-one", "purpose": "diamonds"]
        try check(try donutcitrusMixerView.scope(params: purchaseParams, ownerID: scope.ownerID, appID: scope.appID, environmentID: scope.environmentID) == scope, "trusted native identity accepted")
        try rejects("H5 cannot choose another native account") { _ = try donutcitrusMixerView.scope(params: purchaseParams, ownerID: otherOwner.ownerID, appID: scope.appID, environmentID: scope.environmentID) }
        try rejects("guest cannot authorize purchase") { _ = try donutcitrusMixerView.scope(params: purchaseParams, ownerID: "", appID: scope.appID, environmentID: scope.environmentID) }
        try check(try donutcitrusMixerView.purchase(purchaseParams).productID == "gems-one", "valid business order accepted")
        var invalidParams = purchaseParams
        invalidParams["purpose"] = "subscription"
        try rejects("only diamonds purpose allowed") { _ = try donutcitrusMixerView.purchase(invalidParams) }
        invalidParams = purchaseParams
        invalidParams["ownerId"] = 1
        try rejects("numeric owner cannot bypass string identity") { _ = try donutcitrusMixerView.scope(params: invalidParams, ownerID: "1", appID: scope.appID, environmentID: scope.environmentID) }
        try check(try donutcitrusMixerView.sync(["ownerId": scope.ownerID]).acknowledged.isEmpty, "sync optional arrays default empty")
        try check(try donutcitrusMixerView.sync(["ownerId": scope.ownerID, "acknowledgedTransactionIds": (0..<100).map(String.init)]).acknowledged.count == 100, "100 ACK entries accepted")
        try rejects("101 ACK entries rejected") { _ = try donutcitrusMixerView.sync(["ownerId": scope.ownerID, "acknowledgedTransactionIds": (0..<101).map(String.init)]) }
        try rejects("101 excluded entries rejected") { _ = try donutcitrusMixerView.sync(["ownerId": scope.ownerID, "excludeTransactionIds": (0..<101).map(String.init)]) }
        try rejects("null array is not omitted") { _ = try donutcitrusMixerView.sync(["ownerId": scope.ownerID, "acknowledgedTransactionIds": NSNull()]) }
        try rejects("mixed transaction array rejected") { _ = try donutcitrusMixerView.sync(["ownerId": scope.ownerID, "excludeTransactionIds": ["1", 2]]) }
        try check(try ledger.pending(scope: scope, excluded: []).isEmpty, "initial empty queue")
        let token = try ledger.begin(scope: scope, orderCode: "order-one", productID: "gems-one")
        ledger = try expectedGlazeProductID(directory: directory)
        try check(ledger.scope(for: token) == scope, "purchase context survives relaunch")
        try rejects("legacy submitted is unresolved, not fabricated Ask to Buy") { _ = try ledger.existingResult(scope: scope, orderCode: "order-one", productID: "gems-one") }
        try rejects("same order cannot change product") { _ = try ledger.existingResult(scope: scope, orderCode: "order-one", productID: "different") }
        try ledger.mark(token, phase: "pending")
        try check(try ledger.existingResult(scope: scope, orderCode: "order-one", productID: "gems-one")?["status"] as? String == "pending", "actual Ask to Buy remains pending")
        _ = try ledger.capture(token: token, productID: "gems-one", transactionID: "trade-one", receipt: receipt, state: "purchased", purchasedAt: Date(timeIntervalSince1970: 1))
        try ledger.mark(token, phase: "failed")
        try check(try ledger.existingResult(scope: scope, orderCode: "order-one", productID: "gems-one")?["status"] as? String == "purchased", "error result cannot downgrade an earlier verified update")
        ledger = try expectedGlazeProductID(directory: directory)
        let recovered = try ledger.pending(scope: scope, excluded: [])
        try check(recovered.count == 1 && recovered[0]["receipt"] as? String == receipt && recovered[0]["orderCode"] as? String == "order-one", "late purchase materials survive restart")
        try check(try ledger.pending(scope: otherOwner, excluded: []).isEmpty && ledger.pending(scope: otherApp, excluded: []).isEmpty && ledger.pending(scope: otherEnvironment, excluded: []).isEmpty, "account App service isolation")
        try ledger.acknowledge(scope: otherOwner, transactionIDs: ["trade-one"])
        try check(try ledger.pending(scope: scope, excluded: []).count == 1, "other owner cannot acknowledge")
        _ = try ledger.capture(token: token, productID: "gems-one", transactionID: "trade-one", receipt: receipt, state: "purchased", purchasedAt: Date())
        try check(try ledger.pending(scope: scope, excluded: []).count == 1, "transaction replay is idempotent")
        try check(try ledger.pending(scope: scope, excluded: ["trade-one"]).isEmpty && ledger.pending(scope: scope, excluded: []).count == 1, "exclude is temporary")
        let alienToken = try ledger.begin(scope: otherOwner, orderCode: "alien-order", productID: "gems-one")
        try rejects("transaction cannot be reassigned across accounts") { _ = try ledger.capture(token: alienToken, productID: "gems-one", transactionID: "trade-one", receipt: receipt, state: "purchased", purchasedAt: Date()) }
        try ledger.acknowledge(scope: scope, transactionIDs: ["trade-one", "unknown"])
        try ledger.acknowledge(scope: scope, transactionIDs: ["trade-one"])
        ledger = try expectedGlazeProductID(directory: directory)
        try check(try ledger.pending(scope: scope, excluded: []).isEmpty && ledger.isAcknowledged(token: token, transactionID: "trade-one"), "ACK removes material and survives relaunch")
        try rejects("ACKed transaction cannot reappear") { _ = try ledger.capture(token: token, productID: "gems-one", transactionID: "trade-one", receipt: receipt, state: "purchased", purchasedAt: Date()) }
        try rejects("delivered order cannot charge again") { _ = try ledger.existingResult(scope: scope, orderCode: "order-one", productID: "gems-one") }
        let cancelled = try ledger.begin(scope: scope, orderCode: "cancel-order", productID: "gems-one")
        try ledger.mark(cancelled, phase: "cancelled")
        try check(try ledger.existingResult(scope: scope, orderCode: "cancel-order", productID: "gems-one") == nil, "cancelled purchase can retry")
        try rejects("invalid receipt is not saved") { _ = try ledger.capture(token: cancelled, productID: "gems-one", transactionID: "broken", receipt: "!invalid", state: "purchased", purchasedAt: Date()) }
        try check(try ledger.pending(scope: scope, excluded: []).isEmpty, "invalid capture leaves queue intact")
        let failed = try ledger.begin(scope: scope, orderCode: "failed-order", productID: "gems-one")
        try ledger.mark(failed, phase: "failed")
        ledger = try expectedGlazeProductID(directory: directory)
        try check(try ledger.existingResult(scope: scope, orderCode: "failed-order", productID: "gems-one") == nil, "explicit rejected attempt can retry after restart")
        _ = try ledger.capture(token: failed, productID: "gems-one", transactionID: "late-failed-trade", receipt: receipt, state: "purchased", purchasedAt: Date())
        try check(try ledger.existingResult(scope: scope, orderCode: "failed-order", productID: "gems-one")?["status"] as? String == "purchased", "late transaction keeps original rejected token ownership")
        try ledger.acknowledge(scope: scope, transactionIDs: ["late-failed-trade"])
        try ledger.mark(failed, phase: "failed")
        try rejects("error result cannot downgrade durable ACK") { _ = try ledger.existingResult(scope: scope, orderCode: "failed-order", productID: "gems-one") }
        let uncertain = try ledger.begin(scope: scope, orderCode: "uncertain-order", productID: "gems-one")
        try ledger.mark(uncertain, phase: "uncertain")
        ledger = try expectedGlazeProductID(directory: directory)
        try rejects("ambiguous outcome remains blocked after restart") { _ = try ledger.existingResult(scope: scope, orderCode: "uncertain-order", productID: "gems-one") }
        for index in 0..<25 {
            let context = try ledger.begin(scope: scope, orderCode: "batch-\(index)", productID: "gems-one")
            _ = try ledger.capture(token: context, productID: "gems-one", transactionID: "batch-trade-\(index)", receipt: receipt, state: index == 0 ? "restored" : "purchased", purchasedAt: Date(timeIntervalSince1970: Double(index)))
        }
        let batch = try ledger.pending(scope: scope, excluded: [])
        try check(batch.count == 20 && batch[0]["state"] as? String == "restored", "maximum batch size and exact stored state")
        let exclusion = (0..<20).map { "batch-trade-\($0)" }
        try check(try ledger.pending(scope: scope, excluded: exclusion).count == 5, "exclude permits pagination without deletion")
        let largeScope = donutSnapshot(environmentID: scope.environmentID, appID: scope.appID, ownerID: "large-receipts")
        let largeReceipt = Data(repeating: 42, count: 1_100_000).base64EncodedString()
        for index in 0..<2 {
            let context = try ledger.begin(scope: largeScope, orderCode: "large-\(index)", productID: "gems-one")
            _ = try ledger.capture(token: context, productID: "gems-one", transactionID: "large-trade-\(index)", receipt: largeReceipt, state: "purchased", purchasedAt: Date(timeIntervalSince1970: Double(index)))
        }
        try check(try ledger.pending(scope: largeScope, excluded: []).count == 1, "aggregate receipt character bound")
        let hugeScope = donutSnapshot(environmentID: scope.environmentID, appID: scope.appID, ownerID: "oversize-receipt")
        let hugeToken = try ledger.begin(scope: hugeScope, orderCode: "huge-order", productID: "gems-one")
        _ = try ledger.capture(token: hugeToken, productID: "gems-one", transactionID: "huge-trade", receipt: Data(repeating: 7, count: 2_100_000).base64EncodedString(), state: "purchased", purchasedAt: Date())
        try rejects("oversize receipt fails instead of pretending queue empty") { _ = try ledger.pending(scope: hugeScope, excluded: []) }
        let backupDirectory = root.appendingPathComponent("saved-ledger")
        try FileManager.default.moveItem(at: directory, to: backupDirectory)
        try Data("not-a-directory".utf8).write(to: directory)
        try rejects("failed persistence is surfaced") { _ = try ledger.begin(scope: scope, orderCode: "disk-failure", productID: "gems-one") }
        try FileManager.default.removeItem(at: directory)
        try FileManager.default.moveItem(at: backupDirectory, to: directory)
        ledger = try expectedGlazeProductID(directory: directory)
        try check(try ledger.existingResult(scope: scope, orderCode: "disk-failure", productID: "gems-one") == nil && ledger.pending(scope: scope, excluded: []).count == 20, "failed write preserves prior durable state")
        let file = directory.appendingPathComponent(scope.storageKey + ".json")
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
        try Data("broken".utf8).write(to: corruptDirectory.appendingPathComponent(scope.storageKey + ".json"))
        try rejects("corrupt persistent data is not an empty queue") { _ = try expectedGlazeProductID(directory: corruptDirectory) }
        let symlink = root.appendingPathComponent("symlink-ledger")
        try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: directory)
        try rejects("symlink store rejected") { _ = try expectedGlazeProductID(directory: symlink) }
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
        command = ["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5",
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
