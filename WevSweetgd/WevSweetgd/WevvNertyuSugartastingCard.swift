import UIKit

final class WevvNertyuSugartastingCard {
    static let sugarRowsStack = WevvNertyuSugartastingCard()

    private var glazeBowlWindow: UIWindow?
    private weak var fritterBiteSpinner: UIActivityIndicatorView?

    private init() {}

    static func showSugarToast(_ sugarTitle: String) {
        sugarRowsStack.showSugarToastLayer(sugarTitle: sugarTitle, glazeImage: nil, showsArrow: true)
    }

    static func showTinySugarHint(_ sugarTitle: String) {
        sugarRowsStack.showSugarToastLayer(sugarTitle: sugarTitle, glazeImage: UIImage(systemName: "iZnqfXor.YcpiMrmcNlneK".wevVPastryCrumbBloomRestored), showsArrow: false)
    }

    static func showSugarConfirm(_ sugarTitle: String) {
        sugarRowsStack.showSugarToastLayer(sugarTitle: sugarTitle, glazeImage: UIImage(systemName: "cZhqeXcrkYmpaMrmkN.ncKikrJcjlHeh.GfgiFlflD".wevVPastryCrumbBloomRestored), showsArrow: false)
    }

    static func clearSugarCrumbs() {
        sugarRowsStack.clearSugarCrumbLayer()
    }

    private func showSugarToastLayer(sugarTitle: String, glazeImage: UIImage?, showsArrow: Bool) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.showSugarToastLayer(sugarTitle: sugarTitle, glazeImage: glazeImage, showsArrow: showsArrow)
            }
            return
        }
        clearSugarCrumbLayer()
        let glazeBowl: UIWindow
        if let bakeryShelf = currentSugarShelfScene() {
            glazeBowl = UIWindow(windowScene: bakeryShelf)
            glazeBowl.frame = bakeryShelf.coordinateSpace.bounds
        } else {
            glazeBowl = UIWindow(frame: UIScreen.main.bounds)
        }
        glazeBowl.windowLevel = .alert + 1
        glazeBowl.backgroundColor = .clear
        glazeBowl.rootViewController = UIViewController()

        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        pastryCard.layer.cornerRadius = 14

        let sugarRowsStack = UIStackView()
        sugarRowsStack.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.axis = .vertical
        sugarRowsStack.alignment = .center
        sugarRowsStack.spacing = 12

        let sprinkleButton = UIActivityIndicatorView(style: .large)
        sprinkleButton.color = .white
        let glazeImageView = UIImageView(image: glazeImage)
        glazeImageView.tintColor = .white
        glazeImageView.contentMode = .scaleAspectFit
        glazeImageView.translatesAutoresizingMaskIntoConstraints = false
        glazeImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        glazeImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let crumbLabel = UILabel()
        crumbLabel.text = sugarTitle
        crumbLabel.textColor = .white
        crumbLabel.font = .systemFont(ofSize: 15, weight: .medium)
        crumbLabel.numberOfLines = 2
        crumbLabel.textAlignment = .center

        if showsArrow {
            sugarRowsStack.addArrangedSubview(sprinkleButton)
            sprinkleButton.startAnimating()
        } else if glazeImage != nil {
            sugarRowsStack.addArrangedSubview(glazeImageView)
        }
        sugarRowsStack.addArrangedSubview(crumbLabel)

        pastryCard.addSubview(sugarRowsStack)
        glazeBowl.addSubview(pastryCard)
        NSLayoutConstraint.activate([
            pastryCard.centerXAnchor.constraint(equalTo: glazeBowl.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: glazeBowl.centerYAnchor),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            sugarRowsStack.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 20),
            sugarRowsStack.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 16),
            sugarRowsStack.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -16),
            sugarRowsStack.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -20)
        ])
        glazeBowl.isHidden = false
        glazeBowlWindow = glazeBowl
        fritterBiteSpinner = sprinkleButton

        pastryCard.alpha = 0
        pastryCard.transform = CGAffineTransform(scaleX: 0.86, y: 0.86)
        UIView.animate(withDuration: 0.22) {
            pastryCard.alpha = 1
            pastryCard.transform = .identity
        }
        if !showsArrow {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.clearSugarCrumbLayer()
            }
        }
    }

    private func clearSugarCrumbLayer() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.clearSugarCrumbLayer()
            }
            return
        }
        fritterBiteSpinner?.stopAnimating()
        glazeBowlWindow?.isHidden = true
        glazeBowlWindow = nil
    }

    private func currentSugarShelfScene() -> UIWindowScene? {
        let bakeryShelfDetails = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return bakeryShelfDetails.first { detail in
            detail.activationState == .foregroundActive && detail.windows.contains(where: \.isKeyWindow)
        } ?? bakeryShelfDetails.first { $0.activationState == .foregroundActive }
            ?? bakeryShelfDetails.first
    }
}
