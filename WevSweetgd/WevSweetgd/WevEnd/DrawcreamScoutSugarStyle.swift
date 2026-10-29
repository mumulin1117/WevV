import CryptoKit
import Darwin
import Foundation
#if !WEVV_PURCHASE_TESTING
import StoreKit
import UIKit
#endif

// SDK 2 transaction ownership is established by the native session, never by a
// WebView supplied owner. No credential, order or receipt is written to logs.
enum donutDiaryFolio: String, Error, LocalizedError {
    case invalidParams = "INVALID_PARAMS"
    case paymentsDisabled = "PAYMENTS_DISABLED"
    case paymentBusy = "PAYMENT_BUSY"
    case productInvalid = "PRODUCT_INVALID"
    case productRequestFailed = "PRODUCT_REQUEST_FAILED"
    case storeKitFailed = "STOREKIT_FAILED"
    case transactionUnavailable = "TRANSACTION_UNAVAILABLE"
    case nativeFailed = "NATIVE_FAILED"

    nonisolated var errorDescription: String? {
        switch self {
        case .invalidParams: return "The purchase details are invalid. Please refresh and try again."
        case .paymentsDisabled: return "Purchases are disabled on this device."
        case .paymentBusy: return "Another purchase is already being processed."
        case .productInvalid: return "This App Store product is unavailable."
        case .productRequestFailed: return "App Store products could not be loaded. Please retry."
        case .storeKitFailed: return "The App Store could not complete this purchase. Please retry."
        case .transactionUnavailable: return "Your previous purchase needs confirmation. Please retry to check its status."
        case .nativeFailed: return "Purchase recovery data is unavailable. Please retry."
        }
    }
}

struct donutSnapshot: Codable, Equatable {
    let environmentID: String
    let appID: String
    let ownerID: String

    var storageKey: String {
        // Length framing prevents ambiguities in service/App/account tuples.
        let framed = [environmentID, appID, ownerID].map { "\($0.utf8.count):\($0)" }.joined()
        return SHA256.hash(data: Data(framed.utf8)).map { String(format: "%02x", $0) }.joined()
    }

    func validate() throws {
        guard !environmentID.isEmpty, environmentID.utf8.count <= 4096,
              !appID.isEmpty, appID.utf8.count <= 128,
              !ownerID.isEmpty, ownerID.utf8.count <= 128 else {
            throw donutDiaryFolio.invalidParams
        }
    }
}

enum donutcitrusMixerView {
    static func scope(params: [String: Any], ownerID: String, appID: String, environmentID: String) throws -> donutSnapshot {
        let scope = donutSnapshot(environmentID: environmentID, appID: appID, ownerID: ownerID)
        try scope.validate()
        guard nonempty(params["ownerId"], maximum: 128) == ownerID else { throw donutDiaryFolio.invalidParams }
        return scope
    }

    static func purchase(_ params: [String: Any]) throws -> (orderCode: String, productID: String) {
        guard Set(params.keys) == Set(["ownerId", "orderCode", "productId", "purpose"]),
              let orderCode = nonempty(params["orderCode"], maximum: 256),
              let productID = nonempty(params["productId"], maximum: 256),
              params["purpose"] as? String == "diamonds" else { throw donutDiaryFolio.invalidParams }
        return (orderCode, productID)
    }

    static func sync(_ params: [String: Any]) throws -> (acknowledged: [String], excluded: [String]) {
        guard Set(params.keys).isSubset(of: Set(["ownerId", "acknowledgedTransactionIds", "excludeTransactionIds"])) else {
            throw donutDiaryFolio.invalidParams
        }
        return (try transactionIDs(params["acknowledgedTransactionIds"]), try transactionIDs(params["excludeTransactionIds"]))
    }

    private static func nonempty(_ value: Any?, maximum: Int) -> String? {
        guard let value = value as? String, !value.isEmpty, value.utf8.count <= maximum,
              value == value.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) }) else { return nil }
        return value
    }

    private static func transactionIDs(_ value: Any?) throws -> [String] {
        guard let value else { return [] }
        guard let values = value as? [String], values.count <= 100,
              values.allSatisfy({ nonempty($0, maximum: 256) != nil }) else { throw donutDiaryFolio.invalidParams }
        return values
    }
}

private struct donutcitrusTrayButton: Codable {
    let accountToken: UUID
    let orderCode: String
    let productID: String
    let purpose: String
    let createdAt: Date
    var phase: String
    var acknowledgedTransactionIDs: Set<String>
}

struct doughScrollView {
    let token: UUID
    let phase: String
}

struct doughSession: Codable {
    let accountToken: UUID
    let orderCode: String
    let ownerID: String
    let productID: String
    let purpose: String
    let transactionID: String
    let receipt: String
    let state: String
    let purchasedAt: Date

    var bridgeValue: [String: Any] {
        ["store": "apple", "orderCode": orderCode, "ownerId": ownerID,
         "productId": productID, "purpose": purpose, "transactionId": transactionID,
         "receipt": receipt, "state": state]
    }
}

private struct doughmeltawayCrust: Codable {
    let version: Int
    let scope: donutSnapshot
    var intents: [donutcitrusTrayButton]
    var materials: [doughSession]
}

// Main actor serialization and atomic replacement prevent partial journal reads.
// In-memory snapshots are committed only after the durable write succeeds.
@MainActor
final class expectedGlazeProductID {
    static let maximumReceiptCharacters = 2_796_204
    private let directory: URL
    private var journals: [String: doughmeltawayCrust] = [:]

    init(directory: URL) throws {
        self.directory = directory
        try Self.preparePrivateDirectory(directory)
        for url in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.isRegularFileKey, .isSymbolicLinkKey]) {
            guard url.pathExtension == "json" else { continue }
            let values = try url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
            guard values.isRegularFile == true, values.isSymbolicLink != true else {
                throw donutDiaryFolio.nativeFailed
            }
            let journal = try JSONDecoder().decode(doughmeltawayCrust.self, from: Data(contentsOf: url))
            try journal.scope.validate()
            guard journal.version == 1, url.deletingPathExtension().lastPathComponent == journal.scope.storageKey,
                  journals[journal.scope.storageKey] == nil else {
                throw donutDiaryFolio.nativeFailed
            }
            try Self.validate(journal)
            journals[journal.scope.storageKey] = journal
            try Self.protectFile(url)
        }
        let allTokens = journals.values.flatMap { $0.intents.map(\.accountToken) }
        let allTransactions = journals.values.flatMap { journal in
            journal.materials.map(\.transactionID) + journal.intents.flatMap { Array($0.acknowledgedTransactionIDs) }
        }
        guard Set(allTokens).count == allTokens.count, Set(allTransactions).count == allTransactions.count else {
            throw donutDiaryFolio.nativeFailed
        }
    }

    func existingResult(scope: donutSnapshot, orderCode: String, productID: String) throws -> [String: Any]? {
        guard let journal = journals[scope.storageKey] else { return nil }
        let matching = journal.intents.filter { $0.orderCode == orderCode }
        guard matching.allSatisfy({ $0.productID == productID }) else {
            throw donutDiaryFolio.invalidParams
        }
        if let material = journal.materials.first(where: { $0.orderCode == orderCode }) {
            var result = material.bridgeValue
            result["status"] = "purchased"
            return result
        }
        // A delivered order must never trigger another App Store purchase.
        if matching.contains(where: { !$0.acknowledgedTransactionIDs.isEmpty }) {
            throw donutDiaryFolio.transactionUnavailable
        }
        if matching.contains(where: { $0.phase == "submitted" || $0.phase == "uncertain" || $0.phase == "captured" }) {
            // An interrupted/ambiguous attempt is not proof of Ask to Buy, nor permission to charge again.
            throw donutDiaryFolio.transactionUnavailable
        }
        if matching.contains(where: { $0.phase == "pending" }) {
            return ["status": "pending", "productId": productID]
        }
        return nil
    }

    func begin(scope: donutSnapshot, orderCode: String, productID: String) throws -> UUID {
        try scope.validate()
        let token = UUID()
        var journal = journals[scope.storageKey] ?? doughmeltawayCrust(version: 1, scope: scope, intents: [], materials: [])
        journal.intents.append(donutcitrusTrayButton(accountToken: token, orderCode: orderCode,
                                                    productID: productID, purpose: "diamonds", createdAt: Date(),
                                                    phase: "submitted", acknowledgedTransactionIDs: []))
        try save(journal)
        return token
    }

    func mark(_ token: UUID, phase: String) throws {
        guard let location = locate(token) else { throw donutDiaryFolio.transactionUnavailable }
        var journal = location.journal
        // Transaction.updates can win the race with the purchase result/error.
        // Never downgrade durable captured/acknowledged materials to a failure or pending state.
        if !journal.intents[location.index].acknowledgedTransactionIDs.isEmpty || journal.materials.contains(where: { $0.accountToken == token }) { return }
        journal.intents[location.index].phase = phase
        try save(journal)
    }

    func attempts(scope: donutSnapshot, orderCode: String, productID: String) throws -> [doughScrollView] {
        let matching = journals[scope.storageKey]?.intents.filter { $0.orderCode == orderCode } ?? []
        guard matching.allSatisfy({ $0.productID == productID }) else { throw donutDiaryFolio.invalidParams }
        return matching.map { doughScrollView(token: $0.accountToken, phase: $0.phase) }
    }

    func scope(for token: UUID) -> donutSnapshot? { locate(token)?.journal.scope }

    func owns(token: UUID, productID: String) -> Bool {
        guard let location = locate(token) else { return false }
        return location.journal.intents[location.index].productID == productID
    }

    func knownMaterial(token: UUID, transactionID: String) -> doughSession? {
        locate(token)?.journal.materials.first { $0.transactionID == transactionID }
    }

    func isAcknowledged(token: UUID, transactionID: String) -> Bool {
        guard let location = locate(token) else { return false }
        return location.journal.intents[location.index].acknowledgedTransactionIDs.contains(transactionID)
    }

    func capture(token: UUID, productID: String, transactionID: String, receipt: String,
                 state: String, purchasedAt: Date) throws -> doughSession {
        guard let location = locate(token), !transactionID.isEmpty,
              location.journal.intents[location.index].productID == productID,
              state == "purchased" || state == "restored",
              let receiptData = Data(base64Encoded: receipt), !receiptData.isEmpty else {
            throw donutDiaryFolio.transactionUnavailable
        }
        let intent = location.journal.intents[location.index]
        guard !intent.acknowledgedTransactionIDs.contains(transactionID) else {
            throw donutDiaryFolio.transactionUnavailable
        }
        if let material = location.journal.materials.first(where: { $0.transactionID == transactionID }) {
            guard material.accountToken == token, material.productID == productID else {
                throw donutDiaryFolio.transactionUnavailable
            }
            return material
        }
        // Transaction IDs are Apple-wide; a transaction cannot be reassigned.
        guard !journals.values.contains(where: { $0.materials.contains(where: { $0.transactionID == transactionID }) || $0.intents.contains(where: { $0.acknowledgedTransactionIDs.contains(transactionID) }) }) else {
            throw donutDiaryFolio.transactionUnavailable
        }
        let material = doughSession(accountToken: token, orderCode: intent.orderCode,
                                                ownerID: location.journal.scope.ownerID, productID: productID,
                                                purpose: intent.purpose, transactionID: transactionID,
                                                receipt: receipt, state: state, purchasedAt: purchasedAt)
        var journal = location.journal
        journal.materials.append(material)
        journal.intents[location.index].phase = "captured"
        try save(journal)
        return material
    }

    func acknowledge(scope: donutSnapshot, transactionIDs: [String]) throws {
        guard var journal = journals[scope.storageKey], !transactionIDs.isEmpty else { return }
        let requested = Set(transactionIDs)
        let acknowledged = journal.materials.filter { requested.contains($0.transactionID) }
        guard !acknowledged.isEmpty else { return }
        for material in acknowledged {
            guard let index = journal.intents.firstIndex(where: { $0.accountToken == material.accountToken }) else {
                throw donutDiaryFolio.nativeFailed
            }
            journal.intents[index].acknowledgedTransactionIDs.insert(material.transactionID)
        }
        journal.materials.removeAll { requested.contains($0.transactionID) }
        // Receipt material is removed only by this durable H5 delivery ACK.
        try save(journal)
    }

    func pending(scope: donutSnapshot, excluded: [String]) throws -> [[String: Any]] {
        guard let journal = journals[scope.storageKey] else { return [] }
        let excludedIDs = Set(excluded)
        let materials = journal.materials.filter { !excludedIDs.contains($0.transactionID) }.sorted {
            if $0.purchasedAt == $1.purchasedAt { return $0.transactionID < $1.transactionID }
            return $0.purchasedAt < $1.purchasedAt
        }
        var count = 0
        var result: [[String: Any]] = []
        for material in materials {
            guard result.count < 20 else { break }
            let length = material.receipt.utf8.count
            guard length <= Self.maximumReceiptCharacters else { throw donutDiaryFolio.transactionUnavailable }
            guard count + length <= Self.maximumReceiptCharacters else { break }
            result.append(material.bridgeValue)
            count += length
        }
        return result
    }

    private func locate(_ token: UUID) -> (journal: doughmeltawayCrust, index: Int)? {
        for journal in journals.values {
            if let index = journal.intents.firstIndex(where: { $0.accountToken == token }) { return (journal, index) }
        }
        return nil
    }

    private func save(_ journal: doughmeltawayCrust) throws {
        try Self.validate(journal)
        let url = directory.appendingPathComponent(journal.scope.storageKey + ".json", isDirectory: false)
        let temporary = directory.appendingPathComponent("." + UUID().uuidString + ".pending", isDirectory: false)
        defer { try? FileManager.default.removeItem(at: temporary) }
        let data = try JSONEncoder().encode(journal)
        // Set permissions and backup exclusion before atomic rename. A failure
        // before rename cannot replace a previously valid journal.
        #if os(iOS)
        try data.write(to: temporary, options: [.withoutOverwriting, .completeFileProtectionUntilFirstUserAuthentication])
        #else
        try data.write(to: temporary, options: .withoutOverwriting)
        #endif
        try Self.protectFile(temporary)
        let handle = try FileHandle(forWritingTo: temporary)
        do { try handle.synchronize(); try handle.close() }
        catch { try? handle.close(); throw error }
        let replaced = temporary.withUnsafeFileSystemRepresentation { temporaryPath in
            url.withUnsafeFileSystemRepresentation { destinationPath in
                guard let temporaryPath, let destinationPath else { return Int32(-1) }
                return Darwin.rename(temporaryPath, destinationPath)
            }
        }
        guard replaced == 0 else { throw donutDiaryFolio.nativeFailed }
        // The file is durable before finish; persist its directory entry too.
        let directoryHandle = Darwin.open(directory.path, O_RDONLY)
        guard directoryHandle >= 0 else { throw donutDiaryFolio.nativeFailed }
        defer { Darwin.close(directoryHandle) }
        guard Darwin.fsync(directoryHandle) == 0 else { throw donutDiaryFolio.nativeFailed }
        journals[journal.scope.storageKey] = journal
    }

    private static func validate(_ journal: doughmeltawayCrust) throws {
        guard Set(journal.intents.map(\.accountToken)).count == journal.intents.count,
              Set(journal.materials.map(\.transactionID)).count == journal.materials.count else {
            throw donutDiaryFolio.nativeFailed
        }
        for intent in journal.intents {
            guard !intent.orderCode.isEmpty, !intent.productID.isEmpty, intent.purpose == "diamonds",
                  ["submitted", "pending", "cancelled", "captured", "failed", "uncertain"].contains(intent.phase) else {
                throw donutDiaryFolio.nativeFailed
            }
        }
        for material in journal.materials {
            guard let intent = journal.intents.first(where: { $0.accountToken == material.accountToken }),
                  intent.productID == material.productID, intent.orderCode == material.orderCode,
                  journal.scope.ownerID == material.ownerID, material.purpose == "diamonds",
                  material.state == "purchased" || material.state == "restored",
                  !intent.acknowledgedTransactionIDs.contains(material.transactionID),
                  !material.transactionID.isEmpty, let decoded = Data(base64Encoded: material.receipt), !decoded.isEmpty else {
                throw donutDiaryFolio.nativeFailed
            }
        }
    }

    private static func preparePrivateDirectory(_ url: URL) throws {
        let manager = FileManager.default
        if manager.fileExists(atPath: url.path) {
            let values = try url.resourceValues(forKeys: [.isDirectoryKey, .isSymbolicLinkKey])
            guard values.isDirectory == true, values.isSymbolicLink != true else { throw donutDiaryFolio.nativeFailed }
        } else {
            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
        }
        try manager.setAttributes([.posixPermissions: 0o700], ofItemAtPath: url.path)
        var protectedURL = url
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try protectedURL.setResourceValues(values)
        #if os(iOS)
        protectedURL.removeAllCachedResourceValues()
        guard try protectedURL.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup == true else {
            throw donutDiaryFolio.nativeFailed
        }
        #endif
    }

    private static func protectFile(_ url: URL) throws {
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: url.path)
        #if os(iOS)
        try FileManager.default.setAttributes([.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: url.path)
        #if !targetEnvironment(simulator)
        let protection = try FileManager.default.attributesOfItem(atPath: url.path)[.protectionKey]
        guard (protection as? FileProtectionType)?.rawValue == FileProtectionType.completeUntilFirstUserAuthentication.rawValue
                || protection as? String == FileProtectionType.completeUntilFirstUserAuthentication.rawValue else {
            throw donutDiaryFolio.nativeFailed
        }
        #endif
        #endif
        var protectedURL = url
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try protectedURL.setResourceValues(values)
        #if os(iOS)
        protectedURL.removeAllCachedResourceValues()
        guard try protectedURL.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup == true else {
            throw donutDiaryFolio.nativeFailed
        }
        #endif
    }
}

#if !WEVV_PURCHASE_TESTING
@MainActor
final class DrawcreamScoutSugarStyle {
    static let shared = DrawcreamScoutSugarStyle()
    private var ledger: expectedGlazeProductID?
    private var storageDirectory: URL?
    private var startupFailure: Error?
    private var updateTask: Task<Void, Never>?
    private var unfinishedTask: Task<Void, Never>?
    private var busy = false
    private var receiptTask: Task<String, Error>?
    private var capturing: [String: Task<doughSession?, Error>] = [:]
    private var captureFailures: [String: (donutSnapshot, Error)] = [:]
    private var protectedDataObserver: NSObjectProtocol?

    private init() {
        do {
            let support = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = support.appendingPathComponent("WevVSDK2Transactions", isDirectory: true)
            storageDirectory = directory
            ledger = try expectedGlazeProductID(directory: directory)
        } catch { startupFailure = error }
        startObserving()
        protectedDataObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self, (try? self.readyLedger()) != nil else { return }
                for await result in Transaction.unfinished { await self.receive(result) }
            }
        }
    }

    static func bridgeErrorCode(_ error: Error) -> String {
        (error as? donutDiaryFolio)?.rawValue ?? donutDiaryFolio.nativeFailed.rawValue
    }

    // Calling this at application launch recovers transactions even if no H5
    // container is opened during that launch. Closing a WebView never stops it.
    func startObserving() {
        if updateTask == nil {
            updateTask = Task { [weak self] in
                for await result in Transaction.updates {
                    guard let self else { return }
                    await self.receive(result)
                }
            }
        }
        if unfinishedTask == nil {
            unfinishedTask = Task { [weak self] in
                for await result in Transaction.unfinished {
                    guard let self else { return }
                    await self.receive(result)
                }
            }
        }
    }

    func purchase(params: [String: Any], ownerID: String, appID: String, environmentID: String,
                  allowStoreSyncRetry: Bool = false) async throws -> [String: Any] {
        let scope = try donutcitrusMixerView.scope(params: params, ownerID: ownerID, appID: appID, environmentID: environmentID)
        let (orderCode, productID) = try donutcitrusMixerView.purchase(params)
        let ledger = try readyLedger()
        guard !busy else { throw donutDiaryFolio.paymentBusy }
        busy = true
        defer { busy = false }
        let attempts = try ledger.attempts(scope: scope, orderCode: orderCode, productID: productID)
        if !attempts.isEmpty {
            try await reconcile(attempts: attempts, productID: productID)
            do {
                if let existing = try ledger.existingResult(scope: scope, orderCode: orderCode, productID: productID) { return existing }
            } catch donutDiaryFolio.transactionUnavailable {
                // Only the native purchase button opts in. Background recovery
                // and H5 bridge requests never prompt for App Store credentials.
                // Empty history cannot disprove an interrupted Ask to Buy request.
                if allowStoreSyncRetry && attempts.contains(where: { $0.phase == "submitted" || $0.phase == "uncertain" }) {
                    do { try await AppStore.sync() }
                    catch { throw donutDiaryFolio.transactionUnavailable }
                    try await reconcile(attempts: attempts, productID: productID)
                    if let existing = try ledger.existingResult(scope: scope, orderCode: orderCode, productID: productID) { return existing }
                }
                throw donutDiaryFolio.transactionUnavailable
            }
        }
        guard SKPaymentQueue.canMakePayments() else { throw donutDiaryFolio.paymentsDisabled }
        let product: Product
        do { product = try await fallbackMark.lookup(productID: productID) }
        catch let error as donutDiaryFolio { throw error }
        catch { throw donutDiaryFolio.productRequestFailed }
        guard product.id == productID, product.type == .consumable else { throw donutDiaryFolio.productInvalid }
        try Task.checkCancellation()
        // Save scope, business order and appAccountToken BEFORE presenting the
        // App Store sheet. This association survives process death/Ask to Buy.
        let accountToken = try ledger.begin(scope: scope, orderCode: orderCode, productID: productID)
        let result: Product.PurchaseResult
        do { result = try await product.purchase(options: [.appAccountToken(accountToken)]) }
        catch {
            let phase = Self.purchaseFailurePhase(error)
            try ledger.mark(accountToken, phase: phase)
            // A verified update can arrive before purchase() throws. Capture it
            // under the original token before deciding whether retry is safe.
            try await reconcile(attempts: try ledger.attempts(scope: scope, orderCode: orderCode, productID: productID), productID: productID)
            if let existing = try ledger.existingResult(scope: scope, orderCode: orderCode, productID: productID) { return existing }
            if phase == "cancelled" { return ["status": "cancelled", "productId": productID] }
            throw donutDiaryFolio.storeKitFailed
        }
        switch result {
        case .success(let verification):
            guard case .verified(let transaction) = verification,
                  transaction.appAccountToken == accountToken, transaction.productID == productID else {
                throw donutDiaryFolio.transactionUnavailable
            }
            guard let material = try await capture(transaction) else { throw donutDiaryFolio.transactionUnavailable }
            var response = material.bridgeValue
            response["status"] = "purchased"
            return response
        case .userCancelled:
            try ledger.mark(accountToken, phase: "cancelled")
            if let existing = try ledger.existingResult(scope: scope, orderCode: orderCode, productID: productID) { return existing }
            return ["status": "cancelled", "productId": productID]
        case .pending:
            try ledger.mark(accountToken, phase: "pending")
            guard let existing = try ledger.existingResult(scope: scope, orderCode: orderCode, productID: productID) else {
                throw donutDiaryFolio.transactionUnavailable
            }
            return existing
        @unknown default:
            try ledger.mark(accountToken, phase: "uncertain")
            throw donutDiaryFolio.transactionUnavailable
        }
    }

    // These errors explicitly reject a purchase. Network/system/unknown errors
    // and task cancellation are ambiguous; none authorize another charge.
    private static func purchaseFailurePhase(_ error: Error) -> String {
        if let error = error as? Product.PurchaseError {
            switch error {
            case .invalidQuantity, .productUnavailable, .purchaseNotAllowed, .ineligibleForOffer,
                 .invalidOfferIdentifier, .invalidOfferPrice, .invalidOfferSignature, .missingOfferParameters:
                return "failed"
            default: return "uncertain"
            }
        }
        if let error = error as? StoreKitError {
            switch error {
            case .userCancelled: return "cancelled"
            case .notAvailableInStorefront: return "failed"
            default: return "uncertain"
            }
        }
        return "uncertain"
    }

    private func reconcile(attempts: [doughScrollView], productID: String) async throws {
        let tokens = Set(attempts.map(\.token))
        func consume(_ result: VerificationResult<Transaction>) async throws {
            let transaction: Transaction
            switch result {
            case .verified(let value): transaction = value
            case .unverified(let value, _):
                if let token = value.appAccountToken, tokens.contains(token) { throw donutDiaryFolio.transactionUnavailable }
                return
            }
            guard let token = transaction.appAccountToken, tokens.contains(token) else { return }
            guard transaction.productID == productID else { throw donutDiaryFolio.transactionUnavailable }
            _ = try await capture(transaction)
        }
        // These are finite snapshots. Later approvals are still owned by the
        // independent updates observer, including tokens from failed attempts.
        for await result in Transaction.unfinished {
            try Task.checkCancellation()
            try await consume(result)
        }
        for await result in Transaction.all {
            try Task.checkCancellation()
            try await consume(result)
        }
    }

    func syncTransactions(params: [String: Any], ownerID: String, appID: String, environmentID: String) async throws -> [String: Any] {
        let scope = try donutcitrusMixerView.scope(params: params, ownerID: ownerID, appID: appID, environmentID: environmentID)
        let (acknowledged, excluded) = try donutcitrusMixerView.sync(params)
        let ledger = try readyLedger()
        try Task.checkCancellation()
        try ledger.acknowledge(scope: scope, transactionIDs: acknowledged)
        for await result in Transaction.unfinished {
            try Task.checkCancellation()
            // Receiving another account's transaction still persists it under
            // its original intent, but cannot return it to this caller.
            await receive(result)
        }
        try Task.checkCancellation()
        if let failure = captureFailures.values.first(where: { $0.0 == scope }) { throw failure.1 }
        return ["transactions": try ledger.pending(scope: scope, excluded: excluded)]
    }

    private func receive(_ result: VerificationResult<Transaction>) async {
        guard let ledger = try? readyLedger() else { return }
        switch result {
        case .verified(let transaction):
            guard let token = transaction.appAccountToken, let scope = ledger.scope(for: token) else { return }
            do {
                _ = try await capture(transaction)
                captureFailures.removeValue(forKey: String(transaction.id))
            } catch { captureFailures[String(transaction.id)] = (scope, error) }
        case .unverified(let transaction, _):
            if let token = transaction.appAccountToken, let scope = ledger.scope(for: token) {
                captureFailures[String(transaction.id)] = (scope, donutDiaryFolio.transactionUnavailable)
            }
        }
    }

    private func capture(_ transaction: Transaction) async throws -> doughSession? {
        let transactionID = String(transaction.id)
        if let task = capturing[transactionID] { return try await task.value }
        let task = Task { @MainActor () throws -> doughSession? in
            let ledger = try self.readyLedger()
            guard let token = transaction.appAccountToken,
                  ledger.owns(token: token, productID: transaction.productID), transaction.revocationDate == nil else {
                throw donutDiaryFolio.transactionUnavailable
            }
            if ledger.isAcknowledged(token: token, transactionID: transactionID) {
                await transaction.finish()
                return nil
            }
            if let material = ledger.knownMaterial(token: token, transactionID: transactionID) {
                await transaction.finish()
                return material
            }
            let receipt = try await self.appReceipt()
            // StoreKit 2 purchases and delayed/unfinished purchase updates are
            // purchased, not restored. No restore is fabricated during replay.
            let material = try ledger.capture(token: token, productID: transaction.productID,
                                              transactionID: transactionID, receipt: receipt,
                                              state: "purchased", purchasedAt: transaction.purchaseDate)
            // A failed read or atomic persistence leaves the transaction
            // unfinished, so the independent observer can recover it later.
            await transaction.finish()
            return material
        }
        capturing[transactionID] = task
        defer { capturing.removeValue(forKey: transactionID) }
        let material = try await task.value
        // Direct purchase completion may recover an earlier observer failure;
        // do not retain that obsolete failure after its transaction was saved.
        captureFailures.removeValue(forKey: transactionID)
        return material
    }

    private func appReceipt() async throws -> String {
        if let task = receiptTask { return try await task.value }
        let task = Task { @MainActor in try await glazeAvatar.read() }
        receiptTask = task
        defer { receiptTask = nil }
        return try await task.value
    }

    private func readyLedger() throws -> expectedGlazeProductID {
        if let ledger, startupFailure == nil { return ledger }
        // A protected-data failure during launch may be recoverable after the
        // first unlock. Corrupt files still fail instead of becoming an empty box.
        do {
            guard let storageDirectory else { throw donutDiaryFolio.nativeFailed }
            let restored = try expectedGlazeProductID(directory: storageDirectory)
            ledger = restored
            startupFailure = nil
            return restored
        } catch { throw donutDiaryFolio.nativeFailed }
    }

}

// A continuation race gives product lookup its documented 30 second timeout;
// waiting for a cancelled structured task group could otherwise delay return.
@MainActor
private final class fallbackMark {
    private var continuation: CheckedContinuation<Product, Error>?
    private var query: Task<Void, Never>?
    private var timeout: Task<Void, Never>?

    static func lookup(productID: String) async throws -> Product {
        let request = fallbackMark()
        return try await request.run(productID: productID)
    }

    private func run(productID: String) async throws -> Product {
        try await withTaskCancellationHandler(operation: {
            try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                query = Task { @MainActor in
                    do {
                        let products = try await Product.products(for: [productID])
                        guard let product = products.first(where: { $0.id == productID }) else {
                            self.complete(.failure(donutDiaryFolio.productInvalid)); return
                        }
                        self.complete(.success(product))
                    } catch { self.complete(.failure(donutDiaryFolio.productRequestFailed)) }
                }
                timeout = Task { @MainActor in
                    do { try await Task.sleep(nanoseconds: 30_000_000_000) } catch { return }
                    self.complete(.failure(donutDiaryFolio.productRequestFailed))
                }
                if Task.isCancelled { complete(.failure(CancellationError())) }
            }
        }, onCancel: { Task { @MainActor in self.complete(.failure(CancellationError())) } })
    }

    private func complete(_ result: Result<Product, Error>) {
        guard let continuation else { return }
        self.continuation = nil
        query?.cancel(); timeout?.cancel()
        query = nil; timeout = nil
        continuation.resume(with: result)
    }
}

@MainActor
private final class glazeAvatar: NSObject, SKRequestDelegate {
    private var request: SKReceiptRefreshRequest?
    private var continuation: CheckedContinuation<String, Error>?
    private var timeout: Task<Void, Never>?

    static func read() async throws -> String {
        if let receipt = onDiskReceipt() { return receipt }
        let refresher = glazeAvatar()
        return try await refresher.refresh()
    }

    private static func onDiskReceipt() -> String? {
        guard let url = Bundle.main.appStoreReceiptURL,
              let data = try? Data(contentsOf: url), !data.isEmpty else { return nil }
        // This is the binary App Store receipt, never StoreKit 2 jwsRepresentation.
        return data.base64EncodedString()
    }

    private func refresh() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let request = SKReceiptRefreshRequest(receiptProperties: nil)
            self.request = request
            request.delegate = self
            request.start()
            timeout = Task { @MainActor in
                do { try await Task.sleep(nanoseconds: 30_000_000_000) } catch { return }
                self.complete(.failure(donutDiaryFolio.transactionUnavailable))
            }
        }
    }

    nonisolated func requestDidFinish(_ request: SKRequest) {
        let identifier = ObjectIdentifier(request)
        Task { @MainActor in
            guard let active = self.request, ObjectIdentifier(active) == identifier else { return }
            if let receipt = Self.onDiskReceipt() { self.complete(.success(receipt)) }
            else { self.complete(.failure(donutDiaryFolio.transactionUnavailable)) }
        }
    }

    nonisolated func request(_ request: SKRequest, didFailWithError error: Error) {
        let identifier = ObjectIdentifier(request)
        Task { @MainActor in
            guard let active = self.request, ObjectIdentifier(active) == identifier else { return }
            self.complete(.failure(donutDiaryFolio.transactionUnavailable))
        }
    }

    private func complete(_ result: Result<String, Error>) {
        guard let continuation else { return }
        self.continuation = nil
        timeout?.cancel(); timeout = nil
        request?.delegate = nil; request?.cancel(); request = nil
        continuation.resume(with: result)
    }
}
#endif
