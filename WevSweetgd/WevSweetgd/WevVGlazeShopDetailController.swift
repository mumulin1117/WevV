import UIKit

final class WevVWevvBakeryDetailController: UIViewController {
    private let wevvBakeryDetail: WevVWevvBakeryDetail
    private let bakeryShelf: [WevVWevvBakeryDetail]
    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvTasterStore = WevVGuestGlazeStore.shared
    private let wevvFritterScroll = UIScrollView()
    private let wevvBakeryCanvas = UIView()
    private let wevvCrumbTastingRow = UIStackView()
    private let wevvShelfButton = WevVWevvMaplePillButton(title: "SKa%v@et".wevVPastryCrumbBloomRestored)
    private var wevvSuccessLayer: WevVWevvBakeryShelfToastView?
    private var wevvNoticeSheet: WevVGlazeSafetySheet?

    var onWevvShelfChanged: (() -> Void)?

    init(detail: WevVWevvBakeryDetail, bakeryShelf: [WevVWevvBakeryDetail] = []) {
        self.wevvBakeryDetail = detail
        self.bakeryShelf = bakeryShelf.isEmpty ? [detail] : bakeryShelf
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildWevvBakeryBackdrop()
        buildWevvBakeryScroll()
        buildWevvBakeryDetailContent()
        buildWevvBottomGlazeActions()
        refreshWevvShelfButton()
    }

    private func buildWevvBakeryBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)

        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        backdrop.alpha = 0.52
        view.addSubview(backdrop)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildWevvBakeryScroll() {
        wevvFritterScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.showsVerticalScrollIndicator = false
        wevvFritterScroll.contentInset.bottom = 112
        wevvFritterScroll.verticalScrollIndicatorInsets.bottom = 112
        view.addSubview(wevvFritterScroll)

        wevvBakeryCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.addSubview(wevvBakeryCanvas)

        NSLayoutConstraint.activate([
            wevvFritterScroll.topAnchor.constraint(equalTo: view.topAnchor),
            wevvFritterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvFritterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvFritterScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvBakeryCanvas.topAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.topAnchor),
            wevvBakeryCanvas.leadingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.leadingAnchor),
            wevvBakeryCanvas.trailingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.trailingAnchor),
            wevvBakeryCanvas.bottomAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.bottomAnchor),
            wevvBakeryCanvas.widthAnchor.constraint(equalTo: wevvFritterScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildWevvBakeryDetailContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closeWevvBakeryDetail), for: .touchUpInside)

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = "DmownouOtQ nSAhgo?pZs.".wevVPastryCrumbBloomRestored
        glazeTitle.font = .systemFont(ofSize: 17, weight: .heavy)
        glazeTitle.textColor = UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1)
        glazeTitle.textAlignment = .center

        let safetyButton = UIButton(type: .system)
        safetyButton.translatesAutoresizingMaskIntoConstraints = false
        safetyButton.setImage(UIImage(systemName: "flag"), for: .normal)
        safetyButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        safetyButton.addTarget(self, action: #selector(openWevvNoticeSheet), for: .touchUpInside)

        let bakeryCard = makeWevvHeroBakeryCard()
        let parlorCard = makeWevvParlorCard()
        let crumbTastingTitle = makeWevvSectionTitle("Rpe+cQeQnttH MRNeNvQiKeiw:sf".wevVPastryCrumbBloomRestored)
        wevvCrumbTastingRow.translatesAutoresizingMaskIntoConstraints = false
        wevvCrumbTastingRow.axis = .horizontal
        wevvCrumbTastingRow.spacing = 10
        wevvCrumbTastingRow.distribution = .fillEqually
        refreshWevvCrumbTastingRow()

        let bakeryFindsTitle = makeWevvSectionTitle("Meo%reeE DS*hAoSpls&".wevVPastryCrumbBloomRestored)
        let bakeryFindsStack = UIStackView(arrangedSubviews: wevvBakeryDetail.bakeryFinds.map { makeWevvBakeryFindRow($0) })
        bakeryFindsStack.translatesAutoresizingMaskIntoConstraints = false
        bakeryFindsStack.axis = .vertical
        bakeryFindsStack.spacing = 12

        placeWevvDetailContentViews(doughBackButton: doughBackButton, title: glazeTitle, safetyButton: safetyButton, bakeryCard: bakeryCard, parlorCard: parlorCard, crumbTastingTitle: crumbTastingTitle, bakeryFindsTitle: bakeryFindsTitle, bakeryFindsStack: bakeryFindsStack)
        pinWevvDetailContentLayout(doughBackButton: doughBackButton, title: glazeTitle, safetyButton: safetyButton, bakeryCard: bakeryCard, parlorCard: parlorCard, crumbTastingTitle: crumbTastingTitle, bakeryFindsTitle: bakeryFindsTitle, bakeryFindsStack: bakeryFindsStack)
    }

    private func placeWevvDetailContentViews(doughBackButton: UIButton, title: UILabel, safetyButton: UIButton, bakeryCard: UIView, parlorCard: UIView, crumbTastingTitle: UILabel, bakeryFindsTitle: UILabel, bakeryFindsStack: UIStackView) {
        [doughBackButton, title, safetyButton, bakeryCard, parlorCard, crumbTastingTitle, wevvCrumbTastingRow, bakeryFindsTitle, bakeryFindsStack].forEach {
            wevvBakeryCanvas.addSubview($0)
        }
    }

    private func pinWevvDetailContentLayout(doughBackButton: UIButton, title: UILabel, safetyButton: UIButton, bakeryCard: UIView, parlorCard: UIView, crumbTastingTitle: UILabel, bakeryFindsTitle: UILabel, bakeryFindsStack: UIStackView) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: wevvBakeryCanvas.safeAreaLayoutGuide.topAnchor, constant: 22),
            doughBackButton.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 18),
            doughBackButton.widthAnchor.constraint(equalToConstant: 34),
            doughBackButton.heightAnchor.constraint(equalToConstant: 34),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: wevvBakeryCanvas.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -12),
            safetyButton.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            safetyButton.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -18),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34),
            bakeryCard.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 16),
            bakeryCard.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 14),
            bakeryCard.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -14),
            parlorCard.topAnchor.constraint(equalTo: bakeryCard.bottomAnchor, constant: 12),
            parlorCard.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            parlorCard.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            crumbTastingTitle.topAnchor.constraint(equalTo: parlorCard.bottomAnchor, constant: 12),
            crumbTastingTitle.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            crumbTastingTitle.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            wevvCrumbTastingRow.topAnchor.constraint(equalTo: crumbTastingTitle.bottomAnchor, constant: 10),
            wevvCrumbTastingRow.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            wevvCrumbTastingRow.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsTitle.topAnchor.constraint(equalTo: wevvCrumbTastingRow.bottomAnchor, constant: 16),
            bakeryFindsTitle.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            bakeryFindsTitle.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsStack.topAnchor.constraint(equalTo: bakeryFindsTitle.bottomAnchor, constant: 10),
            bakeryFindsStack.leadingAnchor.constraint(equalTo: bakeryCard.leadingAnchor),
            bakeryFindsStack.trailingAnchor.constraint(equalTo: bakeryCard.trailingAnchor),
            bakeryFindsStack.bottomAnchor.constraint(equalTo: wevvBakeryCanvas.bottomAnchor, constant: -24)
        ])
    }

    private func buildWevvBottomGlazeActions() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 0.94)
        view.addSubview(bar)

        let crumbTastingButton = WevVWevvMaplePillButton(title: "RGervvihe,wa".wevVPastryCrumbBloomRestored)
        crumbTastingButton.addTarget(self, action: #selector(openWevvCrumbTastingForm), for: .touchUpInside)
        wevvShelfButton.addTarget(self, action: #selector(placeWevvBakeryIntoShelf), for: .touchUpInside)

        bar.addSubview(crumbTastingButton)
        bar.addSubview(wevvShelfButton)

        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bar.heightAnchor.constraint(equalToConstant: 86),
            crumbTastingButton.topAnchor.constraint(equalTo: bar.topAnchor, constant: 10),
            crumbTastingButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 15),
            crumbTastingButton.widthAnchor.constraint(equalToConstant: 81),
            crumbTastingButton.heightAnchor.constraint(equalToConstant: 52),
            wevvShelfButton.topAnchor.constraint(equalTo: crumbTastingButton.topAnchor),
            wevvShelfButton.leadingAnchor.constraint(equalTo: crumbTastingButton.trailingAnchor, constant: 9),
            wevvShelfButton.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -15),
            wevvShelfButton.heightAnchor.constraint(equalTo: crumbTastingButton.heightAnchor)
        ])
    }

    private func makeWevvHeroBakeryCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 16
        pastryCard.layer.shadowColor = UIColor(red: 0.57, green: 0.25, blue: 0.48, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.08
        pastryCard.layer.shadowRadius = 14
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        let cover = UIImageView(image: UIImage(named: wevvBakeryDetail.pastryFlight))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12

        let donutTasterName = makeWevvBodyLabel(wevvBakeryDetail.sprinkleFlight, size: 17, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let frostingSubtitle = makeWevvBodyLabel(wevvBakeryDetail.crumbFlight, size: 13, weight: .medium, color: UIColor(red: 0.58, green: 0.48, blue: 0.58, alpha: 1))

        let crumbScoreRow = makeWevvIconTextRow(symbol: "sntlafr*.kfSiMldl/".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.75, blue: 0.08, alpha: 1), first: wevvBakeryDetail.crumbScoreNote, second: wevvBakeryDetail.tastingNoteText)
        let bakeryTrailRow = makeWevvIconTextRow(symbol: "mOaPp#pyi*nT.ecjisrhcGlCeG.Nf?idlxlE".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1), first: wevvBakeryDetail.bakeryTrailLine, second: nil)

        let bakeryTagRow = UIStackView(arrangedSubviews: wevvBakeryDetail.bakeryTags.map { makeWevvTagPill($0) })
        bakeryTagRow.translatesAutoresizingMaskIntoConstraints = false
        bakeryTagRow.axis = .horizontal
        bakeryTagRow.spacing = 8
        bakeryTagRow.alignment = .leading

        pastryCard.addSubview(cover)
        pastryCard.addSubview(donutTasterName)
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
            donutTasterName.topAnchor.constraint(equalTo: cover.topAnchor, constant: 4),
            donutTasterName.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            donutTasterName.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -12),
            frostingSubtitle.topAnchor.constraint(equalTo: donutTasterName.bottomAnchor, constant: 7),
            frostingSubtitle.leadingAnchor.constraint(equalTo: donutTasterName.leadingAnchor),
            frostingSubtitle.trailingAnchor.constraint(equalTo: donutTasterName.trailingAnchor),
            crumbScoreRow.topAnchor.constraint(equalTo: frostingSubtitle.bottomAnchor, constant: 14),
            crumbScoreRow.leadingAnchor.constraint(equalTo: donutTasterName.leadingAnchor),
            crumbScoreRow.trailingAnchor.constraint(lessThanOrEqualTo: donutTasterName.trailingAnchor),
            bakeryTrailRow.topAnchor.constraint(equalTo: crumbScoreRow.bottomAnchor, constant: 12),
            bakeryTrailRow.leadingAnchor.constraint(equalTo: donutTasterName.leadingAnchor),
            bakeryTrailRow.trailingAnchor.constraint(equalTo: donutTasterName.trailingAnchor),
            bakeryTagRow.topAnchor.constraint(equalTo: bakeryTrailRow.bottomAnchor, constant: 16),
            bakeryTagRow.leadingAnchor.constraint(equalTo: donutTasterName.leadingAnchor),
            bakeryTagRow.trailingAnchor.constraint(lessThanOrEqualTo: donutTasterName.trailingAnchor),
            bakeryTagRow.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -15)
        ])
        return pastryCard
    }

    private func makeWevvParlorCard() -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.layer.cornerRadius = 14
        pastryCard.layer.masksToBounds = true
        pastryCard.addTarget(self, action: #selector(openWevvTastingParlor), for: .touchUpInside)

        let glazeLayer = CAGradientLayer()
        glazeLayer.colors = [
            UIColor(red: 1, green: 0.23, blue: 0.66, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.42, blue: 0.73, alpha: 1).cgColor
        ]
        glazeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        pastryCard.layer.insertSublayer(glazeLayer, at: 0)

        let glazeTitle = makeWevvBodyLabel(wevvBakeryDetail.tastingParlorTitle, size: 20, weight: .heavy, color: .white)
        let line = makeWevvBodyLabel(wevvBakeryDetail.tastingParlorLine, size: 14, weight: .semibold, color: UIColor.white.withAlphaComponent(0.9))

        let avatarRow = UIStackView()
        avatarRow.translatesAutoresizingMaskIntoConstraints = false
        avatarRow.axis = .horizontal
        avatarRow.spacing = -7
        for index in 0..<4 {
            let avatar = UIImageView(image: makeWevvTinyTasterImage(index: index))
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.layer.cornerRadius = 15
            avatar.layer.borderWidth = 1.5
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.clipsToBounds = true
            avatarRow.addArrangedSubview(avatar)
            avatar.widthAnchor.constraint(equalToConstant: 30).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }

        let crowd = makeWevvTinyPill(wevvBakeryDetail.tastingTableText)
        let enter = makeWevvTinyPill(" ^JHo:icn@ qRKoPolmk :".wevVPastryCrumbBloomRestored)

        placeWevvParlorCardViews(pastryCard: pastryCard, title: glazeTitle, line: line, avatarRow: avatarRow, crowd: crowd, enter: enter)
        pinWevvParlorCardLayout(pastryCard: pastryCard, title: glazeTitle, line: line, avatarRow: avatarRow, crowd: crowd, enter: enter)
        pastryCard.layoutIfNeeded()
        glazeLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 28, height: 129)
        return pastryCard
    }

    private func placeWevvParlorCardViews(pastryCard: UIControl, title: UILabel, line: UILabel, avatarRow: UIStackView, crowd: UILabel, enter: UILabel) {
        pastryCard.addSubview(title)
        pastryCard.addSubview(line)
        pastryCard.addSubview(avatarRow)
        pastryCard.addSubview(crowd)
        pastryCard.addSubview(enter)
    }

    private func pinWevvParlorCardLayout(pastryCard: UIControl, title: UILabel, line: UILabel, avatarRow: UIStackView, crowd: UILabel, enter: UILabel) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 129),
            title.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 26),
            title.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 14),
            title.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14),
            line.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            line.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            avatarRow.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            avatarRow.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -24),
            crowd.centerYAnchor.constraint(equalTo: avatarRow.centerYAnchor),
            crowd.leadingAnchor.constraint(equalTo: avatarRow.trailingAnchor, constant: 10),
            enter.centerYAnchor.constraint(equalTo: avatarRow.centerYAnchor),
            enter.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14)
        ])
    }

    private func makeWevvCrumbTastingCard(_ crumbTasting: WevVWevvCrumbTasting) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 12
        pastryCard.addTarget(self, action: #selector(openProtectedWevvAction), for: .touchUpInside)

        let avatar = UIImageView(image: makeWevvCrumbTastingAvatar(crumbTasting))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 15
        avatar.clipsToBounds = true

        let donutTasterName = makeWevvBodyLabel(crumbTasting.donutTasterName, size: 16, weight: .heavy, color: UIColor(red: 0.17, green: 0.08, blue: 0.2, alpha: 1))
        let flavorRoleLabel = makeWevvBodyLabel(crumbTasting.flavorRole, size: 12, weight: .semibold, color: UIColor(red: 0.68, green: 0.56, blue: 0.65, alpha: 1))
        let score = makeWevvIconTextRow(symbol: "s/t#amrH.lfNijlwlL".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: crumbTasting.crumbScoreNote, second: nil)
        let biteNoteLabel = makeWevvBodyLabel(crumbTasting.biteNoteText, size: 13, weight: .medium, color: UIColor(red: 0.43, green: 0.35, blue: 0.43, alpha: 1))
        biteNoteLabel.numberOfLines = 2
        let donutBadgeLabel = makeWevvTagText(crumbTasting.donutBadgeText, color: UIColor(red: 1, green: 0.25, blue: 0.61, alpha: 1))

        pastryCard.addSubview(avatar)
        pastryCard.addSubview(donutTasterName)
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
            donutTasterName.topAnchor.constraint(equalTo: avatar.topAnchor),
            donutTasterName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 7),
            donutTasterName.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -5),
            flavorRoleLabel.topAnchor.constraint(equalTo: donutTasterName.bottomAnchor, constant: 1),
            flavorRoleLabel.leadingAnchor.constraint(equalTo: donutTasterName.leadingAnchor),
            flavorRoleLabel.trailingAnchor.constraint(equalTo: donutTasterName.trailingAnchor),
            score.centerYAnchor.constraint(equalTo: donutTasterName.centerYAnchor),
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

    private func refreshWevvCrumbTastingRow() {
        wevvCrumbTastingRow.arrangedSubviews.forEach { crumbCard in
            wevvCrumbTastingRow.removeArrangedSubview(crumbCard)
            crumbCard.removeFromSuperview()
        }
        currentWevvCrumbTastings().prefix(2).forEach { wevvCrumbTastingRow.addArrangedSubview(makeWevvCrumbTastingCard($0)) }
    }

    private func currentWevvCrumbTastings() -> [WevVWevvCrumbTasting] {
        let localReviews = wevvDonutJournalStore.crumbNotePackets(for: wevvBakeryDetail.donutPinKey).map { packet in
            WevVWevvCrumbTasting(
                sprinkleJarKey: "\(packet.bakeryPinKey)\(packet.ringCutterKey)\(Int(packet.timeInterval))",
                donutTasterName: packet.glazeNickname,
                flavorRole: "DVohn,uFtU ctnaXsWtSeorI".wevVPastryCrumbBloomRestored,
                crumbScoreNote: String(format: "%!.K1#fH".wevVPastryCrumbBloomRestored, Double(packet.powderedSampler)),
                biteNoteText: packet.powderedFinder,
                donutBadgeText: "FsrmersohX jN#oftAe?".wevVPastryCrumbBloomRestored,
                donutFrameAsset: packet.donutFrameAsset
            )
        }
        return localReviews + wevvBakeryDetail.crumbTastings
    }

    private func makeWevvCrumbTastingAvatar(_ crumbTasting: WevVWevvCrumbTasting) -> UIImage? {
        if let donutFrameAsset = crumbTasting.donutFrameAsset, let glazeImage = UIImage(named: donutFrameAsset) {
            return glazeImage
        }
        return makeWevvTinyTasterImage(index: abs(crumbTasting.sprinkleJarKey.hashValue % 5))
    }

    private func makeWevvBakeryFindRow(_ bakeryPick: WevVWevvBakeryPick) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.accessibilityIdentifier = bakeryPick.sugarDustKey
        donutRow.addTarget(self, action: #selector(openMoreWevvBakeryPick(_:)), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: wevvBakeryCoverAsset(for: bakeryPick)))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 8

        let glazeTitle = makeWevvBodyLabel(bakeryPick.treatFlight, size: 16, weight: .heavy, color: UIColor(red: 0.15, green: 0.08, blue: 0.2, alpha: 1))
        let bakeryTrailLabel = makeWevvBodyLabel(bakeryPick.bakeryTrailLine, size: 12, weight: .semibold, color: UIColor(red: 0.56, green: 0.47, blue: 0.55, alpha: 1))
        let score = makeWevvIconTextRow(symbol: "smtzahrW.XfSiwlslw".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: bakeryPick.crumbScoreNote, second: nil)

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

    private func wevvBakeryCoverAsset(for bakeryPick: WevVWevvBakeryPick) -> String {
        if UIImage(named: bakeryPick.coverAsset) != nil {
            return bakeryPick.coverAsset
        }
        let doughTitle = bakeryPick.treatFlight.lowercased()
        if doughTitle.contains("golden") || doughTitle.contains("cloud") {
            return "wevv_shop_golden_dough_studio"
        }
        if doughTitle.contains("moon") || doughTitle.contains("mellow") {
            return "wevv_shop_moonlight_donut_bar"
        }
        return "wevv_shop_berry_ring_bakery"
    }

    private func makeWevvSectionTitle(_ text: String) -> UILabel {
        makeWevvBodyLabel(text, size: 17, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1))
    }

    private func makeWevvBodyLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.78
        return crumbLabel
    }

    private func makeWevvIconTextRow(symbol: String, tint: UIColor, first: String, second: String?) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = tint
        icon.contentMode = .scaleAspectFit
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let firstLabel = makeWevvBodyLabel(first, size: 14, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let donutRow = UIStackView(arrangedSubviews: [icon, firstLabel])
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.spacing = 4
        donutRow.alignment = .center
        if let second {
            let secondLabel = makeWevvBodyLabel(second, size: 13, weight: .medium, color: UIColor(red: 0.6, green: 0.5, blue: 0.6, alpha: 1))
            donutRow.addArrangedSubview(secondLabel)
        }
        return donutRow
    }

    private func makeWevvTagPill(_ tag: WevVWevvBakeryTag) -> UILabel {
        let color = UIColor.wevvHex(tag.tintHex)
        let crumbLabel = makeWevvTagText(tag.flavorFlight, color: color)
        crumbLabel.backgroundColor = color.withAlphaComponent(0.12)
        crumbLabel.layer.cornerRadius = 8
        crumbLabel.clipsToBounds = true
        crumbLabel.textAlignment = .center
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        crumbLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return crumbLabel
    }

    private func makeWevvTagText(_ text: String, color: UIColor) -> UILabel {
        let crumbLabel = makeWevvBodyLabel(text, size: 12, weight: .heavy, color: color)
        crumbLabel.numberOfLines = 1
        return crumbLabel
    }

    private func makeWevvTinyPill(_ text: String) -> UILabel {
        let crumbLabel = makeWevvBodyLabel(text, size: 14, weight: .heavy, color: UIColor(red: 1, green: 0.35, blue: 0.7, alpha: 1))
        crumbLabel.backgroundColor = .white
        crumbLabel.textAlignment = .center
        crumbLabel.layer.cornerRadius = 14
        crumbLabel.clipsToBounds = true
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        crumbLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return crumbLabel
    }

    private func makeWevvTinyTasterImage(index: Int) -> UIImage {
        let profile = wevvTasterStore.profile(at: index)
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

    private func refreshWevvShelfButton() {
        let isBakeryShelfed = wevvDonutJournalStore.isGlazeShelfed(bakeryPinKey: wevvBakeryDetail.donutPinKey)
        wevvShelfButton.oldFashionedParlor(isBakeryShelfed ? "Saved" : "SKarv+eG".wevVPastryCrumbBloomRestored)
        wevvShelfButton.isEnabled = !isBakeryShelfed
    }

    @objc private func closeWevvBakeryDetail() {
        dismiss(animated: true)
    }

    @objc private func openProtectedWevvAction() {
        guard wevvDonutJournalStore.isTasterReady else {
            presentWevvBakeryGate()
            return
        }
    }

    @objc private func openMoreWevvBakeryPick(_ sender: UIControl) {
        let bakeryFindKey = sender.accessibilityIdentifier ?? ""
        guard let bakeryPick = wevvBakeryDetail.bakeryFinds.first(where: { $0.sugarDustKey == bakeryFindKey }) else { return }
        let controller = WevVWevvBakeryDetailController(detail: makeWevvBakeryPickDetail(bakeryPick), bakeryShelf: bakeryShelf)
        controller.onWevvShelfChanged = { [weak self] in
            self?.refreshWevvShelfButton()
            self?.onWevvShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "ORppegnSiFn=gG idoobnZugts GsIhmoWp^.r.P.I".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func makeWevvBakeryPickDetail(_ bakeryPick: WevVWevvBakeryPick) -> WevVWevvBakeryDetail {
        if let matchingDetail = bakeryShelf.first(where: { $0.donutPinKey == bakeryPick.sugarDustKey || $0.sprinkleFlight == bakeryPick.treatFlight }) {
            return matchingDetail
        }
        let coverAsset = wevvBakeryCoverAsset(for: bakeryPick)
        return WevVWevvBakeryDetail(
            donutPinKey: bakeryPick.sugarDustKey,
            sprinkleFlight: bakeryPick.treatFlight,
            crumbFlight: "FNrXevsOhJ rdWoTnMuNtr VpliUcbkJsh D·O Clro!craoln CfHa#vWoZrdi?tfev".wevVPastryCrumbBloomRestored,
            pastryFlight: coverAsset,
            crumbScoreNote: bakeryPick.crumbScoreNote,
            tastingNoteText: "(n1f2f8d ?rCeJvBiseBwqsp)*".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: bakeryPick.bakeryTrailLine,
            bakeryTags: [
                WevVWevvBakeryTag(donutPinKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, flavorFlight: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, tintHex: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, flavorFlight: "CCopzsyb".wevVPastryCrumbBloomRestored, tintHex: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, flavorFlight: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, tintHex: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored)
            ],
            tastingParlorTitle: "D?oMn@uWtV YLuoSvOehrCsk aRtoEosmz".wevVPastryCrumbBloomRestored,
            tastingParlorLine: "ODptexn! VfcoWr@ Ws@wVe@e~tH usshro!pc GnQovtHeSsx,O qfJrNefs*hk LpLiDcWkrsI,c #awnWdP WcUo?z%yS vdZoWndu#t~ NtBaalJk#.N".wevVPastryCrumbBloomRestored,
            tastingTableText: "2U8F qognblWiMn%eg".wevVPastryCrumbBloomRestored,
            crumbTastings: wevvBakeryDetail.crumbTastings,
            bakeryFinds: bakeryShelf.filter { $0.sprinkleFlight != bakeryPick.treatFlight }.prefix(2).map {
                WevVWevvBakeryPick(sugarDustKey: $0.donutPinKey, treatFlight: $0.sprinkleFlight, bakeryTrailLine: $0.bakeryTrailLine, crumbScoreNote: $0.crumbScoreNote, coverAsset: $0.pastryFlight)
            }
        )
    }

    @objc private func openWevvTastingParlor() {
        guard wevvDonutJournalStore.isTasterReady else {
            presentWevvBakeryGate()
            return
        }
        let controller = WevVWevvTastingParlorController(donutPinKey: wevvBakeryDetail.donutPinKey, bakeryTitle: wevvBakeryDetail.sprinkleFlight)
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "OOpieannijngg% erTojo:mo.P.d.l".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openWevvCrumbTastingForm() {
        guard wevvDonutJournalStore.isTasterReady else {
            presentWevvBakeryGate()
            return
        }
        let controller = WevVFlavorNoteController(bakeryPinKey: wevvBakeryDetail.donutPinKey)
        controller.onFlavorNoteSaved = { [weak self] in
            self?.refreshWevvCrumbTastingRow()
            self?.onWevvShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "LPoYaOdGiFnxgu yrDe@vMiEeewA TfWoTrkmL.r.T.K".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func placeWevvBakeryIntoShelf() {
        guard wevvDonutJournalStore.isTasterReady else {
            presentWevvBakeryGate()
            return
        }
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Sgaavxi:nhgY AsQhco$pS.+.S.I".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            guard self.wevvDonutJournalStore.placeGlazeShelf(bakeryPinKey: self.wevvBakeryDetail.donutPinKey) else {
                self.refreshWevvShelfButton()
                return
            }
            self.refreshWevvShelfButton()
            self.onWevvShelfChanged?()
            self.showWevvShelfSuccess()
        }
    }

    @objc private func openWevvNoticeSheet() {
        guard wevvDonutJournalStore.isTasterReady else {
            presentWevvBakeryGate()
            return
        }
        guard wevvNoticeSheet == nil else { return }
        let noticeChoices = [
            WevVGlazeSafetyChoice(sugarDustKey: "fiaMkUeWPHhUo+tIoL".wevVPastryCrumbBloomRestored, almondCase: "Fnavkveb /pohCoGtfo;".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "s#c,a/miCDo%m@mPeCricSiSaWlf".wevVPastryCrumbBloomRestored, almondCase: "Socuahmj YovrS FcdommjmYeVrCcLi=aylc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "ncolt%IMnXt~ewrSeDs*tne:dz".wevVPastryCrumbBloomRestored, almondCase: "Njoxt: XiJnItLefrve:sWt?etdL".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "o,tIhQe*rOS.u=gxaOr@".wevVPastryCrumbBloomRestored, almondCase: "OBt~hseXrb".wevVPastryCrumbBloomRestored, needsCreamText: true)
        ]
        let sheet = WevVGlazeSafetySheet(bakeryPinKey: wevvBakeryDetail.donutPinKey, choices: noticeChoices)
        sheet.alpha = 0
        sheet.almondMixer = { [weak self, weak sheet] in
            self?.hideWevvNoticeSheet(sheet)
        }
        sheet.almondBench = { [weak self, weak sheet] packet in
            self?.wevvDonutJournalStore.placeGlazeSafetyCrumb(packet)
            self?.hideWevvNoticeSheet(sheet)
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        wevvNoticeSheet = sheet
        UIView.animate(withDuration: 0.18) {
            sheet.alpha = 1
        }
    }

    private func hideWevvNoticeSheet(_ sheet: WevVGlazeSafetySheet?) {
        UIView.animate(withDuration: 0.18, animations: {
            sheet?.alpha = 0
        }, completion: { [weak self, weak sheet] _ in
            sheet?.removeFromSuperview()
            self?.wevvNoticeSheet = nil
        })
    }

    private func presentWevvBakeryGate() {
        let gate = WevVWevvBakeryGateController()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshWevvShelfButton()
                self?.onWevvShelfChanged?()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func showWevvShelfSuccess() {
        let layer = WevVWevvBakeryShelfToastView()
        layer.alpha = 0
        layer.onWevvSugarDismiss = { [weak self, weak layer] in
            UIView.animate(withDuration: 0.18, animations: {
                layer?.alpha = 0
            }, completion: { _ in
                layer?.removeFromSuperview()
                self?.wevvSuccessLayer = nil
            })
        }
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        wevvSuccessLayer = layer
        UIView.animate(withDuration: 0.22) {
            layer.alpha = 1
        }
    }
}

private extension UIColor {
    static func wevvHex(_ hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        let red = CGFloat((value & 0xFF0000) >> 16) / 255
        let green = CGFloat((value & 0x00FF00) >> 8) / 255
        let blue = CGFloat(value & 0x0000FF) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
