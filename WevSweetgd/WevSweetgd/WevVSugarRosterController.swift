import UIKit

enum WevVSugarRosterMode {
    case glazeFollowing
    case sprinkleFollower
    case sugarShield

    var title: String {
        switch self {
        case .glazeFollowing: return "Following"
        case .sprinkleFollower: return "Follower"
        case .sugarShield: return "Blacklist"
        }
    }
}

final class WevVSugarRosterController: UIViewController {
    var onRosterChanged: (() -> Void)?

    private let mode: WevVSugarRosterMode
    private let guestStore = WevVGuestGlazeStore.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.18, green: 0.12, blue: 0.24, alpha: 1)
    private let mutedTone = UIColor(red: 0.56, green: 0.49, blue: 0.58, alpha: 1)
    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)

    init(mode: WevVSugarRosterMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildRosterPage()
        reloadRosterRows()
    }

    private func buildRosterPage() {
        view.backgroundColor = paleTone

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(closeRoster), for: .touchUpInside)

        let title = makeRosterLabel(mode.title, size: 25, weight: .heavy, color: inkTone)
        title.textAlignment = .center

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(back)
        view.addSubview(title)
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            scrollView.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 22),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36)
        ])
    }

    private func reloadRosterRows() {
        stackView.arrangedSubviews.forEach { row in
            stackView.removeArrangedSubview(row)
            row.removeFromSuperview()
        }

        let profiles = currentProfiles()
        guard !profiles.isEmpty else {
            stackView.addArrangedSubview(makeEmptyRoster())
            return
        }
        profiles.forEach { stackView.addArrangedSubview(makeRosterRow($0)) }
    }

    private func currentProfiles() -> [WevVGuestGlazeProfile] {
        switch mode {
        case .glazeFollowing:
            return guestStore.allProfiles.filter { $0.sugarTie.isGlazeFollowed && !$0.sugarTie.isSugarShielded }
        case .sprinkleFollower:
            return guestStore.allProfiles.filter { $0.sugarTie.isSprinkleFan && !$0.sugarTie.isSugarShielded }
        case .sugarShield:
            return guestStore.allProfiles.filter { $0.sugarTie.isSugarShielded }
        }
    }

    private func makeEmptyRoster() -> UIView {
        //        let empty = UIStackView()
        //        empty.translatesAutoresizingMaskIntoConstraints = false
        //        empty.axis = .vertical
        //        empty.alignment = .center
        //        empty.spacing = 10

                let image = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
                image.translatesAutoresizingMaskIntoConstraints = false
                image.contentMode = .scaleAspectFit

               

        //        empty.addArrangedSubview(image)
               
                NSLayoutConstraint.activate([
        //            empty.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.58),
                    image.widthAnchor.constraint(equalToConstant: 140),
                    image.heightAnchor.constraint(equalToConstant: 153)
                ])
                return image
           
    }

    private func makeRosterRow(_ profile: WevVGuestGlazeProfile) -> UIControl {
        let row = UIControl()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.accessibilityIdentifier = profile.glazeKey
        row.backgroundColor = .white
        row.layer.cornerRadius = 22
        row.clipsToBounds = true
        row.addTarget(self, action: #selector(openGuestProfile(_:)), for: .touchUpInside)

        let avatar = UIImageView(image: UIImage(named: profile.avatarAsset))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 28
        avatar.clipsToBounds = true

        let name = makeRosterLabel(profile.name, size: 17, weight: .heavy, color: inkTone)
        let note = makeRosterLabel(profile.signature.replacingOccurrences(of: "\n", with: " · "), size: 13, weight: .medium, color: mutedTone)
        note.numberOfLines = 1

        let action = UIButton(type: .system)
        action.translatesAutoresizingMaskIntoConstraints = false
        action.accessibilityIdentifier = profile.glazeKey
        action.setTitle(rowActionTitle(profile), for: .normal)
        action.setTitleColor(rowActionTextColor(profile), for: .normal)
        action.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        action.backgroundColor = rowActionFill(profile)
        action.layer.cornerRadius = 18
        action.addTarget(self, action: #selector(tapRosterAction(_:)), for: .touchUpInside)

        row.addSubview(avatar)
        row.addSubview(name)
        row.addSubview(note)
        row.addSubview(action)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 86),
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
            action.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            action.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            action.widthAnchor.constraint(equalToConstant: 92),
            action.heightAnchor.constraint(equalToConstant: 36),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),
            name.topAnchor.constraint(equalTo: row.topAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: action.leadingAnchor, constant: -12),
            note.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            note.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5)
        ])
        return row
    }

    private func rowActionTitle(_ profile: WevVGuestGlazeProfile) -> String {
        if mode == .sugarShield { return "Remove" }
        return profile.sugarTie.isGlazeFollowed ? "Following" : "Follow"
    }

    private func rowActionFill(_ profile: WevVGuestGlazeProfile) -> UIColor {
        if mode == .sugarShield { return UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1) }
        return profile.sugarTie.isGlazeFollowed ? UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1) : pinkTone
    }

    private func rowActionTextColor(_ profile: WevVGuestGlazeProfile) -> UIColor {
        mode == .sugarShield ? inkTone : .white
    }

    private func makeRosterLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.font = .systemFont(ofSize: size, weight: weight)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    @objc private func tapRosterAction(_ sender: UIButton) {
        guard let key = sender.accessibilityIdentifier else { return }
        switch mode {
        case .sugarShield:
            _ = guestStore.toggleSugarShield(for: key)
        case .glazeFollowing, .sprinkleFollower:
            _ = guestStore.toggleGlazeFollow(for: key)
        }
        reloadRosterRows()
        onRosterChanged?()
    }

    @objc private func openGuestProfile(_ sender: UIControl) {
        let key = sender.accessibilityIdentifier ?? ""
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == key }) else { return }
        let controller = WevVGuestGlazeProfileController(guestKey: key)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func closeRoster() {
        dismiss(animated: true)
    }
}
