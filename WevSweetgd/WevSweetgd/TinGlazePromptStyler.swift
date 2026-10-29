import UIKit

enum TinGlazePromptStyler {
    static let strawberryGlazeTone = UIColor(red: 1, green: 0.29, blue: 0.66, alpha: 1)
    static let pinkTone = UIColor(red: 255 / 255.0, green: 75 / 255.0, blue: 169 / 255.0, alpha: 1)
    static let softPinkTone = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 77 / 255.0, alpha: 1)
    static let inkTone = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1)
    static let mutedTone = UIColor(red: 160 / 255.0, green: 160 / 255.0, blue: 176 / 255.0, alpha: 1)
    static let creamTone = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1)

    static func configureGlazeStatusLabel(_ sprinkleRefresh: UIRefreshControl) {
        sprinkleRefresh.tintColor = strawberryGlazeTone
        sprinkleRefresh.backgroundColor = .clear
        sprinkleRefresh.attributedTitle = NSAttributedString(
            string: "Pull to refresh",
            attributes: [.foregroundColor: mutedTone,
                         .font: UIFont.systemFont(ofSize: 13, weight: .medium)]
        )
    }

    static func showSugarToast(
        in view: UIView,
        text: String,
        above anchor: UIView? = nil,
        bottomOffset: CGFloat = -24
    ) {
        let crumbNook = UIView()
        crumbNook.translatesAutoresizingMaskIntoConstraints = false
        crumbNook.backgroundColor = creamTone.withAlphaComponent(0.96)
        crumbNook.layer.cornerRadius = 16
        crumbNook.layer.borderWidth = 1
        crumbNook.layer.borderColor = softPinkTone.cgColor
        crumbNook.layer.shadowColor = UIColor.black.cgColor
        crumbNook.layer.shadowOpacity = 0.22
        crumbNook.layer.shadowRadius = 18
        crumbNook.layer.shadowOffset = CGSize(width: 0, height: 8)
        crumbNook.alpha = 0
        crumbNook.transform = CGAffineTransform(translationX: 0, y: 8)

        let bakeryParlor = UIView()
        bakeryParlor.translatesAutoresizingMaskIntoConstraints = false
        bakeryParlor.backgroundColor = strawberryGlazeTone
        bakeryParlor.layer.cornerRadius = 7
        bakeryParlor.layer.borderWidth = 3
        bakeryParlor.layer.borderColor = strawberryGlazeTone.cgColor

        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textAlignment = .left
        crumbLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        crumbLabel.textColor = inkTone
        crumbLabel.numberOfLines = 2
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.78

        crumbNook.addSubview(bakeryParlor)
        crumbNook.addSubview(crumbLabel)
        view.addSubview(crumbNook)

        pinSugarToast(donutParlor: crumbNook, flavorParlor: bakeryParlor, crumbLabel: crumbLabel, glazeParlor: view, treatParlor: anchor, pastryParlor: bottomOffset)
        animateSugarToast(crumbNook)
    }

    @discardableResult
    static func showSugarLoading(in view: UIView, text: String) -> UIView {
        let loadingShade = UIControl()
        loadingShade.translatesAutoresizingMaskIntoConstraints = false
        loadingShade.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        loadingShade.alpha = 0

        let loadingCard = UIView()
        loadingCard.translatesAutoresizingMaskIntoConstraints = false
        loadingCard.backgroundColor = creamTone.withAlphaComponent(0.98)
        loadingCard.layer.cornerRadius = 20
        loadingCard.layer.borderWidth = 1
        loadingCard.layer.borderColor = softPinkTone.cgColor
        loadingCard.layer.shadowColor = UIColor.black.cgColor
        loadingCard.layer.shadowOpacity = 0.2
        loadingCard.layer.shadowRadius = 18
        loadingCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        let loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.color = strawberryGlazeTone
        loadingSpinner.startAnimating()

        let loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = text
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = inkTone
        loadingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        loadingLabel.numberOfLines = 2

        loadingShade.addSubview(loadingCard)
        loadingCard.addSubview(loadingSpinner)
        loadingCard.addSubview(loadingLabel)
        view.addSubview(loadingShade)

        NSLayoutConstraint.activate([
            loadingShade.topAnchor.constraint(equalTo: view.topAnchor),
            loadingShade.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingShade.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingShade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingCard.centerXAnchor.constraint(equalTo: loadingShade.centerXAnchor),
            loadingCard.centerYAnchor.constraint(equalTo: loadingShade.centerYAnchor),
            loadingCard.leadingAnchor.constraint(greaterThanOrEqualTo: loadingShade.leadingAnchor, constant: 48),
            loadingCard.trailingAnchor.constraint(lessThanOrEqualTo: loadingShade.trailingAnchor, constant: -48),
            loadingCard.widthAnchor.constraint(lessThanOrEqualToConstant: 240),
            loadingSpinner.topAnchor.constraint(equalTo: loadingCard.topAnchor, constant: 18),
            loadingSpinner.centerXAnchor.constraint(equalTo: loadingCard.centerXAnchor),
            loadingSpinner.widthAnchor.constraint(equalToConstant: 22),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 22),
            loadingLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 10),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingCard.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingCard.trailingAnchor, constant: -20),
            loadingLabel.bottomAnchor.constraint(equalTo: loadingCard.bottomAnchor, constant: -18)
        ])

        UIView.animate(withDuration: 0.18) {
            loadingShade.alpha = 1
        }
        return loadingShade
    }

    static func hideSugarLoading(_ loadingShade: UIView) {
        guard loadingShade.superview != nil else { return }
        UIView.animate(withDuration: 0.16, animations: {
            loadingShade.alpha = 0
        }, completion: { _ in
            loadingShade.removeFromSuperview()
        })
    }

    private static func pinSugarToast(donutParlor: UIView, flavorParlor: UIView, crumbLabel: UILabel, glazeParlor: UIView, treatParlor: UIView?, pastryParlor: CGFloat) {
        let bottomTarget = treatParlor?.topAnchor ?? glazeParlor.safeAreaLayoutGuide.bottomAnchor
        NSLayoutConstraint.activate([
            donutParlor.centerXAnchor.constraint(equalTo: glazeParlor.centerXAnchor),
            donutParlor.bottomAnchor.constraint(equalTo: bottomTarget, constant: pastryParlor),
            donutParlor.leadingAnchor.constraint(greaterThanOrEqualTo: glazeParlor.leadingAnchor, constant: 24),
            donutParlor.trailingAnchor.constraint(lessThanOrEqualTo: glazeParlor.trailingAnchor, constant: -24),
            donutParlor.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            flavorParlor.leadingAnchor.constraint(equalTo: donutParlor.leadingAnchor, constant: 18),
            flavorParlor.centerYAnchor.constraint(equalTo: donutParlor.centerYAnchor),
            flavorParlor.widthAnchor.constraint(equalToConstant: 14),
            flavorParlor.heightAnchor.constraint(equalToConstant: 14),
            crumbLabel.leadingAnchor.constraint(equalTo: flavorParlor.trailingAnchor, constant: 10),
            crumbLabel.trailingAnchor.constraint(equalTo: donutParlor.trailingAnchor, constant: -18),
            crumbLabel.topAnchor.constraint(equalTo: donutParlor.topAnchor, constant: 10),
            crumbLabel.bottomAnchor.constraint(equalTo: donutParlor.bottomAnchor, constant: -10)
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
        almondFlavor view: UIView,
        gourmetFlavor: String,
        glazeBowl: String,
        ringStack: String,
        miniDonut: String,
        fritterBite: UIColor = pinkTone,
        sugarFill: UIColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 77 / 255.0, alpha: 1),
        flavorHintLabel: String? = nil,
        twistPastry: @escaping () -> Void
    ) {
        let walnutFlavor = UIControl()
        walnutFlavor.translatesAutoresizingMaskIntoConstraints = false
        walnutFlavor.backgroundColor = UIColor.black.withAlphaComponent(0.87)
        view.addSubview(walnutFlavor)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1)
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor.black.cgColor
        pastryCard.layer.shadowOpacity = 0.2
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        walnutFlavor.addSubview(pastryCard)

        let pecanFlavor = UIView()
        pecanFlavor.translatesAutoresizingMaskIntoConstraints = false
        pecanFlavor.backgroundColor = .clear
        pecanFlavor.layer.cornerRadius = 24
        pecanFlavor.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let hazelnutFlavor = UIImageView(image: UIImage(named: "hazelnutFlavor")?.withRenderingMode(.alwaysOriginal))
        hazelnutFlavor.translatesAutoresizingMaskIntoConstraints = false
        hazelnutFlavor.backgroundColor = .clear
        hazelnutFlavor.contentMode = .scaleAspectFit

        let glazeTitleLabel = makePromptLabel(gourmetFlavor, size: 17, weight: .heavy, color: UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1))
        glazeTitleLabel.textAlignment = .center

        let frostingNoteLabel = makePromptLabel(glazeBowl, size: 12, weight: .semibold, color: UIColor(red: 160 / 255.0, green: 160 / 255.0, blue: 176 / 255.0, alpha: 1))
        frostingNoteLabel.textAlignment = .center
        frostingNoteLabel.numberOfLines = 0
        if let flavorHintLabel {
            let cocoaScout = NSMutableAttributedString(string: glazeBowl)
            let tastingTrayNotes = (glazeBowl as NSString).range(of: flavorHintLabel)
            if tastingTrayNotes.location != NSNotFound {
                cocoaScout.addAttribute(.foregroundColor, value: UIColor(red: 255 / 255.0, green: 86 / 255.0, blue: 86 / 255.0, alpha: 1), range: tastingTrayNotes)
            }
            frostingNoteLabel.attributedText = cocoaScout
        }

        let crumbCancelButton = makePromptButton(miniDonut, fill: sugarFill, color: .white)
        let glazeConfirmButton = makePromptButton(ringStack, fill: fritterBite, color: .white)
        bindSugarConfirmButtons(crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton, shade: walnutFlavor, onConfirm: twistPastry)
        placeSugarConfirmViews(pastryCard: pastryCard, topper: pecanFlavor, ring: hazelnutFlavor, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton)
        pinSugarConfirm(shade: walnutFlavor, pastryCard: pastryCard, topper: pecanFlavor, ring: hazelnutFlavor, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, crumbCancelButton: crumbCancelButton, glazeConfirmButton: glazeConfirmButton, view: view)
    }

    static func showSugarNotice(
        marshmallowFlavor view: UIView,
        cookieFlavor: String,
        oreoFlavor: String,
        bakeryAtlas: String,
        bakeryFinder: @escaping () -> Void
    ) {
        let bakeryTrail = UIControl()
        bakeryTrail.translatesAutoresizingMaskIntoConstraints = false
        bakeryTrail.backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: 0.48)
        view.addSubview(bakeryTrail)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = creamTone
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor.black.cgColor
        pastryCard.layer.shadowOpacity = 0.2
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        bakeryTrail.addSubview(pastryCard)

        let topper = UIView()
        topper.translatesAutoresizingMaskIntoConstraints = false
        topper.backgroundColor = softPinkTone
        topper.layer.cornerRadius = 24
        topper.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let donutFinder = UIView()
        donutFinder.translatesAutoresizingMaskIntoConstraints = false
        donutFinder.backgroundColor = pinkTone
        donutFinder.layer.cornerRadius = 20
        donutFinder.layer.borderWidth = 7
        donutFinder.layer.borderColor = UIColor(red: 1, green: 0.75, blue: 0.9, alpha: 1).cgColor

        let glazeTitleLabel = makePromptLabel(cookieFlavor, size: 17, weight: .heavy, color: inkTone)
        glazeTitleLabel.textAlignment = .center

        let frostingNoteLabel = makePromptLabel(oreoFlavor, size: 12, weight: .semibold, color: mutedTone)
        frostingNoteLabel.textAlignment = .center
        frostingNoteLabel.numberOfLines = 0

        let glazeActionButton = makePromptButton(bakeryAtlas, fill: pinkTone, color: .white)
        glazeActionButton.addAction(UIAction { [weak bakeryTrail] _ in
            bakeryTrail?.removeFromSuperview()
            bakeryFinder()
        }, for: .touchUpInside)

        pastryCard.addSubview(topper)
        pastryCard.addSubview(donutFinder)
        pastryCard.addSubview(glazeTitleLabel)
        pastryCard.addSubview(frostingNoteLabel)
        pastryCard.addSubview(glazeActionButton)

        pinSugarNotice(flavorStop: bakeryTrail, pastryCard: pastryCard, bakeryVisit: topper, pastryStop: donutFinder, glazeTitleLabel: glazeTitleLabel, frostingNoteLabel: frostingNoteLabel, glazeActionButton: glazeActionButton, glazeStop: view)
    }

    private static func pinSugarNotice(flavorStop: UIView, pastryCard: UIView, bakeryVisit: UIView, pastryStop: UIView, glazeTitleLabel: UILabel, frostingNoteLabel: UILabel, glazeActionButton: UIButton, glazeStop: UIView) {
        NSLayoutConstraint.activate([
            flavorStop.topAnchor.constraint(equalTo: glazeStop.topAnchor),
            flavorStop.leadingAnchor.constraint(equalTo: glazeStop.leadingAnchor),
            flavorStop.trailingAnchor.constraint(equalTo: glazeStop.trailingAnchor),
            flavorStop.bottomAnchor.constraint(equalTo: glazeStop.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: flavorStop.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: flavorStop.centerYAnchor, constant: -8),
            pastryCard.widthAnchor.constraint(equalTo: flavorStop.widthAnchor, multiplier: 0.72),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
            bakeryVisit.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            bakeryVisit.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            bakeryVisit.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            bakeryVisit.heightAnchor.constraint(equalToConstant: 54),
            pastryStop.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            pastryStop.centerYAnchor.constraint(equalTo: bakeryVisit.bottomAnchor),
            pastryStop.widthAnchor.constraint(equalToConstant: 40),
            pastryStop.heightAnchor.constraint(equalToConstant: 40),
            glazeTitleLabel.topAnchor.constraint(equalTo: pastryStop.bottomAnchor, constant: 12),
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
            glazeTitleLabel.topAnchor.constraint(equalTo: ring.bottomAnchor, constant: 20),
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
