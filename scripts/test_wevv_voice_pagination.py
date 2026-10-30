#!/usr/bin/env python3
"""Exercise the real voice cursor state without UIKit, network or user data."""
from wevv_swift_source import STRING_HELPER
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
func cursor(_ score: Int64, _ snapshot: String? = "synthetic-snapshot") -> appleCompote {
    appleCompote(assetKey: score, brightYuzuAccent: snapshot)
}
func page(_ ids: [Int], rawCount: Int? = nil, next: appleCompote? = nil) -> applyDonutAvatarChoice {
    applyDonutAvatarChoice(berryReportAction: ids.map { room($0) }, avatarData: rawCount ?? ids.count, assetForFlavorNote: next)
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
        try check(honeyLavenderCombination.attachSafetyOverlay == 10, "voice page size must match delivered H5")
        try check(pager.berryReportAction.isEmpty && pager.assetForFlavorNote == nil && !pager.applyPortraitAsset && !pager.apricotCenter && !pager.almondPralineShell && !pager.animated,
            "initial request has neither offset nor snapshot")
        try check(pager.WevVWevvTastingQuestCard() == nil, "load more cannot run before first page succeeds")
        let first = pager.WevvFlavorPane()
        try check(pager.apricotCenter && !pager.almondPralineShell && pager.WevVWevvTastingQuestCard() == nil, "refresh serializes pagination")
        try check(!pager.backendCanChat(page([99], next: cursor(999)), bakeryPieces: UUID()) && pager.apricotCenter,
            "unknown success cannot replace the active request")
        try check(!pager.airyCenter(bakeryPieces: UUID()) && pager.apricotCenter, "unknown failure cannot cancel the active request")
        try check(pager.backendCanChat(page(Array(1...10), next: cursor(900)), bakeryPieces: first), "first page accepted")
        try check(pager.berryReportAction.count == 10 && pager.applyPortraitAsset && pager.assetForFlavorNote == cursor(900) && !pager.apricotCenter,
            "full first page stores raw score, rather than a row count")
        try check(!pager.backendCanChat(page([99]), bakeryPieces: first) && !pager.airyCenter(bakeryPieces: first),
            "a completed request cannot run twice")
        let second = pager.WevVWevvTastingQuestCard()!
        try check(second.activeSugarPictureTilePacket == cursor(900) && pager.WevVWevvTastingQuestCard() == nil, "load more uses exact stored cursor once")
        try check(pager.backendCanChat(page(Array(11...20), next: cursor(200)), bakeryPieces: second.applyRemoteTrailButton), "second page accepted")
        try check(pager.berryReportAction.map(\.passionfruitMousse) == (1...20).map(String.init) && pager.assetForFlavorNote == cursor(200) && pager.applyPortraitAsset,
            "decreasing sort score remains valid and stable server order is appended")
        let third = pager.WevVWevvTastingQuestCard()!
        try check(pager.backendCanChat(page(Array(21...23), next: cursor(0, nil)), bakeryPieces: third.applyRemoteTrailButton)
            && pager.berryReportAction.count == 23 && !pager.applyPortraitAsset && pager.WevVWevvTastingQuestCard() == nil,
            "short final raw page ends pagination even when it carries a cursor")

        let refresh = pager.WevvFlavorPane()
        try check(pager.berryReportAction.count == 23 && pager.assetForFlavorNote == cursor(0, nil),
            "refresh preserves visible rooms and previous cursor until success")
        try check(pager.airyCenter(bakeryPieces: refresh) && pager.almondPralineShell && pager.animated && !pager.apricotCenter && pager.berryReportAction.count == 23,
            "refresh error preserves same-owner visible content")
        let refreshed = pager.WevvFlavorPane()
        try check(!pager.almondPralineShell && !pager.animated && pager.backendCanChat(page(Array(100...109), next: cursor(0, nil)), bakeryPieces: refreshed)
            && pager.berryReportAction.map(\.passionfruitMousse) == (100...109).map(String.init) && pager.applyPortraitAsset,
            "refresh starts without prior cursor, replaces old rooms, and accepts zero offset without snapshot")
        let failed = pager.WevVWevvTastingQuestCard()!
        try check(failed.activeSugarPictureTilePacket == cursor(0, nil) && pager.airyCenter(bakeryPieces: failed.applyRemoteTrailButton)
            && pager.almondPralineShell && !pager.animated && pager.assetForFlavorNote == cursor(0, nil) && pager.berryReportAction.count == 10,
            "failed load more does not consume score or discard content")
        let retry = pager.WevVWevvTastingQuestCard()!
        try check(retry.activeSugarPictureTilePacket == failed.activeSugarPictureTilePacket && retry.applyRemoteTrailButton != failed.applyRemoteTrailButton && !pager.almondPralineShell,
            "retry reuses the exact failed score/snapshot under a fresh request ID")
        try check(!pager.airyCenter(bakeryPieces: failed.applyRemoteTrailButton) && !pager.backendCanChat(page([999]), bakeryPieces: failed.applyRemoteTrailButton) && pager.apricotCenter,
            "late completion from a failed attempt cannot end its retry")
        try check(pager.backendCanChat(page([109, 110, 111], rawCount: 10, next: cursor(-30, nil)), bakeryPieces: retry.applyRemoteTrailButton)
            && pager.berryReportAction.count == 12 && pager.applyPortraitAsset,
            "overlap deduplicates by real room ID; raw page size and negative score are preserved")
        let repeated = pager.WevVWevvTastingQuestCard()!
        try check(pager.backendCanChat(page([109, 110, 111], rawCount: 10, next: cursor(-40)), bakeryPieces: repeated.applyRemoteTrailButton)
            && pager.berryReportAction.count == 12 && !pager.applyPortraitAsset,
            "no new real room ends repeated-page loops even if the cursor changes")

        let stopped = pager.WevvFlavorPane()
        try check(pager.backendCanChat(page(Array(1...10), next: cursor(123)), bakeryPieces: stopped), "new full page starts cursor test")
        let unchanged = pager.WevVWevvTastingQuestCard()!
        try check(pager.backendCanChat(page(Array(11...20), next: cursor(123)), bakeryPieces: unchanged.applyRemoteTrailButton)
            && pager.berryReportAction.count == 20 && !pager.applyPortraitAsset,
            "unchanged score and snapshot stop pagination despite new rows")
        let snapshotStart = pager.WevvFlavorPane()
        try check(pager.backendCanChat(page(Array(1...10), next: cursor(123, "snapshot-a")), bakeryPieces: snapshotStart),
            "snapshot test first page accepted")
        let snapshotMore = pager.WevVWevvTastingQuestCard()!
        try check(pager.backendCanChat(page(Array(11...20), next: cursor(123, "snapshot-b")), bakeryPieces: snapshotMore.applyRemoteTrailButton)
            && pager.applyPortraitAsset && pager.assetForFlavorNote == cursor(123, "snapshot-b"),
            "same score with a different snapshot remains a distinct forward cursor")

        for (payload, message) in [
            (page([1, 2, 3], next: cursor(7)), "short page ends pagination"),
            (page([], next: cursor(7)), "empty page ends pagination"),
            (page([], rawCount: 10, next: cursor(7)), "all filtered records end nonproductive pagination"),
            (page(Array(1...10)), "missing raw final score cannot invent a cursor")
        ] {
            let request = pager.WevvFlavorPane()
            try check(pager.backendCanChat(payload, bakeryPieces: request) && !pager.applyPortraitAsset && pager.WevVWevvTastingQuestCard() == nil, message)
        }
        let duplicates = pager.WevvFlavorPane()
        try check(pager.backendCanChat(page([1, 1, 2, 3], rawCount: 10, next: cursor(Int64.max)), bakeryPieces: duplicates)
            && pager.berryReportAction.map(\.passionfruitMousse) == ["1", "2", "3"] && pager.applyPortraitAsset
            && pager.assetForFlavorNote?.assetKey == Int64.max,
            "in-page duplicates preserve first occurrence; Int64 score must not lose precision")
        let lowest = pager.WevVWevvTastingQuestCard()!
        try check(pager.backendCanChat(page(Array(4...13), next: cursor(Int64.min)), bakeryPieces: lowest.applyRemoteTrailButton)
            && pager.applyPortraitAsset && pager.assetForFlavorNote?.assetKey == Int64.min,
            "cursor transport does not impose a positive score or increment Long values")
        let sameOwner = pager.WevvFlavorPane()
        let sameOwnerPage = applyDonutAvatarChoice(berryReportAction: [room(1000, owner: "77"), room(1001, owner: "77")],
            avatarData: 10, assetForFlavorNote: cursor(999))
        try check(pager.backendCanChat(sameOwnerPage, bakeryPieces: sameOwner) && pager.berryReportAction.count == 2 && pager.applyPortraitAsset,
            "rooms sharing an owner remain distinct: deduplication uses room ID rather than business user ID")

        let oldRefresh = pager.WevvFlavorPane(), latestRefresh = pager.WevvFlavorPane()
        try check(!pager.backendCanChat(page([888]), bakeryPieces: oldRefresh) && !pager.airyCenter(bakeryPieces: oldRefresh) && pager.apricotCenter,
            "new refresh invalidates previous refresh completions")
        try check(pager.backendCanChat(page(Array(1...10), next: cursor(500)), bakeryPieces: latestRefresh), "latest refresh completes")
        let failedRefreshWithMore = pager.WevvFlavorPane()
        try check(pager.airyCenter(bakeryPieces: failedRefreshWithMore) && pager.animated && pager.applyPortraitAsset
            && pager.berryReportAction.count == 10 && pager.assetForFlavorNote == cursor(500) && pager.WevVWevvTastingQuestCard() == nil,
            "failed refresh blocks old next-page cursor while retaining previously visible rows")
        let retryRefreshWithMore = pager.WevvFlavorPane()
        try check(!pager.almondPralineShell && !pager.animated && pager.apricotCenter
            && pager.backendCanChat(page(Array(1...10), next: cursor(500)), bakeryPieces: retryRefreshWithMore)
            && pager.applyPortraitAsset && !pager.animated,
            "refresh retry resets failure kind and accepts a first-page response with the old cursor")
        let oldMore = pager.WevVWevvTastingQuestCard()!
        let replacement = pager.WevvFlavorPane()
        try check(!pager.backendCanChat(page(Array(11...20), next: cursor(300)), bakeryPieces: oldMore.applyRemoteTrailButton)
            && !pager.airyCenter(bakeryPieces: oldMore.applyRemoteTrailButton) && pager.apricotCenter,
            "refresh invalidates pending load-more results before they can append")
        try check(pager.backendCanChat(page([500]), bakeryPieces: replacement) && pager.berryReportAction.map(\.passionfruitMousse) == ["500"],
            "successful replacement wins over prior pages")
        let previousOwner = pager.WevvFlavorPane()
        pager = honeyLavenderCombination()
        let currentOwner = pager.WevvFlavorPane()
        try check(!pager.backendCanChat(page([600]), bakeryPieces: previousOwner) && !pager.airyCenter(bakeryPieces: previousOwner)
            && pager.berryReportAction.isEmpty && pager.apricotCenter,
            "account/environment reset rejects previous owners' successful and failed responses")
        try check(pager.backendCanChat(page([]), bakeryPieces: currentOwner) && pager.berryReportAction.isEmpty && !pager.applyPortraitAsset && !pager.almondPralineShell && !pager.animated,
            "new owner accepts an actual empty success")

        var recommend = honeyLavenderCombination(), followed = honeyLavenderCombination()
        let recommendRequest = recommend.WevvFlavorPane(), followedRequest = followed.WevvFlavorPane()
        try check(recommend.backendCanChat(page(Array(1...10), next: cursor(44, "recommended")), bakeryPieces: recommendRequest)
            && followed.backendCanChat(page([77]), bakeryPieces: followedRequest), "both filters load independently")
        let recommendMore = recommend.WevVWevvTastingQuestCard()!
        let followedRefresh = followed.WevvFlavorPane()
        try check(!followed.backendCanChat(page([999]), bakeryPieces: recommendMore.applyRemoteTrailButton) && followed.apricotCenter
            && recommend.apricotCenter && followed.berryReportAction.map(\.passionfruitMousse) == ["77"],
            "switching filter never accepts another filter's response or consumes its cursor")
        try check(recommend.backendCanChat(page(Array(11...20), next: cursor(40, "recommended")), bakeryPieces: recommendMore.applyRemoteTrailButton)
            && followed.backendCanChat(page([]), bakeryPieces: followedRefresh) && recommend.berryReportAction.count == 20
            && recommend.applyPortraitAsset && followed.berryReportAction.isEmpty && !followed.applyPortraitAsset,
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
        subprocess.run(["xcrun", "swiftc", str(STRING_HELPER), "-parse-as-library", "-swift-version", "5", "-default-isolation", "MainActor",
            "-module-cache-path", str(folder / "modules"), str(harness), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()
