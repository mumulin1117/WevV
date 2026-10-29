import Foundation

extension LisenNoticepoplater {
    /// One raw feed cursor; a refresh invalidates pending older page responses.
    struct honeyScout {
        static let pageSize = 20
        private(set) var posts: [butteryTexture] = []
        private(set) var cursor: Int64 = 0
        private(set) var hasMore = false
        private(set) var isLoading = false
        private(set) var failed = false
        private var requestID = UUID()
        private(set) var currentPage: Int64 = 0
        private var restored = Set<Int64>()

        mutating func refresh() -> UUID {
            requestID = UUID()
            currentPage = 0
            isLoading = true
            failed = false
            return requestID
        }

        mutating func start() -> (id: UUID, cursor: Int64)? {
            guard hasMore, !isLoading, !(failed && currentPage == 0) else { return nil }
            requestID = UUID()
            currentPage = cursor
            isLoading = true
            failed = false
            return (requestID, cursor)
        }

        @discardableResult
        mutating func completeGlaze(_ page: choiceStackPacket, requestID: UUID) -> Bool {
            guard self.requestID == requestID, isLoading else { return false }
            let count = currentPage == 0 ? 0 : posts.count
            if currentPage == 0 { restored.removeAll() }
            restored.insert(currentPage)
            var seen = Set<Int64>()
            posts = ((currentPage == 0 ? [] : posts) + page.posts.map(\.card)).filter {
                seen.insert($0.coconutCenter).inserted
            }
            hasMore = !page.isLastPage && posts.count > count
            if let cursor = page.nextCursor, !restored.contains(cursor) { self.cursor = cursor }
            else { hasMore = false }
            isLoading = false
            failed = false
            return true
        }

        @discardableResult
        mutating func showGlazeError(requestID: UUID) -> Bool {
            guard self.requestID == requestID, isLoading else { return false }
            isLoading = false
            failed = true
            return true
        }
    }
}
