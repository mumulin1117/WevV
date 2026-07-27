import UIKit

final class WevVCrumbReviewController: UIViewController, UITextViewDelegate {
    private let shopKey: String
    private let glazeSession = WevVGlazeSessionStore.shared
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let noteBox = UITextView()
    private let hintLabel = UILabel()
    private let postButton = WevVGlazePillButton(title: "Post")
    private var starButtons: [UIButton] = []
    private var crumbRating = 3

    var onCrumbPosted: (() -> Void)?

    init(shopKey: String) {
        self.shopKey = shopKey
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildCreamBackdrop()
        buildCreamScroll()
        buildCrumbForm()
        buildCreamPostBar()
        refreshStarRow()
        bindCreamKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildCreamBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.98, alpha: 1)
    }

    private func buildCreamScroll() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.alwaysBounceVertical = true
        frostingScroll.showsVerticalScrollIndicator = false
        frostingScroll.keyboardDismissMode = .interactive
        frostingScroll.contentInset.bottom = 132
        frostingScroll.verticalScrollIndicatorInsets.bottom = 132
        view.addSubview(frostingScroll)

        sprinkleContent.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.addSubview(sprinkleContent)

        NSLayoutConstraint.activate([
            frostingScroll.topAnchor.constraint(equalTo: view.topAnchor),
            frostingScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sprinkleContent.topAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.topAnchor),
            sprinkleContent.leadingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.leadingAnchor),
            sprinkleContent.trailingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.trailingAnchor),
            sprinkleContent.bottomAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.bottomAnchor),
            sprinkleContent.widthAnchor.constraint(equalTo: frostingScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildCrumbForm() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeCrumbForm), for: .touchUpInside)

        let navTitle = makeCreamLabel("Review", size: 25, weight: .bold, color: .black)
        navTitle.textAlignment = .center

        let sectionTitle = makeCreamLabel("Review", size: 20, weight: .bold, color: .black)

        noteBox.translatesAutoresizingMaskIntoConstraints = false
        noteBox.backgroundColor = .white
        noteBox.layer.cornerRadius = 12
        noteBox.font = .systemFont(ofSize: 18, weight: .regular)
        noteBox.textColor = .black
        noteBox.textContainerInset = UIEdgeInsets(top: 24, left: 22, bottom: 22, right: 22)
        noteBox.delegate = self

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Say Something"
        hintLabel.font = .systemFont(ofSize: 19, weight: .regular)
        hintLabel.textColor = UIColor(red: 0.7, green: 0.68, blue: 0.7, alpha: 1)
        noteBox.addSubview(hintLabel)

        let ratingTitle = makeCreamLabel("Rating", size: 20, weight: .bold, color: .black)

        let starRow = UIStackView()
        starRow.translatesAutoresizingMaskIntoConstraints = false
        starRow.axis = .horizontal
        starRow.distribution = .equalSpacing
        starRow.alignment = .center

        for index in 1...5 {
            let star = UIButton(type: .system)
            star.translatesAutoresizingMaskIntoConstraints = false
            star.tag = index
            star.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star.addTarget(self, action: #selector(selectCrumbStar(_:)), for: .touchUpInside)
            starRow.addArrangedSubview(star)
            star.widthAnchor.constraint(equalToConstant: 58).isActive = true
            star.heightAnchor.constraint(equalToConstant: 58).isActive = true
            starButtons.append(star)
        }

        sprinkleContent.addSubview(backButton)
        sprinkleContent.addSubview(navTitle)
        sprinkleContent.addSubview(sectionTitle)
        sprinkleContent.addSubview(noteBox)
        sprinkleContent.addSubview(ratingTitle)
        sprinkleContent.addSubview(starRow)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 58),
            backButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 22),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            navTitle.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            navTitle.centerXAnchor.constraint(equalTo: sprinkleContent.centerXAnchor),
            navTitle.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            sectionTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            sectionTitle.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 24),
            sectionTitle.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -24),
            noteBox.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 24),
            noteBox.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            noteBox.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            noteBox.heightAnchor.constraint(equalTo: noteBox.widthAnchor, multiplier: 0.55),
            hintLabel.topAnchor.constraint(equalTo: noteBox.topAnchor, constant: 25),
            hintLabel.leadingAnchor.constraint(equalTo: noteBox.leadingAnchor, constant: 25),
            hintLabel.trailingAnchor.constraint(equalTo: noteBox.trailingAnchor, constant: -25),
            ratingTitle.topAnchor.constraint(equalTo: noteBox.bottomAnchor, constant: 30),
            ratingTitle.leadingAnchor.constraint(equalTo: sectionTitle.leadingAnchor),
            ratingTitle.trailingAnchor.constraint(equalTo: sectionTitle.trailingAnchor),
            starRow.topAnchor.constraint(equalTo: ratingTitle.bottomAnchor, constant: 26),
            starRow.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 25),
            starRow.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -25),
            starRow.heightAnchor.constraint(equalToConstant: 72),
            starRow.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor, constant: -280)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(tuckCreamKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func buildCreamPostBar() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.98, alpha: 0.96)
        view.addSubview(bar)

        postButton.addTarget(self, action: #selector(postCrumbNote), for: .touchUpInside)
        bar.addSubview(postButton)

        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bar.heightAnchor.constraint(equalToConstant: 118),
            postButton.topAnchor.constraint(equalTo: bar.topAnchor, constant: 15),
            postButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 25),
            postButton.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -25),
            postButton.heightAnchor.constraint(equalToConstant: 52)
        ])
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

    private func refreshStarRow() {
        for star in starButtons {
            star.tintColor = star.tag <= crumbRating
                ? UIColor(red: 1, green: 0.9, blue: 0.02, alpha: 1)
                : UIColor(red: 0.81, green: 0.78, blue: 0.8, alpha: 1)
            star.transform = star.tag <= crumbRating ? CGAffineTransform(scaleX: 1.06, y: 1.06) : .identity
        }
    }

    private func bindCreamKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftCreamForm(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settleCreamForm(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        hintLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func selectCrumbStar(_ sender: UIButton) {
        crumbRating = max(1, min(5, sender.tag))
        refreshStarRow()
    }

    @objc private func postCrumbNote() {
        let cleanText = noteBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        glazeSession.placeCrumbNote(shopKey: shopKey, rating: crumbRating, text: cleanText.isEmpty ? "Sweet glaze visit" : cleanText)
        onCrumbPosted?()
        dismiss(animated: true)
    }

    @objc private func closeCrumbForm() {
        dismiss(animated: true)
    }

    @objc private func tuckCreamKeyboard() {
        view.endEditing(true)
    }

    @objc private func liftCreamForm(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomLift = frame.height + 20
        frostingScroll.contentInset.bottom = bottomLift + 118
        frostingScroll.verticalScrollIndicatorInsets.bottom = bottomLift + 118
    }

    @objc private func settleCreamForm(_ note: Notification) {
        frostingScroll.contentInset.bottom = 132
        frostingScroll.verticalScrollIndicatorInsets.bottom = 132
    }
}
