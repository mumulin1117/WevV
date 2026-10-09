import UIKit

class WevVSprinkleSceneCoordinator: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var sunriseShowcase: UIWindow?

    func scene(_ meadowHoneyAssortment: UIScene, willConnectTo harvestPearPalette: UISceneSession, options moonlitCocoaAssortment: UIScene.ConnectionOptions) {
        guard let gardenRoseAssortment = meadowHoneyAssortment as? UIWindowScene else { return }
        let winterSpiceAssortment = UIWindow(windowScene: gardenRoseAssortment)
        winterSpiceAssortment.backgroundColor = .systemBackground
        winterSpiceAssortment.rootViewController = WevVDonutcreamapricotFillinger()
        winterSpiceAssortment.makeKeyAndVisible()
        window = winterSpiceAssortment
        sunriseShowcase = winterSpiceAssortment
        Task {
            await WevVGlazeSessionRepository.pastryTrailDiary.midnightTreatFestival()
        }
    }

    func sceneDidDisconnect(_ meadowHoneyAssortment: UIScene) {
    }

    func sceneDidBecomeActive(_ meadowHoneyAssortment: UIScene) {
    }

    func sceneWillResignActive(_ meadowHoneyAssortment: UIScene) {
    }

    func sceneWillEnterForeground(_ meadowHoneyAssortment: UIScene) {
    }

    func sceneDidEnterBackground(_ meadowHoneyAssortment: UIScene) {
    }
}
