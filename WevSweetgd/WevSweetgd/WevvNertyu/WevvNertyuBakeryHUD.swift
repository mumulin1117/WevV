import UIKit

final class WevvNertyuBakeryHUD {
    static let shared = WevvNertyuBakeryHUD()

    private var frostingWindow: UIWindow?
    private weak var spinningView: UIActivityIndicatorView?

    private init() {}

    static func show(_ text: String) {
        shared.present(text: text, icon: nil, isSpinning: true)
    }

    static func info(_ text: String) {
        shared.present(text: text, icon: UIImage(systemName: "info.circle"), isSpinning: false)
    }

    static func success(_ text: String) {
        shared.present(text: text, icon: UIImage(systemName: "checkmark.circle.fill"), isSpinning: false)
    }

    static func dismiss() {
        shared.dismissLayer()
    }

    private func present(text: String, icon: UIImage?, isSpinning: Bool) {
        dismissLayer()
        let overlay = UIWindow(frame: UIScreen.main.bounds)
        overlay.windowLevel = .alert + 1
        overlay.backgroundColor = .clear

        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        panel.layer.cornerRadius = 14

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center

        if isSpinning {
            stack.addArrangedSubview(spinner)
            spinner.startAnimating()
        } else if icon != nil {
            stack.addArrangedSubview(iconView)
        }
        stack.addArrangedSubview(label)

        panel.addSubview(stack)
        overlay.addSubview(panel)
        NSLayoutConstraint.activate([
            panel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            panel.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            stack.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20)
        ])
        overlay.makeKeyAndVisible()
        frostingWindow = overlay
        spinningView = spinner

        panel.alpha = 0
        panel.transform = CGAffineTransform(scaleX: 0.86, y: 0.86)
        UIView.animate(withDuration: 0.22) {
            panel.alpha = 1
            panel.transform = .identity
        }
        if !isSpinning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.dismissLayer()
            }
        }
    }

    private func dismissLayer() {
        spinningView?.stopAnimating()
        frostingWindow?.isHidden = true
        frostingWindow = nil
    }
}

