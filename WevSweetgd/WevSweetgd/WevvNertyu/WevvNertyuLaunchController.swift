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
        if let launchSceneWindow = WevvNertyuclassicBadge.powderedFinder.wevvMapleTitleLabel {
            return launchSceneWindow
        }
        let sugarRowsStack = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
        return sugarRowsStack.first(where: \.isKeyWindow)
            ?? sugarRowsStack.first
            ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
            ?? UIApplication.shared.windows.first
    }

    private func buildTopBar() {
        let glazeImage = UIImageView(image: UIImage(named: "wZeqlXaroYipnMgm".wevVPastryCrumbBloomRestored))
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
        if Date().timeIntervalSince1970 <= WevvNertyuclassicBadge.powderedFinder.bakeryPinKey {
            DispatchQueue.main.async {
                WevvNertyuclassicBadge.powderedFinder.sprinkleButton()
            }
            return
        }
        if UserDefaults.standard.bool(forKey: "wZeqvXvr_YnpeMrmtNynuK_klJajuHnhcGhg_FcfhDedcSkseAda".wevVPastryCrumbBloomRestored) {
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
                    WevvNertyuSugartastingCard.showSugarToast("LZoqaXdriYnpgM.m.N.n".wevVPastryCrumbBloomRestored)
                }
            }
        }
        glazeSession.start(queue: DispatchQueue(label: "wZeqvXvr_YnpeMrmtNynuK_knJejtHwhoGrgkF_fqDudeSuseA".wevVPastryCrumbBloomRestored))
    }

    private func showConfirmSugarPanel() {
        WevvNertyuSugartastingCard.showSugarToast("LZoqaXdriYnpgM.m.N.n".wevVPastryCrumbBloomRestored)
        UserDefaults.standard.set(true, forKey: "wZeqvXvr_YnpeMrmtNynuK_klJajuHnhcGhg_FcfhDedcSkseAda".wevVPastryCrumbBloomRestored)
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice(
            "/ZoqpXir/Yvp1M/mcNrnuKmkbJAjrHchhGigvFefoD".wevVPastryCrumbBloomRestored,
            sugarPanel: ["sZtqaXmrpYSpcMomuNtngK".wevVPastryCrumbBloomRestored: 1, "sZuqgXarrYSpcMomuNtndK".wevVPastryCrumbBloomRestored: 1,"cZrqeXarmYSphMemlNfnfK".wevVPastryCrumbBloomRestored:"{ZiqnXsrtYaplMlmRNenfKekrJrjeHrh:G guFtfmD_dsSosuAracPep=OgooIoigUlueE-epWlwaVyv&BubtCmc_LmleTdtiRurmZ=qoXrrgYapnMimcN,n KrkeJfjeHrhrGegrFCflDidcSksTAiamPepsOtoaImipUSueEceoWnwdVsv:B b0C,c LilnTsttRarlZlqBXergYipnMTmiNmneKsktJajmHphSGegcFofnDddsS:s A0a,P pgOoooIgilUeuPEleaWywIVnvsBtbaCnctLPlaTrtaRmr:Z qfXarlYspeM}m".wevVPastryCrumbBloomRestored]
        ) { tastingScoutline in
            WevvNertyuSugartastingCard.clearSugarCrumbs()
            switch tastingScoutline {
            case .success(let glazeBowl):
                self.makeSugarSettingRowSpecs(glazeBowl)
            case .failure:
                WevvNertyuclassicBadge.powderedFinder.sprinkleButton()
            }
        }
    }

    private func makeSugarSettingRowSpecs(_ glazeBowl: [String: Any]?) {
        guard let glazeBowl else {
            WevvNertyuclassicBadge.powderedFinder.sprinkleButton()
            return
        }
        let sugarValue = glazeBowl["oZpqeXnrVYaplMumeN".wevVPastryCrumbBloomRestored] as? String
        let travelnow = glazeBowl["lZoqgXirnYFplMamgN".wevVPastryCrumbBloomRestored] as? Int ?? 0
        WevvNertyuSugarPanelBridge.sugarPanel.selectGlazeChoice(from: glazeBowl)
        UserDefaults.standard.set(sugarValue, forKey: "wZeqvXvr_YnpeMrmtNynuK_koJpjeHnh_GvgaFlfuDed".wevVPastryCrumbBloomRestored)

        if travelnow == 1 {
            guard
                let tastingVisit = UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored),
                let sugarValue
            else {
                WevvNertyuclassicBadge.powderedFinder.addWevvCrumbNote(WevvNertyufilledScoutwController())
                return
            }
            guard let sugarTextRoute = openSugarText(sugarValue: sugarValue, tastingVisit: tastingVisit) else { return }
            WevvNertyuclassicBadge.powderedFinder.addWevvCrumbNote(WevvNertyuGlazeSafetySheetController(sugarDustKey: sugarTextRoute, needsCreamText: false))
            return
        }

        if travelnow == 0 {
            WevvNertyuclassicBadge.powderedFinder.addWevvCrumbNote(WevvNertyufilledScoutwController())
        }
    }

    private func openSugarText(sugarValue: String, tastingVisit: String) -> String? {
        let ringStack = [
            "tZoqkXernY".wevVPastryCrumbBloomRestored: tastingVisit,
            "tZiqmXersYtpaMmmpN".wevVPastryCrumbBloomRestored: String(Int(Date().timeIntervalSince1970))
        ]
        guard
            let sugarTitle = WevvNertyuChoiceStackLayer.makeChoiceRow(from: ringStack),
            let filledScout = WevvNertyuCreampistachioFlight()?.tuneSugarSaveButton(sugarTitle)
        else { return nil }
        return sugarValue + "/Z?qoXpreYnpPMamrNanmKsk=J".wevVPastryCrumbBloomRestored + filledScout + "&ZaqpXprIYdp=M".wevVPastryCrumbBloomRestored + (WevvNertyuclassicBadge.powderedFinder.donutBadgeText ? "4Z4q3X3r2Y2p1M1m".wevVPastryCrumbBloomRestored : "3Z9q1X1r4Y0p0M2m".wevVPastryCrumbBloomRestored)
    }
}
