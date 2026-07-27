import UIKit

final class WevVGlazePillButton: UIControl {
    private let titleLabel = UILabel()
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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.72
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
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
        titleLabel.text = title
    }

    private func refreshGlazeColors() {
        glazeLayer.colors = isEnabled ? activeColors : quietColors
    }
}
