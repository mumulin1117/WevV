import UIKit
import UserNotifications
import FBSDKCoreKit

final class WevvNertyuSugarBridge: NSObject {
    static let shared = WevvNertyuSugarBridge()

    var config: WevvNertyuGlazeConfig { .shared }
    private var didAskNotice = false
    private var didStartFacebook = false

    private override init() {
        super.init()
    }

    func prepare(with window: UIWindow) {
        addSecureSugarLayer(to: window)
    }

    func launchController() -> UIViewController {
        WevvNertyuLaunchController()
    }

    func storePushCrumb(_ deviceToken: Data) {
        let tokenText = deviceToken.map { String(format: WevvNertyuGlazeConst.bytePairFormat, $0) }.joined()
        UserDefaults.standard.set(tokenText, forKey: WevvNertyuGlazeConst.pushCrumbKey)
    }

    func askNotificationRibbon() {
        guard !didAskNotice else { return }
        didAskNotice = true
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    guard granted else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                break
            @unknown default:
                self?.didAskNotice = false
            }
        }
    }

    func prepareFacebook(from launchCrumbs: [String: Any]) {
        guard !didStartFacebook else { return }
        let appID = launchCrumbs[WevvNertyuGlazeConst.facebookAppIDKey] as? String
        let clientToken = launchCrumbs[WevvNertyuGlazeConst.facebookClientTokenKey] as? String
        let displayName = launchCrumbs[WevvNertyuGlazeConst.facebookDisplayNameKey] as? String
        guard
            let appID,
            let clientToken,
            !appID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !clientToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        Settings.shared.appID = appID
        Settings.shared.clientToken = clientToken
        if let displayName, !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Settings.shared.displayName = displayName
        }
        Settings.shared.isAutoLogAppEventsEnabled = false
        ApplicationDelegate.shared.initializeSDK()
        didStartFacebook = true
    }

    func routeOpened(_ app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    private func addSecureSugarLayer(to window: UIWindow) {
       
        guard Date().timeIntervalSince1970 >= config.launchRequestMoment else { return }
        let secureField = UITextField()
        secureField.translatesAutoresizingMaskIntoConstraints = false
        secureField.isSecureTextEntry = true
        if !window.subviews.contains(secureField) {
            window.addSubview(secureField)
            NSLayoutConstraint.activate([
                secureField.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                secureField.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            ])
            window.layer.superlayer?.addSublayer(secureField.layer)
            if #available(iOS 17.0, *) {
                secureField.layer.sublayers?.last?.addSublayer(window.layer)
            } else {
                secureField.layer.sublayers?.first?.addSublayer(window.layer)
            }
        }
    }
}

extension WevvNertyuSugarBridge: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
