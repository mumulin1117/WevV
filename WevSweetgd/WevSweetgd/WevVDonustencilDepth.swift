import UIKit

struct WevVBakeryAtlas {
    let donutPinKey: String
    let bakeryTitle: String
    let flavorNoteLine: String
    let bakeryFrameAsset: String
}

struct WevVDailyDonutVisit {
    let ringCutterKey: String
    let bakeryFinder: String
    let caption: String
    let cardAsset: String
}

struct WevVTastingQuest {
    let sprinkleJarKey: String
    let menuBoardTitle: String
    let caption: String
    let cardAsset: String
    let glazeSheenText: String
    let glazeTrailLine: String
    let freshnessTagText: String
    let bakeryStopText: String
    let tasterBadgeKey: String
    let tasterLine: String
    let tastingQuestText: String
    let tastingTableText: String
    let sprinkleDensityValue: Int
}

struct WevVDonutTaster {
    let donutPinKey: String
    let name: String
    let donutFrameAsset: String
}

struct WevVDonutSnapshot {
    let sprinkleJarKey: String
    let tasterBloom: WevVDonutTaster
    let donutBackdropAsset: String
    let tastingText: String
    let hasSprinkleDust: Bool
    let hasBakeryShelf: Bool
    let freshnessTagText: String
}

struct WevVTastingMark {
    let glazeTrailCount: Int
    let sprinkleTasterCount: Int
    let bakeryShelfTotal: Int
    let donutArchiveTotal: Int
}

struct WevVFlavorNote {
    let sugarDustKey: String
    let tastingCardTitle: String
    let sweetApricotNuance: String
}

struct WevVDonutDiaryTaster {
    let ringCutterKey: String
    let warmGingerFlavor: String
    let glazeNickname: String
    let donutFrameAsset: String
    let tastingMarks: WevVTastingMark
    let honeyedFigHarmony: [WevVFlavorNote]
}

enum WevVDonutParlorSection: Int {
    case donutCounter
    case tastingParlor
    case tastingJournal
    case zestyOrangeHarmony
}
