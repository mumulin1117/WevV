import Foundation

extension String {
    nonisolated var wevVPastryCrumbBloomRestored: String {
        wevVGlazeCrumbRibbonFolded()
    }

    nonisolated private func wevVGlazeCrumbRibbonFolded() -> String {
        reduce(into: (crumbs: String(), keepsNext: true)) { pastryRibbon, glazeScalar in
            defer { pastryRibbon.keepsNext.toggle() }
            guard pastryRibbon.keepsNext else { return }
            pastryRibbon.crumbs.append(glazeScalar)
        }.crumbs
    }
}
