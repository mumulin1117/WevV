import UIKit

final class WevVSprinkleQuestComposerController: UIViewController, UITextViewDelegate {
    var onSprinkleQuestReady: ((WevVSprinkleQuestPacket) -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleField = UITextField()
    private let detailView = UITextView()
    private let detailCountLabel = UILabel()
    private let timeField = UITextField()
    private let placeField = UITextField()
    private let postButton = UIButton(type: .system)
    private let detailPlaceholderText = "Share your sweetest strawberry donut creation."
    private let costValues = [50, 100, 300, 500]
    private var selectedCost = 100
    private var costButtons: [UIButton] = []
    private var detailUsesPlaceholder = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.91, blue: 0.96, alpha: 1)
        buildSprinkleQuestCanvas()
        NotificationCenter.default.addObserver(self, selector: #selector(liftSprinkleCanvas(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropSprinkleCanvas(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildSprinkleQuestCanvas() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeSprinkleQuest), for: .touchUpInside)

        let titleLabel = makeQuestLabel("Publish Challenge", size: 20, weight: .bold)
        titleLabel.textAlignment = .center

        let themeLabel = makeQuestLabel("Challenge Theme", size: 17, weight: .bold)
        let titleCard = makeTitleCard()

        let costLabel = makeQuestLabel("Participation Co" + "ins", size: 17, weight: .bold)
        let costCard = makeCostCard()

        let detailLabel = makeQuestLabel("Introduction", size: 17, weight: .bold)
        let detailCard = makeDetailCard()

        let timeLabel = makeQuestLabel("Time", size: 17, weight: .bold)
        let placeLabel = makeQuestLabel("Loca" + "tion", size: 17, weight: .bold)
        let timeCard = makeSmallFieldCard(field: timeField, text: "Friday · 8:00 PM –\n10:30 PM")
        let placeCard = makeSmallFieldCard(field: placeField, text: "128 Berry Street, San\nFranci...")

        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        postButton.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        postButton.layer.cornerRadius = 26
        postButton.addTarget(self, action: #selector(postSprinkleQuest), for: .touchUpInside)

        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(themeLabel)
        contentView.addSubview(titleCard)
        contentView.addSubview(costLabel)
        contentView.addSubview(costCard)
        contentView.addSubview(detailLabel)
        contentView.addSubview(detailCard)
        contentView.addSubview(timeLabel)
        contentView.addSubview(placeLabel)
        contentView.addSubview(timeCard)
        contentView.addSubview(placeCard)
        contentView.addSubview(postButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            themeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            themeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34),
            titleCard.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 28),
            titleCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34),
            titleCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -34),
            titleCard.heightAnchor.constraint(equalToConstant: 122),
            costLabel.topAnchor.constraint(equalTo: titleCard.bottomAnchor, constant: 30),
            costLabel.leadingAnchor.constraint(equalTo: themeLabel.leadingAnchor),
            costCard.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 30),
            costCard.leadingAnchor.constraint(equalTo: titleCard.leadingAnchor),
            costCard.trailingAnchor.constraint(equalTo: titleCard.trailingAnchor),
            costCard.heightAnchor.constraint(equalToConstant: 78),
            detailLabel.topAnchor.constraint(equalTo: costCard.bottomAnchor, constant: 34),
            detailLabel.leadingAnchor.constraint(equalTo: themeLabel.leadingAnchor),
            detailCard.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 30),
            detailCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 39),
            detailCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            detailCard.heightAnchor.constraint(equalToConstant: 132),
            timeLabel.topAnchor.constraint(equalTo: detailCard.bottomAnchor, constant: 28),
            timeLabel.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 5),
            placeLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 12),
            timeCard.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 28),
            timeCard.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            timeCard.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -12),
            timeCard.heightAnchor.constraint(equalToConstant: 50),
            placeCard.topAnchor.constraint(equalTo: timeCard.topAnchor),
            placeCard.leadingAnchor.constraint(equalTo: placeLabel.leadingAnchor),
            placeCard.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            placeCard.heightAnchor.constraint(equalTo: timeCard.heightAnchor),
            postButton.topAnchor.constraint(equalTo: timeCard.bottomAnchor, constant: 40),
            postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -82),
            postButton.heightAnchor.constraint(equalToConstant: 52),
            postButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])

        refreshCostButtons()
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endQuestEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeTitleCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 46
        card.clipsToBounds = true

        let smallLabel = makeQuestLabel("TITLE", size: 12, weight: .bold)
        smallLabel.textColor = UIColor(red: 0.66, green: 0.56, blue: 0.68, alpha: 1)

        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.text = "Strawberry Sprinkle Week"
        titleField.font = .systemFont(ofSize: 16, weight: .bold)
        titleField.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        titleField.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        titleField.layer.cornerRadius = 25
        titleField.layer.borderWidth = 1.5
        titleField.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 1))
        titleField.leftViewMode = .always

        card.addSubview(smallLabel)
        card.addSubview(titleField)
        NSLayoutConstraint.activate([
            smallLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            smallLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 45),
            titleField.topAnchor.constraint(equalTo: smallLabel.bottomAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 40),
            titleField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -40),
            titleField.heightAnchor.constraint(equalToConstant: 50)
        ])
        return card
    }

    private func makeCostCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 42
        card.clipsToBounds = true

        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 22
        card.addSubview(row)

        for value in costValues {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = value
            button.setTitle("\(value)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.layer.cornerRadius = 24
            button.layer.borderWidth = 1.5
            button.addTarget(self, action: #selector(chooseQuestCost(_:)), for: .touchUpInside)
            costButtons.append(button)
            row.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 34),
            row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -34),
            row.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            row.heightAnchor.constraint(equalToConstant: 48)
        ])
        return card
    }

    private func makeDetailCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        card.layer.cornerRadius = 31
        card.layer.borderWidth = 1.5
        card.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor

        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.delegate = self
        detailView.text = detailPlaceholderText
        detailView.font = .systemFont(ofSize: 15, weight: .bold)
        detailView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailView.backgroundColor = .clear
        detailView.textContainerInset = UIEdgeInsets(top: 30, left: 24, bottom: 28, right: 24)

        detailCountLabel.translatesAutoresizingMaskIntoConstraints = false
        detailCountLabel.text = "0 / 180"
        detailCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        detailCountLabel.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailCountLabel.textAlignment = .right

        card.addSubview(detailView)
        card.addSubview(detailCountLabel)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: card.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            detailCountLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),
            detailCountLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24)
        ])
        return card
    }

    private func makeSmallFieldCard(field: UITextField, text: String) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        card.layer.cornerRadius = 25
        card.layer.borderWidth = 1.5
        card.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor

        field.translatesAutoresizingMaskIntoConstraints = false
        field.text = text
        field.font = .systemFont(ofSize: 14, weight: .bold)
        field.textColor = UIColor(red: 0.47, green: 0.39, blue: 0.48, alpha: 1)
        field.numberOfLinesFallback()

        card.addSubview(field)
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 31),
            field.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            field.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            field.heightAnchor.constraint(equalToConstant: 36)
        ])
        return card
    }

    private func makeQuestLabel(_ text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    private func refreshCostButtons() {
        for button in costButtons {
            let selected = button.tag == selectedCost
            button.backgroundColor = selected ? UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1) : UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
            button.setTitleColor(selected ? .white : UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1), for: .normal)
            button.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !detailUsesPlaceholder else {
            detailCountLabel.text = "0 / 180"
            return
        }
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 180 {
            textView.text = String(text.prefix(180))
        }
        detailCountLabel.text = "\(textView.text.count) / 180"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard detailUsesPlaceholder else { return }
        detailUsesPlaceholder = false
        textView.text = ""
        textView.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        detailCountLabel.text = "0 / 180"
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.isEmpty else { return }
        detailUsesPlaceholder = true
        textView.text = detailPlaceholderText
        textView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailCountLabel.text = "0 / 180"
    }

    @objc private func chooseQuestCost(_ sender: UIButton) {
        selectedCost = sender.tag
        refreshCostButtons()
    }

    @objc private func postSprinkleQuest() {
        guard glazeSession.isTasterReady else {
            showQuestHint("Please sign in first")
            return
        }
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let text = detailUsesPlaceholder ? "" : detailView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let timeText = timeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let placeText = placeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !title.isEmpty else {
            showQuestHint("Add a challenge title")
            return
        }
        guard !text.isEmpty else {
            showQuestHint("Add an introduction")
            return
        }
        guard !timeText.isEmpty else {
            showQuestHint("Add a tasting time")
            return
        }
        guard !placeText.isEmpty else {
            showQuestHint("Add a shop place")
            return
        }
        postButton.isEnabled = false
        postButton.alpha = 0.72
        let packet = glazeSession.placeSprinkleQuest(title: title, text: text, timeText: timeText, placeText: placeText, sugarCost: selectedCost)
        showQuestSuccess(packet)
    }

    @objc private func closeSprinkleQuest() {
        dismiss(animated: true)
    }

    @objc private func endQuestEditing() {
        view.endEditing(true)
    }

    @objc private func liftSprinkleCanvas(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let lift = max(0, frame.height - view.safeAreaInsets.bottom)
        scrollView.contentInset.bottom = lift + 36
        scrollView.verticalScrollIndicatorInsets.bottom = lift + 36
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSprinkleCanvas(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showQuestHint(_ text: String) {
        let hint = UILabel()
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.text = text
        hint.textAlignment = .center
        hint.font = .systemFont(ofSize: 14, weight: .semibold)
        hint.textColor = .white
        hint.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        hint.layer.cornerRadius = 18
        hint.clipsToBounds = true
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            hint.heightAnchor.constraint(equalToConstant: 36),
            hint.widthAnchor.constraint(greaterThanOrEqualToConstant: 230)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.15, options: []) {
            hint.alpha = 0
        } completion: { _ in
            hint.removeFromSuperview()
        }
    }

    private func showQuestSuccess(_ packet: WevVSprinkleQuestPacket) {
        view.endEditing(true)
        let dimLayer = UIControl()
        dimLayer.translatesAutoresizingMaskIntoConstraints = false
        dimLayer.backgroundColor = UIColor.black.withAlphaComponent(0.42)

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.clipsToBounds = true

        let badge = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        badge.contentMode = .scaleAspectFit

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Published"
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        title.textAlignment = .center

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = "Your donut challenge is ready."
        caption.font = .systemFont(ofSize: 13, weight: .medium)
        caption.textColor = UIColor(red: 0.50, green: 0.44, blue: 0.54, alpha: 1)
        caption.textAlignment = .center
        caption.numberOfLines = 2

        view.addSubview(dimLayer)
        dimLayer.addSubview(card)
        card.addSubview(badge)
        card.addSubview(title)
        card.addSubview(caption)

        NSLayoutConstraint.activate([
            dimLayer.topAnchor.constraint(equalTo: view.topAnchor),
            dimLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: dimLayer.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: dimLayer.centerYAnchor),
            card.widthAnchor.constraint(equalToConstant: 254),
            card.heightAnchor.constraint(equalToConstant: 172),
            badge.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            badge.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            badge.widthAnchor.constraint(equalToConstant: 50),
            badge.heightAnchor.constraint(equalToConstant: 50),
            title.topAnchor.constraint(equalTo: badge.bottomAnchor, constant: 14),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            caption.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            caption.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            caption.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24)
        ])

        card.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        card.alpha = 0
        UIView.animate(withDuration: 0.18) {
            card.alpha = 1
            card.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) { [weak self] in
            self?.onSprinkleQuestReady?(packet)
            self?.dismiss(animated: true)
        }
    }
}

private extension UITextField {
    func numberOfLinesFallback() {
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 16
    }
}
