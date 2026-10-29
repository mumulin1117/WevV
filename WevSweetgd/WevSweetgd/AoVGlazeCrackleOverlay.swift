import UIKit

enum AoVGlazeCrackleOverlay {
    static func showGlazeCrackle(
        in frostingDepthView: UIView,
        note: String,
        delay: TimeInterval = 0.58,
        completion: @escaping () -> Void = {}
    ) {
        let glazeCrackleLayer = UIControl()
        glazeCrackleLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeCrackleLayer.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        glazeCrackleLayer.alpha = 0

        let treatCaseCard = UIView()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.backgroundColor = TinGlazePromptStyler.creamTone.withAlphaComponent(0.98)
        treatCaseCard.layer.cornerRadius = 20
        treatCaseCard.layer.borderWidth = 1
        treatCaseCard.layer.borderColor = TinGlazePromptStyler.softPinkTone.cgColor
        treatCaseCard.layer.shadowColor = UIColor.black.cgColor
        treatCaseCard.layer.shadowOpacity = 0.22
        treatCaseCard.layer.shadowRadius = 20
        treatCaseCard.layer.shadowOffset = CGSize(width: 0, height: 10)

        let glazeSpinner = UIActivityIndicatorView(style: .medium)
        glazeSpinner.translatesAutoresizingMaskIntoConstraints = false
        glazeSpinner.color = TinGlazePromptStyler.strawberryGlazeTone
        glazeSpinner.startAnimating()

        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = note
        sugarDustLabel.textAlignment = .center
        sugarDustLabel.textColor = TinGlazePromptStyler.inkTone
        sugarDustLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sugarDustLabel.numberOfLines = 2
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.76

        frostingDepthView.addSubview(glazeCrackleLayer)
        glazeCrackleLayer.addSubview(treatCaseCard)
        treatCaseCard.addSubview(glazeSpinner)
        treatCaseCard.addSubview(sugarDustLabel)
        pinGlazeCrackleLayer(glazeCrackleLayer, treatCaseCard: treatCaseCard, glazeSpinner: glazeSpinner, sugarDustLabel: sugarDustLabel, frostingDepthView: frostingDepthView)

        UIView.animate(withDuration: 0.16) {
            glazeCrackleLayer.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.16, animations: {
                glazeCrackleLayer.alpha = 0
                treatCaseCard.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion: { _ in
                glazeCrackleLayer.removeFromSuperview()
                completion()
            })
        }
    }

    private static func pinGlazeCrackleLayer(_ glazeCrackleLayer: UIView, treatCaseCard: UIView, glazeSpinner: UIActivityIndicatorView, sugarDustLabel: UILabel, frostingDepthView: UIView) {
        NSLayoutConstraint.activate([
            glazeCrackleLayer.topAnchor.constraint(equalTo: frostingDepthView.topAnchor),
            glazeCrackleLayer.leadingAnchor.constraint(equalTo: frostingDepthView.leadingAnchor),
            glazeCrackleLayer.trailingAnchor.constraint(equalTo: frostingDepthView.trailingAnchor),
            glazeCrackleLayer.bottomAnchor.constraint(equalTo: frostingDepthView.bottomAnchor),
            treatCaseCard.centerXAnchor.constraint(equalTo: glazeCrackleLayer.centerXAnchor),
            treatCaseCard.centerYAnchor.constraint(equalTo: glazeCrackleLayer.centerYAnchor, constant: -10),
            treatCaseCard.widthAnchor.constraint(equalTo: glazeCrackleLayer.widthAnchor, multiplier: 0.66),
            treatCaseCard.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
            glazeSpinner.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 22),
            glazeSpinner.centerXAnchor.constraint(equalTo: treatCaseCard.centerXAnchor),
            sugarDustLabel.topAnchor.constraint(equalTo: glazeSpinner.bottomAnchor, constant: 14),
            sugarDustLabel.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 22),
            sugarDustLabel.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -22),
            sugarDustLabel.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor, constant: -22)
        ])
    }
}
