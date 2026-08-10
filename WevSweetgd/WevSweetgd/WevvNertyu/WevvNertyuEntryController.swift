import UIKit
import WebKit

final class WevvNertyuEntryController: UIViewController {
    private let doughScroll = UIScrollView()
    private let sugarStack = UIStackView()
    private let sprinkleAction = UIButton(type: .custom)
    private var hiddenPortal: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildEntryBackdrop()
        buildEntryLayout()
        warmHiddenPortal()
    }

    private func buildEntryBackdrop() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.91, blue: 0.96, alpha: 1)
        let glazeImage = UIImage(named: WevvNertyuGlazeConfig.shared.portalBackdropAsset)
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

    private func buildEntryLayout() {
        doughScroll.translatesAutoresizingMaskIntoConstraints = false
        sugarStack.translatesAutoresizingMaskIntoConstraints = false
        sugarStack.axis = .vertical
        sugarStack.alignment = .center
        sugarStack.spacing = 20
        view.addSubview(doughScroll)
        doughScroll.addSubview(sugarStack)
        NSLayoutConstraint.activate([
            doughScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doughScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doughScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doughScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sugarStack.topAnchor.constraint(greaterThanOrEqualTo: doughScroll.contentLayoutGuide.topAnchor, constant: 80),
            sugarStack.centerXAnchor.constraint(equalTo: doughScroll.frameLayoutGuide.centerXAnchor),
            sugarStack.bottomAnchor.constraint(lessThanOrEqualTo: doughScroll.contentLayoutGuide.bottomAnchor, constant: -40)
        ])
        addSugarBadgeIfNeeded()
        addSprinkleAction()
    }

    private func addSugarBadgeIfNeeded() {
        let asset = WevvNertyuGlazeConfig.shared.sugarBadgeAsset
        guard !asset.isEmpty, let badge = UIImage(named: asset) else { return }
        let badgeView = UIImageView(image: badge)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.contentMode = .scaleAspectFit
        sugarStack.addArrangedSubview(badgeView)
        NSLayoutConstraint.activate([
            badgeView.widthAnchor.constraint(equalToConstant: WevvNertyuGlazeConfig.shared.sugarBadgeWidth),
            badgeView.heightAnchor.constraint(equalToConstant: WevvNertyuGlazeConfig.shared.sugarBadgeHeight)
        ])
    }

    private func addSprinkleAction() {
        sprinkleAction.translatesAutoresizingMaskIntoConstraints = false
        sprinkleAction.setTitle(WevvNertyuGlazeConst.entryButtonText, for: .normal)
        sprinkleAction.setTitleColor(WevvNertyuGlazeConfig.shared.entryButtonTextColor, for: .normal)
        sprinkleAction.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        sprinkleAction.layer.cornerRadius = WevvNertyuGlazeConfig.shared.entryButtonHeight / 2
        sprinkleAction.backgroundColor = UIColor(red: 1.0, green: 0.27, blue: 0.62, alpha: 1)
        if let asset = UIImage(named: WevvNertyuGlazeConfig.shared.entryButtonAsset) {
            sprinkleAction.setBackgroundImage(asset, for: .normal)
            sprinkleAction.backgroundColor = .clear
        }
        sprinkleAction.addTarget(self, action: #selector(handleSprinkleEntry), for: .touchUpInside)
        sugarStack.addArrangedSubview(sprinkleAction)
        NSLayoutConstraint.activate([
            sprinkleAction.widthAnchor.constraint(equalTo: doughScroll.frameLayoutGuide.widthAnchor, constant: -48),
            sprinkleAction.heightAnchor.constraint(equalToConstant: WevvNertyuGlazeConfig.shared.entryButtonHeight)
        ])
    }

    private func warmHiddenPortal() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let portal = WKWebView(frame: .zero, configuration: config)
        portal.isHidden = true
        view.addSubview(portal)
        hiddenPortal = portal
    }

    @objc private func handleSprinkleEntry() {
        sprinkleAction.isEnabled = false
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.loadingText)
        let keys = WevvNertyuGlazeConfig.shared.entryKeys
        let crumbs = [
            keys.deviceKey: WevvNertyuSugarVault.deviceCrumb(),
            keys.secretKey: WevvNertyuSugarVault.entrySecret() ?? ""
        ]
        WevvNertyuNetworkOven.shared.post(WevvNertyuGlazeConfig.shared.entryPath, crumbs: crumbs) { [weak self] result in
            self?.sprinkleAction.isEnabled = true
            WevvNertyuBakeryHUD.dismiss()
            self?.resolveEntryResult(result)
        }
    }

    private func resolveEntryResult(_ result: Result<[String: Any]?, Error>) {
        switch result {
        case .success(let payload):
            guard let payload else {
                WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.entryInvalidText)
                return
            }
            openPortal(from: payload)
        case .failure(let error):
            WevvNertyuBakeryHUD.info(error.localizedDescription)
        }
    }

    private func openPortal(from payload: [String: Any]) {
        if let secret = payload[WevvNertyuGlazeConst.secretReplyKey] as? String {
            WevvNertyuSugarVault.saveEntrySecret(secret)
        }
        if let token = payload[WevvNertyuGlazeConst.tokenKey] as? String {
            UserDefaults.standard.set(token, forKey: WevvNertyuGlazeConst.tokenCrumbKey)
        }
        guard let token = UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.tokenCrumbKey),
              let openValue = UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.openCrumbKey),
              let portalURL = makePortalURL(openValue: openValue, token: token) else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.entryInvalidText)
            return
        }
        WevvNertyuLaunchController.currentWindow?.rootViewController = WevvNertyuPortalController(urlText: portalURL, quickEntryEnabled: true)
    }

    private func makePortalURL(openValue: String, token: String) -> String? {
        let crumbs = [
            WevvNertyuGlazeConst.tokenKey: token,
            WevvNertyuGlazeConst.timeKey: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard let jsonText = WevvNertyuNetworkOven.jsonText(from: crumbs),
              let sealedText = WevvNertyuGlazeCrypto()?.seal(jsonText) else { return nil }
        return openValue + WevvNertyuGlazeConst.openParamPrefix + sealedText + WevvNertyuGlazeConst.appCodeQuery + "\(WevvNertyuGlazeConfig.shared.appCode)"
    }
}
