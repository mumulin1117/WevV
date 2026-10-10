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

    required init?(coder: NSCoder) {
        return nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frostingLayer.frame = bounds
    }
}
