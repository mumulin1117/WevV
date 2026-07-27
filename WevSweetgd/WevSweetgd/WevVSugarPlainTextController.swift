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

        let body = makeSugarLabel(bodyText, size: 15, weight: .regular, color: UIColor(red: 0.28, green: 0.24, blue: 0.32, alpha: 1))
        body.numberOfLines = 0

        view.addSubview(back)
        view.addSubview(title)
        view.addSubview(panel)
        panel.addSubview(body)

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
            body.topAnchor.constraint(equalTo: panel.topAnchor, constant: 22),
            body.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
            body.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
            body.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -22)
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
