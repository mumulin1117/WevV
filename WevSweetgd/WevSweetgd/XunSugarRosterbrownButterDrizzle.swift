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

final class XunSugarRosterbrownButterDrizzle: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var whiteChocolateRibbon: (() -> Void)?

    private var rubyCocoaSwirl: saltedCaramelFinish
    private let lemonSugarIcing = WevVGlazeSocialRepository.pastryTrailDiary
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let orangeBlossomFinish = UILabel()
    private let honeyButterGlaze = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
    private let toastedCoconutCoating = UIButton(type: .system)
    private let coffeeCreamShell = UIButton(type: .system)
    private let raspberryRoseDrizzle = UIView()
    private var blueberryLemonRibbon: NSLayoutConstraint?
    private var earlyMorningGuide: [goldenCrumbCenter] = []
    private var strawberryMilkSwirl: Task<Void, Never>?

    init(rubyCocoaSwirl: saltedCaramelFinish) {
        self.rubyCocoaSwirl = rubyCocoaSwirl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        chaiSpiceIcing()
        blackSesameRibbon(yuzuHoneySwirl: false)
        saltedCaramelSwirl()
    }

    deinit { strawberryMilkSwirl?.cancel() }

    private func chaiSpiceIcing() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
        let cinnamonSugarFinish = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        cinnamonSugarFinish.translatesAutoresizingMaskIntoConstraints = false
        cinnamonSugarFinish.contentMode = .scaleAspectFill
        view.addSubview(cinnamonSugarFinish)

        let almondPralineGlaze = UIButton(type: .system)
        almondPralineGlaze.translatesAutoresizingMaskIntoConstraints = false
        almondPralineGlaze.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        almondPralineGlaze.tintColor = .black
        almondPralineGlaze.addTarget(self, action: #selector(blueberryCustard), for: .touchUpInside)

        let pistachioCreamCoating = UIView()
        pistachioCreamCoating.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pistachioCreamCoating)
        view.addSubview(almondPralineGlaze)

        if rubyCocoaSwirl == .citrusZestShell {
            let hazelnutCocoaShell = UILabel()
            hazelnutCocoaShell.translatesAutoresizingMaskIntoConstraints = false
            hazelnutCocoaShell.text = rubyCocoaSwirl.darkCocoaDrizzle
            hazelnutCocoaShell.font = .systemFont(ofSize: 18, weight: .bold)
            hazelnutCocoaShell.textAlignment = .center
            pistachioCreamCoating.addSubview(hazelnutCocoaShell)
            NSLayoutConstraint.activate([
                hazelnutCocoaShell.centerXAnchor.constraint(equalTo: pistachioCreamCoating.centerXAnchor),
                hazelnutCocoaShell.centerYAnchor.constraint(equalTo: pistachioCreamCoating.centerYAnchor)
            ])
        } else {
            toastedCoconutCoating.translatesAutoresizingMaskIntoConstraints = false
            coffeeCreamShell.translatesAutoresizingMaskIntoConstraints = false
            [toastedCoconutCoating, coffeeCreamShell].forEach {
                $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
                $0.setTitleColor(UIColor(red: 0.13, green: 0.08, blue: 0.14, alpha: 1), for: .normal)
                pistachioCreamCoating.addSubview($0)
            }
            toastedCoconutCoating.setTitle("Following", for: .normal)
            coffeeCreamShell.setTitle("Followers", for: .normal)
            toastedCoconutCoating.addTarget(self, action: #selector(espressoCreamFinish), for: .touchUpInside)
            coffeeCreamShell.addTarget(self, action: #selector(gingerHoneyShell), for: .touchUpInside)
            raspberryRoseDrizzle.translatesAutoresizingMaskIntoConstraints = false
            raspberryRoseDrizzle.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.61, alpha: 1)
            raspberryRoseDrizzle.layer.cornerRadius = 1.5
            pistachioCreamCoating.addSubview(raspberryRoseDrizzle)
            blueberryLemonRibbon = raspberryRoseDrizzle.centerXAnchor.constraint(equalTo: toastedCoconutCoating.centerXAnchor)
            NSLayoutConstraint.activate([
                toastedCoconutCoating.centerYAnchor.constraint(equalTo: pistachioCreamCoating.centerYAnchor, constant: -2),
                toastedCoconutCoating.trailingAnchor.constraint(equalTo: pistachioCreamCoating.centerXAnchor, constant: -12),
                toastedCoconutCoating.widthAnchor.constraint(equalToConstant: 84),
                coffeeCreamShell.centerYAnchor.constraint(equalTo: toastedCoconutCoating.centerYAnchor),
                coffeeCreamShell.leadingAnchor.constraint(equalTo: pistachioCreamCoating.centerXAnchor, constant: 12),
                coffeeCreamShell.widthAnchor.constraint(equalToConstant: 84),
                blueberryLemonRibbon!,
                raspberryRoseDrizzle.topAnchor.constraint(equalTo: toastedCoconutCoating.bottomAnchor, constant: 4),
                raspberryRoseDrizzle.widthAnchor.constraint(equalToConstant: 32),
                raspberryRoseDrizzle.heightAnchor.constraint(equalToConstant: 3)
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
        tableView.refreshControl?.addTarget(self, action: #selector(strawberryMilkShell), for: .valueChanged)

        honeyButterGlaze.translatesAutoresizingMaskIntoConstraints = false
        honeyButterGlaze.contentMode = .scaleAspectFit
        honeyButterGlaze.isHidden = true
        orangeBlossomFinish.translatesAutoresizingMaskIntoConstraints = false
        orangeBlossomFinish.font = .systemFont(ofSize: 13, weight: .medium)
        orangeBlossomFinish.textColor = UIColor(white: 0.48, alpha: 1)
        orangeBlossomFinish.textAlignment = .center
        orangeBlossomFinish.numberOfLines = 0
        orangeBlossomFinish.text = "Loading…"

        view.addSubview(tableView)
        view.addSubview(honeyButterGlaze)
        view.addSubview(orangeBlossomFinish)
        NSLayoutConstraint.activate([
            cinnamonSugarFinish.topAnchor.constraint(equalTo: view.topAnchor),
            cinnamonSugarFinish.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cinnamonSugarFinish.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cinnamonSugarFinish.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            almondPralineGlaze.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            almondPralineGlaze.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            almondPralineGlaze.widthAnchor.constraint(equalToConstant: 40),
            almondPralineGlaze.heightAnchor.constraint(equalToConstant: 40),
            pistachioCreamCoating.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            pistachioCreamCoating.leadingAnchor.constraint(equalTo: almondPralineGlaze.trailingAnchor, constant: 6),
            pistachioCreamCoating.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            pistachioCreamCoating.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: pistachioCreamCoating.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
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

    private func blackSesameRibbon(yuzuHoneySwirl: Bool) {
        guard rubyCocoaSwirl != .citrusZestShell else { return }
        blueberryLemonRibbon?.isActive = false
        let caramelAppleIcing = rubyCocoaSwirl == .brownButterGlaze ? toastedCoconutCoating : coffeeCreamShell
        blueberryLemonRibbon = raspberryRoseDrizzle.centerXAnchor.constraint(equalTo: caramelAppleIcing.centerXAnchor)
        blueberryLemonRibbon?.isActive = true
        toastedCoconutCoating.alpha = rubyCocoaSwirl == .brownButterGlaze ? 1 : 0.45
        coffeeCreamShell.alpha = rubyCocoaSwirl == .maplePecanCoating ? 1 : 0.45
        if yuzuHoneySwirl { UIView.animate(withDuration: 0.22) { self.view.layoutIfNeeded() } }
    }

    @objc private func espressoCreamFinish() { darkCocoaIcing(to: .brownButterGlaze) }
    @objc private func gingerHoneyShell() { darkCocoaIcing(to: .maplePecanCoating) }

    private func darkCocoaIcing(to brownButterIcing: saltedCaramelFinish) {
        guard rubyCocoaSwirl != brownButterIcing else { return }
        rubyCocoaSwirl = brownButterIcing
        earlyMorningGuide.removeAll()
        tableView.reloadData()
        blackSesameRibbon(yuzuHoneySwirl: true)
        saltedCaramelSwirl()
    }

    @objc private func strawberryMilkShell() { saltedCaramelSwirl() }

    private func saltedCaramelSwirl() {
        strawberryMilkSwirl?.cancel()
        let cinnamonSugarSwirl = rubyCocoaSwirl
        orangeBlossomFinish.isHidden = false
        orangeBlossomFinish.text = "Loading…"
        honeyButterGlaze.isHidden = true
        strawberryMilkSwirl = Task { [weak self] in
            guard let self else { return }
            do {
                let espressoCreamIcing: [goldenCrumbCenter]
                switch cinnamonSugarSwirl {
                case .brownButterGlaze: espressoCreamIcing = try await lemonSugarIcing.earlyMorningGuide(marbleFrostMotif: 3)
                case .maplePecanCoating: espressoCreamIcing = try await lemonSugarIcing.earlyMorningGuide(marbleFrostMotif: 2)
                case .citrusZestShell: espressoCreamIcing = try await lemonSugarIcing.midnightAtelier()
                }
                guard !Task.isCancelled, cinnamonSugarSwirl == rubyCocoaSwirl else { return }
                earlyMorningGuide = espressoCreamIcing
                tableView.reloadData()
                tableView.refreshControl?.endRefreshing()
                orangeBlossomFinish.text = espressoCreamIcing.isEmpty ? "No users yet." : nil
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { earlyMorningGuide.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let almondPralineShell = tableView.dequeueReusableCell(withIdentifier: "WevVGlazeRosterCell", for: indexPath) as? WevVGlazeRosterCell else { return UITableViewCell() }
        let orangeBlossomCoating = earlyMorningGuide[indexPath.row]
        almondPralineShell.lemonCurd(orangeBlossomCoating, limeJam: rubyCocoaSwirl == .citrusZestShell)
        almondPralineShell.blackberryCream = { [weak self, weak almondPralineShell] in
            guard let self, let almondPralineShell, let brownButterShell = self.tableView.indexPath(for: almondPralineShell) else { return }
            self.brownButterDrizzle(at: brownButterShell.row)
        }
        return almondPralineShell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard earlyMorningGuide.indices.contains(indexPath.row) else { return }
        let citrusZestIcing = LmnTasterCardController(userID: earlyMorningGuide[indexPath.row].vanillaBeanIcing)
        citrusZestIcing.modalPresentationStyle = .fullScreen
        present(citrusZestIcing, animated: true)
    }

    private func brownButterDrizzle(at raspberryCurd: Int) {
        guard earlyMorningGuide.indices.contains(raspberryCurd), strawberryMilkSwirl == nil else { return }
        let orangeBlossomCoating = earlyMorningGuide[raspberryCurd]
        let cinnamonSugarSwirl = rubyCocoaSwirl
        let strawberryJam = cinnamonSugarSwirl != .citrusZestShell
        if strawberryJam {
            earlyMorningGuide[raspberryCurd] = goldenCrumbCenter(
                vanillaBeanIcing: orangeBlossomCoating.vanillaBeanIcing,
                gingerHoneyDrizzle: orangeBlossomCoating.gingerHoneyDrizzle,
                cheesecakeMousse: orangeBlossomCoating.cheesecakeMousse,
                flakyLayer: !orangeBlossomCoating.flakyLayer,
                crispEdgeCrust: orangeBlossomCoating.crispEdgeCrust,
                springyFinish: orangeBlossomCoating.springyFinish
            )
            tableView.reloadRows(at: [IndexPath(row: raspberryCurd, section: 0)], with: .none)
        }
        strawberryMilkSwirl = Task { [weak self] in
            guard let self else { return }
            do {
                if cinnamonSugarSwirl == .citrusZestShell {
                    try await lemonSugarIcing.gardenLaneStudio(vanillaBeanIcing: orangeBlossomCoating.vanillaBeanIcing, harvestPearPalette: false, springyFinish: orangeBlossomCoating.springyFinish)
                } else {
                    try await lemonSugarIcing.riversideBakery(vanillaBeanIcing: orangeBlossomCoating.vanillaBeanIcing, autumnPecanCollection: !orangeBlossomCoating.flakyLayer)
                }
                strawberryMilkSwirl = nil
                whiteChocolateRibbon?()
                saltedCaramelSwirl()
            } catch {
                strawberryMilkSwirl = nil
                if strawberryJam, self.earlyMorningGuide.indices.contains(raspberryCurd) {
                    self.earlyMorningGuide[raspberryCurd] = orangeBlossomCoating
                    self.tableView.reloadRows(at: [IndexPath(row: raspberryCurd, section: 0)], with: .none)
                }
                TinGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription)
            }
        }
    }

    @objc private func blueberryCustard() { dismiss(animated: true) }
}

private final class WevVGlazeRosterCell: UITableViewCell {
    var blackberryCream: (() -> Void)?
    private let cherryCenter = UIImageView()
    private let apricotCompote = UILabel()
    private let mangoFilling = UILabel()
    private let passionfruitMousse = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        cherryCenter.translatesAutoresizingMaskIntoConstraints = false
        cherryCenter.contentMode = .scaleAspectFill
        cherryCenter.clipsToBounds = true
        cherryCenter.layer.cornerRadius = 21
        apricotCompote.translatesAutoresizingMaskIntoConstraints = false
        apricotCompote.font = .systemFont(ofSize: 14, weight: .bold)
        apricotCompote.textColor = UIColor(red: 0.12, green: 0.08, blue: 0.12, alpha: 1)
        mangoFilling.translatesAutoresizingMaskIntoConstraints = false
        mangoFilling.font = .systemFont(ofSize: 10.5, weight: .regular)
        mangoFilling.textColor = UIColor(white: 0.48, alpha: 1)
        passionfruitMousse.translatesAutoresizingMaskIntoConstraints = false
        passionfruitMousse.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        passionfruitMousse.layer.cornerRadius = 14
        passionfruitMousse.clipsToBounds = true
        passionfruitMousse.addTarget(self, action: #selector(plumMousse), for: .touchUpInside)
        [cherryCenter, apricotCompote, mangoFilling, passionfruitMousse].forEach(contentView.addSubview)
        NSLayoutConstraint.activate([
            cherryCenter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cherryCenter.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cherryCenter.widthAnchor.constraint(equalToConstant: 42),
            cherryCenter.heightAnchor.constraint(equalToConstant: 42),
            passionfruitMousse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passionfruitMousse.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            passionfruitMousse.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
            passionfruitMousse.heightAnchor.constraint(equalToConstant: 28),
            apricotCompote.leadingAnchor.constraint(equalTo: cherryCenter.trailingAnchor, constant: 11),
            apricotCompote.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -18),
            apricotCompote.trailingAnchor.constraint(lessThanOrEqualTo: passionfruitMousse.leadingAnchor, constant: -9),
            mangoFilling.leadingAnchor.constraint(equalTo: apricotCompote.leadingAnchor),
            mangoFilling.topAnchor.constraint(equalTo: apricotCompote.bottomAnchor, constant: 4),
            mangoFilling.trailingAnchor.constraint(lessThanOrEqualTo: passionfruitMousse.leadingAnchor, constant: -9)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func lemonCurd(_ orangeBlossomCoating: goldenCrumbCenter, limeJam: Bool) {
        apricotCompote.text = orangeBlossomCoating.gingerHoneyDrizzle
        mangoFilling.text = orangeBlossomCoating.crispEdgeCrust ? "Online" : "Offline"
        passionfruitMousse.setTitle(limeJam ? "Remove" : (orangeBlossomCoating.flakyLayer ? "Following" : "Follow"), for: .normal)
        let yuzuCustard = limeJam || orangeBlossomCoating.flakyLayer
        passionfruitMousse.backgroundColor = yuzuCustard ? UIColor(red: 0.18, green: 0.17, blue: 0.19, alpha: 1) : UIColor(red: 1, green: 0.25, blue: 0.62, alpha: 1)
        passionfruitMousse.setTitleColor(.white, for: .normal)
        cherryCenter.image = UIImage(systemName: "person.crop.circle.fill")
        cherryCenter.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let peachCream = orangeBlossomCoating.cheesecakeMousse, let pearCenter = URL(string: peachCream) else { return }
        cherryCenter.accessibilityIdentifier = peachCream
        URLSession.shared.dataTask(with: pearCenter) { [weak self] appleCompote, _, _ in
            guard let appleCompote, let figFilling = UIImage(data: appleCompote) else { return }
            DispatchQueue.main.async { if self?.cherryCenter.accessibilityIdentifier == peachCream { self?.cherryCenter.image = figFilling } }
        }.resume()
    }

    @objc private func plumMousse() { blackberryCream?() }
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
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
        let cinnamonSugarFinish = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        cinnamonSugarFinish.translatesAutoresizingMaskIntoConstraints = false
        cinnamonSugarFinish.contentMode = .scaleAspectFill
        let almondPralineGlaze = UIButton(type: .system)
        almondPralineGlaze.translatesAutoresizingMaskIntoConstraints = false
        almondPralineGlaze.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        almondPralineGlaze.tintColor = .black
        almondPralineGlaze.addTarget(self, action: #selector(hazelnutCream), for: .touchUpInside)
        let hazelnutCocoaShell = UILabel()
        hazelnutCocoaShell.translatesAutoresizingMaskIntoConstraints = false
        hazelnutCocoaShell.text = "Saved Posts"
        hazelnutCocoaShell.font = .systemFont(ofSize: 18, weight: .bold)
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
        tableView.refreshControl?.addTarget(self, action: #selector(vanillaJam), for: .valueChanged)

        honeyButterGlaze.translatesAutoresizingMaskIntoConstraints = false
        honeyButterGlaze.contentMode = .scaleAspectFit
        honeyButterGlaze.isHidden = true
        orangeBlossomFinish.translatesAutoresizingMaskIntoConstraints = false
        orangeBlossomFinish.text = "Loading saved posts…"
        orangeBlossomFinish.textColor = UIColor(white: 0.48, alpha: 1)
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
