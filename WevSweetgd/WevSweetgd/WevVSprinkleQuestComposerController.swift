import UIKit

final class WevVSprinkleQuestComposerController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    private let coverImageView = UIImageView()
    private let coverCameraButton = UIButton(type: .system)
    private let coverShadeView = UIView()
    private let detailPlaceholderText = "SKhDaRrleY KyNoiu~ri Xs;whe;e%tSesshtZ Zs/tPrhaUwlb*eerBrqyp adwoPn&ujty Rc.rgeFaut+i,oBnL.R".wevVPastryCrumbBloomRestored
    private let coverAssets = [
        "wevv_challenge_strawberry_week",
        "wevv_challenge_pink_donut_day",
        "wevv_challenge_donut_coffee_match",
        "wevv_challenge_first_bite_reaction",
        "wevv_challenge_donut_of_day",
        "wevv_challenge_sprinkle_style"
    ]
    private let costValues = [50, 100, 300, 500]
    private var selectedCost = 100
    private var selectedCoverAsset = "wevv_challenge_strawberry_week"
    private var costButtons: [UIButton] = []
    private var detailUsesPlaceholder = true
    private var pastryCoverIsReady = false

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
        buildSprinkleQuestScrollShell()

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeSprinkleQuest), for: .touchUpInside)

        let glazeTitleLabel = makeQuestLabel("PMudbRlxiqsih* MCmhOaHlCl;e^nCgieh".wevVPastryCrumbBloomRestored, size: 20, weight: .bold)
        glazeTitleLabel.textAlignment = .center
        let coverLabel = makeQuestLabel("CYh:aDlIlZeLnlgzev ^C,orvZeJr*".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let coverCard = makeCoverCard()
        let themeLabel = makeQuestLabel("CIhpaBlKlgejnjgHe; JTzhLeqmkeZ".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let titleCard = makeTitleCard()
        let costLabel = makeQuestLabel("P!arrltYivc/iCp!a!tui?o?n@ ^CHoU".wevVPastryCrumbBloomRestored + "iynosi".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let costCard = makeCostCard()
        let detailLabel = makeQuestLabel("IGn~tPrxoPduu*cStPi/oGn@".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let detailCard = makeDetailCard()
        let timeLabel = makeQuestLabel("TZiAmgeV".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let placeLabel = makeQuestLabel("Luozc^aH".wevVPastryCrumbBloomRestored + "t!ihoJnH".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let timeCard = makeSmallFieldCard(field: timeField, text: "Friday · 8:00 PM –\n10:30 PM")
        let placeCard = makeSmallFieldCard(field: placeField, text: "128 Berry Street, San\nFranci...")

        tuneSprinklePostButton()
        placeSprinkleQuestViews(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, coverLabel: coverLabel, coverCard: coverCard, themeLabel: themeLabel, titleCard: titleCard, costLabel: costLabel, costCard: costCard, detailLabel: detailLabel, detailCard: detailCard, timeLabel: timeLabel, placeLabel: placeLabel, timeCard: timeCard, placeCard: placeCard)
        pinSprinkleQuestLayout(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, coverLabel: coverLabel, coverCard: coverCard, themeLabel: themeLabel, titleCard: titleCard, costLabel: costLabel, costCard: costCard, detailLabel: detailLabel, detailCard: detailCard, timeLabel: timeLabel, placeLabel: placeLabel, timeCard: timeCard, placeCard: placeCard)
        refreshCostButtons()
        bindSprinkleQuestTap()
    }

    private func buildSprinkleQuestScrollShell() {
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
    }

    private func tuneSprinklePostButton() {
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Pdossjtz".wevVPastryCrumbBloomRestored, for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        postButton.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        postButton.layer.cornerRadius = 26
        postButton.addTarget(self, action: #selector(postSprinkleQuest), for: .touchUpInside)
    }

    private func placeSprinkleQuestViews(doughBackButton: UIButton, glazeTitleLabel: UILabel, coverLabel: UILabel, coverCard: UIControl, themeLabel: UILabel, titleCard: UIView, costLabel: UILabel, costCard: UIView, detailLabel: UILabel, detailCard: UIView, timeLabel: UILabel, placeLabel: UILabel, timeCard: UIView, placeCard: UIView) {
        [doughBackButton, glazeTitleLabel, coverLabel, coverCard, themeLabel, titleCard, costLabel, costCard, detailLabel, detailCard, timeLabel, placeLabel, timeCard, placeCard, postButton].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinSprinkleQuestLayout(doughBackButton: UIButton, glazeTitleLabel: UILabel, coverLabel: UILabel, coverCard: UIControl, themeLabel: UILabel, titleCard: UIView, costLabel: UILabel, costCard: UIView, detailLabel: UILabel, detailCard: UIView, timeLabel: UILabel, placeLabel: UILabel, timeCard: UIView, placeCard: UIView) {
        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            doughBackButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18),
            doughBackButton.widthAnchor.constraint(equalToConstant: 42),
            doughBackButton.heightAnchor.constraint(equalToConstant: 42),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            glazeTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            coverLabel.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 28),
            coverLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34),
            coverCard.topAnchor.constraint(equalTo: coverLabel.bottomAnchor, constant: 18),
            coverCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34),
            coverCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -34),
            coverCard.heightAnchor.constraint(equalToConstant: 142),
            themeLabel.topAnchor.constraint(equalTo: coverCard.bottomAnchor, constant: 26),
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
            timeCard.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 28),
            timeCard.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            timeCard.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            timeCard.heightAnchor.constraint(equalToConstant: 50),
            placeLabel.topAnchor.constraint(equalTo: timeCard.bottomAnchor, constant: 22),
            placeLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            placeCard.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 16),
            placeCard.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor),
            placeCard.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor),
            placeCard.heightAnchor.constraint(equalTo: timeCard.heightAnchor),
            postButton.topAnchor.constraint(equalTo: placeCard.bottomAnchor, constant: 40),
            postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -82),
            postButton.heightAnchor.constraint(equalToConstant: 52),
            postButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }

    private func bindSprinkleQuestTap() {
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endQuestEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeCoverCard() -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        pastryCard.layer.cornerRadius = 30
        pastryCard.clipsToBounds = true

        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.image = nil
        coverImageView.alpha = 0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true

        coverShadeView.translatesAutoresizingMaskIntoConstraints = false
        coverShadeView.backgroundColor = UIColor.black.withAlphaComponent(0.08)

        coverCameraButton.translatesAutoresizingMaskIntoConstraints = false
        coverCameraButton.tintColor = .white
        coverCameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        coverCameraButton.imageView?.contentMode = .scaleAspectFit
        coverCameraButton.addTarget(self, action: #selector(chooseQuestCover), for: .touchUpInside)

        let glazeTitle = makeQuestLabel("A;didO DcBhkaUlul,e.njgWev pcBowvhe+rW".wevVPastryCrumbBloomRestored, size: 16, weight: .bold)
        glazeTitle.textColor = .white
        glazeTitle.textAlignment = .center

        let coverTapButton = UIButton(type: .custom)
        coverTapButton.translatesAutoresizingMaskIntoConstraints = false
        coverTapButton.backgroundColor = .clear
        coverTapButton.addTarget(self, action: #selector(chooseQuestCover), for: .touchUpInside)

        pastryCard.addSubview(coverImageView)
        pastryCard.addSubview(coverShadeView)
        pastryCard.addSubview(coverCameraButton)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(coverTapButton)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            coverShadeView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            coverShadeView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            coverShadeView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            coverShadeView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            coverCameraButton.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            coverCameraButton.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor, constant: -12),
            coverCameraButton.widthAnchor.constraint(equalToConstant: 54),
            coverCameraButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.topAnchor.constraint(equalTo: coverCameraButton.bottomAnchor, constant: 8),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            coverTapButton.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            coverTapButton.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            coverTapButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            coverTapButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor)
        ])
        return pastryCard
    }

    private func makeTitleCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 46
        pastryCard.clipsToBounds = true

        let smallLabel = makeQuestLabel("TGIyTqLsEW".wevVPastryCrumbBloomRestored, size: 12, weight: .bold)
        smallLabel.textColor = UIColor(red: 0.66, green: 0.56, blue: 0.68, alpha: 1)

        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.placeholder = "EPnEt^ebrQ JylojuurZ ^tEi:tClheW".wevVPastryCrumbBloomRestored
        titleField.font = .systemFont(ofSize: 16, weight: .bold)
        titleField.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        titleField.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        titleField.layer.cornerRadius = 25
        titleField.layer.borderWidth = 1.5
        titleField.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 1))
        titleField.leftViewMode = .always

        pastryCard.addSubview(smallLabel)
        pastryCard.addSubview(titleField)
        NSLayoutConstraint.activate([
            smallLabel.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            smallLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 45),
            titleField.topAnchor.constraint(equalTo: smallLabel.bottomAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 40),
            titleField.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -40),
            titleField.heightAnchor.constraint(equalToConstant: 50)
        ])
        return pastryCard
    }

    private func makeCostCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 42
        pastryCard.clipsToBounds = true

        let donutRow = UIStackView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.distribution = .fillEqually
        donutRow.spacing = 22
        pastryCard.addSubview(donutRow)

        for value in costValues {
            let sprinkleButton = UIButton(type: .system)
            sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
            sprinkleButton.tag = value
            sprinkleButton.setTitle("\(value)", for: .normal)
            sprinkleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            sprinkleButton.layer.cornerRadius = 24
            sprinkleButton.layer.borderWidth = 1.5
            sprinkleButton.addTarget(self, action: #selector(chooseQuestCost(_:)), for: .touchUpInside)
            costButtons.append(sprinkleButton)
            donutRow.addArrangedSubview(sprinkleButton)
        }

        NSLayoutConstraint.activate([
            donutRow.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 34),
            donutRow.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -34),
            donutRow.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            donutRow.heightAnchor.constraint(equalToConstant: 48)
        ])
        return pastryCard
    }

    private func makeDetailCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        pastryCard.layer.cornerRadius = 31
        pastryCard.layer.borderWidth = 1.5
        pastryCard.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor

        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.delegate = self
        detailView.text = detailPlaceholderText
        detailView.font = .systemFont(ofSize: 15, weight: .bold)
        detailView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailView.backgroundColor = .clear
        detailView.textContainerInset = UIEdgeInsets(top: 30, left: 24, bottom: 28, right: 24)

        detailCountLabel.translatesAutoresizingMaskIntoConstraints = false
        detailCountLabel.text = "0t e/? !1l8&0/".wevVPastryCrumbBloomRestored
        detailCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        detailCountLabel.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailCountLabel.textAlignment = .right

        pastryCard.addSubview(detailView)
        pastryCard.addSubview(detailCountLabel)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            detailCountLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -28),
            detailCountLabel.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -24)
        ])
        return pastryCard
    }

    private func makeSmallFieldCard(field: UITextField, text: String) -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        pastryCard.layer.cornerRadius = 25
        pastryCard.layer.borderWidth = 1.5
        pastryCard.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor

        field.translatesAutoresizingMaskIntoConstraints = false
        field.text = text
        field.font = .systemFont(ofSize: 14, weight: .bold)
        field.textColor = UIColor(red: 0.47, green: 0.39, blue: 0.48, alpha: 1)
        field.numberOfLinesFallback()

        pastryCard.addSubview(field)
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 31),
            field.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            field.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            field.heightAnchor.constraint(equalToConstant: 36)
        ])
        return pastryCard
    }

    private func makeQuestLabel(_ text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func refreshCostButtons() {
        for sprinkleButton in costButtons {
            let selected = sprinkleButton.tag == selectedCost
            sprinkleButton.backgroundColor = selected ? UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1) : UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
            sprinkleButton.setTitleColor(selected ? .white : UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1), for: .normal)
            sprinkleButton.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !detailUsesPlaceholder else {
            detailCountLabel.text = "0E A/Z @1.8X0D".wevVPastryCrumbBloomRestored
            return
        }
        let sugarText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if sugarText.count > 180 {
            textView.text = String(sugarText.prefix(180))
        }
        detailCountLabel.text = "\(textView.text.count) / 180"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard detailUsesPlaceholder else { return }
        detailUsesPlaceholder = false
        textView.text = ""
        textView.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        detailCountLabel.text = "0m d/# Q1P8:0C".wevVPastryCrumbBloomRestored
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let sugarText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard sugarText.isEmpty else { return }
        detailUsesPlaceholder = true
        textView.text = detailPlaceholderText
        textView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        detailCountLabel.text = "0G G// F1r8!0V".wevVPastryCrumbBloomRestored
    }

    @objc private func chooseQuestCost(_ sender: UIButton) {
        selectedCost = sender.tag
        refreshCostButtons()
    }

    @objc private func chooseQuestCover(_ sender: UIControl) {
        view.endEditing(true)
        let sheet = UIAlertController(title: "AGdNdr dc:hjaslelxeJnTgteW ~cho*vhe/rv".wevVPastryCrumbBloomRestored, message: "CEhjowoEsWez &a. Dw*aYy= mtSoI UsziMmzuwl.aatWe# &aCdlddiZndg, pyOo.umrT %dpo#nHuotk vc=hCaQl~lFe;n!gweJ !cFozv*e!rA.q".wevVPastryCrumbBloomRestored, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "T;aWkven iaO QcxoSvqe%rQ".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in
            self?.openSprinkleCoverPicker(source: .camera)
        })
        sheet.addAction(UIAlertAction(title: "C&h#odoPsxew YfdrFo?m# #allrbmuemO".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in
            self?.openSprinkleCoverPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cpa~nZcUeJlt".wevVPastryCrumbBloomRestored, style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        present(sheet, animated: true)
    }

    private func openSprinkleCoverPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showQuestHint(source == .camera ? "Camera is not available" : "AdlnbYuHmZ +iNs= Zntozto Paxvsa!iglYa!bLlqef".wevVPastryCrumbBloomRestored)
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func applySprinkleCover(glazeImage: UIImage, sugarKey: String) {
        selectedCoverAsset = sugarKey
        pastryCoverIsReady = true
        coverImageView.image = glazeImage
        coverShadeView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        UIView.transition(with: coverImageView, duration: 0.22, options: .transitionCrossDissolve) {
            self.coverImageView.alpha = 1
        }
        showQuestHint("CxoBvpe=rb TaBdIdWe@dR".wevVPastryCrumbBloomRestored)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let pickedImage else {
            picker.dismiss(animated: true)
            showQuestHint("CUo@vvearE UcVoouIladd UnSo#tw xbmeP +uPs%exdx".wevVPastryCrumbBloomRestored)
            return
        }
        guard let sugarKey = WevVPastryImageVault.store(pickedImage, purpose: "s,pVrcisnLkjlneoQCuhejs^twCnoQvQeKr/".wevVPastryCrumbBloomRestored) else {
            picker.dismiss(animated: true)
            showQuestHint("CGoCvveGr. ;c:oxuelHdM JnHo=tS wbgeK ns!axv&eude".wevVPastryCrumbBloomRestored)
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.applySprinkleCover(glazeImage: pickedImage, sugarKey: sugarKey)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func postSprinkleQuest() {
        guard glazeSession.isTasterReady else {
            showQuestHint("PHl+eTaEs;eo Iszi?gWnV biEnZ EfcisrOs@tp".wevVPastryCrumbBloomRestored)
            return
        }
        let glazeTitle = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let sugarText = detailUsesPlaceholder ? "" : detailView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let timeText = timeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let placeText = placeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard pastryCoverIsReady else {
            showQuestHint("ALdNdZ oa: ScXhyaClnlLeHnQgXef mcFo?vue.rK".wevVPastryCrumbBloomRestored)
            return
        }
        guard !glazeTitle.isEmpty else {
            showQuestHint("A!dPdY &aH ~cdhVail=lieynDgHeJ rgilFa+zteHT@iItalhe#".wevVPastryCrumbBloomRestored)
            return
        }
        guard !sugarText.isEmpty else {
            showQuestHint("Awd;dS JafnW Jikn&tJrfo;dIufcPtDikoEnR".wevVPastryCrumbBloomRestored)
            return
        }
        guard !timeText.isEmpty else {
            showQuestHint("AGd&dT nae zt!amsHtniMnygs ltMiLmmeU".wevVPastryCrumbBloomRestored)
            return
        }
        guard !placeText.isEmpty else {
            showQuestHint("ABdsdA mab IskhconpD Rp#lnavcMe:".wevVPastryCrumbBloomRestored)
            return
        }
        postButton.isEnabled = false
        postButton.alpha = 0.72
        WevVBakeryExchange.spin(in: view, note: "PGuAbBlri!sPhjicnNgH kc#hhaslXlNesnwgbeU.O.D.%".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            let packet = self.glazeSession.placeSprinkleQuest(title: glazeTitle, text: sugarText, timeText: timeText, placeText: placeText, sugarCost: self.selectedCost, coverAsset: self.selectedCoverAsset)
            self.showQuestSuccess(packet)
        }
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
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }

    private func showQuestSuccess(_ packet: WevVSprinkleQuestPacket) {
        view.endEditing(true)
        let dimLayer = UIControl()
        dimLayer.translatesAutoresizingMaskIntoConstraints = false
        dimLayer.backgroundColor = UIColor.black.withAlphaComponent(0.42)

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 24
        pastryCard.clipsToBounds = true

        let badge = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        badge.contentMode = .scaleAspectFit

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = "PGuabVlSi?sShIeId,".wevVPastryCrumbBloomRestored
        glazeTitle.font = .systemFont(ofSize: 18, weight: .bold)
        glazeTitle.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        glazeTitle.textAlignment = .center

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = "Y.oPuCr% tdoownBu/t~ AcnhFa^l%lte!n/gYeK Ii%sP Trieoajd.yZ.b".wevVPastryCrumbBloomRestored
        caption.font = .systemFont(ofSize: 13, weight: .medium)
        caption.textColor = UIColor(red: 0.50, green: 0.44, blue: 0.54, alpha: 1)
        caption.textAlignment = .center
        caption.numberOfLines = 2

        view.addSubview(dimLayer)
        dimLayer.addSubview(pastryCard)
        pastryCard.addSubview(badge)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(caption)

        pinQuestSuccess(dimLayer: dimLayer, pastryCard: pastryCard, badge: badge, title: glazeTitle, caption: caption)
        animateQuestSuccess(pastryCard: pastryCard, packet: packet)
    }

    private func pinQuestSuccess(dimLayer: UIView, pastryCard: UIView, badge: UIImageView, title: UILabel, caption: UILabel) {
        NSLayoutConstraint.activate([
            dimLayer.topAnchor.constraint(equalTo: view.topAnchor),
            dimLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: dimLayer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: dimLayer.centerYAnchor),
            pastryCard.widthAnchor.constraint(equalToConstant: 254),
            pastryCard.heightAnchor.constraint(equalToConstant: 172),
            badge.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 24),
            badge.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            badge.widthAnchor.constraint(equalToConstant: 50),
            badge.heightAnchor.constraint(equalToConstant: 50),
            title.topAnchor.constraint(equalTo: badge.bottomAnchor, constant: 14),
            title.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -20),
            caption.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            caption.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 24),
            caption.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24)
        ])
    }

    private func animateQuestSuccess(pastryCard: UIView, packet: WevVSprinkleQuestPacket) {
        pastryCard.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        pastryCard.alpha = 0
        UIView.animate(withDuration: 0.18) {
            pastryCard.alpha = 1
            pastryCard.transform = .identity
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
