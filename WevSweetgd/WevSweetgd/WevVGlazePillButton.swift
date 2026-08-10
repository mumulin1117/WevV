import UIKit

final class WevVGlazePillButton: UIControl {
    private let glazeTitleLabel = UILabel()
    private let glazeLayer = CAGradientLayer()
    private var activeColors: [CGColor] = [
        UIColor(red: 1.0, green: 0.24, blue: 0.66, alpha: 1).cgColor,
        UIColor(red: 0.76, green: 0.22, blue: 0.94, alpha: 1).cgColor
    ]
    private var quietColors: [CGColor] = [
        UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1).cgColor,
        UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1).cgColor
    ]

    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.insertSublayer(glazeLayer, at: 0)
        layer.cornerRadius = 14
        layer.masksToBounds = true

        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = title
        glazeTitleLabel.textColor = .white
        glazeTitleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        glazeTitleLabel.textAlignment = .center
        glazeTitleLabel.adjustsFontSizeToFitWidth = true
        glazeTitleLabel.minimumScaleFactor = 0.72
        addSubview(glazeTitleLabel)

        NSLayoutConstraint.activate([
            glazeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            glazeTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            glazeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
        refreshGlazeColors()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.95
            refreshGlazeColors()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        glazeLayer.frame = bounds
        glazeLayer.cornerRadius = layer.cornerRadius
        glazeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    func setTitle(_ title: String) {
        glazeTitleLabel.text = title
    }

    private func refreshGlazeColors() {
        glazeLayer.colors = isEnabled ? activeColors : quietColors
    }
}
