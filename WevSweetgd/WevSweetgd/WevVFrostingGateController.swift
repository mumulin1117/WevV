import UIKit

private enum WevVFrostingGateMode {
    case welcome
    case signIn
    case signUp
}

private struct WevVCreamAccount {
    let name: String
    let mail: String
    let secret: String
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
    private let agreementKey = "wevv_glaze_eula_agreed"
    private let accountKey = "wevv_glaze_local_accounts"
    private var gateMode = WevVFrostingGateMode.welcome
    private var hasAgreedEula = false
    private var bottomInset: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        hasAgreedEula = frostingDefaults.bool(forKey: agreementKey)
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

        let startButton = makeActionButton("Get Started")
        startButton.addTarget(self, action: #selector(openSignUpLayer), for: .touchUpInside)

        let signInButton = UIButton(type: .system)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("I Already Have an Account", for: .normal)
        signInButton.setTitleColor(inkTone, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        signInButton.backgroundColor = .white
        signInButton.layer.cornerRadius = 26
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = lineTone.cgColor
        signInButton.addTarget(self, action: #selector(openSignInLayer), for: .touchUpInside)

        let agreement = makeAgreementRow()

        contentView.addSubview(welcomeBackdrop)
        contentView.addSubview(eulaButton)
        contentView.addSubview(heroSpace)
        contentView.addSubview(startButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(agreement)

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
        let close = makeCloseButton()
        let title = makeGateLabel("Welcome back", size: 34, weight: .heavy, color: inkTone)
        let note = makeGateLabel("Log in to join rooms and continue your donut challenge.", size: 19, weight: .regular, color: mutedTone)
        note.numberOfLines = 2

        let form = makeFormPanel()
        let mailField = makeTextField(placeholder: "Enter Email")
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .username
        let secretField = makeTextField(placeholder: "Enter password")
        secretField.isSecureTextEntry = true
        secretField.textContentType = .password
        let secretWrap = makeSecretWrap(secretField)
        let action = makeActionButton("Log In")
        action.addAction(UIAction { [weak self, weak mailField, weak secretField] _ in
            self?.trySignIn(mail: mailField?.text ?? "", secret: secretField?.text ?? "")
        }, for: .touchUpInside)

        let create = makeLinkButton(prefix: "Don’t have an account?", title: "Create Account", action: #selector(openSignUpLayer))

        contentView.addSubview(close)
        contentView.addSubview(title)
        contentView.addSubview(note)
        contentView.addSubview(form)
        contentView.addSubview(create)
        form.addSubview(makeFieldTitle("EMAIL"))
        let mailTitle = form.subviews.last!
        form.addSubview(mailField)
        form.addSubview(makeFieldTitle("PASSWORD"))
        let secretTitle = form.subviews.last!
        form.addSubview(secretWrap)
        form.addSubview(action)

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
            form.heightAnchor.constraint(equalToConstant: 298),
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
            action.leadingAnchor.constraint(equalTo: form.leadingAnchor),
            action.trailingAnchor.constraint(equalTo: form.trailingAnchor),
            action.topAnchor.constraint(equalTo: secretWrap.bottomAnchor, constant:78),
            action.heightAnchor.constraint(equalToConstant: 52),
            create.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            create.topAnchor.constraint(equalTo: action.bottomAnchor, constant: 28),
            create.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40),
            create.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            create.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func buildSignUpLayer() {
        let close = makeCloseButton()
//        let eulaButton = makeEulaPill()
        let title = makeGateLabel("Join the donut club", size: 32, weight: .heavy, color: inkTone)
        let note = makeGateLabel("Create your account and start exploring sweet circles.", size: 19, weight: .regular, color: mutedTone)
        note.numberOfLines = 2

        let form = makeFormPanel()
        let nameField = makeTextField(placeholder: "Enter name")
        let mailField = makeTextField(placeholder: "Enter email")
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .username
        let secretField = makeTextField(placeholder: "enter password")
        secretField.isSecureTextEntry = true
        secretField.textContentType = .newPassword
        let confirmField = makeTextField(placeholder: "enter password")
        confirmField.isSecureTextEntry = true
        confirmField.textContentType = .newPassword
        let action = makeActionButton("Create Account")
        action.addAction(UIAction { [weak self, weak nameField, weak mailField, weak secretField, weak confirmField] _ in
            self?.trySignUp(
                name: nameField?.text ?? "",
                mail: mailField?.text ?? "",
                secret: secretField?.text ?? "",
                confirm: confirmField?.text ?? ""
            )
        }, for: .touchUpInside)
//        let signIn = makeFlatLinkButton("Already have an account? Log In", action: #selector(openSignInLayer))

        contentView.addSubview(close)
//        contentView.addSubview(eulaButton)
        contentView.addSubview(title)
        contentView.addSubview(note)
        contentView.addSubview(form)
//        contentView.addSubview(signIn)

        let fields: [(String, UITextField)] = [
            ("DISPLAY NAME", nameField),
            ("EMAIL", mailField),
            ("PASSWORD", secretField),
            ("CONFIRM PASSWORD", confirmField)
        ]
        var previousField: UIView?
        for (fieldTitle, field) in fields {
            let label = makeFieldTitle(fieldTitle)
            form.addSubview(label)
            form.addSubview(field)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
                field.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                field.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 22),
                field.heightAnchor.constraint(equalToConstant: 52)
            ])
            if let previousField {
                label.topAnchor.constraint(equalTo: previousField.bottomAnchor, constant: 34).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: form.topAnchor, constant: 31).isActive = true
            }
            previousField = field
        }
        form.addSubview(action)

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
            form.heightAnchor.constraint(equalToConstant: 530),
            action.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 20),
            action.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -20),
            action.topAnchor.constraint(equalTo: previousField!.bottomAnchor, constant: 70),
            action.heightAnchor.constraint(equalToConstant: 52),
            action.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
//            signIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            signIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
//            signIn.topAnchor.constraint(lessThanOrEqualTo: action.bottomAnchor, constant: 20),
            
        ])
    }

    private func makeEulaPill() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("EULA", for: .normal)
        button.setTitleColor(mutedTone, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        button.backgroundColor = .white
        button.layer.cornerRadius = 23
        button.addTarget(self, action: #selector(openEulaButton), for: .touchUpInside)
        return button
    }

    private func makeAgreementRow() -> UIView {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        let toggle = UIButton()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setImage(UIImage.init(named: "Ellipseunpick"), for: .normal)
        toggle.setImage(UIImage.init(named: "Ellipseunpicknone"), for: .selected)
        toggle.addTarget(self, action: #selector(toggleEulaAgreement), for: .touchUpInside)
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
        firstLine.addArrangedSubview(makeAgreementLabel("By continuing, you agree to our"))
        firstLine.addArrangedSubview(makeAgreementButton("Terms of Use", action: #selector(openTermsText)))
        secondLine.addArrangedSubview(makeAgreementLabel("and"))
        secondLine.addArrangedSubview(makeAgreementButton("Privacy Policy.", action: #selector(openPrivacyText)))
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

//    private func refreshAgreementButton(_ button: UIButton) {
//        button.layer.borderColor = hasAgreedEula ? pinkTone.cgColor : UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1).cgColor
//        button.tintColor = hasAgreedEula ? pinkTone : .clear
//        button.setImage(hasAgreedEula ? UIImage(systemName: "checkmark") : nil, for: .normal)
//    }

    private func makeAgreementLabel(_ text: String) -> UILabel {
        let label = makeGateLabel(text, size: 15, weight: .regular, color: inkTone)
        label.textAlignment = .center
        return label
    }

    private func makeAgreementButton(_ text: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(pinkTone, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = inkTone
        button.addTarget(self, action: #selector(closeGate), for: .touchUpInside)
        return button
    }

    private func makeFormPanel() -> UIView {
        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 26
        return panel
    }

    private func makeActionButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .heavy)
        button.backgroundColor = pinkTone
        button.layer.cornerRadius = 26
        return button
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
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 13
        let prefixLabel = makeGateLabel(prefix, size: 17, weight: .regular, color: mutedTone)
        let button = makeFlatLinkButton(title, action: action)
        stack.addArrangedSubview(prefixLabel)
        stack.addArrangedSubview(button)
        return stack
    }

    private func makeFlatLinkButton(_ title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(pinkTone, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeGateLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.font = .systemFont(ofSize: size, weight: weight)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    private func trySignIn(mail: String, secret: String) {
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanMail.isEmpty else {
            showCreamHint("Please enter email")
            return
        }
        guard !cleanSecret.isEmpty else {
            showCreamHint("Please enter password")
            return
        }

        if cleanMail == "wevv@gmail.com" {
            guard cleanSecret == "1234" else {
                showCreamHint("Password is incorrect")
                return
            }
            finishGlazeGate()
            return
        }

        let accounts = storedAccounts()
        guard let account = accounts.first(where: { $0.mail == cleanMail }) else {
            showCreamHint("Account does not exist")
            return
        }
        guard account.secret == cleanSecret else {
            showCreamHint("Password is incorrect")
            return
        }
        finishGlazeGate()
    }

    private func trySignUp(name: String, mail: String, secret: String, confirm: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanMail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanSecret = secret.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirm = confirm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard hasAgreedEula else {
            showCreamHint("Please agree to EULA first")
            return
        }
        guard !cleanName.isEmpty else {
            showCreamHint("Please enter display name")
            return
        }
        guard isValidMail(cleanMail) else {
            showCreamHint("Please enter a valid email")
            return
        }
        guard cleanSecret.count >= 6 else {
            showCreamHint("Password needs at least 6 characters")
            return
        }
        guard cleanSecret == cleanConfirm else {
            showCreamHint("Passwords do not match")
            return
        }
        guard cleanMail != "wevv@gmail.com" else {
            showCreamHint("Account already exists")
            return
        }
        var accounts = storedAccounts()
        guard !accounts.contains(where: { $0.mail == cleanMail }) else {
            showCreamHint("Account already exists")
            return
        }
        accounts.append(WevVCreamAccount(name: cleanName, mail: cleanMail, secret: cleanSecret))
        storeAccounts(accounts)
        finishGlazeGate()
    }

    private func finishGlazeGate() {
        glazeSession.markGlazeTasterReady()
        onGlazeReady?()
    }

    private func storedAccounts() -> [WevVCreamAccount] {
        (frostingDefaults.stringArray(forKey: accountKey) ?? []).compactMap { raw in
            let parts = raw.components(separatedBy: "|")
            guard parts.count == 3 else { return nil }
            return WevVCreamAccount(name: parts[0], mail: parts[1], secret: parts[2])
        }
    }

    private func storeAccounts(_ accounts: [WevVCreamAccount]) {
        let packets = accounts.map { [$0.name, $0.mail, $0.secret].joined(separator: "|") }
        frostingDefaults.set(packets, forKey: accountKey)
    }

    private func isValidMail(_ text: String) -> Bool {
        text.contains("@") && text.contains(".") && text.count >= 5
    }

    private func showEulaCard(autoAgree: Bool) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        view.addSubview(shade)

        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 22
        shade.addSubview(panel)

        let title = makeGateLabel("EULA", size: 20, weight: .heavy, color: inkTone)
        title.textAlignment = .center
        let body = makeGateLabel(eulaText(), size: 13, weight: .regular, color: mutedTone)
        body.numberOfLines = 0
        body.textAlignment = .center
        let agree = makeActionButton("Agree")
        agree.addAction(UIAction { [weak self, weak shade] _ in
            guard let self else { return }
            self.hasAgreedEula = true
            self.frostingDefaults.set(true, forKey: self.agreementKey)
            shade?.removeFromSuperview()
            if autoAgree {
                self.renderGateMode(self.gateMode)
            }
        }, for: .touchUpInside)

        panel.addSubview(title)
        panel.addSubview(body)
        panel.addSubview(agree)

        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panel.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: shade.centerYAnchor),
            panel.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.76),
            title.topAnchor.constraint(equalTo: panel.topAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            body.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 22),
            body.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -22),
            agree.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 20),
            agree.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 24),
            agree.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -24),
            agree.heightAnchor.constraint(equalToConstant: 48),
            agree.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -24)
        ])
    }

    private func eulaText() -> String {
        "WevV is for friendly donut discovery, shop collections, tasting notes, and local challenge participation. Users must be legally allowed to create an account in their region and must follow respectful conduct rules. Unsafe, misleading, harassing, explicit, or illegal content may be removed. Reports and blocks help keep the tasting space safe. Repeated violations may lead to account restriction."
    }

    private func showCreamHint(_ text: String) {
        let hint = makeGateLabel(text, size: 14, weight: .heavy, color: .white)
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.textAlignment = .center
        hint.numberOfLines = 2
        hint.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        hint.layer.cornerRadius = 19
        hint.clipsToBounds = true
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            hint.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.78),
            hint.heightAnchor.constraint(greaterThanOrEqualToConstant: 38)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.2, options: []) {
            hint.alpha = 0
        } completion: { _ in
            hint.removeFromSuperview()
        }
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
        sender.isSelected = !sender.isSelected
        frostingDefaults.set(hasAgreedEula, forKey: agreementKey)
//        refreshAgreementButton(sender)
    }

    @objc private func openEulaButton() {
        showEulaCard(autoAgree: false)
    }

    @objc private func openTermsText() {
        let controller = WevVSugarPlainTextController(
            titleText: "Terms of Use",
            bodyText: "Use WevV for friendly donut discovery, shop collections, check-ins, tasting notes, and challenge participation. Keep every post respectful, avoid unsafe content, and use report or block tools when needed."
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openPrivacyText() {
        let controller = WevVSugarPlainTextController(
            titleText: "Privacy Policy",
            bodyText: "WevV stores this demo account state, saved shops, tasting notes, and challenge activity locally on this device. The app uses those records only to refresh the donut experience."
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSignInLayer() {
        renderGateMode(.signIn)
    }

    @objc private func openSignUpLayer() {
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
