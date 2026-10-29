import Foundation
import CoreFoundation

/// Semantic community contract. All transport encoding remains in the shared Revision 2 client.
@MainActor
final class LisenNoticepoplater {
    struct caramelPecanMedley: Sendable {
        let card: butteryTexture
        let appID: String
        var allowsInteraction: Bool { !appID.isEmpty && appID != "0" }
    }
    struct choiceStackPacket: Sendable {
        let posts: [caramelPecanMedley]
        let nextCursor: Int64?
        let isLastPage: Bool
    }
    struct choiceTitle: Sendable {
        /// First-level comments followed by their replies; replies preserve parentCommentId.
        let comments: [featherlightBite]
        let total: Int
        let hasMore: Bool
    }
    struct chosenAsset: Sendable {
        let publishEnabled: Bool
        let imageUploadEnabled: Bool
    }
    enum chosenAssetPacket: Sendable {
        case published(Int64)
        /// The server accepted and saved the post for review. It must not be submitted again.
        case pendingReview
    }
    enum chosenDonutAvatarAsset: Error, LocalizedError, Sendable {
        case loginRequired
        case invalidParameters
        case interactionUnavailable
        case momentUnavailable
        case publicationRejected(currentLevel: Int?, targetLevel: Int?, validImageURLs: [String]?)
        nonisolated var errorDescription: String? {
            switch self {
            case .loginRequired: return "Please sign in to continue."
            case .invalidParameters: return "Please check the post or comment and try again."
            case .interactionUnavailable: return "This post does not accept reactions or comments."
            case .momentUnavailable: return "This post is no longer available in the current feed."
            case .publicationRejected(let current, let target, let images):
                if let current, let target { return "Publishing requires level \(target). Your current level is \(current)." }
                if images != nil { return "Some images did not pass review. Please check the selected images." }
                return "The post could not be published. Please check the publishing requirements."
            }
        }
    }

    typealias Request = @MainActor (_ path: String, _ body: [String: Any], _ requiresSignIn: Bool) async throws -> Data
    static let shared = LisenNoticepoplater()
    private let request: Request
    private let isSignedIn: @MainActor () -> Bool
    private let scope: @MainActor () -> String
    private let prepare: @MainActor () async throws -> Void
    private var cachedScope = ""
    private var cachedPosts: [Int64: caramelPecanMedley] = [:]

    init(request: Request? = nil, isSignedIn: (@MainActor () -> Bool)? = nil, scope: (@MainActor () -> String)? = nil, prepare: (@MainActor () async throws -> Void)? = nil) {
        let customTransport = request != nil
        self.request = request ?? { path, body, signedIn in
            if signedIn {
                return try await BrostingmellowCoconutEssence.listenForGlazeTrades.frostedWinterAssortment(glazeCatalogRefresh: path, autumnPecanSelection: JSONSerialization.data(withJSONObject: body), applyRemoteTrailButton: true)
            }
            return try await BrostingmellowCoconutEssence.listenForGlazeTrades.bakeryPieces(glazeCatalogRefresh: path, autumnPecanSelection: body)
        }
        self.isSignedIn = isSignedIn ?? { WevVGlazeSessionStore.shared.isTasterReady }
        self.scope = scope ?? { BrostingmellowCoconutEssence.listenForGlazeTrades.closeCreamRingEdit + "|" + String(WevVGlazeSessionStore.shared.sessionEpoch) }
        self.prepare = prepare ?? { if !customTransport { try await BrostingmellowCoconutEssence.listenForGlazeTrades.glazeCounterBakery() } }
    }

    func feed(cursorID: Int64 = 0, size: Int = 20) async throws -> choiceStackPacket {
        guard cursorID >= 0, (1...50).contains(size) else { throw chosenDonutAvatarAsset.invalidParameters }
        let data = try await send("/_v2/moments/feed", ["cursorId": cursorID, "size": size], signedIn: false)
        let root = try Self.object(data)
        guard let list = root["list"] as? [String: Any], let rows = list["rows"] as? [[String: Any]] else { throw GlazeVaultTradeError.invalidResponse }
        let posts = try rows.map(Self.post)
        let next: Int64?
        if let raw = root["nextCursor"], !(raw is NSNull) {
            guard let value = Self.positiveID(raw), value != cursorID else { throw GlazeVaultTradeError.invalidResponse }
            next = value
        } else { next = nil }
        for post in posts { cachedPosts[post.card.coconutCenter] = post }
        return choiceStackPacket(posts: posts, nextCursor: next, isLastPage: rows.count < size || next == nil)
    }

    /// FOLLOW has no independent endpoint in this contract. Only real followFlag values are used.
    /// A bounded scan can be incomplete; it never fabricates followed posts or sends a legacy type parameter.
    func timeline(followedOnly: Bool = false, maxPages: Int = 5) async throws -> [caramelPecanMedley] {
        guard (1...20).contains(maxPages) else { throw chosenDonutAvatarAsset.invalidParameters }
        try await prepare()
        if followedOnly, !isSignedIn() { throw chosenDonutAvatarAsset.loginRequired }
        let initialScope = currentScope()
        var cursor: Int64 = 0
        var seen = Set<Int64>(), cursors = Set<Int64>()
        var result: [caramelPecanMedley] = []
        for _ in 0..<maxPages {
            guard scope() == initialScope else { throw CancellationError() }
            guard cursors.insert(cursor).inserted else { throw GlazeVaultTradeError.invalidResponse }
            let page = try await feed(cursorID: cursor)
            guard scope() == initialScope else { throw CancellationError() }
            for post in page.posts where (!followedOnly || post.card.mascarponeCream) && seen.insert(post.card.coconutCenter).inserted { result.append(post) }
            if page.isLastPage { break }
            guard let next = page.nextCursor else { break }
            cursor = next
        }
        return result
    }

    func moment(id: Int64, maxPages: Int = 5) async throws -> caramelPecanMedley {
        guard id > 0, (1...20).contains(maxPages) else { throw chosenDonutAvatarAsset.invalidParameters }
        try await prepare()
        _ = currentScope()
        if let cached = cachedPosts[id] { return cached }
        let posts = try await timeline(maxPages: maxPages)
        guard let post = posts.first(where: { $0.card.coconutCenter == id }) else { throw chosenDonutAvatarAsset.momentUnavailable }
        return post
    }

    func comments(momentID: Int64, page: Int = 1, size: Int = 50) async throws -> choiceTitle {
        guard momentID > 0, page > 0, (1...50).contains(size) else { throw chosenDonutAvatarAsset.invalidParameters }
        try await requireInteraction(momentID)
        let root = try Self.object(try await send("/_v2/moments/getComments", ["friendsCircleId": momentID, "currentPage": page, "pageSize": size], signedIn: false))
        guard let rows = root["rows"] as? [[String: Any]] else { throw GlazeVaultTradeError.invalidResponse }
        var comments: [featherlightBite] = []
        for row in rows {
            let first = try Self.comment(row, parentID: nil)
            comments.append(first)
            if let raw = row["subComments"], !(raw is NSNull) {
                guard let replies = raw as? [[String: Any]] else { throw GlazeVaultTradeError.invalidResponse }
                for reply in replies { comments.append(try Self.comment(reply, parentID: first.blueberryCompote)) }
            }
        }
        let total = Self.integer(root["total"]) ?? rows.count
        guard total >= 0 else { throw GlazeVaultTradeError.invalidResponse }
        return choiceTitle(comments: comments, total: total, hasMore: rows.count == size)
    }

    func like(momentID: Int64, liked: Bool) async throws {
        let interactionScope = try captureSignedInScope()
        try await requireInteraction(momentID)
        try requireSignedInScope(interactionScope)
        try Self.requireSuccess(try await send("/_v2/moments/like", ["id": momentID, "optionType": liked ? 1 : 0], signedIn: true))
        cachedPosts.removeValue(forKey: momentID)
    }

    func comment(momentID: Int64, content: String, parentID: Int64? = nil) async throws {
        let interactionScope = try captureSignedInScope()
        let clean = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, clean.count <= 900, parentID == nil || parentID! > 0 else { throw chosenDonutAvatarAsset.invalidParameters }
        try await requireInteraction(momentID)
        try requireSignedInScope(interactionScope)
        var body: [String: Any] = ["friendsCircleId": momentID, "commentContent": clean]
        if let parentID { body["parentCommentId"] = parentID }
        try Self.requireSuccess(try await send("/_v2/moments/comment", body, signedIn: true))
        cachedPosts.removeValue(forKey: momentID)
    }

    func publishConfig() async throws -> chosenAsset {
        try requireSignedIn()
        let root = try Self.object(try await send("/_v2/moments/publishConfig", [:], signedIn: true))
        guard let publish = Self.boolean(root["publishEnabled"]), let images = Self.boolean(root["imageUploadEnabled"]) else { throw GlazeVaultTradeError.invalidResponse }
        return chosenAsset(publishEnabled: publish, imageUploadEnabled: images)
    }

    /// Success means review was submitted, not that the images have passed asynchronous review.
    func imageCheck(urls: [String]) async throws {
        try requireSignedIn()
        try Self.validateImages(urls)
        try Self.requireSuccess(try await send("/_v2/moments/imgCheck", ["imgUrls": urls], signedIn: true))
    }

    func create(content: String, imageURLs: [String], displayRange: Int = 1) async throws -> chosenAssetPacket {
        try requireSignedIn()
        let clean = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, clean.count <= 500, (1...3).contains(displayRange) else { throw chosenDonutAvatarAsset.invalidParameters }
        try Self.validateImages(imageURLs)
        let data: Data
        do { data = try await send("/_v2/moments/create", ["textContent": clean, "imgUrls": imageURLs, "displayRange": displayRange], signedIn: true) }
        catch GlazeVaultTradeError.business(let code, _) where code == "2066" { return .pendingReview }
        let root = try Self.object(data)
        guard let published = Self.boolean(root["published"]) else { throw GlazeVaultTradeError.invalidResponse }
        if published {
            guard let id = Self.positiveID(root["friendsCircleId"]) else { throw GlazeVaultTradeError.invalidResponse }
            return .published(id)
        }
        throw chosenDonutAvatarAsset.publicationRejected(currentLevel: Self.integer(root["currentLevel"]), targetLevel: Self.integer(root["targetLevel"]), validImageURLs: root["validImgUrls"] as? [String])
    }

    private func requireSignedIn() throws { guard isSignedIn() else { throw chosenDonutAvatarAsset.loginRequired } }
    private func captureSignedInScope() throws -> String {
        try Task.checkCancellation()
        try requireSignedIn()
        return scope()
    }
    private func requireSignedInScope(_ expected: String) throws {
        guard !Task.isCancelled, scope() == expected else { throw CancellationError() }
        try requireSignedIn()
    }
    private func requireInteraction(_ id: Int64) async throws {
        guard try await moment(id: id).allowsInteraction else { throw chosenDonutAvatarAsset.interactionUnavailable }
    }
    private func currentScope() -> String {
        let value = scope()
        if value != cachedScope { cachedPosts.removeAll(); cachedScope = value }
        return value
    }
    private func send(_ path: String, _ body: [String: Any], signedIn: Bool) async throws -> Data {
        // A signed-in action belongs to the account that initiated it, including any
        // suspension while preparing the runtime. Guest bootstrap may establish a scope.
        let preparedScope = signedIn ? try captureSignedInScope() : nil
        do { try await prepare() }
        catch {
            if let preparedScope { try requireSignedInScope(preparedScope) }
            throw error
        }
        if let preparedScope { try requireSignedInScope(preparedScope) }
        let before = currentScope()
        do {
            let data = try await request(path, body, signedIn)
            guard !Task.isCancelled, before == scope() else { throw CancellationError() }
            return data
        } catch {
            guard !Task.isCancelled, before == scope() else { throw CancellationError() }
            throw error
        }
    }
    private static func object(_ data: Data) throws -> [String: Any] {
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw GlazeVaultTradeError.invalidResponse }
        return object
    }
    private static func requireSuccess(_ data: Data) throws {
        guard boolean(try object(data)["success"]) == true else { throw GlazeVaultTradeError.invalidResponse }
    }
    private static func post(_ row: [String: Any]) throws -> caramelPecanMedley {
        guard let id = positiveID(row["id"]), let owner = positiveID(row["userId"]) else { throw GlazeVaultTradeError.invalidResponse }
        let appID = text(row["appId"]) ?? ""
        let card = butteryTexture(coconutCenter: id, vanillaBeanIcing: owner, gingerHoneyDrizzle: text(row["nickname"]) ?? "WevV",
            cheesecakeMousse: text(row["icon"]), caramelCurd: text(row["textContent"]) ?? text(row["title"]) ?? "",
            passionfruitFilling: row["imgUrls"] as? [String] ?? [], limeCream: max(0, integer(row["likeNum"]) ?? 0),
            apricotCenter: max(0, integer(row["commentNum"]) ?? 0), figCustard: text(row["createTime"]) ?? "",
            mascarponeCream: flag(row["followFlag"]), cherryCompote: flag(row["likeFlag"]), custardMousse: false,
            peachFilling: nil, pearJam: nil)
        return caramelPecanMedley(card: card, appID: appID)
    }
    private static func comment(_ row: [String: Any], parentID: Int64?) throws -> featherlightBite {
        guard let id = positiveID(row["id"]), let owner = positiveID(row["userId"]) else { throw GlazeVaultTradeError.invalidResponse }
        let suppliedParent = positiveID(row["parentCommentId"])
        if let parentID, let suppliedParent, parentID != suppliedParent { throw GlazeVaultTradeError.invalidResponse }
        return featherlightBite(blueberryCompote: id, vanillaBeanIcing: owner, gingerHoneyDrizzle: text(row["nickname"]) ?? "WevV",
            cheesecakeMousse: text(row["icon"]), figMousse: text(row["commentContent"]) ?? "", figCustard: text(row["createTime"]) ?? "", apricotFilling: suppliedParent ?? parentID)
    }
    private static func text(_ value: Any?) -> String? {
        if let value = value as? String { return value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : value }
        if let value = value as? NSNumber, CFGetTypeID(value) != CFBooleanGetTypeID() { return value.stringValue }
        return nil
    }
    private static func positiveID(_ raw: Any?) -> Int64? {
        guard let text = text(raw), let id = Int64(text), id > 0 else { return nil }; return id
    }
    private static func integer(_ raw: Any?) -> Int? { text(raw).flatMap(Int.init) }
    private static func boolean(_ raw: Any?) -> Bool? {
        guard let value = raw as? NSNumber, CFGetTypeID(value) == CFBooleanGetTypeID() else { return nil }; return value.boolValue
    }
    private static func flag(_ raw: Any?) -> Bool { boolean(raw) ?? (integer(raw) == 1) }
    private static func validateImages(_ urls: [String]) throws {
        guard urls.count <= 9, urls.allSatisfy({ text in
            guard let url = URLComponents(string: text), url.scheme?.lowercased() == "https", let host = url.host, !host.isEmpty, url.user == nil, url.password == nil else { return false }
            return true
        }) else { throw chosenDonutAvatarAsset.invalidParameters }
    }
}
