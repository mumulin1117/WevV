import UIKit

final class WevVWevvTastingQuestComposerController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onWevvTastingQuestReady: ((WevVSprinkleQuestPacket) -> Void)?

    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let wevvPastryScroll = UIScrollView()
    private let wevvBakeryCanvas = UIView()
    private let wevvQuestTitleField = UITextField()
    private let wevvFlavorDetailView = UITextView()
    private let wevvFlavorCountLabel = UILabel()
    private let wevvFreshnessTimeField = UITextField()
    private let wevvBakeryPlaceField = UITextField()
    private let wevvQuestPostButton = UIButton(type: .system)
    private let wevvCoverImageView = UIImageView()
    private let wevvCoverCameraButton = UIButton(type: .system)
    private let wevvCoverShadeView = UIView()
    private let wevvFlavorPlaceholderText = "SKhDaRrleY KyNoiu~ri Xs;whe;e%tSesshtZ Zs/tPrhaUwlb*eerBrqyp adwoPn&ujty Rc.rgeFaut+i,oBnL.R".wevVPastryCrumbBloomRestored
    private let wevvCoverAssets = [
        "wevv_challenge_strawberry_week",
        "wevv_challenge_pink_donut_day",
        "wevv_challenge_donut_coffee_match",
        "wevv_challenge_first_bite_reaction",
        "wevv_challenge_donut_of_day",
        "wevv_challenge_sprinkle_style"
    ]
    private let wevvSprinkleDensityValues = [50, 100, 300, 500]
    private var wevvSelectedSprinkleDensity = 100
    private var wevvSelectedCoverAsset = "wevv_challenge_strawberry_week"
    private var wevvSprinkleDensityButtons: [UIButton] = []
    private var wevvDetailUsesPlaceholder = true
    private var wevvCoverIsReady = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.91, blue: 0.96, alpha: 1)
        buildWevvQuestCanvas()
        NotificationCenter.default.addObserver(self, selector: #selector(liftWevvQuestCanvas(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropWevvQuestCanvas(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildWevvQuestCanvas() {
        buildWevvQuestScrollShell()

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeWevvTastingQuest), for: .touchUpInside)

        let glazeTitleLabel = makeWevvQuestLabel("PMudbRlxiqsih* MCmhOaHlCl;e^nCgieh".wevVPastryCrumbBloomRestored, size: 20, weight: .bold)
        glazeTitleLabel.textAlignment = .center
        let coverLabel = makeWevvQuestLabel("CYh:aDlIlZeLnlgzev ^C,orvZeJr*".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let coverCard = makeWevvCoverCard()
        let themeLabel = makeWevvQuestLabel("CIhpaBlKlgejnjgHe; JTzhLeqmkeZ".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let titleCard = makeWevvTitleCard()
        let sprinkleDensityLabel = makeWevvQuestLabel("P!arrltYivc/iCp!a!tui?o?n@ ^CHoU".wevVPastryCrumbBloomRestored + "iynosi".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let sprinkleDensityCard = makeWevvSprinkleDensityCard()
        let detailLabel = makeWevvQuestLabel("IGn~tPrxoPduu*cStPi/oGn@".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let detailCard = makeWevvDetailCard()
        let timeLabel = makeWevvQuestLabel("TZiAmgeV".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let placeLabel = makeWevvQuestLabel("Luozc^aH".wevVPastryCrumbBloomRestored + "t!ihoJnH".wevVPastryCrumbBloomRestored, size: 17, weight: .bold)
        let timeCard = makeWevvSmallFieldCard(field: wevvFreshnessTimeField, text: "Friday · 8:00 PM –\n10:30 PM")
        let placeCard = makeWevvSmallFieldCard(field: wevvBakeryPlaceField, text: "128 Berry Street, San\nFranci...")

        tuneWevvQuestPostButton()
        placeWevvQuestViews(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, coverLabel: coverLabel, coverCard: coverCard, themeLabel: themeLabel, titleCard: titleCard, sprinkleDensityLabel: sprinkleDensityLabel, sprinkleDensityCard: sprinkleDensityCard, detailLabel: detailLabel, detailCard: detailCard, timeLabel: timeLabel, placeLabel: placeLabel, timeCard: timeCard, placeCard: placeCard)
        pinWevvQuestLayout(yeastBloom: doughBackButton, nuttyFinish: glazeTitleLabel, berryBurst: coverLabel, citrusLift: coverCard, fluffyCenter: themeLabel, crispEdge: titleCard, sprinkleDensityLabel: sprinkleDensityLabel, sprinkleDensityCard: sprinkleDensityCard, chewIndex: detailLabel, freshnessMark: detailCard, donenessCheck: timeLabel, textureMark: placeLabel, glazeBowl: timeCard, batterBowl: placeCard)
        refreshWevvSprinkleDensityButtons()
        bindWevvQuestTap()
    }

    private func buildWevvQuestScrollShell() {
        wevvPastryScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryScroll.alwaysBounceVertical = true
        wevvPastryScroll.keyboardDismissMode = .interactive
        view.addSubview(wevvPastryScroll)

        wevvBakeryCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryScroll.addSubview(wevvBakeryCanvas)

        NSLayoutConstraint.activate([
            wevvPastryScroll.topAnchor.constraint(equalTo: view.topAnchor),
            wevvPastryScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvPastryScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvPastryScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvBakeryCanvas.topAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.topAnchor),
            wevvBakeryCanvas.leadingAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.leadingAnchor),
            wevvBakeryCanvas.trailingAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.trailingAnchor),
            wevvBakeryCanvas.bottomAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.bottomAnchor),
            wevvBakeryCanvas.widthAnchor.constraint(equalTo: wevvPastryScroll.frameLayoutGuide.widthAnchor),
            wevvBakeryCanvas.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }

    private func tuneWevvQuestPostButton() {
        wevvQuestPostButton.translatesAutoresizingMaskIntoConstraints = false
        wevvQuestPostButton.setTitle("Pdossjtz".wevVPastryCrumbBloomRestored, for: .normal)
        wevvQuestPostButton.setTitleColor(.white, for: .normal)
        wevvQuestPostButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        wevvQuestPostButton.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        wevvQuestPostButton.layer.cornerRadius = 26
        wevvQuestPostButton.addTarget(self, action: #selector(postWevvTastingQuest), for: .touchUpInside)
    }

    private func placeWevvQuestViews(doughBackButton: UIButton, glazeTitleLabel: UILabel, coverLabel: UILabel, coverCard: UIControl, themeLabel: UILabel, titleCard: UIView, sprinkleDensityLabel: UILabel, sprinkleDensityCard: UIView, detailLabel: UILabel, detailCard: UIView, timeLabel: UILabel, placeLabel: UILabel, timeCard: UIView, placeCard: UIView) {
        [doughBackButton, glazeTitleLabel, coverLabel, coverCard, themeLabel, titleCard, sprinkleDensityLabel, sprinkleDensityCard, detailLabel, detailCard, timeLabel, placeLabel, timeCard, placeCard, wevvQuestPostButton].forEach {
            wevvBakeryCanvas.addSubview($0)
        }
    }

    private func pinWevvQuestLayout(yeastBloom: UIButton, nuttyFinish: UILabel, berryBurst: UILabel, citrusLift: UIControl, fluffyCenter: UILabel, crispEdge: UIView, sprinkleDensityLabel: UILabel, sprinkleDensityCard: UIView, chewIndex: UILabel, freshnessMark: UIView, donenessCheck: UILabel, textureMark: UILabel, glazeBowl: UIView, batterBowl: UIView) {
        NSLayoutConstraint.activate([
            yeastBloom.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 30),
            yeastBloom.topAnchor.constraint(equalTo: wevvBakeryCanvas.safeAreaLayoutGuide.topAnchor, constant: 18),
            yeastBloom.widthAnchor.constraint(equalToConstant: 42),
            yeastBloom.heightAnchor.constraint(equalToConstant: 42),
            nuttyFinish.centerYAnchor.constraint(equalTo: yeastBloom.centerYAnchor),
            nuttyFinish.centerXAnchor.constraint(equalTo: wevvBakeryCanvas.centerXAnchor),
            nuttyFinish.leadingAnchor.constraint(greaterThanOrEqualTo: yeastBloom.trailingAnchor, constant: 12),
            berryBurst.topAnchor.constraint(equalTo: nuttyFinish.bottomAnchor, constant: 28),
            berryBurst.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 34),
            citrusLift.topAnchor.constraint(equalTo: berryBurst.bottomAnchor, constant: 18),
            citrusLift.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 34),
            citrusLift.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -34),
            citrusLift.heightAnchor.constraint(equalToConstant: 142),
            fluffyCenter.topAnchor.constraint(equalTo: citrusLift.bottomAnchor, constant: 26),
            fluffyCenter.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 34),
            crispEdge.topAnchor.constraint(equalTo: fluffyCenter.bottomAnchor, constant: 28),
            crispEdge.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 34),
            crispEdge.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -34),
            crispEdge.heightAnchor.constraint(equalToConstant: 122),
            sprinkleDensityLabel.topAnchor.constraint(equalTo: crispEdge.bottomAnchor, constant: 30),
            sprinkleDensityLabel.leadingAnchor.constraint(equalTo: fluffyCenter.leadingAnchor),
            sprinkleDensityCard.topAnchor.constraint(equalTo: sprinkleDensityLabel.bottomAnchor, constant: 30),
            sprinkleDensityCard.leadingAnchor.constraint(equalTo: crispEdge.leadingAnchor),
            sprinkleDensityCard.trailingAnchor.constraint(equalTo: crispEdge.trailingAnchor),
            sprinkleDensityCard.heightAnchor.constraint(equalToConstant: 78),
            chewIndex.topAnchor.constraint(equalTo: sprinkleDensityCard.bottomAnchor, constant: 34),
            chewIndex.leadingAnchor.constraint(equalTo: fluffyCenter.leadingAnchor),
            freshnessMark.topAnchor.constraint(equalTo: chewIndex.bottomAnchor, constant: 30),
            freshnessMark.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 39),
            freshnessMark.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -39),
            freshnessMark.heightAnchor.constraint(equalToConstant: 132),
            donenessCheck.topAnchor.constraint(equalTo: freshnessMark.bottomAnchor, constant: 28),
            donenessCheck.leadingAnchor.constraint(equalTo: freshnessMark.leadingAnchor, constant: 5),
            glazeBowl.topAnchor.constraint(equalTo: donenessCheck.bottomAnchor, constant: 28),
            glazeBowl.leadingAnchor.constraint(equalTo: freshnessMark.leadingAnchor),
            glazeBowl.trailingAnchor.constraint(equalTo: freshnessMark.trailingAnchor),
            glazeBowl.heightAnchor.constraint(equalToConstant: 50),
            textureMark.topAnchor.constraint(equalTo: glazeBowl.bottomAnchor, constant: 22),
            textureMark.leadingAnchor.constraint(equalTo: donenessCheck.leadingAnchor),
            batterBowl.topAnchor.constraint(equalTo: textureMark.bottomAnchor, constant: 16),
            batterBowl.leadingAnchor.constraint(equalTo: freshnessMark.leadingAnchor),
            batterBowl.trailingAnchor.constraint(equalTo: freshnessMark.trailingAnchor),
            batterBowl.heightAnchor.constraint(equalTo: glazeBowl.heightAnchor),
            wevvQuestPostButton.topAnchor.constraint(equalTo: batterBowl.bottomAnchor, constant: 40),
            wevvQuestPostButton.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 82),
            wevvQuestPostButton.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -82),
            wevvQuestPostButton.heightAnchor.constraint(equalToConstant: 52),
            wevvQuestPostButton.bottomAnchor.constraint(lessThanOrEqualTo: wevvBakeryCanvas.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }

    private func bindWevvQuestTap() {
        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endWevvQuestEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeWevvCoverCard() -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1)
        pastryCard.layer.cornerRadius = 30
        pastryCard.clipsToBounds = true

        wevvCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        wevvCoverImageView.image = nil
        wevvCoverImageView.alpha = 0
        wevvCoverImageView.contentMode = .scaleAspectFill
        wevvCoverImageView.clipsToBounds = true

        wevvCoverShadeView.translatesAutoresizingMaskIntoConstraints = false
        wevvCoverShadeView.backgroundColor = UIColor.black.withAlphaComponent(0.08)

        wevvCoverCameraButton.translatesAutoresizingMaskIntoConstraints = false
        wevvCoverCameraButton.tintColor = .white
        wevvCoverCameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        wevvCoverCameraButton.imageView?.contentMode = .scaleAspectFit
        wevvCoverCameraButton.addTarget(self, action: #selector(chooseWevvQuestCover), for: .touchUpInside)

        let glazeTitle = makeWevvQuestLabel("A;didO DcBhkaUlul,e.njgWev pcBowvhe+rW".wevVPastryCrumbBloomRestored, size: 16, weight: .bold)
        glazeTitle.textColor = .white
        glazeTitle.textAlignment = .center

        let coverTapButton = UIButton(type: .custom)
        coverTapButton.translatesAutoresizingMaskIntoConstraints = false
        coverTapButton.backgroundColor = .clear
        coverTapButton.addTarget(self, action: #selector(chooseWevvQuestCover), for: .touchUpInside)

        pastryCard.addSubview(wevvCoverImageView)
        pastryCard.addSubview(wevvCoverShadeView)
        pastryCard.addSubview(wevvCoverCameraButton)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(coverTapButton)
        NSLayoutConstraint.activate([
            wevvCoverImageView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            wevvCoverImageView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            wevvCoverImageView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            wevvCoverImageView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            wevvCoverShadeView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            wevvCoverShadeView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            wevvCoverShadeView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            wevvCoverShadeView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            wevvCoverCameraButton.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            wevvCoverCameraButton.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor, constant: -12),
            wevvCoverCameraButton.widthAnchor.constraint(equalToConstant: 54),
            wevvCoverCameraButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.topAnchor.constraint(equalTo: wevvCoverCameraButton.bottomAnchor, constant: 8),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            coverTapButton.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            coverTapButton.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            coverTapButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            coverTapButton.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor)
        ])
        return pastryCard
    }

    private func makeWevvTitleCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 46
        pastryCard.clipsToBounds = true

        let smallLabel = makeWevvQuestLabel("TGIyTqLsEW".wevVPastryCrumbBloomRestored, size: 12, weight: .bold)
        smallLabel.textColor = UIColor(red: 0.66, green: 0.56, blue: 0.68, alpha: 1)

        wevvQuestTitleField.translatesAutoresizingMaskIntoConstraints = false
        wevvQuestTitleField.placeholder = "EPnEt^ebrQ JylojuurZ ^tEi:tClheW".wevVPastryCrumbBloomRestored
        wevvQuestTitleField.font = .systemFont(ofSize: 16, weight: .bold)
        wevvQuestTitleField.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        wevvQuestTitleField.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        wevvQuestTitleField.layer.cornerRadius = 25
        wevvQuestTitleField.layer.borderWidth = 1.5
        wevvQuestTitleField.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        wevvQuestTitleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 1))
        wevvQuestTitleField.leftViewMode = .always

        pastryCard.addSubview(smallLabel)
        pastryCard.addSubview(wevvQuestTitleField)
        NSLayoutConstraint.activate([
            smallLabel.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 22),
            smallLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 45),
            wevvQuestTitleField.topAnchor.constraint(equalTo: smallLabel.bottomAnchor, constant: 20),
            wevvQuestTitleField.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 40),
            wevvQuestTitleField.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -40),
            wevvQuestTitleField.heightAnchor.constraint(equalToConstant: 50)
        ])
        return pastryCard
    }

    private func makeWevvSprinkleDensityCard() -> UIView {
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

        for value in wevvSprinkleDensityValues {
            let sprinkleButton = UIButton(type: .system)
            sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
            sprinkleButton.tag = value
            sprinkleButton.setTitle("\(value)", for: .normal)
            sprinkleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            sprinkleButton.layer.cornerRadius = 24
            sprinkleButton.layer.borderWidth = 1.5
            sprinkleButton.addTarget(self, action: #selector(chooseWevvQuestDensity(_:)), for: .touchUpInside)
            wevvSprinkleDensityButtons.append(sprinkleButton)
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

    private func makeWevvDetailCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
        pastryCard.layer.cornerRadius = 31
        pastryCard.layer.borderWidth = 1.5
        pastryCard.layer.borderColor = UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor

        wevvFlavorDetailView.translatesAutoresizingMaskIntoConstraints = false
        wevvFlavorDetailView.delegate = self
        wevvFlavorDetailView.text = wevvFlavorPlaceholderText
        wevvFlavorDetailView.font = .systemFont(ofSize: 15, weight: .bold)
        wevvFlavorDetailView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        wevvFlavorDetailView.backgroundColor = .clear
        wevvFlavorDetailView.textContainerInset = UIEdgeInsets(top: 30, left: 24, bottom: 28, right: 24)

        wevvFlavorCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wevvFlavorCountLabel.text = "0t e/? !1l8&0/".wevVPastryCrumbBloomRestored
        wevvFlavorCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        wevvFlavorCountLabel.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        wevvFlavorCountLabel.textAlignment = .right

        pastryCard.addSubview(wevvFlavorDetailView)
        pastryCard.addSubview(wevvFlavorCountLabel)
        NSLayoutConstraint.activate([
            wevvFlavorDetailView.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            wevvFlavorDetailView.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            wevvFlavorDetailView.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            wevvFlavorDetailView.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            wevvFlavorCountLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -28),
            wevvFlavorCountLabel.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -24)
        ])
        return pastryCard
    }

    private func makeWevvSmallFieldCard(field: UITextField, text: String) -> UIView {
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

    private func makeWevvQuestLabel(_ text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func refreshWevvSprinkleDensityButtons() {
        for sprinkleButton in wevvSprinkleDensityButtons {
            let selected = sprinkleButton.tag == wevvSelectedSprinkleDensity
            sprinkleButton.backgroundColor = selected ? UIColor(red: 1.0, green: 0.25, blue: 0.62, alpha: 1) : UIColor(red: 1.0, green: 0.97, blue: 0.99, alpha: 1)
            sprinkleButton.setTitleColor(selected ? .white : UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1), for: .normal)
            sprinkleButton.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor(red: 0.94, green: 0.80, blue: 0.89, alpha: 1).cgColor
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !wevvDetailUsesPlaceholder else {
            wevvFlavorCountLabel.text = "0E A/Z @1.8X0D".wevVPastryCrumbBloomRestored
            return
        }
        let crumbReplyText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if crumbReplyText.count > 180 {
            textView.text = String(crumbReplyText.prefix(180))
        }
        wevvFlavorCountLabel.text = "\(textView.text.count) / 180"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard wevvDetailUsesPlaceholder else { return }
        wevvDetailUsesPlaceholder = false
        textView.text = ""
        textView.textColor = UIColor(red: 0.17, green: 0.12, blue: 0.22, alpha: 1)
        wevvFlavorCountLabel.text = "0m d/# Q1P8:0C".wevVPastryCrumbBloomRestored
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let crumbReplyText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard crumbReplyText.isEmpty else { return }
        wevvDetailUsesPlaceholder = true
        textView.text = wevvFlavorPlaceholderText
        textView.textColor = UIColor(red: 0.58, green: 0.50, blue: 0.61, alpha: 1)
        wevvFlavorCountLabel.text = "0G G// F1r8!0V".wevVPastryCrumbBloomRestored
    }

    @objc private func chooseWevvQuestDensity(_ sender: UIButton) {
        wevvSelectedSprinkleDensity = sender.tag
        refreshWevvSprinkleDensityButtons()
    }

    @objc private func chooseWevvQuestCover(_ sender: UIControl) {
        view.endEditing(true)
        let sheet = UIAlertController(title: "AGdNdr dc:hjaslelxeJnTgteW ~cho*vhe/rv".wevVPastryCrumbBloomRestored, message: "CEhjowoEsWez &a. Dw*aYy= mtSoI UsziMmzuwl.aatWe# &aCdlddiZndg, pyOo.umrT %dpo#nHuotk vc=hCaQl~lFe;n!gweJ !cFozv*e!rA.q".wevVPastryCrumbBloomRestored, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "T;aWkven iaO QcxoSvqe%rQ".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in
            self?.openWevvCoverPicker(source: .camera)
        })
        sheet.addAction(UIAlertAction(title: "C&h#odoPsxew YfdrFo?m# #allrbmuemO".wevVPastryCrumbBloomRestored, style: .default) { [weak self] _ in
            self?.openWevvCoverPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cpa~nZcUeJlt".wevVPastryCrumbBloomRestored, style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        present(sheet, animated: true)
    }

    private func openWevvCoverPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showWevvQuestHint(source == .camera ? "Camera is not available" : "AdlnbYuHmZ +iNs= Zntozto Paxvsa!iglYa!bLlqef".wevVPastryCrumbBloomRestored)
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func applyWevvCoverImage(glazeImage: UIImage, sugarDustKey: String) {
        wevvSelectedCoverAsset = sugarDustKey
        wevvCoverIsReady = true
        wevvCoverImageView.image = glazeImage
        wevvCoverShadeView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        UIView.transition(with: wevvCoverImageView, duration: 0.22, options: .transitionCrossDissolve) {
            self.wevvCoverImageView.alpha = 1
        }
        showWevvQuestHint("CxoBvpe=rb TaBdIdWe@dR".wevVPastryCrumbBloomRestored)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let chosenGlazeImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let chosenGlazeImage else {
            picker.dismiss(animated: true)
            showWevvQuestHint("CUo@vvearE UcVoouIladd UnSo#tw xbmeP +uPs%exdx".wevVPastryCrumbBloomRestored)
            return
        }
        guard let sugarDustKey = WevVPastryImageVault.store(chosenGlazeImage, purpose: "s,pVrcisnLkjlneoQCuhejs^twCnoQvQeKr/".wevVPastryCrumbBloomRestored) else {
            picker.dismiss(animated: true)
            showWevvQuestHint("CGoCvveGr. ;c:oxuelHdM JnHo=tS wbgeK ns!axv&eude".wevVPastryCrumbBloomRestored)
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.applyWevvCoverImage(glazeImage: chosenGlazeImage, sugarDustKey: sugarDustKey)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func postWevvTastingQuest() {
        guard wevvDonutJournalStore.isTasterReady else {
            showWevvQuestHint("PHl+eTaEs;eo Iszi?gWnV biEnZ EfcisrOs@tp".wevVPastryCrumbBloomRestored)
            return
        }
        let glazeTitle = wevvQuestTitleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let crumbReplyText = wevvDetailUsesPlaceholder ? "" : wevvFlavorDetailView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let timeText = wevvFreshnessTimeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let placeText = wevvBakeryPlaceField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard wevvCoverIsReady else {
            showWevvQuestHint("ALdNdZ oa: ScXhyaClnlLeHnQgXef mcFo?vue.rK".wevVPastryCrumbBloomRestored)
            return
        }
        guard !glazeTitle.isEmpty else {
            showWevvQuestHint("A!dPdY &aH ~cdhVail=lieynDgHeJ rgilFa+zteHT@iItalhe#".wevVPastryCrumbBloomRestored)
            return
        }
        guard !crumbReplyText.isEmpty else {
            showWevvQuestHint("Awd;dS JafnW Jikn&tJrfo;dIufcPtDikoEnR".wevVPastryCrumbBloomRestored)
            return
        }
        guard !timeText.isEmpty else {
            showWevvQuestHint("AGd&dT nae zt!amsHtniMnygs ltMiLmmeU".wevVPastryCrumbBloomRestored)
            return
        }
        guard !placeText.isEmpty else {
            showWevvQuestHint("ABdsdA mab IskhconpD Rp#lnavcMe:".wevVPastryCrumbBloomRestored)
            return
        }
        wevvQuestPostButton.isEnabled = false
        wevvQuestPostButton.alpha = 0.72
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "PGuAbBlri!sPhjicnNgH kc#hhaslXlNesnwgbeU.O.D.%".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            let packet = self.wevvDonutJournalStore.placeSprinkleQuest(title: glazeTitle, text: crumbReplyText, timeText: timeText, placeText: placeText, sprinkleDensityValue: self.wevvSelectedSprinkleDensity, coverAsset: self.wevvSelectedCoverAsset)
            self.showWevvQuestSuccess(packet)
        }
    }

    @objc private func closeWevvTastingQuest() {
        dismiss(animated: true)
    }

    @objc private func endWevvQuestEditing() {
        view.endEditing(true)
    }

    @objc private func liftWevvQuestCanvas(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let lift = max(0, frame.height - view.safeAreaInsets.bottom)
        wevvPastryScroll.contentInset.bottom = lift + 36
        wevvPastryScroll.verticalScrollIndicatorInsets.bottom = lift + 36
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropWevvQuestCanvas(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        wevvPastryScroll.contentInset.bottom = 0
        wevvPastryScroll.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showWevvQuestHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }

    private func showWevvQuestSuccess(_ packet: WevVSprinkleQuestPacket) {
        view.endEditing(true)
        let wevvDimLayer = UIControl()
        wevvDimLayer.translatesAutoresizingMaskIntoConstraints = false
        wevvDimLayer.backgroundColor = UIColor.black.withAlphaComponent(0.42)

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

        view.addSubview(wevvDimLayer)
        wevvDimLayer.addSubview(pastryCard)
        pastryCard.addSubview(badge)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(caption)

        pinWevvQuestSuccess(wevvDimLayer: wevvDimLayer, pastryCard: pastryCard, badge: badge, title: glazeTitle, caption: caption)
        animateWevvQuestSuccess(pastryCard: pastryCard, packet: packet)
    }

    private func pinWevvQuestSuccess(wevvDimLayer: UIView, pastryCard: UIView, badge: UIImageView, title: UILabel, caption: UILabel) {
        NSLayoutConstraint.activate([
            wevvDimLayer.topAnchor.constraint(equalTo: view.topAnchor),
            wevvDimLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvDimLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvDimLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: wevvDimLayer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: wevvDimLayer.centerYAnchor),
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

    private func animateWevvQuestSuccess(pastryCard: UIView, packet: WevVSprinkleQuestPacket) {
        pastryCard.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        pastryCard.alpha = 0
        UIView.animate(withDuration: 0.18) {
            pastryCard.alpha = 1
            pastryCard.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) { [weak self] in
            self?.onWevvTastingQuestReady?(packet)
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
