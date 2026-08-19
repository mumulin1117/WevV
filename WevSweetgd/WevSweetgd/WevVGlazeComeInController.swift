import AVFoundation
import UIKit

final class WevVWevvTastingParlorController: UIViewController {
    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvTasterStore = WevVGuestGlazeStore.shared
    private var wevvParlorState: WevVCreamDonuWeYeShrState
    private let wevvParlorScroll = UIScrollView()
    private let wevvParlorCanvas = UIView()
    private let wevvBenchCanvas = UIView()
    private let wevvTastingInputBar = UIView()
    private let wevvTastingInputField = UITextField()
    private let wevvTastingLineStack = UIStackView()
    private var wevvInputLiftConstraint: NSLayoutConstraint?
    private var wevvBenchViews: [Int: UIControl] = [:]
    private var wevvPastryGrantLayer: UIView?
    private var wevvHostTrailActive = false
    private let wevvPastryRecordKind = AVMediaType(rawValue: "s*oNufn^".wevVPastryCrumbBloomRestored)

    init(donutPinKey: String, bakeryTitle: String) {
        wevvParlorState = WevVWevvTastingParlorController.makeWevvParlorState(donutPinKey: donutPinKey, bakeryTitle: bakeryTitle)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildWevvParlorBackdrop()
        buildWevvParlorContent()
        buildWevvTastingInputBar()
        bindWevvKeyboardLift()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildWevvParlorBackdrop() {
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

    private func buildWevvParlorContent() {
        wevvParlorScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvParlorScroll.showsVerticalScrollIndicator = false
        wevvParlorScroll.keyboardDismissMode = .interactive
        view.addSubview(wevvParlorScroll)

        wevvParlorCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvParlorScroll.addSubview(wevvParlorCanvas)

        let topBar = makeWevvParlorTopBar()
        wevvBenchCanvas.translatesAutoresizingMaskIntoConstraints = false
        let hintCard = makeWevvHintCard()
        configureWevvTastingLineStack()

        wevvParlorCanvas.addSubview(topBar)
        wevvParlorCanvas.addSubview(wevvBenchCanvas)
        wevvParlorCanvas.addSubview(hintCard)
        wevvParlorCanvas.addSubview(wevvTastingLineStack)

        NSLayoutConstraint.activate([
            wevvParlorScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wevvParlorScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvParlorScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvParlorScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvParlorCanvas.topAnchor.constraint(equalTo: wevvParlorScroll.contentLayoutGuide.topAnchor),
            wevvParlorCanvas.leadingAnchor.constraint(equalTo: wevvParlorScroll.contentLayoutGuide.leadingAnchor),
            wevvParlorCanvas.trailingAnchor.constraint(equalTo: wevvParlorScroll.contentLayoutGuide.trailingAnchor),
            wevvParlorCanvas.bottomAnchor.constraint(equalTo: wevvParlorScroll.contentLayoutGuide.bottomAnchor),
            wevvParlorCanvas.widthAnchor.constraint(equalTo: wevvParlorScroll.frameLayoutGuide.widthAnchor),
            topBar.topAnchor.constraint(equalTo: wevvParlorCanvas.topAnchor, constant: 14),
            topBar.leadingAnchor.constraint(equalTo: wevvParlorCanvas.leadingAnchor, constant: 14),
            topBar.trailingAnchor.constraint(equalTo: wevvParlorCanvas.trailingAnchor, constant: -14),
            topBar.heightAnchor.constraint(equalToConstant: 62),
            wevvBenchCanvas.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 14),
            wevvBenchCanvas.leadingAnchor.constraint(equalTo: wevvParlorCanvas.leadingAnchor, constant: 10),
            wevvBenchCanvas.trailingAnchor.constraint(equalTo: wevvParlorCanvas.trailingAnchor, constant: -10),
            wevvBenchCanvas.heightAnchor.constraint(equalToConstant: 332),
            hintCard.topAnchor.constraint(equalTo: wevvBenchCanvas.bottomAnchor, constant: 18),
            hintCard.leadingAnchor.constraint(equalTo: wevvParlorCanvas.leadingAnchor, constant: 10),
            hintCard.trailingAnchor.constraint(lessThanOrEqualTo: wevvParlorCanvas.trailingAnchor, constant: -10),
            wevvTastingLineStack.topAnchor.constraint(equalTo: hintCard.bottomAnchor, constant: 14),
            wevvTastingLineStack.leadingAnchor.constraint(equalTo: wevvParlorCanvas.leadingAnchor, constant: 10),
            wevvTastingLineStack.trailingAnchor.constraint(equalTo: wevvParlorCanvas.trailingAnchor, constant: -88),
            wevvTastingLineStack.bottomAnchor.constraint(equalTo: wevvParlorCanvas.bottomAnchor, constant: -110)
        ])
        refreshWevvBenchCanvas()
    }

    private func makeWevvParlorTopBar() -> UIView {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        let wevvHostTaster = wevvTasterStore.profile(for: wevvParlorState.tasterBadgeKey)
        wevvHostTrailActive = wevvHostTaster.sugarTie.isGlazeFollowed

        let avatarButton = UIControl()
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.layer.cornerRadius = 26
        avatarButton.clipsToBounds = true
        avatarButton.addTarget(self, action: #selector(openHostDonutCard), for: .touchUpInside)

        let avatar = UIImageView(image: makeWevvTasterAvatar(tasterBadgeKey: wevvParlorState.tasterBadgeKey, seed: wevvParlorState.hostSeed, size: 52))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatarButton.addSubview(avatar)

        let donutTasterName = makeWevvParlorLabel(wevvHostTaster.cocoaCounter, size: 17, weight: .heavy, color: .white)
        donutTasterName.lineBreakMode = .byTruncatingTail

        let heat = makeWevvParlorLabel("🔥  \(wevvParlorState.heatDonuWeYeText)", size: 12, weight: .semibold, color: UIColor.white.withAlphaComponent(0.9))

        let glazeTrailButton = makeWevvRoundButton(
            symbol: wevvHostTrailActive ? "checkmark" : "polRu*sB".wevVPastryCrumbBloomRestored,
            fill: wevvHostTrailActive ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1),
            tint: .white
        )
        glazeTrailButton.layer.cornerRadius = 11.5
        glazeTrailButton.setPreferredSymbolConfiguration(.init(pointSize: 13, weight: .bold), forImageIn: .normal)
        glazeTrailButton.addTarget(self, action: #selector(toggleHostGlazeTrail(_:)), for: .touchUpInside)
        let crowd = makeWevvRoundText(wevvParlorState.tastingTableText, fill: UIColor(red: 0.1, green: 0.04, blue: 0.24, alpha: 0.78), color: .white)
        let noticeButton = makeWevvRoundButton(
            symbol: "fNl;amgl.Hf~i=lGlZ".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.1, green: 0.04, blue: 0.24, alpha: 0.78),
            tint: .white
        )
        noticeButton.addTarget(self, action: #selector(openParlorNoticePrompt), for: .touchUpInside)
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.tintColor = .white
        doughClose.addTarget(self, action: #selector(closeWevvTastingParlor), for: .touchUpInside)

        placeWevvParlorTopBarViews(bar: bar, avatarButton: avatarButton, name: donutTasterName, heat: heat, glazeTrailButton: glazeTrailButton, crowd: crowd, noticeButton: noticeButton, close: doughClose)
        pinWevvParlorTopBar(bar: bar, tastingJournal: avatarButton, tastingAtlas: avatar, sprinkleQuest: donutTasterName, nuttyQuest: heat, glazeTrailButton: glazeTrailButton, pastryScout: crowd, noticeButton: noticeButton, glazeScout: doughClose)
        return bar
    }

    private func placeWevvParlorTopBarViews(bar: UIView, avatarButton: UIControl, name: UILabel, heat: UILabel, glazeTrailButton: UIButton, crowd: UILabel, noticeButton: UIButton, close: UIButton) {
        bar.addSubview(avatarButton)
        bar.addSubview(name)
        bar.addSubview(heat)
        bar.addSubview(glazeTrailButton)
        bar.addSubview(crowd)
        bar.addSubview(noticeButton)
        bar.addSubview(close)
    }

    private func pinWevvParlorTopBar(bar: UIView, tastingJournal: UIControl, tastingAtlas: UIImageView, sprinkleQuest: UILabel, nuttyQuest: UILabel, glazeTrailButton: UIButton, pastryScout: UILabel, noticeButton: UIButton, glazeScout: UIButton) {
        NSLayoutConstraint.activate([
            tastingJournal.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            tastingJournal.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            tastingJournal.widthAnchor.constraint(equalToConstant: 52),
            tastingJournal.heightAnchor.constraint(equalToConstant: 52),
            tastingAtlas.topAnchor.constraint(equalTo: tastingJournal.topAnchor),
            tastingAtlas.leadingAnchor.constraint(equalTo: tastingJournal.leadingAnchor),
            tastingAtlas.trailingAnchor.constraint(equalTo: tastingJournal.trailingAnchor),
            tastingAtlas.bottomAnchor.constraint(equalTo: tastingJournal.bottomAnchor),
            sprinkleQuest.topAnchor.constraint(equalTo: tastingJournal.topAnchor, constant: 7),
            sprinkleQuest.leadingAnchor.constraint(equalTo: tastingJournal.trailingAnchor, constant: 7),
            sprinkleQuest.trailingAnchor.constraint(lessThanOrEqualTo: glazeTrailButton.leadingAnchor, constant: -8),
            nuttyQuest.topAnchor.constraint(equalTo: sprinkleQuest.bottomAnchor, constant: 5),
            nuttyQuest.leadingAnchor.constraint(equalTo: sprinkleQuest.leadingAnchor),
            glazeTrailButton.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            glazeTrailButton.leadingAnchor.constraint(greaterThanOrEqualTo: sprinkleQuest.trailingAnchor, constant: 8),
            glazeTrailButton.widthAnchor.constraint(equalToConstant: 23),
            glazeTrailButton.heightAnchor.constraint(equalToConstant: 23),
            pastryScout.centerYAnchor.constraint(equalTo: glazeTrailButton.centerYAnchor),
            pastryScout.trailingAnchor.constraint(equalTo: noticeButton.leadingAnchor, constant: -10),
            pastryScout.widthAnchor.constraint(equalToConstant: 48),
            pastryScout.heightAnchor.constraint(equalToConstant: 48),
            noticeButton.centerYAnchor.constraint(equalTo: glazeTrailButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: glazeScout.leadingAnchor, constant: -10),
            noticeButton.widthAnchor.constraint(equalToConstant: 42),
            noticeButton.heightAnchor.constraint(equalToConstant: 42),
            glazeScout.centerYAnchor.constraint(equalTo: glazeTrailButton.centerYAnchor),
            glazeScout.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            glazeScout.widthAnchor.constraint(equalToConstant: 42),
            glazeScout.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func refreshWevvBenchCanvas() {
        wevvBenchCanvas.subviews.forEach { $0.removeFromSuperview() }
        wevvBenchViews.removeAll()

        guard wevvParlorState.berryPress.count == 6 else { return }
        let firstSeat = makeWevvBenchView(wevvParlorState.berryPress[0], style: .wevvDozen)
        let secondSeat = makeWevvBenchView(wevvParlorState.berryPress[1], style: .wevvMini)
        let thirdSeat = makeWevvBenchView(wevvParlorState.berryPress[2], style: .wevvMini)
        let secondColumn = UIStackView(arrangedSubviews: [secondSeat, thirdSeat])
        secondColumn.translatesAutoresizingMaskIntoConstraints = false
        secondColumn.axis = .vertical
        secondColumn.spacing = 10
        secondColumn.distribution = .fillEqually

        let lowerRow = UIStackView(arrangedSubviews: [
            makeWevvBenchView(wevvParlorState.berryPress[3], style: .wevvOpen),
            makeWevvBenchView(wevvParlorState.berryPress[4], style: .wevvOpen),
            makeWevvBenchView(wevvParlorState.berryPress[5], style: .wevvOpen)
        ])
        lowerRow.translatesAutoresizingMaskIntoConstraints = false
        lowerRow.axis = .horizontal
        lowerRow.spacing = 6
        lowerRow.distribution = .fillEqually

        wevvBenchCanvas.addSubview(firstSeat)
        wevvBenchCanvas.addSubview(secondColumn)
        wevvBenchCanvas.addSubview(lowerRow)

        NSLayoutConstraint.activate([
            firstSeat.topAnchor.constraint(equalTo: wevvBenchCanvas.topAnchor),
            firstSeat.leadingAnchor.constraint(equalTo: wevvBenchCanvas.leadingAnchor),
            firstSeat.widthAnchor.constraint(equalTo: wevvBenchCanvas.widthAnchor, multiplier: 0.66),
            firstSeat.heightAnchor.constraint(equalToConstant: 218),
            secondColumn.topAnchor.constraint(equalTo: wevvBenchCanvas.topAnchor),
            secondColumn.leadingAnchor.constraint(equalTo: firstSeat.trailingAnchor, constant: 6),
            secondColumn.trailingAnchor.constraint(equalTo: wevvBenchCanvas.trailingAnchor),
            secondColumn.heightAnchor.constraint(equalTo: firstSeat.heightAnchor),
            lowerRow.topAnchor.constraint(equalTo: firstSeat.bottomAnchor, constant: 10),
            lowerRow.leadingAnchor.constraint(equalTo: wevvBenchCanvas.leadingAnchor),
            lowerRow.trailingAnchor.constraint(equalTo: wevvBenchCanvas.trailingAnchor),
            lowerRow.bottomAnchor.constraint(equalTo: wevvBenchCanvas.bottomAnchor)
        ])
    }

    private enum WevvBenchFlavor {
        case wevvDozen
        case wevvMini
        case wevvOpen
    }

    private func makeWevvBenchView(_ seat: WevVGlazeDonuWeYeSeat, style: WevvBenchFlavor) -> UIControl {
        let seatView = UIControl()
        seatView.translatesAutoresizingMaskIntoConstraints = false
        seatView.tag = seat.sugarIndex
        seatView.layer.cornerRadius = 12
        seatView.layer.borderWidth = seat.isCreamEmpty ? 1.2 : 0
        seatView.layer.borderColor = UIColor.white.withAlphaComponent(0.26).cgColor
        seatView.clipsToBounds = true
        seatView.addTarget(self, action: #selector(tapWevvBench(_:)), for: .touchUpInside)
        wevvBenchViews[seat.sugarIndex] = seatView

        let sugarIndexLabel = makeWevvParlorLabel("\(seat.sugarIndex)", size: 16, weight: .semibold, color: .white)
        let sprinkleAddButton = makeWevvRoundButton(symbol: "p%lou^sR".wevVPastryCrumbBloomRestored, fill: UIColor(red: 0.24, green: 0.18, blue: 0.54, alpha: 0.72), tint: .white)
        sprinkleAddButton.isUserInteractionEnabled = false

        seatView.addSubview(sugarIndexLabel)
        NSLayoutConstraint.activate([
            sugarIndexLabel.topAnchor.constraint(equalTo: seatView.topAnchor, constant: 12),
            sugarIndexLabel.leadingAnchor.constraint(equalTo: seatView.leadingAnchor, constant: 13)
        ])

        if seat.isCreamEmpty {
            pinWevvOpenBench(seatView: seatView, add: sprinkleAddButton)
            return seatView
        }

        let glazeImage = makeWevvBenchImage(seat, style: style)
        let sugarShade = makeWevvBenchShade()
        let donutTasterName = makeWevvBenchName(seat, style: style)
        let sprinkleBadge = makeWevvSprinkleBadge(isOpen: seat.isMicOpen, isCurrent: seat.isCurrentDonuWeYeTaster)
        placeWevvBenchViews(seatView: seatView, glazeImage: glazeImage, shade: sugarShade, name: donutTasterName, sprinkleBadge: sprinkleBadge, number: sugarIndexLabel)
        pinWevvBenchViews(seatView: seatView, glazeImage: glazeImage, shade: sugarShade, name: donutTasterName, sprinkleBadge: sprinkleBadge)
        return seatView
    }

    private func makeWevvBenchImage(_ seat: WevVGlazeDonuWeYeSeat, style: WevvBenchFlavor) -> UIImageView {
        let glazeImage = UIImageView(image: makeWevvTasterAvatar(tasterBadgeKey: seat.guestDonuWeYeKey, seed: seat.avatarSeed, size: style == .wevvDozen ? 220 : 120))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        return glazeImage
    }

    private func makeWevvBenchShade() -> UIView {
        let sugarShade = UIView()
        sugarShade.translatesAutoresizingMaskIntoConstraints = false
        sugarShade.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        return sugarShade
    }

    private func makeWevvBenchName(_ seat: WevVGlazeDonuWeYeSeat, style: WevvBenchFlavor) -> UILabel {
        let crumbLabel = makeWevvParlorLabel(seat.tasterName ?? "TZa@svtHehrd".wevVPastryCrumbBloomRestored, size: style == .wevvDozen ? 19 : 16, weight: .heavy, color: .white)
        crumbLabel.lineBreakMode = .byTruncatingTail
        return crumbLabel
    }

    private func pinWevvOpenBench(seatView: UIControl, add: UIButton) {
        seatView.addSubview(add)
        NSLayoutConstraint.activate([
            add.centerXAnchor.constraint(equalTo: seatView.centerXAnchor),
            add.centerYAnchor.constraint(equalTo: seatView.centerYAnchor),
            add.widthAnchor.constraint(equalToConstant: 48),
            add.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func placeWevvBenchViews(seatView: UIControl, glazeImage: UIImageView, shade: UIView, name: UILabel, sprinkleBadge: UIView, number: UILabel) {
        seatView.addSubview(glazeImage)
        seatView.addSubview(shade)
        seatView.addSubview(name)
        seatView.addSubview(sprinkleBadge)
        seatView.bringSubviewToFront(number)
    }

    private func pinWevvBenchViews(seatView: UIControl, glazeImage: UIImageView, shade: UIView, name: UILabel, sprinkleBadge: UIView) {
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
            sprinkleBadge.topAnchor.constraint(equalTo: seatView.topAnchor, constant: 10),
            sprinkleBadge.trailingAnchor.constraint(equalTo: seatView.trailingAnchor, constant: -10),
            sprinkleBadge.widthAnchor.constraint(equalToConstant: 48),
            sprinkleBadge.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func makeWevvSprinkleBadge(isOpen: Bool, isCurrent: Bool) -> UIView {
        let badge = UIView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = isOpen ? UIColor(red: 1, green: 0.14, blue: 0.62, alpha: 1) : UIColor.black.withAlphaComponent(isCurrent ? 0.86 : 0.92)
        badge.layer.cornerRadius = 18

        let crullerScout = isOpen ? "mic.fill" : "mjiVco.gsjlcaDschY.PfEi#lrl@".wevVPastryCrumbBloomRestored
        let vanillaShelf = UIImageView(image: UIImage(systemName: crullerScout))
        vanillaShelf.translatesAutoresizingMaskIntoConstraints = false
        vanillaShelf.tintColor = .white
        vanillaShelf.contentMode = .scaleAspectFit
        badge.addSubview(vanillaShelf)
        NSLayoutConstraint.activate([
            vanillaShelf.centerXAnchor.constraint(equalTo: badge.centerXAnchor),
            vanillaShelf.centerYAnchor.constraint(equalTo: badge.centerYAnchor),
            vanillaShelf.widthAnchor.constraint(equalToConstant: 20),
            vanillaShelf.heightAnchor.constraint(equalToConstant: 20)
        ])
        return badge
    }

    private func makeWevvHintCard() -> UIView {
        let wevvPastryCard = UIView()
        wevvPastryCard.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryCard.layer.cornerRadius = 14
        wevvPastryCard.layer.borderWidth = 1.1
        wevvPastryCard.layer.borderColor = UIColor(red: 0.35, green: 0.87, blue: 1, alpha: 0.95).cgColor
        wevvPastryCard.backgroundColor = UIColor(red: 0.25, green: 0.38, blue: 0.95, alpha: 0.34)

        let sugarText = makeWevvParlorLabel("Pick Your Role And Speak Your Part.\nEvery Voice Shapes The Story.\nWelcome To Our Voice Theater.", size: 14, weight: .medium, color: .white)
        sugarText.numberOfLines = 3
        wevvPastryCard.addSubview(sugarText)
        NSLayoutConstraint.activate([
            wevvPastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
            sugarText.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 11),
            sugarText.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor, constant: 14),
            sugarText.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -14),
            sugarText.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -11)
        ])
        return wevvPastryCard
    }

    private func configureWevvTastingLineStack() {
        wevvTastingLineStack.translatesAutoresizingMaskIntoConstraints = false
        wevvTastingLineStack.axis = .vertical
        wevvTastingLineStack.spacing = 12
        wevvParlorState.roDonuWeYeLines.forEach { wevvTastingLineStack.addArrangedSubview(makeWevvTastingLineBubble($0)) }
    }

    private func makeWevvTastingLineBubble(_ line: WevVSprinkleDonuWeYeRoLine) -> UIView {
        let bubble = UIView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.backgroundColor = UIColor(red: 0.62, green: 0.84, blue: 1, alpha: 0.34)
        bubble.layer.cornerRadius = 14
        bubble.layer.borderWidth = 1
        bubble.layer.borderColor = UIColor(red: 0.1, green: 0.2, blue: 0.62, alpha: 0.75).cgColor

        let sugarText = makeWevvParlorLabel("\(line.tasterDonuWeYeName): \(line.crumbText)", size: 14, weight: .medium, color: .white)
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

    private func buildWevvTastingInputBar() {
        wevvTastingInputBar.translatesAutoresizingMaskIntoConstraints = false
        wevvTastingInputBar.backgroundColor = UIColor(red: 0.3, green: 0.16, blue: 0.6, alpha: 0.62)
        wevvTastingInputBar.layer.cornerRadius = 28
        view.addSubview(wevvTastingInputBar)

        wevvTastingInputField.translatesAutoresizingMaskIntoConstraints = false
        wevvTastingInputField.borderStyle = .none
        wevvTastingInputField.textColor = .white
        wevvTastingInputField.font = .systemFont(ofSize: 17, weight: .heavy)
        wevvTastingInputField.attributedPlaceholder = NSAttributedString(
            string: "SkaOyk vhMiw~:".wevVPastryCrumbBloomRestored,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.76)]
        )

        let sprinkleSendButton = makeWevvSendButton()
        sprinkleSendButton.addTarget(self, action: #selector(sendWevvTastingLine), for: .touchUpInside)
        wevvTastingInputBar.addSubview(wevvTastingInputField)
        view.addSubview(sprinkleSendButton)

        wevvInputLiftConstraint = wevvTastingInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([
            wevvTastingInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            wevvTastingInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            wevvInputLiftConstraint!,
            wevvTastingInputBar.heightAnchor.constraint(equalToConstant: 56),
            wevvTastingInputField.leadingAnchor.constraint(equalTo: wevvTastingInputBar.leadingAnchor, constant: 24),
            wevvTastingInputField.centerYAnchor.constraint(equalTo: wevvTastingInputBar.centerYAnchor),
            wevvTastingInputField.trailingAnchor.constraint(equalTo: sprinkleSendButton.leadingAnchor, constant: -12),
            sprinkleSendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            sprinkleSendButton.centerYAnchor.constraint(equalTo: wevvTastingInputBar.centerYAnchor),
            sprinkleSendButton.widthAnchor.constraint(equalToConstant: 48),
            sprinkleSendButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func bindWevvKeyboardLift() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftWevvTastingInput(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropWevvTastingInput(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftWevvTastingInput(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let lift = max(0, frame.height - view.safeAreaInsets.bottom)
        wevvInputLiftConstraint?.constant = -lift - 10
        wevvParlorScroll.contentInset.bottom = lift + 92
        wevvParlorScroll.verticalScrollIndicatorInsets.bottom = lift + 92
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func dropWevvTastingInput(_ note: Notification) {
        wevvInputLiftConstraint?.constant = -12
        wevvParlorScroll.contentInset.bottom = 0
        wevvParlorScroll.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func tapWevvBench(_ sender: UIControl) {
        let index = sender.tag
        guard let seatPosition = wevvParlorState.berryPress.firstIndex(where: { $0.sugarIndex == index }) else { return }
        let seat = wevvParlorState.berryPress[seatPosition]
        if seat.isCreamEmpty {
            guard wevvDonutJournalStore.hasCreamMicGrant else {
                askWevvPastryRecordGrant {
                    self.occupyWevvBench(index)
                }
                return
            }
            occupyWevvBench(index)
        } else if seat.isCurrentDonuWeYeTaster {
            guard wevvDonutJournalStore.hasCreamMicGrant else {
                askWevvPastryRecordGrant {
                    self.wevvParlorState.berryPress[seatPosition].isMicOpen.toggle()
                    self.refreshWevvBenchCanvas()
                }
                return
            }
            wevvParlorState.berryPress[seatPosition].isMicOpen.toggle()
            refreshWevvBenchCanvas()
        } else {
            if let tasterBadgeKey = seat.guestDonuWeYeKey {
                openTasterDonutCard(tasterBadgeKey: tasterBadgeKey)
            } else {
                showWevvTinyHint("\(seat.tasterName ?? "This taster")d =iSsb ia?lUrUezardBy^ .o*nH NtKh#i/st Bsyexadti.^".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func askWevvPastryRecordGrant(onReady: @escaping () -> Void) {
        let grant = AVCaptureDevice.authorizationStatus(for: wevvPastryRecordKind)
        switch grant {
        case .authorized:
            wevvDonutJournalStore.markCreamMicGrant()
            onReady()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: wevvPastryRecordKind) { [weak self] allowed in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if allowed {
                        self.wevvDonutJournalStore.markCreamMicGrant()
                        onReady()
                    } else {
                        self.showWevvTinyHint("MGircNrIo^p=hfoqn+eV ypseXr^mei~sKsbiGoGnH LwQaOss ?n&ortg ^gbrIaDngt.e*du.:".wevVPastryCrumbBloomRestored)
                    }
                }
            }
        default:
            showWevvTinyHint("Ehn@aSbClIeu nmFiQcurkorpzh,o&nmed @pZeWrQmxiZsBsWiZo#nB BiBnl BSYewtutLiTnOgws,.R".wevVPastryCrumbBloomRestored)
        }
    }

    private func occupyWevvBench(_ index: Int) {
        guard let seatPosition = wevvParlorState.berryPress.firstIndex(where: { $0.sugarIndex == index }) else { return }
        if let oldSeat = wevvParlorState.currentSeatIndex,
           let oldPosition = wevvParlorState.berryPress.firstIndex(where: { $0.sugarIndex == oldSeat }) {
            wevvParlorState.berryPress[oldPosition].isCreamEmpty = true
            wevvParlorState.berryPress[oldPosition].isCurrentDonuWeYeTaster = false
            wevvParlorState.berryPress[oldPosition].tasterName = nil
            wevvParlorState.berryPress[oldPosition].guestDonuWeYeKey = nil
            wevvParlorState.berryPress[oldPosition].isMicOpen = false
        }
        wevvParlorState.berryPress[seatPosition].isCreamEmpty = false
        wevvParlorState.berryPress[seatPosition].isCurrentDonuWeYeTaster = true
        wevvParlorState.berryPress[seatPosition].tasterName = "Y&oWu#".wevVPastryCrumbBloomRestored
        wevvParlorState.berryPress[seatPosition].guestDonuWeYeKey = nil
        wevvParlorState.berryPress[seatPosition].avatarSeed = 8
        wevvParlorState.berryPress[seatPosition].isMicOpen = false
        wevvParlorState.currentSeatIndex = index
        refreshWevvBenchCanvas()
    }

    private func showWevvPastryGrantLayer(for index: Int) {
        let layer = UIView()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.55)

        let wevvPastryCard = UIView()
        wevvPastryCard.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryCard.backgroundColor = .white
        wevvPastryCard.layer.cornerRadius = 22

        let glazeTitle = makeWevvParlorLabel("Agl/l&o@wt qmiiJcN QaYcCcRe:sXsU?m".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: UIColor(red: 0.14, green: 0.08, blue: 0.18, alpha: 1))
        glazeTitle.textAlignment = .center
        let body = makeWevvParlorLabel("UqsJeF fas llEo@cGaLlC gmeiWcK Apkazsvs^ UfKoOrr .t.heicsz zs^w:eGe;tw FrRoXoQmr.G".wevVPastryCrumbBloomRestored, size: 13, weight: .medium, color: UIColor(red: 0.5, green: 0.43, blue: 0.52, alpha: 1))
        body.textAlignment = .center
        body.numberOfLines = 2
        let allow = makeWevvGrantButton("A~l#l?onwo".wevVPastryCrumbBloomRestored, fill: UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1), color: .white)
        let later = makeWevvGrantButton("NooUt* anCo;wJ".wevVPastryCrumbBloomRestored, fill: UIColor(red: 0.92, green: 0.9, blue: 0.94, alpha: 1), color: UIColor(red: 0.24, green: 0.17, blue: 0.28, alpha: 1))
        allow.addAction(UIAction { [weak self] _ in
            self?.wevvDonutJournalStore.markCreamMicGrant()
            self?.hideWevvPastryGrantLayer()
            self?.occupyWevvBench(index)
        }, for: .touchUpInside)
        later.addAction(UIAction { [weak self] _ in
            self?.hideWevvPastryGrantLayer()
        }, for: .touchUpInside)

        wevvPastryCard.addSubview(glazeTitle)
        wevvPastryCard.addSubview(body)
        wevvPastryCard.addSubview(allow)
        wevvPastryCard.addSubview(later)
        layer.addSubview(wevvPastryCard)
        view.addSubview(layer)
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvPastryCard.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            wevvPastryCard.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            wevvPastryCard.widthAnchor.constraint(equalToConstant: 284),
            glazeTitle.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 24),
            glazeTitle.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor, constant: 20),
            glazeTitle.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -20),
            body.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 10),
            body.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            allow.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 20),
            allow.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor, constant: 24),
            allow.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -24),
            allow.heightAnchor.constraint(equalToConstant: 48),
            later.topAnchor.constraint(equalTo: allow.bottomAnchor, constant: 10),
            later.leadingAnchor.constraint(equalTo: allow.leadingAnchor),
            later.trailingAnchor.constraint(equalTo: allow.trailingAnchor),
            later.heightAnchor.constraint(equalToConstant: 44),
            later.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -22)
        ])
        wevvPastryGrantLayer = layer
    }

    private func hideWevvPastryGrantLayer() {
        wevvPastryGrantLayer?.removeFromSuperview()
        wevvPastryGrantLayer = nil
    }

    private func showWevvTinyHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: wevvTastingInputBar, bottomOffset: -14)
    }

    @objc private func sendWevvTastingLine() {
        let cleanText = (wevvTastingInputField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            showWevvTinyHint("SJaMyb Gsmo,mNextXhvi:n.gM usWwde*edtK xfOiqrvspty.w".wevVPastryCrumbBloomRestored)
            return
        }
        wevvTastingInputField.text = nil
        wevvTastingInputField.resignFirstResponder()
        let line = WevVSprinkleDonuWeYeRoLine(
            sprinkleJarKey: "sugarLine\(Date().timeIntervalSince1970)",
            tasterDonuWeYeName: "Ytomui".wevVPastryCrumbBloomRestored,
            crumbText: cleanText
        )
        wevvTastingLineStack.addArrangedSubview(makeWevvTastingLineBubble(line))
        showWevvTinyHint("SKehnatK".wevVPastryCrumbBloomRestored)
        view.layoutIfNeeded()
        let bottomOffset = max(0, wevvParlorScroll.contentSize.height - wevvParlorScroll.bounds.height + wevvParlorScroll.adjustedContentInset.bottom)
        wevvParlorScroll.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: true)
    }

    @objc private func toggleHostGlazeTrail(_ sender: UIButton) {
        wevvHostTrailActive = wevvTasterStore.toggleGlazeFollow(for: wevvParlorState.tasterBadgeKey)
        sender.backgroundColor = wevvHostTrailActive ? .black : UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1)
        sender.setImage(UIImage(systemName: wevvHostTrailActive ? "checkmark" : "plus"), for: .normal)
        showWevvTinyHint(wevvHostTrailActive ? "Following \(wevvParlorState.hostDonuWeYeName)" : "FBoilMleoCwQ krzeOmwojvBeHdK".wevVPastryCrumbBloomRestored)
    }

    @objc private func openHostDonutCard() {
        openTasterDonutCard(tasterBadgeKey: wevvParlorState.tasterBadgeKey)
    }

    @objc private func openParlorNoticePrompt() {
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvTinyHint("PplHe:aBs/eP PlPoKgd wisnD WfRi@rds/tf.A".wevVPastryCrumbBloomRestored)
            return
        }
        WevVGlazePromptStyler.showSugarConfirm(
            almondFlavor: view,
            gourmetFlavor: "R,e@p!o~rUtQ ytchMi@s/ ~r/ohoTmG?p".wevVPastryCrumbBloomRestored,
            glazeBowl: "WIeo NwHiCl.lL OszaQvoeO HtjhQiMs~ xrJoFo!mn *fYoWrE csOaDfyebtrya Zr:eSv~iletw^ BaEncdZ qheiPdBey ;s/iQmfisl!aIr% as;wVeFeWtu acNrcuDmNbfs% XwRhce:n: &nVeDeddhebds.H".wevVPastryCrumbBloomRestored,
            ringStack: "R/eYpKomr?tp".wevVPastryCrumbBloomRestored,
            miniDonut: "Cra:nQcUebl.".wevVPastryCrumbBloomRestored,
            fritterBite: UIColor(red: 1, green: 0.15, blue: 0.62, alpha: 1)
        ) { [weak self] in
            guard let self else { return }
            WevVGlazeCrackleOverlay.showGlazeCrackle(in: self.view, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) {
                self.wevvDonutJournalStore.placeRoomSafetyCrumb(
                    donutPinKey: self.wevvParlorState.roomDonuWeYeKey,
                    hostKey: self.wevvParlorState.tasterBadgeKey,
                    reasonText: "RcoioNmG hs%a#fee.tGyM zroeyvPiIeKwL".wevVPastryCrumbBloomRestored
                )
                self.showWevvTinyHint("RNeXpPobrWtn LsLutbxm@iHtPtQemdi".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func openTasterDonutCard(tasterBadgeKey: String) {
        let controller = WevVWevvTasterCardController(tasterBadgeKey: tasterBadgeKey)
        present(controller, animated: true)
    }

    @objc private func closeWevvTastingParlor() {
        wevvTastingInputField.resignFirstResponder()
        dismiss(animated: true)
    }

    private func makeWevvParlorLabel(_ sugarText: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarText
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func makeWevvRoundButton(symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.backgroundColor = fill
        sprinkleButton.tintColor = tint
        sprinkleButton.setImage(UIImage(systemName: symbol), for: .normal)
        sprinkleButton.layer.cornerRadius = 24
        return sprinkleButton
    }

    private func makeWevvSendButton() -> UIButton {
        let sprinkleButton = UIButton(type: .custom)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(named: "wevv_room_send_glaze"), for: .normal)
        sprinkleButton.imageView?.contentMode = .scaleAspectFit
        return sprinkleButton
    }

    private func makeWevvRoundText(_ sugarText: String, fill: UIColor, color: UIColor) -> UILabel {
        let crumbLabel = makeWevvParlorLabel(sugarText, size: 13, weight: .heavy, color: color)
        crumbLabel.backgroundColor = fill
        crumbLabel.textAlignment = .center
        crumbLabel.layer.cornerRadius = 20
        crumbLabel.clipsToBounds = true
        return crumbLabel
    }

    private func makeWevvGrantButton(_ sugarText: String, fill: UIColor, color: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(sugarText, for: .normal)
        sprinkleButton.setTitleColor(color, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        sprinkleButton.backgroundColor = fill
        sprinkleButton.layer.cornerRadius = 22
        return sprinkleButton
    }

    private func makeWevvCreamAvatar(seed: Int, size: CGFloat) -> UIImage {
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

    private func makeWevvTasterAvatar(tasterBadgeKey: String?, seed: Int, size: CGFloat) -> UIImage {
        if let tasterBadgeKey,
           let glazeImage = UIImage(named: wevvTasterStore.profile(for: tasterBadgeKey).donutFrameAsset) {
            return glazeImage
        }
        return makeWevvCreamAvatar(seed: seed, size: size)
    }

    private static func makeWevvParlorState(donutPinKey: String, bakeryTitle: String) -> WevVCreamDonuWeYeShrState {
        let wevvTasterStore = WevVGuestGlazeStore.shared
        let packet = makeWevvParlorPacket(donutPinKey: donutPinKey, wevvTasterStore: wevvTasterStore)
        let wevvHostTaster = wevvTasterStore.profile(for: packet.0)
        let wevvSecondTaster = wevvTasterStore.profile(for: packet.1)
        let wevvThirdTaster = wevvTasterStore.profile(for: packet.2)
        return WevVCreamDonuWeYeShrState(
            roomDonuWeYeKey: donutPinKey,
            tasterBadgeKey: wevvHostTaster.donutPinKey,
            hostDonuWeYeName: wevvHostTaster.cocoaCounter,
            hostSeed: abs(bakeryTitle.hashValue % 9),
            heatDonuWeYeText: packet.4,
            tastingTableText: packet.5,
            berryPress: makeWevvParlorBenches(wevvHostTaster: wevvHostTaster, wevvSecondTaster: wevvSecondTaster, wevvThirdTaster: wevvThirdTaster),
            roDonuWeYeLines: packet.6,
            currentSeatIndex: nil
        )
    }

    private static func makeWevvParlorPacket(donutPinKey: String, wevvTasterStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        switch donutPinKey {
        case "berryRingBakery":
            return berryCreamParlorPacket(wevvTasterStore: wevvTasterStore)
        case "goldenDoughStudio":
            return goldenCreamParlorPacket(wevvTasterStore: wevvTasterStore)
        case "moonlightDonutBar":
            return moonlightCreamParlorPacket(wevvTasterStore: wevvTasterStore)
        default:
            return classicCreamParlorPacket(wevvTasterStore: wevvTasterStore)
        }
    }

    private static func berryCreamParlorPacket(wevvTasterStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("lVoVumiRs/evS~aMnbtDoSsB".wevVPastryCrumbBloomRestored, "mwiNaoPfiJn;krSDuXgBaCre".wevVPastryCrumbBloomRestored, "m:ats&oHnwGAlJaUzOeySRm,iFlNeJ".wevVPastryCrumbBloomRestored, "n+o,rKaeCmrkeEaImyRBiPn&g%".wevVPastryCrumbBloomRestored, "9J".wevVPastryCrumbBloomRestored, "4x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "b+esrurWy+ByaUtlcgh?O;n@e;".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "mAiiawP%i?ntk=S@uZgAaJrb".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "SYtGrraUw*b,e^rGray~ dgYlGa.zje, afseYeylKsN ~eHxutbrLam XflrvensOhK rt~ojd?a*y/.S".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "bceVr!rmyNB^aGtTcRhDTjw&o*".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "m+apsuo:nUGTlwayzbevSvmViZlle+".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "It uwWoxuPlpdH rpMaViOrI ?txhoi;sk hbhaJtackhu NwWiJtTh; gvtagn^islVlta~ Zcqr?eVavm!.m".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "b#eMrurNyRBhaVtWcXhUT#h#rheje,".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "n;oSrba~CrrZecaVmuRziNnsg#".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "TThJeh nhTaBn/dlmcaed^en brKiin.g#s! ilZoEoOk^ Qs,opf=tw =a:nVdT rcsoizcyb.=".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func goldenCreamParlorPacket(wevvTasterStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("sjoQruaIC,rFe%awmVG,l^avzjeW".wevVPastryCrumbBloomRestored, "pMoqp!p;yiSzumnVGMl!aKzCeF".wevVPastryCrumbBloomRestored, "bnehlUlzauS+pkrHienfkSlcey".wevVPastryCrumbBloomRestored, "a.rQlOoZS%k%y?G%lraTzYe,".wevVPastryCrumbBloomRestored, "1I2e".wevVPastryCrumbBloomRestored, "3x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "gZoglodieEnSBHaVtSc~hEOBnKeV".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "bjeslulFabSVpkrzi;n;khlNeC".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "S?mEaulhl? qbkaJtjczhheas# Va!lawmaRypsH th~a^vde! RbLeFt/treorK UtQewxDt*ulrqew.Q".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "gvoclQdueSnIBwalt~cyhsTkwhoL".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "afrDlnodSuk#yvGvl;a:zfeR".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "G%ohlCdRe/ni ?d#ocueg/hO bw+imtzhQ yaDltmTo=nzd: VcIrlu&n%clho %wOo,u*lKdq GbJey YpLeurcfqexc^t~.e".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "gposludPeRnmBNa,tpcvhbTbhVrYeFeJ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "sUovraaPCVrNeoaXm!GIlXa/zaev".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "FuroeCs,hw vtlrkaRyEsO xmDakk.eH Ht!hneB ww;hVoFlbe^ lcqo#uSnAt,eYrG qsphDiknQey.E".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func moonlightCreamParlorPacket(wevvTasterStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("mTiDrYaUPxutrepzlheyGklQa^zkee".wevVPastryCrumbBloomRestored, "aWv^aRC/oEcUoNaeRJiwnZgo".wevVPastryCrumbBloomRestored, "lSuknea@LVayu&guh~GtlSawzsep".wevVPastryCrumbBloomRestored, "nfoAvSaxB.u&b:bAlTeUGUlpaszBe^".wevVPastryCrumbBloomRestored, "1U6~".wevVPastryCrumbBloomRestored, "2x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "m*oAolnjl=iCgRhJt.BGa:t;cxhEO%nIe=".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "a/vaaICMoyc=oqavRdisnsg&".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "C/olfCf*eLeU igoltaTzxer vf@iHt~s? =tQh@eC RlFaGt@ev-pnOitgShgtx lmmovofd..r".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "mEo~ovnplOiygihCtNBNalt:cfhXT^w~oQ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "lGuvnIaHLVa#uXgJhpGYldaAzoeD".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "C#r&eEaXtji.vTe^ ^durpifn~kwsy PnFeTeQdb Ba. Gc+oacaoTak .cErPuYm/bk AsEiIdYeJ.F".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "m%o&oWntlpiPgxhvtEBjaktNcphxTmh.rve%eQ".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "njoRvJaDBwu?b+bwl:e,G&lba#ztef".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "I, QlWiQkoe. xt@hMeq Lr/e@lIaSxze^dD ~mMixd%nbi,gphYtN dbHa!k!eor#y: seTn#e+r!g=yA.!".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func classicCreamParlorPacket(wevvTasterStore: WevVGuestGlazeStore) -> (String, String, String, String, String, String, [WevVSprinkleDonuWeYeRoLine]) {
        ("jvaHmtideACzo/lCeo".wevVPastryCrumbBloomRestored, "lNoAugiEsjeDSTamn~two,sd".wevVPastryCrumbBloomRestored, "mla#sXo~nDG&l@a:zQeJSlmXi~lReH".wevVPastryCrumbBloomRestored, "axvda&C~o:cnoPa/RNi=nSgS".wevVPastryCrumbBloomRestored, "1N1U".wevVPastryCrumbBloomRestored, "4x".wevVPastryCrumbBloomRestored, [
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "pGiPnSkmBVaTtFcwhIO.n!ea".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "l;oCuRiGsyeWSkasnytiopsz".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "PYiCn?kj dg;l+amzseD SaZnjdW Mb&ecr.rcyy Gf@iIlMlWi^nQgh ga:rSeG Cap tcLlZahsqs@ikcg Wp^aziLrp.h".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "pmi:npk^BQact@c.h%TIw!ou".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "miazsxo:nFGglta+z!eaSfmjielIer".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "TKhset SrLeWcdoOmfmje;n~deaWtIiDonnA .p^aVsKtVr:yhC#adrMdV ZmDaDd.em JmseQ :h,uXn:g.rcy,.~".wevVPastryCrumbBloomRestored),
            WevVSprinkleDonuWeYeRoLine(sprinkleJarKey: "p.ign.kkBJaBthclhnTChFrzeVeF".wevVPastryCrumbBloomRestored, tasterDonuWeYeName: wevvTasterStore.profile(for: "atvKapCHoIczodaORkiunygr".wevVPastryCrumbBloomRestored).cocoaCounter, crumbText: "F&rveqsMhU Rslp,rdi#n:kflhevsZ +c@hDaenug!e; %tYh~eF .w;hYoglUeB Gb,idtdeW.X".wevVPastryCrumbBloomRestored)
        ])
    }

    private static func makeWevvParlorBenches(wevvHostTaster: WevVGuestGlazeProfile, wevvSecondTaster: WevVGuestGlazeProfile, wevvThirdTaster: WevVGuestGlazeProfile) -> [WevVGlazeDonuWeYeSeat] {
        [
            WevVGlazeDonuWeYeSeat(sugarIndex: 1, guestDonuWeYeKey: wevvHostTaster.donutPinKey, tasterName: wevvHostTaster.cocoaCounter, avatarSeed: 1, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 2, guestDonuWeYeKey: wevvSecondTaster.donutPinKey, tasterName: wevvSecondTaster.cocoaCounter, avatarSeed: 2, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 3, guestDonuWeYeKey: wevvThirdTaster.donutPinKey, tasterName: wevvThirdTaster.cocoaCounter, avatarSeed: 3, isCreamEmpty: false, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 4, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 4, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 5, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 5, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false),
            WevVGlazeDonuWeYeSeat(sugarIndex: 6, guestDonuWeYeKey: nil, tasterName: nil, avatarSeed: 6, isCreamEmpty: true, isCurrentDonuWeYeTaster: false, isMicOpen: false)
        ]
    }
}
