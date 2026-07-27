import UIKit

final class WevVGlazeSafetySheet: UIView, UITextViewDelegate {
    private let shadeLayer = UIControl()
    private let sugarPanel = UIView()
    private let choiceStack = UIStackView()
    private let creamBox = UITextView()
    private let creamHint = UILabel()
    private let confirmButton = UIButton(type: .system)
    private let choices: [WevVGlazeSafetyChoice]
    private var selectedChoice: WevVGlazeSafetyChoice?
    private var rowButtons: [String: UIButton] = [:]
    private var panelBottom: NSLayoutConstraint?

    var onClose: (() -> Void)?
    var onConfirm: ((WevVGlazeSafetyPacket) -> Void)?

    init(shopKey: String, choices: [WevVGlazeSafetyChoice]) {
        self.choices = choices
        self.shopKey = shopKey
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

    private let shopKey: String

    private func buildGlazeSheet() {
        shadeLayer.translatesAutoresizingMaskIntoConstraints = false
        shadeLayer.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        shadeLayer.addTarget(self, action: #selector(closeSugarSheet), for: .touchUpInside)
        addSubview(shadeLayer)

        sugarPanel.translatesAutoresizingMaskIntoConstraints = false
        sugarPanel.backgroundColor = .white
        sugarPanel.layer.cornerRadius = 0
        addSubview(sugarPanel)

        let title = makeCreamLabel("Report", size: 15, weight: .heavy, color: .black)
        title.textAlignment = .center

        let hint = makeCreamLabel("Please select the reason for reporting this user:", size: 12, weight: .regular, color: UIColor(red: 0.42, green: 0.38, blue: 0.42, alpha: 1))
        hint.textAlignment = .center
        hint.numberOfLines = 2

        choiceStack.translatesAutoresizingMaskIntoConstraints = false
        choiceStack.axis = .vertical
        choiceStack.spacing = 0

        for choice in choices {
            let row = makeChoiceRow(choice)
            choiceStack.addArrangedSubview(row)
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
        creamHint.text = "Enter your reason here ..."
        creamHint.font = .systemFont(ofSize: 12, weight: .medium)
        creamHint.textColor = UIColor(red: 0.75, green: 0.72, blue: 0.75, alpha: 1)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        confirmButton.layer.cornerRadius = 24
        confirmButton.addTarget(self, action: #selector(confirmSugarChoice), for: .touchUpInside)

        sugarPanel.addSubview(title)
        sugarPanel.addSubview(hint)
        sugarPanel.addSubview(choiceStack)
        sugarPanel.addSubview(creamBox)
        sugarPanel.addSubview(creamHint)
        sugarPanel.addSubview(confirmButton)

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
            confirmButton.topAnchor.constraint(equalTo: creamBox.bottomAnchor, constant: 17),
            confirmButton.leadingAnchor.constraint(equalTo: sugarPanel.leadingAnchor, constant: 25),
            confirmButton.trailingAnchor.constraint(equalTo: sugarPanel.trailingAnchor, constant: -25),
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    private func makeChoiceRow(_ choice: WevVGlazeSafetyChoice) -> UIControl {
        let row = UIControl()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.addAction(UIAction { [weak self] _ in
            self?.selectGlazeChoice(choice)
        }, for: .touchUpInside)

        let mark = UIButton(type: .system)
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.isUserInteractionEnabled = false
        mark.tintColor = .black
        mark.setImage(UIImage(systemName: "circle"), for: .normal)
        rowButtons[choice.sugarKey] = mark

        let label = makeCreamLabel(choice.title, size: 13, weight: .medium, color: UIColor(red: 0.14, green: 0.12, blue: 0.15, alpha: 1))
        label.numberOfLines = 2

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 0.91, green: 0.9, blue: 0.91, alpha: 1)

        row.addSubview(mark)
        row.addSubview(label)
        row.addSubview(line)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 40),
            mark.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 29),
            mark.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            mark.widthAnchor.constraint(equalToConstant: 16),
            mark.heightAnchor.constraint(equalToConstant: 16),
            label.leadingAnchor.constraint(equalTo: mark.trailingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -28),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            line.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        return row
    }

    private func selectGlazeChoice(_ choice: WevVGlazeSafetyChoice) {
        selectedChoice = choice
        for sugarChoice in choices {
            let imageName = sugarChoice.sugarKey == choice.sugarKey ? "largecircle.fill.circle" : "circle"
            rowButtons[sugarChoice.sugarKey]?.setImage(UIImage(systemName: imageName), for: .normal)
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
        confirmButton.isEnabled = canConfirm
        confirmButton.backgroundColor = canConfirm ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        confirmButton.setTitleColor(canConfirm ? .white : UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1), for: .normal)
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
            shopKey: shopKey,
            choiceKey: choice.sugarKey,
            choiceTitle: choice.title,
            creamText: creamBox.text,
            sugarMoment: Date().timeIntervalSince1970
        )
        onConfirm?(packet)
    }

    @objc private func closeSugarSheet() {
        endEditing(true)
        onClose?()
    }

    private func makeCreamLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.82
        return label
    }
}
