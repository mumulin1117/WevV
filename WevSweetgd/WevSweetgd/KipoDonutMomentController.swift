import UIKit

final class KipoDonutMomentController: UIViewController, UITextFieldDelegate {
    var cocoaKissExperience: (() -> Void)?

    private let tangyCitrusAroma = WevVGlazeSocialRepository.pastryTrailDiary
    private let mellowVanillaContrast = WevVGlazeSessionStore.shared
    private var richCocoaFlavor: butteryTexture
    private var fragrantJasmineFlavor: [featherlightBite] = []
    private var herbalLavenderEssence: Task<Void, Never>?

    private let goldenHourFrame = UIScrollView()
    private let frostingDetailFrame = UIStackView()
    private let portraitPastryGallery = UIImageView()
    private let flavorMenuGuide = UILabel()
    private let honeyCrullerCruller = UIButton(type: .system)
    private let daylightDisplayScene = UIImageView()
    private let tastingTrayNotes = UILabel()
    private let berryBurstNotebook = UIButton(type: .system)
    private let donutDiarySelection = UIButton(type: .system)
    private let butterAromaNotes = UILabel()
    private let textureContrastNotes = UIStackView()
    private let cocoaDrinkComplement = UITextField()
    private let pastryCounterCollection = UIView()
    private var crispEdgeCrust: NSLayoutConstraint?

    init(richCocoaFlavor: butteryTexture) {
        self.richCocoaFlavor = richCocoaFlavor
        super.init(nibName: nil, bundle: nil)
    }

    init(vanillaStrawberryDuet: WevVDonutSnapshot) {
        richCocoaFlavor = butteryTexture(
            coconutCenter: Int64(vanillaStrawberryDuet.sprinkleJarKey) ?? 0,
            vanillaBeanIcing: Int64(vanillaStrawberryDuet.tasterBloom.donutPinKey) ?? 0,
            gingerHoneyDrizzle: vanillaStrawberryDuet.tasterBloom.name,
            cheesecakeMousse: vanillaStrawberryDuet.tasterBloom.donutFrameAsset,
            caramelCurd: vanillaStrawberryDuet.tastingText,
            passionfruitFilling: [vanillaStrawberryDuet.donutBackdropAsset],
            limeCream: 0,
            apricotCenter: 0,
            figCustard: vanillaStrawberryDuet.freshnessTagText,
            mascarponeCream: false,
            cherryCompote: false,
            custardMousse: false,
            peachFilling: nil,
            pearJam: nil
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        artisanShowcase()
        glazeGalleryGuide()
        doughMaturationStudy()
        freshMixSequence()
    }

    deinit {
        herbalLavenderEssence?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func artisanShowcase() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.96, alpha: 1)
        let pastelBackdropGallery = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        pastelBackdropGallery.translatesAutoresizingMaskIntoConstraints = false
        pastelBackdropGallery.contentMode = .scaleAspectFill
        view.addSubview(pastelBackdropGallery)

        goldenHourFrame.translatesAutoresizingMaskIntoConstraints = false
        goldenHourFrame.alwaysBounceVertical = true
        goldenHourFrame.keyboardDismissMode = .interactive
        goldenHourFrame.contentInset.bottom = 90
        goldenHourFrame.verticalScrollIndicatorInsets.bottom = 90
        view.addSubview(goldenHourFrame)

        frostingDetailFrame.translatesAutoresizingMaskIntoConstraints = false
        frostingDetailFrame.axis = .vertical
        frostingDetailFrame.spacing = 12
        goldenHourFrame.addSubview(frostingDetailFrame)

        rimLightingGallery(daylightDisplayScene, cornerRadius: 16)
        daylightDisplayScene.backgroundColor = UIColor(red: 0.97, green: 0.84, blue: 0.93, alpha: 1)
        tastingTrayNotes.translatesAutoresizingMaskIntoConstraints = false
        tastingTrayNotes.numberOfLines = 0
        tastingTrayNotes.font = .systemFont(ofSize: 13, weight: .regular)
        tastingTrayNotes.textColor = UIColor(red: 0.16, green: 0.12, blue: 0.13, alpha: 1)

        let tastingFlightShowcase = UIStackView(arrangedSubviews: [berryBurstNotebook, donutDiarySelection, UIView()])
        tastingFlightShowcase.translatesAutoresizingMaskIntoConstraints = false
        tastingFlightShowcase.axis = .horizontal
        tastingFlightShowcase.spacing = 15
        carefulCrimpSequence(berryBurstNotebook, action: #selector(sugarCrystallizationStudy))
        carefulCrimpSequence(donutDiarySelection, action: #selector(butterEmulsionStudy))

        butterAromaNotes.translatesAutoresizingMaskIntoConstraints = false
        butterAromaNotes.font = .systemFont(ofSize: 16, weight: .bold)
        butterAromaNotes.textColor = UIColor(red: 0.12, green: 0.08, blue: 0.1, alpha: 1)
        textureContrastNotes.translatesAutoresizingMaskIntoConstraints = false
        textureContrastNotes.axis = .vertical
        textureContrastNotes.spacing = 10

        let bakeryWindowAtelier = ringDisplayStudio()
        [bakeryWindowAtelier, daylightDisplayScene, tastingTrayNotes, tastingFlightShowcase, butterAromaNotes, textureContrastNotes].forEach(frostingDetailFrame.addArrangedSubview)
        frostingDetailFrame.setCustomSpacing(8, after: bakeryWindowAtelier)
        frostingDetailFrame.setCustomSpacing(10, after: daylightDisplayScene)
        frostingDetailFrame.setCustomSpacing(7, after: tastingTrayNotes)
        pastryWorkshopCounter()

        NSLayoutConstraint.activate([
            pastelBackdropGallery.topAnchor.constraint(equalTo: view.topAnchor),
            pastelBackdropGallery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastelBackdropGallery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastelBackdropGallery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            goldenHourFrame.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            goldenHourFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goldenHourFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goldenHourFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            frostingDetailFrame.topAnchor.constraint(equalTo: goldenHourFrame.contentLayoutGuide.topAnchor, constant: 8),
            frostingDetailFrame.leadingAnchor.constraint(equalTo: goldenHourFrame.frameLayoutGuide.leadingAnchor, constant: 20),
            frostingDetailFrame.trailingAnchor.constraint(equalTo: goldenHourFrame.frameLayoutGuide.trailingAnchor, constant: -20),
            frostingDetailFrame.bottomAnchor.constraint(equalTo: goldenHourFrame.contentLayoutGuide.bottomAnchor, constant: -104),
            daylightDisplayScene.heightAnchor.constraint(equalTo: daylightDisplayScene.widthAnchor, multiplier: 0.78)
        ])

        let sugarPearlAccent = UITapGestureRecognizer(target: self, action: #selector(handDipRhythm))
        sugarPearlAccent.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarPearlAccent)
    }

    private func ringDisplayStudio() -> UIView {
        let bakeryWindowAtelier = UIView()
        bakeryWindowAtelier.translatesAutoresizingMaskIntoConstraints = false
        let doughScraperGuide = UIButton(type: .system)
        doughScraperGuide.translatesAutoresizingMaskIntoConstraints = false
        doughScraperGuide.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        doughScraperGuide.tintColor = .black
        doughScraperGuide.addTarget(self, action: #selector(slowRiseSequence), for: .touchUpInside)

        rimLightingGallery(portraitPastryGallery, cornerRadius: 16)
        portraitPastryGallery.isUserInteractionEnabled = true
        portraitPastryGallery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(worldDoughnutNotebook)))
        flavorMenuGuide.translatesAutoresizingMaskIntoConstraints = false
        flavorMenuGuide.font = .systemFont(ofSize: 14, weight: .bold)
        flavorMenuGuide.textColor = UIColor(red: 0.12, green: 0.05, blue: 0.08, alpha: 1)
        flavorMenuGuide.adjustsFontSizeToFitWidth = true
        flavorMenuGuide.minimumScaleFactor = 0.75

        honeyCrullerCruller.translatesAutoresizingMaskIntoConstraints = false
        honeyCrullerCruller.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        honeyCrullerCruller.layer.cornerRadius = 14
        honeyCrullerCruller.clipsToBounds = true
        honeyCrullerCruller.addTarget(self, action: #selector(yeastActivityStudy), for: .touchUpInside)

        let citrusPeelGarnish = UIButton(type: .system)
        citrusPeelGarnish.translatesAutoresizingMaskIntoConstraints = false
        citrusPeelGarnish.setImage(UIImage(systemName: "exclamationmark.triangle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)), for: .normal)
        citrusPeelGarnish.tintColor = UIColor(red: 1, green: 0.25, blue: 0.58, alpha: 1)
        citrusPeelGarnish.addTarget(self, action: #selector(heritageBakingNotebook), for: .touchUpInside)

        [doughScraperGuide, portraitPastryGallery, flavorMenuGuide, citrusPeelGarnish, honeyCrullerCruller].forEach(bakeryWindowAtelier.addSubview)
        NSLayoutConstraint.activate([
            bakeryWindowAtelier.heightAnchor.constraint(equalToConstant: 36),
            doughScraperGuide.leadingAnchor.constraint(equalTo: bakeryWindowAtelier.leadingAnchor, constant: -4),
            doughScraperGuide.centerYAnchor.constraint(equalTo: bakeryWindowAtelier.centerYAnchor),
            doughScraperGuide.widthAnchor.constraint(equalToConstant: 28),
            doughScraperGuide.heightAnchor.constraint(equalToConstant: 36),
            portraitPastryGallery.leadingAnchor.constraint(equalTo: doughScraperGuide.trailingAnchor, constant: 8),
            portraitPastryGallery.centerYAnchor.constraint(equalTo: bakeryWindowAtelier.centerYAnchor),
            portraitPastryGallery.widthAnchor.constraint(equalToConstant: 32),
            portraitPastryGallery.heightAnchor.constraint(equalToConstant: 32),
            flavorMenuGuide.leadingAnchor.constraint(equalTo: portraitPastryGallery.trailingAnchor, constant: 10),
            flavorMenuGuide.centerYAnchor.constraint(equalTo: portraitPastryGallery.centerYAnchor),
            flavorMenuGuide.trailingAnchor.constraint(lessThanOrEqualTo: citrusPeelGarnish.leadingAnchor, constant: -6),
            citrusPeelGarnish.trailingAnchor.constraint(equalTo: honeyCrullerCruller.leadingAnchor, constant: -6),
            citrusPeelGarnish.centerYAnchor.constraint(equalTo: bakeryWindowAtelier.centerYAnchor),
            citrusPeelGarnish.widthAnchor.constraint(equalToConstant: 24),
            citrusPeelGarnish.heightAnchor.constraint(equalToConstant: 24),
            honeyCrullerCruller.trailingAnchor.constraint(equalTo: bakeryWindowAtelier.trailingAnchor),
            honeyCrullerCruller.centerYAnchor.constraint(equalTo: bakeryWindowAtelier.centerYAnchor),
            honeyCrullerCruller.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            honeyCrullerCruller.heightAnchor.constraint(equalToConstant: 28)
        ])
        return bakeryWindowAtelier
    }

    private func pastryWorkshopCounter() {
        pastryCounterCollection.translatesAutoresizingMaskIntoConstraints = false
        pastryCounterCollection.backgroundColor = .clear
        view.addSubview(pastryCounterCollection)
        crispEdgeCrust = pastryCounterCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cocoaDrinkComplement.translatesAutoresizingMaskIntoConstraints = false
        cocoaDrinkComplement.delegate = self
        cocoaDrinkComplement.placeholder = "Write a comment"
        cocoaDrinkComplement.returnKeyType = .done
        cocoaDrinkComplement.font = .systemFont(ofSize: 12, weight: .regular)
        cocoaDrinkComplement.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
        cocoaDrinkComplement.layer.cornerRadius = 20
        cocoaDrinkComplement.clipsToBounds = true
        cocoaDrinkComplement.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        cocoaDrinkComplement.leftViewMode = .always
        let cocoaNibGarnish = UIButton(type: .system)
        cocoaNibGarnish.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "wevv_room_send_glaze") {
            cocoaNibGarnish.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            cocoaNibGarnish.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        }
        cocoaNibGarnish.addTarget(self, action: #selector(pastryDiaryCollection), for: .touchUpInside)
        pastryCounterCollection.addSubview(cocoaDrinkComplement)
        pastryCounterCollection.addSubview(cocoaNibGarnish)
        NSLayoutConstraint.activate([
            pastryCounterCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryCounterCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryCounterCollection.heightAnchor.constraint(equalToConstant: 76),
            crispEdgeCrust!,
            cocoaDrinkComplement.leadingAnchor.constraint(equalTo: pastryCounterCollection.leadingAnchor, constant: 20),
            cocoaDrinkComplement.topAnchor.constraint(equalTo: pastryCounterCollection.topAnchor, constant: 8),
            cocoaDrinkComplement.heightAnchor.constraint(equalToConstant: 40),
            cocoaNibGarnish.leadingAnchor.constraint(equalTo: cocoaDrinkComplement.trailingAnchor, constant: 12),
            cocoaNibGarnish.trailingAnchor.constraint(equalTo: pastryCounterCollection.trailingAnchor, constant: -20),
            cocoaNibGarnish.centerYAnchor.constraint(equalTo: cocoaDrinkComplement.centerYAnchor),
            cocoaNibGarnish.widthAnchor.constraint(equalToConstant: 40),
            cocoaNibGarnish.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func glazeGalleryGuide() {
        flavorMenuGuide.text = richCocoaFlavor.gingerHoneyDrizzle
        tastingTrayNotes.text = richCocoaFlavor.caramelCurd
        daylightDisplayFrame(richCocoaFlavor.cheesecakeMousse, on: portraitPastryGallery, fallback: "person.crop.circle.fill")
        if let first = richCocoaFlavor.passionfruitFilling.first { daylightDisplayFrame(first, on: daylightDisplayScene, fallback: "photo.fill") }
        daylightDisplayScene.isHidden = richCocoaFlavor.passionfruitFilling.isEmpty
        honeyCrullerCruller.setTitle(richCocoaFlavor.mascarponeCream ? "Following" : "Follow", for: .normal)
        honeyCrullerCruller.backgroundColor = richCocoaFlavor.mascarponeCream ? UIColor(white: 0.69, alpha: 1) : UIColor(red: 1, green: 0.12, blue: 0.58, alpha: 1)
        honeyCrullerCruller.setTitleColor(.white, for: .normal)
        berryBurstNotebook.setImage(UIImage(systemName: richCocoaFlavor.cherryCompote ? "heart.fill" : "heart"), for: .normal)
        berryBurstNotebook.setTitle("  \(richCocoaFlavor.limeCream)", for: .normal)
        berryBurstNotebook.tintColor = UIColor(red: 1, green: 0.15, blue: 0.57, alpha: 1)
        donutDiarySelection.setImage(UIImage(systemName: richCocoaFlavor.custardMousse ? "bookmark.fill" : "bookmark"), for: .normal)
        donutDiarySelection.setTitle("  Save", for: .normal)
        donutDiarySelection.tintColor = UIColor(red: 0.18, green: 0.12, blue: 0.2, alpha: 1)
        butterAromaNotes.text = "Comments"
        seasonalMenuGuide()
    }

    private func seasonalMenuGuide() {
        textureContrastNotes.arrangedSubviews.forEach {
            textureContrastNotes.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        guard !fragrantJasmineFlavor.isEmpty else {
            let airyCenter = doughTendernessNotes("No comments yet. Be the first to share a sweet thought.", size: 12, weight: .regular, color: UIColor(white: 0.48, alpha: 1))
            airyCenter.numberOfLines = 0
            textureContrastNotes.addArrangedSubview(airyCenter)
            return
        }
        fragrantJasmineFlavor.forEach { comment in
            let softCloudDough = UIControl()
            softCloudDough.translatesAutoresizingMaskIntoConstraints = false
            softCloudDough.backgroundColor = .white
            softCloudDough.layer.cornerRadius = 16
            softCloudDough.clipsToBounds = true
            softCloudDough.addTarget(self, action: #selector(heritageBakingNotebook), for: .touchUpInside)
            let portraitPastryGallery = UIImageView()
            rimLightingGallery(portraitPastryGallery, cornerRadius: 14)
            daylightDisplayFrame(comment.cheesecakeMousse, on: portraitPastryGallery, fallback: "person.crop.circle.fill")
            let signatureSelectionNotes = doughTendernessNotes(comment.gingerHoneyDrizzle, size: 13, weight: .semibold, color: UIColor(red: 0.12, green: 0.08, blue: 0.1, alpha: 1))
            let text = doughTendernessNotes(comment.figMousse, size: 13, weight: .regular, color: UIColor(red: 0.48, green: 0.46, blue: 0.49, alpha: 1))
            text.numberOfLines = 0
            let proofingTimeNotes = doughTendernessNotes(comment.figCustard, size: 11, weight: .regular, color: UIColor(red: 0.68, green: 0.66, blue: 0.69, alpha: 1))
            let citrusPeelGarnish = UIButton(type: .system)
            citrusPeelGarnish.translatesAutoresizingMaskIntoConstraints = false
            citrusPeelGarnish.setImage(UIImage(systemName: "exclamationmark.triangle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 11, weight: .semibold)), for: .normal)
            citrusPeelGarnish.tintColor = UIColor(red: 1, green: 0.25, blue: 0.58, alpha: 1)
            citrusPeelGarnish.addTarget(self, action: #selector(heritageBakingNotebook), for: .touchUpInside)
            [portraitPastryGallery, signatureSelectionNotes, text, proofingTimeNotes, citrusPeelGarnish].forEach(softCloudDough.addSubview)
            NSLayoutConstraint.activate([
                softCloudDough.heightAnchor.constraint(greaterThanOrEqualToConstant: 86),
                portraitPastryGallery.leadingAnchor.constraint(equalTo: softCloudDough.leadingAnchor, constant: 12),
                portraitPastryGallery.topAnchor.constraint(equalTo: softCloudDough.topAnchor, constant: 13),
                portraitPastryGallery.widthAnchor.constraint(equalToConstant: 28),
                portraitPastryGallery.heightAnchor.constraint(equalToConstant: 28),
                signatureSelectionNotes.leadingAnchor.constraint(equalTo: portraitPastryGallery.trailingAnchor, constant: 10),
                signatureSelectionNotes.topAnchor.constraint(equalTo: softCloudDough.topAnchor, constant: 12),
                signatureSelectionNotes.trailingAnchor.constraint(equalTo: citrusPeelGarnish.leadingAnchor, constant: -8),
                text.leadingAnchor.constraint(equalTo: signatureSelectionNotes.leadingAnchor),
                text.topAnchor.constraint(equalTo: signatureSelectionNotes.bottomAnchor, constant: 2),
                text.trailingAnchor.constraint(equalTo: citrusPeelGarnish.leadingAnchor, constant: -8),
                proofingTimeNotes.leadingAnchor.constraint(equalTo: signatureSelectionNotes.leadingAnchor),
                proofingTimeNotes.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 3),
                proofingTimeNotes.bottomAnchor.constraint(lessThanOrEqualTo: softCloudDough.bottomAnchor, constant: -10),
                citrusPeelGarnish.trailingAnchor.constraint(equalTo: softCloudDough.trailingAnchor, constant: -10),
                citrusPeelGarnish.bottomAnchor.constraint(equalTo: softCloudDough.bottomAnchor, constant: -10),
                citrusPeelGarnish.widthAnchor.constraint(equalToConstant: 22),
                citrusPeelGarnish.heightAnchor.constraint(equalToConstant: 22)
            ])
            textureContrastNotes.addArrangedSubview(softCloudDough)
        }
    }

    private func freshMixSequence() {
        guard richCocoaFlavor.coconutCenter > 0 else { return }
        herbalLavenderEssence?.cancel()
        herbalLavenderEssence = Task { [weak self] in
            guard let self else { return }
            defer { herbalLavenderEssence = nil }
            do {
                let flavorSpectrumInsight = try await tangyCitrusAroma.glazeSheenNotes(yeastBloomSequence: richCocoaFlavor.coconutCenter)
                guard !Task.isCancelled else { return }
                richCocoaFlavor = flavorSpectrumInsight.pillowyCrumb
                fragrantJasmineFlavor = flavorSpectrumInsight.airyCenter
                glazeGalleryGuide()
            } catch { sugarCraftLaboratory(error.localizedDescription) }
        }
    }

    @objc private func sugarCrystallizationStudy() {
        guard warmGlazeExperience(), richCocoaFlavor.coconutCenter > 0 else { return }
        let springyFinish = !richCocoaFlavor.cherryCompote
        gentleFryRhythm { [self] in try await tangyCitrusAroma.spiceWarmthInsight(yeastBloomSequence: richCocoaFlavor.coconutCenter, springCitrusSelection: springyFinish) }
    }

    @objc private func butterEmulsionStudy() {
        guard warmGlazeExperience(), richCocoaFlavor.coconutCenter > 0 else { return }
        gentleFryRhythm { [self] in _ = try await tangyCitrusAroma.nuttyFinishMatrix(yeastBloomSequence: richCocoaFlavor.coconutCenter, glutenStructureDetail: !richCocoaFlavor.custardMousse) }
    }

    @objc private func yeastActivityStudy() {
        guard warmGlazeExperience(), richCocoaFlavor.vanillaBeanIcing > 0 else { return }
        let tastingMemoryCollection = richCocoaFlavor
        let glossyCoatRhythm = !richCocoaFlavor.mascarponeCream
        richCocoaFlavor = butteryTexture(
            coconutCenter: richCocoaFlavor.coconutCenter,
            vanillaBeanIcing: richCocoaFlavor.vanillaBeanIcing,
            gingerHoneyDrizzle: richCocoaFlavor.gingerHoneyDrizzle,
            cheesecakeMousse: richCocoaFlavor.cheesecakeMousse,
            caramelCurd: richCocoaFlavor.caramelCurd,
            passionfruitFilling: richCocoaFlavor.passionfruitFilling,
            limeCream: richCocoaFlavor.limeCream,
            apricotCenter: richCocoaFlavor.apricotCenter,
            figCustard: richCocoaFlavor.figCustard,
            mascarponeCream: glossyCoatRhythm,
            cherryCompote: richCocoaFlavor.cherryCompote,
            custardMousse: richCocoaFlavor.custardMousse,
            peachFilling: richCocoaFlavor.peachFilling,
            pearJam: richCocoaFlavor.pearJam
        )
        glazeGalleryGuide()
        honeyCrullerCruller.isEnabled = false
        gentleFryRhythm(
            { [self] in try await tangyCitrusAroma.riversideBakery(vanillaBeanIcing: tastingMemoryCollection.vanillaBeanIcing, autumnPecanCollection: glossyCoatRhythm) },
            warmRestSequence: { [weak self] in
                guard let self else { return }
                richCocoaFlavor = tastingMemoryCollection
                glazeGalleryGuide()
                honeyCrullerCruller.isEnabled = true
            }
        )
    }

    @objc private func pastryDiaryCollection() {
        guard warmGlazeExperience(), richCocoaFlavor.coconutCenter > 0 else { return }
        let text = cocoaDrinkComplement.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { sugarCraftLaboratory("Write a comment first."); return }
        cocoaDrinkComplement.resignFirstResponder()
        gentleFryRhythm { [self] in
            try await tangyCitrusAroma.neighborhoodAtelier(coconutCenter: richCocoaFlavor.coconutCenter, figMousse: text)
            await MainActor.run { cocoaDrinkComplement.text = nil }
        }
    }

    private func gentleFryRhythm(_ handKneadSequence: @escaping () async throws -> Void, warmRestSequence: (() -> Void)? = nil) {
        guard herbalLavenderEssence == nil else { return }
        herbalLavenderEssence = Task { [weak self] in
            guard let self else { return }
            do {
                try await handKneadSequence()
                herbalLavenderEssence = nil
                honeyCrullerCruller.isEnabled = true
                cocoaKissExperience?()
                freshMixSequence()
            } catch {
                herbalLavenderEssence = nil
                warmRestSequence?()
                sugarCraftLaboratory(error.localizedDescription)
            }
        }
    }

    @objc private func worldDoughnutNotebook() {
        guard richCocoaFlavor.vanillaBeanIcing > 0 else { return }
        let donutParlorGuide = LmnTasterCardController(userID: richCocoaFlavor.vanillaBeanIcing)
        donutParlorGuide.modalPresentationStyle = .fullScreen
        present(donutParlorGuide, animated: true)
    }

    @objc private func heritageBakingNotebook() {
        guard warmGlazeExperience(), richCocoaFlavor.coconutCenter > 0 else { return }
        let glazeArtAtelier = WevVGlazeContentReportSheet()
        glazeArtAtelier.pralineDismissAction = { [weak self, weak glazeArtAtelier] in
            self?.softShadowGallery(glazeArtAtelier)
        }
        glazeArtAtelier.pralineSubmitAction = { [weak self, weak glazeArtAtelier] reason in
            guard let self else { return }
            softShadowGallery(glazeArtAtelier)
            gentleFryRhythm { [weak self] in
                guard let self else { return }
                try await tangyCitrusAroma.crustSnapIndex(yeastBloomSequence: richCocoaFlavor.coconutCenter, roseTintDesign: "OTHER", lilacSwirlAesthetic: reason)
                await MainActor.run { self.sugarCraftLaboratory("Report submitted.") }
            }
        }
        view.addSubview(glazeArtAtelier)
        NSLayoutConstraint.activate([
            glazeArtAtelier.topAnchor.constraint(equalTo: view.topAnchor),
            glazeArtAtelier.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            glazeArtAtelier.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            glazeArtAtelier.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func softShadowGallery(_ glazeArtAtelier: UIView?) {
        UIView.animate(withDuration: 0.16, animations: {
            glazeArtAtelier?.alpha = 0
        }, completion: { _ in
            glazeArtAtelier?.removeFromSuperview()
        })
    }

    private func warmGlazeExperience() -> Bool {
        guard mellowVanillaContrast.isTasterReady else {
            let morningBiteExperience = UBakerytropicalMangoEssence()
            morningBiteExperience.modalPresentationStyle = .pageSheet
            present(morningBiteExperience, animated: true)
            return false
        }
        return true
    }

    private func carefulCrimpSequence(_ button: UIButton, action: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 0.18, green: 0.12, blue: 0.2, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }

    private func rimLightingGallery(_ imageView: UIImageView, cornerRadius: CGFloat) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
    }

    private func doughTendernessNotes(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    private func daylightDisplayFrame(_ urlText: String?, on imageView: UIImageView, fallback: String) {
        imageView.image = UIImage(named: urlText ?? "") ?? UIImage(systemName: fallback)
        imageView.tintColor = UIColor(red: 1, green: 0.25, blue: 0.6, alpha: 1)
        guard let urlText, !urlText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let url: URL?
        if let absoluteURL = URL(string: urlText), ["http", "https"].contains(absoluteURL.scheme?.lowercased() ?? "") {
            url = absoluteURL
        } else {
            url = URL(string: urlText, relativeTo: filledShellSelection.cafeAtlasGuide)?.absoluteURL
        }
        guard let url else { return }
        imageView.accessibilityIdentifier = url.absoluteString
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if imageView?.accessibilityIdentifier == url.absoluteString { imageView?.image = image } }
        }.resume()
    }

    private func doughMaturationStudy() {
        NotificationCenter.default.addObserver(self, selector: #selector(oilTemperatureStudy(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(proofingTimeDetail(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func oilTemperatureStudy(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        crispEdgeCrust?.constant = -max(0, frame.height - view.safeAreaInsets.bottom)
        goldenHourFrame.contentInset.bottom = frame.height + 76
        goldenHourFrame.verticalScrollIndicatorInsets.bottom = frame.height + 76
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func proofingTimeDetail(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        crispEdgeCrust?.constant = 0
        goldenHourFrame.contentInset.bottom = 90
        goldenHourFrame.verticalScrollIndicatorInsets.bottom = 90
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { pastryDiaryCollection(); return true }
    @objc private func handDipRhythm() { view.endEditing(true) }
    @objc private func slowRiseSequence() { dismiss(animated: true) }

    private func sugarCraftLaboratory(_ text: String) {
        TinGlazePromptStyler.showSugarToast(in: view, text: text, above: pastryCounterCollection, bottomOffset: -12)
    }
}
