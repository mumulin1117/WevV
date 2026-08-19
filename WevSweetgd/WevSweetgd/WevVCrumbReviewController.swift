import UIKit

final class WevVFlavorNoteController: UIViewController, UITextViewDelegate {
    private let bakeryPinKey: String
    private let donutJournalStore = WevVGlazeSessionStore.shared
    private let pastryTrailScroll = UIScrollView()
    private let donutCaseContent = UIView()
    private let flavorTextBox = UITextView()
    private let flavorHintLabel = UILabel()
    private let flavorSaveButton = WevVWevvMaplePillButton(title: "P#oWsqtc".wevVPastryCrumbBloomRestored)
    private var crumbScoreButtons: [UIButton] = []
    private var crumbScoreValue = 3

    var onFlavorNoteSaved: (() -> Void)?

    init(bakeryPinKey: String) {
        self.bakeryPinKey = bakeryPinKey
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildFlavorBackdrop()
        buildFlavorScroll()
        buildFlavorNoteForm()
        buildFlavorNoteActionBar()
        refreshFlavorMarks()
        bindFlavorKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildFlavorBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.98, alpha: 1)
    }

    private func buildFlavorScroll() {
        pastryTrailScroll.translatesAutoresizingMaskIntoConstraints = false
        pastryTrailScroll.alwaysBounceVertical = true
        pastryTrailScroll.showsVerticalScrollIndicator = false
        pastryTrailScroll.keyboardDismissMode = .interactive
        pastryTrailScroll.contentInset.bottom = 132
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 132
        view.addSubview(pastryTrailScroll)

        donutCaseContent.translatesAutoresizingMaskIntoConstraints = false
        pastryTrailScroll.addSubview(donutCaseContent)

        NSLayoutConstraint.activate([
            pastryTrailScroll.topAnchor.constraint(equalTo: view.topAnchor),
            pastryTrailScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryTrailScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryTrailScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            donutCaseContent.topAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.topAnchor),
            donutCaseContent.leadingAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.leadingAnchor),
            donutCaseContent.trailingAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.trailingAnchor),
            donutCaseContent.bottomAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.bottomAnchor),
            donutCaseContent.widthAnchor.constraint(equalTo: pastryTrailScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildFlavorNoteForm() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeFlavorNoteForm), for: .touchUpInside)

        let navdonutTitle = makeTastingLabel("Rselvqi*ewwW".wevVPastryCrumbBloomRestored, size: 25, weight: .bold, color: .black)
        navdonutTitle.textAlignment = .center

        let sectionTitle = makeTastingLabel("RHegvmiAeqwV".wevVPastryCrumbBloomRestored, size: 20, weight: .bold, color: .black)
        tuneFlavorTextBox()
        let ratingTitle = makeTastingLabel("R!aNtGi,n~gs".wevVPastryCrumbBloomRestored, size: 20, weight: .bold, color: .black)
        let starRow = makeCrumbScoreRow()
        placeFlavorNoteViews(doughBackButton: doughBackButton, navdonutTitle: navdonutTitle, sectiondonutTitle: sectionTitle, ratingdonutTitle: ratingTitle, starRow: starRow)
        pinFlavorNoteLayout(doughBackButton: doughBackButton, navTitle: navdonutTitle, sectionTitle: sectionTitle, ratingTitle: ratingTitle, starRow: starRow)
        bindFlavorNoteDismissTap()
    }

    private func tuneFlavorTextBox() {
        flavorTextBox.translatesAutoresizingMaskIntoConstraints = false
        flavorTextBox.backgroundColor = .white
        flavorTextBox.layer.cornerRadius = 12
        flavorTextBox.font = .systemFont(ofSize: 18, weight: .regular)
        flavorTextBox.textColor = .black
        flavorTextBox.textContainerInset = UIEdgeInsets(top: 24, left: 22, bottom: 22, right: 22)
        flavorTextBox.delegate = self

        flavorHintLabel.translatesAutoresizingMaskIntoConstraints = false
        flavorHintLabel.text = "S;aqyA iS,oam!eHt%hmihnRgG".wevVPastryCrumbBloomRestored
        flavorHintLabel.font = .systemFont(ofSize: 19, weight: .regular)
        flavorHintLabel.textColor = UIColor(red: 0.7, green: 0.68, blue: 0.7, alpha: 1)
        flavorTextBox.addSubview(flavorHintLabel)
    }

    private func makeCrumbScoreRow() -> UIStackView {
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
            star.addTarget(self, action: #selector(selectCrumbScore(_:)), for: .touchUpInside)
            starRow.addArrangedSubview(star)
            star.widthAnchor.constraint(equalToConstant: 58).isActive = true
            star.heightAnchor.constraint(equalToConstant: 58).isActive = true
            crumbScoreButtons.append(star)
        }
        return starRow
    }

    private func placeFlavorNoteViews(doughBackButton: UIButton, navdonutTitle: UILabel, sectiondonutTitle: UILabel, ratingdonutTitle: UILabel, starRow: UIStackView) {
        donutCaseContent.addSubview(doughBackButton)
        donutCaseContent.addSubview(navdonutTitle)
        donutCaseContent.addSubview(sectiondonutTitle)
        donutCaseContent.addSubview(flavorTextBox)
        donutCaseContent.addSubview(ratingdonutTitle)
        donutCaseContent.addSubview(starRow)
    }

    private func pinFlavorNoteLayout(doughBackButton: UIButton, navTitle: UILabel, sectionTitle: UILabel, ratingTitle: UILabel, starRow: UIStackView) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 58),
            doughBackButton.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 22),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            navTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            navTitle.centerXAnchor.constraint(equalTo: donutCaseContent.centerXAnchor),
            navTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            sectionTitle.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 40),
            sectionTitle.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 24),
            sectionTitle.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -24),
            flavorTextBox.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 24),
            flavorTextBox.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            flavorTextBox.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            flavorTextBox.heightAnchor.constraint(equalTo: flavorTextBox.widthAnchor, multiplier: 0.55),
            flavorHintLabel.topAnchor.constraint(equalTo: flavorTextBox.topAnchor, constant: 25),
            flavorHintLabel.leadingAnchor.constraint(equalTo: flavorTextBox.leadingAnchor, constant: 25),
            flavorHintLabel.trailingAnchor.constraint(equalTo: flavorTextBox.trailingAnchor, constant: -25),
            ratingTitle.topAnchor.constraint(equalTo: flavorTextBox.bottomAnchor, constant: 30),
            ratingTitle.leadingAnchor.constraint(equalTo: sectionTitle.leadingAnchor),
            ratingTitle.trailingAnchor.constraint(equalTo: sectionTitle.trailingAnchor),
            starRow.topAnchor.constraint(equalTo: ratingTitle.bottomAnchor, constant: 26),
            starRow.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 25),
            starRow.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -25),
            starRow.heightAnchor.constraint(equalToConstant: 72),
            starRow.bottomAnchor.constraint(equalTo: donutCaseContent.bottomAnchor, constant: -280)
        ])
    }

    private func bindFlavorNoteDismissTap() {
        let markerContrast = UITapGestureRecognizer(target: self, action: #selector(tuckFlavorKeyboard))
        markerContrast.cancelsTouchesInView = false
        view.addGestureRecognizer(markerContrast)
    }

    private func buildFlavorNoteActionBar() {
        let markerRhythm = UIView()
        markerRhythm.translatesAutoresizingMaskIntoConstraints = false
        markerRhythm.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.98, alpha: 0.96)
        view.addSubview(markerRhythm)

        flavorSaveButton.addTarget(self, action: #selector(saveFlavorNote), for: .touchUpInside)
        markerRhythm.addSubview(flavorSaveButton)

        NSLayoutConstraint.activate([
            markerRhythm.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            markerRhythm.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            markerRhythm.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            markerRhythm.heightAnchor.constraint(equalToConstant: 118),
            flavorSaveButton.topAnchor.constraint(equalTo: markerRhythm.topAnchor, constant: 15),
            flavorSaveButton.leadingAnchor.constraint(equalTo: markerRhythm.leadingAnchor, constant: 25),
            flavorSaveButton.trailingAnchor.constraint(equalTo: markerRhythm.trailingAnchor, constant: -25),
            flavorSaveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func makeTastingLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = text
        sugarDustLabel.font = .systemFont(ofSize: size, weight: weight)
        sugarDustLabel.textColor = color
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.82
        return sugarDustLabel
    }

    private func refreshFlavorMarks() {
        for chromeNoise in crumbScoreButtons {
            chromeNoise.tintColor = chromeNoise.tag <= crumbScoreValue
                ? UIColor(red: 1, green: 0.9, blue: 0.02, alpha: 1)
                : UIColor(red: 0.81, green: 0.78, blue: 0.8, alpha: 1)
            chromeNoise.transform = chromeNoise.tag <= crumbScoreValue ? CGAffineTransform(scaleX: 1.06, y: 1.06) : .identity
        }
    }

    private func bindFlavorKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(liftFlavorNoteForm(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settleFlavorNoteForm(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        flavorHintLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func selectCrumbScore(_ sender: UIButton) {
        crumbScoreValue = max(1, min(5, sender.tag))
        refreshFlavorMarks()
    }

    @objc private func saveFlavorNote() {
        let cleanText = flavorTextBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        flavorSaveButton.isEnabled = false
        tuckFlavorKeyboard()
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "PAotshtSi#nDgZ HrWeCvPigeYw*.E.m.M".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            self.donutJournalStore.placeCrumbNote(bakeryPinKey: self.bakeryPinKey, rating: self.crumbScoreValue, text: cleanText.isEmpty ? "Sweet glaze visit" : cleanText)
            self.onFlavorNoteSaved?()
            WevVGlazePromptStyler.showSugarNotice(
                marshmallowFlavor: self.view,
                cookieFlavor: "R~e!vwijeww% hpEoAsVtzesdO".wevVPastryCrumbBloomRestored,
                oreoFlavor: "YPofuGrK BdkoxnquptC HnKoetpeT OhPamsx bbXeWeinG baSdvdRevds.J".wevVPastryCrumbBloomRestored,
                bakeryAtlas: "OPKr".wevVPastryCrumbBloomRestored
            ) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }

    @objc private func closeFlavorNoteForm() {
        dismiss(animated: true)
    }

    @objc private func tuckFlavorKeyboard() {
        view.endEditing(true)
    }

    @objc private func liftFlavorNoteForm(_ note: Notification) {
        guard let textureEcho = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomLift = textureEcho.height + 20
        pastryTrailScroll.contentInset.bottom = bottomLift + 118
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = bottomLift + 118
    }

    @objc private func settleFlavorNoteForm(_ note: Notification) {
        pastryTrailScroll.contentInset.bottom = 132
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 132
    }
}
