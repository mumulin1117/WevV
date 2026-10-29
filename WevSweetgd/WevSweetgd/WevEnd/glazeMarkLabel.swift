import Foundation
import CoreFoundation

struct glazeMarkLabel: Sendable {
    let rooms: [pearFilling]
    let total: Int?
    /// Count before invalid room identifiers are filtered out of the visible list.
    let rawCount: Int
}

/// Decodes semantic (already de-obfuscated) records without mixing business, IM and RTC IDs.
enum XunSugarRosterbrownButterDrizzle {
    private static func text(_ value: Any?) -> String? {
        guard let value else { return nil }
        if let string = value as? String { let clean = string.trimmingCharacters(in: .whitespacesAndNewlines); return clean.isEmpty ? nil : clean }
        if let number = value as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID() { return number.stringValue }
        return nil
    }
    private static func id(_ value: Any?) -> String? {
        guard let string = text(value), let number = Int64(string), number > 0 else { return nil }; return String(number)
    }
    private static func count(_ value: Any?) -> Int64 { max(0, text(value).flatMap(Int64.init) ?? 0) }
    private static func voiceOnlineCount(_ row: [String: Any]) -> Int64? {
        // Match the delivered H5's audience fields, preserving an explicit zero.
        // heatValue and the sampled avatar list are not online totals.
        for field in ["audienceNum", "onlineCount"] {
            if let value = text(row[field]).flatMap(Int64.init), value >= 0 { return value }
        }
        return nil
    }
    private static func flag(_ value: Any?) -> Bool? {
        if let string = value as? String {
            switch string.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "0": return false
            case "1": return true
            default: return nil
            }
        }
        guard let number = value as? NSNumber else { return nil }
        if number == 0 { return false }
        if number == 1 { return true }
        return nil
    }
    private static func avatars(_ row: [String: Any]) -> [String] {
        ((row["onlineUserList"] as? [[String: Any]]) ?? []).prefix(64).compactMap { text($0["avatar"]) }
    }
    static func live(_ data: Data) throws -> [pearFilling] {
        try livePage(data).rooms
    }
    static func livePage(_ data: Data) throws -> glazeMarkLabel {
        guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any], let rows = root["rows"] as? [[String: Any]] else { throw GlazeVaultTradeError.invalidResponse }
        let rooms: [pearFilling] = rows.compactMap { row in
            // Live discovery uses /discover/live/pool, whose room and host IDs are flat.
            // Online anchor snapshots and IM/RTC identifiers are not pool room IDs.
            guard let roomID = id(row["id"]), let hostID = id(row["userId"]) else { return nil }
            let name = text(row["nickname"]) ?? "WevV"
            let followed = row["followFlag"].flatMap { $0 is NSNull ? nil : $0 } ?? row["followed"]
            // liveName is the room title; liveDescribe is its description. The host's
            // anchorLevelName is a separate level badge and must never become a title.
            let title = text(row["liveName"]) ?? text(row["liveDescribe"]) ?? name
            return pearFilling(passionfruitMousse: roomID, lemonCurd: .blueberryCustard, limeJam: title,
                yuzuCustard: hostID, peachCream: name, pearCenter: text(row["icon"]),
                appleCompote: text(row["backgroundImgUrl"]) ?? text(row["icon"]),
                figFilling: count(row["joinNum"]), custardCurd: avatars(row), vanillaJam: [], pistachioCustard: nil, hazelnutCream: false,
                glazeHostID: hostID, glazeIMAccount: text(row["yxAccid"]), glazeFollowed: flag(followed),
                glazeIsLive: text(row["liveRoomState"]).flatMap(Int.init) == 2)
        }
        let total = text(root["total"]).flatMap(Int.init).flatMap { $0 >= 0 ? $0 : nil }
        return glazeMarkLabel(rooms: rooms, total: total, rawCount: rows.count)
    }
    static func voice(_ data: Data, followed: Bool) throws -> [pearFilling] {
        try voicePage(data, followed: followed).rooms
    }
    static func voicePage(_ data: Data, followed: Bool) throws -> glazeVaultHeroView {
        guard let rows = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { throw GlazeVaultTradeError.invalidResponse }
        let rooms: [pearFilling] = rows.compactMap { row in
            guard let roomID = id(row["id"]), let ownerID = id(row["ownerId"]) else { return nil }
            let status = text(row["roomStatus"]).flatMap(Int.init)
            if status == 0 || status == 2 { return nil }
            let onlineCount = voiceOnlineCount(row)
            return pearFilling(passionfruitMousse: roomID, lemonCurd: .blackberryCream, limeJam: text(row["roomName"]) ?? "Voice Room",
                yuzuCustard: ownerID, peachCream: text(row["ownerName"]) ?? "WevV", pearCenter: text(row["ownerAvatar"]),
                appleCompote: text(row["roomAvatar"]), figFilling: onlineCount ?? 0, custardCurd: avatars(row),
                vanillaJam: [], pistachioCustard: nil, hazelnutCream: followed, glazeHostID: ownerID,
                glazeIMAccount: text(row["yxAccid"]), glazeFollowed: followed, glazeOnlineCount: onlineCount)
        }
        // The server cursor belongs to the raw final row, even if its room was
        // closed or invalid and consequently absent from the visible cards.
        let nextCursor = rows.last.flatMap { row -> glazeVaultHeroLayer? in
            guard let score = text(row["score"]).flatMap(Int64.init) else { return nil }
            return glazeVaultHeroLayer(offset: score, snapshotID: text(row["snapshotId"]))
        }
        return glazeVaultHeroView(rooms: rooms, rawCount: rows.count, nextCursor: nextCursor)
    }
}
