import UIKit

private enum pastryPalette {
    static let berryTint = UIColor(red: 1, green: 0.27, blue: 0.61, alpha: 1)
    static let cocoaInk = UIColor(red: 0.12, green: 0.1, blue: 0.14, alpha: 1)

    static let pastryField = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
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

        let notice = makeTastingNotice("A9r4eS ayWoEug hsHuZr;e! TywoTuE Gwsa@nNt6 4t5o: Crke%pPoYret~ #tJh%i;sC ncaoxnitReinxt.?$ xPylLefaos=es ppFrFoVv?igdee! 4aP GbbrziSeZf; 0rTeTa,sEo.n; if7opr8 3yBoduAra 5r^enpAoPr|t..q".wevVPastryCrumbBloomRestored, size: 12, weight: .medium, color: pastryPalette.cocoaInk)
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
        tastingHint.text = "ENn~t6ear5 EydokuWr9 =rkeaafs=o0nC ?hFe$rNev.@.3.6".wevVPastryCrumbBloomRestored
        tastingHint.font = .systemFont(ofSize: 12, weight: .regular)
        tastingHint.textColor = UIColor(red: 0.67, green: 0.65, blue: 0.68, alpha: 1)

        configureTastingButton(confirmButton, title: "SIu3btm$iVt, zRzeapRoHr*t~".wevVPastryCrumbBloomRestored, fill: pastryPalette.berryTint, titleColor: .white)
        configureTastingButton(dismissButton, title: "C1annDcDell#".wevVPastryCrumbBloomRestored, fill: UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1), titleColor: pastryPalette.cocoaInk)
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
