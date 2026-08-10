import UIKit

final class WevVGlazeShopDetailController: UIViewController {
    private let glazeDetail: WevVGlazeShopDetail
    private let glazeShelf: [WevVGlazeShopDetail]
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let reviewRow = UIStackView()
    private let shelfButton = WevVGlazePillButton(title: "SKa%v@et".wevVPastryCrumbBloomRestored)
    private var successLayer: WevVShelfSuccessView?
    private var safetySheet: WevVGlazeSafetySheet?

    var onShelfChanged: (() -> Void)?

    init(detail: WevVGlazeShopDetail, glazeShelf: [WevVGlazeShopDetail] = []) {
        self.glazeDetail = detail
        self.glazeShelf = glazeShelf.isEmpty ? [detail] : glazeShelf
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarBackdrop()
        buildFrostingScroll()
        buildDonutDetailContent()
        buildBottomGlazeActions()
        refreshShelfButton()
    }

    private func buildSugarBackdrop() {
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

    private func buildFrostingScroll() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.showsVerticalScrollIndicator = false
        frostingScroll.contentInset.bottom = 112
        frostingScroll.verticalScrollIndicatorInsets.bottom = 112
        view.addSubview(frostingScroll)

        sprinkleContent.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.addSubview(sprinkleContent)

        NSLayoutConstraint.activate([
            frostingScroll.topAnchor.constraint(equalTo: view.topAnchor),
            frostingScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sprinkleContent.topAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.topAnchor),
            sprinkleContent.leadingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.leadingAnchor),
            sprinkleContent.trailingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.trailingAnchor),
            sprinkleContent.bottomAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.bottomAnchor),
            sprinkleContent.widthAnchor.constraint(equalTo: frostingScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildDonutDetailContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closeGlazeDetail), for: .touchUpInside)

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
        safetyButton.addTarget(self, action: #selector(openGlazeSafetySheet), for: .touchUpInside)

        let shopCard = makeHeroShopCard()
        let parlorCard = makeParlorCard()
        let recentTitle = makeSectionTitle("Rpe+cQeQnttH MRNeNvQiKeiw:sf".wevVPastryCrumbBloomRestored)
        reviewRow.translatesAutoresizingMaskIntoConstraints = false
        reviewRow.axis = .horizontal
        reviewRow.spacing = 10
        reviewRow.distribution = .fillEqually
        refreshCrumbReviewRow()

        let moreTitle = makeSectionTitle("Meo%reeE DS*hAoSpls&".wevVPastryCrumbBloomRestored)
        let moreStack = UIStackView(arrangedSubviews: glazeDetail.morePicks.map { makeMorePickRow($0) })
        moreStack.translatesAutoresizingMaskIntoConstraints = false
        moreStack.axis = .vertical
        moreStack.spacing = 12

        placeDetailContentViews(doughBackButton: doughBackButton, title: glazeTitle, safetyButton: safetyButton, shopCard: shopCard, parlorCard: parlorCard, recentTitle: recentTitle, moreTitle: moreTitle, moreStack: moreStack)
        pinDetailContentLayout(doughBackButton: doughBackButton, title: glazeTitle, safetyButton: safetyButton, shopCard: shopCard, parlorCard: parlorCard, recentTitle: recentTitle, moreTitle: moreTitle, moreStack: moreStack)
    }

    private func placeDetailContentViews(doughBackButton: UIButton, title: UILabel, safetyButton: UIButton, shopCard: UIView, parlorCard: UIView, recentTitle: UILabel, moreTitle: UILabel, moreStack: UIStackView) {
        [doughBackButton, title, safetyButton, shopCard, parlorCard, recentTitle, reviewRow, moreTitle, moreStack].forEach {
            sprinkleContent.addSubview($0)
        }
    }

    private func pinDetailContentLayout(doughBackButton: UIButton, title: UILabel, safetyButton: UIButton, shopCard: UIView, parlorCard: UIView, recentTitle: UILabel, moreTitle: UILabel, moreStack: UIStackView) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 22),
            doughBackButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 18),
            doughBackButton.widthAnchor.constraint(equalToConstant: 34),
            doughBackButton.heightAnchor.constraint(equalToConstant: 34),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: sprinkleContent.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -12),
            safetyButton.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            safetyButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -18),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34),
            shopCard.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 16),
            shopCard.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 14),
            shopCard.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -14),
            parlorCard.topAnchor.constraint(equalTo: shopCard.bottomAnchor, constant: 12),
            parlorCard.leadingAnchor.constraint(equalTo: shopCard.leadingAnchor),
            parlorCard.trailingAnchor.constraint(equalTo: shopCard.trailingAnchor),
            recentTitle.topAnchor.constraint(equalTo: parlorCard.bottomAnchor, constant: 12),
            recentTitle.leadingAnchor.constraint(equalTo: shopCard.leadingAnchor),
            recentTitle.trailingAnchor.constraint(equalTo: shopCard.trailingAnchor),
            reviewRow.topAnchor.constraint(equalTo: recentTitle.bottomAnchor, constant: 10),
            reviewRow.leadingAnchor.constraint(equalTo: shopCard.leadingAnchor),
            reviewRow.trailingAnchor.constraint(equalTo: shopCard.trailingAnchor),
            moreTitle.topAnchor.constraint(equalTo: reviewRow.bottomAnchor, constant: 16),
            moreTitle.leadingAnchor.constraint(equalTo: shopCard.leadingAnchor),
            moreTitle.trailingAnchor.constraint(equalTo: shopCard.trailingAnchor),
            moreStack.topAnchor.constraint(equalTo: moreTitle.bottomAnchor, constant: 10),
            moreStack.leadingAnchor.constraint(equalTo: shopCard.leadingAnchor),
            moreStack.trailingAnchor.constraint(equalTo: shopCard.trailingAnchor),
            moreStack.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor, constant: -24)
        ])
    }

    private func buildBottomGlazeActions() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 0.94)
        view.addSubview(bar)

        let reviewButton = WevVGlazePillButton(title: "RGervvihe,wa".wevVPastryCrumbBloomRestored)
        reviewButton.addTarget(self, action: #selector(openCrumbReviewForm), for: .touchUpInside)
        shelfButton.addTarget(self, action: #selector(placeShopIntoShelf), for: .touchUpInside)

        bar.addSubview(reviewButton)
        bar.addSubview(shelfButton)

        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bar.heightAnchor.constraint(equalToConstant: 86),
            reviewButton.topAnchor.constraint(equalTo: bar.topAnchor, constant: 10),
            reviewButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 15),
            reviewButton.widthAnchor.constraint(equalToConstant: 81),
            reviewButton.heightAnchor.constraint(equalToConstant: 52),
            shelfButton.topAnchor.constraint(equalTo: reviewButton.topAnchor),
            shelfButton.leadingAnchor.constraint(equalTo: reviewButton.trailingAnchor, constant: 9),
            shelfButton.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -15),
            shelfButton.heightAnchor.constraint(equalTo: reviewButton.heightAnchor)
        ])
    }

    private func makeHeroShopCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 16
        pastryCard.layer.shadowColor = UIColor(red: 0.57, green: 0.25, blue: 0.48, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.08
        pastryCard.layer.shadowRadius = 14
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        let cover = UIImageView(image: UIImage(named: glazeDetail.coverAsset))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12

        let creamName = makeBodyLabel(glazeDetail.title, size: 17, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let frostingSubtitle = makeBodyLabel(glazeDetail.subtitle, size: 13, weight: .medium, color: UIColor(red: 0.58, green: 0.48, blue: 0.58, alpha: 1))

        let scoreRow = makeIconTextRow(symbol: "sntlafr*.kfSiMldl/".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.75, blue: 0.08, alpha: 1), first: glazeDetail.crumbScoreText, second: glazeDetail.reviewText)
        let addressRow = makeIconTextRow(symbol: "mOaPp#pyi*nT.ecjisrhcGlCeG.Nf?idlxlE".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1), first: glazeDetail.addressLine, second: nil)

        let tagRow = UIStackView(arrangedSubviews: glazeDetail.tags.map { makeTagPill($0) })
        tagRow.translatesAutoresizingMaskIntoConstraints = false
        tagRow.axis = .horizontal
        tagRow.spacing = 8
        tagRow.alignment = .leading

        pastryCard.addSubview(cover)
        pastryCard.addSubview(creamName)
        pastryCard.addSubview(frostingSubtitle)
        pastryCard.addSubview(scoreRow)
        pastryCard.addSubview(addressRow)
        pastryCard.addSubview(tagRow)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            cover.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 15),
            cover.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 15),
            cover.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -15),
            cover.widthAnchor.constraint(equalTo: cover.heightAnchor),
            creamName.topAnchor.constraint(equalTo: cover.topAnchor, constant: 4),
            creamName.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            creamName.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -12),
            frostingSubtitle.topAnchor.constraint(equalTo: creamName.bottomAnchor, constant: 7),
            frostingSubtitle.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            frostingSubtitle.trailingAnchor.constraint(equalTo: creamName.trailingAnchor),
            scoreRow.topAnchor.constraint(equalTo: frostingSubtitle.bottomAnchor, constant: 14),
            scoreRow.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            scoreRow.trailingAnchor.constraint(lessThanOrEqualTo: creamName.trailingAnchor),
            addressRow.topAnchor.constraint(equalTo: scoreRow.bottomAnchor, constant: 12),
            addressRow.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            addressRow.trailingAnchor.constraint(equalTo: creamName.trailingAnchor),
            tagRow.topAnchor.constraint(equalTo: addressRow.bottomAnchor, constant: 16),
            tagRow.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            tagRow.trailingAnchor.constraint(lessThanOrEqualTo: creamName.trailingAnchor),
            tagRow.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -15)
        ])
        return pastryCard
    }

    private func makeParlorCard() -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.layer.cornerRadius = 14
        pastryCard.layer.masksToBounds = true
        pastryCard.addTarget(self, action: #selector(openGlazeRoom), for: .touchUpInside)

        let glazeLayer = CAGradientLayer()
        glazeLayer.colors = [
            UIColor(red: 1, green: 0.23, blue: 0.66, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.42, blue: 0.73, alpha: 1).cgColor
        ]
        glazeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        pastryCard.layer.insertSublayer(glazeLayer, at: 0)

        let glazeTitle = makeBodyLabel(glazeDetail.parlorTitle, size: 20, weight: .heavy, color: .white)
        let line = makeBodyLabel(glazeDetail.parlorLine, size: 14, weight: .semibold, color: UIColor.white.withAlphaComponent(0.9))

        let avatarRow = UIStackView()
        avatarRow.translatesAutoresizingMaskIntoConstraints = false
        avatarRow.axis = .horizontal
        avatarRow.spacing = -7
        for index in 0..<4 {
            let avatar = UIImageView(image: makeTinyTasterImage(index: index))
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.layer.cornerRadius = 15
            avatar.layer.borderWidth = 1.5
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.clipsToBounds = true
            avatarRow.addArrangedSubview(avatar)
            avatar.widthAnchor.constraint(equalToConstant: 30).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }

        let crowd = makeTinyPill(glazeDetail.parlorCrowdText)
        let enter = makeTinyPill(" ^JHo:icn@ qRKoPolmk :".wevVPastryCrumbBloomRestored)

        placeParlorCardViews(pastryCard: pastryCard, title: glazeTitle, line: line, avatarRow: avatarRow, crowd: crowd, enter: enter)
        pinParlorCardLayout(pastryCard: pastryCard, title: glazeTitle, line: line, avatarRow: avatarRow, crowd: crowd, enter: enter)
        pastryCard.layoutIfNeeded()
        glazeLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 28, height: 129)
        return pastryCard
    }

    private func placeParlorCardViews(pastryCard: UIControl, title: UILabel, line: UILabel, avatarRow: UIStackView, crowd: UILabel, enter: UILabel) {
        pastryCard.addSubview(title)
        pastryCard.addSubview(line)
        pastryCard.addSubview(avatarRow)
        pastryCard.addSubview(crowd)
        pastryCard.addSubview(enter)
    }

    private func pinParlorCardLayout(pastryCard: UIControl, title: UILabel, line: UILabel, avatarRow: UIStackView, crowd: UILabel, enter: UILabel) {
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

    private func makeReviewCard(_ review: WevVSprinkleReview) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 12
        pastryCard.addTarget(self, action: #selector(openProtectedSugarAction), for: .touchUpInside)

        let avatar = UIImageView(image: makeReviewAvatarImage(review))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 15
        avatar.clipsToBounds = true

        let creamName = makeBodyLabel(review.tasterName, size: 16, weight: .heavy, color: UIColor(red: 0.17, green: 0.08, blue: 0.2, alpha: 1))
        let role = makeBodyLabel(review.tastingRole, size: 12, weight: .semibold, color: UIColor(red: 0.68, green: 0.56, blue: 0.65, alpha: 1))
        let score = makeIconTextRow(symbol: "s/t#amrH.lfNijlwlL".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: review.crumbScoreText, second: nil)
        let bite = makeBodyLabel(review.biteText, size: 13, weight: .medium, color: UIColor(red: 0.43, green: 0.35, blue: 0.43, alpha: 1))
        bite.numberOfLines = 2
        let badge = makeTagText(review.badgeText, color: UIColor(red: 1, green: 0.25, blue: 0.61, alpha: 1))

        pastryCard.addSubview(avatar)
        pastryCard.addSubview(creamName)
        pastryCard.addSubview(role)
        pastryCard.addSubview(score)
        pastryCard.addSubview(bite)
        pastryCard.addSubview(badge)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 116),
            avatar.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 12),
            avatar.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 12),
            avatar.widthAnchor.constraint(equalToConstant: 37),
            avatar.heightAnchor.constraint(equalToConstant: 37),
            creamName.topAnchor.constraint(equalTo: avatar.topAnchor),
            creamName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 7),
            creamName.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -5),
            role.topAnchor.constraint(equalTo: creamName.bottomAnchor, constant: 1),
            role.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            role.trailingAnchor.constraint(equalTo: creamName.trailingAnchor),
            score.centerYAnchor.constraint(equalTo: creamName.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -8),
            bite.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 11),
            bite.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 12),
            bite.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -12),
            badge.topAnchor.constraint(equalTo: bite.bottomAnchor, constant: 8),
            badge.leadingAnchor.constraint(equalTo: bite.leadingAnchor),
            badge.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -10)
        ])
        return pastryCard
    }

    private func refreshCrumbReviewRow() {
        reviewRow.arrangedSubviews.forEach { crumbCard in
            reviewRow.removeArrangedSubview(crumbCard)
            crumbCard.removeFromSuperview()
        }
        currentCrumbReviews().prefix(2).forEach { reviewRow.addArrangedSubview(makeReviewCard($0)) }
    }

    private func currentCrumbReviews() -> [WevVSprinkleReview] {
        let localReviews = glazeSession.crumbNotePackets(for: glazeDetail.glazeKey).map { packet in
            WevVSprinkleReview(
                sprinkleKey: "\(packet.shopKey)\(packet.doughRingKey)\(Int(packet.timeInterval))",
                tasterName: packet.glazeNickname,
                tastingRole: "DVohn,uFtU ctnaXsWtSeorI".wevVPastryCrumbBloomRestored,
                crumbScoreText: String(format: "%!.K1#fH".wevVPastryCrumbBloomRestored, Double(packet.rating)),
                biteText: packet.text,
                badgeText: "FsrmersohX jN#oftAe?".wevVPastryCrumbBloomRestored,
                donutAvatarAsset: packet.donutAvatarAsset
            )
        }
        return localReviews + glazeDetail.reviews
    }

    private func makeReviewAvatarImage(_ review: WevVSprinkleReview) -> UIImage? {
        if let donutAvatarAsset = review.donutAvatarAsset, let glazeImage = UIImage(named: donutAvatarAsset) {
            return glazeImage
        }
        return makeTinyTasterImage(index: abs(review.sprinkleKey.hashValue % 5))
    }

    private func makeMorePickRow(_ pick: WevVSugarShopPick) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.accessibilityIdentifier = pick.sugarKey
        donutRow.addTarget(self, action: #selector(openMoreGlazePick(_:)), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: glazeCoverAsset(for: pick)))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 8

        let glazeTitle = makeBodyLabel(pick.title, size: 16, weight: .heavy, color: UIColor(red: 0.15, green: 0.08, blue: 0.2, alpha: 1))
        let address = makeBodyLabel(pick.addressLine, size: 12, weight: .semibold, color: UIColor(red: 0.56, green: 0.47, blue: 0.55, alpha: 1))
        let score = makeIconTextRow(symbol: "smtzahrW.XfSiwlslw".wevVPastryCrumbBloomRestored, tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: pick.crumbScoreText, second: nil)

        donutRow.addSubview(cover)
        donutRow.addSubview(glazeTitle)
        donutRow.addSubview(address)
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
            address.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 5),
            address.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            address.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -10),
            score.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor)
        ])
        return donutRow
    }

    private func glazeCoverAsset(for pick: WevVSugarShopPick) -> String {
        if UIImage(named: pick.coverAsset) != nil {
            return pick.coverAsset
        }
        let doughTitle = pick.title.lowercased()
        if doughTitle.contains("golden") || doughTitle.contains("cloud") {
            return "wevv_shop_golden_dough_studio"
        }
        if doughTitle.contains("moon") || doughTitle.contains("mellow") {
            return "wevv_shop_moonlight_donut_bar"
        }
        return "wevv_shop_berry_ring_bakery"
    }

    private func makeSectionTitle(_ text: String) -> UILabel {
        makeBodyLabel(text, size: 17, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1))
    }

    private func makeBodyLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.78
        return crumbLabel
    }

    private func makeIconTextRow(symbol: String, tint: UIColor, first: String, second: String?) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = tint
        icon.contentMode = .scaleAspectFit
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let firstLabel = makeBodyLabel(first, size: 14, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let donutRow = UIStackView(arrangedSubviews: [icon, firstLabel])
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.spacing = 4
        donutRow.alignment = .center
        if let second {
            let secondLabel = makeBodyLabel(second, size: 13, weight: .medium, color: UIColor(red: 0.6, green: 0.5, blue: 0.6, alpha: 1))
            donutRow.addArrangedSubview(secondLabel)
        }
        return donutRow
    }

    private func makeTagPill(_ tag: WevVFrostingShopTag) -> UILabel {
        let color = UIColor.wevvHex(tag.tintHex)
        let crumbLabel = makeTagText(tag.title, color: color)
        crumbLabel.backgroundColor = color.withAlphaComponent(0.12)
        crumbLabel.layer.cornerRadius = 8
        crumbLabel.clipsToBounds = true
        crumbLabel.textAlignment = .center
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        crumbLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return crumbLabel
    }

    private func makeTagText(_ text: String, color: UIColor) -> UILabel {
        let crumbLabel = makeBodyLabel(text, size: 12, weight: .heavy, color: color)
        crumbLabel.numberOfLines = 1
        return crumbLabel
    }

    private func makeTinyPill(_ text: String) -> UILabel {
        let crumbLabel = makeBodyLabel(text, size: 14, weight: .heavy, color: UIColor(red: 1, green: 0.35, blue: 0.7, alpha: 1))
        crumbLabel.backgroundColor = .white
        crumbLabel.textAlignment = .center
        crumbLabel.layer.cornerRadius = 14
        crumbLabel.clipsToBounds = true
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        crumbLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return crumbLabel
    }

    private func makeTinyTasterImage(index: Int) -> UIImage {
        let profile = guestStore.profile(at: index)
        if let glazeImage = UIImage(named: profile.donutAvatarAsset) {
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

    private func refreshShelfButton() {
        let isShelfed = glazeSession.isGlazeShelfed(shopKey: glazeDetail.glazeKey)
        shelfButton.setTitle(isShelfed ? "Saved" : "SKarv+eG".wevVPastryCrumbBloomRestored)
        shelfButton.isEnabled = !isShelfed
    }

    @objc private func closeGlazeDetail() {
        dismiss(animated: true)
    }

    @objc private func openProtectedSugarAction() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
    }

    @objc private func openMoreGlazePick(_ sender: UIControl) {
        let sugarKey = sender.accessibilityIdentifier ?? ""
        guard let pick = glazeDetail.morePicks.first(where: { $0.sugarKey == sugarKey }) else { return }
        let controller = WevVGlazeShopDetailController(detail: makeGlazePickDetail(pick), glazeShelf: glazeShelf)
        controller.onShelfChanged = { [weak self] in
            self?.refreshShelfButton()
            self?.onShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "ORppegnSiFn=gG idoobnZugts GsIhmoWp^.r.P.I".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func makeGlazePickDetail(_ pick: WevVSugarShopPick) -> WevVGlazeShopDetail {
        if let matchingDetail = glazeShelf.first(where: { $0.glazeKey == pick.sugarKey || $0.title == pick.title }) {
            return matchingDetail
        }
        let coverAsset = glazeCoverAsset(for: pick)
        return WevVGlazeShopDetail(
            glazeKey: pick.sugarKey,
            title: pick.title,
            subtitle: "FNrXevsOhJ rdWoTnMuNtr VpliUcbkJsh D·O Clro!craoln CfHa#vWoZrdi?tfev".wevVPastryCrumbBloomRestored,
            coverAsset: coverAsset,
            crumbScoreText: pick.crumbScoreText,
            reviewText: "(n1f2f8d ?rCeJvBiseBwqsp)*".wevVPastryCrumbBloomRestored,
            addressLine: pick.addressLine,
            tags: [
                WevVFrostingShopTag(glazeKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, title: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, tintHex: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, title: "CCopzsyb".wevVPastryCrumbBloomRestored, tintHex: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, title: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, tintHex: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored)
            ],
            parlorTitle: "D?oMn@uWtV YLuoSvOehrCsk aRtoEosmz".wevVPastryCrumbBloomRestored,
            parlorLine: "ODptexn! VfcoWr@ Ws@wVe@e~tH usshro!pc GnQovtHeSsx,O qfJrNefs*hk LpLiDcWkrsI,c #awnWdP WcUo?z%yS vdZoWndu#t~ NtBaalJk#.N".wevVPastryCrumbBloomRestored,
            parlorCrowdText: "2U8F qognblWiMn%eg".wevVPastryCrumbBloomRestored,
            reviews: glazeDetail.reviews,
            morePicks: glazeShelf.filter { $0.title != pick.title }.prefix(2).map {
                WevVSugarShopPick(sugarKey: $0.glazeKey, title: $0.title, addressLine: $0.addressLine, crumbScoreText: $0.crumbScoreText, coverAsset: $0.coverAsset)
            }
        )
    }

    @objc private func openGlazeRoom() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        let controller = WevVGlazeComeInController(roomKey: glazeDetail.glazeKey, shopTitle: glazeDetail.title)
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "OOpieannijngg% erTojo:mo.P.d.l".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openCrumbReviewForm() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        let controller = WevVCrumbReviewController(shopKey: glazeDetail.glazeKey)
        controller.onCrumbPosted = { [weak self] in
            self?.refreshCrumbReviewRow()
            self?.onShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "LPoYaOdGiFnxgu yrDe@vMiEeewA TfWoTrkmL.r.T.K".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func placeShopIntoShelf() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        WevVBakeryExchange.spin(in: view, note: "Sgaavxi:nhgY AsQhco$pS.+.S.I".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            guard self.glazeSession.placeGlazeShelf(shopKey: self.glazeDetail.glazeKey) else {
                self.refreshShelfButton()
                return
            }
            self.refreshShelfButton()
            self.onShelfChanged?()
            self.showShelfSuccess()
        }
    }

    @objc private func openGlazeSafetySheet() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        guard safetySheet == nil else { return }
        let choices = [
            WevVGlazeSafetyChoice(sugarKey: "fiaMkUeWPHhUo+tIoL".wevVPastryCrumbBloomRestored, title: "Fnavkveb /pohCoGtfo;".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "s#c,a/miCDo%m@mPeCricSiSaWlf".wevVPastryCrumbBloomRestored, title: "Socuahmj YovrS FcdommjmYeVrCcLi=aylc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "ncolt%IMnXt~ewrSeDs*tne:dz".wevVPastryCrumbBloomRestored, title: "Njoxt: XiJnItLefrve:sWt?etdL".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "o,tIhQe*rOS.u=gxaOr@".wevVPastryCrumbBloomRestored, title: "OBt~hseXrb".wevVPastryCrumbBloomRestored, needsCreamText: true)
        ]
        let sheet = WevVGlazeSafetySheet(shopKey: glazeDetail.glazeKey, choices: choices)
        sheet.alpha = 0
        sheet.onClose = { [weak self, weak sheet] in
            self?.hideGlazeSafetySheet(sheet)
        }
        sheet.onConfirm = { [weak self, weak sheet] packet in
            self?.glazeSession.placeGlazeSafetyCrumb(packet)
            self?.hideGlazeSafetySheet(sheet)
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        safetySheet = sheet
        UIView.animate(withDuration: 0.18) {
            sheet.alpha = 1
        }
    }

    private func hideGlazeSafetySheet(_ sheet: WevVGlazeSafetySheet?) {
        UIView.animate(withDuration: 0.18, animations: {
            sheet?.alpha = 0
        }, completion: { [weak self, weak sheet] _ in
            sheet?.removeFromSuperview()
            self?.safetySheet = nil
        })
    }

    private func presentGlazeGate() {
        let gate = WevVFrostingGateController()
        gate.onGlazeReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshShelfButton()
                self?.onShelfChanged?()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func showShelfSuccess() {
        let layer = WevVShelfSuccessView()
        layer.alpha = 0
        layer.onCreamClose = { [weak self, weak layer] in
            UIView.animate(withDuration: 0.18, animations: {
                layer?.alpha = 0
            }, completion: { _ in
                layer?.removeFromSuperview()
                self?.successLayer = nil
            })
        }
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        successLayer = layer
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
