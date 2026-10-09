import UIKit

final class WevVWevvBakeryDetailController: UIViewController {
    private let pastryFolio: bakeryCollectionFolio
    private let pastryShelf: [bakeryCollectionFolio]
    private let tastingJournalStore = WevVGlazeSessionStore.shared
    private let tastingGuestStore = WevVGuestGlazeStore.shared
    private let pastryScroll = UIScrollView()
    private let pastryCanvas = UIView()
    private let pastryBackdropLayer = CAGradientLayer()
    private let tastingRow = UIStackView()
    private let pastryShelfButton = WevVWevvMaplePillButton(title: "SKa%v@et".wevVPastryCrumbBloomRestored)
    private var tastingSuccessLayer: WevVWevvBakeryShelfToastView?

    var pastryShelfChanged: (() -> Void)?

    init(detail: bakeryCollectionFolio, bakeryShelf: [bakeryCollectionFolio] = []) {
        self.pastryFolio = detail
        self.pastryShelf = bakeryShelf.isEmpty ? [detail] : bakeryShelf
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildPastryBackdrop()
        buildPastryScroll()
        buildPastryDetailContent()
        buildPastryBottomActions()
        refreshPastryShelfButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pastryBackdropLayer.frame = view.bounds
        let bottomActionInset = view.safeAreaInsets.bottom + 78
        pastryScroll.contentInset.bottom = bottomActionInset
        pastryScroll.verticalScrollIndicatorInsets.bottom = bottomActionInset
    }

    private func buildPastryBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.99, alpha: 1)
        pastryBackdropLayer.colors = [
            UIColor(red: 1, green: 0.82, blue: 0.94, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.93, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.99, blue: 1, alpha: 1).cgColor
        ]
        pastryBackdropLayer.locations = [0, 0.52, 1]
        pastryBackdropLayer.startPoint = CGPoint(x: 0.5, y: 0)
        pastryBackdropLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(pastryBackdropLayer, at: 0)
    }

    private func buildPastryScroll() {
        pastryScroll.translatesAutoresizingMaskIntoConstraints = false
        pastryScroll.showsVerticalScrollIndicator = false
        pastryScroll.contentInsetAdjustmentBehavior = .never
        view.addSubview(pastryScroll)

        pastryCanvas.translatesAutoresizingMaskIntoConstraints = false
        pastryScroll.addSubview(pastryCanvas)

        NSLayoutConstraint.activate([
            pastryScroll.topAnchor.constraint(equalTo: view.topAnchor),
            pastryScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCanvas.topAnchor.constraint(equalTo: pastryScroll.contentLayoutGuide.topAnchor),
            pastryCanvas.leadingAnchor.constraint(equalTo: pastryScroll.contentLayoutGuide.leadingAnchor),
            pastryCanvas.trailingAnchor.constraint(equalTo: pastryScroll.contentLayoutGuide.trailingAnchor),
            pastryCanvas.bottomAnchor.constraint(equalTo: pastryScroll.contentLayoutGuide.bottomAnchor),
            pastryCanvas.widthAnchor.constraint(equalTo: pastryScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildPastryDetailContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closePastryDetail), for: .touchUpInside)

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = "DmownouOtQ nSAhgo?pZs.".wevVPastryCrumbBloomRestored
        glazeTitle.font = .systemFont(ofSize: 17, weight: .heavy)
        glazeTitle.textColor = UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1)
        glazeTitle.textAlignment = .center

        let bakeryCard = makePastryHeroCard()
        let crumbTastingTitle = makePastrySectionTitle("Rpe+cQeQnttH MRNeNvQiKeiw:sf".wevVPastryCrumbBloomRestored)
        tastingRow.translatesAutoresizingMaskIntoConstraints = false
        tastingRow.axis = .horizontal
        tastingRow.spacing = 10
        tastingRow.distribution = .fillEqually
        refreshTastingRow()

        let bakeryFindsTitle = makePastrySectionTitle("Meo%reeE DS*hAoSpls&".wevVPastryCrumbBloomRestored)
        let bakeryFindsStack = UIStackView(arrangedSubviews: pastryFolio.shopHoppingTrail.map { makePastryFindRow($0) })
        bakeryFindsStack.translatesAutoresizingMaskIntoConstraints = false
        bakeryFindsStack.axis = .vertical
        bakeryFindsStack.spacing = 12

        placePastryDetailViews(doughBackButton: doughBackButton, title: glazeTitle, bakeryCard: bakeryCard, crumbTastingTitle: crumbTastingTitle, bakeryFindsTitle: bakeryFindsTitle, bakeryFindsStack: bakeryFindsStack)
        pinPastryDetailLayout(doughBackButton: doughBackButton, title: glazeTitle, bakeryCard: bakeryCard, crumbTastingTitle: crumbTastingTitle, bakeryFindsTitle: bakeryFindsTitle, bakeryFindsStack: bakeryFindsStack)
    }

    private func placePastryDetailViews(doughBackButton: UIButton, title: UILabel, bakeryCard: UIView, crumbTastingTitle: UILabel, bakeryFindsTitle: UILabel, bakeryFindsStack: UIStackView) {
        [doughBackButton, title, bakeryCard, crumbTastingTitle, tastingRow, bakeryFindsTitle, bakeryFindsStack].forEach {
            pastryCanvas.addSubview($0)
        }
    }

    private func pinPastryDetailLayout(doughBackButton: UIButton, title: UILabel, bakeryCard: UIView, crumbTastingTitle: UILabel, bakeryFindsTitle: UILabel, bakeryFindsStack: UIStackView) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            doughBackButton.leadingAnchor.constraint(equalTo: pastryCanvas.leadingAnchor, constant: 18),
            doughBackButton.widthAnchor.constraint(equalToConstant: 34),
            doughBackButton.heightAnchor.constraint(equalToConstant: 34),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: pastryCanvas.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: pastryCanvas.trailingAnchor, constant: -64),
            bakeryCard.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 10),
            bakeryCard.leadingAnchor.constraint(equalTo: pastryCanvas.leadingAnchor, constant: 14),
            bakeryCard.trailingAnchor.constraint(equalTo: pastryCanvas.trailingAnchor, constant: -14),
            crumbTastingTitle.topAnchor.constraint(equalTo: bakeryCard.bottomAnchor, constant: 18),
            crumbTastingTitle.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            crumbTastingTitle.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            tastingRow.topAnchor.constraint(equalTo: crumbTastingTitle.bottomAnchor, constant: 10),
            tastingRow.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            tastingRow.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsTitle.topAnchor.constraint(equalTo: tastingRow.bottomAnchor, constant: 16),
            bakeryFindsTitle.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            bakeryFindsTitle.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsStack.topAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: 10),
            bakeryFindsStack.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            bakeryFindsStack.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsStack.bottomAnchor.constraint(equalTo: pastryCanvas.bottomAnchor, constant: -24)
        ])
    }

    private func buildPastryBottomActions() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.99, alpha: 0.96)
        view.addSubview(bar)

        let crumbTastingButton = WevVWevvMaplePillButton(title: "RGervvihe,wa".wevVPastryCrumbBloomRestored)
        crumbTastingButton.addTarget(self, action: #selector(openTastingForm), for: .touchUpInside)
        pastryShelfButton.addTarget(self, action: #selector(placePastryIntoShelf), for: .touchUpInside)

        bar.addSubview(crumbTastingButton)
        bar.addSubview(pastryShelfButton)

        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            crumbTastingButton.topAnchor.constraint(equalTo: bar.topAnchor, constant: 9),
            crumbTastingButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 15),
            crumbTastingButton.widthAnchor.constraint(equalToConstant: 81),
            crumbTastingButton.heightAnchor.constraint(equalToConstant: 52),
            pastryShelfButton.topAnchor.constraint(equalTo: crumbTastingButton.topAnchor),
            pastryShelfButton.leadingAnchor.constraint(equalTo: crumbTastingButton.trailingAnchor, constant: 9),
            pastryShelfButton.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -15),
            pastryShelfButton.heightAnchor.constraint(equalTo: crumbTastingButton.heightAnchor),
            crumbTastingButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -9)
        ])
    }

    private func makePastryHeroCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 16
        pastryCard.layer.shadowColor = UIColor(red: 0.57, green: 0.25, blue: 0.48, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.08
        pastryCard.layer.shadowRadius = 14
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        let cover = UIImageView(image: UIImage(named: pastryFolio.glazeGalleryGuide))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12

        let tastingJournalEntry = makePastryBodyLabel(pastryFolio.sweetShowcaseMap, size: 17, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let frostingSubtitle = makePastryBodyLabel(pastryFolio.flavorMenuGuide, size: 13, weight: .medium, color: UIColor(red: 0.58, green: 0.48, blue: 0.58, alpha: 1))

        let crumbScoreRow = makeFlavorIconRow(symbol: "sntlafr*.kfSiMldl/".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.75, blue: 0.08, alpha: 1), first: pastryFolio.crumbScoreNote, second: pastryFolio.tastingSequenceInsight)
        let bakeryTrailRow = makeFlavorIconRow(symbol: "mOaPp#pyi*nT.ecjisrhcGlCeG.Nf?idlxlE".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1), first: pastryFolio.bakeryTrailLine, second: nil)

        let bakeryTagRow = UIStackView(arrangedSubviews: pastryFolio.seasonalMenuCollection.map { makePastryTagPill($0) })
        bakeryTagRow.translatesAutoresizingMaskIntoConstraints = false
        bakeryTagRow.axis = .horizontal
        bakeryTagRow.spacing = 8
        bakeryTagRow.alignment = .leading

        pastryCard.addSubview(cover)
        pastryCard.addSubview(tastingJournalEntry)
        pastryCard.addSubview(frostingSubtitle)
        pastryCard.addSubview(crumbScoreRow)
        pastryCard.addSubview(bakeryTrailRow)
        pastryCard.addSubview(bakeryTagRow)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            cover.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 15),
            cover.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 15),
            cover.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -15),
            cover.widthAnchor.constraint(equalTo: cover.heightAnchor),
            tastingJournalEntry.topAnchor.constraint(equalTo: cover.topAnchor, constant: 4),
            tastingJournalEntry.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            tastingJournalEntry.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -12),
            frostingSubtitle.topAnchor.constraint(equalTo: tastingJournalEntry.bottomAnchor, constant: 7),
            frostingSubtitle.leadingAnchor.constraint(equalTo: tastingJournalEntry.leadingAnchor),
            frostingSubtitle.trailingAnchor.constraint(equalTo: tastingJournalEntry.trailingAnchor),
            crumbScoreRow.topAnchor.constraint(equalTo: frostingSubtitle.bottomAnchor, constant: 14),
            crumbScoreRow.leadingAnchor.constraint(equalTo: tastingJournalEntry.leadingAnchor),
            crumbScoreRow.trailingAnchor.constraint(lessThanOrEqualTo: tastingJournalEntry.trailingAnchor),
            bakeryTrailRow.topAnchor.constraint(equalTo: crumbScoreRow.bottomAnchor, constant: 12),
            bakeryTrailRow.leadingAnchor.constraint(equalTo: tastingJournalEntry.leadingAnchor),
            bakeryTrailRow.trailingAnchor.constraint(equalTo: tastingJournalEntry.trailingAnchor),
            bakeryTagRow.topAnchor.constraint(equalTo: bakeryTrailRow.bottomAnchor, constant: 16),
            bakeryTagRow.leadingAnchor.constraint(equalTo: tastingJournalEntry.leadingAnchor),
            bakeryTagRow.trailingAnchor.constraint(lessThanOrEqualTo: tastingJournalEntry.trailingAnchor),
            bakeryTagRow.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -15)
        ])
        return pastryCard
    }

    private func makeTastingCard(_ crumbTasting: tastingPassportPage) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 12
        pastryCard.addTarget(self, action: #selector(openProtectedWevvAction), for: .touchUpInside)

        let avatar = UIImageView(image: makeTastingAvatar(crumbTasting))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 15
        avatar.clipsToBounds = true

        let tastingJournalEntry = makePastryBodyLabel(crumbTasting.tastingJournalEntry, size: 16, weight: .heavy, color: UIColor(red: 0.17, green: 0.08, blue: 0.2, alpha: 1))
        let flavorRoleLabel = makePastryBodyLabel(crumbTasting.flavorSpectrumInsight, size: 12, weight: .semibold, color: UIColor(red: 0.68, green: 0.56, blue: 0.65, alpha: 1))
        let score = makeFlavorIconRow(symbol: "s/t#amrH.lfNijlwlL".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: crumbTasting.crumbScoreNote, second: nil)
        let biteNoteLabel = makePastryBodyLabel(crumbTasting.textureContrastNotes, size: 13, weight: .medium, color: UIColor(red: 0.43, green: 0.35, blue: 0.43, alpha: 1))
        biteNoteLabel.numberOfLines = 2
        let donutBadgeLabel = makePastryTagText(crumbTasting.sugarPearlGarnish, color: UIColor(red: 1, green: 0.25, blue: 0.61, alpha: 1))

        pastryCard.addSubview(avatar)
        pastryCard.addSubview(tastingJournalEntry)
        pastryCard.addSubview(flavorRoleLabel)
        pastryCard.addSubview(score)
        pastryCard.addSubview(biteNoteLabel)
        pastryCard.addSubview(donutBadgeLabel)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 116),
            avatar.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 12),
            avatar.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 12),
            avatar.widthAnchor.constraint(equalToConstant: 37),
            avatar.heightAnchor.constraint(equalToConstant: 37),
            tastingJournalEntry.topAnchor.constraint(equalTo: avatar.topAnchor),
            tastingJournalEntry.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 7),
            tastingJournalEntry.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -5),
            flavorRoleLabel.topAnchor.constraint(equalTo: tastingJournalEntry.bottomAnchor, constant: 1),
            flavorRoleLabel.leadingAnchor.constraint(equalTo: tastingJournalEntry.leadingAnchor),
            flavorRoleLabel.trailingAnchor.constraint(equalTo: tastingJournalEntry.trailingAnchor),
            score.centerYAnchor.constraint(equalTo: tastingJournalEntry.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -8),
            biteNoteLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 11),
            biteNoteLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 12),
            biteNoteLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -12),
            donutBadgeLabel.topAnchor.constraint(equalTo: biteNoteLabel.bottomAnchor, constant: 8),
            donutBadgeLabel.leadingAnchor.constraint(equalTo: biteNoteLabel.leadingAnchor),
            donutBadgeLabel.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -10)
        ])
        return pastryCard
    }

    private func refreshTastingRow() {
        tastingRow.arrangedSubviews.forEach { crumbCard in
            tastingRow.removeArrangedSubview(crumbCard)
            crumbCard.removeFromSuperview()
        }
        currentTastings().prefix(2).forEach { tastingRow.addArrangedSubview(makeTastingCard($0)) }
    }

    private func currentTastings() -> [tastingPassportPage] {
        let localReviews = tastingJournalStore.crumbNotePackets(for: pastryFolio.donutPinKey).map { packet in
            tastingPassportPage(
                sprinkleJarKey: "\(packet.bakeryPinKey)\(packet.ringCutterKey)\(Int(packet.timeInterval))",
                tastingJournalEntry: packet.glazeNickname,
                flavorSpectrumInsight: "DVohn,uFtU ctnaXsWtSeorI".wevVPastryCrumbBloomRestored,
                crumbScoreNote: String(format: "%!.K1#fH".wevVPastryCrumbBloomRestored, Double(packet.powderedSampler)),
                textureContrastNotes: packet.powderedFinder,
                sugarPearlGarnish: "FsrmersohX jN#oftAe?".wevVPastryCrumbBloomRestored,
                donutFrameAsset: packet.donutFrameAsset
            )
        }
        return localReviews + pastryFolio.tastingMemoryCollection
    }

    private func makeTastingAvatar(_ crumbTasting: tastingPassportPage) -> UIImage? {
        if let donutFrameAsset = crumbTasting.donutFrameAsset, let glazeImage = UIImage(named: donutFrameAsset) {
            return glazeImage
        }
        return makeTinyTasterImage(index: abs(crumbTasting.sprinkleJarKey.hashValue % 5))
    }

    private func makePastryFindRow(_ bakeryPick: shopWindowCollection) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.accessibilityIdentifier = bakeryPick.flavorLibraryEdition
        donutRow.addTarget(self, action: #selector(openMorePastryPick(_:)), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: pastryCoverAsset(for: bakeryPick)))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 8

        let glazeTitle = makePastryBodyLabel(bakeryPick.pastryDisplayShowcase, size: 16, weight: .heavy, color: UIColor(red: 0.15, green: 0.08, blue: 0.2, alpha: 1))
        let bakeryTrailLabel = makePastryBodyLabel(bakeryPick.bakeryTrailLine, size: 12, weight: .semibold, color: UIColor(red: 0.56, green: 0.47, blue: 0.55, alpha: 1))
        let score = makeFlavorIconRow(symbol: "smtzahrW.XfSiwlslw".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: bakeryPick.crumbScoreNote, second: nil)

        donutRow.addSubview(cover)
        donutRow.addSubview(glazeTitle)
        donutRow.addSubview(bakeryTrailLabel)
        donutRow.addSubview(score)

        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 64),
            cover.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            cover.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            cover.widthAnchor.constraint(equalToConstant: 54),
            cover.heightAnchor.constraint(equalToConstant: 54),
            glazeTitle.topAnchor.constraint(equalTo: cover.topAnchor, constant: 3),
            glazeTitle.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -10),
            bakeryTrailLabel.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 5),
            bakeryTrailLabel.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            bakeryTrailLabel.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -10),
            score.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor)
        ])
        return donutRow
    }

    private func pastryCoverAsset(for bakeryPick: shopWindowCollection) -> String {
        if UIImage(named: bakeryPick.coverAsset) != nil {
            return bakeryPick.coverAsset
        }
        let doughTitle = bakeryPick.pastryDisplayShowcase.lowercased()
        if doughTitle.contains("golden") || doughTitle.contains("cloud") {
            return "wevv_shop_golden_dough_studio"
        }
        if doughTitle.contains("moon") || doughTitle.contains("mellow") {
            return "wevv_shop_moonlight_donut_bar"
        }
        return "wevv_shop_berry_ring_bakery"
    }

    private func makePastrySectionTitle(_ text: String) -> UILabel {
        makePastryBodyLabel(text, size: 17, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1))
    }

    private func makePastryBodyLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.78
        return crumbLabel
    }

    private func makeFlavorIconRow(symbol: String, tint: UIColor, first: String, second: String?) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = tint
        icon.contentMode = .scaleAspectFit
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let firstLabel = makePastryBodyLabel(first, size: 14, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let donutRow = UIStackView(arrangedSubviews: [icon, firstLabel])
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.spacing = 4
        donutRow.alignment = .center
        if let second {
            let secondLabel = makePastryBodyLabel(second, size: 13, weight: .medium, color: UIColor(red: 0.6, green: 0.5, blue: 0.6, alpha: 1))
            donutRow.addArrangedSubview(secondLabel)
        }
        return donutRow
    }

    private func makePastryTagPill(_ tag: artisanShowcase) -> UILabel {
        let tint = UIColor.pastryHex(tag.pastelPalettePattern)
        let crumbLabel = makePastryTagText(tag.rainbowSprinkleDesign, color: tint)
        crumbLabel.backgroundColor = tint.withAlphaComponent(0.12)
        crumbLabel.layer.cornerRadius = 8
        crumbLabel.clipsToBounds = true
        crumbLabel.textAlignment = .center
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        crumbLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return crumbLabel
    }

    private func makePastryTagText(_ text: String, color: UIColor) -> UILabel {
        let crumbLabel = makePastryBodyLabel(text, size: 12, weight: .heavy, color: color)
        crumbLabel.numberOfLines = 1
        return crumbLabel
    }

    private func makeTinyTasterImage(index: Int) -> UIImage {
        let profile = tastingGuestStore.profile(at: index)
        if let glazeImage = UIImage(named: profile.donutFrameAsset) {
            return glazeImage
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 64, height: 64))
        return renderer.image { _ in
            let colors = [
                UIColor(red: 0.95, green: 0.5, blue: 0.62, alpha: 1),
                UIColor(red: 0.42, green: 0.72, blue: 0.92, alpha: 1),
                UIColor(red: 0.94, green: 0.77, blue: 0.36, alpha: 1),
                UIColor(red: 0.56, green: 0.38, blue: 0.92, alpha: 1),
                UIColor(red: 0.32, green: 0.8, blue: 0.68, alpha: 1)
            ]
            colors[index % colors.count].setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 64, height: 64)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: 18, y: 12, width: 28, height: 28)).fill()
            UIBezierPath(ovalIn: CGRect(x: 13, y: 37, width: 38, height: 20)).fill()
            UIColor(red: 0.18, green: 0.1, blue: 0.2, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 24, y: 24, width: 5, height: 5)).fill()
            UIBezierPath(ovalIn: CGRect(x: 35, y: 24, width: 5, height: 5)).fill()
        }
    }

    private func refreshPastryShelfButton() {
        let isPastryShelved = tastingJournalStore.isGlazeShelfed(bakeryPinKey: pastryFolio.donutPinKey)
        pastryShelfButton.oldFashionedParlor(isPastryShelved ? "Saved" : "SKarv+eG".wevVPastryCrumbBloomRestored)
        pastryShelfButton.isEnabled = !isPastryShelved
    }

    @objc private func closePastryDetail() {
        dismiss(animated: true)
    }

    @objc private func openProtectedWevvAction() {
        guard tastingJournalStore.isTasterReady else {
            presentPastryGate()
            return
        }
    }

    @objc private func openMorePastryPick(_ sender: UIControl) {
        let bakeryFindKey = sender.accessibilityIdentifier ?? ""
        guard let bakeryPick = pastryFolio.shopHoppingTrail.first(where: { $0.flavorLibraryEdition == bakeryFindKey }) else { return }
        let controller = WevVWevvBakeryDetailController(detail: makePastryPickDetail(bakeryPick), bakeryShelf: pastryShelf)
        controller.pastryShelfChanged = { [weak self] in
            self?.refreshPastryShelfButton()
            self?.pastryShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "ORppegnSiFn=gG idoobnZugts GsIhmoWp^.r.P.I".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func makePastryPickDetail(_ bakeryPick: shopWindowCollection) -> bakeryCollectionFolio {
        if let matchingDetail = pastryShelf.first(where: { $0.donutPinKey == bakeryPick.flavorLibraryEdition || $0.sweetShowcaseMap == bakeryPick.pastryDisplayShowcase }) {
            return matchingDetail
        }
        let coverAsset = pastryCoverAsset(for: bakeryPick)
        return bakeryCollectionFolio(
            donutPinKey: bakeryPick.flavorLibraryEdition,
            sweetShowcaseMap: bakeryPick.pastryDisplayShowcase,
            flavorMenuGuide: "FNrXevsOhJ rdWoTnMuNtr VpliUcbkJsh D·O Clro!craoln CfHa#vWoZrdi?tfev".wevVPastryCrumbBloomRestored,
            glazeGalleryGuide: coverAsset,
            crumbScoreNote: bakeryPick.crumbScoreNote,
            tastingSequenceInsight: "(n1f2f8d ?rCeJvBiseBwqsp)*".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: bakeryPick.bakeryTrailLine,
            seasonalMenuCollection: [
                artisanShowcase(donutPinKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "CCopzsyb".wevVPastryCrumbBloomRestored, pastelPalettePattern: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, pastelPalettePattern: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored)
            ],
            tastingMemoryCollection: pastryFolio.tastingMemoryCollection,
            shopHoppingTrail: pastryShelf.filter { $0.sweetShowcaseMap != bakeryPick.pastryDisplayShowcase }.prefix(2).map {
                shopWindowCollection(flavorLibraryEdition: $0.donutPinKey, pastryDisplayShowcase: $0.sweetShowcaseMap, bakeryTrailLine: $0.bakeryTrailLine, crumbScoreNote: $0.crumbScoreNote, coverAsset: $0.glazeGalleryGuide)
            }
        )
    }

    @objc private func openTastingForm() {
        guard tastingJournalStore.isTasterReady else {
            presentPastryGate()
            return
        }
        let controller = WevVFlavorNoteController(bakeryPinKey: pastryFolio.donutPinKey)
        controller.onFlavorNoteSaved = { [weak self] in
            self?.refreshTastingRow()
            self?.pastryShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "LPoYaOdGiFnxgu yrDe@vMiEeewA TfWoTrkmL.r.T.K".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func placePastryIntoShelf() {
        guard tastingJournalStore.isTasterReady else {
            presentPastryGate()
            return
        }
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Sgaavxi:nhgY AsQhco$pS.+.S.I".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            guard self.tastingJournalStore.placeGlazeShelf(bakeryPinKey: self.pastryFolio.donutPinKey) else {
                self.refreshPastryShelfButton()
                return
            }
            self.refreshPastryShelfButton()
            self.pastryShelfChanged?()
            self.showPastrySuccess()
        }
    }

    private func presentPastryGate() {
        let gate = WevVWevvBakerytropicalMangoEssence()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshPastryShelfButton()
                self?.pastryShelfChanged?()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func showPastrySuccess() {
        let layer = WevVWevvBakeryShelfToastView()
        layer.alpha = 0
        layer.firstGlazeDelight = { [weak self, weak layer] in
            UIView.animate(withDuration: 0.18, animations: {
                layer?.alpha = 0
            }, completion: { _ in
                layer?.removeFromSuperview()
                self?.tastingSuccessLayer = nil
            })
        }
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tastingSuccessLayer = layer
        UIView.animate(withDuration: 0.22) {
            layer.alpha = 1
        }
    }
}

private extension UIColor {
    static func pastryHex(_ hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        let red = CGFloat((value & 0xFF0000) >> 16) / 255
        let green = CGFloat((value & 0x00FF00) >> 8) / 255
        let blue = CGFloat(value & 0x0000FF) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
