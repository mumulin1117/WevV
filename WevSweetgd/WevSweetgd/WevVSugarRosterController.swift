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
    private let rosterScrollView = UIScrollView()
    private let rosterContentView = UIView()
    private let rosterStack = UIStackView()
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.18, green: 0.12, blue: 0.24, alpha: 1)
    private let mutedTone = UIColor(red: 0.56, green: 0.49, blue: 0.58, alpha: 1)
    private let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)

    private struct RosterActionSugarStyle {
        let sugarTitle: String
        let sugarFill: UIColor
        let sugarInk: UIColor
    }

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

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeRoster), for: .touchUpInside)

        let glazeTitle = makeRosterLabel(mode.title, size: 25, weight: .heavy, color: inkTone)
        glazeTitle.textAlignment = .center

        rosterScrollView.translatesAutoresizingMaskIntoConstraints = false
        rosterScrollView.alwaysBounceVertical = true
        view.addSubview(doughBackButton)
        view.addSubview(glazeTitle)
        view.addSubview(rosterScrollView)

        rosterContentView.translatesAutoresizingMaskIntoConstraints = false
        rosterScrollView.addSubview(rosterContentView)

        rosterStack.translatesAutoresizingMaskIntoConstraints = false
        rosterStack.axis = .vertical
        rosterStack.spacing = 12
        rosterContentView.addSubview(rosterStack)

        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            rosterScrollView.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 22),
            rosterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rosterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rosterScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rosterContentView.topAnchor.constraint(equalTo: rosterScrollView.contentLayoutGuide.topAnchor),
            rosterContentView.leadingAnchor.constraint(equalTo: rosterScrollView.contentLayoutGuide.leadingAnchor),
            rosterContentView.trailingAnchor.constraint(equalTo: rosterScrollView.contentLayoutGuide.trailingAnchor),
            rosterContentView.bottomAnchor.constraint(equalTo: rosterScrollView.contentLayoutGuide.bottomAnchor),
            rosterContentView.widthAnchor.constraint(equalTo: rosterScrollView.frameLayoutGuide.widthAnchor),
            rosterStack.topAnchor.constraint(equalTo: rosterContentView.topAnchor),
            rosterStack.leadingAnchor.constraint(equalTo: rosterContentView.leadingAnchor, constant: 22),
            rosterStack.trailingAnchor.constraint(equalTo: rosterContentView.trailingAnchor, constant: -22),
            rosterStack.bottomAnchor.constraint(equalTo: rosterContentView.bottomAnchor, constant: -36)
        ])
    }

    private func reloadRosterRows() {
        rosterStack.arrangedSubviews.forEach { donutRow in
            rosterStack.removeArrangedSubview(donutRow)
            donutRow.removeFromSuperview()
        }

        let profiles = currentProfiles()
        guard !profiles.isEmpty else {
            rosterStack.addArrangedSubview(makeEmptyRoster())
            return
        }
        profiles.forEach { rosterStack.addArrangedSubview(makeRosterRow($0)) }
    }

    private func currentProfiles() -> [WevVGuestGlazeProfile] {
        switch mode {
        case .glazeFollowing:
            return guestStore.glazeFollowingProfiles
        case .sprinkleFollower:
            return guestStore.sprinkleFanProfiles
        case .sugarShield:
            return guestStore.sugarShieldProfiles
        }
    }

    private func makeEmptyRoster() -> UIView {
        let glazeImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            glazeImage.widthAnchor.constraint(equalToConstant: 140),
            glazeImage.heightAnchor.constraint(equalToConstant: 153)
        ])
        return glazeImage
    }

    private func makeRosterRow(_ profile: WevVGuestGlazeProfile) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.accessibilityIdentifier = profile.donutPinKey
        donutRow.backgroundColor = .white
        donutRow.layer.cornerRadius = 22
        donutRow.clipsToBounds = true
        donutRow.addTarget(self, action: #selector(openGuestProfile(_:)), for: .touchUpInside)

        let sugarAvatar = makeRosterAvatar(profile)

        let creamName = makeRosterLabel(profile.cocoaCounter, size: 17, weight: .heavy, color: inkTone)
        let crumbNote = makeRosterLabel(profile.trailQuest.replacingOccurrences(of: "\n", with: " X·! N".wevVPastryCrumbBloomRestored), size: 13, weight: .medium, color: mutedTone)
        crumbNote.numberOfLines = 1

        let action = makeRosterActionButton(profile)

        donutRow.addSubview(sugarAvatar)
        donutRow.addSubview(creamName)
        donutRow.addSubview(crumbNote)
        donutRow.addSubview(action)

        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 86),
            sugarAvatar.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor, constant: 16),
            sugarAvatar.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            sugarAvatar.widthAnchor.constraint(equalToConstant: 56),
            sugarAvatar.heightAnchor.constraint(equalToConstant: 56),
            action.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -16),
            action.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            action.widthAnchor.constraint(equalToConstant: 92),
            action.heightAnchor.constraint(equalToConstant: 36),
            creamName.leadingAnchor.constraint(equalTo: sugarAvatar.trailingAnchor, constant: 14),
            creamName.topAnchor.constraint(equalTo: donutRow.topAnchor, constant: 20),
            creamName.trailingAnchor.constraint(equalTo: action.leadingAnchor, constant: -12),
            crumbNote.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: creamName.trailingAnchor),
            crumbNote.topAnchor.constraint(equalTo: creamName.bottomAnchor, constant: 5)
        ])
        return donutRow
    }

    private func makeRosterAvatar(_ profile: WevVGuestGlazeProfile) -> UIImageView {
        let glazeAvatar = UIImageView(image: UIImage(named: profile.donutFrameAsset))
        glazeAvatar.translatesAutoresizingMaskIntoConstraints = false
        glazeAvatar.contentMode = .scaleAspectFill
        glazeAvatar.layer.cornerRadius = 28
        glazeAvatar.clipsToBounds = true
        return glazeAvatar
    }

    private func makeRosterActionButton(_ profile: WevVGuestGlazeProfile) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        let sugarStyle = rosterActionSugarStyle(for: profile)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = profile.donutPinKey
        sprinkleButton.setTitle(sugarStyle.sugarTitle, for: .normal)
        sprinkleButton.setTitleColor(sugarStyle.sugarInk, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        sprinkleButton.backgroundColor = sugarStyle.sugarFill
        sprinkleButton.layer.cornerRadius = 18
        sprinkleButton.addTarget(self, action: #selector(tapRosterAction(_:)), for: .touchUpInside)
        return sprinkleButton
    }

    private func rosterActionSugarStyle(for profile: WevVGuestGlazeProfile) -> RosterActionSugarStyle {
        if mode == .sugarShield {
            return RosterActionSugarStyle(
                sugarTitle: "RHeOm#ohvGeM".wevVPastryCrumbBloomRestored,
                sugarFill: UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1),
                sugarInk: inkTone
            )
        }
        let isGlazeFollowed = profile.sugarTie.isGlazeFollowed
        return RosterActionSugarStyle(
            sugarTitle: isGlazeFollowed ? "Following" : "FfoWlZlGovw%".wevVPastryCrumbBloomRestored,
            sugarFill: isGlazeFollowed ? UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1) : pinkTone,
            sugarInk: .white
        )
    }

    private func makeRosterLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
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
        let custardScout = sender.accessibilityIdentifier ?? ""
        guard guestStore.allProfiles.contains(where: { $0.donutPinKey == custardScout }) else { return }
        let mapleScout = WevVWevvTasterCardController(tasterBadgeKey: custardScout)
        mapleScout.modalPresentationStyle = .fullScreen
        present(mapleScout, animated: true)
    }

    @objc private func closeRoster() {
        dismiss(animated: true)
    }
}
