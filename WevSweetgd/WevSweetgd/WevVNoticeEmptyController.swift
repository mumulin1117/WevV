import UIKit

final class WevVNoticeEmptyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarNoticeScene()
    }

    private func buildSugarNoticeScene() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.98, alpha: 1)

        let doughBackButton = UIButton(type: .custom)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(named: "wevv_notice_sugar_back"), for: .normal)
        doughBackButton.imageView?.contentMode = .scaleAspectFit
        doughBackButton.addTarget(self, action: #selector(closeSugarNotice), for: .touchUpInside)

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = ["MqeYsU".wevVPastryCrumbBloomRestored, "sBapgle:".wevVPastryCrumbBloomRestored].joined()
        glazeTitle.font = .systemFont(ofSize: 25, weight: .heavy)
        glazeTitle.textColor = UIColor(red: 0.14, green: 0.09, blue: 0.19, alpha: 1)
        glazeTitle.textAlignment = .center

        let emptyGlaze = UIImageView(image: UIImage(named: "wevv_notice_empty_glaze"))
        emptyGlaze.translatesAutoresizingMaskIntoConstraints = false
        emptyGlaze.contentMode = .scaleAspectFit

        

        view.addSubview(doughBackButton)
        view.addSubview(glazeTitle)
        view.addSubview(emptyGlaze)
  

        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            doughBackButton.widthAnchor.constraint(equalToConstant: 36),
            doughBackButton.heightAnchor.constraint(equalToConstant: 36),
            glazeTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -64),
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
