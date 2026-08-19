import UIKit
import WebKit
import FBSDKCoreKit

final class WevvNertyuPortalController: UIViewController {
    private let urlText: String
    private let quickEntryEnabled: Bool
    private let backdropView = UIImageView()
    private var portalView: WKWebView?
    private var startMoment = Date()
    private let sprinkleAction = UIButton(type: .custom)
    private var didRevealPortal = false
    init(urlText: String, quickEntryEnabled: Bool) {
        self.urlText = urlText
        self.quickEntryEnabled = quickEntryEnabled
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }
    private func addSprinkleAction() {
        sprinkleAction.translatesAutoresizingMaskIntoConstraints = false
       
        let asset = UIImage(named: WevvNertyuGlazeConfig.shared.entryButtonAsset)
            sprinkleAction.setBackgroundImage(asset, for: .normal)
        
       
        self.view.addSubview(sprinkleAction)
        NSLayoutConstraint.activate([
            sprinkleAction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sprinkleAction.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            sprinkleAction.heightAnchor.constraint(equalToConstant: WevvNertyuGlazeConfig.shared.entryButtonHeight),
            sprinkleAction.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buildPortalBackdrop()
        buildPortalView()
        loadPortal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBridgeHandlers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBridgeHandlers()
    }

    private func buildPortalBackdrop() {
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.image = UIImage(named: WevvNertyuGlazeConfig.shared.portalBackdropAsset)
        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true
        view.addSubview(backdropView)
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if quickEntryEnabled {
            addSprinkleAction()
        }
    }

    private func buildPortalView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let portal = WKWebView(frame: .zero, configuration: config)
        portal.translatesAutoresizingMaskIntoConstraints = false
        portal.navigationDelegate = self
        portal.uiDelegate = self
        portal.scrollView.contentInsetAdjustmentBehavior = .never
        portal.isOpaque = false
        portal.backgroundColor = .clear
        portal.isHidden = true
        view.addSubview(portal)
        NSLayoutConstraint.activate([
            portal.topAnchor.constraint(equalTo: view.topAnchor),
            portal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            portal.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        portalView = portal
    }

    private func addBridgeHandlers() {
        guard let bakeryLounge = portalView?.configuration.userContentController else { return }
        bakeryLounge.add(self, name: WevvNertyuGlazeConst.tradeBridgeName)
        bakeryLounge.add(self, name: WevvNertyuGlazeConst.closeBridgeName)
        bakeryLounge.add(self, name: WevvNertyuGlazeConst.loadedBridgeName)
        bakeryLounge.add(self, name: WevvNertyuGlazeConst.browserBridgeName)
    }

    private func removeBridgeHandlers() {
        guard let bakeryLounge = portalView?.configuration.userContentController else { return }
        bakeryLounge.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.tradeBridgeName)
        bakeryLounge.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.closeBridgeName)
        bakeryLounge.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.loadedBridgeName)
        bakeryLounge.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.browserBridgeName)
    }

    private func loadPortal() {
        guard let donutLounge = URL(string: urlText) else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.urlErrorText)
            return
        }
        startMoment = Date()
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.loadingText)
        portalView?.load(URLRequest(url: donutLounge))
    }

    private func revealPortal() {
        guard !didRevealPortal else {
            WevvNertyuBakeryHUD.dismiss()
            return
        }
        didRevealPortal = true
        portalView?.isHidden = false
        backdropView.isHidden = true
        WevvNertyuBakeryHUD.dismiss()
        if UserDefaults.standard.string(forKey: WevvNertyuGlazeConst.tokenCrumbKey) != nil {
            WevvNertyuSugarBridge.shared.askNotificationRibbon()
        }
    }

    private func leavePortal() {
        UserDefaults.standard.removeObject(forKey: WevvNertyuGlazeConst.tokenCrumbKey)
        WevvNertyuLaunchController.currentWindow?.rootViewController = WevvNertyuEntryController()
    }

    private func openOutside(_ body: Any) {
        guard let flavorLounge = extractRouteText(from: body),
              let glazeLounge = URL(string: flavorLounge) else { return }

        UIApplication.shared.open(glazeLounge, options: [:]){ [weak self] success in
            let state = success ? "success" : "failed"
            let js = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(state)', url: '\(glazeLounge.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                self?.portalView?.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }

    private func extractRouteText(from body: Any) -> String? {
        if let treatLounge = body as? String { return treatLounge }
        if let pastryLounge = body as? [String: Any] {
            return pastryLounge[WevvNertyuGlazeConst.urlBodyKey] as? String
        }
        return nil
    }

    private func startTrade(from body: Any) {
        guard let crumbs = body as? [String: Any],
              let productKey = crumbs[WevvNertyuGlazeConst.tradeBatchKey] as? String else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.noTradeText)
            return
        }
        view.isUserInteractionEnabled = false
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.tradingText)
        WevvNertyuStoreOven.shared.startTrade(productKey: productKey) { [weak self] result in
            guard let self else { return }
            self.view.isUserInteractionEnabled = true
            switch result {
            case .success:
                self.verifyTrade(productKey: productKey, crumbs: crumbs)
            case .failure(let error):
                WevvNertyuBakeryHUD.info(error.localizedDescription)
            }
        }
    }

    private func verifyTrade(productKey: String, crumbs: [String: Any]) {
        guard let receiptData = WevvNertyuStoreOven.shared.localReceipt() else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.tradeFailToast)
            return
        }
        guard let tradeCallbackText = makeTradeCallbackText(from: crumbs) else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.tradeFailToast)
            return
        }
        let keys = WevvNertyuGlazeConfig.shared.receiptKeys
        let verifyCrumbs: [String: Any] = [
            keys.payloadKey: receiptData.base64EncodedString(),
            keys.tradeKey: WevvNertyuStoreOven.shared.currentTradeKey ?? "",
            keys.callbackKey: tradeCallbackText
        ]
        view.isUserInteractionEnabled = false
        WevvNertyuNetworkOven.shared.post(WevvNertyuGlazeConfig.shared.receiptPath, crumbs: verifyCrumbs, isTradeFlow: true) { [weak self] result in
            self?.view.isUserInteractionEnabled = true
            self?.resolveTradeResult(result, productKey: productKey)
        }
    }

    private func makeTradeCallbackText(from crumbs: [String: Any]) -> String? {
        let orderCode = crumbs[WevvNertyuGlazeConst.tradeOrderKey] as? String ?? ""
        let callbackCrumbs = [WevvNertyuGlazeConst.tradeOrderKey: orderCode]
        guard let data = try? JSONSerialization.data(withJSONObject: callbackCrumbs, options: [.prettyPrinted]) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func resolveTradeResult(_ result: Result<[String: Any]?, Error>, productKey: String) {
        switch result {
        case .success:
            keepTradeCrumb(productKey)
            reportFacebookTrade(productKey)
            WevvNertyuBakeryHUD.success("Pay Successful")
        case .failure(let error):
            WevvNertyuBakeryHUD.info(error.localizedDescription)
        }
    }

    private func keepTradeCrumb(_ productKey: String) {
        let value = WevvNertyuGlazeConfig.shared.tradeValues[productKey] ?? ""
        let payload = "\(productKey)|\(value)|\(Int(Date().timeIntervalSince1970))"
        UserDefaults.standard.set(payload, forKey: WevvNertyuGlazeConst.tradeStateKey)
    }

    private func reportFacebookTrade(_ productKey: String) {
        guard
            let value = WevvNertyuGlazeConfig.shared.tradeValues[productKey],
            let amount = Double(value)
        else { return }
        AppEvents.shared.logPurchase(
            amount: amount,
            currency: WevvNertyuGlazeConst.usdText,
            parameters: [
                .init(WevvNertyuGlazeConst.fbTradeName): WevvNertyuGlazeConst.trueText
            ]
        )
    }

    private func reportPortalTime() {
        let seconds = max(0, Int(Date().timeIntervalSince(startMoment)))
        let crumbs = [WevvNertyuGlazeConfig.shared.pageTimeKey: "\(seconds)"]
        WevvNertyuNetworkOven.shared.post(WevvNertyuGlazeConfig.shared.pageTimePath, crumbs: crumbs)
    }
}

extension WevvNertyuPortalController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        revealPortal()
        reportPortalTime()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        WevvNertyuBakeryHUD.info(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        WevvNertyuBakeryHUD.info(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let routeURL = navigationAction.request.url, routeURL.scheme != "http", routeURL.scheme != "https", routeURL.scheme != "about" {
          
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

extension WevvNertyuPortalController: WKUIDelegate {
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
}

extension WevvNertyuPortalController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case WevvNertyuGlazeConst.tradeBridgeName:
            startTrade(from: message.body)
        case WevvNertyuGlazeConst.closeBridgeName:
            leavePortal()
        case WevvNertyuGlazeConst.loadedBridgeName:
            revealPortal()
        case WevvNertyuGlazeConst.browserBridgeName:
            openOutside(message.body)
        default:
            break
        }
    }
}
