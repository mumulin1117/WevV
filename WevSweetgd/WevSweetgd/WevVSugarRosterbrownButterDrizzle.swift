import UIKit

enum WevVSugarRosterMode {
    case glazeFollowing
    case sprinkleFollower
    case sugarShield

    var title: String {
        switch self {
        case .glazeFollowing: return "Following"
        case .sprinkleFollower: return "Followers"
        case .sugarShield: return "Blacklist"
        }
    }
}

final class WevVSugarRosterbrownButterDrizzle: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var onRosterChanged: (() -> Void)?

    private var mode: WevVSugarRosterMode
    private let repository = WevVGlazeSocialRepository.pastryTrailDiary
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let statusLabel = UILabel()
    private let emptyImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
    private let followingButton = UIButton(type: .system)
    private let followerButton = UIButton(type: .system)
    private let selectionBar = UIView()
    private var selectionLeading: NSLayoutConstraint?
    private var earlyMorningGuide: [goldenCrumbCenter] = []
    private var loadTask: Task<Void, Never>?

    init(mode: WevVSugarRosterMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildRosterPage()
        refreshRosterHeader(animated: false)
        loadRoster()
    }

    deinit { loadTask?.cancel() }

    private func buildRosterPage() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        view.addSubview(backdrop)

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(closeRoster), for: .touchUpInside)

        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        view.addSubview(back)

        if mode == .sugarShield {
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.text = mode.title
            title.font = .systemFont(ofSize: 18, weight: .bold)
            title.textAlignment = .center
            header.addSubview(title)
            NSLayoutConstraint.activate([
                title.centerXAnchor.constraint(equalTo: header.centerXAnchor),
                title.centerYAnchor.constraint(equalTo: header.centerYAnchor)
            ])
        } else {
            followingButton.translatesAutoresizingMaskIntoConstraints = false
            followerButton.translatesAutoresizingMaskIntoConstraints = false
            [followingButton, followerButton].forEach {
                $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
                $0.setTitleColor(UIColor(red: 0.13, green: 0.08, blue: 0.14, alpha: 1), for: .normal)
                header.addSubview($0)
            }
            followingButton.setTitle("Following", for: .normal)
            followerButton.setTitle("Followers", for: .normal)
            followingButton.addTarget(self, action: #selector(showFollowing), for: .touchUpInside)
            followerButton.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
            selectionBar.translatesAutoresizingMaskIntoConstraints = false
            selectionBar.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.61, alpha: 1)
            selectionBar.layer.cornerRadius = 1.5
            header.addSubview(selectionBar)
            selectionLeading = selectionBar.centerXAnchor.constraint(equalTo: followingButton.centerXAnchor)
            NSLayoutConstraint.activate([
                followingButton.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: -2),
                followingButton.trailingAnchor.constraint(equalTo: header.centerXAnchor, constant: -12),
                followingButton.widthAnchor.constraint(equalToConstant: 84),
                followerButton.centerYAnchor.constraint(equalTo: followingButton.centerYAnchor),
                followerButton.leadingAnchor.constraint(equalTo: header.centerXAnchor, constant: 12),
                followerButton.widthAnchor.constraint(equalToConstant: 84),
                selectionLeading!,
                selectionBar.topAnchor.constraint(equalTo: followingButton.bottomAnchor, constant: 4),
                selectionBar.widthAnchor.constraint(equalToConstant: 32),
                selectionBar.heightAnchor.constraint(equalToConstant: 3)
            ])
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 68
        tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 20, right: 0)
        tableView.register(WevVGlazeRosterCell.self, forCellReuseIdentifier: "WevVGlazeRosterCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshRoster), for: .valueChanged)

        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.contentMode = .scaleAspectFit
        emptyImage.isHidden = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.textColor = UIColor(white: 0.48, alpha: 1)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.text = "Loading…"

        view.addSubview(tableView)
        view.addSubview(emptyImage)
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            header.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 6),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            header.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -34),
            emptyImage.widthAnchor.constraint(equalToConstant: 110),
            emptyImage.heightAnchor.constraint(equalToConstant: 110),
            statusLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
    }

    private func refreshRosterHeader(animated: Bool) {
        guard mode != .sugarShield else { return }
        selectionLeading?.isActive = false
        let target = mode == .glazeFollowing ? followingButton : followerButton
        selectionLeading = selectionBar.centerXAnchor.constraint(equalTo: target.centerXAnchor)
        selectionLeading?.isActive = true
        followingButton.alpha = mode == .glazeFollowing ? 1 : 0.45
        followerButton.alpha = mode == .sprinkleFollower ? 1 : 0.45
        if animated { UIView.animate(withDuration: 0.22) { self.view.layoutIfNeeded() } }
    }

    @objc private func showFollowing() { switchRoster(to: .glazeFollowing) }
    @objc private func showFollowers() { switchRoster(to: .sprinkleFollower) }

    private func switchRoster(to newMode: WevVSugarRosterMode) {
        guard mode != newMode else { return }
        mode = newMode
        earlyMorningGuide.removeAll()
        tableView.reloadData()
        refreshRosterHeader(animated: true)
        loadRoster()
    }

    @objc private func refreshRoster() { loadRoster() }

    private func loadRoster() {
        loadTask?.cancel()
        let requestedMode = mode
        statusLabel.isHidden = false
        statusLabel.text = "Loading…"
        emptyImage.isHidden = true
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result: [goldenCrumbCenter]
                switch requestedMode {
                case .glazeFollowing: result = try await repository.earlyMorningGuide(marbleFrostMotif: 3)
                case .sprinkleFollower: result = try await repository.earlyMorningGuide(marbleFrostMotif: 2)
                case .sugarShield: result = try await repository.midnightAtelier()
                }
                guard !Task.isCancelled, requestedMode == mode else { return }
                earlyMorningGuide = result
                tableView.reloadData()
                tableView.refreshControl?.endRefreshing()
                statusLabel.text = result.isEmpty ? "No users yet." : nil
                statusLabel.isHidden = !result.isEmpty
                emptyImage.isHidden = !result.isEmpty
            } catch {
                guard !Task.isCancelled else { return }
                tableView.refreshControl?.endRefreshing()
                statusLabel.text = error.localizedDescription
                statusLabel.isHidden = false
                emptyImage.isHidden = false
            }
            loadTask = nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { earlyMorningGuide.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WevVGlazeRosterCell", for: indexPath) as? WevVGlazeRosterCell else { return UITableViewCell() }
        let relation = earlyMorningGuide[indexPath.row]
        cell.bind(relation, isBlocked: mode == .sugarShield)
        cell.onAction = { [weak self, weak cell] in
            guard let self, let cell, let current = self.tableView.indexPath(for: cell) else { return }
            self.changeRelation(at: current.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard earlyMorningGuide.indices.contains(indexPath.row) else { return }
        let controller = WevVWevvTasterCardController(userID: earlyMorningGuide[indexPath.row].vanillaBeanIcing)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func changeRelation(at index: Int) {
        guard earlyMorningGuide.indices.contains(index), loadTask == nil else { return }
        let relation = earlyMorningGuide[index]
        let requestedMode = mode
        let isFollowingChange = requestedMode != .sugarShield
        if isFollowingChange {
            earlyMorningGuide[index] = goldenCrumbCenter(
                vanillaBeanIcing: relation.vanillaBeanIcing,
                gingerHoneyDrizzle: relation.gingerHoneyDrizzle,
                cheesecakeMousse: relation.cheesecakeMousse,
                flakyLayer: !relation.flakyLayer,
                crispEdgeCrust: relation.crispEdgeCrust,
                springyFinish: relation.springyFinish
            )
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                if requestedMode == .sugarShield {
                    try await repository.gardenLaneStudio(vanillaBeanIcing: relation.vanillaBeanIcing, harvestPearPalette: false, springyFinish: relation.springyFinish)
                } else {
                    try await repository.riversideBakery(vanillaBeanIcing: relation.vanillaBeanIcing, autumnPecanCollection: !relation.flakyLayer)
                }
                loadTask = nil
                onRosterChanged?()
                loadRoster()
            } catch {
                loadTask = nil
                if isFollowingChange, self.earlyMorningGuide.indices.contains(index) {
                    self.earlyMorningGuide[index] = relation
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    @objc private func closeRoster() { dismiss(animated: true) }
}

private final class WevVGlazeRosterCell: UITableViewCell {
    var onAction: (() -> Void)?
    private let avatar = UIImageView()
    private let name = UILabel()
    private let presence = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 21
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 14, weight: .bold)
        name.textColor = UIColor(red: 0.12, green: 0.08, blue: 0.12, alpha: 1)
        presence.translatesAutoresizingMaskIntoConstraints = false
        presence.font = .systemFont(ofSize: 10.5, weight: .regular)
        presence.textColor = UIColor(white: 0.48, alpha: 1)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        actionButton.layer.cornerRadius = 14
        actionButton.clipsToBounds = true
        actionButton.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        [avatar, name, presence, actionButton].forEach(contentView.addSubview)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 42),
            avatar.heightAnchor.constraint(equalToConstant: 42),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
            actionButton.heightAnchor.constraint(equalToConstant: 28),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 11),
            name.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -18),
            name.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -9),
            presence.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            presence.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            presence.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -9)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func bind(_ relation: goldenCrumbCenter, isBlocked: Bool) {
        name.text = relation.gingerHoneyDrizzle
        presence.text = relation.crispEdgeCrust ? "Online" : "Offline"
        actionButton.setTitle(isBlocked ? "Remove" : (relation.flakyLayer ? "Following" : "Follow"), for: .normal)
        let quiet = isBlocked || relation.flakyLayer
        actionButton.backgroundColor = quiet ? UIColor(red: 0.18, green: 0.17, blue: 0.19, alpha: 1) : UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1)
        actionButton.setTitleColor(.white, for: .normal)
        avatar.image = UIImage(systemName: "person.crop.circle.fill")
        avatar.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let text = relation.cheesecakeMousse, let url = URL(string: text) else { return }
        avatar.accessibilityIdentifier = text
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if self?.avatar.accessibilityIdentifier == text { self?.avatar.image = image } }
        }.resume()
    }

    @objc private func tapAction() { onAction?() }
}

final class WevVGlazeFavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let statusLabel = UILabel()
    private let emptyImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
    private var starchGelatinizationStudy: [butteryTexture] = []
    private var loadTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildFavoritePage()
        loadFavorites()
    }

    deinit { loadTask?.cancel() }

    private func buildFavoritePage() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(closeFavorites), for: .touchUpInside)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Saved Posts"
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textAlignment = .center

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 20, right: 0)
        tableView.register(WevVGlazeFavoriteCell.self, forCellReuseIdentifier: "WevVGlazeFavoriteCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)

        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.contentMode = .scaleAspectFit
        emptyImage.isHidden = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Loading saved posts…"
        statusLabel.textColor = UIColor(white: 0.48, alpha: 1)
        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        [backdrop, back, title, tableView, emptyImage, statusLabel].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -54),
            tableView.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -34),
            emptyImage.widthAnchor.constraint(equalToConstant: 110),
            emptyImage.heightAnchor.constraint(equalToConstant: 110),
            statusLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func refreshFavorites() { loadFavorites() }

    private func loadFavorites() {
        loadTask?.cancel()
        statusLabel.isHidden = false
        statusLabel.text = "Loading saved posts…"
        emptyImage.isHidden = true
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await WevVGlazeSocialRepository.pastryTrailDiary.familyOwnedCounter()
                guard !Task.isCancelled else { return }
                starchGelatinizationStudy = result
                tableView.reloadData()
                tableView.refreshControl?.endRefreshing()
                statusLabel.text = result.isEmpty ? "No saved posts yet." : nil
                statusLabel.isHidden = !result.isEmpty
                emptyImage.isHidden = !result.isEmpty
            } catch {
                guard !Task.isCancelled else { return }
                tableView.refreshControl?.endRefreshing()
                statusLabel.text = error.localizedDescription
                statusLabel.isHidden = false
                emptyImage.isHidden = false
            }
            loadTask = nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { starchGelatinizationStudy.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WevVGlazeFavoriteCell", for: indexPath) as? WevVGlazeFavoriteCell else { return UITableViewCell() }
        cell.bind(starchGelatinizationStudy[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = WevVWevvDonutMomentController(richCocoaFlavor: starchGelatinizationStudy[indexPath.row])
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func closeFavorites() { dismiss(animated: true) }
}

private final class WevVGlazeFavoriteCell: UITableViewCell {
    private let card = UIView()
    private let cover = UIImageView()
    private let name = UILabel()
    private let caption = UILabel()
    private let activity = UILabel()
    private let time = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.clipsToBounds = true
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 14, weight: .bold)
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.font = .systemFont(ofSize: 11, weight: .regular)
        caption.textColor = UIColor(white: 0.43, alpha: 1)
        caption.numberOfLines = 2
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.font = .systemFont(ofSize: 10.5, weight: .semibold)
        activity.textColor = UIColor(red: 1, green: 0.23, blue: 0.6, alpha: 1)
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = .systemFont(ofSize: 9.5, weight: .regular)
        time.textColor = UIColor(white: 0.58, alpha: 1)
        contentView.addSubview(card)
        [cover, name, caption, activity, time].forEach(card.addSubview)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),
            cover.widthAnchor.constraint(equalToConstant: 88),
            name.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 11),
            name.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            name.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
            caption.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            caption.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            caption.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            activity.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            activity.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -13),
            time.leadingAnchor.constraint(greaterThanOrEqualTo: activity.trailingAnchor, constant: 8),
            time.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -11),
            time.centerYAnchor.constraint(equalTo: activity.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func bind(_ moment: butteryTexture) {
        name.text = moment.gingerHoneyDrizzle
        caption.text = moment.caramelCurd.isEmpty ? "Photo moment" : moment.caramelCurd
        activity.text = "♥ \(moment.limeCream)    Comments \(moment.apricotCenter)"
        time.text = moment.figCustard
        cover.image = UIImage(systemName: "photo.fill")
        cover.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let text = moment.passionfruitFilling.first, let url = URL(string: text) else { return }
        cover.accessibilityIdentifier = text
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if self?.cover.accessibilityIdentifier == text { self?.cover.image = image } }
        }.resume()
    }
}
