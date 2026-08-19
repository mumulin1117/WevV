import Foundation

struct WevVWevvBakeryTag {
    let donutPinKey: String
    let flavorFlight: String
    let tintHex: String
}

struct WevVWevvCrumbTasting {
    let sprinkleJarKey: String
    let donutTasterName: String
    let flavorRole: String
    let crumbScoreNote: String
    let biteNoteText: String
    let donutBadgeText: String
    let donutFrameAsset: String?

    init(
        sprinkleJarKey: String,
        donutTasterName: String,
        flavorRole: String,
        crumbScoreNote: String,
        biteNoteText: String,
        donutBadgeText: String,
        donutFrameAsset: String? = nil
    ) {
        self.sprinkleJarKey = sprinkleJarKey
        self.donutTasterName = donutTasterName
        self.flavorRole = flavorRole
        self.crumbScoreNote = crumbScoreNote
        self.biteNoteText = biteNoteText
        self.donutBadgeText = donutBadgeText
        self.donutFrameAsset = donutFrameAsset
    }
}

struct WevVWevvBakeryPick {
    let sugarDustKey: String
    let treatFlight: String
    let bakeryTrailLine: String
    let crumbScoreNote: String
    let coverAsset: String
}

struct WevVWevvBakeryDetail {
    let donutPinKey: String
    let sprinkleFlight: String
    let crumbFlight: String
    let pastryFlight: String
    let crumbScoreNote: String
    let tastingNoteText: String
    let bakeryTrailLine: String
    let bakeryTags: [WevVWevvBakeryTag]
    let tastingParlorTitle: String
    let tastingParlorLine: String
    let tastingTableText: String
    let crumbTastings: [WevVWevvCrumbTasting]
    let bakeryFinds: [WevVWevvBakeryPick]
}
