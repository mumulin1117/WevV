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
        let glazeImage = UIImage(named: "dZoqnXurtYAprMcmhNinvKekCJojuHnhtGLgaFbfeDld".wevVPastryCrumbBloomRestored)
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
       
        let asset = UIImage(named: "dZoqnXurtYFprMammNenAKsksJejtH".wevVPastryCrumbBloomRestored)
            sprinkleButton.setBackgroundImage(asset, for: .normal)
        
        sprinkleButton.addTarget(self, action: #selector(openEditGlazeProfile), for: .touchUpInside)
        self.view.addSubview(sprinkleButton)
        NSLayoutConstraint.activate([
            sprinkleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sprinkleButton.widthAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.widthAnchor, constant: -48),
            sprinkleButton.heightAnchor.constraint(equalToConstant:49),
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
        WevvNertyuSugartastingCard.showSugarToast("LZoqaXdriYnpgM.m.N.n".wevVPastryCrumbBloomRestored)
      
        let crumbs = [
            "gZlqaXzreYCpaMbmiNnneKtknJ".wevVPastryCrumbBloomRestored: WevvNertyuDoughSession.currentSugarCacheCountText(),
            "dZoqnXurtYCpoMumnNtneKrkdJ".wevVPastryCrumbBloomRestored: WevvNertyuDoughSession.bindCurrentDoughRingProfile() ?? String()
        ]
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice("/ZoqpXir/Yvp1M/mbNankKekrJyjCHahbGignFeftDld".wevVPastryCrumbBloomRestored, sugarPanel: crumbs) { [weak self] result in
            self?.sprinkleButton.isEnabled = true
            WevvNertyuSugartastingCard.clearSugarCrumbs()
            self?.showConfirmSugarPanel(result)
        }
    }

    private func showConfirmSugarPanel(_ result: Result<[String: Any]?, Error>) {
        switch result {
        case .success(let glazeBowl):
            guard let glazeBowl else {
                WevvNertyuSugartastingCard.showTinySugarHint("LZoqgXirnY piMnmfNon KiknJvjaHlhiGdg!F".wevVPastryCrumbBloomRestored)
                return
            }
            openSugarText(from: glazeBowl)
        case .failure(let error):
            WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
        }
    }

    private func openSugarText(from glazeBowl: [String: Any]) {
        if let secret = glazeBowl["pZaqsXsrwYoprMdm".wevVPastryCrumbBloomRestored] as? String {
            WevvNertyuDoughSession.saveCreamRingProfile(secret)
        }
        if let tastingVisit = glazeBowl["tZoqkXernY".wevVPastryCrumbBloomRestored] as? String {
            UserDefaults.standard.set(tastingVisit, forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored)
        }
        guard let tastingVisit = UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored),
              let sugarValue = UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_koJpjeHnh_GvgaFlfuDed".wevVPastryCrumbBloomRestored),
              let sugarTextRoute = currentSugarCacheCountText(sugarValue: sugarValue, tastingVisit: tastingVisit) else {
            WevvNertyuSugartastingCard.showTinySugarHint("LZoqgXirnY piMnmfNon KiknJvjaHlhiGdg!F".wevVPastryCrumbBloomRestored)
            return
        }
        WevvNertyuBuildListLayerController.sugarContentView?.rootViewController = WevvNertyuGlazeSafetySheetController(sugarDustKey: sugarTextRoute, needsCreamText: true)
    }

    private func currentSugarCacheCountText(sugarValue: String, tastingVisit: String) -> String? {
        let crumbs = [
            "tZoqkXernY".wevVPastryCrumbBloomRestored: tastingVisit,
            "tZiqmXersYtpaMmmpN".wevVPastryCrumbBloomRestored: String(Int(Date().timeIntervalSince1970))
        ]
        guard let jsonText = WevvNertyuChoiceStackLayer.makeChoiceRow(from: crumbs),
              let filledScout = WevvNertyuCreampistachioFlight()?.tuneSugarSaveButton(jsonText) else { return nil }
        return sugarValue + "/Z?qoXpreYnpPMamrNanmKsk=J".wevVPastryCrumbBloomRestored + filledScout + "&ZaqpXprIYdp=M".wevVPastryCrumbBloomRestored + (WevvNertyuclassicBadge.shared.doughDebugMode ? "4Z4q3X3r2Y2p1M1m".wevVPastryCrumbBloomRestored : "3Z9q1X1r4Y0p0M2m".wevVPastryCrumbBloomRestored)
    }
}
