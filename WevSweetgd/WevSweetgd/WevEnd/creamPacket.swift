import Foundation

/// One live-pool cursor per environment/session. Request IDs also reject late refresh replies.
struct creamPacket {
    static let pageSize = 10
    private(set) var rooms: [pearFilling] = []
    private(set) var nextPage = 1
    private(set) var hasMore = false
    private(set) var isLoading = false
    private(set) var failed = false
    private var requestID = UUID()
    private var loadingPage = 1
    private var loadedRowCount = 0
    mutating func beginRefresh() -> UUID {
        requestID = UUID()
        loadingPage = 1
        isLoading = true
        failed = false
        return requestID
    }

    mutating func beginNextPage() -> (id: UUID, page: Int)? {
        guard hasMore, !isLoading else { return nil }
        requestID = UUID()
        loadingPage = nextPage
        isLoading = true
        failed = false
        return (requestID, loadingPage)
    }

    @discardableResult
    mutating func receive(_ result: glazeMarkLabel, request: UUID) -> Bool {
        guard request == requestID, isLoading else { return false }
        let previousCount = loadingPage == 1 ? 0 : rooms.count
        var seen = Set<String>()
        rooms = ((loadingPage == 1 ? [] : rooms) + result.rooms).filter {
            seen.insert($0.passionfruitMousse).inserted
        }
        loadedRowCount = (loadingPage == 1 ? 0 : loadedRowCount) + result.rawCount
        nextPage = loadingPage + 1
        // A repeated page must not allow an endless sequence of identical requests.
        let madeProgress = rooms.count > previousCount
        hasMore = result.rawCount > 0 && madeProgress && (result.total.map {
            loadedRowCount < $0
        } ?? (result.rawCount >= Self.pageSize))
        isLoading = false
        failed = false
        return true
    }

    @discardableResult
    mutating func fail(request: UUID) -> Bool {
        guard request == requestID, isLoading else { return false }
        isLoading = false
        failed = true
        return true
    }
}
