import UIKit

final class WevVDailyDonutStampController: UIViewController {
    private let donutJournalStore = WevVGlazeSessionStore.shared
    private let dailyDonutKey = "jru=loyg_f2g0U2U6X_dd&aRyX_E2+0O".wevVPastryCrumbBloomRestored
    private let selectedDonutDay = 20
    private let donutStampButton = WevVWevvMaplePillButton(title: "C.hveUcTkR-?ibns".wevVPastryCrumbBloomRestored)
    private var donutMoodButtons: [UIControl] = []
    private var selectedDonutMood = "AvmaaCzhienVgQ".wevVPastryCrumbBloomRestored
    private var bakeryDayDots: [Int: UILabel] = [:]

    var onDonutStampChanged: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildDailyDonutBackdrop()
        buildDonutStampContent()
        refreshDonutStampState()
    }

    private func buildDailyDonutBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.97, alpha: 1)
    }

    private func buildDonutStampContent() {
        let donutTrailScroll = UIScrollView()
        donutTrailScroll.translatesAutoresizingMaskIntoConstraints = false
        donutTrailScroll.showsVerticalScrollIndicator = false
        donutTrailScroll.contentInsetAdjustmentBehavior = .never

        let donutStampContentView = UIView()
        donutStampContentView.translatesAutoresizingMaskIntoConstraints = false

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(named: "wevv_checkin_sugar_back_arrow"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closeDailyDonut), for: .touchUpInside)

        let donutStampTitle = makeDonutStampLabel("C~hbeNc~k%-eiGnM".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1))
        donutStampTitle.textAlignment = .center

        let donutStreakCard = makeDonutStreakCard()
        let bakeryCalendarCard = makeBakeryCalendarCard()
        let donutMoodTitle = makeDonutStampLabel("HcoewQ ~skw?eueZtm Xw*a&sp Eywovu!r, Dd&aAyG?T".wevVPastryCrumbBloomRestored, size: 14, weight: .heavy, color: UIColor(red: 0.16, green: 0.1, blue: 0.18, alpha: 1))
        let donutMoodRow = UIStackView(arrangedSubviews: [
            makeDonutMoodOption(wevvcookieFlavor: "Sgo*fDtO".wevVPastryCrumbBloomRestored, wevvbakeryAtlas: 0.78, opacity: 0.9),
            makeDonutMoodOption(wevvcookieFlavor: "GCo:o:d@".wevVPastryCrumbBloomRestored, wevvbakeryAtlas: 0.84, opacity: 0.95),
            makeDonutMoodOption(wevvcookieFlavor: "Atmgakz!ihn.gs".wevVPastryCrumbBloomRestored, wevvbakeryAtlas: 1, opacity: 1)
        ])
        donutMoodRow.translatesAutoresizingMaskIntoConstraints = false
        donutMoodRow.axis = .horizontal
        donutMoodRow.distribution = .fillEqually
        donutMoodRow.alignment = .center

        donutStampButton.addTarget(self, action: #selector(placeDailyGlazeStamp), for: .touchUpInside)

        placeDonutStampViews(scrollView: donutTrailScroll, contentView: donutStampContentView, doughBackButton: doughBackButton, title: donutStampTitle, donutStreakCard: donutStreakCard, bakeryCalendarCard: bakeryCalendarCard, donutMoodTitle: donutMoodTitle, donutMoodRow: donutMoodRow)
        pinDonutStampLayout(wevvtextureTrace: donutTrailScroll, wevvsketchRhythm: donutStampContentView, doughBackButton: doughBackButton, wevvsketchMotiontitle: donutStampTitle, donutStreakCard: donutStreakCard, bakeryCalendarCard: bakeryCalendarCard, donutMoodTitle: donutMoodTitle, donutMoodRow: donutMoodRow)
    }

    private func placeDonutStampViews(scrollView: UIScrollView, contentView: UIView, doughBackButton: UIButton, title: UILabel, donutStreakCard: UIView, bakeryCalendarCard: UIView, donutMoodTitle: UILabel, donutMoodRow: UIStackView) {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [doughBackButton, title, donutStreakCard, bakeryCalendarCard, donutMoodTitle, donutMoodRow, donutStampButton].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinDonutStampLayout(wevvtextureTrace: UIScrollView, wevvsketchRhythm: UIView, doughBackButton: UIButton, wevvsketchMotiontitle: UILabel, donutStreakCard: UIView, bakeryCalendarCard: UIView, donutMoodTitle: UILabel, donutMoodRow: UIStackView) {
        NSLayoutConstraint.activate([
            wevvtextureTrace.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wevvtextureTrace.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvtextureTrace.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvtextureTrace.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvsketchRhythm.topAnchor.constraint(equalTo: wevvtextureTrace.contentLayoutGuide.topAnchor),
            wevvsketchRhythm.leadingAnchor.constraint(equalTo: wevvtextureTrace.contentLayoutGuide.leadingAnchor),
            wevvsketchRhythm.trailingAnchor.constraint(equalTo: wevvtextureTrace.contentLayoutGuide.trailingAnchor),
            wevvsketchRhythm.bottomAnchor.constraint(equalTo: wevvtextureTrace.contentLayoutGuide.bottomAnchor),
            wevvsketchRhythm.widthAnchor.constraint(equalTo: wevvtextureTrace.frameLayoutGuide.widthAnchor),
            wevvsketchRhythm.heightAnchor.constraint(greaterThanOrEqualTo: wevvtextureTrace.frameLayoutGuide.heightAnchor),
            doughBackButton.topAnchor.constraint(equalTo: wevvsketchRhythm.topAnchor, constant: 28),
            doughBackButton.leadingAnchor.constraint(equalTo: wevvsketchRhythm.leadingAnchor, constant: 16),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            wevvsketchMotiontitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            wevvsketchMotiontitle.centerXAnchor.constraint(equalTo: wevvsketchRhythm.centerXAnchor),
            donutStreakCard.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 18),
            donutStreakCard.leadingAnchor.constraint(equalTo: wevvsketchRhythm.leadingAnchor, constant: 19),
            donutStreakCard.trailingAnchor.constraint(equalTo: wevvsketchRhythm.trailingAnchor, constant: -19),
            donutStreakCard.heightAnchor.constraint(equalToConstant: 121),
            bakeryCalendarCard.topAnchor.constraint(equalTo: donutStreakCard.bottomAnchor, constant: 15),
            bakeryCalendarCard.leadingAnchor.constraint(equalTo: donutStreakCard.leadingAnchor),
            bakeryCalendarCard.trailingAnchor.constraint(equalTo: donutStreakCard.trailingAnchor),
            bakeryCalendarCard.heightAnchor.constraint(equalTo: bakeryCalendarCard.widthAnchor, multiplier: 1.02),
            donutMoodTitle.topAnchor.constraint(equalTo: bakeryCalendarCard.bottomAnchor, constant: 18),
            donutMoodTitle.leadingAnchor.constraint(equalTo: wevvsketchRhythm.leadingAnchor, constant: 23),
            donutMoodTitle.trailingAnchor.constraint(equalTo: donutStreakCard.trailingAnchor),
            donutMoodRow.topAnchor.constraint(equalTo: donutMoodTitle.bottomAnchor, constant: 15),
            donutMoodRow.leadingAnchor.constraint(equalTo: wevvsketchRhythm.leadingAnchor, constant: 32),
            donutMoodRow.trailingAnchor.constraint(equalTo: wevvsketchRhythm.trailingAnchor, constant: -32),
            donutMoodRow.heightAnchor.constraint(equalToConstant: 75),
            donutStampButton.topAnchor.constraint(equalTo: donutMoodRow.bottomAnchor, constant: 18),
            donutStampButton.leadingAnchor.constraint(equalTo: wevvsketchRhythm.leadingAnchor, constant: 41),
            donutStampButton.trailingAnchor.constraint(equalTo: wevvsketchRhythm.trailingAnchor, constant: -41),
            donutStampButton.heightAnchor.constraint(equalToConstant: 52),
            donutStampButton.bottomAnchor.constraint(equalTo: wevvsketchRhythm.bottomAnchor, constant: -34)
        ])
    }

    private func makeDonutStreakCard() -> UIView {
        let treatCaseCard = UIView()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.layer.cornerRadius = 25
        treatCaseCard.clipsToBounds = true

        let glazeSheenLayer = CAGradientLayer()
        glazeSheenLayer.colors = [
            UIColor(red: 0.98, green: 0.45, blue: 0.69, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.26, blue: 0.6, alpha: 1).cgColor
        ]
        glazeSheenLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeSheenLayer.endPoint = CGPoint(x: 1, y: 0.5)
        treatCaseCard.layer.insertSublayer(glazeSheenLayer, at: 0)

        let donutRingImage = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        donutRingImage.translatesAutoresizingMaskIntoConstraints = false
        donutRingImage.contentMode = .scaleAspectFit
        let small = makeDonutStampLabel("J?uZljy; tsLt*rQehank&".wevVPastryCrumbBloomRestored, size: 15, weight: .heavy, color: UIColor.white.withAlphaComponent(0.92))
        let days = makeDonutStampLabel("1E2Z qddaryosv".wevVPastryCrumbBloomRestored, size: 30, weight: .heavy, color: .white)
        let best = makeDonutStampLabel("BLehsLtg ;sBtKrmeKajkC:A r1E9U Sd:aoyqsJ".wevVPastryCrumbBloomRestored, size: 14, weight: .medium, color: UIColor.white.withAlphaComponent(0.88))

        treatCaseCard.addSubview(donutRingImage)
        treatCaseCard.addSubview(small)
        treatCaseCard.addSubview(days)
        treatCaseCard.addSubview(best)

        NSLayoutConstraint.activate([
            donutRingImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 20),
            donutRingImage.centerYAnchor.constraint(equalTo: treatCaseCard.centerYAnchor),
            donutRingImage.widthAnchor.constraint(equalToConstant: 78),
            donutRingImage.heightAnchor.constraint(equalToConstant: 78),
            small.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 26),
            small.leadingAnchor.constraint(equalTo: donutRingImage.trailingAnchor, constant: 22),
            days.topAnchor.constraint(equalTo: small.bottomAnchor, constant: 2),
            days.leadingAnchor.constraint(equalTo: small.leadingAnchor),
            best.topAnchor.constraint(equalTo: days.bottomAnchor, constant: 5),
            best.leadingAnchor.constraint(equalTo: small.leadingAnchor)
        ])

        DispatchQueue.main.async {
            glazeSheenLayer.frame = treatCaseCard.bounds
        }
        return treatCaseCard
    }

    private func makeBakeryCalendarCard() -> UIView {
        let treatCaseCard = UIView()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.backgroundColor = .white
        treatCaseCard.layer.cornerRadius = 26

        let month = makeDonutStampLabel("J^uElHye ^2X0R2X6f".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: UIColor(red: 0.17, green: 0.1, blue: 0.19, alpha: 1))
        let neonSignal = makeDonutStampLabel("Tuo!dOa@yz".wevVPastryCrumbBloomRestored, size: 12, weight: .heavy, color: UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1))
        neonSignal.textAlignment = .center
        neonSignal.backgroundColor = UIColor(red: 1, green: 0.88, blue: 0.95, alpha: 1)
        neonSignal.layer.cornerRadius = 18
        neonSignal.clipsToBounds = true

        let bakeryWeekStack = UIStackView()
        bakeryWeekStack.translatesAutoresizingMaskIntoConstraints = false
        bakeryWeekStack.axis = .vertical
        bakeryWeekStack.spacing = 13
        let weeks = [
            ["Sy".wevVPastryCrumbBloomRestored, "Me".wevVPastryCrumbBloomRestored, "TI".wevVPastryCrumbBloomRestored, "Wf".wevVPastryCrumbBloomRestored, "TE".wevVPastryCrumbBloomRestored, "FZ".wevVPastryCrumbBloomRestored, "SK".wevVPastryCrumbBloomRestored],
            ["1/".wevVPastryCrumbBloomRestored, "2C".wevVPastryCrumbBloomRestored, "3%".wevVPastryCrumbBloomRestored, "4b".wevVPastryCrumbBloomRestored, "5T".wevVPastryCrumbBloomRestored, "6b".wevVPastryCrumbBloomRestored, "7F".wevVPastryCrumbBloomRestored],
            ["8L".wevVPastryCrumbBloomRestored, "9W".wevVPastryCrumbBloomRestored, "1H0i".wevVPastryCrumbBloomRestored, "1/1T".wevVPastryCrumbBloomRestored, "1j2K".wevVPastryCrumbBloomRestored, "1F3Q".wevVPastryCrumbBloomRestored, "1L4D".wevVPastryCrumbBloomRestored],
            ["1Q5#".wevVPastryCrumbBloomRestored, "1M6I".wevVPastryCrumbBloomRestored, "1c7T".wevVPastryCrumbBloomRestored, "1g8h".wevVPastryCrumbBloomRestored, "1#9z".wevVPastryCrumbBloomRestored, "2^0D".wevVPastryCrumbBloomRestored, "2e1Y".wevVPastryCrumbBloomRestored],
            ["2,2F".wevVPastryCrumbBloomRestored, "2j3S".wevVPastryCrumbBloomRestored, "2e4Q".wevVPastryCrumbBloomRestored, "2%5G".wevVPastryCrumbBloomRestored, "2/6W".wevVPastryCrumbBloomRestored, "2?7?".wevVPastryCrumbBloomRestored, "2c8E".wevVPastryCrumbBloomRestored],
            ["2c9n".wevVPastryCrumbBloomRestored, "3b0O".wevVPastryCrumbBloomRestored, "3d1S".wevVPastryCrumbBloomRestored, "", "", "", ""]
        ]
        for week in weeks {
            let donutRow = UIStackView()
            donutRow.translatesAutoresizingMaskIntoConstraints = false
            donutRow.axis = .horizontal
            donutRow.distribution = .fillEqually
            donutRow.alignment = .center
            for day in week {
                donutRow.addArrangedSubview(makeBakeryDaySlot(day))
            }
            bakeryWeekStack.addArrangedSubview(donutRow)
        }

        treatCaseCard.addSubview(month)
        treatCaseCard.addSubview(neonSignal)
        treatCaseCard.addSubview(bakeryWeekStack)

        NSLayoutConstraint.activate([
            month.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 20),
            month.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 25),
            neonSignal.centerYAnchor.constraint(equalTo: month.centerYAnchor),
            neonSignal.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -24),
            neonSignal.widthAnchor.constraint(equalToConstant: 52),
            neonSignal.heightAnchor.constraint(equalToConstant: 28),
            bakeryWeekStack.topAnchor.constraint(equalTo: month.bottomAnchor, constant: 24),
            bakeryWeekStack.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 22),
            bakeryWeekStack.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -22),
            bakeryWeekStack.bottomAnchor.constraint(lessThanOrEqualTo: treatCaseCard.bottomAnchor, constant: -28)
        ])
        return treatCaseCard
    }

    private func makeBakeryDaySlot(_ text: String) -> UIView {
        let bakeryDaySlot = UIView()
        bakeryDaySlot.translatesAutoresizingMaskIntoConstraints = false
        let sugarDustLabel = makeDonutStampLabel(text, size: 12, weight: .heavy, color: UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1))
        sugarDustLabel.textAlignment = .center
        sugarDustLabel.layer.cornerRadius = 17
        sugarDustLabel.clipsToBounds = true
        bakeryDaySlot.addSubview(sugarDustLabel)
        NSLayoutConstraint.activate([
            bakeryDaySlot.heightAnchor.constraint(equalToConstant: 34),
            sugarDustLabel.centerXAnchor.constraint(equalTo: bakeryDaySlot.centerXAnchor),
            sugarDustLabel.centerYAnchor.constraint(equalTo: bakeryDaySlot.centerYAnchor),
            sugarDustLabel.widthAnchor.constraint(equalToConstant: 34),
            sugarDustLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        if let value = Int(text) {
            bakeryDayDots[value] = sugarDustLabel
            applyDonutDayStyle(sugarDustLabel, value: value)
        }
        return bakeryDaySlot
    }

    private func applyDonutDayStyle(_ sugarDustLabel: UILabel, value: Int) {
        sugarDustLabel.backgroundColor = .clear
        sugarDustLabel.textColor = UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1)
        sugarDustLabel.layer.borderWidth = 0
        if value <= 12 || (value == selectedDonutDay && donutJournalStore.hasDailyDonutStamp(dayKey: dailyDonutKey)) {
            sugarDustLabel.backgroundColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
            sugarDustLabel.textColor = .white
        } else if value == selectedDonutDay {
            sugarDustLabel.layer.borderColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1).cgColor
            sugarDustLabel.layer.borderWidth = 1.1
            sugarDustLabel.textColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
        }
    }

    private func makeDonutMoodOption(wevvcookieFlavor: String, wevvbakeryAtlas: CGFloat, opacity: CGFloat) -> UIControl {
        let donutMoodButton = UIControl()
        donutMoodButton.translatesAutoresizingMaskIntoConstraints = false
        donutMoodButton.accessibilityIdentifier = wevvcookieFlavor
        donutMoodButton.addTarget(self, action: #selector(selectDonutMood(_:)), for: .touchUpInside)
        donutMoodButton.layer.cornerRadius = 7

        let donutMoodRing = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        donutMoodRing.translatesAutoresizingMaskIntoConstraints = false
        donutMoodRing.contentMode = .scaleAspectFit
        donutMoodRing.alpha = opacity
        donutMoodRing.transform = CGAffineTransform(scaleX: wevvbakeryAtlas, y: wevvbakeryAtlas)
        let sugarDustLabel = makeDonutStampLabel(wevvcookieFlavor, size: 12, weight: .heavy, color: UIColor(red: 0.53, green: 0.43, blue: 0.51, alpha: 1))
        sugarDustLabel.textAlignment = .center
        donutMoodButton.addSubview(donutMoodRing)
        donutMoodButton.addSubview(sugarDustLabel)
        donutMoodButtons.append(donutMoodButton)

        NSLayoutConstraint.activate([
            donutMoodButton.heightAnchor.constraint(equalToConstant: 74),
            donutMoodRing.topAnchor.constraint(equalTo: donutMoodButton.topAnchor, constant: 2),
            donutMoodRing.centerXAnchor.constraint(equalTo: donutMoodButton.centerXAnchor),
            donutMoodRing.widthAnchor.constraint(equalToConstant: 48),
            donutMoodRing.heightAnchor.constraint(equalToConstant: 48),
            sugarDustLabel.topAnchor.constraint(equalTo: donutMoodRing.bottomAnchor, constant: 2),
            sugarDustLabel.leadingAnchor.constraint(equalTo: donutMoodButton.leadingAnchor),
            sugarDustLabel.trailingAnchor.constraint(equalTo: donutMoodButton.trailingAnchor)
        ])
        return donutMoodButton
    }

    private func makeDonutStampLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = text
        sugarDustLabel.font = .systemFont(ofSize: size, weight: weight)
        sugarDustLabel.textColor = color
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.75
        return sugarDustLabel
    }

    private func refreshDonutStampState() {
        let hasStamp = donutJournalStore.hasDailyDonutStamp(dayKey: dailyDonutKey)
        donutStampButton.isEnabled = !hasStamp
        donutStampButton.oldFashionedParlor(hasStamp ? "Check-in" : "CchmeGcNkf-*i=nn".wevVPastryCrumbBloomRestored)
        for (value, dot) in bakeryDayDots {
            applyDonutDayStyle(dot, value: value)
        }
        for mood in donutMoodButtons {
            let active = mood.accessibilityIdentifier == selectedDonutMood
            mood.layer.borderWidth = active ? 1.2 : 0
            mood.layer.borderColor = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1).cgColor
            mood.backgroundColor = active ? UIColor(red: 1, green: 0.96, blue: 0.99, alpha: 1) : .clear
        }
    }

    @objc private func selectDonutMood(_ sender: UIControl) {
        selectedDonutMood = sender.accessibilityIdentifier ?? "AYmxaXzLifnIgB".wevVPastryCrumbBloomRestored
        refreshDonutStampState()
    }

    @objc private func placeDailyGlazeStamp() {
        guard donutJournalStore.placeDailyGlazeStamp(dayKey: dailyDonutKey, mood: selectedDonutMood) else {
            refreshDonutStampState()
            return
        }
        onDonutStampChanged?()
        refreshDonutStampState()
    }

    @objc private func closeDailyDonut() {
        dismiss(animated: true)
    }
}
