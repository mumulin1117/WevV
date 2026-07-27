import UIKit

final class WevVSugarPlainTextController: UIViewController {
    private let titleText: String
    private let bodyText: String

    init(titleText: String, bodyText: String) {
        self.titleText = titleText
        self.bodyText = bodyText
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

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.tintColor = .black
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.addTarget(self, action: #selector(closeSugarText), for: .touchUpInside)

        let title = makeSugarLabel(titleText, size: 18, weight: .heavy, color: .black)
        title.textAlignment = .center

        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 16

        let sugarScroll = UIScrollView()
        sugarScroll.translatesAutoresizingMaskIntoConstraints = false
        sugarScroll.alwaysBounceVertical = true
        sugarScroll.showsVerticalScrollIndicator = true

        let sugarContent = UIView()
        sugarContent.translatesAutoresizingMaskIntoConstraints = false

        let body = makeSugarLabel(bodyText, size: 15, weight: .regular, color: UIColor(red: 0.28, green: 0.24, blue: 0.32, alpha: 1))
        body.numberOfLines = 0

        view.addSubview(back)
        view.addSubview(title)
        view.addSubview(panel)
        panel.addSubview(sugarScroll)
        sugarScroll.addSubview(sugarContent)
        sugarContent.addSubview(body)

        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70),
            panel.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 28),
            panel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            panel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            panel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            sugarScroll.topAnchor.constraint(equalTo: panel.topAnchor, constant: 18),
            sugarScroll.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 18),
            sugarScroll.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -18),
            sugarScroll.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -18),
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
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    @objc private func closeSugarText() {
        dismiss(animated: true)
    }
}
