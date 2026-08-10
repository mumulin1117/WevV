import UIKit

enum WevVGlazePromptStyler {
    static let pinkTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    static let softPinkTone = UIColor(red: 1, green: 0.91, blue: 0.97, alpha: 1)
    static let inkTone = UIColor(red: 0.16, green: 0.09, blue: 0.2, alpha: 1)
    static let mutedTone = UIColor(red: 0.54, green: 0.47, blue: 0.58, alpha: 1)
    static let creamTone = UIColor(red: 1, green: 0.98, blue: 0.99, alpha: 1)

    static func showSugarToast(
        in view: UIView,
        text: String,
        above anchor: UIView? = nil,
        bottomOffset: CGFloat = -24
    ) {
        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.backgroundColor = creamTone.withAlphaComponent(0.96)
        shell.layer.cornerRadius = 22
        shell.layer.borderWidth = 1
        shell.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        shell.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        shell.layer.shadowOpacity = 0.22
        shell.layer.shadowRadius = 18
        shell.layer.shadowOffset = CGSize(width: 0, height: 8)
        shell.alpha = 0
        shell.transform = CGAffineTransform(translationX: 0, y: 8)

        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = pinkTone
        dot.layer.cornerRadius = 7
        dot.layer.borderWidth = 3
        dot.layer.borderColor = UIColor(red: 1, green: 0.78, blue: 0.91, alpha: 1).cgColor

        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textAlignment = .left
        crumbLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        crumbLabel.textColor = inkTone
        crumbLabel.numberOfLines = 2
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.78

        shell.addSubview(dot)
        shell.addSubview(crumbLabel)
        view.addSubview(shell)

        pinSugarToast(shell: shell, dot: dot, crumbLabel: crumbLabel, view: view, anchor: anchor, bottomOffset: bottomOffset)
        animateSugarToast(shell)
    }

    private static func pinSugarToast(shell: UIView, dot: UIView, crumbLabel: UILabel, view: UIView, anchor: UIView?, bottomOffset: CGFloat) {
        let bottomTarget = anchor?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor
        NSLayoutConstraint.activate([
            shell.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shell.bottomAnchor.constraint(equalTo: bottomTarget, constant: bottomOffset),
            shell.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            shell.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            shell.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            dot.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: 18),
            dot.centerYAnchor.constraint(equalTo: shell.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 14),
            dot.heightAnchor.constraint(equalToConstant: 14),
            crumbLabel.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 10),
            crumbLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -18),
            crumbLabel.topAnchor.constraint(equalTo: shell.topAnchor, constant: 10),
            crumbLabel.bottomAnchor.constraint(equalTo: shell.bottomAnchor, constant: -10)
        ])
    }

    private static func animateSugarToast(_ shell: UIView) {
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            shell.alpha = 1
            shell.transform = .identity
        }
        UIView.animate(withDuration: 0.22, delay: 1.45, options: [.curveEaseIn]) {
            shell.alpha = 0
            shell.transform = CGAffineTransform(translationX: 0, y: 8)
        } completion: { _ in
            shell.removeFromSuperview()
        }
    }

    static func showSugarConfirm(
        in view: UIView,
        title: String,
        note: String,
        confirmTitle: String,
        cancelTitle: String,
        confirmFill: UIColor = pinkTone,
        onConfirm: @escaping () -> Void
    ) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.48)
        view.addSubview(shade)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = creamTone
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor.black.cgColor
        pastryCard.layer.shadowOpacity = 0.2
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        shade.addSubview(pastryCard)

        let topper = UIView()
        topper.translatesAutoresizingMaskIntoConstraints = false
        topper.backgroundColor = softPinkTone
        topper.layer.cornerRadius = 24
        topper.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let ring = UIView()
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.backgroundColor = pinkTone
        ring.layer.cornerRadius = 20
        ring.layer.borderWidth = 7
        ring.layer.borderColor = UIColor(red: 1, green: 0.75, blue: 0.9, alpha: 1).cgColor

        let glazeTitleLabel = makePromptLabel(title, size: 17, weight: .heavy, color: inkTone)
        glazeTitleLabel.textAlignment = .center

        let frostingNoteLabel = makePromptLabel(note, size: 12, weight: .semibold, color: mutedTone)
        frostingNoteLabel.textAlignment = .center
        frostingNoteLabel.numberOfLines = 0

        let crumbCancelButton = makePromptButton(cancelTitle, fill: UIColor(red: 0.88, green: 0.85, blue: 0.89, alpha: 1), color: .white)
        let glazeConfirmButton = makePromptButton(confirmTitle, fill: confirmFill, color: .white)
        bindSugarConfirmButtons(crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton, shade: shade, onConfirm: onConfirm)
        placeSugarConfirmViews(pastryCard: pastryCard, topper: topper, ring: ring, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton)
        pinSugarConfirm(shade: shade, pastryCard: pastryCard, topper: topper, ring: ring, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton, view: view)
    }

    static func showSugarNotice(
        in view: UIView,
        title: String,
        note: String,
        actionTitle: String,
        onClose: @escaping () -> Void
    ) {
        let shade = UIControl()
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.48)
        view.addSubview(shade)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = creamTone
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor.black.cgColor
        pastryCard.layer.shadowOpacity = 0.2
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        shade.addSubview(pastryCard)

        let topper = UIView()
        topper.translatesAutoresizingMaskIntoConstraints = false
        topper.backgroundColor = softPinkTone
        topper.layer.cornerRadius = 24
        topper.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let ring = UIView()
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.backgroundColor = pinkTone
        ring.layer.cornerRadius = 20
        ring.layer.borderWidth = 7
        ring.layer.borderColor = UIColor(red: 1, green: 0.75, blue: 0.9, alpha: 1).cgColor

        let glazeTitleLabel = makePromptLabel(title, size: 17, weight: .heavy, color: inkTone)
        glazeTitleLabel.textAlignment = .center

        let frostingNoteLabel = makePromptLabel(note, size: 12, weight: .semibold, color: mutedTone)
        frostingNoteLabel.textAlignment = .center
        frostingNoteLabel.numberOfLines = 0

        let glazeActionButton = makePromptButton(actionTitle, fill: pinkTone, color: .white)
        glazeActionButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
            onClose()
        }, for: .touchUpInside)

        pastryCard.addSubview(topper)
        pastryCard.addSubview(ring)
        pastryCard.addSubview(glazeTitleLabel)
        pastryCard.addSubview(frostingNoteLabel)
        pastryCard.addSubview(glazeActionButton)

        pinSugarNotice(shade: shade, pastryCard: pastryCard, topper: topper, ring: ring, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, glazeActionButton: glazeActionButton, view: view)
    }

    private static func pinSugarNotice(shade: UIView, pastryCard: UIView, topper: UIView, ring: UIView, glazeTitleLabel: UILabel, frostingNoteLabel: UILabel, glazeActionButton: UIButton, view: UIView) {
        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: shade.centerYAnchor, constant: -8),
            pastryCard.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.72),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
            topper.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            topper.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            topper.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            topper.heightAnchor.constraint(equalToConstant: 54),
            ring.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            ring.centerYAnchor.constraint(equalTo: topper.bottomAnchor),
            ring.widthAnchor.constraint(equalToConstant: 40),
            ring.heightAnchor.constraint(equalToConstant: 40),
            glazeTitleLabel.topAnchor.constraint(equalTo: ring.bottomAnchor, constant: 12),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            frostingNoteLabel.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 10),
            frostingNoteLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 24),
            frostingNoteLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24),
            glazeActionButton.topAnchor.constraint(equalTo: frostingNoteLabel.bottomAnchor, constant: 20),
            glazeActionButton.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 28),
            glazeActionButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -28),
            glazeActionButton.heightAnchor.constraint(equalToConstant: 42),
            glazeActionButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -22)
        ])
    }

    private static func bindSugarConfirmButtons(crumbCancelButton: UIButton, glazeConfirmButton: UIButton, shade: UIView, onConfirm: @escaping () -> Void) {
        crumbCancelButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
        }, for: .touchUpInside)
        glazeConfirmButton.addAction(UIAction { [weak shade] _ in
            shade?.removeFromSuperview()
            onConfirm()
        }, for: .touchUpInside)
    }

    private static func placeSugarConfirmViews(pastryCard: UIView, topper: UIView, ring: UIView, glazeTitleLabel: UILabel, frostingNoteLabel: UILabel, crumbCancelButton: UIButton, glazeConfirmButton: UIButton) {
        pastryCard.addSubview(topper)
        pastryCard.addSubview(ring)
        pastryCard.addSubview(glazeTitleLabel)
        pastryCard.addSubview(frostingNoteLabel)
        pastryCard.addSubview(crumbCancelButton)
        pastryCard.addSubview(glazeConfirmButton)
    }

    private static func pinSugarConfirm(shade: UIView, pastryCard: UIView, topper: UIView, ring: UIView, glazeTitleLabel: UILabel, frostingNoteLabel: UILabel, crumbCancelButton: UIButton, glazeConfirmButton: UIButton, view: UIView) {
        NSLayoutConstraint.activate([
            shade.topAnchor.constraint(equalTo: view.topAnchor),
            shade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: shade.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: shade.centerYAnchor, constant: -8),
            pastryCard.widthAnchor.constraint(equalTo: shade.widthAnchor, multiplier: 0.72),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
            topper.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            topper.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            topper.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            topper.heightAnchor.constraint(equalToConstant: 54),
            ring.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            ring.centerYAnchor.constraint(equalTo: topper.bottomAnchor),
            ring.widthAnchor.constraint(equalToConstant: 40),
            ring.heightAnchor.constraint(equalToConstant: 40),
            glazeTitleLabel.topAnchor.constraint(equalTo: ring.bottomAnchor, constant: 12),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            frostingNoteLabel.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 10),
            frostingNoteLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 24),
            frostingNoteLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24),
            crumbCancelButton.topAnchor.constraint(equalTo: frostingNoteLabel.bottomAnchor, constant: 20),
            crumbCancelButton.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            crumbCancelButton.trailingAnchor.constraint(equalTo: pastryCard.centerXAnchor, constant: -7),
            crumbCancelButton.heightAnchor.constraint(equalToConstant: 40),
            glazeConfirmButton.leadingAnchor.constraint(equalTo: pastryCard.centerXAnchor, constant: 7),
            glazeConfirmButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            glazeConfirmButton.centerYAnchor.constraint(equalTo: crumbCancelButton.centerYAnchor),
            glazeConfirmButton.heightAnchor.constraint(equalTo: crumbCancelButton.heightAnchor),
            glazeConfirmButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -22)
        ])
    }

    static func makePromptButton(_ title: String, fill: UIColor, color: UIColor) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setTitle(title, for: .normal)
        sprinkleButton.setTitleColor(color, for: .normal)
        sprinkleButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        sprinkleButton.backgroundColor = fill
        sprinkleButton.layer.cornerRadius = 20
        return sprinkleButton
    }

    private static func makePromptLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.76
        return crumbLabel
    }
}
