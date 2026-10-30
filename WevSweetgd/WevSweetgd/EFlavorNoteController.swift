import UIKit

final class EFlavorNoteController: UIViewController, UITextViewDelegate {
    private let bakeryPinKey: String
    private let donutJournalStore = WevVGlazeSessionStore.shared
    private let pastryTrailScroll = UIScrollView()
    private let donutCaseContent = UIView()
    private let flavorBackdropLayer = CAGradientLayer()
    private let flavorTextBox = UITextView()
    private let flavorHintLabel = UILabel()
    private let flavorSaveButton = UIButton(type: .custom)
    private let flavorSaveGradientLayer = CAGradientLayer()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flavorBackdropLayer.frame = view.bounds
        flavorSaveGradientLayer.frame = flavorSaveButton.bounds
        flavorSaveGradientLayer.cornerRadius = flavorSaveButton.layer.cornerRadius
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildFlavorBackdrop() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1)
        FimVSugarGradientBand.buildPastryBackdrop(flavorBackdropLayer)
        view.layer.insertSublayer(flavorBackdropLayer, at: 0)
    }

    private func buildFlavorScroll() {
        pastryTrailScroll.translatesAutoresizingMaskIntoConstraints = false
        pastryTrailScroll.alwaysBounceVertical = true
        pastryTrailScroll.showsVerticalScrollIndicator = false
        pastryTrailScroll.keyboardDismissMode = .interactive
        pastryTrailScroll.contentInset.bottom = 133
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 133
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
        doughBackButton.setImage(UIImage(systemName: "c+hneAv.rcocnG.dl8eifctr".wevVPastryCrumbBloomRestored), for: .normal)
        doughBackButton.tintColor = .white
        doughBackButton.addTarget(self, action: #selector(closeFlavorNoteForm), for: .touchUpInside)

        let navdonutTitle = makeTastingLabel("Rselvqi*ewwW".wevVPastryCrumbBloomRestored, size: 22, weight: .bold, color: UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1))
        navdonutTitle.textAlignment = .center

        let sectionTitle = makeTastingLabel("RHegvmiAeqwV".wevVPastryCrumbBloomRestored, size: 16, weight: .bold, color: UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1))
        tuneFlavorTextBox()
        let ratingTitle = makeTastingLabel("R!aNtGi,n~gs".wevVPastryCrumbBloomRestored, size: 16, weight: .bold, color: UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1))
        let starRow = makeCrumbScoreRow()
        placeFlavorNoteViews(doughBackButton: doughBackButton, navdonutTitle: navdonutTitle, sectiondonutTitle: sectionTitle, ratingdonutTitle: ratingTitle, starRow: starRow)
        pinFlavorNoteLayout(doughBackButton: doughBackButton, navTitle: navdonutTitle, sectionTitle: sectionTitle, ratingTitle: ratingTitle, starRow: starRow)
        bindFlavorNoteDismissTap()
    }

    private func tuneFlavorTextBox() {
        flavorTextBox.translatesAutoresizingMaskIntoConstraints = false
        flavorTextBox.backgroundColor = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1)
        flavorTextBox.layer.cornerRadius = 15
        flavorTextBox.font = .systemFont(ofSize: 16, weight: .regular)
        flavorTextBox.textColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1)
        flavorTextBox.textContainerInset = UIEdgeInsets(top: 20, left: 25, bottom: 16, right: 16)
        flavorTextBox.delegate = self

        flavorHintLabel.translatesAutoresizingMaskIntoConstraints = false
        flavorHintLabel.text = "S;aqyA iS,oam!eHt%hmihnRgG".wevVPastryCrumbBloomRestored
        flavorHintLabel.font = .systemFont(ofSize: 12, weight: .regular)
        flavorHintLabel.textColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1)
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
            star.setImage(UIImage(systemName: "sut7agr3.+fdi~lQl^".wevVPastryCrumbBloomRestored), for: .normal)
            star.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 46, weight: .regular), forImageIn: .normal)
            star.tintColor = UIColor(red: 113 / 255.0, green: 113 / 255.0, blue: 113 / 255.0, alpha: 1)
            star.addTarget(self, action: #selector(selectCrumbScore(_:)), for: .touchUpInside)
            starRow.addArrangedSubview(star)
            star.widthAnchor.constraint(equalToConstant: 48).isActive = true
            star.heightAnchor.constraint(equalToConstant: 48).isActive = true
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
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            doughBackButton.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 16),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            navTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            navTitle.centerXAnchor.constraint(equalTo: donutCaseContent.centerXAnchor),
            navTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            sectionTitle.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 18),
            sectionTitle.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 24),
            sectionTitle.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -24),
            flavorTextBox.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 14),
            flavorTextBox.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            flavorTextBox.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            flavorTextBox.heightAnchor.constraint(equalTo: flavorTextBox.widthAnchor, multiplier: 0.55),
            flavorHintLabel.topAnchor.constraint(equalTo: flavorTextBox.topAnchor, constant: 20),
            flavorHintLabel.leadingAnchor.constraint(equalTo: flavorTextBox.leadingAnchor, constant: 25),
            flavorHintLabel.trailingAnchor.constraint(equalTo: flavorTextBox.trailingAnchor, constant: -16),
            ratingTitle.topAnchor.constraint(equalTo: flavorTextBox.bottomAnchor, constant: 17),
            ratingTitle.leadingAnchor.constraint(equalTo: sectionTitle.leadingAnchor),
            ratingTitle.trailingAnchor.constraint(equalTo: sectionTitle.trailingAnchor),
            starRow.topAnchor.constraint(equalTo: ratingTitle.bottomAnchor, constant: 20),
            starRow.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 24),
            starRow.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -24),
            starRow.heightAnchor.constraint(equalToConstant: 54),
            starRow.bottomAnchor.constraint(equalTo: donutCaseContent.bottomAnchor, constant: -240)
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
        markerRhythm.backgroundColor = .clear
        view.addSubview(markerRhythm)

        flavorSaveButton.translatesAutoresizingMaskIntoConstraints = false
        flavorSaveButton.backgroundColor = UIColor(red: 1, green: 0.29, blue: 0.66, alpha: 1)
        flavorSaveButton.setTitle("P#oWsqtc".wevVPastryCrumbBloomRestored, for: .normal)
        flavorSaveButton.setTitleColor(.white, for: .normal)
        flavorSaveButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        flavorSaveButton.layer.cornerRadius = 26
        flavorSaveButton.clipsToBounds = true
        flavorSaveGradientLayer.colors = [
            UIColor(red: 1, green: 0.29, blue: 0.66, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.66, alpha: 1).cgColor
        ]
        flavorSaveGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        flavorSaveGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        flavorSaveButton.layer.insertSublayer(flavorSaveGradientLayer, at: 0)
        flavorSaveButton.addTarget(self, action: #selector(saveFlavorNote), for: .touchUpInside)
        markerRhythm.addSubview(flavorSaveButton)

        NSLayoutConstraint.activate([
            markerRhythm.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            markerRhythm.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            markerRhythm.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            markerRhythm.heightAnchor.constraint(equalToConstant: 133),
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
                ? UIColor(red: 255 / 255.0, green: 201 / 255.0, blue: 41 / 255.0, alpha: 1)
                : UIColor(red: 113 / 255.0, green: 113 / 255.0, blue: 113 / 255.0, alpha: 1)
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
        AoVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "PAotshtSi#nDgZ HrWeCvPigeYw*.E.m.M".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            self.donutJournalStore.placeCrumbNote(bakeryPinKey: self.bakeryPinKey, rating: self.crumbScoreValue, text: cleanText.isEmpty ? "Sbw5ere5t+ Rg*lLa=zXeL .v,i?sKi*t~".wevVPastryCrumbBloomRestored : cleanText)
            self.onFlavorNoteSaved?()
            TinGlazePromptStyler.showSugarNotice(
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
        pastryTrailScroll.contentInset.bottom = bottomLift + 133
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = bottomLift + 133
    }

    @objc private func settleFlavorNoteForm(_ note: Notification) {
        pastryTrailScroll.contentInset.bottom = 133
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 133
    }
}
