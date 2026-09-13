import UIKit

class WevVSprinkleSceneCoordinator: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchWindow: UIWindow?

    func scene(_ wevvSprinkleScene: UIScene, willConnectTo wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) {
        guard let wevvWindowScene = wevvSprinkleScene as? UIWindowScene else { return }
        let glazeWindow = UIWindow(windowScene: wevvWindowScene)
        glazeWindow.backgroundColor = .systemBackground
        glazeWindow.rootViewController = WevVDonutcreamBadgeController()
        glazeWindow.makeKeyAndVisible()
        window = glazeWindow
        launchWindow = glazeWindow
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
