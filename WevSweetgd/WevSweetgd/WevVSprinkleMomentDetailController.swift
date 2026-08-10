import UIKit

private struct WevVSugarReply {
    let sugarKey: String
    let guestKey: String
    let sugarText: String
    let timeText: String
    let tasterName: String?
    let donutAvatarAsset: String?

    init(sugarKey: String, guestKey: String, text: String, timeText: String, tasterName: String? = nil, donutAvatarAsset: String? = nil) {
        self.sugarKey = sugarKey
        self.guestKey = guestKey
        self.sugarText = text
        self.timeText = timeText
        self.tasterName = tasterName
        self.donutAvatarAsset = donutAvatarAsset
    }
}

final class WevVSprinkleMomentDetailController: UIViewController, UITextFieldDelegate {
    var onSugarMomentShielded: (() -> Void)?

    private let sprinkleMoment: WevVSprinkleFeedItem
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared

    private let sugarScrollView = UIScrollView()
    private let sugarStackView = UIStackView()
    private let followButton = UIButton(type: .system)
    private let replyField = UITextField()
    private let bottomTray = UIView()
    private var trayBottomConstraint: NSLayoutConstraint?
    private var sugarReplies: [WevVSugarReply] = [
        WevVSugarReply(sugarKey: "b?rNulnOoBCHr/eDaHmRO#nweZ".wevVPastryCrumbBloomRestored, guestKey: "aRrVlpotS+k?yMG&l=aHz;ee".wevVPastryCrumbBloomRestored, text: "G;rIebagtR hs/hJomt/!g VIL @lMoivteo Xietk".wevVPastryCrumbBloomRestored, timeText: "2l /mAinnpsZ raZguoi".wevVPastryCrumbBloomRestored),
        WevVSugarReply(sugarKey: "b@rguKnyojCcr!erahmiTXwno+".wevVPastryCrumbBloomRestored, guestKey: "b~lna:iZrsBYlVu;esG:lkauzzee".wevVPastryCrumbBloomRestored, text: "Ghr&e^awta msUhJo,tk!m dIW xleo@vReH ~iBtX".wevVPastryCrumbBloomRestored, timeText: "2Y /mUiKnysL oaYgXo&".wevVPastryCrumbBloomRestored)
    ]

    init(sprinkleMoment: WevVSprinkleFeedItem) {
        self.sprinkleMoment = sprinkleMoment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("iDntiQte(&cVondzedr;:~)+ VhsaZs/ #n#octz abFeBeAnJ iiDmbpnlhe%mbe,n%tNe/dq".wevVPastryCrumbBloomRestored)
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

        sugarScrollView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.alwaysBounceVertical = true
        sugarScrollView.keyboardDismissMode = .interactive
        sugarScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 132, right: 0)
        view.addSubview(sugarScrollView)

        sugarStackView.translatesAutoresizingMaskIntoConstraints = false
        sugarStackView.axis = .vertical
        sugarStackView.spacing = 18
        sugarScrollView.addSubview(sugarStackView)

        bottomTray.translatesAutoresizingMaskIntoConstraints = false
        bottomTray.backgroundColor = .white
        view.addSubview(bottomTray)
        trayBottomConstraint = bottomTray.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([
            frostingGlow.topAnchor.constraint(equalTo: view.topAnchor),
            frostingGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sugarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sugarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sugarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sugarScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sugarStackView.topAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.topAnchor, constant: 28),
            sugarStackView.leadingAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.leadingAnchor, constant: 30),
            sugarStackView.trailingAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.trailingAnchor, constant: -30),
            sugarStackView.bottomAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.bottomAnchor, constant: -150),
            bottomTray.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomTray.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomTray.heightAnchor.constraint(equalToConstant: 88),
            trayBottomConstraint!
        ])

        sugarStackView.addArrangedSubview(makeSugarHeader())
        sugarStackView.addArrangedSubview(makeHeroPanel())
        sugarStackView.addArrangedSubview(makeMomentText())
        sugarStackView.addArrangedSubview(makeReplyTitle())
        rebuildSugarReplies()
        buildBottomTray()
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endSugarEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeSugarHeader() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeSprinkleMoment), for: .touchUpInside)

        let avatarButton = UIButton(type: .custom)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 26
        avatarButton.setImage(makeAuthorAvatar(), for: .normal)
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.addTarget(self, action: #selector(openBoundGuestProfile), for: .touchUpInside)

        let creamNameLabel = UILabel()
        creamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creamNameLabel.text = boundGuest?.name ?? sprinkleMoment.author.name
        creamNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        creamNameLabel.textColor = UIColor(red: 0.12, green: 0.05, blue: 0.08, alpha: 1)
        creamNameLabel.adjustsFontSizeToFitWidth = true
        creamNameLabel.minimumScaleFactor = 0.72

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        followButton.layer.cornerRadius = 17.5
        followButton.clipsToBounds = true
        followButton.addTarget(self, action: #selector(toggleSugarFollow), for: .touchUpInside)

        let safetyButton = UIButton(type: .system)
        safetyButton.translatesAutoresizingMaskIntoConstraints = false
        safetyButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        safetyButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        safetyButton.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        safetyButton.layer.cornerRadius = 17
        safetyButton.addTarget(self, action: #selector(openSugarMomentSafety), for: .touchUpInside)

        placeSugarHeaderViews(header: header, doughBackButton: doughBackButton, avatarButton: avatarButton, creamNameLabel: creamNameLabel, safetyButton: safetyButton)
        pinSugarHeaderLayout(header: header, doughBackButton: doughBackButton, avatarButton: avatarButton, creamNameLabel: creamNameLabel, safetyButton: safetyButton)
        return header
    }

    private func placeSugarHeaderViews(header: UIView, doughBackButton: UIButton, avatarButton: UIButton, creamNameLabel: UILabel, safetyButton: UIButton) {
        [doughBackButton, avatarButton, creamNameLabel, followButton, safetyButton].forEach {
            header.addSubview($0)
        }
    }

    private func pinSugarHeaderLayout(header: UIView, doughBackButton: UIButton, avatarButton: UIButton, creamNameLabel: UILabel, safetyButton: UIButton) {
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 74),
            doughBackButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: -8),
            doughBackButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            doughBackButton.widthAnchor.constraint(equalToConstant: 38),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            avatarButton.leadingAnchor.constraint(equalTo: doughBackButton.trailingAnchor, constant: 20),
            avatarButton.topAnchor.constraint(equalTo: header.topAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: 52),
            avatarButton.heightAnchor.constraint(equalToConstant: 52),
            creamNameLabel.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 16),
            creamNameLabel.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            creamNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -14),
            followButton.trailingAnchor.constraint(equalTo: safetyButton.leadingAnchor, constant: -10),
            followButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            followButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 84),
            followButton.heightAnchor.constraint(equalToConstant: 35),
            safetyButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            safetyButton.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeHeroPanel() -> UIView {
        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.clipsToBounds = true
        glazePanel.layer.cornerRadius = 18

        let hero = UIImageView(image: WevVPastryImageVault.glazeImage(for: sprinkleMoment.heroAsset) ?? makeFallbackSugarImage(seed: sprinkleMoment.heroAsset))
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.contentMode = .scaleAspectFill
        hero.clipsToBounds = true

        glazePanel.addSubview(hero)
        NSLayoutConstraint.activate([
            glazePanel.heightAnchor.constraint(equalTo: glazePanel.widthAnchor, multiplier: 0.78),
            hero.topAnchor.constraint(equalTo: glazePanel.topAnchor),
            hero.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor),
            hero.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor),
            hero.bottomAnchor.constraint(equalTo: glazePanel.bottomAnchor)
        ])
        return glazePanel
    }

    private func makeMomentText() -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sprinkleMoment.displayText
        crumbLabel.font = .systemFont(ofSize: 21, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.16, green: 0.12, blue: 0.13, alpha: 1)
        crumbLabel.numberOfLines = 0
        return crumbLabel
    }

    private func makeReplyTitle() -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = "CkocmpmYe#nwt;s,".wevVPastryCrumbBloomRestored
        crumbLabel.font = .systemFont(ofSize: 24, weight: .bold)
        crumbLabel.textColor = .black
        return crumbLabel
    }

    private func rebuildSugarReplies() {
        sugarStackView.arrangedSubviews
            .filter { $0.accessibilityIdentifier == "w@eDvJvgS&ukgPa;rURkeRp^lmyUC~aSr!d?".wevVPastryCrumbBloomRestored }
            .forEach { crumbCard in
                sugarStackView.removeArrangedSubview(crumbCard)
                crumbCard.removeFromSuperview()
            }
        sugarReplies.forEach { sugarStackView.addArrangedSubview(makeSugarReplyCard($0)) }
    }

    private func makeSugarReplyCard(_ reply: WevVSugarReply) -> UIView {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = "wlewvYvKSyu.gPaormRFeQp=loyYCVa+rTdc".wevVPastryCrumbBloomRestored
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 28
        pastryCard.clipsToBounds = true
        pastryCard.addTarget(self, action: #selector(showReplyFlagHint), for: .touchUpInside)

        let profile = guestStore.profile(for: reply.guestKey)
        let avatar = makeSugarReplyAvatar(reply, profile: profile)
        let creamNameLabel = makeSugarReplyName(reply, profile: profile)
        let textLabel = makeSugarReplyText(reply.sugarText)
        let timeLabel = makeSugarReplyTime(reply.timeText)
        let flagButton = makeSugarReplyFlagButton()

        placeSugarReplyViews(pastryCard: pastryCard, avatar: avatar, creamNameLabel: creamNameLabel, textLabel: textLabel, timeLabel: timeLabel, flagButton: flagButton)
        pinSugarReplyLayout(pastryCard: pastryCard, avatar: avatar, creamNameLabel: creamNameLabel, textLabel: textLabel, timeLabel: timeLabel, flagButton: flagButton)
        return pastryCard
    }

    private func makeSugarReplyAvatar(_ reply: WevVSugarReply, profile: WevVGuestGlazeProfile) -> UIImageView {
        let replyAvatarAsset = reply.donutAvatarAsset ?? profile.donutAvatarAsset
        let glazeAvatar = UIImageView(image: UIImage(named: replyAvatarAsset) ?? makeFallbackSugarImage(seed: reply.tasterName ?? reply.guestKey))
        glazeAvatar.translatesAutoresizingMaskIntoConstraints = false
        glazeAvatar.contentMode = .scaleAspectFill
        glazeAvatar.clipsToBounds = true
        glazeAvatar.layer.cornerRadius = 21
        return glazeAvatar
    }

    private func makeSugarReplyName(_ reply: WevVSugarReply, profile: WevVGuestGlazeProfile) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = reply.tasterName ?? (reply.guestKey == "a.rWlVo?SQkWyaGxlRaRzveh".wevVPastryCrumbBloomRestored ? "Bruno Pham" : profile.name)
        crumbLabel.font = .systemFont(ofSize: 18, weight: .bold)
        crumbLabel.textColor = .black
        return crumbLabel
    }

    private func makeSugarReplyText(_ sugarText: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarText
        crumbLabel.font = .systemFont(ofSize: 18, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.5, alpha: 1)
        crumbLabel.numberOfLines = 2
        return crumbLabel
    }

    private func makeSugarReplyTime(_ sugarTime: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarTime
        crumbLabel.font = .systemFont(ofSize: 16, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 1)
        return crumbLabel
    }

    private func makeSugarReplyFlagButton() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.addTarget(self, action: #selector(showReplyFlagHint), for: .touchUpInside)
        return sprinkleButton
    }

    private func placeSugarReplyViews(pastryCard: UIView, avatar: UIImageView, creamNameLabel: UILabel, textLabel: UILabel, timeLabel: UILabel, flagButton: UIButton) {
        [avatar, creamNameLabel, textLabel, timeLabel, flagButton].forEach {
            pastryCard.addSubview($0)
        }
    }

    private func pinSugarReplyLayout(pastryCard: UIView, avatar: UIImageView, creamNameLabel: UILabel, textLabel: UILabel, timeLabel: UILabel, flagButton: UIButton) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 92),
            avatar.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 26),
            avatar.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            avatar.widthAnchor.constraint(equalToConstant: 42),
            avatar.heightAnchor.constraint(equalToConstant: 42),
            creamNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 18),
            creamNameLabel.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            creamNameLabel.trailingAnchor.constraint(equalTo: flagButton.leadingAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: creamNameLabel.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: creamNameLabel.bottomAnchor, constant: 3),
            textLabel.trailingAnchor.constraint(equalTo: flagButton.leadingAnchor, constant: -12),
            timeLabel.leadingAnchor.constraint(equalTo: creamNameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -14),
            flagButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -20),
            flagButton.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            flagButton.widthAnchor.constraint(equalToConstant: 34),
            flagButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func buildBottomTray() {
        replyField.translatesAutoresizingMaskIntoConstraints = false
        replyField.delegate = self
        replyField.placeholder = "WIhwaHtr ed.oR gyioouk Ed,oh noknk uwmeAeskOepn%dmsh?K".wevVPastryCrumbBloomRestored
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
            followButton.setTitle("FBowlGl%oWwRiqneg@".wevVPastryCrumbBloomRestored, for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1)
            followButton.isEnabled = false
            return
        }
        let isFollowed = guestStore.profile(for: sprinkleMoment.author.glazeKey).sugarTie.isGlazeFollowed
        followButton.setTitle(isFollowed ? "Following" : "FEo*lZlyoVw@".wevVPastryCrumbBloomRestored, for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = isFollowed ? UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1) : UIColor(red: 1, green: 0.12, blue: 0.58, alpha: 1)
        followButton.isEnabled = true
    }

    private func makeAuthorAvatar() -> UIImage? {
        if let profile = boundGuest, let glazeImage = UIImage(named: profile.donutAvatarAsset) {
            return glazeImage
        }
        if let glazeImage = UIImage(named: sprinkleMoment.author.donutAvatarAsset) {
            return glazeImage
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
        let sugarText = replyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !sugarText.isEmpty else {
            showSugarToast("SGaYy/ ;sDodm!eltnhLixnigM NsFw?eweXte !fMixrNset#".wevVPastryCrumbBloomRestored)
            return
        }
        replyField.resignFirstResponder()
        WevVBakeryExchange.spin(in: view, note: "Pfuobcllims@hzi!n!gc fpcoPs:tq.l.Q.;".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            let creamProfile = self.glazeSession.currentDoughRingTasterProfile
            self.sugarReplies.append(
                WevVSugarReply(
                    sugarKey: "freshSugar\(self.sugarReplies.count)",
                    guestKey: creamProfile.doughRingKey,
                    text: sugarText,
                    timeText: "JzuesTtv ,nmo/wO".wevVPastryCrumbBloomRestored,
                    tasterName: creamProfile.glazeNickname,
                    donutAvatarAsset: creamProfile.donutAvatarAsset
                )
            )
            self.replyField.text = nil
            self.rebuildSugarReplies()
            self.showSugarToast("Phoks=tEe?dn".wevVPastryCrumbBloomRestored)
        }
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
        showSugarToast("RAe/aRsjo%nC ig:lfa;zQeHPEaJnbeula =rleCaudwy!".wevVPastryCrumbBloomRestored)
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
            self.showSugarToast("H@ifdXdPeYnT SfrrDotmw ty@olurrm Ef/eGefdR".wevVPastryCrumbBloomRestored)
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
            WevVGlazeSafetyChoice(sugarKey: "fDaak#e+Sludg*a&r/PIhdoSt&og".wevVPastryCrumbBloomRestored, title: "Fka*kze, BpDh/oktjoc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "p&rnoamkorSSp/r~iJnbkDlPeU".wevVPastryCrumbBloomRestored, title: "ShcvavmV UoRr! Ac/oBm+mPewric;i!a.lq".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "pylsaWi;nSCVrVuOm?bo".wevVPastryCrumbBloomRestored, title: "N,oxtE ni,n#toe^r?eCs@t=evdc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "ceuTsZtGoHm+G,lNa;z?eH".wevVPastryCrumbBloomRestored, title: "OPtchwexrU".wevVPastryCrumbBloomRestored, needsCreamText: true)
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
        sugarScrollView.contentInset.bottom = overlap + 132
        sugarScrollView.verticalScrollIndicatorInsets.bottom = overlap + 132
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSugarTray(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        trayBottomConstraint?.constant = 0
        sugarScrollView.contentInset.bottom = 132
        sugarScrollView.verticalScrollIndicatorInsets.bottom = 132
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
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: bottomTray, bottomOffset: -16)
    }
}
