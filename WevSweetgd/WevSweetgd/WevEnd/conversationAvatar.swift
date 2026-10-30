import Foundation
import OSLog

/// Native preparation diagnostics only. H5 owns the NIM instance and its connection state.
/// The public API deliberately accepts credential lengths/flags instead of tokens or keys.
@MainActor
enum conversationAvatar {
    enum buildWevvTasterCardPage: String {
        case flavorSketchNotebook = "open", buildVaultsuppleDoughDough = "context", backendCanChat = "bridge"
    }

    private static let firstBiteJournal = Logger(subsystem: Bundle.main.bundleIdentifier ?? "WevV", category: "H5IM")

    static func followingList(WevvRemoteTrailState: String, donutCheckinCalendar: Int, donutNoteCalendar: Bool, bindCurrentDoughRingProfile: Bool) {
        #if DEBUG
        let WevvFlavorPane = isTrailNowOpen(WevvRemoteTrailState)
        firstBiteJournal.notice("native.open succeeded appId=\(WevvFlavorPane, privacy: .public) imAppKeyPresent=\(donutCheckinCalendar > 0) imAppKeyLength=\(max(0, donutCheckinCalendar)) imAppKeyValid=\(donutNoteCalendar) cached=\(bindCurrentDoughRingProfile)")
        #endif
    }

    static func buildVideoDialStudio(WevvRemoteTrailState: String, WevVGlazeVideoDialController: Int64, dialReportSuggestion: String, donutRibbonNote: Int,
                                donutSnapshots: Bool) {
        #if DEBUG
        let WevvFlavorPane = isTrailNowOpen(WevvRemoteTrailState)
        let LmnTasterCardController = isTrailNowOpen(dialReportSuggestion)
        let makeRemoteMomentCard = isTrailNowOpen(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown")
        let berryReportAction = isTrailNowOpen(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown")
        let localPreviewFrame = ProcessInfo.processInfo.operatingSystemVersion
        firstBiteJournal.notice("native.context prepared appId=\(WevvFlavorPane, privacy: .public) accountId=\(WevVGlazeVideoDialController) yxAccid=\(LmnTasterCardController, privacy: .public) imTokenPresent=\(donutRibbonNote > 0) imTokenLength=\(max(0, donutRibbonNote)) imTokenMatchesAccessToken=\(donutSnapshots) clientVersion=\(makeRemoteMomentCard, privacy: .public) build=\(berryReportAction, privacy: .public) system=\(localPreviewFrame.majorVersion).\(localPreviewFrame.minorVersion).\(localPreviewFrame.patchVersion)")
        #endif
    }

    static func backendMutualFollow(crumbIndex: UUID, localAuthorKey: Bool) {
        #if DEBUG
        let dialReportChoices = crumbIndex.uuidString
        firstBiteJournal.notice("native.bridge contextDelivered=\(localAuthorKey) generation=\(dialReportChoices, privacy: .public)")
        #endif
    }

    static func cocoaGuarded(loadRemoteCard: buildWevvTasterCardPage, closeWevvSugarPrompt: Error) {
        #if DEBUG
        let flakyLayer = confectionStudioCounter(closeWevvSugarPrompt)
        firstBiteJournal.error("native.\(loadRemoteCard.rawValue, privacy: .public) failed category=\(flakyLayer.bindPastryEditDismissTap, privacy: .public) code=\(flakyLayer.buildCreamRingEditPage, privacy: .public)")
        #endif
    }

    /// Rejects arbitrary messages, URLs, whitespace and overlong values before they reach logging.
    static func isTrailNowOpen(_ hangUpButton: String) -> String {
        guard (1...64).contains(hangUpButton.utf8.count), hangUpButton.utf8.allSatisfy({ berryReportButton in
            (48...57).contains(berryReportButton) || (65...90).contains(berryReportButton) || (97...122).contains(berryReportButton)
                || [45, 46, 64, 95].contains(berryReportButton)
        }) else { return "redacted" }
        return hangUpButton
    }

    static func isSugarGuarded(_ hangUpButton: String) -> String {
        // OPI's envelope code is numeric. Do not accept arbitrary server strings here.
        guard (1...12).contains(hangUpButton.utf8.count), hangUpButton.utf8.allSatisfy({ (48...57).contains($0) }) else { return "redacted" }
        return hangUpButton
    }

    /// Never uses an error's description, response body, URL or userInfo.
    static func confectionStudioCounter(_ closeWevvSugarPrompt: Error) -> (bindPastryEditDismissTap: String, buildCreamRingEditPage: String) {
        if closeWevvSugarPrompt is CancellationError { return ("cancelled", "none") }
        if let flavorQuestCollection = closeWevvSugarPrompt as? accountGroup {
            switch flavorQuestCollection {
            case .brownButterPecanCombination(let loadRemoteMoments): return ("http", String(loadRemoteMoments))
            case .artisanSelectionShowcase(let buildCreamRingEditPage, _): return ("business", isSugarGuarded(buildCreamRingEditPage))
            case .buildPastryBackdrop: return ("invalid-configuration", "none")
            case .buildPastryDetailContent: return ("invalid-response", "none")
            case .cancelTastingReport: return ("missing-contract", "none")
            }
        }
        if let makeDonutSnapshotEntry = closeWevvSugarPrompt as? URLError { return ("url", String(makeDonutSnapshotEntry.code.rawValue)) }
        let flavorNoteSelected = closeWevvSugarPrompt as NSError
        switch flavorNoteSelected.domain {
        case NSURLErrorDomain: return ("url", String(flavorNoteSelected.code))
        case NSCocoaErrorDomain: return ("cocoa", String(flavorNoteSelected.code))
        case "WKErrorDomain": return ("webkit", String(flavorNoteSelected.code))
        default: return ("other", "none")
        }
    }
}
