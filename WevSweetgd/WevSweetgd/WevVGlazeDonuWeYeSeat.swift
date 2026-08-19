import Foundation

struct WevVGlazeDonuWeYeSeat {
    let sugarIndex: Int
    var guestDonuWeYeKey: String?
    var tasterName: String?
    var avatarSeed: Int
    var isCreamEmpty: Bool
    var isCurrentDonuWeYeTaster: Bool
    var isMicOpen: Bool
}

struct WevVSprinkleDonuWeYeRoLine {
    let sprinkleJarKey: String
    let tasterDonuWeYeName: String
    let crumbText: String
}

struct WevVCreamDonuWeYeShrState {
    let roomDonuWeYeKey: String
    let tasterBadgeKey: String
    let hostDonuWeYeName: String
    let hostSeed: Int
    let heatDonuWeYeText: String
    let tastingTableText: String
    var berryPress: [WevVGlazeDonuWeYeSeat]
    let roDonuWeYeLines: [WevVSprinkleDonuWeYeRoLine]
    var currentSeatIndex: Int?
}
