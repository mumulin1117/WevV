import UIKit
import WebKit

final class WevvNertyufilledScoutwController: UIViewController {
    private let sugarScrollView = UIScrollView()
    private let sugarRowsStack = UIStackView()
    private let sprinkleButton = UIButton(type: .custom)
    private var tastingScoutline: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarSettingsPage()
        buildListLayer()
        fillSugarSettingRows()
    }

    private func buildSugarSettingsPage() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.91, blue: 0.96, alpha: 1)
        let glazeImage = UIImage(named: WevvNertyuclassicBadge.shared.portalBackdropAsset)
        let glazeView = UIImageView(image: glazeImage)
        glazeView.translatesAutoresizingMaskIntoConstraints = false
        glazeView.contentMode = .scaleAspectFill
        glazeView.clipsToBounds = true
        view.addSubview(glazeView)
        NSLayoutConstraint.activate([
            glazeView.topAnchor.constraint(equalTo: view.topAnchor),
            glazeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            glazeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            glazeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildListLayer() {
        sugarScrollView.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.axis = .vertical
        sugarRowsStack.alignment = .center
        sugarRowsStack.spacing = 20
        view.addSubview(sugarScrollView)
        sugarScrollView.addSubview(sugarRowsStack)
        NSLayoutConstraint.activate([
            sugarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sugarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sugarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sugarScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sugarRowsStack.topAnchor.constraint(greaterThanOrEqualTo: sugarScrollView.contentLayoutGuide.topAnchor, constant: 80),
            sugarRowsStack.centerXAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.centerXAnchor),
            sugarRowsStack.bottomAnchor.constraint(lessThanOrEqualTo: sugarScrollView.contentLayoutGuide.bottomAnchor, constant: -40)
        ])
    
        buildBottomActions()
    }

   

    private func buildBottomActions() {
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
       
        let asset = UIImage(named: WevvNertyuclassicBadge.shared.entryButtonAsset)
            sprinkleButton.setBackgroundImage(asset, for: .normal)
        
        sprinkleButton.addTarget(self, action: #selector(openEditGlazeProfile), for: .touchUpInside)
        self.view.addSubview(sprinkleButton)
        NSLayoutConstraint.activate([
            sprinkleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sprinkleButton.widthAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.widthAnchor, constant: -48),
            sprinkleButton.heightAnchor.constraint(equalToConstant: WevvNertyuclassicBadge.shared.entryButtonHeight),
            sprinkleButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func fillSugarSettingRows() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let portal = WKWebView(frame: .zero, configuration: config)
        portal.isHidden = true
        view.addSubview(portal)
        tastingScoutline = portal
    }

    @objc private func openEditGlazeProfile() {
        sprinkleButton.isEnabled = false
        WevvNertyuSugartastingCard.showSugarToast(WevvmarshmallowFlight.loadingText)
        let keys = WevvNertyuclassicBadge.shared.entryKeys
        let crumbs = [
            keys.sugarTitle: WevvNertyuDoughSession.currentSugarCacheCountText(),
            keys.sugarValue: WevvNertyuDoughSession.bindCurrentDoughRingProfile() ?? ""
        ]
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice(WevvNertyuclassicBadge.shared.entryPath, sugarPanel: crumbs) { [weak self] result in
            self?.sprinkleButton.isEnabled = true
            WevvNertyuSugartastingCard.clearSugarCrumbs()
            self?.showConfirmSugarPanel(result)
        }
    }

    private func showConfirmSugarPanel(_ result: Result<[String: Any]?, Error>) {
        switch result {
        case .success(let glazeBowl):
            guard let glazeBowl else {
                WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.entryInvalidText)
                return
            }
            openSugarText(from: glazeBowl)
        case .failure(let error):
            WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
        }
    }

    private func openSugarText(from glazeBowl: [String: Any]) {
        if let secret = glazeBowl[WevvmarshmallowFlight.secretReplyKey] as? String {
            WevvNertyuDoughSession.saveCreamRingProfile(secret)
        }
        if let tastingVisit = glazeBowl[WevvmarshmallowFlight.tokenKey] as? String {
            UserDefaults.standard.set(tastingVisit, forKey: WevvmarshmallowFlight.tokenCrumbKey)
        }
        guard let tastingVisit = UserDefaults.standard.string(forKey: WevvmarshmallowFlight.tokenCrumbKey),
              let sugarValue = UserDefaults.standard.string(forKey: WevvmarshmallowFlight.openCrumbKey),
              let sugarTextRoute = currentSugarCacheCountText(sugarValue: sugarValue, tastingVisit: tastingVisit) else {
            WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.entryInvalidText)
            return
        }
        WevvNertyuBuildListLayerController.sugarContentView?.rootViewController = WevvNertyuGlazeSafetySheetController(sugarDustKey: sugarTextRoute, needsCreamText: true)
    }

    private func currentSugarCacheCountText(sugarValue: String, tastingVisit: String) -> String? {
        let crumbs = [
            WevvmarshmallowFlight.tokenKey: tastingVisit,
            WevvmarshmallowFlight.timeKey: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard let jsonText = WevvNertyuChoiceStackLayer.makeChoiceRow(from: crumbs),
              let filledScout = WevvNertyuCreampistachioFlight()?.tuneSugarSaveButton(jsonText) else { return nil }
        return sugarValue + WevvmarshmallowFlight.openParamPrefix + filledScout + WevvmarshmallowFlight.appCodeQuery + "\(WevvNertyuclassicBadge.shared.appCode)"
    }
}
