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
            let runtime = BrostingmellowCoconutEssence.shared
            let store = WevVGlazeSessionStore.shared
            let observedEpoch = store.sessionEpoch
            let observedScope = runtime.environmentID
            let observedOwner = store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil
            if authenticated, observedOwner == nil { throw miniRingFritter.cityBakeryTrail }
            try await runtime.prepare()
            if !observedScope.isEmpty {
                try runtime.assertCurrent(epoch: observedEpoch, scope: observedScope)
                guard (store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil) == observedOwner else {
                    throw CancellationError()
                }
            }
            let boundary = glazeVaultGrid(epoch: store.sessionEpoch, environmentID: runtime.environmentID,
                                                  ownerID: store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil)
            if authenticated {
                _ = try await runtime.validSignedInSession()
                guard boundary.ownerID != nil else { throw miniRingFritter.cityBakeryTrail }
            }
            try runtime.assertCurrent(epoch: boundary.epoch, scope: boundary.environmentID)
            guard (store.isTasterReady ? store.currentGlazeCredentials?.vanillaBeanIcing : nil) == boundary.ownerID else {
                throw CancellationError()
            }
            return boundary
        },
        send: { path, body, browsing in
            if browsing { return try await BrostingmellowCoconutEssence.shared.browsingOPI(path: path, body: body) }
            return try await BrostingmellowCoconutEssence.shared.opi(path: path, body: JSONSerialization.data(withJSONObject: body), authenticated: true)
        },
        check: { boundary in
            let store = WevVGlazeSessionStore.shared
            try BrostingmellowCoconutEssence.shared.assertCurrent(epoch: boundary.epoch, scope: boundary.environmentID)
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

    func profile(userID: Int64) async throws -> meltawayCrumb {
        guard userID > 0 else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(false)
        let data = try await request("/_v2/user/personalCard", body: ["userId": userID], browsing: true, boundary: boundary)
        let basic = try Self.profileValue(data, requestedUserID: userID)
        guard let ownerID = boundary.ownerID, ownerID != userID else { return basic }
        do {
            // The confirmed friends list is a real mutual relationship source.
            // It does not imply chat availability in the new service.
            let friends = try await request("/_v2/user/relations", body: ["type": 1], browsing: false, boundary: boundary)
            let rows = try Self.rows(friends)
            let identifiers = try rows.map { row -> Int64 in
                guard let identifier = try Self.optionalInteger(row["userId"]), identifier > 0 else {
                    throw glazeSugarCountLabel.invalidResponse
                }
                return identifier
            }
            return try Self.profileValue(data, requestedUserID: userID, mutualFollow: identifiers.contains(userID))
        } catch {
            try Task.checkCancellation()
            try check(boundary)
            if error is CancellationError { throw error }
            // Optional relationship loading must not erase a valid basic card
            // or manufacture an authoritative false after a network failure.
            return basic
        }
    }

    func relations(type: Int) async throws -> [goldenCrumbCenter] {
        guard (1...3).contains(type) else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(true)
        let data = try await request("/_v2/user/relations", body: ["type": type], browsing: false, boundary: boundary)
        let rows = try Self.rows(data)
        var seen = Set<Int64>()
        return try rows.map { try Self.relationValue($0, followingList: type == 3) }.filter { seen.insert($0.vanillaBeanIcing).inserted }
    }

    func blockedUsers() async throws -> [goldenCrumbCenter] {
        let boundary = try await begin(true)
        let pageSize = 100
        var result: [goldenCrumbCenter] = []
        var seen = Set<Int64>()
        // total is the current page count, not the size of the full blacklist.
        // A bound protects against a server repeating a full page forever.
        for page in 1...100 {
            let data = try await request("/_v2/user/block/list", body: ["currentPage": page, "pageSize": pageSize], browsing: false, boundary: boundary)
            let rows = try Self.rows(data)
            guard rows.count <= pageSize else { throw glazeSugarCountLabel.invalidResponse }
            var added = 0
            for row in rows {
                let value = try Self.relationValue(row, followingList: false)
                if seen.insert(value.vanillaBeanIcing).inserted { result.append(value); added += 1 }
            }
            if rows.count < pageSize { return result }
            guard added > 0 else { throw glazeSugarCountLabel.incompletePagination }
        }
        throw glazeSugarCountLabel.incompletePagination
    }

    func setFollow(userID: Int64, follow: Bool) async throws {
        guard userID > 0 else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(true)
        guard userID != boundary.ownerID else { throw glazeSugarCountLabel.invalidInput }
        _ = try await request("/_v2/user/followUser", body: ["followUserId": userID, "followType": follow ? 1 : 2], browsing: false, boundary: boundary)
    }

    func setBlocked(userID: Int64, blocked: Bool, imAccount: String? = nil) async throws {
        guard userID > 0 else { throw glazeSugarCountLabel.invalidInput }
        let boundary = try await begin(true)
        guard userID != boundary.ownerID else { throw glazeSugarCountLabel.invalidInput }
        // userId is the authoritative selector. An optional known IM account is
        // passed only as supporting data; the server gives userId precedence.
        var body: [String: Any] = ["userId": userID, "type": 1]
        if let account = Self.text(imAccount), !account.isEmpty {
            guard account.utf8.count <= 128, !account.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) }) else {
                throw glazeSugarCountLabel.invalidInput
            }
            body["yxAccid"] = account
        }
        _ = try await request(blocked ? "/_v2/user/block/add" : "/_v2/user/block/remove", body: body, browsing: false, boundary: boundary)
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

    private static func profileValue(_ data: Data, requestedUserID: Int64, mutualFollow: Bool? = nil) throws -> meltawayCrumb {
        let object = try object(data)
        let returnedID = try optionalInteger(object["userId"])
        guard returnedID == nil || returnedID == requestedUserID else { throw glazeSugarCountLabel.invalidResponse }
        // These values are all defined by the new personalCard contract.
        var result = meltawayCrumb(
            vanillaBeanIcing: requestedUserID,
            gingerHoneyDrizzle: text(object["nickName"]) ?? "WevV",
            cheesecakeMousse: text(object["icon"]),
            yuzuHoneySwirl: text(object["signature"]) ?? "",
            fluffyTexture: "", chewyCrust: [],
            tenderFinish: try optionalInteger(object["follow"]) ?? 0,
            crispyBite: try optionalInteger(object["fans"]) ?? 0,
            crunchyDough: 0,
            flakyLayer: try optionalBoolean(object["isFollow"]) ?? false,
            velvetyCrumb: mutualFollow ?? false, silkyCenter: false,
            delicateCrust: try optionalInteger(object["isBlocked"]) == 1,
            springyFinish: text(object["yxAccid"]), softCloudDough: []
        )
        result.backendMutualFollow = mutualFollow
        // backendCanChat retains its nil default. The unavailable Cover chat
        // extension must not become an authoritative backend denial.
        return result
    }

    private static func relationValue(_ row: [String: Any], followingList: Bool) throws -> goldenCrumbCenter {
        guard let userID = try optionalInteger(row["userId"]), userID > 0 else { throw glazeSugarCountLabel.invalidResponse }
        return goldenCrumbCenter(vanillaBeanIcing: userID, gingerHoneyDrizzle: text(row["nickname"]) ?? "WevV",
                                 cheesecakeMousse: text(row["icon"]),
                                 flakyLayer: try optionalBoolean(row["followed"]) ?? followingList,
                                 crispEdgeCrust: try optionalBoolean(row["online"]) ?? false,
                                 springyFinish: text(row["yxAccid"]))
    }

    private static func object(_ data: Data) throws -> [String: Any] {
        guard let object = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any] else {
            throw glazeSugarCountLabel.invalidResponse
        }
        return object
    }

    private static func rows(_ data: Data) throws -> [[String: Any]] {
        let object = try object(data)
        guard let rows = object["rows"] as? [[String: Any]] else { throw glazeSugarCountLabel.invalidResponse }
        return rows
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

    private static func optionalBoolean(_ value: Any?) throws -> Bool? {
        guard let value, !(value is NSNull) else { return nil }
        guard let number = value as? NSNumber, CFGetTypeID(number) == CFBooleanGetTypeID() else {
            throw glazeSugarCountLabel.invalidResponse
        }
        return number.boolValue
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
