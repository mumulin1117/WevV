import UIKit

@main
class WevVGlazeApplication: UIResponder, UIApplicationDelegate {

    private let wevvGlazeSceneName = "WevVSprinkleScene"

    func application(_ wevvGlazeApp: UIApplication, didFinishLaunchingWithOptions wevvLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ wevvGlazeApp: UIApplication, configurationForConnecting wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: wevvGlazeSceneName, sessionRole: wevvSprinkleSession.role)
    }

    func application(_ wevvGlazeApp: UIApplication, didDiscardSceneSessions wevvDormantSessions: Set<UISceneSession>) {
    }
}
