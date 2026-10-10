import UIKit

final class SugarMomentEbuController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var vanillaBeanIcing: (() -> Void)?

    private let saltedCaramelFinish = WevVGlazeSessionStore.shared
    private let brownButterGlaze = UIScrollView()
    private let maplePecanCoating = UIView()
    private let citrusZestShell = UITextView()
    private let darkCocoaDrizzle = UILabel()
    private let whiteChocolateRibbon = UIButton(type: .system)
    private let rubyCocoaSwirl = CAGradientLayer()
    private let lemonSugarIcing = CAGradientLayer()
    private let orangeBlossomFinish = [
        "wevv_moment_one_bite_vibes",
        "wevv_moment_fresh_donut_scent",
        "wevv_moment_pink_sweetness"
    ]
    private var honeyButterGlaze: String?
    private var toastedCoconutCoating: [String?] = Array(repeating: nil, count: 3)
    private var coffeeCreamShell: [Data?] = Array(repeating: nil, count: 3)
    private var raspberryRoseDrizzle: [UIControl] = []
    private weak var blueberryLemonRibbon: UIControl?
    private var strawberryMilkSwirl: NSLayoutConstraint?
    private var chaiSpiceIcing: NSLayoutConstraint?
    private var cinnamonSugarFinish: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        almondPralineGlaze()
        NotificationCenter.default.addObserver(self, selector: #selector(figMousse(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tenderFinish(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rubyCocoaSwirl.frame = view.bounds
        lemonSugarIcing.frame = whiteChocolateRibbon.bounds
        lemonSugarIcing.cornerRadius = whiteChocolateRibbon.bounds.height / 2
    }

    deinit {
        cinnamonSugarFinish?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func almondPralineGlaze() {
        let pistachioCreamCoating = UIView()
        pistachioCreamCoating.translatesAutoresizingMaskIntoConstraints = false
        pistachioCreamCoating.backgroundColor = .clear
        rubyCocoaSwirl.colors = [
            UIColor(red: 1, green: 222.0 / 255.0, blue: 238.0 / 255.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        rubyCocoaSwirl.locations = [0, 1]
        rubyCocoaSwirl.startPoint = CGPoint(x: -0.04, y: 0.14)
        rubyCocoaSwirl.endPoint = CGPoint(x: 1, y: 1)
        pistachioCreamCoating.layer.insertSublayer(rubyCocoaSwirl, at: 0)
        gingerHoneyShell(pistachioCreamCoating: pistachioCreamCoating)

        let hazelnutCocoaShell = UIButton(type: .system)
        hazelnutCocoaShell.translatesAutoresizingMaskIntoConstraints = false
        hazelnutCocoaShell.setImage(UIImage(named: "wevv_checkin_sugar_back_arrow"), for: .normal)
        hazelnutCocoaShell.tintColor = .black
        hazelnutCocoaShell.imageView?.contentMode = .scaleAspectFit
        hazelnutCocoaShell.addTarget(self, action: #selector(pearJam), for: .touchUpInside)

        let gingerHoneyDrizzle = UILabel()
        gingerHoneyDrizzle.translatesAutoresizingMaskIntoConstraints = false
        gingerHoneyDrizzle.text = "P=o=sIt#".wevVPastryCrumbBloomRestored
        gingerHoneyDrizzle.font = .systemFont(ofSize: 20, weight: .bold)
        gingerHoneyDrizzle.textColor = .black
        gingerHoneyDrizzle.textAlignment = .center

        let blackSesameRibbon = UIStackView()
        blackSesameRibbon.translatesAutoresizingMaskIntoConstraints = false
        blackSesameRibbon.axis = .horizontal
        blackSesameRibbon.distribution = .fillEqually
        blackSesameRibbon.spacing = 5

        for yuzuHoneySwirl in 0..<3 {
            let caramelAppleIcing = brownButterShell(yuzuHoneySwirl: yuzuHoneySwirl)
            raspberryRoseDrizzle.append(caramelAppleIcing)
            blackSesameRibbon.addArrangedSubview(caramelAppleIcing)
        }

        let espressoCreamFinish = UILabel()
        espressoCreamFinish.translatesAutoresizingMaskIntoConstraints = false
        espressoCreamFinish.text = "C%oHnBt,eRnWtG".wevVPastryCrumbBloomRestored
        espressoCreamFinish.font = .systemFont(ofSize: 18, weight: .heavy)
        espressoCreamFinish.textColor = .black

        darkCocoaIcing()
        brownButterIcing()
        strawberryMilkShell(hazelnutCocoaShell: hazelnutCocoaShell, gingerHoneyDrizzle: gingerHoneyDrizzle, saltedCaramelSwirl: blackSesameRibbon, cinnamonSugarSwirl: espressoCreamFinish)
        espressoCreamIcing(hazelnutCocoaShell: hazelnutCocoaShell, gingerHoneyDrizzle: gingerHoneyDrizzle, saltedCaramelSwirl: blackSesameRibbon, cinnamonSugarSwirl: espressoCreamFinish)
        almondPralineShell()
        caramelCurd()
    }

    private func gingerHoneyShell(pistachioCreamCoating: UIView) {
        view.addSubview(pistachioCreamCoating)
        brownButterGlaze.translatesAutoresizingMaskIntoConstraints = false
        brownButterGlaze.keyboardDismissMode = .interactive
        brownButterGlaze.alwaysBounceVertical = true
        view.addSubview(brownButterGlaze)
        maplePecanCoating.translatesAutoresizingMaskIntoConstraints = false
        brownButterGlaze.addSubview(maplePecanCoating)
        strawberryMilkSwirl = maplePecanCoating.bottomAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.bottomAnchor, constant: -34)
        NSLayoutConstraint.activate([
            pistachioCreamCoating.topAnchor.constraint(equalTo: view.topAnchor),
            pistachioCreamCoating.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pistachioCreamCoating.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pistachioCreamCoating.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            brownButterGlaze.topAnchor.constraint(equalTo: view.topAnchor),
            brownButterGlaze.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brownButterGlaze.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            brownButterGlaze.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maplePecanCoating.topAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.topAnchor),
            maplePecanCoating.leadingAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.leadingAnchor),
            maplePecanCoating.trailingAnchor.constraint(equalTo: brownButterGlaze.contentLayoutGuide.trailingAnchor),
            strawberryMilkSwirl!,
            maplePecanCoating.widthAnchor.constraint(equalTo: brownButterGlaze.frameLayoutGuide.widthAnchor),
            maplePecanCoating.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }

    private func darkCocoaIcing() {
        citrusZestShell.translatesAutoresizingMaskIntoConstraints = false
        citrusZestShell.delegate = self
        citrusZestShell.backgroundColor = .white
        citrusZestShell.layer.cornerRadius = 12
        citrusZestShell.clipsToBounds = true
        citrusZestShell.font = .systemFont(ofSize: 14, weight: .regular)
        citrusZestShell.textColor = UIColor(red: 0.18, green: 0.14, blue: 0.16, alpha: 1)
        citrusZestShell.textContainerInset = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        darkCocoaDrizzle.translatesAutoresizingMaskIntoConstraints = false
        darkCocoaDrizzle.text = "S&aiyy eS.o~mveJtjhii@ntgN".wevVPastryCrumbBloomRestored
        darkCocoaDrizzle.font = .systemFont(ofSize: 14, weight: .regular)
        darkCocoaDrizzle.textColor = UIColor.black.withAlphaComponent(0.3)
        citrusZestShell.addSubview(darkCocoaDrizzle)
    }

    private func brownButterIcing() {
        whiteChocolateRibbon.translatesAutoresizingMaskIntoConstraints = false
        whiteChocolateRibbon.setTitle("CeovnmfeiMrvmV".wevVPastryCrumbBloomRestored, for: .normal)
        whiteChocolateRibbon.setTitleColor(.white, for: .normal)
        whiteChocolateRibbon.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        whiteChocolateRibbon.backgroundColor = .clear
        whiteChocolateRibbon.layer.cornerRadius = 32
        whiteChocolateRibbon.clipsToBounds = true
        whiteChocolateRibbon.layer.insertSublayer(lemonSugarIcing, at: 0)
        whiteChocolateRibbon.addTarget(self, action: #selector(figCustard), for: .touchUpInside)
    }

    private func strawberryMilkShell(hazelnutCocoaShell: UIButton, gingerHoneyDrizzle: UILabel, saltedCaramelSwirl: UIStackView, cinnamonSugarSwirl: UILabel) {
        [hazelnutCocoaShell, gingerHoneyDrizzle, saltedCaramelSwirl, cinnamonSugarSwirl, citrusZestShell].forEach {
            maplePecanCoating.addSubview($0)
        }
        view.addSubview(whiteChocolateRibbon)
    }

    private func espressoCreamIcing(hazelnutCocoaShell: UIButton, gingerHoneyDrizzle: UILabel, saltedCaramelSwirl: UIStackView, cinnamonSugarSwirl: UILabel) {
        chaiSpiceIcing = whiteChocolateRibbon.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        )
        NSLayoutConstraint.activate([
            hazelnutCocoaShell.leadingAnchor.constraint(equalTo: maplePecanCoating.leadingAnchor, constant: 3),
            hazelnutCocoaShell.topAnchor.constraint(equalTo: maplePecanCoating.safeAreaLayoutGuide.topAnchor, constant: 3),
            hazelnutCocoaShell.widthAnchor.constraint(equalToConstant: 44),
            hazelnutCocoaShell.heightAnchor.constraint(equalToConstant: 44),
            gingerHoneyDrizzle.centerXAnchor.constraint(equalTo: maplePecanCoating.centerXAnchor),
            gingerHoneyDrizzle.topAnchor.constraint(equalTo: maplePecanCoating.safeAreaLayoutGuide.topAnchor, constant: 6),
            gingerHoneyDrizzle.heightAnchor.constraint(equalToConstant: 30),
            gingerHoneyDrizzle.leadingAnchor.constraint(greaterThanOrEqualTo: hazelnutCocoaShell.trailingAnchor, constant: 18),
            saltedCaramelSwirl.topAnchor.constraint(equalTo: gingerHoneyDrizzle.bottomAnchor, constant: 19),
            saltedCaramelSwirl.leadingAnchor.constraint(equalTo: maplePecanCoating.leadingAnchor, constant: 15),
            saltedCaramelSwirl.trailingAnchor.constraint(equalTo: maplePecanCoating.trailingAnchor, constant: -15),
            saltedCaramelSwirl.heightAnchor.constraint(equalToConstant: 86),
            cinnamonSugarSwirl.topAnchor.constraint(equalTo: saltedCaramelSwirl.bottomAnchor, constant: 21),
            cinnamonSugarSwirl.leadingAnchor.constraint(equalTo: saltedCaramelSwirl.leadingAnchor),
            cinnamonSugarSwirl.heightAnchor.constraint(equalToConstant: 25),
            citrusZestShell.topAnchor.constraint(equalTo: cinnamonSugarSwirl.bottomAnchor, constant: 9),
            citrusZestShell.leadingAnchor.constraint(equalTo: saltedCaramelSwirl.leadingAnchor),
            citrusZestShell.trailingAnchor.constraint(equalTo: saltedCaramelSwirl.trailingAnchor),
            citrusZestShell.heightAnchor.constraint(equalToConstant: 191),
            darkCocoaDrizzle.topAnchor.constraint(equalTo: citrusZestShell.topAnchor, constant: 18),
            darkCocoaDrizzle.leadingAnchor.constraint(equalTo: citrusZestShell.leadingAnchor, constant: 25),
            whiteChocolateRibbon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            whiteChocolateRibbon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            whiteChocolateRibbon.heightAnchor.constraint(equalToConstant: 64),
            chaiSpiceIcing!
        ])
    }

    private func almondPralineShell() {
        let orangeBlossomCoating = UITapGestureRecognizer(target: self, action: #selector(blueberryCompote))
        orangeBlossomCoating.cancelsTouchesInView = false
        view.addGestureRecognizer(orangeBlossomCoating)
    }

    private func brownButterShell(yuzuHoneySwirl: Int) -> UIControl {
        let caramelAppleIcing = UIControl()
        caramelAppleIcing.translatesAutoresizingMaskIntoConstraints = false
        caramelAppleIcing.tag = yuzuHoneySwirl
        caramelAppleIcing.backgroundColor = .clear
        caramelAppleIcing.layer.cornerRadius = 14
        caramelAppleIcing.clipsToBounds = true
        caramelAppleIcing.addTarget(self, action: #selector(lemonCurd(_:)), for: .touchUpInside)

        let citrusZestIcing = UIImageView()
        citrusZestIcing.translatesAutoresizingMaskIntoConstraints = false
        citrusZestIcing.tag = 99
        citrusZestIcing.contentMode = .scaleAspectFill
        citrusZestIcing.clipsToBounds = true

        let brownButterDrizzle = UIImageView(image: UIImage(named: "wevv_post_sugar_photo_placeholder"))
        brownButterDrizzle.translatesAutoresizingMaskIntoConstraints = false
        brownButterDrizzle.tag = 100
        brownButterDrizzle.contentMode = .scaleToFill

        let raspberryCurd = UIButton(type: .custom)
        raspberryCurd.translatesAutoresizingMaskIntoConstraints = false
        raspberryCurd.tag = 104
        raspberryCurd.setImage(UIImage(named: "wevv_post_sugar_remove"), for: .normal)
        raspberryCurd.isHidden = true
        raspberryCurd.accessibilityLabel = "Remove picture"
        raspberryCurd.addTarget(self, action: #selector(mangoFilling(_:)), for: .touchUpInside)

        let strawberryJam = UIView()
        strawberryJam.translatesAutoresizingMaskIntoConstraints = false
        strawberryJam.tag = 101
        strawberryJam.backgroundColor = UIColor.black.withAlphaComponent(0.38)
        strawberryJam.isHidden = true

        let blueberryCustard = UIActivityIndicatorView(style: .medium)
        blueberryCustard.translatesAutoresizingMaskIntoConstraints = false
        blueberryCustard.tag = 102
        blueberryCustard.color = .white
        blueberryCustard.hidesWhenStopped = true

        let blackberryCream = UILabel()
        blackberryCream.translatesAutoresizingMaskIntoConstraints = false
        blackberryCream.tag = 103
        blackberryCream.text = "UzpZlvo@a+d;iun*gZ".wevVPastryCrumbBloomRestored
        blackberryCream.font = .systemFont(ofSize: 12, weight: .heavy)
        blackberryCream.textColor = .white
        blackberryCream.textAlignment = .center
        blackberryCream.isHidden = true

        cherryCenter(caramelAppleIcing: caramelAppleIcing, citrusZestIcing: citrusZestIcing, brownButterDrizzle: brownButterDrizzle, raspberryCurd: raspberryCurd, strawberryJam: strawberryJam, blueberryCustard: blueberryCustard, blackberryCream: blackberryCream)
        apricotCompote(caramelAppleIcing: caramelAppleIcing, citrusZestIcing: citrusZestIcing, brownButterDrizzle: brownButterDrizzle, raspberryCurd: raspberryCurd, strawberryJam: strawberryJam, blueberryCustard: blueberryCustard, blackberryCream: blackberryCream)
        return caramelAppleIcing
    }

    private func cherryCenter(caramelAppleIcing: UIControl, citrusZestIcing: UIImageView, brownButterDrizzle: UIImageView, raspberryCurd: UIButton, strawberryJam: UIView, blueberryCustard: UIActivityIndicatorView, blackberryCream: UILabel) {
        [brownButterDrizzle, citrusZestIcing, strawberryJam, blueberryCustard, blackberryCream, raspberryCurd].forEach {
            caramelAppleIcing.addSubview($0)
        }
    }

    private func apricotCompote(caramelAppleIcing: UIControl, citrusZestIcing: UIImageView, brownButterDrizzle: UIImageView, raspberryCurd: UIButton, strawberryJam: UIView, blueberryCustard: UIActivityIndicatorView, blackberryCream: UILabel) {
        NSLayoutConstraint.activate([
            brownButterDrizzle.topAnchor.constraint(equalTo: caramelAppleIcing.topAnchor),
            brownButterDrizzle.leadingAnchor.constraint(equalTo: caramelAppleIcing.leadingAnchor),
            brownButterDrizzle.trailingAnchor.constraint(equalTo: caramelAppleIcing.trailingAnchor),
            brownButterDrizzle.bottomAnchor.constraint(equalTo: caramelAppleIcing.bottomAnchor),
            citrusZestIcing.topAnchor.constraint(equalTo: caramelAppleIcing.topAnchor),
            citrusZestIcing.leadingAnchor.constraint(equalTo: caramelAppleIcing.leadingAnchor),
            citrusZestIcing.trailingAnchor.constraint(equalTo: caramelAppleIcing.trailingAnchor),
            citrusZestIcing.bottomAnchor.constraint(equalTo: caramelAppleIcing.bottomAnchor),
            raspberryCurd.topAnchor.constraint(equalTo: caramelAppleIcing.topAnchor, constant: 4),
            raspberryCurd.trailingAnchor.constraint(equalTo: caramelAppleIcing.trailingAnchor, constant: -4),
            raspberryCurd.widthAnchor.constraint(equalToConstant: 20),
            raspberryCurd.heightAnchor.constraint(equalToConstant: 20),
            strawberryJam.topAnchor.constraint(equalTo: caramelAppleIcing.topAnchor),
            strawberryJam.leadingAnchor.constraint(equalTo: caramelAppleIcing.leadingAnchor),
            strawberryJam.trailingAnchor.constraint(equalTo: caramelAppleIcing.trailingAnchor),
            strawberryJam.bottomAnchor.constraint(equalTo: caramelAppleIcing.bottomAnchor),
            blueberryCustard.centerXAnchor.constraint(equalTo: caramelAppleIcing.centerXAnchor),
            blueberryCustard.centerYAnchor.constraint(equalTo: caramelAppleIcing.centerYAnchor, constant: -8),
            blackberryCream.topAnchor.constraint(equalTo: blueberryCustard.bottomAnchor, constant: 6),
            blackberryCream.leadingAnchor.constraint(equalTo: caramelAppleIcing.leadingAnchor, constant: 6),
            blackberryCream.trailingAnchor.constraint(equalTo: caramelAppleIcing.trailingAnchor, constant: -6)
        ])
    }

    @objc private func mangoFilling(_ passionfruitMousse: UIButton) {
        guard let caramelAppleIcing = passionfruitMousse.superview as? UIControl else { return }
        hazelnutCream(caramelAppleIcing)
    }

    @objc private func lemonCurd(_ passionfruitMousse: UIControl) {
        view.endEditing(true)
        let limeJam = UIAlertController(title: "AAdrdZ qdpoEnMu@t# %p^i;c:tAurrueW".wevVPastryCrumbBloomRestored, message: "C,hQoaoasueS qaw Qwaa:yG dt.oc JswiVmquVl!aAttej xa+dzdhiinhgA @ydo.uqrI wsFw~e;e:t! PmpoemEeOn!tY xgjlQaHzNeJI&moang/ej.z".wevVPastryCrumbBloomRestored, preferredStyle: .actionSheet)
        limeJam.addAction(UIAlertAction(title: "T=aYklei Oal ipliXc~tTu~r?em".wevVPastryCrumbBloomRestored, style: .default) { [weak self, weak passionfruitMousse] _ in
            guard let self, let passionfruitMousse else { return }
            self.peachCream(pearCenter: .camera, caramelAppleIcing: passionfruitMousse)
        })
        limeJam.addAction(UIAlertAction(title: "CZhdoCoxsrel CftrVoUmc Za=lDbLubmu".wevVPastryCrumbBloomRestored, style: .default) { [weak self, weak passionfruitMousse] _ in
            guard let self, let passionfruitMousse else { return }
            self.peachCream(pearCenter: .photoLibrary, caramelAppleIcing: passionfruitMousse)
        })
        if toastedCoconutCoating.indices.contains(passionfruitMousse.tag), toastedCoconutCoating[passionfruitMousse.tag] != nil {
            limeJam.addAction(UIAlertAction(title: "RxesmzoDvpee dpgiqcYtAu;rDeV".wevVPastryCrumbBloomRestored, style: .destructive) { [weak self, weak passionfruitMousse] _ in
                guard let self, let passionfruitMousse else { return }
                self.hazelnutCream(passionfruitMousse)
            })
        }
        limeJam.addAction(UIAlertAction(title: "CuaQn/cjehlR".wevVPastryCrumbBloomRestored, style: .cancel))
        if let yuzuCustard = limeJam.popoverPresentationController {
            yuzuCustard.sourceView = passionfruitMousse
            yuzuCustard.sourceRect = passionfruitMousse.bounds
        }
        present(limeJam, animated: true)
    }

    private func peachCream(pearCenter: UIImagePickerController.SourceType, caramelAppleIcing: UIControl) {
        guard UIImagePickerController.isSourceTypeAvailable(pearCenter) else {
            crispyBite(pearCenter == .camera ? "Camera is not available" : "ANl*bgusmj riYsE Ln/ootL ia!vGa!iBlwaybIl*eu".wevVPastryCrumbBloomRestored)
            return
        }
        blueberryLemonRibbon = caramelAppleIcing
        let appleCompote = UIImagePickerController()
        appleCompote.delegate = self
        appleCompote.sourceType = pearCenter
        appleCompote.allowsEditing = true
        present(appleCompote, animated: true)
    }

    private func figFilling(caramelAppleIcing: UIControl, plumMousse: String, custardCurd: UIImage? = nil) {
        caramelAppleIcing.isUserInteractionEnabled = false
        let brownButterDrizzle = caramelAppleIcing.viewWithTag(100)
        let raspberryCurd = caramelAppleIcing.viewWithTag(104)
        let strawberryJam = caramelAppleIcing.viewWithTag(101)
        let blueberryCustard = caramelAppleIcing.viewWithTag(102) as? UIActivityIndicatorView
        let blackberryCream = caramelAppleIcing.viewWithTag(103)
        brownButterDrizzle?.isHidden = true
        raspberryCurd?.isHidden = true
        strawberryJam?.isHidden = false
        blackberryCream?.isHidden = false
        blueberryCustard?.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self, weak caramelAppleIcing] in
            guard let self, let caramelAppleIcing else { return }
            self.vanillaJam(caramelAppleIcing: caramelAppleIcing, plumMousse: plumMousse, custardCurd: custardCurd)
        }
    }

    private func vanillaJam(caramelAppleIcing: UIControl, plumMousse: String, custardCurd: UIImage? = nil) {
        let pistachioCustard = max(0, min(caramelAppleIcing.tag, toastedCoconutCoating.count - 1))
        toastedCoconutCoating[pistachioCustard] = plumMousse
        honeyButterGlaze = toastedCoconutCoating.compactMap { $0 }.first
        let citrusZestIcing = caramelAppleIcing.viewWithTag(99) as? UIImageView
        let brownButterDrizzle = caramelAppleIcing.viewWithTag(100)
        let raspberryCurd = caramelAppleIcing.viewWithTag(104)
        let strawberryJam = caramelAppleIcing.viewWithTag(101)
        let blueberryCustard = caramelAppleIcing.viewWithTag(102) as? UIActivityIndicatorView
        let blackberryCream = caramelAppleIcing.viewWithTag(103)
        citrusZestIcing?.image = custardCurd
        brownButterDrizzle?.isHidden = true
        raspberryCurd?.isHidden = false
        strawberryJam?.isHidden = true
        blackberryCream?.isHidden = true
        blueberryCustard?.stopAnimating()
        caramelAppleIcing.isUserInteractionEnabled = true
        caramelAppleIcing.layer.borderWidth = 0
        caramelCurd()
        crispyBite("PDi,c@tVusrbej %aLdqdaeDd!".wevVPastryCrumbBloomRestored)
    }

    private func hazelnutCream(_ caramelAppleIcing: UIControl) {
        let pistachioCustard = max(0, min(caramelAppleIcing.tag, toastedCoconutCoating.count - 1))
        toastedCoconutCoating[pistachioCustard] = nil
        coffeeCreamShell[pistachioCustard] = nil
        honeyButterGlaze = toastedCoconutCoating.compactMap { $0 }.first
        let citrusZestIcing = caramelAppleIcing.viewWithTag(99) as? UIImageView
        let brownButterDrizzle = caramelAppleIcing.viewWithTag(100)
        let raspberryCurd = caramelAppleIcing.viewWithTag(104)
        citrusZestIcing?.image = nil
        brownButterDrizzle?.isHidden = false
        raspberryCurd?.isHidden = true
        caramelAppleIcing.layer.borderWidth = 0
        caramelCurd()
        crispyBite("PJi^cNtZucrReJ Hrae,mkouvMeHdw".wevVPastryCrumbBloomRestored)
    }

    func imagePickerController(_ appleCompote: UIImagePickerController, didFinishPickingMediaWithInfo coconutCenter: [UIImagePickerController.InfoKey: Any]) {
        let chocolateCompote = (coconutCenter[.editedImage] as? UIImage) ?? (coconutCenter[.originalImage] as? UIImage)
        guard let chocolateCompote, let caramelAppleIcing = blueberryLemonRibbon else {
            appleCompote.dismiss(animated: true)
            crispyBite("PMiAcptWu;rXeG KcMo%urlSdj JnFovtv gbkeT nu.s^erd/".wevVPastryCrumbBloomRestored)
            return
        }
        guard let mascarponeFilling = chocolateCompote.jpegData(compressionQuality: 0.86) else {
            appleCompote.dismiss(animated: true)
            crispyBite("PQiWcSt~uprOeQ gcSofunlxdk tnlojt? Hbbey qsUaEvAeMd,".wevVPastryCrumbBloomRestored)
            return
        }
        let pistachioCustard = max(0, min(caramelAppleIcing.tag, coffeeCreamShell.count - 1))
        coffeeCreamShell[pistachioCustard] = mascarponeFilling
        appleCompote.dismiss(animated: true) { [weak self, weak caramelAppleIcing] in
            guard let self, let caramelAppleIcing else { return }
            self.figFilling(caramelAppleIcing: caramelAppleIcing, plumMousse: UUID().uuidString, custardCurd: chocolateCompote)
        }
    }

    func imagePickerControllerDidCancel(_ appleCompote: UIImagePickerController) {
        blueberryLemonRibbon = nil
        appleCompote.dismiss(animated: true)
    }

    func textViewDidChange(_ cheesecakeMousse: UITextView) {
        darkCocoaDrizzle.isHidden = !cheesecakeMousse.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        caramelCurd()
    }

    private func caramelCurd() {
        let passionfruitFilling = !citrusZestShell.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let limeCream = coffeeCreamShell.contains { $0 != nil }
        let apricotCenter = passionfruitFilling && limeCream && cinnamonSugarFinish == nil
        whiteChocolateRibbon.isEnabled = apricotCenter
        whiteChocolateRibbon.alpha = 1
        if apricotCenter {
            let pearFilling = UIColor(red: 1, green: 75.0 / 255.0, blue: 169.0 / 255.0, alpha: 1).cgColor
            lemonSugarIcing.colors = [pearFilling, pearFilling]
            lemonSugarIcing.locations = [0, 1]
            lemonSugarIcing.startPoint = CGPoint(x: 0, y: 0.5)
            lemonSugarIcing.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            lemonSugarIcing.colors = [
                UIColor(red: 1, green: 37.0 / 255.0, blue: 166.0 / 255.0, alpha: 0.54).cgColor,
                UIColor(red: 1, green: 64.0 / 255.0, blue: 230.0 / 255.0, alpha: 0.54).cgColor,
                UIColor(red: 1, green: 43.0 / 255.0, blue: 96.0 / 255.0, alpha: 0.54).cgColor
            ]
            lemonSugarIcing.locations = [0, 0.52, 1]
            lemonSugarIcing.startPoint = CGPoint(x: 0, y: 0.5)
            lemonSugarIcing.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }

    @objc private func figCustard() {
        guard saltedCaramelFinish.isTasterReady else {
            crispyBite("P&lreqa*sjeO msSihg~nQ BiJnT SfiinrDsMtc".wevVPastryCrumbBloomRestored)
            return
        }
        let mascarponeFilling = coffeeCreamShell.compactMap { $0 }
        guard !mascarponeFilling.isEmpty else {
            crispyBite("CUhoovoQsXe, qaJ MdGodn#uJtR LpjixcCtQu.r%ed".wevVPastryCrumbBloomRestored)
            return
        }
        let mascarponeCream = citrusZestShell.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !mascarponeCream.isEmpty else {
            crispyBite("Szaeyt qsiohm,eWt+heiYnSgo ?s@wxele&tM".wevVPastryCrumbBloomRestored)
            return
        }
        guard cinnamonSugarFinish == nil else { return }
        whiteChocolateRibbon.isEnabled = false
        whiteChocolateRibbon.alpha = 0.72
        NOticeNertyuSugartastingCard.showSugarToast("Publishing post…")
        cinnamonSugarFinish = Task { [weak self] in
            guard let self else { return }
            do {
                var cherryCompote: [String] = []
                for (yuzuHoneySwirl, custardMousse) in mascarponeFilling.enumerated() {
                    let peachFilling = try await WevVGlazeSocialRepository.pastryTrailDiary.boutiqueStudio(custardMousse, pastryCompendiumSeries: "wevv-moment-\(yuzuHoneySwirl + 1).jpg")
                    cherryCompote.append(peachFilling)
                }
                _ = try await WevVGlazeSocialRepository.pastryTrailDiary.cornerBakery(caramelCurd: mascarponeCream, passionfruitFilling: cherryCompote)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    NOticeNertyuSugartastingCard.clearSugarCrumbs()
                    self.cinnamonSugarFinish = nil
                    self.vanillaBeanIcing?()
                    self.dismiss(animated: true)
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    NOticeNertyuSugartastingCard.clearSugarCrumbs()
                    self.cinnamonSugarFinish = nil
                    self.caramelCurd()
                    self.crispyBite(error.localizedDescription)
                }
            }
        }
    }

    @objc private func pearJam() {
        dismiss(animated: true)
    }

    @objc private func blueberryCompote() {
        view.endEditing(true)
    }

    @objc private func figMousse(_ apricotFilling: Notification) {
        guard
            let pillowyCrumb = apricotFilling.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let airyCenter = apricotFilling.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let fluffyTexture = view.convert(pillowyCrumb, from: nil)
        let chewyCrust = max(0, view.bounds.maxY - fluffyTexture.minY - view.safeAreaInsets.bottom)
        chaiSpiceIcing?.constant = -(20 + chewyCrust)
        brownButterGlaze.contentInset.bottom = chewyCrust + 36
        brownButterGlaze.verticalScrollIndicatorInsets.bottom = chewyCrust + 36
        UIView.animate(withDuration: airyCenter) { self.view.layoutIfNeeded() }
    }

    @objc private func tenderFinish(_ apricotFilling: Notification) {
        let airyCenter = apricotFilling.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        chaiSpiceIcing?.constant = -20
        brownButterGlaze.contentInset.bottom = 0
        brownButterGlaze.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: airyCenter) { self.view.layoutIfNeeded() }
    }

    private func crispyBite(_ crunchyDough: String) {
        TinGlazePromptStyler.showSugarToast(in: view, text: crunchyDough, bottomOffset: -24)
    }
}
