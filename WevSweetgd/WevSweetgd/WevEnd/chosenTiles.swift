import Foundation

/// The SDK's documented standalone entries. Credentials belong in Bridge context only.
enum chosenTiles: Sendable {
    enum cocoaInkTone: String, CaseIterable, Sendable {
        case friends = "1"
        case fans = "2"
        case following = "3"
    }

    case room(pearFilling)
    case messages, systemMessages, likedMessages
    case user(userID: String, imAccount: String?)
    case creator(userID: String, imAccount: String?)
    case conversation(userID: String, imAccount: String, name: String?, avatarURL: String?)
    case editProfile, diamonds, diamondRecords, blocklist, feedback, level, store, backpack
    case relations(cocoaInkTone)
    case liveSearch, liveRanking, partyCreate, partySearch, partyRanking, cpSettings

    var requiresFullFeatures: Bool {
        if case .cpSettings = self { return true }
        return false
    }

    /// Use the exact same route builder for direct URLs and SDK idle activation.
    var bridgeEntry: [String: Any]? {
        guard let url = makeURL(indexURL: URL(fileURLWithPath: "/index.html")),
              let hash = url.absoluteString.firstIndex(of: "#"),
              let components = URLComponents(string: "https://entry.invalid" + url.absoluteString[url.absoluteString.index(after: hash)...]) else { return nil }
        var query: [String: String] = [:]
        for item in components.queryItems ?? [] { query[item.name] = item.value ?? "" }
        return ["path": components.percentEncodedPath, "query": query]
    }

    func makeURL(indexURL: URL) -> URL? {
        guard indexURL.isFileURL, indexURL.query == nil, indexURL.fragment == nil else { return nil }
        var path: String
        var query: [(String, String)] = []
        switch self {
        case .room(let room):
            let roomID = room.passionfruitMousse
            if room.lemonCurd == .blueberryCustard {
                guard let hostID = room.glazeHostID, Self.isPositiveID(hostID) else { return nil }
                path = Self.isPositiveID(roomID) ? "/live/room/\(roomID)" : "/live/room"
                query.append(("hostId", hostID))
                Self.append(room.limeJam, as: "displayName", to: &query)
                Self.append(room.pearCenter, as: "avatarUrl", to: &query)
                Self.append(room.glazeIMAccount, as: "imAccount", to: &query)
                if let followed = room.glazeFollowed { query.append(("followed", followed ? "1" : "0")) }
            } else {
                guard Self.isPositiveID(roomID) else { return nil }
                path = "/party/room/\(roomID)"
            }
        case .messages: path = "/messages"
        case .systemMessages: path = "/messages/system"
        case .likedMessages: path = "/messages/likes"
        case .user(let userID, let imAccount):
            guard Self.isPositiveID(userID) else { return nil }
            path = "/user/\(userID)"
            Self.append(imAccount, as: "yxAccid", to: &query)
        case .creator(let userID, let imAccount):
            guard Self.isPositiveID(userID) else { return nil }
            path = "/creator/\(userID)"
            Self.append(imAccount, as: "yxAccid", to: &query)
        case .conversation(let userID, let imAccount, let name, let avatarURL):
            guard Self.isPositiveID(userID), !imAccount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
            path = "/conversation/\(Self.encode(imAccount))"
            query = [("userId", userID), ("yxAccid", imAccount)]
            Self.append(name, as: "name", to: &query)
            Self.append(avatarURL, as: "avatar", to: &query)
        case .editProfile: path = "/profile/edit"
        case .diamonds: path = "/profile/diamonds"
        case .diamondRecords: path = "/profile/diamonds/records"
        case .blocklist: path = "/profile/blocklist"
        case .feedback: path = "/profile/feedback"
        case .level: path = "/profile/level"
        case .store:
            path = "/profile/store"
            query = [("tab", "all")]
        case .backpack:
            path = "/profile/backpack"
            query = [("tab", "all")]
        case .relations(let relation): path = "/profile/relations/\(relation.rawValue)"
        case .liveSearch: path = "/live/search"
        case .liveRanking: path = "/live/ranking"
        case .partyCreate: path = "/party/create"
        case .partySearch: path = "/party/search"
        case .partyRanking: path = "/party/ranking"
        case .cpSettings: path = "/profile/cp-settings"
        }
        guard path.utf16.count <= 2048, query.allSatisfy({ $0.1.utf16.count <= 4096 }) else { return nil }
        let encodedQuery = query.map { Self.encode($0.0) + "=" + Self.encode($0.1) }.joined(separator: "&")
        let fragment = path + (encodedQuery.isEmpty ? "" : "?" + encodedQuery)
        // Keep each hash query value encoded once, including nested avatar URLs and IM accounts.
        return URL(string: indexURL.absoluteString + "#" + fragment)
    }

    private static func isPositiveID(_ value: String) -> Bool {
        !value.isEmpty && value.first != "0" && value.allSatisfy { $0.isASCII && $0.isNumber }
    }

    private static func append(_ value: String?, as name: String, to query: inout [(String, String)]) {
        if let value, !value.isEmpty { query.append((name, value)) }
    }

    private static func encode(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")) ?? ""
    }
}
