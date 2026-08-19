import UIKit

final class WevVWevvMaplePillButton: UIControl {
    private let wevvMapleTitleLabel = UILabel()
    private let wevvMapleLayer = CAGradientLayer()
    private var wevvActiveGlazeColors: [CGColor] = [
        UIColor(red: 1.0, green: 0.24, blue: 0.66, alpha: 1).cgColor,
        UIColor(red: 0.76, green: 0.22, blue: 0.94, alpha: 1).cgColor
    ]
    private var wevvQuietCrumbColors: [CGColor] = [
        UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1).cgColor,
        UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1).cgColor
    ]

    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.insertSublayer(wevvMapleLayer, at: 0)
        layer.cornerRadius = 14
        layer.masksToBounds = true

        wevvMapleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wevvMapleTitleLabel.text = title
        wevvMapleTitleLabel.textColor = .white
        wevvMapleTitleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        wevvMapleTitleLabel.textAlignment = .center
        wevvMapleTitleLabel.adjustsFontSizeToFitWidth = true
        wevvMapleTitleLabel.minimumScaleFactor = 0.72
        addSubview(wevvMapleTitleLabel)

        NSLayoutConstraint.activate([
            wevvMapleTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            wevvMapleTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            wevvMapleTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            wevvMapleTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
        refreshWevvMapleColors()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.95
            refreshWevvMapleColors()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wevvMapleLayer.frame = bounds
        wevvMapleLayer.cornerRadius = layer.cornerRadius
        wevvMapleLayer.startPoint = CGPoint(x: 0, y: 0.5)
        wevvMapleLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    func oldFashionedParlor(_ title: String) {
        wevvMapleTitleLabel.text = title
    }

    private func refreshWevvMapleColors() {
        wevvMapleLayer.colors = isEnabled ? wevvActiveGlazeColors : wevvQuietCrumbColors
    }
}
