import UIKit

final class WevVShelfSuccessView: UIControl {
    private let card = UIView()
    private let okButton = WevVGlazePillButton(title: "Ok")

    var onCreamClose: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.48)
        addTarget(self, action: #selector(closeCreamLayer), for: .touchUpInside)

        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 1, green: 0.55, blue: 0.82, alpha: 1)
        card.layer.cornerRadius = 22
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.22
        card.layer.shadowRadius = 18
        card.layer.shadowOffset = CGSize(width: 0, height: 10)
        addSubview(card)

        let mark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.tintColor = UIColor(red: 0.53, green: 0.28, blue: 1, alpha: 1)
        mark.contentMode = .scaleAspectFit

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Saved Successfully"
        title.font = .systemFont(ofSize: 17, weight: .heavy)
        title.textColor = .black
        title.textAlignment = .center

        let note = UILabel()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.text = "Added to your favorites. You can find it anytime in your collection."
        note.font = .systemFont(ofSize: 13, weight: .semibold)
        note.textColor = .black
        note.textAlignment = .center
        note.numberOfLines = 0

        okButton.addTarget(self, action: #selector(closeCreamLayer), for: .touchUpInside)

        card.addSubview(mark)
        card.addSubview(title)
        card.addSubview(note)
        card.addSubview(okButton)

        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: centerXAnchor),
            card.centerYAnchor.constraint(equalTo: centerYAnchor),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 236),
            card.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.64),
            mark.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            mark.topAnchor.constraint(equalTo: card.topAnchor, constant: -38),
            mark.widthAnchor.constraint(equalToConstant: 82),
            mark.heightAnchor.constraint(equalToConstant: 82),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 52),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            note.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            note.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            okButton.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20),
            okButton.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            okButton.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 50),
            okButton.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    @objc private func closeCreamLayer() {
        onCreamClose?()
    }
}
