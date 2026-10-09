import AVFoundation
import UIKit
import WebKit

final class WevVGlazeActortroller: UIViewController {
    private enum pastryPalette {
        static let handler = "roomBridge"
        static let receiver = "__ROOM_H5_BRIDGE_RECEIVE__"
    }

    private static let pastelBackdropGallery = UIColor(
        red: 21.0 / 255.0,
        green: 5.0 / 255.0,
        blue: 46.0 / 255.0,
        alpha: 1
    )

    private struct pastryCompendiumSeries: Decodable {
        struct pastryCatalogEntry: Decodable {
            let minimumHostVersion: String
        }

        struct glazeNotebookEntry: Decodable {
            let handler: String
            let receiver: String
        }

        let build: pastryCatalogEntry
        let bridge: glazeNotebookEntry
    }

    private let tastingRoom: pearFilling
    private var pastryWebView: WKWebView?
    private var pastryBundleURL: URL?
    private var pastryBridgeHandler = pastryPalette.handler
    private var pastryBridgeReceiver = pastryPalette.receiver
    private var pastryLoadTask: Task<Void, Never>?
    private var pastryFreshnessTask: Task<Void, Never>?
    private var pastryErrorView: UIView?
    private var pastryLoadingView: UIView?
    private var tastingCommandArchive = Set<String>()

    init(tastingRoom: pearFilling) {
        self.tastingRoom = tastingRoom
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Self.pastelBackdropGallery
        prepareTastingParlor()
    }

    deinit {
        pastryFreshnessTask?.cancel()
        pastryLoadTask?.cancel()
        pastryWebView?.configuration.userContentController.removeScriptMessageHandler(forName: pastryBridgeHandler)
    }

    private func prepareTastingParlor() {
        pastryFreshnessTask?.cancel()
        showPastryLoading()
        pastryFreshnessTask = Task { [weak self] in
            let isReady = await WevVGlazeSessionRepository.pastryTrailDiary.donutCarnivalCalendar()
            guard !Task.isCancelled, let self else { return }
            self.pastryFreshnessTask = nil
            guard isReady else {
                self.showTastingParlorError("The room could not be prepared. Please try again.")
                return
            }
            self.buildTastingParlor()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || navigationController?.isBeingDismissed == true {
            tearDownTastingParlor()
        }
    }

    private func buildTastingParlor() {
        tearDownTastingParlor()
        pastryErrorView?.removeFromSuperview()
        pastryErrorView = nil
        guard let tastingCredentials = WevVGlazeSessionStore.shared.currentGlazeCredentials else {
            showTastingParlorError("Please log in before joining a room.")
            return
        }
        guard let pastryBundle = Bundle.main.url(forResource: "room-dist", withExtension: "bundle") else {
            showTastingParlorError("The room experience is unavailable in this build.")
            return
        }
        guard let parlorConfig = readTastingParlorConfig(bundleURL: pastryBundle),
              isTastingHostVersionSupported(minimumVersion: parlorConfig.build.minimumHostVersion) else {
            showTastingParlorError("Please update WevV before joining this room.")
            return
        }
        let pastryIndex = pastryBundle.appendingPathComponent("index.html", isDirectory: false)
        guard FileManager.default.fileExists(atPath: pastryIndex.path),
              let parlorURL = makeTastingParlorURL(pastryIndexURL: pastryIndex, tastingCredentials: tastingCredentials) else {
            showTastingParlorError("The room experience is unavailable in this build.")
            return
        }

        let pastryMessageController = WKUserContentController()
        pastryBridgeHandler = parlorConfig.bridge.handler
        pastryBridgeReceiver = parlorConfig.bridge.receiver
        pastryMessageController.add(self, name: pastryBridgeHandler)
        let pastryConfiguration = WKWebViewConfiguration()
        pastryConfiguration.userContentController = pastryMessageController
        pastryConfiguration.allowsInlineMediaPlayback = true
        pastryConfiguration.mediaTypesRequiringUserActionForPlayback = []

        let pastryView = WKWebView(frame: .zero, configuration: pastryConfiguration)
        pastryView.translatesAutoresizingMaskIntoConstraints = false
        pastryView.navigationDelegate = self
        pastryView.uiDelegate = self
        pastryView.isOpaque = false
        pastryView.backgroundColor = Self.pastelBackdropGallery
        pastryView.scrollView.backgroundColor = Self.pastelBackdropGallery
        pastryView.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(pastryView)
        NSLayoutConstraint.activate([
            pastryView.topAnchor.constraint(equalTo: view.topAnchor),
            pastryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        pastryBundleURL = pastryBundle
        pastryWebView = pastryView
        showPastryLoading()
        pastryView.loadFileURL(parlorURL, allowingReadAccessTo: pastryBundle)
        startTastingParlorTimeout()
    }

    private func showPastryLoading() {
        pastryLoadingView?.removeFromSuperview()

        let loadingPanel = UIView()
        loadingPanel.translatesAutoresizingMaskIntoConstraints = false
        loadingPanel.backgroundColor = Self.pastelBackdropGallery

        let glazeIndicator = UIActivityIndicatorView(style: .large)
        glazeIndicator.translatesAutoresizingMaskIntoConstraints = false
        glazeIndicator.color = .white
        glazeIndicator.startAnimating()

        loadingPanel.addSubview(glazeIndicator)
        view.addSubview(loadingPanel)
        NSLayoutConstraint.activate([
            loadingPanel.topAnchor.constraint(equalTo: view.topAnchor),
            loadingPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            glazeIndicator.centerXAnchor.constraint(equalTo: loadingPanel.centerXAnchor),
            glazeIndicator.centerYAnchor.constraint(equalTo: loadingPanel.centerYAnchor)
        ])
        pastryLoadingView = loadingPanel
    }

    private func hidePastryLoading() {
        pastryLoadTask?.cancel()
        pastryLoadTask = nil
        guard let loadingPanel = pastryLoadingView else { return }
        pastryLoadingView = nil
        let duration = UIAccessibility.isReduceMotionEnabled ? 0 : 0.2
        UIView.animate(withDuration: duration, animations: {
            loadingPanel.alpha = 0
        }, completion: { _ in
            loadingPanel.removeFromSuperview()
        })
    }

    private func makeTastingParlorURL(pastryIndexURL: URL, tastingCredentials: almondPralineGlaze) -> URL? {
        let parlorPath = tastingRoom.lemonCurd == .blueberryCustard ? "live" : "voice"
        let token = tastingCredentials.brownButterGlaze.hasPrefix("Bearer ")
            ? String(tastingCredentials.brownButterGlaze.dropFirst("Bearer ".count))
            : tastingCredentials.brownButterGlaze
        let values = [
            "token": token,
            "userId": String(tastingCredentials.vanillaBeanIcing),
            "appVersion": filledShellSelection.tastingJourneyAtlas,
            "deviceNo": filledShellSelection.glazeQuestTrail,
            "locale": filledShellSelection.flavorJourneyJournal
        ]
        let query = values
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\(pastryEncode($0.value))" }
            .joined(separator: "&")
        let fragment = "/\(parlorPath)/\(pastryEncode(tastingRoom.passionfruitMousse))?\(query)"
        return URL(string: "\(pastryIndexURL.absoluteString)#\(fragment)")
    }

    private func readTastingParlorConfig(bundleURL: URL) -> pastryCompendiumSeries? {
        let configURL = bundleURL.appendingPathComponent("config/app-config.js", isDirectory: false)
        guard let source = try? String(contentsOf: configURL, encoding: .utf8),
              let startRange = source.range(of: "/*__APP_CONFIG_START__*/"),
              let endRange = source.range(of: "/*__APP_CONFIG_END__*/", range: startRange.upperBound..<source.endIndex) else {
            return nil
        }
        let json = source[startRange.upperBound..<endRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(pastryCompendiumSeries.self, from: data)
    }

    private func isTastingHostVersionSupported(minimumVersion: String) -> Bool {
        let actualParts = filledShellSelection.tastingJourneyAtlas.split(separator: ".").compactMap { Int($0) }
        let minimumParts = minimumVersion.split(separator: ".").compactMap { Int($0) }
        guard !actualParts.isEmpty, !minimumParts.isEmpty,
              actualParts.count == filledShellSelection.tastingJourneyAtlas.split(separator: ".").count,
              minimumParts.count == minimumVersion.split(separator: ".").count else { return false }
        for index in 0..<max(actualParts.count, minimumParts.count) {
            let actual = index < actualParts.count ? actualParts[index] : 0
            let minimum = index < minimumParts.count ? minimumParts[index] : 0
            if actual != minimum { return actual > minimum }
        }
        return true
    }

    private func pastryEncode(_ value: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
    }

    private func showTastingParlorError(_ notice: String) {
        tearDownTastingParlor()
        pastryErrorView?.removeFromSuperview()
        let errorPanel = UIView()
        errorPanel.translatesAutoresizingMaskIntoConstraints = false
        errorPanel.backgroundColor = view.backgroundColor

        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.tintColor = .white
        close.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        close.layer.cornerRadius = 22
        close.addTarget(self, action: #selector(closeTastingParlor), for: .touchUpInside)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = notice
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0

        let retry = UIButton(type: .system)
        retry.translatesAutoresizingMaskIntoConstraints = false
        retry.setTitle("Retry", for: .normal)
        retry.setTitleColor(.white, for: .normal)
        retry.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        retry.backgroundColor = UIColor(red: 1, green: 0.19, blue: 0.47, alpha: 1)
        retry.layer.cornerRadius = 22
        retry.addTarget(self, action: #selector(retryTastingParlor), for: .touchUpInside)

        view.addSubview(errorPanel)
        errorPanel.addSubview(close)
        errorPanel.addSubview(label)
        errorPanel.addSubview(retry)
        NSLayoutConstraint.activate([
            errorPanel.topAnchor.constraint(equalTo: view.topAnchor),
            errorPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            close.topAnchor.constraint(equalTo: errorPanel.safeAreaLayoutGuide.topAnchor, constant: 12),
            close.leadingAnchor.constraint(equalTo: errorPanel.leadingAnchor, constant: 16),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalTo: close.widthAnchor),
            label.centerYAnchor.constraint(equalTo: errorPanel.centerYAnchor, constant: -30),
            label.leadingAnchor.constraint(equalTo: errorPanel.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: errorPanel.trailingAnchor, constant: -32),
            retry.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            retry.centerXAnchor.constraint(equalTo: errorPanel.centerXAnchor),
            retry.widthAnchor.constraint(equalToConstant: 132),
            retry.heightAnchor.constraint(equalToConstant: 44)
        ])
        pastryErrorView = errorPanel
    }

    private func startTastingParlorTimeout() {
        pastryLoadTask?.cancel()
        pastryLoadTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 20_000_000_000)
            guard !Task.isCancelled, let self else { return }
            self.showTastingParlorError("The room is taking too long to load. Please try again.")
        }
    }

    private func tearDownTastingParlor() {
        pastryLoadTask?.cancel()
        pastryLoadTask = nil
        pastryLoadingView?.removeFromSuperview()
        pastryLoadingView = nil
        guard let webView = pastryWebView else { return }
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
        webView.configuration.userContentController.removeScriptMessageHandler(forName: pastryBridgeHandler)
        webView.removeFromSuperview()
        pastryWebView = nil
        pastryBundleURL = nil
    }

    @objc private func retryTastingParlor() {
        prepareTastingParlor()
    }

    @objc private func closeTastingParlor() {
        Task {
            _ = try? await WevVGlazeSessionRepository.pastryTrailDiary.coldBrewTasting()
        }
        tearDownTastingParlor()
        dismiss(animated: true)
    }

    private func openPastryVault() {
        guard presentedViewController == nil else { return }
        let vault = WevVDonutdenCrumbCenterler()
        vault.silkyCenter = { [weak self] in
            self?.sendPastryRechargeSucceeded()
        }
        vault.modalPresentationStyle = .fullScreen
        present(vault, animated: true)
    }

    private func sendPastryRechargeSucceeded() {
        let eventMessage: [String: Any] = [
            "protocolVersion": 1,
            "kind": "event",
            "name": "recharge.succeeded",
            "payload": [
                "eventId": UUID().uuidString,
                "occurredAt": Int64(Date().timeIntervalSince1970 * 1_000)
            ]
        ]
        guard let webView = pastryWebView else { return }
        Task {
            _ = try? await webView.callAsyncJavaScript(
                "window[receiver](message)",
                arguments: ["receiver": pastryBridgeReceiver, "message": eventMessage],
                in: nil,
                contentWorld: .page
            )
        }
    }

    private func isValidPastryCommand(_ pastryCommand: [String: Any]) -> Bool {
        guard pastryCommand["protocolVersion"] as? Int == 1,
              pastryCommand["kind"] as? String == "command",
              let commandID = pastryCommand["id"] as? String,
              !commandID.isEmpty,
              commandID.count <= 128,
              pastryCommand["occurredAt"] is NSNumber,
              !tastingCommandArchive.contains(commandID) else { return false }
        tastingCommandArchive.insert(commandID)
        if tastingCommandArchive.count > 200,
           let firstCommand = tastingCommandArchive.first {
            tastingCommandArchive.remove(firstCommand)
        }
        return true
    }

    private func isCurrentTastingPayload(_ payload: [String: Any]) -> Bool {
        payload["roomId"] as? String == tastingRoom.passionfruitMousse
            && payload["roomType"] as? String == tastingRoom.lemonCurd.rawValue
    }
}

extension WevVGlazeActortroller: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == pastryBridgeHandler,
              let command = message.body as? [String: Any],
              isValidPastryCommand(command),
              let name = command["name"] as? String,
              let payload = command["payload"] as? [String: Any],
              isCurrentTastingPayload(payload) else { return }
        switch name {
        case "room.ready":
            hidePastryLoading()
        case "room.close":
            guard let reason = payload["reason"] as? String,
                  ["user", "ended", "fatal", "auth-invalid"].contains(reason) else { return }
            closeTastingParlor()
        case "recharge.open":
            guard let requestID = payload["requestId"] as? String,
                  !requestID.isEmpty,
                  requestID.count <= 128,
                  let source = payload["source"] as? String,
                  ["live", "party"].contains(source),
                  let requiredDiamonds = payload["requiredDiamonds"] as? NSNumber,
                  requiredDiamonds.doubleValue.isFinite,
                  requiredDiamonds.doubleValue >= 0 else { return }
            openPastryVault()
        default:
            break
        }
    }
}

extension WevVGlazeActortroller: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showTastingParlorError("The room could not be loaded. Please try again.")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showTastingParlorError("The room could not be loaded. Please try again.")
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if url.scheme == "about" {
            decisionHandler(.allow)
            return
        }
        guard url.isFileURL, let distURL = pastryBundleURL else {
            decisionHandler(.cancel)
            return
        }
        let rootPath = distURL.standardizedFileURL.path.hasSuffix("/")
            ? distURL.standardizedFileURL.path
            : distURL.standardizedFileURL.path + "/"
        decisionHandler(url.standardizedFileURL.path.hasPrefix(rootPath) ? .allow : .cancel)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        buildTastingParlor()
    }
}

extension WevVGlazeActortroller: WKUIDelegate {
    @available(iOS 15.0, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        guard frame.isMainFrame, origin.protocol.lowercased() == "file" else {
            decisionHandler(.deny)
            return
        }
        Task {
            let allowed: Bool
            switch type {
            case .microphone:
                allowed = await requestGlazeCaptureAccess(for: .audio)
            case .camera:
                allowed = await requestGlazeCaptureAccess(for: .video)
            case .cameraAndMicrophone:
                let microphone = await requestGlazeCaptureAccess(for: .audio)
                if microphone {
                    allowed = await requestGlazeCaptureAccess(for: .video)
                } else {
                    allowed = false
                }
            @unknown default:
                allowed = false
            }
            decisionHandler(allowed ? .grant : .deny)
        }
    }

    private func requestGlazeCaptureAccess(for mediaType: AVMediaType) async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: mediaType)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}
