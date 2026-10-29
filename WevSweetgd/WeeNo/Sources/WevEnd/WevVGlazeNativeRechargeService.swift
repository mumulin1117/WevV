//import Foundation
//import CoreFoundation
//import CryptoKit
//import Darwin
//
///// Native wallet orchestration. StoreKit observation and receipts remain exclusively in the SDK2 coordinator.
//@MainActor
//final class WevVGlazeNativeRechargeService {
//    struct Package {
//        let productID: String
//        let skuID: Int64
//        let channelID: Int64
//        let paymentMethodType: String
//        let showType: Int
//        let diamonds: Int
//        let giftDiamonds: Int
//        let firstChargeDiamonds: Int
//        let bought: Bool
//        let recommended: Bool
//        let price: Decimal
//        let currencySymbol: String
//    }
//    struct Context: Equatable {
//        let ownerID: String
//        let appID: String
//        let environmentID: String
//        let sessionEpoch: Int
//        var purchaseScope: WevVGlazePurchaseScope { WevVGlazePurchaseScope(environmentID: environmentID, appID: appID, ownerID: ownerID) }
//    }
//    enum Outcome {
//        case cancelled
//        case pending
//        case credited(balance: Int)
//    }
//    struct RecoveryReport {
//        let creditedTransactions: Int
//        let pendingOrders: Int
//        let skippedForeignTransactions: Int
//        let failedCodes: [String]
//        let limitReached: Bool
//        let balance: Int?
//    }
//    enum RechargeError: Error, LocalizedError, Sendable {
//        case invalidConfiguration
//        case invalidResponse
//        case unavailableProduct
//        case paymentBusy
//        case sessionChanged
//        case storageUnavailable
//        case confirmationPending
//        nonisolated var errorDescription: String? {
//            switch self {
//            case .invalidConfiguration: return "The payment service configuration is unavailable."
//            case .invalidResponse: return "The payment service returned an invalid response. Please retry."
//            case .unavailableProduct: return "This recharge package is unavailable. Please refresh and try again."
//            case .paymentBusy: return "Another purchase is already being processed."
//            case .sessionChanged: return "Your account changed. Sign in to the original account to finish this purchase."
//            case .storageUnavailable: return "Purchase recovery data could not be saved. Please try again."
//            case .confirmationPending: return "Your purchase is still being confirmed. Retry to check this order without purchasing again."
//            }
//        }
//    }
//
//    typealias Request = @MainActor (String, [String: Any]) async throws -> Data
//    typealias Purchase = @MainActor ([String: Any], Context) async throws -> [String: Any]
//    typealias Sync = @MainActor ([String: Any], Context) async throws -> [String: Any]
//    static let shared = WevVGlazeNativeRechargeService()
//    private let request: Request
//    private let purchaseProduct: Purchase
//    private let syncTransactions: Sync
//    private let trustedContext: @MainActor () async throws -> Context
//    private let contextIsCurrent: @MainActor (Context) -> Bool
//    private let refreshBalance: @MainActor () async throws -> Int
//    private let storageDirectory: URL?
//    private var journal: NativeOrders?
//    private var busy = false
//
//    init(request: Request? = nil, purchase: Purchase? = nil, sync: Sync? = nil,
//         context: (@MainActor () async throws -> Context)? = nil,
//         isCurrent: (@MainActor (Context) -> Bool)? = nil,
//         balance: (@MainActor () async throws -> Int)? = nil, storageDirectory: URL? = nil) {
//        self.request = request ?? { path, body in
//            try await WevVGlazeRuntime.shared.opi(path: path, body: JSONSerialization.data(withJSONObject: body), authenticated: true)
//        }
//        purchaseProduct = purchase ?? { params, context in
//            try await WevVGlazePurchaseCoordinator.shared.purchase(params: params, ownerID: context.ownerID, appID: context.appID, environmentID: context.environmentID, allowStoreSyncRetry: true)
//        }
//        syncTransactions = sync ?? { params, context in
//            try await WevVGlazePurchaseCoordinator.shared.syncTransactions(params: params, ownerID: context.ownerID, appID: context.appID, environmentID: context.environmentID)
//        }
//        trustedContext = context ?? {
//            let runtime = WevVGlazeRuntime.shared
//            let account = try await runtime.validSignedInSession()
//            guard WevVGlazeSessionStore.shared.isTasterReady, account.vanillaBeanIcing > 0, !runtime.appID.isEmpty, !runtime.environmentID.isEmpty else { throw RechargeError.invalidConfiguration }
//            return Context(ownerID: String(account.vanillaBeanIcing), appID: runtime.appID, environmentID: runtime.environmentID, sessionEpoch: WevVGlazeSessionStore.shared.sessionEpoch)
//        }
//        contextIsCurrent = isCurrent ?? { context in
//            let store = WevVGlazeSessionStore.shared, runtime = WevVGlazeRuntime.shared
//            return store.isTasterReady && store.sessionEpoch == context.sessionEpoch && runtime.environmentID == context.environmentID
//                && runtime.appID == context.appID && store.currentGlazeCredentials.map { String($0.vanillaBeanIcing) } == context.ownerID
//        }
//        refreshBalance = balance ?? { try await WevVGlazeSessionRepository.pastryTrailDiary.coldBrewTasting().glazeVaultCount }
//        self.storageDirectory = storageDirectory
//    }
//
//    /// Returns only actual server SKUs with an unambiguous iOS payment channel. No filler products are created.
//    func packages() async throws -> [Package] {
//        let context = try await trustedContext()
//        return try await packages(context: context)
//    }
//
//    func purchase(productID: String) async throws -> Outcome {
//        guard !busy else { throw RechargeError.paymentBusy }
//        guard Self.nonempty(productID) != nil else { throw RechargeError.unavailableProduct }
//        busy = true; defer { busy = false }
//        let context = try await trustedContext()
//        try check(context)
//        let store = try orders()
//        var order: NativeOrder
//        if let existing = try store.records(context.purchaseScope).last(where: { $0.productID == productID && ["created", "pending", "verified"].contains($0.phase) }) {
//            order = existing
//            if order.phase == "verified" { return .credited(balance: try await finishVerified(order, context: context)) }
//            let state = try await orderState(order.orderCode, context: context)
//            if state == 2 {
//                // H5 may already have delivered this native-origin order through the shared inbox.
//                // Never buy an already completed business order a second time.
//                let batch = try await sync(context: context, acknowledged: [], excluded: [])
//                if let material = batch.first(where: { $0["orderCode"] as? String == order.orderCode }) {
//                    return .credited(balance: try await deliver(material, order: order, context: context))
//                }
//                let balance = try await balance(context)
//                order.phase = "delivered"; try store.upsert(order, scope: context.purchaseScope)
//                return .credited(balance: balance)
//            }
//        } else {
//            guard let package = try await packages(context: context).first(where: { $0.productID == productID }) else { throw RechargeError.unavailableProduct }
//            let response = try Self.object(try await send("/_v2/pay/createOrder", ["vipFlag": 0, "skuInfoId": package.channelID, "productId": package.productID,
//                                                                                 "paymentMethodType": package.paymentMethodType, "showType": package.showType], context: context))
//            guard let orderCode = Self.nonempty(response["orderCode"]), orderCode.utf8.count <= 256,
//                  let channelType = Self.text(response["channelType"]), Self.isAppleChannel(channelType) else { throw RechargeError.invalidResponse }
//            order = NativeOrder(orderCode: orderCode, productID: package.productID, phase: "created", createdAt: Date(), verifiedTransactionIDs: [], acknowledgedTransactionIDs: [])
//            // Persist native origin BEFORE StoreKit; H5-created orders never enter this journal.
//            try store.upsert(order, scope: context.purchaseScope)
//        }
//        try check(context)
//        let result = try await purchaseProduct(["orderCode": order.orderCode, "ownerId": context.ownerID, "productId": order.productID, "purpose": "diamonds"], context)
//        // Late transactions are already durable in the independent coordinator under their original owner.
//        try check(context)
//        guard result["productId"] as? String == order.productID, let status = result["status"] as? String else { throw RechargeError.invalidResponse }
//        switch status {
//        case "cancelled":
//            order.phase = "cancelled"; try store.upsert(order, scope: context.purchaseScope); return .cancelled
//        case "pending":
//            order.phase = "pending"; try store.upsert(order, scope: context.purchaseScope); return .pending
//        case "purchased": return .credited(balance: try await deliver(result, order: order, context: context))
//        default: throw RechargeError.invalidResponse
//        }
//    }
//
//    /// Reads the common inbox but verifies/ACKs only exact native-origin records for this App/service/account.
//    func recoverPending() async throws -> RecoveryReport {
//        guard !busy else { throw RechargeError.paymentBusy }
//        busy = true; defer { busy = false }
//        let context = try await trustedContext()
//        try check(context)
//        let store = try orders()
//        let records = try store.records(context.purchaseScope)
//        guard !records.isEmpty else { return RecoveryReport(creditedTransactions: 0, pendingOrders: 0, skippedForeignTransactions: 0, failedCodes: [], limitReached: false, balance: nil) }
//        var credited = 0, foreign = 0, codes: [String] = [], excluded = Set<String>(), lastBalance: Int?, limitReached = false
//        // Finish proofs persisted before an earlier failed balance refresh or ACK, without buying again.
//        for order in records where order.phase == "verified" {
//            do {
//                lastBalance = try await finishVerified(order, context: context)
//                credited += order.verifiedTransactionIDs.subtracting(order.acknowledgedTransactionIDs).count
//            }
//            catch {
//                try check(context)
//                codes.append(Self.errorCode(error))
//            }
//        }
//        for index in 0..<5 {
//            let batch = try await sync(context: context, acknowledged: [], excluded: Array(excluded))
//            if batch.isEmpty { break }
//            var added = false
//            for material in batch {
//                guard let transactionID = Self.nonempty(material["transactionId"]), let orderCode = Self.nonempty(material["orderCode"]),
//                      !excluded.contains(transactionID) else { throw RechargeError.invalidResponse }
//                added = true
//                guard let order = try store.records(context.purchaseScope).first(where: { $0.orderCode == orderCode }) else {
//                    // H5 origin: neither backend verification nor ACK is permitted here.
//                    excluded.insert(transactionID); foreign += 1; continue
//                }
//                do { lastBalance = try await deliver(material, order: order, context: context); credited += 1 }
//                catch {
//                    try check(context)
//                    codes.append(Self.errorCode(error)); excluded.insert(transactionID)
//                }
//            }
//            guard added else { throw RechargeError.invalidResponse }
//            if excluded.count >= 100 || index == 4 { limitReached = true; break }
//        }
//        let pending = try store.records(context.purchaseScope).filter { ["created", "pending", "verified"].contains($0.phase) }.count
//        return RecoveryReport(creditedTransactions: credited, pendingOrders: pending, skippedForeignTransactions: foreign, failedCodes: codes, limitReached: limitReached, balance: lastBalance)
//    }
//
//    private func packages(context: Context) async throws -> [Package] {
//        let root = try Self.object(try await send("/_v2/pay/rechargeList", [:], context: context))
//        guard let rows = root["rows"] as? [[String: Any]] else { throw RechargeError.invalidResponse }
//        var products = Set<String>(), result: [Package] = []
//        for row in rows {
//            guard let product = Self.nonempty(row["batchNo"]), product.utf8.count <= 256,
//                  let skuID = Self.positiveID(row["id"]), let channels = row["channels"] as? [[String: Any]],
//                  let diamonds = Self.integer(row["diamondNum"]), diamonds > 0 else { throw RechargeError.invalidResponse }
//            let ios = channels.filter { Self.text($0["channelType"]).map(Self.isAppleChannel) == true }
//            if ios.isEmpty { continue }
//            guard ios.count == 1, let channel = ios.first, let channelID = Self.positiveID(channel["id"]),
//                  let method = Self.nonempty(channel["payMethodType"]),
//                  let priceText = Self.text(row["convertPrice"]) ?? Self.text(row["price"]),
//                  let price = Decimal(string: priceText, locale: Locale(identifier: "en_US_POSIX")), price >= 0,
//                  products.insert(product).inserted else { throw RechargeError.invalidResponse }
//            let showType = Self.integer(channel["showType"]) ?? 2
//            guard showType == 1 || showType == 2 else { throw RechargeError.invalidResponse }
//            result.append(Package(productID: product, skuID: skuID, channelID: channelID, paymentMethodType: method, showType: showType,
//                                  diamonds: diamonds, giftDiamonds: max(0, Self.integer(row["giveDiamondNum"]) ?? 0),
//                                  firstChargeDiamonds: max(0, Self.integer(row["firstChargeGive"]) ?? 0), bought: Self.boolean(row["bought"]) ?? false,
//                                  recommended: Self.boolean(row["recommend"]) ?? false, price: price,
//                                  currencySymbol: Self.text(row["currencySymbol"]) ?? Self.text(root["currencySymbol"]) ?? ""))
//        }
//        return result
//    }
//
//    private func deliver(_ material: [String: Any], order: NativeOrder, context: Context) async throws -> Int {
//        try check(context)
//        guard material["store"] as? String == "apple", material["ownerId"] as? String == context.ownerID,
//              material["productId"] as? String == order.productID, material["orderCode"] as? String == order.orderCode,
//              material["purpose"] as? String == "diamonds", let state = material["state"] as? String, ["purchased", "restored"].contains(state),
//              let transactionID = Self.nonempty(material["transactionId"]), transactionID.utf8.count <= 256,
//              let receipt = Self.nonempty(material["receipt"]), receipt.utf8.count <= 2_796_204,
//              let receiptData = Data(base64Encoded: receipt), !receiptData.isEmpty else { throw RechargeError.invalidResponse }
//        let store = try orders()
//        guard var current = try store.records(context.purchaseScope).first(where: { $0.orderCode == order.orderCode && $0.productID == order.productID }) else { throw RechargeError.storageUnavailable }
//        if !current.verifiedTransactionIDs.contains(transactionID) {
//            let callback = try JSONSerialization.data(withJSONObject: ["orderCode": order.orderCode], options: [.sortedKeys])
//            guard let callbackString = String(data: callback, encoding: .utf8) else { throw RechargeError.invalidResponse }
//            let response = try Self.object(try await send("/_v2/pay/verifyIosPurchase", ["transactionId": transactionID, "payload": receipt, "callbackResult": callbackString], context: context))
//            guard Self.boolean(response["success"]) == true else { throw RechargeError.confirmationPending }
//            guard try await orderState(order.orderCode, context: context) == 2 else { throw RechargeError.confirmationPending }
//            current.verifiedTransactionIDs.insert(transactionID); current.phase = "verified"
//            try store.upsert(current, scope: context.purchaseScope)
//        }
//        return try await finishVerified(current, context: context)
//    }
//    private func finishVerified(_ order: NativeOrder, context: Context) async throws -> Int {
//        guard !order.verifiedTransactionIDs.isEmpty else { throw RechargeError.invalidResponse }
//        // A failed balance refresh keeps a durable verified order: retry cannot charge the customer again.
//        let value = try await balance(context)
//        let unacknowledged = order.verifiedTransactionIDs.subtracting(order.acknowledgedTransactionIDs)
//        if !unacknowledged.isEmpty { _ = try await sync(context: context, acknowledged: Array(unacknowledged), excluded: []) }
//        var completed = order
//        completed.acknowledgedTransactionIDs.formUnion(unacknowledged); completed.phase = "delivered"
//        try orders().upsert(completed, scope: context.purchaseScope)
//        return value
//    }
//    private func orderState(_ orderCode: String, context: Context) async throws -> Int {
//        let response = try Self.object(try await send("/_v2/pay/orderStatus", ["orderCode": orderCode], context: context))
//        guard let state = Self.integer(response["state"]), state == 1 || state == 2 else { throw RechargeError.invalidResponse }; return state
//    }
//    private func send(_ path: String, _ body: [String: Any], context: Context) async throws -> Data {
//        try check(context)
//        let data = try await request(path, body)
//        try check(context)
//        return data
//    }
//    private func sync(context: Context, acknowledged: [String], excluded: [String]) async throws -> [[String: Any]] {
//        try check(context)
//        guard acknowledged.count <= 100, excluded.count <= 100 else { throw RechargeError.invalidResponse }
//        let result = try await syncTransactions(["ownerId": context.ownerID, "acknowledgedTransactionIds": acknowledged, "excludeTransactionIds": excluded], context)
//        try check(context)
//        guard let transactions = result["transactions"] as? [[String: Any]], transactions.count <= 20 else { throw RechargeError.invalidResponse }
//        return transactions
//    }
//    private func balance(_ context: Context) async throws -> Int {
//        try check(context); let value = try await refreshBalance(); try check(context)
//        guard value >= 0 else { throw RechargeError.invalidResponse }; return value
//    }
//    private func check(_ context: Context) throws {
//        guard !Task.isCancelled, contextIsCurrent(context) else { throw RechargeError.sessionChanged }
//        try context.purchaseScope.validate()
//    }
//    private func orders() throws -> NativeOrders {
//        if let journal { return journal }
//        let base = try storageDirectory ?? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("WevVNativeRechargeOrders", isDirectory: true)
//        let value = try NativeOrders(directory: base); journal = value; return value
//    }
//    private static func object(_ data: Data) throws -> [String: Any] {
//        guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw RechargeError.invalidResponse }; return result
//    }
//    private static func text(_ raw: Any?) -> String? {
//        if let value = raw as? String { return value.isEmpty ? nil : value }
//        if let value = raw as? NSNumber, CFGetTypeID(value) != CFBooleanGetTypeID() { return value.stringValue }; return nil
//    }
//    private static func nonempty(_ raw: Any?) -> String? {
//        guard let value = raw as? String, !value.isEmpty, value == value.trimmingCharacters(in: .whitespacesAndNewlines),
//              !value.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) }) else { return nil }; return value
//    }
//    private static func integer(_ raw: Any?) -> Int? { text(raw).flatMap(Int.init) }
//    private static func positiveID(_ raw: Any?) -> Int64? { guard let value = text(raw).flatMap(Int64.init), value > 0 else { return nil }; return value }
//    private static func boolean(_ raw: Any?) -> Bool? { guard let value = raw as? NSNumber, CFGetTypeID(value) == CFBooleanGetTypeID() else { return nil }; return value.boolValue }
//    /// The supplied OPI document names IOS; the delivered SDK also identifies Apple's channel as "7".
//    nonisolated private static func isAppleChannel(_ value: String) -> Bool { value.uppercased() == "IOS" || value == "7" }
//    private static func errorCode(_ error: Error) -> String {
//        if let value = error as? WevVGlazePurchaseError { return value.rawValue }
//        if case WevVGlazeNetworkError.business(let code, _) = error { return "BUSINESS_" + code }
//        if case WevVGlazeNetworkError.http(let code) = error { return "HTTP_" + String(code) }
//        if case RechargeError.confirmationPending = error { return "CONFIRMATION_PENDING" }
//        return "RECOVERY_FAILED"
//    }
//
//    private struct NativeOrder: Codable {
//        let orderCode: String
//        let productID: String
//        var phase: String
//        let createdAt: Date
//        var verifiedTransactionIDs: Set<String>
//        var acknowledgedTransactionIDs: Set<String>
//    }
//    private struct NativeJournal: Codable {
//        let version: Int
//        let origin: String
//        let scope: WevVGlazePurchaseScope
//        var orders: [NativeOrder]
//    }
//    private final class NativeOrders {
//        let directory: URL
//        private var cached: [String: NativeJournal] = [:]
//        init(directory: URL) throws {
//            self.directory = directory
//            let manager = FileManager.default
//            if manager.fileExists(atPath: directory.path) {
//                let values = try directory.resourceValues(forKeys: [.isDirectoryKey, .isSymbolicLinkKey])
//                guard values.isDirectory == true, values.isSymbolicLink != true else { throw RechargeError.storageUnavailable }
//            } else { try manager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700]) }
//            try manager.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
//            var protected = directory, flags = URLResourceValues(); flags.isExcludedFromBackup = true; try protected.setResourceValues(flags)
//        }
//        func records(_ scope: WevVGlazePurchaseScope) throws -> [NativeOrder] { try read(scope).orders }
//        func upsert(_ order: NativeOrder, scope: WevVGlazePurchaseScope) throws {
//            var journal = try read(scope)
//            if let index = journal.orders.firstIndex(where: { $0.orderCode == order.orderCode }) {
//                guard journal.orders[index].productID == order.productID else { throw RechargeError.storageUnavailable }
//                journal.orders[index] = order
//            } else { journal.orders.append(order) }
//            try validate(journal)
//            let data = try JSONEncoder().encode(journal)
//            let destination = directory.appendingPathComponent(scope.storageKey + ".json")
//            let temporary = directory.appendingPathComponent("." + UUID().uuidString + ".pending")
//            defer { try? FileManager.default.removeItem(at: temporary) }
//            #if os(iOS)
//            try data.write(to: temporary, options: [.withoutOverwriting, .completeFileProtectionUntilFirstUserAuthentication])
//            #else
//            try data.write(to: temporary, options: .withoutOverwriting)
//            #endif
//            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: temporary.path)
//            var protected = temporary, flags = URLResourceValues(); flags.isExcludedFromBackup = true; try protected.setResourceValues(flags)
//            let handle = try FileHandle(forWritingTo: temporary)
//            do { try handle.synchronize(); try handle.close() } catch { try? handle.close(); throw error }
//            let result = temporary.withUnsafeFileSystemRepresentation { old in destination.withUnsafeFileSystemRepresentation { new in
//                guard let old, let new else { return Int32(-1) }; return Darwin.rename(old, new)
//            } }
//            guard result == 0 else { throw RechargeError.storageUnavailable }
//            let descriptor = Darwin.open(directory.path, O_RDONLY)
//            guard descriptor >= 0 else { throw RechargeError.storageUnavailable }
//            defer { Darwin.close(descriptor) }
//            guard Darwin.fsync(descriptor) == 0 else { throw RechargeError.storageUnavailable }
//            cached[scope.storageKey] = journal
//        }
//        private func read(_ scope: WevVGlazePurchaseScope) throws -> NativeJournal {
//            try scope.validate()
//            if let journal = cached[scope.storageKey] { return journal }
//            let url = directory.appendingPathComponent(scope.storageKey + ".json")
//            let journal: NativeJournal
//            if FileManager.default.fileExists(atPath: url.path) {
//                let attributes = try url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
//                guard attributes.isRegularFile == true, attributes.isSymbolicLink != true else { throw RechargeError.storageUnavailable }
//                journal = try JSONDecoder().decode(NativeJournal.self, from: Data(contentsOf: url))
//            } else { journal = NativeJournal(version: 1, origin: "native-recharge", scope: scope, orders: []) }
//            guard journal.scope == scope else { throw RechargeError.storageUnavailable }
//            try validate(journal); cached[scope.storageKey] = journal; return journal
//        }
//        private func validate(_ journal: NativeJournal) throws {
//            guard journal.version == 1, journal.origin == "native-recharge", journal.orders.count <= 10_000,
//                  Set(journal.orders.map(\.orderCode)).count == journal.orders.count else { throw RechargeError.storageUnavailable }
//            for order in journal.orders {
//                guard let _ = WevVGlazeNativeRechargeService.nonempty(order.orderCode), order.orderCode.utf8.count <= 256,
//                      let _ = WevVGlazeNativeRechargeService.nonempty(order.productID), order.productID.utf8.count <= 256,
//                      ["created", "pending", "cancelled", "verified", "delivered"].contains(order.phase),
//                      order.verifiedTransactionIDs.count <= 100, order.acknowledgedTransactionIDs.isSubset(of: order.verifiedTransactionIDs),
//                      order.verifiedTransactionIDs.allSatisfy({ WevVGlazeNativeRechargeService.nonempty($0) != nil && $0.utf8.count <= 256 }) else { throw RechargeError.storageUnavailable }
//            }
//        }
//    }
//}
