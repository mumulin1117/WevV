import UIKit

final class WevVSugarSettingsController: UIViewController {
    var onSugarSettingChanged: (() -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let sugarScrollView = UIScrollView()
    private let sugarContentView = UIView()
    private let sugarRowsStack = UIStackView()
    private let sugarCacheCountLabel = UILabel()
    private let sugarCacheCountKey = "wGexvkvU_TstuegKa*r@_Bc.akcMhXe:_:cFomuunztb_ytTe:x/te".wevVPastryCrumbBloomRestored
    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.11, green: 0.08, blue: 0.14, alpha: 1)
    private let mutedTone = UIColor(red: 0.54, green: 0.49, blue: 0.58, alpha: 1)

    private struct SugarSettingRowSpec {
        let sugarTitle: String
        let sugarValue: String?
        let showsArrow: Bool
        let action: Selector?
        let countLabel: UILabel?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarSettingsPage()
    }

    private func buildSugarSettingsPage() {
        view.backgroundColor = paleTone
        buildTopBar()
        buildListLayer()
        buildBottomActions()
    }

    private func buildTopBar() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.tintColor = .black
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.addTarget(self, action: #selector(closeSugarSettings), for: .touchUpInside)

        let glazeTitle = makeSettingLabel("Sbejtxtti!nrgcs^".wevVPastryCrumbBloomRestored, size: 16, weight: .heavy, color: inkTone)
        glazeTitle.textAlignment = .center

        view.addSubview(doughBackButton)
        view.addSubview(glazeTitle)

        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70)
        ])
    }

    private func buildListLayer() {
        sugarScrollView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.alwaysBounceVertical = true
        view.addSubview(sugarScrollView)

        sugarContentView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.addSubview(sugarContentView)

        sugarRowsStack.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.axis = .vertical
        sugarRowsStack.spacing = 0
        sugarRowsStack.backgroundColor = .white
        sugarRowsStack.layer.cornerRadius = 4
        sugarRowsStack.clipsToBounds = true
        sugarContentView.addSubview(sugarRowsStack)

        fillSugarSettingRows()

        NSLayoutConstraint.activate([
            sugarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            sugarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sugarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sugarScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sugarContentView.topAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.topAnchor),
            sugarContentView.leadingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.leadingAnchor),
            sugarContentView.trailingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.trailingAnchor),
            sugarContentView.bottomAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.bottomAnchor),
            sugarContentView.widthAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.widthAnchor),
            sugarRowsStack.topAnchor.constraint(equalTo: sugarContentView.topAnchor),
            sugarRowsStack.leadingAnchor.constraint(equalTo: sugarContentView.leadingAnchor, constant: 38),
            sugarRowsStack.trailingAnchor.constraint(equalTo: sugarContentView.trailingAnchor, constant: -38),
            sugarRowsStack.heightAnchor.constraint(equalToConstant: 258)
        ])
    }

    private func fillSugarSettingRows() {
        makeSugarSettingRowSpecs().forEach { crumbSpec in
            sugarRowsStack.addArrangedSubview(
                makeSettingRow(
                    title: crumbSpec.sugarTitle,
                    value: crumbSpec.sugarValue,
                    showsArrow: crumbSpec.showsArrow,
                    action: crumbSpec.action,
                    countLabel: crumbSpec.countLabel
                )
            )
        }
    }

    private func makeSugarSettingRowSpecs() -> [SugarSettingRowSpec] {
        [
            SugarSettingRowSpec(sugarTitle: "EBd^iktw mPErwoLfkiJl.eP".wevVPastryCrumbBloomRestored, sugarValue: nil, showsArrow: true, action: #selector(openEditGlazeProfile), countLabel: nil),
            SugarSettingRowSpec(sugarTitle: "C#lIeCa%rK ncxaIcrh=eE".wevVPastryCrumbBloomRestored, sugarValue: currentSugarCacheCountText(), showsArrow: false, action: #selector(clearSugarCache), countLabel: sugarCacheCountLabel),
            SugarSettingRowSpec(sugarTitle: "Pcr#iZvHaNcqy^ ^PsoxlHiRctyT".wevVPastryCrumbBloomRestored, sugarValue: nil, showsArrow: false, action: #selector(openPrivacySugarText), countLabel: nil),
            SugarSettingRowSpec(sugarTitle: "B^l&aUcskNlDiSsKt!".wevVPastryCrumbBloomRestored, sugarValue: nil, showsArrow: true, action: #selector(openSugarListText), countLabel: nil),
            SugarSettingRowSpec(sugarTitle: "TCeTrum/sR XoIfL ,S@eHrQvXiTc.ea".wevVPastryCrumbBloomRestored, sugarValue: nil, showsArrow: false, action: #selector(openTermsSugarText), countLabel: nil),
            SugarSettingRowSpec(sugarTitle: "App Version", sugarValue: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0", showsArrow: false, action: nil, countLabel: nil)
        ]
    }

    private func buildBottomActions() {
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
            sugarFill: pinkTone,
            fontSize: 15,
            action: #selector(showRestSugarPrompt)
        )

        sugarContentView.addSubview(crumbEraseButton)
        sugarContentView.addSubview(frostingRestButton)

        NSLayoutConstraint.activate([
            crumbEraseButton.topAnchor.constraint(equalTo: sugarRowsStack.bottomAnchor, constant: 52),
            crumbEraseButton.leadingAnchor.constraint(equalTo: sugarRowsStack.leadingAnchor),
            crumbEraseButton.trailingAnchor.constraint(equalTo: sugarRowsStack.trailingAnchor),
            crumbEraseButton.heightAnchor.constraint(equalToConstant: 46),
            frostingRestButton.topAnchor.constraint(equalTo: crumbEraseButton.bottomAnchor, constant: 14),
            frostingRestButton.leadingAnchor.constraint(equalTo: sugarRowsStack.leadingAnchor),
            frostingRestButton.trailingAnchor.constraint(equalTo: sugarRowsStack.trailingAnchor),
            frostingRestButton.heightAnchor.constraint(equalToConstant: 46),
            frostingRestButton.bottomAnchor.constraint(equalTo: sugarContentView.bottomAnchor, constant: -60)
        ])
    }

    private func makeSugarBottomButton(sugarTitle: String, sugarInk: UIColor, sugarFill: UIColor, fontSize: CGFloat, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(sugarTitle, for: .normal)
        sprinkleButton.setTitleColor(sugarInk, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .heavy)
        sprinkleButton.backgroundColor = sugarFill
        sprinkleButton.layer.cornerRadius = 23
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeSettingRow(title: String, value: String?, showsArrow: Bool, action: Selector?, countLabel: UILabel? = nil) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.backgroundColor = .white
        if let action {
            donutRow.addTarget(self, action: action, for: .touchUpInside)
        }

        let glazeTitleLabel = makeSettingLabel(title, size: 13, weight: .heavy, color: inkTone)
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.92, alpha: 1)

        donutRow.addSubview(glazeTitleLabel)
        donutRow.addSubview(divider)

        if let value {
            let valueLabel = countLabel ?? makeSettingLabel(value, size: 12, weight: .regular, color: mutedTone)
            if countLabel != nil {
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.text = value
                valueLabel.textColor = mutedTone
                valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
                valueLabel.adjustsFontSizeToFitWidth = true
                valueLabel.minimumScaleFactor = 0.72
            }
            valueLabel.textAlignment = .right
            donutRow.addSubview(valueLabel)
            pinSugarSettingValue(valueLabel, donutRow: donutRow, glazeTitleLabel: glazeTitleLabel)
        }

        if showsArrow {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.tintColor = UIColor(red: 0.63, green: 0.59, blue: 0.66, alpha: 1)
            arrow.contentMode = .scaleAspectFit
            donutRow.addSubview(arrow)
            pinSugarSettingArrow(arrow, donutRow: donutRow)
        }

        pinSugarSettingRow(donutRow: donutRow, glazeTitleLabel: glazeTitleLabel, divider: divider)
        return donutRow
    }

    private func pinSugarSettingValue(_ valueLabel: UILabel, donutRow: UIControl, glazeTitleLabel: UILabel) {
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -14),
            valueLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: glazeTitleLabel.trailingAnchor, constant: 12)
        ])
    }

    private func pinSugarSettingArrow(_ arrow: UIImageView, donutRow: UIControl) {
        NSLayoutConstraint.activate([
            arrow.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -12),
            arrow.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 10),
            arrow.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func pinSugarSettingRow(donutRow: UIControl, glazeTitleLabel: UILabel, divider: UIView) {
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 43),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor, constant: 14),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            glazeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutRow.trailingAnchor, constant: -55),
            divider.leadingAnchor.constraint(equalTo: glazeTitleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -14),
            divider.bottomAnchor.constraint(equalTo: donutRow.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func currentSugarCacheCountText() -> String {
        UserDefaults.standard.string(forKey: sugarCacheCountKey) ?? "1C2eMHbV".wevVPastryCrumbBloomRestored
    }

    private func showConfirmSugarPanel(title: String, note: String, okTitle: String, cancelTitle: String, okFill: UIColor, okAction: @escaping () -> Void) {
        WevVGlazePromptStyler.showSugarConfirm(
            in: view,
            title: title,
            note: note,
            confirmTitle: okTitle,
            cancelTitle: cancelTitle,
            confirmFill: okFill,
            onConfirm: okAction
        )
    }

    private func makeDialogButton(_ title: String, fill: UIColor, color: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(color, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        sprinkleButton.backgroundColor = fill
        sprinkleButton.layer.cornerRadius = 17
        return sprinkleButton
    }

    private func makeSettingLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func openEditGlazeProfile() {
        let controller = WevVCreamRingEditController()
        controller.onCreamRingSaved = { [weak self] in
            self?.onSugarSettingChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func clearSugarCache() {
        glazeSession.clearSugarCrumbs()
        UserDefaults.standard.set("0=MYbQ".wevVPastryCrumbBloomRestored, forKey: sugarCacheCountKey)
        sugarCacheCountLabel.text = "0YMgbt".wevVPastryCrumbBloomRestored
        showTinySugarHint("CXaAckh.eP TcelfeaaXr&e~d!.O".wevVPastryCrumbBloomRestored)
    }

    @objc private func openPrivacySugarText() {
        openSugarText(title: "PXrRimvkaNcLyj SP;o@lHigcfyL".wevVPastryCrumbBloomRestored, body: privacySugarText())
    }

    @objc private func openSugarListText() {
        let controller = WevVSugarRosterController(mode: .sugarShield)
        controller.onRosterChanged = { [weak self] in
            self?.onSugarSettingChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openTermsSugarText() {
        openSugarText(title: "TWeMrsmKs~ +ovfU &S!ekrwvzi.cLe^".wevVPastryCrumbBloomRestored, body: termsSugarText())
    }

    private func openSugarText(title: String, body: String) {
        let controller = WevVSugarPlainTextController(titleText: title, bodyText: body)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func privacySugarText() -> String {
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

    private func termsSugarText() -> String {
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

    private func showTinySugarHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -18)
    }

    @objc private func showDeleteSugarPrompt() {
        showConfirmSugarPanel(
            title: "DieulLe%tfeE OA#cqcAoFuFnQtl".wevVPastryCrumbBloomRestored,
            note: "Your account and all data will be permanently removed and cannot be recovered.\nThis action cannot be undone.",
            okTitle: "DQe*l~e=t%eW".wevVPastryCrumbBloomRestored,
            cancelTitle: "CYawn^cqe=lL".wevVPastryCrumbBloomRestored,
            okFill: pinkTone
        ) { [weak self] in
            self?.glazeSession.dissolveGlazeTasterPacket()
            self?.onSugarSettingChanged?()
            self?.dismiss(animated: true)
        }
    }

    @objc private func showRestSugarPrompt() {
        showConfirmSugarPanel(
            title: "LRo@gX Qoxu+t%".wevVPastryCrumbBloomRestored,
            note: "A^rYeh Ty,osu; isEugr?e= *yzoIu& PwZaVnqto HtUod %lko!gy :oBunt~?Y".wevVPastryCrumbBloomRestored,
            okTitle: "LJo%gN JohuwtA".wevVPastryCrumbBloomRestored,
            cancelTitle: "CmavnscXeSlM".wevVPastryCrumbBloomRestored,
            okFill: pinkTone
        ) { [weak self] in
            self?.glazeSession.restGlazeTaster()
            self?.onSugarSettingChanged?()
            self?.dismiss(animated: true)
        }
    }

    @objc private func closeSugarSettings() {
        dismiss(animated: true)
    }
}
