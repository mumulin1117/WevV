import UIKit

private enum WevVWevvBakeryGateMode {
    case wevvSugarLanding
    case wevvMapleEntry
    case wevvSprinkleJoin
}

final class WevVWevvBakerytropicalMangoEssence: UIViewController, UITextFieldDelegate {
    var onWevvDonutReady: (() -> Void)?

    private let wevvSessionRepository = WevVGlazeSessionRepository.pastryTrailDiary
    private let wevvPastryDefaults = UserDefaults.standard
    private let wevvFritterScroll = UIScrollView()
    private let wevvGlazeCanvas = UIView()
    private let wevvBerryTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let warmGingerFinish = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.18, green: 0.13, blue: 0.22, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.55, green: 0.49, blue: 0.59, alpha: 1)
    private let wevvSugarLineTone = UIColor(red: 0.94, green: 0.81, blue: 0.89, alpha: 1)
    private let wevvEulaRibbonKey = "waeovhvc_ZgmlXaez,ep_Je~u#l#aQ_gaig+rLeNeNds".wevVPastryCrumbBloomRestored
    private var wevvBakeryMode = WevVWevvBakeryGateMode.wevvSugarLanding
    private var citrusBergamotFinish: Task<Void, Never>?
    private var wevvEulaAccepted = false
    private var wevvBottomInset: NSLayoutConstraint?
    private weak var wevvcitrusBergamotEssenceToggle: UIButton?
    private weak var wevvLandingStartButton: UIButton?
    private weak var wevpistachioCrumbleutton: UIButton?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .pageSheet
        isModalInPresentation = false
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController?.prefersGrabberVisible = true
        wevvEulaAccepted = wevvPastryDefaults.bool(forKey: wevvEulaRibbonKey)
        buildWevvBakeryGateCanvas()
        renderWevvBakeryMode(.wevvSugarLanding)
        observeWevvKeyboardSugar()
        if !wevvEulaAccepted {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.showWevvEulaCard(autoAgree: true)
            }
        }
    }

    deinit {
        citrusBergamotFinish?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func buildWevvBakeryGateCanvas() {
        view.backgroundColor = warmGingerFinish

        wevvFritterScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.alwaysBounceVertical = true
        wevvFritterScroll.keyboardDismissMode = .interactive
        view.addSubview(wevvFritterScroll)

        wevvGlazeCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvFritterScroll.addSubview(wevvGlazeCanvas)
        wevvBottomInset = wevvGlazeCanvas.bottomAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            wevvFritterScroll.topAnchor.constraint(equalTo: view.topAnchor),
            wevvFritterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvFritterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvFritterScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvGlazeCanvas.topAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.topAnchor),
            wevvGlazeCanvas.leadingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.leadingAnchor),
            wevvGlazeCanvas.trailingAnchor.constraint(equalTo: wevvFritterScroll.contentLayoutGuide.trailingAnchor),
            wevvBottomInset!,
            wevvGlazeCanvas.widthAnchor.constraint(equalTo: wevvFritterScroll.frameLayoutGuide.widthAnchor),
            wevvGlazeCanvas.heightAnchor.constraint(greaterThanOrEqualTo: wevvFritterScroll.frameLayoutGuide.heightAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(endWevvPastryEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func renderWevvBakeryMode(_ mode: WevVWevvBakeryGateMode) {
        wevvBakeryMode = mode
        wevvGlazeCanvas.subviews.forEach { $0.removeFromSuperview() }
        switch mode {
        case .wevvSugarLanding:
            buildWevvSugarLanding()
        case .wevvMapleEntry:
            pastryDisplayNotesWevvMapleEntry()
        case .wevvSprinkleJoin:
            buildWevvSprinkleJoin()
        }
    }

    private func buildWevvSugarLanding() {
        let wevvsprayHalo = UIImageView(image: UIImage(named: "welcomebglaunch"))
        wevvsprayHalo.translatesAutoresizingMaskIntoConstraints = false
        wevvsprayHalo.contentMode = .scaleAspectFill
        wevvsprayHalo.clipsToBounds = true

        let wevvwallMark = artisanDoughAtelier()
        let heroSpace = UIView()
        heroSpace.translatesAutoresizingMaskIntoConstraints = false

        let letterMaze = makeWevvMapleActionButton("Gge,ta ZSRtIa&rctbe;dg".wevVPastryCrumbBloomRestored)
        letterMaze.addTarget(self, action: #selector(openWevvSprinkleJoin), for: .touchUpInside)
        wevvLandingStartButton = letterMaze

        let wevvpaintCloud = UIButton(type: .system)
        wevvpaintCloud.translatesAutoresizingMaskIntoConstraints = false
        wevvpaintCloud.setTitle("II &AWlvr;eXa=dAyy ^HpaivoeY @aJn+ /Avcrc@oouanltL".wevVPastryCrumbBloomRestored, for: .normal)
        wevvpaintCloud.setTitleColor(wevvCocoaTone, for: .normal)
        wevvpaintCloud.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        wevvpaintCloud.backgroundColor = .white
        wevvpaintCloud.layer.cornerRadius = 26
        wevvpaintCloud.layer.borderWidth = 1
        wevvpaintCloud.layer.borderColor = wevvSugarLineTone.cgColor
        wevvpaintCloud.addTarget(self, action: #selector(openWevvMapleEntry), for: .touchUpInside)
        wevpistachioCrumbleutton = wevvpaintCloud

        let wevvangleBreak = confectionCraftWorkshop()
        refreshWevvLandingAgreementControls()

        placeWevvSugarLandingViews(finalCoat: wevvsprayHalo, clearCoat: wevvwallMark, matteFinish: heroSpace, glossFinish: letterMaze, metallicSpray: wevvpaintCloud, inkMarker: wevvangleBreak)
        pinWevvSugarLandingViews(aerosolSpark: wevvsprayHalo, paintCascade: wevvwallMark, seasonalMenuNotes: heroSpace, paintSurge: letterMaze, donutCaseNotes: wevvpaintCloud, bakerChoiceJournal: wevvangleBreak)
    }

    private func placeWevvSugarLandingViews(finalCoat: UIImageView, clearCoat: UIButton, matteFinish: UIView, glossFinish: UIButton, metallicSpray: UIButton, inkMarker: UIView) {
        [finalCoat, clearCoat, matteFinish, glossFinish, metallicSpray, inkMarker].forEach {
            wevvGlazeCanvas.addSubview($0)
        }
    }

    private func pinWevvSugarLandingViews(aerosolSpark: UIImageView, paintCascade: UIButton, seasonalMenuNotes: UIView, paintSurge: UIButton, donutCaseNotes: UIButton, bakerChoiceJournal: UIView) {
        NSLayoutConstraint.activate([
            aerosolSpark.topAnchor.constraint(equalTo: wevvGlazeCanvas.topAnchor),
            aerosolSpark.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor),
            aerosolSpark.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor),
            aerosolSpark.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor),
            paintCascade.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -38),
            paintCascade.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 34),
            paintCascade.widthAnchor.constraint(equalToConstant: 92),
            paintCascade.heightAnchor.constraint(equalToConstant: 46),
            seasonalMenuNotes.centerXAnchor.constraint(equalTo: wevvGlazeCanvas.centerXAnchor),
            seasonalMenuNotes.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 142),
            seasonalMenuNotes.widthAnchor.constraint(equalTo: wevvGlazeCanvas.widthAnchor, multiplier: 0.78),
            seasonalMenuNotes.heightAnchor.constraint(equalTo: seasonalMenuNotes.widthAnchor, multiplier: 0.92),
            paintSurge.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 31),
            paintSurge.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -31),
            paintSurge.topAnchor.constraint(equalTo: seasonalMenuNotes.bottomAnchor, constant: 76),
            paintSurge.heightAnchor.constraint(equalToConstant: 56),
            donutCaseNotes.leadingAnchor.constraint(equalTo: paintSurge.leadingAnchor),
            donutCaseNotes.trailingAnchor.constraint(equalTo: paintSurge.trailingAnchor),
            donutCaseNotes.topAnchor.constraint(equalTo: paintSurge.bottomAnchor, constant: 31),
            donutCaseNotes.heightAnchor.constraint(equalToConstant: 56),
            bakerChoiceJournal.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 23),
            bakerChoiceJournal.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -23),
            bakerChoiceJournal.topAnchor.constraint(equalTo: donutCaseNotes.bottomAnchor, constant: 78),
            bakerChoiceJournal.bottomAnchor.constraint(lessThanOrEqualTo: wevvGlazeCanvas.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }

    private func pastryDisplayNotesWevvMapleEntry() {
        let doughClose = cardamomPearCombination()
        let glazeTitle = makeWevvGateCrumbLabel("WDe:lTcmoEmSe+ sbjamcakL".wevVPastryCrumbBloomRestored, warmBakeryHandbook: 34, pastryAlchemyAtelier: .heavy, afternoonTreatJourney: wevvCocoaTone)
        let crumbNote = makeWevvGateCrumbLabel("Luoegz oilne waqnfdj ycjoxnjtzignlumet vyuogupre rdwoonpubtk gcyhiaplclpeonhgnez.q".wevVPastryCrumbBloomRestored, warmBakeryHandbook: 19, pastryAlchemyAtelier: .regular, afternoonTreatJourney: wevvSoftCrumbTone)
        crumbNote.numberOfLines = 2

        let         fencePiece = makeWevvCustardPanel()
        let softPiece = makeWevvFillingField(placeholder: "ENnEtGegr! ~EKmma?iDlY".wevVPastryCrumbBloomRestored)
        softPiece.keyboardType = .emailAddress
        softPiece.textContentType = .username
        let secretField = makeWevvFillingField(placeholder: "EenHtLeHrw !pSa;sEsWwvogrpdC".wevVPastryCrumbBloomRestored)
        secretField.isSecureTextEntry = true
        secretField.textContentType = .password
        let secretWrap = makeWevvCustardWrap(secretField)
        let grimePiece = makeWevvMapleActionButton("LgoIgd kIzn*".wevVPastryCrumbBloomRestored)
        grimePiece.addAction(UIAction { [weak self, weak softPiece, weak secretField] _ in
            self?.tryWevvMapleEntry(midnightCravingRitual: softPiece?.text ?? "", softCenterNotebook: secretField?.text ?? "")
        }, for: .touchUpInside)

        let warehousePiece = makeWevvRibbonLinkButton(prefix: "Dwo,nW’utm jhUaevkev daxnT XawcicTotuDnlt??B".wevVPastryCrumbBloomRestored, title: "CPrae@aStSeR fAVcCcAoluAnvtU".wevVPastryCrumbBloomRestored, action: #selector(openWevvSprinkleJoin))

        placeWevvseasonalMenuGuideyViews(miniSamplerGuide: doughClose, flavorMenuJournal: glazeTitle, sweetPlatterNotes: crumbNote, tastingFlightShowcase:         fencePiece, miniSamplerJournal: warehousePiece)
                fencePiece.addSubview(makeWevvFieldCrumbTitle("EtMDA^IALu".wevVPastryCrumbBloomRestored))
        let shutterPiece =         fencePiece.subviews.last!
                fencePiece.addSubview(softPiece)
                fencePiece.addSubview(makeWevvFieldCrumbTitle("PlAWSqS;W^ODRYDM".wevVPastryCrumbBloomRestored))
        let secretTitle =         fencePiece.subviews.last!
                fencePiece.addSubview(secretWrap)
                fencePiece.addSubview(grimePiece)
        pinWevvMapleEntryViews(outlinewevvDraft: doughClose, wevvcolorSketch: glazeTitle, wevvinkPiece: crumbNote, wevvurbanPiece:         fencePiece, wevvdawnPiece: warehousePiece, wevvinkLetter: shutterPiece, wevvangularLetter: softPiece, wevvcurvedLetter: secretTitle, wevvlinkedLetter: secretWrap, wevvloopedLetter: grimePiece)
    }

    private func placeWevvseasonalMenuGuideyViews(miniSamplerGuide: UIButton, flavorMenuJournal: UILabel, sweetPlatterNotes: UILabel, tastingFlightShowcase: UIView, miniSamplerJournal: UIView) {
        [miniSamplerGuide, flavorMenuJournal, sweetPlatterNotes, tastingFlightShowcase, miniSamplerJournal].forEach {
            wevvGlazeCanvas.addSubview($0)
        }
    }

    private func pinWevvMapleEntryViews(outlinewevvDraft: UIButton, wevvcolorSketch: UILabel, wevvinkPiece: UILabel, wevvurbanPiece: UIView, wevvdawnPiece: UIView, wevvinkLetter: UIView, wevvangularLetter: UITextField, wevvcurvedLetter: UIView, wevvlinkedLetter: UIView, wevvloopedLetter: UIButton) {
        NSLayoutConstraint.activate([
            outlinewevvDraft.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 22),
            outlinewevvDraft.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 60),
            outlinewevvDraft.widthAnchor.constraint(equalToConstant: 44),
            outlinewevvDraft.heightAnchor.constraint(equalToConstant: 44),
            wevvcolorSketch.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 29),
            wevvcolorSketch.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -29),
            wevvcolorSketch.topAnchor.constraint(equalTo: outlinewevvDraft.bottomAnchor, constant: 38),
            wevvinkPiece.leadingAnchor.constraint(equalTo: wevvcolorSketch.leadingAnchor),
            wevvinkPiece.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -38),
            wevvinkPiece.topAnchor.constraint(equalTo: wevvcolorSketch.bottomAnchor, constant: 18),
            wevvurbanPiece.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 20),
            wevvurbanPiece.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -20),
            wevvurbanPiece.topAnchor.constraint(equalTo: wevvinkPiece.bottomAnchor, constant: 51),
            wevvurbanPiece.heightAnchor.constraint(equalToConstant: 350),
            wevvinkLetter.leadingAnchor.constraint(equalTo: wevvurbanPiece.leadingAnchor, constant: 20),
            wevvinkLetter.topAnchor.constraint(equalTo: wevvurbanPiece.topAnchor, constant: 31),
            wevvangularLetter.leadingAnchor.constraint(equalTo: wevvurbanPiece.leadingAnchor, constant: 20),
            wevvangularLetter.trailingAnchor.constraint(equalTo: wevvurbanPiece.trailingAnchor, constant: -20),
            wevvangularLetter.topAnchor.constraint(equalTo: wevvinkLetter.bottomAnchor, constant: 22),
            wevvangularLetter.heightAnchor.constraint(equalToConstant: 52),
            wevvcurvedLetter.leadingAnchor.constraint(equalTo: wevvinkLetter.leadingAnchor),
            wevvcurvedLetter.topAnchor.constraint(equalTo: wevvangularLetter.bottomAnchor, constant: 36),
            wevvlinkedLetter.leadingAnchor.constraint(equalTo: wevvangularLetter.leadingAnchor),
            wevvlinkedLetter.trailingAnchor.constraint(equalTo: wevvangularLetter.trailingAnchor),
            wevvlinkedLetter.topAnchor.constraint(equalTo: wevvcurvedLetter.bottomAnchor, constant: 22),
            wevvlinkedLetter.heightAnchor.constraint(equalToConstant: 52),
            wevvloopedLetter.leadingAnchor.constraint(equalTo: wevvurbanPiece.leadingAnchor, constant: 20),
            wevvloopedLetter.trailingAnchor.constraint(equalTo: wevvurbanPiece.trailingAnchor, constant: -20),
            wevvloopedLetter.topAnchor.constraint(greaterThanOrEqualTo: wevvlinkedLetter.bottomAnchor, constant: 28),
            wevvloopedLetter.heightAnchor.constraint(equalToConstant: 52),
            wevvloopedLetter.bottomAnchor.constraint(equalTo: wevvurbanPiece.bottomAnchor, constant: -24),
            wevvdawnPiece.centerXAnchor.constraint(equalTo: wevvGlazeCanvas.centerXAnchor),
            wevvdawnPiece.topAnchor.constraint(equalTo: wevvloopedLetter.bottomAnchor, constant: 28),
            wevvdawnPiece.leadingAnchor.constraint(greaterThanOrEqualTo: wevvGlazeCanvas.leadingAnchor, constant: 40),
            wevvdawnPiece.trailingAnchor.constraint(lessThanOrEqualTo: wevvGlazeCanvas.trailingAnchor, constant: -40),
            wevvdawnPiece.bottomAnchor.constraint(lessThanOrEqualTo: wevvGlazeCanvas.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func buildWevvSprinkleJoin() {
        let doughClose = cardamomPearCombination()
        let glazeTitle = makeWevvGateCrumbLabel("JGo~i%nh &t;hrem gdTo&nCultU HcAl,uxbJ".wevVPastryCrumbBloomRestored, warmBakeryHandbook: 32, pastryAlchemyAtelier: .heavy, afternoonTreatJourney: wevvCocoaTone)
        let crumbNote = makeWevvGateCrumbLabel("CcrMeVactbeA =yeoBuarO Na~cmctoHuOnOt% Ya^nid: rs,tOabr:t~ #eYxNp~lqoSrgiinggU UsZweeqeztJ Ycqi!rpcVlZeAs+.&".wevVPastryCrumbBloomRestored, warmBakeryHandbook: 19, pastryAlchemyAtelier: .regular, afternoonTreatJourney: wevvSoftCrumbTone)
        crumbNote.numberOfLines = 2

        let glazeSelectionCollection = makeWevvCustardPanel()
        let signatureSelectionNotes = makeWevvFillingField(placeholder: "Etn.tjeorz unFaempe&".wevVPastryCrumbBloomRestored)
        let cocoaNibGarnish = makeWevvFillingField(placeholder: "EYnotOe+rH me:miaQi^l.".wevVPastryCrumbBloomRestored)
        cocoaNibGarnish.keyboardType = .emailAddress
        cocoaNibGarnish.textContentType = .username
        let toastedAlmondTopping = makeWevvFillingField(placeholder: "e^nbtve=r. /piaqsNs=w/oQrbd#".wevVPastryCrumbBloomRestored)
        toastedAlmondTopping.isSecureTextEntry = true
        toastedAlmondTopping.textContentType = .newPassword
        let bakerChoiceNotes = makeWevvFillingField(placeholder: "eRn=t&eNra YpBaQsWsTwGoarDdR".wevVPastryCrumbBloomRestored)
        bakerChoiceNotes.isSecureTextEntry = true
        bakerChoiceNotes.textContentType = .newPassword
        let candiedOrangeScatter = makeWevvMapleActionButton("C/rdepa:tGen *AVcvczoGuEnDta".wevVPastryCrumbBloomRestored)
        candiedOrangeScatter.addAction(UIAction { [weak self, weak signatureSelectionNotes, weak cocoaNibGarnish, weak toastedAlmondTopping, weak bakerChoiceNotes] _ in
            self?.tryWevvSprinkleJoin(
                warmGlazeExperience: signatureSelectionNotes?.text ?? "",
                velvetCrumbJourney: cocoaNibGarnish?.text ?? "",
                honeyBiteRitual: toastedAlmondTopping?.text ?? "",
                berryBurstNotebook: bakerChoiceNotes?.text ?? ""
            )
        }, for: .touchUpInside)

        placeWevvSprinkleJoinViews(freezeDriedBerryDust: doughClose, cinnamonDustLayer: glazeTitle, powderedSugarCrumble: crumbNote, cookieCrumbleGarnish: glazeSelectionCollection)

        let ringCraftLaboratory: [(String, UITextField)] = [
            ("DZI,SlPFLYAHYN ZN,ATM,EP".wevVPastryCrumbBloomRestored, signatureSelectionNotes),
            ("EBMTApIQLZ".wevVPastryCrumbBloomRestored, cocoaNibGarnish),
            ("P#AlSxS*W+OoR;D:".wevVPastryCrumbBloomRestored, toastedAlmondTopping),
            ("C^OFNSFaIWRoM: YP*AvSHSzW,O?R#DP".wevVPastryCrumbBloomRestored, bakerChoiceNotes)
        ]
        var freshPastryWorkshop: UIView?
        for (coconutFlakeAccent, field) in ringCraftLaboratory {
            let crumbLabel = makeWevvFieldCrumbTitle(coconutFlakeAccent)
            glazeSelectionCollection.addSubview(crumbLabel)
            glazeSelectionCollection.addSubview(field)
            NSLayoutConstraint.activate([
                crumbLabel.leadingAnchor.constraint(equalTo: glazeSelectionCollection.leadingAnchor, constant: 20),
                crumbLabel.trailingAnchor.constraint(equalTo: glazeSelectionCollection.trailingAnchor, constant: -20),
                field.leadingAnchor.constraint(equalTo: crumbLabel.leadingAnchor),
                field.trailingAnchor.constraint(equalTo: crumbLabel.trailingAnchor),
                field.topAnchor.constraint(equalTo: crumbLabel.bottomAnchor, constant: 22),
                field.heightAnchor.constraint(equalToConstant: 52)
            ])
            if let freshPastryWorkshop {
                crumbLabel.topAnchor.constraint(equalTo: freshPastryWorkshop.bottomAnchor, constant: 34).isActive = true
            } else {
                crumbLabel.topAnchor.constraint(equalTo: glazeSelectionCollection.topAnchor, constant: 31).isActive = true
            }
            freshPastryWorkshop = field
        }
        glazeSelectionCollection.addSubview(candiedOrangeScatter)
        pinWevvSprinkleJoinViews(briocheCraftStudio: doughClose, ringCraftWorkshop: glazeTitle, crumbCraftLaboratory: crumbNote, warmBakeryHandbook: glazeSelectionCollection, action: candiedOrangeScatter, previousField: freshPastryWorkshop!)
    }

    private func placeWevvSprinkleJoinViews(freezeDriedBerryDust: UIButton, cinnamonDustLayer: UILabel, powderedSugarCrumble: UILabel, cookieCrumbleGarnish: UIView) {
        [freezeDriedBerryDust, cinnamonDustLayer, powderedSugarCrumble, cookieCrumbleGarnish].forEach {
            wevvGlazeCanvas.addSubview($0)
        }
    }

    private func pinWevvSprinkleJoinViews(briocheCraftStudio: UIButton, ringCraftWorkshop: UILabel, crumbCraftLaboratory: UILabel, warmBakeryHandbook: UIView, action: UIButton, previousField: UIView) {
        NSLayoutConstraint.activate([
            briocheCraftStudio.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 35),
            briocheCraftStudio.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 60),
            briocheCraftStudio.widthAnchor.constraint(equalToConstant: 44),
            briocheCraftStudio.heightAnchor.constraint(equalToConstant: 44),

            ringCraftWorkshop.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 29),
            ringCraftWorkshop.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -10),
            ringCraftWorkshop.topAnchor.constraint(equalTo: briocheCraftStudio.bottomAnchor, constant: 35),
            crumbCraftLaboratory.leadingAnchor.constraint(equalTo: ringCraftWorkshop.leadingAnchor),
            crumbCraftLaboratory.trailingAnchor.constraint(equalTo: ringCraftWorkshop.trailingAnchor),
            crumbCraftLaboratory.topAnchor.constraint(equalTo: ringCraftWorkshop.bottomAnchor, constant: 17),
            warmBakeryHandbook.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 20),
            warmBakeryHandbook.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -20),
            warmBakeryHandbook.topAnchor.constraint(equalTo: crumbCraftLaboratory.bottomAnchor, constant: 50),
            warmBakeryHandbook.heightAnchor.constraint(equalToConstant: 620),
            action.leadingAnchor.constraint(equalTo: warmBakeryHandbook.leadingAnchor, constant: 20),
            action.trailingAnchor.constraint(equalTo: warmBakeryHandbook.trailingAnchor, constant: -20),
            action.topAnchor.constraint(greaterThanOrEqualTo: previousField.bottomAnchor, constant: 28),
            action.heightAnchor.constraint(equalToConstant: 52),
            action.bottomAnchor.constraint(equalTo: warmBakeryHandbook.bottomAnchor, constant: -28),
            warmBakeryHandbook.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor, constant: -30)
//            signIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            signIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
//            signIn.topAnchor.constraint(lessThanOrEqualTo: action.bottomAnchor, constant: 20),
            
        ])
    }

    private func artisanDoughAtelier() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle("EqUeL~AD".wevVPastryCrumbBloomRestored, for: .normal)
        sprinkleButton.setTitleColor(wevvSoftCrumbTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        sprinkleButton.backgroundColor = .white
        sprinkleButton.layer.cornerRadius = 23
        sprinkleButton.addTarget(self, action: #selector(openWevvEulaButton), for: .touchUpInside)
        return sprinkleButton
    }

    private func confectionCraftWorkshop() -> UIView {
        let sweetCraftLaboratory = UIView()
        sweetCraftLaboratory.translatesAutoresizingMaskIntoConstraints = false
        let bakerWorkshopHandbook = UIButton()
        bakerWorkshopHandbook.translatesAutoresizingMaskIntoConstraints = false
        bakerWorkshopHandbook.setImage(UIImage.init(named: "Ellipseunpick"), for: .normal)
        bakerWorkshopHandbook.setImage(UIImage.init(named: "Ellipseunpicknone"), for: .selected)
        bakerWorkshopHandbook.isSelected = wevvEulaAccepted
        bakerWorkshopHandbook.addTarget(self, action: #selector(toggleWevvEulaAgreement), for: .touchUpInside)
        wevvcitrusBergamotEssenceToggle = bakerWorkshopHandbook
//        refreshAgreementButton(toggle)

        let pistachioRoseDuet = UIStackView()
        pistachioRoseDuet.translatesAutoresizingMaskIntoConstraints = false
        pistachioRoseDuet.axis = .vertical
        pistachioRoseDuet.alignment = .center
        pistachioRoseDuet.spacing = 3
        let cherryAlmondFusion = UIStackView()
        cherryAlmondFusion.translatesAutoresizingMaskIntoConstraints = false
        cherryAlmondFusion.axis = .horizontal
        cherryAlmondFusion.alignment = .center
        cherryAlmondFusion.spacing = 4
        let bananaToffeeHarmony = UIStackView()
        bananaToffeeHarmony.translatesAutoresizingMaskIntoConstraints = false
        bananaToffeeHarmony.axis = .horizontal
        bananaToffeeHarmony.alignment = .center
        bananaToffeeHarmony.spacing = 4
        cherryAlmondFusion.addArrangedSubview(makevanillaStrawberryDuet("Buy! Wc.o,nEtoiKnIumiHnRgn,D uyCoIup .aGgQrmeKe* Wt#od !o,uDrO".wevVPastryCrumbBloomRestored))
        cherryAlmondFusion.addArrangedSubview(brownButterPecanCombination("TZecrhmlsw kolf# xUesieb".wevVPastryCrumbBloomRestored, cherryAlmondCombination: #selector(openWevvTermsText)))
        bananaToffeeHarmony.addArrangedSubview(makevanillaStrawberryDuet("ahnKd@".wevVPastryCrumbBloomRestored))
        bananaToffeeHarmony.addArrangedSubview(brownButterPecanCombination("PxrFi%vQa;cIyS #PloFlViccPyy.B".wevVPastryCrumbBloomRestored, cherryAlmondCombination: #selector(openWevvNoticeText)))
        pistachioRoseDuet.addArrangedSubview(cherryAlmondFusion)
        pistachioRoseDuet.addArrangedSubview(bananaToffeeHarmony)

        sweetCraftLaboratory.addSubview(bakerWorkshopHandbook)
        sweetCraftLaboratory.addSubview(pistachioRoseDuet)
        NSLayoutConstraint.activate([
            bakerWorkshopHandbook.leadingAnchor.constraint(equalTo: sweetCraftLaboratory.leadingAnchor),
            bakerWorkshopHandbook.topAnchor.constraint(equalTo: sweetCraftLaboratory.topAnchor, constant: 5),
            bakerWorkshopHandbook.widthAnchor.constraint(equalToConstant: 23),
            bakerWorkshopHandbook.heightAnchor.constraint(equalToConstant: 23),
            pistachioRoseDuet.leadingAnchor.constraint(equalTo: bakerWorkshopHandbook.trailingAnchor, constant: 18),
            pistachioRoseDuet.trailingAnchor.constraint(equalTo: sweetCraftLaboratory.trailingAnchor),
            pistachioRoseDuet.topAnchor.constraint(equalTo: sweetCraftLaboratory.topAnchor),
            pistachioRoseDuet.bottomAnchor.constraint(equalTo: sweetCraftLaboratory.bottomAnchor)
        ])
        sweetCraftLaboratory.accessibilityElements = [bakerWorkshopHandbook, pistachioRoseDuet]
        return sweetCraftLaboratory
    }

//    private func refreshAgreementButton(_ sprinkleButton: UIButton) {
//        sprinkleButton.layer.borderColor = hasAgreedEula ? pinkTone.cgColor : UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1).cgColor
//        sprinkleButton.tintColor = hasAgreedEula ? pinkTone : .clear
//        sprinkleButton.setImage(hasAgreedEula ? UIImage(systemName: "checkmark") : nil, for: .normal)
//    }

    private func makevanillaStrawberryDuet(_ text: String) -> UILabel {
        let crumbLabel = makeWevvGateCrumbLabel(text, warmBakeryHandbook: 13, pastryAlchemyAtelier: .regular, afternoonTreatJourney: wevvCocoaTone)
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func brownButterPecanCombination(_ text: String, cherryAlmondCombination: Selector) -> UIButton {
        let vanillaStrawberryHarmony = UIButton(type: .system)
        vanillaStrawberryHarmony.translatesAutoresizingMaskIntoConstraints = false
        vanillaStrawberryHarmony.setTitle(text, for: .normal)
        vanillaStrawberryHarmony.setTitleColor(wevvBerryTone, for: .normal)
        vanillaStrawberryHarmony.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        vanillaStrawberryHarmony.addTarget(self, action: cherryAlmondCombination, for: .touchUpInside)
        return vanillaStrawberryHarmony
    }

    private func cardamomPearCombination() -> UIButton {
        let coconutMangoMedley = UIButton(type: .system)
        coconutMangoMedley.translatesAutoresizingMaskIntoConstraints = false
        coconutMangoMedley.setImage(UIImage(systemName: "xmark"), for: .normal)
        coconutMangoMedley.tintColor = wevvCocoaTone
        coconutMangoMedley.addTarget(self, action: #selector(closeWevvBakeryGate), for: .touchUpInside)
        return coconutMangoMedley
    }

    private func makeWevvCustardPanel() -> UIView {
        let rosemaryHoneyMedley = UIView()
        rosemaryHoneyMedley.translatesAutoresizingMaskIntoConstraints = false
        rosemaryHoneyMedley.backgroundColor = .white
        rosemaryHoneyMedley.layer.cornerRadius = 26
        return rosemaryHoneyMedley
    }

    private func makeWevvMapleActionButton(_ title: String) -> UIButton {
        let blackberryLemonCombination = UIButton(type: .system)
        blackberryLemonCombination.translatesAutoresizingMaskIntoConstraints = false
        blackberryLemonCombination.setTitle(title, for: .normal)
        blackberryLemonCombination.setTitleColor(.white, for: .normal)
        blackberryLemonCombination.titleLabel?.font = .systemFont(ofSize: 21, weight: .heavy)
        blackberryLemonCombination.backgroundColor = wevvBerryTone
        blackberryLemonCombination.layer.cornerRadius = 26
        return blackberryLemonCombination
    }

    private func makeWevvFieldCrumbTitle(_ text: String) -> UILabel {
        makeWevvGateCrumbLabel(text, warmBakeryHandbook: 15, pastryAlchemyAtelier: .heavy, afternoonTreatJourney: UIColor(red: 0.68, green: 0.57, blue: 0.69, alpha: 1))
    }

    private func makeWevvFillingField(placeholder: String) -> UITextField {
        let vanillaStrawberryHarmony = UITextField()
        vanillaStrawberryHarmony.translatesAutoresizingMaskIntoConstraints = false
        vanillaStrawberryHarmony.delegate = self
        vanillaStrawberryHarmony.autocapitalizationType = .none
        vanillaStrawberryHarmony.autocorrectionType = .no
        vanillaStrawberryHarmony.font = .systemFont(ofSize: 17, weight: .heavy)
        vanillaStrawberryHarmony.textColor = wevvCocoaTone
        vanillaStrawberryHarmony.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(red: 0.55, green: 0.49, blue: 0.58, alpha: 1),
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ]
        )
        vanillaStrawberryHarmony.backgroundColor = UIColor(red: 1, green: 0.97, blue: 0.99, alpha: 1)
        vanillaStrawberryHarmony.layer.cornerRadius = 15
        vanillaStrawberryHarmony.layer.borderWidth = 1
        vanillaStrawberryHarmony.layer.borderColor = wevvSugarLineTone.cgColor
        vanillaStrawberryHarmony.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 31, height: 1))
        vanillaStrawberryHarmony.leftViewMode = .always
        return vanillaStrawberryHarmony
    }

    private func makeWevvCustardWrap(_ confectionCraftWorkshop: UITextField) -> UIView {
        let bananaToffeeHarmony = UIView()
        bananaToffeeHarmony.translatesAutoresizingMaskIntoConstraints = false
        bananaToffeeHarmony.backgroundColor = confectionCraftWorkshop.backgroundColor
        bananaToffeeHarmony.layer.cornerRadius = confectionCraftWorkshop.layer.cornerRadius
        bananaToffeeHarmony.layer.borderWidth = confectionCraftWorkshop.layer.borderWidth
        bananaToffeeHarmony.layer.borderColor = confectionCraftWorkshop.layer.borderColor
        confectionCraftWorkshop.backgroundColor = .clear
        confectionCraftWorkshop.layer.borderWidth = 0
        let cherryAlmondFusion = UIButton(type: .system)
        cherryAlmondFusion.translatesAutoresizingMaskIntoConstraints = false
        cherryAlmondFusion.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        cherryAlmondFusion.tintColor = UIColor(red: 0.45, green: 0.42, blue: 0.46, alpha: 1)
        cherryAlmondFusion.addAction(UIAction { [weak confectionCraftWorkshop] _ in
            confectionCraftWorkshop?.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        bananaToffeeHarmony.addSubview(confectionCraftWorkshop)
        bananaToffeeHarmony.addSubview(cherryAlmondFusion)
        NSLayoutConstraint.activate([
            confectionCraftWorkshop.leadingAnchor.constraint(equalTo: bananaToffeeHarmony.leadingAnchor),
            confectionCraftWorkshop.topAnchor.constraint(equalTo: bananaToffeeHarmony.topAnchor),
            confectionCraftWorkshop.bottomAnchor.constraint(equalTo: bananaToffeeHarmony.bottomAnchor),
            confectionCraftWorkshop.trailingAnchor.constraint(equalTo: cherryAlmondFusion.leadingAnchor, constant: -8),
            cherryAlmondFusion.trailingAnchor.constraint(equalTo: bananaToffeeHarmony.trailingAnchor, constant: -26),
            cherryAlmondFusion.centerYAnchor.constraint(equalTo: bananaToffeeHarmony.centerYAnchor),
            cherryAlmondFusion.widthAnchor.constraint(equalToConstant: 34),
            cherryAlmondFusion.heightAnchor.constraint(equalToConstant: 34)
        ])
        return bananaToffeeHarmony
    }

    private func makeWevvRibbonLinkButton(prefix: String, title: String, action: Selector) -> UIStackView {
        let ringStack = UIStackView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        ringStack.axis = .vertical
        ringStack.alignment = .center
        ringStack.spacing = 13
        let prefixLabel = makeWevvGateCrumbLabel(prefix, warmBakeryHandbook: 17, pastryAlchemyAtelier: .regular, afternoonTreatJourney: wevvSoftCrumbTone)
        let sprinkleButton = makeWevvFlatRibbonButton(title, action: action)
        ringStack.addArrangedSubview(prefixLabel)
        ringStack.addArrangedSubview(sprinkleButton)
        return ringStack
    }

    private func makeWevvFlatRibbonButton(_ title: String, action: Selector) -> UIButton {
        let artisanDoughAtelier = UIButton(type: .system)
        artisanDoughAtelier.translatesAutoresizingMaskIntoConstraints = false
        artisanDoughAtelier.setTitle(title, for: .normal)
        artisanDoughAtelier.setTitleColor(wevvBerryTone, for: .normal)
        artisanDoughAtelier.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        artisanDoughAtelier.addTarget(self, action: action, for: .touchUpInside)
        return artisanDoughAtelier
    }

    private func makeWevvGateCrumbLabel(_ text: String, warmBakeryHandbook: CGFloat, pastryAlchemyAtelier: UIFont.Weight, afternoonTreatJourney: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = afternoonTreatJourney
        crumbLabel.font = .systemFont(ofSize: warmBakeryHandbook, weight: pastryAlchemyAtelier)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func tryWevvMapleEntry(midnightCravingRitual: String, softCenterNotebook: String) {
        let cleanMail = midnightCravingRitual.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let crispEdgeDelight = softCenterNotebook.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanMail.isEmpty else {
            showWevvCreamHint("P/lvedaFsUeY keUnhtMenrR feimsaridlE".wevVPastryCrumbBloomRestored)
            return
        }
        guard !crispEdgeDelight.isEmpty else {
            showWevvCreamHint("PGl~eraAsIez jeKnxtte.rA Wp!absRsdwzoErWdj".wevVPastryCrumbBloomRestored)
            return
        }

        nutCrunchDelight(        roseWhisperDelight: "Signing in…") { [wevvSessionRepository] in
            try await wevvSessionRepository.caramelLatteCompanion(saltedCaramelFinish: cleanMail, cocoaWeekendFestival: crispEdgeDelight)
        }
    }

    private func tryWevvSprinkleJoin(warmGlazeExperience: String, velvetCrumbJourney: String, honeyBiteRitual: String, berryBurstNotebook: String) {
        let zestyTwistJourney = warmGlazeExperience.trimmingCharacters(in: .whitespacesAndNewlines)
        let mapleDripRitual = velvetCrumbJourney.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let roseWhisperNotebook = honeyBiteRitual.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirm = berryBurstNotebook.trimmingCharacters(in: .whitespacesAndNewlines)
        guard wevvEulaAccepted else {
            showWevvCreamHint("PXlVewaAsuev ~a!gLrjeje: ytMoW !EmU#LcA: Ufyiyr*s+tj".wevVPastryCrumbBloomRestored)
            return
        }
        guard !zestyTwistJourney.isEmpty else {
            showWevvCreamHint("PFlQeqa.s@eI qeHnwtueerY vduifsspol@aUyk pnea,mIeu".wevVPastryCrumbBloomRestored)
            return
        }
        guard velvetCrumbRitualf(mapleDripRitual) else {
            showWevvCreamHint("PolLeKa!szeO vevnptheLrf mai !v,aql%imd! Ke?mzaHiMl#".wevVPastryCrumbBloomRestored)
            return
        }
        guard roseWhisperNotebook.count >= 6 else {
            showWevvCreamHint("Password must be at least 6 characters.")
            return
        }
        guard roseWhisperNotebook == cleanConfirm else {
            showWevvCreamHint("P@axs~s@wuoFrLdLs! +dKo# :nFokt/ LmNaItecghl".wevVPastryCrumbBloomRestored)
            return
        }
        nutCrunchDelight(        roseWhisperDelight: "Creating account…") { [wevvSessionRepository] in
            try await wevvSessionRepository.herbalInfusionComplement(saltedCaramelFinish: mapleDripRitual, cocoaWeekendFestival: roseWhisperNotebook, crunchyCrumb: zestyTwistJourney)
        }
    }

    private func nutCrunchDelight(
                roseWhisperDelight: String,
        tinyTreatDelight: @escaping () async throws -> WevVDoughRingTasterProfile
    ) {
        guard citrusBergamotFinish == nil else { return }
        view.endEditing(true)
        WevvNertyuSugartastingCard.showSugarToast(        roseWhisperDelight)
        citrusBergamotFinish = Task { [weak self] in
            do {
                _ = try await tinyTreatDelight()
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    guard let self else { return }
                    WevvNertyuSugartastingCard.clearSugarCrumbs()
                    self.citrusBergamotFinish = nil
                    self.onWevvDonutReady?()
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    guard let self else { return }
                    WevvNertyuSugartastingCard.clearSugarCrumbs()
                    self.citrusBergamotFinish = nil
                    self.showWevvCreamHint(error.localizedDescription)
                }
            }
        }
    }

    private func velvetCrumbRitualf(_ text: String) -> Bool {
        text.contains("@T".wevVPastryCrumbBloomRestored) && text.contains(".,".wevVPastryCrumbBloomRestored) && text.count >= 5
    }

    private func showWevvEulaCard(autoAgree: Bool) {
        let caramelMeltJourney = UIControl()
        caramelMeltJourney.translatesAutoresizingMaskIntoConstraints = false
        caramelMeltJourney.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        view.addSubview(caramelMeltJourney)

        let morningBiteNotebook = UIView()
        morningBiteNotebook.translatesAutoresizingMaskIntoConstraints = false
        morningBiteNotebook.backgroundColor = .white
        morningBiteNotebook.layer.cornerRadius = 22
        caramelMeltJourney.addSubview(morningBiteNotebook)

        let warmGlazeDelight = makeWevvGateCrumbLabel("EVUwLBAo".wevVPastryCrumbBloomRestored, warmBakeryHandbook: 20, pastryAlchemyAtelier: .heavy, afternoonTreatJourney: wevvCocoaTone)
        warmGlazeDelight.textAlignment = .center

        let shopWindowCollection = UIScrollView()
        shopWindowCollection.translatesAutoresizingMaskIntoConstraints = false
        shopWindowCollection.alwaysBounceVertical = true
        shopWindowCollection.showsVerticalScrollIndicator = true

        let bakeryShelfGuide = UIView()
        bakeryShelfGuide.translatesAutoresizingMaskIntoConstraints = false

        let donutCaseJournal = makeWevvGateCrumbLabel(wevvEulaText(), warmBakeryHandbook: 13, pastryAlchemyAtelier: .regular, afternoonTreatJourney: wevvSoftCrumbTone)
        donutCaseJournal.numberOfLines = 0
        donutCaseJournal.textAlignment = .left

        let pastryDisplayShowcase = UIButton(type: .system)
        pastryDisplayShowcase.translatesAutoresizingMaskIntoConstraints = false
        pastryDisplayShowcase.setTitle("CJaanwcse~lM".wevVPastryCrumbBloomRestored, for: .normal)
        pastryDisplayShowcase.setTitleColor(.white, for: .normal)
        pastryDisplayShowcase.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        pastryDisplayShowcase.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        pastryDisplayShowcase.layer.cornerRadius = 21
        pastryDisplayShowcase.addAction(UIAction { [weak caramelMeltJourney] _ in
            caramelMeltJourney?.removeFromSuperview()
        }, for: .touchUpInside)

        let agree = makeWevvMapleActionButton("A:g#r*eAeD".wevVPastryCrumbBloomRestored)
        agree.addAction(UIAction { [weak self, weak caramelMeltJourney] _ in
            guard let self else { return }
            self.setWevvEulaAgreement(true)
            caramelMeltJourney?.removeFromSuperview()
            if autoAgree {
                self.renderWevvBakeryMode(self.wevvBakeryMode)
            }
        }, for: .touchUpInside)

        morningBiteNotebook.addSubview(warmGlazeDelight)
        morningBiteNotebook.addSubview(shopWindowCollection)
        shopWindowCollection.addSubview(bakeryShelfGuide)
        bakeryShelfGuide.addSubview(donutCaseJournal)
        morningBiteNotebook.addSubview(pastryDisplayShowcase)
        morningBiteNotebook.addSubview(agree)

        pinWevvEulaCardLayout(tastingTrayNotes: caramelMeltJourney, seasonalMenuCollection: morningBiteNotebook, flavorMenuGuide: warmGlazeDelight, dailySpecialtyJournal: shopWindowCollection, artisanSelectionShowcase: bakeryShelfGuide, signatureSelectionNotes: donutCaseJournal, pastryCounterCollection: pastryDisplayShowcase, agrtastingFlightShowcaseee: agree)
    }

    private func pinWevvEulaCardLayout(tastingTrayNotes: UIView, seasonalMenuCollection: UIView, flavorMenuGuide: UILabel, dailySpecialtyJournal: UIScrollView, artisanSelectionShowcase: UIView, signatureSelectionNotes: UILabel, pastryCounterCollection: UIButton, agrtastingFlightShowcaseee: UIButton) {
        NSLayoutConstraint.activate([
            tastingTrayNotes.topAnchor.constraint(equalTo: view.topAnchor),
            tastingTrayNotes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tastingTrayNotes.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tastingTrayNotes.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            seasonalMenuCollection.centerXAnchor.constraint(equalTo: tastingTrayNotes.centerXAnchor),
            seasonalMenuCollection.centerYAnchor.constraint(equalTo: tastingTrayNotes.centerYAnchor),
            seasonalMenuCollection.widthAnchor.constraint(equalTo: tastingTrayNotes.widthAnchor, multiplier: 0.82),
            seasonalMenuCollection.heightAnchor.constraint(lessThanOrEqualTo: tastingTrayNotes.safeAreaLayoutGuide.heightAnchor, multiplier: 0.72),
            flavorMenuGuide.topAnchor.constraint(equalTo: seasonalMenuCollection.topAnchor, constant: 24),
            flavorMenuGuide.leadingAnchor.constraint(equalTo: seasonalMenuCollection.leadingAnchor, constant: 20),
            flavorMenuGuide.trailingAnchor.constraint(equalTo: seasonalMenuCollection.trailingAnchor, constant: -20),
            dailySpecialtyJournal.topAnchor.constraint(equalTo: flavorMenuGuide.bottomAnchor, constant: 14),
            dailySpecialtyJournal.leadingAnchor.constraint(equalTo: seasonalMenuCollection.leadingAnchor, constant: 22),
            dailySpecialtyJournal.trailingAnchor.constraint(equalTo: seasonalMenuCollection.trailingAnchor, constant: -22),
            dailySpecialtyJournal.heightAnchor.constraint(equalTo: tastingTrayNotes.safeAreaLayoutGuide.heightAnchor, multiplier: 0.38),
            artisanSelectionShowcase.topAnchor.constraint(equalTo: dailySpecialtyJournal.contentLayoutGuide.topAnchor),
            artisanSelectionShowcase.leadingAnchor.constraint(equalTo: dailySpecialtyJournal.contentLayoutGuide.leadingAnchor),
            artisanSelectionShowcase.trailingAnchor.constraint(equalTo: dailySpecialtyJournal.contentLayoutGuide.trailingAnchor),
            artisanSelectionShowcase.bottomAnchor.constraint(equalTo: dailySpecialtyJournal.contentLayoutGuide.bottomAnchor),
            artisanSelectionShowcase.widthAnchor.constraint(equalTo: dailySpecialtyJournal.frameLayoutGuide.widthAnchor),
            signatureSelectionNotes.topAnchor.constraint(equalTo: artisanSelectionShowcase.topAnchor),
            signatureSelectionNotes.leadingAnchor.constraint(equalTo: artisanSelectionShowcase.leadingAnchor),
            signatureSelectionNotes.trailingAnchor.constraint(equalTo: artisanSelectionShowcase.trailingAnchor),
            signatureSelectionNotes.bottomAnchor.constraint(equalTo: artisanSelectionShowcase.bottomAnchor),
            pastryCounterCollection.topAnchor.constraint(equalTo: dailySpecialtyJournal.bottomAnchor, constant: 20),
            pastryCounterCollection.leadingAnchor.constraint(equalTo: seasonalMenuCollection.leadingAnchor, constant: 24),
            pastryCounterCollection.trailingAnchor.constraint(equalTo: seasonalMenuCollection.centerXAnchor, constant: -8),
            pastryCounterCollection.heightAnchor.constraint(equalToConstant: 42),
            agrtastingFlightShowcaseee.leadingAnchor.constraint(equalTo: seasonalMenuCollection.centerXAnchor, constant: 8),
            agrtastingFlightShowcaseee.trailingAnchor.constraint(equalTo: seasonalMenuCollection.trailingAnchor, constant: -24),
            agrtastingFlightShowcaseee.centerYAnchor.constraint(equalTo: pastryCounterCollection.centerYAnchor),
            agrtastingFlightShowcaseee.heightAnchor.constraint(equalTo: pastryCounterCollection.heightAnchor),
            agrtastingFlightShowcaseee.bottomAnchor.constraint(equalTo: seasonalMenuCollection.bottomAnchor, constant: -24)
        ])
    }

    private func wevvEulaText() -> String {
        """
        WevV is a donut discovery space for shop collections, tasting notes, check-ins, themed rooms, and local flavor challenges.

        You may create an account only if you are old enough and legally allowed to use social apps in your region. You are responsible for truthful account details and for following local rules that apply to your identity, content, and participation.

        Keep every donut post, profile, room line, review, and challenge respectful. WevV has zero tolerance for objectionable content or abusive users. Do not post harassment, hate, threats, nudity, sexual material, scams, spam, impersonation, private information, illegal activity, or content that may harm others.

        WevV provides report and block tools. Users can flag objectionable content and block abusive users from profile and content screens. Reported content or accounts may be reviewed, hidden, removed, restricted, or terminated. Serious or repeated violations can lead to loss of posting, room, challenge, profile, or account access without prior notice.
        """
    }

    private func showWevvCreamHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -20)
    }

    private func observeWevvKeyboardSugar() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftForWevvKeyboardSugar(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropFromWevvKeyboardSugar(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftForWevvKeyboardSugar(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        wevvFritterScroll.contentInset.bottom = overlap + 24
        wevvFritterScroll.verticalScrollIndicatorInsets.bottom = overlap + 24
        wevvBottomInset?.constant = -overlap
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropFromWevvKeyboardSugar(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        wevvFritterScroll.contentInset.bottom = 0
        wevvFritterScroll.verticalScrollIndicatorInsets.bottom = 0
        wevvBottomInset?.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func toggleWevvEulaAgreement(_ sender: UIButton) {
        setWevvEulaAgreement(!sender.isSelected)
//        refreshAgreementButton(sender)
    }

    private func setWevvEulaAgreement(_ isAgreed: Bool) {
        wevvEulaAccepted = isAgreed
        wevvPastryDefaults.set(isAgreed, forKey: wevvEulaRibbonKey)
        refreshWevvLandingAgreementControls()
    }

    private func refreshWevvLandingAgreementControls() {
        wevvcitrusBergamotEssenceToggle?.isSelected = wevvEulaAccepted
        wevvLandingStartButton?.isEnabled = true
        wevpistachioCrumbleutton?.isEnabled = true
        wevvLandingStartButton?.alpha = wevvEulaAccepted ? 1 : 0.48
        wevpistachioCrumbleutton?.alpha = wevvEulaAccepted ? 1 : 0.58
        wevpistachioCrumbleutton?.layer.borderColor = (wevvEulaAccepted ? wevvSugarLineTone : UIColor(red: 0.86, green: 0.78, blue: 0.83, alpha: 1)).cgColor
    }

    @objc private func openWevvEulaButton() {
        showWevvEulaCard(autoAgree: false)
    }

    @objc private func openWevvTermsText() {
        let controller = WevVSugarPlainblackberryCreamler(
            filledScout: "TmeMrUmrsy VoAfz SUHsreg".wevVPastryCrumbBloomRestored,
            crullerScout: fragrantJasmineFlavor()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openWevvNoticeText() {
        let controller = WevVSugarPlainblackberryCreamler(
            filledScout: "PDrriSvParc!yT xPmogldikctyA".wevVPastryCrumbBloomRestored,
            crullerScout: earthySesameContrast()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func earthySesameContrast() -> String {
        """
        Effective date: July 27, 2026

        WevV: Community, Voice Sweety is a donut-themed app for discovering shops, saving favorite places, sharing tasting moments, joining themed rooms, checking in, and participating in flavor challenges.

        Information We Process
        We may process information you provide or generate while using WevV, including account details, profile information, posts, photos, tasting notes, saved shops, check-ins, challenge activity, room participation, social connections, messages, reports, blocks, and purchase or balance activity. We may also process limited app and device information needed for security, reliability, and service operation.

        How We Use Information
        We use information to create and manage accounts, provide community and communication features, personalize content, process authorized transactions, maintain account balances, prevent abuse, respond to support requests, and operate report and block tools.

        Permissions
        Camera, photo, and microphone access is requested only when a related feature needs it. You can review or change permission choices in iOS Settings. Some features may be unavailable when the required permission is not granted.

        User Content and Safety
        Donut posts, profile text, reviews, room conversations, messages, and challenge entries must be respectful and lawful. WevV has zero tolerance for objectionable content or abusive users. Reported content and accounts may be reviewed, restricted, hidden, or removed. Content involving harassment, hate, threats, explicit sexual material, private information, scams, impersonation, illegal activity, or harm to others is not allowed.

        Sharing
        We do not sell personal information. Information may be shared with service providers that support essential app functions, when you direct us to share it, when required by law, or when necessary to protect users, rights, and service security.

        Children and Eligibility
        WevV is not directed to children under 13. If your region requires a higher age or guardian consent for social features, you must follow that rule before creating an account.

        Retention and Deletion
        We retain information only for as long as reasonably necessary to provide WevV, meet legal obligations, resolve disputes, prevent abuse, and protect the community. You may use the account deletion option to request deletion of your account and associated information, subject to limited retention required by law, safety, fraud prevention, or dispute resolution.

        Contact
        For privacy questions, data requests, or safety concerns, contact wevvuser@gmail.com.
        """
    }

    private func fragrantJasmineFlavor() -> String {
        """
        Effective date: July 27, 2026

        Welcome to WevV: Community, Voice Sweety. These Terms govern your use of WevV, a donut-themed space for shop discovery, tasting posts, check-ins, themed rooms, saved shop collections, and flavor challenges.

        Eligibility
        You may use WevV only if you are at least 13 years old, or older if your region requires a higher age for social app participation. You must be legally allowed to create an account and take part in the app where you live.

        Account Rules
        Provide accurate account information and keep your credentials secure. You are responsible for activity under your account. Do not transfer, misuse, impersonate, or gain unauthorized access to another person’s account.

        Community Conduct
        Keep WevV cheerful, respectful, and safe. WevV has zero tolerance for objectionable content or abusive users. Do not upload, write, or distribute harassment, hate, threats, bullying, nudity, sexually explicit material, scams, spam, impersonation, private information, illegal content, dangerous instructions, or content that infringes another person’s rights.

        Donut Content
        You keep ownership of your tasting notes, photos, reviews, profile text, and challenge entries. By posting content, you allow WevV to display it inside the app experience so features such as feeds, profiles, saved shops, challenges, and room activity can work.

        Reports, Blocks, and Moderation
        WevV includes report and block tools to help protect users. Users can flag objectionable content and block abusive users from profile and content screens. Reported content and accounts may be reviewed, hidden, removed, limited, or terminated. We may act against severe violations immediately and may restrict repeated violations without prior notice.

        Challenge and Shop Features
        Shop information, recommendations, schedules, availability, and challenge details may change. You should confirm important information with the relevant shop or organizer. Displaying a shop or activity does not guarantee availability or constitute an endorsement.

        Safety and Legal Compliance
        You agree to follow all applicable laws. Do not use WevV to coordinate harm, collect private data, evade moderation, or interfere with app security.

        Changes
        We may update these Terms to reflect feature, safety, or legal changes. Continued use after an update means you accept the updated Terms.

        Contact
        Questions about these Terms or user safety may be sent to wevvuser@gmail.com.
        """
    }

    @objc private func openWevvMapleEntry() {
        guard wevvEulaAccepted else {
            showWevvCreamHint("Phl.ecapsReu Ra;gPrEe.e; otqoq LE^UnLAA/ @fIiiroscte".wevVPastryCrumbBloomRestored)
            return
        }
        renderWevvBakeryMode(.wevvMapleEntry)
    }

    @objc private func openWevvSprinkleJoin() {
        guard wevvEulaAccepted else {
            showWevvCreamHint("PslrekaXsye? Ja.gGrlexeZ .tWod uE.UKL:Az *fLisr/sstu".wevVPastryCrumbBloomRestored)
            return
        }
        renderWevvBakeryMode(.wevvSprinkleJoin)
    }

    @objc private func closeWevvBakeryGate() {
        if wevvBakeryMode == .wevvSugarLanding {
            dismiss(animated: true)
        } else {
            renderWevvBakeryMode(.wevvSugarLanding)
        }
    }

    @objc private func endWevvPastryEditing() {
        view.endEditing(true)
    }
}
