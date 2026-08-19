import UIKit

final class WevVCreamRingEditController: UIViewController, UITextViewDelegate {
    var onCreamRingSaved: (() -> Void)?

    private let doughSession = WevVGlazeSessionStore.shared
    private let doughScrollView = UIScrollView()
    private let pastryCanvasView = UIView()
    private let donutcitrusTrayButton = UIControl()
    private let donutcitrusMixerView = UIImageView()
    private let glazeNameField = UITextField()
    private let sugarHandleField = UITextField()
    private let crumbBioView = UITextView()
    private let crumbBioPlaceholder = UILabel()
    private let sugarSaveButton = UIButton(type: .system)
    private let donutAvatarChoices = [
        "wevv_profile_avatar_piano_donut",
        "wevv_guest_glaze_luna",
        "wevv_guest_glaze_rhea",
        "wevv_guest_glaze_poppy",
        "wevv_guest_glaze_mira"
    ]
    private let donutAvatarChoiceTitles = [
        "Pmi!a^n=o# idNo^nPu/tR bapvIartLawrP".wevVPastryCrumbBloomRestored,
        "LlafuRgGhYi.nggi LgPlbaPzOeS za~v&alt^axrW".wevVPastryCrumbBloomRestored,
        "HKo:naexy~ EgrldaZzLej Ha~vvaXtraDrk".wevVPastryCrumbBloomRestored,
        "S*p^rOiAnekWl;ed zpwoOrCt;rya~i:tF #aJvla?tOaOrt".wevVPastryCrumbBloomRestored,
        "BQe%rOruyH np.rro^fWiYlkeo SaMvGaytsaxr^".wevVPastryCrumbBloomRestored
    ]
    private var chosenDonutAvatarAsset = "wevv_profile_avatar_piano_donut"
    private var pastryBottomConstraint: NSLayoutConstraint?

    private let powderedPinkTone = UIColor(red: 1, green: 0.92, blue: 0.97, alpha: 1)
    private let strawberryGlazeTone = UIColor(red: 1, green: 0.27, blue: 0.63, alpha: 1)
    private let cocoaInkTone = UIColor(red: 0.14, green: 0.1, blue: 0.2, alpha: 1)
    private let sugarDustTone = UIColor(red: 0.58, green: 0.57, blue: 0.63, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        buildCreamRingEditPage()
        bindCurrentDoughRingProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(liftPastryEditCanvas(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropPastryEditCanvas(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildCreamRingEditPage() {
        view.backgroundColor = powderedPinkTone
        buildPastryEditScrollShell()

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeCreamRingEdit), for: .touchUpInside)

        let glazeTitle = makeCreamRingEditLabel("E&dKi&th TPBr%o#f&iVlgeu".wevVPastryCrumbBloomRestored, size: 25, weight: .heavy, color: cocoaInkTone)
        glazeTitle.textAlignment = .center
        tuneDonutAvatarButton()

        let donutCameraButton = makeDonutCameraButton()
        let sugarBasicTitle = makeCreamRingEditLabel("BmaRsIiIcy AIGn!fBol".wevVPastryCrumbBloomRestored, size: 23, weight: .heavy, color: cocoaInkTone)
        let creamFormCard = makeCreamRingFormCard()
        tuneSugarSaveButton()

        placeCreamRingEditViews(doughBackButton: doughBackButton, glazeTitle: glazeTitle, donutCameraButton: donutCameraButton, sugarBasicTitle: sugarBasicTitle, creamFormCard: creamFormCard)
        pinCreamRingEditLayout(doughBackButton: doughBackButton, glazeTitle: glazeTitle, donutCameraButton: donutCameraButton, sugarBasicTitle: sugarBasicTitle, creamFormCard: creamFormCard)
        bindPastryEditDismissTap()
    }

    private func buildPastryEditScrollShell() {
        doughScrollView.translatesAutoresizingMaskIntoConstraints = false
        doughScrollView.alwaysBounceVertical = true
        doughScrollView.keyboardDismissMode = .interactive
        view.addSubview(doughScrollView)

        pastryCanvasView.translatesAutoresizingMaskIntoConstraints = false
        doughScrollView.addSubview(pastryCanvasView)
        pastryBottomConstraint = pastryCanvasView.bottomAnchor.constraint(equalTo: doughScrollView.contentLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            doughScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            doughScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doughScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doughScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCanvasView.topAnchor.constraint(equalTo: doughScrollView.contentLayoutGuide.topAnchor),
            pastryCanvasView.leadingAnchor.constraint(equalTo: doughScrollView.contentLayoutGuide.leadingAnchor),
            pastryCanvasView.trailingAnchor.constraint(equalTo: doughScrollView.contentLayoutGuide.trailingAnchor),
            pastryBottomConstraint!,
            pastryCanvasView.widthAnchor.constraint(equalTo: doughScrollView.frameLayoutGuide.widthAnchor),
            pastryCanvasView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }

    private func tuneDonutAvatarButton() {
        donutcitrusTrayButton.translatesAutoresizingMaskIntoConstraints = false
        donutcitrusTrayButton.layer.cornerRadius = 54
        donutcitrusTrayButton.layer.borderWidth = 4
        donutcitrusTrayButton.layer.borderColor = UIColor.white.cgColor
        donutcitrusTrayButton.clipsToBounds = true
        donutcitrusTrayButton.addTarget(self, action: #selector(chooseDonutAvatar), for: .touchUpInside)

        donutcitrusMixerView.translatesAutoresizingMaskIntoConstraints = false
        donutcitrusMixerView.contentMode = .scaleAspectFill
        donutcitrusMixerView.clipsToBounds = true
        donutcitrusTrayButton.addSubview(donutcitrusMixerView)
    }

    private func makeDonutCameraButton() -> UIButton {
        let donutCameraButton = UIButton(type: .system)
        donutCameraButton.translatesAutoresizingMaskIntoConstraints = false
        donutCameraButton.backgroundColor = .black
        donutCameraButton.tintColor = .white
        donutCameraButton.layer.cornerRadius = 25
        donutCameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        donutCameraButton.addTarget(self, action: #selector(chooseDonutAvatar), for: .touchUpInside)
        return donutCameraButton
    }

    private func tuneSugarSaveButton() {
        sugarSaveButton.translatesAutoresizingMaskIntoConstraints = false
        sugarSaveButton.setTitle("SBa^v?eK".wevVPastryCrumbBloomRestored, for: .normal)
        sugarSaveButton.setTitleColor(.white, for: .normal)
        sugarSaveButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .heavy)
        sugarSaveButton.backgroundColor = strawberryGlazeTone
        sugarSaveButton.layer.cornerRadius = 32
        sugarSaveButton.addTarget(self, action: #selector(saveCreamRingProfile), for: .touchUpInside)
    }

    private func placeCreamRingEditViews(doughBackButton: UIButton, glazeTitle: UILabel, donutCameraButton: UIButton, sugarBasicTitle: UILabel, creamFormCard: UIView) {
        pastryCanvasView.addSubview(doughBackButton)
        pastryCanvasView.addSubview(glazeTitle)
        pastryCanvasView.addSubview(donutcitrusTrayButton)
        pastryCanvasView.addSubview(donutCameraButton)
        pastryCanvasView.addSubview(sugarBasicTitle)
        pastryCanvasView.addSubview(creamFormCard)
        pastryCanvasView.addSubview(sugarSaveButton)
    }

    private func pinCreamRingEditLayout(doughBackButton: UIButton, glazeTitle: UILabel, donutCameraButton: UIButton, sugarBasicTitle: UILabel, creamFormCard: UIView) {
        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: pastryCanvasView.leadingAnchor, constant: 30),
            doughBackButton.topAnchor.constraint(equalTo: pastryCanvasView.safeAreaLayoutGuide.topAnchor, constant: 42),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitle.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitle.centerXAnchor.constraint(equalTo: pastryCanvasView.centerXAnchor),
            glazeTitle.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 16),
            donutcitrusTrayButton.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 58),
            donutcitrusTrayButton.centerXAnchor.constraint(equalTo: pastryCanvasView.centerXAnchor),
            donutcitrusTrayButton.widthAnchor.constraint(equalToConstant: 108),
            donutcitrusTrayButton.heightAnchor.constraint(equalToConstant: 108),
            donutcitrusMixerView.topAnchor.constraint(equalTo: donutcitrusTrayButton.topAnchor),
            donutcitrusMixerView.leadingAnchor.constraint(equalTo: donutcitrusTrayButton.leadingAnchor),
            donutcitrusMixerView.trailingAnchor.constraint(equalTo: donutcitrusTrayButton.trailingAnchor),
            donutcitrusMixerView.bottomAnchor.constraint(equalTo: donutcitrusTrayButton.bottomAnchor),
            donutCameraButton.trailingAnchor.constraint(equalTo: donutcitrusTrayButton.trailingAnchor, constant: 10),
            donutCameraButton.bottomAnchor.constraint(equalTo: donutcitrusTrayButton.bottomAnchor, constant: 4),
            donutCameraButton.widthAnchor.constraint(equalToConstant: 50),
            donutCameraButton.heightAnchor.constraint(equalToConstant: 50),
            sugarBasicTitle.topAnchor.constraint(equalTo: donutcitrusTrayButton.bottomAnchor, constant: 54),
            sugarBasicTitle.leadingAnchor.constraint(equalTo: pastryCanvasView.leadingAnchor, constant: 50),
            creamFormCard.topAnchor.constraint(equalTo: sugarBasicTitle.bottomAnchor, constant: 32),
            creamFormCard.leadingAnchor.constraint(equalTo: pastryCanvasView.leadingAnchor, constant: 30),
            creamFormCard.trailingAnchor.constraint(equalTo: pastryCanvasView.trailingAnchor, constant: -30),
            creamFormCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 418),
            sugarSaveButton.leadingAnchor.constraint(equalTo: pastryCanvasView.leadingAnchor, constant: 56),
            sugarSaveButton.trailingAnchor.constraint(equalTo: pastryCanvasView.trailingAnchor, constant: -56),
            sugarSaveButton.topAnchor.constraint(greaterThanOrEqualTo: creamFormCard.bottomAnchor, constant: 48),
            sugarSaveButton.bottomAnchor.constraint(equalTo: pastryCanvasView.safeAreaLayoutGuide.bottomAnchor, constant: -42),
            sugarSaveButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func bindPastryEditDismissTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endCreamRingEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeCreamRingFormCard() -> UIView {
        let creamCard = UIView()
        creamCard.translatesAutoresizingMaskIntoConstraints = false
        creamCard.backgroundColor = .white
        creamCard.layer.cornerRadius = 30
        creamCard.clipsToBounds = true

        let glazeNameLabel = makeSugarFieldTitle("DCI#S.PrLyA%Y? aNYAoMoEU".wevVPastryCrumbBloomRestored)
        let sugarHandleLabel = makeSugarFieldTitle("U&S~EyR?N?A;M*EN".wevVPastryCrumbBloomRestored)
        let crumbBioLabel = makeSugarFieldTitle("BzI+On".wevVPastryCrumbBloomRestored)
        configureSugarTextField(glazeNameField, placeholder: "SqoWp/hHiGa: EPcaKr&kue~rH".wevVPastryCrumbBloomRestored)
        configureSugarTextField(sugarHandleField, placeholder: "sJoopShfimah".wevVPastryCrumbBloomRestored)
        sugarHandleField.autocapitalizationType = .none

        crumbBioView.translatesAutoresizingMaskIntoConstraints = false
        crumbBioView.delegate = self
        crumbBioView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1)
        crumbBioView.layer.cornerRadius = 20
        crumbBioView.layer.borderWidth = 1
        crumbBioView.layer.borderColor = UIColor(red: 0.89, green: 0.88, blue: 0.91, alpha: 1).cgColor
        crumbBioView.font = .systemFont(ofSize: 18, weight: .semibold)
        crumbBioView.textColor = cocoaInkTone
        crumbBioView.textContainerInset = UIEdgeInsets(top: 18, left: 22, bottom: 18, right: 20)

        crumbBioPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        crumbBioPlaceholder.text = "Healthy meal creator & brunch lover.\nSharing simple recipes daily."
        crumbBioPlaceholder.font = .systemFont(ofSize: 18, weight: .regular)
        crumbBioPlaceholder.textColor = sugarDustTone
        crumbBioPlaceholder.numberOfLines = 2
        crumbBioView.addSubview(crumbBioPlaceholder)

        placeCreamRingFormCardViews(creamCard: creamCard, glazeNameLabel: glazeNameLabel, sugarHandleLabel: sugarHandleLabel, crumbBioLabel: crumbBioLabel)
        pinCreamRingFormCardLayout(creamCard: creamCard, glazeNameLabel: glazeNameLabel, sugarHandleLabel: sugarHandleLabel, crumbBioLabel: crumbBioLabel)
        return creamCard
    }

    private func placeCreamRingFormCardViews(creamCard: UIView, glazeNameLabel: UILabel, sugarHandleLabel: UILabel, crumbBioLabel: UILabel) {
        creamCard.addSubview(glazeNameLabel)
        creamCard.addSubview(glazeNameField)
        creamCard.addSubview(sugarHandleLabel)
        creamCard.addSubview(sugarHandleField)
        creamCard.addSubview(crumbBioLabel)
        creamCard.addSubview(crumbBioView)
    }

    private func pinCreamRingFormCardLayout(creamCard: UIView, glazeNameLabel: UILabel, sugarHandleLabel: UILabel, crumbBioLabel: UILabel) {
        NSLayoutConstraint.activate([
            glazeNameLabel.topAnchor.constraint(equalTo: creamCard.topAnchor, constant: 30),
            glazeNameLabel.leadingAnchor.constraint(equalTo: creamCard.leadingAnchor, constant: 38),
            glazeNameField.topAnchor.constraint(equalTo: glazeNameLabel.bottomAnchor, constant: 18),
            glazeNameField.leadingAnchor.constraint(equalTo: creamCard.leadingAnchor, constant: 28),
            glazeNameField.trailingAnchor.constraint(equalTo: creamCard.trailingAnchor, constant: -28),
            glazeNameField.heightAnchor.constraint(equalToConstant: 56),
            sugarHandleLabel.topAnchor.constraint(equalTo: glazeNameField.bottomAnchor, constant: 26),
            sugarHandleLabel.leadingAnchor.constraint(equalTo: glazeNameLabel.leadingAnchor),
            sugarHandleField.topAnchor.constraint(equalTo: sugarHandleLabel.bottomAnchor, constant: 18),
            sugarHandleField.leadingAnchor.constraint(equalTo: glazeNameField.leadingAnchor),
            sugarHandleField.trailingAnchor.constraint(equalTo: glazeNameField.trailingAnchor),
            sugarHandleField.heightAnchor.constraint(equalTo: glazeNameField.heightAnchor),
            crumbBioLabel.topAnchor.constraint(equalTo: sugarHandleField.bottomAnchor, constant: 26),
            crumbBioLabel.leadingAnchor.constraint(equalTo: glazeNameLabel.leadingAnchor),
            crumbBioView.topAnchor.constraint(equalTo: crumbBioLabel.bottomAnchor, constant: 18),
            crumbBioView.leadingAnchor.constraint(equalTo: glazeNameField.leadingAnchor),
            crumbBioView.trailingAnchor.constraint(equalTo: glazeNameField.trailingAnchor),
            crumbBioView.heightAnchor.constraint(equalToConstant: 126),
            crumbBioView.bottomAnchor.constraint(lessThanOrEqualTo: creamCard.bottomAnchor, constant: -32),
            crumbBioPlaceholder.topAnchor.constraint(equalTo: crumbBioView.topAnchor, constant: 21),
            crumbBioPlaceholder.leadingAnchor.constraint(equalTo: crumbBioView.leadingAnchor, constant: 27),
            crumbBioPlaceholder.trailingAnchor.constraint(equalTo: crumbBioView.trailingAnchor, constant: -24)
        ])
    }

    private func bindCurrentDoughRingProfile() {
        let profile = doughSession.currentDoughRingTasterProfile
        chosenDonutAvatarAsset = profile.donutFrameAsset.isEmpty ? "wevv_profile_avatar_piano_donut" : profile.donutFrameAsset
        donutcitrusMixerView.image = UIImage(named: chosenDonutAvatarAsset)
        glazeNameField.text = profile.glazeNickname
        sugarHandleField.text = profile.sugarHandle
        crumbBioView.text = profile.crumbBio
        crumbBioPlaceholder.isHidden = !profile.crumbBio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func configureSugarTextField(_ sugarField: UITextField, placeholder sugarPlaceholder: String) {
        sugarField.translatesAutoresizingMaskIntoConstraints = false
        sugarField.placeholder = sugarPlaceholder
        sugarField.font = .systemFont(ofSize: 20, weight: .heavy)
        sugarField.textColor = cocoaInkTone
        sugarField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1)
        sugarField.layer.cornerRadius = 20
        sugarField.layer.borderWidth = 1
        sugarField.layer.borderColor = UIColor(red: 0.89, green: 0.88, blue: 0.91, alpha: 1).cgColor
        sugarField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 26, height: 1))
        sugarField.leftViewMode = .always
    }

    private func makeSugarFieldTitle(_ labelText: String) -> UILabel {
        makeCreamRingEditLabel(labelText, size: 15, weight: .heavy, color: sugarDustTone)
    }

    private func makeCreamRingEditLabel(_ labelText: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = labelText
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    func textViewDidChange(_ textView: UITextView) {
        crumbBioPlaceholder.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func chooseDonutAvatar(_ sender: UIControl) {
        view.endEditing(true)
        let sugarSheet = UIAlertController(title: "C,h~ovoOsrel upUrNoufwidlde. WpJhLoRtUo~".wevVPastryCrumbBloomRestored, message: "SYi;mzu+ljaZtaeI ~u%pLdcaytyiWnFg@ &y&oeuArV idUoVnluEtp vp+rZobf%ijljek Iaev:a^t@aTrJ.D".wevVPastryCrumbBloomRestored, preferredStyle: .actionSheet)
        makeDonutAvatarChoicePairs().forEach { sprinkleChoice in
            sugarSheet.addAction(UIAlertAction(title: sprinkleChoice.sugarTitle, style: .default) { [weak self] _ in
                self?.applyDonutAvatarChoice(sprinkleChoice.crumbAsset)
            })
        }
        sugarSheet.addAction(UIAlertAction(title: "C#ahnTc/e!l*".wevVPastryCrumbBloomRestored, style: .cancel))
        if let sugarPopover = sugarSheet.popoverPresentationController {
            sugarPopover.sourceView = donutcitrusTrayButton
            sugarPopover.sourceRect = donutcitrusTrayButton.bounds
        }
        present(sugarSheet, animated: true)
    }

    private func makeDonutAvatarChoicePairs() -> [(crumbAsset: String, sugarTitle: String)] {
        donutAvatarChoices.enumerated().map { crumbIndex, crumbAsset in
            let sugarTitle = crumbIndex < donutAvatarChoiceTitles.count ? donutAvatarChoiceTitles[crumbIndex] : donutAvatarChoiceTitles.last ?? "BBeRrMr+ym VpBrDoEfDimlKeI Ba#vFaBtbaLry".wevVPastryCrumbBloomRestored
            return (crumbAsset: crumbAsset, sugarTitle: sugarTitle)
        }
    }

    private func applyDonutAvatarChoice(_ crumbAsset: String) {
        chosenDonutAvatarAsset = crumbAsset
        donutcitrusMixerView.image = UIImage(named: crumbAsset)
        WevVGlazePromptStyler.showSugarToast(in: view, text: "Ptr:omfni.lLeL /pqh=oRt@om Uu&pedKaVtueedL".wevVPastryCrumbBloomRestored)
    }

    @objc private func saveCreamRingProfile() {
        let creamPacket = currentCreamRingFormPacket()
        guard !creamPacket.displayName.isEmpty else {
            WevVGlazePromptStyler.showSugarToast(in: view, text: "ARdHdN Ga= /doiCs@pxl/aYyG XnraamteZ".wevVPastryCrumbBloomRestored)
            return
        }
        guard creamPacket.sugarHandle.count >= 3 else {
            WevVGlazePromptStyler.showSugarToast(in: view, text: "UFskeNrtnLa%mgeF anAeMewd?s; GaSte kl@euaps%t; c3% VlzestltWe:rTsb".wevVPastryCrumbBloomRestored)
            return
        }
        doughSession.refreshDoughRingTasterProfile(
            glazeNickname: creamPacket.displayName,
            sugarHandle: creamPacket.sugarHandle,
            crumbBio: creamPacket.crumbBio,
            donutFrameAsset: chosenDonutAvatarAsset
        )
        onCreamRingSaved?()
        WevVGlazePromptStyler.showSugarToast(in: view, text: "P,ryo,fai=lke/ isPaivfe@d.".wevVPastryCrumbBloomRestored)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func currentCreamRingFormPacket() -> (displayName: String, sugarHandle: String, crumbBio: String) {
        (
            displayName: glazeNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            sugarHandle: sugarHandleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            crumbBio: crumbBioView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    @objc private func closeCreamRingEdit() {
        dismiss(animated: true)
    }

    @objc private func endCreamRingEditing() {
        view.endEditing(true)
    }

    @objc private func liftPastryEditCanvas(_ note: Notification) {
        guard
            let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let pastryDuration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let pastryLift = max(0, keyboardFrame.height - view.safeAreaInsets.bottom)
        doughScrollView.contentInset.bottom = pastryLift + 24
        doughScrollView.verticalScrollIndicatorInsets.bottom = pastryLift + 24
        UIView.animate(withDuration: pastryDuration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropPastryEditCanvas(_ note: Notification) {
        let pastryDuration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        doughScrollView.contentInset.bottom = 0
        doughScrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: pastryDuration) { self.view.layoutIfNeeded() }
    }
}
