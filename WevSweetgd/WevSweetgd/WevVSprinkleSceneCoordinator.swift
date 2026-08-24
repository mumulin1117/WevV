import UIKit

class WevVSprinkleSceneCoordinator: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ wevvSprinkleScene: UIScene, willConnectTo wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) {
        guard let wevvWindowScene = wevvSprinkleScene as? UIWindowScene else { return }
        let glazeWindow = UIWindow(windowScene: wevvWindowScene)
        WevvNertyuclassicBadge.powderedFinder.sugarDustKey = { sugarWindow in
            let rootWindow = sugarWindow ?? glazeWindow
            rootWindow.rootViewController = WevVDonutcreamBadgeController()
            rootWindow.makeKeyAndVisible()
        }
        glazeWindow.rootViewController = WevvNertyuSugarPanelBridge.sugarPanel.makeChoiceRow()
        window = glazeWindow
       
        WevvNertyuSugarPanelBridge.sugarPanel.buildGlazeSheet(with: glazeWindow)
        
        glazeWindow.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ wevvSprinkleScene: UIScene) {
    }

    func sceneDidBecomeActive(_ wevvSprinkleScene: UIScene) {
    }

    func sceneWillResignActive(_ wevvSprinkleScene: UIScene) {
    }

    func sceneWillEnterForeground(_ wevvSprinkleScene: UIScene) {
    }

    func sceneDidEnterBackground(_ wevvSprinkleScene: UIScene) {
    }
}
