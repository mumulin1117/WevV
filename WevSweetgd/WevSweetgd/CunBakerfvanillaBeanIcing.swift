import UIKit

final class CunBakerfvanillaBeanIcing: UIViewController {
    var onWevvShelfChanged: (() -> Void)?

    private let wevvDonutJournalStore = WevVGlazeSessionStore.shared
    private let bakeryDetails: [bakeryCollectionFolio]
    private let brownButterGlaze = UIScrollView()
    private let wevvBakeryCanvas = UIView()
    private let wevvShelfStack = UIStackView()
    private let wevvCreamTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let wevvCocoaTone = UIColor(red: 0.18, green: 0.12, blue: 0.24, alpha: 1)
    private let wevvSoftCrumbTone = UIColor(red: 0.58, green: 0.46, blue: 0.55, alpha: 1)
    private let wevvBerryTone = UIColor(red: 1, green: 0.3, blue: 0.64, alpha: 1)

    init(bakeryDetails: [bakeryCollectionFolio]) {
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

        brownButterGlaze.translatesAutoresizingMaskIntoConstraints = false
        brownButterGlaze.alwaysBounceVertical = true
        view.addSubview(pistachioFlavor)
        view.addSubview(glazeTitle)
        view.addSubview(brownButterGlaze)

        wevvBakeryCanvas.translatesAutoresizingMaskIntoConstraints = false
        brownButterGlaze.addSubview(wevvBakeryCanvas)

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
            brownButterGlaze.topAnchor.constraint(equalTo: pistachioFlavor.bottomAnchor, constant: 20),
            brownButterGlaze.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brownButterGlaze.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            brownButterGlaze.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wevvBakeryCanvas.topAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.topAnchor),
            wevvBakeryCanvas.leadingAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.leadingAnchor),
            wevvBakeryCanvas.trailingAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.trailingAnchor),
            wevvBakeryCanvas.bottomAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.bottomAnchor),
            wevvBakeryCanvas.widthAnchor.constraint(equalTo: brownButterGlaze.frameLayoutGuide.widthAnchor),
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

    private func makeWevvBakeryCard(_ detail: bakeryCollectionFolio) -> UIControl {
        let maplePecanCoating = UIControl()
        maplePecanCoating.translatesAutoresizingMaskIntoConstraints = false
        maplePecanCoating.accessibilityIdentifier = detail.donutPinKey
        maplePecanCoating.backgroundColor = .white
        maplePecanCoating.layer.cornerRadius = 24
        maplePecanCoating.clipsToBounds = true
        maplePecanCoating.addTarget(self, action: #selector(openWevvShelfBakery(_:)), for: .touchUpInside)

        let citrusZestShell = UIImageView(image: UIImage(named: detail.glazeGalleryGuide))
        citrusZestShell.translatesAutoresizingMaskIntoConstraints = false
        citrusZestShell.contentMode = .scaleAspectFill
        citrusZestShell.clipsToBounds = true
        citrusZestShell.layer.cornerRadius = 15

        let glazeTitle = makeWevvShelfLabel(detail.sweetShowcaseMap, size: 19, weight: .heavy, color: wevvCocoaTone)
        let frostingSubtitle = makeWevvShelfLabel(detail.flavorMenuGuide, size: 15, weight: .regular, color: wevvSoftCrumbTone)

        let darkCocoaDrizzle = UIImageView(image: UIImage(systemName: "star.fill"))
        darkCocoaDrizzle.translatesAutoresizingMaskIntoConstraints = false
        darkCocoaDrizzle.tintColor = UIColor(red: 1, green: 0.67, blue: 0.08, alpha: 1)

        let whiteChocolateRibbon = makeWevvShelfLabel("\(detail.crumbScoreNote) \(detail.tastingSequenceInsight)", size: 15, weight: .heavy, color: wevvCocoaTone)
        whiteChocolateRibbon.attributedText = wevvScoreText(detail)

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
        detail.seasonalMenuCollection.prefix(3).forEach { sugarTag in
            tagStack.addArrangedSubview(makeWevvBakeryTag(sugarTag))
        }

        placeWevvBakeryCardViews(rubyCocoaSwirl: maplePecanCoating, lemonSugarIcing: citrusZestShell, orangeBlossomFinish: glazeTitle, honeyButterGlaze: frostingSubtitle, chaiSpiceIcing: darkCocoaDrizzle, cinnamonSugarFinish: whiteChocolateRibbon, crumbMark: crumbMark, bakeryTrailLabel: bakeryTrailLabel, tagStack: tagStack)
        pinWevvBakeryCardLayout(pastryCard: maplePecanCoating, crumbBadge: citrusZestShell, pastryBadge: glazeTitle, flavorBadge: frostingSubtitle, pecanBadge: darkCocoaDrizzle, aromaFlight: whiteChocolateRibbon, crumbMark: crumbMark, bakeryTrailLabel: bakeryTrailLabel, tagStack: tagStack)
        return maplePecanCoating
    }

    private func placeWevvBakeryCardViews(rubyCocoaSwirl: UIControl, lemonSugarIcing: UIImageView, orangeBlossomFinish: UILabel, honeyButterGlaze: UILabel, chaiSpiceIcing: UIImageView, cinnamonSugarFinish: UILabel, crumbMark: UIImageView, bakeryTrailLabel: UILabel, tagStack: UIStackView) {
        rubyCocoaSwirl.addSubview(lemonSugarIcing)
        rubyCocoaSwirl.addSubview(orangeBlossomFinish)
        rubyCocoaSwirl.addSubview(honeyButterGlaze)
        rubyCocoaSwirl.addSubview(chaiSpiceIcing)
        rubyCocoaSwirl.addSubview(cinnamonSugarFinish)
        rubyCocoaSwirl.addSubview(crumbMark)
        rubyCocoaSwirl.addSubview(bakeryTrailLabel)
        rubyCocoaSwirl.addSubview(tagStack)
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

    private func wevvScoreText(_ detail: bakeryCollectionFolio) -> NSAttributedString {
        let cocoaScout = NSMutableAttributedString(
            string: "\(detail.crumbScoreNote) ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .heavy),
                .foregroundColor: wevvCocoaTone
            ]
        )
        cocoaScout.append(NSAttributedString(
            string: detail.tastingSequenceInsight,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: wevvSoftCrumbTone
            ]
        ))
        return cocoaScout
    }

    private func makeWevvBakeryTag(_ tag: artisanShowcase) -> UILabel {
        let crumbLabel = makeWevvShelfLabel(tag.rainbowSprinkleDesign, size: 13, weight: .heavy, color: wevvTagColor(tag.pastelPalettePattern))
        crumbLabel.textAlignment = .center
        crumbLabel.backgroundColor = wevvTagColor(tag.pastelPalettePattern).withAlphaComponent(0.12)
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
        let tastingScoutline = IOpBakeryDetailController(detail: jellyFlight, bakeryShelf: bakeryDetails)
        tastingScoutline.pastryShelfChanged = { [weak self] in
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
