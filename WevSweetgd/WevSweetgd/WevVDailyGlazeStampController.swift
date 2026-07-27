import UIKit

final class WevVDailyGlazeStampController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let dayKey = "july_2026_day_20"
    private let selectedDay = 20
    private let stampButton = WevVGlazePillButton(title: "Check-in")
    private var moodButtons: [UIControl] = []
    private var selectedMood = "Amazing"
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
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "wevv_checkin_sugar_back_arrow"), for: .normal)
        backButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        backButton.addTarget(self, action: #selector(closeDailyGlaze), for: .touchUpInside)

        let title = makeStampLabel("Check-in", size: 17, weight: .heavy, color: UIColor(red: 0.13, green: 0.08, blue: 0.18, alpha: 1))
        title.textAlignment = .center

        let streakCard = makeStreakCard()
        let calendarCard = makeCalendarCard()
        let moodTitle = makeStampLabel("How sweet was your day?", size: 14, weight: .heavy, color: UIColor(red: 0.16, green: 0.1, blue: 0.18, alpha: 1))
        let moodRow = UIStackView(arrangedSubviews: [
            makeMoodOption(title: "Soft", scale: 0.78, opacity: 0.9),
            makeMoodOption(title: "Good", scale: 0.84, opacity: 0.95),
            makeMoodOption(title: "Amazing", scale: 1, opacity: 1)
        ])
        moodRow.translatesAutoresizingMaskIntoConstraints = false
        moodRow.axis = .horizontal
        moodRow.distribution = .fillEqually
        moodRow.alignment = .center

        stampButton.addTarget(self, action: #selector(placeDailyGlazeStamp), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(title)
        contentView.addSubview(streakCard)
        contentView.addSubview(calendarCard)
        contentView.addSubview(moodTitle)
        contentView.addSubview(moodRow)
        contentView.addSubview(stampButton)

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
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            streakCard.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 18),
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
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 25
        card.clipsToBounds = true

        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.98, green: 0.45, blue: 0.69, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.26, blue: 0.6, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.5)
        glaze.endPoint = CGPoint(x: 1, y: 0.5)
        card.layer.insertSublayer(glaze, at: 0)

        let ring = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.contentMode = .scaleAspectFit
        let small = makeStampLabel("July streak", size: 15, weight: .heavy, color: UIColor.white.withAlphaComponent(0.92))
        let days = makeStampLabel("12 days", size: 30, weight: .heavy, color: .white)
        let best = makeStampLabel("Best streak: 19 days", size: 14, weight: .medium, color: UIColor.white.withAlphaComponent(0.88))

        card.addSubview(ring)
        card.addSubview(small)
        card.addSubview(days)
        card.addSubview(best)

        NSLayoutConstraint.activate([
            ring.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            ring.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            ring.widthAnchor.constraint(equalToConstant: 78),
            ring.heightAnchor.constraint(equalToConstant: 78),
            small.topAnchor.constraint(equalTo: card.topAnchor, constant: 26),
            small.leadingAnchor.constraint(equalTo: ring.trailingAnchor, constant: 22),
            days.topAnchor.constraint(equalTo: small.bottomAnchor, constant: 2),
            days.leadingAnchor.constraint(equalTo: small.leadingAnchor),
            best.topAnchor.constraint(equalTo: days.bottomAnchor, constant: 5),
            best.leadingAnchor.constraint(equalTo: small.leadingAnchor)
        ])

        DispatchQueue.main.async {
            glaze.frame = card.bounds
        }
        return card
    }

    private func makeCalendarCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 26

        let month = makeStampLabel("July 2026", size: 17, weight: .heavy, color: UIColor(red: 0.17, green: 0.1, blue: 0.19, alpha: 1))
        let today = makeStampLabel("Today", size: 12, weight: .heavy, color: UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1))
        today.textAlignment = .center
        today.backgroundColor = UIColor(red: 1, green: 0.88, blue: 0.95, alpha: 1)
        today.layer.cornerRadius = 18
        today.clipsToBounds = true

        let grid = UIStackView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 13
        let weeks = [
            ["S", "M", "T", "W", "T", "F", "S"],
            ["1", "2", "3", "4", "5", "6", "7"],
            ["8", "9", "10", "11", "12", "13", "14"],
            ["15", "16", "17", "18", "19", "20", "21"],
            ["22", "23", "24", "25", "26", "27", "28"],
            ["29", "30", "31", "", "", "", ""]
        ]
        for week in weeks {
            let row = UIStackView()
            row.translatesAutoresizingMaskIntoConstraints = false
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.alignment = .center
            for day in week {
                row.addArrangedSubview(makeDaySlot(day))
            }
            grid.addArrangedSubview(row)
        }

        card.addSubview(month)
        card.addSubview(today)
        card.addSubview(grid)

        NSLayoutConstraint.activate([
            month.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            month.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 25),
            today.centerYAnchor.constraint(equalTo: month.centerYAnchor),
            today.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            today.widthAnchor.constraint(equalToConstant: 52),
            today.heightAnchor.constraint(equalToConstant: 28),
            grid.topAnchor.constraint(equalTo: month.bottomAnchor, constant: 24),
            grid.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            grid.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            grid.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -28)
        ])
        return card
    }

    private func makeDaySlot(_ text: String) -> UIView {
        let slot = UIView()
        slot.translatesAutoresizingMaskIntoConstraints = false
        let label = makeStampLabel(text, size: 12, weight: .heavy, color: UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1))
        label.textAlignment = .center
        label.layer.cornerRadius = 17
        label.clipsToBounds = true
        slot.addSubview(label)
        NSLayoutConstraint.activate([
            slot.heightAnchor.constraint(equalToConstant: 34),
            label.centerXAnchor.constraint(equalTo: slot.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: slot.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 34),
            label.heightAnchor.constraint(equalToConstant: 34)
        ])
        if let value = Int(text) {
            dayDots[value] = label
            applySugarDayStyle(label, value: value)
        }
        return slot
    }

    private func applySugarDayStyle(_ label: UILabel, value: Int) {
        label.backgroundColor = .clear
        label.textColor = UIColor(red: 0.51, green: 0.42, blue: 0.49, alpha: 1)
        label.layer.borderWidth = 0
        if value <= 12 || (value == selectedDay && glazeSession.hasDailyGlazeStamp(dayKey: dayKey)) {
            label.backgroundColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
            label.textColor = .white
        } else if value == selectedDay {
            label.layer.borderColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1).cgColor
            label.layer.borderWidth = 1.1
            label.textColor = UIColor(red: 1, green: 0.31, blue: 0.63, alpha: 1)
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
        let label = makeStampLabel(title, size: 12, weight: .heavy, color: UIColor(red: 0.53, green: 0.43, blue: 0.51, alpha: 1))
        label.textAlignment = .center
        option.addSubview(icon)
        option.addSubview(label)
        moodButtons.append(option)

        NSLayoutConstraint.activate([
            option.heightAnchor.constraint(equalToConstant: 74),
            icon.topAnchor.constraint(equalTo: option.topAnchor, constant: 2),
            icon.centerXAnchor.constraint(equalTo: option.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: option.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: option.trailingAnchor)
        ])
        return option
    }

    private func makeStampLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }

    private func refreshStampState() {
        let hasStamp = glazeSession.hasDailyGlazeStamp(dayKey: dayKey)
        stampButton.isEnabled = !hasStamp
        stampButton.setTitle(hasStamp ? "Check-in" : "Check-in")
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
        selectedMood = sender.accessibilityIdentifier ?? "Amazing"
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
