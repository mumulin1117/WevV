import UIKit

final class WevVWevvTasterCardController: UIViewController {
    private enum WevvFlavorPane {
        case flavorNotePane
        case tastingQuestPane
    }

    private struct WevVWevvTastingQuestCard {
        let crumbScoutline: String
        let pastryScoutline: String
        let treatScoutline: String
        let flavorScoutline: String
        let assetName: String
    }

    private let tasterBadgeKey: String
    private let wevvTasterStore = WevVGuestGlazeStore.shared
    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvFritterScroll = UIScrollView()
    private let wevvGlazeCanvas = UIView()
    private let wevvDonutAvatarView = UIImageView()
    private let wevvTrailButton = UIButton(type: .system)
    private let wevvNameTitle = UILabel()
    private let wevvNameHero = UILabel()
    private let wevvFlavorLine = UILabel()
    private let wevvBakeryLine = UILabel()
    private let wevvKudosValue = UILabel()
    private let wevvTasterValue = UILabel()
    private let wevvTrailValue = UILabel()
    private let wevvFlavorNoteButton = UIButton(type: .system)
    private let wevvTastingQuestButton = UIButton(type: .system)
    private let wevvBodyStack = UIStackView()
    private let wevvLockedFoot = UIControl()
    private let wevvActionFoot = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    private var wevvFirstStatCenter: NSLayoutConstraint?
    private var wevvSecondStatCenter: NSLayoutConstraint?
    private var wevvSelectedPane: WevvFlavorPane = .tastingQuestPane

    private let wevvBerryTone = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
    private let wevvBlushCreamTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.08, green: 0.07, blue: 0.12, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1)

    init(tasterBadgeKey: String) {
        self.tasterBadgeKey = tasterBadgeKey
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wevvSelectedPane = isDonutTrailOpen ? .flavorNotePane : .tastingQuestPane
        buildWevvTasterCardPage()
        refreshWevvTasterCardPage()
    }

    private var currentTasterCard: WevVGuestGlazeProfile {
        wevvTasterStore.profile(for: tasterBadgeKey)
    }

    private var isDonutTrailOpen: Bool {
        currentTasterCard.sugarTie.isGlazeFollowed
    }

    private func buildWevvTasterCardPage() {
        view.backgroundColor = wevvBlushCreamTone
        buildWevvTasterTopBar()
        buildWevvTasterScrollLayer()
        buildWevvLockedFoot()
        buildWevvActionFoot()
    }

    private func buildWevvTasterTopBar() {
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.tintColor = .black
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(closeWevvTasterCard), for: .touchUpInside)

        wevvNameTitle.translatesAutoresizingMaskIntoConstraints = false
        wevvNameTitle.font = .systemFont(ofSize: 20, weight: .heavy)
        wevvNameTitle.textAlignment = .center
        wevvNameTitle.textColor = .black
        wevvNameTitle.adjustsFontSizeToFitWidth = true
        wevvNameTitle.minimumScaleFactor = 0.72

        let dots = UIButton(type: .system)
        dots.translatesAutoresizingMaskIntoConstraints = false
        dots.tintColor = .black
        dots.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        dots.addTarget(self, action: #selector(openWevvNoticeTray), for: .touchUpInside)

        view.addSubview(back)
        view.addSubview(wevvNameTitle)
        view.addSubview(dots)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            wevvNameTitle.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            wevvNameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wevvNameTitle.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 14),
            wevvNameTitle.trailingAnchor.constraint(lessThanOrEqualTo: dots.leadingAnchor, constant: -14),
            dots.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            dots.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            dots.widthAnchor.constraint(equalToConstant: 44),
            dots.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildWevvTasterScrollLayer() {
        buildWevvTasterScrollShell()
        tuneWevvTasterHeaderViews()

        let statRow = UIStackView(arrangedSubviews: [
            makeWevvSugarStat(value: wevvKudosValue, title: "LFizkQehsw".wevVPastryCrumbBloomRestored),
            makeWevvSugarStat(value: wevvTasterValue, title: "FnoYlyl&oHw*eErWsy".wevVPastryCrumbBloomRestored),
            makeWevvSugarStat(value: wevvTrailValue, title: "FpovlYlTolwzi:nrgX".wevVPastryCrumbBloomRestored)
        ])
        statRow.translatesAutoresizingMaskIntoConstraints = false
        statRow.axis = .horizontal
        statRow.distribution = .fillEqually

        let firstDivider = makeWevvStatDivider()
        let secondDivider = makeWevvStatDivider()
        let segment = makeWevvTastingSegment()
        configureWevvTasterBodyStack()
        placeWevvTasterScrollViews(statRow: statRow, firstDivider: firstDivider, secondDivider: secondDivider, segment: segment)

        let firstStatCenter = firstDivider.centerXAnchor.constraint(equalTo: statRow.leadingAnchor)
        let secondStatCenter = secondDivider.centerXAnchor.constraint(equalTo: statRow.trailingAnchor)
        wevvFirstStatCenter = firstStatCenter
        wevvSecondStatCenter = secondStatCenter
        pinWevvTasterScrollViews(statRow: statRow, firstDivider: firstDivider, secondDivider: secondDivider, segment: segment, firstStatCenter: firstStatCenter, secondStatCenter: secondStatCenter)
    }

    private func buildWevvTasterScrollShell() {
        wevvFritterScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.alwaysBounceVertical = true
        wevvFritterScroll.contentInsetAdjustmentBehavior = .never
        view.addSubview(wevvFritterScroll)

        wevvGlazeCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.addSubview(wevvGlazeCanvas)
    }

    private func tuneWevvTasterHeaderViews() {
        wevvDonutAvatarView.translatesAutoresizingMaskIntoConstraints = false
        wevvDonutAvatarView.contentMode = .scaleAspectFill
        wevvDonutAvatarView.clipsToBounds = true
        wevvDonutAvatarView.layer.cornerRadius = 50

        wevvTrailButton.translatesAutoresizingMaskIntoConstraints = false
        wevvTrailButton.tintColor = .white
        wevvTrailButton.layer.cornerRadius = 14.5
        wevvTrailButton.addTarget(self, action: #selector(toggleWevvTasterTrail), for: .touchUpInside)

        wevvNameHero.translatesAutoresizingMaskIntoConstraints = false
        wevvNameHero.font = .systemFont(ofSize: 25, weight: .heavy)
        wevvNameHero.textColor = .black
        wevvNameHero.adjustsFontSizeToFitWidth = true
        wevvNameHero.minimumScaleFactor = 0.68

        wevvFlavorLine.translatesAutoresizingMaskIntoConstraints = false
        wevvFlavorLine.font = .systemFont(ofSize: 16, weight: .heavy)
        wevvFlavorLine.textColor = wevvSoftCrumbTone
        wevvFlavorLine.adjustsFontSizeToFitWidth = true
        wevvFlavorLine.minimumScaleFactor = 0.68

        wevvBakeryLine.translatesAutoresizingMaskIntoConstraints = false
        wevvBakeryLine.font = .systemFont(ofSize: 15, weight: .heavy)
        wevvBakeryLine.textColor = wevvSoftCrumbTone
        wevvBakeryLine.adjustsFontSizeToFitWidth = true
        wevvBakeryLine.minimumScaleFactor = 0.68
    }

    private func makeWevvTastingSegment() -> UIView {
        let segment = UIView()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.layer.cornerRadius = 28
        segment.clipsToBounds = true

        configureWevvSegmentButton(wevvFlavorNoteButton, title: "PDo~s^tV".wevVPastryCrumbBloomRestored, action: #selector(selectWevvFlavorNotePane))
        configureWevvSegmentButton(wevvTastingQuestButton, title: "CDhwaUloldein&g?eB".wevVPastryCrumbBloomRestored, action: #selector(selectWevvTastingQuestPane))
        segment.addSubview(wevvFlavorNoteButton)
        segment.addSubview(wevvTastingQuestButton)
        return segment
    }

    private func configureWevvTasterBodyStack() {
        wevvBodyStack.translatesAutoresizingMaskIntoConstraints = false
        wevvBodyStack.axis = .vertical
        wevvBodyStack.spacing = 22
    }

    private func placeWevvTasterScrollViews(statRow: UIStackView, firstDivider: UIView, secondDivider: UIView, segment: UIView) {
        wevvGlazeCanvas.addSubview(wevvDonutAvatarView)
        wevvGlazeCanvas.addSubview(wevvTrailButton)
        wevvGlazeCanvas.addSubview(wevvNameHero)
        wevvGlazeCanvas.addSubview(wevvFlavorLine)
        wevvGlazeCanvas.addSubview(wevvBakeryLine)
        wevvGlazeCanvas.addSubview(statRow)
        wevvGlazeCanvas.addSubview(firstDivider)
        wevvGlazeCanvas.addSubview(secondDivider)
        wevvGlazeCanvas.addSubview(segment)
        wevvGlazeCanvas.addSubview(wevvBodyStack)
    }

    private func pinWevvTasterScrollViews(statRow: UIStackView, firstDivider: UIView, secondDivider: UIView, segment: UIView, firstStatCenter: NSLayoutConstraint, secondStatCenter: NSLayoutConstraint) {
        NSLayoutConstraint.activate([
            wevvFritterScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 108),
            wevvFritterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvFritterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvFritterScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvGlazeCanvas.topAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.topAnchor),
            wevvGlazeCanvas.leadingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.leadingAnchor),
            wevvGlazeCanvas.trailingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.trailingAnchor),
            wevvGlazeCanvas.bottomAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.bottomAnchor),
            wevvGlazeCanvas.widthAnchor.constraint(equalTo: wevvFritterScroll.frameLayoutGuide.widthAnchor),
            wevvDonutAvatarView.topAnchor.constraint(equalTo: wevvGlazeCanvas.topAnchor, constant: 6),
            wevvDonutAvatarView.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 64),
            wevvDonutAvatarView.widthAnchor.constraint(equalToConstant: 100),
            wevvDonutAvatarView.heightAnchor.constraint(equalToConstant: 100),
            wevvTrailButton.centerXAnchor.constraint(equalTo: wevvDonutAvatarView.centerXAnchor),
            wevvTrailButton.bottomAnchor.constraint(equalTo: wevvDonutAvatarView.bottomAnchor, constant: 22),
            wevvTrailButton.widthAnchor.constraint(equalToConstant: 78),
            wevvTrailButton.heightAnchor.constraint(equalToConstant: 29),
            wevvNameHero.leadingAnchor.constraint(equalTo: wevvDonutAvatarView.trailingAnchor, constant: 38),
            wevvNameHero.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -32),
            wevvNameHero.topAnchor.constraint(equalTo: wevvDonutAvatarView.topAnchor, constant: 18),
            wevvFlavorLine.leadingAnchor.constraint(equalTo: wevvNameHero.leadingAnchor),
            wevvFlavorLine.trailingAnchor.constraint(equalTo: wevvNameHero.trailingAnchor),
            wevvFlavorLine.topAnchor.constraint(equalTo: wevvNameHero.bottomAnchor, constant: 16),
            wevvBakeryLine.leadingAnchor.constraint(equalTo: wevvNameHero.leadingAnchor),
            wevvBakeryLine.trailingAnchor.constraint(equalTo: wevvNameHero.trailingAnchor),
            wevvBakeryLine.topAnchor.constraint(equalTo: wevvFlavorLine.bottomAnchor, constant: 6),
            statRow.topAnchor.constraint(equalTo: wevvDonutAvatarView.bottomAnchor, constant: 62),
            statRow.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 58),
            statRow.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -58),
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
            segment.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 30),
            segment.widthAnchor.constraint(equalTo: wevvGlazeCanvas.widthAnchor, multiplier: 0.58),
            segment.heightAnchor.constraint(equalToConstant: 48),
            wevvFlavorNoteButton.leadingAnchor.constraint(equalTo: segment.leadingAnchor, constant: 6),
            wevvFlavorNoteButton.topAnchor.constraint(equalTo: segment.topAnchor, constant: 4),
            wevvFlavorNoteButton.bottomAnchor.constraint(equalTo: segment.bottomAnchor, constant: -4),
            wevvFlavorNoteButton.widthAnchor.constraint(equalTo: segment.widthAnchor, multiplier: 0.5, constant: -6),
            wevvTastingQuestButton.trailingAnchor.constraint(equalTo: segment.trailingAnchor, constant: -6),
            wevvTastingQuestButton.topAnchor.constraint(equalTo: wevvFlavorNoteButton.topAnchor),
            wevvTastingQuestButton.bottomAnchor.constraint(equalTo: wevvFlavorNoteButton.bottomAnchor),
            wevvTastingQuestButton.widthAnchor.constraint(equalTo: wevvFlavorNoteButton.widthAnchor),
            wevvBodyStack.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 30),
            wevvBodyStack.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 30),
            wevvBodyStack.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -30),
            wevvBodyStack.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor, constant: -180)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statWidth = max(view.bounds.width - 116, 1)
        wevvFirstStatCenter?.constant = statWidth / 3
        wevvSecondStatCenter?.constant = -statWidth / 3
        wevvDonutAvatarView.layer.cornerRadius = wevvDonutAvatarView.bounds.height / 2
        wevvTrailButton.layer.cornerRadius = wevvTrailButton.bounds.height / 2
        wevvFlavorNoteButton.layer.cornerRadius = wevvFlavorNoteButton.bounds.height / 2
        wevvTastingQuestButton.layer.cornerRadius = wevvTastingQuestButton.bounds.height / 2
    }

    private func buildWevvLockedFoot() {
        wevvLockedFoot.translatesAutoresizingMaskIntoConstraints = false
        wevvLockedFoot.backgroundColor = .clear//UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        wevvLockedFoot.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)

//        let crumbLabel = makeGlazeLabel(
//            "You can only send messages and videos to each other once you have followed one another. Please follow the user first and wait for them to follow you back.",
//            size: 17,
//            weight: .semibold,
//            color: UIColor(red: 0.56, green: 0.56, blue: 0.57, alpha: 1)
//        )
//        crumbLabel.numberOfLines = 0
//        lockedFoot.addSubview(crumbLabel)
        view.addSubview(wevvLockedFoot)

        NSLayoutConstraint.activate([
            wevvLockedFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvLockedFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvLockedFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvLockedFoot.heightAnchor.constraint(equalToConstant: 134),
//            crumbLabel.leadingAnchor.constraint(equalTo: lockedFoot.leadingAnchor, constant: 30),
//            crumbLabel.trailingAnchor.constraint(equalTo: lockedFoot.trailingAnchor, constant: -24),
//            crumbLabel.topAnchor.constraint(equalTo: lockedFoot.topAnchor, constant: 22)
        ])
    }

    private func buildWevvActionFoot() {
        wevvActionFoot.translatesAutoresizingMaskIntoConstraints = false
        wevvActionFoot.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 0.88)
        view.addSubview(wevvActionFoot)

        let donutRibbonNote = makeWevvBottomAction(
            title: "MueLsps%aTg.eu".wevVPastryCrumbBloomRestored,
            symbol: "bhuCbnbGlLeU.mlPeOfNtz.%f.iAlBlF".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.91, green: 0.9, blue: 1, alpha: 1),
            tint: UIColor(red: 0.06, green: 0.06, blue: 0.09, alpha: 1)
        )
        let sprinkleLensButton = makeWevvBottomAction(
            title: "V.iDd^eXo;".wevVPastryCrumbBloomRestored,
            symbol: "c#a.m%eEr,aG.tfNivl.lf".wevVPastryCrumbBloomRestored,
            fill: wevvBerryTone,
            tint: .white
        )
        donutRibbonNote.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)
        sprinkleLensButton.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)
        wevvActionFoot.contentView.addSubview(donutRibbonNote)
        wevvActionFoot.contentView.addSubview(sprinkleLensButton)

        NSLayoutConstraint.activate([
            wevvActionFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvActionFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvActionFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvActionFoot.heightAnchor.constraint(equalToConstant: 122),
            donutRibbonNote.leadingAnchor.constraint(equalTo: wevvActionFoot.contentView.leadingAnchor, constant: 48),
            donutRibbonNote.topAnchor.constraint(equalTo: wevvActionFoot.contentView.topAnchor, constant: 24),
            donutRibbonNote.heightAnchor.constraint(equalToConstant: 54),
            donutRibbonNote.trailingAnchor.constraint(equalTo: wevvActionFoot.contentView.centerXAnchor, constant: -14),
            sprinkleLensButton.leadingAnchor.constraint(equalTo: wevvActionFoot.contentView.centerXAnchor, constant: 14),
            sprinkleLensButton.trailingAnchor.constraint(equalTo: wevvActionFoot.contentView.trailingAnchor, constant: -48),
            sprinkleLensButton.topAnchor.constraint(equalTo: donutRibbonNote.topAnchor),
            sprinkleLensButton.heightAnchor.constraint(equalTo: donutRibbonNote.heightAnchor)
        ])
    }

    private func refreshWevvTasterCardPage() {
        let profile = currentTasterCard
        let signatureLines = profile.trailQuest.components(separatedBy: "\n")
        wevvNameTitle.text = profile.cocoaCounter
        wevvNameHero.text = profile.cocoaCounter
        wevvFlavorLine.text = signatureLines.first ?? profile.trailQuest
        wevvBakeryLine.text = signatureLines.dropFirst().first ?? "S,wmepeKtS HgOlFatzie= mrQeYgcusl*aKrv".wevVPastryCrumbBloomRestored
        wevvKudosValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.sweetMarkCount))"
        wevvTasterValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.sprinkleTasterCount))"
        wevvTrailValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.glazeTrailCount))"
        wevvDonutAvatarView.image = UIImage(named: profile.donutFrameAsset)
        refreshWevvTrailButton()
        refreshWevvSegmentState()
        refreshWevvBodyStack()
        wevvLockedFoot.isHidden = isDonutTrailOpen
        wevvActionFoot.isHidden = !isDonutTrailOpen
        wevvFritterScroll.contentInset.bottom = isDonutTrailOpen ? 132 : 148
        wevvFritterScroll.verticalScrollIndicatorInsets.bottom = wevvFritterScroll.contentInset.bottom
    }

    private func makeWevvTinyTastingStat(for sugarDustKey: String, salt: Int) -> Int {
        let crumbSeed = sugarDustKey.unicodeScalars.reduce(salt) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        return abs(crumbSeed % 14) + 1
    }

    private func refreshWevvTrailButton() {
        let followed = currentTasterCard.sugarTie.isGlazeFollowed
        wevvTrailButton.backgroundColor = followed ? UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1) : wevvBerryTone
        wevvTrailButton.setImage(UIImage(systemName: followed ? "checkmark" : "plus"), for: .normal)
        wevvTrailButton.imageView?.contentMode = .scaleAspectFit
        wevvTrailButton.contentHorizontalAlignment = .center
    }

    private func refreshWevvSegmentState() {
        let flavorNoteSelected = wevvSelectedPane == .flavorNotePane
        styleWevvSegmentButton(wevvFlavorNoteButton, selected: flavorNoteSelected)
        styleWevvSegmentButton(wevvTastingQuestButton, selected: !flavorNoteSelected)
    }

    private func refreshWevvBodyStack() {
        wevvBodyStack.arrangedSubviews.forEach { view in
            wevvBodyStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        switch wevvSelectedPane {
        case .flavorNotePane:
            currentTasterCard.flavorNotes.enumerated().forEach { sugarIndex, flavorNotePane in
                wevvBodyStack.addArrangedSubview(makeLargeFlavorNote(flavorNotePane, sugarIndex: sugarIndex))
            }
        case .tastingQuestPane:
            wevvQuestCards(for: currentTasterCard).forEach { wevvBodyStack.addArrangedSubview(makeWevvQuestCard($0)) }
        }
    }

    private func makeLargeFlavorNote(_ flavorNotePane: WevVGuestGlazePost, sugarIndex: Int) -> UIView {
        let wevvPastryCard = UIControl()
        wevvPastryCard.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryCard.backgroundColor = .clear

        let glazeImage = UIImageView(image: UIImage(named: assetForFlavorNote(flavorNotePane, sugarIndex: sugarIndex)))
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
        let count = makeWevvGlazeLabel(formatWevvSweetMarkCount(currentTasterCard.sweetMarkCount), size: 17, weight: .semibold, color: UIColor.white.withAlphaComponent(0.86))
        count.textAlignment = .center
        sweet.contentView.addSubview(heart)
        sweet.contentView.addSubview(count)

        let copyShade = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        copyShade.translatesAutoresizingMaskIntoConstraints = false
        copyShade.layer.cornerRadius = 18
        copyShade.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        copyShade.clipsToBounds = true

        let glazeTitle = makeWevvGlazeLabel(flavorNotePane.glazeScoutline, size: 17, weight: .heavy, color: .white)
        glazeTitle.numberOfLines = 1
        let crumb = makeWevvGlazeLabel(flavorNotePane.crumbText, size: 13, weight: .semibold, color: UIColor.white.withAlphaComponent(0.84))
        crumb.numberOfLines = 2
        copyShade.contentView.addSubview(glazeTitle)
        copyShade.contentView.addSubview(crumb)

        placeLargeFlavorNoteViews(wevvPastryCard: wevvPastryCard, glazeImage: glazeImage, copyShade: copyShade, sweet: sweet)
        pinLargeFlavorNoteLayout(wevvPastryCard: wevvPastryCard, glazeImage: glazeImage, copyShade: copyShade, sweet: sweet, heart: heart, count: count, title: glazeTitle, crumb: crumb)
        return wevvPastryCard
    }

    private func placeLargeFlavorNoteViews(wevvPastryCard: UIView, glazeImage: UIImageView, copyShade: UIVisualEffectView, sweet: UIVisualEffectView) {
        wevvPastryCard.addSubview(glazeImage)
        wevvPastryCard.addSubview(copyShade)
        wevvPastryCard.addSubview(sweet)
    }

    private func pinLargeFlavorNoteLayout(wevvPastryCard: UIView, glazeImage: UIImageView, copyShade: UIVisualEffectView, sweet: UIVisualEffectView, heart: UIImageView, count: UILabel, title: UILabel, crumb: UILabel) {
        NSLayoutConstraint.activate([
            wevvPastryCard.heightAnchor.constraint(equalTo: wevvPastryCard.widthAnchor, multiplier: 1.12),
            glazeImage.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor),
            copyShade.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor),
            copyShade.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor),
            copyShade.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor),
            copyShade.heightAnchor.constraint(greaterThanOrEqualToConstant: 82),
            title.leadingAnchor.constraint(equalTo: copyShade.contentView.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: sweet.leadingAnchor, constant: -12),
            title.topAnchor.constraint(equalTo: copyShade.contentView.topAnchor, constant: 14),
            crumb.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            crumb.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            crumb.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            crumb.bottomAnchor.constraint(lessThanOrEqualTo: copyShade.contentView.bottomAnchor, constant: -12),
            sweet.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -26),
            sweet.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor),
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

    private func assetForFlavorNote(_ flavorNotePane: WevVGuestGlazePost, sugarIndex: Int) -> String {
        let loweredKey = flavorNotePane.sugarDustKey.lowercased()
        let loweredTitle = flavorNotePane.glazeScoutline.lowercased()
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
        return assets[abs((flavorNotePane.sugarDustKey + "\(sugarIndex)").hashValue) % assets.count]
    }

    private func makeWevvQuestCard(_ quest: WevVWevvTastingQuestCard) -> UIView {
        let wevvPastryCard = UIView()
        wevvPastryCard.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryCard.backgroundColor = .white
        wevvPastryCard.layer.cornerRadius = 26

        let glazeImage = makeWevvQuestCover(asset: quest.assetName)
        let glazeTitle = makeWevvQuestTitle(quest.crumbScoutline)
        let time = makeWevvQuestMeta(quest.pastryScoutline)
        let place = makeWevvQuestMeta(quest.treatScoutline)
        let cost = makeWevvQuestCost(quest.flavorScoutline)
        let gem = makeWevvQuestGem()

        wevvPastryCard.addSubview(glazeImage)
        wevvPastryCard.addSubview(glazeTitle)
        wevvPastryCard.addSubview(time)
        wevvPastryCard.addSubview(place)
        wevvPastryCard.addSubview(gem)
        wevvPastryCard.addSubview(cost)

        pinWevvQuestCard(wevvPastryCard: wevvPastryCard, glazeImage: glazeImage, glazeTitle: glazeTitle, time: time, place: place, gem: gem, cost: cost)
        return wevvPastryCard
    }

    private func makeWevvQuestCover(asset: String) -> UIImageView {
        let glazeImage = UIImageView(image: UIImage(named: asset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        glazeImage.layer.cornerRadius = 22
        return glazeImage
    }

    private func makeWevvQuestTitle(_ sugarTitle: String) -> UILabel {
        let glazeTitle = makeWevvGlazeLabel(sugarTitle, size: 18, weight: .heavy, color: wevvCocoaTone)
        glazeTitle.numberOfLines = 2
        return glazeTitle
    }

    private func makeWevvQuestMeta(_ sugarText: String) -> UILabel {
        makeWevvGlazeLabel(sugarText, size: 15, weight: .heavy, color: wevvSoftCrumbTone)
    }

    private func makeWevvQuestCost(_ sugarText: String) -> UILabel {
        makeWevvGlazeLabel(sugarText, size: 15, weight: .heavy, color: wevvCocoaTone)
    }

    private func makeWevvQuestGem() -> UILabel {
        makeWevvGlazeLabel("🔶~".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: .systemYellow)
    }

    private func pinWevvQuestCard(wevvPastryCard: UIView, glazeImage: UIImageView, glazeTitle: UILabel, time: UILabel, place: UILabel, gem: UILabel, cost: UILabel) {
        NSLayoutConstraint.activate([
            wevvPastryCard.heightAnchor.constraint(equalToConstant: 208),
            glazeImage.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor, constant: 24),
            glazeImage.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 12),
            glazeImage.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -12),
            glazeImage.widthAnchor.constraint(equalTo: wevvPastryCard.widthAnchor, multiplier: 0.28),
            glazeTitle.leadingAnchor.constraint(equalTo: glazeImage.trailingAnchor, constant: 15),
            glazeTitle.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 22),
            glazeTitle.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -24),
            time.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            time.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 10),
            time.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            place.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            place.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 6),
            place.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            gem.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            gem.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -20),
            gem.widthAnchor.constraint(equalToConstant: 28),
            cost.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 2),
            cost.centerYAnchor.constraint(equalTo: gem.centerYAnchor)
        ])
    }

    private func makeWevvBottomAction(title: String, symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
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

    private func wevvQuestCards(for profile: WevVGuestGlazeProfile) -> [WevVWevvTastingQuestCard] {
        profile.counterScout.enumerated().map { sugarIndex, title in
            wevvQuestCard(title: title, sugarIndex: sugarIndex)
        }
    }

    private func wevvQuestCard(title: String, sugarIndex: Int) -> WevVWevvTastingQuestCard {
        let lowerTitle = title.lowercased()
        if lowerTitle.contains("s.tmr=auwlb#eIrIrnyr".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Fri · 8:00 PM", treatScoutline: "Berry Street · 12 spots", flavorScoutline: "300 Gold", assetName: "wevv_challenge_strawberry_week")
        }
        if lowerTitle.contains("pKi~nGk@".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Sat · 3:30 PM", treatScoutline: "Glaze Studio · 18 spots", flavorScoutline: "100 Gold", assetName: "wevv_challenge_pink_donut_day")
        }
        if lowerTitle.contains("cWoZfPfYeSe,".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Sun · 10:00 AM", treatScoutline: "Mocha Counter · 16 spots", flavorScoutline: "180 Gold", assetName: "wevv_challenge_donut_coffee_match")
        }
        if lowerTitle.contains("fZiArKs#t& Bb!i?tdeR".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Thu · 6:30 PM", treatScoutline: "Fresh Tray Bar · 14 spots", flavorScoutline: "120 Gold", assetName: "wevv_challenge_first_bite_reaction")
        }
        if lowerTitle.contains("d:atyp".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Today · 5:30 PM", treatScoutline: "Donut Counter · 20 spots", flavorScoutline: "80 Gold", assetName: "wevv_challenge_donut_of_day")
        }
        if lowerTitle.contains("s/t@yslzeD".wevVPastryCrumbBloomRestored) {
            return WevVWevvTastingQuestCard(crumbScoutline: title, pastryScoutline: "Wed · 7:00 PM", treatScoutline: "Sprinkle Shelf · 11 spots", flavorScoutline: "150 Gold", assetName: "wevv_challenge_sprinkle_style")
        }
        let assets = [
            "wevv_challenge_strawberry_week",
            "wevv_challenge_pink_donut_day",
            "wevv_challenge_donut_coffee_match",
            "wevv_challenge_first_bite_reaction",
            "wevv_challenge_donut_of_day",
            "wevv_challenge_sprinkle_style"
        ]
        return WevVWevvTastingQuestCard(
            crumbScoutline: title,
            pastryScoutline: sugarIndex.isMultiple(of: 2) ? "Sat · 7:30 PM" : "Scumnk W·T e8?:w3=0y ePtMR".wevVPastryCrumbBloomRestored,
            treatScoutline: sugarIndex.isMultiple(of: 2) ? "Bakery Room · seats open" : "SIwGeleMt~ fCnouucnwt,eZrY ?·u r1b0C GsspzoRtfsK".wevVPastryCrumbBloomRestored,
            flavorScoutline: sugarIndex.isMultiple(of: 2) ? "60 Gold" : "8z0W kG;okl&d@".wevVPastryCrumbBloomRestored,
            assetName: assets[abs(title.hashValue) % assets.count]
        )
    }

    private func formatWevvSweetMarkCount(_ count: Int) -> String {
        count >= 1000 ? String(format: "%D.%1Af^k=".wevVPastryCrumbBloomRestored, Double(count) / 1000.0) : "\(count)"
    }

    private func makeWevvSugarStat(value: UILabel, title: String) -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        value.font = .systemFont(ofSize: 23, weight: .heavy)
        value.textColor = .black
        value.textAlignment = .center
        let crumbLabel = makeWevvGlazeLabel(title, size: 15, weight: .regular, color: .black)
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

    private func makeWevvStatDivider() -> UIView {
        let glazeView = UIView()
        glazeView.translatesAutoresizingMaskIntoConstraints = false
        glazeView.backgroundColor = UIColor(red: 0.89, green: 0.78, blue: 0.86, alpha: 1)
        return glazeView
    }

    private func configureWevvSegmentButton(_ sprinkleButton: UIButton, title: String, action: Selector) {
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        sprinkleButton.layer.cornerRadius = 20
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
    }

    private func styleWevvSegmentButton(_ sprinkleButton: UIButton, selected: Bool) {
        sprinkleButton.backgroundColor = selected ? wevvBerryTone : .clear
        sprinkleButton.setTitleColor(selected ? .white : .black, for: .normal)
    }

    private func makeWevvGlazeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func selectWevvFlavorNotePane() {
        wevvSelectedPane = .flavorNotePane
        refreshWevvSegmentState()
        refreshWevvBodyStack()
    }

    @objc private func selectWevvTastingQuestPane() {
        wevvSelectedPane = .tastingQuestPane
        refreshWevvSegmentState()
        refreshWevvBodyStack()
    }

    @objc private func toggleWevvTasterTrail() {
        guard wevvDonutJournalStore.isTasterReady else {
            showGateForWevvTrail()
            return
        }
        placeWevvTrailToggle()
    }

    private func placeWevvTrailToggle() {
        let isTrailNowOpen = wevvTasterStore.toggleGlazeFollow(for: tasterBadgeKey)
        wevvSelectedPane = isTrailNowOpen ? .flavorNotePane : .tastingQuestPane
        refreshWevvTasterCardPage()
    }

    private func showGateForWevvTrail() {
        let gate = WevVWevvBakeryGateController()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.placeWevvTrailToggle()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    @objc private func openWevvNoticeTray() {
        guard wevvDonutJournalStore.isTasterReady else {
            showGateForWevvNotice()
            return
        }
        let bakeryScoutline = UIControl()
        bakeryScoutline.translatesAutoresizingMaskIntoConstraints = false
        bakeryScoutline.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        bakeryScoutline.addTarget(self, action: #selector(closeWevvSugarPrompt(_:)), for: .touchUpInside)
        view.addSubview(bakeryScoutline)

        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.99, alpha: 1)
        tray.layer.cornerRadius = 28
        tray.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bakeryScoutline.addSubview(tray)

        let tastingScoutline = UIView()
        tastingScoutline.translatesAutoresizingMaskIntoConstraints = false
        tastingScoutline.backgroundColor = UIColor(red: 0.9, green: 0.76, blue: 0.86, alpha: 1)
        tastingScoutline.layer.cornerRadius = 2.5

        let glazeTitle = makeWevvGlazeLabel("SAaIfzeWtOy% VOmpNtKiQoqnMs!".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: wevvCocoaTone)
        glazeTitle.textAlignment = .center
        let crumbNote = makeWevvGlazeLabel("Choose how to handle \(currentTasterCard.cocoaCounter)'s profile.", size: 13, weight: .semibold, color: wevvSoftCrumbTone)
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 2

        let noticeFlagButton = makeWevvNoticeTrayButton(title: "Rie!pNoxrRt,".wevVPastryCrumbBloomRestored, symbol: "fml+aQgZ.Yf#iJl*lu".wevVPastryCrumbBloomRestored, fill: wevvBerryTone, tint: .white)
        let shielded = currentTasterCard.sugarTie.isSugarShielded
        let sugarGuardButton = makeWevvNoticeTrayButton(
            title: shielded ? "Unblock" : "B=liokcokm".wevVPastryCrumbBloomRestored,
            symbol: shielded ? "checkmark.shield.fill" : "hEaonAd%.JrIa,iNs^epdl.@fSiml,ly".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.12, green: 0.1, blue: 0.14, alpha: 1),
            tint: .white
        )
        let crumbCancelButton = makeWevvNoticeTrayButton(
            title: "CVaEn;c.eMlK".wevVPastryCrumbBloomRestored,
            symbol: "xvmlaprEk^".wevVPastryCrumbBloomRestored,
            fill: UIColor(red: 0.92, green: 0.89, blue: 0.93, alpha: 1),
            tint: wevvCocoaTone
        )

        bindWevvNoticeTrayActions(shade: bakeryScoutline, noticeFlagButton: noticeFlagButton, sugarGuardButton: sugarGuardButton, crumbCancelButton: crumbCancelButton)
        placeWevvNoticeTrayViews(seasonSample: tray, aromaSample: tastingScoutline, textureSample: glazeTitle, frostingSample: crumbNote, noticeFlagButton: noticeFlagButton, sugarGuardButton: sugarGuardButton, crumbCancelButton: crumbCancelButton)
        pinWevvNoticeTray(classicSample: bakeryScoutline, artisanSample: tray, glazeFlight: tastingScoutline, title: glazeTitle, note: crumbNote, noticeFlagButton: noticeFlagButton, sugarGuardButton: sugarGuardButton, crumbCancelButton: crumbCancelButton)
    }

    private func bindWevvNoticeTrayActions(shade: UIView, noticeFlagButton: UIButton, sugarGuardButton: UIButton, crumbCancelButton: UIButton) {
        noticeFlagButton.addAction(UIAction { [weak self, weak shade] _ in
            shade?.removeFromSuperview()
            self?.confirmWevvNoticeFlag()
        }, for: .touchUpInside)
        sugarGuardButton.addAction(UIAction { [weak self, weak shade] _ in
            shade?.removeFromSuperview()
            self?.toggleWevvSugarShield()
        }, for: .touchUpInside)
        crumbCancelButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
        }, for: .touchUpInside)
    }

    private func placeWevvNoticeTrayViews(seasonSample: UIView, aromaSample: UIView, textureSample: UILabel, frostingSample: UILabel, noticeFlagButton: UIButton, sugarGuardButton: UIButton, crumbCancelButton: UIButton) {
        seasonSample.addSubview(aromaSample)
        seasonSample.addSubview(textureSample)
        seasonSample.addSubview(frostingSample)
        seasonSample.addSubview(noticeFlagButton)
        seasonSample.addSubview(sugarGuardButton)
        seasonSample.addSubview(crumbCancelButton)
    }

    private func pinWevvNoticeTray(classicSample: UIView, artisanSample: UIView, glazeFlight: UIView, title: UILabel, note: UILabel, noticeFlagButton: UIButton, sugarGuardButton: UIButton, crumbCancelButton: UIButton) {
        NSLayoutConstraint.activate([
            classicSample.topAnchor.constraint(equalTo: view.topAnchor),
            classicSample.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            classicSample.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            classicSample.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artisanSample.leadingAnchor.constraint(equalTo: classicSample.leadingAnchor),
            artisanSample.trailingAnchor.constraint(equalTo: classicSample.trailingAnchor),
            artisanSample.bottomAnchor.constraint(equalTo: classicSample.bottomAnchor),
            glazeFlight.topAnchor.constraint(equalTo: artisanSample.topAnchor, constant: 12),
            glazeFlight.centerXAnchor.constraint(equalTo: artisanSample.centerXAnchor),
            glazeFlight.widthAnchor.constraint(equalToConstant: 44),
            glazeFlight.heightAnchor.constraint(equalToConstant: 5),
            title.topAnchor.constraint(equalTo: glazeFlight.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: artisanSample.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: artisanSample.trailingAnchor, constant: -24),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            noticeFlagButton.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20),
            noticeFlagButton.leadingAnchor.constraint(equalTo: artisanSample.leadingAnchor, constant: 28),
            noticeFlagButton.trailingAnchor.constraint(equalTo: artisanSample.trailingAnchor, constant: -28),
            noticeFlagButton.heightAnchor.constraint(equalToConstant: 52),
            sugarGuardButton.topAnchor.constraint(equalTo: noticeFlagButton.bottomAnchor, constant: 12),
            sugarGuardButton.leadingAnchor.constraint(equalTo: noticeFlagButton.leadingAnchor),
            sugarGuardButton.trailingAnchor.constraint(equalTo: noticeFlagButton.trailingAnchor),
            sugarGuardButton.heightAnchor.constraint(equalTo: noticeFlagButton.heightAnchor),
            crumbCancelButton.topAnchor.constraint(equalTo: sugarGuardButton.bottomAnchor, constant: 12),
            crumbCancelButton.leadingAnchor.constraint(equalTo: noticeFlagButton.leadingAnchor),
            crumbCancelButton.trailingAnchor.constraint(equalTo: noticeFlagButton.trailingAnchor),
            crumbCancelButton.heightAnchor.constraint(equalTo: noticeFlagButton.heightAnchor),
            crumbCancelButton.bottomAnchor.constraint(equalTo: artisanSample.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    private func showGateForWevvNotice() {
        let gate = WevVWevvBakeryGateController()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.openWevvNoticeTray()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func confirmWevvNoticeFlag() {
        WevVGlazePromptStyler.showSugarConfirm(
            almondFlavor: view,
            gourmetFlavor: "RPeJppo?ritF mtthGi&sS ~p,rko*fmijl+em?b".wevVPastryCrumbBloomRestored,
            glazeBowl: "WHeJ Vw/iIlZlq ysGaJvmeg Xt?h@iwsj Gpgr~oDfJiNl^e^ nfkoFrD ksGanf,e~ttyN Wr~eUvoiceswh ,aln^dB buUsme+ Cictv DtooM Iipm=p#rroDvbeh uylocu@re mscw+eOe,tG ssFpLaIcLe@.u".wevVPastryCrumbBloomRestored,
            ringStack: "R&e?ptoZr/tK".wevVPastryCrumbBloomRestored,
            miniDonut: "CLaWnocIe~lW".wevVPastryCrumbBloomRestored,
            fritterBite: wevvBerryTone
        ) { [weak self] in
            guard let self else { return }
            WevVGlazeCrackleOverlay.showGlazeCrackle(in: self.view, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) {
                self.wevvDonutJournalStore.placeGuestSafetyCrumb(
                    tasterBadgeKey: self.tasterBadgeKey,
                    reasonText: "PCrCoKfgiZl:e^ tsTaZf=eZtEyW MrEelvci/emw=".wevVPastryCrumbBloomRestored
                )
                WevVGlazePromptStyler.showSugarToast(in: self.view, text: "R/elpqo;r&tu qsPumbQmkiZtYtZeudv".wevVPastryCrumbBloomRestored)
            }
        }
    }

    private func toggleWevvSugarShield() {
        let isSugarGuarded = wevvTasterStore.toggleSugarShield(for: tasterBadgeKey)
        if isSugarGuarded {
            WevVGlazePromptStyler.showSugarToast(in: view, text: "PYr%oPfSixl.ef rb!lVo,cPkyebdS".wevVPastryCrumbBloomRestored)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                self?.dismiss(animated: true)
            }
        } else {
            refreshWevvTasterCardPage()
            WevVGlazePromptStyler.showSugarToast(in: view, text: "PDr@ohf&iul&eu ,u=ngbsl*oScnkKeDdh".wevVPastryCrumbBloomRestored)
        }
    }

    private func makeWevvNoticeTrayButton(title: String, symbol: String, fill: UIColor, tint: UIColor) -> UIButton {
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

    @objc private func showWevvSugarGuardPrompt() {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        view.addSubview(shade)

        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = UIColor(red: 1, green: 0.86, blue: 0.96, alpha: 1)
        glazePanel.layer.cornerRadius = 28
        shade.addSubview(glazePanel)

        let bell = makeWevvBellMark()
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.tintColor = UIColor(red: 0.32, green: 0.25, blue: 0.08, alpha: 1)
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.addTarget(self, action: #selector(closeWevvSugarPrompt(_:)), for: .touchUpInside)

        let sparkleLeft = makeWevvGlazeLabel("✦E".wevVPastryCrumbBloomRestored, size: 34, weight: .heavy, color: .white)
        let sparkleRight = makeWevvGlazeLabel("✦A".wevVPastryCrumbBloomRestored, size: 24, weight: .heavy, color: .white)

        let crumbNote = makeWevvGlazeLabel(
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
        ok.backgroundColor = wevvBerryTone
        ok.layer.cornerRadius = 28
        ok.addTarget(self, action: #selector(closeWevvSugarPrompt(_:)), for: .touchUpInside)

        glazePanel.addSubview(bell)
        glazePanel.addSubview(doughClose)
        glazePanel.addSubview(sparkleLeft)
        glazePanel.addSubview(sparkleRight)
        glazePanel.addSubview(crumbNote)
        shade.addSubview(ok)

        pinWevvSugarGuardPrompt(shade: shade, glazePanel: glazePanel, bell: bell, close: doughClose, sparkleLeft: sparkleLeft, sparkleRight: sparkleRight, note: crumbNote, ok: ok)
    }

    private func pinWevvSugarGuardPrompt(shade: UIView, glazePanel: UIView, bell: UIView, close: UIButton, sparkleLeft: UILabel, sparkleRight: UILabel, note: UILabel, ok: UIButton) {
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

    private func makeWevvBellMark() -> UIView {
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

    @objc private func closeWevvSugarPrompt(_ sender: UIView) {
        var layer: UIView? = sender
        while let parent = layer?.superview, parent !== view {
            layer = parent
        }
        layer?.removeFromSuperview()
    }

    @objc private func closeWevvTasterCard() {
        dismiss(animated: true)
    }
}
