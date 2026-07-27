import Foundation

struct WevVGlazeRoomSeat {
    let sugarIndex: Int
    var guestKey: String?
    var tasterName: String?
    var avatarSeed: Int
    var isCreamEmpty: Bool
    var isCurrentTaster: Bool
    var isMicOpen: Bool
}

struct WevVSprinkleRoomLine {
    let sprinkleKey: String
    let tasterName: String
    let crumbText: String
}

struct WevVCreamRoomState {
    let roomKey: String
    let hostGuestKey: String
    let hostName: String
    let hostSeed: Int
    let heatText: String
    let crowdText: String
    var seats: [WevVGlazeRoomSeat]
    let roomLines: [WevVSprinkleRoomLine]
    var currentSeatIndex: Int?
}
