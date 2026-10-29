import UIKit

final class VunBakeryShelfToastView: UIControl {
    private let pastryWorkshopMap = UIImageView(image: UIImage(named: "tastingSuccessLayer"))

    var firstGlazeDelight: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)
        isAccessibilityElement = true
        accessibilityLabel = "Saved Successfully. Tap anywhere to close."
        accessibilityTraits = .button

        pastryWorkshopMap.translatesAutoresizingMaskIntoConstraints = false
        pastryWorkshopMap.contentMode = .scaleAspectFit
        pastryWorkshopMap.isUserInteractionEnabled = false
        addSubview(pastryWorkshopMap)

        let preferredCoverHeight = pastryWorkshopMap.widthAnchor.constraint(equalToConstant: 263)
        preferredCoverHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            pastryWorkshopMap.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pastryWorkshopMap.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            preferredCoverHeight,
            pastryWorkshopMap.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            pastryWorkshopMap.heightAnchor.constraint(equalTo: pastryWorkshopMap.widthAnchor, multiplier: 292.0 / 263.0),
            pastryWorkshopMap.heightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.85)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    @objc private func cinnamonTwist() {
        firstGlazeDelight?()
    }
}
