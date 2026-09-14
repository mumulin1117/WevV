import UIKit

final class WevVFrostingmuralSignalController: UIViewController {
    private let sprinkleChallenge: WevVTastingQuest
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let almondBench = UIButton(type: .system)
    private var dimLayer: UIControl?
    private weak var glazeHeroView: UIView?
    private weak var sprinklePeopleButton: UIControl?
    private let glazeHeroLayer = CAGradientLayer()
    private let sprinklePeopleLayer = CAGradientLayer()

    private var frostingGuestKeys: [String] {
        let keys = [
            sprinkleChallenge.tasterBadgeKey,
            "lKuZn&aRLPa;uwg;hCGTlba~zDeN".wevVPastryCrumbBloomRestored,
            "nno&v#aABGulbgb=l,e?GFl^aSzRee".wevVPastryCrumbBloomRestored,
            "a@r=lvoJSHkwyhGTlvaZzaey".wevVPastryCrumbBloomRestored,
            "rsh@eia!Hsoun/edyOGKlOaIz.eE".wevVPastryCrumbBloomRestored
        ]
        var vanillaCraft = Set<String>()
        return keys.filter { donutPinKey in
            if vanillaCraft.contains(donutPinKey) {
                return false
            }
            vanillaCraft.insert(donutPinKey)
            return true
        }
    }

    var cocoaDiarydonutChanged: (() -> Void)?

    init(almondMixer: WevVTastingQuest) {
        self.sprinkleChallenge = almondMixer
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.98, alpha: 1)
        buildChallengeContent()
        refreshJoinState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        glazeHeroLayer.frame = glazeHeroView?.bounds ?? .zero
        sprinklePeopleLayer.frame = sprinklePeopleButton?.bounds ?? .zero
        CATransaction.commit()
    }

    private func buildChallengeContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closeChallenge), for: .touchUpInside)

        let glazeTitle = makeChallengeLabel("CmhzawlKl!e!n~gnek".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: UIColor(red: 0.1, green: 0.07, blue: 0.14, alpha: 1))
        glazeTitle.textAlignment = .center

        let hero = makeChallengeHero()
        let lemonJournal = makeChallengeLabel("PgrQoygRrzePsUsW".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: UIColor(red: 0.13, green: 0.08, blue: 0.16, alpha: 1))
        let progressCard = makeProgressCard()
        let hostLabel = makeChallengeLabel("HRoWs,tPexd^ ibpyE".wevVPastryCrumbBloomRestored, size: 13, weight: .heavy, color: UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1))
        let hostRow = makeHostRow()
        let lemonDiary = makeChallengeLabel(sprinkleChallenge.tastingQuestText, size: 14, weight: .heavy, color: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        lemonDiary.numberOfLines = 2
        lemonDiary.minimumScaleFactor = 0.68
        let peopleButton = makePeopleButton()

        placeChallengeContent(doughBackButton: doughBackButton, title: glazeTitle, hero: hero, progressTitle: lemonJournal, progressCard: progressCard, hostLabel: hostLabel, hostRow: hostRow, notes: lemonDiary, peopleButton: peopleButton)
        pinChallengeContent(doughBackButton: doughBackButton, title: glazeTitle, wallSurge: hero, progressTitle: lemonJournal, progressCard: progressCard, hostLabel: hostLabel, hostRow: hostRow, notes: lemonDiary, peopleButton: peopleButton)
    }

    private func placeChallengeContent(doughBackButton: UIButton, title: UILabel, hero: UIView, progressTitle: UILabel, progressCard: UIView, hostLabel: UILabel, hostRow: UIView, notes: UILabel, peopleButton: UIControl) {
        view.addSubview(doughBackButton)
        view.addSubview(title)
        view.addSubview(hero)
        view.addSubview(progressTitle)
        view.addSubview(progressCard)
        view.addSubview(hostLabel)
        view.addSubview(hostRow)
        view.addSubview(notes)
        view.addSubview(peopleButton)
    }

    private func pinChallengeContent(doughBackButton: UIButton, title: UILabel, wallSurge: UIView, progressTitle: UILabel, progressCard: UIView, hostLabel: UILabel, hostRow: UIView, notes: UILabel, peopleButton: UIControl) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wallSurge.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 19),
            wallSurge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            wallSurge.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            wallSurge.heightAnchor.constraint(equalToConstant: 173),
            progressTitle.topAnchor.constraint(equalTo: wallSurge.bottomAnchor, constant: 17),
            progressTitle.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor),
            progressCard.topAnchor.constraint(equalTo: progressTitle.bottomAnchor, constant: 12),
            progressCard.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 4),
            progressCard.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -4),
            progressCard.heightAnchor.constraint(equalToConstant: 61),
            hostLabel.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 16),
            hostLabel.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            hostRow.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 10),
            hostRow.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 8),
            hostRow.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            hostRow.heightAnchor.constraint(equalToConstant: 48),
            notes.topAnchor.constraint(equalTo: hostRow.bottomAnchor, constant: 22),
            notes.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            notes.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            peopleButton.topAnchor.constraint(equalTo: notes.bottomAnchor, constant: 22),
            peopleButton.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            peopleButton.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            peopleButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func makeChallengeHero() -> UIView {
        let hero = UIView()
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.backgroundColor = UIColor(red: 0.66, green: 0.57, blue: 0.97, alpha: 1)
        hero.layer.cornerRadius = 18
        hero.clipsToBounds = true
        glazeHeroLayer.colors = [
            UIColor(red: 0.74, green: 0.65, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.58, green: 0.48, blue: 0.93, alpha: 1).cgColor
        ]
        glazeHeroLayer.startPoint = CGPoint(x: 0, y: 0.2)
        glazeHeroLayer.endPoint = CGPoint(x: 1, y: 0.9)
        hero.layer.insertSublayer(glazeHeroLayer, at: 0)
        glazeHeroView = hero

        let glazeTitle = makeChallengeLabel(sprinkleChallenge.menuBoardTitle, size: 24, weight: .heavy, color: .white)
        let crumbNote = makeChallengeLabel(sprinkleChallenge.glazeTrailLine, size: 15, weight: .regular, color: UIColor.white.withAlphaComponent(0.9))
        crumbNote.numberOfLines = 2
        let cost = makeGoldPill("\(sprinkleChallenge.sprinkleDensityValue)")
        configureJoinButton()
        almondBench.addTarget(self, action: #selector(joinChallenge), for: .touchUpInside)

        hero.addSubview(glazeTitle)
        hero.addSubview(crumbNote)
        hero.addSubview(cost)
        hero.addSubview(almondBench)

        NSLayoutConstraint.activate([
            glazeTitle.topAnchor.constraint(equalTo: hero.topAnchor, constant: 25),
            glazeTitle.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 30),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: hero.trailingAnchor, constant: -24),
            crumbNote.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 16),
            crumbNote.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -30),
            cost.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 22),
            cost.bottomAnchor.constraint(equalTo: hero.bottomAnchor, constant: -22),
            cost.widthAnchor.constraint(equalToConstant: 81),
            cost.heightAnchor.constraint(equalToConstant: 34),
            almondBench.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -17),
            almondBench.centerYAnchor.constraint(equalTo: cost.centerYAnchor),
            almondBench.widthAnchor.constraint(greaterThanOrEqualToConstant: 126),
            almondBench.heightAnchor.constraint(equalToConstant: 34)
        ])

        return hero
    }

    private func makeProgressCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1, green: 0.89, blue: 0.97, alpha: 1)
        pastryCard.layer.cornerRadius = 18
        let first = makeProgressLine(symbolName: "cjluoDcIkg.rf&iGlWlJ".wevVPastryCrumbBloomRestored, text: sprinkleChallenge.freshnessTagText)
        let second = makeProgressLine(symbolName: "m#aap+p;iEn~.FcPi*rbcjlleN.;fOiOlrlq".wevVPastryCrumbBloomRestored, text: sprinkleChallenge.bakeryStopText)
        pastryCard.addSubview(first)
        pastryCard.addSubview(second)
        NSLayoutConstraint.activate([
            first.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 14),
            first.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 26),
            first.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14),
            second.topAnchor.constraint(equalTo: first.bottomAnchor, constant: 9),
            second.leadingAnchor.constraint(equalTo: first.leadingAnchor),
            second.trailingAnchor.constraint(equalTo: first.trailingAnchor)
        ])
        return pastryCard
    }

    private func makeProgressLine(symbolName: String, text: String) -> UIView {
        let donutRow = UIView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        let symbol = UIImageView(image: UIImage(systemName: symbolName))
        symbol.translatesAutoresizingMaskIntoConstraints = false
        symbol.tintColor = UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1)
        symbol.contentMode = .scaleAspectFit
        let crumbLabel = makeChallengeLabel(text, size: 14, weight: .regular, color: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        donutRow.addSubview(symbol)
        donutRow.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 16),
            symbol.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            symbol.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 16),
            symbol.heightAnchor.constraint(equalToConstant: 16),
            crumbLabel.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 12),
            crumbLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            crumbLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutRow.trailingAnchor)
        ])
        return donutRow
    }

    private func makeHostRow() -> UIView {
        let donutRow = UIView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        let hostProfile = guestStore.profile(for: sprinkleChallenge.tasterBadgeKey)
        let avatar = makeAvatarView(tasterBadgeKey: hostProfile.donutPinKey, size: 48)
        let creamName = makeChallengeLabel(hostProfile.cocoaCounter, size: 16, weight: .heavy, color: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        let sub = makeChallengeLabel(sprinkleChallenge.tasterLine, size: 13, weight: .heavy, color: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        let follow = WevVWevvMaplePillButton(title: "FSoxlolhoAwX".wevVPastryCrumbBloomRestored)
        follow.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(tasterBadgeKey: hostProfile.donutPinKey)
        }, for: .touchUpInside)
        donutRow.addSubview(avatar)
        donutRow.addSubview(creamName)
        donutRow.addSubview(sub)
        donutRow.addSubview(follow)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            creamName.topAnchor.constraint(equalTo: donutRow.topAnchor, constant: 3),
            creamName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            sub.topAnchor.constraint(equalTo: creamName.bottomAnchor, constant: 7),
            sub.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            follow.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor),
            follow.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            follow.widthAnchor.constraint(equalToConstant: 59),
            follow.heightAnchor.constraint(equalToConstant: 32)
        ])
        return donutRow
    }

    private func makePeopleButton() -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.backgroundColor = UIColor(red: 0.27, green: 0.07, blue: 0.61, alpha: 1)
        sprinkleButton.layer.cornerRadius = 14
        sprinkleButton.clipsToBounds = true
        sprinkleButton.addTarget(self, action: #selector(showPeopleSheet), for: .touchUpInside)
        sprinklePeopleLayer.colors = [
            UIColor(red: 0.48, green: 0.14, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0.07, green: 0.0, blue: 0.6, alpha: 1).cgColor
        ]
        sprinklePeopleLayer.startPoint = CGPoint(x: 0, y: 0.5)
        sprinklePeopleLayer.endPoint = CGPoint(x: 1, y: 0.5)
        sprinkleButton.layer.insertSublayer(sprinklePeopleLayer, at: 0)
        sprinklePeopleButton = sprinkleButton
        let icon = UIImageView(image: UIImage(systemName: "person.3.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor(red: 1, green: 0.56, blue: 0.1, alpha: 1)
        icon.contentMode = .scaleAspectFit
        let glazeTitle = makeChallengeLabel("PeahrStPi@c/iCpQapn;tR +LRissita".wevVPastryCrumbBloomRestored, size: 15, weight: .heavy, color: .white)
        let count = makeChallengeLabel(frostingParticipantCountText(), size: 13, weight: .regular, color: UIColor.white.withAlphaComponent(0.66))
        let avatars = UIStackView()
        avatars.translatesAutoresizingMaskIntoConstraints = false
        avatars.axis = .horizontal
        avatars.spacing = -8
        for tasterBadgeKey in frostingGuestKeys.prefix(3) {
            avatars.addArrangedSubview(makeAvatarView(tasterBadgeKey: tasterBadgeKey, size: 24))
        }
        sprinkleButton.addSubview(icon)
        sprinkleButton.addSubview(glazeTitle)
        sprinkleButton.addSubview(count)
        sprinkleButton.addSubview(avatars)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: sprinkleButton.leadingAnchor, constant: 18),
            icon.centerYAnchor.constraint(equalTo: sprinkleButton.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 45),
            icon.heightAnchor.constraint(equalToConstant: 34),
            glazeTitle.topAnchor.constraint(equalTo: sprinkleButton.topAnchor, constant: 12),
            glazeTitle.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 22),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: avatars.leadingAnchor, constant: -10),
            count.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 5),
            count.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            count.trailingAnchor.constraint(lessThanOrEqualTo: avatars.leadingAnchor, constant: -10),
            avatars.trailingAnchor.constraint(equalTo: sprinkleButton.trailingAnchor, constant: -15),
            avatars.centerYAnchor.constraint(equalTo: sprinkleButton.centerYAnchor)
        ])
        return sprinkleButton
    }

    private func makeGoldPill(_ text: String) -> UIView {
        let pill = UIView()
        pill.translatesAutoresizingMaskIntoConstraints = false
        pill.backgroundColor = .white
        pill.layer.cornerRadius = 17
        let gem = UIImageView(image: UIImage.init(named: "ervoldgem"))// makeGemView(size: 31)
        gem.translatesAutoresizingMaskIntoConstraints = false
        let crumbLabel = makeChallengeLabel(text, size: 15, weight: .heavy, color: UIColor(red: 0.35, green: 0.08, blue: 0.25, alpha: 1))
        pill.addSubview(gem)
        pill.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            gem.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 9),
            gem.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            gem.widthAnchor.constraint(equalToConstant: 31),
            gem.heightAnchor.constraint(equalToConstant: 31),
            crumbLabel.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 7),
            crumbLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            crumbLabel.trailingAnchor.constraint(lessThanOrEqualTo: pill.trailingAnchor, constant: -8)
        ])
        return pill
    }

    private func configureJoinButton() {
        almondBench.translatesAutoresizingMaskIntoConstraints = false
        almondBench.backgroundColor = UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
        almondBench.layer.cornerRadius = 17
        almondBench.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        almondBench.titleLabel?.adjustsFontSizeToFitWidth = true
        almondBench.titleLabel?.minimumScaleFactor = 0.72
        almondBench.setTitleColor(UIColor(red: 0.55, green: 0.42, blue: 0.93, alpha: 1), for: .normal)
        almondBench.setTitleColor(.white, for: .disabled)
    }

//    private func makeGemView(size: CGFloat) -> UIImageView {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size * 0.72))
//        let glazeImage = renderer.image { _ in
//            UIColor(red: 1, green: 0.78, blue: 0.05, alpha: 1).setFill()
//            UIBezierPath(roundedRect: CGRect(x: size * 0.18, y: 0, width: size * 0.64, height: size * 0.24), cornerRadius: 3).fill()
//            UIColor(red: 1, green: 0.5, blue: 0, alpha: 1).setFill()
//            let body = UIBezierPath()
//            body.move(to: CGPoint(x: 0, y: size * 0.2))
//            body.addLine(to: CGPoint(x: size, y: size * 0.2))
//            body.addLine(to: CGPoint(x: size * 0.5, y: size * 0.7))
//            body.close()
//            body.fill()
//        }
//        let glazeView = UIImageView(image: glazeImage)
//        glazeView.translatesAutoresizingMaskIntoConstraints = false
//        glazeView.contentMode = .scaleAspectFit
//        return glazeView
//    }

    private func makeAvatarView(index: Int, size: CGFloat) -> UIImageView {
        let profile = guestStore.profile(at: index)
        return makeAvatarView(tasterBadgeKey: profile.donutPinKey, size: size)
    }

    private func frostingParticipantCountText() -> String {
        let count = frostingGuestKeys.count
        return count == 1 ? "1 person" : "\(count) people"
    }

    private func makeAvatarView(tasterBadgeKey: String, size: CGFloat) -> UIImageView {
        let profile = guestStore.profile(for: tasterBadgeKey)
        if let glazeImage = UIImage(named: profile.donutFrameAsset) {
            let citrusCraft = UIImageView(image: glazeImage)
            citrusCraft.translatesAutoresizingMaskIntoConstraints = false
            citrusCraft.contentMode = .scaleAspectFill
            citrusCraft.layer.cornerRadius = size / 2
            citrusCraft.layer.borderWidth = 1
            citrusCraft.layer.borderColor = UIColor.white.cgColor
            citrusCraft.clipsToBounds = true
            NSLayoutConstraint.activate([
                citrusCraft.widthAnchor.constraint(equalToConstant: size),
                citrusCraft.heightAnchor.constraint(equalToConstant: size)
            ])
            return citrusCraft
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let glazeImage = renderer.image { _ in
            let colors = [
                UIColor(red: 0.25, green: 0.08, blue: 0.12, alpha: 1),
                UIColor(red: 0.95, green: 0.55, blue: 0.62, alpha: 1),
                UIColor(red: 0.76, green: 0.58, blue: 0.38, alpha: 1),
                UIColor(red: 0.5, green: 0.35, blue: 0.78, alpha: 1)
            ]
            colors[abs(tasterBadgeKey.hashValue) % colors.count].setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.32, y: size * 0.2, width: size * 0.36, height: size * 0.36)).fill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.22, y: size * 0.57, width: size * 0.56, height: size * 0.27)).fill()
        }
        let wevvlineBurst = UIImageView(image: glazeImage)
        wevvlineBurst.translatesAutoresizingMaskIntoConstraints = false
        wevvlineBurst.contentMode = .scaleAspectFill
        wevvlineBurst.layer.cornerRadius = size / 2
        wevvlineBurst.layer.borderWidth = 1
        wevvlineBurst.layer.borderColor = UIColor.white.cgColor
        wevvlineBurst.clipsToBounds = true
        NSLayoutConstraint.activate([
            wevvlineBurst.widthAnchor.constraint(equalToConstant: size),
            wevvlineBurst.heightAnchor.constraint(equalToConstant: size)
        ])
        return wevvlineBurst
    }

    private func makeChallengeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.76
        return crumbLabel
    }

    private func refreshJoinState() {
        let joined = glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleJarKey)
        almondBench.setTitle(joined ? "Joined" : "JIo.i^nY bCqhsaql,lCebnMgreE".wevVPastryCrumbBloomRestored, for: .normal)
        almondBench.isEnabled = !joined
        almondBench.backgroundColor = joined ? UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1) : UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
    }

    @objc private func joinChallenge() {
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        guard !glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleJarKey) else {
            refreshJoinState()
            return
        }
        guard glazeSession.spendGlazeGold(sprinkleChallenge.sprinkleDensityValue) else {
            showNotEnoughGold()
            return
        }
        almondBench.isEnabled = false
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "SZyMnxcCifnfgO HsEwZe;eUt= QdQahtuaO.@.&.x".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            self.glazeSession.placeJoinedGlazeQuest(self.sprinkleChallenge.sprinkleJarKey)
            self.refreshJoinState()
            self.cocoaDiarydonutChanged?()
        }
    }

    private func showGlazeGate() {
        let gate = WevVWevvBakeryGateController()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshJoinState()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func showNotEnoughGold() {
        let layer = makeChallengeDimLayer(alpha: 0.5)
        view.addSubview(layer)

        let pastryCard = makeGoldShortageCard()
        layer.addSubview(pastryCard)

        let wevvletterForm = UIImageView(image: UIImage.init(named: "ervoldgem"))
        wevvletterForm.translatesAutoresizingMaskIntoConstraints = false
        let glazeTitle = makeChallengeLabel("NSoCtz qeLnCosujgoh= sgloWlKdn".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: WevVGlazePromptStyler.inkTone)
        glazeTitle.textAlignment = .center
        let crumbNote = makeChallengeLabel("Sorry, your donut vault is short.\nRecharge to join this sweet challenge.", size: 12, weight: .semibold, color: WevVGlazePromptStyler.mutedTone)
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 2
        let wevv = WevVWevvMaplePillButton(title: "BGu;yq".wevVPastryCrumbBloomRestored)
        wevv.addTarget(self, action: #selector(openVaultFromPopup), for: .touchUpInside)
        pastryCard.addSubview(wevvletterForm)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(crumbNote)
        pastryCard.addSubview(wevv)

        pinGoldShortageLayer(layer: layer, pastryCard: pastryCard, gem: wevvletterForm, glazeTitle: glazeTitle, crumbNote: crumbNote, wevvfillPattern: wevv)
        dimLayer = layer
    }

    private func makeChallengeDimLayer(alpha: CGFloat) -> UIControl {
        let glazeLayer = UIControl()
        glazeLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeLayer.backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: alpha)
        glazeLayer.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        return glazeLayer
    }

    private func makeGoldShortageCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = WevVGlazePromptStyler.creamTone
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.22
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        return pastryCard
    }

    private func pinGoldShortageLayer(layer: UIView, pastryCard: UIView, gem: UIImageView, glazeTitle: UILabel, crumbNote: UILabel, wevvfillPattern: UIView) {
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            pastryCard.widthAnchor.constraint(equalTo: layer.widthAnchor, multiplier: 0.68),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 294),
            pastryCard.heightAnchor.constraint(equalToConstant: 176),
            gem.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            gem.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: -54),
            gem.widthAnchor.constraint(equalToConstant: 98),
            gem.heightAnchor.constraint(equalToConstant: 72),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 40),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            crumbNote.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 12),
            crumbNote.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            wevvfillPattern.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            wevvfillPattern.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            wevvfillPattern.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -14),
            wevvfillPattern.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func showPeopleSheet() {
        let wevvstrokeWeightlayer = makePeopleDimLayer()
        view.addSubview(wevvstrokeWeightlayer)

        let sheet = makePeopleSheetPanel()
        wevvstrokeWeightlayer.addSubview(sheet)

        let glazeTitle = makeChallengeLabel("PfaProtdiucniMpkaMnYtf GLsi?sTtz".wevVPastryCrumbBloomRestored, size: 13, weight: .heavy, color: .black)
        glazeTitle.textAlignment = .center
        let doughClose = makePeopleSheetCloseButton()
        let ringStack = makePeopleSheetStack()

        sheet.addSubview(glazeTitle)
        sheet.addSubview(doughClose)
        sheet.addSubview(ringStack)

        pinPeopleSheetLayer(            wevvsprayBloom: wevvstrokeWeightlayer, sheet: sheet, glazeTitle: glazeTitle, doughClose: doughClose, ringStack: ringStack)
        dimLayer = wevvstrokeWeightlayer
    }

    private func makePeopleDimLayer() -> UIControl {
        let glazeLayer = UIControl()
        glazeLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeLayer.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        glazeLayer.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        return glazeLayer
    }

    private func makePeopleSheetPanel() -> UIView {
        let sheet = UIView()
        sheet.translatesAutoresizingMaskIntoConstraints = false
        sheet.backgroundColor = .white
        sheet.layer.cornerRadius = 16
        sheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return sheet
    }

    private func makePeopleSheetCloseButton() -> UIButton {
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.tintColor = .black
        doughClose.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        return doughClose
    }

    private func makePeopleSheetStack() -> UIStackView {
        let ringStack = UIStackView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        ringStack.axis = .vertical
        ringStack.spacing = 18
        for tasterBadgeKey in frostingGuestKeys {
            ringStack.addArrangedSubview(makePersonRow(profile: guestStore.profile(for: tasterBadgeKey)))
        }
        return ringStack
    }

    private func pinPeopleSheetLayer(            wevvsprayBloom: UIView, sheet: UIView, glazeTitle: UILabel, doughClose: UIButton, ringStack: UIStackView) {
        NSLayoutConstraint.activate([
                        wevvsprayBloom.topAnchor.constraint(equalTo: view.topAnchor),
                        wevvsprayBloom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        wevvsprayBloom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        wevvsprayBloom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheet.leadingAnchor.constraint(equalTo:             wevvsprayBloom.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo:             wevvsprayBloom.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo:             wevvsprayBloom.bottomAnchor),
            sheet.heightAnchor.constraint(equalTo:             wevvsprayBloom.heightAnchor, multiplier: 0.45),
            glazeTitle.topAnchor.constraint(equalTo: sheet.topAnchor, constant: 16),
            glazeTitle.centerXAnchor.constraint(equalTo: sheet.centerXAnchor),
            doughClose.centerYAnchor.constraint(equalTo: glazeTitle.centerYAnchor),
            doughClose.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -14),
            doughClose.widthAnchor.constraint(equalToConstant: 32),
            doughClose.heightAnchor.constraint(equalToConstant: 32),
            ringStack.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 22),
            ringStack.leadingAnchor.constraint(equalTo: sheet.leadingAnchor, constant: 34),
            ringStack.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -34)
        ])
    }

    private func makePersonRow(profile: WevVGuestGlazeProfile) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(tasterBadgeKey: profile.donutPinKey)
        }, for: .touchUpInside)
        let avatar = makeAvatarView(tasterBadgeKey: profile.donutPinKey, size: 42)
        let crumbLabel = makeChallengeLabel(profile.cocoaCounter, size: 13, weight: .heavy, color: .black)
        donutRow.addSubview(avatar)
        donutRow.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 44),
            avatar.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 42),
            avatar.heightAnchor.constraint(equalToConstant: 42),
            crumbLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            crumbLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor)
        ])
        return donutRow
    }

    @objc private func openVaultFromPopup() {
        closeDimLayer()
        let controller = WevVDonutVaultController()
        controller.onVaultChanged = { [weak self] in
            self?.cocoaDiarydonutChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func openPersonProfile(tasterBadgeKey: String) {
        closeDimLayer()
        let controller = WevVWevvTasterCardController(tasterBadgeKey: tasterBadgeKey)
        present(controller, animated: true)
    }

    @objc private func closeDimLayer() {
        dimLayer?.removeFromSuperview()
        dimLayer = nil
    }

    @objc private func closeChallenge() {
        dismiss(animated: true)
    }
}
