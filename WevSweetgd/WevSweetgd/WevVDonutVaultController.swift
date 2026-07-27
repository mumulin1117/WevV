import UIKit

final class WevVDonutVaultController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let goldLabel = UILabel()
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()

    var onVaultChanged: (() -> Void)?

    private let glazePacks: [(amount: Int, mark: String)] = [
        (400, "0.99$"),
        (800, "1.99$"),
        (1900, "3.99$"),
        (2450, "4.99$"),
        (3950, "6.99$"),
        (4900, "9.99$"),
        (8400, "17.99$"),
        (9800, "19.99$"),
        (24500, "49.99$"),
        (49000, "99.99$")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        buildVaultBackdrop()
        buildVaultScroll()
        buildVaultContent()
        refreshVaultHeader()
    }

    private func buildVaultBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.82, blue: 0.9, alpha: 1)
        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        backdrop.alpha = 0.5
        view.addSubview(backdrop)
        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildVaultScroll() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.showsVerticalScrollIndicator = false
        view.addSubview(frostingScroll)

        sprinkleContent.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.addSubview(sprinkleContent)

        NSLayoutConstraint.activate([
            frostingScroll.topAnchor.constraint(equalTo: view.topAnchor),
            frostingScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sprinkleContent.topAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.topAnchor),
            sprinkleContent.leadingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.leadingAnchor),
            sprinkleContent.trailingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.trailingAnchor),
            sprinkleContent.bottomAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.bottomAnchor),
            sprinkleContent.widthAnchor.constraint(equalTo: frostingScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildVaultContent() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeVault), for: .touchUpInside)

        let title = makeVaultLabel("My wallet", size: 27, weight: .heavy, color: .black)
        title.textAlignment = .center

        let hero = makeVaultHero()
        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        tray.layer.cornerRadius = 26

        let grid = UIStackView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 14
        for rowIndex in stride(from: 0, to: glazePacks.count, by: 3) {
            let row = UIStackView()
            row.translatesAutoresizingMaskIntoConstraints = false
            row.axis = .horizontal
            row.spacing = 12
            row.distribution = .fillEqually
            for packIndex in rowIndex..<min(rowIndex + 3, glazePacks.count) {
                row.addArrangedSubview(makePackCard(index: packIndex))
            }
            if row.arrangedSubviews.count < 3 {
                for _ in row.arrangedSubviews.count..<3 {
                    let spacer = UIView()
                    spacer.translatesAutoresizingMaskIntoConstraints = false
                    row.addArrangedSubview(spacer)
                }
            }
            grid.addArrangedSubview(row)
        }

        sprinkleContent.addSubview(backButton)
        sprinkleContent.addSubview(title)
        sprinkleContent.addSubview(hero)
        sprinkleContent.addSubview(tray)
        tray.addSubview(grid)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 36),
            backButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 38),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: sprinkleContent.centerXAnchor),
            hero.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 54),
            hero.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 12),
            hero.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -12),
            hero.heightAnchor.constraint(equalToConstant: 284),
            tray.topAnchor.constraint(equalTo: hero.topAnchor, constant: 206),
            tray.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 16),
            tray.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -16),
            tray.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor, constant: -32),
            grid.topAnchor.constraint(equalTo: tray.topAnchor, constant: 36),
            grid.leadingAnchor.constraint(equalTo: tray.leadingAnchor, constant: 16),
            grid.trailingAnchor.constraint(equalTo: tray.trailingAnchor, constant: -16),
            grid.bottomAnchor.constraint(equalTo: tray.bottomAnchor, constant: -24)
        ])
    }

    private func makeVaultHero() -> UIView {
        let hero = UIView()
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.layer.cornerRadius = 34
        hero.clipsToBounds = true
        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.87, green: 0.05, blue: 0.92, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.03, blue: 0.58, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.2)
        glaze.endPoint = CGPoint(x: 1, y: 0.8)
        hero.layer.insertSublayer(glaze, at: 0)

        let gem = UIImageView(image: UIImage(named: "oldgem"))
        gem.translatesAutoresizingMaskIntoConstraints = false
        gem.contentMode = .scaleAspectFit
        goldLabel.translatesAutoresizingMaskIntoConstraints = false
        goldLabel.font = .systemFont(ofSize: 44, weight: .heavy)
        goldLabel.textColor = .white
        goldLabel.textAlignment = .center
        let caption = makeVaultLabel("My golden gems", size: 19, weight: .medium, color: .white)
        caption.textAlignment = .center

        hero.addSubview(gem)
        hero.addSubview(goldLabel)
        hero.addSubview(caption)

        NSLayoutConstraint.activate([
            gem.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 22),
            gem.topAnchor.constraint(equalTo: hero.topAnchor, constant: 10),
            gem.widthAnchor.constraint(equalToConstant: 132),
            gem.heightAnchor.constraint(equalToConstant: 132),
            goldLabel.centerYAnchor.constraint(equalTo: gem.centerYAnchor, constant: 4),
            goldLabel.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 10),
            goldLabel.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -20),
            caption.topAnchor.constraint(equalTo: goldLabel.bottomAnchor, constant: 4),
            caption.centerXAnchor.constraint(equalTo: goldLabel.centerXAnchor)
        ])
        DispatchQueue.main.async {
            glaze.frame = hero.bounds
        }
        return hero
    }

    private func makePackCard(index: Int) -> UIControl {
        let pack = glazePacks[index]
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.tag = index
        card.backgroundColor = .white
        card.layer.cornerRadius = 20
        card.layer.borderColor = UIColor(red: 1, green: 0.15, blue: 0.56, alpha: 1).cgColor
        card.layer.borderWidth = 3
        card.addTarget(self, action: #selector(addVaultGold(_:)), for: .touchUpInside)

        let gem = UIImageView(image: UIImage(named: "ervoldgem"))
        gem.translatesAutoresizingMaskIntoConstraints = false
        gem.contentMode = .scaleAspectFit
        let amount = makeVaultLabel("\(pack.amount)", size: 23, weight: .heavy, color: UIColor(red: 0.16, green: 0.24, blue: 0.04, alpha: 1))
        amount.textAlignment = .center
        let mark = makeVaultLabel(pack.mark, size: 18, weight: .heavy, color: UIColor(red: 0.16, green: 0.24, blue: 0.04, alpha: 1))
        mark.textAlignment = .center
        let action = makeVaultLabel("Recharge", size: 16, weight: .heavy, color: .white)
        action.textAlignment = .center
        action.backgroundColor = UIColor(red: 1, green: 0.15, blue: 0.64, alpha: 1)
        action.layer.cornerRadius = 19
        action.clipsToBounds = true

        card.addSubview(gem)
        card.addSubview(amount)
        card.addSubview(mark)
        card.addSubview(action)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 150),
            gem.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            gem.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            gem.widthAnchor.constraint(equalToConstant: 42),
            gem.heightAnchor.constraint(equalToConstant: 42),
            amount.topAnchor.constraint(equalTo: gem.bottomAnchor, constant: 2),
            amount.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            amount.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            mark.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: 12),
            mark.leadingAnchor.constraint(equalTo: amount.leadingAnchor),
            mark.trailingAnchor.constraint(equalTo: amount.trailingAnchor),
            action.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            action.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
            action.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            action.heightAnchor.constraint(equalToConstant: 38)
        ])
        return card
    }

//    private func makeGemView(size: CGFloat) -> UIImageView {
////        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size * 0.72))
////        let image = renderer.image { _ in
////            UIColor(red: 1, green: 0.78, blue: 0.05, alpha: 1).setFill()
////            UIBezierPath(rect: CGRect(x: size * 0.22, y: size * 0.06, width: size * 0.56, height: size * 0.18)).fill()
////            UIColor(red: 1, green: 0.57, blue: 0.02, alpha: 1).setFill()
////            let body = UIBezierPath()
////            body.move(to: CGPoint(x: size * 0.1, y: size * 0.24))
////            body.addLine(to: CGPoint(x: size * 0.9, y: size * 0.24))
////            body.addLine(to: CGPoint(x: size * 0.5, y: size * 0.7))
////            body.close()
////            body.fill()
////            UIColor(red: 1, green: 0.9, blue: 0.18, alpha: 1).setFill()
////            UIBezierPath(roundedRect: CGRect(x: size * 0.15, y: size * 0.08, width: size * 0.7, height: size * 0.18), cornerRadius: 5).fill()
////        }
//        let view = UIImageView(image: UIImage(named: "oldgem"))
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFit
//        return view
//    }

    private func makeVaultLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    private func refreshVaultHeader() {
        goldLabel.text = "\(glazeSession.glazeGoldCount)"
    }

    @objc private func addVaultGold(_ sender: UIControl) {
        let pack = glazePacks[max(0, min(sender.tag, glazePacks.count - 1))]
        glazeSession.addGlazeGold(pack.amount)
        refreshVaultHeader()
        onVaultChanged?()
    }

    @objc private func closeVault() {
        dismiss(animated: true)
    }
}
