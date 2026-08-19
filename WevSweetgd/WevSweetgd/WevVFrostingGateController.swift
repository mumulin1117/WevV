import UIKit

private enum WevVWevvBakeryGateMode {
    case wevvSugarLanding
    case wevvMapleEntry
    case wevvSprinkleJoin
}

private struct WevVWevvDoughRecord {
    let wevvcleanOutline: String
    let wevvhardOutline: String
    let wevvhighlightStroke: String
    let wevvwhitePop: String
}

private enum WevVWevvDoughAccessState {
    case wevvVanillaBloom(WevVWevvDoughRecord)
    case wevvCocoaFinish
    case wevvCrumbMismatch
}

final class WevVWevvBakeryGateController: UIViewController, UITextFieldDelegate {
    var onWevvDonutReady: (() -> Void)?

    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvPastryDefaults = UserDefaults.standard
    private let wevvFritterScroll = UIScrollView()
    private let wevvGlazeCanvas = UIView()
    private let wevvBerryTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let wevvCreamTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.18, green: 0.13, blue: 0.22, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.55, green: 0.49, blue: 0.59, alpha: 1)
    private let wevvSugarLineTone = UIColor(red: 0.94, green: 0.81, blue: 0.89, alpha: 1)
    private let wevvEulaRibbonKey = "waeovhvc_ZgmlXaez,ep_Je~u#l#aQ_gaig+rLeNeNds".wevVPastryCrumbBloomRestored
    private let wevvDoughTrayKey = "wBePv~ve_yg*l,arzVeo_olNowcsaZlX_UaPc,cUoTuhnHtTss".wevVPastryCrumbBloomRestored
    private let wevvCrumbDivider = "|x".wevVPastryCrumbBloomRestored
    private var wevvBakeryMode = WevVWevvBakeryGateMode.wevvSugarLanding
    private var wevvEulaAccepted = false
    private var wevvBottomInset: NSLayoutConstraint?
    private weak var wevvLandingAgreeToggle: UIButton?
    private weak var wevvLandingStartButton: UIButton?
    private weak var wevvLandingReturnButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        NotificationCenter.default.removeObserver(self)
    }

    private func buildWevvBakeryGateCanvas() {
        view.backgroundColor = wevvCreamTone

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
            buildWevvMapleEntry()
        case .wevvSprinkleJoin:
            buildWevvSprinkleJoin()
        }
    }

    private func buildWevvSugarLanding() {
        let wevvsprayHalo = UIImageView(image: UIImage(named: "welcomebglaunch"))
        wevvsprayHalo.translatesAutoresizingMaskIntoConstraints = false
        wevvsprayHalo.contentMode = .scaleAspectFill
        wevvsprayHalo.clipsToBounds = true

        let wevvwallMark = makeWevvEulaPill()
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
        wevvLandingReturnButton = wevvpaintCloud

        let wevvangleBreak = makeWevvEulaRow()
        refreshWevvLandingAgreementControls()

        placeWevvSugarLandingViews(finalCoat: wevvsprayHalo, clearCoat: wevvwallMark, matteFinish: heroSpace, glossFinish: letterMaze, metallicSpray: wevvpaintCloud, inkMarker: wevvangleBreak)
        pinWevvSugarLandingViews(aerosolSpark: wevvsprayHalo, paintCascade: wevvwallMark, paintRipple: heroSpace, paintSurge: letterMaze, inkSignal: wevvpaintCloud, inkQuest: wevvangleBreak)
    }

    private func placeWevvSugarLandingViews(finalCoat: UIImageView, clearCoat: UIButton, matteFinish: UIView, glossFinish: UIButton, metallicSpray: UIButton, inkMarker: UIView) {
        [finalCoat, clearCoat, matteFinish, glossFinish, metallicSpray, inkMarker].forEach {
            wevvGlazeCanvas.addSubview($0)
        }
    }

    private func pinWevvSugarLandingViews(aerosolSpark: UIImageView, paintCascade: UIButton, paintRipple: UIView, paintSurge: UIButton, inkSignal: UIButton, inkQuest: UIView) {
        NSLayoutConstraint.activate([
            aerosolSpark.topAnchor.constraint(equalTo: wevvGlazeCanvas.topAnchor),
            aerosolSpark.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor),
            aerosolSpark.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor),
            aerosolSpark.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor),
            paintCascade.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -38),
            paintCascade.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 34),
            paintCascade.widthAnchor.constraint(equalToConstant: 92),
            paintCascade.heightAnchor.constraint(equalToConstant: 46),
            paintRipple.centerXAnchor.constraint(equalTo: wevvGlazeCanvas.centerXAnchor),
            paintRipple.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 142),
            paintRipple.widthAnchor.constraint(equalTo: wevvGlazeCanvas.widthAnchor, multiplier: 0.78),
            paintRipple.heightAnchor.constraint(equalTo: paintRipple.widthAnchor, multiplier: 0.92),
            paintSurge.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 31),
            paintSurge.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -31),
            paintSurge.topAnchor.constraint(equalTo: paintRipple.bottomAnchor, constant: 76),
            paintSurge.heightAnchor.constraint(equalToConstant: 56),
            inkSignal.leadingAnchor.constraint(equalTo: paintSurge.leadingAnchor),
            inkSignal.trailingAnchor.constraint(equalTo: paintSurge.trailingAnchor),
            inkSignal.topAnchor.constraint(equalTo: paintSurge.bottomAnchor, constant: 31),
            inkSignal.heightAnchor.constraint(equalToConstant: 56),
            inkQuest.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 23),
            inkQuest.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -23),
            inkQuest.topAnchor.constraint(equalTo: inkSignal.bottomAnchor, constant: 78),
            inkQuest.bottomAnchor.constraint(lessThanOrEqualTo: wevvGlazeCanvas.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }

    private func buildWevvMapleEntry() {
        let doughClose = makeWevvCrullerCloseButton()
        let glazeTitle = makeWevvGateCrumbLabel("WDe:lTcmoEmSe+ sbjamcakL".wevVPastryCrumbBloomRestored, size: 34, weight: .heavy, color: wevvCocoaTone)
        let crumbNote = makeWevvGateCrumbLabel("Luoegz oilne waqnfdj ycjoxnjtzignlumet vyuogupre rdwoonpubtk gcyhiaplclpeonhgnez.q".wevVPastryCrumbBloomRestored, size: 19, weight: .regular, color: wevvSoftCrumbTone)
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
            self?.tryWevvMapleEntry(mail: softPiece?.text ?? "", secret: secretField?.text ?? "")
        }, for: .touchUpInside)

        let warehousePiece = makeWevvRibbonLinkButton(prefix: "Dwo,nW’utm jhUaevkev daxnT XawcicTotuDnlt??B".wevVPastryCrumbBloomRestored, title: "CPrae@aStSeR fAVcCcAoluAnvtU".wevVPastryCrumbBloomRestored, action: #selector(openWevvSprinkleJoin))

        placeWevvMapleEntryViews(close: doughClose, title: glazeTitle, note: crumbNote, form:         fencePiece, create: warehousePiece)
                fencePiece.addSubview(makeWevvFieldCrumbTitle("EtMDA^IALu".wevVPastryCrumbBloomRestored))
        let shutterPiece =         fencePiece.subviews.last!
                fencePiece.addSubview(softPiece)
                fencePiece.addSubview(makeWevvFieldCrumbTitle("PlAWSqS;W^ODRYDM".wevVPastryCrumbBloomRestored))
        let secretTitle =         fencePiece.subviews.last!
                fencePiece.addSubview(secretWrap)
                fencePiece.addSubview(grimePiece)
        pinWevvMapleEntryViews(outlinewevvDraft: doughClose, wevvcolorSketch: glazeTitle, wevvinkPiece: crumbNote, wevvurbanPiece:         fencePiece, wevvdawnPiece: warehousePiece, wevvinkLetter: shutterPiece, wevvangularLetter: softPiece, wevvcurvedLetter: secretTitle, wevvlinkedLetter: secretWrap, wevvloopedLetter: grimePiece)
    }

    private func placeWevvMapleEntryViews(close: UIButton, title: UILabel, note: UILabel, form: UIView, create: UIView) {
        [close, title, note, form, create].forEach {
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
        let doughClose = makeWevvCrullerCloseButton()
        let glazeTitle = makeWevvGateCrumbLabel("JGo~i%nh &t;hrem gdTo&nCultU HcAl,uxbJ".wevVPastryCrumbBloomRestored, size: 32, weight: .heavy, color: wevvCocoaTone)
        let crumbNote = makeWevvGateCrumbLabel("CcrMeVactbeA =yeoBuarO Na~cmctoHuOnOt% Ya^nid: rs,tOabr:t~ #eYxNp~lqoSrgiinggU UsZweeqeztJ Ycqi!rpcVlZeAs+.&".wevVPastryCrumbBloomRestored, size: 19, weight: .regular, color: wevvSoftCrumbTone)
        crumbNote.numberOfLines = 2

        let form = makeWevvCustardPanel()
        let nameField = makeWevvFillingField(placeholder: "Etn.tjeorz unFaempe&".wevVPastryCrumbBloomRestored)
        let mailField = makeWevvFillingField(placeholder: "EYnotOe+rH me:miaQi^l.".wevVPastryCrumbBloomRestored)
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .username
        let secretField = makeWevvFillingField(placeholder: "e^nbtve=r. /piaqsNs=w/oQrbd#".wevVPastryCrumbBloomRestored)
        secretField.isSecureTextEntry = true
        secretField.textContentType = .newPassword
        let confirmField = makeWevvFillingField(placeholder: "eRn=t&eNra YpBaQsWsTwGoarDdR".wevVPastryCrumbBloomRestored)
        confirmField.isSecureTextEntry = true
        confirmField.textContentType = .newPassword
        let action = makeWevvMapleActionButton("C/rdepa:tGen *AVcvczoGuEnDta".wevVPastryCrumbBloomRestored)
        action.addAction(UIAction { [weak self, weak nameField, weak mailField, weak secretField, weak confirmField] _ in
            self?.tryWevvSprinkleJoin(
                name: nameField?.text ?? "",
                mail: mailField?.text ?? "",
                secret: secretField?.text ?? "",
                confirm: confirmField?.text ?? ""
            )
        }, for: .touchUpInside)

        placeWevvSprinkleJoinViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form)

        let fields: [(String, UITextField)] = [
            ("DZI,SlPFLYAHYN ZN,ATM,EP".wevVPastryCrumbBloomRestored, nameField),
            ("EBMTApIQLZ".wevVPastryCrumbBloomRestored, mailField),
            ("P#AlSxS*W+OoR;D:".wevVPastryCrumbBloomRestored, secretField),
            ("C^OFNSFaIWRoM: YP*AvSHSzW,O?R#DP".wevVPastryCrumbBloomRestored, confirmField)
        ]
        var previousField: UIView?
        for (fieldTitle, field) in fields {
            let crumbLabel = makeWevvFieldCrumbTitle(fieldTitle)
            form.addSubview(crumbLabel)
            form.addSubview(field)
            NSLayoutConstraint.activate([
                crumbLabel.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
                crumbLabel.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
                field.leadingAnchor.constraint(equalTo: crumbLabel.leadingAnchor),
                field.trailingAnchor.constraint(equalTo: crumbLabel.trailingAnchor),
                field.topAnchor.constraint(equalTo: crumbLabel.bottomAnchor, constant: 22),
                field.heightAnchor.constraint(equalToConstant: 52)
            ])
            if let previousField {
                crumbLabel.topAnchor.constraint(equalTo: previousField.bottomAnchor, constant: 34).isActive = true
            } else {
                crumbLabel.topAnchor.constraint(equalTo: form.topAnchor, constant: 31).isActive = true
            }
            previousField = field
        }
        form.addSubview(action)
        pinWevvSprinkleJoinViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form, action: action, previousField: previousField!)
    }

    private func placeWevvSprinkleJoinViews(close: UIButton, title: UILabel, note: UILabel, form: UIView) {
        [close, title, note, form].forEach {
            wevvGlazeCanvas.addSubview($0)
        }
    }

    private func pinWevvSprinkleJoinViews(close: UIButton, title: UILabel, note: UILabel, form: UIView, action: UIButton, previousField: UIView) {
        NSLayoutConstraint.activate([
            close.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 35),
            close.topAnchor.constraint(equalTo: wevvGlazeCanvas.safeAreaLayoutGuide.topAnchor, constant: 60),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
//            eulaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
//            eulaButton.centerYAnchor.constraint(equalTo: close.centerYAnchor),
//            eulaButton.widthAnchor.constraint(equalToConstant: 92),
//            eulaButton.heightAnchor.constraint(equalToConstant: 46),
            title.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 29),
            title.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 35),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 17),
            form.leadingAnchor.constraint(equalTo: wevvGlazeCanvas.leadingAnchor, constant: 20),
            form.trailingAnchor.constraint(equalTo: wevvGlazeCanvas.trailingAnchor, constant: -20),
            form.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 50),
            form.heightAnchor.constraint(equalToConstant: 620),
            action.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            action.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
            action.topAnchor.constraint(greaterThanOrEqualTo: previousField.bottomAnchor, constant: 28),
            action.heightAnchor.constraint(equalToConstant: 52),
            action.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -28),
            form.bottomAnchor.constraint(equalTo: wevvGlazeCanvas.bottomAnchor, constant: -30)
//            signIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            signIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
//            signIn.topAnchor.constraint(lessThanOrEqualTo: action.bottomAnchor, constant: 20),
            
        ])
    }

    private func makeWevvEulaPill() -> UIButton {
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

    private func makeWevvEulaRow() -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        let toggle = UIButton()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setImage(UIImage.init(named: "Ellipseunpick"), for: .normal)
        toggle.setImage(UIImage.init(named: "Ellipseunpicknone"), for: .selected)
        toggle.isSelected = wevvEulaAccepted
        toggle.addTarget(self, action: #selector(toggleWevvEulaAgreement), for: .touchUpInside)
        wevvLandingAgreeToggle = toggle
//        refreshAgreementButton(toggle)

        let textStack = UIStackView()
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.spacing = 3
        let firstLine = UIStackView()
        firstLine.translatesAutoresizingMaskIntoConstraints = false
        firstLine.axis = .horizontal
        firstLine.alignment = .center
        firstLine.spacing = 4
        let secondLine = UIStackView()
        secondLine.translatesAutoresizingMaskIntoConstraints = false
        secondLine.axis = .horizontal
        secondLine.alignment = .center
        secondLine.spacing = 4
        firstLine.addArrangedSubview(makeWevvEulaLabel("Buy! Wc.o,nEtoiKnIumiHnRgn,D uyCoIup .aGgQrmeKe* Wt#od !o,uDrO".wevVPastryCrumbBloomRestored))
        firstLine.addArrangedSubview(makeWevvEulaButton("TZecrhmlsw kolf# xUesieb".wevVPastryCrumbBloomRestored, action: #selector(openWevvTermsText)))
        secondLine.addArrangedSubview(makeWevvEulaLabel("ahnKd@".wevVPastryCrumbBloomRestored))
        secondLine.addArrangedSubview(makeWevvEulaButton("PxrFi%vQa;cIyS #PloFlViccPyy.B".wevVPastryCrumbBloomRestored, action: #selector(openWevvNoticeText)))
        textStack.addArrangedSubview(firstLine)
        textStack.addArrangedSubview(secondLine)

        holder.addSubview(toggle)
        holder.addSubview(textStack)
        NSLayoutConstraint.activate([
            toggle.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            toggle.topAnchor.constraint(equalTo: holder.topAnchor, constant: 5),
            toggle.widthAnchor.constraint(equalToConstant: 23),
            toggle.heightAnchor.constraint(equalToConstant: 23),
            textStack.leadingAnchor.constraint(equalTo: toggle.trailingAnchor, constant: 18),
            textStack.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            textStack.topAnchor.constraint(equalTo: holder.topAnchor),
            textStack.bottomAnchor.constraint(equalTo: holder.bottomAnchor)
        ])
        holder.accessibilityElements = [toggle, textStack]
        return holder
    }

//    private func refreshAgreementButton(_ sprinkleButton: UIButton) {
//        sprinkleButton.layer.borderColor = hasAgreedEula ? pinkTone.cgColor : UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1).cgColor
//        sprinkleButton.tintColor = hasAgreedEula ? pinkTone : .clear
//        sprinkleButton.setImage(hasAgreedEula ? UIImage(systemName: "checkmark") : nil, for: .normal)
//    }

    private func makeWevvEulaLabel(_ text: String) -> UILabel {
        let crumbLabel = makeWevvGateCrumbLabel(text, size: 13, weight: .regular, color: wevvCocoaTone)
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeWevvEulaButton(_ text: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(text, for: .normal)
        sprinkleButton.setTitleColor(wevvBerryTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeWevvCrullerCloseButton() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        sprinkleButton.tintColor = wevvCocoaTone
        sprinkleButton.addTarget(self, action: #selector(closeWevvBakeryGate), for: .touchUpInside)
        return sprinkleButton
    }

    private func makeWevvCustardPanel() -> UIView {
        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = .white
        glazePanel.layer.cornerRadius = 26
        return glazePanel
    }

    private func makeWevvMapleActionButton(_ title: String) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(.white, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .heavy)
        sprinkleButton.backgroundColor = wevvBerryTone
        sprinkleButton.layer.cornerRadius = 26
        return sprinkleButton
    }

    private func makeWevvFieldCrumbTitle(_ text: String) -> UILabel {
        makeWevvGateCrumbLabel(text, size: 15, weight: .heavy, color: UIColor(red: 0.68, green: 0.57, blue: 0.69, alpha: 1))
    }

    private func makeWevvFillingField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = .systemFont(ofSize: 17, weight: .heavy)
        field.textColor = wevvCocoaTone
        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(red: 0.55, green: 0.49, blue: 0.58, alpha: 1),
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ]
        )
        field.backgroundColor = UIColor(red: 1, green: 0.97, blue: 0.99, alpha: 1)
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = wevvSugarLineTone.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 31, height: 1))
        field.leftViewMode = .always
        return field
    }

    private func makeWevvCustardWrap(_ field: UITextField) -> UIView {
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.backgroundColor = field.backgroundColor
        wrap.layer.cornerRadius = field.layer.cornerRadius
        wrap.layer.borderWidth = field.layer.borderWidth
        wrap.layer.borderColor = field.layer.borderColor
        field.backgroundColor = .clear
        field.layer.borderWidth = 0
        let eye = UIButton(type: .system)
        eye.translatesAutoresizingMaskIntoConstraints = false
        eye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eye.tintColor = UIColor(red: 0.45, green: 0.42, blue: 0.46, alpha: 1)
        eye.addAction(UIAction { [weak field] _ in
            field?.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        wrap.addSubview(field)
        wrap.addSubview(eye)
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            field.topAnchor.constraint(equalTo: wrap.topAnchor),
            field.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
            field.trailingAnchor.constraint(equalTo: eye.leadingAnchor, constant: -8),
            eye.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -26),
            eye.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            eye.widthAnchor.constraint(equalToConstant: 34),
            eye.heightAnchor.constraint(equalToConstant: 34)
        ])
        return wrap
    }

    private func makeWevvRibbonLinkButton(prefix: String, title: String, action: Selector) -> UIStackView {
        let ringStack = UIStackView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        ringStack.axis = .vertical
        ringStack.alignment = .center
        ringStack.spacing = 13
        let prefixLabel = makeWevvGateCrumbLabel(prefix, size: 17, weight: .regular, color: wevvSoftCrumbTone)
        let sprinkleButton = makeWevvFlatRibbonButton(title, action: action)
        ringStack.addArrangedSubview(prefixLabel)
        ringStack.addArrangedSubview(sprinkleButton)
        return ringStack
    }

    private func makeWevvFlatRibbonButton(_ title: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(wevvBerryTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeWevvGateCrumbLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func tryWevvMapleEntry(mail: String, secret: String) {
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanMail.isEmpty else {
            showWevvCreamHint("P/lvedaFsUeY keUnhtMenrR feimsaridlE".wevVPastryCrumbBloomRestored)
            return
        }
        guard !cleanSecret.isEmpty else {
            showWevvCreamHint("PGl~eraAsIez jeKnxtte.rA Wp!absRsdwzoErWdj".wevVPastryCrumbBloomRestored)
            return
        }

        switch wevvDoughAccessResult(mail: cleanMail, secret: cleanSecret) {
        case .wevvVanillaBloom(let creamAccount):
            finishWevvBakeryGate(userKey: creamAccount.wevvcleanOutline, name: creamAccount.wevvhardOutline, mail: creamAccount.wevvhighlightStroke)
        case .wevvCocoaFinish:
            showWevvCreamHint("AIcucRoAunnXtY RdKoleZs, qnqoBtc Heixiikswt:".wevVPastryCrumbBloomRestored)
        case .wevvCrumbMismatch:
            showWevvCreamHint("PSaVsDsXwqo=r*d~ Pi#sm ai!nmcWo.rLrgeKcZtI".wevVPastryCrumbBloomRestored)
        }
    }

    private func tryWevvSprinkleJoin(name: String, mail: String, secret: String, confirm: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirm = confirm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard wevvEulaAccepted else {
            showWevvCreamHint("PXlVewaAsuev ~a!gLrjeje: ytMoW !EmU#LcA: Ufyiyr*s+tj".wevVPastryCrumbBloomRestored)
            return
        }
        guard !cleanName.isEmpty else {
            showWevvCreamHint("PFlQeqa.s@eI qeHnwtueerY vduifsspol@aUyk pnea,mIeu".wevVPastryCrumbBloomRestored)
            return
        }
        guard isWevvMailShapeValid(cleanMail) else {
            showWevvCreamHint("PolLeKa!szeO vevnptheLrf mai !v,aql%imd! Ke?mzaHiMl#".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanSecret.count >= 4 else {
            showWevvCreamHint("PVa^stsvwQoJrUdw ;nSeyerd%sn %a!td Gl/e*a!snt% b4O wcbhmaxrDaHc=t,eMr=sk".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanSecret == cleanConfirm else {
            showWevvCreamHint("P@axs~s@wuoFrLdLs! +dKo# :nFokt/ LmNaItecghl".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanMail != "wDeqvIvy@WgjmjaVi@lS.acCotmd".wevVPastryCrumbBloomRestored else {
            showWevvCreamHint("AAc,c!oRu,n/tf gailMrNefaldjyl teBxSiws#tks.".wevVPastryCrumbBloomRestored)
            return
        }
        var accounts = wevvDoughRecordTray()
        guard !accounts.contains(where: { $0.wevvhighlightStroke == cleanMail }) else {
            showWevvCreamHint("AFcFcLoJu=nZto @a^lcreenakd?yB leLx.ihsTt;sA".wevVPastryCrumbBloomRestored)
            return
        }
        accounts.append(WevVWevvDoughRecord(wevvcleanOutline: makeWevvDoughTasterKey(name: cleanName, mail: cleanMail), wevvhardOutline: cleanName, wevvhighlightStroke: cleanMail, wevvwhitePop: cleanSecret))
        sealWevvDoughRecordTray(accounts)
        finishWevvBakeryGate(userKey: accounts.last?.wevvcleanOutline ?? makeWevvDoughTasterKey(name: cleanName, mail: cleanMail), name: cleanName, mail: cleanMail)
    }

    private func finishWevvBakeryGate(userKey: String, name: String, mail: String) {
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "C&hceAcDkFiOntg^ kaacrcxoNuHnstW.T.b.x".wevVPastryCrumbBloomRestored) { [weak self] in
            let profile = WevVDoughRingTasterProfile(
                ringCutterKey: userKey,
                powderedAtlas: mail,
                glazeNickname: name,
                donutFrameAsset: "wevv_profile_avatar_piano_donut",
                glazeTrailCount: 0,
                sprinkleTasterCount: 0,
                bakeryShelfTotal: 0,
                glazeVaultCount: 0
            )
            self?.wevvDonutJournalStore.markDoughRingTasterReady(profile: profile)
            self?.onWevvDonutReady?()
        }
    }

    private func wevvDoughAccessResult(mail: String, secret: String) -> WevVWevvDoughAccessState {
        if let reviewAccount = reviewWevvDoughRecord(mail: mail) {
            return reviewAccount.wevvwhitePop == secret ? .wevvVanillaBloom(reviewAccount) : .wevvCrumbMismatch
        }
        guard let creamAccount = wevvDoughRecordTray().first(where: { $0.wevvhighlightStroke == mail }) else {
            return .wevvCocoaFinish
        }
        return creamAccount.wevvwhitePop == secret ? .wevvVanillaBloom(creamAccount) : .wevvCrumbMismatch
    }

    private func reviewWevvDoughRecord(mail: String) -> WevVWevvDoughRecord? {
        guard mail == "wCeSv;vq@bgJmHaFizlw.hcNowm!".wevVPastryCrumbBloomRestored else { return nil }
        return WevVWevvDoughRecord(wevvcleanOutline: "wjervNv@S=u~gNaNr/TMaCs=tyeWr*".wevVPastryCrumbBloomRestored, wevvhardOutline: "G#lHa=zHeJ hT;aHsTtzeorQ".wevVPastryCrumbBloomRestored, wevvhighlightStroke: mail, wevvwhitePop: "1.2M3o4Q".wevVPastryCrumbBloomRestored)
    }

    private func wevvDoughRecordTray() -> [WevVWevvDoughRecord] {
        wevvPastryDefaults.stringArray(forKey: wevvDoughTrayKey)?.compactMap(unwrapWevvDoughRecord) ?? []
    }

    private func sealWevvDoughRecordTray(_ accounts: [WevVWevvDoughRecord]) {
        let packets = accounts.map { wevvDoughRecordPacket($0) }
        wevvPastryDefaults.set(packets, forKey: wevvDoughTrayKey)
    }

    private func unwrapWevvDoughRecord(_ rawPacket: String) -> WevVWevvDoughRecord? {
        let parts = wevvPastryParts(from: rawPacket)
        if parts.count == 4 {
            return WevVWevvDoughRecord(wevvcleanOutline: parts[0], wevvhardOutline: parts[1], wevvhighlightStroke: parts[2], wevvwhitePop: parts[3])
        }
        guard parts.count == 3 else { return nil }
        return WevVWevvDoughRecord(wevvcleanOutline: makeWevvDoughTasterKey(name: parts[0], mail: parts[1]), wevvhardOutline: parts[0], wevvhighlightStroke: parts[1], wevvwhitePop: parts[2])
    }

    private func wevvDoughRecordPacket(_ creamAccount: WevVWevvDoughRecord) -> String {
        makeWevvPastryPacket([
            creamAccount.wevvcleanOutline,
            cleanWevvCrumbPacketPart(creamAccount.wevvhardOutline),
            cleanWevvCrumbPacketPart(creamAccount.wevvhighlightStroke),
            cleanWevvCrumbPacketPart(creamAccount.wevvwhitePop)
        ])
    }

    private func isWevvMailShapeValid(_ text: String) -> Bool {
        text.contains("@T".wevVPastryCrumbBloomRestored) && text.contains(".,".wevVPastryCrumbBloomRestored) && text.count >= 5
    }

    private func makeWevvDoughTasterKey(name: String, mail: String) -> String {
        let rawName = name.lowercased().filter { $0.isLetter || $0.isNumber }
        let rawMail = mail.lowercased().filter { $0.isLetter || $0.isNumber }
        return "wevvCream\(rawName.prefix(10))\(rawMail.prefix(8))"
    }

    private func cleanWevvCrumbPacketPart(_ text: String) -> String {
        text.replacingOccurrences(of: wevvCrumbDivider, with: " J".wevVPastryCrumbBloomRestored)
    }

    private func wevvPastryParts(from rawPacket: String) -> [String] {
        rawPacket.components(separatedBy: wevvCrumbDivider)
    }

    private func makeWevvPastryPacket(_ parts: [String]) -> String {
        parts.joined(separator: wevvCrumbDivider)
    }

    private func showWevvEulaCard(autoAgree: Bool) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        view.addSubview(shade)

        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = .white
        glazePanel.layer.cornerRadius = 22
        shade.addSubview(glazePanel)

        let glazeTitle = makeWevvGateCrumbLabel("EVUwLBAo".wevVPastryCrumbBloomRestored, size: 20, weight: .heavy, color: wevvCocoaTone)
        glazeTitle.textAlignment = .center

        let eulaScroll = UIScrollView()
        eulaScroll.translatesAutoresizingMaskIntoConstraints = false
        eulaScroll.alwaysBounceVertical = true
        eulaScroll.showsVerticalScrollIndicator = true

        let eulaContent = UIView()
        eulaContent.translatesAutoresizingMaskIntoConstraints = false

        let body = makeWevvGateCrumbLabel(wevvEulaText(), size: 13, weight: .regular, color: wevvSoftCrumbTone)
        body.numberOfLines = 0
        body.textAlignment = .left

        let cancel = UIButton(type: .system)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle("CJaanwcse~lM".wevVPastryCrumbBloomRestored, for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        cancel.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        cancel.layer.cornerRadius = 21
        cancel.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
        }, for: .touchUpInside)

        let agree = makeWevvMapleActionButton("A:g#r*eAeD".wevVPastryCrumbBloomRestored)
        agree.addAction(UIAction { [weak self, weak shade] _ in
            guard let self else { return }
            self.setWevvEulaAgreement(true)
            shade?.removeFromSuperview()
            if autoAgree {
                self.renderWevvBakeryMode(self.wevvBakeryMode)
            }
        }, for: .touchUpInside)

        glazePanel.addSubview(glazeTitle)
        glazePanel.addSubview(eulaScroll)
        eulaScroll.addSubview(eulaContent)
        eulaContent.addSubview(body)
        glazePanel.addSubview(cancel)
        glazePanel.addSubview(agree)

        pinWevvEulaCardLayout(shade: shade, glazePanel: glazePanel, title: glazeTitle, eulaScroll: eulaScroll, eulaContent: eulaContent, body: body, cancel: cancel, agree: agree)
    }

    private func pinWevvEulaCardLayout(shade: UIView, glazePanel: UIView, title: UILabel, eulaScroll: UIScrollView, eulaContent: UIView, body: UILabel, cancel: UIButton, agree: UIButton) {
        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            glazePanel.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            glazePanel.centerYAnchor.constraint(equalTo: shade.centerYAnchor),
            glazePanel.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.82),
            glazePanel.heightAnchor.constraint(lessThanOrEqualTo: shade.safeAreaLayoutGuide.heightAnchor, multiplier: 0.72),
            title.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -20),
            eulaScroll.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            eulaScroll.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 22),
            eulaScroll.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -22),
            eulaScroll.heightAnchor.constraint(equalTo: shade.safeAreaLayoutGuide.heightAnchor, multiplier: 0.38),
            eulaContent.topAnchor.constraint(equalTo: eulaScroll.contentLayoutGuide.topAnchor),
            eulaContent.leadingAnchor.constraint(equalTo: eulaScroll.contentLayoutGuide.leadingAnchor),
            eulaContent.trailingAnchor.constraint(equalTo: eulaScroll.contentLayoutGuide.trailingAnchor),
            eulaContent.bottomAnchor.constraint(equalTo: eulaScroll.contentLayoutGuide.bottomAnchor),
            eulaContent.widthAnchor.constraint(equalTo: eulaScroll.frameLayoutGuide.widthAnchor),
            body.topAnchor.constraint(equalTo: eulaContent.topAnchor),
            body.leadingAnchor.constraint(equalTo: eulaContent.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: eulaContent.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: eulaContent.bottomAnchor),
            cancel.topAnchor.constraint(equalTo: eulaScroll.bottomAnchor, constant: 20),
            cancel.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 24),
            cancel.trailingAnchor.constraint(equalTo: glazePanel.centerXAnchor, constant: -8),
            cancel.heightAnchor.constraint(equalToConstant: 42),
            agree.leadingAnchor.constraint(equalTo: glazePanel.centerXAnchor, constant: 8),
            agree.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -24),
            agree.centerYAnchor.constraint(equalTo: cancel.centerYAnchor),
            agree.heightAnchor.constraint(equalTo: cancel.heightAnchor),
            agree.bottomAnchor.constraint(equalTo: glazePanel.bottomAnchor, constant: -24)
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
        wevvLandingAgreeToggle?.isSelected = wevvEulaAccepted
        wevvLandingStartButton?.isEnabled = true
        wevvLandingReturnButton?.isEnabled = true
        wevvLandingStartButton?.alpha = wevvEulaAccepted ? 1 : 0.48
        wevvLandingReturnButton?.alpha = wevvEulaAccepted ? 1 : 0.58
        wevvLandingReturnButton?.layer.borderColor = (wevvEulaAccepted ? wevvSugarLineTone : UIColor(red: 0.86, green: 0.78, blue: 0.83, alpha: 1)).cgColor
    }

    @objc private func openWevvEulaButton() {
        showWevvEulaCard(autoAgree: false)
    }

    @objc private func openWevvTermsText() {
        let controller = WevVSugarPlainTextController(
            filledScout: "TmeMrUmrsy VoAfz SUHsreg".wevVPastryCrumbBloomRestored,
            crullerScout: wevvTermsText()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openWevvNoticeText() {
        let controller = WevVSugarPlainTextController(
            filledScout: "PDrriSvParc!yT xPmogldikctyA".wevVPastryCrumbBloomRestored,
            crullerScout: wevvNoticeText()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func wevvNoticeText() -> String {
        """
        Effective date: July 27, 2026

        WevV: Community, Voice Sweety is a donut-themed app for discovering shops, saving favorite places, sharing tasting moments, joining themed rooms, checking in, and participating in flavor challenges.

        Information We Use
        We may use the account details you enter, such as email address, display name, password credential, profile glazeImage choice, saved shops, check-in history, challenge activity, room participation state, tasting notes, post content, relationship status, reports, blocks, and local app preferences. Camera, photo, and microphone permissions are requested only when a related feature needs them. Permission choices can be changed in iOS Settings.

        Local Storage
        This version uses local app storage to simulate a complete app experience. Your account state, saved shops, posts, challenge joins, and profile details are stored in the app sandbox on this device unless a future version clearly adds an online service.

        How We Use Information
        We use information to keep you signed in, refresh your donut profile, show saved shops and posts, support check-ins, process challenge participation, maintain relationship states, and provide safety tools such as report and block.

        User Content and Safety
        Donut posts, profile text, reviews, room lines, and challenge entries must be respectful and lawful. WevV has zero tolerance for objectionable content or abusive users. Reported or blocked content may be hidden locally and may be reviewed if online moderation is added. Content involving harassment, hate, threats, explicit sexual material, private information, scams, impersonation, illegal activity, or harm to others is not allowed.

        Sharing
        We do not sell personal information. We do not share local demo data with advertisers. Information may be disclosed only if required by law, needed to protect users, or necessary to operate a future service that is clearly described.

        Children and Eligibility
        WevV is not directed to children under 13. If your region requires a higher age or guardian consent for social features, you must follow that rule before creating an account.

        Retention and Deletion
        Logging out clears only the current signed-in state. Deleting an account removes the local profile data controlled by this app on the device. Some content may remain if it has already been copied outside the app by the user.

        Contact
        For privacy questions, data requests, or safety concerns, contact wevvuser@gmail.com.
        """
    }

    private func wevvTermsText() -> String {
        """
        Effective date: July 27, 2026

        Welcome to WevV: Community, Voice Sweety. These Terms govern your use of WevV, a donut-themed space for shop discovery, tasting posts, check-ins, themed rooms, saved shop collections, and flavor challenges.

        Eligibility
        You may use WevV only if you are at least 13 years old, or older if your region requires a higher age for social app participation. You must be legally allowed to create an account and take part in the app where you live.

        Account Rules
        Provide accurate account information and keep your password secure. You are responsible for activity under your account. The fixed test account is intended only for review and development testing.

        Community Conduct
        Keep WevV cheerful, respectful, and safe. WevV has zero tolerance for objectionable content or abusive users. Do not upload, write, or distribute harassment, hate, threats, bullying, nudity, sexually explicit material, scams, spam, impersonation, private information, illegal content, dangerous instructions, or content that infringes another person’s rights.

        Donut Content
        You keep ownership of your tasting notes, photos, reviews, profile text, and challenge entries. By posting content, you allow WevV to display it inside the app experience so features such as feeds, profiles, saved shops, challenges, and room activity can work.

        Reports, Blocks, and Moderation
        WevV includes report and block tools to help protect users. Users can flag objectionable content and block abusive users from profile and content screens. Reported content and accounts may be reviewed, hidden, removed, limited, or terminated. We may act against severe violations immediately and may restrict repeated violations without prior notice.

        Challenge and Shop Features
        Shop recommendations, check-ins, saved shops, room activity, and challenge participation are simulated with local data in this version. They are provided for app experience and review purposes, not as guaranteed real-world availability, scheduling, or shop endorsement.

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
