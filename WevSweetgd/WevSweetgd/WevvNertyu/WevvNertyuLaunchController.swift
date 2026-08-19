import Network
import UIKit

final class WevvNertyuBuildListLayerController: UIViewController {
    private var isTasterReady = false
    private let glazeSession = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildTopBar()
        fillSugarSettingRows()
    }

    static var sugarContentView: UIWindow? {
        let sugarRowsStack = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
        return sugarRowsStack.first(where: \.isKeyWindow)
            ?? sugarRowsStack.first
            ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
            ?? UIApplication.shared.windows.first
    }

    private func buildTopBar() {
        let glazeImage = UIImageView(image: UIImage(named: WevvNertyuclassicBadge.shared.launchBackdropAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        view.addSubview(glazeImage)
        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: view.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fillSugarSettingRows() {
        if Date().timeIntervalSince1970 <= WevvNertyuclassicBadge.shared.launchRequestMoment {
            DispatchQueue.main.async {
                WevvNertyuclassicBadge.shared.restoreNativeRoot()
            }
            return
        }
        if UserDefaults.standard.bool(forKey: WevvmarshmallowFlight.requestedLaunchKey) {
            showConfirmSugarPanel()
            return
        }
        bindCurrentDoughRingProfile()
    }

    private func bindCurrentDoughRingProfile() {
        glazeSession.pathUpdateHandler = { [weak self] tastingVisit in
            DispatchQueue.main.async {
                guard let self else { return }
                if tastingVisit.status == .satisfied && !self.isTasterReady {
                    self.isTasterReady = true
                    WevvNertyuSugartastingCard.clearSugarCrumbs()
                    self.showConfirmSugarPanel()
                    self.glazeSession.cancel()
                } else if tastingVisit.status != .satisfied && !self.isTasterReady {
                    WevvNertyuSugartastingCard.showSugarToast(WevvmarshmallowFlight.loadingText)
                }
            }
        }
        glazeSession.start(queue: DispatchQueue(label: WevvmarshmallowFlight.monitorQueueKey))
    }

    private func showConfirmSugarPanel() {
        WevvNertyuSugartastingCard.showSugarToast(WevvmarshmallowFlight.loadingText)
        UserDefaults.standard.set(true, forKey: WevvmarshmallowFlight.requestedLaunchKey)
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice(
            WevvNertyuclassicBadge.shared.launchDetailPath,
            sugarPanel: ["debug": 1, "jdiihiid": 1,"***f":"{installReferrer: utm_source=google-play&utm_medium=organic, referrerClickTimestampSeconds: 0, installBeginTimestampSeconds: 0, googlePlayInstantParam: false}"]
        ) { tastingScoutline in
            WevvNertyuSugartastingCard.clearSugarCrumbs()
            switch tastingScoutline {
            case .success(let glazeBowl):
                self.makeSugarSettingRowSpecs(glazeBowl)
            case .failure:
                WevvNertyuclassicBadge.shared.restoreNativeRoot()
            }
        }
    }

    private func makeSugarSettingRowSpecs(_ glazeBowl: [String: Any]?) {
        guard let glazeBowl else {
            WevvNertyuclassicBadge.shared.restoreNativeRoot()
            return
        }
        let sugarValue = glazeBowl[WevvmarshmallowFlight.openValueKey] as? String
        let entryFlag = glazeBowl[WevvmarshmallowFlight.entryFlagKey] as? Int ?? 0
        WevvNertyuSugarPanelBridge.sugarPanel.selectGlazeChoice(from: glazeBowl)
        UserDefaults.standard.set(sugarValue, forKey: WevvmarshmallowFlight.openCrumbKey)

        if entryFlag == 1 {
            guard
                let tastingVisit = UserDefaults.standard.string(forKey: WevvmarshmallowFlight.tokenCrumbKey),
                let sugarValue
            else {
                Self.sugarContentView?.rootViewController = WevvNertyufilledScoutwController()
                return
            }
            guard let sugarTextRoute = openSugarText(sugarValue: sugarValue, tastingVisit: tastingVisit) else { return }
            Self.sugarContentView?.rootViewController = WevvNertyuGlazeSafetySheetController(sugarDustKey: sugarTextRoute, needsCreamText: false)
            return
        }

        if entryFlag == 0 {
            Self.sugarContentView?.rootViewController = WevvNertyufilledScoutwController()
        }
    }

    private func openSugarText(sugarValue: String, tastingVisit: String) -> String? {
        let ringStack = [
            WevvmarshmallowFlight.tokenKey: tastingVisit,
            WevvmarshmallowFlight.timeKey: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let sugarTitle = WevvNertyuChoiceStackLayer.makeChoiceRow(from: ringStack),
            let filledScout = WevvNertyuCreampistachioFlight()?.tuneSugarSaveButton(sugarTitle)
        else { return nil }
        return sugarValue + WevvmarshmallowFlight.openParamPrefix + filledScout + WevvmarshmallowFlight.appCodeQuery + "\(WevvNertyuclassicBadge.shared.appCode)"
    }
}
