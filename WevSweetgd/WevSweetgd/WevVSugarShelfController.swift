import UIKit

final class WevVSugarShelfController: UIViewController {
    var onShelfChanged: (() -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let shopDetails: [WevVGlazeShopDetail]
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let paleTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let inkTone = UIColor(red: 0.18, green: 0.12, blue: 0.24, alpha: 1)
    private let mutedTone = UIColor(red: 0.58, green: 0.46, blue: 0.55, alpha: 1)
    private let pinkTone = UIColor(red: 1, green: 0.3, blue: 0.64, alpha: 1)

    init(shopDetails: [WevVGlazeShopDetail]) {
        self.shopDetails = shopDetails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarShelfPage()
        reloadSugarShelfRows()
    }

    private func buildSugarShelfPage() {
        view.backgroundColor = paleTone

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(closeSugarShelf), for: .touchUpInside)

        let glazeTitle = makeShelfLabel("SJaFvJej js*h#o?pD".wevVPastryCrumbBloomRestored, size: 26, weight: .heavy, color: inkTone)
        glazeTitle.textAlignment = .center

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(back)
        view.addSubview(glazeTitle)
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 14
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeTitle.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            scrollView.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36)
        ])
    }

    private func reloadSugarShelfRows() {
        stackView.arrangedSubviews.forEach { donutRow in
            stackView.removeArrangedSubview(donutRow)
            donutRow.removeFromSuperview()
        }

        let savedKeys = glazeSession.glazeShelfPacketKeys
        let savedDetails = shopDetails.filter { savedKeys.contains($0.glazeKey) }
        guard !savedDetails.isEmpty else {
            stackView.addArrangedSubview(makeEmptySugarShelf())
            return
        }

        savedDetails.forEach { detail in
            stackView.addArrangedSubview(makeSugarShopCard(detail))
        }
    }

    private func makeEmptySugarShelf() -> UIView {
//        let empty = UIStackView()
//        empty.translatesAutoresizingMaskIntoConstraints = false
//        empty.axis = .vertical
//        empty.alignment = .center
//        empty.spacing = 10

        let glazeImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFit

       

//        empty.addArrangedSubview(glazeImage)
       
        NSLayoutConstraint.activate([
//            empty.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.58),
            glazeImage.widthAnchor.constraint(equalToConstant: 140),
            glazeImage.heightAnchor.constraint(equalToConstant: 153)
        ])
        return glazeImage
    }

    private func makeSugarShopCard(_ detail: WevVGlazeShopDetail) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = detail.glazeKey
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 24
        pastryCard.clipsToBounds = true
        pastryCard.addTarget(self, action: #selector(openShelfShop(_:)), for: .touchUpInside)

        let cover = UIImageView(image: UIImage(named: detail.coverAsset))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 15

        let glazeTitle = makeShelfLabel(detail.title, size: 19, weight: .heavy, color: inkTone)
        let frostingSubtitle = makeShelfLabel(detail.subtitle, size: 15, weight: .regular, color: mutedTone)

        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.translatesAutoresizingMaskIntoConstraints = false
        star.tintColor = UIColor(red: 1, green: 0.67, blue: 0.08, alpha: 1)

        let score = makeShelfLabel("\(detail.crumbScoreText) \(detail.reviewText)", size: 15, weight: .heavy, color: inkTone)
        score.attributedText = scoreText(detail)

        let crumbMark = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        crumbMark.translatesAutoresizingMaskIntoConstraints = false
        crumbMark.tintColor = pinkTone

        let address = makeShelfLabel(detail.addressLine, size: 15, weight: .regular, color: mutedTone)
        address.numberOfLines = 1

        let tagStack = UIStackView()
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        tagStack.axis = .horizontal
        tagStack.spacing = 8
        tagStack.distribution = .fillProportionally
        detail.tags.prefix(3).forEach { sugarTag in
            tagStack.addArrangedSubview(makeTag(sugarTag))
        }

        placeSugarShopCardViews(pastryCard: pastryCard, cover: cover, title: glazeTitle, subtitle: frostingSubtitle, star: star, score: score, crumbMark: crumbMark, address: address, tagStack: tagStack)
        pinSugarShopCardLayout(pastryCard: pastryCard, cover: cover, title: glazeTitle, subtitle: frostingSubtitle, star: star, score: score, crumbMark: crumbMark, address: address, tagStack: tagStack)
        return pastryCard
    }

    private func placeSugarShopCardViews(pastryCard: UIControl, cover: UIImageView, title: UILabel, subtitle: UILabel, star: UIImageView, score: UILabel, crumbMark: UIImageView, address: UILabel, tagStack: UIStackView) {
        pastryCard.addSubview(cover)
        pastryCard.addSubview(title)
        pastryCard.addSubview(subtitle)
        pastryCard.addSubview(star)
        pastryCard.addSubview(score)
        pastryCard.addSubview(crumbMark)
        pastryCard.addSubview(address)
        pastryCard.addSubview(tagStack)
    }

    private func pinSugarShopCardLayout(pastryCard: UIControl, cover: UIImageView, title: UILabel, subtitle: UILabel, star: UIImageView, score: UILabel, crumbMark: UIImageView, address: UILabel, tagStack: UIStackView) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 203),
            cover.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 15),
            cover.centerYAnchor.constraint(equalTo: pastryCard.centerYAnchor),
            cover.widthAnchor.constraint(equalToConstant: 115),
            cover.heightAnchor.constraint(equalToConstant: 142),
            title.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 25),
            title.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -16),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            star.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            star.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 15),
            star.widthAnchor.constraint(equalToConstant: 19),
            star.heightAnchor.constraint(equalToConstant: 19),
            score.leadingAnchor.constraint(equalTo: star.trailingAnchor, constant: 12),
            score.centerYAnchor.constraint(equalTo: star.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            crumbMark.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            crumbMark.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 15),
            crumbMark.widthAnchor.constraint(equalToConstant: 22),
            crumbMark.heightAnchor.constraint(equalToConstant: 22),
            address.leadingAnchor.constraint(equalTo: crumbMark.trailingAnchor, constant: 10),
            address.centerYAnchor.constraint(equalTo: crumbMark.centerYAnchor),
            address.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            tagStack.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            tagStack.trailingAnchor.constraint(lessThanOrEqualTo: title.trailingAnchor),
            tagStack.topAnchor.constraint(equalTo: crumbMark.bottomAnchor, constant: 14),
            tagStack.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    private func scoreText(_ detail: WevVGlazeShopDetail) -> NSAttributedString {
        let base = NSMutableAttributedString(
            string: "\(detail.crumbScoreText) ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .heavy),
                .foregroundColor: inkTone
            ]
        )
        base.append(NSAttributedString(
            string: detail.reviewText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: mutedTone
            ]
        ))
        return base
    }

    private func makeTag(_ tag: WevVFrostingShopTag) -> UILabel {
        let crumbLabel = makeShelfLabel(tag.title, size: 13, weight: .heavy, color: tagColor(tag.tintHex))
        crumbLabel.textAlignment = .center
        crumbLabel.backgroundColor = tagColor(tag.tintHex).withAlphaComponent(0.12)
        crumbLabel.layer.cornerRadius = 13
        crumbLabel.clipsToBounds = true
        crumbLabel.setContentHuggingPriority(.required, for: .horizontal)
        crumbLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        return crumbLabel
    }

    private func tagColor(_ hex: String) -> UIColor {
        switch hex.lowercased() {
        case "ff4aa0": return UIColor(red: 0.95, green: 0.24, blue: 0.55, alpha: 1)
        case "f5b431": return UIColor(red: 0.82, green: 0.47, blue: 0.02, alpha: 1)
        case "8b63ff": return UIColor(red: 0.45, green: 0.37, blue: 0.82, alpha: 1)
        default: return mutedTone
        }
    }

    private func makeShelfLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = color
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func openShelfShop(_ sender: UIControl) {
        let key = sender.accessibilityIdentifier ?? ""
        guard let detail = shopDetails.first(where: { $0.glazeKey == key }) else { return }
        let controller = WevVGlazeShopDetailController(detail: detail, glazeShelf: shopDetails)
        controller.onShelfChanged = { [weak self] in
            self?.reloadSugarShelfRows()
            self?.onShelfChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func closeSugarShelf() {
        dismiss(animated: true)
    }
}
