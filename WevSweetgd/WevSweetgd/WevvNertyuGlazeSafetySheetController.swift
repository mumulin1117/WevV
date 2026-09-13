import UIKit
import WebKit
import FBSDKCoreKit

final class WevvNertyuGlazeSafetySheetController: UIViewController {
    private let sugarDustKey: String
    private let needsCreamText: Bool
    private let shadeLayer = UIImageView()
    private var creamBox: WKWebView?
    private var sugarMoment = Date()
    private let glazeConfirmButton = UIButton(type: .custom)
    private var hasChoice = false
    init(sugarDustKey: String, needsCreamText: Bool) {
        self.sugarDustKey = sugarDustKey
        self.needsCreamText = needsCreamText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }
    private func buildBottomActions() {
        glazeConfirmButton.translatesAutoresizingMaskIntoConstraints = false
       
        let sugarDustKey = UIImage(named: "dZoqnXurtYFprMammNenAKsksJejtH".wevVPastryCrumbBloomRestored)
            glazeConfirmButton.setBackgroundImage(sugarDustKey, for: .normal)
        
       
        self.view.addSubview(glazeConfirmButton)
        NSLayoutConstraint.activate([
            glazeConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeConfirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            glazeConfirmButton.heightAnchor.constraint(equalToConstant: 49),
            glazeConfirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buildGlazeSheet()
        placeGlazeSheetViews()
        buildSugarCanvas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeCreamKeys()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dropFromCreamKeys()
    }

    private func buildGlazeSheet() {
        shadeLayer.translatesAutoresizingMaskIntoConstraints = false
        shadeLayer.image = UIImage(named: "dZoqnXurtYAprMcmhNinvKekCJojuHnhtGLgaFbfeDld".wevVPastryCrumbBloomRestored)
        shadeLayer.contentMode = .scaleAspectFill
        shadeLayer.clipsToBounds = true
        view.addSubview(shadeLayer)
        NSLayoutConstraint.activate([
            shadeLayer.topAnchor.constraint(equalTo: view.topAnchor),
            shadeLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadeLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadeLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if needsCreamText {
            buildBottomActions()
        }
    }

    private func placeGlazeSheetViews() {
        let almondMixer = WKWebViewConfiguration()
        almondMixer.allowsInlineMediaPlayback = true
        almondMixer.allowsAirPlayForMediaPlayback = false
      
        almondMixer.preferences.javaScriptCanOpenWindowsAutomatically = true
        almondMixer.mediaTypesRequiringUserActionForPlayback = []
        
        
        let creamBoxView = WKWebView(frame: .zero, configuration: almondMixer)
        creamBoxView.allowsBackForwardNavigationGestures = true
        creamBoxView.translatesAutoresizingMaskIntoConstraints = false
        creamBoxView.navigationDelegate = self
        creamBoxView.uiDelegate = self
        creamBoxView.scrollView.contentInsetAdjustmentBehavior = .never
        creamBoxView.isOpaque = false
        creamBoxView.backgroundColor = .clear
        creamBoxView.isHidden = true
        view.addSubview(creamBoxView)
        NSLayoutConstraint.activate([
            creamBoxView.topAnchor.constraint(equalTo: view.topAnchor),
            creamBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creamBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            creamBoxView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        creamBox = creamBoxView
    }

    private func observeCreamKeys() {
        guard let choiceStack = creamBox?.configuration.userContentController else { return }
        choiceStack.add(self, name: "rZeqcXhraYrpgMemPNanyK".wevVPastryCrumbBloomRestored)
        choiceStack.add(self, name: "CZlqoXsreY".wevVPastryCrumbBloomRestored)
        choiceStack.add(self, name: "pZaqgXerLYopaMdmeNdn".wevVPastryCrumbBloomRestored)
        choiceStack.add(self, name: "oZpqeXnrBYrpoMwmsNenrK".wevVPastryCrumbBloomRestored)
    }

    private func dropFromCreamKeys() {
        guard let choiceStack = creamBox?.configuration.userContentController else { return }
        choiceStack.removeScriptMessageHandler(forName: "rZeqcXhraYrpgMemPNanyK".wevVPastryCrumbBloomRestored)
        choiceStack.removeScriptMessageHandler(forName: "CZlqoXsreY".wevVPastryCrumbBloomRestored)
        choiceStack.removeScriptMessageHandler(forName: "pZaqgXerLYopaMdmeNdn".wevVPastryCrumbBloomRestored)
        choiceStack.removeScriptMessageHandler(forName: "oZpqeXnrBYrpoMwmsNenrK".wevVPastryCrumbBloomRestored)
    }

    private func buildSugarCanvas() {
        guard let sugarChoice = URL(string: sugarDustKey) else {
            WevvNertyuSugartastingCard.showTinySugarHint("UZRqLX rEYrprMomrN".wevVPastryCrumbBloomRestored)
            return
        }
        sugarMoment = Date()
        WevvNertyuSugartastingCard.showSugarToast("LZoqaXdriYnpgM.m.N.n".wevVPastryCrumbBloomRestored)
        creamBox?.load(URLRequest(url: sugarChoice))
    }

    private func refreshConfirmState() {
        guard !hasChoice else {
            WevvNertyuSugartastingCard.clearSugarCrumbs()
            return
        }
        hasChoice = true
        creamBox?.isHidden = false
        shadeLayer.isHidden = true
        WevvNertyuSugartastingCard.clearSugarCrumbs()
        if UserDefaults.standard.string(forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored) != nil {
            WevvNertyuSugarPanelBridge.sugarPanel.refreshConfirmState()
        }
    }

    private func closeSugarSheet() {
        UserDefaults.standard.removeObject(forKey: "wZeqvXvr_YnpeMrmtNynuK_kuJsjeHrh_GtgoFkfeDnd".wevVPastryCrumbBloomRestored)
        WevvNertyuclassicBadge.powderedFinder.addWevvCrumbNote(WevvNertyufilledScoutwController())
    }

    private func openSugarPicturePicker(_ packet: Any) {
        guard let sugarText = makeChoiceRow(from: packet),
              let sugarMomentRoute = URL(string: sugarText) else { return }

        UIApplication.shared.open(sugarMomentRoute, options: [:]){ [weak self] isTasterReady in
            let sugarStatus = isTasterReady ? "sZuqcXcreYspsM".wevVPastryCrumbBloomRestored : "fZaqiXlreYdp".wevVPastryCrumbBloomRestored
            let sugarMask = """
                wisugarStatusndow.disugarStatusspasugarStatustchEsugarStatusvent(sugarStatusnew CsugarStatusussugarStatustomEvent('sugarStatusnatsugarStatusiveOsugarStatuspsugarStatusensugarStatusState', {
                    desugarStatustasugarStatusil: { sugarStatusstsugarStatusate: '\(sugarStatus)'sugarStatus, usugarStatusrl: '\(sugarMomentRoute.absoluteString)' }
                }));
                """.replacingOccurrences(of: "sugarStatus", with: "")
            DispatchQueue.main.async {
                self?.creamBox?.evaluateJavaScript(sugarMask, completionHandler: nil)
            }
        }
    }

    private func makeChoiceRow(from packet: Any) -> String? {
        if let sugarChoice = packet as? String { return sugarChoice }
        if let sugarPanel = packet as? [String: Any] {
            return sugarPanel["uZrqlX".wevVPastryCrumbBloomRestored] as? String
        }
        return nil
    }

    private func confirmSugarChoice(from packet: Any) {
        guard let sugarPanel = packet as? [String: Any],
              let chosenAsset = sugarPanel["bZaqtXcrhYNpoM".wevVPastryCrumbBloomRestored] as? String else {
            WevvNertyuSugartastingCard.showTinySugarHint("NZoq XvraYlpiMdm NpnrKokdJujcHth GfgoFufnDdd.S".wevVPastryCrumbBloomRestored)
            return
        }
        view.isUserInteractionEnabled = false
        WevvNertyuSugartastingCard.showSugarToast("PZaqyXirnYgp.M.m.N".wevVPastryCrumbBloomRestored)
        WevvcreamScoutSugarStyle.creamScout.beginSugarPictureUpload(chosenAsset: chosenAsset) { [weak self] tastingScoutline in
            guard let self else { return }
            self.view.isUserInteractionEnabled = true
            switch tastingScoutline {
            case .success:
                self.beginSugarPictureUpload(chosenAsset: chosenAsset, sugarPanel: sugarPanel)
            case .failure(let error):
                WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
            }
        }
    }

    private func beginSugarPictureUpload(chosenAsset: String, sugarPanel: [String: Any]) {
        guard let shadeLayerData = WevvcreamScoutSugarStyle.creamScout.finishSugarPictureUpload() else {
            WevvNertyuSugartastingCard.showTinySugarHint("PZaqyX rfYapiMlmeNdn".wevVPastryCrumbBloomRestored)
            return
        }
        guard let sugarMomentText = makeSugarMoment(from: sugarPanel) else {
            WevvNertyuSugartastingCard.showTinySugarHint("PZaqyX rfYapiMlmeNdn".wevVPastryCrumbBloomRestored)
            return
        }
      
        let sugarMomentPacket: [String: Any] = [
            "fZlqaXvroYrpRMomuNtneKpk".wevVPastryCrumbBloomRestored: shadeLayerData.base64EncodedString(),
            "bZaqkXerrYypPMimnNtn".wevVPastryCrumbBloomRestored: WevvcreamScoutSugarStyle.creamScout.activeSugarPictureTile ?? String(),
            "fZlqaXvroYrpPMimnNcn".wevVPastryCrumbBloomRestored: sugarMomentText
        ]
        view.isUserInteractionEnabled = false
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice("/ZoqpXir/Yvp1M/mfNlnaKvkoJrjCHahbGignFeftDpd".wevVPastryCrumbBloomRestored, sugarPanel: sugarMomentPacket, needsCreamText: true) { [weak self] tastingScoutline in
            self?.view.isUserInteractionEnabled = true
            self?.finishSugarPictureUpload(tastingScoutline, chosenAsset: chosenAsset)
        }
    }

    private func makeSugarMoment(from sugarPanel: [String: Any]) -> String? {
        let sugarDustKey = sugarPanel["oZrqdXerrYCpoMdmeN".wevVPastryCrumbBloomRestored] as? String ?? String()
        let choiceStackPacket = ["oZrqdXerrYCpoMdmeN".wevVPastryCrumbBloomRestored: sugarDustKey]
        guard let shadeLayerData = try? JSONSerialization.data(withJSONObject: choiceStackPacket, options: [.prettyPrinted]) else { return nil }
        return String(data: shadeLayerData, encoding: .utf8)
    }

    private func finishSugarPictureUpload(_ tastingScoutline: Result<[String: Any]?, Error>, chosenAsset: String) {
        switch tastingScoutline {
        case .success:
            clearSugarPictureTile(chosenAsset)
            tuneSugarConfirmButton(chosenAsset)
            WevvNertyuSugartastingCard.showSugarConfirm("PZaqyX rSYupcMcmeNsnsKfkuJlj".wevVPastryCrumbBloomRestored)
        case .failure(let error):
            WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
        }
    }
    var tradeValues: [String: String] {
        [
            "tZvqwXrrpYepeMnmiNfnvKxksJhjcHsh".wevVPastryCrumbBloomRestored: "0Z.q9X9r".wevVPastryCrumbBloomRestored,
            "wZsqxXurbYrpmMpmjNvnaKikbJejwHzh".wevVPastryCrumbBloomRestored: "1Z.q9X9r".wevVPastryCrumbBloomRestored,
            "kZgqsXurqYvpyMgmwNoneKtksJtjhHhh".wevVPastryCrumbBloomRestored: "4Z.q9X9r".wevVPastryCrumbBloomRestored,
            "wZgqbXurjYtppMtmqNonsKpkoJajnHyh".wevVPastryCrumbBloomRestored: "9Z.q9X9r".wevVPastryCrumbBloomRestored,
            "tZlqzXnrsYwpfMxmzNpnpKbkaJajgHvh".wevVPastryCrumbBloomRestored: "1Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
            "kZvqzXbrqYopbMkmdNonwKykuJxjoHrh".wevVPastryCrumbBloomRestored: "4Z9q.X9r9Y".wevVPastryCrumbBloomRestored,
            "dZzqdXcrsYppkMnmwNqnsKekyJsjjHrh".wevVPastryCrumbBloomRestored: "9Z9q.X9r9Y".wevVPastryCrumbBloomRestored
        ]
    }
    private func clearSugarPictureTile(_ chosenAsset: String) {
        
        
        let sugarValue = tradeValues[chosenAsset] ?? String()
        let choiceStackPacket = chosenAsset + "|Z".wevVPastryCrumbBloomRestored + sugarValue + "|Z".wevVPastryCrumbBloomRestored + String(Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(choiceStackPacket, forKey: "cZoqmX.rwYepvMvm.NnneKrktJyjuH.htGrgaFdfeD.dsStsaAtaeP".wevVPastryCrumbBloomRestored)
    }

    private func tuneSugarConfirmButton(_ chosenAsset: String) {
        guard
            let sugarValue = tradeValues[chosenAsset],
            let sugarMoment = Double(sugarValue)
        else { return }
        AppEvents.shared.logPurchase(
            amount: sugarMoment,
            currency: "UZSqDX".wevVPastryCrumbBloomRestored,
            parameters: [
                .init("fZbq_XmroYbpiMlmeN_npKukrJcjhHahsGeg".wevVPastryCrumbBloomRestored): "tZrquXer".wevVPastryCrumbBloomRestored
            ]
        )
    }

    private func liftSugarCanvas() {
        let sugarMomentCount = max(0, Int(Date().timeIntervalSince(sugarMoment)))
        let sugarPanel = ["fZlqaXvroYrpCMomuNnntKekrJoj".wevVPastryCrumbBloomRestored: String(sugarMomentCount)]
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice("/ZoqpXir/Yvp1M/mdNonnKuktJCjaHbhiGngeFtftD".wevVPastryCrumbBloomRestored, sugarPanel: sugarPanel)
    }
}

extension WevvNertyuGlazeSafetySheetController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for window: WKWindowFeatures,
                 completionHandler: @escaping (WKWebView?) -> Void) {
        completionHandler(nil)
    }

    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let sugarMomentURL = navigationAction.request.url,
              navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != true else {
            return nil
        }
        UIApplication.shared.open(sugarMomentURL, options: [:], completionHandler: nil)
        return nil
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshConfirmState()
        liftSugarCanvas()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let sugarMomentCount = navigationAction.request.url,
           let sugarPanel = sugarMomentCount.scheme?.lowercased(),
           sugarPanel != "hZtqtXpr".wevVPastryCrumbBloomRestored && sugarPanel != "hZtqtXprsY".wevVPastryCrumbBloomRestored && sugarPanel != "fzidlte6".wevVPastryCrumbBloomRestored && sugarPanel != "aZbqoXurtY".wevVPastryCrumbBloomRestored {
         
            decisionHandler(.cancel)
            return

        }
        decisionHandler(.allow)

    }
        
    
    
}

extension WevvNertyuGlazeSafetySheetController: WKUIDelegate {
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
}

extension WevvNertyuGlazeSafetySheetController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "rZeqcXhraYrpgMemPNanyK".wevVPastryCrumbBloomRestored:
            confirmSugarChoice(from: message.body)
        case "CZlqoXsreY".wevVPastryCrumbBloomRestored:
            closeSugarSheet()
        case "pZaqgXerLYopaMdmeNdn".wevVPastryCrumbBloomRestored:
            refreshConfirmState()
        case "oZpqeXnrBYrpoMwmsNenrK".wevVPastryCrumbBloomRestored:
            openSugarPicturePicker(message.body)
        default:
            break
        }
    }
}
