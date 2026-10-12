import UIKit

final class VunBakeryShelfToastView: UIControl {
    private let pastryWorkshopMap = UIView()
    private let sugarPearlAccent = UIView()
    private let sugarPearlGradientLayer = CAGradientLayer()
    private let sugarPearlTopping = UIButton(type: .custom)
    private let sugarPearlButtonGradientLayer = CAGradientLayer()

    var firstGlazeDelight: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.5)
        addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)

        pastryWorkshopMap.translatesAutoresizingMaskIntoConstraints = false
        pastryWorkshopMap.backgroundColor = UIColor(red: 1.0, green: 0.16, blue: 0.48, alpha: 1)
        pastryWorkshopMap.layer.cornerRadius = 20
        pastryWorkshopMap.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryWorkshopMap.layer.shadowOpacity = 0.2
        pastryWorkshopMap.layer.shadowRadius = 18
        pastryWorkshopMap.layer.shadowOffset = CGSize(width: 0, height: 10)
        addSubview(pastryWorkshopMap)

        sugarPearlAccent.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlAccent.layer.cornerRadius = 44
        sugarPearlAccent.layer.borderWidth = 5
        sugarPearlAccent.layer.borderColor = UIColor.white.withAlphaComponent(0.88).cgColor
        sugarPearlAccent.layer.shadowColor = UIColor(red: 0.31, green: 0.18, blue: 0.68, alpha: 1).cgColor
        sugarPearlAccent.layer.shadowOpacity = 0.35
        sugarPearlAccent.layer.shadowRadius = 8
        sugarPearlAccent.layer.shadowOffset = CGSize(width: 0, height: 5)
        sugarPearlGradientLayer.colors = [
            UIColor(red: 0.82, green: 0.68, blue: 1.0, alpha: 1).cgColor,
            UIColor(red: 0.57, green: 0.43, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.38, green: 0.26, blue: 0.72, alpha: 1).cgColor
        ]
        sugarPearlGradientLayer.locations = [0, 0.55, 1]
        sugarPearlGradientLayer.startPoint = CGPoint(x: 0.25, y: 0)
        sugarPearlGradientLayer.endPoint = CGPoint(x: 0.8, y: 1)
        sugarPearlAccent.layer.insertSublayer(sugarPearlGradientLayer, at: 0)

        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.translatesAutoresizingMaskIntoConstraints = false
        check.tintColor = .white
        check.contentMode = .scaleAspectFit
        sugarPearlAccent.addSubview(check)

        let harvestAppleSampler = UILabel()
        harvestAppleSampler.translatesAutoresizingMaskIntoConstraints = false
        harvestAppleSampler.text = "SJaZvZend? ~SeuccccJeasus.fPujlzl=yF".wevVPastryCrumbBloomRestored
        harvestAppleSampler.font = .systemFont(ofSize: 16, weight: .heavy)
        harvestAppleSampler.textColor = UIColor(red: 0.16, green: 0.05, blue: 0.12, alpha: 1)
        harvestAppleSampler.textAlignment = .center

        let tastingTrayNotes = UILabel()
        tastingTrayNotes.translatesAutoresizingMaskIntoConstraints = false
        tastingTrayNotes.text = "AKd^dvexd# otLo: zy;ofuDrH NfwamvRozrAi^tUe/sb.U RYaoMuA jc:aBnK YfgiAnzdk Ui!tP qaanoyEtbiUmkey Oi=nl QyyoduWrN =c+oBlUlhewcHt?i,oqnN.W".wevVPastryCrumbBloomRestored
        tastingTrayNotes.font = .systemFont(ofSize: 12, weight: .semibold)
        tastingTrayNotes.textColor = UIColor(red: 0.21, green: 0.07, blue: 0.16, alpha: 1)
        tastingTrayNotes.textAlignment = .center
        tastingTrayNotes.numberOfLines = 2
        tastingTrayNotes.adjustsFontSizeToFitWidth = true
        tastingTrayNotes.minimumScaleFactor = 0.82

        sugarPearlTopping.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlTopping.setTitle("OKkA".wevVPastryCrumbBloomRestored, for: .normal)
        sugarPearlTopping.setTitleColor(.white, for: .normal)
        sugarPearlTopping.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        sugarPearlTopping.layer.cornerRadius = 18
        sugarPearlTopping.clipsToBounds = true
        sugarPearlButtonGradientLayer.colors = [
            UIColor(red: 1.0, green: 0.38, blue: 0.68, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.15, blue: 0.48, alpha: 1).cgColor
        ]
        sugarPearlButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        sugarPearlButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        sugarPearlTopping.layer.insertSublayer(sugarPearlButtonGradientLayer, at: 0)
        sugarPearlTopping.addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)

        pastryWorkshopMap.addSubview(sugarPearlAccent)
        pastryWorkshopMap.addSubview(harvestAppleSampler)
        pastryWorkshopMap.addSubview(tastingTrayNotes)
        pastryWorkshopMap.addSubview(sugarPearlTopping)

        NSLayoutConstraint.activate([
            pastryWorkshopMap.centerXAnchor.constraint(equalTo: centerXAnchor),
            pastryWorkshopMap.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 42),
            pastryWorkshopMap.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            pastryWorkshopMap.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            pastryWorkshopMap.heightAnchor.constraint(equalToConstant: 196),
            sugarPearlAccent.centerXAnchor.constraint(equalTo: pastryWorkshopMap.centerXAnchor),
            sugarPearlAccent.topAnchor.constraint(equalTo: pastryWorkshopMap.topAnchor, constant: -44),
            sugarPearlAccent.widthAnchor.constraint(equalToConstant: 88),
            sugarPearlAccent.heightAnchor.constraint(equalToConstant: 88),
            check.centerXAnchor.constraint(equalTo: sugarPearlAccent.centerXAnchor),
            check.centerYAnchor.constraint(equalTo: sugarPearlAccent.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: 40),
            check.heightAnchor.constraint(equalToConstant: 40),
            harvestAppleSampler.topAnchor.constraint(equalTo: pastryWorkshopMap.topAnchor, constant: 50),
            harvestAppleSampler.leadingAnchor.constraint(equalTo: pastryWorkshopMap.leadingAnchor, constant: 18),
            harvestAppleSampler.trailingAnchor.constraint(equalTo: pastryWorkshopMap.trailingAnchor, constant: -18),
            tastingTrayNotes.topAnchor.constraint(equalTo: harvestAppleSampler.bottomAnchor, constant: 11),
            tastingTrayNotes.leadingAnchor.constraint(equalTo: pastryWorkshopMap.leadingAnchor, constant: 20),
            tastingTrayNotes.trailingAnchor.constraint(equalTo: pastryWorkshopMap.trailingAnchor, constant: -20),
            sugarPearlTopping.topAnchor.constraint(equalTo: tastingTrayNotes.bottomAnchor, constant: 18),
            sugarPearlTopping.centerXAnchor.constraint(equalTo: pastryWorkshopMap.centerXAnchor),
            sugarPearlTopping.widthAnchor.constraint(equalToConstant: 144),
            sugarPearlTopping.heightAnchor.constraint(equalToConstant: 36),
            sugarPearlTopping.bottomAnchor.constraint(equalTo: pastryWorkshopMap.bottomAnchor, constant: -18)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sugarPearlGradientLayer.frame = sugarPearlAccent.bounds
        sugarPearlGradientLayer.cornerRadius = sugarPearlAccent.bounds.height / 2
        sugarPearlButtonGradientLayer.frame = sugarPearlTopping.bounds
        sugarPearlButtonGradientLayer.cornerRadius = sugarPearlTopping.layer.cornerRadius
    }

    required init?(coder: NSCoder) {
        return nil
    }

    @objc private func cinnamonTwist() {
        firstGlazeDelight?()
    }
}
