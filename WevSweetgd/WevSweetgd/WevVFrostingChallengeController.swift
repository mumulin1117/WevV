import UIKit

final class WevVFrostingChallengeController: UIViewController {
    private let sprinkleChallenge: WevVSprinkleChallenge
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let joinButton = UIButton(type: .system)
    private var dimLayer: UIControl?

    private var frostingGuestKeys: [String] {
        let keys = [
            sprinkleChallenge.hostGuestKey,
            "lunaLaughGlaze",
            "novaBubbleGlaze",
            "arloSkyGlaze",
            "rheaHoneyGlaze"
        ]
        var seenKeys = Set<String>()
        return keys.filter { glazeKey in
            if seenKeys.contains(glazeKey) {
                return false
            }
            seenKeys.insert(glazeKey)
            return true
        }
    }

    var onChallengeChanged: (() -> Void)?

    init(challenge: WevVSprinkleChallenge) {
        self.sprinkleChallenge = challenge
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

    private func buildChallengeContent() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        backButton.addTarget(self, action: #selector(closeChallenge), for: .touchUpInside)

        let title = makeChallengeLabel("Challenge", size: 18, weight: .heavy, color: UIColor(red: 0.1, green: 0.07, blue: 0.14, alpha: 1))
        title.textAlignment = .center

        let hero = makeChallengeHero()
        let progressTitle = makeChallengeLabel("Progress", size: 17, weight: .heavy, color: UIColor(red: 0.13, green: 0.08, blue: 0.16, alpha: 1))
        let progressCard = makeProgressCard()
        let hostLabel = makeChallengeLabel("Hosted by", size: 13, weight: .heavy, color: UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1))
        let hostRow = makeHostRow()
        let notes = makeChallengeLabel(sprinkleChallenge.missionText, size: 14, weight: .heavy, color: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        notes.numberOfLines = 2
        notes.minimumScaleFactor = 0.68
        let peopleButton = makePeopleButton()

        view.addSubview(backButton)
        view.addSubview(title)
        view.addSubview(hero)
        view.addSubview(progressTitle)
        view.addSubview(progressCard)
        view.addSubview(hostLabel)
        view.addSubview(hostRow)
        view.addSubview(notes)
        view.addSubview(peopleButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hero.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 19),
            hero.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            hero.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            hero.heightAnchor.constraint(equalToConstant: 173),
            progressTitle.topAnchor.constraint(equalTo: hero.bottomAnchor, constant: 17),
            progressTitle.leadingAnchor.constraint(equalTo: hero.leadingAnchor),
            progressCard.topAnchor.constraint(equalTo: progressTitle.bottomAnchor, constant: 12),
            progressCard.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 4),
            progressCard.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -4),
            progressCard.heightAnchor.constraint(equalToConstant: 61),
            hostLabel.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 16),
            hostLabel.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 5),
            hostRow.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 10),
            hostRow.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 8),
            hostRow.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -5),
            hostRow.heightAnchor.constraint(equalToConstant: 48),
            notes.topAnchor.constraint(equalTo: hostRow.bottomAnchor, constant: 22),
            notes.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 5),
            notes.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -5),
            peopleButton.topAnchor.constraint(equalTo: notes.bottomAnchor, constant: 22),
            peopleButton.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 5),
            peopleButton.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -5),
            peopleButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func makeChallengeHero() -> UIView {
        let hero = UIView()
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.layer.cornerRadius = 18
        hero.clipsToBounds = true
        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.74, green: 0.65, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.58, green: 0.48, blue: 0.93, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.2)
        glaze.endPoint = CGPoint(x: 1, y: 0.9)
        hero.layer.insertSublayer(glaze, at: 0)

        let title = makeChallengeLabel(sprinkleChallenge.title, size: 24, weight: .heavy, color: .white)
        let note = makeChallengeLabel(sprinkleChallenge.glazeLine, size: 15, weight: .regular, color: UIColor.white.withAlphaComponent(0.9))
        note.numberOfLines = 2
        let cost = makeGoldPill("\(sprinkleChallenge.sugarCost)")
        configureJoinButton()
        joinButton.addTarget(self, action: #selector(joinChallenge), for: .touchUpInside)

        hero.addSubview(title)
        hero.addSubview(note)
        hero.addSubview(cost)
        hero.addSubview(joinButton)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: hero.topAnchor, constant: 25),
            title.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 30),
            title.trailingAnchor.constraint(lessThanOrEqualTo: hero.trailingAnchor, constant: -24),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -30),
            cost.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 22),
            cost.bottomAnchor.constraint(equalTo: hero.bottomAnchor, constant: -22),
            cost.widthAnchor.constraint(equalToConstant: 81),
            cost.heightAnchor.constraint(equalToConstant: 34),
            joinButton.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -17),
            joinButton.centerYAnchor.constraint(equalTo: cost.centerYAnchor),
            joinButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 126),
            joinButton.heightAnchor.constraint(equalToConstant: 34)
        ])

        DispatchQueue.main.async {
            glaze.frame = hero.bounds
        }
        return hero
    }

    private func makeProgressCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 1, green: 0.89, blue: 0.97, alpha: 1)
        card.layer.cornerRadius = 18
        let first = makeProgressLine(symbolName: "clock.fill", text: sprinkleChallenge.sprinkleTimeText)
        let second = makeProgressLine(symbolName: "mappin.circle.fill", text: sprinkleChallenge.crumbPlaceText)
        card.addSubview(first)
        card.addSubview(second)
        NSLayoutConstraint.activate([
            first.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            first.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 26),
            first.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            second.topAnchor.constraint(equalTo: first.bottomAnchor, constant: 9),
            second.leadingAnchor.constraint(equalTo: first.leadingAnchor),
            second.trailingAnchor.constraint(equalTo: first.trailingAnchor)
        ])
        return card
    }

    private func makeProgressLine(symbolName: String, text: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        let symbol = UIImageView(image: UIImage(systemName: symbolName))
        symbol.translatesAutoresizingMaskIntoConstraints = false
        symbol.tintColor = UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1)
        symbol.contentMode = .scaleAspectFit
        let label = makeChallengeLabel(text, size: 14, weight: .regular, color: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        row.addSubview(symbol)
        row.addSubview(label)
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 16),
            symbol.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            symbol.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 16),
            symbol.heightAnchor.constraint(equalToConstant: 16),
            label.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: row.trailingAnchor)
        ])
        return row
    }

    private func makeHostRow() -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        let hostProfile = guestStore.profile(for: sprinkleChallenge.hostGuestKey)
        let avatar = makeAvatarView(guestKey: hostProfile.glazeKey, size: 48)
        let name = makeChallengeLabel(hostProfile.name, size: 16, weight: .heavy, color: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        let sub = makeChallengeLabel(sprinkleChallenge.hostLine, size: 13, weight: .heavy, color: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        let follow = WevVGlazePillButton(title: "Follow")
        follow.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(guestKey: hostProfile.glazeKey)
        }, for: .touchUpInside)
        row.addSubview(avatar)
        row.addSubview(name)
        row.addSubview(sub)
        row.addSubview(follow)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            name.topAnchor.constraint(equalTo: row.topAnchor, constant: 3),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            sub.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 7),
            sub.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            follow.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            follow.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            follow.widthAnchor.constraint(equalToConstant: 59),
            follow.heightAnchor.constraint(equalToConstant: 32)
        ])
        return row
    }

    private func makePeopleButton() -> UIControl {
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(showPeopleSheet), for: .touchUpInside)
        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.48, green: 0.14, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0.07, green: 0.0, blue: 0.6, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.5)
        glaze.endPoint = CGPoint(x: 1, y: 0.5)
        button.layer.insertSublayer(glaze, at: 0)
        let icon = UIImageView(image: UIImage(systemName: "person.3.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor(red: 1, green: 0.56, blue: 0.1, alpha: 1)
        icon.contentMode = .scaleAspectFit
        let title = makeChallengeLabel("Participant List", size: 15, weight: .heavy, color: .white)
        let count = makeChallengeLabel(sprinkleChallenge.crowdText, size: 13, weight: .regular, color: UIColor.white.withAlphaComponent(0.66))
        let avatars = UIStackView()
        avatars.translatesAutoresizingMaskIntoConstraints = false
        avatars.axis = .horizontal
        avatars.spacing = -8
        for index in 0..<3 {
            avatars.addArrangedSubview(makeAvatarView(index: index + 1, size: 24))
        }
        button.addSubview(icon)
        button.addSubview(title)
        button.addSubview(count)
        button.addSubview(avatars)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 18),
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 45),
            icon.heightAnchor.constraint(equalToConstant: 34),
            title.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 22),
            title.trailingAnchor.constraint(lessThanOrEqualTo: avatars.leadingAnchor, constant: -10),
            count.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            count.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            count.trailingAnchor.constraint(lessThanOrEqualTo: avatars.leadingAnchor, constant: -10),
            avatars.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -15),
            avatars.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        DispatchQueue.main.async {
            glaze.frame = button.bounds
        }
        return button
    }

    private func makeGoldPill(_ text: String) -> UIView {
        let pill = UIView()
        pill.translatesAutoresizingMaskIntoConstraints = false
        pill.backgroundColor = .white
        pill.layer.cornerRadius = 17
        let gem = makeGemView(size: 31)
        let label = makeChallengeLabel(text, size: 15, weight: .heavy, color: UIColor(red: 0.35, green: 0.08, blue: 0.25, alpha: 1))
        pill.addSubview(gem)
        pill.addSubview(label)
        NSLayoutConstraint.activate([
            gem.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 9),
            gem.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            gem.widthAnchor.constraint(equalToConstant: 31),
            gem.heightAnchor.constraint(equalToConstant: 22),
            label.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 7),
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: pill.trailingAnchor, constant: -8)
        ])
        return pill
    }

    private func configureJoinButton() {
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.backgroundColor = UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
        joinButton.layer.cornerRadius = 17
        joinButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        joinButton.titleLabel?.adjustsFontSizeToFitWidth = true
        joinButton.titleLabel?.minimumScaleFactor = 0.72
        joinButton.setTitleColor(UIColor(red: 0.55, green: 0.42, blue: 0.93, alpha: 1), for: .normal)
        joinButton.setTitleColor(.white, for: .disabled)
    }

    private func makeGemView(size: CGFloat) -> UIImageView {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size * 0.72))
        let image = renderer.image { _ in
            UIColor(red: 1, green: 0.78, blue: 0.05, alpha: 1).setFill()
            UIBezierPath(roundedRect: CGRect(x: size * 0.18, y: 0, width: size * 0.64, height: size * 0.24), cornerRadius: 3).fill()
            UIColor(red: 1, green: 0.5, blue: 0, alpha: 1).setFill()
            let body = UIBezierPath()
            body.move(to: CGPoint(x: 0, y: size * 0.2))
            body.addLine(to: CGPoint(x: size, y: size * 0.2))
            body.addLine(to: CGPoint(x: size * 0.5, y: size * 0.7))
            body.close()
            body.fill()
        }
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }

    private func makeAvatarView(index: Int, size: CGFloat) -> UIImageView {
        let profile = guestStore.profile(at: index)
        return makeAvatarView(guestKey: profile.glazeKey, size: size)
    }

    private func makeAvatarView(guestKey: String, size: CGFloat) -> UIImageView {
        let profile = guestStore.profile(for: guestKey)
        if let image = UIImage(named: profile.avatarAsset) {
            let avatar = UIImageView(image: image)
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.contentMode = .scaleAspectFill
            avatar.layer.cornerRadius = size / 2
            avatar.layer.borderWidth = 1
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.clipsToBounds = true
            return avatar
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = renderer.image { _ in
            let colors = [
                UIColor(red: 0.25, green: 0.08, blue: 0.12, alpha: 1),
                UIColor(red: 0.95, green: 0.55, blue: 0.62, alpha: 1),
                UIColor(red: 0.76, green: 0.58, blue: 0.38, alpha: 1),
                UIColor(red: 0.5, green: 0.35, blue: 0.78, alpha: 1)
            ]
            colors[abs(guestKey.hashValue) % colors.count].setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.32, y: size * 0.2, width: size * 0.36, height: size * 0.36)).fill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.22, y: size * 0.57, width: size * 0.56, height: size * 0.27)).fill()
        }
        let avatar = UIImageView(image: image)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = size / 2
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        return avatar
    }

    private func makeChallengeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.76
        return label
    }

    private func refreshJoinState() {
        let joined = glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleKey)
        joinButton.setTitle(joined ? "Joined" : "Join Challenge", for: .normal)
        joinButton.isEnabled = !joined
        joinButton.backgroundColor = joined ? UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1) : UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
    }

    @objc private func joinChallenge() {
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        guard !glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleKey) else {
            refreshJoinState()
            return
        }
        guard glazeSession.spendGlazeGold(sprinkleChallenge.sugarCost) else {
            showNotEnoughGold()
            return
        }
        glazeSession.placeJoinedGlazeQuest(sprinkleChallenge.sprinkleKey)
        refreshJoinState()
        onChallengeChanged?()
    }

    private func showGlazeGate() {
        let gate = WevVFrostingGateController()
        gate.onGlazeReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshJoinState()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func showNotEnoughGold() {
        let layer = UIControl()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        layer.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        view.addSubview(layer)

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 15
        layer.addSubview(card)

        let gem = makeGemView(size: 98)
        let title = makeChallengeLabel("Not enough gold", size: 16, weight: .heavy, color: .black)
        title.textAlignment = .center
        let note = makeChallengeLabel("Sorry, your vault is short.\nPlease recharge to continue.", size: 10, weight: .medium, color: UIColor(red: 0.46, green: 0.4, blue: 0.46, alpha: 1))
        note.textAlignment = .center
        note.numberOfLines = 2
        let buy = WevVGlazePillButton(title: "Buy")
        buy.addTarget(self, action: #selector(openVaultFromPopup), for: .touchUpInside)
        card.addSubview(gem)
        card.addSubview(title)
        card.addSubview(note)
        card.addSubview(buy)

        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            card.widthAnchor.constraint(equalTo: layer.widthAnchor, multiplier: 0.62),
            card.heightAnchor.constraint(equalToConstant: 156),
            gem.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            gem.topAnchor.constraint(equalTo: card.topAnchor, constant: -54),
            gem.widthAnchor.constraint(equalToConstant: 98),
            gem.heightAnchor.constraint(equalToConstant: 72),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 36),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            buy.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            buy.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            buy.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14),
            buy.heightAnchor.constraint(equalToConstant: 40)
        ])
        dimLayer = layer
    }

    @objc private func showPeopleSheet() {
        let layer = UIControl()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        layer.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        view.addSubview(layer)

        let sheet = UIView()
        sheet.translatesAutoresizingMaskIntoConstraints = false
        sheet.backgroundColor = .white
        sheet.layer.cornerRadius = 16
        sheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.addSubview(sheet)

        let title = makeChallengeLabel("Participant List", size: 13, weight: .heavy, color: .black)
        title.textAlignment = .center
        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.tintColor = .black
        close.addTarget(self, action: #selector(closeDimLayer), for: .touchUpInside)
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 18
        for guestKey in frostingGuestKeys {
            stack.addArrangedSubview(makePersonRow(profile: guestStore.profile(for: guestKey)))
        }

        sheet.addSubview(title)
        sheet.addSubview(close)
        sheet.addSubview(stack)

        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheet.leadingAnchor.constraint(equalTo: layer.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: layer.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: layer.bottomAnchor),
            sheet.heightAnchor.constraint(equalTo: layer.heightAnchor, multiplier: 0.45),
            title.topAnchor.constraint(equalTo: sheet.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: sheet.centerXAnchor),
            close.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            close.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -14),
            close.widthAnchor.constraint(equalToConstant: 32),
            close.heightAnchor.constraint(equalToConstant: 32),
            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 22),
            stack.leadingAnchor.constraint(equalTo: sheet.leadingAnchor, constant: 34),
            stack.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -34)
        ])
        dimLayer = layer
    }

    private func makePersonRow(profile: WevVGuestGlazeProfile) -> UIControl {
        let row = UIControl()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(guestKey: profile.glazeKey)
        }, for: .touchUpInside)
        let avatar = makeAvatarView(guestKey: profile.glazeKey, size: 42)
        let label = makeChallengeLabel(profile.name, size: 13, weight: .heavy, color: .black)
        row.addSubview(avatar)
        row.addSubview(label)
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 44),
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 42),
            avatar.heightAnchor.constraint(equalToConstant: 42),
            label.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        return row
    }

    @objc private func openVaultFromPopup() {
        closeDimLayer()
        let controller = WevVDonutVaultController()
        controller.onVaultChanged = { [weak self] in
            self?.onChallengeChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func openPersonProfile(guestKey: String) {
        closeDimLayer()
        let controller = WevVGuestGlazeProfileController(guestKey: guestKey)
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
