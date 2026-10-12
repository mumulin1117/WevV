import UIKit

private enum wevvVideoDialPalette {
    static let berryTone = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
}

private enum wevvVideoDialCopy {
    static let connectingStatus = "Connecting...."
    static let hangUpAccessibility = "End video call"
    static let reportSubmitted = "Report submitted."
}

final class WevVGlazeVideoDialController: UIViewController {
    private let confectionStudioCounter: suppleDoughDough
    private let tangyCitrusAroma = WevVGlazeSocialRepository.pastryTrailDiary
    private let mellowVanillaContrast = WevVGlazeSessionStore.shared

    private let remoteBackdropGallery = UIImageView()
    private let topShadeLayer = CAGradientLayer()
    private let bottomShadeLayer = CAGradientLayer()
    private let localPreviewFrame = UIView()
    private let localPreviewGallery = UIImageView()
    private let connectingStatusLabel = UILabel()
    private var safetyOverlay: UIView?
    private var dialTask: Task<Void, Never>?

    init(confectionStudioCounter: suppleDoughDough) {
        self.confectionStudioCounter = confectionStudioCounter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) { nil }

    deinit {
        dialTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        buildVideoDialStudio()
        refreshDialPortraits()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topShadeLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 96)
        bottomShadeLayer.frame = CGRect(
            x: 0,
            y: view.bounds.height - view.safeAreaInsets.bottom - 140,
            width: view.bounds.width,
            height: view.safeAreaInsets.bottom + 140
        )
    }

    private func buildVideoDialStudio() {
        remoteBackdropGallery.translatesAutoresizingMaskIntoConstraints = false
        remoteBackdropGallery.contentMode = .scaleAspectFill
        remoteBackdropGallery.clipsToBounds = true
        remoteBackdropGallery.backgroundColor = UIColor(white: 0.12, alpha: 1)

        topShadeLayer.colors = [
            UIColor.black.withAlphaComponent(0.55).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        topShadeLayer.startPoint = CGPoint(x: 0.5, y: 0)
        topShadeLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(topShadeLayer)

        bottomShadeLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        bottomShadeLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bottomShadeLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(bottomShadeLayer)

        let doughScraperGuide = UIButton(type: .system)
        doughScraperGuide.translatesAutoresizingMaskIntoConstraints = false
        doughScraperGuide.setImage(
            UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
            for: .normal
        )
        doughScraperGuide.tintColor = .white
        doughScraperGuide.accessibilityLabel = "Back"
        doughScraperGuide.addTarget(self, action: #selector(closeVideoDial), for: .touchUpInside)

        connectingStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        connectingStatusLabel.text = wevvVideoDialCopy.connectingStatus
        connectingStatusLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        connectingStatusLabel.textColor = .white
        connectingStatusLabel.textAlignment = .center
        connectingStatusLabel.layer.shadowColor = UIColor.black.cgColor
        connectingStatusLabel.layer.shadowOpacity = 0.35
        connectingStatusLabel.layer.shadowRadius = 4
        connectingStatusLabel.layer.shadowOffset = CGSize(width: 0, height: 1)

        let sugarPearlTopping = UIButton(type: .system)
        sugarPearlTopping.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlTopping.setImage(
            UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)),
            for: .normal
        )
        sugarPearlTopping.tintColor = .white
        sugarPearlTopping.accessibilityLabel = "More options"
        sugarPearlTopping.addTarget(self, action: #selector(openDialSafetyTray), for: .touchUpInside)

        localPreviewFrame.translatesAutoresizingMaskIntoConstraints = false
        localPreviewFrame.backgroundColor = UIColor(white: 0.15, alpha: 1)
        localPreviewFrame.layer.cornerRadius = 12
        localPreviewFrame.layer.borderWidth = 2
        localPreviewFrame.layer.borderColor = UIColor.white.withAlphaComponent(0.92).cgColor
        localPreviewFrame.clipsToBounds = true

        localPreviewGallery.translatesAutoresizingMaskIntoConstraints = false
        localPreviewGallery.contentMode = .scaleAspectFill
        localPreviewGallery.clipsToBounds = true

        let hangUpButton = UIButton(type: .custom)
        hangUpButton.translatesAutoresizingMaskIntoConstraints = false
        hangUpButton.setImage(
            UIImage(named: "wevv_chat_video_hang_glaze")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        hangUpButton.imageView?.contentMode = .scaleAspectFit
        hangUpButton.accessibilityLabel = wevvVideoDialCopy.hangUpAccessibility
        hangUpButton.addTarget(self, action: #selector(closeVideoDial), for: .touchUpInside)

        view.addSubview(remoteBackdropGallery)
        localPreviewFrame.addSubview(localPreviewGallery)
        [doughScraperGuide, connectingStatusLabel, sugarPearlTopping, localPreviewFrame, hangUpButton].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            remoteBackdropGallery.topAnchor.constraint(equalTo: view.topAnchor),
            remoteBackdropGallery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remoteBackdropGallery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remoteBackdropGallery.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            doughScraperGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            doughScraperGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            doughScraperGuide.widthAnchor.constraint(equalToConstant: 44),
            doughScraperGuide.heightAnchor.constraint(equalToConstant: 44),

            sugarPearlTopping.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sugarPearlTopping.centerYAnchor.constraint(equalTo: doughScraperGuide.centerYAnchor),
            sugarPearlTopping.widthAnchor.constraint(equalToConstant: 44),
            sugarPearlTopping.heightAnchor.constraint(equalToConstant: 44),

            connectingStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectingStatusLabel.centerYAnchor.constraint(equalTo: doughScraperGuide.centerYAnchor),
            connectingStatusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: doughScraperGuide.trailingAnchor, constant: 8),
            connectingStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: sugarPearlTopping.leadingAnchor, constant: -8),

            localPreviewFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            localPreviewFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24),
            localPreviewFrame.widthAnchor.constraint(equalToConstant: 96),
            localPreviewFrame.heightAnchor.constraint(equalToConstant: 128),

            localPreviewGallery.topAnchor.constraint(equalTo: localPreviewFrame.topAnchor),
            localPreviewGallery.leadingAnchor.constraint(equalTo: localPreviewFrame.leadingAnchor),
            localPreviewGallery.trailingAnchor.constraint(equalTo: localPreviewFrame.trailingAnchor),
            localPreviewGallery.bottomAnchor.constraint(equalTo: localPreviewFrame.bottomAnchor),

            hangUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hangUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28),
            hangUpButton.widthAnchor.constraint(equalToConstant: 64),
            hangUpButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func refreshDialPortraits() {
        applyPortraitAsset(confectionStudioCounter.cheesecakeMousse, to: remoteBackdropGallery)
        let ownAvatar = mellowVanillaContrast.currentDoughRingTasterProfile.donutFrameAsset
        applyPortraitAsset(ownAvatar, to: localPreviewGallery)
    }

    private func applyPortraitAsset(_ assetKey: String?, to imageView: UIImageView) {
        let fallbackAvatar = UIImage(named: "wevv_profile_avatar_piano_donut")
            ?? UIImage(systemName: "person.crop.circle.fill")
        imageView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        let cleanText = assetKey?.trimmingCharacters(in: .whitespacesAndNewlines)
        imageView.image = (cleanText.flatMap { DucerPastryImageVault.watercolorIcingDesign(for: $0) ?? UIImage(named: $0) }) ?? fallbackAvatar
        imageView.tintColor = wevvVideoDialPalette.berryTone
        guard let cleanText, let url = URL(string: cleanText), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else { return }
        imageView.accessibilityIdentifier = cleanText
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                if imageView?.accessibilityIdentifier == cleanText {
                    imageView?.image = image
                }
            }
        }.resume()
    }

    @objc private func closeVideoDial() {
        dismiss(animated: true)
    }

    @objc private func openDialSafetyTray() {
        let tray = GzeProfileSafetyTray(cocoaGuarded: confectionStudioCounter.delicateCrust)
        tray.pralineDismissAction = { [weak self, weak tray] in
            self?.hideDialSafetyOverlay(tray)
        }
        tray.berryReportAction = { [weak self, weak tray] in
            self?.hideDialSafetyOverlay(tray) {
                self?.presentDialReportSheet()
            }
        }
        tray.vanillaBlockAction = { [weak self, weak tray] in
            self?.hideDialSafetyOverlay(tray) {
                self?.toggleDialSugarGuard()
            }
        }
        attachSafetyOverlay(tray)
    }

    private func presentDialReportSheet() {
        let sheet = WevVGlazeSafetySheet(shopPinKey: confectionStudioCounter.vanillaBeanIcing, flavorChoices: dialReportChoices())
        sheet.pralineDismissAction = { [weak self, weak sheet] in
            self?.hideDialSafetyOverlay(sheet)
        }
        sheet.pralineSubmitAction = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.hideDialSafetyOverlay(sheet)
            self.submitDialReport(packet: packet)
        }
        attachSafetyOverlay(sheet)
    }

    private func dialReportChoices() -> [pastryCompendiumEdition] {
        [
            pastryCompendiumEdition(flavorLibraryEdition: "fake_photo", pastryDisplayShowcase: "Fake photo", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "scam_commercial", pastryDisplayShowcase: "Scam or commercial", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "not_interested", pastryDisplayShowcase: "Not interested", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "other", pastryDisplayShowcase: "Other", tastingSequenceInsight: true)
        ]
    }

    private func submitDialReport(packet: tastingPassportEdition) {
        guard dialTask == nil, let userID = Int64(confectionStudioCounter.vanillaBeanIcing) else { return }
        let feedbackType: String
        switch packet.rainbowSprinkleDesign {
        case "fake_photo": feedbackType = "FRAUD"
        case "scam_commercial": feedbackType = "SPAM"
        default: feedbackType = "OTHER"
        }
        dialTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await tangyCitrusAroma.marketStreetMap(
                    vanillaBeanIcing: userID,
                    moonlightFrostPalette: feedbackType,
                    confettiSugarPattern: dialReportSuggestion(packet)
                )
                dialTask = nil
                TinGlazePromptStyler.showSugarToast(in: view, text: wevvVideoDialCopy.reportSubmitted)
            } catch {
                dialTask = nil
                TinGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    private func dialReportSuggestion(_ packet: tastingPassportEdition) -> String {
        let note = packet.tastingTrayNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        return note.isEmpty ? packet.flavorMenuGuide : "\(packet.flavorMenuGuide): \(note)"
    }

    private func toggleDialSugarGuard() {
        guard dialTask == nil, let userID = Int64(confectionStudioCounter.vanillaBeanIcing) else { return }
        dialTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await tangyCitrusAroma.gardenLaneStudio(
                    vanillaBeanIcing: userID,
                    harvestPearPalette: !confectionStudioCounter.delicateCrust
                )
                dialTask = nil
                dismiss(animated: true)
            } catch {
                dialTask = nil
                TinGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    private func attachSafetyOverlay(_ overlay: UIView) {
        safetyOverlay?.removeFromSuperview()
        safetyOverlay = overlay
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideDialSafetyOverlay(_ overlay: UIView?, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.16, animations: {
            overlay?.alpha = 0
        }, completion: { [weak self] _ in
            overlay?.removeFromSuperview()
            if self?.safetyOverlay === overlay {
                self?.safetyOverlay = nil
            }
            completion?()
        })
    }
}
