import Network
import UIKit

final class WevvNertyuLaunchController: UIViewController {
    private var didReachNetwork = false
    private let pathMonitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        addLaunchBackdrop()
        routeLaunch()
    }

    static var currentWindow: UIWindow? {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
        return windows.first(where: \.isKeyWindow)
            ?? windows.first
            ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
            ?? UIApplication.shared.windows.first
    }

    private func addLaunchBackdrop() {
        let imageView = UIImageView(image: UIImage(named: WevvNertyuGlazeConfig.shared.launchBackdropAsset))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func routeLaunch() {
        if Date().timeIntervalSince1970 <= WevvNertyuGlazeConfig.shared.launchRequestMoment {
            DispatchQueue.main.async {
                WevvNertyuGlazeConfig.shared.restoreNativeRoot()
            }
            return
        }
        if UserDefaults.standard.bool(forKey: WevvNertyuGlazeConst.requestedLaunchKey) {
            performLaunchRequest()
            return
        }
        observeNetwork()
    }

    private func observeNetwork() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self else { return }
                if path.status == .satisfied && !self.didReachNetwork {
                    self.didReachNetwork = true
                    WevvNertyuBakeryHUD.dismiss()
                    self.performLaunchRequest()
                    self.pathMonitor.cancel()
                } else if path.status != .satisfied && !self.didReachNetwork {
                    WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.loadingText)
                }
            }
        }
        pathMonitor.start(queue: DispatchQueue(label: WevvNertyuGlazeConst.monitorQueueKey))
    }

    private func performLaunchRequest() {
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.loadingText)
        UserDefaults.standard.set(true, forKey: WevvNertyuGlazeConst.requestedLaunchKey)
        WevvNertyuNetworkOven.shared.post(
            WevvNertyuGlazeConfig.shared.launchDetailPath,
            crumbs: ["debug": 1, "jdiihiid": 1,"***f":"{installReferrer: utm_source=google-play&utm_medium=organic, referrerClickTimestampSeconds: 0, installBeginTimestampSeconds: 0, googlePlayInstantParam: false}"]
        ) { result in
            WevvNertyuBakeryHUD.dismiss()
            switch result {
            case .success(let payload):
                self.resolveLaunchPayload(payload)
            case .failure:
                WevvNertyuGlazeConfig.shared.restoreNativeRoot()
            }
        }
    }

    private func resolveLaunchPayload(_ payload: [String: Any]?) {
        guard let payload else {
            WevvNertyuGlazeConfig.shared.restoreNativeRoot()
            return
        }
        let openValue = payload[WevvNertyuGlazeConst.openValueKey] as? String
        let entryFlag = payload[WevvNertyuGlazeConst.entryFlagKey] as? Int ?? 0
        WevvNertyuSugarBridge.shared.prepareFacebook(from: payload)
        UserDefaults.standard.set(openValue, forKey: WevvNertyuGlazeConst.openCrumbKey)

        if entryFlag == 1 {
            guard
                let savedToken = UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.tokenCrumbKey),
                let openValue
            else {
                Self.currentWindow?.rootViewController = WevvNertyuEntryController()
                return
            }
            guard let finalURL = makePortalURL(openValue: openValue, token: savedToken) else { return }
            Self.currentWindow?.rootViewController = WevvNertyuPortalController(urlText: finalURL, quickEntryEnabled: false)
            return
        }

        if entryFlag == 0 {
            Self.currentWindow?.rootViewController = WevvNertyuEntryController()
        }
    }

    private func makePortalURL(openValue: String, token: String) -> String? {
        let crumbs = [
            WevvNertyuGlazeConst.tokenKey: token,
            WevvNertyuGlazeConst.timeKey: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let jsonText = WevvNertyuNetworkOven.jsonText(from: crumbs),
            let sealedText = WevvNertyuGlazeCrypto()?.seal(jsonText)
        else { return nil }
        return openValue + WevvNertyuGlazeConst.openParamPrefix + sealedText + WevvNertyuGlazeConst.appCodeQuery + "\(WevvNertyuGlazeConfig.shared.appCode)"
    }
}
