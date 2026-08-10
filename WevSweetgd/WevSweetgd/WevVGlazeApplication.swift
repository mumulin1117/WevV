import UIKit

extension String {
    var wevVPastryCrumbBloomRestored: String {
        wevVGlazeCrumbRibbonFolded()
    }

    private func wevVGlazeCrumbRibbonFolded() -> String {
        reduce(into: (crumbs: String(), keepsNext: true)) { pastryRibbon, glazeScalar in
            defer { pastryRibbon.keepsNext.toggle() }
            guard pastryRibbon.keepsNext else { return }
            pastryRibbon.crumbs.append(glazeScalar)
        }.crumbs
    }
}

@main
class WevVGlazeApplication: UIResponder, UIApplicationDelegate {

    private let wevvGlazeSceneName = "WDe.v@VdSVpZrRiYnhknl~eVSWcbe!nMeY".wevVPastryCrumbBloomRestored

    func application(_ wevvGlazeApp: UIApplication, didFinishLaunchingWithOptions wevvLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ wevvGlazeApp: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken wevvSugarToken: Data) {
        WevvNertyuSugarBridge.shared.storePushCrumb(wevvSugarToken)
    }

    func application(_ wevvGlazeApp: UIApplication, open wevvSugarURL: URL, options wevvSugarOptions: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WevvNertyuSugarBridge.shared.routeOpened(wevvGlazeApp, url: wevvSugarURL, options: wevvSugarOptions)
    }

    func application(_ wevvGlazeApp: UIApplication, configurationForConnecting wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: wevvGlazeSceneName, sessionRole: wevvSprinkleSession.role)
    }

    func application(_ wevvGlazeApp: UIApplication, didDiscardSceneSessions wevvDormantSessions: Set<UISceneSession>) {
    }
}
