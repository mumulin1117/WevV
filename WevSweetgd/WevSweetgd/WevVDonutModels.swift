import UIKit

struct WevVGlazeShop {
    let glazeKey: String
    let shopTitle: String
    let flavorLine: String
    let coverAsset: String
}

struct WevVDailyCheckin {
    let doughRingKey: String
    let title: String
    let caption: String
    let cardAsset: String
}

struct WevVSprinkleChallenge {
    let sprinkleKey: String
    let title: String
    let caption: String
    let cardAsset: String
    let joinedText: String
    let glazeLine: String
    let sprinkleTimeText: String
    let crumbPlaceText: String
    let hostGuestKey: String
    let hostLine: String
    let missionText: String
    let crowdText: String
    let sugarCost: Int
}

struct WevVGlazeAuthor {
    let glazeKey: String
    let name: String
    let donutAvatarAsset: String
}

struct WevVSprinkleFeedItem {
    let sprinkleKey: String
    let author: WevVGlazeAuthor
    let heroAsset: String
    let displayText: String
    let isSprinkled: Bool
    let isSaved: Bool
    let frostingTimeText: String
}

struct WevVCreamStat {
    let glazeFollowCount: Int
    let sprinkleFanCount: Int
    let bakeryShelfCount: Int
    let vaultCount: Int
}

struct WevVSugarPost {
    let sugarKey: String
    let title: String
    let note: String
}

struct WevVCreamRingTaster {
    let doughRingKey: String
    let email: String
    let glazeNickname: String
    let donutAvatarAsset: String
    let creamStats: WevVCreamStat
    let sugarNotes: [WevVSugarPost]
}

enum WevVDonutMainSection: Int {
    case glazeHome
    case frostingDiary
    case sugarProfile
}
