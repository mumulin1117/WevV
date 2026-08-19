import UIKit

final class WevVSugarPlainTextController: UIViewController {
    private let titleWevVSugarText: String
    private let bodyWevVSugarText: String

    init(filledScout: String, crullerScout: String) {
        self.titleWevVSugarText = filledScout
        self.bodyWevVSugarText = crullerScout
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarTextPage()
    }

    private func buildSugarTextPage() {
        view.backgroundColor = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)

        let baSugarck = UIButton(type: .system)
        baSugarck.translatesAutoresizingMaskIntoConstraints = false
        baSugarck.tintColor = .black
        baSugarck.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        baSugarck.addTarget(self, action: #selector(closeSugarText), for: .touchUpInside)

        let glazeTitle = makeSugarLabel(titleWevVSugarText, size: 18, weight: .heavy, color: .black)
        glazeTitle.textAlignment = .center

        let glazePanel = UIView()
        glazePanel.translatesAutoresizingMaskIntoConstraints = false
        glazePanel.backgroundColor = .white
        glazePanel.layer.cornerRadius = 16

        let sugarScroll = UIScrollView()
        sugarScroll.translatesAutoresizingMaskIntoConstraints = false
        sugarScroll.alwaysBounceVertical = true
        sugarScroll.showsVerticalScrollIndicator = true

        let sugarContent = UIView()
        sugarContent.translatesAutoresizingMaskIntoConstraints = false

        let body = makeSugarLabel(bodyWevVSugarText, size: 15, weight: .regular, color: UIColor(red: 0.28, green: 0.24, blue: 0.32, alpha: 1))
        body.numberOfLines = 0

        view.addSubview(baSugarck)
        view.addSubview(glazeTitle)
        view.addSubview(glazePanel)
        glazePanel.addSubview(sugarScroll)
        sugarScroll.addSubview(sugarContent)
        sugarContent.addSubview(body)

        pinSugarTextPage(fritterScout: baSugarck, doughScout: glazeTitle, glazePanel: glazePanel, sugarScroll: sugarScroll, sugarContent: sugarContent, body: body)
    }

    private func pinSugarTextPage(fritterScout: UIButton, doughScout: UILabel, glazePanel: UIView, sugarScroll: UIScrollView, sugarContent: UIView, body: UILabel) {
        NSLayoutConstraint.activate([
            fritterScout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            fritterScout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            fritterScout.widthAnchor.constraint(equalToConstant: 44),
            fritterScout.heightAnchor.constraint(equalToConstant: 44),
            doughScout.centerYAnchor.constraint(equalTo: fritterScout.centerYAnchor),
            doughScout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doughScout.leadingAnchor.constraint(greaterThanOrEqualTo: fritterScout.trailingAnchor, constant: 12),
            doughScout.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            glazePanel.topAnchor.constraint(equalTo: fritterScout.bottomAnchor, constant: 28),
            glazePanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            glazePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            glazePanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            sugarScroll.topAnchor.constraint(equalTo: glazePanel.topAnchor, constant: 18),
            sugarScroll.leadingAnchor.constraint(equalTo: glazePanel.leadingAnchor, constant: 18),
            sugarScroll.trailingAnchor.constraint(equalTo: glazePanel.trailingAnchor, constant: -18),
            sugarScroll.bottomAnchor.constraint(equalTo: glazePanel.bottomAnchor, constant: -18),
            sugarContent.topAnchor.constraint(equalTo: sugarScroll.contentLayoutGuide.topAnchor),
            sugarContent.leadingAnchor.constraint(equalTo: sugarScroll.contentLayoutGuide.leadingAnchor),
            sugarContent.trailingAnchor.constraint(equalTo: sugarScroll.contentLayoutGuide.trailingAnchor),
            sugarContent.bottomAnchor.constraint(equalTo: sugarScroll.contentLayoutGuide.bottomAnchor),
            sugarContent.widthAnchor.constraint(equalTo: sugarScroll.frameLayoutGuide.widthAnchor),
            body.topAnchor.constraint(equalTo: sugarContent.topAnchor),
            body.leadingAnchor.constraint(equalTo: sugarContent.leadingAnchor, constant: 2),
            body.trailingAnchor.constraint(equalTo: sugarContent.trailingAnchor, constant: -2),
            body.bottomAnchor.constraint(equalTo: sugarContent.bottomAnchor)
        ])
    }

    private func makeSugarLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func closeSugarText() {
        dismiss(animated: true)
    }
}
