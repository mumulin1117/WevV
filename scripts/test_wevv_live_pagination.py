#!/usr/bin/env python3
"""Exercise the real live pagination state without UIKit, network, or user data."""
from pathlib import Path
import runpy
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WevSweetgd/WevSweetgd"
declaration = runpy.run_path(str(ROOT / "scripts/verify_wevv_session_runtime.py"))["declaration"]

CHECKS = r'''
import Foundation
func room(_ id: Int) -> pearFilling {
    pearFilling(passionfruitMousse: String(id), lemonCurd: .blueberryCustard, limeJam: "Synthetic room",
        yuzuCustard: "7", peachCream: "Synthetic", pearCenter: nil, appleCompote: nil,
        figFilling: 0, custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false)
}
func page(_ ids: [Int], total: Int? = nil, rawCount: Int? = nil) -> WevVGlazeLivePage {
    WevVGlazeLivePage(rooms: ids.map(room), total: total, rawCount: rawCount ?? ids.count)
}
@main struct PaginationVerification {
    static func main() throws {
        var checks = 0
        func check(_ condition: Bool, _ message: String) throws {
            checks += 1
            if !condition { throw NSError(domain: "LivePaginationRegression", code: checks,
                userInfo: [NSLocalizedDescriptionKey: message]) }
        }
        var pager = WevVGlazeLivePagination()
        try check(pager.rooms.isEmpty && !pager.hasMore && !pager.isLoading && pager.nextPage == 1,
            "initial state must not request page two")
        try check(pager.beginNextPage() == nil, "load more requires a successful first page")
        let first = pager.beginRefresh()
        try check(pager.isLoading && !pager.failed && pager.beginNextPage() == nil, "refresh serializes requests")
        try check(!pager.receive(page([99]), request: UUID()) && pager.isLoading,
            "unknown success cannot replace the active refresh")
        try check(!pager.fail(request: UUID()) && pager.isLoading, "unknown failure cannot end the active refresh")
        try check(pager.receive(page(Array(1...10), total: 25), request: first), "first page is accepted once")
        try check(pager.rooms.count == 10 && pager.nextPage == 2 && pager.hasMore && !pager.isLoading,
            "all ten first-page rooms survive and total enables page two")
        try check(!pager.receive(page([99]), request: first), "duplicate first-page completion is ignored")
        let second = pager.beginNextPage()!
        try check(second.page == 2 && pager.beginNextPage() == nil, "concurrent load-more requests coalesce")
        try check(pager.receive(page(Array(11...20), total: 25), request: second.id), "second page accepted")
        try check(pager.rooms.map(\.passionfruitMousse) == (1...20).map(String.init) && pager.nextPage == 3 && pager.hasMore,
            "later rooms append in stable server order")
        let third = pager.beginNextPage()!
        try check(pager.receive(page(Array(21...25), total: 25), request: third.id)
            && pager.rooms.count == 25 && !pager.hasMore && pager.beginNextPage() == nil,
            "total exhaustion ends pagination without an extra request")

        let refresh = pager.beginRefresh()
        try check(pager.rooms.count == 25, "refresh preserves visible rooms until success")
        try check(pager.fail(request: refresh) && pager.failed && !pager.isLoading && pager.rooms.count == 25,
            "failed same-owner refresh preserves visible rooms")
        let refreshed = pager.beginRefresh()
        try check(pager.receive(page(Array(100...109)), request: refreshed)
            && pager.rooms.map(\.passionfruitMousse) == (100...109).map(String.init) && pager.hasMore,
            "successful refresh replaces the old pool and full unknown-total page can continue")
        let failed = pager.beginNextPage()!
        try check(pager.fail(request: failed.id) && pager.failed && pager.nextPage == 2 && pager.rooms.count == 10,
            "load-more failure retains cursor and existing rooms")
        let retry = pager.beginNextPage()!
        try check(retry.page == 2 && retry.id != failed.id && !pager.failed, "retry requests the failed page again")
        try check(!pager.fail(request: failed.id) && pager.isLoading,
            "late failure from the previous attempt cannot stop its retry")
        try check(pager.receive(page([109, 110, 111], rawCount: 10), request: retry.id)
            && pager.rooms.count == 12 && pager.hasMore,
            "overlap is deduplicated by room ID while raw page size drives unknown totals")
        let repeated = pager.beginNextPage()!
        try check(pager.receive(page([109, 110, 111], total: 100, rawCount: 10), request: repeated.id)
            && pager.rooms.count == 12 && !pager.hasMore,
            "a repeated page stops an endless loop even when the server reports more rows")

        for (payload, message) in [
            (page([1, 2, 3]), "short page without total ends pagination"),
            (page([], total: 99), "empty rows end pagination despite a stale total"),
            (page([], total: 99, rawCount: 10), "all invalid room identifiers end nonproductive pagination"),
            (page(Array(1...10), total: 10), "full final page honors total")
        ] {
            let request = pager.beginRefresh()
            try check(pager.receive(payload, request: request) && !pager.hasMore, message)
        }

        let duplicateFirst = pager.beginRefresh()
        try check(pager.receive(page([1, 1, 2, 3], total: 4, rawCount: 4), request: duplicateFirst)
            && pager.rooms.map(\.passionfruitMousse) == ["1", "2", "3"] && !pager.hasMore,
            "raw records, rather than deduplicated display count, satisfy total")
        let oldFirst = pager.beginRefresh(), newFirst = pager.beginRefresh()
        try check(!pager.receive(page([888]), request: oldFirst) && !pager.fail(request: oldFirst) && pager.isLoading,
            "a newer refresh invalidates all old refresh completions")
        try check(pager.receive(page(Array(1...10), total: 30), request: newFirst), "new refresh completes normally")
        let oldMore = pager.beginNextPage()!
        let replacement = pager.beginRefresh()
        try check(!pager.receive(page(Array(11...20), total: 30), request: oldMore.id)
            && pager.isLoading && pager.nextPage == 2,
            "refresh invalidates a pending load-more completion before it can append")
        try check(pager.receive(page([500]), request: replacement) && pager.rooms.map(\.passionfruitMousse) == ["500"],
            "refreshed first page wins over a late previous page")
        let previousOwnerRequest = pager.beginRefresh()
        pager = WevVGlazeLivePagination()
        let currentOwnerRequest = pager.beginRefresh()
        try check(!pager.receive(page([600]), request: previousOwnerRequest) && pager.isLoading && pager.rooms.isEmpty,
            "resetting for a different environment or account isolates late old replies")
        try check(pager.receive(page([], total: 0), request: currentOwnerRequest)
            && pager.rooms.isEmpty && !pager.hasMore && !pager.failed,
            "new owner accepts an actual empty success")
        print("Live pagination source checks passed: \(checks)")
    }
}
'''


def main():
    kettle = (SOURCE / "kettleGlazeSequence.swift").read_text()
    mapper = (SOURCE / "WevVGlazeRoomMapper.swift").read_text()
    models = "\n".join(declaration(kettle, name) for name in ("enum chocolateCompote", "struct pearFilling"))
    with tempfile.TemporaryDirectory(prefix="wevv-live-pagination-") as temporary:
        folder = Path(temporary)
        harness = folder / "Verification.swift"
        harness.write_text("import Foundation\n" + models + "\n" + declaration(mapper, "struct WevVGlazeLivePage")
            + "\n" + (SOURCE / "WevVGlazeLivePagination.swift").read_text() + CHECKS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5", "-default-isolation", "MainActor",
            "-module-cache-path", str(folder / "modules"), str(harness), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()
