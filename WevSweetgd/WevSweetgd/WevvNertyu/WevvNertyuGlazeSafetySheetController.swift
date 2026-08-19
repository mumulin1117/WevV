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
       
        let asset = UIImage(named: WevvNertyuclassicBadge.shared.entryButtonAsset)
            glazeConfirmButton.setBackgroundImage(asset, for: .normal)
        
       
        self.view.addSubview(glazeConfirmButton)
        NSLayoutConstraint.activate([
            glazeConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeConfirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            glazeConfirmButton.heightAnchor.constraint(equalToConstant: WevvNertyuclassicBadge.shared.entryButtonHeight),
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
        shadeLayer.image = UIImage(named: WevvNertyuclassicBadge.shared.portalBackdropAsset)
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
        let creamBoxView = WKWebView(frame: .zero, configuration: almondMixer)
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
        choiceStack.add(self, name: WevvmarshmallowFlight.tradeBridgeName)
        choiceStack.add(self, name: WevvmarshmallowFlight.closeBridgeName)
        choiceStack.add(self, name: WevvmarshmallowFlight.loadedBridgeName)
        choiceStack.add(self, name: WevvmarshmallowFlight.browserBridgeName)
    }

    private func dropFromCreamKeys() {
        guard let choiceStack = creamBox?.configuration.userContentController else { return }
        choiceStack.removeScriptMessageHandler(forName: WevvmarshmallowFlight.tradeBridgeName)
        choiceStack.removeScriptMessageHandler(forName: WevvmarshmallowFlight.closeBridgeName)
        choiceStack.removeScriptMessageHandler(forName: WevvmarshmallowFlight.loadedBridgeName)
        choiceStack.removeScriptMessageHandler(forName: WevvmarshmallowFlight.browserBridgeName)
    }

    private func buildSugarCanvas() {
        guard let sugarChoice = URL(string: sugarDustKey) else {
            WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.urlErrorText)
            return
        }
        sugarMoment = Date()
        WevvNertyuSugartastingCard.showSugarToast(WevvmarshmallowFlight.loadingText)
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
        if UserDefaults.standard.string(forKey: WevvmarshmallowFlight.tokenCrumbKey) != nil {
            WevvNertyuSugarPanelBridge.sugarPanel.refreshConfirmState()
        }
    }

    private func closeSugarSheet() {
        UserDefaults.standard.removeObject(forKey: WevvmarshmallowFlight.tokenCrumbKey)
        WevvNertyuBuildListLayerController.sugarContentView?.rootViewController = WevvNertyufilledScoutwController()
    }

    private func openSugarPicturePicker(_ packet: Any) {
        guard let sugarText = makeChoiceRow(from: packet),
              let sugarMomentRoute = URL(string: sugarText) else { return }

        UIApplication.shared.open(sugarMomentRoute, options: [:]){ [weak self] isTasterReady in
            let sugarStatus = isTasterReady ? "success" : "failed"
            let sugarMask = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(sugarStatus)', url: '\(sugarMomentRoute.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                self?.creamBox?.evaluateJavaScript(sugarMask, completionHandler: nil)
            }
        }
    }

    private func makeChoiceRow(from packet: Any) -> String? {
        if let sugarChoice = packet as? String { return sugarChoice }
        if let sugarPanel = packet as? [String: Any] {
            return sugarPanel[WevvmarshmallowFlight.urlBodyKey] as? String
        }
        return nil
    }

    private func confirmSugarChoice(from packet: Any) {
        guard let sugarPanel = packet as? [String: Any],
              let chosenAsset = sugarPanel[WevvmarshmallowFlight.tradeBatchKey] as? String else {
            WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.noTradeText)
            return
        }
        view.isUserInteractionEnabled = false
        WevvNertyuSugartastingCard.showSugarToast(WevvmarshmallowFlight.tradingText)
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
            WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.tradeFailToast)
            return
        }
        guard let sugarMomentText = makeSugarMoment(from: sugarPanel) else {
            WevvNertyuSugartastingCard.showTinySugarHint(WevvmarshmallowFlight.tradeFailToast)
            return
        }
        let choice = WevvNertyuclassicBadge.shared.receiptKeys
        let sugarMomentPacket: [String: Any] = [
            choice.payloadKey: shadeLayerData.base64EncodedString(),
            choice.tradeKey: WevvcreamScoutSugarStyle.creamScout.activeSugarPictureTile ?? "",
            choice.callbackKey: sugarMomentText
        ]
        view.isUserInteractionEnabled = false
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice(WevvNertyuclassicBadge.shared.receiptPath, sugarPanel: sugarMomentPacket, needsCreamText: true) { [weak self] tastingScoutline in
            self?.view.isUserInteractionEnabled = true
            self?.finishSugarPictureUpload(tastingScoutline, chosenAsset: chosenAsset)
        }
    }

    private func makeSugarMoment(from sugarPanel: [String: Any]) -> String? {
        let sugarDustKey = sugarPanel[WevvmarshmallowFlight.tradeOrderKey] as? String ?? ""
        let choiceStackPacket = [WevvmarshmallowFlight.tradeOrderKey: sugarDustKey]
        guard let shadeLayerData = try? JSONSerialization.data(withJSONObject: choiceStackPacket, options: [.prettyPrinted]) else { return nil }
        return String(data: shadeLayerData, encoding: .utf8)
    }

    private func finishSugarPictureUpload(_ tastingScoutline: Result<[String: Any]?, Error>, chosenAsset: String) {
        switch tastingScoutline {
        case .success:
            clearSugarPictureTile(chosenAsset)
            tuneSugarConfirmButton(chosenAsset)
            WevvNertyuSugartastingCard.showSugarConfirm("Pay Successful")
        case .failure(let error):
            WevvNertyuSugartastingCard.showTinySugarHint(error.localizedDescription)
        }
    }

    private func clearSugarPictureTile(_ chosenAsset: String) {
        let sugarValue = WevvNertyuclassicBadge.shared.tradeValues[chosenAsset] ?? ""
        let choiceStackPacket = "\(chosenAsset)|\(sugarValue)|\(Int(Date().timeIntervalSince1970))"
        UserDefaults.standard.set(choiceStackPacket, forKey: WevvmarshmallowFlight.tradeStateKey)
    }

    private func tuneSugarConfirmButton(_ chosenAsset: String) {
        guard
            let sugarValue = WevvNertyuclassicBadge.shared.tradeValues[chosenAsset],
            let sugarMoment = Double(sugarValue)
        else { return }
        AppEvents.shared.logPurchase(
            amount: sugarMoment,
            currency: WevvmarshmallowFlight.usdText,
            parameters: [
                .init(WevvmarshmallowFlight.fbTradeName): WevvmarshmallowFlight.trueText
            ]
        )
    }

    private func liftSugarCanvas() {
        let sugarMomentCount = max(0, Int(Date().timeIntervalSince(sugarMoment)))
        let sugarPanel = [WevvNertyuclassicBadge.shared.pageTimeKey: "\(sugarMomentCount)"]
        WevvNertyuChoiceStackLayer.choiceStack.confirmSugarChoice(WevvNertyuclassicBadge.shared.pageTimePath, sugarPanel: sugarPanel)
    }
}

extension WevvNertyuGlazeSafetySheetController: WKNavigationDelegate {
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

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let routeURL = navigationAction.request.url, routeURL.scheme != "http", routeURL.scheme != "https", routeURL.scheme != "about" {
          
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
        case WevvmarshmallowFlight.tradeBridgeName:
            confirmSugarChoice(from: message.body)
        case WevvmarshmallowFlight.closeBridgeName:
            closeSugarSheet()
        case WevvmarshmallowFlight.loadedBridgeName:
            refreshConfirmState()
        case WevvmarshmallowFlight.browserBridgeName:
            openSugarPicturePicker(message.body)
        default:
            break
        }
    }
}
