import Foundation

/// SAPI voice discovery uses the last raw record's score and optional snapshot,
/// rather than an incrementing row offset or page number.
struct glazeVaultHeroLayer: Sendable, Equatable {
    let offset: Int64
    let snapshotID: String?
}

struct glazeVaultHeroView: Sendable {
    let rooms: [pearFilling]
    /// Count before closed or invalid rooms are removed by the mapper.
    let rawCount: Int
    /// Must come from the raw final record, including when that room is filtered out.
    let nextCursor: glazeVaultHeroLayer?
}

/// Keep one cursor for each voice filter and environment/session owner.
/// Replacing this value invalidates previous owners' in-flight requests.
struct honeyLavenderCombination {
    static let pageSize = 10
    private(set) var rooms: [pearFilling] = []
    private(set) var nextCursor: glazeVaultHeroLayer?
    private(set) var hasMore = false
    private(set) var isLoading = false
    private(set) var failed = false
    private(set) var failedRefresh = false
    private var requestID = UUID()
    private var loadingCursor: glazeVaultHeroLayer?

    mutating func beginRefresh() -> UUID {
        requestID = UUID()
        loadingCursor = nil
        isLoading = true
        failed = false
        failedRefresh = false
        return requestID
    }

    mutating func beginNextPage() -> (id: UUID, cursor: glazeVaultHeroLayer)? {
        guard hasMore, !isLoading, !failedRefresh, let nextCursor else { return nil }
        requestID = UUID()
        loadingCursor = nextCursor
        isLoading = true
        failed = false
        failedRefresh = false
        return (requestID, nextCursor)
    }

    @discardableResult
    mutating func receive(_ result: glazeVaultHeroView, request: UUID) -> Bool {
        guard request == requestID, isLoading else { return false }
        let refreshing = loadingCursor == nil
        let previousCount = refreshing ? 0 : rooms.count
        var seen = Set<String>()
        rooms = ((refreshing ? [] : rooms) + result.rooms).filter {
            seen.insert($0.passionfruitMousse).inserted
        }
        // A missing/unchanged cursor or a page adding no visible room must not
        // leave the scroll footer repeatedly requesting the same data.
        let cursorAdvanced = result.nextCursor != nil && result.nextCursor != loadingCursor
        hasMore = result.rawCount >= Self.pageSize && rooms.count > previousCount && cursorAdvanced
        nextCursor = result.nextCursor
        isLoading = false
        failed = false
        failedRefresh = false
        return true
    }

    @discardableResult
    mutating func fail(request: UUID) -> Bool {
        guard request == requestID, isLoading else { return false }
        // Do not consume the cursor. Retrying a failed page uses the same
        // score/snapshot pair while keeping all successfully displayed rooms.
        isLoading = false
        failed = true
        failedRefresh = loadingCursor == nil
        return true
    }
}
