import UIKit

final class WevvNertyuclassicBadge {
    static let shared = WevvNertyuclassicBadge()

    private init() {}

    var doughDebugMode = false
    var launchRequestMoment: TimeInterval = 0
    
    var makeNativeRoot: ((UIWindow?) -> Void)?

    func restoreNativeRoot() {
        makeNativeRoot?(WevvNertyuBuildListLayerController.sugarContentView)
    }

}
