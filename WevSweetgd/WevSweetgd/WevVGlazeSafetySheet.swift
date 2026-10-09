import UIKit

final class WevVGlazeProfileSafetyTray: UIView {
    private let frostingBackdrop = UIControl()
    private let berryReportButton = UIButton(type: .system)
    private let vanillaBlockButton = UIButton(type: .system)
    private let citrusCancelButton = UIButton(type: .system)

    var berryReportAction: (() -> Void)?
    var vanillaBlockAction: (() -> Void)?
    var pralineDismissAction: (() -> Void)?

    init(cocoaGuarded: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildFrostingTray(cocoaGuarded: cocoaGuarded)
    }

    required init?(coder: NSCoder) { nil }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        frostingBackdrop.alpha = 0
        [berryReportButton, vanillaBlockButton, citrusCancelButton].forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 18)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
            self.frostingBackdrop.alpha = 1
            [self.berryReportButton, self.vanillaBlockButton, self.citrusCancelButton].forEach {
                $0.alpha = 1
                $0.transform = .identity
            }
        }
    }

    private func buildFrostingTray(cocoaGuarded: Bool) {
        frostingBackdrop.translatesAutoresizingMaskIntoConstraints = false
        frostingBackdrop.backgroundColor = UIColor.black.withAlphaComponent(0.52)
        frostingBackdrop.addTarget(self, action: #selector(cancelCitrusTray), for: .touchUpInside)
        addSubview(frostingBackdrop)

        configurePastryButton(berryReportButton, title: "Report", fill: .white, titleColor: pastryPalette.berryTint)
        configurePastryButton(vanillaBlockButton, title: cocoaGuarded ? "Unblock" : "Block", fill: .white, titleColor: pastryPalette.berryTint)
        configurePastryButton(citrusCancelButton, title: "Cancel", fill: pastryPalette.berryTint, titleColor: .white)
        berryReportButton.addTarget(self, action: #selector(reportBerryTaster), for: .touchUpInside)
        vanillaBlockButton.addTarget(self, action: #selector(toggleVanillaGuard), for: .touchUpInside)
        citrusCancelButton.addTarget(self, action: #selector(cancelCitrusTray), for: .touchUpInside)

        [berryReportButton, vanillaBlockButton, citrusCancelButton].forEach(addSubview)
        NSLayoutConstraint.activate([
            frostingBackdrop.topAnchor.constraint(equalTo: topAnchor),
            frostingBackdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            frostingBackdrop.trailingAnchor.constraint(equalTo: trailingAnchor),
            frostingBackdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            citrusCancelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 14),
            citrusCancelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -14),
            citrusCancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18),
            citrusCancelButton.heightAnchor.constraint(equalToConstant: 42),
            vanillaBlockButton.leadingAnchor.constraint(equalTo: citrusCancelButton.leadingAnchor),
            vanillaBlockButton.trailingAnchor.constraint(equalTo: citrusCancelButton.trailingAnchor),
            vanillaBlockButton.bottomAnchor.constraint(equalTo: citrusCancelButton.topAnchor, constant: -9),
            vanillaBlockButton.heightAnchor.constraint(equalTo: citrusCancelButton.heightAnchor),
            berryReportButton.leadingAnchor.constraint(equalTo: citrusCancelButton.leadingAnchor),
            berryReportButton.trailingAnchor.constraint(equalTo: citrusCancelButton.trailingAnchor),
            berryReportButton.bottomAnchor.constraint(equalTo: vanillaBlockButton.topAnchor, constant: -9),
            berryReportButton.heightAnchor.constraint(equalTo: citrusCancelButton.heightAnchor)
        ])
    }

    private func configurePastryButton(_ button: UIButton, title: String, fill: UIColor, titleColor: UIColor) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = fill
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 21
    }

    @objc private func reportBerryTaster() { berryReportAction?() }
    @objc private func toggleVanillaGuard() { vanillaBlockAction?() }
    @objc private func cancelCitrusTray() { pralineDismissAction?() }
}

private enum pastryPalette {
    static let berryTint = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
    static let cocoaInk = UIColor(red: 0.12, green: 0.1, blue: 0.14, alpha: 1)
    static let vanillaInk = UIColor(red: 0.43, green: 0.4, blue: 0.46, alpha: 1)
    static let pastryField = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
}

final class WevVGlazeSafetySheet: UIView, UITextViewDelegate {
    private let frostingBackdrop = UIControl()
    private let pastryPanel = UIView()
    private let flavorStack = UIStackView()
    private let tastingBox = UITextView()
    private let tastingHint = UILabel()
    private let vanillaConfirmButton = UIButton(type: .system)
    private let flavorChoices: [pastryCompendiumEdition]
    private var chosenFlavor: pastryCompendiumEdition?
    private var flavorButtons: [String: UIButton] = [:]
    private var panelLowerConstraint: NSLayoutConstraint?

    var pralineDismissAction: (() -> Void)?
    var pralineSubmitAction: ((tastingPassportEdition) -> Void)?

    init(shopPinKey: String, flavorChoices: [pastryCompendiumEdition]) {
        self.flavorChoices = flavorChoices
        self.shopPinKey = shopPinKey
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildPastrySheet()
        refreshVanillaState()
        observeTastingKeys()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private let shopPinKey: String

    private func buildPastrySheet() {
        frostingBackdrop.translatesAutoresizingMaskIntoConstraints = false
        frostingBackdrop.backgroundColor = UIColor.black.withAlphaComponent(0.52)
        frostingBackdrop.addTarget(self, action: #selector(closePastrySheet), for: .touchUpInside)
        addSubview(frostingBackdrop)

        pastryPanel.translatesAutoresizingMaskIntoConstraints = false
        pastryPanel.backgroundColor = .white
        pastryPanel.layer.cornerRadius = 0
        addSubview(pastryPanel)

        let pastryTitle = makeTastingLabel("REePpfoTrOth".wevVPastryCrumbBloomRestored, size: 15, weight: .heavy, color: .black)
        pastryTitle.textAlignment = .center

        let pastryHint = makeTastingLabel("PklqefaUsQed ls#eCl#eLc,tU Vt+hReQ erie~a:saoon# zfaoKrO FrUeJploErStcimn+gi .tPhbiOs# Puas/etr#:H".wevVPastryCrumbBloomRestored, size: 12, weight: .regular, color: pastryPalette.vanillaInk)
        pastryHint.textAlignment = .center
        pastryHint.numberOfLines = 2

        flavorStack.translatesAutoresizingMaskIntoConstraints = false
        flavorStack.axis = .vertical
        flavorStack.spacing = 0

        for flavor in flavorChoices {
            let pastryRow = makeFlavorRow(flavor)
            flavorStack.addArrangedSubview(pastryRow)
        }

        tastingBox.translatesAutoresizingMaskIntoConstraints = false
        tastingBox.backgroundColor = pastryPalette.pastryField
        tastingBox.layer.cornerRadius = 8
        tastingBox.font = .systemFont(ofSize: 12, weight: .regular)
        tastingBox.textColor = pastryPalette.cocoaInk
        tastingBox.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 10, right: 12)
        tastingBox.delegate = self
        tastingBox.isUserInteractionEnabled = false

        tastingHint.translatesAutoresizingMaskIntoConstraints = false
        tastingHint.text = "E:n:tAe?rO ;yCo%uSrd br#eTaEsqo*n+ MhtebryeW +.a.?.g".wevVPastryCrumbBloomRestored
        tastingHint.font = .systemFont(ofSize: 12, weight: .medium)
        tastingHint.textColor = UIColor(red: 0.75, green: 0.72, blue: 0.75, alpha: 1)

        vanillaConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        vanillaConfirmButton.setTitle("CZoonrfriUrJm%".wevVPastryCrumbBloomRestored, for: .normal)
        vanillaConfirmButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        vanillaConfirmButton.layer.cornerRadius = 21
        vanillaConfirmButton.addTarget(self, action: #selector(confirmVanillaChoice), for: .touchUpInside)

        placePastrySheetViews(title: pastryTitle, hint: pastryHint)
        pinPastrySheetLayout(title: pastryTitle, hint: pastryHint)
    }

    private func placePastrySheetViews(title: UILabel, hint: UILabel) {
        pastryPanel.addSubview(title)
        pastryPanel.addSubview(hint)
        pastryPanel.addSubview(flavorStack)
        pastryPanel.addSubview(tastingBox)
        pastryPanel.addSubview(tastingHint)
        pastryPanel.addSubview(vanillaConfirmButton)
    }

    private func pinPastrySheetLayout(title: UILabel, hint: UILabel) {
        let bottom = pastryPanel.bottomAnchor.constraint(equalTo: bottomAnchor)
        panelLowerConstraint = bottom

        NSLayoutConstraint.activate([
            frostingBackdrop.topAnchor.constraint(equalTo: topAnchor),
            frostingBackdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            frostingBackdrop.trailingAnchor.constraint(equalTo: trailingAnchor),
            frostingBackdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            pastryPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pastryPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottom,
            title.topAnchor.constraint(equalTo: pastryPanel.topAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: pastryPanel.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: pastryPanel.trailingAnchor, constant: -24),
            hint.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            hint.leadingAnchor.constraint(equalTo: pastryPanel.leadingAnchor, constant: 24),
            hint.trailingAnchor.constraint(equalTo: pastryPanel.trailingAnchor, constant: -24),
            flavorStack.topAnchor.constraint(equalTo: hint.bottomAnchor, constant: 10),
            flavorStack.leadingAnchor.constraint(equalTo: pastryPanel.leadingAnchor),
            flavorStack.trailingAnchor.constraint(equalTo: pastryPanel.trailingAnchor),
            tastingBox.topAnchor.constraint(equalTo: flavorStack.bottomAnchor, constant: 9),
            tastingBox.leadingAnchor.constraint(equalTo: pastryPanel.leadingAnchor, constant: 16),
            tastingBox.trailingAnchor.constraint(equalTo: pastryPanel.trailingAnchor, constant: -16),
            tastingBox.heightAnchor.constraint(equalToConstant: 72),
            tastingHint.topAnchor.constraint(equalTo: tastingBox.topAnchor, constant: 14),
            tastingHint.leadingAnchor.constraint(equalTo: tastingBox.leadingAnchor, constant: 16),
            tastingHint.trailingAnchor.constraint(equalTo: tastingBox.trailingAnchor, constant: -16),
            vanillaConfirmButton.topAnchor.constraint(equalTo: tastingBox.bottomAnchor, constant: 14),
            vanillaConfirmButton.leadingAnchor.constraint(equalTo: pastryPanel.leadingAnchor, constant: 15),
            vanillaConfirmButton.trailingAnchor.constraint(equalTo: pastryPanel.trailingAnchor, constant: -15),
            vanillaConfirmButton.heightAnchor.constraint(equalToConstant: 42),
            vanillaConfirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    private func makeFlavorRow(_ flavor: pastryCompendiumEdition) -> UIControl {
        let pastryRow = UIControl()
        pastryRow.translatesAutoresizingMaskIntoConstraints = false
        pastryRow.addAction(UIAction { [weak self] _ in
            self?.selectFlavorChoice(flavor)
        }, for: .touchUpInside)

        let almondCutter = UIButton(type: .system)
        almondCutter.translatesAutoresizingMaskIntoConstraints = false
        almondCutter.isUserInteractionEnabled = false
        almondCutter.tintColor = pastryPalette.vanillaInk
        almondCutter.setImage(UIImage(systemName: "circle"), for: .normal)
        flavorButtons[flavor.flavorLibraryEdition] = almondCutter

        let crumbLabel = makeTastingLabel(flavor.pastryDisplayShowcase, size: 13, weight: .medium, color: UIColor(red: 0.14, green: 0.12, blue: 0.15, alpha: 1))
        crumbLabel.numberOfLines = 2

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 0.91, green: 0.9, blue: 0.91, alpha: 1)

        pastryRow.addSubview(almondCutter)
        pastryRow.addSubview(crumbLabel)
        pastryRow.addSubview(line)

        NSLayoutConstraint.activate([
            pastryRow.heightAnchor.constraint(equalToConstant: 42),
            almondCutter.leadingAnchor.constraint(equalTo: pastryRow.leadingAnchor, constant: 17),
            almondCutter.centerYAnchor.constraint(equalTo: pastryRow.centerYAnchor),
            almondCutter.widthAnchor.constraint(equalToConstant: 16),
            almondCutter.heightAnchor.constraint(equalToConstant: 16),
            crumbLabel.leadingAnchor.constraint(equalTo: almondCutter.trailingAnchor, constant: 12),
            crumbLabel.trailingAnchor.constraint(equalTo: pastryRow.trailingAnchor, constant: -28),
            crumbLabel.centerYAnchor.constraint(equalTo: pastryRow.centerYAnchor),
            line.leadingAnchor.constraint(equalTo: pastryRow.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: pastryRow.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: pastryRow.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        return pastryRow
    }

    private func selectFlavorChoice(_ flavor: pastryCompendiumEdition) {
        chosenFlavor = flavor
        for flavorOption in flavorChoices {
            let imageName = flavorOption.flavorLibraryEdition == flavor.flavorLibraryEdition ? "largecircle.fill.circle" : "cFiRrYcMlbe=".wevVPastryCrumbBloomRestored
            flavorButtons[flavorOption.flavorLibraryEdition]?.setImage(UIImage(systemName: imageName), for: .normal)
            flavorButtons[flavorOption.flavorLibraryEdition]?.tintColor = flavorOption.flavorLibraryEdition == flavor.flavorLibraryEdition ? pastryPalette.berryTint : pastryPalette.vanillaInk
        }
        tastingBox.isUserInteractionEnabled = flavor.tastingSequenceInsight
        if flavor.tastingSequenceInsight {
            tastingBox.becomeFirstResponder()
        } else {
            tastingBox.text = ""
            tastingHint.isHidden = false
            tastingBox.resignFirstResponder()
        }
        refreshVanillaState()
    }

    private func refreshVanillaState() {
        let hasFlavor = chosenFlavor != nil
        let needsNotes = chosenFlavor?.tastingSequenceInsight == true
        let hasNotes = !tastingBox.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let canConfirm = hasFlavor && (!needsNotes || hasNotes)
        vanillaConfirmButton.isEnabled = canConfirm
        vanillaConfirmButton.backgroundColor = canConfirm ? pastryPalette.berryTint : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        vanillaConfirmButton.setTitleColor(canConfirm ? .white : UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1), for: .normal)
    }

    func textViewDidChange(_ textView: UITextView) {
        tastingHint.isHidden = !textView.text.isEmpty
        refreshVanillaState()
    }

    private func observeTastingKeys() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftForTastingKeys(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropFromTastingKeys), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftForTastingKeys(_ note: Notification) {
        guard let frameValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, bounds.maxY - frameValue.minY - safeAreaInsets.bottom)
        panelLowerConstraint?.constant = -overlap
        UIView.animate(withDuration: 0.24) {
            self.layoutIfNeeded()
        }
    }

    @objc private func dropFromTastingKeys() {
        panelLowerConstraint?.constant = 0
        UIView.animate(withDuration: 0.24) {
            self.layoutIfNeeded()
        }
    }

    @objc private func confirmVanillaChoice() {
        guard let flavor = chosenFlavor else { return }
        let packet = tastingPassportEdition(
            glazeNotebookEdition: shopPinKey,
            rainbowSprinkleDesign: flavor.flavorLibraryEdition,
            flavorMenuGuide: flavor.pastryDisplayShowcase,
            tastingTrayNotes: tastingBox.text,
            glazeSheenIndex: Date().timeIntervalSince1970
        )
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: self, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.pralineSubmitAction?(packet)
        }
    }

    @objc private func closePastrySheet() {
        endEditing(true)
        pralineDismissAction?()
    }

    private func makeTastingLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let pastryLabel = UILabel()
        pastryLabel.translatesAutoresizingMaskIntoConstraints = false
        pastryLabel.text = text
        pastryLabel.font = .systemFont(ofSize: size, weight: weight)
        pastryLabel.textColor = color
        pastryLabel.adjustsFontSizeToFitWidth = true
        pastryLabel.minimumScaleFactor = 0.82
        return pastryLabel
    }
}

final class WevVGlazeContentReportSheet: UIView, UITextViewDelegate {
    private let frostingBackdrop = UIControl()
    private let pastryCard = UIView()
    private let tastingBox = UITextView()
    private let tastingHint = UILabel()
    private let confirmButton = UIButton(type: .system)
    private let dismissButton = UIButton(type: .system)
    private var cardVerticalConstraint: NSLayoutConstraint?

    var pralineDismissAction: (() -> Void)?
    var pralineSubmitAction: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        buildTastingReportSheet()
        observeTastingKeys()
    }

    required init?(coder: NSCoder) { nil }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        alpha = 0
        pastryCard.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1
            self.pastryCard.transform = .identity
        }
    }

    private func buildTastingReportSheet() {
        frostingBackdrop.translatesAutoresizingMaskIntoConstraints = false
        frostingBackdrop.backgroundColor = UIColor.black.withAlphaComponent(0.58)
        frostingBackdrop.addTarget(self, action: #selector(cancelTastingReport), for: .touchUpInside)
        addSubview(frostingBackdrop)

        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 16
        pastryCard.clipsToBounds = true
        addSubview(pastryCard)

        let notice = makeTastingNotice("Are you sure you want to report this content? Please provide a brief reason for your report.", size: 12, weight: .medium, color: pastryPalette.cocoaInk)
        notice.textAlignment = .center
        notice.numberOfLines = 0

        tastingBox.translatesAutoresizingMaskIntoConstraints = false
        tastingBox.backgroundColor = pastryPalette.pastryField
        tastingBox.layer.cornerRadius = 8
        tastingBox.font = .systemFont(ofSize: 12, weight: .regular)
        tastingBox.textColor = pastryPalette.cocoaInk
        tastingBox.textContainerInset = UIEdgeInsets(top: 12, left: 11, bottom: 10, right: 11)
        tastingBox.delegate = self

        tastingHint.translatesAutoresizingMaskIntoConstraints = false
        tastingHint.text = "Enter your reason here..."
        tastingHint.font = .systemFont(ofSize: 12, weight: .regular)
        tastingHint.textColor = UIColor(red: 0.67, green: 0.65, blue: 0.68, alpha: 1)

        configureTastingButton(confirmButton, title: "Submit Report", fill: pastryPalette.berryTint, titleColor: .white)
        configureTastingButton(dismissButton, title: "Cancel", fill: UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1), titleColor: pastryPalette.cocoaInk)
        confirmButton.addTarget(self, action: #selector(submitTastingReport), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(cancelTastingReport), for: .touchUpInside)

        [notice, tastingBox, tastingHint, confirmButton, dismissButton].forEach(pastryCard.addSubview)
        let centerY = pastryCard.centerYAnchor.constraint(equalTo: centerYAnchor)
        cardVerticalConstraint = centerY
        let preferredWidth = pastryCard.widthAnchor.constraint(equalToConstant: 304)
        preferredWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            frostingBackdrop.topAnchor.constraint(equalTo: topAnchor),
            frostingBackdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            frostingBackdrop.trailingAnchor.constraint(equalTo: trailingAnchor),
            frostingBackdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerY,
            preferredWidth,
            pastryCard.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            pastryCard.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
            notice.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 20),
            notice.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            notice.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            tastingBox.topAnchor.constraint(equalTo: notice.bottomAnchor, constant: 15),
            tastingBox.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 16),
            tastingBox.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -16),
            tastingBox.heightAnchor.constraint(equalToConstant: 88),
            tastingHint.topAnchor.constraint(equalTo: tastingBox.topAnchor, constant: 12),
            tastingHint.leadingAnchor.constraint(equalTo: tastingBox.leadingAnchor, constant: 15),
            tastingHint.trailingAnchor.constraint(equalTo: tastingBox.trailingAnchor, constant: -12),
            confirmButton.topAnchor.constraint(equalTo: tastingBox.bottomAnchor, constant: 14),
            confirmButton.leadingAnchor.constraint(equalTo: tastingBox.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: tastingBox.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 38),
            dismissButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 9),
            dismissButton.leadingAnchor.constraint(equalTo: tastingBox.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: tastingBox.trailingAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 38),
            dismissButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -16)
        ])
    }

    private func makeTastingNotice(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let notice = UILabel()
        notice.translatesAutoresizingMaskIntoConstraints = false
        notice.text = text
        notice.font = .systemFont(ofSize: size, weight: weight)
        notice.textColor = color
        return notice
    }

    private func configureTastingButton(_ button: UIButton, title: String, fill: UIColor, titleColor: UIColor) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = fill
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.layer.cornerRadius = 19
    }

    func textViewDidChange(_ textView: UITextView) {
        tastingHint.isHidden = !textView.text.isEmpty
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let current = textView.text, let textRange = Range(range, in: current) else { return false }
        return current.replacingCharacters(in: textRange, with: text).count <= 200
    }

    private func observeTastingKeys() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftForTastingKeys(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropFromTastingKeys), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftForTastingKeys(_ note: Notification) {
        guard let frameValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        layoutIfNeeded()
        let keyboardFrame = convert(frameValue, from: nil)
        let overlap = max(0, pastryCard.frame.maxY + 12 - keyboardFrame.minY)
        cardVerticalConstraint?.constant = -overlap
        UIView.animate(withDuration: 0.24) { self.layoutIfNeeded() }
    }

    @objc private func dropFromTastingKeys() {
        cardVerticalConstraint?.constant = 0
        UIView.animate(withDuration: 0.24) { self.layoutIfNeeded() }
    }

    @objc private func submitTastingReport() {
        let tastingNote = tastingBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !tastingNote.isEmpty else {
            tastingBox.becomeFirstResponder()
            return
        }
        endEditing(true)
        pralineSubmitAction?(tastingNote)
    }

    @objc private func cancelTastingReport() {
        endEditing(true)
        pralineDismissAction?()
    }
}
