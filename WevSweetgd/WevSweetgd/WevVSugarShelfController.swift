import UIKit

final class WevVWevvBakeryShelfController: UIViewController {
    var onWevvShelfChanged: (() -> Void)?

    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let bakeryDetails: [WevVWevvBakeryDetail]
    private let wevvPastryScroll = UIScrollView()
    private let wevvBakeryCanvas = UIView()
    private let wevvShelfStack = UIStackView()
    private let wevvCreamTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.18, green: 0.12, blue: 0.24, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.58, green: 0.46, blue: 0.55, alpha: 1)
    private let wevvBerryTone = UIColor(red: 1, green: 0.3, blue: 0.64, alpha: 1)

    init(bakeryDetails: [WevVWevvBakeryDetail]) {
        self.bakeryDetails = bakeryDetails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildWevvBakeryShelfPage()
        reloadWevvBakeryShelfRows()
    }

    private func buildWevvBakeryShelfPage() {
        view.backgroundColor = wevvCreamTone

        let pistachioFlavor = UIButton(type: .system)
        pistachioFlavor.translatesAutoresizingMaskIntoConstraints = false
        pistachioFlavor.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        pistachioFlavor.tintColor = .black
        pistachioFlavor.addTarget(self, action: #selector(closeWevvBakeryShelf), for: .touchUpInside)

        let glazeTitle = makeWevvShelfLabel("SJaFvJej js*h#o?pD".wevVPastryCrumbBloomRestored, size: 26, weight: .heavy, color: wevvCocoaTone)
        glazeTitle.textAlignment = .center

        wevvPastryScroll.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryScroll.alwaysBounceVertical = true
        view.addSubview(pistachioFlavor)
        view.addSubview(glazeTitle)
        view.addSubview(wevvPastryScroll)

        wevvBakeryCanvas.translatesAutoresizingMaskIntoConstraints = false
        wevvPastryScroll.addSubview(wevvBakeryCanvas)

        wevvShelfStack.translatesAutoresizingMaskIntoConstraints = false
        wevvShelfStack.axis = .vertical
        wevvShelfStack.spacing = 14
        wevvBakeryCanvas.addSubview(wevvShelfStack)

        NSLayoutConstraint.activate([
            pistachioFlavor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            pistachioFlavor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            pistachioFlavor.widthAnchor.constraint(equalToConstant: 44),
            pistachioFlavor.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeTitle.centerYAnchor.constraint(equalTo: pistachioFlavor.centerYAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: pistachioFlavor.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            wevvPastryScroll.topAnchor.constraint(equalTo: pistachioFlavor.bottomAnchor, constant: 20),
            wevvPastryScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wevvPastryScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wevvPastryScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvBakeryCanvas.topAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.topAnchor),
            wevvBakeryCanvas.leadingAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.leadingAnchor),
            wevvBakeryCanvas.trailingAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.trailingAnchor),
            wevvBakeryCanvas.bottomAnchor.constraint(equalTo: wevvPastryScroll.contentLayoutGuide.bottomAnchor),
            wevvBakeryCanvas.widthAnchor.constraint(equalTo: wevvPastryScroll.frameLayoutGuide.widthAnchor),
            wevvShelfStack.topAnchor.constraint(equalTo: wevvBakeryCanvas.topAnchor),
            wevvShelfStack.leadingAnchor.constraint(equalTo: wevvBakeryCanvas.leadingAnchor, constant: 15),
            wevvShelfStack.trailingAnchor.constraint(equalTo: wevvBakeryCanvas.trailingAnchor, constant: -15),
            wevvShelfStack.bottomAnchor.constraint(equalTo: wevvBakeryCanvas.bottomAnchor, constant: -36)
        ])
    }

    private func reloadWevvBakeryShelfRows() {
        wevvShelfStack.arrangedSubviews.forEach { donutRow in
            wevvShelfStack.removeArrangedSubview(donutRow)
            donutRow.removeFromSuperview()
        }

        let bakeryShelfKeys = wevvDonutJournalStore.glazeShelfPacketKeys
        let bakeryShelfDetails = bakeryDetails.filter { bakeryShelfKeys.contains($0.donutPinKey) }
        guard !bakeryShelfDetails.isEmpty else {
            wevvShelfStack.addArrangedSubview(makeWevvEmptyBakeryShelf())
            return
        }

        bakeryShelfDetails.forEach { detail in
            wevvShelfStack.addArrangedSubview(makeWevvBakeryCard(detail))
        }
    }

    private func makeWevvEmptyBakeryShelf() -> UIView {

        let glazeImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFit


        NSLayoutConstraint.activate([

            glazeImage.widthAnchor.constraint(equalToConstant: 140),
            glazeImage.heightAnchor.constraint(equalToConstant: 153)
        ])
        return glazeImage
    }

    private func makeWevvBakeryCard(_ detail: WevVWevvBakeryDetail) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = detail.donutPinKey
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 24
        pastryCard.clipsToBounds = true
        pastryCard.addTarget(self, action: #selector(openWevvShelfBakery(_:)), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: detail.pastryFlight))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 15

        let glazeTitle = makeWevvShelfLabel(detail.sprinkleFlight, size: 19, weight: .heavy, color: wevvCocoaTone)
        let frostingSubtitle = makeWevvShelfLabel(detail.crumbFlight, size: 15, weight: .regular, color: wevvSoftCrumbTone)

        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.translatesAutoresizingMaskIntoConstraints = false
        star.tintColor = UIColor(red: 1, green: 0.67, blue: 0.08, alpha: 1)

        let score = makeWevvShelfLabel("\(detail.crumbScoreNote) \(detail.tastingNoteText)", size: 15, weight: .heavy, color: wevvCocoaTone)
        score.attributedText = wevvScoreText(detail)

        let crumbMark = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        crumbMark.translatesAutoresizingMaskIntoConstraints = false
        crumbMark.tintColor = wevvBerryTone

        let bakeryTrailLabel = makeWevvShelfLabel(detail.bakeryTrailLine, size: 15, weight: .regular, color: wevvSoftCrumbTone)
        bakeryTrailLabel.numberOfLines = 1

        let tagStack = UIStackView()
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        tagStack.axis = .horizontal
        tagStack.spacing = 8
        tagStack.distribution = .fillProportionally
        detail.bakeryTags.prefix(3).forEach { sugarTag in
            tagStack.addArrangedSubview(makeWevvBakeryTag(sugarTag))
        }

        placeWevvBakeryCardViews(pastryCard: pastryCard, cover: cover, title: glazeTitle, subtitle: frostingSubtitle, star: star, score: score, crumbMark: crumbMark, bakeryTrailLabel: bakeryTrailLabel, tagStack: tagStack)
        pinWevvBakeryCardLayout(pastryCard: pastryCard, crumbBadge: cover, pastryBadge: glazeTitle, flavorBadge: frostingSubtitle, pecanBadge: star, aromaFlight: score, crumbMark: crumbMark, bakeryTrailLabel: bakeryTrailLabel, tagStack: tagStack)
        return pastryCard
    }

    private func placeWevvBakeryCardViews(pastryCard: UIControl, cover: UIImageView, title: UILabel, subtitle: UILabel, star: UIImageView, score: UILabel, crumbMark: UIImageView, bakeryTrailLabel: UILabel, tagStack: UIStackView) {
        pastryCard.addSubview(cover)
        pastryCard.addSubview(title)
        pastryCard.addSubview(subtitle)
        pastryCard.addSubview(star)
        pastryCard.addSubview(score)
        pastryCard.addSubview(crumbMark)
        pastryCard.addSubview(bakeryTrailLabel)
        pastryCard.addSubview(tagStack)
    }

    private func pinWevvBakeryCardLayout(pastryCard: UIControl, crumbBadge: UIImageView, pastryBadge: UILabel, flavorBadge: UILabel, pecanBadge: UIImageView, aromaFlight: UILabel, crumbMark: UIImageView, bakeryTrailLabel: UILabel, tagStack: UIStackView) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 203),
            crumbBadge.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 15),
            crumbBadge.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            crumbBadge.widthAnchor.constraint(equalToConstant: 115),
            crumbBadge.heightAnchor.constraint(equalToConstant: 142),
            pastryBadge.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 25),
            pastryBadge.leadingAnchor.constraint(equalTo: crumbBadge.trailingAnchor, constant: 16),
            pastryBadge.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -16),
            flavorBadge.topAnchor.constraint(equalTo: pastryBadge.bottomAnchor, constant: 5),
            flavorBadge.leadingAnchor.constraint(equalTo: pastryBadge.leadingAnchor),
            flavorBadge.trailingAnchor.constraint(equalTo: pastryBadge.trailingAnchor),
            pecanBadge.leadingAnchor.constraint(equalTo: pastryBadge.leadingAnchor),
            pecanBadge.topAnchor.constraint(equalTo: flavorBadge.bottomAnchor, constant: 15),
            pecanBadge.widthAnchor.constraint(equalToConstant: 19),
            pecanBadge.heightAnchor.constraint(equalToConstant: 19),
            aromaFlight.leadingAnchor.constraint(equalTo: pecanBadge.trailingAnchor, constant: 12),
            aromaFlight.centerYAnchor.constraint(equalTo: pecanBadge.centerYAnchor),
            aromaFlight.trailingAnchor.constraint(equalTo: pastryBadge.trailingAnchor),
            crumbMark.leadingAnchor.constraint(equalTo: pastryBadge.leadingAnchor),
            crumbMark.topAnchor.constraint(equalTo: pecanBadge.bottomAnchor, constant: 15),
            crumbMark.widthAnchor.constraint(equalToConstant: 22),
            crumbMark.heightAnchor.constraint(equalToConstant: 22),
            bakeryTrailLabel.leadingAnchor.constraint(equalTo: crumbMark.trailingAnchor, constant: 10),
            bakeryTrailLabel.centerYAnchor.constraint(equalTo: crumbMark.centerYAnchor),
            bakeryTrailLabel.trailingAnchor.constraint(equalTo: pastryBadge.trailingAnchor),
            tagStack.leadingAnchor.constraint(equalTo: pastryBadge.leadingAnchor),
            tagStack.trailingAnchor.constraint(lessThanOrEqualTo: pastryBadge.trailingAnchor),
            tagStack.topAnchor.constraint(equalTo: crumbMark.bottomAnchor, constant: 14),
            tagStack.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    private func wevvScoreText(_ detail: WevVWevvBakeryDetail) -> NSAttributedString {
        let cocoaScout = NSMutableAttributedString(
            string: "\(detail.crumbScoreNote) ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .heavy),
                .foregroundColor: wevvCocoaTone
            ]
        )
        cocoaScout.append(NSAttributedString(
            string: detail.tastingNoteText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: wevvSoftCrumbTone
            ]
        ))
        return cocoaScout
    }

    private func makeWevvBakeryTag(_ tag: WevVWevvBakeryTag) -> UILabel {
        let crumbLabel = makeWevvShelfLabel(tag.flavorFlight, size: 13, weight: .heavy, color: wevvTagColor(tag.tintHex))
        crumbLabel.textAlignment = .center
        crumbLabel.backgroundColor = wevvTagColor(tag.tintHex).withAlphaComponent(0.12)
        crumbLabel.layer.cornerRadius = 13
        crumbLabel.clipsToBounds = true
        crumbLabel.setContentHuggingPriority(.required, for: .horizontal)
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        return crumbLabel
    }

    private func wevvTagColor(_ hex: String) -> UIColor {
        switch hex.lowercased() {
        case "ff4aa0": return UIColor(red: 0.95, green: 0.24, blue: 0.55, alpha: 1)
        case "f5b431": return UIColor(red: 0.82, green: 0.47, blue: 0.02, alpha: 1)
        case "8b63ff": return UIColor(red: 0.45, green: 0.37, blue: 0.82, alpha: 1)
        default: return wevvSoftCrumbTone
        }
    }

    private func makeWevvShelfLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func openWevvShelfBakery(_ sender: UIControl) {
        let crullerScout = sender.accessibilityIdentifier ?? ""
        guard let jellyFlight = bakeryDetails.first(where: { $0.donutPinKey == crullerScout }) else { return }
        let tastingScoutline = WevVWevvBakeryDetailController(detail: jellyFlight, bakeryShelf: bakeryDetails)
        tastingScoutline.onWevvShelfChanged = { [weak self] in
            self?.reloadWevvBakeryShelfRows()
            self?.onWevvShelfChanged?()
        }
        tastingScoutline.modalPresentationStyle = .fullScreen
        present(tastingScoutline, animated: true)
    }

    @objc private func closeWevvBakeryShelf() {
        dismiss(animated: true)
    }
}
