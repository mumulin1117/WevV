import UIKit
import FBSDKCoreKit

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
        ApplicationDelegate.shared.application(wevvGlazeApp, didFinishLaunchingWithOptions: wevvLaunchOptions)
        return true
    }

    func application(_ wevvGlazeApp: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken wevvSugarToken: Data) {
        WevvNertyuSugarPanelBridge.sugarPanel.confirmSugarChoice(wevvSugarToken)
    }

    func application(_ wevvGlazeApp: UIApplication, open wevvSugarURL: URL, options wevvSugarOptions: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WevvNertyuSugarPanelBridge.sugarPanel.openSugarPicturePicker(wevvGlazeApp, sugarURL: wevvSugarURL, sugarOptions: wevvSugarOptions)
    }

    func application(_ wevvGlazeApp: UIApplication, configurationForConnecting wevvSprinkleSession: UISceneSession, options wevvSprinkleOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: wevvGlazeSceneName, sessionRole: wevvSprinkleSession.role)
    }

    func application(_ wevvGlazeApp: UIApplication, didDiscardSceneSessions wevvDormantSessions: Set<UISceneSession>) {
    }
}
