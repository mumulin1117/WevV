
import UIKit

final class WevVWevvTasterCardController: UIViewController {
    private enum WevvFlavorPane {
        case flavorNotePane
        case tastingQuestPane
    }

    private enum WevvRemoteTrailState {
        case notFollowed
        case waitingForFollowBack
        case mutual
    }

    private struct WevVWevvTastingQuestCard {
        let crumbScoutline: String
        let pastryScoutline: String
        let treatScoutline: String
        let flavorScoutline: String
        let assetName: String
    }

    private let tasterBadgeKey: String
    private let remoteUserID: Int64?
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
    private let wevvLockedFootLabel = UILabel()
    private let wevvActionFoot = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    private var wevvFirstStatCenter: NSLayoutConstraint?
    private var wevvSecondStatCenter: NSLayoutConstraint?
    private var wevvSelectedPane: WevvFlavorPane = .tastingQuestPane
    private let remoteRepository = WevVGlazeSocialRepository.pastryTrailDiary
    private let remoteStatus = UILabel()
    private var remoteCard: meltawayCrumb?
    private var remoteMoments: [butteryTexture] = []
    private var remoteTask: Task<Void, Never>?

    private let wevvBerryTone = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
    private let wevvBlushCreamTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.08, green: 0.07, blue: 0.12, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1)

    init(tasterBadgeKey: String) {
        self.tasterBadgeKey = tasterBadgeKey
        remoteUserID = Int64(tasterBadgeKey)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    init(userID: Int64) {
        tasterBadgeKey = String(userID)
        remoteUserID = userID
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if remoteUserID != nil {
            buildRemoteCardPage()
            loadRemoteCard()
            return
        }
        wevvSelectedPane = isDonutTrailOpen ? .flavorNotePane : .tastingQuestPane
        buildWevvTasterCardPage()
        refreshWevvTasterCardPage()
    }

    deinit { remoteTask?.cancel() }

    private var currentTasterCard: WevVGuestGlazeProfile {
        wevvTasterStore.profile(for: tasterBadgeKey)
    }

    private var isDonutTrailOpen: Bool {
        if remoteUserID != nil {
            return remoteTrailState == .mutual
        }
        return currentTasterCard.sugarTie.isGlazeFollowed
    }

    private var remoteTrailState: WevvRemoteTrailState {
        guard let remoteCard else { return .notFollowed }
        if remoteCard.velvetyCrumb || remoteCard.silkyCenter { return .mutual }
        return remoteCard.flakyLayer ? .waitingForFollowBack : .notFollowed
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
        wevvNameTitle.font = .systemFont(ofSize: 16, weight: .bold)
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
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            back.widthAnchor.constraint(equalToConstant: 36),
            back.heightAnchor.constraint(equalToConstant: 36),
            wevvNameTitle.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            wevvNameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wevvNameTitle.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 14),
            wevvNameTitle.trailingAnchor.constraint(lessThanOrEqualTo: dots.leadingAnchor, constant: -14),
            dots.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dots.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            dots.widthAnchor.constraint(equalToConstant: 36),
            dots.heightAnchor.constraint(equalToConstant: 36)
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
        wevvDonutAvatarView.layer.cornerRadius = 46

        wevvTrailButton.translatesAutoresizingMaskIntoConstraints = false
        wevvTrailButton.tintColor = .white
        wevvTrailButton.layer.cornerRadius = 14.5
        wevvTrailButton.addTarget(self, action: #selector(toggleWevvTasterTrail), for: .touchUpInside)

        wevvNameHero.translatesAutoresizingMaskIntoConstraints = false
        wevvNameHero.font = .systemFont(ofSize: 21, weight: .bold)
        wevvNameHero.textColor = .black
        wevvNameHero.adjustsFontSizeToFitWidth = true
        wevvNameHero.minimumScaleFactor = 0.68

        wevvFlavorLine.translatesAutoresizingMaskIntoConstraints = false
        wevvFlavorLine.font = .systemFont(ofSize: 13, weight: .semibold)
        wevvFlavorLine.textColor = wevvSoftCrumbTone
        wevvFlavorLine.adjustsFontSizeToFitWidth = true
        wevvFlavorLine.minimumScaleFactor = 0.68

        wevvBakeryLine.translatesAutoresizingMaskIntoConstraints = false
        wevvBakeryLine.font = .systemFont(ofSize: 12, weight: .medium)
        wevvBakeryLine.textColor = wevvSoftCrumbTone
        wevvBakeryLine.adjustsFontSizeToFitWidth = true
        wevvBakeryLine.minimumScaleFactor = 0.68
    }

    private func makeWevvTastingSegment() -> UIView {
        let segment = UIView()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.layer.cornerRadius = 21
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
        wevvBodyStack.spacing = 14
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
            wevvFritterScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            wevvFritterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvFritterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvFritterScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvGlazeCanvas.topAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.topAnchor),
            wevvGlazeCanvas.leadingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.leadingAnchor),
            wevvGlazeCanvas.trailingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.trailingAnchor),
            wevvGlazeCanvas.bottomAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.bottomAnchor),
            wevvGlazeCanvas.widthAnchor.constraint(equalTo: wevvFritterScroll.frameLayoutGuide.widthAnchor),
            wevvDonutAvatarView.topAnchor.constraint(equalTo: wevvGlazeCanvas.topAnchor, constant: 8),
            wevvDonutAvatarView.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 32),
            wevvDonutAvatarView.widthAnchor.constraint(equalToConstant: 92),
            wevvDonutAvatarView.heightAnchor.constraint(equalToConstant: 92),
            wevvTrailButton.centerXAnchor.constraint(equalTo: wevvDonutAvatarView.centerXAnchor),
            wevvTrailButton.bottomAnchor.constraint(equalTo: wevvDonutAvatarView.bottomAnchor, constant: 18),
            wevvTrailButton.widthAnchor.constraint(equalToConstant: 76),
            wevvTrailButton.heightAnchor.constraint(equalToConstant: 30),
            wevvNameHero.leadingAnchor.constraint(equalTo: wevvDonutAvatarView.trailingAnchor, constant: 24),
            wevvNameHero.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -24),
            wevvNameHero.topAnchor.constraint(equalTo: wevvDonutAvatarView.topAnchor, constant: 12),
            wevvFlavorLine.leadingAnchor.constraint(equalTo: wevvNameHero.leadingAnchor),
            wevvFlavorLine.trailingAnchor.constraint(equalTo: wevvNameHero.trailingAnchor),
            wevvFlavorLine.topAnchor.constraint(equalTo: wevvNameHero.bottomAnchor, constant: 10),
            wevvBakeryLine.leadingAnchor.constraint(equalTo: wevvNameHero.leadingAnchor),
            wevvBakeryLine.trailingAnchor.constraint(equalTo: wevvNameHero.trailingAnchor),
            wevvBakeryLine.topAnchor.constraint(equalTo: wevvFlavorLine.bottomAnchor, constant: 5),
            statRow.topAnchor.constraint(equalTo: wevvDonutAvatarView.bottomAnchor, constant: 46),
            statRow.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 36),
            statRow.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -36),
            statRow.heightAnchor.constraint(equalToConstant: 50),
            firstDivider.centerYAnchor.constraint(equalTo: statRow.centerYAnchor),
            firstStatCenter,
            firstDivider.widthAnchor.constraint(equalToConstant: 1),
            firstDivider.heightAnchor.constraint(equalToConstant: 32),
            secondDivider.centerYAnchor.constraint(equalTo: statRow.centerYAnchor),
            secondStatCenter,
            secondDivider.widthAnchor.constraint(equalToConstant: 1),
            secondDivider.heightAnchor.constraint(equalToConstant: 32),
            segment.topAnchor.constraint(equalTo: statRow.bottomAnchor, constant: 18),
            segment.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 20),
            segment.widthAnchor.constraint(equalTo: wevvGlazeCanvas.widthAnchor, multiplier: 0.62),
            segment.heightAnchor.constraint(equalToConstant: 42),
            wevvFlavorNoteButton.leadingAnchor.constraint(equalTo: segment.leadingAnchor, constant: 4),
            wevvFlavorNoteButton.topAnchor.constraint(equalTo: segment.topAnchor, constant: 4),
            wevvFlavorNoteButton.bottomAnchor.constraint(equalTo: segment.bottomAnchor, constant: -4),
            wevvFlavorNoteButton.widthAnchor.constraint(equalTo: segment.widthAnchor, multiplier: 0.5, constant: -4),
            wevvTastingQuestButton.trailingAnchor.constraint(equalTo: segment.trailingAnchor, constant: -4),
            wevvTastingQuestButton.topAnchor.constraint(equalTo: wevvFlavorNoteButton.topAnchor),
            wevvTastingQuestButton.bottomAnchor.constraint(equalTo: wevvFlavorNoteButton.bottomAnchor),
            wevvTastingQuestButton.widthAnchor.constraint(equalTo: wevvFlavorNoteButton.widthAnchor),
            wevvBodyStack.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 16),
            wevvBodyStack.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 20),
            wevvBodyStack.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -20),
            wevvBodyStack.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor, constant: -128)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statWidth = max(view.bounds.width - 72, 1)
        wevvFirstStatCenter?.constant = statWidth / 3
        wevvSecondStatCenter?.constant = -statWidth / 3
        wevvDonutAvatarView.layer.cornerRadius = wevvDonutAvatarView.bounds.height / 2
        wevvTrailButton.layer.cornerRadius = wevvTrailButton.bounds.height / 2
        wevvFlavorNoteButton.layer.cornerRadius = wevvFlavorNoteButton.bounds.height / 2
        wevvTastingQuestButton.layer.cornerRadius = wevvTastingQuestButton.bounds.height / 2
    }

    private func buildWevvLockedFoot() {
        wevvLockedFoot.translatesAutoresizingMaskIntoConstraints = false
        wevvLockedFoot.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        wevvLockedFoot.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)

        wevvLockedFootLabel.translatesAutoresizingMaskIntoConstraints = false
        wevvLockedFootLabel.font = .systemFont(ofSize: 11, weight: .medium)
        wevvLockedFootLabel.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.52, alpha: 1)
        wevvLockedFootLabel.numberOfLines = 0
        wevvLockedFootLabel.textAlignment = .left
        wevvLockedFoot.addSubview(wevvLockedFootLabel)
        view.addSubview(wevvLockedFoot)

        NSLayoutConstraint.activate([
            wevvLockedFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvLockedFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvLockedFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvLockedFoot.heightAnchor.constraint(equalToConstant: 96),
            wevvLockedFootLabel.leadingAnchor.constraint(equalTo: wevvLockedFoot.leadingAnchor, constant: 22),
            wevvLockedFootLabel.trailingAnchor.constraint(equalTo: wevvLockedFoot.trailingAnchor, constant: -22),
            wevvLockedFootLabel.topAnchor.constraint(equalTo: wevvLockedFoot.topAnchor, constant: 16),
            wevvLockedFootLabel.bottomAnchor.constraint(lessThanOrEqualTo: wevvLockedFoot.safeAreaLayoutGuide.bottomAnchor, constant: -8)
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
        if remoteUserID == nil {
            donutRibbonNote.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)
            sprinkleLensButton.addTarget(self, action: #selector(showWevvSugarGuardPrompt), for: .touchUpInside)
        } else {
            donutRibbonNote.addTarget(self, action: #selector(openRemoteChat), for: .touchUpInside)
            sprinkleLensButton.addTarget(self, action: #selector(openRemoteVideo), for: .touchUpInside)
        }
        wevvActionFoot.contentView.addSubview(donutRibbonNote)
        wevvActionFoot.contentView.addSubview(sprinkleLensButton)

        NSLayoutConstraint.activate([
            wevvActionFoot.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvActionFoot.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvActionFoot.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvActionFoot.heightAnchor.constraint(equalToConstant: 94),
            donutRibbonNote.leadingAnchor.constraint(equalTo: wevvActionFoot.contentView.leadingAnchor, constant: 24),
            donutRibbonNote.topAnchor.constraint(equalTo: wevvActionFoot.contentView.topAnchor, constant: 12),
            donutRibbonNote.heightAnchor.constraint(equalToConstant: 46),
            donutRibbonNote.trailingAnchor.constraint(equalTo: wevvActionFoot.contentView.centerXAnchor, constant: -7),
            sprinkleLensButton.leadingAnchor.constraint(equalTo: wevvActionFoot.contentView.centerXAnchor, constant: 7),
            sprinkleLensButton.trailingAnchor.constraint(equalTo: wevvActionFoot.contentView.trailingAnchor, constant: -24),
            sprinkleLensButton.topAnchor.constraint(equalTo: donutRibbonNote.topAnchor),
            sprinkleLensButton.heightAnchor.constraint(equalTo: donutRibbonNote.heightAnchor)
        ])
    }

    private func refreshWevvTasterCardPage() {
        let profile = currentTasterCard
        if let remoteCard {
            let signatureLines = remoteCard.yuzuHoneySwirl.components(separatedBy: "\n").filter { !$0.isEmpty }
            let bakeryPieces = ([remoteCard.fluffyTexture] + remoteCard.chewyCrust.prefix(1)).filter { !$0.isEmpty }
            wevvNameTitle.text = remoteCard.gingerHoneyDrizzle
            wevvNameHero.text = remoteCard.gingerHoneyDrizzle
            wevvFlavorLine.text = signatureLines.first ?? "Donut community member"
            wevvBakeryLine.text = bakeryPieces.isEmpty ? "Sharing sweet discoveries" : bakeryPieces.joined(separator: " · ")
            wevvKudosValue.text = "\(remoteCard.crunchyDough)"
            wevvTasterValue.text = "\(remoteCard.crispyBite)"
            wevvTrailValue.text = "\(remoteCard.tenderFinish)"
            setRemoteProfileImage(remoteCard.cheesecakeMousse, imageView: wevvDonutAvatarView)
        } else {
            let signatureLines = profile.trailQuest.components(separatedBy: "\n")
            wevvNameTitle.text = profile.cocoaCounter
            wevvNameHero.text = profile.cocoaCounter
            wevvFlavorLine.text = signatureLines.first ?? profile.trailQuest
            wevvBakeryLine.text = signatureLines.dropFirst().first ?? "S,wmepeKtS HgOlFatzie= mrQeYgcusl*aKrv".wevVPastryCrumbBloomRestored
            wevvKudosValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.sweetMarkCount))"
            wevvTasterValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.sprinkleTasterCount))"
            wevvTrailValue.text = "\(makeWevvTinyTastingStat(for: profile.donutPinKey, salt: profile.glazeTrailCount))"
            wevvDonutAvatarView.image = UIImage(named: profile.donutFrameAsset)
                ?? UIImage(named: "wevv_profile_avatar_piano_donut")
        }
        refreshWevvTrailButton()
        refreshWevvSegmentState()
        refreshWevvBodyStack()
        wevvLockedFoot.isHidden = isDonutTrailOpen
        wevvActionFoot.isHidden = !isDonutTrailOpen
        if remoteUserID != nil {
            switch remoteTrailState {
            case .notFollowed:
                wevvLockedFootLabel.text = "You can only send messages and videos to each other once you have followed one another. Please follow the user first and wait for them to follow you back."
            case .waitingForFollowBack:
                wevvLockedFootLabel.text = "Please wait for the other person to follow you to unlock the chat and video features."
            case .mutual:
                wevvLockedFootLabel.text = nil
            }
        }
        wevvFritterScroll.contentInset.bottom = isDonutTrailOpen ? 104 : 108
        wevvFritterScroll.verticalScrollIndicatorInsets.bottom = wevvFritterScroll.contentInset.bottom
    }

    private func makeWevvTinyTastingStat(for sugarDustKey: String, salt: Int) -> Int {
        let crumbSeed = sugarDustKey.unicodeScalars.reduce(salt) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        return abs(crumbSeed % 14) + 1
    }

    private func refreshWevvTrailButton() {
        if remoteUserID != nil {
            applyRemoteTrailButton(followed: remoteTrailState != .notFollowed, mutual: remoteTrailState == .mutual)
            return
        }
        let followed = currentTasterCard.sugarTie.isGlazeFollowed
        wevvTrailButton.backgroundColor = followed ? UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1) : wevvBerryTone
        wevvTrailButton.setImage(UIImage(systemName: followed ? "checkmark" : "plus"), for: .normal)
        wevvTrailButton.imageView?.contentMode = .scaleAspectFit
        wevvTrailButton.contentHorizontalAlignment = .center
    }

    private func applyRemoteTrailButton(followed: Bool, mutual: Bool) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        wevvTrailButton.backgroundColor = mutual ? UIColor(red: 0.18, green: 0.18, blue: 0.19, alpha: 1) : wevvBerryTone
        wevvTrailButton.setImage(
            UIImage(systemName: mutual ? "checkmark" : (followed ? "circle.dashed" : "plus"), withConfiguration: configuration),
            for: .normal
        )
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
            if remoteUserID != nil {
                if remoteMoments.isEmpty {
                    let empty = makeWevvGlazeLabel("No public posts yet.", size: 13, weight: .medium, color: wevvSoftCrumbTone)
                    empty.textAlignment = .center
                    wevvBodyStack.addArrangedSubview(empty)
                } else {
                    remoteMoments.forEach { wevvBodyStack.addArrangedSubview(makeRemoteMomentCard($0)) }
                }
            } else {
                currentTasterCard.flavorNotes.enumerated().forEach { sugarIndex, flavorNotePane in
                    wevvBodyStack.addArrangedSubview(makeLargeFlavorNote(flavorNotePane, sugarIndex: sugarIndex))
                }
            }
        case .tastingQuestPane:
            guard remoteUserID == nil,
                  WevVDonutcreamapricotFillinger.homeChallengeParticipantKeys.contains(tasterBadgeKey) else {
                let empty = makeWevvGlazeLabel("No challenge activity yet.", size: 13, weight: .medium, color: wevvSoftCrumbTone)
                empty.textAlignment = .center
                empty.numberOfLines = 0
                empty.heightAnchor.constraint(equalToConstant: 96).isActive = true
                wevvBodyStack.addArrangedSubview(empty)
                return
            }
            let quests = wevvQuestCards(for: currentTasterCard)
            quests.forEach { wevvBodyStack.addArrangedSubview(makeWevvQuestCard($0)) }
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
        wevvPastryCard.layer.cornerRadius = 16

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
        glazeImage.layer.cornerRadius = 14
        return glazeImage
    }

    private func makeWevvQuestTitle(_ sugarTitle: String) -> UILabel {
        let glazeTitle = makeWevvGlazeLabel(sugarTitle, size: 14, weight: .bold, color: wevvCocoaTone)
        glazeTitle.numberOfLines = 2
        return glazeTitle
    }

    private func makeWevvQuestMeta(_ sugarText: String) -> UILabel {
        makeWevvGlazeLabel(sugarText, size: 11, weight: .medium, color: wevvSoftCrumbTone)
    }

    private func makeWevvQuestCost(_ sugarText: String) -> UILabel {
        makeWevvGlazeLabel(sugarText, size: 12, weight: .semibold, color: wevvCocoaTone)
    }

    private func makeWevvQuestGem() -> UILabel {
        makeWevvGlazeLabel("🔶~".wevVPastryCrumbBloomRestored, size: 18, weight: .heavy, color: .systemYellow)
    }

    private func pinWevvQuestCard(wevvPastryCard: UIView, glazeImage: UIImageView, glazeTitle: UILabel, time: UILabel, place: UILabel, gem: UILabel, cost: UILabel) {
        NSLayoutConstraint.activate([
            wevvPastryCard.heightAnchor.constraint(equalToConstant: 136),
            glazeImage.leadingAnchor.constraint(equalTo: wevvPastryCard.leadingAnchor, constant: 10),
            glazeImage.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 10),
            glazeImage.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -10),
            glazeImage.widthAnchor.constraint(equalToConstant: 112),
            glazeTitle.leadingAnchor.constraint(equalTo: glazeImage.trailingAnchor, constant: 12),
            glazeTitle.topAnchor.constraint(equalTo: wevvPastryCard.topAnchor, constant: 15),
            glazeTitle.trailingAnchor.constraint(equalTo: wevvPastryCard.trailingAnchor, constant: -12),
            time.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            time.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 7),
            time.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            place.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            place.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 4),
            place.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            gem.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            gem.bottomAnchor.constraint(equalTo: wevvPastryCard.bottomAnchor, constant: -14),
            gem.widthAnchor.constraint(equalToConstant: 24),
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
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        sprinkleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sprinkleButton.titleLabel?.minimumScaleFactor = 0.82
        sprinkleButton.layer.cornerRadius = 23
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
        value.font = .systemFont(ofSize: 18, weight: .bold)
        value.textColor = .black
        value.textAlignment = .center
        let crumbLabel = makeWevvGlazeLabel(title, size: 12, weight: .regular, color: wevvSoftCrumbTone)
        crumbLabel.textAlignment = .center
        holder.addSubview(value)
        holder.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            value.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            value.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            value.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            crumbLabel.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 4),
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
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
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
        if remoteUserID != nil {
            toggleRemoteFollow()
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
        let gate = WevVWevvBakerytropicalMangoEssence()
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
        openRemoteSafety()
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
        let gate = WevVWevvBakerytropicalMangoEssence()
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

    private func buildRemoteCardPage() {
        wevvSelectedPane = .tastingQuestPane
        buildWevvTasterCardPage()
        refreshWevvTasterCardPage()
        remoteStatus.translatesAutoresizingMaskIntoConstraints = false
        remoteStatus.text = "Loading profile…"
        remoteStatus.textColor = wevvSoftCrumbTone
        remoteStatus.font = .systemFont(ofSize: 13, weight: .semibold)
        remoteStatus.textAlignment = .center
        remoteStatus.numberOfLines = 0
        view.addSubview(remoteStatus)
        NSLayoutConstraint.activate([
            remoteStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            remoteStatus.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            remoteStatus.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 28),
            remoteStatus.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -28)
        ])
    }

    private func loadRemoteCard(showsLoading: Bool = true) {
        guard let remoteUserID else { return }
        remoteTask?.cancel()
        if showsLoading {
            remoteStatus.isHidden = false
            remoteStatus.text = "Loading profile…"
        }
        remoteTask = Task { [weak self] in
            guard let self else { return }
            do {
                async let card = remoteRepository.smallBatchKitchen(vanillaBeanIcing: remoteUserID)
                async let starchGelatinizationStudy = remoteRepository.heritageMap(vanillaBeanIcing: remoteUserID)
                let result = try await (card, starchGelatinizationStudy)
                guard !Task.isCancelled else { return }
                remoteCard = result.0
                remoteMoments = result.1
                wevvSelectedPane = remoteTrailState == .mutual ? .flavorNotePane : .tastingQuestPane
                rebuildRemoteCard()
                remoteStatus.isHidden = true
            } catch {
                remoteStatus.text = error.localizedDescription
            }
            remoteTask = nil
        }
    }

    private func rebuildRemoteCard() {
        refreshWevvTasterCardPage()
    }

    private func makeRemoteMomentCard(_ moment: butteryTexture) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = String(moment.coconutCenter)
        card.backgroundColor = UIColor(red: 0.93, green: 0.83, blue: 0.9, alpha: 1)
        card.layer.cornerRadius = 18
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(openRemoteMoment(_:)), for: .touchUpInside)
        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        setRemoteProfileImage(moment.passionfruitFilling.first ?? remoteCard?.softCloudDough.first, imageView: cover)

        let report = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        report.translatesAutoresizingMaskIntoConstraints = false
        report.tintColor = .white
        report.contentMode = .scaleAspectFit

        let sweet = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        sweet.translatesAutoresizingMaskIntoConstraints = false
        sweet.layer.cornerRadius = 24
        sweet.clipsToBounds = true
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.tintColor = UIColor(red: 1, green: 0.16, blue: 0.38, alpha: 1)
        let count = makeRemoteLabel(formatWevvSweetMarkCount(moment.limeCream), size: 11, weight: .semibold, color: .white)
        count.textAlignment = .center
        sweet.contentView.addSubview(heart)
        sweet.contentView.addSubview(count)
        [cover, report, sweet].forEach(card.addSubview)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 1.12),
            cover.topAnchor.constraint(equalTo: card.topAnchor),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            report.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            report.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            report.widthAnchor.constraint(equalToConstant: 24),
            report.heightAnchor.constraint(equalToConstant: 24),
            sweet.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            sweet.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14),
            sweet.widthAnchor.constraint(equalToConstant: 48),
            sweet.heightAnchor.constraint(equalToConstant: 64),
            heart.centerXAnchor.constraint(equalTo: sweet.contentView.centerXAnchor),
            heart.topAnchor.constraint(equalTo: sweet.contentView.topAnchor, constant: 10),
            heart.widthAnchor.constraint(equalToConstant: 20),
            heart.heightAnchor.constraint(equalToConstant: 20),
            count.leadingAnchor.constraint(equalTo: sweet.contentView.leadingAnchor, constant: 3),
            count.trailingAnchor.constraint(equalTo: sweet.contentView.trailingAnchor, constant: -3),
            count.topAnchor.constraint(equalTo: heart.bottomAnchor, constant: 5)
        ])
        return card
    }

    private func makeRemoteLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    private func setRemoteProfileImage(_ text: String?, imageView: UIImageView) {
        let fallbackAvatar = UIImage(named: "wevv_profile_avatar_piano_donut")
            ?? UIImage(systemName: "person.crop.circle.fill")
        let cleanText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        imageView.image = (cleanText.flatMap { UIImage(named: $0) }) ?? fallbackAvatar
        imageView.tintColor = wevvBerryTone
        guard let cleanText, let url = URL(string: cleanText), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else { return }
        imageView.accessibilityIdentifier = cleanText
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if imageView?.accessibilityIdentifier == cleanText { imageView?.image = image } }
        }.resume()
    }

    @objc private func toggleRemoteFollow() {
        guard requireRemoteLogin(), let card = remoteCard, remoteTask == nil else { return }
        let shouldFollow = !card.flakyLayer
        applyRemoteTrailButton(followed: shouldFollow, mutual: false)
        remoteTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await remoteRepository.riversideBakery(vanillaBeanIcing: card.vanillaBeanIcing, autumnPecanCollection: shouldFollow)
                remoteTask = nil
                loadRemoteCard(showsLoading: false)
            } catch {
                remoteTask = nil
                refreshWevvTrailButton()
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    @objc private func openRemoteChat() {
        guard requireRemoteLogin(), let card = remoteCard, remoteTask == nil else { return }
        guard card.silkyCenter else {
            showWevvSugarGuardPrompt()
            return
        }
        remoteTask = Task { [weak self] in
            guard let self else { return }
            do {
                let confectionStudioCounter = try await remoteRepository.confectionStudioCounter(vanillaBeanIcing: card.vanillaBeanIcing, springyFinish: card.springyFinish)
                remoteTask = nil
                let controller = WevVGlazeMessageController(confectionStudioCounter: confectionStudioCounter)
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true)
            } catch {
                remoteTask = nil
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    @objc private func openRemoteVideo() {
        guard requireRemoteLogin(), let card = remoteCard else { return }
        guard card.silkyCenter else {
            showWevvSugarGuardPrompt()
            return
        }
        WevVGlazePromptStyler.showSugarToast(in: view, text: "Video calling is not available in this build.")
    }

    @objc private func openRemoteMoment(_ sender: UIControl) {
        guard let text = sender.accessibilityIdentifier, let id = Int64(text), let moment = remoteMoments.first(where: { $0.coconutCenter == id }) else { return }
        let controller = WevVWevvDonutMomentController(richCocoaFlavor: moment)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openRemoteSafety() {
        let isSugarGuarded = remoteCard?.delicateCrust ?? currentTasterCard.sugarTie.isSugarShielded
        let tray = WevVGlazeProfileSafetyTray(cocoaGuarded: isSugarGuarded)
        tray.pralineDismissAction = { [weak self, weak tray] in
            self?.hideRemoteSafetyView(tray)
        }
        tray.berryReportAction = { [weak self, weak tray] in
            self?.hideRemoteSafetyView(tray) {
                self?.presentRemoteReportSheet()
            }
        }
        tray.vanillaBlockAction = { [weak self, weak tray] in
            self?.hideRemoteSafetyView(tray) {
                self?.toggleRemoteSugarGuard()
            }
        }
        view.addSubview(tray)
        NSLayoutConstraint.activate([
            tray.topAnchor.constraint(equalTo: view.topAnchor),
            tray.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tray.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tray.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideRemoteSafetyView(_ safetyView: UIView?, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.16, animations: {
            safetyView?.alpha = 0
        }, completion: { _ in
            safetyView?.removeFromSuperview()
            completion?()
        })
    }

    private func presentRemoteReportSheet() {
        let sheet = WevVGlazeSafetySheet(shopPinKey: tasterBadgeKey, flavorChoices: remoteReportChoices())
        sheet.pralineDismissAction = { [weak self, weak sheet] in
            self?.hideRemoteSafetyView(sheet)
        }
        sheet.pralineSubmitAction = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.hideRemoteSafetyView(sheet)
            if let card = self.remoteCard {
                self.submitRemoteReport(card: card, packet: packet)
            } else {
                self.wevvDonutJournalStore.placeGuestSafetyCrumb(
                    tasterBadgeKey: self.tasterBadgeKey,
                    reasonText: self.remoteReportSuggestion(packet)
                )
                WevVGlazePromptStyler.showSugarToast(in: self.view, text: "Report submitted.")
            }
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func remoteReportChoices() -> [pastryCompendiumEdition] {
        [
            pastryCompendiumEdition(flavorLibraryEdition: "fake_photo", pastryDisplayShowcase: "Fake photo", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "scam_commercial", pastryDisplayShowcase: "Scam or commercial", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "not_interested", pastryDisplayShowcase: "Not interested", tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "other", pastryDisplayShowcase: "Other", tastingSequenceInsight: true)
        ]
    }

    private func submitRemoteReport(card: meltawayCrumb, packet: tastingPassportEdition) {
        guard remoteTask == nil else { return }
        let feedbackType: String
        switch packet.rainbowSprinkleDesign {
        case "fake_photo": feedbackType = "FRAUD"
        case "scam_commercial": feedbackType = "SPAM"
        default: feedbackType = "OTHER"
        }
        remoteTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await remoteRepository.marketStreetMap(
                    vanillaBeanIcing: card.vanillaBeanIcing,
                    moonlightFrostPalette: feedbackType,
                    confettiSugarPattern: remoteReportSuggestion(packet)
                )
                remoteTask = nil
                WevVGlazePromptStyler.showSugarToast(in: view, text: "Report submitted.")
            } catch {
                remoteTask = nil
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    private func remoteReportSuggestion(_ packet: tastingPassportEdition) -> String {
        let note = packet.tastingTrayNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        return note.isEmpty ? packet.flavorMenuGuide : "\(packet.flavorMenuGuide): \(note)"
    }

    private func toggleRemoteSugarGuard() {
        guard let card = remoteCard else {
            toggleWevvSugarShield()
            return
        }
        guard remoteTask == nil else { return }
        remoteTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await remoteRepository.gardenLaneStudio(vanillaBeanIcing: card.vanillaBeanIcing, harvestPearPalette: !card.delicateCrust, springyFinish: card.springyFinish)
                remoteTask = nil
                loadRemoteCard()
            } catch {
                remoteTask = nil
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    private func requireRemoteLogin() -> Bool {
        guard wevvDonutJournalStore.isTasterReady else {
            let gate = WevVWevvBakerytropicalMangoEssence()
            gate.modalPresentationStyle = .pageSheet
            present(gate, animated: true)
            return false
        }
        return true
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
