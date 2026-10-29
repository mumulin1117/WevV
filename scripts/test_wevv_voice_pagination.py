#!/usr/bin/env python3
"""Exercise the real voice cursor state without UIKit, network or user data."""
from pathlib import Path
import runpy
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WevSweetgd/WevSweetgd"
declaration = runpy.run_path(str(ROOT / "scripts/verify_wevv_session_runtime.py"))["declaration"]

CHECKS = r'''
import Foundation
func room(_ id: Int, owner: String = "7") -> pearFilling {
    pearFilling(passionfruitMousse: String(id), lemonCurd: .blackberryCream, limeJam: "Synthetic room",
        yuzuCustard: owner, peachCream: "Synthetic", pearCenter: nil, appleCompote: nil,
        figFilling: 0, custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false)
}
func cursor(_ score: Int64, _ snapshot: String? = "synthetic-snapshot") -> glazeVaultHeroLayer {
    glazeVaultHeroLayer(offset: score, snapshotID: snapshot)
}
func page(_ ids: [Int], rawCount: Int? = nil, next: glazeVaultHeroLayer? = nil) -> glazeVaultHeroView {
    glazeVaultHeroView(rooms: ids.map { room($0) }, rawCount: rawCount ?? ids.count, nextCursor: next)
}
@main struct VoicePaginationVerification {
    static func main() throws {
        var checks = 0
        func check(_ condition: Bool, _ message: String) throws {
            checks += 1
            if !condition { throw NSError(domain: "VoicePaginationRegression", code: checks,
                userInfo: [NSLocalizedDescriptionKey: message]) }
        }
        var pager = honeyLavenderCombination()
        try check(honeyLavenderCombination.pageSize == 10, "voice page size must match delivered H5")
        try check(pager.rooms.isEmpty && pager.nextCursor == nil && !pager.hasMore && !pager.isLoading && !pager.failed && !pager.failedRefresh,
            "initial request has neither offset nor snapshot")
        try check(pager.beginNextPage() == nil, "load more cannot run before first page succeeds")
        let first = pager.beginRefresh()
        try check(pager.isLoading && !pager.failed && pager.beginNextPage() == nil, "refresh serializes pagination")
        try check(!pager.receive(page([99], next: cursor(999)), request: UUID()) && pager.isLoading,
            "unknown success cannot replace the active request")
        try check(!pager.fail(request: UUID()) && pager.isLoading, "unknown failure cannot cancel the active request")
        try check(pager.receive(page(Array(1...10), next: cursor(900)), request: first), "first page accepted")
        try check(pager.rooms.count == 10 && pager.hasMore && pager.nextCursor == cursor(900) && !pager.isLoading,
            "full first page stores raw score, rather than a row count")
        try check(!pager.receive(page([99]), request: first) && !pager.fail(request: first),
            "a completed request cannot run twice")
        let second = pager.beginNextPage()!
        try check(second.cursor == cursor(900) && pager.beginNextPage() == nil, "load more uses exact stored cursor once")
        try check(pager.receive(page(Array(11...20), next: cursor(200)), request: second.id), "second page accepted")
        try check(pager.rooms.map(\.passionfruitMousse) == (1...20).map(String.init) && pager.nextCursor == cursor(200) && pager.hasMore,
            "decreasing sort score remains valid and stable server order is appended")
        let third = pager.beginNextPage()!
        try check(pager.receive(page(Array(21...23), next: cursor(0, nil)), request: third.id)
            && pager.rooms.count == 23 && !pager.hasMore && pager.beginNextPage() == nil,
            "short final raw page ends pagination even when it carries a cursor")

        let refresh = pager.beginRefresh()
        try check(pager.rooms.count == 23 && pager.nextCursor == cursor(0, nil),
            "refresh preserves visible rooms and previous cursor until success")
        try check(pager.fail(request: refresh) && pager.failed && pager.failedRefresh && !pager.isLoading && pager.rooms.count == 23,
            "refresh error preserves same-owner visible content")
        let refreshed = pager.beginRefresh()
        try check(!pager.failed && !pager.failedRefresh && pager.receive(page(Array(100...109), next: cursor(0, nil)), request: refreshed)
            && pager.rooms.map(\.passionfruitMousse) == (100...109).map(String.init) && pager.hasMore,
            "refresh starts without prior cursor, replaces old rooms, and accepts zero offset without snapshot")
        let failed = pager.beginNextPage()!
        try check(failed.cursor == cursor(0, nil) && pager.fail(request: failed.id)
            && pager.failed && !pager.failedRefresh && pager.nextCursor == cursor(0, nil) && pager.rooms.count == 10,
            "failed load more does not consume score or discard content")
        let retry = pager.beginNextPage()!
        try check(retry.cursor == failed.cursor && retry.id != failed.id && !pager.failed,
            "retry reuses the exact failed score/snapshot under a fresh request ID")
        try check(!pager.fail(request: failed.id) && !pager.receive(page([999]), request: failed.id) && pager.isLoading,
            "late completion from a failed attempt cannot end its retry")
        try check(pager.receive(page([109, 110, 111], rawCount: 10, next: cursor(-30, nil)), request: retry.id)
            && pager.rooms.count == 12 && pager.hasMore,
            "overlap deduplicates by real room ID; raw page size and negative score are preserved")
        let repeated = pager.beginNextPage()!
        try check(pager.receive(page([109, 110, 111], rawCount: 10, next: cursor(-40)), request: repeated.id)
            && pager.rooms.count == 12 && !pager.hasMore,
            "no new real room ends repeated-page loops even if the cursor changes")

        let stopped = pager.beginRefresh()
        try check(pager.receive(page(Array(1...10), next: cursor(123)), request: stopped), "new full page starts cursor test")
        let unchanged = pager.beginNextPage()!
        try check(pager.receive(page(Array(11...20), next: cursor(123)), request: unchanged.id)
            && pager.rooms.count == 20 && !pager.hasMore,
            "unchanged score and snapshot stop pagination despite new rows")
        let snapshotStart = pager.beginRefresh()
        try check(pager.receive(page(Array(1...10), next: cursor(123, "snapshot-a")), request: snapshotStart),
            "snapshot test first page accepted")
        let snapshotMore = pager.beginNextPage()!
        try check(pager.receive(page(Array(11...20), next: cursor(123, "snapshot-b")), request: snapshotMore.id)
            && pager.hasMore && pager.nextCursor == cursor(123, "snapshot-b"),
            "same score with a different snapshot remains a distinct forward cursor")

        for (payload, message) in [
            (page([1, 2, 3], next: cursor(7)), "short page ends pagination"),
            (page([], next: cursor(7)), "empty page ends pagination"),
            (page([], rawCount: 10, next: cursor(7)), "all filtered records end nonproductive pagination"),
            (page(Array(1...10)), "missing raw final score cannot invent a cursor")
        ] {
            let request = pager.beginRefresh()
            try check(pager.receive(payload, request: request) && !pager.hasMore && pager.beginNextPage() == nil, message)
        }
        let duplicates = pager.beginRefresh()
        try check(pager.receive(page([1, 1, 2, 3], rawCount: 10, next: cursor(Int64.max)), request: duplicates)
            && pager.rooms.map(\.passionfruitMousse) == ["1", "2", "3"] && pager.hasMore
            && pager.nextCursor?.offset == Int64.max,
            "in-page duplicates preserve first occurrence; Int64 score must not lose precision")
        let lowest = pager.beginNextPage()!
        try check(pager.receive(page(Array(4...13), next: cursor(Int64.min)), request: lowest.id)
            && pager.hasMore && pager.nextCursor?.offset == Int64.min,
            "cursor transport does not impose a positive score or increment Long values")
        let sameOwner = pager.beginRefresh()
        let sameOwnerPage = glazeVaultHeroView(rooms: [room(1000, owner: "77"), room(1001, owner: "77")],
            rawCount: 10, nextCursor: cursor(999))
        try check(pager.receive(sameOwnerPage, request: sameOwner) && pager.rooms.count == 2 && pager.hasMore,
            "rooms sharing an owner remain distinct: deduplication uses room ID rather than business user ID")

        let oldRefresh = pager.beginRefresh(), latestRefresh = pager.beginRefresh()
        try check(!pager.receive(page([888]), request: oldRefresh) && !pager.fail(request: oldRefresh) && pager.isLoading,
            "new refresh invalidates previous refresh completions")
        try check(pager.receive(page(Array(1...10), next: cursor(500)), request: latestRefresh), "latest refresh completes")
        let failedRefreshWithMore = pager.beginRefresh()
        try check(pager.fail(request: failedRefreshWithMore) && pager.failedRefresh && pager.hasMore
            && pager.rooms.count == 10 && pager.nextCursor == cursor(500) && pager.beginNextPage() == nil,
            "failed refresh blocks old next-page cursor while retaining previously visible rows")
        let retryRefreshWithMore = pager.beginRefresh()
        try check(!pager.failed && !pager.failedRefresh && pager.isLoading
            && pager.receive(page(Array(1...10), next: cursor(500)), request: retryRefreshWithMore)
            && pager.hasMore && !pager.failedRefresh,
            "refresh retry resets failure kind and accepts a first-page response with the old cursor")
        let oldMore = pager.beginNextPage()!
        let replacement = pager.beginRefresh()
        try check(!pager.receive(page(Array(11...20), next: cursor(300)), request: oldMore.id)
            && !pager.fail(request: oldMore.id) && pager.isLoading,
            "refresh invalidates pending load-more results before they can append")
        try check(pager.receive(page([500]), request: replacement) && pager.rooms.map(\.passionfruitMousse) == ["500"],
            "successful replacement wins over prior pages")
        let previousOwner = pager.beginRefresh()
        pager = honeyLavenderCombination()
        let currentOwner = pager.beginRefresh()
        try check(!pager.receive(page([600]), request: previousOwner) && !pager.fail(request: previousOwner)
            && pager.rooms.isEmpty && pager.isLoading,
            "account/environment reset rejects previous owners' successful and failed responses")
        try check(pager.receive(page([]), request: currentOwner) && pager.rooms.isEmpty && !pager.hasMore && !pager.failed && !pager.failedRefresh,
            "new owner accepts an actual empty success")

        var recommend = honeyLavenderCombination(), followed = honeyLavenderCombination()
        let recommendRequest = recommend.beginRefresh(), followedRequest = followed.beginRefresh()
        try check(recommend.receive(page(Array(1...10), next: cursor(44, "recommended")), request: recommendRequest)
            && followed.receive(page([77]), request: followedRequest), "both filters load independently")
        let recommendMore = recommend.beginNextPage()!
        let followedRefresh = followed.beginRefresh()
        try check(!followed.receive(page([999]), request: recommendMore.id) && followed.isLoading
            && recommend.isLoading && followed.rooms.map(\.passionfruitMousse) == ["77"],
            "switching filter never accepts another filter's response or consumes its cursor")
        try check(recommend.receive(page(Array(11...20), next: cursor(40, "recommended")), request: recommendMore.id)
            && followed.receive(page([]), request: followedRefresh) && recommend.rooms.count == 20
            && recommend.hasMore && followed.rooms.isEmpty && !followed.hasMore,
            "independent follow refresh cannot clear or stop recommended pagination")
        print("Voice pagination source checks passed: \(checks)")
    }
}
'''


def main():
    kettle = (SOURCE / "kettleGlazeSequence.swift").read_text()
    models = "\n".join(declaration(kettle, name) for name in ("enum chocolateCompote", "struct pearFilling"))
    with tempfile.TemporaryDirectory(prefix="wevv-voice-pagination-") as temporary:
        folder = Path(temporary)
        harness = folder / "Verification.swift"
        harness.write_text("import Foundation\n" + models + "\n"
            + (SOURCE / 'WevEnd/honeyLavenderCombination.swift').read_text() + CHECKS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5", "-default-isolation", "MainActor",
            "-module-cache-path", str(folder / "modules"), str(harness), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()
