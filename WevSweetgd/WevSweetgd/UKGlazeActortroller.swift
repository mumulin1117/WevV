import AVFoundation
import CommonCrypto
import CoreFoundation
import UIKit
import WebKit
import zlib

/// Shared SDK 2 container. H5 owns its secondary pages, room membership, IM and RTC.
final class UKGlazeActortroller: UIViewController {
    private static weak var glazeActiveHost: UKGlazeActortroller?
    private static var glazeStandbyHost: UKGlazeActortroller?
    private static var glazeWebPrewarmTask: Task<Void, Never>?
    private static let glazePaintHandler = "wevvGlazeFirstPaint"
    private struct GlazeArchiveStamp: Equatable, Sendable {
        let inode: UInt64
        let size: UInt64
        let modifiedAt: Date
    }
    private struct GlazePreparedArchive: Sendable {
        let folder: URL
        let bootstrapPaths: [String]
        let stamp: [String: GlazeArchiveStamp]
    }
    private static var glazeResourcePreparation: (id: UUID, task: Task<GlazePreparedArchive?, Never>)?
    private static var glazePreparedResources: GlazePreparedArchive?
    private enum sugarPalette {
        // Keep the established archive derivation declarations available to the packaging tool.
        nonisolated static let crumbArchiveName = "vqaqnqiqlqlqaqBqeqaqnqIqcqiqnqgq".wevVPastryCrumbBloomRestored
        nonisolated static let vanillaCipher = "vXaXnXiXlXlXaXBXeXaXnXIXcXiXnXgXSXaXlXtXeXdXCXaXrXaXmXeXlXFXiXnXiXsXhX".wevVPastryCrumbBloomRestored
        nonisolated static let sdkArchiveName = "vanillaBeanIcingSdk2"
    }
    nonisolated static var glazeArchiveConfigurationSeed: String { sugarPalette.vanillaCipher }
    private static let berryBackdrop = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
    private static let contextPaths = [
        "deviceNo", "apiBaseUrl", "fullFeaturesEnabled", "open", "open.runtimeConfig",
        "open.runtimeConfig.imAppKey", "open.runtimeConfig.noticeAccount", "open.runtimeConfig.rtcAppId",
        "open.runtimeConfig.sapiAesIv", "open.runtimeConfig.sapiAesKey", "open.runtimeConfig.sapiBaseUrl", "open.runtimeConfig.socketUrl",
        "open.cdnDomainConfig", "session", "session.accountId", "session.accessToken", "session.legacyToken",
        "session.realtime", "session.realtime.imAccount", "session.realtime.imToken"
    ]
    private static let methodNames = ["host.getContext", "host.setNavigation", "host.close", "payment.purchaseProduct", "payment.syncTransactions"]

    private struct GlazeConfiguration {
        let handler: String
        let receiver: String
        let methods: [String: String]
        let contextFields: [String: String]
    }
    private struct GlazeRequest {
        let method: String
        let deadline: Double?
        var work: Task<Void, Never>?
        var timeout: Task<Void, Never>?
    }
    private struct GlazeCommand {
        let completion: (Result<[String: Any]?, Error>) -> Void
        let timeout: Task<Void, Never>
    }
    private enum GlazeFailure: Error { case code(String) }

    private var glazeEntry: chosenTiles
    private var glazeIsStandby = false
    private var glazeUsesIdleEntry = false
    private var glazeIdleReady = false
    private var glazeOpenEntrySent = false
    private var glazeEntryActivationTask: Task<Void, Never>?
    private var glazeLoadingTimeoutTask: Task<Void, Never>?
    private var glazeBlankPageTimeoutTask: Task<Void, Never>?
    private var glazeLoadStartedAt = ProcessInfo.processInfo.systemUptime
    private var glazeFirstPaint = false
    private var glazeContentVisible = false
    private var glazePendingError: String?
    private var glazeErrorPresentationTask: Task<Void, Never>?
    private var glazeContextDeliveryStarted = false
    private var glazeContextOwner = ""
    private var glazeContextTaskID = UUID()
    private var glazeContextPrepared = false
    var onGlazeClosed: (() -> Void)?
    private var glazeCloseCompletionDelivered = false
    private var tastingWebView: WKWebView?
    private var tastingBundleURL: URL?
    private var glazeConfiguration: GlazeConfiguration?
    private var pastryArchiveTask: Task<Void, Never>?
    private var glazeContextTask: Task<[String: Any], Error>?
    private var glazeContextRefreshTask: Task<Void, Never>?
    private var glazeErrorView: UIView?
    private var glazeBackgroundView: UIImageView?
    private var glazeRetainedFrame: UIView?
    private var glazeRequests: [String: GlazeRequest] = [:]
    private var glazeResponses: [String: [String: Any]] = [:]
    private var glazeRequestFingerprints: [String: String] = [:]
    private var glazeCloseResponseTargets: [String: Int] = [:]
    private var glazeCommands: [String: GlazeCommand] = [:]
    private var glazeNativeCloseTask: Task<Void, Never>?
    private var glazeNavigationTarget = 0
    private var glazeExiting = false
    private var glazeExitRequested = false
    private var glazeSDKClosing = false
    private var glazeExitTarget = 0
    private var glazeVisible = false
    private var glazePresentationReady = false
    private var glazeNativeOverlayDepth = 0
    private var glazeIdentityFingerprint = ""
    private var glazeContextPreparationDepth = 0
    private var glazeContextNeedsRefresh = false
    private var glazePreviousPopEnabled: Bool?
    private var glazeWebViewGeneration = UUID()
    private var glazeDocumentLoaded = false
    private var glazeContextDelivered = false
    private var glazeProcessCrashDates: [Date] = []
    private lazy var glazeExitSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGlazeExitSwipe(_:)))

    init(entry: chosenTiles) {
        self.glazeEntry = entry
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        isModalInPresentation = true
        hidesBottomBarWhenPushed = true
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Self.berryBackdrop
        glazeExitSwipe.edges = .left
        glazeExitSwipe.isEnabled = false
        view.addGestureRecognizer(glazeExitSwipe)
        presentationController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(glazeApplicationVisibilityChanged), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(glazeApplicationVisibilityChanged), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(glazeAccountChanged), name: .bakeryTrailMap, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(glazeMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        warmTastingParlor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if glazePreviousPopEnabled == nil { glazePreviousPopEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(glazeNativeBack))
        }
        glazeVisible = true
        publishGlazeVisibility()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        glazeVisible = false
        glazePresentationReady = false
        glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        publishGlazeVisibility()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        glazeVisible = true
        glazePresentationReady = true
        publishGlazeVisibility()
        // A standby WebView has just moved out of the native window. Activate
        // only after UIKit has attached it to the presented controller again.
        activateGlazeIdleEntry()
        monitorGlazeBlankPage()
        presentPendingGlazeError()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activateGlazeIdleEntry()
    }
    // A preloaded view moving between the window and a modal can receive an
    // intermediate disappearance with isBeingDismissed still true. Only the
    // SDK exit handshake + transition completion owns active-host teardown.
    deinit {
        NotificationCenter.default.removeObserver(self)
        pastryArchiveTask?.cancel()
        glazeContextTask?.cancel()
        glazeContextRefreshTask?.cancel()
        glazeNativeCloseTask?.cancel()
        glazeEntryActivationTask?.cancel()
        glazeLoadingTimeoutTask?.cancel()
        glazeBlankPageTimeoutTask?.cancel()
        glazeErrorPresentationTask?.cancel()
        for request in glazeRequests.values { request.work?.cancel(); request.timeout?.cancel() }
        for command in glazeCommands.values { command.timeout.cancel(); command.completion(.failure(GlazeFailure.code("NATIVE_FAILED"))) }
    }

    /// Only the documented idle route is warmed. It never requests a user context.
    static func prewarmGlazeWebView() {
        guard glazeActiveHost == nil, glazeStandbyHost == nil, glazeWebPrewarmTask == nil,
              UIApplication.shared.applicationState == .active else { return }
        glazeWebPrewarmTask = Task { @MainActor in
            await Task.yield()
            defer { glazeWebPrewarmTask = nil }
            guard !Task.isCancelled, glazeActiveHost == nil, glazeStandbyHost == nil,
                  UIApplication.shared.applicationState == .active,
                  let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
                    .flatMap(\.windows).first(where: { $0.isKeyWindow }),
                  window.rootViewController?.viewIfLoaded?.window != nil else { return }
            let host = UKGlazeActortroller(entry: .firstStatCenter)
            host.glazeIsStandby = true
            host.glazeUsesIdleEntry = true
            glazeStandbyHost = host
            host.loadViewIfNeeded()
            // Keep WebKit attached for rendering, behind the native root view.
            host.view.isUserInteractionEnabled = false
            host.view.accessibilityElementsHidden = true
            host.view.translatesAutoresizingMaskIntoConstraints = false
            window.insertSubview(host.view, at: 0)
            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: window.topAnchor), host.view.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                host.view.leadingAnchor.constraint(equalTo: window.leadingAnchor), host.view.trailingAnchor.constraint(equalTo: window.trailingAnchor)
            ])
        }
    }

    static func entryController(for entry: chosenTiles) -> UKGlazeActortroller? {
        guard glazeActiveHost == nil else { return nil }
        glazeWebPrewarmTask?.cancel()
        if let host = glazeStandbyHost, host.glazeIdleReady, host.tastingWebView != nil {
            glazeStandbyHost = nil
            host.view.removeFromSuperview()
            host.view.translatesAutoresizingMaskIntoConstraints = true
            host.view.isUserInteractionEnabled = true
            host.view.accessibilityElementsHidden = false
            host.glazeIsStandby = false
            host.glazePresentationReady = false
            host.glazeEntry = entry
            glazeActiveHost = host
            host.glazeLoadStartedAt = ProcessInfo.processInfo.systemUptime
            host.traceGlazeLoad("entry-preloaded")
            host.armGlazeLoadingTimeout(standby: false)
            host.startGlazeContextTask()
            return host
        }
        discardGlazeStandby()
        let host = UKGlazeActortroller(entry: entry)
        glazeActiveHost = host
        return host
    }

    private static func discardGlazeStandby() {
        let host = glazeStandbyHost
        glazeStandbyHost = nil
        host?.glazeIsStandby = false
        host?.tearDownGlaze()
        host?.viewIfLoaded?.removeFromSuperview()
    }

    @objc private func glazeMemoryWarning() {
        if glazeIsStandby { Self.discardGlazeStandby() }
    }

    static func prewarmGlazeResources() {
        Task(priority: .utility) { _ = await prepareGlazeResources(priority: .utility) }
    }

    private static func prepareGlazeResources(priority: TaskPriority = .userInitiated) async -> URL? {
        if let running = glazeResourcePreparation { return await running.task.value?.folder }
        let id = UUID()
        let prepared = glazePreparedResources
        // The shared task outlives individual containers and never prepares a user session.
        let work = Task.detached(priority: priority) { () -> GlazePreparedArchive? in
            if let prepared, Self.glazeArchiveStamp(at: prepared.folder, files: prepared.bootstrapPaths) == prepared.stamp { return prepared }
            guard let folder = Self.restorePastryArchive(), let paths = Self.glazeBootstrapPaths(),
                  let stamp = Self.glazeArchiveStamp(at: folder, files: paths) else { return nil }
            return GlazePreparedArchive(folder: folder, bootstrapPaths: paths, stamp: stamp)
        }
        glazeResourcePreparation = (id, work)
        let archive = await work.value
        if glazeResourcePreparation?.id == id {
            glazePreparedResources = archive
            glazeResourcePreparation = nil
        }
        return archive?.folder
    }

    /// Read the executable dependency list once, after full bundle validation.
    nonisolated private static func glazeBootstrapPaths() -> [String]? {
        guard let manifestURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".manifest", withExtension: "json"),
              let data = try? Data(contentsOf: manifestURL),
              let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let records = manifest["files"] as? [[String: Any]] else { return nil }
        let extensions: Set<String> = ["html", "js", "mjs", "cjs", "css", "wasm"]
        let paths = records.compactMap { $0["path"] as? String }.filter {
            extensions.contains(($0 as NSString).pathExtension.lowercased())
        }
        guard Set(["index.html", "config/app-config.js", "config/opi-profile.js"]).isSubset(of: Set(paths)),
              paths.allSatisfy(Self.safeGlazePath) else { return nil }
        return paths
    }

    /// The immutable bundle was fully verified once in this process. Entry only
    /// stats executable dependencies and their directories; it reads no assets.
    nonisolated private static func glazeArchiveStamp(at folder: URL, files: [String]) -> [String: GlazeArchiveStamp]? {
        let manager = FileManager.default
        let namespace = folder.deletingLastPathComponent()
        let cacheBase = namespace.deletingLastPathComponent()
        var result: [String: GlazeArchiveStamp] = [:]
        var directories: Set<URL> = [cacheBase, namespace, folder]
        for path in files {
            let parts = path.split(separator: "/")
            for count in 1..<parts.count {
                directories.insert(folder.appendingPathComponent(parts.prefix(count).joined(separator: "/"), isDirectory: true))
            }
        }
        for directory in directories {
            guard let attributes = try? manager.attributesOfItem(atPath: directory.path),
                  attributes[.type] as? FileAttributeType == .typeDirectory,
                  let inode = attributes[.systemFileNumber] as? NSNumber else { return nil }
            result[directory.path] = GlazeArchiveStamp(inode: inode.uint64Value, size: 0, modifiedAt: .distantPast)
        }
        for path in files {
            let file = folder.appendingPathComponent(path)
            guard let attributes = try? manager.attributesOfItem(atPath: file.path),
                  attributes[.type] as? FileAttributeType == .typeRegular,
                  let inode = attributes[.systemFileNumber] as? NSNumber,
                  let size = attributes[.size] as? NSNumber, size.uint64Value > 0,
                  let modifiedAt = attributes[.modificationDate] as? Date else { return nil }
            result[file.path] = GlazeArchiveStamp(inode: inode.uint64Value, size: size.uint64Value, modifiedAt: modifiedAt)
        }
        return result
    }

    private func warmTastingParlor() {
        if let active = Self.glazeActiveHost, active !== self {
            showGlazeError("Please close the current page before opening another page.")
            return
        }
        if !glazeIsStandby {
            Self.glazeWebPrewarmTask?.cancel()
            Self.discardGlazeStandby()
        }
        tearDownGlaze()
        glazeErrorView?.removeFromSuperview()
        glazeErrorView = nil
        glazeExiting = false
        glazeExitRequested = false
        glazeExitTarget = 0
        glazeIdleReady = false
        glazeOpenEntrySent = false
        glazeUsesIdleEntry = glazeIsStandby
        glazeLoadStartedAt = ProcessInfo.processInfo.systemUptime
        let generation = glazeWebViewGeneration
        if glazeIsStandby {
            armGlazeLoadingTimeout(standby: true)
        } else {
            Self.glazeActiveHost = self
            traceGlazeLoad("entry-direct")
            armGlazeLoadingTimeout(standby: false)
            startGlazeContextTask()
        }
        pastryArchiveTask = Task { [weak self] in
            let folder = await Self.prepareGlazeResources(priority: self?.glazeIsStandby == true ? .utility : .userInitiated)
            guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else {
                return
            }
            self.pastryArchiveTask = nil
            guard let folder else {
                self.showGlazeError("This page is unavailable in this build. Please try again.")
                return
            }
            self.traceGlazeLoad("resources-ready")
            // Parse/mount H5 while Open is in flight. Context is awaited only by Bridge.
            self.stageTastingParlor(pastryFolder: folder)
        }
    }

    private func currentGlazeContextOwner() -> String {
        let store = WevVGlazeSessionStore.shared
        let account = store.currentGlazeCredentials.map { String($0.vanillaBeanIcing) } ?? "guest"
        return "\(store.activeEnvironmentID ?? ""):\(store.sessionEpoch):\(account)"
    }

    private func traceGlazeLoad(_ stage: String) {
        #if DEBUG
        NSLog("[WevV H5] stage=%@ elapsedMs=%.1f", stage, (ProcessInfo.processInfo.systemUptime - glazeLoadStartedAt) * 1000)
        #endif
    }

    private func armGlazeLoadingTimeout(standby: Bool) {
        glazeLoadingTimeoutTask?.cancel()
        let generation = glazeWebViewGeneration
        glazeLoadingTimeoutTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(standby ? 60 : 75) * 1_000_000_000)
            guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else { return }
            if self.glazeIsStandby { Self.discardGlazeStandby() }
            else { self.showGlazeError("This page is taking too long to load. Please try again.") }
        }
    }

    private func cancelGlazeEntryPreparation() {
        // SDK close aborts startup, so its pending openEntry may legitimately
        // fail. Stop observing entry errors while preserving release and ACKs.
        glazeEntryActivationTask?.cancel()
        glazeLoadingTimeoutTask?.cancel(); glazeLoadingTimeoutTask = nil
        glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        glazeErrorPresentationTask?.cancel(); glazeErrorPresentationTask = nil
        glazePendingError = nil
    }

    private func resumeGlazeEntryMonitoring() {
        guard !glazeIsStandby, !glazeExiting, !glazeSDKClosing, !glazeExitRequested else { return }
        if !glazeFirstPaint { armGlazeLoadingTimeout(standby: false) }
        monitorGlazeBlankPage()
    }

    /// A painted wrapper is not a painted page. Keep watching after first paint
    /// as SDK route changes can remove the last visible content later as well.
    private func monitorGlazeBlankPage() {
        guard glazeBlankPageTimeoutTask == nil, !glazeIsStandby, !glazeExiting,
              !glazeSDKClosing, !glazeExitRequested,
              !glazeContentVisible, glazeVisible, viewIfLoaded?.window != nil,
              UIApplication.shared.applicationState == .active,
              glazeRetainedFrame == nil, glazeNativeCloseTask == nil,
              glazeErrorView == nil, glazePendingError == nil else { return }
        let generation = glazeWebViewGeneration
        glazeBlankPageTimeoutTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 15 * 1_000_000_000)
            guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else { return }
            self.glazeBlankPageTimeoutTask = nil
            guard !self.glazeContentVisible, !self.glazeExiting, self.glazeVisible,
                  !self.glazeSDKClosing, !self.glazeExitRequested,
                  self.viewIfLoaded?.window != nil, UIApplication.shared.applicationState == .active,
                  self.glazeRetainedFrame == nil, self.glazeNativeCloseTask == nil else { return }
            self.traceGlazeLoad("blank-page-timeout")
            self.showGlazeError("This page could not be displayed. Please try again.")
        }
    }

    private func presentPendingGlazeError() {
        guard let notice = glazePendingError, !glazeExiting, !glazeSDKClosing, !glazeExitRequested,
              glazeVisible, glazePresentationReady,
              viewIfLoaded?.window != nil, UIApplication.shared.applicationState == .active,
              presentedViewController == nil else { return }
        glazePendingError = nil
        showGlazeError(notice)
    }

    private func queueGlazeError(_ notice: String) {
        guard !glazeExiting, !glazeSDKClosing, !glazeExitRequested else { return }
        glazePendingError = notice
        guard glazeErrorPresentationTask == nil else { return }
        let generation = glazeWebViewGeneration
        glazeErrorPresentationTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 250_000_000)
                guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation,
                      !self.glazeExiting, self.glazePendingError != nil else { return }
                self.presentPendingGlazeError()
            }
        }
    }

    @objc private func cancelGlazeLoading() {
        // Until context/activation has crossed the bridge H5 cannot own an account or room.
        if !glazeContextDeliveryStarted, !glazeOpenEntrySent { performGlazeExit(target: 0) }
        else { requestNativeGlazeClose() }
    }

    private func glazeFirstPaintScript() -> String {
        let generation = glazeWebViewGeneration.uuidString
        return """
        (() => {
          let lastVisible, queued = false;
          function visible(element) {
            const rect = element.getBoundingClientRect();
            if (rect.width <= 0 || rect.height <= 0 || rect.bottom <= 0 || rect.right <= 0 || rect.top >= innerHeight || rect.left >= innerWidth) return false;
            for (let node = element; node; node = node.parentElement) {
              const style = getComputedStyle(node);
              if (style.display === 'none' || style.visibility === 'hidden' || style.visibility === 'collapse' || Number(style.opacity) === 0) return false;
            }
            return true;
          }
          function hasContent(root) {
            if (!root || !root.isConnected) return false;
            const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
            for (let text; (text = walker.nextNode());) {
              if (!text.textContent.trim() || !visible(text.parentElement)) continue;
              const range = document.createRange(); range.selectNodeContents(text);
              if (Array.from(range.getClientRects()).some(r => r.width > 0 && r.height > 0 && r.bottom > 0 && r.top < innerHeight)) return true;
            }
            return Array.from(root.querySelectorAll('input,textarea,select,svg,video,img,[role="progressbar"],.skeleton-block,.skeleton-text')).some(element => {
              if (!visible(element)) return false;
              if (element.tagName === 'IMG') return element.complete && element.naturalWidth > 0;
              if (element.tagName === 'VIDEO') return element.readyState >= 2 && element.videoWidth > 0;
              if (element.tagName.toLowerCase() === 'svg') return !!element.querySelector('path,rect,circle,line,polyline,polygon,use,text');
              return true;
            });
          }
          function check() {
            if (queued || document.hidden) return;
            queued = true;
            requestAnimationFrame(() => requestAnimationFrame(() => {
              queued = false;
              const painted = !location.hash.startsWith('#/sdk/idle') &&
                [document.getElementById('app'), ...document.querySelectorAll('.boot-error,.global-loading[role="status"],.room-shell-host')].some(hasContent);
              if (painted === lastVisible) return;
              lastVisible = painted;
              window.webkit.messageHandlers.\(Self.glazePaintHandler).postMessage({generation: '\(generation)', visible: painted});
            }));
          }
          new MutationObserver(check).observe(document, {childList: true, characterData: true, subtree: true, attributes: true, attributeFilter: ['class', 'style', 'hidden', 'src']});
          for (const event of ['hashchange', 'resize', 'visibilitychange', 'transitionend', 'animationend', 'load']) window.addEventListener(event, check, true);
          document.addEventListener('DOMContentLoaded', check, {once: true});
          // replaceState and stylesheet changes need not emit a DOM mutation.
          setInterval(check, 1000);
        })();
        """
    }

    private func receiveGlazeFirstPaint(_ message: WKScriptMessage) {
        guard message.webView === tastingWebView, message.frameInfo.isMainFrame, !glazeIsStandby,
              let url = message.frameInfo.request.url, isWithinGlazeBundle(url),
              let body = message.body as? [String: Any], body["generation"] as? String == glazeWebViewGeneration.uuidString,
              let visible = Self.jsonBoolean(body["visible"]) else { return }
        glazeContentVisible = visible
        if visible {
            if !glazeFirstPaint { glazeFirstPaint = true; traceGlazeLoad("h5-first-paint") }
            glazeLoadingTimeoutTask?.cancel(); glazeLoadingTimeoutTask = nil
            glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        } else { monitorGlazeBlankPage() }
    }

    private func startGlazeContextTask() {
        glazeContextTask?.cancel()
        let generation = glazeWebViewGeneration
        let owner = currentGlazeContextOwner()
        let taskID = UUID()
        glazeContextTaskID = taskID
        glazeContextOwner = owner
        glazeContextPrepared = false
        glazeContextTask = Task { @MainActor [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation,
                  self.glazeContextTaskID == taskID else { throw CancellationError() }
            self.beginGlazeContextPreparation()
            defer { if self.glazeWebViewGeneration == generation { self.finishGlazeContextPreparation() } }
            do {
                let context = try await WevVGlazeSessionRepository.pastryTrailDiary.prepareH5Context()
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation,
                      self.glazeContextTaskID == taskID, self.currentGlazeContextOwner() == owner else { throw CancellationError() }
                guard let current = WevVGlazeSessionStore.shared.currentGlazeCredentials,
                      let session = context["session"] as? [String: Any],
                      session["accountId"] as? String == String(current.vanillaBeanIcing),
                      session["accessToken"] as? String == current.brownButterGlaze else { throw GlazeFailure.code("NATIVE_FAILED") }
                guard !self.glazeEntry.hideRemoteSheenPlaceholder || Self.jsonBoolean(context["fullFeaturesEnabled"]) == true else {
                    throw GlazeFailure.code("FEATURE_UNAVAILABLE")
                }
                self.glazeIdentityFingerprint = self.currentGlazeIdentityFingerprint()
                self.glazeContextPrepared = true
                self.traceGlazeLoad("context-ready")
                return context
            } catch {
                if self.glazeWebViewGeneration == generation, self.glazeContextTaskID == taskID {
                    self.glazeContextTask = nil
                    self.glazeContextPrepared = false
                }
                throw error
            }
        }
    }

    private func activateGlazeIdleEntry() {
        guard !glazeIsStandby, glazeUsesIdleEntry, glazeIdleReady, !glazeOpenEntrySent,
              !glazeExiting, !glazeSDKClosing, !glazeExitRequested, glazeVisible, viewIfLoaded?.window != nil,
              view.bounds.width > 0, view.bounds.height > 0,
              glazeEntryActivationTask == nil, let entry = glazeEntry.bakeGlazeVaultPack else { return }
        let generation = glazeWebViewGeneration
        glazeEntryActivationTask = Task { @MainActor [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            defer { if self.glazeWebViewGeneration == generation { self.glazeEntryActivationTask = nil } }
            do {
                guard let folder = await Self.prepareGlazeResources(), folder == self.tastingBundleURL,
                      !Task.isCancelled, self.glazeWebViewGeneration == generation else { throw CancellationError() }
                guard !self.glazeExiting, !self.glazeSDKClosing, !self.glazeExitRequested,
                      self.glazeVisible, self.viewIfLoaded?.window != nil else { return }
                self.glazeOpenEntrySent = true
                self.traceGlazeLoad("open-entry-sent")
                let result = try await self.sendGlazeCommand("openEntry", params: ["entry": entry], timeout: 65)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation,
                      !self.glazeExiting, !self.glazeSDKClosing, !self.glazeExitRequested else { return }
                guard Self.jsonBoolean(result?["opened"]) == true else { throw GlazeFailure.code("NATIVE_FAILED") }
                self.traceGlazeLoad("entry-opened")
                self.publishGlazeVisibility()
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation,
                      !self.glazeExiting, !self.glazeSDKClosing, !self.glazeExitRequested else { return }
                self.showGlazeError("This page could not be prepared. Please try again.")
            }
        }
    }

    private func stageTastingParlor(pastryFolder: URL) {
        tastingBundleURL = pastryFolder
        if let active = Self.glazeActiveHost, active !== self, active.tastingWebView != nil {
            showGlazeError("Please close the current page before opening another page.")
            return
        }
        guard let configuration = readTastingConfig(pastryFolder: pastryFolder),
              let entry = glazeUsesIdleEntry ? URL(string: pastryFolder.appendingPathComponent("index.html").absoluteString + "#/sdk/idle")
                : makeTastingURL(indexURL: pastryFolder.appendingPathComponent("index.html")) else {
            showGlazeError("This page could not be prepared. Please try again.")
            return
        }
        glazeConfiguration = configuration
        let controller = WKUserContentController()
        let receiveMessage: (WKScriptMessage) -> Void = { [weak self] message in
            if message.name == Self.glazePaintHandler { self?.receiveGlazeFirstPaint(message) }
            else { self?.receiveGlaze(message) }
        }
        controller.add(WevVGlazeConversationCell(closeDailyDonut: receiveMessage), name: configuration.handler)
        controller.add(WevVGlazeConversationCell(closeDailyDonut: receiveMessage), name: Self.glazePaintHandler)
        controller.addUserScript(WKUserScript(source: glazeFirstPaintScript(), injectionTime: .atDocumentStart, forMainFrameOnly: true))
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = controller
        webConfiguration.websiteDataStore = .nonPersistent()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        let backgroundPath = pastryFolder.appendingPathComponent("assets/common/background.png")
        if let image = UIImage(contentsOfFile: backgroundPath.path) {
            let backdrop = UIImageView(image: image)
            backdrop.translatesAutoresizingMaskIntoConstraints = false
            backdrop.contentMode = .scaleAspectFit
            view.addSubview(backdrop)
            NSLayoutConstraint.activate([
                backdrop.topAnchor.constraint(equalTo: view.topAnchor),
                backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backdrop.heightAnchor.constraint(equalTo: backdrop.widthAnchor, multiplier: image.size.height / max(image.size.width, 1))
            ])
            glazeBackgroundView = backdrop
        }
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        if #available(iOS 15.0, *) { webView.underPageBackgroundColor = .clear }
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tastingWebView = webView
        if !glazeIsStandby { Self.glazeActiveHost = self }
        traceGlazeLoad("webview-load")
        webView.loadFileURL(entry, allowingReadAccessTo: pastryFolder)
    }

    private func makeTastingURL(indexURL: URL) -> URL? {
        glazeEntry.firstDivider(doughKitchenBakery: indexURL)
    }

    private func readTastingConfig(pastryFolder: URL) -> GlazeConfiguration? {
        guard let app = Self.readMarkedJSON(at: pastryFolder.appendingPathComponent("config/app-config.js"), marker: "APP_CONFIG"),
              (app["schemaVersion"] as? NSNumber)?.intValue == 18,
              let build = app["build"] as? [String: Any],
              let appSettings = app["app"] as? [String: Any], appSettings["appVersion"] as? String == filledShellSelection.tastingJourneyAtlas,
              let profile = Self.readMarkedJSON(at: pastryFolder.appendingPathComponent("config/opi-profile.js"), marker: "OPI_PROFILE"),
              let services = profile["services"] as? [String: Any], let client = services["apiClient"] as? [String: Any],
              let appID = client["appId"] as? String, !appID.isEmpty,
              (WevVGlazeSessionRepository.pastryTrailDiary.glazeAppID.isEmpty || appID == WevVGlazeSessionRepository.pastryTrailDiary.glazeAppID),
              client["appVersion"] as? String == filledShellSelection.tastingJourneyAtlas,
              let bridge = app["bridge"] as? [String: Any], let handler = bridge["handler"] as? String, Self.validContextName(handler), handler != Self.glazePaintHandler,
              let receiver = bridge["receiver"] as? String, Self.validContextName(receiver),
              let methods = bridge["methods"] as? [String: String], Set(methods.keys) == Set(Self.methodNames),
              Set(methods.values).count == methods.count, methods.values.allSatisfy({ !$0.isEmpty && $0.count <= 128 }),
              let fields = bridge["contextFields"] as? [String: String], Set(fields.keys) == Set(Self.contextPaths),
              fields.values.allSatisfy(Self.validContextName) else { return nil }
        if let floor = build["minimumHostVersion"] as? String, !supportsBakeVersion(bakeFloor: floor) { return nil }
        var siblings: [String: Set<String>] = [:]
        for (path, actual) in fields {
            let parent = path.split(separator: ".").dropLast().joined(separator: ".")
            guard siblings[parent, default: []].insert(actual).inserted else { return nil }
        }
        return GlazeConfiguration(handler: handler, receiver: receiver, methods: methods, contextFields: fields)
    }

    nonisolated private static func validContextName(_ name: String) -> Bool {
        guard !["__proto__", "prototype", "constructor"].contains(name), (1...64).contains(name.utf8.count),
              let first = name.utf8.first, (65...90).contains(first) || (97...122).contains(first) || first == 95 else { return false }
        return name.utf8.allSatisfy { (65...90).contains($0) || (97...122).contains($0) || (48...57).contains($0) || $0 == 95 || $0 == 45 }
    }
    private func supportsBakeVersion(bakeFloor: String) -> Bool {
        let current = filledShellSelection.tastingJourneyAtlas.split(separator: ".").compactMap { Int($0) }
        let required = bakeFloor.split(separator: ".").compactMap { Int($0) }
        guard !current.isEmpty, !required.isEmpty, required.count == bakeFloor.split(separator: ".").count else { return false }
        for i in 0..<max(current.count, required.count) {
            let a = i < current.count ? current[i] : 0, b = i < required.count ? required[i] : 0
            if a != b { return a > b }
        }
        return true
    }

    private func receiveGlaze(_ message: WKScriptMessage) {
        guard message.webView === tastingWebView, message.frameInfo.isMainFrame,
              message.name == glazeConfiguration?.handler,
              let url = message.frameInfo.request.url, isWithinGlazeBundle(url),
              let envelope = message.body as? [String: Any], let kind = envelope["kind"] as? String,
              let id = envelope["id"] as? String, !id.isEmpty, id.utf8.count <= 128 else { return }
        if kind == "response" {
            guard let pending = glazeCommands.removeValue(forKey: id) else { return }
            pending.timeout.cancel()
            if Self.jsonBoolean(envelope["ok"]) == true {
                if envelope["result"] is NSNull { pending.completion(.success(nil)) }
                else if let result = envelope["result"] as? [String: Any] { pending.completion(.success(result)) }
                else { pending.completion(.failure(GlazeFailure.code("INVALID_PAYLOAD"))) }
            } else { pending.completion(.failure(GlazeFailure.code("NATIVE_FAILED"))) }
            return
        }
        guard kind == "request" else { return }
        let fingerprint = (try? JSONSerialization.data(withJSONObject: envelope, options: [.sortedKeys])).map(Self.glazeSHA256) ?? ""
        if let previous = glazeRequestFingerprints[id] {
            guard previous == fingerprint else { return }
            if let response = glazeResponses[id] {
                let generation = glazeWebViewGeneration
                Task { [weak self] in
                    guard let self, self.glazeWebViewGeneration == generation else { return }
                    do {
                        try await self.sendGlaze(response)
                        if self.glazeWebViewGeneration == generation, Self.jsonBoolean(response["ok"]) == true, let target = self.glazeCloseResponseTargets[id] {
                            self.performGlazeExit(target: target)
                        }
                    } catch { }
                }
            }
            return
        }
        glazeRequestFingerprints[id] = fingerprint
        guard let wireMethod = envelope["method"] as? String,
              let method = glazeConfiguration?.methods.first(where: { $0.value == wireMethod })?.key else {
            respondInvalidGlaze(id: id, code: "UNSUPPORTED_METHOD"); return
        }
        guard let params = envelope["params"] as? [String: Any] else { respondInvalidGlaze(id: id, code: "INVALID_PARAMS"); return }
        guard !glazeIsStandby || (method == "host.setNavigation" && Self.jsonInteger(params["target"]) == 0) else {
            respondInvalidGlaze(id: id, code: "UNSUPPORTED_METHOD"); return
        }
        let purchase = method == "payment.purchaseProduct"
        let deadline: Double?
        if purchase {
            guard envelope["deadlineMs"] == nil else { respondInvalidGlaze(id: id, code: "INVALID_PAYLOAD"); return }
            deadline = nil
        } else {
            guard let number = envelope["deadlineMs"] as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID(), number.doubleValue.isFinite else {
                respondInvalidGlaze(id: id, code: "INVALID_PAYLOAD"); return
            }
            let maxWait: Double = method == "host.getContext" ? 60_000 : (method == "host.setNavigation" ? 5_000 : 15_000)
            deadline = min(number.doubleValue, Date().timeIntervalSince1970 * 1000 + maxWait)
            guard deadline! > Date().timeIntervalSince1970 * 1000 else { respondInvalidGlaze(id: id, code: "TIMEOUT"); return }
        }
        glazeRequests[id] = GlazeRequest(method: method, deadline: deadline)
        let generation = glazeWebViewGeneration
        glazeRequests[id]?.work = Task { [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            if let deadline, deadline <= Date().timeIntervalSince1970 * 1000 {
                _ = await self.completeGlaze(id: id, error: "TIMEOUT")
                return
            }
            do {
                let result = try await self.executeGlaze(method: method, params: params)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                if method == "host.close", let target = Self.jsonInteger(params["target"]) { self.glazeCloseResponseTargets[id] = target }
                let sent = await self.completeGlaze(id: id, result: result)
                if sent, self.glazeWebViewGeneration == generation, method == "host.setNavigation",
                   params["reason"] as? String == "preload-ready", self.glazeIsStandby {
                    self.glazeIdleReady = true
                    self.glazeLoadingTimeoutTask?.cancel(); self.glazeLoadingTimeoutTask = nil
                    self.traceGlazeLoad("idle-ready")
                }
                if sent, self.glazeWebViewGeneration == generation, method == "host.close", let target = Self.jsonInteger(params["target"]) { self.performGlazeExit(target: target) }
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                #if DEBUG
                if method == "host.getContext" { conversationAvatar.cocoaGuarded(loadRemoteCard: .buildVaultsuppleDoughDough, closeWevvSugarPrompt: error) }
                #endif
                let code: String
                if case GlazeFailure.code(let value) = error { code = value }
                else if method.hasPrefix("payment.") { code = DrawcreamScoutSugarStyle.apricotCompote(error) }
                else { code = "NATIVE_FAILED" }
                _ = await self.completeGlaze(id: id, error: code)
            }
        }
        if let deadline {
            glazeRequests[id]?.timeout = Task { [weak self] in
                let wait = max(0, deadline - Date().timeIntervalSince1970 * 1000)
                try? await Task.sleep(nanoseconds: UInt64(wait * 1_000_000))
                guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else { return }
                _ = await self.completeGlaze(id: id, error: "TIMEOUT", fromTimeout: true)
            }
        }
    }

    private func executeGlaze(method: String, params: [String: Any]) async throws -> Any {
        switch method {
        case "host.getContext":
            guard params.isEmpty, !glazeIsStandby else { throw GlazeFailure.code("INVALID_PARAMS") }
            let generation = glazeWebViewGeneration
            beginGlazeContextPreparation()
            defer { if glazeWebViewGeneration == generation { finishGlazeContextPreparation() } }
            let epoch = WevVGlazeSessionStore.shared.sessionEpoch
            let environment = WevVGlazeSessionStore.shared.activeEnvironmentID
            let owner = currentGlazeContextOwner()
            if glazeContextTask == nil || glazeContextOwner != owner ||
                (glazeContextPrepared && (glazeIdentityFingerprint != currentGlazeIdentityFingerprint() || WevVGlazeSessionStore.shared.needsGlazeRenewal)) {
                startGlazeContextTask()
            }
            guard let task = glazeContextTask else { throw GlazeFailure.code("NATIVE_FAILED") }
            let taskID = glazeContextTaskID
            let context = try await task.value
            guard !Task.isCancelled, glazeWebViewGeneration == generation, currentGlazeContextOwner() == owner,
                  WevVGlazeSessionStore.shared.sessionEpoch == epoch,
                  WevVGlazeSessionStore.shared.activeEnvironmentID == environment,
                  WevVGlazeSessionStore.shared.isTasterReady,
                  let current = WevVGlazeSessionStore.shared.currentGlazeCredentials,
                  let session = context["session"] as? [String: Any],
                  session["accountId"] as? String == String(current.vanillaBeanIcing),
                  session["accessToken"] as? String == current.brownButterGlaze,
                  !glazeEntry.hideRemoteSheenPlaceholder || Self.jsonBoolean(context["fullFeaturesEnabled"]) == true else {
                if glazeWebViewGeneration == generation, glazeContextTaskID == taskID {
                    glazeContextTask = nil; glazeContextPrepared = false
                }
                throw GlazeFailure.code("NATIVE_FAILED")
            }
            glazeIdentityFingerprint = currentGlazeIdentityFingerprint()
            return try mappedGlazeContext(context)
        case "host.setNavigation":
            guard let target = Self.jsonInteger(params["target"]), (0...2).contains(target), Set(params.keys).isSubset(of: ["target", "reason"]) else {
                applyGlazeNavigation(0); throw GlazeFailure.code("INVALID_PARAMS")
            }
            if let raw = params["reason"] {
                guard let reason = raw as? String, target == 0, ["preload-ready", "sdk-close", "sdk-close-failed"].contains(reason) else {
                    applyGlazeNavigation(0); throw GlazeFailure.code("INVALID_PARAMS")
                }
                if reason == "sdk-close" {
                    glazeSDKClosing = true
                    cancelGlazeEntryPreparation()
                } else if reason == "sdk-close-failed" {
                    glazeSDKClosing = false
                }
                if reason == "sdk-close", glazeRetainedFrame == nil, let frame = tastingWebView?.snapshotView(afterScreenUpdates: false) {
                    frame.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(frame)
                    NSLayoutConstraint.activate([
                        frame.topAnchor.constraint(equalTo: view.topAnchor), frame.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        frame.trailingAnchor.constraint(equalTo: view.trailingAnchor), frame.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
                    glazeRetainedFrame = frame
                } else if reason == "sdk-close-failed" {
                    glazeRetainedFrame?.removeFromSuperview(); glazeRetainedFrame = nil
                    resumeGlazeEntryMonitoring()
                }
            }
            applyGlazeNavigation(target)
            return NSNull()
        case "host.close":
            guard Set(params.keys) == ["target"], let target = Self.jsonInteger(params["target"]), (0...1).contains(target) else { throw GlazeFailure.code("INVALID_PARAMS") }
            return NSNull()
        case "payment.purchaseProduct", "payment.syncTransactions":
            guard WevVGlazeSessionStore.shared.isTasterReady,
                  let current = WevVGlazeSessionStore.shared.currentGlazeCredentials else { throw GlazeFailure.code("INVALID_PARAMS") }
            let repository = WevVGlazeSessionRepository.pastryTrailDiary
            let owner = String(current.vanillaBeanIcing)
            let epoch = WevVGlazeSessionStore.shared.sessionEpoch
            let environment = repository.glazeEnvironmentID
            let result: [String: Any]
            if method == "payment.purchaseProduct" {
                let generation = glazeWebViewGeneration
                beginGlazeNativeOverlay()
                defer { if glazeWebViewGeneration == generation { finishGlazeNativeOverlay() } }
                result = try await DrawcreamScoutSugarStyle.donutCheckinCalendar.crispEdgeDough(coffeeCreamShell: params, cocoaWeekendFestival: owner, applyDonutAvatarChoice: repository.glazeAppID, boundary: environment)
            } else {
                result = try await DrawcreamScoutSugarStyle.donutCheckinCalendar.donutSnapshots(coffeeCreamShell: params, cocoaWeekendFestival: owner, applyDonutAvatarChoice: repository.glazeAppID, boundary: environment)
            }
            guard !Task.isCancelled, WevVGlazeSessionStore.shared.sessionEpoch == epoch,
                  repository.glazeEnvironmentID == environment, WevVGlazeSessionStore.shared.isTasterReady,
                  WevVGlazeSessionStore.shared.currentGlazeCredentials?.vanillaBeanIcing == current.vanillaBeanIcing else {
                throw GlazeFailure.code("TRANSACTION_UNAVAILABLE")
            }
            return result
        default: throw GlazeFailure.code("UNSUPPORTED_METHOD")
        }
    }

    private func mappedGlazeContext(_ context: [String: Any]) throws -> [String: Any] {
        guard let mapping = glazeConfiguration?.contextFields, let session = context["session"] as? [String: Any],
              session["refreshToken"] == nil, session["accessTokenExpiresAt"] == nil, context["refreshToken"] == nil else {
            throw GlazeFailure.code("NATIVE_FAILED")
        }
        func rename(_ object: [String: Any], prefix: String) -> [String: Any] {
            var result: [String: Any] = [:]
            for (key, value) in object {
                let path = prefix.isEmpty ? key : prefix + "." + key
                let renamed = mapping[path] ?? key
                result[renamed] = (value as? [String: Any]).map { rename($0, prefix: path) } ?? value
            }
            return result
        }
        return rename(context, prefix: "")
    }

    @discardableResult
    private func completeGlaze(id: String, result: Any = NSNull(), error: String? = nil, fromTimeout: Bool = false) async -> Bool {
        guard let request = glazeRequests.removeValue(forKey: id) else { return false }
        if fromTimeout { request.work?.cancel() }
        else { request.timeout?.cancel() }
        var code = error
        if let deadline = request.deadline, deadline <= Date().timeIntervalSince1970 * 1000 { code = "TIMEOUT" }
        let response: [String: Any] = code.map { ["kind": "response", "id": id, "ok": false, "error": ["code": $0]] }
            ?? ["kind": "response", "id": id, "ok": true, "result": result]
        glazeResponses[id] = response
        let generation = glazeWebViewGeneration
        if request.method == "host.getContext", code == nil { glazeContextDeliveryStarted = true }
        do {
            try await sendGlaze(response)
            guard glazeWebViewGeneration == generation else { return false }
            if request.method == "host.getContext" {
                if code == nil { glazeContextDelivered = true; traceGlazeLoad("context-delivered") }
                #if DEBUG
                conversationAvatar.backendMutualFollow(crumbIndex: generation, localAuthorKey: code == nil)
                #endif
            }
            return code == nil
        } catch {
            #if DEBUG
            if request.method == "host.getContext" {
                conversationAvatar.backendMutualFollow(crumbIndex: generation, localAuthorKey: false)
                conversationAvatar.cocoaGuarded(loadRemoteCard: .backendCanChat, closeWevvSugarPrompt: error)
            }
            #endif
            return false
        }
    }
    private func respondInvalidGlaze(id: String, code: String) {
        let response: [String: Any] = ["kind": "response", "id": id, "ok": false, "error": ["code": code]]
        glazeResponses[id] = response
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation else { return }
            try? await self.sendGlaze(response)
        }
    }
    private func sendGlaze(_ message: [String: Any]) async throws {
        guard let webView = tastingWebView, let receiver = glazeConfiguration?.receiver else { throw GlazeFailure.code("NATIVE_FAILED") }
        _ = try await webView.callAsyncJavaScript("const fn = window[receiver]; if (typeof fn !== 'function') throw new Error('Bridge unavailable'); return fn(message);", arguments: ["receiver": receiver, "message": message], in: nil, contentWorld: .page)
    }
    private func sendGlazeCommand(_ command: String, params: [String: Any] = [:], timeout: Double = 15) async throws -> [String: Any]? {
        guard tastingWebView != nil else { throw GlazeFailure.code("NATIVE_FAILED") }
        let id = UUID().uuidString
        let generation = glazeWebViewGeneration
        return try await withCheckedThrowingContinuation { continuation in
            let timeoutTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                guard !Task.isCancelled, let pending = self?.glazeCommands.removeValue(forKey: id) else { return }
                pending.completion(.failure(GlazeFailure.code("TIMEOUT")))
            }
            glazeCommands[id] = GlazeCommand(completion: { continuation.resume(with: $0) }, timeout: timeoutTask)
            Task { [weak self] in
                guard let self, self.glazeWebViewGeneration == generation, self.glazeCommands[id] != nil else { return }
                do { try await self.sendGlaze(["kind": "command", "id": id, "command": command, "params": params]) }
                catch {
                    guard let pending = self.glazeCommands.removeValue(forKey: id) else { return }
                    pending.timeout.cancel(); pending.completion(.failure(error))
                }
            }
        }
    }
    private static func jsonBoolean(_ raw: Any?) -> Bool? {
        guard let value = raw as? NSNumber, CFGetTypeID(value) == CFBooleanGetTypeID() else { return nil }
        return value.boolValue
    }
    private static func jsonInteger(_ raw: Any?) -> Int? {
        guard let value = raw as? NSNumber, CFGetTypeID(value) != CFBooleanGetTypeID(), value.doubleValue.isFinite,
              value.doubleValue.rounded() == value.doubleValue, (0...2).contains(value.doubleValue) else { return nil }
        return value.intValue
    }
    private func applyGlazeNavigation(_ target: Int) {
        glazeNavigationTarget = target
        tastingWebView?.allowsBackForwardNavigationGestures = target == 1
        glazeExitSwipe.isEnabled = target == 2
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /// Existing callers retain the same room entry. Native back actions may route through this method.
    func requestGlazeBack() {
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation else { return }
            do {
                let response = try await self.sendGlazeCommand("back", timeout: 15)
                guard Self.jsonBoolean(response?["handled"]) == true else { throw GlazeFailure.code("NATIVE_FAILED") }
            } catch { if self.glazeWebViewGeneration == generation { self.showGlazeReleaseFailure() } }
        }
    }
    @objc private func glazeNativeBack() {
        if !glazeContentVisible { cancelGlazeLoading() }
        else { requestGlazeBack() }
    }
    @objc private func handleGlazeExitSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard glazeNavigationTarget == 2, gesture.state == .ended else { return }
        let committed = gesture.translation(in: view).x > view.bounds.width * 0.25 || gesture.velocity(in: view).x > 600
        if committed { requestNativeGlazeClose() }
    }
    @objc private func closeGlaze() { requestNativeGlazeClose() }
    private func requestNativeGlazeClose(target: Int = 0) {
        glazeExitTarget = max(glazeExitTarget, target)
        glazeExitRequested = true
        cancelGlazeEntryPreparation()
        guard !glazeExiting, glazeNativeCloseTask == nil else { return }
        guard tastingWebView != nil else { performGlazeExit(target: target); return }
        let generation = glazeWebViewGeneration
        glazeNativeCloseTask = Task { [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            defer { if self.glazeWebViewGeneration == generation { self.glazeNativeCloseTask = nil } }
            do {
                let response = try await self.sendGlazeCommand("close")
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                guard Self.jsonBoolean(response?["released"]) == true else { throw GlazeFailure.code("NATIVE_FAILED") }
                self.performGlazeExit(target: self.glazeExitTarget)
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                self.showGlazeReleaseFailure()
            }
        }
    }
    private func performGlazeExit(target: Int) {
        glazeExitTarget = max(glazeExitTarget, target)
        guard !glazeExiting else { return }
        glazeExiting = true
        applyGlazeNavigation(0)
        let presenter = presentingViewController ?? navigationController?.presentingViewController ?? navigationController?.viewControllers.dropLast().last
        let completed: () -> Void = { [self, weak presenter] in
            self.tearDownGlaze()
            if let enabled = self.glazePreviousPopEnabled { self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enabled }
            if self.glazeExitTarget == 1 { WevVGlazeSessionRepository.pastryTrailDiary.invalidateH5Authentication() }
            if !self.glazeCloseCompletionDelivered {
                self.glazeCloseCompletionDelivered = true
                let completion = self.onGlazeClosed
                self.onGlazeClosed = nil
                completion?()
            }
            Self.prewarmGlazeWebView()
            guard self.glazeExitTarget == 1 else { return }
            guard let presenter, presenter.presentedViewController == nil else { return }
            let gate = UBakerytropicalMangoEssence()
            gate.onWevvDonutReady = { [weak gate] in gate?.dismiss(animated: true) }
            presenter.present(gate, animated: true)
        }
        if let modalPresenter = presentingViewController ?? navigationController?.presentingViewController {
            // Dismiss the host and any alert it owns together. Calling dismiss
            // on self can dismiss only that alert and leave an empty host up.
            modalPresenter.dismiss(animated: true, completion: completed)
        } else if let navigationController, navigationController.topViewController === self {
            navigationController.popViewController(animated: true)
            if let transition = navigationController.transitionCoordinator { transition.animate(alongsideTransition: nil) { _ in completed() } }
            else { completed() }
        } else { completed() }
    }
    private func showGlazeReleaseFailure() {
        guard !glazeExiting, presentedViewController == nil else { return }
        glazeRetainedFrame?.removeFromSuperview(); glazeRetainedFrame = nil
        let alert = UIAlertController(title: "Unable to close page", message: "This page has not finished releasing its resources. Please try again.", preferredStyle: .alert)
        beginGlazeNativeOverlay()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.finishGlazeNativeOverlay()
            self?.glazeExitRequested = false
            self?.resumeGlazeEntryMonitoring()
        })
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in self?.finishGlazeNativeOverlay(); self?.requestNativeGlazeClose() })
        present(alert, animated: true)
    }

    @objc private func glazeApplicationVisibilityChanged() {
        if glazeIsStandby, UIApplication.shared.applicationState != .active { Self.discardGlazeStandby(); return }
        if UIApplication.shared.applicationState == .active {
            monitorGlazeBlankPage()
            presentPendingGlazeError()
        } else {
            glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        }
        publishGlazeVisibility()
    }
    private func publishGlazeVisibility() {
        guard tastingWebView != nil, glazeDocumentLoaded, !glazeIsStandby, !glazeExiting else { return }
        let visible = glazeVisible && UIApplication.shared.applicationState == .active && glazeNativeOverlayDepth == 0
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation else { return }
            _ = try? await self.sendGlazeCommand("visibilityChanged", params: ["visible": visible], timeout: 5)
        }
    }
    private func beginGlazeNativeOverlay() { glazeNativeOverlayDepth += 1; publishGlazeVisibility() }
    private func finishGlazeNativeOverlay() { glazeNativeOverlayDepth = max(0, glazeNativeOverlayDepth - 1); publishGlazeVisibility() }
    @objc private func glazeAccountChanged() {
        if glazeContextPreparationDepth > 0 { glazeContextNeedsRefresh = true; return }
        guard tastingWebView != nil, !glazeExiting, !glazeIdentityFingerprint.isEmpty,
              currentGlazeIdentityFingerprint() != glazeIdentityFingerprint else { return }
        if !WevVGlazeSessionStore.shared.isTasterReady { requestNativeGlazeClose(target: 1); return }
        guard glazeContextRefreshTask == nil else { return }
        let generation = glazeWebViewGeneration
        glazeContextRefreshTask = Task { [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            defer { if self.glazeWebViewGeneration == generation { self.glazeContextRefreshTask = nil } }
            do { try await self.refreshGlazeContext() }
            catch { if self.glazeWebViewGeneration == generation { self.showGlazeReleaseFailure() } }
        }
    }
    func refreshGlazeContext() async throws {
        let generation = glazeWebViewGeneration
        beginGlazeContextPreparation()
        defer { if glazeWebViewGeneration == generation { finishGlazeContextPreparation() } }
        startGlazeContextTask()
        guard let task = glazeContextTask else { throw GlazeFailure.code("NATIVE_FAILED") }
        let context = try await task.value
        guard !Task.isCancelled, glazeWebViewGeneration == generation, tastingWebView != nil, !glazeExiting else { return }
        _ = try mappedGlazeContext(context)
        glazeIdentityFingerprint = currentGlazeIdentityFingerprint()
        _ = try await sendGlazeCommand("contextChanged")
    }
    private func currentGlazeIdentityFingerprint() -> String {
        let scope = WevVGlazeSessionRepository.pastryTrailDiary.glazeEnvironmentID + ":" + String(WevVGlazeSessionStore.shared.sessionEpoch)
        guard let current = WevVGlazeSessionStore.shared.currentGlazeCredentials else { return scope + ":guest" }
        let fields = [scope, String(current.vanillaBeanIcing), current.brownButterGlaze, current.maplePecanCoating,
                      current.legacyToken, current.imAccount, current.imToken]
        return Self.glazeSHA256(Data(fields.joined(separator: "\u{0}").utf8))
    }
    private func beginGlazeContextPreparation() { glazeContextPreparationDepth += 1 }
    private func finishGlazeContextPreparation() {
        glazeContextPreparationDepth = max(0, glazeContextPreparationDepth - 1)
        guard glazeContextPreparationDepth == 0, glazeContextNeedsRefresh else { return }
        glazeContextNeedsRefresh = false
        DispatchQueue.main.async { [weak self] in self?.glazeAccountChanged() }
    }
    @objc private func retryGlaze() {
        glazeProcessCrashDates.removeAll()
        guard tastingWebView != nil, glazeDocumentLoaded || glazeContextDelivered || glazeContextDeliveryStarted || glazeOpenEntrySent else { warmTastingParlor(); return }
        guard glazeNativeCloseTask == nil, !glazeExiting else { return }
        glazeExitRequested = false
        let generation = glazeWebViewGeneration
        glazeNativeCloseTask = Task { [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            defer { if self.glazeWebViewGeneration == generation { self.glazeNativeCloseTask = nil } }
            do {
                let response = try await self.sendGlazeCommand("close")
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                guard Self.jsonBoolean(response?["released"]) == true else { throw GlazeFailure.code("NATIVE_FAILED") }
                if self.glazeExitRequested { self.performGlazeExit(target: self.glazeExitTarget) }
                else { self.warmTastingParlor() }
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                self.showGlazeReleaseFailure()
            }
        }
    }
    private func tearDownGlaze() {
        glazeWebViewGeneration = UUID()
        glazeLoadingTimeoutTask?.cancel(); glazeLoadingTimeoutTask = nil
        glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        glazeErrorPresentationTask?.cancel(); glazeErrorPresentationTask = nil
        glazePendingError = nil
        glazeEntryActivationTask?.cancel(); glazeEntryActivationTask = nil
        pastryArchiveTask?.cancel(); pastryArchiveTask = nil
        glazeContextTask?.cancel(); glazeContextTask = nil
        glazeContextRefreshTask?.cancel(); glazeContextRefreshTask = nil
        glazeNativeCloseTask?.cancel(); glazeNativeCloseTask = nil
        for request in glazeRequests.values {
            // StoreKit independently observes/persists late transactions after the WebView is gone.
            request.work?.cancel(); request.timeout?.cancel()
        }
        glazeRequests.removeAll(); glazeResponses.removeAll(); glazeRequestFingerprints.removeAll(); glazeCloseResponseTargets.removeAll()
        let pending = glazeCommands; glazeCommands.removeAll()
        for command in pending.values { command.timeout.cancel(); command.completion(.failure(GlazeFailure.code("NATIVE_FAILED"))) }
        applyGlazeNavigation(0)
        if let webView = tastingWebView {
            webView.stopLoading(); webView.navigationDelegate = nil; webView.uiDelegate = nil
            if let handler = glazeConfiguration?.handler { webView.configuration.userContentController.removeScriptMessageHandler(forName: handler) }
            webView.configuration.userContentController.removeScriptMessageHandler(forName: Self.glazePaintHandler)
            webView.removeFromSuperview()
        }
        tastingWebView = nil; glazeConfiguration = nil
        glazeDocumentLoaded = false
        glazeContextDelivered = false
        glazeContextDeliveryStarted = false
        glazeFirstPaint = false
        glazeContentVisible = false
        glazeContextPrepared = false
        glazeContextOwner = ""
        glazeContextTaskID = UUID()
        glazeContextPreparationDepth = 0
        glazeContextNeedsRefresh = false
        if Self.glazeActiveHost === self { Self.glazeActiveHost = nil }
        glazeRetainedFrame?.removeFromSuperview(); glazeRetainedFrame = nil
        glazeBackgroundView?.removeFromSuperview(); glazeBackgroundView = nil
        tastingBundleURL = nil
        glazeIdentityFingerprint = ""
        glazeNativeOverlayDepth = 0
        glazeSDKClosing = false
    }
    private func isWithinGlazeBundle(_ url: URL) -> Bool {
        guard url.isFileURL, let folder = tastingBundleURL else { return false }
        return url.standardizedFileURL.path.hasPrefix(folder.standardizedFileURL.path + "/")
    }

    /// Reuse only a complete, verified copy of this bundle's exact SDK content version.
    nonisolated private static func restorePastryArchive() -> URL? {
        glazeArchiveCacheLock.lock()
        defer { glazeArchiveCacheLock.unlock() }
        let manager = FileManager.default
        guard let manifestURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".manifest", withExtension: "json"),
              let manifestData = try? Data(contentsOf: manifestURL),
              manifestData.count <= 2 * 1024 * 1024,
              let manifest = try? JSONSerialization.jsonObject(with: manifestData) as? [String: Any],
              manifest["schemaVersion"] as? Int == 1, manifest["archiveFormat"] as? String == "WVVROOM1",
              manifest["sdkProtocolVersion"] as? String == "2.0.0", manifest["appConfigSchemaVersion"] as? Int == 18,
              manifest["opiProfileRevision"] as? Int == 2,
              let compression = manifest["compression"] as? [String: Any], compression["algorithm"] as? String == "zlib", compression["layers"] as? Int == 2,
              let encryption = manifest["encryption"] as? [String: Any], encryption["algorithm"] as? String == "AES-128-CBC", encryption["padding"] as? String == "PKCS7",
              let version = manifest["contentVersion"] as? String, version.hasPrefix("sdk2-"), version.count == 69,
              version.dropFirst(5).allSatisfy({ $0.isASCII && $0.isHexDigit }),
              manifest["archiveFile"] as? String == sugarPalette.sdkArchiveName + ".data",
              manifest["entryPoint"] as? String == "index.html",
              let records = manifest["files"] as? [[String: Any]], records.count == manifest["fileCount"] as? Int,
              !records.isEmpty, records.count <= 20_000,
              let canonical = try? JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .withoutEscapingSlashes]),
              "sdk2-" + glazeSHA256(canonical) == version,
              let expectedBytes = manifest["archiveBytes"] as? Int, expectedBytes > 0, expectedBytes <= 256 * 1024 * 1024,
              let expectedDigest = manifest["archiveSha256"] as? String, expectedDigest.count == 64,
              expectedDigest.allSatisfy({ $0.isASCII && $0.isHexDigit }),
              let cacheBase = manager.urls(for: .cachesDirectory, in: .userDomainMask).first, cacheBase.isFileURL else { return nil }
        do {
            var expected: [String: (size: Int, digest: String)] = [:]
            var foldedPaths = Set<String>()
            var byteCount = 0
            for record in records {
                guard let path = record["path"] as? String, safeGlazePath(path),
                      let size = record["bytes"] as? Int, size >= 0,
                      let digest = record["sha256"] as? String, digest.count == 64,
                      digest.allSatisfy({ $0.isASCII && $0.isHexDigit }), expected[path] == nil,
                      foldedPaths.insert(path.precomposedStringWithCanonicalMapping.lowercased()).inserted,
                      size <= 256 * 1024 * 1024 - byteCount else { throw GlazeFailure.code("INVALID_PAYLOAD") }
                byteCount += size; expected[path] = (size, digest)
            }
            guard byteCount == manifest["unpackedBytes"] as? Int else { throw GlazeFailure.code("INVALID_PAYLOAD") }

            try manager.createDirectory(at: cacheBase, withIntermediateDirectories: true)
            guard (try manager.attributesOfItem(atPath: cacheBase.path))[.type] as? FileAttributeType == .typeDirectory else {
                throw GlazeFailure.code("INVALID_PAYLOAD")
            }
            let root = cacheBase.standardizedFileURL.appendingPathComponent(sugarPalette.sdkArchiveName, isDirectory: true)
            try manager.createDirectory(at: root, withIntermediateDirectories: true)
            guard (try manager.attributesOfItem(atPath: root.path))[.type] as? FileAttributeType == .typeDirectory else {
                throw GlazeFailure.code("INVALID_PAYLOAD")
            }
            // Normalize an existing root before appending new descendants. This
            // keeps /private/var aliases consistent on devices and simulators.
            let cacheRoot = root.standardizedFileURL
            try protectGlazeArchiveFolder(cacheRoot, manager: manager)
            let lockURL = cacheRoot.appendingPathComponent(".prepare-" + version + ".lock")
            let descriptor = open(lockURL.path, O_CREAT | O_RDWR | O_NOFOLLOW | O_CLOEXEC, S_IRUSR | S_IWUSR)
            guard descriptor >= 0 else { throw GlazeFailure.code("INVALID_PAYLOAD") }
            defer { _ = close(descriptor) }
            guard flock(descriptor, LOCK_EX) == 0 else { throw GlazeFailure.code("INVALID_PAYLOAD") }
            defer { _ = flock(descriptor, LOCK_UN) }

            let folder = cacheRoot.appendingPathComponent(version, isDirectory: true)
            if validateGlazeArchive(at: folder, manifest: manifest, expected: expected, manager: manager) {
                try protectGlazeArchiveFolder(folder, manager: manager)
                return folder.standardizedFileURL
            }

            // A cache miss is the only path that reads/decrypts the AES package.
            guard let archiveURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName, withExtension: "data"),
                  let archive = decodeGlazeResource(at: archiveURL, expectedBytes: expectedBytes, expectedDigest: expectedDigest) else {
                throw GlazeFailure.code("INVALID_PAYLOAD")
            }
            let staging = cacheRoot.appendingPathComponent(".staging-" + version + "-" + UUID().uuidString, isDirectory: true)
            var displaced: URL?
            defer {
                try? manager.removeItem(at: staging)
                if let displaced { try? manager.removeItem(at: displaced) }
            }
            try manager.createDirectory(at: staging, withIntermediateDirectories: false)
            let canonicalFolder = staging.standardizedFileURL
            try protectGlazeArchiveFolder(canonicalFolder, manager: manager)
            guard archive.starts(with: Data("WVVROOM1".utf8)) else { throw GlazeFailure.code("INVALID_PAYLOAD") }
            var cursor = 8, restored = Set<String>()
            while cursor < archive.count {
                guard archive.count - cursor >= 12 else { throw GlazeFailure.code("INVALID_PAYLOAD") }
                let pathLength = (0..<4).reduce(0) { $0 | Int(archive[cursor + $1]) << ($1 * 8) }
                let contentLength = (0..<8).reduce(UInt64(0)) { $0 | UInt64(archive[cursor + 4 + $1]) << ($1 * 8) }
                cursor += 12
                guard pathLength > 0, pathLength <= 4096, pathLength <= archive.count - cursor,
                      contentLength <= UInt64(archive.count - cursor - pathLength),
                      let path = String(data: archive.subdata(in: cursor..<(cursor + pathLength)), encoding: .utf8), safeGlazePath(path),
                      let record = expected[path], contentLength == UInt64(record.size), restored.insert(path).inserted else { throw GlazeFailure.code("INVALID_PAYLOAD") }
                cursor += pathLength
                let content = archive.subdata(in: cursor..<(cursor + record.size)); cursor += record.size
                guard glazeSHA256(content) == record.digest else { throw GlazeFailure.code("INVALID_PAYLOAD") }
                let destination = canonicalFolder.appendingPathComponent(path)
                guard destination.standardizedFileURL.path.hasPrefix(canonicalFolder.path + "/") else { throw GlazeFailure.code("INVALID_PAYLOAD") }
                try manager.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                try content.write(to: destination, options: .atomic)
            }
            guard restored == Set(expected.keys),
                  validateGlazeArchive(at: canonicalFolder, manifest: manifest, expected: expected, manager: manager) else {
                throw GlazeFailure.code("INVALID_PAYLOAD")
            }
            // Recheck before publication. A valid winner must never be removed.
            if validateGlazeArchive(at: folder, manifest: manifest, expected: expected, manager: manager) {
                return folder.standardizedFileURL
            }
            if (try? manager.attributesOfItem(atPath: folder.path)) != nil {
                let invalid = cacheRoot.appendingPathComponent(".invalid-" + version + "-" + UUID().uuidString, isDirectory: true)
                try manager.moveItem(at: folder, to: invalid)
                displaced = invalid
            }
            do {
                // Both paths share a parent/filesystem. Rename publishes the
                // complete tree at once and refuses to overwrite another winner.
                try manager.moveItem(at: canonicalFolder, to: folder)
            } catch {
                guard validateGlazeArchive(at: folder, manifest: manifest, expected: expected, manager: manager) else { throw error }
            }
            return folder.standardizedFileURL
        } catch { return nil }
    }
    nonisolated private static let glazeArchiveCacheLock = NSLock()

    nonisolated private static func protectGlazeArchiveFolder(_ folder: URL, manager: FileManager) throws {
        try manager.setAttributes([.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: folder.path)
        var excluded = URLResourceValues(); excluded.isExcludedFromBackup = true
        var protectedFolder = folder
        try protectedFolder.setResourceValues(excluded)
    }

    /// Check the exact tree before trusting cached executable HTML/JavaScript.
    /// Directory/file links and unlisted entries cannot expand WebView access.
    nonisolated private static func validateGlazeArchive(at folder: URL, manifest: [String: Any],
                                                        expected: [String: (size: Int, digest: String)], manager: FileManager) -> Bool {
        guard let rootAttributes = try? manager.attributesOfItem(atPath: folder.path),
              rootAttributes[.type] as? FileAttributeType == .typeDirectory else { return false }
        let canonicalFolder = folder.standardizedFileURL
        let rootPrefix = canonicalFolder.path + "/"
        var expectedFiles: [String: (size: Int, digest: String)] = [:]
        var expectedDirectories = Set<String>()
        for (path, record) in expected {
            let normalized = path.precomposedStringWithCanonicalMapping
            expectedFiles[normalized] = record
            let parts = normalized.split(separator: "/")
            for count in 1..<parts.count { expectedDirectories.insert(parts.prefix(count).joined(separator: "/")) }
        }
        guard Set(expectedFiles.keys).isDisjoint(with: expectedDirectories) else { return false }
        var enumerationFailed = false
        guard let entries = manager.enumerator(at: canonicalFolder, includingPropertiesForKeys: nil, options: [], errorHandler: { _, _ in
            enumerationFailed = true
            return false
        }) else { return false }
        var files = Set<String>(), directories = Set<String>()
        for case let item as URL in entries {
            guard let attributes = try? manager.attributesOfItem(atPath: item.path),
                  let type = attributes[.type] as? FileAttributeType,
                  type == .typeDirectory || type == .typeRegular else { return false }
            let path = item.standardizedFileURL.path
            guard path.hasPrefix(rootPrefix) else { return false }
            let relative = String(path.dropFirst(rootPrefix.count)).precomposedStringWithCanonicalMapping
            if type == .typeDirectory {
                guard expectedDirectories.contains(relative), directories.insert(relative).inserted else { return false }
            } else {
                guard let record = expectedFiles[relative], files.insert(relative).inserted,
                      attributes[.size] as? Int == record.size,
                      let data = try? Data(contentsOf: item, options: .mappedIfSafe), data.count == record.size,
                      glazeSHA256(data) == record.digest else { return false }
            }
        }
        guard !enumerationFailed, files == Set(expectedFiles.keys), directories == expectedDirectories,
              let app = readMarkedJSON(at: canonicalFolder.appendingPathComponent("config/app-config.js"), marker: "APP_CONFIG"),
              app["schemaVersion"] as? Int == 18,
              let appSettings = app["app"] as? [String: Any], appSettings["appVersion"] as? String == manifest["hostVersion"] as? String,
              (app["build"] as? [String: Any])?["buildId"] as? String == manifest["h5BuildId"] as? String,
              let profile = readMarkedJSON(at: canonicalFolder.appendingPathComponent("config/opi-profile.js"), marker: "OPI_PROFILE"),
              let client = (profile["services"] as? [String: Any])?["apiClient"] as? [String: Any],
              client["appId"] as? String == manifest["appId"] as? String,
              client["appVersion"] as? String == manifest["hostVersion"] as? String,
              manager.fileExists(atPath: canonicalFolder.appendingPathComponent("index.html").path) else { return false }
        return true
    }
    nonisolated private static func safeGlazePath(_ path: String) -> Bool {
        !path.isEmpty && path.utf8.count <= 4096 && !path.hasPrefix("/") && !path.contains("\\") && !path.contains("\0") && !path.contains(":")
            && path.split(separator: "/", omittingEmptySubsequences: false).allSatisfy { !$0.isEmpty && $0 != "." && $0 != ".." }
    }
    nonisolated private static func readMarkedJSON(at url: URL, marker: String) -> [String: Any]? {
        guard let source = try? String(contentsOf: url, encoding: .utf8),
              let start = source.range(of: "/*__\(marker)_START__*/"),
              let end = source.range(of: "/*__\(marker)_END__*/", range: start.upperBound..<source.endIndex),
              let data = source[start.upperBound..<end.lowerBound].data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    nonisolated private static func glazeSHA256(_ data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    nonisolated private static func decodeGlazeResource(at url: URL, expectedBytes: Int, expectedDigest: String) -> Data? {
        // Keep intermediate encrypted/compressed buffers out of the directory-writing lifetime.
        guard expectedBytes > 0, expectedBytes <= 256 * 1024 * 1024,
              let encrypted = try? Data(contentsOf: url), encrypted.count == expectedBytes, glazeSHA256(encrypted) == expectedDigest,
              let decrypted = unlockPastryArchive(encrypted), let compressed = expandPastryArchive(decrypted) else { return nil }
        return expandPastryArchive(compressed)
    }
    nonisolated private static func unlockPastryArchive(_ sealedArchive: Data) -> Data? {
        let relativePath = sugarPalette.vanillaCipher.data(using: .utf8) ?? Data()
        guard relativePath.count > 20 else { return nil }
        var restorePastryArchive = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        relativePath.withUnsafeBytes { unlockPastryArchive in
            _ = CC_SHA256(
                unlockPastryArchive.bindMemory(to: UInt8.self).baseAddress,
                CC_LONG(relativePath.count),
                &restorePastryArchive
            )
        }
        let vanillaKey = Data(restorePastryArchive.prefix(kCCKeySizeAES128))
        let cinnamonVector = Data(restorePastryArchive.suffix(kCCBlockSizeAES128))
        var inflatedArchive = Data(count: sealedArchive.count + kCCBlockSizeAES128)
        let archiveCapacity = inflatedArchive.count
        var decodedSize = 0
        let glazeResult = inflatedArchive.withUnsafeMutableBytes { outputBytes in
            sealedArchive.withUnsafeBytes { inputBytes in
                vanillaKey.withUnsafeBytes { keyBytes in
                    cinnamonVector.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            vanillaKey.count,
                            ivBytes.baseAddress,
                            inputBytes.baseAddress,
                            sealedArchive.count,
                            outputBytes.baseAddress,
                            archiveCapacity,
                            &decodedSize
                        )
                    }
                }
            }
        }
        guard glazeResult == kCCSuccess else { return nil }
        inflatedArchive.removeSubrange(decodedSize..<inflatedArchive.count)
        return inflatedArchive
    }

    nonisolated private static func expandPastryArchive(_ sealedArchive: Data) -> Data? {
        let limit = 256 * 1024 * 1024
        guard !sealedArchive.isEmpty, sealedArchive.count <= limit else { return nil }
        var stream = z_stream()
        guard inflateInit_(&stream, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK else { return nil }
        defer { inflateEnd(&stream) }
        // Streaming avoids the former 4x allocation for this approximately 40 MB delivery.
        var chunk = [UInt8](repeating: 0, count: 64 * 1024)
        var output = Data()
        output.reserveCapacity(min(limit, sealedArchive.count + sealedArchive.count / 4))
        return sealedArchive.withUnsafeBytes { input in
            stream.next_in = UnsafeMutablePointer(mutating: input.bindMemory(to: Bytef.self).baseAddress)
            stream.avail_in = uInt(sealedArchive.count)
            while true {
                let status = chunk.withUnsafeMutableBufferPointer { buffer in
                    stream.next_out = buffer.baseAddress
                    stream.avail_out = uInt(buffer.count)
                    return inflate(&stream, Z_NO_FLUSH)
                }
                let count = chunk.count - Int(stream.avail_out)
                guard count <= limit - output.count else { return nil }
                output.append(contentsOf: chunk.prefix(count))
                if status == Z_STREAM_END { return stream.avail_in == 0 ? output : nil }
                guard status == Z_OK, stream.avail_in > 0 || count > 0 else { return nil }
            }
        }
    }

    private func showGlazeError(_ glazeNotice: String) {
        if glazeIsStandby { Self.discardGlazeStandby(); return }
        guard !glazeExiting, !glazeSDKClosing, !glazeExitRequested else { return }
        guard glazeVisible, glazePresentationReady, viewIfLoaded?.window != nil,
              UIApplication.shared.applicationState == .active,
              presentedViewController == nil else {
            queueGlazeError(glazeNotice)
            return
        }
        glazeErrorPresentationTask?.cancel(); glazeErrorPresentationTask = nil
        glazePendingError = nil
        glazeLoadingTimeoutTask?.cancel(); glazeLoadingTimeoutTask = nil
        glazeBlankPageTimeoutTask?.cancel(); glazeBlankPageTimeoutTask = nil
        // A loaded, live process may still own a room. Retry must release it before rebuilding.
        if tastingWebView != nil, glazeDocumentLoaded || glazeContextDelivered || glazeContextDeliveryStarted || glazeOpenEntrySent {
            let alert = UIAlertController(title: "Room unavailable", message: glazeNotice, preferredStyle: .alert)
            beginGlazeNativeOverlay()
            let awaitingFirstPaint = !glazeContentVisible
            alert.addAction(UIAlertAction(title: awaitingFirstPaint ? "Close" : "Cancel", style: .cancel) { [weak self] _ in
                self?.finishGlazeNativeOverlay()
                if awaitingFirstPaint { self?.cancelGlazeLoading() }
            })
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in self?.finishGlazeNativeOverlay(); self?.retryGlaze() })
            present(alert, animated: true)
            return
        }
        tearDownGlaze()
        glazeErrorView?.removeFromSuperview()
        let errorSurface = UIView()
        errorSurface.translatesAutoresizingMaskIntoConstraints = false
        errorSurface.backgroundColor = view.backgroundColor

        let dismissControl = UIButton(type: .system)
        dismissControl.translatesAutoresizingMaskIntoConstraints = false
        dismissControl.setImage(UIImage(systemName: "xqmqaqrqkq".wevVPastryCrumbBloomRestored), for: .normal)
        dismissControl.tintColor = .white
        dismissControl.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        dismissControl.layer.cornerRadius = 22
        dismissControl.addTarget(self, action: #selector(closeGlaze), for: .touchUpInside)

        let noticeLabel = UILabel()
        noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        noticeLabel.text = glazeNotice
        noticeLabel.textColor = .white
        noticeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        noticeLabel.textAlignment = .center
        noticeLabel.numberOfLines = 0

        let retryControl = UIButton(type: .system)
        retryControl.translatesAutoresizingMaskIntoConstraints = false
        retryControl.setTitle("Rqeqtqrqyq".wevVPastryCrumbBloomRestored, for: .normal)
        retryControl.setTitleColor(.white, for: .normal)
        retryControl.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        retryControl.backgroundColor = UIColor(red: 1, green: 0.19, blue: 0.47, alpha: 1)
        retryControl.layer.cornerRadius = 22
        retryControl.addTarget(self, action: #selector(retryGlaze), for: .touchUpInside)

        view.addSubview(errorSurface)
        errorSurface.addSubview(dismissControl)
        errorSurface.addSubview(noticeLabel)
        errorSurface.addSubview(retryControl)
        NSLayoutConstraint.activate([
            errorSurface.topAnchor.constraint(equalTo: view.topAnchor),
            errorSurface.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorSurface.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorSurface.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissControl.topAnchor.constraint(equalTo: errorSurface.safeAreaLayoutGuide.topAnchor, constant: 12),
            dismissControl.leadingAnchor.constraint(equalTo: errorSurface.leadingAnchor, constant: 16),
            dismissControl.widthAnchor.constraint(equalToConstant: 44),
            dismissControl.heightAnchor.constraint(equalTo: dismissControl.widthAnchor),
            noticeLabel.centerYAnchor.constraint(equalTo: errorSurface.centerYAnchor, constant: -30),
            noticeLabel.leadingAnchor.constraint(equalTo: errorSurface.leadingAnchor, constant: 32),
            noticeLabel.trailingAnchor.constraint(equalTo: errorSurface.trailingAnchor, constant: -32),
            retryControl.topAnchor.constraint(equalTo: noticeLabel.bottomAnchor, constant: 24),
            retryControl.centerXAnchor.constraint(equalTo: errorSurface.centerXAnchor),
            retryControl.widthAnchor.constraint(equalToConstant: 132),
            retryControl.heightAnchor.constraint(equalToConstant: 44)
        ])
        glazeErrorView = errorSurface
    }

}

extension UKGlazeActortroller: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard webView === tastingWebView else { return }
        glazeDocumentLoaded = true
        traceGlazeLoad("document-finished")
        publishGlazeVisibility()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard webView === tastingWebView, !glazeExiting, (error as NSError).code != NSURLErrorCancelled else { return }
        Self.glazePreparedResources = nil
        showGlazeError("This page could not be loaded. Please try again.")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard webView === tastingWebView, !glazeExiting, (error as NSError).code != NSURLErrorCancelled else { return }
        Self.glazePreparedResources = nil
        showGlazeError("This page could not be loaded. Please try again.")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard webView === tastingWebView, let url = navigationAction.request.url else { decisionHandler(.cancel); return }
        if url.absoluteString == "about:blank" || isWithinGlazeBundle(url) { decisionHandler(.allow) }
        else { decisionHandler(.cancel) }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard webView === tastingWebView, !glazeExiting else { return }
        if glazeIsStandby { Self.discardGlazeStandby(); return }
        if glazeExitRequested {
            // This process is dead and cannot acknowledge close. Preserve the
            // user's exit intent instead of unexpectedly reopening the room.
            performGlazeExit(target: glazeExitTarget)
            return
        }
        // A dead process cannot perform a release handshake. Always create a fresh instance and fresh Open.
        let now = Date()
        glazeProcessCrashDates.removeAll { now.timeIntervalSince($0) > 60 }
        glazeProcessCrashDates.append(now)
        glazeDocumentLoaded = false
        glazeContextDelivered = false
        if glazeProcessCrashDates.count > 2 {
            tearDownGlaze()
            showGlazeError("This page stopped unexpectedly. Please try again.")
            return
        }
        warmTastingParlor()
    }
}

extension UKGlazeActortroller: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool { false }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) { requestNativeGlazeClose() }
}

extension UKGlazeActortroller: WKUIDelegate {
    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        guard webView === tastingWebView, frame.isMainFrame, origin.protocol.lowercased() == "file",
              let url = frame.request.url, isWithinGlazeBundle(url) else { decisionHandler(.deny); return }
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation, webView === self.tastingWebView,
                  !self.glazeExiting else { decisionHandler(.deny); return }
            let allowed: Bool
            switch type {
            case .microphone: allowed = await self.requestPastryCapture(for: .audio)
            case .camera: allowed = await self.requestPastryCapture(for: .video)
            case .cameraAndMicrophone:
                let audio = await self.requestPastryCapture(for: .audio)
                guard self.glazeWebViewGeneration == generation, webView === self.tastingWebView,
                      !self.glazeExiting else { decisionHandler(.deny); return }
                allowed = audio ? await self.requestPastryCapture(for: .video) : false
            @unknown default: allowed = false
            }
            guard self.glazeWebViewGeneration == generation, webView === self.tastingWebView,
                  !self.glazeExiting else { decisionHandler(.deny); return }
            decisionHandler(allowed ? .grant : .deny)
        }
    }
    private func requestPastryCapture(for type: AVMediaType) async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: type) {
        case .authorized: return true
        case .notDetermined: return await AVCaptureDevice.requestAccess(for: type)
        case .denied, .restricted: return false
        @unknown default: return false
        }
    }
}
