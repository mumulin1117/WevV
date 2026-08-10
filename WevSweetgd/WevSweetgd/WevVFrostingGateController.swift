import UIKit

private enum WevVFrostingGateMode {
    case welcome
    case signIn
    case signUp
}

private struct WevVCreamAccount {
    let userKey: String
    let name: String
    let mail: String
    let secret: String
}

private enum WevVCreamAccessResult {
    case ready(WevVCreamAccount)
    case missing
    case wrongSecret
}

final class WevVFrostingGateController: UIViewController, UITextFieldDelegate {
    var onGlazeReady: (() -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let frostingDefaults = UserDefaults.standard
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.18, green: 0.13, blue: 0.22, alpha: 1)
    private let mutedTone = UIColor(red: 0.55, green: 0.49, blue: 0.59, alpha: 1)
    private let lineTone = UIColor(red: 0.94, green: 0.81, blue: 0.89, alpha: 1)
    private let glazeAgreementRibbonKey = "waeovhvc_ZgmlXaez,ep_Je~u#l#aQ_gaig+rLeNeNds".wevVPastryCrumbBloomRestored
    private let creamAccountTrayKey = "wBePv~ve_yg*l,arzVeo_olNowcsaZlX_UaPc,cUoTuhnHtTss".wevVPastryCrumbBloomRestored
    private let pastryPacketDivider = "|x".wevVPastryCrumbBloomRestored
    private var gateMode = WevVFrostingGateMode.welcome
    private var hasAgreedEula = false
    private var bottomInset: NSLayoutConstraint?
    private weak var welcomeAgreementToggle: UIButton?
    private weak var welcomeStartButton: UIButton?
    private weak var welcomeSignInButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        hasAgreedEula = frostingDefaults.bool(forKey: glazeAgreementRibbonKey)
        buildFrostingGateCanvas()
        renderGateMode(.welcome)
        observeSugarKeys()
        if !hasAgreedEula {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.showEulaCard(autoAgree: true)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildFrostingGateCanvas() {
        view.backgroundColor = paleTone

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        bottomInset = contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            bottomInset!,
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(endCreamEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func renderGateMode(_ mode: WevVFrostingGateMode) {
        gateMode = mode
        contentView.subviews.forEach { $0.removeFromSuperview() }
        switch mode {
        case .welcome:
            buildWelcomeLayer()
        case .signIn:
            buildSignInLayer()
        case .signUp:
            buildSignUpLayer()
        }
    }

    private func buildWelcomeLayer() {
        let welcomeBackdrop = UIImageView(image: UIImage(named: "welcomebglaunch"))
        welcomeBackdrop.translatesAutoresizingMaskIntoConstraints = false
        welcomeBackdrop.contentMode = .scaleAspectFill
        welcomeBackdrop.clipsToBounds = true

        let eulaButton = makeEulaPill()
        let heroSpace = UIView()
        heroSpace.translatesAutoresizingMaskIntoConstraints = false

        let startButton = makeActionButton("Gge,ta ZSRtIa&rctbe;dg".wevVPastryCrumbBloomRestored)
        startButton.addTarget(self, action: #selector(openSignUpLayer), for: .touchUpInside)
        welcomeStartButton = startButton

        let signInButton = UIButton(type: .system)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("II &AWlvr;eXa=dAyy ^HpaivoeY @aJn+ /Avcrc@oouanltL".wevVPastryCrumbBloomRestored, for: .normal)
        signInButton.setTitleColor(inkTone, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        signInButton.backgroundColor = .white
        signInButton.layer.cornerRadius = 26
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = lineTone.cgColor
        signInButton.addTarget(self, action: #selector(openSignInLayer), for: .touchUpInside)
        welcomeSignInButton = signInButton

        let agreement = makeAgreementRow()
        refreshWelcomeAgreementControls()

        placeWelcomeLayerViews(welcomeBackdrop: welcomeBackdrop, eulaButton: eulaButton, heroSpace: heroSpace, startButton: startButton, signInButton: signInButton, agreement: agreement)
        pinWelcomeLayerViews(welcomeBackdrop: welcomeBackdrop, eulaButton: eulaButton, heroSpace: heroSpace, startButton: startButton, signInButton: signInButton, agreement: agreement)
    }

    private func placeWelcomeLayerViews(welcomeBackdrop: UIImageView, eulaButton: UIButton, heroSpace: UIView, startButton: UIButton, signInButton: UIButton, agreement: UIView) {
        [welcomeBackdrop, eulaButton, heroSpace, startButton, signInButton, agreement].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinWelcomeLayerViews(welcomeBackdrop: UIImageView, eulaButton: UIButton, heroSpace: UIView, startButton: UIButton, signInButton: UIButton, agreement: UIView) {
        NSLayoutConstraint.activate([
            welcomeBackdrop.topAnchor.constraint(equalTo: contentView.topAnchor),
            welcomeBackdrop.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            welcomeBackdrop.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            welcomeBackdrop.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            eulaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
            eulaButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 34),
            eulaButton.widthAnchor.constraint(equalToConstant: 92),
            eulaButton.heightAnchor.constraint(equalToConstant: 46),
            heroSpace.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroSpace.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 142),
            heroSpace.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.78),
            heroSpace.heightAnchor.constraint(equalTo: heroSpace.widthAnchor, multiplier: 0.92),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            startButton.topAnchor.constraint(equalTo: heroSpace.bottomAnchor, constant: 76),
            startButton.heightAnchor.constraint(equalToConstant: 56),
            signInButton.leadingAnchor.constraint(equalTo: startButton.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: startButton.trailingAnchor),
            signInButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 31),
            signInButton.heightAnchor.constraint(equalToConstant: 56),
            agreement.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23),
            agreement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            agreement.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 78),
            agreement.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }

    private func buildSignInLayer() {
        let doughClose = makeCloseButton()
        let glazeTitle = makeGateLabel("WDe:lTcmoEmSe+ sbjamcakL".wevVPastryCrumbBloomRestored, size: 34, weight: .heavy, color: inkTone)
        let crumbNote = makeGateLabel("Luoegz oilne waqnfdj ycjoxnjtzignlumet vyuogupre rdwoonpubtk gcyhiaplclpeonhgnez.q".wevVPastryCrumbBloomRestored, size: 19, weight: .regular, color: mutedTone)
        crumbNote.numberOfLines = 2

        let form = makeFormPanel()
        let mailField = makeTextField(placeholder: "ENnEtGegr! ~EKmma?iDlY".wevVPastryCrumbBloomRestored)
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .username
        let secretField = makeTextField(placeholder: "EenHtLeHrw !pSa;sEsWwvogrpdC".wevVPastryCrumbBloomRestored)
        secretField.isSecureTextEntry = true
        secretField.textContentType = .password
        let secretWrap = makeSecretWrap(secretField)
        let action = makeActionButton("LgoIgd kIzn*".wevVPastryCrumbBloomRestored)
        action.addAction(UIAction { [weak self, weak mailField, weak secretField] _ in
            self?.trySignIn(mail: mailField?.text ?? "", secret: secretField?.text ?? "")
        }, for: .touchUpInside)

        let create = makeLinkButton(prefix: "Dwo,nW’utm jhUaevkev daxnT XawcicTotuDnlt??B".wevVPastryCrumbBloomRestored, title: "CPrae@aStSeR fAVcCcAoluAnvtU".wevVPastryCrumbBloomRestored, action: #selector(openSignUpLayer))

        placeSignInLayerViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form, create: create)
        form.addSubview(makeFieldTitle("EtMDA^IALu".wevVPastryCrumbBloomRestored))
        let mailTitle = form.subviews.last!
        form.addSubview(mailField)
        form.addSubview(makeFieldTitle("PlAWSqS;W^ODRYDM".wevVPastryCrumbBloomRestored))
        let secretTitle = form.subviews.last!
        form.addSubview(secretWrap)
        form.addSubview(action)
        pinSignInLayerViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form, create: create, mailTitle: mailTitle, mailField: mailField, secretTitle: secretTitle, secretWrap: secretWrap, action: action)
    }

    private func placeSignInLayerViews(close: UIButton, title: UILabel, note: UILabel, form: UIView, create: UIView) {
        [close, title, note, form, create].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinSignInLayerViews(close: UIButton, title: UILabel, note: UILabel, form: UIView, create: UIView, mailTitle: UIView, mailField: UITextField, secretTitle: UIView, secretWrap: UIView, action: UIButton) {
        NSLayoutConstraint.activate([
            close.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            close.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29),
            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 38),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            form.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            form.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            form.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 51),
            form.heightAnchor.constraint(equalToConstant: 350),
            mailTitle.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            mailTitle.topAnchor.constraint(equalTo: form.topAnchor, constant: 31),
            mailField.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            mailField.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
            mailField.topAnchor.constraint(equalTo: mailTitle.bottomAnchor, constant: 22),
            mailField.heightAnchor.constraint(equalToConstant: 52),
            secretTitle.leadingAnchor.constraint(equalTo: mailTitle.leadingAnchor),
            secretTitle.topAnchor.constraint(equalTo: mailField.bottomAnchor, constant: 36),
            secretWrap.leadingAnchor.constraint(equalTo: mailField.leadingAnchor),
            secretWrap.trailingAnchor.constraint(equalTo: mailField.trailingAnchor),
            secretWrap.topAnchor.constraint(equalTo: secretTitle.bottomAnchor, constant: 22),
            secretWrap.heightAnchor.constraint(equalToConstant: 52),
            action.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            action.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
            action.topAnchor.constraint(greaterThanOrEqualTo: secretWrap.bottomAnchor, constant: 28),
            action.heightAnchor.constraint(equalToConstant: 52),
            action.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -24),
            create.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            create.topAnchor.constraint(equalTo: action.bottomAnchor, constant: 28),
            create.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40),
            create.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            create.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func buildSignUpLayer() {
        let doughClose = makeCloseButton()
        let glazeTitle = makeGateLabel("JGo~i%nh &t;hrem gdTo&nCultU HcAl,uxbJ".wevVPastryCrumbBloomRestored, size: 32, weight: .heavy, color: inkTone)
        let crumbNote = makeGateLabel("CcrMeVactbeA =yeoBuarO Na~cmctoHuOnOt% Ya^nid: rs,tOabr:t~ #eYxNp~lqoSrgiinggU UsZweeqeztJ Ycqi!rpcVlZeAs+.&".wevVPastryCrumbBloomRestored, size: 19, weight: .regular, color: mutedTone)
        crumbNote.numberOfLines = 2

        let form = makeFormPanel()
        let nameField = makeTextField(placeholder: "Etn.tjeorz unFaempe&".wevVPastryCrumbBloomRestored)
        let mailField = makeTextField(placeholder: "EYnotOe+rH me:miaQi^l.".wevVPastryCrumbBloomRestored)
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .username
        let secretField = makeTextField(placeholder: "e^nbtve=r. /piaqsNs=w/oQrbd#".wevVPastryCrumbBloomRestored)
        secretField.isSecureTextEntry = true
        secretField.textContentType = .newPassword
        let confirmField = makeTextField(placeholder: "eRn=t&eNra YpBaQsWsTwGoarDdR".wevVPastryCrumbBloomRestored)
        confirmField.isSecureTextEntry = true
        confirmField.textContentType = .newPassword
        let action = makeActionButton("C/rdepa:tGen *AVcvczoGuEnDta".wevVPastryCrumbBloomRestored)
        action.addAction(UIAction { [weak self, weak nameField, weak mailField, weak secretField, weak confirmField] _ in
            self?.trySignUp(
                name: nameField?.text ?? "",
                mail: mailField?.text ?? "",
                secret: secretField?.text ?? "",
                confirm: confirmField?.text ?? ""
            )
        }, for: .touchUpInside)

        placeSignUpLayerViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form)

        let fields: [(String, UITextField)] = [
            ("DZI,SlPFLYAHYN ZN,ATM,EP".wevVPastryCrumbBloomRestored, nameField),
            ("EBMTApIQLZ".wevVPastryCrumbBloomRestored, mailField),
            ("P#AlSxS*W+OoR;D:".wevVPastryCrumbBloomRestored, secretField),
            ("C^OFNSFaIWRoM: YP*AvSHSzW,O?R#DP".wevVPastryCrumbBloomRestored, confirmField)
        ]
        var previousField: UIView?
        for (fieldTitle, field) in fields {
            let crumbLabel = makeFieldTitle(fieldTitle)
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
        pinSignUpLayerViews(close: doughClose, title: glazeTitle, note: crumbNote, form: form, action: action, previousField: previousField!)
    }

    private func placeSignUpLayerViews(close: UIButton, title: UILabel, note: UILabel, form: UIView) {
        [close, title, note, form].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinSignUpLayerViews(close: UIButton, title: UILabel, note: UILabel, form: UIView, action: UIButton, previousField: UIView) {
        NSLayoutConstraint.activate([
            close.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            close.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
//            eulaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
//            eulaButton.centerYAnchor.constraint(equalTo: close.centerYAnchor),
//            eulaButton.widthAnchor.constraint(equalToConstant: 92),
//            eulaButton.heightAnchor.constraint(equalToConstant: 46),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 35),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 17),
            form.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            form.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            form.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 50),
            form.heightAnchor.constraint(equalToConstant: 620),
            action.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            action.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
            action.topAnchor.constraint(greaterThanOrEqualTo: previousField.bottomAnchor, constant: 28),
            action.heightAnchor.constraint(equalToConstant: 52),
            action.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -28),
            form.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
//            signIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            signIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
//            signIn.topAnchor.constraint(lessThanOrEqualTo: action.bottomAnchor, constant: 20),
            
        ])
    }

    private func makeEulaPill() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle("EqUeL~AD".wevVPastryCrumbBloomRestored, for: .normal)
        sprinkleButton.setTitleColor(mutedTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        sprinkleButton.backgroundColor = .white
        sprinkleButton.layer.cornerRadius = 23
        sprinkleButton.addTarget(self, action: #selector(openEulaButton), for: .touchUpInside)
        return sprinkleButton
    }

    private func makeAgreementRow() -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        let toggle = UIButton()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setImage(UIImage.init(named: "Ellipseunpick"), for: .normal)
        toggle.setImage(UIImage.init(named: "Ellipseunpicknone"), for: .selected)
        toggle.isSelected = hasAgreedEula
        toggle.addTarget(self, action: #selector(toggleEulaAgreement), for: .touchUpInside)
        welcomeAgreementToggle = toggle
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
        firstLine.addArrangedSubview(makeAgreementLabel("Buy! Wc.o,nEtoiKnIumiHnRgn,D uyCoIup .aGgQrmeKe* Wt#od !o,uDrO".wevVPastryCrumbBloomRestored))
        firstLine.addArrangedSubview(makeAgreementButton("TZecrhmlsw kolf# xUesieb".wevVPastryCrumbBloomRestored, action: #selector(openTermsText)))
        secondLine.addArrangedSubview(makeAgreementLabel("ahnKd@".wevVPastryCrumbBloomRestored))
        secondLine.addArrangedSubview(makeAgreementButton("PxrFi%vQa;cIyS #PloFlViccPyy.B".wevVPastryCrumbBloomRestored, action: #selector(openPrivacyText)))
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

    private func makeAgreementLabel(_ text: String) -> UILabel {
        let crumbLabel = makeGateLabel(text, size: 13, weight: .regular, color: inkTone)
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeAgreementButton(_ text: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(text, for: .normal)
        sprinkleButton.setTitleColor(pinkTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeCloseButton() -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        sprinkleButton.tintColor = inkTone
        sprinkleButton.addTarget(self, action: #selector(closeGate), for: .touchUpInside)
        return sprinkleButton
    }

    private func makeFormPanel() -> UIView {
        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = .white
        glazePanel.layer.cornerRadius = 26
        return glazePanel
    }

    private func makeActionButton(_ title: String) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(.white, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .heavy)
        sprinkleButton.backgroundColor = pinkTone
        sprinkleButton.layer.cornerRadius = 26
        return sprinkleButton
    }

    private func makeFieldTitle(_ text: String) -> UILabel {
        makeGateLabel(text, size: 15, weight: .heavy, color: UIColor(red: 0.68, green: 0.57, blue: 0.69, alpha: 1))
    }

    private func makeTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = .systemFont(ofSize: 17, weight: .heavy)
        field.textColor = inkTone
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
        field.layer.borderColor = lineTone.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 31, height: 1))
        field.leftViewMode = .always
        return field
    }

    private func makeSecretWrap(_ field: UITextField) -> UIView {
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

    private func makeLinkButton(prefix: String, title: String, action: Selector) -> UIStackView {
        let ringStack = UIStackView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        ringStack.axis = .vertical
        ringStack.alignment = .center
        ringStack.spacing = 13
        let prefixLabel = makeGateLabel(prefix, size: 17, weight: .regular, color: mutedTone)
        let sprinkleButton = makeFlatLinkButton(title, action: action)
        ringStack.addArrangedSubview(prefixLabel)
        ringStack.addArrangedSubview(sprinkleButton)
        return ringStack
    }

    private func makeFlatLinkButton(_ title: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(pinkTone, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeGateLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func trySignIn(mail: String, secret: String) {
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanMail.isEmpty else {
            showCreamHint("P/lvedaFsUeY keUnhtMenrR feimsaridlE".wevVPastryCrumbBloomRestored)
            return
        }
        guard !cleanSecret.isEmpty else {
            showCreamHint("PGl~eraAsIez jeKnxtte.rA Wp!absRsdwzoErWdj".wevVPastryCrumbBloomRestored)
            return
        }

        switch glazeAccessResult(mail: cleanMail, secret: cleanSecret) {
        case .ready(let creamAccount):
            finishGlazeGate(userKey: creamAccount.userKey, name: creamAccount.name, mail: creamAccount.mail)
        case .missing:
            showCreamHint("AIcucRoAunnXtY RdKoleZs, qnqoBtc Heixiikswt:".wevVPastryCrumbBloomRestored)
        case .wrongSecret:
            showCreamHint("PSaVsDsXwqo=r*d~ Pi#sm ai!nmcWo.rLrgeKcZtI".wevVPastryCrumbBloomRestored)
        }
    }

    private func trySignUp(name: String, mail: String, secret: String, confirm: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirm = confirm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard hasAgreedEula else {
            showCreamHint("PXlVewaAsuev ~a!gLrjeje: ytMoW !EmU#LcA: Ufyiyr*s+tj".wevVPastryCrumbBloomRestored)
            return
        }
        guard !cleanName.isEmpty else {
            showCreamHint("PFlQeqa.s@eI qeHnwtueerY vduifsspol@aUyk pnea,mIeu".wevVPastryCrumbBloomRestored)
            return
        }
        guard isValidMail(cleanMail) else {
            showCreamHint("PolLeKa!szeO vevnptheLrf mai !v,aql%imd! Ke?mzaHiMl#".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanSecret.count >= 4 else {
            showCreamHint("PVa^stsvwQoJrUdw ;nSeyerd%sn %a!td Gl/e*a!snt% b4O wcbhmaxrDaHc=t,eMr=sk".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanSecret == cleanConfirm else {
            showCreamHint("P@axs~s@wuoFrLdLs! +dKo# :nFokt/ LmNaItecghl".wevVPastryCrumbBloomRestored)
            return
        }
        guard cleanMail != "wDeqvIvy@WgjmjaVi@lS.acCotmd".wevVPastryCrumbBloomRestored else {
            showCreamHint("AAc,c!oRu,n/tf gailMrNefaldjyl teBxSiws#tks.".wevVPastryCrumbBloomRestored)
            return
        }
        var accounts = creamAccountTray()
        guard !accounts.contains(where: { $0.mail == cleanMail }) else {
            showCreamHint("AFcFcLoJu=nZto @a^lcreenakd?yB leLx.ihsTt;sA".wevVPastryCrumbBloomRestored)
            return
        }
        accounts.append(WevVCreamAccount(userKey: makeCreamUserKey(name: cleanName, mail: cleanMail), name: cleanName, mail: cleanMail, secret: cleanSecret))
        sealCreamAccountTray(accounts)
        finishGlazeGate(userKey: accounts.last?.userKey ?? makeCreamUserKey(name: cleanName, mail: cleanMail), name: cleanName, mail: cleanMail)
    }

    private func finishGlazeGate(userKey: String, name: String, mail: String) {
        WevVBakeryExchange.spin(in: view, note: "C&hceAcDkFiOntg^ kaacrcxoNuHnstW.T.b.x".wevVPastryCrumbBloomRestored) { [weak self] in
            let profile = WevVDoughRingTasterProfile(
                doughRingKey: userKey,
                email: mail,
                glazeNickname: name,
                donutAvatarAsset: "wevv_profile_avatar_piano_donut",
                glazeFollowCount: 0,
                sprinkleFanCount: 0,
                bakeryShelfCount: 0,
                glazeVaultCount: 0
            )
            self?.glazeSession.markDoughRingTasterReady(profile: profile)
            self?.onGlazeReady?()
        }
    }

    private func glazeAccessResult(mail: String, secret: String) -> WevVCreamAccessResult {
        if let reviewAccount = reviewCreamAccount(mail: mail) {
            return reviewAccount.secret == secret ? .ready(reviewAccount) : .wrongSecret
        }
        guard let creamAccount = creamAccountTray().first(where: { $0.mail == mail }) else {
            return .missing
        }
        return creamAccount.secret == secret ? .ready(creamAccount) : .wrongSecret
    }

    private func reviewCreamAccount(mail: String) -> WevVCreamAccount? {
        guard mail == "wCeSv;vq@bgJmHaFizlw.hcNowm!".wevVPastryCrumbBloomRestored else { return nil }
        return WevVCreamAccount(userKey: "wjervNv@S=u~gNaNr/TMaCs=tyeWr*".wevVPastryCrumbBloomRestored, name: "G#lHa=zHeJ hT;aHsTtzeorQ".wevVPastryCrumbBloomRestored, mail: mail, secret: "1.2M3o4Q".wevVPastryCrumbBloomRestored)
    }

    private func creamAccountTray() -> [WevVCreamAccount] {
        frostingDefaults.stringArray(forKey: creamAccountTrayKey)?.compactMap(unwrapCreamAccount) ?? []
    }

    private func sealCreamAccountTray(_ accounts: [WevVCreamAccount]) {
        let packets = accounts.map { creamAccountPacket($0) }
        frostingDefaults.set(packets, forKey: creamAccountTrayKey)
    }

    private func unwrapCreamAccount(_ rawPacket: String) -> WevVCreamAccount? {
        let parts = pastryParts(from: rawPacket)
        if parts.count == 4 {
            return WevVCreamAccount(userKey: parts[0], name: parts[1], mail: parts[2], secret: parts[3])
        }
        guard parts.count == 3 else { return nil }
        return WevVCreamAccount(userKey: makeCreamUserKey(name: parts[0], mail: parts[1]), name: parts[0], mail: parts[1], secret: parts[2])
    }

    private func creamAccountPacket(_ creamAccount: WevVCreamAccount) -> String {
        makePastryPacket([
            creamAccount.userKey,
            cleanCreamPacketPart(creamAccount.name),
            cleanCreamPacketPart(creamAccount.mail),
            cleanCreamPacketPart(creamAccount.secret)
        ])
    }

    private func isValidMail(_ text: String) -> Bool {
        text.contains("@T".wevVPastryCrumbBloomRestored) && text.contains(".,".wevVPastryCrumbBloomRestored) && text.count >= 5
    }

    private func makeCreamUserKey(name: String, mail: String) -> String {
        let rawName = name.lowercased().filter { $0.isLetter || $0.isNumber }
        let rawMail = mail.lowercased().filter { $0.isLetter || $0.isNumber }
        return "wevvCream\(rawName.prefix(10))\(rawMail.prefix(8))"
    }

    private func cleanCreamPacketPart(_ text: String) -> String {
        text.replacingOccurrences(of: pastryPacketDivider, with: " J".wevVPastryCrumbBloomRestored)
    }

    private func pastryParts(from rawPacket: String) -> [String] {
        rawPacket.components(separatedBy: pastryPacketDivider)
    }

    private func makePastryPacket(_ parts: [String]) -> String {
        parts.joined(separator: pastryPacketDivider)
    }

    private func showEulaCard(autoAgree: Bool) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        view.addSubview(shade)

        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = .white
        glazePanel.layer.cornerRadius = 22
        shade.addSubview(glazePanel)

        let glazeTitle = makeGateLabel("EVUwLBAo".wevVPastryCrumbBloomRestored, size: 20, weight: .heavy, color: inkTone)
        glazeTitle.textAlignment = .center

        let eulaScroll = UIScrollView()
        eulaScroll.translatesAutoresizingMaskIntoConstraints = false
        eulaScroll.alwaysBounceVertical = true
        eulaScroll.showsVerticalScrollIndicator = true

        let eulaContent = UIView()
        eulaContent.translatesAutoresizingMaskIntoConstraints = false

        let body = makeGateLabel(eulaText(), size: 13, weight: .regular, color: mutedTone)
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

        let agree = makeActionButton("A:g#r*eAeD".wevVPastryCrumbBloomRestored)
        agree.addAction(UIAction { [weak self, weak shade] _ in
            guard let self else { return }
            self.setEulaAgreement(true)
            shade?.removeFromSuperview()
            if autoAgree {
                self.renderGateMode(self.gateMode)
            }
        }, for: .touchUpInside)

        glazePanel.addSubview(glazeTitle)
        glazePanel.addSubview(eulaScroll)
        eulaScroll.addSubview(eulaContent)
        eulaContent.addSubview(body)
        glazePanel.addSubview(cancel)
        glazePanel.addSubview(agree)

        pinEulaCardLayout(shade: shade, glazePanel: glazePanel, title: glazeTitle, eulaScroll: eulaScroll, eulaContent: eulaContent, body: body, cancel: cancel, agree: agree)
    }

    private func pinEulaCardLayout(shade: UIView, glazePanel: UIView, title: UILabel, eulaScroll: UIScrollView, eulaContent: UIView, body: UILabel, cancel: UIButton, agree: UIButton) {
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

    private func eulaText() -> String {
        """
        WevV is a donut discovery space for shop collections, tasting notes, check-ins, themed rooms, and local flavor challenges.

        You may create an account only if you are old enough and legally allowed to use social apps in your region. You are responsible for truthful account details and for following local rules that apply to your identity, content, and participation.

        Keep every donut post, profile, room line, review, and challenge respectful. WevV has zero tolerance for objectionable content or abusive users. Do not post harassment, hate, threats, nudity, sexual material, scams, spam, impersonation, private information, illegal activity, or content that may harm others.

        WevV provides report and block tools. Users can flag objectionable content and block abusive users from profile and content screens. Reported content or accounts may be reviewed, hidden, removed, restricted, or terminated. Serious or repeated violations can lead to loss of posting, room, challenge, profile, or account access without prior notice.
        """
    }

    private func showCreamHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -20)
    }

    private func observeSugarKeys() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftForSugarKeys(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropFromSugarKeys(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftForSugarKeys(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        scrollView.contentInset.bottom = overlap + 24
        scrollView.verticalScrollIndicatorInsets.bottom = overlap + 24
        bottomInset?.constant = -overlap
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropFromSugarKeys(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
        bottomInset?.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func toggleEulaAgreement(_ sender: UIButton) {
        setEulaAgreement(!sender.isSelected)
//        refreshAgreementButton(sender)
    }

    private func setEulaAgreement(_ isAgreed: Bool) {
        hasAgreedEula = isAgreed
        frostingDefaults.set(isAgreed, forKey: glazeAgreementRibbonKey)
        refreshWelcomeAgreementControls()
    }

    private func refreshWelcomeAgreementControls() {
        welcomeAgreementToggle?.isSelected = hasAgreedEula
        welcomeStartButton?.isEnabled = true
        welcomeSignInButton?.isEnabled = true
        welcomeStartButton?.alpha = hasAgreedEula ? 1 : 0.48
        welcomeSignInButton?.alpha = hasAgreedEula ? 1 : 0.58
        welcomeSignInButton?.layer.borderColor = (hasAgreedEula ? lineTone : UIColor(red: 0.86, green: 0.78, blue: 0.83, alpha: 1)).cgColor
    }

    @objc private func openEulaButton() {
        showEulaCard(autoAgree: false)
    }

    @objc private func openTermsText() {
        let controller = WevVSugarPlainTextController(
            titleText: "TmeMrUmrsy VoAfz SUHsreg".wevVPastryCrumbBloomRestored,
            bodyText: termsText()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openPrivacyText() {
        let controller = WevVSugarPlainTextController(
            titleText: "PDrriSvParc!yT xPmogldikctyA".wevVPastryCrumbBloomRestored,
            bodyText: privacyText()
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func privacyText() -> String {
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

    private func termsText() -> String {
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

    @objc private func openSignInLayer() {
        guard hasAgreedEula else {
            showCreamHint("Phl.ecapsReu Ra;gPrEe.e; otqoq LE^UnLAA/ @fIiiroscte".wevVPastryCrumbBloomRestored)
            return
        }
        renderGateMode(.signIn)
    }

    @objc private func openSignUpLayer() {
        guard hasAgreedEula else {
            showCreamHint("PslrekaXsye? Ja.gGrlexeZ .tWod uE.UKL:Az *fLisr/sstu".wevVPastryCrumbBloomRestored)
            return
        }
        renderGateMode(.signUp)
    }

    @objc private func closeGate() {
        if gateMode == .welcome {
            dismiss(animated: true)
        } else {
            renderGateMode(.welcome)
        }
    }

    @objc private func endCreamEditing() {
        view.endEditing(true)
    }
}
