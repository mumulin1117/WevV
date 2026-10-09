import UIKit

final class WevVWevvBakeryShelfToastView: UIControl {
    private let pastryWorkshopMap = UIView()
    private let sugarPearlTopping = WevVWevvMaplePillButton(title: "OKkA".wevVPastryCrumbBloomRestored)

    var firstGlazeDelight: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.5)
        addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)

        pastryWorkshopMap.translatesAutoresizingMaskIntoConstraints = false
        pastryWorkshopMap.backgroundColor = WevVGlazePromptStyler.creamTone
        pastryWorkshopMap.layer.cornerRadius = 26
        pastryWorkshopMap.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryWorkshopMap.layer.shadowOpacity = 0.24
        pastryWorkshopMap.layer.shadowRadius = 24
        pastryWorkshopMap.layer.shadowOffset = CGSize(width: 0, height: 12)
        addSubview(pastryWorkshopMap)

        let sugarPearlAccent = UIView()
        sugarPearlAccent.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlAccent.backgroundColor = WevVGlazePromptStyler.pinkTone
        sugarPearlAccent.layer.cornerRadius = 36
        sugarPearlAccent.layer.borderWidth = 12
        sugarPearlAccent.layer.borderColor = UIColor(red: 1, green: 0.76, blue: 0.91, alpha: 1).cgColor

        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.translatesAutoresizingMaskIntoConstraints = false
        check.tintColor = .white
        check.contentMode = .scaleAspectFit
        sugarPearlAccent.addSubview(check)

        let harvestAppleSampler = UILabel()
        harvestAppleSampler.translatesAutoresizingMaskIntoConstraints = false
        harvestAppleSampler.text = "SJaZvZend? ~SeuccccJeasus.fPujlzl=yF".wevVPastryCrumbBloomRestored
        harvestAppleSampler.font = .systemFont(ofSize: 17, weight: .heavy)
        harvestAppleSampler.textColor = WevVGlazePromptStyler.inkTone
        harvestAppleSampler.textAlignment = .center

        let tastingTrayNotes = UILabel()
        tastingTrayNotes.translatesAutoresizingMaskIntoConstraints = false
        tastingTrayNotes.text = "AKd^dvexd# otLo: zy;ofuDrH NfwamvRozrAi^tUe/sb.U RYaoMuA jc:aBnK YfgiAnzdk Ui!tP qaanoyEtbiUmkey Oi=nl QyyoduWrN =c+oBlUlhewcHt?i,oqnN.W".wevVPastryCrumbBloomRestored
        tastingTrayNotes.font = .systemFont(ofSize: 13, weight: .semibold)
        tastingTrayNotes.textColor = WevVGlazePromptStyler.mutedTone
        tastingTrayNotes.textAlignment = .center
        tastingTrayNotes.numberOfLines = 0

        sugarPearlTopping.addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)

        pastryWorkshopMap.addSubview(sugarPearlAccent)
        pastryWorkshopMap.addSubview(harvestAppleSampler)
        pastryWorkshopMap.addSubview(tastingTrayNotes)
        pastryWorkshopMap.addSubview(sugarPearlTopping)

        NSLayoutConstraint.activate([
            pastryWorkshopMap.centerXAnchor.constraint(equalTo: centerXAnchor),
            pastryWorkshopMap.centerYAnchor.constraint(equalTo: centerYAnchor),
            pastryWorkshopMap.widthAnchor.constraint(lessThanOrEqualToConstant: 236),
            pastryWorkshopMap.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.64),
            sugarPearlAccent.centerXAnchor.constraint(equalTo: pastryWorkshopMap.centerXAnchor),
            sugarPearlAccent.topAnchor.constraint(equalTo: pastryWorkshopMap.topAnchor, constant: -38),
            sugarPearlAccent.widthAnchor.constraint(equalToConstant: 72),
            sugarPearlAccent.heightAnchor.constraint(equalToConstant: 72),
            check.centerXAnchor.constraint(equalTo: sugarPearlAccent.centerXAnchor),
            check.centerYAnchor.constraint(equalTo: sugarPearlAccent.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: 32),
            check.heightAnchor.constraint(equalToConstant: 32),
            harvestAppleSampler.topAnchor.constraint(equalTo: pastryWorkshopMap.topAnchor, constant: 52),
            harvestAppleSampler.leadingAnchor.constraint(equalTo: pastryWorkshopMap.leadingAnchor, constant: 18),
            harvestAppleSampler.trailingAnchor.constraint(equalTo: pastryWorkshopMap.trailingAnchor, constant: -18),
            tastingTrayNotes.topAnchor.constraint(equalTo: harvestAppleSampler.bottomAnchor, constant: 14),
            tastingTrayNotes.leadingAnchor.constraint(equalTo: pastryWorkshopMap.leadingAnchor, constant: 22),
            tastingTrayNotes.trailingAnchor.constraint(equalTo: pastryWorkshopMap.trailingAnchor, constant: -22),
            sugarPearlTopping.topAnchor.constraint(equalTo: tastingTrayNotes.bottomAnchor, constant: 20),
            sugarPearlTopping.leadingAnchor.constraint(equalTo: pastryWorkshopMap.leadingAnchor),
            sugarPearlTopping.trailingAnchor.constraint(equalTo: pastryWorkshopMap.trailingAnchor),
            sugarPearlTopping.heightAnchor.constraint(equalToConstant: 50),
            sugarPearlTopping.bottomAnchor.constraint(equalTo: pastryWorkshopMap.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    @objc private func cinnamonTwist() {
        firstGlazeDelight?()
    }
}
