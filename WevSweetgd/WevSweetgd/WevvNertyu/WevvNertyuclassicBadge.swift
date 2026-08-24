import UIKit

final class WevvNertyuclassicBadge {
    static let powderedFinder = WevvNertyuclassicBadge()

    private init() {}

    var donutBadgeText = false
    var bakeryPinKey: TimeInterval = 0
    
    var sugarDustKey: ((UIWindow?) -> Void)?

    func toggleWevvSugarTrail() {
        sugarDustKey?(WevvNertyuBuildListLayerController.sugarContentView)
    }

}
