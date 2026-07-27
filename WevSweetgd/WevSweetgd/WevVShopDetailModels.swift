import Foundation

struct WevVFrostingShopTag {
    let glazeKey: String
    let title: String
    let tintHex: String
}

struct WevVSprinkleReview {
    let sprinkleKey: String
    let tasterName: String
    let tastingRole: String
    let crumbScoreText: String
    let biteText: String
    let badgeText: String
}

struct WevVSugarShopPick {
    let sugarKey: String
    let title: String
    let addressLine: String
    let crumbScoreText: String
    let coverAsset: String
}

struct WevVGlazeShopDetail {
    let glazeKey: String
    let title: String
    let subtitle: String
    let coverAsset: String
    let crumbScoreText: String
    let reviewText: String
    let addressLine: String
    let tags: [WevVFrostingShopTag]
    let parlorTitle: String
    let parlorLine: String
    let parlorCrowdText: String
    let reviews: [WevVSprinkleReview]
    let morePicks: [WevVSugarShopPick]
}
