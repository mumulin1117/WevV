#!/usr/bin/env python3
"""Run production purchase/capture/reconciliation methods with offline StoreKit doubles."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/WevVGlazePurchaseCoordinator.swift'


def method(source, marker):
    start = source.index(marker)
    brace = source.index('{', start)
    depth = 1
    end = brace + 1
    while depth:
        depth += (source[end] == '{') - (source[end] == '}')
        end += 1
    return source[start:end]


STUBS = r'''
enum VerificationResult<T> { case verified(T), unverified(T, Error) }
struct Product {
    enum ProductType { case consumable }
    enum PurchaseError: Error { case invalidQuantity, productUnavailable, purchaseNotAllowed, ineligibleForOffer, invalidOfferIdentifier, invalidOfferPrice, invalidOfferSignature, missingOfferParameters, futureError }
    enum PurchaseResult { case success(VerificationResult<Transaction>), userCancelled, pending }
    enum PurchaseOption: Hashable { case appAccountToken(UUID) }
    let id: String
    let type = ProductType.consumable
    @MainActor func purchase(options: Set<PurchaseOption>) async throws -> PurchaseResult {
        guard case .appAccountToken(let token) = options.first! else { fatalError() }
        Fixture.purchaseCalls += 1
        return try await Fixture.onPurchase(id, token)
    }
}
enum StoreKitError: Error { case userCancelled, notAvailableInStorefront, networkError, systemError, unknown }
struct Transaction {
    let id: UInt64
    let productID: String
    let appAccountToken: UUID?
    var revocationDate: Date? = nil
    let purchaseDate = Date()
    @MainActor static var unfinished: AsyncStream<VerificationResult<Transaction>> { stream(Fixture.unfinished) }
    @MainActor static var all: AsyncStream<VerificationResult<Transaction>> { stream(Fixture.history) }
    @MainActor static func stream(_ values: [VerificationResult<Transaction>]) -> AsyncStream<VerificationResult<Transaction>> {
        AsyncStream { continuation in values.forEach { continuation.yield($0) }; continuation.finish() }
    }
    @MainActor func finish() async { Fixture.finished.insert(id) }
}
enum SKPaymentQueue { static func canMakePayments() -> Bool { true } }
enum WevVGlazeProductRequest {
    @MainActor static func lookup(productID: String) async throws -> Product { Product(id: productID) }
}
enum WevVGlazeAppReceiptRequest {
    @MainActor static func read() async throws -> String {
        if Fixture.receiptFails { throw WevVGlazePurchaseError.transactionUnavailable }
        return Data("actual-app-receipt-fixture".utf8).base64EncodedString()
    }
}
enum AppStore {
    @MainActor static func sync() async throws { Fixture.syncCalls += 1; try Fixture.onSync() }
}
@MainActor enum Fixture {
    static var purchaseCalls = 0, syncCalls = 0
    static var receiptFails = false
    static var unfinished: [VerificationResult<Transaction>] = [], history: [VerificationResult<Transaction>] = []
    static var finished = Set<UInt64>()
    static var onPurchase: (String, UUID) async throws -> Product.PurchaseResult = { _, _ in .pending }
    static var onSync: () throws -> Void = {}
    static func reset() {
        purchaseCalls = 0; syncCalls = 0; receiptFails = false; unfinished = []; history = []; finished = []
        onPurchase = { _, _ in .pending }; onSync = {}
    }
}
@MainActor final class RetryProbe {
    var ledger: WevVGlazePurchaseLedger?
    var storageDirectory: URL?
    var startupFailure: Error?
    var busy = false
    var receiptTask: Task<String, Error>?
    var capturing: [String: Task<WevVGlazePurchaseMaterial?, Error>] = [:]
    var captureFailures: [String: (WevVGlazePurchaseScope, Error)] = [:]
    init(directory: URL) throws { ledger = try WevVGlazePurchaseLedger(directory: directory) }
'''

TESTS = r'''
@main struct RetryVerification {
    @MainActor static func main() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("wevv-retry-" + UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let scope = WevVGlazePurchaseScope(environmentID: "test|https://example.invalid", appID: "app", ownerID: "one")
        let params: [String: Any] = ["ownerId": "one", "orderCode": "order", "productId": "gems", "purpose": "diamonds"]
        var checks = 0
        func check(_ value: @autoclosure () throws -> Bool, _ label: String) throws {
            guard try value() else { throw NSError(domain: label, code: 1) }; checks += 1
        }
        func rejects(_ expected: WevVGlazePurchaseError, _ operation: () async throws -> [String: Any]) async throws {
            do { _ = try await operation() } catch let error as WevVGlazePurchaseError where error == expected { checks += 1; return }
            throw NSError(domain: "Expected " + expected.rawValue, code: 2)
        }
        func setup(_ name: String) throws -> RetryProbe { Fixture.reset(); return try RetryProbe(directory: root.appendingPathComponent(name)) }
        func buy(_ probe: RetryProbe, sync: Bool = false) async throws -> [String: Any] {
            try await probe.purchase(params: params, ownerID: "one", appID: "app", environmentID: scope.environmentID, allowStoreSyncRetry: sync)
        }

        let rejected = try setup("rejected")
        Fixture.onPurchase = { _, _ in throw Product.PurchaseError.purchaseNotAllowed }
        try await rejects(.storeKitFailed) { try await buy(rejected) }
        try check(try rejected.ledger!.attempts(scope: scope, orderCode: "order", productID: "gems").first?.phase == "failed", "rejection persisted as failed, not pending")
        Fixture.onPurchase = { _, _ in .pending }
        let retried = try await buy(rejected, sync: true)
        try check(retried["status"] as? String == "pending" && Fixture.purchaseCalls == 2 && Fixture.syncCalls == 0, "definite rejection safely permits a new purchase")
        _ = try await buy(rejected, sync: true)
        try check(Fixture.purchaseCalls == 2 && Fixture.syncCalls == 0, "genuine Ask to Buy stays pending without another sheet or auth")

        let ambiguous = try setup("ambiguous")
        Fixture.onPurchase = { _, _ in throw StoreKitError.networkError }
        try await rejects(.transactionUnavailable) { try await buy(ambiguous) }
        try check(try ambiguous.ledger!.attempts(scope: scope, orderCode: "order", productID: "gems").first?.phase == "uncertain", "network error persisted as uncertain")
        try await rejects(.transactionUnavailable) { try await buy(ambiguous) }
        try check(Fixture.purchaseCalls == 1 && Fixture.syncCalls == 0, "H5/default retry never invokes authenticated sync")
        try await rejects(.transactionUnavailable) { try await buy(ambiguous, sync: true) }
        try check(Fixture.purchaseCalls == 1 && Fixture.syncCalls == 1, "empty sync history cannot prove a failed purchase")
        let token = try ambiguous.ledger!.attempts(scope: scope, orderCode: "order", productID: "gems")[0].token
        Fixture.onSync = { Fixture.unfinished = [.verified(Transaction(id: 11, productID: "gems", appAccountToken: token))] }
        let late = try await buy(ambiguous, sync: true)
        try check(late["status"] as? String == "purchased" && late["transactionId"] as? String == "11" && Fixture.purchaseCalls == 1, "sync can recover original-token transaction without rebuy")
        try check(Fixture.finished.contains(11), "capture stores receipt before finish")
        try ambiguous.ledger!.acknowledge(scope: scope, transactionIDs: ["11"])
        try await rejects(.transactionUnavailable) { try await buy(ambiguous, sync: true) }
        try check(Fixture.purchaseCalls == 1, "ACKed order never buys again")

        let legacy = try setup("legacy")
        let legacyToken = try legacy.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        try await rejects(.transactionUnavailable) { try await buy(legacy, sync: true) }
        try check(Fixture.purchaseCalls == 0 && Fixture.syncCalls == 1, "legacy submitted cannot be migrated to failed on absent history")
        Fixture.history = [.verified(Transaction(id: 12, productID: "gems", appAccountToken: legacyToken))]
        let legacyRecovered = try await buy(legacy, sync: true)
        try check(legacyRecovered["status"] as? String == "purchased" && Fixture.purchaseCalls == 0, "legacy submitted recovers from finite history")

        let failedLate = try setup("failed-late")
        let oldToken = try failedLate.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        try failedLate.ledger!.mark(oldToken, phase: "failed")
        Fixture.unfinished = [.verified(Transaction(id: 13, productID: "gems", appAccountToken: oldToken))]
        let failedRecovered = try await buy(failedLate)
        try check(failedRecovered["status"] as? String == "purchased" && Fixture.purchaseCalls == 0, "late failed-token result beats retry")

        let racing = try setup("racing")
        Fixture.onPurchase = { product, token in
            _ = try racing.ledger!.capture(token: token, productID: product, transactionID: "14", receipt: Data("receipt".utf8).base64EncodedString(), state: "purchased", purchasedAt: Date())
            throw Product.PurchaseError.productUnavailable
        }
        let raced = try await buy(racing)
        try check(raced["transactionId"] as? String == "14", "observer capture cannot be downgraded by later purchase throw")

        let throwsAfterPayment = try setup("throws-after-payment")
        Fixture.onPurchase = { product, token in
            Fixture.unfinished = [.verified(Transaction(id: 17, productID: product, appAccountToken: token))]
            throw StoreKitError.systemError
        }
        let paid = try await buy(throwsAfterPayment)
        try check(paid["transactionId"] as? String == "17" && Fixture.purchaseCalls == 1 && Fixture.syncCalls == 0, "purchase throw reconciles a transaction already charged")

        let pendingRestart = try setup("pending-restart")
        let pendingToken = try pendingRestart.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        try pendingRestart.ledger!.mark(pendingToken, phase: "pending")
        let restarted = try RetryProbe(directory: root.appendingPathComponent("pending-restart"))
        let stillPending = try await buy(restarted, sync: true)
        try check(stillPending["status"] as? String == "pending" && Fixture.purchaseCalls == 0 && Fixture.syncCalls == 0, "Ask to Buy survives restart without another purchase")
        Fixture.unfinished = [.verified(Transaction(id: 18, productID: "gems", appAccountToken: pendingToken))]
        let approved = try await buy(restarted, sync: true)
        try check(approved["transactionId"] as? String == "18" && Fixture.purchaseCalls == 0, "late Ask to Buy approval recovers original order")

        let cancelled = try setup("cancelled")
        Fixture.onPurchase = { _, _ in throw StoreKitError.userCancelled }
        let cancellation = try await buy(cancelled)
        try check(cancellation["status"] as? String == "cancelled", "explicit StoreKit cancellation is not pending")
        Fixture.onPurchase = { _, _ in .userCancelled }
        _ = try await buy(cancelled)
        try check(Fixture.purchaseCalls == 2, "cancelled attempt can retry")

        let bad = try setup("unverified")
        let badToken = try bad.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        try bad.ledger!.mark(badToken, phase: "failed")
        Fixture.history = [.unverified(Transaction(id: 15, productID: "gems", appAccountToken: badToken), StoreKitError.unknown)]
        try await rejects(.transactionUnavailable) { try await buy(bad) }
        try check(Fixture.purchaseCalls == 0 && Fixture.finished.isEmpty, "unverified evidence blocks re-purchase and finish")

        let receipt = try setup("receipt")
        let receiptToken = try receipt.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        try receipt.ledger!.mark(receiptToken, phase: "failed")
        Fixture.history = [.verified(Transaction(id: 16, productID: "gems", appAccountToken: receiptToken))]
        Fixture.receiptFails = true
        try await rejects(.transactionUnavailable) { try await buy(receipt) }
        try check(Fixture.purchaseCalls == 0 && Fixture.finished.isEmpty, "missing receipt retains transaction without new charge")
        Fixture.receiptFails = false
        let receiptRecovered = try await buy(receipt)
        try check(receiptRecovered["status"] as? String == "purchased", "receipt failure remains recoverable")

        let syncFailure = try setup("sync-failure")
        _ = try syncFailure.ledger!.begin(scope: scope, orderCode: "order", productID: "gems")
        Fixture.onSync = { throw StoreKitError.systemError }
        try await rejects(.transactionUnavailable) { try await buy(syncFailure, sync: true) }
        try check(Fixture.purchaseCalls == 0, "sync failure never enables purchase")
        syncFailure.busy = true
        try await rejects(.paymentBusy) { try await buy(syncFailure) }
        print("PASS: \(checks) production-method purchase retry checks; no real StoreKit/server operations")
    }
}
'''


def main():
    original = SOURCE.read_text()
    production = original[original.index('final class WevVGlazePurchaseCoordinator {'):]
    markers = ['    func purchase(', '    private static func purchaseFailurePhase(',
               '    private func reconcile(', '    private func capture(',
               '    private func appReceipt(', '    private func readyLedger(']
    harness = STUBS + '\n'.join(method(production, marker) for marker in markers) + '\n}\n' + TESTS
    with tempfile.TemporaryDirectory(prefix='wevv-purchase-retry-') as temporary:
        temporary = Path(temporary)
        file = temporary / 'Retry.swift'
        file.write_text(original + '\n' + harness)
        binary = temporary / 'retry'
        subprocess.run(['xcrun', 'swiftc', '-parse-as-library', '-swift-version', '5', '-D', 'WEVV_PURCHASE_TESTING',
                        '-module-cache-path', str(temporary / 'modules'), str(file), '-o', str(binary)], check=True)
        subprocess.run([str(binary)], check=True)


if __name__ == '__main__':
    main()
