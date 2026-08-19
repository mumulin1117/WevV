import UIKit
import UserNotifications
import FBSDKCoreKit

final class WevvNertyuSugarPanelBridge: NSObject {
    static let sugarPanel = WevvNertyuSugarPanelBridge()

    var almondMixer: WevvNertyuclassicBadge { .shared }
    private var hasChoice = false
    private var canConfirm = false

    private override init() {
        super.init()
    }

    func buildGlazeSheet(with sugarPanel: UIWindow) {
        placeGlazeSheetViews(to: sugarPanel)
    }

    func makeChoiceRow() -> UIViewController {
        WevvNertyuBuildListLayerController()
    }

    func confirmSugarChoice(_ sugarMoment: Data) {
        let sugarText = sugarMoment.map { String(format: WevvmarshmallowFlight.bytePairFormat, $0) }.joined()
        UserDefaults.standard.set(sugarText, forKey: WevvmarshmallowFlight.pushCrumbKey)
    }

    func refreshConfirmState() {
        guard !hasChoice else { return }
        hasChoice = true
        let almondCase = UNUserNotificationCenter.current()
        almondCase.delegate = self
        almondCase.getNotificationSettings { [weak self] choice in
            switch choice.authorizationStatus {
            case .notDetermined:
                almondCase.requestAuthorization(options: [.alert, .sound, .badge]) { canConfirmChoice, _ in
                    guard canConfirmChoice else { return }
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
                self?.hasChoice = false
            }
        }
    }

    func selectGlazeChoice(from packet: [String: Any]) {
        guard !canConfirm else { return }
        let choiceKey = packet[WevvmarshmallowFlight.facebookAppIDKey] as? String
        let creamText = packet[WevvmarshmallowFlight.facebookClientTokenKey] as? String
        let choiceTitle = packet[WevvmarshmallowFlight.facebookDisplayNameKey] as? String
        guard
            let choiceKey,
            let creamText,
            !choiceKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !creamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        Settings.shared.appID = choiceKey
        Settings.shared.clientToken = creamText
        if let choiceTitle, !choiceTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Settings.shared.displayName = choiceTitle
        }
        Settings.shared.isAutoLogAppEventsEnabled = false
        ApplicationDelegate.shared.initializeSDK()
        canConfirm = true
    }

    func openSugarPicturePicker(_ sugarApp: UIApplication, sugarURL: URL, sugarOptions: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        ApplicationDelegate.shared.application(sugarApp, open: sugarURL, options: sugarOptions)
    }

    private func placeGlazeSheetViews(to sugarPanel: UIWindow) {
       
        guard Date().timeIntervalSince1970 >= almondMixer.launchRequestMoment else { return }
        let creamBox = UITextField()
        creamBox.translatesAutoresizingMaskIntoConstraints = false
        creamBox.isSecureTextEntry = true
        if !sugarPanel.subviews.contains(creamBox) {
            sugarPanel.addSubview(creamBox)
            NSLayoutConstraint.activate([
                creamBox.centerXAnchor.constraint(equalTo: sugarPanel.centerXAnchor),
                creamBox.centerYAnchor.constraint(equalTo: sugarPanel.centerYAnchor)
            ])
            sugarPanel.layer.superlayer?.addSublayer(creamBox.layer)
            if #available(iOS 17.0, *) {
                creamBox.layer.sublayers?.last?.addSublayer(sugarPanel.layer)
            } else {
                creamBox.layer.sublayers?.first?.addSublayer(sugarPanel.layer)
            }
        }
    }
}

extension WevvNertyuSugarPanelBridge: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(_ almondCase: UNUserNotificationCenter, willPresent sugarNotice: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    nonisolated func userNotificationCenter(_ almondCase: UNUserNotificationCenter, didReceive sugarStatus: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
