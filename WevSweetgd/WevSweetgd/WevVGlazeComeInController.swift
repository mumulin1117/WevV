import AVFoundation
import UIKit

final class WevVGlazeComeInController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private var creamState: WevVCreamDonuWeYeShrState
    private let creamScrollView = UIScrollView()
    private let creamContentView = UIView()
    private let creamSeatCanvas = UIView()
    private let creamInputBar = UIView()
    private let creamInputField = UITextField()
    private let roomLineStack = UIStackView()
    private var inputBottomConstraint: NSLayoutConstraint?
    private var seatViews: [Int: UIControl] = [:]
    private var grantLayer: UIView?
    private var hostIsFollowed = false
    private let creamRecordFlavor = AVMediaType(rawValue: "s*oNufn^".wevVPastryCrumbBloomRestored)

    init(roomKey: String, shopTitle: String) {
        creamState = WevVGlazeComeInController.makeCreamState(roomKey: roomKey, shopTitle: shopTitle)
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
        creamScrollView.translatesAutoresizingMaskIntoConstraints = false
        creamScrollView.showsVerticalScrollIndicator = false
        creamScrollView.keyboardDismissMode = .interactive
        view.addSubview(creamScrollView)

        creamContentView.translatesAutoresizingMaskIntoConstraints = false
        creamScrollView.addSubview(creamContentView)

        let topBar = makeTopBar()
        creamSeatCanvas.translatesAutoresizingMaskIntoConstraints = false
        let hintCard = makeHintCard()
        configureRoomLineStack()

        creamContentView.addSubview(topBar)
        creamContentView.addSubview(creamSeatCanvas)
        creamContentView.addSubview(hintCard)
        creamContentView.addSubview(roomLineStack)

        NSLayoutConstraint.activate([
            creamScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            creamScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creamScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            creamScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            creamContentView.topAnchor.constraint(equalTo: creamScrollView.contentLayoutGuide.topAnchor),
            creamContentView.leadingAnchor.constraint(equalTo: creamScrollView.contentLayoutGuide.leadingAnchor),
            creamContentView.trailingAnchor.constraint(equalTo: creamScrollView.contentLayoutGuide.trailingAnchor),
            creamContentView.bottomAnchor.constraint(equalTo: creamScrollView.contentLayoutGuide.bottomAnchor),
            creamContentView.widthAnchor.constraint(equalTo: creamScrollView.frameLayoutGuide.widthAnchor),
            topBar.topAnchor.constraint(equalTo: creamContentView.topAnchor, constant: 14),
            topBar.leadingAnchor.constraint(equalTo: creamContentView.leadingAnchor, constant: 14),
            topBar.trailingAnchor.constraint(equalTo: creamContentView.trailingAnchor, constant: -14),
            topBar.heightAnchor.constraint(equalToConstant: 62),
            creamSeatCanvas.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 14),
            creamSeatCanvas.leadingAnchor.constraint(equalTo: creamContentView.leadingAnchor, constant: 10),
            creamSeatCanvas.trailingAnchor.constraint(equalTo: creamContentView.trailingAnchor, constant: -10),
            creamSeatCanvas.heightAnchor.constraint(equalToConstant: 332),
            hintCard.topAnchor.constraint(equalTo: creamSeatCanvas.bottomAnchor, constant: 18),
            hintCard.leadingAnchor.constraint(equalTo: creamContentView.leadingAnchor, constant: 10),
            hintCard.trailingAnchor.constraint(lessThanOrEqualTo: creamContentView.trailingAnchor, constant: -10),
            roomLineStack.topAnchor.constraint(equalTo: hintCard.bottomAnchor, constant: 14),
            roomLineStack.leadingAnchor.constraint(equalTo: creamContentView.leadingAnchor, constant: 10),
            roomLineStack.trailingAnchor.constraint(equalTo: creamContentView.trailingAnchor, constant: -88),
            roomLineStack.bottomAnchor.constraint(equalTo: creamContentView.bottomAnchor, constant: -110)
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

        let creamName = makeRoomLabel(hostProfile.name, size: 17, weight: .heavy, color: .white)
        creamName.lineBreakMode = .byTruncatingTail

        let heat = makeRoomLabel("🔥  \(creamState.heatDonuWeYeText)", size: 12, weight: .semibold, color: UIColor.white.withAlphaComponent(0.9))

        let follow = makeCircleButton(
            symbol: hostIsFollowed ? "checkmark" : "polRu*sB".wevVPastryCrumbBloomRestored,
            fill: hostIsFollowed ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1),
            tint: .white
        )
        follow.layer.cornerRadius = 11.5
        follow.setPreferredSymbolConfiguration(.init(pointSize: 13, weight: .bold), forImageIn: .normal)
        follow.addTarget(self, action: #selector(toggleHostSugarFollow(_:)), for: .touchUpInside)
        let crowd = makeRoundText(creamState.crowdText, fill: UIColor(red: 0.1, green: 0.04, blue: 0.24, alpha: 0.78), color: .white)
        let safety = makeCircleButton(
            symbol: "fNl;amgl.Hf~i=lGlZ".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.1, green: 0.04, blue: 0.24, alpha: 0.78),
            tint: .white
        )
        safety.addTarget(self, action: #selector(openRoomSafetyPrompt), for: .touchUpInside)
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.tintColor = .white
        doughClose.addTarget(self, action: #selector(closeCreamRoom), for: .touchUpInside)

        placeRoomTopBarViews(bar: bar, avatarButton: avatarButton, name: creamName, heat: heat, follow: follow, crowd: crowd, safety: safety, close: doughClose)
        pinRoomTopBar(bar: bar, avatarButton: avatarButton, avatar: avatar, name: creamName, heat: heat, follow: follow, crowd: crowd, safety: safety, close: doughClose)
        return bar
    }

    private func placeRoomTopBarViews(bar: UIView, avatarButton: UIControl, name: UILabel, heat: UILabel, follow: UIButton, crowd: UILabel, safety: UIButton, close: UIButton) {
        bar.addSubview(avatarButton)
        bar.addSubview(name)
        bar.addSubview(heat)
        bar.addSubview(follow)
        bar.addSubview(crowd)
        bar.addSubview(safety)
        bar.addSubview(close)
    }

    private func pinRoomTopBar(bar: UIView, avatarButton: UIControl, avatar: UIImageView, name: UILabel, heat: UILabel, follow: UIButton, crowd: UILabel, safety: UIButton, close: UIButton) {
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
            follow.widthAnchor.constraint(equalToConstant: 23),
            follow.heightAnchor.constraint(equalToConstant: 23),
            crowd.centerYAnchor.constraint(equalTo: follow.centerYAnchor),
            crowd.trailingAnchor.constraint(equalTo: safety.leadingAnchor, constant: -10),
            crowd.widthAnchor.constraint(equalToConstant: 48),
            crowd.heightAnchor.constraint(equalToConstant: 48),
            safety.centerYAnchor.constraint(equalTo: follow.centerYAnchor),
            safety.trailingAnchor.constraint(equalTo: close.leadingAnchor, constant: -10),
            safety.widthAnchor.constraint(equalToConstant: 42),
            safety.heightAnchor.constraint(equalToConstant: 42),
            close.centerYAnchor.constraint(equalTo: follow.centerYAnchor),
            close.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            close.widthAnchor.constraint(equalToConstant: 42),
            close.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func refreshSeatCanvas() {
        creamSeatCanvas.subviews.forEach { $0.removeFromSuperview() }
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

        creamSeatCanvas.addSubview(firstSeat)
        creamSeatCanvas.addSubview(secondColumn)
        creamSeatCanvas.addSubview(lowerRow)

        NSLayoutConstraint.activate([
            firstSeat.topAnchor.constraint(equalTo: creamSeatCanvas.topAnchor),
            firstSeat.leadingAnchor.constraint(equalTo: creamSeatCanvas.leadingAnchor),
            firstSeat.widthAnchor.constraint(equalTo: creamSeatCanvas.widthAnchor, multiplier: 0.66),
            firstSeat.heightAnchor.constraint(equalToConstant: 218),
            secondColumn.topAnchor.constraint(equalTo: creamSeatCanvas.topAnchor),
            secondColumn.leadingAnchor.constraint(equalTo: firstSeat.trailingAnchor, constant: 6),
            secondColumn.trailingAnchor.constraint(equalTo: creamSeatCanvas.trailingAnchor),
            secondColumn.heightAnchor.constraint(equalTo: firstSeat.heightAnchor),
            lowerRow.topAnchor.constraint(equalTo: firstSeat.bottomAnchor, constant: 10),
            lowerRow.leadingAnchor.constraint(equalTo: creamSeatCanvas.leadingAnchor),
            lowerRow.trailingAnchor.constraint(equalTo: creamSeatCanvas.trailingAnchor),
            lowerRow.bottomAnchor.constraint(equalTo: creamSeatCanvas.bottomAnchor)
        ])
    }

    private enum SeatFlavor {
        case large
        case small
        case empty
    }

    private func makeSeatView(_ seat: WevVGlazeDonuWeYeSeat, style: SeatFlavor) -> UIControl {
        let seatView = UIControl()
        seatView.translatesAutoresizingMaskIntoConstraints = false
        seatView.tag = seat.sugarIndex
        seatView.layer.cornerRadius = 12
        seatView.layer.borderWidth = seat.isCreamEmpty ? 1.2 : 0
        seatView.layer.borderColor = UIColor.white.withAlphaComponent(0.26).cgColor
        seatView.clipsToBounds = true
        seatView.addTarget(self, action: #selector(tapCreamSeat(_:)), for: .touchUpInside)
        seatViews[seat.sugarIndex] = seatView

        let sugarIndexLabel = makeRoomLabel("\(seat.sugarIndex)", size: 16, weight: .semibold, color: .white)
        let sprinkleAddButton = makeCircleButton(symbol: "p%lou^sR".wevVPastryCrumbBloomRestored, fill: UIColor(red: 0.24, green: 0.18, blue: 0.54, alpha: 0.72), tint: .white)
        sprinkleAddButton.isUserInteractionEnabled = false

        seatView.addSubview(sugarIndexLabel)
        NSLayoutConstraint.activate([
            sugarIndexLabel.topAnchor.constraint(equalTo: seatView.topAnchor, constant: 12),
            sugarIndexLabel.leadingAnchor.constraint(equalTo: seatView.leadingAnchor, constant: 13)
        ])

        if seat.isCreamEmpty {
            pinEmptyCreamSeat(seatView: seatView, add: sprinkleAddButton)
            return seatView
        }

        let glazeImage = makeCreamSeatImage(seat, style: style)
        let sugarShade = makeCreamSeatShade()
        let creamName = makeCreamSeatName(seat, style: style)
        let mic = makeMicBadge(isOpen: seat.isMicOpen, isCurrent: seat.isCurrentDonuWeYeTaster)
        placeCreamSeatViews(seatView: seatView, glazeImage: glazeImage, shade: sugarShade, name: creamName, mic: mic, number: sugarIndexLabel)
        pinCreamSeatViews(seatView: seatView, glazeImage: glazeImage, shade: sugarShade, name: creamName, mic: mic)
        return seatView
    }

    private func makeCreamSeatImage(_ seat: WevVGlazeDonuWeYeSeat, style: SeatFlavor) -> UIImageView {
        let glazeImage = UIImageView(image: makeGuestAvatar(guestKey: seat.guestDonuWeYeKey, seed: seat.avatarSeed, size: style == .large ? 220 : 120))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        return glazeImage
    }

    private func makeCreamSeatShade() -> UIView {
        let sugarShade = UIView()
        sugarShade.translatesAutoresizingMaskIntoConstraints = false
        sugarShade.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        return sugarShade
    }

    private func makeCreamSeatName(_ seat: WevVGlazeDonuWeYeSeat, style: SeatFlavor) -> UILabel {
        let crumbLabel = makeRoomLabel(seat.tasterName ?? "TZa@svtHehrd".wevVPastryCrumbBloomRestored, size: style == .large ? 19 : 16, weight: .heavy, color: .white)
        crumbLabel.lineBreakMode = .byTruncatingTail
        return crumbLabel
    }

    private func pinEmptyCreamSeat(seatView: UIControl, add: UIButton) {
        seatView.addSubview(add)
        NSLayoutConstraint.activate([
            add.centerXAnchor.constraint(equalTo: seatView.centerXAnchor),
            add.centerYAnchor.constraint(equalTo: seatView.centerYAnchor),
            add.widthAnchor.constraint(equalToConstant: 48),
            add.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func placeCreamSeatViews(seatView: UIControl, glazeImage: UIImageView, shade: UIView, name: UILabel, mic: UIView, number: UILabel) {
        seatView.addSubview(glazeImage)
        seatView.addSubview(shade)
        seatView.addSubview(name)
        seatView.addSubview(mic)
        seatView.bringSubviewToFront(number)
    }

    private func pinCreamSeatViews(seatView: UIControl, glazeImage: UIImageView, shade: UIView, name: UILabel, mic: UIView) {
        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: seatView.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: seatView.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: seatView.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: seatView.bottomAnchor),
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
    }

    private func makeMicBadge(isOpen: Bool, isCurrent: Bool) -> UIView {
        let badge = UIView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = isOpen ? UIColor(red: 1, green: 0.14, blue: 0.62, alpha: 1) : UIColor.black.withAlphaComponent(isCurrent ? 0.86 : 0.92)
        badge.layer.cornerRadius = 18

        let iconName = isOpen ? "mic.fill" : "mjiVco.gsjlcaDschY.PfEi#lrl@".wevVPastryCrumbBloomRestored
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
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.layer.cornerRadius = 14
        pastryCard.layer.borderWidth = 1.1
        pastryCard.layer.borderColor = UIColor(red: 0.35, green: 0.87, blue: 1, alpha: 0.95).cgColor
        pastryCard.backgroundColor = UIColor(red: 0.25, green: 0.38, blue: 0.95, alpha: 0.34)

        let sugarText = makeRoomLabel("Pick Your Role And Speak Your Part.\nEvery Voice Shapes The Story.\nWelcome To Our Voice Theater.", size: 14, weight: .medium, color: .white)
        sugarText.numberOfLines = 3
        pastryCard.addSubview(sugarText)
        NSLayoutConstraint.activate([
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
            sugarText.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 11),
            sugarText.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 14),
            sugarText.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14),
            sugarText.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -11)
        ])
        return pastryCard
    }

    private func configureRoomLineStack() {
        roomLineStack.translatesAutoresizingMaskIntoConstraints = false
        roomLineStack.axis = .vertical
        roomLineStack.spacing = 12
        creamState.roDonuWeYeLines.forEach { roomLineStack.addArrangedSubview(makeRoomLineBubble($0)) }
    }

    private func makeRoomLineBubble(_ line: WevVSprinkleDonuWeYeRoLine) -> UIView {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.backgroundColor = UIColor(red: 0.62, green: 0.84, blue: 1, alpha: 0.34)
        bubble.layer.cornerRadius = 14
        bubble.layer.borderWidth = 1
        bubble.layer.borderColor = UIColor(red: 0.1, green: 0.2, blue: 0.62, alpha: 0.75).cgColor

        let sugarText = makeRoomLabel("\(line.tasterDonuWeYeName): \(line.crumbText)", size: 14, weight: .medium, color: .white)
        sugarText.numberOfLines = 0
        if let value = sugarText.text {
            let packet = NSMutableAttributedString(string: value)
            let nameRange = (value as NSString).range(of: "\(line.tasterDonuWeYeName):")
            packet.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .heavy), range: nameRange)
            sugarText.attributedText = packet
        }
        bubble.addSubview(sugarText)
        NSLayoutConstraint.activate([
            bubble.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            sugarText.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            sugarText.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
            sugarText.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12),
            sugarText.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10)
        ])
        return bubble
    }

    private func buildInputBar() {
        creamInputBar.translatesAutoresizingMaskIntoConstraints = false
        creamInputBar.backgroundColor = UIColor(red: 0.3, green: 0.16, blue: 0.6, alpha: 0.62)
        creamInputBar.layer.cornerRadius = 28
        view.addSubview(creamInputBar)

        creamInputField.translatesAutoresizingMaskIntoConstraints = false
        creamInputField.borderStyle = .none
        creamInputField.textColor = .white
        creamInputField.font = .systemFont(ofSize: 17, weight: .heavy)
        creamInputField.attributedPlaceholder = NSAttributedString(
            string: "SkaOyk vhMiw~:".wevVPastryCrumbBloomRestored,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.76)]
        )

        let sprinkleSendButton = makeSendButton()
        sprinkleSendButton.addTarget(self, action: #selector(sendCreamLine), for: .touchUpInside)
        creamInputBar.addSubview(creamInputField)
        view.addSubview(sprinkleSendButton)

        inputBottomConstraint = creamInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([
            creamInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            creamInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            inputBottomConstraint!,
            creamInputBar.heightAnchor.constraint(equalToConstant: 56),
            creamInputField.leadingAnchor.constraint(equalTo: creamInputBar.leadingAnchor, constant: 24),
            creamInputField.centerYAnchor.constraint(equalTo: creamInputBar.centerYAnchor),
            creamInputField.trailingAnchor.constraint(equalTo: sprinkleSendButton.leadingAnchor, constant: -12),
            sprinkleSendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            sprinkleSendButton.centerYAnchor.constraint(equalTo: creamInputBar.centerYAnchor),
            sprinkleSendButton.widthAnchor.constraint(equalToConstant: 48),
            sprinkleSendButton.heightAnchor.constraint(equalToConstant: 48)
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
        creamScrollView.contentInset.bottom = lift + 92
        creamScrollView.verticalScrollIndicatorInsets.bottom = lift + 92
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func dropCreamInput(_ note: Notification) {
        inputBottomConstraint?.constant = -12
        creamScrollView.contentInset.bottom = 0
        creamScrollView.verticalScrollIndicatorInsets.bottom = 0
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
        } else if seat.isCurrentDonuWeYeTaster {
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
            if let guestKey = seat.guestDonuWeYeKey {
                openGuestGlazeProfile(guestKey: guestKey)
            } else {
                showTinyHint("\(seat.tasterName ?? "This taster")d =iSsb ia?lUrUezardBy^ .o*nH NtKh#i/st Bsyexadti.^".wevVPastryCrumbBloomRestored)
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
                        self.showTinyHint("MGircNrIo^p=hfoqn+eV ypseXr^mei~sKsbiGoGnH LwQaOss ?n&ortg ^gbrIaDngt.e*du.:".wevVPastryCrumbBloomRestored)
                    }
                }
            }
        default:
            showTinyHint("Ehn@aSbClIeu nmFiQcurkorpzh,o&nmed @pZeWrQmxiZsBsWiZo#nB BiBnl BSYewtutLiTnOgws,.R".wevVPastryCrumbBloomRestored)
        }
    }

    private func occupyCreamSeat(_ index: Int) {
        guard let seatPosition = creamState.seats.firstIndex(where: { $0.sugarIndex == index }) else { return }
        if let oldSeat = creamState.currentSeatIndex,
           let oldPosition = creamState.seats.firstIndex(where: { $0.sugarIndex == oldSeat }) {
            creamState.seats[oldPosition].isCreamEmpty = true
            creamState.seats[oldPosition].isCurrentDonuWeYeTaster = false
            creamState.seats[oldPosition].tasterName = nil
            creamState.seats[oldPosition].guestDonuWeYeKey = nil
            creamState.seats[oldPosition].isMicOpen = false
        }
        creamState.seats[seatPosition].isCreamEmpty = false
        creamState.seats[seatPosition].isCurrentDonuWeYeTaster = true
        creamState.seats[seatPosition].tasterName = "Y&oWu#".wevVPastryCrumbBloomRestored
        creamState.seats[seatPosition].guestDonuWeYeKey = nil
        creamState.seats[seatPosition].avatarSeed = 8
        creamState.seats[seatPosition].isMicOpen = false
        creamState.currentSeatIndex = index
        refreshSeatCanvas()
    }

    private func showCreamGrantLayer(for index: Int) {
        let layer = UIView()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.55)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 22

        let glazeTitle = makeRoomLabel("Agl/l&o@wt qmiiJcN QaYcCcRe:sXsU?m".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.18, alpha: 1))
        glazeTitle.textAlignment = .center
        let body = makeRoomLabel("UqsJeF fas llEo@cGaLlC gmeiWcK Apkazsvs^ UfKoOrr .t.heicsz zs^w:eGe;tw FrRoXoQmr.G".wevVPastryCrumbBloomRestored, size: 13, weight: .medium, color: UIColor(red: 0.5, green: 0.43, blue: 0.52, alpha: 1))
        body.textAlignment = .center
        body.numberOfLines = 2
        let allow = makeGrantButton("A~l#l?onwo".wevVPastryCrumbBloomRestored, fill: UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1), color: .white)
        let later = makeGrantButton("NooUt* anCo;wJ".wevVPastryCrumbBloomRestored, fill: UIColor(red: 0.92, green: 0.9, blue: 0.94, alpha: 1), color: UIColor(red: 0.24, green: 0.17, blue: 0.28, alpha: 1))
        allow.addAction(UIAction { [weak self] _ in
            self?.glazeSession.markCreamMicGrant()
            self?.hideCreamGrantLayer()
            self?.occupyCreamSeat(index)
        }, for: .touchUpInside)
        later.addAction(UIAction { [weak self] _ in
            self?.hideCreamGrantLayer()
        }, for: .touchUpInside)

        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(body)
        pastryCard.addSubview(allow)
        pastryCard.addSubview(later)
        layer.addSubview(pastryCard)
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            pastryCard.widthAnchor.constraint(equalToConstant: 284),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 24),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 20),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -20),
            body.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 10),
            body.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            allow.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 20),
            allow.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 24),
            allow.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24),
            allow.heightAnchor.constraint(equalToConstant: 48),
            later.topAnchor.constraint(equalTo: allow.bottomAnchor, constant: 10),
            later.leadingAnchor.constraint(equalTo: allow.leadingAnchor),
            later.trailingAnchor.constraint(equalTo: allow.trailingAnchor),
            later.heightAnchor.constraint(equalToConstant: 44),
            later.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -22)
        ])
        grantLayer = layer
    }

    private func hideCreamGrantLayer() {
        grantLayer?.removeFromSuperview()
        grantLayer = nil
    }

    private func showTinyHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: creamInputBar, bottomOffset: -14)
    }

    @objc private func sendCreamLine() {
        let cleanText = (creamInputField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            showTinyHint("SJaMyb Gsmo,mNextXhvi:n.gM usWwde*edtK xfOiqrvspty.w".wevVPastryCrumbBloomRestored)
            return
        }
        creamInputField.text = nil
        creamInputField.resignFirstResponder()
        let line = WevVSprinkleDonuWeYeRoLine(
            sprinkleKey: "sugarLine\(Date().timeIntervalSince1970)",
            tasterDonuWeYeName: "Ytomui".wevVPastryCrumbBloomRestored,
            crumbText: cleanText
        )
        roomLineStack.addArrangedSubview(makeRoomLineBubble(line))
        showTinyHint("SKehnatK".wevVPastryCrumbBloomRestored)
        view.layoutIfNeeded()
        let bottomOffset = max(0, creamScrollView.contentSize.height - creamScrollView.bounds.height + creamScrollView.adjustedContentInset.bottom)
        creamScrollView.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: true)
    }

    @objc private func toggleHostSugarFollow(_ sender: UIButton) {
        hostIsFollowed = guestStore.toggleGlazeFollow(for: creamState.hostGuestKey)
        sender.backgroundColor = hostIsFollowed ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1)
        sender.setImage(UIImage(systemName: hostIsFollowed ? "checkmark" : "plus"), for: .normal)
        showTinyHint(hostIsFollowed ? "Following \(creamState.hostDonuWeYeName)" : "FBoilMleoCwQ krzeOmwojvBeHdK".wevVPastryCrumbBloomRestored)
    }

    @objc private func openHostSugarProfile() {
        openGuestGlazeProfile(guestKey: creamState.hostGuestKey)
    }

    @objc private func openRoomSafetyPrompt() {
        guard glazeSession.isTasterReady else {
            showTinyHint("PplHe:aBs/eP PlPoKgd wisnD WfRi@rds/tf.A".wevVPastryCrumbBloomRestored)
            return
        }
        WevVGlazePromptStyler.showSugarConfirm(
            in: view,
            title: "R,e@p!o~rUtQ ytchMi@s/ ~r/ohoTmG?p".wevVPastryCrumbBloomRestored,
            note: "WIeo NwHiCl.lL OszaQvoeO HtjhQiMs~ xrJoFo!mn *fYoWrE csOaDfyebtrya Zr:eSv~iletw^ BaEncdZ qheiPdBey ;s/iQmfisl!aIr% as;wVeFeWtu acNrcuDmNbfs% XwRhce:n: &nVeDeddhebds.H".wevVPastryCrumbBloomRestored,
            confirmTitle: "R/eYpKomr?tp".wevVPastryCrumbBloomRestored,
            cancelTitle: "Cra:nQcUebl.".wevVPastryCrumbBloomRestored,
            confirmFill: UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1)
        ) { [weak self] in
            guard let self else { return }
            WevVBakeryExchange.spin(in: self.view, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) {
                self.glazeSession.placeRoomSafetyCrumb(
                    roomKey: self.creamState.roomDonuWeYeKey,
                    hostKey: self.creamState.hostGuestKey,
                    reasonText: "RcoioNmG hs%a#fee.tGyM zroeyvPiIeKwL".wevVPastryCrumbBloomRestored
                )
                self.showTinyHint("RNeXpPobrWtn LsLutbxm@iHtPtQemdi".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func openGuestGlazeProfile(guestKey: String) {
        let controller = WevVGuestGlazeProfileController(guestKey: guestKey)
        present(controller, animated: true)
    }

    @objc private func closeCreamRoom() {
        creamInputField.resignFirstResponder()
        dismiss(animated: true)
    }

    private func makeRoomLabel(_ sugarText: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarText
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func makeCircleButton(symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.backgroundColor = fill
        sprinkleButton.tintColor = tint
        sprinkleButton.setImage(UIImage(systemName: symbol), for: .normal)
        sprinkleButton.layer.cornerRadius = 24
        return sprinkleButton
    }

    private func makeSendButton() -> UIButton {
        let sprinkleButton = UIButton(type: .custom)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(named: "wevv_room_send_glaze"), for: .normal)
        sprinkleButton.imageView?.contentMode = .scaleAspectFit
        return sprinkleButton
    }

    private func makeRoundText(_ sugarText: String, fill: UIColor, color: UIColor) -> UILabel {
        let crumbLabel = makeRoomLabel(sugarText, size: 13, weight: .heavy, color: color)
        crumbLabel.backgroundColor = fill
        crumbLabel.textAlignment = .center
        crumbLabel.layer.cornerRadius = 20
        crumbLabel.clipsToBounds = true
        return crumbLabel
    }

    private func makeGrantButton(_ sugarText: String, fill: UIColor, color: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(sugarText, for: .normal)
        sprinkleButton.setTitleColor(color, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        sprinkleButton.backgroundColor = fill
        sprinkleButton.layer.cornerRadius = 22
        return sprinkleButton
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
           let glazeImage = UIImage(named: guestStore.profile(for: guestKey).donutAvatarAsset) {
            return glazeImage
        }
        return makeCreamAvatar(seed: seed, size: size)
    }

    private static func makeCreamState(roomKey: String, shopTitle: String) -> WevVCreamDonuWeYeShrState {
        let guestStore = WevVGuestGlazeStore.shared
        let packet = makeCreamRoomPacket(roomKey: roomKey, guestStore: guestStore)
        let hostProfile = guestStore.profile(for: packet.0)
        let secondProfile = guestStore.profile(for: packet.1)
        let thirdProfile = guestStore.profile(for: packet.2)
        return WevVCreamDonuWeYeShrState(
            roomDonuWeYeKey: roomKey,
            hostGuestKey: hostProfile.glazeKey,
            hostDonuWeYeName: hostProfile.name,
            hostSeed: abs(shopTitle.hashValue % 9),
            heatDonuWeYeText: packet.4,
            crowdText: packet.5,
            seats: makeCreamRoomSeats(hostProfile: hostProfile, secondProfile: secondProfile, thirdProfile: thirdProfile),
            roDonuWeYeLines: packet.6,
            currentSeatIndex: nil
        )
    }

    private static func makeCreamRoomPacket(roomKey: String, guestStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        switch roomKey {
        case "berryRingBakery":
            return berryCreamRoomPacket(guestStore: guestStore)
        case "goldenDoughStudio":
            return goldenCreamRoomPacket(guestStore: guestStore)
        case "moonlightDonutBar":
            return moonlightCreamRoomPacket(guestStore: guestStore)
        default:
            return classicCreamRoomPacket(guestStore: guestStore)
        }
    }

    private static func berryCreamRoomPacket(guestStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("lVoVumiRs/evS~aMnbtDoSsB".wevVPastryCrumbBloomRestored, "mwiNaoPfiJn;krSDuXgBaCre".wevVPastryCrumbBloomRestored, "m:ats&oHnwGAlJaUzOeySRm,iFlNeJ".wevVPastryCrumbBloomRestored, "n+o,rKaeCmrkeEaImyRBiPn&g%".wevVPastryCrumbBloomRestored, "9J".wevVPastryCrumbBloomRestored, "4x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "b+esrurWy+ByaUtlcgh?O;n@e;".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "mAiiawP%i?ntk=S@uZgAaJrb".wevVPastryCrumbBloomRestored).name, crumbText: "SYtGrraUw*b,e^rGray~ dgYlGa.zje, afseYeylKsN ~eHxutbrLam XflrvensOhK rt~ojd?a*y/.S".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "bceVr!rmyNB^aGtTcRhDTjw&o*".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "m+apsuo:nUGTlwayzbevSvmViZlle+".wevVPastryCrumbBloomRestored).name, crumbText: "It uwWoxuPlpdH rpMaViOrI ?txhoi;sk hbhaJtackhu NwWiJtTh; gvtagn^islVlta~ Zcqr?eVavm!.m".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "b#eMrurNyRBhaVtWcXhUT#h#rheje,".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "n;oSrba~CrrZecaVmuRziNnsg#".wevVPastryCrumbBloomRestored).name, crumbText: "TThJeh nhTaBn/dlmcaed^en brKiin.g#s! ilZoEoOk^ Qs,opf=tw =a:nVdT rcsoizcyb.=".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func goldenCreamRoomPacket(guestStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("sjoQruaIC,rFe%awmVG,l^avzjeW".wevVPastryCrumbBloomRestored, "pMoqp!p;yiSzumnVGMl!aKzCeF".wevVPastryCrumbBloomRestored, "bnehlUlzauS+pkrHienfkSlcey".wevVPastryCrumbBloomRestored, "a.rQlOoZS%k%y?G%lraTzYe,".wevVPastryCrumbBloomRestored, "1I2e".wevVPastryCrumbBloomRestored, "3x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "gZoglodieEnSBHaVtSc~hEOBnKeV".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "bjeslulFabSVpkrzi;n;khlNeC".wevVPastryCrumbBloomRestored).name, crumbText: "S?mEaulhl? qbkaJtjczhheas# Va!lawmaRypsH th~a^vde! RbLeFt/treorK UtQewxDt*ulrqew.Q".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "gvoclQdueSnIBwalt~cyhsTkwhoL".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "afrDlnodSuk#yvGvl;a:zfeR".wevVPastryCrumbBloomRestored).name, crumbText: "G%ohlCdRe/ni ?d#ocueg/hO bw+imtzhQ yaDltmTo=nzd: VcIrlu&n%clho %wOo,u*lKdq GbJey YpLeurcfqexc^t~.e".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "gposludPeRnmBNa,tpcvhbTbhVrYeFeJ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "sUovraaPCVrNeoaXm!GIlXa/zaev".wevVPastryCrumbBloomRestored).name, crumbText: "FuroeCs,hw vtlrkaRyEsO xmDakk.eH Ht!hneB ww;hVoFlbe^ lcqo#uSnAt,eYrG qsphDiknQey.E".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func moonlightCreamRoomPacket(guestStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("mTiDrYaUPxutrepzlheyGklQa^zkee".wevVPastryCrumbBloomRestored, "aWv^aRC/oEcUoNaeRJiwnZgo".wevVPastryCrumbBloomRestored, "lSuknea@LVayu&guh~GtlSawzsep".wevVPastryCrumbBloomRestored, "nfoAvSaxB.u&b:bAlTeUGUlpaszBe^".wevVPastryCrumbBloomRestored, "1U6~".wevVPastryCrumbBloomRestored, "2x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "m*oAolnjl=iCgRhJt.BGa:t;cxhEO%nIe=".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "a/vaaICMoyc=oqavRdisnsg&".wevVPastryCrumbBloomRestored).name, crumbText: "C/olfCf*eLeU igoltaTzxer vf@iHt~s? =tQh@eC RlFaGt@ev-pnOitgShgtx lmmovofd..r".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "mEo~ovnplOiygihCtNBNalt:cfhXT^w~oQ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "lGuvnIaHLVa#uXgJhpGYldaAzoeD".wevVPastryCrumbBloomRestored).name, crumbText: "C#r&eEaXtji.vTe^ ^durpifn~kwsy PnFeTeQdb Ba. Gc+oacaoTak .cErPuYm/bk AsEiIdYeJ.F".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "m%o&oWntlpiPgxhvtEBjaktNcphxTmh.rve%eQ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "njoRvJaDBwu?b+bwl:e,G&lba#ztef".wevVPastryCrumbBloomRestored).name, crumbText: "I, QlWiQkoe. xt@hMeq Lr/e@lIaSxze^dD ~mMixd%nbi,gphYtN dbHa!k!eor#y: seTn#e+r!g=yA.!".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func classicCreamRoomPacket(guestStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("jvaHmtideACzo/lCeo".wevVPastryCrumbBloomRestored, "lNoAugiEsjeDSTamn~two,sd".wevVPastryCrumbBloomRestored, "mla#sXo~nDG&l@a:zQeJSlmXi~lReH".wevVPastryCrumbBloomRestored, "axvda&C~o:cnoPa/RNi=nSgS".wevVPastryCrumbBloomRestored, "1N1U".wevVPastryCrumbBloomRestored, "4x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "pGiPnSkmBVaTtFcwhIO.n!ea".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "l;oCuRiGsyeWSkasnytiopsz".wevVPastryCrumbBloomRestored).name, crumbText: "PYiCn?kj dg;l+amzseD SaZnjdW Mb&ecr.rcyy Gf@iIlMlWi^nQgh ga:rSeG Cap tcLlZahsqs@ikcg Wp^aziLrp.h".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "pmi:npk^BQact@c.h%TIw!ou".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "miazsxo:nFGglta+z!eaSfmjielIer".wevVPastryCrumbBloomRestored).name, crumbText: "TKhset SrLeWcdoOmfmje;n~deaWtIiDonnA .p^aVsKtVr:yhC#adrMdV ZmDaDd.em JmseQ :h,uXn:g.rcy,.~".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleKey: "p.ign.kkBJaBthclhnTChFrzeVeF".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: guestStore.profile(for: "atvKapCHoIczodaORkiunygr".wevVPastryCrumbBloomRestored).name, crumbText: "F&rveqsMhU Rslp,rdi#n:kflhevsZ +c@hDaenug!e; %tYh~eF .w;hYoglUeB Gb,idtdeW.X".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func makeCreamRoomSeats(hostProfile: WevVGuestGlazeProfile, secondProfile: WevVGuestGlazeProfile, thirdProfile: WevVGuestGlazeProfile) -> [WevVGlazeDonuWeYeSeat] {
        [
            WevVGlazeDonuWeYeSeat(sugarIndex: 1, guestDonuWeYeKey: hostProfile.glazeKey, tasterName: hostProfile.name, avatarSeed: 1, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 2, guestDonuWeYeKey: secondProfile.glazeKey, tasterName: secondProfile.name, avatarSeed: 2, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 3, guestDonuWeYeKey: thirdProfile.glazeKey, tasterName: thirdProfile.name, avatarSeed: 3, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 4, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 4, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 5, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 5, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 6, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 6, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false)
        ]
    }
}
