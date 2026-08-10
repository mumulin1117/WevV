import UIKit

class WevVSprinkleSceneCoordinator: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ wevvSprinkleScene: UIScene, willConnectTo wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) {
        guard let wevvWindowScene = wevvSprinkleScene as? UIWindowScene else { return }
        let glazeWindow = UIWindow(windowScene: wevvWindowScene)
        WevvNertyuGlazeConfig.shared.makeNativeRoot = { sugarWindow in
            let rootWindow = sugarWindow ?? glazeWindow
            rootWindow.rootViewController = WevVDonutRootController()
            rootWindow.makeKeyAndVisible()
        }
        glazeWindow.rootViewController = WevvNertyuSugarBridge.shared.launchController()
        window = glazeWindow
        glazeWindow.makeKeyAndVisible()
        WevvNertyuSugarBridge.shared.prepare(with: glazeWindow)
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
