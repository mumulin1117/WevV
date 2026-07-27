import UIKit

final class WevVGuestGlazeProfileController: UIViewController {
    private enum SugarPane {
        case sugarPost
        case glazeQuest
    }

    private struct WevVGlazeQuestCard {
        let title: String
        let timeText: String
        let placeText: String
        let costText: String
        let assetName: String
    }

    private let guestKey: String
    private let glazeStore = WevVGuestGlazeStore.shared
    private let glazeSession = WevVGlazeSessionStore.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarView = UIImageView()
    private let followButton = UIButton(type: .system)
    private let nameTitle = UILabel()
    private let nameHero = UILabel()
    private let roleLine = UILabel()
    private let placeLine = UILabel()
    private let likesValue = UILabel()
    private let followerValue = UILabel()
    private let followingValue = UILabel()
    private let sugarPostButton = UIButton(type: .system)
    private let glazeQuestButton = UIButton(type: .system)
    private let bodyStack = UIStackView()
    private let lockedFoot = UIControl()
    private let actionFoot = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    private var firstStatSeparatorCenter: NSLayoutConstraint?
    private var secondStatSeparatorCenter: NSLayoutConstraint?
    private var selectedPane: SugarPane = .glazeQuest

    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
    private let palePinkTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.08, green: 0.07, blue: 0.12, alpha: 1)
    private let mutedTone = UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1)

    init(guestKey: String) {
        self.guestKey = guestKey
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPane = isCreamUnlocked ? .sugarPost : .glazeQuest
        buildGlazePage()
        refreshGlazePage()
    }

    private var currentProfile: WevVGuestGlazeProfile {
        glazeStore.profile(for: guestKey)
    }

    private var isCreamUnlocked: Bool {
        currentProfile.sugarTie.isGlazeFollowed
    }

    private func buildGlazePage() {
        view.backgroundColor = palePinkTone
        buildTopBar()
        buildScrollLayer()
        buildLockedFoot()
        buildActionFoot()
    }

    private func buildTopBar() {
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.tintColor = .black
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(closeGuestGlazeProfile), for: .touchUpInside)

        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.font = .systemFont(ofSize: 20, weight: .heavy)
        nameTitle.textAlignment = .center
        nameTitle.textColor = .black
        nameTitle.adjustsFontSizeToFitWidth = true
        nameTitle.minimumScaleFactor = 0.72

        let dots = UIButton(type: .system)
        dots.translatesAutoresizingMaskIntoConstraints = false
        dots.tintColor = .black
        dots.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        dots.addTarget(self, action: #selector(showSugarGuardPrompt), for: .touchUpInside)

        view.addSubview(back)
        view.addSubview(nameTitle)
        view.addSubview(dots)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            nameTitle.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            nameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTitle.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 14),
            nameTitle.trailingAnchor.constraint(lessThanOrEqualTo: dots.leadingAnchor, constant: -14),
            dots.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            dots.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            dots.widthAnchor.constraint(equalToConstant: 44),
            dots.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildScrollLayer() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 50

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.tintColor = .white
        followButton.layer.cornerRadius = 22
        followButton.addTarget(self, action: #selector(toggleGuestGlazeFollow), for: .touchUpInside)

        nameHero.translatesAutoresizingMaskIntoConstraints = false
        nameHero.font = .systemFont(ofSize: 25, weight: .heavy)
        nameHero.textColor = .black
        nameHero.adjustsFontSizeToFitWidth = true
        nameHero.minimumScaleFactor = 0.68

        roleLine.translatesAutoresizingMaskIntoConstraints = false
        roleLine.font = .systemFont(ofSize: 16, weight: .heavy)
        roleLine.textColor = mutedTone
        roleLine.adjustsFontSizeToFitWidth = true
        roleLine.minimumScaleFactor = 0.68

        placeLine.translatesAutoresizingMaskIntoConstraints = false
        placeLine.font = .systemFont(ofSize: 15, weight: .heavy)
        placeLine.textColor = mutedTone
        placeLine.adjustsFontSizeToFitWidth = true
        placeLine.minimumScaleFactor = 0.68

        let statRow = UIStackView(arrangedSubviews: [
            makeSugarStat(value: likesValue, title: "Likes"),
            makeSugarStat(value: followerValue, title: "Followers"),
            makeSugarStat(value: followingValue, title: "Following")
        ])
        statRow.translatesAutoresizingMaskIntoConstraints = false
        statRow.axis = .horizontal
        statRow.distribution = .fillEqually

        let firstDivider = makeStatDivider()
        let secondDivider = makeStatDivider()

        let segment = UIView()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.layer.cornerRadius = 28
        segment.clipsToBounds = true

        configureSegmentButton(sugarPostButton, title: "Post", action: #selector(selectSugarPost))
        configureSegmentButton(glazeQuestButton, title: "Challenge", action: #selector(selectGlazeQuest))
        segment.addSubview(sugarPostButton)
        segment.addSubview(glazeQuestButton)

        bodyStack.translatesAutoresizingMaskIntoConstraints = false
        bodyStack.axis = .vertical
        bodyStack.spacing = 22

        contentView.addSubview(avatarView)
        contentView.addSubview(followButton)
        contentView.addSubview(nameHero)
        contentView.addSubview(roleLine)
        contentView.addSubview(placeLine)
        contentView.addSubview(statRow)
        contentView.addSubview(firstDivider)
        contentView.addSubview(secondDivider)
        contentView.addSubview(segment)
        contentView.addSubview(bodyStack)

        let firstStatCenter = firstDivider.centerXAnchor.constraint(equalTo: statRow.leadingAnchor)
        let secondStatCenter = secondDivider.centerXAnchor.constraint(equalTo: statRow.trailingAnchor)
        firstStatSeparatorCenter = firstStatCenter
        secondStatSeparatorCenter = secondStatCenter

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 108),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
            followButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            followButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 22),
            followButton.widthAnchor.constraint(equalToConstant: 118),
            followButton.heightAnchor.constraint(equalToConstant: 44),

            nameHero.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 38),
            nameHero.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            nameHero.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 18),
            roleLine.leadingAnchor.constraint(equalTo: nameHero.leadingAnchor),
            roleLine.trailingAnchor.constraint(equalTo: nameHero.trailingAnchor),
            roleLine.topAnchor.constraint(equalTo: nameHero.bottomAnchor, constant: 16),
            placeLine.leadingAnchor.constraint(equalTo: nameHero.leadingAnchor),
            placeLine.trailingAnchor.constraint(equalTo: nameHero.trailingAnchor),
            placeLine.topAnchor.constraint(equalTo: roleLine.bottomAnchor, constant: 6),

            statRow.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 62),
            statRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 58),
            statRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -58),
            statRow.heightAnchor.constraint(equalToConstant: 64),
            firstDivider.centerYAnchor.constraint(equalTo: statRow.centerYAnchor),
            firstStatCenter,
            firstDivider.widthAnchor.constraint(equalToConstant: 1),
            firstDivider.heightAnchor.constraint(equalToConstant: 40),
            secondDivider.centerYAnchor.constraint(equalTo: statRow.centerYAnchor),
            secondStatCenter,
            secondDivider.widthAnchor.constraint(equalToConstant: 1),
            secondDivider.heightAnchor.constraint(equalToConstant: 40),

            segment.topAnchor.constraint(equalTo: statRow.bottomAnchor, constant: 28),
            segment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            segment.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.58),
            segment.heightAnchor.constraint(equalToConstant: 48),
            sugarPostButton.leadingAnchor.constraint(equalTo: segment.leadingAnchor, constant: 6),
            sugarPostButton.topAnchor.constraint(equalTo: segment.topAnchor, constant: 4),
            sugarPostButton.bottomAnchor.constraint(equalTo: segment.bottomAnchor, constant: -4),
            sugarPostButton.widthAnchor.constraint(equalTo: segment.widthAnchor, multiplier: 0.5, constant: -6),
            glazeQuestButton.trailingAnchor.constraint(equalTo: segment.trailingAnchor, constant: -6),
            glazeQuestButton.topAnchor.constraint(equalTo: sugarPostButton.topAnchor),
            glazeQuestButton.bottomAnchor.constraint(equalTo: sugarPostButton.bottomAnchor),
            glazeQuestButton.widthAnchor.constraint(equalTo: sugarPostButton.widthAnchor),

            bodyStack.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 30),
            bodyStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            bodyStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            bodyStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -180)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statWidth = max(view.bounds.width - 116, 1)
        firstStatSeparatorCenter?.constant = statWidth / 3
        secondStatSeparatorCenter?.constant = -statWidth / 3
        avatarView.layer.cornerRadius = avatarView.bounds.height / 2
        followButton.layer.cornerRadius = followButton.bounds.height / 2
        sugarPostButton.layer.cornerRadius = sugarPostButton.bounds.height / 2
        glazeQuestButton.layer.cornerRadius = glazeQuestButton.bounds.height / 2
    }

    private func buildLockedFoot() {
        lockedFoot.translatesAutoresizingMaskIntoConstraints = false
        lockedFoot.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        lockedFoot.addTarget(self, action: #selector(showSugarGuardPrompt), for: .touchUpInside)

        let label = makeGlazeLabel(
            "You can only send messages and videos to each other once you have followed one another. Please follow the user first and wait for them to follow you back.",
            size: 17,
            weight: .semibold,
            color: UIColor(red: 0.56, green: 0.56, blue: 0.57, alpha: 1)
        )
        label.numberOfLines = 0
        lockedFoot.addSubview(label)
        view.addSubview(lockedFoot)

        NSLayoutConstraint.activate([
            lockedFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lockedFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lockedFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lockedFoot.heightAnchor.constraint(equalToConstant: 134),
            label.leadingAnchor.constraint(equalTo: lockedFoot.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: lockedFoot.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: lockedFoot.topAnchor, constant: 22)
        ])
    }

    private func buildActionFoot() {
        actionFoot.translatesAutoresizingMaskIntoConstraints = false
        actionFoot.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 0.88)
        view.addSubview(actionFoot)

        let creamNote = makeBottomAction(
            title: "Message",
            symbol: "bubble.left.fill",
            fill: UIColor(red: 0.91, green: 0.9, blue: 1, alpha: 1),
            tint: UIColor(red: 0.06, green: 0.06, blue: 0.09, alpha: 1)
        )
        let sprinkleLens = makeBottomAction(
            title: "Video",
            symbol: "camera.fill",
            fill: pinkTone,
            tint: .white
        )
        creamNote.addTarget(self, action: #selector(showSugarGuardPrompt), for: .touchUpInside)
        sprinkleLens.addTarget(self, action: #selector(showSugarGuardPrompt), for: .touchUpInside)
        actionFoot.contentView.addSubview(creamNote)
        actionFoot.contentView.addSubview(sprinkleLens)

        NSLayoutConstraint.activate([
            actionFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            actionFoot.heightAnchor.constraint(equalToConstant: 122),
            creamNote.leadingAnchor.constraint(equalTo: actionFoot.contentView.leadingAnchor, constant: 48),
            creamNote.topAnchor.constraint(equalTo: actionFoot.contentView.topAnchor, constant: 24),
            creamNote.heightAnchor.constraint(equalToConstant: 54),
            creamNote.trailingAnchor.constraint(equalTo: actionFoot.contentView.centerXAnchor, constant: -14),
            sprinkleLens.leadingAnchor.constraint(equalTo: actionFoot.contentView.centerXAnchor, constant: 14),
            sprinkleLens.trailingAnchor.constraint(equalTo: actionFoot.contentView.trailingAnchor, constant: -48),
            sprinkleLens.topAnchor.constraint(equalTo: creamNote.topAnchor),
            sprinkleLens.heightAnchor.constraint(equalTo: creamNote.heightAnchor)
        ])
    }

    private func refreshGlazePage() {
        let profile = currentProfile
        let signatureLines = profile.signature.components(separatedBy: "\n")
        nameTitle.text = profile.name
        nameHero.text = profile.name
        roleLine.text = signatureLines.first ?? profile.signature
        placeLine.text = signatureLines.dropFirst().first ?? "Sweet glaze regular"
        likesValue.text = "\(profile.sweetMarkCount)"
        followerValue.text = "\(profile.followerCount)"
        followingValue.text = "\(profile.followingCount)"
        avatarView.image = UIImage(named: profile.avatarAsset)
        refreshFollowButton()
        refreshSegmentState()
        refreshBodyStack()
        lockedFoot.isHidden = isCreamUnlocked
        actionFoot.isHidden = !isCreamUnlocked
        scrollView.contentInset.bottom = isCreamUnlocked ? 132 : 148
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }

    private func refreshFollowButton() {
        let followed = currentProfile.sugarTie.isGlazeFollowed
        followButton.backgroundColor = followed ? UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1) : pinkTone
        followButton.setImage(UIImage(systemName: followed ? "checkmark" : "plus"), for: .normal)
        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.contentHorizontalAlignment = .center
    }

    private func refreshSegmentState() {
        let postSelected = selectedPane == .sugarPost
        styleSegmentButton(sugarPostButton, selected: postSelected)
        styleSegmentButton(glazeQuestButton, selected: !postSelected)
    }

    private func refreshBodyStack() {
        bodyStack.arrangedSubviews.forEach { view in
            bodyStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        switch selectedPane {
        case .sugarPost:
            bodyStack.addArrangedSubview(makeLargeSugarPost())
        case .glazeQuest:
            questCards().forEach { bodyStack.addArrangedSubview(makeQuestCard($0)) }
        }
    }

    private func makeLargeSugarPost() -> UIView {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .clear

        let image = UIImageView(image: UIImage(named: "wevv_challenge_donut_of_day"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 18

        let mark = UIButton(type: .system)
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.tintColor = .white
        mark.setImage(UIImage(systemName: "exclamationmark"), for: .normal)
        mark.layer.borderColor = UIColor.white.cgColor
        mark.layer.borderWidth = 2
        mark.layer.cornerRadius = 24

        let sweet = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        sweet.translatesAutoresizingMaskIntoConstraints = false
        sweet.layer.cornerRadius = 26
        sweet.clipsToBounds = true

        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.tintColor = UIColor(red: 1, green: 0.16, blue: 0.38, alpha: 1)
        let count = makeGlazeLabel("12.5k", size: 17, weight: .semibold, color: UIColor.white.withAlphaComponent(0.86))
        count.textAlignment = .center
        sweet.contentView.addSubview(heart)
        sweet.contentView.addSubview(count)

        card.addSubview(image)
        card.addSubview(mark)
        card.addSubview(sweet)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 1.12),
            image.topAnchor.constraint(equalTo: card.topAnchor),
            image.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            mark.topAnchor.constraint(equalTo: card.topAnchor, constant: 28),
            mark.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),
            mark.widthAnchor.constraint(equalToConstant: 48),
            mark.heightAnchor.constraint(equalToConstant: 48),
            sweet.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -26),
            sweet.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            sweet.widthAnchor.constraint(equalToConstant: 82),
            sweet.heightAnchor.constraint(equalToConstant: 122),
            heart.centerXAnchor.constraint(equalTo: sweet.contentView.centerXAnchor),
            heart.topAnchor.constraint(equalTo: sweet.contentView.topAnchor, constant: 30),
            heart.widthAnchor.constraint(equalToConstant: 30),
            heart.heightAnchor.constraint(equalToConstant: 30),
            count.centerXAnchor.constraint(equalTo: sweet.contentView.centerXAnchor),
            count.topAnchor.constraint(equalTo: heart.bottomAnchor, constant: 10),
            count.leadingAnchor.constraint(equalTo: sweet.contentView.leadingAnchor, constant: 6),
            count.trailingAnchor.constraint(equalTo: sweet.contentView.trailingAnchor, constant: -6)
        ])
        return card
    }

    private func makeQuestCard(_ quest: WevVGlazeQuestCard) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 26

        let image = UIImageView(image: UIImage(named: quest.assetName))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 22

        let title = makeGlazeLabel(quest.title, size: 18, weight: .heavy, color: inkTone)
        title.numberOfLines = 2
        let time = makeGlazeLabel(quest.timeText, size: 15, weight: .heavy, color: mutedTone)
        let place = makeGlazeLabel(quest.placeText, size: 15, weight: .heavy, color: mutedTone)
        let cost = makeGlazeLabel(quest.costText, size: 15, weight: .heavy, color: inkTone)
        let gem = makeGlazeLabel("🔶", size: 18, weight: .heavy, color: .systemYellow)
        let action = WevVGlazePillButton(title: "View")
        action.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(image)
        card.addSubview(title)
        card.addSubview(time)
        card.addSubview(place)
        card.addSubview(gem)
        card.addSubview(cost)
        card.addSubview(action)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 128),
            image.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            image.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            image.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            image.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.28),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            time.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            time.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            time.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            place.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            place.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 6),
            place.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            gem.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            gem.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            gem.widthAnchor.constraint(equalToConstant: 28),
            cost.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 6),
            cost.centerYAnchor.constraint(equalTo: gem.centerYAnchor),
            action.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            action.centerYAnchor.constraint(equalTo: gem.centerYAnchor),
            action.widthAnchor.constraint(equalToConstant: 84),
            action.heightAnchor.constraint(equalToConstant: 44)
        ])
        return card
    }

    private func makeBottomAction(title: String, symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = fill
        button.tintColor = tint
        button.setTitle(title, for: .normal)
        button.setTitleColor(tint, for: .normal)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.82
        button.layer.cornerRadius = 27
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }

    private func questCards() -> [WevVGlazeQuestCard] {
        [
            WevVGlazeQuestCard(
                title: "Newcomer Comedy Club",
                timeText: "Sat · 7:30 PM",
                placeText: "Brooklyn · 10 spots",
                costText: "60 Gold",
                assetName: "wevv_challenge_strawberry_week"
            ),
            WevVGlazeQuestCard(
                title: "Storytelling After Dark",
                timeText: "Sun · 8:30 PM",
                placeText: "SoHo · Audience seats open",
                costText: "80 Gold",
                assetName: "wevv_challenge_donut_of_day"
            )
        ]
    }

    private func makeSugarStat(value: UILabel, title: String) -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        value.font = .systemFont(ofSize: 23, weight: .heavy)
        value.textColor = .black
        value.textAlignment = .center
        let label = makeGlazeLabel(title, size: 15, weight: .regular, color: .black)
        label.textAlignment = .center
        holder.addSubview(value)
        holder.addSubview(label)
        NSLayoutConstraint.activate([
            value.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            value.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            value.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            label.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: holder.trailingAnchor)
        ])
        return holder
    }

    private func makeStatDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.89, green: 0.78, blue: 0.86, alpha: 1)
        return view
    }

    private func configureSegmentButton(_ button: UIButton, title: String, action: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    private func styleSegmentButton(_ button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? pinkTone : .clear
        button.setTitleColor(selected ? .white : .black, for: .normal)
    }

    private func makeGlazeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    @objc private func selectSugarPost() {
        selectedPane = .sugarPost
        refreshSegmentState()
        refreshBodyStack()
    }

    @objc private func selectGlazeQuest() {
        selectedPane = .glazeQuest
        refreshSegmentState()
        refreshBodyStack()
    }

    @objc private func toggleGuestGlazeFollow() {
        guard glazeSession.isTasterReady else {
            showGateForSugarFollow()
            return
        }
        placeSugarFollowToggle()
    }

    private func placeSugarFollowToggle() {
        let isNowFollowed = glazeStore.toggleGlazeFollow(for: guestKey)
        selectedPane = isNowFollowed ? .sugarPost : .glazeQuest
        refreshGlazePage()
    }

    private func showGateForSugarFollow() {
        let gate = WevVFrostingGateController()
        gate.onGlazeReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.placeSugarFollowToggle()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    @objc private func showSugarGuardPrompt() {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        view.addSubview(shade)

        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = UIColor(red: 1, green: 0.86, blue: 0.96, alpha: 1)
        panel.layer.cornerRadius = 28
        shade.addSubview(panel)

        let bell = makeBellMark()
        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.tintColor = UIColor(red: 0.32, green: 0.25, blue: 0.08, alpha: 1)
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.addTarget(self, action: #selector(closeSugarPrompt(_:)), for: .touchUpInside)

        let sparkleLeft = makeGlazeLabel("✦", size: 34, weight: .heavy, color: .white)
        let sparkleRight = makeGlazeLabel("✦", size: 24, weight: .heavy, color: .white)

        let note = makeGlazeLabel(
            "Please wait for the other\nperson to follow you to unlock\nthe chat and video features.",
            size: 18,
            weight: .heavy,
            color: UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1)
        )
        note.textAlignment = .center
        note.numberOfLines = 0

        let ok = UIButton(type: .system)
        ok.translatesAutoresizingMaskIntoConstraints = false
        ok.setTitle("Ok", for: .normal)
        ok.setTitleColor(.white, for: .normal)
        ok.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        ok.backgroundColor = pinkTone
        ok.layer.cornerRadius = 28
        ok.addTarget(self, action: #selector(closeSugarPrompt(_:)), for: .touchUpInside)

        panel.addSubview(bell)
        panel.addSubview(close)
        panel.addSubview(sparkleLeft)
        panel.addSubview(sparkleRight)
        panel.addSubview(note)
        panel.addSubview(ok)

        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panel.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: shade.centerYAnchor, constant: -18),
            panel.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.72),
            panel.heightAnchor.constraint(equalToConstant: 222),
            bell.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
            bell.topAnchor.constraint(equalTo: panel.topAnchor, constant: -86),
            bell.widthAnchor.constraint(equalToConstant: 156),
            bell.heightAnchor.constraint(equalToConstant: 142),
            close.topAnchor.constraint(equalTo: panel.topAnchor, constant: 18),
            close.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -22),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
            sparkleLeft.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 32),
            sparkleLeft.topAnchor.constraint(equalTo: panel.topAnchor, constant: 26),
            sparkleRight.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -58),
            sparkleRight.topAnchor.constraint(equalTo: panel.topAnchor, constant: 42),
            note.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 32),
            note.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -32),
            note.topAnchor.constraint(equalTo: panel.topAnchor, constant: 94),
            ok.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
            ok.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -30),
            ok.widthAnchor.constraint(equalTo: panel.widthAnchor, multiplier: 0.4),
            ok.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func makeBellMark() -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        let bell = UIImageView(image: UIImage(systemName: "bell.fill"))
        bell.translatesAutoresizingMaskIntoConstraints = false
        bell.tintColor = UIColor(red: 1, green: 0.68, blue: 0.05, alpha: 1)
        bell.contentMode = .scaleAspectFit
        holder.addSubview(bell)
        NSLayoutConstraint.activate([
            bell.topAnchor.constraint(equalTo: holder.topAnchor),
            bell.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            bell.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            bell.bottomAnchor.constraint(equalTo: holder.bottomAnchor)
        ])
        return holder
    }

    @objc private func closeSugarPrompt(_ sender: UIView) {
        var layer: UIView? = sender
        while let parent = layer?.superview, parent !== view {
            layer = parent
        }
        layer?.removeFromSuperview()
    }

    @objc private func closeGuestGlazeProfile() {
        dismiss(animated: true)
    }
}
