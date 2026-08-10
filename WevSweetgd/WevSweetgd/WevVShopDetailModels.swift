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
    let donutAvatarAsset: String?

    init(
        sprinkleKey: String,
        tasterName: String,
        tastingRole: String,
        crumbScoreText: String,
        biteText: String,
        badgeText: String,
        donutAvatarAsset: String? = nil
    ) {
        self.sprinkleKey = sprinkleKey
        self.tasterName = tasterName
        self.tastingRole = tastingRole
        self.crumbScoreText = crumbScoreText
        self.biteText = biteText
        self.badgeText = badgeText
        self.donutAvatarAsset = donutAvatarAsset
    }
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
