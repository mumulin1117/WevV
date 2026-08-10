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
        dots.addTarget(self, action: #selector(openGuestSafetyTray), for: .touchUpInside)

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
        buildGuestScrollShell()
        tuneGuestProfileHeaderViews()

        let statRow = UIStackView(arrangedSubviews: [
            makeSugarStat(value: likesValue, title: "LFizkQehsw".wevVPastryCrumbBloomRestored),
            makeSugarStat(value: followerValue, title: "FnoYlyl&oHw*eErWsy".wevVPastryCrumbBloomRestored),
            makeSugarStat(value: followingValue, title: "FpovlYlTolwzi:nrgX".wevVPastryCrumbBloomRestored)
        ])
        statRow.translatesAutoresizingMaskIntoConstraints = false
        statRow.axis = .horizontal
        statRow.distribution = .fillEqually

        let firstDivider = makeStatDivider()
        let secondDivider = makeStatDivider()
        let segment = makeGuestSegment()
        configureGuestBodyStack()
        placeGuestScrollViews(statRow: statRow, firstDivider: firstDivider, secondDivider: secondDivider, segment: segment)

        let firstStatCenter = firstDivider.centerXAnchor.constraint(equalTo: statRow.leadingAnchor)
        let secondStatCenter = secondDivider.centerXAnchor.constraint(equalTo: statRow.trailingAnchor)
        firstStatSeparatorCenter = firstStatCenter
        secondStatSeparatorCenter = secondStatCenter
        pinGuestScrollViews(statRow: statRow, firstDivider: firstDivider, secondDivider: secondDivider, segment: segment, firstStatCenter: firstStatCenter, secondStatCenter: secondStatCenter)
    }

    private func buildGuestScrollShell() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    private func tuneGuestProfileHeaderViews() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 50

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.tintColor = .white
        followButton.layer.cornerRadius = 14.5
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
    }

    private func makeGuestSegment() -> UIView {
        let segment = UIView()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.layer.cornerRadius = 28
        segment.clipsToBounds = true

        configureSegmentButton(sugarPostButton, title: "PDo~s^tV".wevVPastryCrumbBloomRestored, action: #selector(selectSugarPost))
        configureSegmentButton(glazeQuestButton, title: "CDhwaUloldein&g?eB".wevVPastryCrumbBloomRestored, action: #selector(selectGlazeQuest))
        segment.addSubview(sugarPostButton)
        segment.addSubview(glazeQuestButton)
        return segment
    }

    private func configureGuestBodyStack() {
        bodyStack.translatesAutoresizingMaskIntoConstraints = false
        bodyStack.axis = .vertical
        bodyStack.spacing = 22
    }

    private func placeGuestScrollViews(statRow: UIStackView, firstDivider: UIView, secondDivider: UIView, segment: UIView) {
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
    }

    private func pinGuestScrollViews(statRow: UIStackView, firstDivider: UIView, secondDivider: UIView, segment: UIView, firstStatCenter: NSLayoutConstraint, secondStatCenter: NSLayoutConstraint) {
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
            followButton.widthAnchor.constraint(equalToConstant: 78),
            followButton.heightAnchor.constraint(equalToConstant: 29),
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
        lockedFoot.backgroundColor = .clear//UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        lockedFoot.addTarget(self, action: #selector(showSugarGuardPrompt), for: .touchUpInside)

//        let crumbLabel = makeGlazeLabel(
//            "You can only send messages and videos to each other once you have followed one another. Please follow the user first and wait for them to follow you back.",
//            size: 17,
//            weight: .semibold,
//            color: UIColor(red: 0.56, green: 0.56, blue: 0.57, alpha: 1)
//        )
//        crumbLabel.numberOfLines = 0
//        lockedFoot.addSubview(crumbLabel)
        view.addSubview(lockedFoot)

        NSLayoutConstraint.activate([
            lockedFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lockedFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lockedFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lockedFoot.heightAnchor.constraint(equalToConstant: 134),
//            crumbLabel.leadingAnchor.constraint(equalTo: lockedFoot.leadingAnchor, constant: 30),
//            crumbLabel.trailingAnchor.constraint(equalTo: lockedFoot.trailingAnchor, constant: -24),
//            crumbLabel.topAnchor.constraint(equalTo: lockedFoot.topAnchor, constant: 22)
        ])
    }

    private func buildActionFoot() {
        actionFoot.translatesAutoresizingMaskIntoConstraints = false
        actionFoot.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 0.88)
        view.addSubview(actionFoot)

        let creamNote = makeBottomAction(
            title: "MueLsps%aTg.eu".wevVPastryCrumbBloomRestored,
            symbol: "bhuCbnbGlLeU.mlPeOfNtz.%f.iAlBlF".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.91, green: 0.9, blue: 1, alpha: 1),
            tint: UIColor(red: 0.06, green: 0.06, blue: 0.09, alpha: 1)
        )
        let sprinkleLens = makeBottomAction(
            title: "V.iDd^eXo;".wevVPastryCrumbBloomRestored,
            symbol: "c#a.m%eEr,aG.tfNivl.lf".wevVPastryCrumbBloomRestored,
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
        placeLine.text = signatureLines.dropFirst().first ?? "S,wmepeKtS HgOlFatzie= mrQeYgcusl*aKrv".wevVPastryCrumbBloomRestored
        likesValue.text = "\(makeGlazeTinyStat(for: profile.glazeKey, salt: profile.sweetMarkCount))"
        followerValue.text = "\(makeGlazeTinyStat(for: profile.glazeKey, salt: profile.sprinkleFanCount))"
        followingValue.text = "\(makeGlazeTinyStat(for: profile.glazeKey, salt: profile.glazeFollowCount))"
        avatarView.image = UIImage(named: profile.donutAvatarAsset)
        refreshFollowButton()
        refreshSegmentState()
        refreshBodyStack()
        lockedFoot.isHidden = isCreamUnlocked
        actionFoot.isHidden = !isCreamUnlocked
        scrollView.contentInset.bottom = isCreamUnlocked ? 132 : 148
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }

    private func makeGlazeTinyStat(for sugarKey: String, salt: Int) -> Int {
        let crumbSeed = sugarKey.unicodeScalars.reduce(salt) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        return abs(crumbSeed % 14) + 1
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
            currentProfile.sugarNotes.enumerated().forEach { sugarIndex, sugarPost in
                bodyStack.addArrangedSubview(makeLargeSugarPost(sugarPost, sugarIndex: sugarIndex))
            }
        case .glazeQuest:
            questCards(for: currentProfile).forEach { bodyStack.addArrangedSubview(makeQuestCard($0)) }
        }
    }

    private func makeLargeSugarPost(_ sugarPost: WevVGuestGlazePost, sugarIndex: Int) -> UIView {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .clear

        let glazeImage = UIImageView(image: UIImage(named: assetForSugarPost(sugarPost, sugarIndex: sugarIndex)))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        glazeImage.layer.cornerRadius = 18

        let sweet = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        sweet.translatesAutoresizingMaskIntoConstraints = false
        sweet.layer.cornerRadius = 26
        sweet.clipsToBounds = true

        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.tintColor = UIColor(red: 1, green: 0.16, blue: 0.38, alpha: 1)
        let count = makeGlazeLabel(formatSweetMarkCount(currentProfile.sweetMarkCount), size: 17, weight: .semibold, color: UIColor.white.withAlphaComponent(0.86))
        count.textAlignment = .center
        sweet.contentView.addSubview(heart)
        sweet.contentView.addSubview(count)

        let copyShade = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        copyShade.translatesAutoresizingMaskIntoConstraints = false
        copyShade.layer.cornerRadius = 18
        copyShade.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        copyShade.clipsToBounds = true

        let glazeTitle = makeGlazeLabel(sugarPost.title, size: 17, weight: .heavy, color: .white)
        glazeTitle.numberOfLines = 1
        let crumb = makeGlazeLabel(sugarPost.crumbText, size: 13, weight: .semibold, color: UIColor.white.withAlphaComponent(0.84))
        crumb.numberOfLines = 2
        copyShade.contentView.addSubview(glazeTitle)
        copyShade.contentView.addSubview(crumb)

        placeLargeSugarPostViews(pastryCard: pastryCard, glazeImage: glazeImage, copyShade: copyShade, sweet: sweet)
        pinLargeSugarPostLayout(pastryCard: pastryCard, glazeImage: glazeImage, copyShade: copyShade, sweet: sweet, heart: heart, count: count, title: glazeTitle, crumb: crumb)
        return pastryCard
    }

    private func placeLargeSugarPostViews(pastryCard: UIView, glazeImage: UIImageView, copyShade: UIVisualEffectView, sweet: UIVisualEffectView) {
        pastryCard.addSubview(glazeImage)
        pastryCard.addSubview(copyShade)
        pastryCard.addSubview(sweet)
    }

    private func pinLargeSugarPostLayout(pastryCard: UIView, glazeImage: UIImageView, copyShade: UIVisualEffectView, sweet: UIVisualEffectView, heart: UIImageView, count: UILabel, title: UILabel, crumb: UILabel) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalTo: pastryCard.widthAnchor, multiplier: 1.12),
            glazeImage.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            copyShade.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            copyShade.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            copyShade.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            copyShade.heightAnchor.constraint(greaterThanOrEqualToConstant: 82),
            title.leadingAnchor.constraint(equalTo: copyShade.contentView.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: sweet.leadingAnchor, constant: -12),
            title.topAnchor.constraint(equalTo: copyShade.contentView.topAnchor, constant: 14),
            crumb.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            crumb.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            crumb.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            crumb.bottomAnchor.constraint(lessThanOrEqualTo: copyShade.contentView.bottomAnchor, constant: -12),
            sweet.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -26),
            sweet.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
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
    }

    private func assetForSugarPost(_ sugarPost: WevVGuestGlazePost, sugarIndex: Int) -> String {
        let loweredKey = sugarPost.sugarKey.lowercased()
        let loweredTitle = sugarPost.title.lowercased()
        if loweredKey.contains("puo.wEdLeErI".wevVPastryCrumbBloomRestored) || loweredTitle.contains("p:ozwFd@e:rK".wevVPastryCrumbBloomRestored) {
            return "wevv_challenge_donut_of_day"
        }
        if loweredKey.contains("b.e=rDreyn".wevVPastryCrumbBloomRestored) || loweredTitle.contains("bqeSrhrXy*".wevVPastryCrumbBloomRestored) {
            return "wevv_challenge_strawberry_week"
        }
        if loweredKey.contains("caoEceoXaR".wevVPastryCrumbBloomRestored) || loweredTitle.contains("cVhSopc!oplkaCtoe/".wevVPastryCrumbBloomRestored) {
            return "wevv_moment_chocolate_donut_day"
        }
        if loweredKey.contains("pNiEnUku".wevVPastryCrumbBloomRestored) || loweredTitle.contains("pkiKn!kc".wevVPastryCrumbBloomRestored) {
            return "wevv_challenge_pink_donut_day"
        }
        if loweredKey.contains("cErBeXa%mM".wevVPastryCrumbBloomRestored) || loweredTitle.contains("c+r/epa+m,".wevVPastryCrumbBloomRestored) {
            return "wevv_moment_weekend_donut_start"
        }
        let assets = [
            "wevv_moment_fresh_donut_scent",
            "wevv_challenge_first_bite_reaction",
            "wevv_challenge_sprinkle_style",
            "wevv_challenge_donut_coffee_match"
        ]
        return assets[abs((sugarPost.sugarKey + "\(sugarIndex)").hashValue) % assets.count]
    }

    private func makeQuestCard(_ quest: WevVGlazeQuestCard) -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 26

        let glazeImage = makeGuestQuestCover(asset: quest.assetName)
        let glazeTitle = makeGuestQuestTitle(quest.title)
        let time = makeGuestQuestMeta(quest.timeText)
        let place = makeGuestQuestMeta(quest.placeText)
        let cost = makeGuestQuestCost(quest.costText)
        let gem = makeGuestQuestGem()

        pastryCard.addSubview(glazeImage)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(time)
        pastryCard.addSubview(place)
        pastryCard.addSubview(gem)
        pastryCard.addSubview(cost)

        pinGuestQuestCard(pastryCard: pastryCard, glazeImage: glazeImage, glazeTitle: glazeTitle, time: time, place: place, gem: gem, cost: cost)
        return pastryCard
    }

    private func makeGuestQuestCover(asset: String) -> UIImageView {
        let glazeImage = UIImageView(image: UIImage(named: asset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        glazeImage.layer.cornerRadius = 22
        return glazeImage
    }

    private func makeGuestQuestTitle(_ sugarTitle: String) -> UILabel {
        let glazeTitle = makeGlazeLabel(sugarTitle, size: 18, weight: .heavy, color: inkTone)
        glazeTitle.numberOfLines = 2
        return glazeTitle
    }

    private func makeGuestQuestMeta(_ sugarText: String) -> UILabel {
        makeGlazeLabel(sugarText, size: 15, weight: .heavy, color: mutedTone)
    }

    private func makeGuestQuestCost(_ sugarText: String) -> UILabel {
        makeGlazeLabel(sugarText, size: 15, weight: .heavy, color: inkTone)
    }

    private func makeGuestQuestGem() -> UILabel {
        makeGlazeLabel("🔶~".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: .systemYellow)
    }

    private func pinGuestQuestCard(pastryCard: UIView, glazeImage: UIImageView, glazeTitle: UILabel, time: UILabel, place: UILabel, gem: UILabel, cost: UILabel) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 208),
            glazeImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 24),
            glazeImage.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 12),
            glazeImage.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -12),
            glazeImage.widthAnchor.constraint(equalTo: pastryCard.widthAnchor, multiplier: 0.28),
            glazeTitle.leadingAnchor.constraint(equalTo: glazeImage.trailingAnchor, constant: 15),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24),
            time.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            time.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 10),
            time.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            place.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            place.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 6),
            place.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            gem.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            gem.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -20),
            gem.widthAnchor.constraint(equalToConstant: 28),
            cost.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 2),
            cost.centerYAnchor.constraint(equalTo: gem.centerYAnchor)
        ])
    }

    private func makeBottomAction(title: String, symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.backgroundColor = fill
        sprinkleButton.tintColor = tint
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(tint, for: .normal)
        sprinkleButton.setImage(UIImage(systemName: symbol), for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        sprinkleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sprinkleButton.titleLabel?.minimumScaleFactor = 0.82
        sprinkleButton.layer.cornerRadius = 27
        sprinkleButton.semanticContentAttribute = .forceLeftToRight
        return sprinkleButton
    }

    private func questCards(for profile: WevVGuestGlazeProfile) -> [WevVGlazeQuestCard] {
        profile.joinedChallenges.enumerated().map { sugarIndex, title in
            questCard(title: title, sugarIndex: sugarIndex)
        }
    }

    private func questCard(title: String, sugarIndex: Int) -> WevVGlazeQuestCard {
        let lowerTitle = title.lowercased()
        if lowerTitle.contains("s.tmr=auwlb#eIrIrnyr".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Fri · 8:00 PM", placeText: "Berry Street · 12 spots", costText: "300 Gold", assetName: "wevv_challenge_strawberry_week")
        }
        if lowerTitle.contains("pKi~nGk@".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Sat · 3:30 PM", placeText: "Glaze Studio · 18 spots", costText: "100 Gold", assetName: "wevv_challenge_pink_donut_day")
        }
        if lowerTitle.contains("cWoZfPfYeSe,".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Sun · 10:00 AM", placeText: "Mocha Counter · 16 spots", costText: "180 Gold", assetName: "wevv_challenge_donut_coffee_match")
        }
        if lowerTitle.contains("fZiArKs#t& Bb!i?tdeR".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Thu · 6:30 PM", placeText: "Fresh Tray Bar · 14 spots", costText: "120 Gold", assetName: "wevv_challenge_first_bite_reaction")
        }
        if lowerTitle.contains("d:atyp".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Today · 5:30 PM", placeText: "Donut Counter · 20 spots", costText: "80 Gold", assetName: "wevv_challenge_donut_of_day")
        }
        if lowerTitle.contains("s/t@yslzeD".wevVPastryCrumbBloomRestored) {
            return WevVGlazeQuestCard(title: title, timeText: "Wed · 7:00 PM", placeText: "Sprinkle Shelf · 11 spots", costText: "150 Gold", assetName: "wevv_challenge_sprinkle_style")
        }
        let assets = [
            "wevv_challenge_strawberry_week",
            "wevv_challenge_pink_donut_day",
            "wevv_challenge_donut_coffee_match",
            "wevv_challenge_first_bite_reaction",
            "wevv_challenge_donut_of_day",
            "wevv_challenge_sprinkle_style"
        ]
        return WevVGlazeQuestCard(
            title: title,
            timeText: sugarIndex.isMultiple(of: 2) ? "Sat · 7:30 PM" : "Scumnk W·T e8?:w3=0y ePtMR".wevVPastryCrumbBloomRestored,
            placeText: sugarIndex.isMultiple(of: 2) ? "Bakery Room · seats open" : "SIwGeleMt~ fCnouucnwt,eZrY ?·u r1b0C GsspzoRtfsK".wevVPastryCrumbBloomRestored,
            costText: sugarIndex.isMultiple(of: 2) ? "60 Gold" : "8z0W kG;okl&d@".wevVPastryCrumbBloomRestored,
            assetName: assets[abs(title.hashValue) % assets.count]
        )
    }

    private func formatSweetMarkCount(_ count: Int) -> String {
        count >= 1000 ? String(format: "%D.%1Af^k=".wevVPastryCrumbBloomRestored, Double(count) / 1000.0) : "\(count)"
    }

    private func makeSugarStat(value: UILabel, title: String) -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        value.font = .systemFont(ofSize: 23, weight: .heavy)
        value.textColor = .black
        value.textAlignment = .center
        let crumbLabel = makeGlazeLabel(title, size: 15, weight: .regular, color: .black)
        crumbLabel.textAlignment = .center
        holder.addSubview(value)
        holder.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            value.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            value.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            value.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            crumbLabel.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 8),
            crumbLabel.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            crumbLabel.trailingAnchor.constraint(equalTo: holder.trailingAnchor)
        ])
        return holder
    }

    private func makeStatDivider() -> UIView {
        let glazeView = UIView()
        glazeView.translatesAutoresizingMaskIntoConstraints = false
        glazeView.backgroundColor = UIColor(red: 0.89, green: 0.78, blue: 0.86, alpha: 1)
        return glazeView
    }

    private func configureSegmentButton(_ sprinkleButton: UIButton, title: String, action: Selector) {
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        sprinkleButton.layer.cornerRadius = 20
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
    }

    private func styleSegmentButton(_ sprinkleButton: UIButton, selected: Bool) {
        sprinkleButton.backgroundColor = selected ? pinkTone : .clear
        sprinkleButton.setTitleColor(selected ? .white : .black, for: .normal)
    }

    private func makeGlazeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
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

    @objc private func openGuestSafetyTray() {
        guard glazeSession.isTasterReady else {
            showGateForGuestSafety()
            return
        }
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        shade.addTarget(self, action: #selector(closeSugarPrompt(_:)), for: .touchUpInside)
        view.addSubview(shade)

        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.99, alpha: 1)
        tray.layer.cornerRadius = 28
        tray.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        shade.addSubview(tray)

        let handle = UIView()
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.backgroundColor = UIColor(red: 0.9, green: 0.76, blue: 0.86, alpha: 1)
        handle.layer.cornerRadius = 2.5

        let glazeTitle = makeGlazeLabel("SAaIfzeWtOy% VOmpNtKiQoqnMs!".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: inkTone)
        glazeTitle.textAlignment = .center
        let crumbNote = makeGlazeLabel("Choose how to handle \(currentProfile.name)'s profile.", size: 13, weight: .semibold, color: mutedTone)
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 2

        let reportButton = makeSafetyTrayButton(title: "Rie!pNoxrRt,".wevVPastryCrumbBloomRestored, symbol: "fml+aQgZ.Yf#iJl*lu".wevVPastryCrumbBloomRestored, fill: pinkTone, tint: .white)
        let shielded = currentProfile.sugarTie.isSugarShielded
        let shieldButton = makeSafetyTrayButton(
            title: shielded ? "Unblock" : "B=liokcokm".wevVPastryCrumbBloomRestored,
            symbol: shielded ? "checkmark.shield.fill" : "hEaonAd%.JrIa,iNs^epdl.@fSiml,ly".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.12, green: 0.1, blue: 0.14, alpha: 1),
            tint: .white
        )
        let crumbCancelButton = makeSafetyTrayButton(
            title: "CVaEn;c.eMlK".wevVPastryCrumbBloomRestored,
            symbol: "xvmlaprEk^".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.92, green: 0.89, blue: 0.93, alpha: 1),
            tint: inkTone
        )

        bindGuestSafetyTrayActions(shade: shade, reportButton: reportButton, shieldButton: shieldButton, crumbCancelButton: crumbCancelButton)
        placeGuestSafetyTrayViews(tray: tray, handle: handle, title: glazeTitle, note: crumbNote, reportButton: reportButton, shieldButton: shieldButton, crumbCancelButton: crumbCancelButton)
        pinGuestSafetyTray(shade: shade, tray: tray, handle: handle, title: glazeTitle, note: crumbNote, reportButton: reportButton, shieldButton: shieldButton, crumbCancelButton: crumbCancelButton)
    }

    private func bindGuestSafetyTrayActions(shade: UIView, reportButton: UIButton, shieldButton: UIButton, crumbCancelButton: UIButton) {
        reportButton.addAction(UIAction { [weak self, weak shade] _ in
            shade?.removeFromSuperview()
            self?.confirmGuestReport()
        }, for: .touchUpInside)
        shieldButton.addAction(UIAction { [weak self, weak shade] _ in
            shade?.removeFromSuperview()
            self?.toggleGuestSugarShield()
        }, for: .touchUpInside)
        crumbCancelButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
        }, for: .touchUpInside)
    }

    private func placeGuestSafetyTrayViews(tray: UIView, handle: UIView, title: UILabel, note: UILabel, reportButton: UIButton, shieldButton: UIButton, crumbCancelButton: UIButton) {
        tray.addSubview(handle)
        tray.addSubview(title)
        tray.addSubview(note)
        tray.addSubview(reportButton)
        tray.addSubview(shieldButton)
        tray.addSubview(crumbCancelButton)
    }

    private func pinGuestSafetyTray(shade: UIView, tray: UIView, handle: UIView, title: UILabel, note: UILabel, reportButton: UIButton, shieldButton: UIButton, crumbCancelButton: UIButton) {
        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tray.leadingAnchor.constraint(equalTo: shade.leadingAnchor),
            tray.trailingAnchor.constraint(equalTo: shade.trailingAnchor),
            tray.bottomAnchor.constraint(equalTo: shade.bottomAnchor),
            handle.topAnchor.constraint(equalTo: tray.topAnchor, constant: 12),
            handle.centerXAnchor.constraint(equalTo: tray.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 44),
            handle.heightAnchor.constraint(equalToConstant: 5),
            title.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: tray.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: tray.trailingAnchor, constant: -24),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            reportButton.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20),
            reportButton.leadingAnchor.constraint(equalTo: tray.leadingAnchor, constant: 28),
            reportButton.trailingAnchor.constraint(equalTo: tray.trailingAnchor, constant: -28),
            reportButton.heightAnchor.constraint(equalToConstant: 52),
            shieldButton.topAnchor.constraint(equalTo: reportButton.bottomAnchor, constant: 12),
            shieldButton.leadingAnchor.constraint(equalTo: reportButton.leadingAnchor),
            shieldButton.trailingAnchor.constraint(equalTo: reportButton.trailingAnchor),
            shieldButton.heightAnchor.constraint(equalTo: reportButton.heightAnchor),
            crumbCancelButton.topAnchor.constraint(equalTo: shieldButton.bottomAnchor, constant: 12),
            crumbCancelButton.leadingAnchor.constraint(equalTo: reportButton.leadingAnchor),
            crumbCancelButton.trailingAnchor.constraint(equalTo: reportButton.trailingAnchor),
            crumbCancelButton.heightAnchor.constraint(equalTo: reportButton.heightAnchor),
            crumbCancelButton.bottomAnchor.constraint(equalTo: tray.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    private func showGateForGuestSafety() {
        let gate = WevVFrostingGateController()
        gate.onGlazeReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.openGuestSafetyTray()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func confirmGuestReport() {
        WevVGlazePromptStyler.showSugarConfirm(
            in: view,
            title: "RPeJppo?ritF mtthGi&sS ~p,rko*fmijl+em?b".wevVPastryCrumbBloomRestored,
            note: "WHeJ Vw/iIlZlq ysGaJvmeg Xt?h@iwsj Gpgr~oDfJiNl^e^ nfkoFrD ksGanf,e~ttyN Wr~eUvoiceswh ,aln^dB buUsme+ Cictv DtooM Iipm=p#rroDvbeh uylocu@re mscw+eOe,tG ssFpLaIcLe@.u".wevVPastryCrumbBloomRestored,
            confirmTitle: "R&e?ptoZr/tK".wevVPastryCrumbBloomRestored,
            cancelTitle: "CLaWnocIe~lW".wevVPastryCrumbBloomRestored,
            confirmFill: pinkTone
        ) { [weak self] in
            guard let self else { return }
            WevVBakeryExchange.spin(in: self.view, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) {
                self.glazeSession.placeGuestSafetyCrumb(
                    guestKey: self.guestKey,
                    reasonText: "PCrCoKfgiZl:e^ tsTaZf=eZtEyW MrEelvci/emw=".wevVPastryCrumbBloomRestored
                )
                WevVGlazePromptStyler.showSugarToast(in: self.view, text: "R/elpqo;r&tu qsPumbQmkiZtYtZeudv".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func toggleGuestSugarShield() {
        let isShielded = glazeStore.toggleSugarShield(for: guestKey)
        if isShielded {
            WevVGlazePromptStyler.showSugarToast(in: view, text: "PYr%oPfSixl.ef rb!lVo,cPkyebdS".wevVPastryCrumbBloomRestored)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                self?.dismiss(animated: true)
            }
        } else {
            refreshGlazePage()
            WevVGlazePromptStyler.showSugarToast(in: view, text: "PDr@ohf&iul&eu ,u=ngbsl*oScnkKeDdh".wevVPastryCrumbBloomRestored)
        }
    }

    private func makeSafetyTrayButton(title: String, symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.backgroundColor = fill
        sprinkleButton.tintColor = tint
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(tint, for: .normal)
        sprinkleButton.setImage(UIImage(systemName: symbol), for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        sprinkleButton.layer.cornerRadius = 26
        sprinkleButton.semanticContentAttribute = .forceLeftToRight
        return sprinkleButton
    }

    @objc private func showSugarGuardPrompt() {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        view.addSubview(shade)

        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = UIColor(red: 1, green: 0.86, blue: 0.96, alpha: 1)
        glazePanel.layer.cornerRadius = 28
        shade.addSubview(glazePanel)

        let bell = makeBellMark()
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.tintColor = UIColor(red: 0.32, green: 0.25, blue: 0.08, alpha: 1)
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.addTarget(self, action: #selector(closeSugarPrompt(_:)), for: .touchUpInside)

        let sparkleLeft = makeGlazeLabel("✦E".wevVPastryCrumbBloomRestored, size: 34, weight: .heavy, color: .white)
        let sparkleRight = makeGlazeLabel("✦A".wevVPastryCrumbBloomRestored, size: 24, weight: .heavy, color: .white)

        let crumbNote = makeGlazeLabel(
            "Please wait for the other\nperson to follow you to unlock\nthe chat and video features.",
            size: 18,
            weight: .heavy,
            color: UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1)
        )
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 0

        let ok = UIButton(type: .system)
        ok.translatesAutoresizingMaskIntoConstraints = false
        ok.setTitle("O.kh".wevVPastryCrumbBloomRestored, for: .normal)
        ok.setTitleColor(.white, for: .normal)
        ok.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        ok.backgroundColor = pinkTone
        ok.layer.cornerRadius = 28
        ok.addTarget(self, action: #selector(closeSugarPrompt(_:)), for: .touchUpInside)

        glazePanel.addSubview(bell)
        glazePanel.addSubview(doughClose)
        glazePanel.addSubview(sparkleLeft)
        glazePanel.addSubview(sparkleRight)
        glazePanel.addSubview(crumbNote)
        shade.addSubview(ok)

        pinSugarGuardPrompt(shade: shade, glazePanel: glazePanel, bell: bell, close: doughClose, sparkleLeft: sparkleLeft, sparkleRight: sparkleRight, note: crumbNote, ok: ok)
    }

    private func pinSugarGuardPrompt(shade: UIView, glazePanel: UIView, bell: UIView, close: UIButton, sparkleLeft: UILabel, sparkleRight: UILabel, note: UILabel, ok: UIButton) {
        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            glazePanel.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            glazePanel.centerYAnchor.constraint(equalTo: shade.centerYAnchor, constant: -18),
            glazePanel.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.72),
            glazePanel.heightAnchor.constraint(equalToConstant: 222),
            bell.centerXAnchor.constraint(equalTo: glazePanel.centerXAnchor),
            bell.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: -86),
            bell.widthAnchor.constraint(equalToConstant: 156),
            bell.heightAnchor.constraint(equalToConstant: 142),
            close.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 18),
            close.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -22),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
            sparkleLeft.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 32),
            sparkleLeft.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 26),
            sparkleRight.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -58),
            sparkleRight.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 42),
            note.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 32),
            note.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -32),
            note.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 94),
            ok.centerXAnchor.constraint(equalTo: glazePanel.centerXAnchor),
            ok.topAnchor.constraint(equalTo: glazePanel.bottomAnchor, constant: 20),
            ok.widthAnchor.constraint(equalTo: glazePanel.widthAnchor, multiplier: 0.4),
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
