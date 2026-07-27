import UIKit

final class WevVNoticeEmptyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarNoticeScene()
    }

    private func buildSugarNoticeScene() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.98, alpha: 1)

        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "wevv_notice_sugar_back"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(closeSugarNotice), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = ["Mes", "sage"].joined()
        title.font = .systemFont(ofSize: 25, weight: .heavy)
        title.textColor = UIColor(red: 0.14, green: 0.09, blue: 0.19, alpha: 1)
        title.textAlignment = .center

        let emptyGlaze = UIImageView(image: UIImage(named: "wevv_notice_empty_glaze"))
        emptyGlaze.translatesAutoresizingMaskIntoConstraints = false
        emptyGlaze.contentMode = .scaleAspectFit

        

        view.addSubview(backButton)
        view.addSubview(title)
        view.addSubview(emptyGlaze)
  

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -64),
            emptyGlaze.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyGlaze.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -52),
            emptyGlaze.widthAnchor.constraint(equalToConstant: 140),
            emptyGlaze.heightAnchor.constraint(equalToConstant: 127),
         
        ])
    }

    @objc private func closeSugarNotice() {
        dismiss(animated: true)
    }
}
