import UIKit

enum WevVBakeryExchange {
    static func spin(
        in frostingView: UIView,
        note: String,
        delay: TimeInterval = 0.58,
        completion: @escaping () -> Void = {}
    ) {
        let glazeLayer = UIControl()
        glazeLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeLayer.backgroundColor = UIColor(red: 0.12, green: 0.05, blue: 0.11, alpha: 0.34)
        glazeLayer.alpha = 0

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.99, alpha: 0.98)
        pastryCard.layer.cornerRadius = 22
        pastryCard.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.22
        pastryCard.layer.shadowRadius = 20
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 10)

        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
        spinner.startAnimating()

        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = note
        crumbLabel.textAlignment = .center
        crumbLabel.textColor = UIColor(red: 0.16, green: 0.09, blue: 0.2, alpha: 1)
        crumbLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        crumbLabel.numberOfLines = 2
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.76

        frostingView.addSubview(glazeLayer)
        glazeLayer.addSubview(pastryCard)
        pastryCard.addSubview(spinner)
        pastryCard.addSubview(crumbLabel)
        pinExchangeLayer(glazeLayer, pastryCard: pastryCard, spinner: spinner, crumbLabel: crumbLabel, frostingView: frostingView)

        UIView.animate(withDuration: 0.16) {
            glazeLayer.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.16, animations: {
                glazeLayer.alpha = 0
                pastryCard.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion: { _ in
                glazeLayer.removeFromSuperview()
                completion()
            })
        }
    }

    private static func pinExchangeLayer(_ glazeLayer: UIView, pastryCard: UIView, spinner: UIActivityIndicatorView, crumbLabel: UILabel, frostingView: UIView) {
        NSLayoutConstraint.activate([
            glazeLayer.topAnchor.constraint(equalTo: frostingView.topAnchor),
            glazeLayer.leadingAnchor.constraint(equalTo: frostingView.leadingAnchor),
            glazeLayer.trailingAnchor.constraint(equalTo: frostingView.trailingAnchor),
            glazeLayer.bottomAnchor.constraint(equalTo: frostingView.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: glazeLayer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: glazeLayer.centerYAnchor, constant: -10),
            pastryCard.widthAnchor.constraint(equalTo: glazeLayer.widthAnchor, multiplier: 0.66),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 270),
            spinner.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            spinner.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            crumbLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 14),
            crumbLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            crumbLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            crumbLabel.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -22)
        ])
    }
}
