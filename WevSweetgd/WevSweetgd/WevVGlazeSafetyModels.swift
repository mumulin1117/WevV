import Foundation

struct WevVGlazeSafetyChoice {
    let sugarKey: String
    let title: String
    let needsCreamText: Bool
}

struct WevVGlazeSafetyPacket {
    let shopKey: String
    let choiceKey: String
    let choiceTitle: String
    let creamText: String
    let sugarMoment: TimeInterval
}
