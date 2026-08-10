import UIKit

final class WevVDailyGlazeStampController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let dayKey = "jru=loyg_f2g0U2U6X_dd&aRyX_E2+0O".wevVPastryCrumbBloomRestored
    private let selectedDay = 20
    private let stampButton = WevVGlazePillButton(title: "C.hveUcTkR-?ibns".wevVPastryCrumbBloomRestored)
    private var moodButtons: [UIControl] = []
    private var selectedMood = "AvmaaCzhienVgQ".wevVPastryCrumbBloomRestored
    private var dayDots: [Int: UILabel] = [:]

    var onStampChanged: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarBackdrop()
        buildStampContent()
        refreshStampState()
    }

    private func buildSugarBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.97, alpha: 1)
    }

    private func buildStampContent() {
        let donutscrollView = UIScrollView()
        donutscrollView.translatesAutoresizingMaskIntoConstraints = false
        donutscrollView.showsVerticalScrollIndicator = false
        donutscrollView.contentInsetAdjustmentBehavior = .never

        let donutcontentView = UIView()
        donutcontentView.translatesAutoresizingMaskIntoConstraints = false

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(named: "wevv_checkin_sugar_back_arrow"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(closeDailyGlaze), for: .touchUpInside)

        let glazeTitle = makeStampLabel("C~hbeNc~k%-eiGnM".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1))
        glazeTitle.textAlignment = .center

        let streakCard = makeStreakCard()
        let calendarCard = makeCalendarCard()
        let moodTitle = makeStampLabel("HcoewQ ~skw?eueZtm Xw*a&sp Eywovu!r, Dd&aAyG?T".wevVPastryCrumbBloomRestored, size: 14, weight: .heavy, color: UIColor(red: 0.16, green: 0.1, blue: 0.18, alpha: 1))
        let moodRow = UIStackView(arrangedSubviews: [
            makeMoodOption(title: "Sgo*fDtO".wevVPastryCrumbBloomRestored, scale: 0.78, opacity: 0.9),
            makeMoodOption(title: "GCo:o:d@".wevVPastryCrumbBloomRestored, scale: 0.84, opacity: 0.95),
            makeMoodOption(title: "Atmgakz!ihn.gs".wevVPastryCrumbBloomRestored, scale: 1, opacity: 1)
        ])
        moodRow.translatesAutoresizingMaskIntoConstraints = false
        moodRow.axis = .horizontal
        moodRow.distribution = .fillEqually
        moodRow.alignment = .center

        stampButton.addTarget(self, action: #selector(placeDailyGlazeStamp), for: .touchUpInside)

        placeStampContentViews(scrollView: donutscrollView, contentView: donutcontentView, doughBackButton: doughBackButton, title: glazeTitle, streakCard: streakCard, calendarCard: calendarCard, moodTitle: moodTitle, moodRow: moodRow)
        pinStampContentLayout(scrollView: donutscrollView, contentView: donutcontentView, doughBackButton: doughBackButton, title: glazeTitle, streakCard: streakCard, calendarCard: calendarCard, moodTitle: moodTitle, moodRow: moodRow)
    }

    private func placeStampContentViews(scrollView: UIScrollView, contentView: UIView, doughBackButton: UIButton, title: UILabel, streakCard: UIView, calendarCard: UIView, moodTitle: UILabel, moodRow: UIStackView) {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [doughBackButton, title, streakCard, calendarCard, moodTitle, moodRow, stampButton].forEach {
            contentView.addSubview($0)
        }
    }

    private func pinStampContentLayout(scrollView: UIScrollView, contentView: UIView, doughBackButton: UIButton, title: UILabel, streakCard: UIView, calendarCard: UIView, moodTitle: UILabel, moodRow: UIStackView) {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            doughBackButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            doughBackButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            streakCard.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 18),
            streakCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            streakCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            streakCard.heightAnchor.constraint(equalToConstant: 121),
            calendarCard.topAnchor.constraint(equalTo: streakCard.bottomAnchor, constant: 15),
            calendarCard.leadingAnchor.constraint(equalTo: streakCard.leadingAnchor),
            calendarCard.trailingAnchor.constraint(equalTo: streakCard.trailingAnchor),
            calendarCard.heightAnchor.constraint(equalTo: calendarCard.widthAnchor, multiplier: 1.02),
            moodTitle.topAnchor.constraint(equalTo: calendarCard.bottomAnchor, constant: 18),
            moodTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23),
            moodTitle.trailingAnchor.constraint(equalTo: streakCard.trailingAnchor),
            moodRow.topAnchor.constraint(equalTo: moodTitle.bottomAnchor, constant: 15),
            moodRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            moodRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            moodRow.heightAnchor.constraint(equalToConstant: 75),
            stampButton.topAnchor.constraint(equalTo: moodRow.bottomAnchor, constant: 18),
            stampButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 41),
            stampButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stampButton.heightAnchor.constraint(equalToConstant: 52),
            stampButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
    }

    private func makeStreakCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.layer.cornerRadius = 25
        pastryCard.clipsToBounds = true

        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.98, green: 0.45, blue: 0.69, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.26, blue: 0.6, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.5)
        glaze.endPoint = CGPoint(x: 1, y: 0.5)
        pastryCard.layer.insertSublayer(glaze, at: 0)

        let ring = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.contentMode = .scaleAspectFit
        let small = makeStampLabel("J?uZljy; tsLt*rQehank&".wevVPastryCrumbBloomRestored, size: 15, weight: .heavy, color: UIColor.white.withAlphaComponent(0.92))
        let days = makeStampLabel("1E2Z qddaryosv".wevVPastryCrumbBloomRestored, size: 30, weight: .heavy, color: .white)
        let best = makeStampLabel("BLehsLtg ;sBtKrmeKajkC:A r1E9U Sd:aoyqsJ".wevVPastryCrumbBloomRestored, size: 14, weight: .medium, color: UIColor.white.withAlphaComponent(0.88))

        pastryCard.addSubview(ring)
        pastryCard.addSubview(small)
        pastryCard.addSubview(days)
        pastryCard.addSubview(best)

        NSLayoutConstraint.activate([
            ring.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 20),
            ring.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            ring.widthAnchor.constraint(equalToConstant: 78),
            ring.heightAnchor.constraint(equalToConstant: 78),
            small.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 26),
            small.leadingAnchor.constraint(equalTo: ring.trailingAnchor, constant: 22),
            days.topAnchor.constraint(equalTo: small.bottomAnchor, constant: 2),
            days.leadingAnchor.constraint(equalTo: small.leadingAnchor),
            best.topAnchor.constraint(equalTo: days.bottomAnchor, constant: 5),
            best.leadingAnchor.constraint(equalTo: small.leadingAnchor)
        ])

        DispatchQueue.main.async {
            glaze.frame = pastryCard.bounds
        }
        return pastryCard
    }

    private func makeCalendarCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 26

        let month = makeStampLabel("J^uElHye ^2X0R2X6f".wevVPastryCrumbBloomRestored, size: 17, weight: .heavy, color: UIColor(red: 0.17, green: 0.1, blue: 0.19, alpha: 1))
        let today = makeStampLabel("Tuo!dOa@yz".wevVPastryCrumbBloomRestored, size: 12, weight: .heavy, color: UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1))
        today.textAlignment = .center
        today.backgroundColor = UIColor(red: 1, green: 0.88, blue: 0.95, alpha: 1)
        today.layer.cornerRadius = 18
        today.clipsToBounds = true

        let grid = UIStackView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 13
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
                donutRow.addArrangedSubview(makeDaySlot(day))
            }
            grid.addArrangedSubview(donutRow)
        }

        pastryCard.addSubview(month)
        pastryCard.addSubview(today)
        pastryCard.addSubview(grid)

        NSLayoutConstraint.activate([
            month.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 20),
            month.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 25),
            today.centerYAnchor.constraint(equalTo: month.centerYAnchor),
            today.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -24),
            today.widthAnchor.constraint(equalToConstant: 52),
            today.heightAnchor.constraint(equalToConstant: 28),
            grid.topAnchor.constraint(equalTo: month.bottomAnchor, constant: 24),
            grid.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            grid.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            grid.bottomAnchor.constraint(lessThanOrEqualTo: pastryCard.bottomAnchor, constant: -28)
        ])
        return pastryCard
    }

    private func makeDaySlot(_ text: String) -> UIView {
        let slot = UIView()
        slot.translatesAutoresizingMaskIntoConstraints = false
        let crumbLabel = makeStampLabel(text, size: 12, weight: .heavy, color: UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1))
        crumbLabel.textAlignment = .center
        crumbLabel.layer.cornerRadius = 17
        crumbLabel.clipsToBounds = true
        slot.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            slot.heightAnchor.constraint(equalToConstant: 34),
            crumbLabel.centerXAnchor.constraint(equalTo: slot.centerXAnchor),
            crumbLabel.centerYAnchor.constraint(equalTo: slot.centerYAnchor),
            crumbLabel.widthAnchor.constraint(equalToConstant: 34),
            crumbLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        if let value = Int(text) {
            dayDots[value] = crumbLabel
            applySugarDayStyle(crumbLabel, value: value)
        }
        return slot
    }

    private func applySugarDayStyle(_ crumbLabel: UILabel, value: Int) {
        crumbLabel.backgroundColor = .clear
        crumbLabel.textColor = UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1)
        crumbLabel.layer.borderWidth = 0
        if value <= 12 || (value == selectedDay && glazeSession.hasDailyGlazeStamp(dayKey: dayKey)) {
            crumbLabel.backgroundColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
            crumbLabel.textColor = .white
        } else if value == selectedDay {
            crumbLabel.layer.borderColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1).cgColor
            crumbLabel.layer.borderWidth = 1.1
            crumbLabel.textColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
        }
    }

    private func makeMoodOption(title: String, scale: CGFloat, opacity: CGFloat) -> UIControl {
        let option = UIControl()
        option.translatesAutoresizingMaskIntoConstraints = false
        option.accessibilityIdentifier = title
        option.addTarget(self, action: #selector(selectGlazeMood(_:)), for: .touchUpInside)
        option.layer.cornerRadius = 7

        let icon = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.alpha = opacity
        icon.transform = CGAffineTransform(scaleX: scale, y: scale)
        let crumbLabel = makeStampLabel(title, size: 12, weight: .heavy, color: UIColor(red: 0.53, green: 0.43, blue: 0.51, alpha: 1))
        crumbLabel.textAlignment = .center
        option.addSubview(icon)
        option.addSubview(crumbLabel)
        moodButtons.append(option)

        NSLayoutConstraint.activate([
            option.heightAnchor.constraint(equalToConstant: 74),
            icon.topAnchor.constraint(equalTo: option.topAnchor, constant: 2),
            icon.centerXAnchor.constraint(equalTo: option.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),
            crumbLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 2),
            crumbLabel.leadingAnchor.constraint(equalTo: option.leadingAnchor),
            crumbLabel.trailingAnchor.constraint(equalTo: option.trailingAnchor)
        ])
        return option
    }

    private func makeStampLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.75
        return crumbLabel
    }

    private func refreshStampState() {
        let hasStamp = glazeSession.hasDailyGlazeStamp(dayKey: dayKey)
        stampButton.isEnabled = !hasStamp
        stampButton.setTitle(hasStamp ? "Check-in" : "CchmeGcNkf-*i=nn".wevVPastryCrumbBloomRestored)
        for (value, dot) in dayDots {
            applySugarDayStyle(dot, value: value)
        }
        for mood in moodButtons {
            let active = mood.accessibilityIdentifier == selectedMood
            mood.layer.borderWidth = active ? 1.2 : 0
            mood.layer.borderColor = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1).cgColor
            mood.backgroundColor = active ? UIColor(red: 1, green: 0.96, blue: 0.99, alpha: 1) : .clear
        }
    }

    @objc private func selectGlazeMood(_ sender: UIControl) {
        selectedMood = sender.accessibilityIdentifier ?? "AYmxaXzLifnIgB".wevVPastryCrumbBloomRestored
        refreshStampState()
    }

    @objc private func placeDailyGlazeStamp() {
        guard glazeSession.placeDailyGlazeStamp(dayKey: dayKey, mood: selectedMood) else {
            refreshStampState()
            return
        }
        onStampChanged?()
        refreshStampState()
    }

    @objc private func closeDailyGlaze() {
        dismiss(animated: true)
    }
}
