import AVFoundation
import UIKit

final class WevVGlazeRoomController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private var creamState: WevVCreamRoomState
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let seatCanvas = UIView()
    private let inputBar = UIView()
    private let inputField = UITextField()
    private let roomLineStack = UIStackView()
    private var inputBottomConstraint: NSLayoutConstraint?
    private var seatViews: [Int: UIControl] = [:]
    private var grantLayer: UIView?
    private var hostIsFollowed = false
    private let creamRecordFlavor = AVMediaType(rawValue: "soun")

    init(roomKey: String, shopTitle: String) {
        creamState = WevVGlazeRoomController.makeCreamState(roomKey: roomKey, shopTitle: shopTitle)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildBackdrop()
        buildRoomContent()
        buildInputBar()
        bindKeyboardLift()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildBackdrop() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.26, alpha: 1)
        let stage = UIImageView(image: UIImage(named: "wevv_room_stage_backdrop"))
        stage.translatesAutoresizingMaskIntoConstraints = false
        stage.contentMode = .scaleAspectFill
        view.addSubview(stage)
        NSLayoutConstraint.activate([
            stage.topAnchor.constraint(equalTo: view.topAnchor),
            stage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildRoomContent() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let topBar = makeTopBar()
        seatCanvas.translatesAutoresizingMaskIntoConstraints = false
        let hintCard = makeHintCard()
        configureRoomLineStack()

        contentView.addSubview(topBar)
        contentView.addSubview(seatCanvas)
        contentView.addSubview(hintCard)
        contentView.addSubview(roomLineStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            topBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            topBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            topBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            topBar.heightAnchor.constraint(equalToConstant: 62),
            seatCanvas.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 14),
            seatCanvas.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seatCanvas.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            seatCanvas.heightAnchor.constraint(equalToConstant: 332),
            hintCard.topAnchor.constraint(equalTo: seatCanvas.bottomAnchor, constant: 18),
            hintCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hintCard.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            roomLineStack.topAnchor.constraint(equalTo: hintCard.bottomAnchor, constant: 14),
            roomLineStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            roomLineStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -88),
            roomLineStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -110)
        ])
        refreshSeatCanvas()
    }

    private func makeTopBar() -> UIView {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        let hostProfile = guestStore.profile(for: creamState.hostGuestKey)
        hostIsFollowed = hostProfile.sugarTie.isGlazeFollowed

        let avatarButton = UIControl()
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.layer.cornerRadius = 26
        avatarButton.clipsToBounds = true
        avatarButton.addTarget(self, action: #selector(openHostSugarProfile), for: .touchUpInside)

        let avatar = UIImageView(image: makeGuestAvatar(guestKey: creamState.hostGuestKey, seed: creamState.hostSeed, size: 52))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatarButton.addSubview(avatar)

        let name = makeRoomLabel(hostProfile.name, size: 17, weight: .heavy, color: .white)
        name.lineBreakMode = .byTruncatingTail

        let heat = makeRoomLabel("🔥  \(creamState.heatText)", size: 12, weight: .semibold, color: UIColor.white.withAlphaComponent(0.9))

        let follow = makeCircleButton(
            symbol: hostIsFollowed ? "checkmark" : "plus",
            fill: hostIsFollowed ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1),
            tint: .white
        )
        follow.addTarget(self, action: #selector(toggleHostSugarFollow(_:)), for: .touchUpInside)
        let crowd = makeRoundText(creamState.crowdText, fill: UIColor(red: 0.1, green: 0.04, blue: 0.24, alpha: 0.78), color: .white)
        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(closeCreamRoom), for: .touchUpInside)

        bar.addSubview(avatarButton)
        bar.addSubview(name)
        bar.addSubview(heat)
        bar.addSubview(follow)
        bar.addSubview(crowd)
        bar.addSubview(close)

        NSLayoutConstraint.activate([
            avatarButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: 52),
            avatarButton.heightAnchor.constraint(equalToConstant: 52),
            avatar.topAnchor.constraint(equalTo: avatarButton.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: avatarButton.leadingAnchor),
            avatar.trailingAnchor.constraint(equalTo: avatarButton.trailingAnchor),
            avatar.bottomAnchor.constraint(equalTo: avatarButton.bottomAnchor),
            name.topAnchor.constraint(equalTo: avatarButton.topAnchor, constant: 7),
            name.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 7),
            name.trailingAnchor.constraint(lessThanOrEqualTo: follow.leadingAnchor, constant: -8),
            heat.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            heat.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            follow.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            follow.leadingAnchor.constraint(greaterThanOrEqualTo: name.trailingAnchor, constant: 8),
            follow.widthAnchor.constraint(equalToConstant: 53),
            follow.heightAnchor.constraint(equalToConstant: 53),
            crowd.centerYAnchor.constraint(equalTo: follow.centerYAnchor),
            crowd.trailingAnchor.constraint(equalTo: close.leadingAnchor, constant: -18),
            crowd.widthAnchor.constraint(equalToConstant: 48),
            crowd.heightAnchor.constraint(equalToConstant: 48),
            close.centerYAnchor.constraint(equalTo: follow.centerYAnchor),
            close.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            close.widthAnchor.constraint(equalToConstant: 42),
            close.heightAnchor.constraint(equalToConstant: 42)
        ])
        return bar
    }

    private func refreshSeatCanvas() {
        seatCanvas.subviews.forEach { $0.removeFromSuperview() }
        seatViews.removeAll()

        guard creamState.seats.count == 6 else { return }
        let firstSeat = makeSeatView(creamState.seats[0], style: .large)
        let secondSeat = makeSeatView(creamState.seats[1], style: .small)
        let thirdSeat = makeSeatView(creamState.seats[2], style: .small)
        let secondColumn = UIStackView(arrangedSubviews: [secondSeat, thirdSeat])
        secondColumn.translatesAutoresizingMaskIntoConstraints = false
        secondColumn.axis = .vertical
        secondColumn.spacing = 10
        secondColumn.distribution = .fillEqually

        let lowerRow = UIStackView(arrangedSubviews: [
            makeSeatView(creamState.seats[3], style: .empty),
            makeSeatView(creamState.seats[4], style: .empty),
            makeSeatView(creamState.seats[5], style: .empty)
        ])
        lowerRow.translatesAutoresizingMaskIntoConstraints = false
        lowerRow.axis = .horizontal
        lowerRow.spacing = 6
        lowerRow.distribution = .fillEqually

        seatCanvas.addSubview(firstSeat)
        seatCanvas.addSubview(secondColumn)
        seatCanvas.addSubview(lowerRow)

        NSLayoutConstraint.activate([
            firstSeat.topAnchor.constraint(equalTo: seatCanvas.topAnchor),
            firstSeat.leadingAnchor.constraint(equalTo: seatCanvas.leadingAnchor),
            firstSeat.widthAnchor.constraint(equalTo: seatCanvas.widthAnchor, multiplier: 0.66),
            firstSeat.heightAnchor.constraint(equalToConstant: 218),
            secondColumn.topAnchor.constraint(equalTo: seatCanvas.topAnchor),
            secondColumn.leadingAnchor.constraint(equalTo: firstSeat.trailingAnchor, constant: 6),
            secondColumn.trailingAnchor.constraint(equalTo: seatCanvas.trailingAnchor),
            secondColumn.heightAnchor.constraint(equalTo: firstSeat.heightAnchor),
            lowerRow.topAnchor.constraint(equalTo: firstSeat.bottomAnchor, constant: 10),
            lowerRow.leadingAnchor.constraint(equalTo: seatCanvas.leadingAnchor),
            lowerRow.trailingAnchor.constraint(equalTo: seatCanvas.trailingAnchor),
            lowerRow.bottomAnchor.constraint(equalTo: seatCanvas.bottomAnchor)
        ])
    }

    private enum SeatFlavor {
        case large
        case small
        case empty
    }

    private func makeSeatView(_ seat: WevVGlazeRoomSeat, style: SeatFlavor) -> UIControl {
        let seatView = UIControl()
        seatView.translatesAutoresizingMaskIntoConstraints = false
        seatView.tag = seat.sugarIndex
        seatView.layer.cornerRadius = 12
        seatView.layer.borderWidth = seat.isCreamEmpty ? 1.2 : 0
        seatView.layer.borderColor = UIColor.white.withAlphaComponent(0.26).cgColor
        seatView.clipsToBounds = true
        seatView.addTarget(self, action: #selector(tapCreamSeat(_:)), for: .touchUpInside)
        seatViews[seat.sugarIndex] = seatView

        let number = makeRoomLabel("\(seat.sugarIndex)", size: 16, weight: .semibold, color: .white)
        let add = makeCircleButton(symbol: "plus", fill: UIColor(red: 0.24, green: 0.18, blue: 0.54, alpha: 0.72), tint: .white)
        add.isUserInteractionEnabled = false

        seatView.addSubview(number)
        NSLayoutConstraint.activate([
            number.topAnchor.constraint(equalTo: seatView.topAnchor, constant: 12),
            number.leadingAnchor.constraint(equalTo: seatView.leadingAnchor, constant: 13)
        ])

        if seat.isCreamEmpty {
            seatView.addSubview(add)
            NSLayoutConstraint.activate([
                add.centerXAnchor.constraint(equalTo: seatView.centerXAnchor),
                add.centerYAnchor.constraint(equalTo: seatView.centerYAnchor),
                add.widthAnchor.constraint(equalToConstant: 48),
                add.heightAnchor.constraint(equalToConstant: 48)
            ])
            return seatView
        }

        let image = UIImageView(image: makeGuestAvatar(guestKey: seat.guestKey, seed: seat.avatarSeed, size: style == .large ? 220 : 120))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let shade = UIView()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.28)

        let name = makeRoomLabel(seat.tasterName ?? "Taster", size: style == .large ? 19 : 16, weight: .heavy, color: .white)
        name.lineBreakMode = .byTruncatingTail

        let mic = makeMicBadge(isOpen: seat.isMicOpen, isCurrent: seat.isCurrentTaster)
        seatView.addSubview(image)
        seatView.addSubview(shade)
        seatView.addSubview(name)
        seatView.addSubview(mic)
        seatView.bringSubviewToFront(number)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: seatView.topAnchor),
            image.leadingAnchor.constraint(equalTo: seatView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: seatView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: seatView.bottomAnchor),
            shade.leadingAnchor.constraint(equalTo: seatView.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: seatView.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: seatView.bottomAnchor),
            shade.heightAnchor.constraint(equalTo: seatView.heightAnchor, multiplier: 0.28),
            name.leadingAnchor.constraint(equalTo: seatView.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(lessThanOrEqualTo: seatView.trailingAnchor, constant: -8),
            name.bottomAnchor.constraint(equalTo: seatView.bottomAnchor, constant: -10),
            mic.topAnchor.constraint(equalTo: seatView.topAnchor, constant: 10),
            mic.trailingAnchor.constraint(equalTo: seatView.trailingAnchor, constant: -10),
            mic.widthAnchor.constraint(equalToConstant: 48),
            mic.heightAnchor.constraint(equalToConstant: 36)
        ])
        return seatView
    }

    private func makeMicBadge(isOpen: Bool, isCurrent: Bool) -> UIView {
        let badge = UIView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = isOpen ? UIColor(red: 1, green: 0.14, blue: 0.62, alpha: 1) : UIColor.black.withAlphaComponent(isCurrent ? 0.86 : 0.92)
        badge.layer.cornerRadius = 18

        let iconName = isOpen ? "mic.fill" : "mic.slash.fill"
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        badge.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: badge.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: badge.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20)
        ])
        return badge
    }

    private func makeHintCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 1.1
        card.layer.borderColor = UIColor(red: 0.35, green: 0.87, blue: 1, alpha: 0.95).cgColor
        card.backgroundColor = UIColor(red: 0.25, green: 0.38, blue: 0.95, alpha: 0.34)

        let text = makeRoomLabel("Pick Your Role And Speak Your Part.\nEvery Voice Shapes The Story.\nWelcome To Our Voice Theater.", size: 14, weight: .medium, color: .white)
        text.numberOfLines = 3
        card.addSubview(text)
        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
            text.topAnchor.constraint(equalTo: card.topAnchor, constant: 11),
            text.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            text.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            text.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -11)
        ])
        return card
    }

    private func configureRoomLineStack() {
        roomLineStack.translatesAutoresizingMaskIntoConstraints = false
        roomLineStack.axis = .vertical
        roomLineStack.spacing = 12
        creamState.roomLines.forEach { roomLineStack.addArrangedSubview(makeRoomLineBubble($0)) }
    }

    private func makeRoomLineBubble(_ line: WevVSprinkleRoomLine) -> UIView {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.backgroundColor = UIColor(red: 0.62, green: 0.84, blue: 1, alpha: 0.34)
        bubble.layer.cornerRadius = 14
        bubble.layer.borderWidth = 1
        bubble.layer.borderColor = UIColor(red: 0.1, green: 0.2, blue: 0.62, alpha: 0.75).cgColor

        let text = makeRoomLabel("\(line.tasterName): \(line.crumbText)", size: 14, weight: .medium, color: .white)
        text.numberOfLines = 0
        if let value = text.text {
            let packet = NSMutableAttributedString(string: value)
            let nameRange = (value as NSString).range(of: "\(line.tasterName):")
            packet.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .heavy), range: nameRange)
            text.attributedText = packet
        }
        bubble.addSubview(text)
        NSLayoutConstraint.activate([
            bubble.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            text.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            text.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
            text.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12),
            text.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10)
        ])
        return bubble
    }

    private func buildInputBar() {
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.backgroundColor = UIColor(red: 0.3, green: 0.16, blue: 0.6, alpha: 0.62)
        inputBar.layer.cornerRadius = 28
        view.addSubview(inputBar)

        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.borderStyle = .none
        inputField.textColor = .white
        inputField.font = .systemFont(ofSize: 17, weight: .heavy)
        inputField.attributedPlaceholder = NSAttributedString(
            string: "Say hi~",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.76)]
        )

        let send = makeSendButton()
        send.addTarget(self, action: #selector(sendCreamLine), for: .touchUpInside)
        inputBar.addSubview(inputField)
        view.addSubview(send)

        inputBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            inputBottomConstraint!,
            inputBar.heightAnchor.constraint(equalToConstant: 56),
            inputField.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: 24),
            inputField.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            inputField.trailingAnchor.constraint(equalTo: send.leadingAnchor, constant: -12),
            send.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            send.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            send.widthAnchor.constraint(equalToConstant: 48),
            send.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func bindKeyboardLift() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftCreamInput(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropCreamInput(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftCreamInput(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let lift = max(0, frame.height - view.safeAreaInsets.bottom)
        inputBottomConstraint?.constant = -lift - 10
        scrollView.contentInset.bottom = lift + 92
        scrollView.verticalScrollIndicatorInsets.bottom = lift + 92
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func dropCreamInput(_ note: Notification) {
        inputBottomConstraint?.constant = -12
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func tapCreamSeat(_ sender: UIControl) {
        let index = sender.tag
        guard let seatPosition = creamState.seats.firstIndex(where: { $0.sugarIndex == index }) else { return }
        let seat = creamState.seats[seatPosition]
        if seat.isCreamEmpty {
            guard glazeSession.hasCreamMicGrant else {
                askCreamRecordGrant {
                    self.occupyCreamSeat(index)
                }
                return
            }
            occupyCreamSeat(index)
        } else if seat.isCurrentTaster {
            guard glazeSession.hasCreamMicGrant else {
                askCreamRecordGrant {
                    self.creamState.seats[seatPosition].isMicOpen.toggle()
                    self.refreshSeatCanvas()
                }
                return
            }
            creamState.seats[seatPosition].isMicOpen.toggle()
            refreshSeatCanvas()
        } else {
            if let guestKey = seat.guestKey {
                openGuestGlazeProfile(guestKey: guestKey)
            } else {
                showTinyHint("\(seat.tasterName ?? "This taster") is already on this seat.")
            }
        }
    }

    private func askCreamRecordGrant(onReady: @escaping () -> Void) {
        let grant = AVCaptureDevice.authorizationStatus(for: creamRecordFlavor)
        switch grant {
        case .authorized:
            glazeSession.markCreamMicGrant()
            onReady()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: creamRecordFlavor) { [weak self] allowed in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if allowed {
                        self.glazeSession.markCreamMicGrant()
                        onReady()
                    } else {
                        self.showTinyHint("Microphone permission was not granted.")
                    }
                }
            }
        default:
            showTinyHint("Enable microphone permission in Settings.")
        }
    }

    private func occupyCreamSeat(_ index: Int) {
        guard let seatPosition = creamState.seats.firstIndex(where: { $0.sugarIndex == index }) else { return }
        if let oldSeat = creamState.currentSeatIndex,
           let oldPosition = creamState.seats.firstIndex(where: { $0.sugarIndex == oldSeat }) {
            creamState.seats[oldPosition].isCreamEmpty = true
            creamState.seats[oldPosition].isCurrentTaster = false
            creamState.seats[oldPosition].tasterName = nil
            creamState.seats[oldPosition].guestKey = nil
            creamState.seats[oldPosition].isMicOpen = false
        }
        creamState.seats[seatPosition].isCreamEmpty = false
        creamState.seats[seatPosition].isCurrentTaster = true
        creamState.seats[seatPosition].tasterName = "You"
        creamState.seats[seatPosition].guestKey = nil
        creamState.seats[seatPosition].avatarSeed = 8
        creamState.seats[seatPosition].isMicOpen = false
        creamState.currentSeatIndex = index
        refreshSeatCanvas()
    }

    private func showCreamGrantLayer(for index: Int) {
        let layer = UIView()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.55)

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 22

        let title = makeRoomLabel("Allow mic access?", size: 18, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.18, alpha: 1))
        title.textAlignment = .center
        let body = makeRoomLabel("Use a local mic pass for this sweet room.", size: 13, weight: .medium, color: UIColor(red: 0.5, green: 0.43, blue: 0.52, alpha: 1))
        body.textAlignment = .center
        body.numberOfLines = 2
        let allow = makeGrantButton("Allow", fill: UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1), color: .white)
        let later = makeGrantButton("Not now", fill: UIColor(red: 0.92, green: 0.9, blue: 0.94, alpha: 1), color: UIColor(red: 0.24, green: 0.17, blue: 0.28, alpha: 1))
        allow.addAction(UIAction { [weak self] _ in
            self?.glazeSession.markCreamMicGrant()
            self?.hideCreamGrantLayer()
            self?.occupyCreamSeat(index)
        }, for: .touchUpInside)
        later.addAction(UIAction { [weak self] _ in
            self?.hideCreamGrantLayer()
        }, for: .touchUpInside)

        card.addSubview(title)
        card.addSubview(body)
        card.addSubview(allow)
        card.addSubview(later)
        layer.addSubview(card)
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            card.widthAnchor.constraint(equalToConstant: 284),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            body.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            allow.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 20),
            allow.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            allow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            allow.heightAnchor.constraint(equalToConstant: 48),
            later.topAnchor.constraint(equalTo: allow.bottomAnchor, constant: 10),
            later.leadingAnchor.constraint(equalTo: allow.leadingAnchor),
            later.trailingAnchor.constraint(equalTo: allow.trailingAnchor),
            later.heightAnchor.constraint(equalToConstant: 44),
            later.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22)
        ])
        grantLayer = layer
    }

    private func hideCreamGrantLayer() {
        grantLayer?.removeFromSuperview()
        grantLayer = nil
    }

    private func showTinyHint(_ text: String) {
        let hint = makeRoundText(text, fill: UIColor.black.withAlphaComponent(0.72), color: .white)
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.numberOfLines = 2
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: inputBar.topAnchor, constant: -14),
            hint.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.82),
            hint.heightAnchor.constraint(greaterThanOrEqualToConstant: 42)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.1, options: []) {
            hint.alpha = 0
        } completion: { _ in
            hint.removeFromSuperview()
        }
    }

    @objc private func sendCreamLine() {
        let cleanText = (inputField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            showTinyHint("Say something sweet first.")
            return
        }
        inputField.text = nil
        inputField.resignFirstResponder()
        let line = WevVSprinkleRoomLine(
            sprinkleKey: "sugarLine\(Date().timeIntervalSince1970)",
            tasterName: "You",
            crumbText: cleanText
        )
        roomLineStack.addArrangedSubview(makeRoomLineBubble(line))
        showTinyHint("Sent")
        view.layoutIfNeeded()
        let bottomOffset = max(0, scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.bottom)
        scrollView.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: true)
    }

    @objc private func toggleHostSugarFollow(_ sender: UIButton) {
        hostIsFollowed = guestStore.toggleGlazeFollow(for: creamState.hostGuestKey)
        sender.backgroundColor = hostIsFollowed ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1)
        sender.setImage(UIImage(systemName: hostIsFollowed ? "checkmark" : "plus"), for: .normal)
        showTinyHint(hostIsFollowed ? "Following \(creamState.hostName)" : "Follow removed")
    }

    @objc private func openHostSugarProfile() {
        openGuestGlazeProfile(guestKey: creamState.hostGuestKey)
    }

    private func openGuestGlazeProfile(guestKey: String) {
        let controller = WevVGuestGlazeProfileController(guestKey: guestKey)
        present(controller, animated: true)
    }

    @objc private func closeCreamRoom() {
        inputField.resignFirstResponder()
        dismiss(animated: true)
    }

    private func makeRoomLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    private func makeCircleButton(symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = fill
        button.tintColor = tint
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.layer.cornerRadius = 24
        return button
    }

    private func makeSendButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "wevv_room_send_glaze"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }

    private func makeRoundText(_ text: String, fill: UIColor, color: UIColor) -> UILabel {
        let label = makeRoomLabel(text, size: 13, weight: .heavy, color: color)
        label.backgroundColor = fill
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }

    private func makeGrantButton(_ text: String, fill: UIColor, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = fill
        button.layer.cornerRadius = 22
        return button
    }

    private func makeCreamAvatar(seed: Int, size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            let colors = [
                UIColor(red: 0.94, green: 0.53, blue: 0.62, alpha: 1),
                UIColor(red: 0.98, green: 0.74, blue: 0.38, alpha: 1),
                UIColor(red: 0.42, green: 0.72, blue: 0.92, alpha: 1),
                UIColor(red: 0.62, green: 0.48, blue: 0.94, alpha: 1),
                UIColor(red: 0.36, green: 0.82, blue: 0.65, alpha: 1)
            ]
            colors[seed % colors.count].setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size)).fill()
            UIColor.white.withAlphaComponent(0.95).setFill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.28, y: size * 0.16, width: size * 0.44, height: size * 0.44)).fill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.18, y: size * 0.58, width: size * 0.64, height: size * 0.3)).fill()
            UIColor(red: 0.18, green: 0.1, blue: 0.24, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.38, y: size * 0.33, width: size * 0.055, height: size * 0.055)).fill()
            UIBezierPath(ovalIn: CGRect(x: size * 0.56, y: size * 0.33, width: size * 0.055, height: size * 0.055)).fill()
            context.cgContext.setLineWidth(max(2, size * 0.025))
            context.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.38).cgColor)
            context.cgContext.move(to: CGPoint(x: size * 0.18, y: size * 0.72))
            context.cgContext.addCurve(to: CGPoint(x: size * 0.86, y: size * 0.24), control1: CGPoint(x: size * 0.34, y: size * 0.18), control2: CGPoint(x: size * 0.7, y: size * 0.92))
            context.cgContext.strokePath()
        }
    }

    private func makeGuestAvatar(guestKey: String?, seed: Int, size: CGFloat) -> UIImage {
        if let guestKey,
           let image = UIImage(named: guestStore.profile(for: guestKey).avatarAsset) {
            return image
        }
        return makeCreamAvatar(seed: seed, size: size)
    }

    private static func makeCreamState(roomKey: String, shopTitle: String) -> WevVCreamRoomState {
        let variant = abs(roomKey.hashValue) % 3
        let baseSeed = abs(shopTitle.hashValue % 9)
        let guestStore = WevVGuestGlazeStore.shared
        let hostProfile = guestStore.profile(at: variant)
        let secondProfile = guestStore.profile(at: variant + 1)
        let thirdProfile = guestStore.profile(at: variant + 2)
        let fourthProfile = guestStore.profile(at: variant + 3)
        let packets: (String, String, [WevVSprinkleRoomLine])
        switch variant {
        case 1:
            packets = (
                "8",
                "14",
                [
                    WevVSprinkleRoomLine(sprinkleKey: "powderCueOne", tasterName: secondProfile.name, crumbText: "Cinnamon glaze wins today."),
                    WevVSprinkleRoomLine(sprinkleKey: "powderCueTwo", tasterName: thirdProfile.name, crumbText: "I saved the last strawberry ring."),
                    WevVSprinkleRoomLine(sprinkleKey: "powderCueThree", tasterName: fourthProfile.name, crumbText: "Soft dough, bright icing, perfect bite.")
                ]
            )
        case 2:
            packets = (
                "16",
                "19",
                [
                    WevVSprinkleRoomLine(sprinkleKey: "berryCueOne", tasterName: secondProfile.name, crumbText: "The cocoa topping is richer than expected."),
                    WevVSprinkleRoomLine(sprinkleKey: "berryCueTwo", tasterName: thirdProfile.name, crumbText: "Maple cream should be the next pick."),
                    WevVSprinkleRoomLine(sprinkleKey: "berryCueThree", tasterName: fourthProfile.name, crumbText: "Someone rate the blueberry glaze.")
                ]
            )
        default:
            packets = (
                "12",
                "18",
                [
                    WevVSprinkleRoomLine(sprinkleKey: "sugarCueOne", tasterName: secondProfile.name, crumbText: "That pink glaze looks like summer."),
                    WevVSprinkleRoomLine(sprinkleKey: "sugarCueTwo", tasterName: thirdProfile.name, crumbText: "What topping would you pick next?"),
                    WevVSprinkleRoomLine(sprinkleKey: "sugarCueThree", tasterName: fourthProfile.name, crumbText: "Blueberry cream is quietly winning.")
                ]
            )
        }
        return WevVCreamRoomState(
            roomKey: roomKey,
            hostGuestKey: hostProfile.glazeKey,
            hostName: hostProfile.name,
            hostSeed: baseSeed,
            heatText: packets.0,
            crowdText: packets.1,
            seats: [
                WevVGlazeRoomSeat(sugarIndex: 1, guestKey: hostProfile.glazeKey, tasterName: hostProfile.name, avatarSeed: 1 + variant, isCreamEmpty: false, isCurrentTaster: false, isMicOpen: false),
                WevVGlazeRoomSeat(sugarIndex: 2, guestKey: secondProfile.glazeKey, tasterName: secondProfile.name, avatarSeed: 2 + variant, isCreamEmpty: false, isCurrentTaster: false, isMicOpen: false),
                WevVGlazeRoomSeat(sugarIndex: 3, guestKey: thirdProfile.glazeKey, tasterName: thirdProfile.name, avatarSeed: 3 + variant, isCreamEmpty: false, isCurrentTaster: false, isMicOpen: false),
                WevVGlazeRoomSeat(sugarIndex: 4, guestKey: nil, tasterName: nil, avatarSeed: 4, isCreamEmpty: true, isCurrentTaster: false, isMicOpen: false),
                WevVGlazeRoomSeat(sugarIndex: 5, guestKey: nil, tasterName: nil, avatarSeed: 5, isCreamEmpty: true, isCurrentTaster: false, isMicOpen: false),
                WevVGlazeRoomSeat(sugarIndex: 6, guestKey: nil, tasterName: nil, avatarSeed: 6, isCreamEmpty: true, isCurrentTaster: false, isMicOpen: false)
            ],
            roomLines: packets.2,
            currentSeatIndex: nil
        )
    }
}
