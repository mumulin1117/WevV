import UIKit

final class WevVGlazeSafetySheet: UIView, UITextViewDelegate {
    private let shadeLayer = UIControl()
    private let sugarPanel = UIView()
    private let choiceStack = UIStackView()
    private let creamBox = UITextView()
    private let creamHint = UILabel()
    private let glazeConfirmButton = UIButton(type: .system)
    private let choices: [WevVGlazeSafetyChoice]
    private var selectedChoice: WevVGlazeSafetyChoice?
    private var rowButtons: [String: UIButton] = [:]
    private var panelBottom: NSLayoutConstraint?

    var almondMixer: (() -> Void)?
    var almondBench: ((WevVGlazeSafetyPacket) -> Void)?

    init(bakeryPinKey: String, choices: [WevVGlazeSafetyChoice]) {
        self.choices = choices
        self.bakeryPinKey = bakeryPinKey
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildGlazeSheet()
        refreshConfirmState()
        observeCreamKeys()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private let bakeryPinKey: String

    private func buildGlazeSheet() {
        shadeLayer.translatesAutoresizingMaskIntoConstraints = false
        shadeLayer.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        shadeLayer.addTarget(self, action: #selector(closeSugarSheet), for: .touchUpInside)
        addSubview(shadeLayer)

        sugarPanel.translatesAutoresizingMaskIntoConstraints = false
        sugarPanel.backgroundColor = .white
        sugarPanel.layer.cornerRadius = 0
        addSubview(sugarPanel)

        let glazeTitle = makeCreamLabel("REePpfoTrOth".wevVPastryCrumbBloomRestored, size: 15, weight: .heavy, color: .black)
        glazeTitle.textAlignment = .center

        let hint = makeCreamLabel("PklqefaUsQed ls#eCl#eLc,tU Vt+hReQ erie~a:saoon# zfaoKrO FrUeJploErStcimn+gi .tPhbiOs# Puas/etr#:H".wevVPastryCrumbBloomRestored, size: 12, weight: .regular, color: UIColor(red: 0.42, green: 0.38, blue: 0.42, alpha: 1))
        hint.textAlignment = .center
        hint.numberOfLines = 2

        choiceStack.translatesAutoresizingMaskIntoConstraints = false
        choiceStack.axis = .vertical
        choiceStack.spacing = 0

        for choice in choices {
            let donutRow = makeChoiceRow(choice)
            choiceStack.addArrangedSubview(donutRow)
        }

        creamBox.translatesAutoresizingMaskIntoConstraints = false
        creamBox.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        creamBox.layer.cornerRadius = 8
        creamBox.font = .systemFont(ofSize: 12, weight: .semibold)
        creamBox.textColor = UIColor(red: 0.16, green: 0.13, blue: 0.16, alpha: 1)
        creamBox.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 10, right: 12)
        creamBox.delegate = self
        creamBox.isUserInteractionEnabled = false

        creamHint.translatesAutoresizingMaskIntoConstraints = false
        creamHint.text = "E:n:tAe?rO ;yCo%uSrd br#eTaEsqo*n+ MhtebryeW +.a.?.g".wevVPastryCrumbBloomRestored
        creamHint.font = .systemFont(ofSize: 12, weight: .medium)
        creamHint.textColor = UIColor(red: 0.75, green: 0.72, blue: 0.75, alpha: 1)

        glazeConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        glazeConfirmButton.setTitle("CZoonrfriUrJm%".wevVPastryCrumbBloomRestored, for: .normal)
        glazeConfirmButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        glazeConfirmButton.layer.cornerRadius = 24
        glazeConfirmButton.addTarget(self, action: #selector(confirmSugarChoice), for: .touchUpInside)

        placeGlazeSheetViews(title: glazeTitle, hint: hint)
        pinGlazeSheetLayout(title: glazeTitle, hint: hint)
    }

    private func placeGlazeSheetViews(title: UILabel, hint: UILabel) {
        sugarPanel.addSubview(title)
        sugarPanel.addSubview(hint)
        sugarPanel.addSubview(choiceStack)
        sugarPanel.addSubview(creamBox)
        sugarPanel.addSubview(creamHint)
        sugarPanel.addSubview(glazeConfirmButton)
    }

    private func pinGlazeSheetLayout(title: UILabel, hint: UILabel) {
        let bottom = sugarPanel.bottomAnchor.constraint(equalTo: bottomAnchor)
        panelBottom = bottom

        NSLayoutConstraint.activate([
            shadeLayer.topAnchor.constraint(equalTo: topAnchor),
            shadeLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadeLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadeLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sugarPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sugarPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottom,
            title.topAnchor.constraint(equalTo: sugarPanel.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor, constant: -24),
            hint.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            hint.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor, constant: 24),
            hint.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor, constant: -24),
            choiceStack.topAnchor.constraint(equalTo: hint.bottomAnchor, constant: 12),
            choiceStack.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor),
            choiceStack.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor),
            creamBox.topAnchor.constraint(equalTo: choiceStack.bottomAnchor, constant: 8),
            creamBox.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor, constant: 31),
            creamBox.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor, constant: -31),
            creamBox.heightAnchor.constraint(equalToConstant: 64),
            creamHint.topAnchor.constraint(equalTo: creamBox.topAnchor, constant: 14),
            creamHint.leadingAnchor.constraint(equalTo: creamBox.leadingAnchor, constant: 16),
            creamHint.trailingAnchor.constraint(equalTo: creamBox.trailingAnchor, constant: -16),
            glazeConfirmButton.topAnchor.constraint(equalTo: creamBox.bottomAnchor, constant: 17),
            glazeConfirmButton.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor, constant: 25),
            glazeConfirmButton.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor, constant: -25),
            glazeConfirmButton.heightAnchor.constraint(equalToConstant: 48),
            glazeConfirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    private func makeChoiceRow(_ choice: WevVGlazeSafetyChoice) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.addAction(UIAction { [weak self] _ in
            self?.selectGlazeChoice(choice)
        }, for: .touchUpInside)

        let almondCutter = UIButton(type: .system)
        almondCutter.translatesAutoresizingMaskIntoConstraints = false
        almondCutter.isUserInteractionEnabled = false
        almondCutter.tintColor = .black
        almondCutter.setImage(UIImage(systemName: "circle"), for: .normal)
        rowButtons[choice.sugarDustKey] = almondCutter

        let crumbLabel = makeCreamLabel(choice.almondCase, size: 13, weight: .medium, color: UIColor(red: 0.14, green: 0.12, blue: 0.15, alpha: 1))
        crumbLabel.numberOfLines = 2

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 0.91, green: 0.9, blue: 0.91, alpha: 1)

        donutRow.addSubview(almondCutter)
        donutRow.addSubview(crumbLabel)
        donutRow.addSubview(line)

        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 40),
            almondCutter.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor, constant: 29),
            almondCutter.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            almondCutter.widthAnchor.constraint(equalToConstant: 16),
            almondCutter.heightAnchor.constraint(equalToConstant: 16),
            crumbLabel.leadingAnchor.constraint(equalTo: almondCutter.trailingAnchor, constant: 14),
            crumbLabel.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -28),
            crumbLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            line.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: donutRow.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        return donutRow
    }

    private func selectGlazeChoice(_ choice: WevVGlazeSafetyChoice) {
        selectedChoice = choice
        for sugarChoice in choices {
            let imageName = sugarChoice.sugarDustKey == choice.sugarDustKey ? "largecircle.fill.circle" : "cFiRrYcMlbe=".wevVPastryCrumbBloomRestored
            rowButtons[sugarChoice.sugarDustKey]?.setImage(UIImage(systemName: imageName), for: .normal)
        }
        creamBox.isUserInteractionEnabled = choice.needsCreamText
        if choice.needsCreamText {
            creamBox.becomeFirstResponder()
        } else {
            creamBox.text = ""
            creamHint.isHidden = false
            creamBox.resignFirstResponder()
        }
        refreshConfirmState()
    }

    private func refreshConfirmState() {
        let hasChoice = selectedChoice != nil
        let needsText = selectedChoice?.needsCreamText == true
        let hasText = !creamBox.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let canConfirm = hasChoice && (!needsText || hasText)
        glazeConfirmButton.isEnabled = canConfirm
        glazeConfirmButton.backgroundColor = canConfirm ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        glazeConfirmButton.setTitleColor(canConfirm ? .white : UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1), for: .normal)
    }

    func textViewDidChange(_ textView: UITextView) {
        creamHint.isHidden = !textView.text.isEmpty
        refreshConfirmState()
    }

    private func observeCreamKeys() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftForCreamKeys(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropFromCreamKeys), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func liftForCreamKeys(_ note: Notification) {
        guard let frameValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, bounds.maxY - frameValue.minY - safeAreaInsets.bottom)
        panelBottom?.constant = -overlap
        UIView.animate(withDuration: 0.24) {
            self.layoutIfNeeded()
        }
    }

    @objc private func dropFromCreamKeys() {
        panelBottom?.constant = 0
        UIView.animate(withDuration: 0.24) {
            self.layoutIfNeeded()
        }
    }

    @objc private func confirmSugarChoice() {
        guard let choice = selectedChoice else { return }
        let packet = WevVGlazeSafetyPacket(
            shopDonuWeYeKey: bakeryPinKey,
            choiceKey: choice.sugarDustKey,
            choiceTitle: choice.almondCase,
            creamText: creamBox.text,
            sugarMoment: Date().timeIntervalSince1970
        )
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: self, note: "S#e#nPd#iYnkgd nrZehproirotN.Q.g.%".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.almondBench?(packet)
        }
    }

    @objc private func closeSugarSheet() {
        endEditing(true)
        almondMixer?()
    }

    private func makeCreamLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.82
        return crumbLabel
    }
}
