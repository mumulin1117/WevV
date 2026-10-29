import CoreFoundation
import Foundation

enum glazeSugarCountLabel: LocalizedError {
    case invalidInput
    case invalidResponse
    case incompletePagination

    var errorDescription: String? {
        switch self {
        case .invalidInput: return "This action could not be prepared. Please check your selection and try again."
        case .invalidResponse: return "User information could not be loaded. Please try again."
        case .incompletePagination: return "The complete blocked list could not be loaded. Please try again."
        }
    }
}

struct glazeVaultGrid: Equatable {
    let epoch: Int
    let environmentID: String
    let ownerID: Int64?
}

// Dependencies are injectable only to run the same service against offline
// fixtures. The production instance always uses the selected test Runtime.
@MainActor
final class WevVGlazeRosterCell {
    typealias Begin = (Bool) async throws -> glazeVaultGrid
    typealias Send = (String, [String: Any], Bool) async throws -> Data
    typealias Check = (glazeVaultGrid) throws -> Void

    #if !WEVV_SOCIAL_TESTING
    static let shared = WevVGlazeRosterCell(
        begin: { authenticated in
            let runtime = BrostingmellowCoconutEssence.listenForGlazeTrades
            let store = WevVGlazeSessionStore.shared
            let observedEpoch = store.sessionEpoch
            let observedScope = runtime.closeCreamRingEdit
            let observedOwner = store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil
            if authenticated, observedOwner == nil { throw miniRingFritter.cityBakeryTrail }
            try await runtime.glazeCounterBakery()
            if !observedScope.isEmpty {
                try runtime.applyPortraitAsset(closeVideoDial: observedEpoch, liftPastryEditCanvas: observedScope)
                guard (store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil) == observedOwner else {
                    throw CancellationError()
                }
            }
            let boundary = glazeVaultGrid(epoch: store.sessionEpoch, environmentID: runtime.closeCreamRingEdit,
                                                  ownerID: store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil)
            if authenticated {
                _ = try await runtime.makePackCard()
                guard boundary.ownerID != nil else { throw miniRingFritter.cityBakeryTrail }
            }
            try runtime.applyPortraitAsset(closeVideoDial: boundary.epoch, liftPastryEditCanvas: boundary.environmentID)
            guard (store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil) == boundary.ownerID else {
                throw CancellationError()
            }
            return boundary
        },
        send: { path, body, browsing in
            if browsing { return try await BrostingmellowCoconutEssence.listenForGlazeTrades.bakeryPieces(glazeCatalogRefresh: path, autumnPecanSelection: body) }
            return try await BrostingmellowCoconutEssence.listenForGlazeTrades.frostedWinterAssortment(glazeCatalogRefresh: path, autumnPecanSelection: JSONSerialization.data(withJSONObject: body), applyRemoteTrailButton: true)
        },
        check: { boundary in
            let store = WevVGlazeSessionStore.shared
            try BrostingmellowCoconutEssence.listenForGlazeTrades.applyPortraitAsset(closeVideoDial: boundary.epoch, liftPastryEditCanvas: boundary.environmentID)
            guard (store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil) == boundary.ownerID else {
                throw CancellationError()
            }
        }
    )
    #endif

    private let begin: Begin
    private let send: Send
    private let check: Check

    init(begin: @escaping Begin, send: @escaping Send, check: @escaping Check) {
        self.begin = begin
        self.send = send
        self.check = check
    }

    func displayName(userID: Int64) async throws -> String? {
        guard userID > 0 else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(false)
        let data = try await request("/_v2/user/personalCard", body: ["userId": userID], browsing: true, boundary: boundary)
        let object = try Self.object(data)
        let returnedID = try Self.optionalInteger(object["userId"])
        guard returnedID == nil || returnedID == userID else { throw glazeSugarCountLabel.invalidResponse }
        // Room names and placeholder text are not a user's display name.
        // A list only needs the public card, without relationship requests.
        return Self.text(object["nickName"])
    }




    func setFollow(userID: Int64, follow: Bool) async throws {
        guard userID > 0 else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(true)
        guard userID != boundary.ownerID else { throw glazeSugarCountLabel.invalidInput }
        _ = try await request("/_v2/user/followUser", body: ["followUserId": userID, "followType": follow ? 1 : 2], browsing: false, boundary: boundary)
    }


    func report(userID: Int64, type: String, detail: String?, momentID: Int64? = nil) async throws {
        let code = type.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let allowed = Set(["SPAM", "NUDITY", "HARASS", "FRAUD", "UNDERAGE", "OTHER"])
        guard userID > 0, allowed.contains(code), momentID.map({ $0 > 0 }) ?? true else {
            throw glazeSugarCountLabel.invalidInput
        }
        let boundary = try await begin(true)
        guard userID != boundary.ownerID else { throw glazeSugarCountLabel.invalidInput }
        var body: [String: Any] = ["feedbackType": code, "targetUserId": userID]
        // feedback/save reports a real user. Post ID is operator-readable
        // context only; this does not claim a missing moment-report endpoint.
        let suggestion = Self.reportSuggestion(detail: detail, momentID: momentID)
        if !suggestion.isEmpty { body["suggestion"] = suggestion }
        _ = try await request("/_v2/feedback/save", body: body, browsing: false, boundary: boundary)
    }

    private func request(_ path: String, body: [String: Any], browsing: Bool, boundary: glazeVaultGrid) async throws -> Data {
        try Task.checkCancellation()
        try check(boundary)
        guard browsing || boundary.ownerID != nil else { throw glazeSugarCountLabel.invalidInput }
        let data: Data
        do { data = try await send(path, body, browsing) }
        catch {
            try Task.checkCancellation()
            try check(boundary)
            throw error
        }
        try Task.checkCancellation()
        try check(boundary)
        return data
    }



    private static func object(_ data: Data) throws -> [String: Any] {
        guard let object = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any] else {
            throw glazeSugarCountLabel.invalidResponse
        }
        return object
    }


    private static func text(_ value: Any?) -> String? {
        guard let value = value as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func optionalInteger(_ value: Any?) throws -> Int64? {
        guard let value, !(value is NSNull) else { return nil }
        if let number = value as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID(), let integer = Int64(number.stringValue) { return integer }
        if let value = value as? String, let integer = Int64(value) { return integer }
        throw glazeSugarCountLabel.invalidResponse
    }


    private static func reportSuggestion(detail: String?, momentID: Int64?) -> String {
        let prefix = momentID.map { "[Post#\($0)] " } ?? ""
        let full = prefix + (text(detail) ?? "")
        // Bound UTF-16 as well as visible characters to remain within server
        // string limits without splitting an emoji/grapheme in the middle.
        var bounded = ""
        var length = 0
        for character in full {
            let piece = String(character)
            guard length + piece.utf16.count <= 200 else { break }
            bounded += piece
            length += piece.utf16.count
        }
        return bounded.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
