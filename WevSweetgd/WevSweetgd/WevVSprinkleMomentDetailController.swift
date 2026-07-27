import UIKit

private struct WevVSugarReply {
    let sugarKey: String
    let guestKey: String
    let text: String
    let timeText: String
}

final class WevVSprinkleMomentDetailController: UIViewController, UITextFieldDelegate {
    var onSugarMomentShielded: (() -> Void)?

    private let sprinkleMoment: WevVSprinkleFeedItem
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let followButton = UIButton(type: .system)
    private let replyField = UITextField()
    private let bottomTray = UIView()
    private var trayBottomConstraint: NSLayoutConstraint?
    private var sugarReplies: [WevVSugarReply] = [
        WevVSugarReply(sugarKey: "brunoCreamOne", guestKey: "arloSkyGlaze", text: "Great shot! I love it", timeText: "2 mins ago"),
        WevVSugarReply(sugarKey: "brunoCreamTwo", guestKey: "blairBlueGlaze", text: "Great shot! I love it", timeText: "2 mins ago")
    ]

    init(sprinkleMoment: WevVSprinkleFeedItem) {
        self.sprinkleMoment = sprinkleMoment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.86, alpha: 1.0)
        buildGlazeCanvas()
        refreshFollowButton()
        NotificationCenter.default.addObserver(self, selector: #selector(liftSugarTray(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropSugarTray(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private var boundGuest: WevVGuestGlazeProfile? {
        guestStore.allProfiles.first { $0.glazeKey == sprinkleMoment.author.glazeKey }
    }

    private func buildGlazeCanvas() {
        let frostingGlow = UIView()
        frostingGlow.translatesAutoresizingMaskIntoConstraints = false
        frostingGlow.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.86, alpha: 1.0)
        view.addSubview(frostingGlow)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 132, right: 0)
        view.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        scrollView.addSubview(stackView)

        bottomTray.translatesAutoresizingMaskIntoConstraints = false
        bottomTray.backgroundColor = .white
        view.addSubview(bottomTray)
        trayBottomConstraint = bottomTray.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([
            frostingGlow.topAnchor.constraint(equalTo: view.topAnchor),
            frostingGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -150),
            bottomTray.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomTray.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomTray.heightAnchor.constraint(equalToConstant: 88),
            trayBottomConstraint!
        ])

        stackView.addArrangedSubview(makeSugarHeader())
        stackView.addArrangedSubview(makeHeroPanel())
        stackView.addArrangedSubview(makeMomentText())
        stackView.addArrangedSubview(makeReplyTitle())
        rebuildSugarReplies()
        buildBottomTray()
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endSugarEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeSugarHeader() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeSprinkleMoment), for: .touchUpInside)

        let avatarButton = UIButton(type: .custom)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 26
        avatarButton.setImage(makeAuthorAvatar(), for: .normal)
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.addTarget(self, action: #selector(openBoundGuestProfile), for: .touchUpInside)

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = boundGuest?.name ?? sprinkleMoment.author.name
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.12, green: 0.05, blue: 0.08, alpha: 1)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.72

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        followButton.layer.cornerRadius = 25
        followButton.clipsToBounds = true
        followButton.addTarget(self, action: #selector(toggleSugarFollow), for: .touchUpInside)

        let safetyButton = UIButton(type: .system)
        safetyButton.translatesAutoresizingMaskIntoConstraints = false
        safetyButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        safetyButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        safetyButton.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        safetyButton.layer.cornerRadius = 17
        safetyButton.addTarget(self, action: #selector(openSugarMomentSafety), for: .touchUpInside)

        header.addSubview(backButton)
        header.addSubview(avatarButton)
        header.addSubview(nameLabel)
        header.addSubview(followButton)
        header.addSubview(safetyButton)

        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 74),
            backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: -8),
            backButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            avatarButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            avatarButton.topAnchor.constraint(equalTo: header.topAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: 52),
            avatarButton.heightAnchor.constraint(equalToConstant: 52),
            nameLabel.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -14),
            followButton.trailingAnchor.constraint(equalTo: safetyButton.leadingAnchor, constant: -10),
            followButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            followButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 104),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            safetyButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            safetyButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        return header
    }

    private func makeHeroPanel() -> UIView {
        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.clipsToBounds = true
        panel.layer.cornerRadius = 18

        let hero = UIImageView(image: UIImage(named: sprinkleMoment.heroAsset) ?? makeFallbackSugarImage(seed: sprinkleMoment.heroAsset))
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.contentMode = .scaleAspectFill
        hero.clipsToBounds = true

        panel.addSubview(hero)
        NSLayoutConstraint.activate([
            panel.heightAnchor.constraint(equalTo: panel.widthAnchor, multiplier: 0.78),
            hero.topAnchor.constraint(equalTo: panel.topAnchor),
            hero.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
            hero.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
            hero.bottomAnchor.constraint(equalTo: panel.bottomAnchor)
        ])
        return panel
    }

    private func makeMomentText() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = sprinkleMoment.displayText
        label.font = .systemFont(ofSize: 21, weight: .regular)
        label.textColor = UIColor(red: 0.16, green: 0.12, blue: 0.13, alpha: 1)
        label.numberOfLines = 0
        return label
    }

    private func makeReplyTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Comments"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }

    private func rebuildSugarReplies() {
        stackView.arrangedSubviews
            .filter { $0.accessibilityIdentifier == "wevvSugarReplyCard" }
            .forEach { crumbCard in
                stackView.removeArrangedSubview(crumbCard)
                crumbCard.removeFromSuperview()
            }
        sugarReplies.forEach { stackView.addArrangedSubview(makeSugarReplyCard($0)) }
    }

    private func makeSugarReplyCard(_ reply: WevVSugarReply) -> UIView {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = "wevvSugarReplyCard"
        card.backgroundColor = .white
        card.layer.cornerRadius = 28
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(showReplyFlagHint), for: .touchUpInside)

        let profile = guestStore.profile(for: reply.guestKey)
        let avatar = UIImageView(image: UIImage(named: profile.avatarAsset) ?? makeFallbackSugarImage(seed: reply.guestKey))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 21

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = reply.guestKey == "arloSkyGlaze" ? "Bruno Pham" : profile.name
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .black

        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = reply.text
        textLabel.font = .systemFont(ofSize: 18, weight: .regular)
        textLabel.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.5, alpha: 1)
        textLabel.numberOfLines = 2

        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = reply.timeText
        timeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        timeLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 1)

        let flagButton = UIButton(type: .system)
        flagButton.translatesAutoresizingMaskIntoConstraints = false
        flagButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        flagButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        flagButton.addTarget(self, action: #selector(showReplyFlagHint), for: .touchUpInside)

        card.addSubview(avatar)
        card.addSubview(nameLabel)
        card.addSubview(textLabel)
        card.addSubview(timeLabel)
        card.addSubview(flagButton)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 92),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 26),
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            avatar.widthAnchor.constraint(equalToConstant: 42),
            avatar.heightAnchor.constraint(equalToConstant: 42),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 18),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            nameLabel.trailingAnchor.constraint(equalTo: flagButton.leadingAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            textLabel.trailingAnchor.constraint(equalTo: flagButton.leadingAnchor, constant: -12),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -14),
            flagButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            flagButton.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            flagButton.widthAnchor.constraint(equalToConstant: 34),
            flagButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        return card
    }

    private func buildBottomTray() {
        replyField.translatesAutoresizingMaskIntoConstraints = false
        replyField.delegate = self
        replyField.placeholder = "What do you do on weekends?"
        replyField.font = .systemFont(ofSize: 17, weight: .regular)
        replyField.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
        replyField.layer.cornerRadius = 24
        replyField.clipsToBounds = true
        replyField.returnKeyType = .send
        replyField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 1))
        replyField.leftViewMode = .always

        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        if let sendImage = UIImage(named: "wevv_room_send_glaze") {
            sendButton.setImage(sendImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            sendButton.tintColor = .white
            sendButton.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.58, alpha: 1)
            sendButton.layer.cornerRadius = 33
        }
        sendButton.addTarget(self, action: #selector(addSugarReply), for: .touchUpInside)

        bottomTray.addSubview(replyField)
        bottomTray.addSubview(sendButton)

        NSLayoutConstraint.activate([
            replyField.leadingAnchor.constraint(equalTo: bottomTray.leadingAnchor, constant: 30),
            replyField.topAnchor.constraint(equalTo: bottomTray.topAnchor, constant: 12),
            replyField.heightAnchor.constraint(equalToConstant: 48),
            sendButton.leadingAnchor.constraint(equalTo: replyField.trailingAnchor, constant: 24),
            sendButton.trailingAnchor.constraint(equalTo: bottomTray.trailingAnchor, constant: -30),
            sendButton.centerYAnchor.constraint(equalTo: replyField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 56),
            sendButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func refreshFollowButton() {
        guard boundGuest != nil else {
            followButton.setTitle("Following", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1)
            followButton.isEnabled = false
            return
        }
        let isFollowed = guestStore.profile(for: sprinkleMoment.author.glazeKey).sugarTie.isGlazeFollowed
        followButton.setTitle(isFollowed ? "Following" : "Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = isFollowed ? UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1) : UIColor(red: 1, green: 0.12, blue: 0.58, alpha: 1)
        followButton.isEnabled = true
    }

    private func makeAuthorAvatar() -> UIImage? {
        if let profile = boundGuest, let image = UIImage(named: profile.avatarAsset) {
            return image
        }
        if let image = UIImage(named: sprinkleMoment.author.avatarAsset) {
            return image
        }
        return makeFallbackSugarImage(seed: sprinkleMoment.author.name)
    }

    private func makeFallbackSugarImage(seed: String) -> UIImage {
        let colors: [UIColor] = [
            UIColor(red: 1.0, green: 0.42, blue: 0.67, alpha: 1),
            UIColor(red: 0.58, green: 0.42, blue: 1.0, alpha: 1),
            UIColor(red: 1.0, green: 0.72, blue: 0.28, alpha: 1),
            UIColor(red: 0.24, green: 0.74, blue: 0.84, alpha: 1)
        ]
        let size = CGSize(width: 160, height: 160)
        return UIGraphicsImageRenderer(size: size).image { context in
            let color = colors[abs(seed.hashValue) % colors.count]
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let letter = String(seed.prefix(1)).uppercased()
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 72, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = letter.size(withAttributes: attrs)
            letter.draw(at: CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2), withAttributes: attrs)
        }
    }

    @objc private func toggleSugarFollow() {
        guard boundGuest != nil else { return }
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        _ = guestStore.toggleGlazeFollow(for: sprinkleMoment.author.glazeKey)
        refreshFollowButton()
    }

    @objc private func addSugarReply() {
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        let text = replyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else {
            showSugarToast("Say something sweet first")
            return
        }
        sugarReplies.append(WevVSugarReply(sugarKey: "freshSugar\(sugarReplies.count)", guestKey: "jamieCole", text: text, timeText: "Just now"))
        replyField.text = nil
        replyField.resignFirstResponder()
        rebuildSugarReplies()
        showSugarToast("Posted")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addSugarReply()
        return true
    }

    @objc private func openBoundGuestProfile() {
        guard let profile = boundGuest else { return }
        let controller = WevVGuestGlazeProfileController(guestKey: profile.glazeKey)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func showReplyFlagHint() {
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        showSugarToast("Reason panel ready")
    }

    @objc private func openSugarMomentSafety() {
        guard glazeSession.isTasterReady else {
            showGlazeGate()
            return
        }
        presentSugarSafetySheet()
    }

    private func presentSugarSafetySheet() {
        let sheet = WevVGlazeSafetySheet(shopKey: sprinkleMoment.author.glazeKey, choices: sugarSafetyChoices())
        sheet.onClose = { [weak self, weak sheet] in
            self?.hideSugarSafetySheet(sheet)
        }
        sheet.onConfirm = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.glazeSession.placeGlazeSafetyCrumb(packet)
            self.placeSugarShield()
            self.hideSugarSafetySheet(sheet)
            self.showSugarToast("Hidden from your feed")
            self.onSugarMomentShielded?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.dismiss(animated: true)
            }
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }

    private func hideSugarSafetySheet(_ sheet: WevVGlazeSafetySheet?) {
        sheet?.endEditing(true)
        sheet?.removeFromSuperview()
    }

    private func sugarSafetyChoices() -> [WevVGlazeSafetyChoice] {
        [
            WevVGlazeSafetyChoice(sugarKey: "fakeSugarPhoto", title: "Fake photo", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "promoSprinkle", title: "Scam or commercial", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "plainCrumb", title: "Not interested", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "customGlaze", title: "Other", needsCreamText: true)
        ]
    }

    private func placeSugarShield() {
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == sprinkleMoment.author.glazeKey }) else { return }
        if !guestStore.profile(for: sprinkleMoment.author.glazeKey).sugarTie.isSugarShielded {
            _ = guestStore.toggleSugarShield(for: sprinkleMoment.author.glazeKey)
        }
    }

    @objc private func closeSprinkleMoment() {
        dismiss(animated: true)
    }

    @objc private func endSugarEditing() {
        view.endEditing(true)
    }

    @objc private func liftSugarTray(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        trayBottomConstraint?.constant = -overlap
        scrollView.contentInset.bottom = overlap + 132
        scrollView.verticalScrollIndicatorInsets.bottom = overlap + 132
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSugarTray(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        trayBottomConstraint?.constant = 0
        scrollView.contentInset.bottom = 132
        scrollView.verticalScrollIndicatorInsets.bottom = 132
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showGlazeGate() {
        let gate = WevVFrostingGateController()
        gate.modalPresentationStyle = .fullScreen
        gate.onGlazeReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshFollowButton()
            }
        }
        present(gate, animated: true)
    }

    private func showSugarToast(_ text: String) {
        let toast = UILabel()
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.text = text
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .semibold)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        toast.layer.cornerRadius = 18
        toast.clipsToBounds = true
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: bottomTray.topAnchor, constant: -16),
            toast.heightAnchor.constraint(equalToConstant: 36),
            toast.widthAnchor.constraint(greaterThanOrEqualToConstant: 170)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.2, options: []) {
            toast.alpha = 0
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }
}
