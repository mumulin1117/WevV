import UIKit

final class WevVGlazeShopDetailController: UIViewController {
    private let glazeDetail: WevVGlazeShopDetail
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let shelfButton = WevVGlazePillButton(title: "Save")
    private var successLayer: WevVShelfSuccessView?
    private var safetySheet: WevVGlazeSafetySheet?

    var onShelfChanged: (() -> Void)?

    init(detail: WevVGlazeShopDetail) {
        self.glazeDetail = detail
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
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        backButton.addTarget(self, action: #selector(closeGlazeDetail), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Donut Shops"
        title.font = .systemFont(ofSize: 17, weight: .heavy)
        title.textColor = UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1)
        title.textAlignment = .center

        let safetyButton = UIButton(type: .system)
        safetyButton.translatesAutoresizingMaskIntoConstraints = false
        safetyButton.setImage(UIImage(systemName: "flag"), for: .normal)
        safetyButton.tintColor = UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1)
        safetyButton.addTarget(self, action: #selector(openGlazeSafetySheet), for: .touchUpInside)

        let shopCard = makeHeroShopCard()
        let parlorCard = makeParlorCard()
        let recentTitle = makeSectionTitle("Recent Reviews")
        let reviewRow = UIStackView(arrangedSubviews: glazeDetail.reviews.map { makeReviewCard($0) })
        reviewRow.translatesAutoresizingMaskIntoConstraints = false
        reviewRow.axis = .horizontal
        reviewRow.spacing = 10
        reviewRow.distribution = .fillEqually

        let moreTitle = makeSectionTitle("More Shops")
        let moreStack = UIStackView(arrangedSubviews: glazeDetail.morePicks.map { makeMorePickRow($0) })
        moreStack.translatesAutoresizingMaskIntoConstraints = false
        moreStack.axis = .vertical
        moreStack.spacing = 12

        sprinkleContent.addSubview(backButton)
        sprinkleContent.addSubview(title)
        sprinkleContent.addSubview(safetyButton)
        sprinkleContent.addSubview(shopCard)
        sprinkleContent.addSubview(parlorCard)
        sprinkleContent.addSubview(recentTitle)
        sprinkleContent.addSubview(reviewRow)
        sprinkleContent.addSubview(moreTitle)
        sprinkleContent.addSubview(moreStack)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 22),
            backButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 34),
            backButton.heightAnchor.constraint(equalToConstant: 34),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: sprinkleContent.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -12),
            safetyButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            safetyButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -18),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34),
            shopCard.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
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

        let reviewButton = WevVGlazePillButton(title: "Review")
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
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor(red: 0.57, green: 0.25, blue: 0.48, alpha: 1).cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 14
        card.layer.shadowOffset = CGSize(width: 0, height: 8)

        let cover = UIImageView(image: UIImage(named: glazeDetail.coverAsset))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12

        let name = makeBodyLabel(glazeDetail.title, size: 17, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let subtitle = makeBodyLabel(glazeDetail.subtitle, size: 13, weight: .medium, color: UIColor(red: 0.58, green: 0.48, blue: 0.58, alpha: 1))

        let scoreRow = makeIconTextRow(symbol: "star.fill", tint: UIColor(red: 1, green: 0.75, blue: 0.08, alpha: 1), first: glazeDetail.crumbScoreText, second: glazeDetail.reviewText)
        let addressRow = makeIconTextRow(symbol: "mappin.circle.fill", tint: UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1), first: glazeDetail.addressLine, second: nil)

        let tagRow = UIStackView(arrangedSubviews: glazeDetail.tags.map { makeTagPill($0) })
        tagRow.translatesAutoresizingMaskIntoConstraints = false
        tagRow.axis = .horizontal
        tagRow.spacing = 8
        tagRow.alignment = .leading

        card.addSubview(cover)
        card.addSubview(name)
        card.addSubview(subtitle)
        card.addSubview(scoreRow)
        card.addSubview(addressRow)
        card.addSubview(tagRow)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15),
            cover.widthAnchor.constraint(equalTo: cover.heightAnchor),
            name.topAnchor.constraint(equalTo: cover.topAnchor, constant: 4),
            name.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            subtitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 7),
            subtitle.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            scoreRow.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 14),
            scoreRow.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            scoreRow.trailingAnchor.constraint(lessThanOrEqualTo: name.trailingAnchor),
            addressRow.topAnchor.constraint(equalTo: scoreRow.bottomAnchor, constant: 12),
            addressRow.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            addressRow.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            tagRow.topAnchor.constraint(equalTo: addressRow.bottomAnchor, constant: 16),
            tagRow.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            tagRow.trailingAnchor.constraint(lessThanOrEqualTo: name.trailingAnchor),
            tagRow.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -15)
        ])
        return card
    }

    private func makeParlorCard() -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 14
        card.layer.masksToBounds = true
        card.addTarget(self, action: #selector(openGlazeRoom), for: .touchUpInside)

        let glazeLayer = CAGradientLayer()
        glazeLayer.colors = [
            UIColor(red: 1, green: 0.23, blue: 0.66, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.42, blue: 0.73, alpha: 1).cgColor
        ]
        glazeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        card.layer.insertSublayer(glazeLayer, at: 0)

        let title = makeBodyLabel(glazeDetail.parlorTitle, size: 20, weight: .heavy, color: .white)
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
        let enter = makeTinyPill(" Join Room ")

        card.addSubview(title)
        card.addSubview(line)
        card.addSubview(avatarRow)
        card.addSubview(crowd)
        card.addSubview(enter)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 129),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 26),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            line.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            line.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            avatarRow.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            avatarRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24),
            crowd.centerYAnchor.constraint(equalTo: avatarRow.centerYAnchor),
            crowd.leadingAnchor.constraint(equalTo: avatarRow.trailingAnchor, constant: 10),
            enter.centerYAnchor.constraint(equalTo: avatarRow.centerYAnchor),
            enter.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14)
        ])

        card.layoutIfNeeded()
        glazeLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 28, height: 129)
        return card
    }

    private func makeReviewCard(_ review: WevVSprinkleReview) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.addTarget(self, action: #selector(openProtectedSugarAction), for: .touchUpInside)

        let avatar = UIImageView(image: makeTinyTasterImage(index: abs(review.sprinkleKey.hashValue % 5)))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 15
        avatar.clipsToBounds = true

        let name = makeBodyLabel(review.tasterName, size: 16, weight: .heavy, color: UIColor(red: 0.17, green: 0.08, blue: 0.2, alpha: 1))
        let role = makeBodyLabel(review.tastingRole, size: 12, weight: .semibold, color: UIColor(red: 0.68, green: 0.56, blue: 0.65, alpha: 1))
        let score = makeIconTextRow(symbol: "star.fill", tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: review.crumbScoreText, second: nil)
        let bite = makeBodyLabel(review.biteText, size: 13, weight: .medium, color: UIColor(red: 0.43, green: 0.35, blue: 0.43, alpha: 1))
        bite.numberOfLines = 2
        let badge = makeTagText(review.badgeText, color: UIColor(red: 1, green: 0.25, blue: 0.61, alpha: 1))

        card.addSubview(avatar)
        card.addSubview(name)
        card.addSubview(role)
        card.addSubview(score)
        card.addSubview(bite)
        card.addSubview(badge)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 116),
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            avatar.widthAnchor.constraint(equalToConstant: 37),
            avatar.heightAnchor.constraint(equalToConstant: 37),
            name.topAnchor.constraint(equalTo: avatar.topAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 7),
            name.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -5),
            role.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 1),
            role.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            role.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            score.centerYAnchor.constraint(equalTo: name.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            bite.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 11),
            bite.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            bite.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            badge.topAnchor.constraint(equalTo: bite.bottomAnchor, constant: 8),
            badge.leadingAnchor.constraint(equalTo: bite.leadingAnchor),
            badge.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -10)
        ])
        return card
    }

    private func makeMorePickRow(_ pick: WevVSugarShopPick) -> UIControl {
        let row = UIControl()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.addTarget(self, action: #selector(openProtectedSugarAction), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: pick.coverAsset))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 8

        let title = makeBodyLabel(pick.title, size: 16, weight: .heavy, color: UIColor(red: 0.15, green: 0.08, blue: 0.2, alpha: 1))
        let address = makeBodyLabel(pick.addressLine, size: 12, weight: .semibold, color: UIColor(red: 0.56, green: 0.47, blue: 0.55, alpha: 1))
        let score = makeIconTextRow(symbol: "star.fill", tint: UIColor(red: 1, green: 0.74, blue: 0.04, alpha: 1), first: pick.crumbScoreText, second: nil)

        row.addSubview(cover)
        row.addSubview(title)
        row.addSubview(address)
        row.addSubview(score)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 64),
            cover.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            cover.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            cover.widthAnchor.constraint(equalToConstant: 54),
            cover.heightAnchor.constraint(equalToConstant: 54),
            title.topAnchor.constraint(equalTo: cover.topAnchor, constant: 3),
            title.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -10),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.trailingAnchor.constraint(lessThanOrEqualTo: score.leadingAnchor, constant: -10),
            score.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: row.trailingAnchor)
        ])
        return row
    }

    private func makeSectionTitle(_ text: String) -> UILabel {
        makeBodyLabel(text, size: 17, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.19, alpha: 1))
    }

    private func makeBodyLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.78
        return label
    }

    private func makeIconTextRow(symbol: String, tint: UIColor, first: String, second: String?) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = tint
        icon.contentMode = .scaleAspectFit
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let firstLabel = makeBodyLabel(first, size: 14, weight: .heavy, color: UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1))
        let row = UIStackView(arrangedSubviews: [icon, firstLabel])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = 4
        row.alignment = .center
        if let second {
            let secondLabel = makeBodyLabel(second, size: 13, weight: .medium, color: UIColor(red: 0.6, green: 0.5, blue: 0.6, alpha: 1))
            row.addArrangedSubview(secondLabel)
        }
        return row
    }

    private func makeTagPill(_ tag: WevVFrostingShopTag) -> UILabel {
        let color = UIColor.wevvHex(tag.tintHex)
        let label = makeTagText(tag.title, color: color)
        label.backgroundColor = color.withAlphaComponent(0.12)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }

    private func makeTagText(_ text: String, color: UIColor) -> UILabel {
        let label = makeBodyLabel(text, size: 12, weight: .heavy, color: color)
        label.numberOfLines = 1
        return label
    }

    private func makeTinyPill(_ text: String) -> UILabel {
        let label = makeBodyLabel(text, size: 14, weight: .heavy, color: UIColor(red: 1, green: 0.35, blue: 0.7, alpha: 1))
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return label
    }

    private func makeTinyTasterImage(index: Int) -> UIImage {
        let profile = guestStore.profile(at: index)
        if let image = UIImage(named: profile.avatarAsset) {
            return image
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
        shelfButton.setTitle(isShelfed ? "Saved" : "Save")
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

    @objc private func openGlazeRoom() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        let controller = WevVGlazeRoomController(roomKey: glazeDetail.glazeKey, shopTitle: glazeDetail.title)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openCrumbReviewForm() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        let controller = WevVCrumbReviewController(shopKey: glazeDetail.glazeKey)
        controller.onCrumbPosted = { [weak self] in
            self?.onShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func placeShopIntoShelf() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        guard glazeSession.placeGlazeShelf(shopKey: glazeDetail.glazeKey) else {
            refreshShelfButton()
            return
        }
        refreshShelfButton()
        onShelfChanged?()
        showShelfSuccess()
    }

    @objc private func openGlazeSafetySheet() {
        guard glazeSession.isTasterReady else {
            presentGlazeGate()
            return
        }
        guard safetySheet == nil else { return }
        let choices = [
            WevVGlazeSafetyChoice(sugarKey: "fakePhoto", title: "Fake photo", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "scamCommercial", title: "Scam or commercial", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "notInterested", title: "Not interested", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "otherSugar", title: "Other", needsCreamText: true)
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
