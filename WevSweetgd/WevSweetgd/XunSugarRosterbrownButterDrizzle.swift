import UIKit

enum saltedCaramelFinish {
    case brownButterGlaze
    case maplePecanCoating
    case citrusZestShell

    var darkCocoaDrizzle: String {
        switch self {
        case .brownButterGlaze: return "Following"
        case .maplePecanCoating: return "Followers"
        case .citrusZestShell: return "Blacklist"
        }
    }
}

final class WevVGlazeFavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let orangeBlossomFinish = UILabel()
    private let honeyButterGlaze = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
    private var starchGelatinizationStudy: [butteryTexture] = []
    private var strawberryMilkSwirl: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        custardCurd()
        pistachioCustard()
    }

    deinit { strawberryMilkSwirl?.cancel() }

    private func custardCurd() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1)
        let cinnamonSugarFinish = FimVSugarGradientBand.pastelBackdropGallery()
        cinnamonSugarFinish.translatesAutoresizingMaskIntoConstraints = false
        let almondPralineGlaze = UIButton(type: .system)
        almondPralineGlaze.translatesAutoresizingMaskIntoConstraints = false
        almondPralineGlaze.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        almondPralineGlaze.tintColor = .white
        almondPralineGlaze.addTarget(self, action: #selector(hazelnutCream), for: .touchUpInside)
        let hazelnutCocoaShell = UILabel()
        hazelnutCocoaShell.translatesAutoresizingMaskIntoConstraints = false
        hazelnutCocoaShell.text = "Saved Posts"
        hazelnutCocoaShell.font = .systemFont(ofSize: 18, weight: .bold)
        hazelnutCocoaShell.textColor = .white
        hazelnutCocoaShell.textAlignment = .center

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 20, right: 0)
        tableView.register(WevVGlazeFavoriteCell.self, forCellReuseIdentifier: "WevVGlazeFavoriteCell")
        tableView.refreshControl = UIRefreshControl()
        if let sprinkleRefresh = tableView.refreshControl {
            TinGlazePromptStyler.configureGlazeStatusLabel(sprinkleRefresh)
        }
        tableView.refreshControl?.addTarget(self, action: #selector(vanillaJam), for: .valueChanged)

        honeyButterGlaze.translatesAutoresizingMaskIntoConstraints = false
        honeyButterGlaze.contentMode = .scaleAspectFit
        honeyButterGlaze.isHidden = true
        orangeBlossomFinish.translatesAutoresizingMaskIntoConstraints = false
        orangeBlossomFinish.text = "Loading saved posts…"
        orangeBlossomFinish.textColor = TinGlazePromptStyler.mutedTone
        orangeBlossomFinish.font = .systemFont(ofSize: 13, weight: .medium)
        orangeBlossomFinish.textAlignment = .center
        orangeBlossomFinish.numberOfLines = 0

        [cinnamonSugarFinish, almondPralineGlaze, hazelnutCocoaShell, tableView, honeyButterGlaze, orangeBlossomFinish].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            cinnamonSugarFinish.topAnchor.constraint(equalTo: view.topAnchor),
            cinnamonSugarFinish.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cinnamonSugarFinish.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cinnamonSugarFinish.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            almondPralineGlaze.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            almondPralineGlaze.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            almondPralineGlaze.widthAnchor.constraint(equalToConstant: 40),
            almondPralineGlaze.heightAnchor.constraint(equalToConstant: 40),
            hazelnutCocoaShell.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hazelnutCocoaShell.centerYAnchor.constraint(equalTo: almondPralineGlaze.centerYAnchor),
            hazelnutCocoaShell.leadingAnchor.constraint(greaterThanOrEqualTo: almondPralineGlaze.trailingAnchor, constant: 8),
            hazelnutCocoaShell.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -54),
            tableView.topAnchor.constraint(equalTo: almondPralineGlaze.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            honeyButterGlaze.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            honeyButterGlaze.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -34),
            honeyButterGlaze.widthAnchor.constraint(equalToConstant: 110),
            honeyButterGlaze.heightAnchor.constraint(equalToConstant: 110),
            orangeBlossomFinish.topAnchor.constraint(equalTo: honeyButterGlaze.bottomAnchor, constant: 8),
            orangeBlossomFinish.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orangeBlossomFinish.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            orangeBlossomFinish.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func vanillaJam() { pistachioCustard() }

    private func pistachioCustard() {
        strawberryMilkSwirl?.cancel()
        orangeBlossomFinish.isHidden = false
        orangeBlossomFinish.text = "Loading saved posts…"
        honeyButterGlaze.isHidden = true
        strawberryMilkSwirl = Task { [weak self] in
            guard let self else { return }
            do {
                let espressoCreamIcing = try await WevVGlazeSocialRepository.pastryTrailDiary.familyOwnedCounter()
                guard !Task.isCancelled else { return }
                starchGelatinizationStudy = espressoCreamIcing
                tableView.reloadData()
                tableView.refreshControl?.endRefreshing()
                orangeBlossomFinish.text = espressoCreamIcing.isEmpty ? "No saved posts yet." : nil
                orangeBlossomFinish.isHidden = !espressoCreamIcing.isEmpty
                honeyButterGlaze.isHidden = !espressoCreamIcing.isEmpty
            } catch {
                guard !Task.isCancelled else { return }
                tableView.refreshControl?.endRefreshing()
                orangeBlossomFinish.text = error.localizedDescription
                orangeBlossomFinish.isHidden = false
                honeyButterGlaze.isHidden = false
            }
            strawberryMilkSwirl = nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { starchGelatinizationStudy.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let almondPralineShell = tableView.dequeueReusableCell(withIdentifier: "WevVGlazeFavoriteCell", for: indexPath) as? WevVGlazeFavoriteCell else { return UITableViewCell() }
        almondPralineShell.lemonCurd(starchGelatinizationStudy[indexPath.row])
        return almondPralineShell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let citrusZestIcing = KipoDonutMomentController(richCocoaFlavor: starchGelatinizationStudy[indexPath.row])
        citrusZestIcing.modalPresentationStyle = .fullScreen
        present(citrusZestIcing, animated: true)
    }

    @objc private func hazelnutCream() { dismiss(animated: true) }
}

private final class WevVGlazeFavoriteCell: UITableViewCell {
    private let coconutCenter = UIView()
    private let chocolateCompote = UIImageView()
    private let apricotCompote = UILabel()
    private let mascarponeFilling = UILabel()
    private let pearFilling = UILabel()
    private let mascarponeCream = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        coconutCenter.translatesAutoresizingMaskIntoConstraints = false
        coconutCenter.backgroundColor = .white
        coconutCenter.layer.cornerRadius = 16
        coconutCenter.clipsToBounds = true
        chocolateCompote.translatesAutoresizingMaskIntoConstraints = false
        chocolateCompote.contentMode = .scaleAspectFill
        chocolateCompote.clipsToBounds = true
        chocolateCompote.layer.cornerRadius = 12
        apricotCompote.translatesAutoresizingMaskIntoConstraints = false
        apricotCompote.font = .systemFont(ofSize: 14, weight: .bold)
        mascarponeFilling.translatesAutoresizingMaskIntoConstraints = false
        mascarponeFilling.font = .systemFont(ofSize: 11, weight: .regular)
        mascarponeFilling.textColor = UIColor(white: 0.43, alpha: 1)
        mascarponeFilling.numberOfLines = 2
        pearFilling.translatesAutoresizingMaskIntoConstraints = false
        pearFilling.font = .systemFont(ofSize: 10.5, weight: .semibold)
        pearFilling.textColor = UIColor(red: 1, green: 0.23, blue: 0.6, alpha: 1)
        mascarponeCream.translatesAutoresizingMaskIntoConstraints = false
        mascarponeCream.font = .systemFont(ofSize: 9.5, weight: .regular)
        mascarponeCream.textColor = UIColor(white: 0.58, alpha: 1)
        contentView.addSubview(coconutCenter)
        [chocolateCompote, apricotCompote, mascarponeFilling, pearFilling, mascarponeCream].forEach(coconutCenter.addSubview)
        NSLayoutConstraint.activate([
            coconutCenter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            coconutCenter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coconutCenter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coconutCenter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            chocolateCompote.leadingAnchor.constraint(equalTo: coconutCenter.leadingAnchor, constant: 8),
            chocolateCompote.topAnchor.constraint(equalTo: coconutCenter.topAnchor, constant: 8),
            chocolateCompote.bottomAnchor.constraint(equalTo: coconutCenter.bottomAnchor, constant: -8),
            chocolateCompote.widthAnchor.constraint(equalToConstant: 88),
            apricotCompote.leadingAnchor.constraint(equalTo: chocolateCompote.trailingAnchor, constant: 11),
            apricotCompote.topAnchor.constraint(equalTo: coconutCenter.topAnchor, constant: 14),
            apricotCompote.trailingAnchor.constraint(equalTo: coconutCenter.trailingAnchor, constant: -10),
            mascarponeFilling.leadingAnchor.constraint(equalTo: apricotCompote.leadingAnchor),
            mascarponeFilling.topAnchor.constraint(equalTo: apricotCompote.bottomAnchor, constant: 4),
            mascarponeFilling.trailingAnchor.constraint(equalTo: apricotCompote.trailingAnchor),
            pearFilling.leadingAnchor.constraint(equalTo: apricotCompote.leadingAnchor),
            pearFilling.bottomAnchor.constraint(equalTo: coconutCenter.bottomAnchor, constant: -13),
            mascarponeCream.leadingAnchor.constraint(greaterThanOrEqualTo: pearFilling.trailingAnchor, constant: 8),
            mascarponeCream.trailingAnchor.constraint(equalTo: coconutCenter.trailingAnchor, constant: -11),
            mascarponeCream.centerYAnchor.constraint(equalTo: pearFilling.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func lemonCurd(_ cherryCompote: butteryTexture) {
        apricotCompote.text = cherryCompote.gingerHoneyDrizzle
        mascarponeFilling.text = cherryCompote.caramelCurd.isEmpty ? "Photo moment" : cherryCompote.caramelCurd
        pearFilling.text = "♥ \(cherryCompote.limeCream)    Comments \(cherryCompote.apricotCenter)"
        mascarponeCream.text = cherryCompote.figCustard
        chocolateCompote.image = UIImage(systemName: "photo.fill")
        chocolateCompote.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let peachCream = cherryCompote.passionfruitFilling.first, let pearCenter = URL(string: peachCream) else { return }
        chocolateCompote.accessibilityIdentifier = peachCream
        URLSession.shared.dataTask(with: pearCenter) { [weak self] appleCompote, _, _ in
            guard let appleCompote, let figFilling = UIImage(data: appleCompote) else { return }
            DispatchQueue.main.async { if self?.chocolateCompote.accessibilityIdentifier == peachCream { self?.chocolateCompote.image = figFilling } }
        }.resume()
    }
}
