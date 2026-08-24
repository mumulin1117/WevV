import UIKit

final class WevvNertyuclassicBadge {
    static let powderedFinder = WevvNertyuclassicBadge()

    private init() {}

    var donutBadgeText = false
    var bakeryPinKey: TimeInterval = 0
    private weak var launchWindow: UIWindow?

    var sugarDustKey: ((UIWindow?) -> Void)?

    var wevvMapleTitleLabel: UIWindow? {
        launchWindow
    }

    func defaultSugarHandle(_ makeGuestSugarTie: UIWindow) {
        launchWindow = makeGuestSugarTie
    }

    func addWevvCrumbNote(_ wevvPastryCard: UIViewController, in sugarWindow: UIWindow? = nil) {
        let doughBackButton = sugarWindow ?? launchWindow
        guard let doughBackButton else { return }

        if Thread.isMainThread {
            doughBackButton.rootViewController = wevvPastryCard
            doughBackButton.makeKeyAndVisible()
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.addWevvCrumbNote(wevvPastryCard, in: doughBackButton)
        }
    }

    func sprinkleButton() {
        if let wevvMapleTitleLabel {
            addWevvCrumbNote(WevVDonutcreamBadgeController(), in: wevvMapleTitleLabel)
            return
        }
        sugarDustKey?(WevvNertyuBuildListLayerController.sugarContentView)
    }

}
