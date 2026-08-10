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
    let sprinkleKey: String
    let tasterDonuWeYeName: String
    let crumbText: String
}

struct WevVCreamDonuWeYeShrState {
    let roomDonuWeYeKey: String
    let hostGuestKey: String
    let hostDonuWeYeName: String
    let hostSeed: Int
    let heatDonuWeYeText: String
    let crowdText: String
    var seats: [WevVGlazeDonuWeYeSeat]
    let roDonuWeYeLines: [WevVSprinkleDonuWeYeRoLine]
    var currentSeatIndex: Int?
}
