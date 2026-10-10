import AVFoundation
import CommonCrypto
import UIKit
import WebKit
import zlib

final class UKGlazeActortroller: UIViewController {
    private enum sugarPalette {
        static let glazeChannel = "rqoqoqmqBqrqiqdqgqeq".wevVPastryCrumbBloomRestored
        static let glazeReceiver = "_q_qRqOqOqMq_qHq5q_qBqRqIqDqGqEq_qRqEqCqEqIqVqEq_q_q".wevVPastryCrumbBloomRestored
        nonisolated static let crumbArchiveName = "vqaqnqiqlqlqaqBqeqaqnqIqcqiqnqgq".wevVPastryCrumbBloomRestored
        nonisolated static let vanillaCipher = "vXaXnXiXlXlXaXBXeXaXnXIXcXiXnXgXSXaXlXtXeXdXCXaXrXaXmXeXlXFXiXnXiXsXhX".wevVPastryCrumbBloomRestored
    }

    private static let berryBackdrop = UIColor(
        red: 21.0 / 255.0,
        green: 5.0 / 255.0,
        blue: 46.0 / 255.0,
        alpha: 1
    )

    private struct tastingBlueprint: Decodable {
        private struct glazeKey: CodingKey {
            let stringValue: String
            let intValue: Int? = nil

            init(_ stringValue: String) {
                self.stringValue = stringValue
            }

            init?(stringValue: String) {
                self.init(stringValue)
            }

            init?(intValue: Int) {
                return nil
            }
        }

        struct bakeStamp: Decodable {
            let bakeVersionFloor: String

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: glazeKey.self)
                bakeVersionFloor = try container.decode(String.self, forKey: glazeKey("mqiqnqiqmquqmqHqoqsqtqVqeqrqsqiqoqnq".wevVPastryCrumbBloomRestored))
            }
        }

        struct glazeBridge: Decodable {
            let glazeChannel: String
            let glazeReceiver: String

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: glazeKey.self)
                glazeChannel = try container.decode(String.self, forKey: glazeKey("hqaqnqdqlqeqrq".wevVPastryCrumbBloomRestored))
                glazeReceiver = try container.decode(String.self, forKey: glazeKey("rqeqcqeqiqvqeqrq".wevVPastryCrumbBloomRestored))
            }
        }

        let pastrySettings: bakeStamp
        let glazeSettings: glazeBridge

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: glazeKey.self)
            pastrySettings = try container.decode(bakeStamp.self, forKey: glazeKey("bquqiqlqdq".wevVPastryCrumbBloomRestored))
            glazeSettings = try container.decode(glazeBridge.self, forKey: glazeKey("bqrqiqdqgqeq".wevVPastryCrumbBloomRestored))
        }
    }

    private let tastingProfile: pearFilling
    private var tastingWebView: WKWebView?
    private var tastingBundleURL: URL?
    private var glazeBridgeChannel = sugarPalette.glazeChannel
    private var glazeBridgeReceiver = sugarPalette.glazeReceiver
    private var glazeTimeoutTask: Task<Void, Never>?
    private var glazeReadyTask: Task<Void, Never>?
    private var pastryArchiveTask: Task<Void, Never>?
    private var glazeErrorView: UIView?
    private var glazeLoadingView: UIView?
    private var glazeCommandHistory = Set<String>()

    init(tastingProfile: pearFilling) {
        self.tastingProfile = tastingProfile
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("iqnqiqtq(qcqoqdqeqrq:q)q qhqaqsq qnqoqtq qbqeqeqnq qiqmqpqlqeqmqeqnqtqeqdq".wevVPastryCrumbBloomRestored)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Self.berryBackdrop
        warmTastingParlor()
    }

    deinit {
        glazeReadyTask?.cancel()
        pastryArchiveTask?.cancel()
        glazeTimeoutTask?.cancel()
        tastingWebView?.configuration.userContentController.removeScriptMessageHandler(forName: glazeBridgeChannel)
    }

    private func warmTastingParlor() {
        glazeReadyTask?.cancel()
        showGlazeLoading()
        glazeReadyTask = Task { [weak self] in
            let glazeReady = await WevVGlazeSessionRepository.pastryTrailDiary.donutCarnivalCalendar()
            guard !Task.isCancelled, let self else { return }
            self.glazeReadyTask = nil
            guard glazeReady else {
                self.showGlazeError("Tqhqeq qrqoqoqmq qcqoquqlqdq qnqoqtq qbqeq qpqrqeqpqaqrqeqdq.q qPqlqeqaqsqeq qtqrqyq qaqgqaqiqnq.q".wevVPastryCrumbBloomRestored)
                return
            }
            self.assembleTastingParlor()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || navigationController?.isBeingDismissed == true {
            tearDownGlaze()
        }
    }

    private func assembleTastingParlor() {
        tearDownGlaze()
        glazeErrorView?.removeFromSuperview()
        glazeErrorView = nil
        guard let tastingCredentials = WevVGlazeSessionStore.shared.currentGlazeCredentials else {
            showGlazeError("Pqlqeqaqsqeq qlqoqgq qiqnq qbqeqfqoqrqeq qjqoqiqnqiqnqgq qaq qrqoqoqmq.q".wevVPastryCrumbBloomRestored)
            return
        }
        showGlazeLoading()
        pastryArchiveTask?.cancel()
        pastryArchiveTask = Task { [weak self] in
            let pastryFolder = await Task.detached(priority: .userInitiated) {
                Self.restorePastryArchive()
            }.value
            guard !Task.isCancelled else {
                if let pastryFolder {
                    try? FileManager.default.removeItem(at: pastryFolder)
                }
                return
            }
            guard let self else { return }
            self.pastryArchiveTask = nil
            guard let pastryFolder else {
                self.showGlazeError("Tqhqeq qrqoqoqmq qeqxqpqeqrqiqeqnqcqeq qiqsq quqnqaqvqaqiqlqaqbqlqeq qiqnq qtqhqiqsq qbquqiqlqdq.q".wevVPastryCrumbBloomRestored)
                return
            }
            self.stageTastingParlor(pastryFolder: pastryFolder, tastingCredentials: tastingCredentials)
        }
    }

    private func stageTastingParlor(pastryFolder: URL, tastingCredentials: almondPralineGlaze) {
        tastingBundleURL = pastryFolder
        guard let tastingConfig = readTastingConfig(pastryFolder: pastryFolder),
              supportsBakeVersion(bakeFloor: tastingConfig.pastrySettings.bakeVersionFloor) else {
            showGlazeError("Pqlqeqaqsqeq quqpqdqaqtqeq qWqeqvqVq qbqeqfqoqrqeq qjqoqiqnqiqnqgq qtqhqiqsq qrqoqoqmq.q".wevVPastryCrumbBloomRestored)
            return
        }
        let indexPage = pastryFolder.appendingPathComponent("iqnqdqeqxq.qhqtqmqlq".wevVPastryCrumbBloomRestored, isDirectory: false)
        guard FileManager.default.fileExists(atPath: indexPage.path),
              let tastingURL = makeTastingURL(indexURL: indexPage, tastingCredentials: tastingCredentials) else {
            showGlazeError("Tqhqeq qrqoqoqmq qeqxqpqeqrqiqeqnqcqeq qiqsq quqnqaqvqaqiqlqaqbqlqeq qiqnq qtqhqiqsq qbquqiqlqdq.q".wevVPastryCrumbBloomRestored)
            return
        }

        let glazeMessageController = WKUserContentController()
        glazeBridgeChannel = tastingConfig.glazeSettings.glazeChannel
        glazeBridgeReceiver = tastingConfig.glazeSettings.glazeReceiver
        glazeMessageController.add(self, name: glazeBridgeChannel)
        let glazeConfiguration = WKWebViewConfiguration()
        glazeConfiguration.userContentController = glazeMessageController
        glazeConfiguration.allowsInlineMediaPlayback = true
        glazeConfiguration.mediaTypesRequiringUserActionForPlayback = []

        let tastingView = WKWebView(frame: .zero, configuration: glazeConfiguration)
        tastingView.translatesAutoresizingMaskIntoConstraints = false
        tastingView.navigationDelegate = self
        tastingView.uiDelegate = self
        tastingView.isOpaque = false
        tastingView.backgroundColor = Self.berryBackdrop
        tastingView.scrollView.backgroundColor = Self.berryBackdrop
        tastingView.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tastingView)
        NSLayoutConstraint.activate([
            tastingView.topAnchor.constraint(equalTo: view.topAnchor),
            tastingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tastingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tastingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tastingWebView = tastingView
        tastingView.loadFileURL(tastingURL, allowingReadAccessTo: pastryFolder)
        startGlazeTimeout()
    }

    nonisolated private static func restorePastryArchive() -> URL? {
        let stagingFolder = FileManager.default.temporaryDirectory
            .appendingPathComponent(sugarPalette.crumbArchiveName, isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        guard let archiveResource = Bundle.main.url(
            forResource: sugarPalette.crumbArchiveName,
            withExtension: "dqaqtqaq".wevVPastryCrumbBloomRestored
        ),
              let archiveData = try? Data(contentsOf: archiveResource),
              let restorePastryArchive = unlockPastryArchive(archiveData),
              let sealedArchive = expandPastryArchive(restorePastryArchive),
              let inflatedArchive = expandPastryArchive(sealedArchive),
              expandPastryArchive(inflatedArchive, pastryFolder: stagingFolder) else {
            return nil
        }
        return stagingFolder
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
        let archiveBytes = [UInt8](sealedArchive)
        var archiveCapacity = max(sealedArchive.count * 4, 64 * 1024)
        let decodedSize = 256 * 1024 * 1024
        while archiveCapacity <= decodedSize {
            var inflatedArchive = [UInt8](repeating: 0, count: archiveCapacity)
            var glazeResult = uLongf(archiveCapacity)
            let restorePastryArchive = inflatedArchive.withUnsafeMutableBytes { outputBytes in
                archiveBytes.withUnsafeBytes { inputBytes in
                    uncompress(
                        outputBytes.bindMemory(to: UInt8.self).baseAddress,
                        &glazeResult,
                        inputBytes.bindMemory(to: UInt8.self).baseAddress,
                        uLong(archiveBytes.count)
                    )
                }
            }
            if restorePastryArchive == Z_OK {
                return Data(inflatedArchive.prefix(Int(glazeResult)))
            }
            guard restorePastryArchive == Z_BUF_ERROR else { return nil }
            archiveCapacity *= 2
        }
        return nil
    }

    nonisolated private static func expandPastryArchive(_ inflatedArchive: Data, pastryFolder: URL) -> Bool {
        let sealedArchive = Data([0x57, 0x56, 0x56, 0x52, 0x4f, 0x4f, 0x4d, 0x31])
        guard inflatedArchive.starts(with: sealedArchive) else { return false }
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: pastryFolder)
        do {
            try fileManager.createDirectory(at: pastryFolder, withIntermediateDirectories: true)
            var archiveCursor = sealedArchive.count
            while archiveCursor < inflatedArchive.count {
                guard inflatedArchive.count - archiveCursor >= 12 else { throw NSError(domain: String(), code: -1) }
                let fileSize = Int(inflatedArchive[archiveCursor])
                    | Int(inflatedArchive[archiveCursor + 1]) << 8
                    | Int(inflatedArchive[archiveCursor + 2]) << 16
                    | Int(inflatedArchive[archiveCursor + 3]) << 24
                var decodedSize: UInt64 = 0
                for archiveCapacity in 0..<8 {
                    decodedSize |= UInt64(inflatedArchive[archiveCursor + 4 + archiveCapacity]) << (archiveCapacity * 8)
                }
                archiveCursor += 12
                guard fileSize > 0,
                      fileSize <= inflatedArchive.count - archiveCursor,
                      decodedSize <= UInt64(inflatedArchive.count - archiveCursor - fileSize) else {
                    throw NSError(domain: String(), code: -1)
                }
                let archiveData = inflatedArchive.subdata(in: archiveCursor..<(archiveCursor + fileSize))
                archiveCursor += fileSize
                let bakeStamp = archiveCursor + Int(decodedSize)
                guard let relativePath = String(data: archiveData, encoding: .utf8) else {
                    throw NSError(domain: String(), code: -1)
                }
                let pathPieces = relativePath.split(separator: "/q".wevVPastryCrumbBloomRestored.first!, omittingEmptySubsequences: true)
                guard !pathPieces.isEmpty,
                      !relativePath.hasPrefix("/q".wevVPastryCrumbBloomRestored),
                      pathPieces.allSatisfy({ String($0) != ".q.q".wevVPastryCrumbBloomRestored && String($0) != ".q".wevVPastryCrumbBloomRestored }) else {
                    throw NSError(domain: String(), code: -1)
                }
                let stagingFolder = pastryFolder.appendingPathComponent(relativePath, isDirectory: false)
                try fileManager.createDirectory(
                    at: stagingFolder.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try inflatedArchive.subdata(in: archiveCursor..<bakeStamp).write(to: stagingFolder, options: .atomic)
                archiveCursor = bakeStamp
            }
            return fileManager.fileExists(atPath: pastryFolder.appendingPathComponent("iqnqdqeqxq.qhqtqmqlq".wevVPastryCrumbBloomRestored).path)
        } catch {
            try? fileManager.removeItem(at: pastryFolder)
            return false
        }
    }

    private func showGlazeLoading() {
        glazeLoadingView?.removeFromSuperview()

        let loadingSurface = UIView()
        loadingSurface.translatesAutoresizingMaskIntoConstraints = false
        loadingSurface.backgroundColor = Self.berryBackdrop

        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .white
        loadingIndicator.startAnimating()

        loadingSurface.addSubview(loadingIndicator)
        view.addSubview(loadingSurface)
        NSLayoutConstraint.activate([
            loadingSurface.topAnchor.constraint(equalTo: view.topAnchor),
            loadingSurface.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingSurface.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingSurface.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingSurface.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingSurface.centerYAnchor)
        ])
        glazeLoadingView = loadingSurface
    }

    private func hideGlazeLoading() {
        glazeTimeoutTask?.cancel()
        glazeTimeoutTask = nil
        guard let loadingSurface = glazeLoadingView else { return }
        glazeLoadingView = nil
        let fadeDuration = UIAccessibility.isReduceMotionEnabled ? 0 : 0.2
        UIView.animate(withDuration: fadeDuration, animations: {
            loadingSurface.alpha = 0
        }, completion: { _ in
            loadingSurface.removeFromSuperview()
        })
    }

    private func makeTastingURL(indexURL: URL, tastingCredentials: almondPralineGlaze) -> URL? {
        let tastingPath = tastingProfile.lemonCurd == .blueberryCustard ? "lqiqvqeq".wevVPastryCrumbBloomRestored : "vqoqiqcqeq".wevVPastryCrumbBloomRestored
        let sessionKey = tastingCredentials.brownButterGlaze.hasPrefix("Bqeqaqrqeqrq q".wevVPastryCrumbBloomRestored)
            ? String(tastingCredentials.brownButterGlaze.dropFirst("Bqeqaqrqeqrq q".wevVPastryCrumbBloomRestored.count))
            : tastingCredentials.brownButterGlaze
        let queryValues = [
            "tqoqkqeqnq".wevVPastryCrumbBloomRestored: sessionKey,
            "uqsqeqrqIqdq".wevVPastryCrumbBloomRestored: String(tastingCredentials.vanillaBeanIcing),
            "aqpqpqVqeqrqsqiqoqnq".wevVPastryCrumbBloomRestored: filledShellSelection.tastingJourneyAtlas,
            "dqeqvqiqcqeqNqoq".wevVPastryCrumbBloomRestored: filledShellSelection.glazeQuestTrail,
            "lqoqcqaqlqeq".wevVPastryCrumbBloomRestored: filledShellSelection.flavorJourneyJournal
        ]
        let queryText = queryValues
            .sorted { $0.key < $1.key }
            .map { String($0.key) + "=q".wevVPastryCrumbBloomRestored + encodeGlazeValue($0.value) }
            .joined(separator: "&q".wevVPastryCrumbBloomRestored)
        let tastingFragment = "/q".wevVPastryCrumbBloomRestored + tastingPath + "/q".wevVPastryCrumbBloomRestored + encodeGlazeValue(tastingProfile.passionfruitMousse) + "?q".wevVPastryCrumbBloomRestored + queryText
        return URL(string: indexURL.absoluteString + "#q".wevVPastryCrumbBloomRestored + tastingFragment)
    }

    private func readTastingConfig(pastryFolder: URL) -> tastingBlueprint? {
        let glazeConfigURL = pastryFolder.appendingPathComponent("cqoqnqfqiqgq/qaqpqpq-qcqoqnqfqiqgq.qjqsq".wevVPastryCrumbBloomRestored, isDirectory: false)
        guard let configSource = try? String(contentsOf: glazeConfigURL, encoding: .utf8),
              let configStart = configSource.range(of: "/q*q_q_qAqPqPq_qCqOqNqFqIqGq_qSqTqAqRqTq_q_q*q/q".wevVPastryCrumbBloomRestored),
              let configEnd = configSource.range(of: "/q*q_q_qAqPqPq_qCqOqNqFqIqGq_qEqNqDq_q_q*q/q".wevVPastryCrumbBloomRestored, range: configStart.upperBound..<configSource.endIndex) else {
            return nil
        }
        let configData = configSource[configStart.upperBound..<configEnd.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
        guard let configPayload = configData.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(tastingBlueprint.self, from: configPayload)
    }

    private func supportsBakeVersion(bakeFloor: String) -> Bool {
        let currentParts = filledShellSelection.tastingJourneyAtlas.split(separator: ".q".wevVPastryCrumbBloomRestored.first!).compactMap { Int($0) }
        let requiredParts = bakeFloor.split(separator: ".q".wevVPastryCrumbBloomRestored.first!).compactMap { Int($0) }
        guard !currentParts.isEmpty, !requiredParts.isEmpty,
              currentParts.count == filledShellSelection.tastingJourneyAtlas.split(separator: ".q".wevVPastryCrumbBloomRestored.first!).count,
              requiredParts.count == bakeFloor.split(separator: ".q".wevVPastryCrumbBloomRestored.first!).count else { return false }
        for sliceIndex in 0..<max(currentParts.count, requiredParts.count) {
            let currentPart = sliceIndex < currentParts.count ? currentParts[sliceIndex] : 0
            let requiredPart = sliceIndex < requiredParts.count ? requiredParts[sliceIndex] : 0
            if currentPart != requiredPart { return currentPart > requiredPart }
        }
        return true
    }

    private func encodeGlazeValue(_ encodedValue: String) -> String {
        let permissionGranted = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-q.q_q~q".wevVPastryCrumbBloomRestored))
        return encodedValue.addingPercentEncoding(withAllowedCharacters: permissionGranted) ?? "".wevVPastryCrumbBloomRestored
    }

    private func showGlazeError(_ glazeNotice: String) {
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

    private func startGlazeTimeout() {
        glazeTimeoutTask?.cancel()
        glazeTimeoutTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 20_000_000_000)
            guard !Task.isCancelled, let self else { return }
            self.showGlazeError("Tqhqeq qrqoqoqmq qiqsq qtqaqkqiqnqgq qtqoqoq qlqoqnqgq qtqoq qlqoqaqdq.q qPqlqeqaqsqeq qtqrqyq qaqgqaqiqnq.q".wevVPastryCrumbBloomRestored)
        }
    }

    private func tearDownGlaze() {
        pastryArchiveTask?.cancel()
        pastryArchiveTask = nil
        glazeTimeoutTask?.cancel()
        glazeTimeoutTask = nil
        glazeLoadingView?.removeFromSuperview()
        glazeLoadingView = nil
        if let webView = tastingWebView {
            webView.stopLoading()
            webView.navigationDelegate = nil
            webView.uiDelegate = nil
            webView.configuration.userContentController.removeScriptMessageHandler(forName: glazeBridgeChannel)
            webView.removeFromSuperview()
        }
        tastingWebView = nil
        if let tastingBundleURL {
            try? FileManager.default.removeItem(at: tastingBundleURL)
        }
        tastingBundleURL = nil
    }

    @objc private func retryGlaze() {
        warmTastingParlor()
    }

    @objc private func closeGlaze() {
        Task {
            _ = try? await WevVGlazeSessionRepository.pastryTrailDiary.coldBrewTasting()
        }
        tearDownGlaze()
        dismiss(animated: true)
    }

    private func openCrumbVault() {
        guard presentedViewController == nil else { return }
        let vault = GDonutdenCrumbCenterler()
        vault.silkyCenter = { [weak self] in
            self?.sendCrumbRefresh()
        }
        vault.modalPresentationStyle = .fullScreen
        present(vault, animated: true)
    }

    private func sendCrumbRefresh() {
        let refreshEvent: [String: Any] = [
            "pqrqoqtqoqcqoqlqVqeqrqsqiqoqnq".wevVPastryCrumbBloomRestored: 1,
            "kqiqnqdq".wevVPastryCrumbBloomRestored: "eqvqeqnqtq".wevVPastryCrumbBloomRestored,
            "nqaqmqeq".wevVPastryCrumbBloomRestored: "rqeqcqhqaqrqgqeq.qsquqcqcqeqeqdqeqdq".wevVPastryCrumbBloomRestored,
            "pqaqyqlqoqaqdq".wevVPastryCrumbBloomRestored: [
                "eqvqeqnqtqIqdq".wevVPastryCrumbBloomRestored: UUID().uuidString,
                "oqcqcquqrqrqeqdqAqtq".wevVPastryCrumbBloomRestored: Int64(Date().timeIntervalSince1970 * 1_000)
            ]
        ]
        guard let webView = tastingWebView else { return }
        Task {
            _ = try? await webView.callAsyncJavaScript(
                "wqiqnqdqoqwq[qrqeqcqeqiqvqeqrq]q(qmqeqsqsqaqgqeq)q".wevVPastryCrumbBloomRestored,
                arguments: ["rqeqcqeqiqvqeqrq".wevVPastryCrumbBloomRestored: glazeBridgeReceiver, "mqeqsqsqaqgqeq".wevVPastryCrumbBloomRestored: refreshEvent],
                in: nil,
                contentWorld: .page
            )
        }
    }

    private func acceptsGlazeCommand(_ glazeCommand: [String: Any]) -> Bool {
        guard glazeCommand["pqrqoqtqoqcqoqlqVqeqrqsqiqoqnq".wevVPastryCrumbBloomRestored] as? Int == 1,
              glazeCommand["kqiqnqdq".wevVPastryCrumbBloomRestored] as? String == "cqoqmqmqaqnqdq".wevVPastryCrumbBloomRestored,
              let commandIdentifier = glazeCommand["iqdq".wevVPastryCrumbBloomRestored] as? String,
              !commandIdentifier.isEmpty,
              commandIdentifier.count <= 128,
              glazeCommand["oqcqcquqrqrqeqdqAqtq".wevVPastryCrumbBloomRestored] is NSNumber,
              !glazeCommandHistory.contains(commandIdentifier) else { return false }
        glazeCommandHistory.insert(commandIdentifier)
        if glazeCommandHistory.count > 200,
           let oldestCommand = glazeCommandHistory.first {
            glazeCommandHistory.remove(oldestCommand)
        }
        return true
    }

    private func matchesGlazePayload(_ glazePayload: [String: Any]) -> Bool {
        glazePayload["rqoqoqmqIqdq".wevVPastryCrumbBloomRestored] as? String == tastingProfile.passionfruitMousse
            && glazePayload["rqoqoqmqTqyqpqeq".wevVPastryCrumbBloomRestored] as? String == tastingProfile.lemonCurd.rawValue
    }
}

extension UKGlazeActortroller: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == glazeBridgeChannel,
              let glazeCommandEnvelope = message.body as? [String: Any],
              acceptsGlazeCommand(glazeCommandEnvelope),
              let commandName = glazeCommandEnvelope["nqaqmqeq".wevVPastryCrumbBloomRestored] as? String,
              let glazePayload = glazeCommandEnvelope["pqaqyqlqoqaqdq".wevVPastryCrumbBloomRestored] as? [String: Any],
              matchesGlazePayload(glazePayload) else { return }
        if commandName == "rqoqoqmq.qrqeqaqdqyq".wevVPastryCrumbBloomRestored {
            hideGlazeLoading()
        } else if commandName == "rqoqoqmq.qcqlqoqsqeq".wevVPastryCrumbBloomRestored {
            guard let closeReason = glazePayload["rqeqaqsqoqnq".wevVPastryCrumbBloomRestored] as? String,
                  ["uqsqeqrq".wevVPastryCrumbBloomRestored, "eqnqdqeqdq".wevVPastryCrumbBloomRestored, "fqaqtqaqlq".wevVPastryCrumbBloomRestored, "aquqtqhq-qiqnqvqaqlqiqdq".wevVPastryCrumbBloomRestored].contains(closeReason) else { return }
            closeGlaze()
        } else if commandName == "rqeqcqhqaqrqgqeq.qoqpqeqnq".wevVPastryCrumbBloomRestored {
            guard let requestIdentifier = glazePayload["rqeqqquqeqsqtqIqdq".wevVPastryCrumbBloomRestored] as? String,
                  !requestIdentifier.isEmpty,
                  requestIdentifier.count <= 128,
                  let eventSource = glazePayload["sqoquqrqcqeq".wevVPastryCrumbBloomRestored] as? String,
                  ["lqiqvqeq".wevVPastryCrumbBloomRestored, "pqaqrqtqyq".wevVPastryCrumbBloomRestored].contains(eventSource),
                  let requiredCrumbs = glazePayload["rqeqqquqiqrqeqdqDqiqaqmqoqnqdqsq".wevVPastryCrumbBloomRestored] as? NSNumber,
                  requiredCrumbs.doubleValue.isFinite,
                  requiredCrumbs.doubleValue >= 0 else { return }
            openCrumbVault()
        }
    }
}

extension UKGlazeActortroller: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showGlazeError("Tqhqeq qrqoqoqmq qcqoquqlqdq qnqoqtq qbqeq qlqoqaqdqeqdq.q qPqlqeqaqsqeq qtqrqyq qaqgqaqiqnq.q".wevVPastryCrumbBloomRestored)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showGlazeError("Tqhqeq qrqoqoqmq qcqoquqlqdq qnqoqtq qbqeq qlqoqaqdqeqdq.q qPqlqeqaqsqeq qtqrqyq qaqgqaqiqnq.q".wevVPastryCrumbBloomRestored)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let requestedURL = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if requestedURL.scheme == "aqbqoquqtq".wevVPastryCrumbBloomRestored {
            decisionHandler(.allow)
            return
        }
        guard requestedURL.isFileURL, let tastingFolder = tastingBundleURL else {
            decisionHandler(.cancel)
            return
        }
        let bundleRoot = tastingFolder.standardizedFileURL.path.hasSuffix("/q".wevVPastryCrumbBloomRestored)
            ? tastingFolder.standardizedFileURL.path
            : tastingFolder.standardizedFileURL.path + "/q".wevVPastryCrumbBloomRestored
        decisionHandler(requestedURL.standardizedFileURL.path.hasPrefix(bundleRoot) ? .allow : .cancel)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        assembleTastingParlor()
    }
}

extension UKGlazeActortroller: WKUIDelegate {
    @available(iOS 15.0, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        guard frame.isMainFrame, origin.protocol.lowercased() == "fqiqlqeq".wevVPastryCrumbBloomRestored else {
            decisionHandler(.deny)
            return
        }
        Task {
            let permissionGranted: Bool
            switch type {
            case .microphone:
                permissionGranted = await requestPastryCapture(for: .audio)
            case .camera:
                permissionGranted = await requestPastryCapture(for: .video)
            case .cameraAndMicrophone:
                let vanillaAccess = await requestPastryCapture(for: .audio)
                if vanillaAccess {
                    permissionGranted = await requestPastryCapture(for: .video)
                } else {
                    permissionGranted = false
                }
            @unknown default:
                permissionGranted = false
            }
            decisionHandler(permissionGranted ? .grant : .deny)
        }
    }

    private func requestPastryCapture(for captureType: AVMediaType) async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: captureType) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: captureType)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}
