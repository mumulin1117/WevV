import UIKit

/// A temporary representation of feed requests or a detail page's first presentation.
/// The host decides when a request has settled; this view owns only presentation.
final class WevVGlazeMessageCell: UIView {
    enum glazeNameLabel {
        case home, voice, moments
        case sprinkleChallenge, pastryFolio
    }

    private struct glazePackCards {
        let backdrop: [UIColor]
        let surface: UIColor
        let block: UIColor
        let detail: UIColor
        let highlight: UIColor

        // Match the packaged H5's sRGB color-mix skeleton tokens.
        static let shared = glazePackCards(
            backdrop: [UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 33 / 255.0, alpha: 1), UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 33 / 255.0, alpha: 1)],
            surface: UIColor(red: 6.4 / 255.0, green: 5.44 / 255.0, blue: 38.12 / 255.0, alpha: 1),
            block: UIColor(red: 35.2 / 255.0, green: 29.92 / 255.0, blue: 61.16 / 255.0, alpha: 1),
            detail: UIColor(red: 35.2 / 255.0, green: 29.92 / 255.0, blue: 61.16 / 255.0, alpha: 1),
            highlight: UIColor(red: 78.3 / 255.0, green: 47.38 / 255.0, blue: 112.42 / 255.0, alpha: 1)
        )
    }

    private let kind: glazeNameLabel
    private let palette: glazePackCards
    private let backdrop = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let content = UIStackView()
    private var tiles: [glazeSaveTask] = []
    private var loadingVisible = false
    private var transitionID: UInt = 0
    private var applicationActive = UIApplication.shared.applicationState == .active

    init(kind: glazeNameLabel) {
        self.kind = kind
        self.palette = .shared
        super.init(frame: .zero)
        isHidden = true
        clipsToBounds = true
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        switch kind {
        case .home: accessibilityLabel = "Loading live rooms"
        case .voice: accessibilityLabel = "Loading voice rooms"
        case .moments: accessibilityLabel = "Loading community posts"
        case .sprinkleChallenge: accessibilityLabel = "Loading challenge details"
        case .pastryFolio: accessibilityLabel = "Loading shop details"
        }
        accessibilityIdentifier = "wevv.initialLoading.\(kind)"
        backgroundColor = palette.backdrop.first
        backdrop.colors = palette.backdrop.map(\.cgColor)
        backdrop.startPoint = CGPoint(x: 0.15, y: 0)
        backdrop.endPoint = CGPoint(x: 0.9, y: 1)
        layer.insertSublayer(backdrop, at: 0)
        buildLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reduceMotionChanged),
                                               name: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) { nil }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layer geometry follows the Auto Layout managed view, never a device-specific frame.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backdrop.frame = bounds
        CATransaction.commit()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateAnimations()
    }

    override var isHidden: Bool {
        didSet { updateAnimations() }
    }

    func setLoadingVisible(_ visible: Bool, animated: Bool = true) {
        guard loadingVisible != visible else {
            updateAnimations()
            return
        }
        loadingVisible = visible
        transitionID &+= 1
        let currentTransition = transitionID
        layer.removeAllAnimations()
        accessibilityElementsHidden = !visible
        let shouldAnimate = animated && window != nil && !UIAccessibility.isReduceMotionEnabled
        if visible {
            let wasHidden = isHidden
            isHidden = false
            if wasHidden { alpha = shouldAnimate ? 0 : 1 }
            updateAnimations()
            if shouldAnimate {
                UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.alpha = 1
                }
            } else {
                alpha = 1
            }
        } else {
            updateAnimations()
            let finish = { [weak self] in
                guard let self, !self.loadingVisible, self.transitionID == currentTransition else { return }
                self.isHidden = true
                self.alpha = 1
                self.scrollView.setContentOffset(.zero, animated: false)
            }
            if shouldAnimate {
                UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction],
                               animations: { self.alpha = 0 }, completion: { _ in finish() })
            } else {
                finish()
            }
        }
    }

    private func buildLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = false
        scrollView.accessibilityElementsHidden = true
        content.translatesAutoresizingMaskIntoConstraints = false
        content.axis = .vertical
        content.spacing = 14
        addSubview(scrollView)
        scrollView.addSubview(content)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: kind == .sprinkleChallenge || kind == .pastryFolio ? 0 : 24),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 15),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -15),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -30)
        ])
        if kind != .sprinkleChallenge && kind != .pastryFolio { buildHeader() }
        switch kind {
        case .home: buildHome()
        case .voice: buildVoice()
        case .moments: buildMoments()
        case .sprinkleChallenge: buildChallengeContent()
        case .pastryFolio: buildPastryDetailContent()
        }
    }

    private func buildChallengeContent() {
        let hero = tile(radius: 18)
        content.addArrangedSubview(hero)
        hero.heightAnchor.constraint(equalToConstant: 173).isActive = true
        addSectionLine(fraction: 0.25)
        let progressCard = surface(radius: 18)
        let title = tile(radius: 6)
        let sub = tile(radius: 6)
        [title, sub].forEach(progressCard.addSubview)
        content.addArrangedSubview(progressCard)
        NSLayoutConstraint.activate([
            progressCard.heightAnchor.constraint(equalToConstant: 61),
            title.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 26),
            title.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 14),
            title.widthAnchor.constraint(equalTo: progressCard.widthAnchor, multiplier: 0.62),
            title.heightAnchor.constraint(equalToConstant: 12),
            sub.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            sub.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 9),
            sub.widthAnchor.constraint(equalTo: progressCard.widthAnchor, multiplier: 0.46),
            sub.heightAnchor.constraint(equalToConstant: 12)
        ])
        addSectionLine(fraction: 0.22)
        let avatar = tile(radius: 24)
        let name = tile(radius: 6)
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        [avatar, name].forEach(card.addSubview)
        content.addArrangedSubview(card)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 48),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            avatar.topAnchor.constraint(equalTo: card.topAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            name.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.46),
            name.heightAnchor.constraint(equalToConstant: 16)
        ])
        let detail = tile(radius: 6)
        content.addArrangedSubview(detail)
        detail.heightAnchor.constraint(equalToConstant: 38).isActive = true
        let peopleButton = tile(radius: 14)
        content.addArrangedSubview(peopleButton)
        peopleButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
    }

    private func buildPastryDetailContent() {
        let card = surface(radius: 16)
        let cover = tile(radius: 12)
        let title = tile(radius: 6)
        let sub = tile(radius: 6)
        let detail = tile(radius: 6)
        [cover, title, sub, detail].forEach(card.addSubview)
        content.addArrangedSubview(card)
        NSLayoutConstraint.activate([
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15),
            cover.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.38),
            cover.heightAnchor.constraint(equalTo: cover.widthAnchor),
            title.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: cover.topAnchor, constant: 4),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15),
            title.heightAnchor.constraint(equalToConstant: 17),
            sub.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            sub.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            sub.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            sub.heightAnchor.constraint(equalToConstant: 13),
            detail.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            detail.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            detail.topAnchor.constraint(equalTo: sub.bottomAnchor, constant: 16),
            detail.heightAnchor.constraint(equalToConstant: 34)
        ])
        addSectionLine(fraction: 0.38)
        let row = horizontalStack(spacing: 10)
        for _ in 0..<3 { row.addArrangedSubview(tile(radius: 16)) }
        content.addArrangedSubview(row)
        row.heightAnchor.constraint(equalToConstant: 140).isActive = true
        addSectionLine(fraction: 0.32)
        for _ in 0..<2 {
            let card = tile(radius: 16)
            content.addArrangedSubview(card)
            card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }

    private func buildHeader() {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        content.addArrangedSubview(header)
        let logo = tile(radius: 8)
        let notice = tile(radius: 15)
        header.addSubview(logo)
        header.addSubview(notice)
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 30),
            logo.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            logo.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            logo.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: kind == .moments ? 0.36 : 0.28),
            logo.heightAnchor.constraint(equalToConstant: 28),
            notice.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            notice.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            notice.widthAnchor.constraint(equalToConstant: 30),
            notice.heightAnchor.constraint(equalTo: notice.widthAnchor)
        ])
        if kind == .home {
            let action = tile(radius: 12)
            header.addSubview(action)
            NSLayoutConstraint.activate([
                action.centerYAnchor.constraint(equalTo: header.centerYAnchor),
                action.trailingAnchor.constraint(equalTo: notice.leadingAnchor, constant: -14),
                action.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.28),
                action.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
    }

    private func buildHome() {
        let banner = tile(radius: 14)
        content.addArrangedSubview(banner)
        banner.heightAnchor.constraint(equalTo: banner.widthAnchor, multiplier: 95.0 / 345.0).isActive = true
        let activity = horizontalStack(spacing: 10)
        activity.addArrangedSubview(tile(radius: 18))
        let activitySide = UIStackView()
        activitySide.axis = .vertical
        activitySide.spacing = 10
        activitySide.distribution = .fillEqually
        activitySide.addArrangedSubview(tile(radius: 18))
        activitySide.addArrangedSubview(tile(radius: 18))
        activity.addArrangedSubview(activitySide)
        content.addArrangedSubview(activity)
        activity.heightAnchor.constraint(equalTo: activity.widthAnchor, multiplier: 0.60).isActive = true
        addSectionLine(fraction: 0.31)
        for _ in 0..<2 {
            let row = horizontalStack(spacing: 10)
            for _ in 0..<2 {
                let card = tile(radius: 14)
                let badge = tile(radius: 7, detail: true)
                let title = tile(radius: 6, detail: true)
                card.addSubview(badge)
                card.addSubview(title)
                row.addArrangedSubview(card)
                NSLayoutConstraint.activate([
                    card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.99),
                    badge.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
                    badge.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                    badge.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.32),
                    badge.heightAnchor.constraint(equalToConstant: 17),
                    title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
                    title.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15),
                    title.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.62),
                    title.heightAnchor.constraint(equalToConstant: 13)
                ])
            }
            content.addArrangedSubview(row)
        }
    }

    private func buildVoice() {
        let hotRow = horizontalStack(spacing: 10)
        for _ in 0..<3 {
            let hot = tile(radius: 13)
            hot.heightAnchor.constraint(equalToConstant: 52).isActive = true
            hotRow.addArrangedSubview(hot)
        }
        content.addArrangedSubview(hotRow)
        addTabLines()
        let owners = horizontalStack(spacing: 18)
        for _ in 0..<5 {
            let owner = UIStackView()
            owner.axis = .vertical
            owner.alignment = .center
            owner.spacing = 9
            let avatar = tile(radius: 28)
            let name = tile(radius: 5)
            owner.addArrangedSubview(avatar)
            owner.addArrangedSubview(name)
            NSLayoutConstraint.activate([
                avatar.widthAnchor.constraint(equalTo: owner.widthAnchor),
                avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),
                name.widthAnchor.constraint(equalTo: owner.widthAnchor, multiplier: 0.82),
                name.heightAnchor.constraint(equalToConstant: 10)
            ])
            owners.addArrangedSubview(owner)
        }
        content.addArrangedSubview(owners)
        for _ in 0..<3 {
            let card = surface(radius: 14)
            let avatar = tile(radius: 27)
            let title = tile(radius: 7)
            let caption = tile(radius: 5)
            let join = tile(radius: 10.5, detail: true)
            [avatar, title, caption, join].forEach(card.addSubview)
            content.addArrangedSubview(card)
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalToConstant: 124),
                avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                avatar.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                avatar.widthAnchor.constraint(equalToConstant: 54),
                avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),
                title.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),
                title.topAnchor.constraint(equalTo: card.topAnchor, constant: 29),
                title.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.43),
                title.heightAnchor.constraint(equalToConstant: 16),
                caption.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                caption.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 13),
                caption.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.30),
                caption.heightAnchor.constraint(equalToConstant: 11),
                join.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15),
                join.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15),
                join.widthAnchor.constraint(equalToConstant: 55),
                join.heightAnchor.constraint(equalToConstant: 21)
            ])
        }
    }

    private func buildMoments() {
        addTabLines()
        let featured = UIView()
        featured.translatesAutoresizingMaskIntoConstraints = false
        content.addArrangedSubview(featured)
        let hero = surface(radius: 18)
        let image = tile(radius: 13)
        let caption = tile(radius: 6)
        let sides = UIStackView()
        sides.translatesAutoresizingMaskIntoConstraints = false
        sides.axis = .vertical
        sides.spacing = 8
        sides.distribution = .fillEqually
        for _ in 0..<3 { sides.addArrangedSubview(tile(radius: 12)) }
        [hero, sides].forEach(featured.addSubview)
        [image, caption].forEach(hero.addSubview)
        NSLayoutConstraint.activate([
            featured.heightAnchor.constraint(equalTo: featured.widthAnchor, multiplier: 1.04),
            hero.leadingAnchor.constraint(equalTo: featured.leadingAnchor),
            hero.topAnchor.constraint(equalTo: featured.topAnchor),
            hero.bottomAnchor.constraint(equalTo: featured.bottomAnchor),
            hero.widthAnchor.constraint(equalTo: featured.widthAnchor, multiplier: 0.68),
            sides.leadingAnchor.constraint(equalTo: hero.trailingAnchor, constant: 10),
            sides.trailingAnchor.constraint(equalTo: featured.trailingAnchor),
            sides.topAnchor.constraint(equalTo: featured.topAnchor),
            sides.bottomAnchor.constraint(equalTo: featured.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 10),
            image.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -10),
            image.topAnchor.constraint(equalTo: hero.topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: hero.bottomAnchor, constant: -61),
            caption.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            caption.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 17),
            caption.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.76),
            caption.heightAnchor.constraint(equalToConstant: 14)
        ])
        addSectionLine(fraction: 0.30)
        for _ in 0..<2 { content.addArrangedSubview(makeMomentCard()) }
    }

    private func makeMomentCard() -> UIView {
        let card = surface(radius: 16)
        let author = tile(radius: 19)
        let name = tile(radius: 6)
        let line = tile(radius: 5)
        let shortLine = tile(radius: 5)
        let picture = tile(radius: 13)
        [author, name, line, shortLine, picture].forEach(card.addSubview)
        NSLayoutConstraint.activate([
            author.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            author.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            author.widthAnchor.constraint(equalToConstant: 38),
            author.heightAnchor.constraint(equalTo: author.widthAnchor),
            name.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: 10),
            name.centerYAnchor.constraint(equalTo: author.centerYAnchor),
            name.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.35),
            name.heightAnchor.constraint(equalToConstant: 13),
            line.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 14),
            line.leadingAnchor.constraint(equalTo: author.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            line.heightAnchor.constraint(equalToConstant: 11),
            shortLine.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 8),
            shortLine.leadingAnchor.constraint(equalTo: line.leadingAnchor),
            shortLine.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.60),
            shortLine.heightAnchor.constraint(equalToConstant: 11),
            picture.topAnchor.constraint(equalTo: shortLine.bottomAnchor, constant: 14),
            picture.leadingAnchor.constraint(equalTo: author.leadingAnchor),
            picture.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            picture.heightAnchor.constraint(equalTo: picture.widthAnchor, multiplier: 0.67),
            picture.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
        return card
    }

    private func addSectionLine(fraction: CGFloat) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let line = tile(radius: 7)
        container.addSubview(line)
        content.addArrangedSubview(container)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 28),
            line.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            line.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            line.heightAnchor.constraint(equalToConstant: 19),
            line.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: fraction)
        ])
    }

    private func addTabLines() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let first = tile(radius: 6)
        let second = tile(radius: 6)
        let underline = tile(radius: 2, detail: true)
        [first, second, underline].forEach(container.addSubview)
        content.addArrangedSubview(container)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 36),
            first.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            first.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            first.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.23),
            first.heightAnchor.constraint(equalToConstant: 20),
            second.leadingAnchor.constraint(equalTo: first.trailingAnchor, constant: 18),
            second.centerYAnchor.constraint(equalTo: first.centerYAnchor),
            second.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.29),
            second.heightAnchor.constraint(equalToConstant: 20),
            underline.topAnchor.constraint(equalTo: first.bottomAnchor, constant: 7),
            underline.centerXAnchor.constraint(equalTo: kind == .voice ? second.centerXAnchor : first.centerXAnchor),
            underline.widthAnchor.constraint(equalToConstant: 22),
            underline.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    private func horizontalStack(spacing: CGFloat) -> UIStackView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = spacing
        return row
    }

    private func surface(radius: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = palette.surface
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.isAccessibilityElement = false
        return view
    }

    private func tile(radius: CGFloat, detail: Bool = false) -> glazeSaveTask {
        let view = glazeSaveTask(base: detail ? palette.detail : palette.block,
                                        highlight: palette.highlight, radius: radius)
        view.translatesAutoresizingMaskIntoConstraints = false
        tiles.append(view)
        return view
    }

    @objc private func applicationWillResignActive() {
        applicationActive = false
        updateAnimations()
    }

    @objc private func applicationDidBecomeActive() {
        applicationActive = true
        updateAnimations()
    }

    @objc private func reduceMotionChanged() { updateAnimations() }

    private func updateAnimations() {
        let animate = loadingVisible && !isHidden && window != nil && applicationActive
            && !UIAccessibility.isReduceMotionEnabled
        tiles.forEach { $0.setAnimating(animate) }
    }
}

private final class glazeSaveTask: UIView {
    private let shimmer = CAGradientLayer()
    private let preferredCornerRadius: CGFloat

    init(base: UIColor, highlight: UIColor, radius: CGFloat) {
        preferredCornerRadius = radius
        super.init(frame: .zero)
        backgroundColor = base
        layer.cornerRadius = radius
        clipsToBounds = true
        isAccessibilityElement = false
        isUserInteractionEnabled = false
        shimmer.colors = [UIColor.clear.cgColor, highlight.cgColor, UIColor.clear.cgColor]
        shimmer.locations = [-1, -0.5, 0]
        shimmer.startPoint = CGPoint(x: 0, y: 0.25)
        shimmer.endPoint = CGPoint(x: 1, y: 0.75)
        layer.addSublayer(shimmer)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shimmer.frame = bounds
        layer.cornerRadius = min(preferredCornerRadius, min(bounds.width, bounds.height) / 2)
        CATransaction.commit()
    }

    func setAnimating(_ enabled: Bool) {
        guard enabled else {
            shimmer.removeAnimation(forKey: "wevvSkeletonSweep")
            return
        }
        guard shimmer.animation(forKey: "wevvSkeletonSweep") == nil else { return }
        let sweep = CABasicAnimation(keyPath: "locations")
        sweep.fromValue = [-1.0, -0.5, 0.0]
        sweep.toValue = [1.0, 1.5, 2.0]
        sweep.duration = 1.45
        sweep.repeatCount = .infinity
        sweep.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shimmer.add(sweep, forKey: "wevvSkeletonSweep")
    }
}
