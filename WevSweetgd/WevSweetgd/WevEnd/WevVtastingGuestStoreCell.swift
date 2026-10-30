import UIKit



final class WevVtastingGuestStoreCell: UIView {
    enum bottomTarget: String, CustomStringConvertible {
        case brownButterShell = "\u{68}\u{6f}\u{6d}\u{65}", compactChallenge = "\u{76}\u{6f}\u{69}\u{63}\u{65}", buildTopDonutBar = "\u{6d}\u{6f}\u{6d}\u{65}\u{6e}\u{74}\u{73}"
        case clearGlazeRelationsForFreshTaster = "\u{73}\u{70}\u{72}\u{69}\u{6e}\u{6b}\u{6c}\u{65}\u{43}\u{68}\u{61}\u{6c}\u{6c}\u{65}\u{6e}\u{67}\u{65}", cappuccinoCompanion = "\u{70}\u{61}\u{73}\u{74}\u{72}\u{79}\u{46}\u{6f}\u{6c}\u{69}\u{6f}"
        var description: String { rawValue }
    }

    private struct boutiqueStudio {
        let artisanFrySequence: [UIColor]
        let closePastryDetail: UIColor
        let awaitingFirstPaint: UIColor
        let beginGlazeContextPreparation: UIColor
        let brownButterIcing: UIColor


        static let citrusPeelGarnish = boutiqueStudio(
            artisanFrySequence: [UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 33 / 255.0, alpha: 1), UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 33 / 255.0, alpha: 1)],
            closePastryDetail: UIColor(red: 6.4 / 255.0, green: 5.44 / 255.0, blue: 38.12 / 255.0, alpha: 1),
            awaitingFirstPaint: UIColor(red: 35.2 / 255.0, green: 29.92 / 255.0, blue: 61.16 / 255.0, alpha: 1),
            beginGlazeContextPreparation: UIColor(red: 35.2 / 255.0, green: 29.92 / 255.0, blue: 61.16 / 255.0, alpha: 1),
            brownButterIcing: UIColor(red: 78.3 / 255.0, green: 47.38 / 255.0, blue: 112.42 / 255.0, alpha: 1)
        )
    }

    private let buildPastryBackdrop: bottomTarget
    private let candiedOrangeScatter: boutiqueStudio
    private let artisanFrySequence = CAGradientLayer()
    private let cinnamonDustLayer = UIScrollView()
    private let bakeryTrailMap = UIStackView()
    private var closeWevvBakeryShelf: [glazeSaveTask] = []
    private var buildPastrySheet = false
    private var cocoaDepthNotes: UInt = 0
    private var apricotCompote = UIApplication.shared.applicationState == .active

    init(buildPastryBackdrop: bottomTarget) {
        self.buildPastryBackdrop = buildPastryBackdrop
        self.candiedOrangeScatter = .citrusPeelGarnish
        super.init(frame: .zero)
        isHidden = true
        clipsToBounds = true
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        switch buildPastryBackdrop {
        case .brownButterShell: accessibilityLabel = "Laonawdhi*n/ge .lOiqvWeO urSoMoPmesI".wevVPastryCrumbBloomRestored
        case .compactChallenge: accessibilityLabel = "L!oxaHd@i1n!g? $vsoTiac5e~ =rJo!oImTsI".wevVPastryCrumbBloomRestored
        case .buildTopDonutBar: accessibilityLabel = "L6o6aBd3i!nng? 7cloZmcm2u4n4iitjyO +pYobsAt5sf".wevVPastryCrumbBloomRestored
        case .clearGlazeRelationsForFreshTaster: accessibilityLabel = "LEoUaxdiiNnlg% ScQhSaJl.lpelnUgBem *d~eGttadi$lGsA".wevVPastryCrumbBloomRestored
        case .cappuccinoCompanion: accessibilityLabel = "LGoHa?dgiGn+g2 JsYh#oCpx Yd/e3tsa*iRl5s;".wevVPastryCrumbBloomRestored
        }
        accessibilityIdentifier = "\("w~ecv7vX.0iTn8iFt#iGaxloL?oHaXddiwn4gW.D".wevVPastryCrumbBloomRestored)\(buildPastryBackdrop)"
        backgroundColor = candiedOrangeScatter.artisanFrySequence.first
        artisanFrySequence.colors = candiedOrangeScatter.artisanFrySequence.map(\.cgColor)
        artisanFrySequence.startPoint = CGPoint(x: 0.15, y: 0)
        artisanFrySequence.endPoint = CGPoint(x: 0.9, y: 1)
        layer.insertSublayer(artisanFrySequence, at: 0)
        bakeryDayDots()
        NotificationCenter.default.addObserver(self, selector: #selector(archiveCapacity),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(apricotFilling),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkinArtwork),
                                               name: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil)
    }

    required init?(coder bakeryStopText: NSCoder) { nil }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        artisanFrySequence.frame = bounds
        CATransaction.commit()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        cocoaNibGarnish()
    }

    override var isHidden: Bool {
        didSet { cocoaNibGarnish() }
    }

    func citrusParlor(_ coldBrewTasting: Bool, applyVoiceRoomPages: Bool = true) {
        guard buildPastrySheet != coldBrewTasting else {
            cocoaNibGarnish()
            return
        }
        buildPastrySheet = coldBrewTasting
        cocoaDepthNotes &+= 1
        let bananaToffeeHarmony = cocoaDepthNotes
        layer.removeAllAnimations()
        accessibilityElementsHidden = !coldBrewTasting
        let cleanConfirm = applyVoiceRoomPages && window != nil && !UIAccessibility.isReduceMotionEnabled
        if coldBrewTasting {
            let completeGlaze = isHidden
            isHidden = false
            if completeGlaze { alpha = cleanConfirm ? 0 : 1 }
            cocoaNibGarnish()
            if cleanConfirm {
                UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.alpha = 1
                }
            } else {
                alpha = 1
            }
        } else {
            cocoaNibGarnish()
            let blackberryLemonCombination = { [weak self] in
                guard let self, !self.buildPastrySheet, self.cocoaDepthNotes == bananaToffeeHarmony else { return }
                self.isHidden = true
                self.alpha = 1
                self.cinnamonDustLayer.setContentOffset(.zero, animated: false)
            }
            if cleanConfirm {
                UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction],
                               animations: { self.alpha = 0 }, completion: { _ in blackberryLemonCombination() })
            } else {
                blackberryLemonCombination()
            }
        }
    }

    private func bakeryDayDots() {
        cinnamonDustLayer.translatesAutoresizingMaskIntoConstraints = false
        cinnamonDustLayer.showsVerticalScrollIndicator = false
        cinnamonDustLayer.contentInsetAdjustmentBehavior = .never
        cinnamonDustLayer.alwaysBounceVertical = false
        cinnamonDustLayer.accessibilityElementsHidden = true
        bakeryTrailMap.translatesAutoresizingMaskIntoConstraints = false
        bakeryTrailMap.axis = .vertical
        bakeryTrailMap.spacing = 14
        addSubview(cinnamonDustLayer)
        cinnamonDustLayer.addSubview(bakeryTrailMap)
        NSLayoutConstraint.activate([
            cinnamonDustLayer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cinnamonDustLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            cinnamonDustLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            cinnamonDustLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
            bakeryTrailMap.topAnchor.constraint(equalTo: cinnamonDustLayer.contentLayoutGuide.topAnchor,
                constant: buildPastryBackdrop == .clearGlazeRelationsForFreshTaster || buildPastryBackdrop == .cappuccinoCompanion ? 0 : 24),
            bakeryTrailMap.leadingAnchor.constraint(equalTo: cinnamonDustLayer.contentLayoutGuide.leadingAnchor, constant: 15),
            bakeryTrailMap.trailingAnchor.constraint(equalTo: cinnamonDustLayer.contentLayoutGuide.trailingAnchor, constant: -15),
            bakeryTrailMap.bottomAnchor.constraint(equalTo: cinnamonDustLayer.contentLayoutGuide.bottomAnchor, constant: -24),
            bakeryTrailMap.widthAnchor.constraint(equalTo: cinnamonDustLayer.frameLayoutGuide.widthAnchor, constant: -30)
        ])
        if buildPastryBackdrop != .clearGlazeRelationsForFreshTaster && buildPastryBackdrop != .cappuccinoCompanion { bakeryAtlasTimer() }
        switch buildPastryBackdrop {
        case .brownButterShell: bakeryCalendarCard()
        case .compactChallenge: bakeryFindKey()
        case .buildTopDonutBar: bakeryDaySlot()
        case .clearGlazeRelationsForFreshTaster: bakeryAtlasCarousel()
        case .cappuccinoCompanion: bakeryDetails()
        }
    }

    private func bakeryAtlasCarousel() {
        let brownButterGlaze = closeWevvBakeryGate(challengeDonutWevvButton: 18)
        bakeryTrailMap.addArrangedSubview(brownButterGlaze)
        brownButterGlaze.heightAnchor.constraint(equalToConstant: 173).isActive = true
        americanoComplement(bootstrapPaths: 0.25)
        let chaiCompanion = closePastryDetail(challengeDonutWevvButton: 18)
        let cocoaCounter = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let clearSugarCrumbs = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        [cocoaCounter, clearSugarCrumbs].forEach(chaiCompanion.addSubview)
        bakeryTrailMap.addArrangedSubview(chaiCompanion)
        NSLayoutConstraint.activate([
            chaiCompanion.heightAnchor.constraint(equalToConstant: 61),
            cocoaCounter.leadingAnchor.constraint(equalTo: chaiCompanion.leadingAnchor, constant: 26),
            cocoaCounter.topAnchor.constraint(equalTo: chaiCompanion.topAnchor, constant: 14),
            cocoaCounter.widthAnchor.constraint(equalTo: chaiCompanion.widthAnchor, multiplier: 0.62),
            cocoaCounter.heightAnchor.constraint(equalToConstant: 12),
            clearSugarCrumbs.leadingAnchor.constraint(equalTo: cocoaCounter.leadingAnchor),
            clearSugarCrumbs.topAnchor.constraint(equalTo: cocoaCounter.bottomAnchor, constant: 9),
            clearSugarCrumbs.widthAnchor.constraint(equalTo: chaiCompanion.widthAnchor, multiplier: 0.46),
            clearSugarCrumbs.heightAnchor.constraint(equalToConstant: 12)
        ])
        americanoComplement(bootstrapPaths: 0.22)
        let artisanDoughAtelier = closeWevvBakeryGate(challengeDonutWevvButton: 24)
        let buildWevvBakeryShelfPage = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let bakeryFindsTitle = UIView()
        bakeryFindsTitle.translatesAutoresizingMaskIntoConstraints = false
        [artisanDoughAtelier, buildWevvBakeryShelfPage].forEach(bakeryFindsTitle.addSubview)
        bakeryTrailMap.addArrangedSubview(bakeryFindsTitle)
        NSLayoutConstraint.activate([
            bakeryFindsTitle.heightAnchor.constraint(equalToConstant: 48),
            artisanDoughAtelier.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor),
            artisanDoughAtelier.topAnchor.constraint(equalTo: bakeryFindsTitle.topAnchor),
            artisanDoughAtelier.widthAnchor.constraint(equalToConstant: 48),
            artisanDoughAtelier.heightAnchor.constraint(equalTo: artisanDoughAtelier.widthAnchor),
            buildWevvBakeryShelfPage.leadingAnchor.constraint(equalTo: artisanDoughAtelier.trailingAnchor, constant: 20),
            buildWevvBakeryShelfPage.centerYAnchor.constraint(equalTo: artisanDoughAtelier.centerYAnchor),
            buildWevvBakeryShelfPage.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.46),
            buildWevvBakeryShelfPage.heightAnchor.constraint(equalToConstant: 16)
        ])
        let beginGlazeContextPreparation = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        bakeryTrailMap.addArrangedSubview(beginGlazeContextPreparation)
        beginGlazeContextPreparation.heightAnchor.constraint(equalToConstant: 38).isActive = true
        let caramelAppleIcing = closeWevvBakeryGate(challengeDonutWevvButton: 14)
        bakeryTrailMap.addArrangedSubview(caramelAppleIcing)
        caramelAppleIcing.heightAnchor.constraint(equalToConstant: 58).isActive = true
    }

    private func bakeryDetails() {
        let bakeryFindsTitle = closePastryDetail(challengeDonutWevvButton: 16)
        let bakeryVisitArchive = closeWevvBakeryGate(challengeDonutWevvButton: 12)
        let cocoaCounter = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let clearSugarCrumbs = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let beginGlazeContextPreparation = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        [bakeryVisitArchive, cocoaCounter, clearSugarCrumbs, beginGlazeContextPreparation].forEach(bakeryFindsTitle.addSubview)
        bakeryTrailMap.addArrangedSubview(bakeryFindsTitle)
        NSLayoutConstraint.activate([
            bakeryVisitArchive.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor, constant: 15),
            bakeryVisitArchive.topAnchor.constraint(equalTo: bakeryFindsTitle.topAnchor, constant: 15),
            bakeryVisitArchive.bottomAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: -15),
            bakeryVisitArchive.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.38),
            bakeryVisitArchive.heightAnchor.constraint(equalTo: bakeryVisitArchive.widthAnchor),
            cocoaCounter.leadingAnchor.constraint(equalTo: bakeryVisitArchive.trailingAnchor, constant: 12),
            cocoaCounter.topAnchor.constraint(equalTo: bakeryVisitArchive.topAnchor, constant: 4),
            cocoaCounter.trailingAnchor.constraint(equalTo: bakeryFindsTitle.trailingAnchor, constant: -15),
            cocoaCounter.heightAnchor.constraint(equalToConstant: 17),
            clearSugarCrumbs.leadingAnchor.constraint(equalTo: cocoaCounter.leadingAnchor),
            clearSugarCrumbs.trailingAnchor.constraint(equalTo: cocoaCounter.trailingAnchor),
            clearSugarCrumbs.topAnchor.constraint(equalTo: cocoaCounter.bottomAnchor, constant: 12),
            clearSugarCrumbs.heightAnchor.constraint(equalToConstant: 13),
            beginGlazeContextPreparation.leadingAnchor.constraint(equalTo: cocoaCounter.leadingAnchor),
            beginGlazeContextPreparation.trailingAnchor.constraint(equalTo: cocoaCounter.trailingAnchor),
            beginGlazeContextPreparation.topAnchor.constraint(equalTo: clearSugarCrumbs.bottomAnchor, constant: 16),
            beginGlazeContextPreparation.heightAnchor.constraint(equalToConstant: 34)
        ])
        americanoComplement(bootstrapPaths: 0.38)
        let cherryCompote = brunchRouteRoute(cleanSugarHandle: 10)
        for _ in 0..<3 { cherryCompote.addArrangedSubview(closeWevvBakeryGate(challengeDonutWevvButton: 16)) }
        bakeryTrailMap.addArrangedSubview(cherryCompote)
        cherryCompote.heightAnchor.constraint(equalToConstant: 140).isActive = true
        americanoComplement(bootstrapPaths: 0.32)
        for _ in 0..<2 {
            let bakeryFindsTitle = closeWevvBakeryGate(challengeDonutWevvButton: 16)
            bakeryTrailMap.addArrangedSubview(bakeryFindsTitle)
            bakeryFindsTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }

    private func bakeryAtlasTimer() {
        let brownButterDrizzle = UIView()
        brownButterDrizzle.translatesAutoresizingMaskIntoConstraints = false
        bakeryTrailMap.addArrangedSubview(brownButterDrizzle)
        let buildPastryTrailScroll = closeWevvBakeryGate(challengeDonutWevvButton: 8)
        let buildWevvSprinkleJoin = closeWevvBakeryGate(challengeDonutWevvButton: 15)
        brownButterDrizzle.addSubview(buildPastryTrailScroll)
        brownButterDrizzle.addSubview(buildWevvSprinkleJoin)
        NSLayoutConstraint.activate([
            brownButterDrizzle.heightAnchor.constraint(equalToConstant: 30),
            buildPastryTrailScroll.leadingAnchor.constraint(equalTo: brownButterDrizzle.leadingAnchor),
            buildPastryTrailScroll.centerYAnchor.constraint(equalTo: brownButterDrizzle.centerYAnchor),
            buildPastryTrailScroll.widthAnchor.constraint(equalTo: brownButterDrizzle.widthAnchor, multiplier: buildPastryBackdrop == .buildTopDonutBar ? 0.36 : 0.28),
            buildPastryTrailScroll.heightAnchor.constraint(equalToConstant: 28),
            buildWevvSprinkleJoin.trailingAnchor.constraint(equalTo: brownButterDrizzle.trailingAnchor),
            buildWevvSprinkleJoin.centerYAnchor.constraint(equalTo: brownButterDrizzle.centerYAnchor),
            buildWevvSprinkleJoin.widthAnchor.constraint(equalToConstant: 30),
            buildWevvSprinkleJoin.heightAnchor.constraint(equalTo: buildWevvSprinkleJoin.widthAnchor)
        ])
        if buildPastryBackdrop == .brownButterShell {
            let almondDuster = closeWevvBakeryGate(challengeDonutWevvButton: 12)
            brownButterDrizzle.addSubview(almondDuster)
            NSLayoutConstraint.activate([
                almondDuster.centerYAnchor.constraint(equalTo: brownButterDrizzle.centerYAnchor),
                almondDuster.trailingAnchor.constraint(equalTo: buildWevvSprinkleJoin.leadingAnchor, constant: -14),
                almondDuster.widthAnchor.constraint(equalTo: brownButterDrizzle.widthAnchor, multiplier: 0.28),
                almondDuster.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
    }

    private func bakeryCalendarCard() {
        let autumnPecanCollection = closeWevvBakeryGate(challengeDonutWevvButton: 14)
        bakeryTrailMap.addArrangedSubview(autumnPecanCollection)
        autumnPecanCollection.heightAnchor.constraint(equalTo: autumnPecanCollection.widthAnchor, multiplier: 95.0 / 345.0).isActive = true
        let almondFlavor = brunchRouteRoute(cleanSugarHandle: 10)
        almondFlavor.addArrangedSubview(closeWevvBakeryGate(challengeDonutWevvButton: 18))
        let almondPralineShell = UIStackView()
        almondPralineShell.axis = .vertical
        almondPralineShell.spacing = 10
        almondPralineShell.distribution = .fillEqually
        almondPralineShell.addArrangedSubview(closeWevvBakeryGate(challengeDonutWevvButton: 18))
        almondPralineShell.addArrangedSubview(closeWevvBakeryGate(challengeDonutWevvButton: 18))
        almondFlavor.addArrangedSubview(almondPralineShell)
        bakeryTrailMap.addArrangedSubview(almondFlavor)
        almondFlavor.heightAnchor.constraint(equalTo: almondFlavor.widthAnchor, multiplier: 0.60).isActive = true
        americanoComplement(bootstrapPaths: 0.31)
        for _ in 0..<2 {
            let cherryCompote = brunchRouteRoute(cleanSugarHandle: 10)
            for _ in 0..<2 {
                let bakeryFindsTitle = closeWevvBakeryGate(challengeDonutWevvButton: 14)
                let artisanSelectionShowcase = closeWevvBakeryGate(challengeDonutWevvButton: 7, beginGlazeContextPreparation: true)
                let cocoaCounter = closeWevvBakeryGate(challengeDonutWevvButton: 6, beginGlazeContextPreparation: true)
                bakeryFindsTitle.addSubview(artisanSelectionShowcase)
                bakeryFindsTitle.addSubview(cocoaCounter)
                cherryCompote.addArrangedSubview(bakeryFindsTitle)
                NSLayoutConstraint.activate([
                    bakeryFindsTitle.heightAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.99),
                    artisanSelectionShowcase.topAnchor.constraint(equalTo: bakeryFindsTitle.topAnchor, constant: 12),
                    artisanSelectionShowcase.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor, constant: 10),
                    artisanSelectionShowcase.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.32),
                    artisanSelectionShowcase.heightAnchor.constraint(equalToConstant: 17),
                    cocoaCounter.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor, constant: 12),
                    cocoaCounter.bottomAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: -15),
                    cocoaCounter.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.62),
                    cocoaCounter.heightAnchor.constraint(equalToConstant: 13)
                ])
            }
            bakeryTrailMap.addArrangedSubview(cherryCompote)
        }
    }

    private func bakeryFindKey() {
        let buildDonutDiaryPanel = brunchRouteRoute(cleanSugarHandle: 10)
        for _ in 0..<3 {
            let buildDailyDonutBackdrop = closeWevvBakeryGate(challengeDonutWevvButton: 13)
            buildDailyDonutBackdrop.heightAnchor.constraint(equalToConstant: 52).isActive = true
            buildDonutDiaryPanel.addArrangedSubview(buildDailyDonutBackdrop)
        }
        bakeryTrailMap.addArrangedSubview(buildDonutDiaryPanel)
        animateSugarToast()
        let cancelTastingReport = brunchRouteRoute(cleanSugarHandle: 18)
        for _ in 0..<5 {
            let cancelGlazeEntryPreparation = UIStackView()
            cancelGlazeEntryPreparation.axis = .vertical
            cancelGlazeEntryPreparation.alignment = .center
            cancelGlazeEntryPreparation.spacing = 9
            let artisanDoughAtelier = closeWevvBakeryGate(challengeDonutWevvButton: 28)
            let buildWevvBakeryShelfPage = closeWevvBakeryGate(challengeDonutWevvButton: 5)
            cancelGlazeEntryPreparation.addArrangedSubview(artisanDoughAtelier)
            cancelGlazeEntryPreparation.addArrangedSubview(buildWevvBakeryShelfPage)
            NSLayoutConstraint.activate([
                artisanDoughAtelier.widthAnchor.constraint(equalTo: cancelGlazeEntryPreparation.widthAnchor),
                artisanDoughAtelier.heightAnchor.constraint(equalTo: artisanDoughAtelier.widthAnchor),
                buildWevvBakeryShelfPage.widthAnchor.constraint(equalTo: cancelGlazeEntryPreparation.widthAnchor, multiplier: 0.82),
                buildWevvBakeryShelfPage.heightAnchor.constraint(equalToConstant: 10)
            ])
            cancelTastingReport.addArrangedSubview(cancelGlazeEntryPreparation)
        }
        bakeryTrailMap.addArrangedSubview(cancelTastingReport)
        for _ in 0..<3 {
            let bakeryFindsTitle = closePastryDetail(challengeDonutWevvButton: 14)
            let artisanDoughAtelier = closeWevvBakeryGate(challengeDonutWevvButton: 27)
            let cocoaCounter = closeWevvBakeryGate(challengeDonutWevvButton: 7)
            let bakeryFindsStack = closeWevvBakeryGate(challengeDonutWevvButton: 5)
            let buildHomeLiveRoomBand = closeWevvBakeryGate(challengeDonutWevvButton: 10.5, beginGlazeContextPreparation: true)
            [artisanDoughAtelier, cocoaCounter, bakeryFindsStack, buildHomeLiveRoomBand].forEach(bakeryFindsTitle.addSubview)
            bakeryTrailMap.addArrangedSubview(bakeryFindsTitle)
            NSLayoutConstraint.activate([
                bakeryFindsTitle.heightAnchor.constraint(equalToConstant: 124),
                artisanDoughAtelier.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor, constant: 16),
                artisanDoughAtelier.centerYAnchor.constraint(equalTo: bakeryFindsTitle.centerYAnchor),
                artisanDoughAtelier.widthAnchor.constraint(equalToConstant: 54),
                artisanDoughAtelier.heightAnchor.constraint(equalTo: artisanDoughAtelier.widthAnchor),
                cocoaCounter.leadingAnchor.constraint(equalTo: artisanDoughAtelier.trailingAnchor, constant: 14),
                cocoaCounter.topAnchor.constraint(equalTo: bakeryFindsTitle.topAnchor, constant: 29),
                cocoaCounter.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.43),
                cocoaCounter.heightAnchor.constraint(equalToConstant: 16),
                bakeryFindsStack.leadingAnchor.constraint(equalTo: cocoaCounter.leadingAnchor),
                bakeryFindsStack.topAnchor.constraint(equalTo: cocoaCounter.bottomAnchor, constant: 13),
                bakeryFindsStack.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.30),
                bakeryFindsStack.heightAnchor.constraint(equalToConstant: 11),
                buildHomeLiveRoomBand.trailingAnchor.constraint(equalTo: bakeryFindsTitle.trailingAnchor, constant: -15),
                buildHomeLiveRoomBand.bottomAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: -15),
                buildHomeLiveRoomBand.widthAnchor.constraint(equalToConstant: 55),
                buildHomeLiveRoomBand.heightAnchor.constraint(equalToConstant: 21)
            ])
        }
    }

    private func bakeryDaySlot() {
        animateSugarToast()
        let bindFlavorNoteDismissTap = UIView()
        bindFlavorNoteDismissTap.translatesAutoresizingMaskIntoConstraints = false
        bakeryTrailMap.addArrangedSubview(bindFlavorNoteDismissTap)
        let brownButterGlaze = closePastryDetail(challengeDonutWevvButton: 18)
        let buildDonutParlorTabBar = closeWevvBakeryGate(challengeDonutWevvButton: 13)
        let bakeryFindsStack = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let cleanCrumbBio = UIStackView()
        cleanCrumbBio.translatesAutoresizingMaskIntoConstraints = false
        cleanCrumbBio.axis = .vertical
        cleanCrumbBio.spacing = 8
        cleanCrumbBio.distribution = .fillEqually
        for _ in 0..<3 { cleanCrumbBio.addArrangedSubview(closeWevvBakeryGate(challengeDonutWevvButton: 12)) }
        [brownButterGlaze, cleanCrumbBio].forEach(bindFlavorNoteDismissTap.addSubview)
        [buildDonutParlorTabBar, bakeryFindsStack].forEach(brownButterGlaze.addSubview)
        NSLayoutConstraint.activate([
            bindFlavorNoteDismissTap.heightAnchor.constraint(equalTo: bindFlavorNoteDismissTap.widthAnchor, multiplier: 1.04),
            brownButterGlaze.leadingAnchor.constraint(equalTo: bindFlavorNoteDismissTap.leadingAnchor),
            brownButterGlaze.topAnchor.constraint(equalTo: bindFlavorNoteDismissTap.topAnchor),
            brownButterGlaze.bottomAnchor.constraint(equalTo: bindFlavorNoteDismissTap.bottomAnchor),
            brownButterGlaze.widthAnchor.constraint(equalTo: bindFlavorNoteDismissTap.widthAnchor, multiplier: 0.68),
            cleanCrumbBio.leadingAnchor.constraint(equalTo: brownButterGlaze.trailingAnchor, constant: 10),
            cleanCrumbBio.trailingAnchor.constraint(equalTo: bindFlavorNoteDismissTap.trailingAnchor),
            cleanCrumbBio.topAnchor.constraint(equalTo: bindFlavorNoteDismissTap.topAnchor),
            cleanCrumbBio.bottomAnchor.constraint(equalTo: bindFlavorNoteDismissTap.bottomAnchor),
            buildDonutParlorTabBar.leadingAnchor.constraint(equalTo: brownButterGlaze.leadingAnchor, constant: 10),
            buildDonutParlorTabBar.trailingAnchor.constraint(equalTo: brownButterGlaze.trailingAnchor, constant: -10),
            buildDonutParlorTabBar.topAnchor.constraint(equalTo: brownButterGlaze.topAnchor, constant: 10),
            buildDonutParlorTabBar.bottomAnchor.constraint(equalTo: brownButterGlaze.bottomAnchor, constant: -61),
            bakeryFindsStack.leadingAnchor.constraint(equalTo: buildDonutParlorTabBar.leadingAnchor),
            bakeryFindsStack.topAnchor.constraint(equalTo: buildDonutParlorTabBar.bottomAnchor, constant: 17),
            bakeryFindsStack.widthAnchor.constraint(equalTo: buildDonutParlorTabBar.widthAnchor, multiplier: 0.76),
            bakeryFindsStack.heightAnchor.constraint(equalToConstant: 14)
        ])
        americanoComplement(bootstrapPaths: 0.30)
        for _ in 0..<2 { bakeryTrailMap.addArrangedSubview(buildSugarSettingsPage()) }
    }

    private func buildSugarSettingsPage() -> UIView {
        let bakeryFindsTitle = closePastryDetail(challengeDonutWevvButton: 16)
        let aromaSpectrumNotes = closeWevvBakeryGate(challengeDonutWevvButton: 19)
        let buildWevvBakeryShelfPage = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let buildPastryScroll = closeWevvBakeryGate(challengeDonutWevvButton: 5)
        let citrusZestShell = closeWevvBakeryGate(challengeDonutWevvButton: 5)
        let caramelMeltDelight = closeWevvBakeryGate(challengeDonutWevvButton: 13)
        [aromaSpectrumNotes, buildWevvBakeryShelfPage, buildPastryScroll, citrusZestShell, caramelMeltDelight].forEach(bakeryFindsTitle.addSubview)
        NSLayoutConstraint.activate([
            aromaSpectrumNotes.topAnchor.constraint(equalTo: bakeryFindsTitle.topAnchor, constant: 14),
            aromaSpectrumNotes.leadingAnchor.constraint(equalTo: bakeryFindsTitle.leadingAnchor, constant: 14),
            aromaSpectrumNotes.widthAnchor.constraint(equalToConstant: 38),
            aromaSpectrumNotes.heightAnchor.constraint(equalTo: aromaSpectrumNotes.widthAnchor),
            buildWevvBakeryShelfPage.leadingAnchor.constraint(equalTo: aromaSpectrumNotes.trailingAnchor, constant: 10),
            buildWevvBakeryShelfPage.centerYAnchor.constraint(equalTo: aromaSpectrumNotes.centerYAnchor),
            buildWevvBakeryShelfPage.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.35),
            buildWevvBakeryShelfPage.heightAnchor.constraint(equalToConstant: 13),
            buildPastryScroll.topAnchor.constraint(equalTo: aromaSpectrumNotes.bottomAnchor, constant: 14),
            buildPastryScroll.leadingAnchor.constraint(equalTo: aromaSpectrumNotes.leadingAnchor),
            buildPastryScroll.trailingAnchor.constraint(equalTo: bakeryFindsTitle.trailingAnchor, constant: -20),
            buildPastryScroll.heightAnchor.constraint(equalToConstant: 11),
            citrusZestShell.topAnchor.constraint(equalTo: buildPastryScroll.bottomAnchor, constant: 8),
            citrusZestShell.leadingAnchor.constraint(equalTo: buildPastryScroll.leadingAnchor),
            citrusZestShell.widthAnchor.constraint(equalTo: bakeryFindsTitle.widthAnchor, multiplier: 0.60),
            citrusZestShell.heightAnchor.constraint(equalToConstant: 11),
            caramelMeltDelight.topAnchor.constraint(equalTo: citrusZestShell.bottomAnchor, constant: 14),
            caramelMeltDelight.leadingAnchor.constraint(equalTo: aromaSpectrumNotes.leadingAnchor),
            caramelMeltDelight.trailingAnchor.constraint(equalTo: bakeryFindsTitle.trailingAnchor, constant: -14),
            caramelMeltDelight.heightAnchor.constraint(equalTo: caramelMeltDelight.widthAnchor, multiplier: 0.67),
            caramelMeltDelight.bottomAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: -14)
        ])
        return bakeryFindsTitle
    }

    private func americanoComplement(bootstrapPaths: CGFloat) {
        let bakeryTrailLine = UIView()
        bakeryTrailLine.translatesAutoresizingMaskIntoConstraints = false
        let buildPastryScroll = closeWevvBakeryGate(challengeDonutWevvButton: 7)
        bakeryTrailLine.addSubview(buildPastryScroll)
        bakeryTrailMap.addArrangedSubview(bakeryTrailLine)
        NSLayoutConstraint.activate([
            bakeryTrailLine.heightAnchor.constraint(equalToConstant: 28),
            buildPastryScroll.leadingAnchor.constraint(equalTo: bakeryTrailLine.leadingAnchor),
            buildPastryScroll.centerYAnchor.constraint(equalTo: bakeryTrailLine.centerYAnchor),
            buildPastryScroll.heightAnchor.constraint(equalToConstant: 19),
            buildPastryScroll.widthAnchor.constraint(equalTo: bakeryTrailLine.widthAnchor, multiplier: bootstrapPaths)
        ])
    }

    private func animateSugarToast() {
        let bakeryTrailLine = UIView()
        bakeryTrailLine.translatesAutoresizingMaskIntoConstraints = false
        let blueberryCompote = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let cinnamonSugarFinish = closeWevvBakeryGate(challengeDonutWevvButton: 6)
        let cocoaKissExperience = closeWevvBakeryGate(challengeDonutWevvButton: 2, beginGlazeContextPreparation: true)
        [blueberryCompote, cinnamonSugarFinish, cocoaKissExperience].forEach(bakeryTrailLine.addSubview)
        bakeryTrailMap.addArrangedSubview(bakeryTrailLine)
        NSLayoutConstraint.activate([
            bakeryTrailLine.heightAnchor.constraint(equalToConstant: 36),
            blueberryCompote.leadingAnchor.constraint(equalTo: bakeryTrailLine.leadingAnchor),
            blueberryCompote.topAnchor.constraint(equalTo: bakeryTrailLine.topAnchor, constant: 4),
            blueberryCompote.widthAnchor.constraint(equalTo: bakeryTrailLine.widthAnchor, multiplier: 0.23),
            blueberryCompote.heightAnchor.constraint(equalToConstant: 20),
            cinnamonSugarFinish.leadingAnchor.constraint(equalTo: blueberryCompote.trailingAnchor, constant: 18),
            cinnamonSugarFinish.centerYAnchor.constraint(equalTo: blueberryCompote.centerYAnchor),
            cinnamonSugarFinish.widthAnchor.constraint(equalTo: bakeryTrailLine.widthAnchor, multiplier: 0.29),
            cinnamonSugarFinish.heightAnchor.constraint(equalToConstant: 20),
            cocoaKissExperience.topAnchor.constraint(equalTo: blueberryCompote.bottomAnchor, constant: 7),
            cocoaKissExperience.centerXAnchor.constraint(equalTo: buildPastryBackdrop == .compactChallenge ? cinnamonSugarFinish.centerXAnchor : blueberryCompote.centerXAnchor),
            cocoaKissExperience.widthAnchor.constraint(equalToConstant: 22),
            cocoaKissExperience.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    private func brunchRouteRoute(cleanSugarHandle: CGFloat) -> UIStackView {
        let cherryCompote = UIStackView()
        cherryCompote.translatesAutoresizingMaskIntoConstraints = false
        cherryCompote.axis = .horizontal
        cherryCompote.distribution = .fillEqually
        cherryCompote.spacing = cleanSugarHandle
        return cherryCompote
    }

    private func closePastryDetail(challengeDonutWevvButton: CGFloat) -> UIView {
        let coffeeCreamShell = UIView()
        coffeeCreamShell.translatesAutoresizingMaskIntoConstraints = false
        coffeeCreamShell.backgroundColor = candiedOrangeScatter.closePastryDetail
        coffeeCreamShell.layer.cornerRadius = challengeDonutWevvButton
        coffeeCreamShell.clipsToBounds = true
        coffeeCreamShell.isAccessibilityElement = false
        return coffeeCreamShell
    }

    private func closeWevvBakeryGate(challengeDonutWevvButton: CGFloat, beginGlazeContextPreparation: Bool = false) -> glazeSaveTask {
        let coffeeCreamShell = glazeSaveTask(autumnSpiceFestival: beginGlazeContextPreparation ? candiedOrangeScatter.beginGlazeContextPreparation : candiedOrangeScatter.awaitingFirstPaint,
                                        brownButterIcing: candiedOrangeScatter.brownButterIcing, challengeDonutWevvButton: challengeDonutWevvButton)
        coffeeCreamShell.translatesAutoresizingMaskIntoConstraints = false
        closeWevvBakeryShelf.append(coffeeCreamShell)
        return coffeeCreamShell
    }

    @objc private func archiveCapacity() {
        apricotCompote = false
        cocoaNibGarnish()
    }

    @objc private func apricotFilling() {
        apricotCompote = true
        cocoaNibGarnish()
    }

    @objc private func checkinArtwork() { cocoaNibGarnish() }

    private func cocoaNibGarnish() {
        let applyGlazeNavigation = buildPastrySheet && !isHidden && window != nil && apricotCompote
            && !UIAccessibility.isReduceMotionEnabled
        closeWevvBakeryShelf.forEach { $0.citrusBrightnessMatrix(applyGlazeNavigation) }
    }
}

private final class glazeSaveTask: UIView {
    private let citrusSeasonGathering = CAGradientLayer()
    private let carnivalGlazeTasting: CGFloat

    init(autumnSpiceFestival: UIColor, brownButterIcing: UIColor, challengeDonutWevvButton: CGFloat) {
        carnivalGlazeTasting = challengeDonutWevvButton
        super.init(frame: .zero)
        backgroundColor = autumnSpiceFestival
        layer.cornerRadius = challengeDonutWevvButton
        clipsToBounds = true
        isAccessibilityElement = false
        isUserInteractionEnabled = false
        citrusSeasonGathering.colors = [UIColor.clear.cgColor, brownButterIcing.cgColor, UIColor.clear.cgColor]
        citrusSeasonGathering.locations = [-1, -0.5, 0]
        citrusSeasonGathering.startPoint = CGPoint(x: 0, y: 0.25)
        citrusSeasonGathering.endPoint = CGPoint(x: 1, y: 0.75)
        layer.addSublayer(citrusSeasonGathering)
    }

    required init?(coder bakeryStopText: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        citrusSeasonGathering.frame = bounds
        layer.cornerRadius = min(carnivalGlazeTasting, min(bounds.width, bounds.height) / 2)
        CATransaction.commit()
    }

    func citrusBrightnessMatrix(_ beginVoiceRoomRefresh: Bool) {
        guard beginVoiceRoomRefresh else {
            citrusSeasonGathering.removeAnimation(forKey: "wIejvgv!Sqk,e:lAe7tjoSn?SCwje2e$pO".wevVPastryCrumbBloomRestored)
            return
        }
        guard citrusSeasonGathering.animation(forKey: "wye?vrvaSpkYeXlOeXt|oJngSiwZe#eKpC".wevVPastryCrumbBloomRestored) == nil else { return }
        let closePastrySheet = CABasicAnimation(keyPath: "l5oMc6altIiNonnSsY".wevVPastryCrumbBloomRestored)
        closePastrySheet.fromValue = [-1.0, -0.5, 0.0]
        closePastrySheet.toValue = [1.0, 1.5, 2.0]
        closePastrySheet.duration = 1.45
        closePastrySheet.repeatCount = .infinity
        closePastrySheet.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        citrusSeasonGathering.add(closePastrySheet, forKey: "w!eVvhv4SMk/e2loestRoOnCS?wPegezp=".wevVPastryCrumbBloomRestored)
    }
}
