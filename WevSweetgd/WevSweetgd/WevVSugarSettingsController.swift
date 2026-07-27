import UIKit

final class WevVSugarSettingsController: UIViewController {
    var onSugarSettingChanged: (() -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.11, green: 0.08, blue: 0.14, alpha: 1)
    private let mutedTone = UIColor(red: 0.54, green: 0.49, blue: 0.58, alpha: 1)

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
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.tintColor = .black
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(closeSugarSettings), for: .touchUpInside)

        let title = makeSettingLabel("Settings", size: 16, weight: .heavy, color: inkTone)
        title.textAlignment = .center

        view.addSubview(back)
        view.addSubview(title)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70)
        ])
    }

    private func buildListLayer() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        contentView.addSubview(stackView)

        [
            makeSettingRow(title: "Edit Profile", value: nil, showsArrow: true, action: #selector(openEditGlazeProfile)),
            makeSettingRow(title: "Clear cache", value: "12Mb", showsArrow: false, action: #selector(clearSugarCache)),
            makeSettingRow(title: "Privacy Policy", value: nil, showsArrow: false, action: #selector(openPrivacySugarText)),
            makeSettingRow(title: "Blacklist", value: nil, showsArrow: true, action: #selector(openSugarListText)),
            makeSettingRow(title: "Terms of Service", value: nil, showsArrow: false, action: #selector(openTermsSugarText)),
            makeSettingRow(title: "App Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0", showsArrow: false, action: nil)
        ].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
            stackView.heightAnchor.constraint(equalToConstant: 258)
        ])
    }

    private func buildBottomActions() {
        let removeButton = UIButton(type: .system)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Delete Account", for: .normal)
        removeButton.setTitleColor(UIColor(red: 0.92, green: 0.12, blue: 0.18, alpha: 1), for: .normal)
        removeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        removeButton.backgroundColor = .white
        removeButton.layer.cornerRadius = 23
        removeButton.layer.borderWidth = 1
        removeButton.layer.borderColor = UIColor(red: 0.87, green: 0.84, blue: 0.88, alpha: 1).cgColor
        removeButton.addTarget(self, action: #selector(showDeleteSugarPrompt), for: .touchUpInside)

        let restButton = UIButton(type: .system)
        restButton.translatesAutoresizingMaskIntoConstraints = false
        restButton.setTitle("Log out", for: .normal)
        restButton.setTitleColor(.white, for: .normal)
        restButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        restButton.backgroundColor = pinkTone
        restButton.layer.cornerRadius = 23
        restButton.addTarget(self, action: #selector(showRestSugarPrompt), for: .touchUpInside)

        contentView.addSubview(removeButton)
        contentView.addSubview(restButton)

        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 52),
            removeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            removeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 46),
            restButton.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 14),
            restButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            restButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            restButton.heightAnchor.constraint(equalToConstant: 46),
            restButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }

    private func makeSettingRow(title: String, value: String?, showsArrow: Bool, action: Selector?) -> UIControl {
        let row = UIControl()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.backgroundColor = .white
        if let action {
            row.addTarget(self, action: action, for: .touchUpInside)
        }

        let titleLabel = makeSettingLabel(title, size: 13, weight: .heavy, color: inkTone)
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.92, alpha: 1)

        row.addSubview(titleLabel)
        row.addSubview(divider)

        if let value {
            let valueLabel = makeSettingLabel(value, size: 12, weight: .regular, color: mutedTone)
            valueLabel.textAlignment = .right
            row.addSubview(valueLabel)
            NSLayoutConstraint.activate([
                valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),
                valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
            ])
        }

        if showsArrow {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.tintColor = UIColor(red: 0.63, green: 0.59, blue: 0.66, alpha: 1)
            arrow.contentMode = .scaleAspectFit
            row.addSubview(arrow)
            NSLayoutConstraint.activate([
                arrow.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12),
                arrow.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                arrow.widthAnchor.constraint(equalToConstant: 10),
                arrow.heightAnchor.constraint(equalToConstant: 14)
            ])
        }

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 43),
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: row.trailingAnchor, constant: -55),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),
            divider.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        return row
    }

    private func showConfirmSugarPanel(title: String, note: String, okTitle: String, cancelTitle: String, okFill: UIColor, okAction: @escaping () -> Void) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        view.addSubview(shade)

        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 16
        shade.addSubview(panel)

        let titleLabel = makeSettingLabel(title, size: 16, weight: .heavy, color: .black)
        titleLabel.textAlignment = .center
        let noteLabel = makeSettingLabel(note, size: 11, weight: .regular, color: mutedTone)
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0

        let cancelButton = makeDialogButton(cancelTitle, fill: UIColor(red: 0.8, green: 0.8, blue: 0.82, alpha: 1), color: .white)
        let okButton = makeDialogButton(okTitle, fill: okFill, color: .white)
        cancelButton.addAction(UIAction { [weak shade] _ in shade?.removeFromSuperview() }, for: .touchUpInside)
        okButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
            okAction()
        }, for: .touchUpInside)

        panel.addSubview(titleLabel)
        panel.addSubview(noteLabel)
        panel.addSubview(cancelButton)
        panel.addSubview(okButton)

        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panel.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: shade.centerYAnchor, constant: -8),
            panel.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.6),
            panel.heightAnchor.constraint(greaterThanOrEqualToConstant: 142),
            titleLabel.topAnchor.constraint(equalTo: panel.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -18),
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            noteLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 18),
            cancelButton.widthAnchor.constraint(equalTo: panel.widthAnchor, multiplier: 0.34),
            cancelButton.heightAnchor.constraint(equalToConstant: 34),
            okButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
            okButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            okButton.widthAnchor.constraint(equalTo: panel.widthAnchor, multiplier: 0.38),
            okButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            okButton.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20)
        ])
    }

    private func makeDialogButton(_ title: String, fill: UIColor, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        button.backgroundColor = fill
        button.layer.cornerRadius = 17
        return button
    }

    private func makeSettingLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.font = .systemFont(ofSize: size, weight: weight)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    @objc private func openEditGlazeProfile() {
        showTinySugarHint("Profile editing is ready for your next frosting pass.")
    }

    @objc private func clearSugarCache() {
        glazeSession.clearSugarCrumbs()
        showTinySugarHint("Cache cleared.")
    }

    @objc private func openPrivacySugarText() {
        openSugarText(title: "Privacy Policy", body: "WevV keeps this donut tasting experience local for demo data. Your tasting choices, saved shops, stamps, and challenge joins stay in the app sandbox for a private preview.")
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
        openSugarText(title: "Terms of Service", body: "Use WevV for friendly donut discovery, shop collections, check-ins, tasting notes, and challenge participation. Keep content respectful and report unsafe behavior.")
    }

    private func openSugarText(title: String, body: String) {
        let controller = WevVSugarPlainTextController(titleText: title, bodyText: body)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func showTinySugarHint(_ text: String) {
        let hint = makeSettingLabel(text, size: 13, weight: .heavy, color: .white)
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.textAlignment = .center
        hint.numberOfLines = 2
        hint.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        hint.layer.cornerRadius = 20
        hint.clipsToBounds = true
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            hint.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.78),
            hint.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.05, options: []) {
            hint.alpha = 0
        } completion: { _ in
            hint.removeFromSuperview()
        }
    }

    @objc private func showDeleteSugarPrompt() {
        showConfirmSugarPanel(
            title: "Delete Account",
            note: "Your account and all data will be permanently removed and cannot be recovered.\nThis action cannot be undone.",
            okTitle: "Delete",
            cancelTitle: "Cancel",
            okFill: pinkTone
        ) { [weak self] in
            self?.glazeSession.dissolveGlazeTasterPacket()
            self?.onSugarSettingChanged?()
            self?.dismiss(animated: true)
        }
    }

    @objc private func showRestSugarPrompt() {
        showConfirmSugarPanel(
            title: "Log out",
            note: "Are you sure you want to log out?",
            okTitle: "Log out",
            cancelTitle: "Cancel",
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
