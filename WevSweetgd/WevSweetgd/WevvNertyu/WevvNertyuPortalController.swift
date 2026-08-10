import UIKit
import WebKit

final class WevvNertyuPortalController: UIViewController {
    private let urlText: String
    private let quickEntryEnabled: Bool
    private let backdropView = UIImageView()
    private var portalView: WKWebView?
    private var startMoment = Date()

    init(urlText: String, quickEntryEnabled: Bool) {
        self.urlText = urlText
        self.quickEntryEnabled = quickEntryEnabled
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
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
        guard let content = portalView?.configuration.userContentController else { return }
        content.add(self, name: WevvNertyuGlazeConst.tradeBridgeName)
        content.add(self, name: WevvNertyuGlazeConst.closeBridgeName)
        content.add(self, name: WevvNertyuGlazeConst.loadedBridgeName)
        content.add(self, name: WevvNertyuGlazeConst.browserBridgeName)
    }

    private func removeBridgeHandlers() {
        guard let content = portalView?.configuration.userContentController else { return }
        content.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.tradeBridgeName)
        content.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.closeBridgeName)
        content.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.loadedBridgeName)
        content.removeScriptMessageHandler(forName: WevvNertyuGlazeConst.browserBridgeName)
    }

    private func loadPortal() {
        guard let portalURL = URL(string: urlText) else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.urlErrorText)
            return
        }
        startMoment = Date()
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.loadingText)
        portalView?.load(URLRequest(url: portalURL))
    }

    private func revealPortal() {
        portalView?.isHidden = false
        backdropView.isHidden = true
        WevvNertyuBakeryHUD.dismiss()
    }

    private func leavePortal() {
        UserDefaults.standard.removeObject(forKey: WevvNertyuGlazeConst.tokenCrumbKey)
        WevvNertyuLaunchController.currentWindow?.rootViewController = WevvNertyuEntryController()
    }

    private func openOutside(_ body: Any) {
        guard let routeText = extractRouteText(from: body),
              let routeURL = URL(string: routeText) else { return }
        UIApplication.shared.open(routeURL)
        let script = "window.dispatchEvent(new CustomEvent('openBrowserBack',{detail:{success:true}}));"
        portalView?.evaluateJavaScript(script)
    }

    private func extractRouteText(from body: Any) -> String? {
        if let text = body as? String { return text }
        if let dict = body as? [String: Any] {
            return dict[WevvNertyuGlazeConst.urlBodyKey] as? String
        }
        return nil
    }

    private func startTrade(from body: Any) {
        guard let crumbs = body as? [String: Any],
              let productKey = crumbs[WevvNertyuGlazeConst.tradeBatchKey] as? String else {
            WevvNertyuBakeryHUD.info(WevvNertyuGlazeConst.noTradeText)
            return
        }
        WevvNertyuBakeryHUD.show(WevvNertyuGlazeConst.tradingText)
        WevvNertyuStoreOven.shared.startTrade(productKey: productKey) { [weak self] result in
            switch result {
            case .success:
                self?.verifyTrade(productKey: productKey, crumbs: crumbs)
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
        let keys = WevvNertyuGlazeConfig.shared.receiptKeys
        let verifyCrumbs: [String: Any] = [
            keys.payloadKey: receiptData.base64EncodedString(),
            keys.tradeKey: WevvNertyuStoreOven.shared.currentTradeKey ?? "",
            keys.callbackKey: crumbs[WevvNertyuGlazeConst.tradeOrderKey] as? String ?? ""
        ]
        WevvNertyuNetworkOven.shared.post(WevvNertyuGlazeConfig.shared.receiptPath, crumbs: verifyCrumbs, isTradeFlow: true) { [weak self] result in
            self?.resolveTradeResult(result, productKey: productKey)
        }
    }

    private func resolveTradeResult(_ result: Result<[String: Any]?, Error>, productKey: String) {
        switch result {
        case .success:
            keepTradeCrumb(productKey)
            WevvNertyuBakeryHUD.success("Success")
        case .failure(let error):
            WevvNertyuBakeryHUD.info(error.localizedDescription)
        }
    }

    private func keepTradeCrumb(_ productKey: String) {
        let value = WevvNertyuGlazeConfig.shared.tradeValues[productKey] ?? ""
        let payload = "\(productKey)|\(value)|\(Int(Date().timeIntervalSince1970))"
        UserDefaults.standard.set(payload, forKey: WevvNertyuGlazeConst.tradeStateKey)
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
            UIApplication.shared.open(routeURL)
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
