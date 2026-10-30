import AVFoundation
import CommonCrypto
import CoreFoundation
import UIKit
import WebKit
import zlib


final class UKGlazeActortroller: UIViewController {
    private static weak var glazeActiveHost: UKGlazeActortroller?
    private static var glazeStandbyHost: UKGlazeActortroller?
    private static var glazeWebPrewarmTask: Task<Void, Never>?
    private static let glazePaintHandler = "w1e6vwvUG*lSaZz8eTF3i|rbsMt3P@a|i2n*tX".wevVPastryCrumbBloomRestored
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


        nonisolated static let vanillaCipher = "vXaXnXiXlXlXaXBXeXaXnXIXcXiXnXgXSXaXlXtXeXdXCXaXrXaXmXeXlXFXiXnXiXsXhX".wevVPastryCrumbBloomRestored
        nonisolated static let sdkArchiveName = "vCaun~iLlKl$aIBce6aPnlIzc6i/n+g8Dlo.nsuct2".wevVPastryCrumbBloomRestored
    }
    nonisolated static var glazeArchiveConfigurationSeed: String { sugarPalette.vanillaCipher }
    private static let berryBackdrop = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
    private static let contextPaths = [
        "dLe1vZiGcTe$Ngo!".wevVPastryCrumbBloomRestored, "a2p?i?B+a8ske3USrSlk".wevVPastryCrumbBloomRestored, "fVuJl,lKF8e$ajtTuTrJe~sXEPnCaxbFl8e*dV".wevVPastryCrumbBloomRestored, "o&pTe;nP".wevVPastryCrumbBloomRestored, "o?pueTnB.Gr@u?nqt*icmxe5CVoEnefUi@gW".wevVPastryCrumbBloomRestored,
        "okpjeznt.Nrsuzn!tSi&mEekCUoMnfffijgU.qi:mMA8pqpFK~ejy,".wevVPastryCrumbBloomRestored, "oJp!efni.urhuhn8tVi1mPeXCNoJn/fci/gt.snLoetliWc|evAmc9c*o#u,nft$".wevVPastryCrumbBloomRestored, "o;p7e2nV.xr%udn3tUi@meemC=o6nAfAi1g:.brqtvcKARpzpuI@dM".wevVPastryCrumbBloomRestored,
        "oMpje=n2.vrOu0n;t5iPmvegCuoAnWf,iPgs.Esca#pWi1AneQsCI#vX".wevVPastryCrumbBloomRestored, "oIpieXn?.VrQubnLtAiImHeMCaoDnCf%ixgZ.,sWa1pbi1A7eRsaKUelyf".wevVPastryCrumbBloomRestored, "o~pTe8nY.hrKuAn|tEijm~eBCyoMnjfbirgF.;s@a+p4iEB7aLspeOUErmlG".wevVPastryCrumbBloomRestored, "oQpne^nL.:rvuun$t*iLmmeYC=oVnWfliagC..s%opcokVe^t8UfrOls".wevVPastryCrumbBloomRestored,
        "ovpweInR.DcQdXnkD!oymmaPiAn/C:oXnkfgikg~".wevVPastryCrumbBloomRestored, "sFegs%s^i;o4n^".wevVPastryCrumbBloomRestored, "s1eHsXs#iqoRn...auczc?oHuDn?ttIDdY".wevVPastryCrumbBloomRestored, "sne2s5s0i+oAnw.gajc;cseistsVT9o9k|eqnb".wevVPastryCrumbBloomRestored, "sue5sXsMiloon#.WlEePgaaxcpy3TJo4k4eNnP".wevVPastryCrumbBloomRestored,
        "s8ess#sFiJoDnB.:r1eSaVljthi+mcep".wevVPastryCrumbBloomRestored, "s5ePs;sYiroXnk.+rbeba!lxtgi#m:e1.ci@mKAMc*ctoUu|nctM".wevVPastryCrumbBloomRestored, "s+eqsZsdibo6nw.arBetaUlWt9i*m4eY.%i0mrT7o+k!eknc".wevVPastryCrumbBloomRestored
    ]
    private static let methodNames = ["hfoUs4t;.$gjeetaCOolnFtqelxTty".wevVPastryCrumbBloomRestored, "hQoIskt+.^sheltvN:aLvSiWg%aStyi3oDnY".wevVPastryCrumbBloomRestored, "hxoQsktv.YcMl2o#soee".wevVPastryCrumbBloomRestored, "p9aCyGmUeIn4tD.rp1uurVcYhta9sZevP6r!owdYu|c.tp".wevVPastryCrumbBloomRestored, "p3aUyGmLeLn%t..nsvy$nscCTcrQarnHs9auc6t3ito+nfsn".wevVPastryCrumbBloomRestored]

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

    private var glazeEntry: WevVchosenTiles
    private var glazeIsStandby = false
    private var glazeUsesIdleEntry = false
    private var glazeIdleReady = false
    private var glazeOpenEntrySent = false
    private var glazeEntryActivationTask: Task<Void, Never>?
    private var glazeLoadingTimeoutTask: Task<Void, Never>?
    private var glazeBlankPageTimeoutTask: Task<Void, Never>?

    private var glazeFirstPaint = false
    private var glazeContentVisible = false
    private var glazePendingError: String?
    private var glazeErrorPresentationTask: Task<Void, Never>?
    private var glazeContextDeliveryStarted = false
    private var glazeContextOwner = "".wevVPastryCrumbBloomRestored
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
    private var glazeIdentityFingerprint = "".wevVPastryCrumbBloomRestored
    private var glazeContextPreparationDepth = 0
    private var glazeContextNeedsRefresh = false
    private var glazePreviousPopEnabled: Bool?
    private var glazeWebViewGeneration = UUID()
    private var glazeDocumentLoaded = false
    private var glazeContextDelivered = false
    private var glazeProcessCrashDates: [Date] = []
    private lazy var glazeExitSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGlazeExitSwipe(_:)))

    init(entry: WevVchosenTiles) {
        self.glazeEntry = entry
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        isModalInPresentation = true
        hidesBottomBarWhenPushed = true
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("i3nciNtQ(ScZo1d0e1rV:z)n Bhtads4 Vndo0tB nb|eYemn* diEm+p^lue/mLeTn*t=e4d5".wevVPastryCrumbBloomRestored) }

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
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "c7h9ewvJrpotn?.rbhaSctkEw+aArcdG".wevVPastryCrumbBloomRestored), style: .plain, target: self, action: #selector(glazeNativeBack))
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


        activateGlazeIdleEntry()
        monitorGlazeBlankPage()
        presentPendingGlazeError()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activateGlazeIdleEntry()
    }



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
        for command in glazeCommands.values { command.timeout.cancel(); command.completion(.failure(GlazeFailure.code("N.AuTuIzVwE._nF4A^IbL|EFDz".wevVPastryCrumbBloomRestored))) }
    }


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

    static func entryController(for entry: WevVchosenTiles) -> UKGlazeActortroller? {
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


    nonisolated private static func glazeBootstrapPaths() -> [String]? {
        guard let manifestURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".9m;aAnjiIfVeQsct6".wevVPastryCrumbBloomRestored, withExtension: "d@aatFa9".wevVPastryCrumbBloomRestored),
              let manifestData = try? Data(contentsOf: manifestURL), manifestData.count <= 2 * 1024 * 1024,
              let decrypted = unlockPastryArchive(manifestData),
              let compressed = expandPastryArchive(decrypted, limit: 2 * 1024 * 1024),
              let data = expandPastryArchive(compressed, limit: 2 * 1024 * 1024),
              let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let records = manifest["fri;lfensU".wevVPastryCrumbBloomRestored] as? [[String: Any]] else { return nil }
        let extensions: Set<String> = ["h,tJm9le".wevVPastryCrumbBloomRestored, "j!ss".wevVPastryCrumbBloomRestored, "mBjLsc".wevVPastryCrumbBloomRestored, "c7jAsx".wevVPastryCrumbBloomRestored, "czs|sp".wevVPastryCrumbBloomRestored, "wJa*s,mi".wevVPastryCrumbBloomRestored]
        let paths = records.compactMap { $0["p2aat~hU".wevVPastryCrumbBloomRestored] as? String }.filter {
            extensions.contains(($0 as NSString).pathExtension.lowercased())
        }
        guard Set(["i7n0d5e;xt.ph9tAm;lZ".wevVPastryCrumbBloomRestored, "croDnsfpi*gW/5a=pFpv-9cpoNnVfYirg0.qjNsE".wevVPastryCrumbBloomRestored, "c~o+nQfliAgI/IoKpKiQ-rprrWo?f3inlPe+.6jws*".wevVPastryCrumbBloomRestored]).isSubset(of: Set(paths)),
              paths.allSatisfy(Self.safeGlazePath) else { return nil }
        return paths
    }



    nonisolated private static func glazeArchiveStamp(at folder: URL, files: [String]) -> [String: GlazeArchiveStamp]? {
        let manager = FileManager.default
        let namespace = folder.deletingLastPathComponent()
        let cacheBase = namespace.deletingLastPathComponent()
        var result: [String: GlazeArchiveStamp] = [:]
        var directories: Set<URL> = [cacheBase, namespace, folder]
        for path in files {
            let parts = path.split(separator: Character("/s".wevVPastryCrumbBloomRestored))
            for count in 1..<parts.count {
                directories.insert(folder.appendingPathComponent(parts.prefix(count).joined(separator: "/&".wevVPastryCrumbBloomRestored), isDirectory: true))
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
            showGlazeError("P^lpe/arsBeC &c2lDolsAeM 4t/h4eK Xc!ufrNr~ennVtj 3peaagven #bTeJfTo3r7el To9p:eMn8i|nhgE yaInDoFt+hcemr8 npPalg2e7.$".wevVPastryCrumbBloomRestored)
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

        let generation = glazeWebViewGeneration
        if glazeIsStandby {
            armGlazeLoadingTimeout(standby: true)
        } else {
            Self.glazeActiveHost = self

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
                self.showGlazeError("TDheiCs~ %pAaBgQe0 6ims6 kuInBavvJa=iWlya%bJlKez ~iAn/ AtRhUias. eb~uLiulvdg.r =P=l0e:azsFen DtRrcyn ca$gjaTi=n=.v".wevVPastryCrumbBloomRestored)
                return
            }


            self.stageTastingParlor(pastryFolder: folder)
        }
    }

    private func currentGlazeContextOwner() -> String {
        let store = WevVGlazeSessionStore.shared
        let account = store.currentGlazeCredentials.map { String($0.vanillaBeanIcing) } ?? "gTu9ePs8tr".wevVPastryCrumbBloomRestored
        return "\(store.activeEnvironmentID ?? "".wevVPastryCrumbBloomRestored)\(":b".wevVPastryCrumbBloomRestored)\(store.sessionEpoch)\(":$".wevVPastryCrumbBloomRestored)\(account)"
    }



    private func armGlazeLoadingTimeout(standby: Bool) {
        glazeLoadingTimeoutTask?.cancel()
        let generation = glazeWebViewGeneration
        glazeLoadingTimeoutTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(standby ? 60 : 75) * 1_000_000_000)
            guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else { return }
            if self.glazeIsStandby { Self.discardGlazeStandby() }
            else { self.showGlazeError("T,hhi.s@ 4pjawgdez aikss Gt%aGkhiJn$gZ Nthonoa DlBoQn3gg ztAov flioha$d/.c OP3lAe$aDsbet ItBryy@ @a%gYa#i:n2.a".wevVPastryCrumbBloomRestored) }
        }
    }

    private func cancelGlazeEntryPreparation() {


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

            self.showGlazeError("T@hOi*sg %pwacg$eo AcGohu#lqd; Znbo;t8 @b+eQ EdQi|sApQlba5yKe7d7.e ZPDlje#awsgez htRrky+ .a4gvanihnR.T".wevVPastryCrumbBloomRestored)
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

        if !glazeContextDeliveryStarted, !glazeOpenEntrySent { performGlazeExit(target: 0) }
        else { requestNativeGlazeClose() }
    }

    private func glazeFirstPaintScript() -> String {
        let generation = glazeWebViewGeneration.uuidString
        return "\("(A(|)t i=@>I g{q\n8 | ll3eYtz 2lcags%t*Viiis5ihb1lhei,7 4qyu%eMuLe*dr r=: @fjanleszex;+\nw l Rf@u9nVcItui,ozn! $vXi|s/i,bkl6eb(.e/lKeam3eVnct$)V k{,\nE = n F bc!o2n&s7t5 nrlexcftK $=L hevlzeNmleJn?tx.+gdeFtsB.oKuPnTd+i~n?g3CAl%i5emn.tRR|e/cnty(G)U;V\nP : z r Ji7fn b(lrhe.cFtr.NwJidd~tThr N<&=, A0r T|g|: yrTe+cWt*.zh*eRi5gchQt9 #<@=n F07 A|*|h mr8evcItv.7bEoqt9tPo,mt Y<^=Y 90A m|G|I irxe.crtl.xrwi^gOhotE !<Z=M s0$ L|j|! Krce~cWt2.UtEo,p| 6>u=W ~iKnUnLerrwHTepi=g,hvtF d|s|G Zr~e=cQt2.qlFe%f@tX p>u=I hi#nSn3esr%WjiRdFtYhl)n /r,e4tEubrln/ cf.a%lGsNeQ;Z\nY w E ! SfMonrG x(jl@emta ;n8oCdNe2 L=. 2eYlAe%mqewnpt$;5 Pn8ohd6eL;& !n8oYdqeq ?=2 knuoCd+er.AptaVrLe&nTtUE7lOemmve2nNtn)2 E{i\nB u O E 6 C $cEoonPsxtV &sCtyyKlBeQ e=h ?g*ett!CRo9m0p%u|tleQdwSNtsy;l0eD(yntoVdeex)c;L\np z # K ~ 9 &ilf+ z(TsdtjyMlMes.DdOiYstpklHa/yg 7=!=G=R e\'4nFojnjec\'V #|M|y !syt^yYlYe7.dvUigsQi9b6iTl|i.toy; i=^=j=k p\',h^iMd~d@e$nQ\'M h|;|U Osutqy~lWe7.PvLivs|i2b9ivl*i5ttyK K=#=P=v s\';cUo/lWl?ahpEsuep\'? .|||c 5N;u8moblefr*(wshtWyZlZex.^ooplaNcki;t@yU)l !=m=t=w Q0#)O Cr~eetauxrxn= ufkaClfsieY;X\ne / W ^ !}I\n| c O P Wr8eYtZu~rfnl +tOrbu$e6;.\ne O z}7\n0 ! kfMuKn$cQtQipouny ?hOahsDCToFn3tNe@n/tR(Cr?oIoPtH)# ,{?\nv e d 6 RiTfZ &(F!or!oAo?tW D|Q|W %!+rwoboUtD.JiUsSCvo~n?nve|c6t6e*dW)R LrQett$u@rhnN #f5a3l7sLei;3\nm a : N Gcnobn/s!t? ^w0aHl@kpe/rs w=d rdPo6c$ubm8epnLtI.,ctrge=aPt|e8Tvr:edeeWuaHl@k5eDro(%rpo4o;tw,q !Nwofd0eEFjiDlBt!e5rK.,SuH*OAWu_HT6E~XXTI)c;|\ny W @ 2 zf|o5rz I(QlNegt& HtIetxdtS;@ h(Qt,eTxWtP U=H Pw6aqlfk!eUr:.2n?erxlt?NBoPd.ey(q)m)e;T)D n{a\n$ ; O U 7 8 9iUfs A(0!dtQeJx5t,.btfe/x~tBCCo5nrtSe^n8ti.?t3r&irmK(t)j w|E|Q V!Gvoiqswiebvl^eE(&tje~xstp.lp9aArfeJnjt2E^lJeummeMnitA)w)r BcVoPn4t%i!nMu^e8;5\nS # K . N * ScyoHn6s0tX drtabnzgxex E=~ Ed4oWcXu5mQe#nlts.5c|r2eDaYtEeNROaFn4g8eW(G)S;8 WrcaqnFg0e0.ssLekl6eBc=tSNyo%dJeeCWo8ngtMejnbt=ss(gt#e|xPtV)0;=\nS + ^ 6 6 O ?iPfm :(qA/rer^a^yT.7fqr5o/mV(WroaCnJg*eq.Wg0eOtICxlgi8elnjt=R3eJcvt9s!(I)n)i.%sPo5mqe=(Lr5 9=V>I ur=.lwSi$d;tGhH 5>7 l04 Y&i&? srE.chweli3gZh&tI Y>y %0G i&2&2 .r5.;bCo~tCt,oVm& f>i &0. E&E&G Lr1.mtyoQpP 4<9 jiXn$n9eorwH+e%i^gJhDt?)P)? Arpe3tBuEr0nP 0t^rQulea;i\nl Q a t z}@\nH k d N %r~entbuNr5nY 8AYrxr*aJyO.Af%r+oSm,(~rSogo?tH.AqYuNeer|yMS;eZlDe$cxt6o7r8A8lGl1(;\'iivn!p,uGte,StZedx8t0a3r6eaaB,Asce*l8e8c3tf,ZsVvUg4,sv1iwdoeTo2,divm;g%,$[$r$oHl/eE=4\"@p9rsotg7rieJsxsgbJaGry\"k]U,r.:spk3eWlne2t?odnR-qb;lloGclkr,L.%sjkUeXl=ewtyoHno-~t2erxEtl\'!)|)o.%sdoWmYeh(Ce%lneWmoegn9tv u=M>, m{V\n= A c 4 I ^ ?i=fe :(J!FvOios^iBbYl3ey($e6lveTmTeMnYtm)f)K gr7e&twu4rTnA *fua4l1szec;^\nS i Q ; B B !iSf1 4(#e,lae#m5e8nlt;.6tGaVg*N@aImKe: I=p=#=* ~\'IISM&GG\'K)2 irXemtJuXrLnz ,epl0esmuetntt#.=choHmIpdlUejt5ev #&5&C oe|lcepmfe5n%t~.Qn@autpu3r/aQl~Wvi^dftLh. b>Z N0/;M\n& F v d b F :i6f5 0(ae6laeumNeNnWt%.4tjaMg3NNaVmVen k=f=+=$ d\'rVMI#D9E:O/\'k)f LrZeSt^u;r#nR geGlZekmheznYt|.*r~eaa5dzytSOt;aCt7eJ +>0=g ,2P c&x&! +eVlSelmTewnhtj.svEind3eeouWlixdCt9hW />/ 706;s\n^ 9 f V | I Mi6f, 3(beHlhekmJeinRt2.ItMajg1NBacmce9.etVo?LTo*wzeBr.CKaGsBeA(B), ?=I=p=b j\'0sUvXgJ\'v)U 6rHe:teuWrQnW $!1!2eil=e0m6e9nvtH.kqqu2eCrvy~S2eUl/exctt&o:r@(*\'npvadtNh%,Dr+e&cutd,Mclinrecwlkep,QlPiRnGe&,OpTollgyXl,i3nHe6,tpzoUl|ytgBo&n$,@uespe5,5tPe3x2ty\'Q)t;4\nM W N m c g jrReUt3uXrmnk itrr0ude4;A\nj q E V O}7)Z;U\n7 G 3}|\nA K 8f6udnScNt?ino:nn Ac5hKescnk4(Q)f k{0\n7 K d D ViOf^ Y(2qbu=evuFendJ 7|a|B pdOo|c2uym@e8n:t$.&hHi6d%dBe0n&)t 7rLeAtKuer|nq;K\n= $ = m jqQuwe=uZeKd! 8=J +t;r.uLe+;~\n+ k L ^ YrqeTqluke|smt4AQn#iRm+a$tjitonn8F,r$almAe0(F(&)m c=H>M kr!e8qcuqeqsZt0ASn=i|m3a/t5iAoVn4FLrdammmei(m(w): Y=O>/ 5{!\nM R s V ; O *qyu0eUuEe=d0 9=f JfPaxl@sje%;j\n6 & q W % ! 8cMoQn*s1tW xpZa?iJn7tmezd& D=H B!qlvoNcza%tgi1o:nB.;hIa8sCh*.As~t^aRrbt~s8WVimtBh%(r\'V#6/EsudRkd/%iad&l2e9\':)m 4&g&B\n$ ! i S 7 5 F E A[HdYorc+upmcebnit1.6gQeftiEwlce8mUe.ndtfBly!I:dA(3\'zatp6py\'m)w,# K.h.O.Tdmo&c=urm0eanktU.!qnuseJroyvSze6l9emcAtcoHrZAfldle(~\'x.ab?oQoitL-XejrXrborrI,^.6g=l!o*bxa^l4-FlIokaEdxiZnEgl[irMo;l+eT=8\"4sEt5aZtdu6sD\"u];,0.fr,o;o5mf-usch*e,lilU-Yhsols*tF\'K)W]f.KsyoOm$eu(khAahs,CnoTnhtle*nStW)P;m\n/ F v f 5 m QiMfK b(Lp^axixn#tvesdu n=V=5=p ?lMa4sLt5VZiQsbi~bYlEeE)p 2rAeUtHuSr;nm;w\n: y $ # t x 8lFaBs$tgVbipsoi=bFlHeU n=l %p&aziFn2tle!dw;P\n/ V p b A b IwHiznOdkoNwS.uwkeibpkDirtn.Jm$eIs~s$a1gaejHwajnmdBl9elrtsq.:".wevVPastryCrumbBloomRestored)\(Self.glazePaintHandler)\(".*p9ojsgtFM.ebsCsiahg$ea(1{;gCennneer?azt6i!oznd:d :\'P".wevVPastryCrumbBloomRestored)\(generation)\("\'F,n :vDi#s$i|b0lreb:3 Bp^a|i4n*t1eZdi}4)$;N\nN h 7 8 ;}.)I)+;N\n$ = 5}h\nz T YnHe/wE ~MSust;ait+i@o@nJOhbWs6e+r6vye+rb(3cXh8edcJkk)j.=oEbosYe0r3v9eZ(WdJoxc=uPmJeBnVtr,f &{.cPhQiClEdhL.i;s2tj:k ZtxriuSek,& .c$h9aRrKagcVt:eUr~Dza5tNah:q dtfrGuxe@,P CsJu@b$txr$eze/:^ QtSrxuuec,R 1a5tWtWrQiWb?u*txevs::o 3t8r,u@eV,@ Ga9tktQrFicbyuUtSe3FQiRlDt5ecra:4 n[T\'jc~lkaDsKs7\'Z,s T\'usstjy,l6e3\'c,r 1\'Phoi.dHd/e=n3\'@,j 7\'%s?rIcz\'d]H}~)U;l\n9 P 0fOo*ru 2(uc9oHnAsntc yeKvVeanvt~ Fo%f? .[&\';hca|schTcyhWa/nwgKez\'g,~ l\'mrie?sgitzue*\'&,Z D\'mvCixsgi|b9i@lHiOt.yKcehvaSn@gLe|\'@,0 2\'#t=r;a/nnsaiqtii;olnzeYnhdn\'3,6 F\'Zatn#idmnaBt%iMoVn4eHn+d*\'w,% &\'HlgoTaldu\';]|)B ow~imn^dvogwo.$a8d:d=Ebv#eJn!tjL8iGsrtke@nke0rj(2eyvRehn$t.,d ^cChSeQc;kQ,u 0t?rPuoeR)!;b\nU 4 |dZo~clu4m2e%nItV.|ald1dlEXv5eWngtwLli@sPtge=nxe7r=(A\'dD=O?M;CYo.nvtfeqnFt7L3oyatdEeudv\'K,= Gcihze2c,k*,F w{KoFnYc~ej:J ?t.r=u2e#}b)Q;:\n% ^ F/x/3 ;r:enpxlYaRcheVSNtsamt6e. &ainndi Os+tGyslPens@h.e2ext: EcQh.a#nwg;e5sP InFeFead* knGoVtg .egmtidt2 6aT :D%OvM~ km~uxtaaptBiHofn9.T\nL H Os~ejtxI@nytEeirQvEa+lJ(3cHh2eccxka,h |170N0H0y)I;R\nX}w)O(@)i;,".wevVPastryCrumbBloomRestored)"
    }

    private func receiveGlazeFirstPaint(_ message: WKScriptMessage) {
        guard message.webView === tastingWebView, message.frameInfo.isMainFrame, !glazeIsStandby,
              let url = message.frameInfo.request.url, isWithinGlazeBundle(url),
              let body = message.body as? [String: Any], body["gJeunXeyrcaQtWiuofnX".wevVPastryCrumbBloomRestored] as? String == glazeWebViewGeneration.uuidString,
              let visible = Self.jsonBoolean(body["vHizsii7bSlce@".wevVPastryCrumbBloomRestored]) else { return }
        glazeContentVisible = visible
        if visible {
            if !glazeFirstPaint { glazeFirstPaint = true;  }
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
                      let session = context["sdeCs%sTiQoInP".wevVPastryCrumbBloomRestored] as? [String: Any],
                      session["adcfcrohu|nTtFI@dU".wevVPastryCrumbBloomRestored] as? String == String(current.vanillaBeanIcing),
                      session["aKc0c$eGs4sOTMoYkOeTn4".wevVPastryCrumbBloomRestored] as? String == current.brownButterGlaze else { throw GlazeFailure.code("NOAbT9IGVoEg_MF9A2IUL6EQDs".wevVPastryCrumbBloomRestored) }
                guard !self.glazeEntry.hideRemoteSheenPlaceholder || Self.jsonBoolean(context["fWu.lgl~F5e*a2t~u1rvehstE;n0aYb?l;e5dn".wevVPastryCrumbBloomRestored]) == true else {
                    throw GlazeFailure.code("FTERA+T6UXR:ES_AUdNAAeVDAUI%LkAjB3LNEz".wevVPastryCrumbBloomRestored)
                }
                self.glazeIdentityFingerprint = self.currentGlazeIdentityFingerprint()
                self.glazeContextPrepared = true

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

                let result = try await self.sendGlazeCommand("oXpmeTnOE:n=t8royh".wevVPastryCrumbBloomRestored, params: ["esnTt%rgyA".wevVPastryCrumbBloomRestored: entry], timeout: 65)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation,
                      !self.glazeExiting, !self.glazeSDKClosing, !self.glazeExitRequested else { return }
                guard Self.jsonBoolean(result?["oEpLeUn+eXd=".wevVPastryCrumbBloomRestored]) == true else { throw GlazeFailure.code("N/A2TfI.V.E*_nFtARIELEERDq".wevVPastryCrumbBloomRestored) }

                self.publishGlazeVisibility()
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation,
                      !self.glazeExiting, !self.glazeSDKClosing, !self.glazeExitRequested else { return }
                self.showGlazeError("TThfi!sc 9pVa#gNes ,c&odu~lfdZ AnPovt* wb@e6 2pbrqePpuaxrNeIdy.T ZPYlfeLaFs@ef ~t*r,yG Tagg~aQiMnY.:".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func stageTastingParlor(pastryFolder: URL) {
        tastingBundleURL = pastryFolder
        if let active = Self.glazeActiveHost, active !== self, active.tastingWebView != nil {
            showGlazeError("Pvl4e%aDs6eO Acml=oMsCe/ st~hweA ;cMuGrRroe5nUtF zp*aTgke2 ^bve4fGo5rFe~ Movp+e$nPiRnEgG XaInpo3t?h.eVrQ ;pha*gGe6.|".wevVPastryCrumbBloomRestored)
            return
        }
        guard let configuration = readTastingConfig(pastryFolder: pastryFolder),
              let entry = glazeUsesIdleEntry ? URL(string: pastryFolder.appendingPathComponent("i$nldqeuxY.hh*t5mSlf".wevVPastryCrumbBloomRestored).absoluteString + "#j/6sbdGki/;ildolaeI".wevVPastryCrumbBloomRestored)
                : makeTastingURL(indexURL: pastryFolder.appendingPathComponent("iUnLd6ecxv.8hht,m0lW".wevVPastryCrumbBloomRestored)) else {
            showGlazeError("TDhkidsc zp|akgQee Tc8o$unlfdN cnYoxtN 8b@ed DptrlePpba&rFe=dW.r :PPl$efags4ev xt?r#yl Na1gxa^ibnM.5".wevVPastryCrumbBloomRestored)
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
        let backgroundPath = pastryFolder.appendingPathComponent("azs#sseEtMsk/jc?odm:mqo?ny/,bYa8cIk1g.r.oou7nQdi.zpHn*gI".wevVPastryCrumbBloomRestored)
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

        webView.loadFileURL(entry, allowingReadAccessTo: pastryFolder)
    }

    private func makeTastingURL(indexURL: URL) -> URL? {
        glazeEntry.firstDivider(doughKitchenBakery: indexURL)
    }

    private func readTastingConfig(pastryFolder: URL) -> GlazeConfiguration? {
        guard let app = Self.readMarkedJSON(at: pastryFolder.appendingPathComponent("c~oMn*ffi8gO/Ra3pDpr-nccoxnAfGicg$.rj@s!".wevVPastryCrumbBloomRestored), marker: "AuPVPB_^CUO?NWFqI|GE".wevVPastryCrumbBloomRestored),
              (app["sIcdhPeFmtaxVFeWr$s#i*o5nG".wevVPastryCrumbBloomRestored] as? NSNumber)?.intValue == 18,
              let build = app["b&uUiBl2dk".wevVPastryCrumbBloomRestored] as? [String: Any],
              let appSettings = app["acprp9".wevVPastryCrumbBloomRestored] as? [String: Any], appSettings["atp9poVZeHr4sRiQoyna".wevVPastryCrumbBloomRestored] as? String == filledShellSelection.tastingJourneyAtlas,
              let profile = Self.readMarkedJSON(at: pastryFolder.appendingPathComponent("cpoLnef2i0g!/boGptig-yp@r$oXfui;lbeN.yjcs!".wevVPastryCrumbBloomRestored), marker: "OqPDIt_IP;RQOqFjIOLjEC".wevVPastryCrumbBloomRestored),
              let services = profile["sqeMr0vgiVcce%sg".wevVPastryCrumbBloomRestored] as? [String: Any], let client = services["abp=iMCHlUi1eMn=t~".wevVPastryCrumbBloomRestored] as? [String: Any],
              let appID = client["aGpYpQI.d.".wevVPastryCrumbBloomRestored] as? String, !appID.isEmpty,
              (WevVGlazeSessionRepository.pastryTrailDiary.glazeAppID.isEmpty || appID == WevVGlazeSessionRepository.pastryTrailDiary.glazeAppID),
              client["aMpcpQVDemrqsRi#obnF".wevVPastryCrumbBloomRestored] as? String == filledShellSelection.tastingJourneyAtlas,
              let bridge = app["bVr^i^d%g8eI".wevVPastryCrumbBloomRestored] as? [String: Any], let handler = bridge["hcaRnddZlNeHrG".wevVPastryCrumbBloomRestored] as? String, Self.validContextName(handler), handler != Self.glazePaintHandler,
              let receiver = bridge["roe!cxeBiQv%eRrZ".wevVPastryCrumbBloomRestored] as? String, Self.validContextName(receiver),
              let methods = bridge["m9eptAhjo.d7sR".wevVPastryCrumbBloomRestored] as? [String: String], Set(methods.keys) == Set(Self.methodNames),
              Set(methods.values).count == methods.count, methods.values.allSatisfy({ !$0.isEmpty && $0.count <= 128 }),
              let fields = bridge["c+oSn8tyeEx;txFniYe&lIdMs0".wevVPastryCrumbBloomRestored] as? [String: String], Set(fields.keys) == Set(Self.contextPaths),
              fields.values.allSatisfy(Self.validContextName) else { return nil }
        if let floor = build["m+iNnAiXmbupmzHSoss^tDVOe0r4swi@oUnR".wevVPastryCrumbBloomRestored] as? String, !supportsBakeVersion(bakeFloor: floor) { return nil }
        var siblings: [String: Set<String>] = [:]
        for (path, actual) in fields {
            let parent = path.split(separator: Character(".|".wevVPastryCrumbBloomRestored)).dropLast().joined(separator: ".0".wevVPastryCrumbBloomRestored)
            guard siblings[parent, default: []].insert(actual).inserted else { return nil }
        }
        return GlazeConfiguration(handler: handler, receiver: receiver, methods: methods, contextFields: fields)
    }

    nonisolated private static func validContextName(_ name: String) -> Bool {
        guard !["_0_Kpor.oMt|oP_4_y".wevVPastryCrumbBloomRestored, "pXruovt|o9try*pLe5".wevVPastryCrumbBloomRestored, "c#omnts*t:rJujcetwobr/".wevVPastryCrumbBloomRestored].contains(name), (1...64).contains(name.utf8.count),
              let first = name.utf8.first, (65...90).contains(first) || (97...122).contains(first) || first == 95 else { return false }
        return name.utf8.allSatisfy { (65...90).contains($0) || (97...122).contains($0) || (48...57).contains($0) || $0 == 95 || $0 == 45 }
    }
    private func supportsBakeVersion(bakeFloor: String) -> Bool {
        let current = filledShellSelection.tastingJourneyAtlas.split(separator: Character(".;".wevVPastryCrumbBloomRestored)).compactMap { Int($0) }
        let required = bakeFloor.split(separator: Character(".e".wevVPastryCrumbBloomRestored)).compactMap { Int($0) }
        guard !current.isEmpty, !required.isEmpty, required.count == bakeFloor.split(separator: Character(".H".wevVPastryCrumbBloomRestored)).count else { return false }
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
              let envelope = message.body as? [String: Any], let kind = envelope["ksi+ngdR".wevVPastryCrumbBloomRestored] as? String,
              let id = envelope["iydM".wevVPastryCrumbBloomRestored] as? String, !id.isEmpty, id.utf8.count <= 128 else { return }
        if kind == "rme=sgpfopn3sNep".wevVPastryCrumbBloomRestored {
            guard let pending = glazeCommands.removeValue(forKey: id) else { return }
            pending.timeout.cancel()
            if Self.jsonBoolean(envelope["o7kP".wevVPastryCrumbBloomRestored]) == true {
                if envelope["rqegsauXlit0".wevVPastryCrumbBloomRestored] is NSNull { pending.completion(.success(nil)) }
                else if let result = envelope["rxe6sYu:lZtu".wevVPastryCrumbBloomRestored] as? [String: Any] { pending.completion(.success(result)) }
                else { pending.completion(.failure(GlazeFailure.code("I#NMVDA3LfI+DB_IPQAhYqL3OtAtDZ".wevVPastryCrumbBloomRestored))) }
            } else { pending.completion(.failure(GlazeFailure.code("NCA7TMICV0Ex_nFRAzI,LhEADl".wevVPastryCrumbBloomRestored))) }
            return
        }
        guard kind == "r*e%quuceSsEt^".wevVPastryCrumbBloomRestored else { return }
        let fingerprint = (try? JSONSerialization.data(withJSONObject: envelope, options: [.sortedKeys])).map(Self.glazeSHA256) ?? "".wevVPastryCrumbBloomRestored
        if let previous = glazeRequestFingerprints[id] {
            guard previous == fingerprint else { return }
            if let response = glazeResponses[id] {
                let generation = glazeWebViewGeneration
                Task { [weak self] in
                    guard let self, self.glazeWebViewGeneration == generation else { return }
                    do {
                        try await self.sendGlaze(response)
                        if self.glazeWebViewGeneration == generation, Self.jsonBoolean(response["oOk.".wevVPastryCrumbBloomRestored]) == true, let target = self.glazeCloseResponseTargets[id] {
                            self.performGlazeExit(target: target)
                        }
                    } catch { }
                }
            }
            return
        }
        glazeRequestFingerprints[id] = fingerprint
        guard let wireMethod = envelope["mGeZt,hJoLdK".wevVPastryCrumbBloomRestored] as? String,
              let method = glazeConfiguration?.methods.first(where: { $0.value == wireMethod })?.key else {
            respondInvalidGlaze(id: id, code: "U%N8SwUQPwPMO+RBThEeD6_LM7E&TFHiOUDG".wevVPastryCrumbBloomRestored); return
        }
        guard let params = envelope["pFa:rYa4mfsa".wevVPastryCrumbBloomRestored] as? [String: Any] else { respondInvalidGlaze(id: id, code: "I0NvVyAqLCI9D5_zPBACRvAdM@S!".wevVPastryCrumbBloomRestored); return }
        guard !glazeIsStandby || (method == "huofsyto.:sse0tpN@aivkiWgaa1tEioo;nw".wevVPastryCrumbBloomRestored && Self.jsonInteger(params["tja=rPgtegtY".wevVPastryCrumbBloomRestored]) == 0) else {
            respondInvalidGlaze(id: id, code: "UuNESsUOPFPMO.RPT|E6Dx_JMLEaT*H1O9Di".wevVPastryCrumbBloomRestored); return
        }
        let purchase = method == "pDaiyHmVewn*t%.qp:u#rEcWhZaEsDe.PkrTordpuycHtZ".wevVPastryCrumbBloomRestored
        let deadline: Double?
        if purchase {
            guard envelope["d8eFagdDlDiTn*e;M9sQ".wevVPastryCrumbBloomRestored] == nil else { respondInvalidGlaze(id: id, code: "IlN,VuA&L7IvD._:P/AlYbLsOxAwDn".wevVPastryCrumbBloomRestored); return }
            deadline = nil
        } else {
            guard let number = envelope["dke~asdnlwimnZehM=s*".wevVPastryCrumbBloomRestored] as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID(), number.doubleValue.isFinite else {
                respondInvalidGlaze(id: id, code: "IpNHV=ANLdILDZ_mP0A+Y=LfODAaD$".wevVPastryCrumbBloomRestored); return
            }
            let maxWait: Double = method == "h8o$suts.&gue#t8CGo0npt:eLx$tg".wevVPastryCrumbBloomRestored ? 60_000 : (method == "hxo$sftq.#soeAtyN6aPvSi&guaTt,i6o1nU".wevVPastryCrumbBloomRestored ? 5_000 : 15_000)
            deadline = min(number.doubleValue, Date().timeIntervalSince1970 * 1000 + maxWait)
            guard deadline! > Date().timeIntervalSince1970 * 1000 else { respondInvalidGlaze(id: id, code: "TCICMMEwO#UVTR".wevVPastryCrumbBloomRestored); return }
        }
        glazeRequests[id] = GlazeRequest(method: method, deadline: deadline)
        let generation = glazeWebViewGeneration
        glazeRequests[id]?.work = Task { [weak self] in
            guard let self, !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
            if let deadline, deadline <= Date().timeIntervalSince1970 * 1000 {
                _ = await self.completeGlaze(id: id, error: "TsIfM$EQO$UFTu".wevVPastryCrumbBloomRestored)
                return
            }
            do {
                let result = try await self.executeGlaze(method: method, params: params)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                if method == "hiocs,t4.xc*lDoVsSeE".wevVPastryCrumbBloomRestored, let target = Self.jsonInteger(params["tLaDrRg&eGt@".wevVPastryCrumbBloomRestored]) { self.glazeCloseResponseTargets[id] = target }
                let sent = await self.completeGlaze(id: id, result: result)
                if sent, self.glazeWebViewGeneration == generation, method == "hXoisptY.+sqeTtzNUa~v6iXgJaYt*i5o6n%".wevVPastryCrumbBloomRestored,
                   params["rce&a=sZoqnx".wevVPastryCrumbBloomRestored] as? String == "p?roezlSooa;df-IrSevaTdJyD".wevVPastryCrumbBloomRestored, self.glazeIsStandby {
                    self.glazeIdleReady = true
                    self.glazeLoadingTimeoutTask?.cancel(); self.glazeLoadingTimeoutTask = nil

                }
                if sent, self.glazeWebViewGeneration == generation, method == "hnojsYtW.Dc7l3o$s/er".wevVPastryCrumbBloomRestored, let target = Self.jsonInteger(params["tiaYrxgzeUt,".wevVPastryCrumbBloomRestored]) { self.performGlazeExit(target: target) }
            } catch {
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }

                let code: String
                if case GlazeFailure.code(let value) = error { code = value }
                else if method.hasPrefix("p!a$yAmhe9natE.O".wevVPastryCrumbBloomRestored) { code = DrawcreamScoutSugarStyle.apricotCompote(error) }
                else { code = "NxAwT!IoVUEY_~FeAuIDLhEGD+".wevVPastryCrumbBloomRestored }
                _ = await self.completeGlaze(id: id, error: code)
            }
        }
        if let deadline {
            glazeRequests[id]?.timeout = Task { [weak self] in
                let wait = max(0, deadline - Date().timeIntervalSince1970 * 1000)
                try? await Task.sleep(nanoseconds: UInt64(wait * 1_000_000))
                guard !Task.isCancelled, let self, self.glazeWebViewGeneration == generation else { return }
                _ = await self.completeGlaze(id: id, error: "TNICMWEKO5UJT;".wevVPastryCrumbBloomRestored, fromTimeout: true)
            }
        }
    }

    private func executeGlaze(method: String, params: [String: Any]) async throws -> Any {
        switch method {
        case "hBo5s%tT.!gweBtlCGoVn|tcevxGt!".wevVPastryCrumbBloomRestored:
            guard params.isEmpty, !glazeIsStandby else { throw GlazeFailure.code("I^NzV9A*LpI4D1_uPWALR%AVMhSr".wevVPastryCrumbBloomRestored) }
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
            guard let task = glazeContextTask else { throw GlazeFailure.code("NAAlTSI$V?E^_7FcA#ICLiEIDz".wevVPastryCrumbBloomRestored) }
            let taskID = glazeContextTaskID
            let context = try await task.value
            guard !Task.isCancelled, glazeWebViewGeneration == generation, currentGlazeContextOwner() == owner,
                  WevVGlazeSessionStore.shared.sessionEpoch == epoch,
                  WevVGlazeSessionStore.shared.activeEnvironmentID == environment,
                  WevVGlazeSessionStore.shared.isTasterReady,
                  let current = WevVGlazeSessionStore.shared.currentGlazeCredentials,
                  let session = context["see~s0s&itolns".wevVPastryCrumbBloomRestored] as? [String: Any],
                  session["a6cAcIo+uqnjtII!dw".wevVPastryCrumbBloomRestored] as? String == String(current.vanillaBeanIcing),
                  session["a0cWc=eAs~s9T7o#k5e.no".wevVPastryCrumbBloomRestored] as? String == current.brownButterGlaze,
                  !glazeEntry.hideRemoteSheenPlaceholder || Self.jsonBoolean(context["fJuTlvlUFFe6ast$ulr2evsuEVn|aBb%l7e4d/".wevVPastryCrumbBloomRestored]) == true else {
                if glazeWebViewGeneration == generation, glazeContextTaskID == taskID {
                    glazeContextTask = nil; glazeContextPrepared = false
                }
                throw GlazeFailure.code("NtALT,ImVREp_$FbAUIOLeE%De".wevVPastryCrumbBloomRestored)
            }
            glazeIdentityFingerprint = currentGlazeIdentityFingerprint()
            return try mappedGlazeContext(context)
        case "hRoXs3tL.,sJe|tdNJasv~iwg.agt5i,o!n|".wevVPastryCrumbBloomRestored:
            guard let target = Self.jsonInteger(params["t=aJrOg?e;tO".wevVPastryCrumbBloomRestored]), (0...2).contains(target), Set(params.keys).isSubset(of: ["tVaIrbgSeHty".wevVPastryCrumbBloomRestored, "r;ePazsFo!n1".wevVPastryCrumbBloomRestored]) else {
                applyGlazeNavigation(0); throw GlazeFailure.code("IWN9VBAzL.IrDP_qPfAcR4AKM!Sn".wevVPastryCrumbBloomRestored)
            }
            if let raw = params["r*e.a8s/o0nA".wevVPastryCrumbBloomRestored] {
                guard let reason = raw as? String, target == 0, ["pWr/e$l1o?a,d:-Hrge6aPdKyi".wevVPastryCrumbBloomRestored, "sZdgkA-jc9lJoqs/e~".wevVPastryCrumbBloomRestored, "sadZkp-5celZo^s%ev-Jf5aiiOlFeBd*".wevVPastryCrumbBloomRestored].contains(reason) else {
                    applyGlazeNavigation(0); throw GlazeFailure.code("IMNNVsA+LYIcDc_KPoA~R1AuM#SH".wevVPastryCrumbBloomRestored)
                }
                if reason == "s&d=kc-Pclliobs@eX".wevVPastryCrumbBloomRestored {
                    glazeSDKClosing = true
                    cancelGlazeEntryPreparation()
                } else if reason == "s%dtkB-CcSl$oUsAe!-3f!aGidlwepdr".wevVPastryCrumbBloomRestored {
                    glazeSDKClosing = false
                }
                if reason == "s7dikC-scol:o@sKed".wevVPastryCrumbBloomRestored, glazeRetainedFrame == nil, let frame = tastingWebView?.snapshotView(afterScreenUpdates: false) {
                    frame.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(frame)
                    NSLayoutConstraint.activate([
                        frame.topAnchor.constraint(equalTo: view.topAnchor), frame.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        frame.trailingAnchor.constraint(equalTo: view.trailingAnchor), frame.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
                    glazeRetainedFrame = frame
                } else if reason == "s1d:kd-kcFlZoOsNe7-WfQaki+l?exdN".wevVPastryCrumbBloomRestored {
                    glazeRetainedFrame?.removeFromSuperview(); glazeRetainedFrame = nil
                    resumeGlazeEntryMonitoring()
                }
            }
            applyGlazeNavigation(target)
            return NSNull()
        case "h~ors4tl.mcAl@oDskea".wevVPastryCrumbBloomRestored:
            guard Set(params.keys) == ["t0aTrAg2evt5".wevVPastryCrumbBloomRestored], let target = Self.jsonInteger(params["t@a;r5gkeotp".wevVPastryCrumbBloomRestored]), (0...1).contains(target) else { throw GlazeFailure.code("I=NLVcA%LUI7D&_*P:AnR#ASMMSy".wevVPastryCrumbBloomRestored) }
            return NSNull()
        case "piaDyIm&eXn@tT.=pXuNrfc$hoaUs?e$Pur+o1dou.cTtW".wevVPastryCrumbBloomRestored, "p*a$yOmCe8nJtH.PsWyVngc$Thr^agn1snahcOt6iko!ncs/".wevVPastryCrumbBloomRestored:
            guard WevVGlazeSessionStore.shared.isTasterReady,
                  let current = WevVGlazeSessionStore.shared.currentGlazeCredentials else { throw GlazeFailure.code("IyNMV%AJLEI3De_tPFA@ReAYMNS%".wevVPastryCrumbBloomRestored) }
            let repository = WevVGlazeSessionRepository.pastryTrailDiary
            let owner = String(current.vanillaBeanIcing)
            let epoch = WevVGlazeSessionStore.shared.sessionEpoch
            let environment = repository.glazeEnvironmentID
            let result: [String: Any]
            if method == "peaByxmQepn,tI.Ip*uvrJc5h~aAsoeoPDr6oid;u.cltN".wevVPastryCrumbBloomRestored {
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
                throw GlazeFailure.code("TBRMAFNgS4AoC.TNI,OKNW_4U|N.AbV&ARI@LyAjBJLRE5".wevVPastryCrumbBloomRestored)
            }
            return result
        default: throw GlazeFailure.code("UMN6SLUSPFP?OSRkT4EeDN_SMsEzTTH5O9Dr".wevVPastryCrumbBloomRestored)
        }
    }

    private func mappedGlazeContext(_ context: [String: Any]) throws -> [String: Any] {
        guard let mapping = glazeConfiguration?.contextFields, let session = context["sKePs#sRi*o4nJ".wevVPastryCrumbBloomRestored] as? [String: Any],
              session["rIewfhr2eGslhrT,o3k$e@n2".wevVPastryCrumbBloomRestored] == nil, session["a3cucPeUs,s*TQo*kxeOn,EMx+peiVr$e!srAst@".wevVPastryCrumbBloomRestored] == nil, context["rte;f#r;ezshh:TzoZkXe,nu".wevVPastryCrumbBloomRestored] == nil else {
            throw GlazeFailure.code("N8A$TwI$V&E/_PFSAkI&LiE3DX".wevVPastryCrumbBloomRestored)
        }
        func rename(_ object: [String: Any], prefix: String) -> [String: Any] {
            var result: [String: Any] = [:]
            for (key, value) in object {
                let path = prefix.isEmpty ? key : prefix + ".d".wevVPastryCrumbBloomRestored + key
                let renamed = mapping[path] ?? key
                result[renamed] = (value as? [String: Any]).map { rename($0, prefix: path) } ?? value
            }
            return result
        }
        return rename(context, prefix: "".wevVPastryCrumbBloomRestored)
    }

    @discardableResult
    private func completeGlaze(id: String, result: Any = NSNull(), error: String? = nil, fromTimeout: Bool = false) async -> Bool {
        guard let request = glazeRequests.removeValue(forKey: id) else { return false }
        if fromTimeout { request.work?.cancel() }
        else { request.timeout?.cancel() }
        var code = error
        if let deadline = request.deadline, deadline <= Date().timeIntervalSince1970 * 1000 { code = "TJIoMZEJO+UcT:".wevVPastryCrumbBloomRestored }
        let response: [String: Any] = code.map { ["kAiAn9dw".wevVPastryCrumbBloomRestored: "rreLs0p8oMn:s!e,".wevVPastryCrumbBloomRestored, "i7dR".wevVPastryCrumbBloomRestored: id, "o:ka".wevVPastryCrumbBloomRestored: false, "e5r:rQonrc".wevVPastryCrumbBloomRestored: ["cKoFd*ei".wevVPastryCrumbBloomRestored: $0]] }
            ?? ["kci!nzd8".wevVPastryCrumbBloomRestored: "rbeKsypNo/nlsfen".wevVPastryCrumbBloomRestored, "i8dH".wevVPastryCrumbBloomRestored: id, "oPkr".wevVPastryCrumbBloomRestored: true, "rQeUs.uAlhtP".wevVPastryCrumbBloomRestored: result]
        glazeResponses[id] = response
        let generation = glazeWebViewGeneration
        if request.method == "h@o3smt1.ug8e^tFCDoBn%t0eZxltH".wevVPastryCrumbBloomRestored, code == nil { glazeContextDeliveryStarted = true }
        do {
            try await sendGlaze(response)
            guard glazeWebViewGeneration == generation else { return false }
            if request.method == "hWoUs3t*.5gFektmC2oSnut?exx*tG".wevVPastryCrumbBloomRestored {
                if code == nil { glazeContextDelivered = true;  }

            }
            return code == nil
        } catch {

            return false
        }
    }
    private func respondInvalidGlaze(id: String, code: String) {
        let response: [String: Any] = ["kiiDn9d|".wevVPastryCrumbBloomRestored: "rHe|sqpNo!n^sFe@".wevVPastryCrumbBloomRestored, "iqd6".wevVPastryCrumbBloomRestored: id, "oZk,".wevVPastryCrumbBloomRestored: false, "eNror:oRrU".wevVPastryCrumbBloomRestored: ["c0ozdXeh".wevVPastryCrumbBloomRestored: code]]
        glazeResponses[id] = response
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation else { return }
            try? await self.sendGlaze(response)
        }
    }
    private func sendGlaze(_ message: [String: Any]) async throws {
        guard let webView = tastingWebView, let receiver = glazeConfiguration?.receiver else { throw GlazeFailure.code("N4A.T|ItVlE8_%F:A;IXL!E#D%".wevVPastryCrumbBloomRestored) }
        _ = try await webView.callAsyncJavaScript("c%own6skti Wf|n9 S=W 9wPiinod5onwq[Vr*efcjeti7vBeurR],;c #iPf6 /(;tbyHpfe~oVf! *f^n# d!u=G=y ?\'sfeuvnMcqt8iOornP\'j)a EtzhjrnoUwc FnZeNw4 +EAr|rYo@rI(C\'VBBrfi#d|gqeN %uSnta!vcafirlEa:b&lze?\'5)j;% brteKtAuxr~nV ^f~n3(omFeDsas9akgle!)!;S".wevVPastryCrumbBloomRestored, arguments: ["rLe#cue9i^vreJrO".wevVPastryCrumbBloomRestored: receiver, "mQeis/s6aug9eM".wevVPastryCrumbBloomRestored: message], in: nil, contentWorld: .page)
    }
    private func sendGlazeCommand(_ command: String, params: [String: Any] = [:], timeout: Double = 15) async throws -> [String: Any]? {
        guard tastingWebView != nil else { throw GlazeFailure.code("NvAnTPI^VQE0_eFxA+I1L=ElDj".wevVPastryCrumbBloomRestored) }
        let id = UUID().uuidString
        let generation = glazeWebViewGeneration
        return try await withCheckedThrowingContinuation { continuation in
            let timeoutTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                guard !Task.isCancelled, let pending = self?.glazeCommands.removeValue(forKey: id) else { return }
                pending.completion(.failure(GlazeFailure.code("TJIQMxEOOEU3Tz".wevVPastryCrumbBloomRestored)))
            }
            glazeCommands[id] = GlazeCommand(completion: { continuation.resume(with: $0) }, timeout: timeoutTask)
            Task { [weak self] in
                guard let self, self.glazeWebViewGeneration == generation, self.glazeCommands[id] != nil else { return }
                do { try await self.sendGlaze(["k&iQn~d4".wevVPastryCrumbBloomRestored: "c/o;m.m3a1npd7".wevVPastryCrumbBloomRestored, "i|d0".wevVPastryCrumbBloomRestored: id, "c%oImkmNaenLdV".wevVPastryCrumbBloomRestored: command, "pea9r#admtsg".wevVPastryCrumbBloomRestored: params]) }
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


    func requestGlazeBack() {
        let generation = glazeWebViewGeneration
        Task { [weak self] in
            guard let self, self.glazeWebViewGeneration == generation else { return }
            do {
                let response = try await self.sendGlazeCommand("bna%c&kC".wevVPastryCrumbBloomRestored, timeout: 15)
                guard Self.jsonBoolean(response?["hJarn0dxldeZd+".wevVPastryCrumbBloomRestored]) == true else { throw GlazeFailure.code("NOAiTVIXVsE/_.F5ArILLuEGDS".wevVPastryCrumbBloomRestored) }
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
                let response = try await self.sendGlazeCommand("c5looYsoek".wevVPastryCrumbBloomRestored)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                guard Self.jsonBoolean(response?["r9eUl8e|ans#eSda".wevVPastryCrumbBloomRestored]) == true else { throw GlazeFailure.code("NBAdTzIxV,El_+FYANIWLSEBD:".wevVPastryCrumbBloomRestored) }
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
        let alert = UIAlertController(title: "Ufn~a:bYl|ed 7t.oF scSl3oIs~eV Rpha5g7eV".wevVPastryCrumbBloomRestored, message: "T%hTiXsd 9p^awg8e| YhVaNsK ?nKoOtq EfXiPncihsohAeidl Hr5e|lseFajsmiun+gi 7iBtss. 4rEe7suobuJrfcMews4.: yPelEe0aIsyev *tvr|yj padgFaDidnD.&".wevVPastryCrumbBloomRestored, preferredStyle: .alert)
        beginGlazeNativeOverlay()
        alert.addAction(UIAlertAction(title: "COaJnDc!e?lV".wevVPastryCrumbBloomRestored, style: .cancel) { [weak self] _ in
            self?.finishGlazeNativeOverlay()
            self?.glazeExitRequested = false
            self?.resumeGlazeEntryMonitoring()
        })
        alert.addAction(UIAlertAction(title: "R.emtxr0yn".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in self?.finishGlazeNativeOverlay(); self?.requestNativeGlazeClose() })
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
            _ = try? await self.sendGlazeCommand("vmi;sVi=bhivl^i?tFyrCkhya+nfghe;d;".wevVPastryCrumbBloomRestored, params: ["v^iQs$iab^lWeA".wevVPastryCrumbBloomRestored: visible], timeout: 5)
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
        guard let task = glazeContextTask else { throw GlazeFailure.code("N#ANT2I+V|EH_%FoAeImL.E6D|".wevVPastryCrumbBloomRestored) }
        let context = try await task.value
        guard !Task.isCancelled, glazeWebViewGeneration == generation, tastingWebView != nil, !glazeExiting else { return }
        _ = try mappedGlazeContext(context)
        glazeIdentityFingerprint = currentGlazeIdentityFingerprint()
        _ = try await sendGlazeCommand("cDotnCtve;x:t5CwhEa8nUg9e,d,".wevVPastryCrumbBloomRestored)
    }
    private func currentGlazeIdentityFingerprint() -> String {
        let scope = WevVGlazeSessionRepository.pastryTrailDiary.glazeEnvironmentID + ":6".wevVPastryCrumbBloomRestored + String(WevVGlazeSessionStore.shared.sessionEpoch)
        guard let current = WevVGlazeSessionStore.shared.currentGlazeCredentials else { return scope + ":ag,uGens8t8".wevVPastryCrumbBloomRestored }
        let fields = [scope, String(current.vanillaBeanIcing), current.brownButterGlaze, current.maplePecanCoating,
                      current.tastingTrayNotesWevv, current.apricotFilling, current.hazelnutCream]
        return Self.glazeSHA256(Data(fields.joined(separator: "\0&".wevVPastryCrumbBloomRestored).utf8))
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
                let response = try await self.sendGlazeCommand("cBljo!steI".wevVPastryCrumbBloomRestored)
                guard !Task.isCancelled, self.glazeWebViewGeneration == generation else { return }
                guard Self.jsonBoolean(response?["rvekl;e$ausSeyd2".wevVPastryCrumbBloomRestored]) == true else { throw GlazeFailure.code("N~A,TSI4VREp_gF7A%I+LzE:D2".wevVPastryCrumbBloomRestored) }
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

            request.work?.cancel(); request.timeout?.cancel()
        }
        glazeRequests.removeAll(); glazeResponses.removeAll(); glazeRequestFingerprints.removeAll(); glazeCloseResponseTargets.removeAll()
        let pending = glazeCommands; glazeCommands.removeAll()
        for command in pending.values { command.timeout.cancel(); command.completion(.failure(GlazeFailure.code("NKAETVICV;EN_iFuAyI|LiERD|".wevVPastryCrumbBloomRestored))) }
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
        glazeContextOwner = "".wevVPastryCrumbBloomRestored
        glazeContextTaskID = UUID()
        glazeContextPreparationDepth = 0
        glazeContextNeedsRefresh = false
        if Self.glazeActiveHost === self { Self.glazeActiveHost = nil }
        glazeRetainedFrame?.removeFromSuperview(); glazeRetainedFrame = nil
        glazeBackgroundView?.removeFromSuperview(); glazeBackgroundView = nil
        tastingBundleURL = nil
        glazeIdentityFingerprint = "".wevVPastryCrumbBloomRestored
        glazeNativeOverlayDepth = 0
        glazeSDKClosing = false
    }
    private func isWithinGlazeBundle(_ url: URL) -> Bool {
        guard url.isFileURL, let folder = tastingBundleURL else { return false }
        return url.standardizedFileURL.path.hasPrefix(folder.standardizedFileURL.path + "/%".wevVPastryCrumbBloomRestored)
    }


    nonisolated private static func restorePastryArchive() -> URL? {
        glazeArchiveCacheLock.lock()
        defer { glazeArchiveCacheLock.unlock() }
        let manager = FileManager.default
        guard let manifestURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".fmBa?nei,f5eLspt&".wevVPastryCrumbBloomRestored, withExtension: "dIa0tpac".wevVPastryCrumbBloomRestored),
              let manifestData = try? Data(contentsOf: manifestURL),
              manifestData.count <= 2 * 1024 * 1024,
              let decrypted = unlockPastryArchive(manifestData),
              let compressed = expandPastryArchive(decrypted, limit: 2 * 1024 * 1024),
              let data = expandPastryArchive(compressed, limit: 2 * 1024 * 1024),
              let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              manifest["scc&hgekmWa6V*eKrvsrioobnp".wevVPastryCrumbBloomRestored] as? Int == 1, manifest["a|rAcwhHi;v6eZF:orrhm#aQtJ".wevVPastryCrumbBloomRestored] as? String == "WCVlVCR5O$ONM71d".wevVPastryCrumbBloomRestored,
              manifest["s;d4kzP|rQo;t3oAc4oalAVGeHrcsji;oonU".wevVPastryCrumbBloomRestored] as? String == "2B.V0#.T0^".wevVPastryCrumbBloomRestored, manifest["a&p~ppCfo/n#fting~SHcZhJemmrarV#eercsXiCouna".wevVPastryCrumbBloomRestored] as? Int == 18,
              manifest["o4pUixP+r~oqfKiGlhezRTeVv/i3sGi&osn2".wevVPastryCrumbBloomRestored] as? Int == 2,
              let compression = manifest["cFo$mcp4rxe?sSsJiDo9n@".wevVPastryCrumbBloomRestored] as? [String: Any], compression["aElAg!oor,iptyhimD".wevVPastryCrumbBloomRestored] as? String == "zrlZizbz".wevVPastryCrumbBloomRestored, compression["l~aCype9rrsU".wevVPastryCrumbBloomRestored] as? Int == 2,
              let encryption = manifest["e5nQcLrUyIpwt?iZoknZ".wevVPastryCrumbBloomRestored] as? [String: Any], encryption["all6gZoIr$idt1hnmI".wevVPastryCrumbBloomRestored] as? String == "AgEmSp-t1U218V-?CrB$Cc".wevVPastryCrumbBloomRestored, encryption["pqa=dOdGi#nKgF".wevVPastryCrumbBloomRestored] as? String == "P/K,CaS27.".wevVPastryCrumbBloomRestored,
              let version = manifest["cWo3n~t=eBnyt.VkeUr8sMi.oLnb".wevVPastryCrumbBloomRestored] as? String, version.hasPrefix("s~dZkm2f-C".wevVPastryCrumbBloomRestored), version.count == 69,
              version.dropFirst(5).allSatisfy({ $0.isASCII && $0.isHexDigit }),
              manifest["aNr%c~h1i+v$eBF|irl;eK".wevVPastryCrumbBloomRestored] as? String == sugarPalette.sdkArchiveName + ".idKaltnak".wevVPastryCrumbBloomRestored,
              manifest["e2nvtOroyUP4oSi&n5tm".wevVPastryCrumbBloomRestored] as? String == "iun8dBe?xq.Ghwt^mAlV".wevVPastryCrumbBloomRestored,
              let records = manifest["f&iil!eas#".wevVPastryCrumbBloomRestored] as? [[String: Any]], records.count == manifest["ffiql2e.C^oduYnPtZ".wevVPastryCrumbBloomRestored] as? Int,
              !records.isEmpty, records.count <= 20_000,
              let canonical = try? JSONSerialization.data(withJSONObject: records, options: [.sortedKeys, .withoutEscapingSlashes]),
              "sPdPk%2s-%".wevVPastryCrumbBloomRestored + glazeSHA256(canonical) == version,
              let expectedBytes = manifest["a7rEcMh1iIvheQBJyatTe2sX".wevVPastryCrumbBloomRestored] as? Int, expectedBytes > 0, expectedBytes <= 256 * 1024 * 1024,
              let expectedDigest = manifest["acrHc1hzipvhenSAhoa72U5i6=".wevVPastryCrumbBloomRestored] as? String, expectedDigest.count == 64,
              expectedDigest.allSatisfy({ $0.isASCII && $0.isHexDigit }),
              let cacheBase = manager.urls(for: .cachesDirectory, in: .userDomainMask).first, cacheBase.isFileURL else { return nil }
        do {
            var expected: [String: (size: Int, digest: String)] = [:]
            var foldedPaths = Set<String>()
            var byteCount = 0
            for record in records {
                guard let path = record["p1akt#hp".wevVPastryCrumbBloomRestored] as? String, safeGlazePath(path),
                      let size = record["bIyitPeesN".wevVPastryCrumbBloomRestored] as? Int, size >= 0,
                      let digest = record["svhda!2l586Z".wevVPastryCrumbBloomRestored] as? String, digest.count == 64,
                      digest.allSatisfy({ $0.isASCII && $0.isHexDigit }), expected[path] == nil,
                      foldedPaths.insert(path.precomposedStringWithCanonicalMapping.lowercased()).inserted,
                      size <= 256 * 1024 * 1024 - byteCount else { throw GlazeFailure.code("IONPVRA8LQI|DL_=PyARYQL=OfAcD~".wevVPastryCrumbBloomRestored) }
                byteCount += size; expected[path] = (size, digest)
            }
            guard byteCount == manifest["u5n$pva4cKkwebdJB.yGtHeVs~".wevVPastryCrumbBloomRestored] as? Int else { throw GlazeFailure.code("IANBViAoL2IDDX_rP7AMY5L9OQAtD!".wevVPastryCrumbBloomRestored) }

            try manager.createDirectory(at: cacheBase, withIntermediateDirectories: true)
            guard (try manager.attributesOfItem(atPath: cacheBase.path))[.type] as? FileAttributeType == .typeDirectory else {
                throw GlazeFailure.code("I5NsV:A5LqIyD~_vPQAzYVLJO*APD6".wevVPastryCrumbBloomRestored)
            }
            let root = cacheBase.standardizedFileURL.appendingPathComponent("vla=n+iTlTlJaFB!eIa!nnIQc%isnEgHS3d4k92,".wevVPastryCrumbBloomRestored, isDirectory: true)
            try manager.createDirectory(at: root, withIntermediateDirectories: true)
            guard (try manager.attributesOfItem(atPath: root.path))[.type] as? FileAttributeType == .typeDirectory else {
                throw GlazeFailure.code("IGNbV/AALXIfDt_ZPNAXYuLdONA*DB".wevVPastryCrumbBloomRestored)
            }


            let cacheRoot = root.standardizedFileURL
            try protectGlazeArchiveFolder(cacheRoot, manager: manager)
            let lockURL = cacheRoot.appendingPathComponent(".5pRr3ejpQa%rJe,-Y".wevVPastryCrumbBloomRestored + version + ".0lco!c?kD".wevVPastryCrumbBloomRestored)
            let descriptor = open(lockURL.path, O_CREAT | O_RDWR | O_NOFOLLOW | O_CLOEXEC, S_IRUSR | S_IWUSR)
            guard descriptor >= 0 else { throw GlazeFailure.code("I:NyVnA%LFIoDM_LPJApYwLIOcATD,".wevVPastryCrumbBloomRestored) }
            defer { _ = close(descriptor) }
            guard flock(descriptor, LOCK_EX) == 0 else { throw GlazeFailure.code("INNvVcA=L,IWDt_OPrA;YpLDOqArDb".wevVPastryCrumbBloomRestored) }
            defer { _ = flock(descriptor, LOCK_UN) }

            let folder = cacheRoot.appendingPathComponent(version, isDirectory: true)
            if validateGlazeArchive(at: folder, manifest: manifest, expected: expected, manager: manager) {
                try protectGlazeArchiveFolder(folder, manager: manager)
                return folder.standardizedFileURL
            }


            guard let archiveURL = Bundle.main.url(forResource: sugarPalette.sdkArchiveName, withExtension: "dta^tNa%".wevVPastryCrumbBloomRestored),
                  let archive = decodeGlazeResource(at: archiveURL, expectedBytes: expectedBytes, expectedDigest: expectedDigest) else {
                throw GlazeFailure.code("IQNbV2A:LpI3DS_JP4AGYmLGOFAnDD".wevVPastryCrumbBloomRestored)
            }
            let staging = cacheRoot.appendingPathComponent(".ys@tladgYiTn|gG-U".wevVPastryCrumbBloomRestored + version + "-3".wevVPastryCrumbBloomRestored + UUID().uuidString, isDirectory: true)
            var displaced: URL?
            defer {
                try? manager.removeItem(at: staging)
                if let displaced { try? manager.removeItem(at: displaced) }
            }
            try manager.createDirectory(at: staging, withIntermediateDirectories: false)
            let canonicalFolder = staging.standardizedFileURL
            try protectGlazeArchiveFolder(canonicalFolder, manager: manager)
            guard archive.starts(with: Data("W1VLV9RaOmOuM:1#".wevVPastryCrumbBloomRestored.utf8)) else { throw GlazeFailure.code("IGN~V8AULiI6Dx_aPOAhYXLPO4A0Dz".wevVPastryCrumbBloomRestored) }
            var cursor = 8, restored = Set<String>()
            while cursor < archive.count {
                guard archive.count - cursor >= 12 else { throw GlazeFailure.code("I:NQVdA#L=IYDK_~P;AJY;LBOEA:DZ".wevVPastryCrumbBloomRestored) }
                let pathLength = (0..<4).reduce(0) { $0 | Int(archive[cursor + $1]) << ($1 * 8) }
                let contentLength = (0..<8).reduce(UInt64(0)) { $0 | UInt64(archive[cursor + 4 + $1]) << ($1 * 8) }
                cursor += 12
                guard pathLength > 0, pathLength <= 4096, pathLength <= archive.count - cursor,
                      contentLength <= UInt64(archive.count - cursor - pathLength),
                      let path = String(data: archive.subdata(in: cursor..<(cursor + pathLength)), encoding: .utf8), safeGlazePath(path),
                      let record = expected[path], contentLength == UInt64(record.size), restored.insert(path).inserted else { throw GlazeFailure.code("IdN3VTA@L$IxDN_tPRAiYbL9OxAJD7".wevVPastryCrumbBloomRestored) }
                cursor += pathLength
                let content = archive.subdata(in: cursor..<(cursor + record.size)); cursor += record.size
                guard glazeSHA256(content) == record.digest else { throw GlazeFailure.code("IqNrVxAZLuIsDS_gPFAOYqLwO6AuDA".wevVPastryCrumbBloomRestored) }
                let destination = canonicalFolder.appendingPathComponent(path)
                guard destination.standardizedFileURL.path.hasPrefix(canonicalFolder.path + "/x".wevVPastryCrumbBloomRestored) else { throw GlazeFailure.code("IiN;V#AaLZIrD=_TPQAyYFLHO#A4DD".wevVPastryCrumbBloomRestored) }
                try manager.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                try content.write(to: destination, options: .atomic)
            }
            guard restored == Set(expected.keys),
                  validateGlazeArchive(at: canonicalFolder, manifest: manifest, expected: expected, manager: manager) else {
                throw GlazeFailure.code("I.N~VtAdLrI1D%_+P&A8YrLNO,AADO".wevVPastryCrumbBloomRestored)
            }

            if validateGlazeArchive(at: folder, manifest: manifest, expected: expected, manager: manager) {
                return folder.standardizedFileURL
            }
            if (try? manager.attributesOfItem(atPath: folder.path)) != nil {
                let invalid = cacheRoot.appendingPathComponent(".YirntvFaFlJiVd.-*".wevVPastryCrumbBloomRestored + version + "-%".wevVPastryCrumbBloomRestored + UUID().uuidString, isDirectory: true)
                try manager.moveItem(at: folder, to: invalid)
                displaced = invalid
            }
            do {


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



    nonisolated private static func validateGlazeArchive(at folder: URL, manifest: [String: Any],
                                                        expected: [String: (size: Int, digest: String)], manager: FileManager) -> Bool {
        guard let rootAttributes = try? manager.attributesOfItem(atPath: folder.path),
              rootAttributes[.type] as? FileAttributeType == .typeDirectory else { return false }
        let canonicalFolder = folder.standardizedFileURL
        let rootPrefix = canonicalFolder.path + "/I".wevVPastryCrumbBloomRestored
        var expectedFiles: [String: (size: Int, digest: String)] = [:]
        var expectedDirectories = Set<String>()
        for (path, record) in expected {
            let normalized = path.precomposedStringWithCanonicalMapping
            expectedFiles[normalized] = record
            let parts = normalized.split(separator: Character("/=".wevVPastryCrumbBloomRestored))
            for count in 1..<parts.count { expectedDirectories.insert(parts.prefix(count).joined(separator: "/m".wevVPastryCrumbBloomRestored)) }
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
              let app = readMarkedJSON(at: canonicalFolder.appendingPathComponent("cEoOnwfliDgB/|azpop+-rc;oOnDfdifga.3j$s,".wevVPastryCrumbBloomRestored), marker: "A=POPo_CCCOVNpF|I4Gv".wevVPastryCrumbBloomRestored),
              app["sSc8hNeymKauV&e;r=sPiXo3nw".wevVPastryCrumbBloomRestored] as? Int == 18,
              let appSettings = app["aqpspa".wevVPastryCrumbBloomRestored] as? [String: Any], appSettings["a;pDp8V2eqrDs:ikoRnf".wevVPastryCrumbBloomRestored] as? String == manifest["h9oPs6taVKe#r7saivoXn&".wevVPastryCrumbBloomRestored] as? String,
              (app["bjuMiLl&d8".wevVPastryCrumbBloomRestored] as? [String: Any])?["b;u,inl6d%I%d$".wevVPastryCrumbBloomRestored] as? String == manifest["hw5YBLu#iwlkd.IMd,".wevVPastryCrumbBloomRestored] as? String,
              let profile = readMarkedJSON(at: canonicalFolder.appendingPathComponent("cBo%n.fIiAgJ/aoYpziV-!p=r&oUfMiMlce:.!jOs$".wevVPastryCrumbBloomRestored), marker: "O2PUI~_NPhR,OEF=IPL&EU".wevVPastryCrumbBloomRestored),
              let client = (profile["sMehrWvbiecxe.sw".wevVPastryCrumbBloomRestored] as? [String: Any])?["ampbixC=lkiZeQn,tp".wevVPastryCrumbBloomRestored] as? [String: Any],
              client["a6pZp2I4dr".wevVPastryCrumbBloomRestored] as? String == manifest["aFpOpAIMd+".wevVPastryCrumbBloomRestored] as? String,
              client["a9pBpOV$e8rZs8iooUnV".wevVPastryCrumbBloomRestored] as? String == manifest["h4oNs|t;V/eLr/sEiro;n6".wevVPastryCrumbBloomRestored] as? String,
              manager.fileExists(atPath: canonicalFolder.appendingPathComponent("i3n!doerx..xh/t?mFl$".wevVPastryCrumbBloomRestored).path) else { return false }
        return true
    }
    nonisolated private static func safeGlazePath(_ path: String) -> Bool {
        !path.isEmpty && path.utf8.count <= 4096 && !path.hasPrefix("/P".wevVPastryCrumbBloomRestored) && !path.contains("\\3".wevVPastryCrumbBloomRestored) && !path.contains("\0|".wevVPastryCrumbBloomRestored) && !path.contains(":E".wevVPastryCrumbBloomRestored)
            && path.split(separator: Character("/8".wevVPastryCrumbBloomRestored), omittingEmptySubsequences: false).allSatisfy { !$0.isEmpty && $0 != ".R".wevVPastryCrumbBloomRestored && $0 != ".z.a".wevVPastryCrumbBloomRestored }
    }
    nonisolated private static func readMarkedJSON(at url: URL, marker: String) -> [String: Any]? {
        guard let source = try? String(contentsOf: url, encoding: .utf8),
              let start = source.range(of: "\("/m*0_e_B".wevVPastryCrumbBloomRestored)\(marker)\("_1SaTwA,R2T@_%_/*X/#".wevVPastryCrumbBloomRestored)"),
              let end = source.range(of: "\("/.*._2_=".wevVPastryCrumbBloomRestored)\(marker)\("_!EuN7Dl_:_3*d/,".wevVPastryCrumbBloomRestored)", range: start.upperBound..<source.endIndex),
              let data = source[start.upperBound..<end.lowerBound].data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    nonisolated private static func glazeSHA256(_ data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest) }
        return digest.map { String(format: "%V0:2Txq".wevVPastryCrumbBloomRestored, $0) }.joined()
    }
    nonisolated private static func decodeGlazeResource(at url: URL, expectedBytes: Int, expectedDigest: String) -> Data? {

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

    nonisolated private static func expandPastryArchive(_ sealedArchive: Data, limit: Int = 256 * 1024 * 1024) -> Data? {
        guard !sealedArchive.isEmpty, sealedArchive.count <= limit else { return nil }
        var stream = z_stream()
        guard inflateInit_(&stream, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK else { return nil }
        defer { inflateEnd(&stream) }

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

        if tastingWebView != nil, glazeDocumentLoaded || glazeContextDelivered || glazeContextDeliveryStarted || glazeOpenEntrySent {
            let alert = UIAlertController(title: "RWo4obm@ Qu%nia7v:aoi@lpavb;lmes".wevVPastryCrumbBloomRestored, message: glazeNotice, preferredStyle: .alert)
            beginGlazeNativeOverlay()
            let awaitingFirstPaint = !glazeContentVisible
            alert.addAction(UIAlertAction(title: awaitingFirstPaint ? "Cullousee8".wevVPastryCrumbBloomRestored : "C;axn+cTewlF".wevVPastryCrumbBloomRestored, style: .cancel) { [weak self] _ in
                self?.finishGlazeNativeOverlay()
                if awaitingFirstPaint { self?.cancelGlazeLoading() }
            })
            alert.addAction(UIAlertAction(title: "Rke&tjrPyy".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in self?.finishGlazeNativeOverlay(); self?.retryGlaze() })
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

        publishGlazeVisibility()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard webView === tastingWebView, !glazeExiting, (error as NSError).code != NSURLErrorCancelled else { return }
        Self.glazePreparedResources = nil
        showGlazeError("T0h9iOs2 !pga@gUeB Gcaofu#l#dE 7nqo2tH NbKe0 ,l0oXa,dee*d;.f 9PHlde5aasDem btSr|ym iaSgzaIiGn,.X".wevVPastryCrumbBloomRestored)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard webView === tastingWebView, !glazeExiting, (error as NSError).code != NSURLErrorCancelled else { return }
        Self.glazePreparedResources = nil
        showGlazeError("Tzhsi9sd EpVaOgGeY Sc.oYuwlhdc DnEobt^ Ubaed zlwo/abd8eNd0.6 |P~lGeta&s|e, 3tjrCyI 5ajgya@i/n%.j".wevVPastryCrumbBloomRestored)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard webView === tastingWebView, let url = navigationAction.request.url else { decisionHandler(.cancel); return }
        if url.absoluteString == "aobUoLu0tr:Tb1lPa=n?kZ".wevVPastryCrumbBloomRestored || isWithinGlazeBundle(url) { decisionHandler(.allow) }
        else { decisionHandler(.cancel) }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard webView === tastingWebView, !glazeExiting else { return }
        if glazeIsStandby { Self.discardGlazeStandby(); return }
        if glazeExitRequested {


            performGlazeExit(target: glazeExitTarget)
            return
        }

        let now = Date()
        glazeProcessCrashDates.removeAll { now.timeIntervalSince($0) > 60 }
        glazeProcessCrashDates.append(now)
        glazeDocumentLoaded = false
        glazeContextDelivered = false
        if glazeProcessCrashDates.count > 2 {
            tearDownGlaze()
            showGlazeError("Tshzi?sJ ,p&aPg1e$ Ysbtaoxp9pze3dh AuUn/e@xIpoe!cQt~e7dZl?yR.^ ZPOl@eIaMsreI ct3rDyq Wa/gCaYi;no.7".wevVPastryCrumbBloomRestored)
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
        guard webView === tastingWebView, frame.isMainFrame, origin.protocol.lowercased() == "fWi.lPeU".wevVPastryCrumbBloomRestored,
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
