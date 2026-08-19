import UIKit

private struct WevVWevvCrumbReply {
    let sugarDustKey: String
    let tasterBadgeKey: String
    let crumbReplyText: String
    let cocoaShelf: String
    let donutTasterName: String?
    let donutFrameAsset: String?

    init(sugarDustKey: String, tasterBadgeKey: String, text: String, timeText: String, donutTasterName: String? = nil, donutFrameAsset: String? = nil) {
        self.sugarDustKey = sugarDustKey
        self.tasterBadgeKey = tasterBadgeKey
        self.crumbReplyText = text
        self.cocoaShelf = timeText
        self.donutTasterName = donutTasterName
        self.donutFrameAsset = donutFrameAsset
    }
}

final class WevVWevvDonutMomentController: UIViewController, UITextFieldDelegate {
    var onWevvDonutMomentGuarded: (() -> Void)?

    private let donutSnapshot: WevVDonutSnapshot
    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvTasterStore = WevVGuestGlazeStore.shared

    private let wevvMomentScroll = UIScrollView()
    private let wevvMomentStack = UIStackView()
    private let wevvTrailButton = UIButton(type: .system)
    private let wevvReplyField = UITextField()
    private let wevvBottomTray = UIView()
    private var wevvTrayBottomConstraint: NSLayoutConstraint?
    private var wevvCrumbReplies: [WevVWevvCrumbReply] = [
        WevVWevvCrumbReply(sugarDustKey: "b?rNulnOoBCHr/eDaHmRO#nweZ".wevVPastryCrumbBloomRestored, tasterBadgeKey: "aRrVlpotS+k?yMG&l=aHz;ee".wevVPastryCrumbBloomRestored, text: "G;rIebagtR hs/hJomt/!g VIL @lMoivteo Xietk".wevVPastryCrumbBloomRestored, timeText: "2l /mAinnpsZ raZguoi".wevVPastryCrumbBloomRestored),
        WevVWevvCrumbReply(sugarDustKey: "b@rguKnyojCcr!erahmiTXwno+".wevVPastryCrumbBloomRestored, tasterBadgeKey: "b~lna:iZrsBYlVu;esG:lkauzzee".wevVPastryCrumbBloomRestored, text: "Ghr&e^awta msUhJo,tk!m dIW xleo@vReH ~iBtX".wevVPastryCrumbBloomRestored, timeText: "2Y /mUiKnysL oaYgXo&".wevVPastryCrumbBloomRestored)
    ]

    init(donutSnapshot: WevVDonutSnapshot) {
        self.donutSnapshot = donutSnapshot
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("iDntiQte(&cVondzedr;:~)+ VhsaZs/ #n#octz abFeBeAnJ iiDmbpnlhe%mbe,n%tNe/dq".wevVPastryCrumbBloomRestored)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.86, alpha: 1.0)
        buildWevvMomentCanvas()
        refreshWevvTrailButton()
        NotificationCenter.default.addObserver(self, selector: #selector(liftWevvCrumbTray(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropWevvCrumbTray(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private var boundTasterCard: WevVGuestGlazeProfile? {
        wevvTasterStore.allProfiles.first { $0.donutPinKey == donutSnapshot.tasterBloom.donutPinKey }
    }

    private func buildWevvMomentCanvas() {
        let frostingGlow = UIView()
        frostingGlow.translatesAutoresizingMaskIntoConstraints = false
        frostingGlow.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.86, alpha: 1.0)
        view.addSubview(frostingGlow)

        wevvMomentScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvMomentScroll.alwaysBounceVertical = true
        wevvMomentScroll.keyboardDismissMode = .interactive
        wevvMomentScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 132, right: 0)
        view.addSubview(wevvMomentScroll)

        wevvMomentStack.translatesAutoresizingMaskIntoConstraints = false
        wevvMomentStack.axis = .vertical
        wevvMomentStack.spacing = 18
        wevvMomentScroll.addSubview(wevvMomentStack)

        wevvBottomTray.translatesAutoresizingMaskIntoConstraints = false
        wevvBottomTray.backgroundColor = .white
        view.addSubview(wevvBottomTray)
        wevvTrayBottomConstraint = wevvBottomTray.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([
            frostingGlow.topAnchor.constraint(equalTo: view.topAnchor),
            frostingGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvMomentScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wevvMomentScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvMomentScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvMomentScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvMomentStack.topAnchor.constraint(equalTo: wevvMomentScroll.contentLayoutGuide.topAnchor, constant: 28),
            wevvMomentStack.leadingAnchor.constraint(equalTo: wevvMomentScroll.frameLayoutGuide.leadingAnchor, constant: 30),
            wevvMomentStack.trailingAnchor.constraint(equalTo: wevvMomentScroll.frameLayoutGuide.trailingAnchor, constant: -30),
            wevvMomentStack.bottomAnchor.constraint(equalTo: wevvMomentScroll.contentLayoutGuide.bottomAnchor, constant: -150),
            wevvBottomTray.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvBottomTray.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvBottomTray.heightAnchor.constraint(equalToConstant: 88),
            wevvTrayBottomConstraint!
        ])

        wevvMomentStack.addArrangedSubview(makeWevvMomentHeader())
        wevvMomentStack.addArrangedSubview(makeWevvHeroPanel())
        wevvMomentStack.addArrangedSubview(makeWevvMomentText())
        wevvMomentStack.addArrangedSubview(makeWevvReplyTitle())
        rebuildWevvCrumbReplies()
        buildWevvBottomTray()
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endWevvCrumbEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeWevvMomentHeader() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeWevvDonutMoment), for: .touchUpInside)

        let parlorQuest = UIButton(type: .custom)
        parlorQuest.translatesAutoresizingMaskIntoConstraints = false
        parlorQuest.clipsToBounds = true
        parlorQuest.layer.cornerRadius = 26
        parlorQuest.setImage(makeWevvAuthorAvatar(), for: .normal)
        parlorQuest.imageView?.contentMode = .scaleAspectFill
        parlorQuest.addTarget(self, action: #selector(openBoundTasterCard), for: .touchUpInside)

        let donutTasterNameLabel = UILabel()
        donutTasterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        donutTasterNameLabel.text = boundTasterCard?.cocoaCounter ?? donutSnapshot.tasterBloom.name
        donutTasterNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        donutTasterNameLabel.textColor = UIColor(red: 0.12, green: 0.05, blue: 0.08, alpha: 1)
        donutTasterNameLabel.adjustsFontSizeToFitWidth = true
        donutTasterNameLabel.minimumScaleFactor = 0.72

        wevvTrailButton.translatesAutoresizingMaskIntoConstraints = false
        wevvTrailButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        wevvTrailButton.layer.cornerRadius = 17.5
        wevvTrailButton.clipsToBounds = true
        wevvTrailButton.addTarget(self, action: #selector(toggleWevvSugarTrail), for: .touchUpInside)

        let trailQuest = UIButton(type: .system)
        trailQuest.translatesAutoresizingMaskIntoConstraints = false
        trailQuest.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        trailQuest.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        trailQuest.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        trailQuest.layer.cornerRadius = 17
        trailQuest.addTarget(self, action: #selector(openWevvMomentNotice), for: .touchUpInside)

        placeWevvMomentHeaderViews(header: header, doughBackButton: doughBackButton, avatarButton: parlorQuest, donutTasterNameLabel: donutTasterNameLabel, noticeButton: trailQuest)
        pinWevvMomentHeaderLayout(header: header, doughBackButton: doughBackButton, cherryScout: parlorQuest, donutTasterNameLabel: donutTasterNameLabel, cherryQuest: trailQuest)
        return header
    }

    private func placeWevvMomentHeaderViews(header: UIView, doughBackButton: UIButton, avatarButton: UIButton, donutTasterNameLabel: UILabel, noticeButton: UIButton) {
        [doughBackButton, avatarButton, donutTasterNameLabel, wevvTrailButton, noticeButton].forEach {
            header.addSubview($0)
        }
    }

    private func pinWevvMomentHeaderLayout(header: UIView, doughBackButton: UIButton, cherryScout: UIButton, donutTasterNameLabel: UILabel, cherryQuest: UIButton) {
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 74),
            doughBackButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: -8),
            doughBackButton.centerYAnchor.constraint(equalTo: cherryScout.centerYAnchor),
            doughBackButton.widthAnchor.constraint(equalToConstant: 38),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            cherryScout.leadingAnchor.constraint(equalTo: doughBackButton.trailingAnchor, constant: 20),
            cherryScout.topAnchor.constraint(equalTo: header.topAnchor),
            cherryScout.widthAnchor.constraint(equalToConstant: 52),
            cherryScout.heightAnchor.constraint(equalToConstant: 52),
            donutTasterNameLabel.leadingAnchor.constraint(equalTo: cherryScout.trailingAnchor, constant: 16),
            donutTasterNameLabel.centerYAnchor.constraint(equalTo: cherryScout.centerYAnchor),
            donutTasterNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: wevvTrailButton.leadingAnchor, constant: -14),
            wevvTrailButton.trailingAnchor.constraint(equalTo: cherryQuest.leadingAnchor, constant: -10),
            wevvTrailButton.centerYAnchor.constraint(equalTo: cherryScout.centerYAnchor),
            wevvTrailButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 84),
            wevvTrailButton.heightAnchor.constraint(equalToConstant: 35),
            cherryQuest.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            cherryQuest.centerYAnchor.constraint(equalTo: cherryScout.centerYAnchor),
            cherryQuest.widthAnchor.constraint(equalToConstant: 34),
            cherryQuest.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeWevvHeroPanel() -> UIView {
        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.clipsToBounds = true
        glazePanel.layer.cornerRadius = 18

        let pistachioSample = UIImageView(image: WevVPastryImageVault.glazeImage(for: donutSnapshot.donutBackdropAsset) ?? makeWevvFallbackDonutImage(seed: donutSnapshot.donutBackdropAsset))
        pistachioSample.translatesAutoresizingMaskIntoConstraints = false
        pistachioSample.contentMode = .scaleAspectFill
        pistachioSample.clipsToBounds = true

        glazePanel.addSubview(pistachioSample)
        NSLayoutConstraint.activate([
            glazePanel.heightAnchor.constraint(equalTo: glazePanel.widthAnchor, multiplier: 0.78),
            pistachioSample.topAnchor.constraint(equalTo: glazePanel.topAnchor),
            pistachioSample.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor),
            pistachioSample.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor),
            pistachioSample.bottomAnchor.constraint(equalTo: glazePanel.bottomAnchor)
        ])
        return glazePanel
    }

    private func makeWevvMomentText() -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = donutSnapshot.tastingText
        crumbLabel.font = .systemFont(ofSize: 21, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.16, green: 0.12, blue: 0.13, alpha: 1)
        crumbLabel.numberOfLines = 0
        return crumbLabel
    }

    private func makeWevvReplyTitle() -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = "CkocmpmYe#nwt;s,".wevVPastryCrumbBloomRestored
        crumbLabel.font = .systemFont(ofSize: 24, weight: .bold)
        crumbLabel.textColor = .black
        return crumbLabel
    }

    private func rebuildWevvCrumbReplies() {
        wevvMomentStack.arrangedSubviews
            .filter { $0.accessibilityIdentifier == "w@eDvJvgS&ukgPa;rURkeRp^lmyUC~aSr!d?".wevVPastryCrumbBloomRestored }
            .forEach { crumbCard in
                wevvMomentStack.removeArrangedSubview(crumbCard)
                crumbCard.removeFromSuperview()
            }
        wevvCrumbReplies.forEach { wevvMomentStack.addArrangedSubview(makeWevvCrumbNoteCard($0)) }
    }

    private func makeWevvCrumbNoteCard(_ crumbNote: WevVWevvCrumbReply) -> UIView {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = "wlewvYvKSyu.gPaormRFeQp=loyYCVa+rTdc".wevVPastryCrumbBloomRestored
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 28
        pastryCard.clipsToBounds = true
        pastryCard.addTarget(self, action: #selector(showWevvCrumbFlagHint), for: .touchUpInside)

        let tasterCard = wevvTasterStore.profile(for: crumbNote.tasterBadgeKey)
        let avatar = makeWevvCrumbNoteAvatar(crumbNote, tasterCard: tasterCard)
        let donutTasterNameLabel = makeWevvCrumbNoteName(crumbNote, tasterCard: tasterCard)
        let textLabel = makeWevvCrumbNoteText(crumbNote.crumbReplyText)
        let timeLabel = makeWevvCrumbNoteTime(crumbNote.cocoaShelf)
        let crumbFlagButton = makeWevvCrumbFlagButton()

        placeWevvCrumbNoteViews(pastryCard: pastryCard, avatar: avatar, donutTasterNameLabel: donutTasterNameLabel, textLabel: textLabel, timeLabel: timeLabel, crumbFlagButton: crumbFlagButton)
        pinWevvCrumbNoteLayout(pastryCard: pastryCard, aromaFlight: avatar, donutTasterNameLabel: donutTasterNameLabel, textLabel: textLabel, timeLabel: timeLabel, crumbFlagButton: crumbFlagButton)
        return pastryCard
    }

    private func makeWevvCrumbNoteAvatar(_ crumbNote: WevVWevvCrumbReply, tasterCard: WevVGuestGlazeProfile) -> UIImageView {
        let crumbAvatarAsset = crumbNote.donutFrameAsset ?? tasterCard.donutFrameAsset
        let glazeAvatar = UIImageView(image: UIImage(named: crumbAvatarAsset) ?? makeWevvFallbackDonutImage(seed: crumbNote.donutTasterName ?? crumbNote.tasterBadgeKey))
        glazeAvatar.translatesAutoresizingMaskIntoConstraints = false
        glazeAvatar.contentMode = .scaleAspectFill
        glazeAvatar.clipsToBounds = true
        glazeAvatar.layer.cornerRadius = 21
        return glazeAvatar
    }

    private func makeWevvCrumbNoteName(_ crumbNote: WevVWevvCrumbReply, tasterCard: WevVGuestGlazeProfile) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = crumbNote.donutTasterName ?? (crumbNote.tasterBadgeKey == "a.rWlVo?SQkWyaGxlRaRzveh".wevVPastryCrumbBloomRestored ? "Bruno Pham" : tasterCard.cocoaCounter)
        crumbLabel.font = .systemFont(ofSize: 18, weight: .bold)
        crumbLabel.textColor = .black
        return crumbLabel
    }

    private func makeWevvCrumbNoteText(_ crumbReplyText: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = crumbReplyText
        crumbLabel.font = .systemFont(ofSize: 18, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.5, alpha: 1)
        crumbLabel.numberOfLines = 2
        return crumbLabel
    }

    private func makeWevvCrumbNoteTime(_ sugarTime: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarTime
        crumbLabel.font = .systemFont(ofSize: 16, weight: .regular)
        crumbLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 1)
        return crumbLabel
    }

    private func makeWevvCrumbFlagButton() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.addTarget(self, action: #selector(showWevvCrumbFlagHint), for: .touchUpInside)
        return sprinkleButton
    }

    private func placeWevvCrumbNoteViews(pastryCard: UIView, avatar: UIImageView, donutTasterNameLabel: UILabel, textLabel: UILabel, timeLabel: UILabel, crumbFlagButton: UIButton) {
        [avatar, donutTasterNameLabel, textLabel, timeLabel, crumbFlagButton].forEach {
            pastryCard.addSubview($0)
        }
    }

    private func pinWevvCrumbNoteLayout(pastryCard: UIView, aromaFlight: UIImageView, donutTasterNameLabel: UILabel, textLabel: UILabel, timeLabel: UILabel, crumbFlagButton: UIButton) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 92),
            aromaFlight.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 26),
            aromaFlight.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            aromaFlight.widthAnchor.constraint(equalToConstant: 42),
            aromaFlight.heightAnchor.constraint(equalToConstant: 42),
            donutTasterNameLabel.leadingAnchor.constraint(equalTo: aromaFlight.trailingAnchor, constant: 18),
            donutTasterNameLabel.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            donutTasterNameLabel.trailingAnchor.constraint(equalTo: crumbFlagButton.leadingAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: donutTasterNameLabel.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: donutTasterNameLabel.bottomAnchor, constant: 3),
            textLabel.trailingAnchor.constraint(equalTo: crumbFlagButton.leadingAnchor, constant: -12),
            timeLabel.leadingAnchor.constraint(equalTo: donutTasterNameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -14),
            crumbFlagButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -20),
            crumbFlagButton.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            crumbFlagButton.widthAnchor.constraint(equalToConstant: 34),
            crumbFlagButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func buildWevvBottomTray() {
        wevvReplyField.translatesAutoresizingMaskIntoConstraints = false
        wevvReplyField.delegate = self
        wevvReplyField.placeholder = "WIhwaHtr ed.oR gyioouk Ed,oh noknk uwmeAeskOepn%dmsh?K".wevVPastryCrumbBloomRestored
        wevvReplyField.font = .systemFont(ofSize: 17, weight: .regular)
        wevvReplyField.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
        wevvReplyField.layer.cornerRadius = 24
        wevvReplyField.clipsToBounds = true
        wevvReplyField.returnKeyType = .send
        wevvReplyField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 1))
        wevvReplyField.leftViewMode = .always

        let crumbSendButton = UIButton(type: .system)
        crumbSendButton.translatesAutoresizingMaskIntoConstraints = false
        if let sendImage = UIImage(named: "wevv_room_send_glaze") {
            crumbSendButton.setImage(sendImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            crumbSendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            crumbSendButton.tintColor = .white
            crumbSendButton.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.58, alpha: 1)
            crumbSendButton.layer.cornerRadius = 33
        }
        crumbSendButton.addTarget(self, action: #selector(addWevvCrumbNote), for: .touchUpInside)

        wevvBottomTray.addSubview(wevvReplyField)
        wevvBottomTray.addSubview(crumbSendButton)

        NSLayoutConstraint.activate([
            wevvReplyField.leadingAnchor.constraint(equalTo: wevvBottomTray.leadingAnchor, constant: 30),
            wevvReplyField.topAnchor.constraint(equalTo: wevvBottomTray.topAnchor, constant: 12),
            wevvReplyField.heightAnchor.constraint(equalToConstant: 48),
            crumbSendButton.leadingAnchor.constraint(equalTo: wevvReplyField.trailingAnchor, constant: 24),
            crumbSendButton.trailingAnchor.constraint(equalTo: wevvBottomTray.trailingAnchor, constant: -30),
            crumbSendButton.centerYAnchor.constraint(equalTo: wevvReplyField.centerYAnchor),
            crumbSendButton.widthAnchor.constraint(equalToConstant: 56),
            crumbSendButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func refreshWevvTrailButton() {
        guard boundTasterCard != nil else {
            wevvTrailButton.setTitle("FBowlGl%oWwRiqneg@".wevVPastryCrumbBloomRestored, for: .normal)
            wevvTrailButton.setTitleColor(.white, for: .normal)
            wevvTrailButton.backgroundColor = UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1)
            wevvTrailButton.isEnabled = false
            return
        }
        let isFollowed = wevvTasterStore.profile(for: donutSnapshot.tasterBloom.donutPinKey).sugarTie.isGlazeFollowed
        wevvTrailButton.setTitle(isFollowed ? "Following" : "FEo*lZlyoVw@".wevVPastryCrumbBloomRestored, for: .normal)
        wevvTrailButton.setTitleColor(.white, for: .normal)
        wevvTrailButton.backgroundColor = isFollowed ? UIColor(red: 0.69, green: 0.69, blue: 0.7, alpha: 1) : UIColor(red: 1, green: 0.12, blue: 0.58, alpha: 1)
        wevvTrailButton.isEnabled = true
    }

    private func makeWevvAuthorAvatar() -> UIImage? {
        if let tasterCard = boundTasterCard, let glazeImage = UIImage(named: tasterCard.donutFrameAsset) {
            return glazeImage
        }
        if let glazeImage = UIImage(named: donutSnapshot.tasterBloom.donutFrameAsset) {
            return glazeImage
        }
        return makeWevvFallbackDonutImage(seed: donutSnapshot.tasterBloom.name)
    }

    private func makeWevvFallbackDonutImage(seed: String) -> UIImage {
        let mapleFlight: [UIColor] = [
            UIColor(red: 1.0, green: 0.42, blue: 0.67, alpha: 1),
            UIColor(red: 0.58, green: 0.42, blue: 1.0, alpha: 1),
            UIColor(red: 1.0, green: 0.72, blue: 0.28, alpha: 1),
            UIColor(red: 0.24, green: 0.74, blue: 0.84, alpha: 1)
        ]
        let cocoaFlight = CGSize(width: 160, height: 160)
        return UIGraphicsImageRenderer(size: cocoaFlight).image { context in
            let vanillaFlight = mapleFlight[abs(seed.hashValue) % mapleFlight.count]
            vanillaFlight.setFill()
            context.fill(CGRect(origin: .zero, size: cocoaFlight))
            let mapleBadge = String(seed.prefix(1)).uppercased()
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 72, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = mapleBadge.size(withAttributes: attrs)
            mapleBadge.draw(at: CGPoint(x: (cocoaFlight.width - textSize.width) / 2, y: (cocoaFlight.height - textSize.height) / 2), withAttributes: attrs)
        }
    }

    @objc private func toggleWevvSugarTrail() {
        guard boundTasterCard != nil else { return }
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvBakeryGate()
            return
        }
        _ = wevvTasterStore.toggleGlazeFollow(for: donutSnapshot.tasterBloom.donutPinKey)
        refreshWevvTrailButton()
    }

    @objc private func addWevvCrumbNote() {
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvBakeryGate()
            return
        }
        let crumbReplyText = wevvReplyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !crumbReplyText.isEmpty else {
            showWevvDonutToast("SGaYy/ ;sDodm!eltnhLixnigM NsFw?eweXte !fMixrNset#".wevVPastryCrumbBloomRestored)
            return
        }
        wevvReplyField.resignFirstResponder()
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Pfuobcllims@hzi!n!gc fpcoPs:tq.l.Q.;".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            let creamProfile = self.wevvDonutJournalStore.currentDoughRingTasterProfile
            self.wevvCrumbReplies.append(
                WevVWevvCrumbReply(
                    sugarDustKey: "freshSugar\(self.wevvCrumbReplies.count)",
                    tasterBadgeKey: creamProfile.ringCutterKey,
                    text: crumbReplyText,
                    timeText: "JzuesTtv ,nmo/wO".wevVPastryCrumbBloomRestored,
                    donutTasterName: creamProfile.glazeNickname,
                    donutFrameAsset: creamProfile.donutFrameAsset
                )
            )
            self.wevvReplyField.text = nil
            self.rebuildWevvCrumbReplies()
            self.showWevvDonutToast("Phoks=tEe?dn".wevVPastryCrumbBloomRestored)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addWevvCrumbNote()
        return true
    }

    @objc private func openBoundTasterCard() {
        guard let tasterCard = boundTasterCard else { return }
        let controller = WevVWevvTasterCardController(tasterBadgeKey: tasterCard.donutPinKey)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func showWevvCrumbFlagHint() {
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvBakeryGate()
            return
        }
        showWevvDonutToast("RAe/aRsjo%nC ig:lfa;zQeHPEaJnbeula =rleCaudwy!".wevVPastryCrumbBloomRestored)
    }

    @objc private func openWevvMomentNotice() {
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvBakeryGate()
            return
        }
        presentWevvNoticeSheet()
    }

    private func presentWevvNoticeSheet() {
        let donutQuest = WevVGlazeSafetySheet(bakeryPinKey: donutSnapshot.tasterBloom.donutPinKey, choices: wevvNoticeChoices())
        donutQuest.almondMixer = { [weak self, weak donutQuest] in
            self?.hideWevvNoticeSheet(donutQuest)
        }
        donutQuest.almondBench = { [weak self, weak donutQuest] packet in
            guard let self else { return }
            self.wevvDonutJournalStore.placeGlazeSafetyCrumb(packet)
            self.placeWevvSugarGuard()
            self.hideWevvNoticeSheet(donutQuest)
            self.showWevvDonutToast("H@ifdXdPeYnT SfrrDotmw ty@olurrm Ef/eGefdR".wevVPastryCrumbBloomRestored)
            self.onWevvDonutMomentGuarded?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.dismiss(animated: true)
            }
        }
        view.addSubview(donutQuest)
        NSLayoutConstraint.activate([
            donutQuest.topAnchor.constraint(equalTo: view.topAnchor),
            donutQuest.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            donutQuest.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            donutQuest.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }

    private func hideWevvNoticeSheet(_ treatStudio: WevVGlazeSafetySheet?) {
        treatStudio?.endEditing(true)
        treatStudio?.removeFromSuperview()
    }

    private func wevvNoticeChoices() -> [WevVGlazeSafetyChoice] {
        [
            WevVGlazeSafetyChoice(sugarDustKey: "fDaak#e+Sludg*a&r/PIhdoSt&og".wevVPastryCrumbBloomRestored, almondCase: "Fka*kze, BpDh/oktjoc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "p&rnoamkorSSp/r~iJnbkDlPeU".wevVPastryCrumbBloomRestored, almondCase: "ShcvavmV UoRr! Ac/oBm+mPewric;i!a.lq".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "pylsaWi;nSCVrVuOm?bo".wevVPastryCrumbBloomRestored, almondCase: "N,oxtE ni,n#toe^r?eCs@t=evdc".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "ceuTsZtGoHm+G,lNa;z?eH".wevVPastryCrumbBloomRestored, almondCase: "OPtchwexrU".wevVPastryCrumbBloomRestored, needsCreamText: true)
        ]
    }

    private func placeWevvSugarGuard() {
        guard wevvTasterStore.allProfiles.contains(where: { $0.donutPinKey == donutSnapshot.tasterBloom.donutPinKey }) else { return }
        if !wevvTasterStore.profile(for: donutSnapshot.tasterBloom.donutPinKey).sugarTie.isSugarShielded {
            _ = wevvTasterStore.toggleSugarShield(for: donutSnapshot.tasterBloom.donutPinKey)
        }
    }

    @objc private func closeWevvDonutMoment() {
        dismiss(animated: true)
    }

    @objc private func endWevvCrumbEditing() {
        view.endEditing(true)
    }

    @objc private func liftWevvCrumbTray(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        wevvTrayBottomConstraint?.constant = -overlap
        wevvMomentScroll.contentInset.bottom = overlap + 132
        wevvMomentScroll.verticalScrollIndicatorInsets.bottom = overlap + 132
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropWevvCrumbTray(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        wevvTrayBottomConstraint?.constant = 0
        wevvMomentScroll.contentInset.bottom = 132
        wevvMomentScroll.verticalScrollIndicatorInsets.bottom = 132
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showWevvBakeryGate() {
        let menuFlight = WevVWevvBakeryGateController()
        menuFlight.modalPresentationStyle = .fullScreen
        menuFlight.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.refreshWevvTrailButton()
            }
        }
        present(menuFlight, animated: true)
    }

    private func showWevvDonutToast(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: wevvBottomTray, bottomOffset: -16)
    }
}
