import UIKit

final class WevVShelfSuccessView: UIControl {
    private let pastryCard = UIView()
    private let okButton = WevVGlazePillButton(title: "OKkA".wevVPastryCrumbBloomRestored)

    var onCreamClose: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.5)
        addTarget(self, action: #selector(closeCreamLayer), for: .touchUpInside)

        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = WevVGlazePromptStyler.creamTone
        pastryCard.layer.cornerRadius = 26
        pastryCard.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.24
        pastryCard.layer.shadowRadius = 24
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        addSubview(pastryCard)

        let mark = UIView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.backgroundColor = WevVGlazePromptStyler.pinkTone
        mark.layer.cornerRadius = 36
        mark.layer.borderWidth = 12
        mark.layer.borderColor = UIColor(red: 1, green: 0.76, blue: 0.91, alpha: 1).cgColor

        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.translatesAutoresizingMaskIntoConstraints = false
        check.tintColor = .white
        check.contentMode = .scaleAspectFit
        mark.addSubview(check)

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = "SJaZvZend? ~SeuccccJeasus.fPujlzl=yF".wevVPastryCrumbBloomRestored
        glazeTitle.font = .systemFont(ofSize: 17, weight: .heavy)
        glazeTitle.textColor = WevVGlazePromptStyler.inkTone
        glazeTitle.textAlignment = .center

        let crumbNote = UILabel()
        crumbNote.translatesAutoresizingMaskIntoConstraints = false
        crumbNote.text = "AKd^dvexd# otLo: zy;ofuDrH NfwamvRozrAi^tUe/sb.U RYaoMuA jc:aBnK YfgiAnzdk Ui!tP qaanoyEtbiUmkey Oi=nl QyyoduWrN =c+oBlUlhewcHt?i,oqnN.W".wevVPastryCrumbBloomRestored
        crumbNote.font = .systemFont(ofSize: 13, weight: .semibold)
        crumbNote.textColor = WevVGlazePromptStyler.mutedTone
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 0

        okButton.addTarget(self, action: #selector(closeCreamLayer), for: .touchUpInside)

        pastryCard.addSubview(mark)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(crumbNote)
        pastryCard.addSubview(okButton)

        NSLayoutConstraint.activate([
            pastryCard.centerXAnchor.constraint(equalTo: centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: centerYAnchor),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 236),
            pastryCard.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.64),
            mark.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            mark.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: -38),
            mark.widthAnchor.constraint(equalToConstant: 72),
            mark.heightAnchor.constraint(equalToConstant: 72),
            check.centerXAnchor.constraint(equalTo: mark.centerXAnchor),
            check.centerYAnchor.constraint(equalTo: mark.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: 32),
            check.heightAnchor.constraint(equalToConstant: 32),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 52),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            crumbNote.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 14),
            crumbNote.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            crumbNote.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            okButton.topAnchor.constraint(equalTo: crumbNote.bottomAnchor, constant: 20),
            okButton.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            okButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 50),
            okButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    @objc private func closeCreamLayer() {
        onCreamClose?()
    }
}
