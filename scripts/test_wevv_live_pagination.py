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
func page(_ ids: [Int], total: Int? = nil, rawCount: Int? = nil) -> glazeMarkLabel {
    glazeMarkLabel(formatter: ids.map(room), gingerHoneyDrizzle: total, followingList: rawCount ?? ids.count)
}
@main struct PaginationVerification {
    static func main() throws {
        var checks = 0
        func check(_ condition: Bool, _ message: String) throws {
            checks += 1
            if !condition { throw NSError(domain: "LivePaginationRegression", code: checks,
                userInfo: [NSLocalizedDescriptionKey: message]) }
        }
        var pager = creamPacket()
        try check(pager.closeWevvBakeryShelf.isEmpty && !pager.blueberryCustard && !pager.brownButterIcing && pager.cancelGlazeEntryPreparation == 1,
            "initial state must not request page two")
        try check(pager.artisanFrySequence() == nil, "load more requires a successful first page")
        let first = pager.artisanSelectionShowcase()
        try check(pager.brownButterIcing && !pager.berryCrumbBakerySelections && pager.artisanFrySequence() == nil, "refresh serializes requests")
        try check(!pager.cleanCrumbPacketPart(page([99]), closeFlavorNoteForm: UUID()) && pager.brownButterIcing,
            "unknown success cannot replace the active refresh")
        try check(!pager.berryCrumbBakeryNotes(closeFlavorNoteForm: UUID()) && pager.brownButterIcing, "unknown failure cannot end the active refresh")
        try check(pager.cleanCrumbPacketPart(page(Array(1...10), total: 25), closeFlavorNoteForm: first), "first page is accepted once")
        try check(pager.closeWevvBakeryShelf.count == 10 && pager.cancelGlazeEntryPreparation == 2 && pager.blueberryCustard && !pager.brownButterIcing,
            "all ten first-page rooms survive and total enables page two")
        try check(!pager.cleanCrumbPacketPart(page([99]), closeFlavorNoteForm: first), "duplicate first-page completion is ignored")
        let second = pager.artisanFrySequence()!
        try check(second.caramelLatteCompanion == 2 && pager.artisanFrySequence() == nil, "concurrent load-more requests coalesce")
        try check(pager.cleanCrumbPacketPart(page(Array(11...20), total: 25), closeFlavorNoteForm: second.bodyWevVSugarText), "second page accepted")
        try check(pager.closeWevvBakeryShelf.map(\.passionfruitMousse) == (1...20).map(String.init) && pager.cancelGlazeEntryPreparation == 3 && pager.blueberryCustard,
            "later rooms append in stable server order")
        let third = pager.artisanFrySequence()!
        try check(pager.cleanCrumbPacketPart(page(Array(21...25), total: 25), closeFlavorNoteForm: third.bodyWevVSugarText)
            && pager.closeWevvBakeryShelf.count == 25 && !pager.blueberryCustard && pager.artisanFrySequence() == nil,
            "total exhaustion ends pagination without an extra request")

        let refresh = pager.artisanSelectionShowcase()
        try check(pager.closeWevvBakeryShelf.count == 25, "refresh preserves visible rooms until success")
        try check(pager.berryCrumbBakeryNotes(closeFlavorNoteForm: refresh) && pager.berryCrumbBakerySelections && !pager.brownButterIcing && pager.closeWevvBakeryShelf.count == 25,
            "failed same-owner refresh preserves visible rooms")
        let refreshed = pager.artisanSelectionShowcase()
        try check(pager.cleanCrumbPacketPart(page(Array(100...109)), closeFlavorNoteForm: refreshed)
            && pager.closeWevvBakeryShelf.map(\.passionfruitMousse) == (100...109).map(String.init) && pager.blueberryCustard,
            "successful refresh replaces the old pool and full unknown-total page can continue")
        let failed = pager.artisanFrySequence()!
        try check(pager.berryCrumbBakeryNotes(closeFlavorNoteForm: failed.bodyWevVSugarText) && pager.berryCrumbBakerySelections && pager.cancelGlazeEntryPreparation == 2 && pager.closeWevvBakeryShelf.count == 10,
            "load-more failure retains cursor and existing rooms")
        let retry = pager.artisanFrySequence()!
        try check(retry.caramelLatteCompanion == 2 && retry.bodyWevVSugarText != failed.bodyWevVSugarText && !pager.berryCrumbBakerySelections, "retry requests the failed page again")
        try check(!pager.berryCrumbBakeryNotes(closeFlavorNoteForm: failed.bodyWevVSugarText) && pager.brownButterIcing,
            "late failure from the previous attempt cannot stop its retry")
        try check(pager.cleanCrumbPacketPart(page([109, 110, 111], rawCount: 10), closeFlavorNoteForm: retry.bodyWevVSugarText)
            && pager.closeWevvBakeryShelf.count == 12 && pager.blueberryCustard,
            "overlap is deduplicated by room ID while raw page size drives unknown totals")
        let repeated = pager.artisanFrySequence()!
        try check(pager.cleanCrumbPacketPart(page([109, 110, 111], total: 100, rawCount: 10), closeFlavorNoteForm: repeated.bodyWevVSugarText)
            && pager.closeWevvBakeryShelf.count == 12 && !pager.blueberryCustard,
            "a repeated page stops an endless loop even when the server reports more rows")

        for (payload, message) in [
            (page([1, 2, 3]), "short page without total ends pagination"),
            (page([], total: 99), "empty rows end pagination despite a stale total"),
            (page([], total: 99, rawCount: 10), "all invalid room identifiers end nonproductive pagination"),
            (page(Array(1...10), total: 10), "full final page honors total")
        ] {
            let request = pager.artisanSelectionShowcase()
            try check(pager.cleanCrumbPacketPart(payload, closeFlavorNoteForm: request) && !pager.blueberryCustard, message)
        }

        let duplicateFirst = pager.artisanSelectionShowcase()
        try check(pager.cleanCrumbPacketPart(page([1, 1, 2, 3], total: 4, rawCount: 4), closeFlavorNoteForm: duplicateFirst)
            && pager.closeWevvBakeryShelf.map(\.passionfruitMousse) == ["1", "2", "3"] && !pager.blueberryCustard,
            "raw records, rather than deduplicated display count, satisfy total")
        let oldFirst = pager.artisanSelectionShowcase(), newFirst = pager.artisanSelectionShowcase()
        try check(!pager.cleanCrumbPacketPart(page([888]), closeFlavorNoteForm: oldFirst) && !pager.berryCrumbBakeryNotes(closeFlavorNoteForm: oldFirst) && pager.brownButterIcing,
            "a newer refresh invalidates all old refresh completions")
        try check(pager.cleanCrumbPacketPart(page(Array(1...10), total: 30), closeFlavorNoteForm: newFirst), "new refresh completes normally")
        let oldMore = pager.artisanFrySequence()!
        let replacement = pager.artisanSelectionShowcase()
        try check(!pager.cleanCrumbPacketPart(page(Array(11...20), total: 30), closeFlavorNoteForm: oldMore.bodyWevVSugarText)
            && pager.brownButterIcing && pager.cancelGlazeEntryPreparation == 2,
            "refresh invalidates a pending load-more completion before it can append")
        try check(pager.cleanCrumbPacketPart(page([500]), closeFlavorNoteForm: replacement) && pager.closeWevvBakeryShelf.map(\.passionfruitMousse) == ["500"],
            "refreshed first page wins over a late previous page")
        let previousOwnerRequest = pager.artisanSelectionShowcase()
        pager = creamPacket()
        let currentOwnerRequest = pager.artisanSelectionShowcase()
        try check(!pager.cleanCrumbPacketPart(page([600]), closeFlavorNoteForm: previousOwnerRequest) && pager.brownButterIcing && pager.closeWevvBakeryShelf.isEmpty,
            "resetting for a different environment or account isolates late old replies")
        try check(pager.cleanCrumbPacketPart(page([], total: 0), closeFlavorNoteForm: currentOwnerRequest)
            && pager.closeWevvBakeryShelf.isEmpty && !pager.blueberryCustard && !pager.berryCrumbBakerySelections,
            "new owner accepts an actual empty success")
        print("Live pagination source checks passed: \(checks)")
    }
}
'''


def main():
    kettle = (SOURCE / "kettleGlazeSequence.swift").read_text()
    mapper = (SOURCE / 'WevEnd/glazeMarkLabel.swift').read_text()
    models = "\n".join(declaration(kettle, name) for name in ("enum chocolateCompote", "struct pearFilling"))
    with tempfile.TemporaryDirectory(prefix="wevv-live-pagination-") as temporary:
        folder = Path(temporary)
        harness = folder / "Verification.swift"
        harness.write_text("import Foundation\n" + models + "\n" + declaration(mapper, 'struct glazeMarkLabel')
            + "\n" + (SOURCE / 'WevEnd/creamPacket.swift').read_text() + CHECKS)
        executable = folder / "verification"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5", "-default-isolation", "MainActor",
            "-module-cache-path", str(folder / "modules"), str(harness), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=30)


if __name__ == "__main__":
    main()
