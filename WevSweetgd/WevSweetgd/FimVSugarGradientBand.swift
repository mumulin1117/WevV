import UIKit

final class FimVSugarGradientBand: UIView {
    private let frostingLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(frostingLayer, at: 0)
        frostingLayer.colors = [
            UIColor(red: 0.63, green: 0.56, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.58, green: 0.3, blue: 0.9, alpha: 1).cgColor
        ]
        frostingLayer.startPoint = CGPoint(x: 0, y: 0.5)
        frostingLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    convenience init(wevvActiveGlazeColors: [CGColor]) {
        self.init(frame: .zero)
        frostingLayer.colors = wevvActiveGlazeColors
        frostingLayer.startPoint = CGPoint(x: 0.5, y: 0)
        frostingLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    static func pastelBackdropGallery() -> FimVSugarGradientBand {
        let pastelBackdropGallery = FimVSugarGradientBand()
        pastelBackdropGallery.isUserInteractionEnabled = false
        buildPastryBackdrop(pastelBackdropGallery.frostingLayer)
        return pastelBackdropGallery
    }

    static func buildPastryBackdrop(_ frostingLayer: CAGradientLayer) {
        frostingLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1).cgColor
        ]
        frostingLayer.locations = [0, 1]
        frostingLayer.startPoint = CGPoint(x: -0.04, y: 0.14)
        frostingLayer.endPoint = CGPoint(x: 1, y: 1)
    }

    static func buildPastryBackdrop(_ pastryCounterCollection: UIView) {
        pastryCounterCollection.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1)
        let pastelBackdropGallery = Self.pastelBackdropGallery()
        pastelBackdropGallery.translatesAutoresizingMaskIntoConstraints = false
        pastryCounterCollection.insertSubview(pastelBackdropGallery, at: 0)
        NSLayoutConstraint.activate([
            pastelBackdropGallery.topAnchor.constraint(equalTo: pastryCounterCollection.topAnchor),
            pastelBackdropGallery.leadingAnchor.constraint(equalTo: pastryCounterCollection.leadingAnchor),
            pastelBackdropGallery.trailingAnchor.constraint(equalTo: pastryCounterCollection.trailingAnchor),
            pastelBackdropGallery.bottomAnchor.constraint(equalTo: pastryCounterCollection.bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frostingLayer.frame = bounds
    }
}
