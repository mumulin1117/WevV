import UIKit

final class WevVSugarMomentComposerController: UIViewController, UITextViewDelegate {
    var onSugarMomentReady: ((WevVSugarMomentPacket) -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    private let confirmButton = UIButton(type: .system)
    private let imageAssets = [
        "wevv_moment_one_bite_vibes",
        "wevv_moment_fresh_donut_scent",
        "wevv_moment_pink_sweetness"
    ]
    private var chosenAsset: String?
    private var chosenTiles: [UIControl] = []
    private var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.76, blue: 0.86, alpha: 1.0)
        buildSugarCanvas()
        NotificationCenter.default.addObserver(self, selector: #selector(liftSugarCanvas(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropSugarCanvas(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildSugarCanvas() {
        let frostingGlow = UIView()
        frostingGlow.translatesAutoresizingMaskIntoConstraints = false
        frostingGlow.backgroundColor = UIColor(red: 1.0, green: 0.76, blue: 0.86, alpha: 1.0)
        view.addSubview(frostingGlow)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -34)
        NSLayoutConstraint.activate([
            frostingGlow.topAnchor.constraint(equalTo: view.topAnchor),
            frostingGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            bottomConstraint!,
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeSugarComposer), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Post"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        let imageRow = UIStackView()
        imageRow.translatesAutoresizingMaskIntoConstraints = false
        imageRow.axis = .horizontal
        imageRow.distribution = .fillEqually
        imageRow.spacing = 10

        for index in 0..<3 {
            let tile = makeSugarImageTile(index: index)
            chosenTiles.append(tile)
            imageRow.addArrangedSubview(tile)
        }

        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = "Content"
        contentLabel.font = .systemFont(ofSize: 34, weight: .bold)
        contentLabel.textColor = .black

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 22
        textView.clipsToBounds = true
        textView.font = .systemFont(ofSize: 28, weight: .regular)
        textView.textColor = UIColor(red: 0.18, green: 0.14, blue: 0.16, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 30, left: 28, bottom: 24, right: 24)

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Say Something"
        placeholderLabel.font = .systemFont(ofSize: 28, weight: .regular)
        placeholderLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 1)
        textView.addSubview(placeholderLabel)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        confirmButton.backgroundColor = UIColor(red: 1.0, green: 0.44, blue: 0.72, alpha: 1.0)
        confirmButton.layer.cornerRadius = 40
        confirmButton.addTarget(self, action: #selector(confirmSugarMoment), for: .touchUpInside)

        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageRow)
        contentView.addSubview(contentLabel)
        contentView.addSubview(textView)
        contentView.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 18),
            imageRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            imageRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            imageRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            imageRow.heightAnchor.constraint(equalTo: imageRow.widthAnchor, multiplier: 0.25),
            contentLabel.topAnchor.constraint(equalTo: imageRow.bottomAnchor, constant: 48),
            contentLabel.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            textView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 22),
            textView.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 235),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 31),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            confirmButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            confirmButton.heightAnchor.constraint(equalToConstant: 80),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -92)
        ])

        let sugarTap = UITapGestureRecognizer(target: self, action: #selector(endSugarEditing))
        sugarTap.cancelsTouchesInView = false
        view.addGestureRecognizer(sugarTap)
    }

    private func makeSugarImageTile(index: Int) -> UIControl {
        let tile = UIControl()
        tile.translatesAutoresizingMaskIntoConstraints = false
        tile.tag = index
        tile.backgroundColor = .white
        tile.layer.cornerRadius = 20
        tile.clipsToBounds = true
        tile.addTarget(self, action: #selector(chooseSugarImage(_:)), for: .touchUpInside)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 99
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.translatesAutoresizingMaskIntoConstraints = false
        camera.tag = 100
        camera.tintColor = UIColor(red: 0.72, green: 0.72, blue: 0.73, alpha: 1)
        camera.contentMode = .scaleAspectFit

        tile.addSubview(imageView)
        tile.addSubview(camera)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: tile.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: tile.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: tile.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: tile.bottomAnchor),
            camera.centerXAnchor.constraint(equalTo: tile.centerXAnchor),
            camera.centerYAnchor.constraint(equalTo: tile.centerYAnchor),
            camera.widthAnchor.constraint(equalToConstant: 56),
            camera.heightAnchor.constraint(equalToConstant: 56)
        ])
        return tile
    }

    @objc private func chooseSugarImage(_ sender: UIControl) {
        let asset = imageAssets[sender.tag % imageAssets.count]
        chosenAsset = asset
        for tile in chosenTiles {
            let imageView = tile.viewWithTag(99) as? UIImageView
            let camera = tile.viewWithTag(100)
            if tile === sender {
                imageView?.image = UIImage(named: asset)
                camera?.isHidden = true
                tile.layer.borderColor = UIColor(red: 1.0, green: 0.18, blue: 0.58, alpha: 1).cgColor
                tile.layer.borderWidth = 3
            } else {
                imageView?.image = nil
                camera?.isHidden = false
                tile.layer.borderWidth = 0
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func confirmSugarMoment() {
        guard glazeSession.isTasterReady else {
            showSugarHint("Please sign in first")
            return
        }
        guard let asset = chosenAsset else {
            showSugarHint("Choose a donut picture")
            return
        }
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            showSugarHint("Say something sweet")
            return
        }
        let packet = glazeSession.placeSugarMoment(heroAsset: asset, text: text)
        onSugarMomentReady?(packet)
        dismiss(animated: true)
    }

    @objc private func closeSugarComposer() {
        dismiss(animated: true)
    }

    @objc private func endSugarEditing() {
        view.endEditing(true)
    }

    @objc private func liftSugarCanvas(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let bottomLift = max(0, frame.height - view.safeAreaInsets.bottom)
        scrollView.contentInset.bottom = bottomLift + 36
        scrollView.verticalScrollIndicatorInsets.bottom = bottomLift + 36
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSugarCanvas(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showSugarHint(_ text: String) {
        let hint = UILabel()
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.text = text
        hint.textAlignment = .center
        hint.font = .systemFont(ofSize: 14, weight: .semibold)
        hint.textColor = .white
        hint.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        hint.layer.cornerRadius = 18
        hint.clipsToBounds = true
        view.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            hint.heightAnchor.constraint(equalToConstant: 36),
            hint.widthAnchor.constraint(greaterThanOrEqualToConstant: 190)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.15, options: []) {
            hint.alpha = 0
        } completion: { _ in
            hint.removeFromSuperview()
        }
    }
}
