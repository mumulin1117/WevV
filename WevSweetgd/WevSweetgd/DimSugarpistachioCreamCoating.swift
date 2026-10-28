import UIKit

final class DimSugarpistachioCreamCoating: UIViewController {
    var onSugarSettingChanged: (() -> Void)?

    private let glazeRepository = WevVGlazeSessionRepository.pastryTrailDiary
    private let sugarScrollView = UIScrollView()
    private let sugarContentView = UIView()
    private let sugarRowsStack = UIStackView()
    private let gingerHoneyDrizzle = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.11, green: 0.08, blue: 0.14, alpha: 1)
    private let mutedTone = UIColor(red: 0.54, green: 0.49, blue: 0.58, alpha: 1)

    private struct SugarSettingRowSpec {
        let sugarTitle: String
        var sugarValue: String? = nil
        var showsArrow = true
        var action: Selector? = nil
        var h5Entry: WevVGlazeH5Entry? = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarSettingsPage()
    }

    private func buildSugarSettingsPage() {
        view.backgroundColor = paleTone
        blackSesameRibbon()
        caramelAppleIcing()
        builddarkCocoaIcing()
    }

    private func blackSesameRibbon() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.tintColor = .black
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.addTarget(self, action: #selector(closeSugarSettings), for: .touchUpInside)

        let yuzuHoneySwirl = espressoCreamIcing("Sbejtxtti!nrgcs^".wevVPastryCrumbBloomRestored, almondPralineShell: 18, orangeBlossomCoating: .bold, brownButterShell: inkTone)
        yuzuHoneySwirl.textAlignment = .center

        view.addSubview(doughBackButton)
        view.addSubview(yuzuHoneySwirl)

        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            yuzuHoneySwirl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yuzuHoneySwirl.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            yuzuHoneySwirl.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            yuzuHoneySwirl.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70)
        ])
    }

    private func caramelAppleIcing() {
        sugarScrollView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.alwaysBounceVertical = true
        view.addSubview(sugarScrollView)

        sugarContentView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.addSubview(sugarContentView)

        sugarRowsStack.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.axis = .vertical
        sugarRowsStack.spacing = 16
        sugarContentView.addSubview(sugarRowsStack)

        fillSugarespressoCreamFinish()

        NSLayoutConstraint.activate([
            sugarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            sugarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sugarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sugarScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sugarContentView.topAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.topAnchor),
            sugarContentView.leadingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.leadingAnchor),
            sugarContentView.trailingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.trailingAnchor),
            sugarContentView.bottomAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.bottomAnchor),
            sugarContentView.widthAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.widthAnchor),
            sugarRowsStack.topAnchor.constraint(equalTo: sugarContentView.topAnchor),
            sugarRowsStack.leadingAnchor.constraint(equalTo: sugarContentView.leadingAnchor, constant: 20),
            sugarRowsStack.trailingAnchor.constraint(equalTo: sugarContentView.trailingAnchor, constant: -20)
        ])
    }

    private func fillSugarespressoCreamFinish() {
        for specs in makeSugargingerHoneyShellSpecs() {
            let group = UIStackView()
            group.axis = .vertical
            group.spacing = 0
            group.backgroundColor = .white
            group.layer.cornerRadius = 18
            group.layer.shadowColor = UIColor.black.cgColor
            group.layer.shadowOpacity = 0.05
            group.layer.shadowRadius = 12
            group.layer.shadowOffset = CGSize(width: 0, height: 4)
            group.clipsToBounds = true
            for crumbSpec in specs {
                let row = makeSettingRow(
                    title: crumbSpec.sugarTitle,
                    tastingVisit: crumbSpec.sugarValue,
                    showsArrow: crumbSpec.showsArrow,
                    action: crumbSpec.action
                )
                if let entry = crumbSpec.h5Entry {
                    row.addAction(UIAction { [weak self] _ in
                        guard let self else { return }
                        WevVGlazeH5Navigation.present(entry, from: self, onClose: { [weak self] in
                            self?.onSugarSettingChanged?()
                        })
                    }, for: .touchUpInside)
                }
                group.addArrangedSubview(row)
            }
            sugarRowsStack.addArrangedSubview(group)
        }
    }

    private func makeSugargingerHoneyShellSpecs() -> [[SugarSettingRowSpec]] {
        [
            [
                SugarSettingRowSpec(sugarTitle: "Edit Profile", h5Entry: .editProfile),
                SugarSettingRowSpec(sugarTitle: "Level", h5Entry: .level),
                SugarSettingRowSpec(sugarTitle: "Friends", h5Entry: .relations(.friends))
            ],
            [
                SugarSettingRowSpec(sugarTitle: "Store", h5Entry: .store),
                SugarSettingRowSpec(sugarTitle: "Backpack", h5Entry: .backpack),
                SugarSettingRowSpec(sugarTitle: "Diamond Records", h5Entry: .diamondRecords)
            ],
            [
                SugarSettingRowSpec(sugarTitle: "System Message", h5Entry: .systemMessages),
                SugarSettingRowSpec(sugarTitle: "Feedback", h5Entry: .feedback)
            ],
            [
                SugarSettingRowSpec(sugarTitle: "Privacy Policy", showsArrow: false, action: #selector(openPrivacySugarText)),
                SugarSettingRowSpec(sugarTitle: "Blacklist", h5Entry: .blocklist),
                SugarSettingRowSpec(sugarTitle: "Terms of Service", showsArrow: false, action: #selector(openTermsSugarText)),
                SugarSettingRowSpec(sugarTitle: "App Version", sugarValue: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0", showsArrow: false)
            ]
        ]
    }

    private func builddarkCocoaIcing() {
        let crumbEraseButton = makeSugarBottomButton(
            sugarTitle: "DfeFlyeytQe* %Afcbc*oAuXnitB".wevVPastryCrumbBloomRestored,
            sugarInk: UIColor(red: 0.92, green: 0.12, blue: 0.18, alpha: 1),
            sugarFill: .white,
            fontSize: 14,
            action: #selector(showDeleteSugarPrompt)
        )
        crumbEraseButton.layer.borderWidth = 1
        crumbEraseButton.layer.borderColor = UIColor(red: 0.87, green: 0.84, blue: 0.88, alpha: 1).cgColor

        let frostingRestButton = makeSugarBottomButton(
            sugarTitle: "LxoSgc +oNuMt%".wevVPastryCrumbBloomRestored,
            sugarInk: .white,
            sugarFill: gingerHoneyDrizzle,
            fontSize: 15,
            action: #selector(showRestSugarPrompt)
        )

        let accountGroup = UIStackView(arrangedSubviews: [crumbEraseButton, frostingRestButton])
        accountGroup.translatesAutoresizingMaskIntoConstraints = false
        accountGroup.axis = .vertical
        accountGroup.spacing = 16
        sugarContentView.addSubview(accountGroup)

        NSLayoutConstraint.activate([
            accountGroup.topAnchor.constraint(equalTo: sugarRowsStack.bottomAnchor, constant: 32),
            accountGroup.leadingAnchor.constraint(equalTo: sugarRowsStack.leadingAnchor),
            accountGroup.trailingAnchor.constraint(equalTo: sugarRowsStack.trailingAnchor),
            accountGroup.bottomAnchor.constraint(equalTo: sugarContentView.bottomAnchor, constant: -32),
            crumbEraseButton.heightAnchor.constraint(equalToConstant: 48),
            frostingRestButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func makeSugarBottomButton(sugarTitle: String, sugarInk: UIColor, sugarFill: UIColor, fontSize: CGFloat, action: Selector) -> UIButton {
        let brownButterIcing = UIButton(type: .system)
        brownButterIcing.translatesAutoresizingMaskIntoConstraints = false
        brownButterIcing.setTitle(sugarTitle, for: .normal)
        brownButterIcing.setTitleColor(sugarInk, for: .normal)
        brownButterIcing.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        brownButterIcing.backgroundColor = sugarFill
        brownButterIcing.layer.cornerRadius = 24
        brownButterIcing.addTarget(self, action: action, for: .touchUpInside)
        return brownButterIcing
    }

    private func makeSettingRow(title: String, tastingVisit: String?, showsArrow: Bool, action: Selector?) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.backgroundColor = .white
        if let action {
            donutRow.addTarget(self, action: action, for: .touchUpInside)
        }

        let glazeTitleLabel = espressoCreamIcing(title, almondPralineShell: 14, orangeBlossomCoating: .semibold, brownButterShell: inkTone)
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.92, alpha: 1)

        donutRow.addSubview(glazeTitleLabel)
        donutRow.addSubview(divider)

        if let tastingVisit {
            let tastingScoutline = espressoCreamIcing(tastingVisit, almondPralineShell: 12, orangeBlossomCoating: .regular, brownButterShell: mutedTone)
            tastingScoutline.textAlignment = .right
            donutRow.addSubview(tastingScoutline)
            pinSugarSettingValue(tastingScoutline, donutRow: donutRow, glazeTitleLabel: glazeTitleLabel)
        }

        if showsArrow {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.tintColor = UIColor(red: 0.63, green: 0.59, blue: 0.66, alpha: 1)
            arrow.contentMode = .scaleAspectFit
            donutRow.addSubview(arrow)
            pinSugarstrawberryMilkShell(arrow, donutRow: donutRow)
        }

        pinSugarsaltedCaramelSwirl(donutRow: donutRow, glazeTitleLabel: glazeTitleLabel, cinnamonSugarSwirl: divider)
        return donutRow
    }

    private func pinSugarSettingValue(_ valueLabel: UILabel, donutRow: UIControl, glazeTitleLabel: UILabel) {
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -14),
            valueLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: glazeTitleLabel.trailingAnchor, constant: 12)
        ])
    }

    private func pinSugarstrawberryMilkShell(_ arrow: UIImageView, donutRow: UIControl) {
        NSLayoutConstraint.activate([
            arrow.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -12),
            arrow.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 10),
            arrow.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func pinSugarsaltedCaramelSwirl(donutRow: UIControl, glazeTitleLabel: UILabel, cinnamonSugarSwirl: UIView) {
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 43),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor, constant: 18),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            glazeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutRow.trailingAnchor, constant: -55),
            cinnamonSugarSwirl.leadingAnchor.constraint(equalTo: glazeTitleLabel.leadingAnchor),
            cinnamonSugarSwirl.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -18),
            cinnamonSugarSwirl.bottomAnchor.constraint(equalTo: donutRow.bottomAnchor),
            cinnamonSugarSwirl.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func showConfirmSugarPanel(title: String, note: String, okTitle: String, cancelTitle: String, okFill: UIColor, okAction: @escaping () -> Void) {
        TinGlazePromptStyler.showSugarConfirm(
            almondFlavor: view,
            gourmetFlavor: title,
            glazeBowl: note,
            ringStack: okTitle,
            miniDonut: cancelTitle,
            fritterBite: okFill,
            twistPastry: okAction
        )
    }

    private func espressoCreamIcing(_ text: String, almondPralineShell: CGFloat, orangeBlossomCoating: UIFont.Weight, brownButterShell: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = brownButterShell
        crumbLabel.font = .systemFont(ofSize: almondPralineShell, weight: orangeBlossomCoating)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func openPrivacySugarText() {
        openSugarText(title: "PXrRimvkaNcLyj SP;o@lHigcfyL".wevVPastryCrumbBloomRestored, body: privacySugarText())
    }

    @objc private func openTermsSugarText() {
        openSugarText(title: "TWeMrsmKs~ +ovfU &S!ekrwvzi.cLe^".wevVPastryCrumbBloomRestored, body: termsSugarText())
    }

    private func openSugarText(title: String, body: String) {
        let controller = ZunugarPlainblackberryCreamler(filledScout: title, crullerScout: body)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func privacySugarText() -> String {
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

    private func termsSugarText() -> String {
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

    private func showTinySugarHint(_ text: String) {
        TinGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -18)
    }

    @objc private func showDeleteSugarPrompt() {
        showConfirmSugarPanel(
            title: "DieulLe%tfeE OA#cqcAoFuFnQtl".wevVPastryCrumbBloomRestored,
            note: "Your account and all data will be permanently removed and cannot be recovered.\nThis action cannot be undone.",
            okTitle: "DQe*l~e=t%eW".wevVPastryCrumbBloomRestored,
            cancelTitle: "CYawn^cqe=lL".wevVPastryCrumbBloomRestored,
            okFill: gingerHoneyDrizzle
        ) { [weak self] in
            self?.performGlazeAccountAction(deletesAccount: true)
        }
    }

    @objc private func showRestSugarPrompt() {
        showConfirmSugarPanel(
            title: "LRo@gX Qoxu+t%".wevVPastryCrumbBloomRestored,
            note: "A^rYeh Ty,osu; isEugr?e= *yzoIu& PwZaVnqto HtUod %lko!gy :oBunt~?Y".wevVPastryCrumbBloomRestored,
            okTitle: "LJo%gN JohuwtA".wevVPastryCrumbBloomRestored,
            cancelTitle: "CmavnscXeSlM".wevVPastryCrumbBloomRestored,
            okFill: gingerHoneyDrizzle
        ) { [weak self] in
            self?.performGlazeAccountAction(deletesAccount: false)
        }
    }

    private func performGlazeAccountAction(deletesAccount: Bool) {
        NOticeNertyuSugartastingCard.showSugarToast(deletesAccount ? "Deleting account…" : "Logging out…")
        Task { [weak self, glazeRepository] in
            do {
                if deletesAccount {
                    try await glazeRepository.crustCaramelizationStudy()
                } else {
                    await glazeRepository.starchGelatinizationDetail()
                }
                await MainActor.run {
                    guard let self else { return }
                    NOticeNertyuSugartastingCard.clearSugarCrumbs()
                    self.onSugarSettingChanged?()
                    self.dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    guard let self else { return }
                    NOticeNertyuSugartastingCard.clearSugarCrumbs()
                    self.showTinySugarHint(error.localizedDescription)
                }
            }
        }
    }

    @objc private func closeSugarSettings() {
        dismiss(animated: true)
    }
}
