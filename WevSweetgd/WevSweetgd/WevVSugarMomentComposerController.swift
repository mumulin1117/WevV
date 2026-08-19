import UIKit

final class WevVSugarMomentComposerController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onSugarMomentReady: ((WevVSugarMomentPacket) -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let SugarscrollView = UIScrollView()
    private let SugarcontentView = UIView()
    private let SugartextView = UITextView()
    private let placeholderLabel = UILabel()
    private let glazeConfirmButton = UIButton(type: .system)
    private let imageAssets = [
        "wevv_moment_one_bite_vibes",
        "wevv_moment_fresh_donut_scent",
        "wevv_moment_pink_sweetness"
    ]
    private var chosenAsset: String?
    private var chosenAssetSlots: [String?] = Array(repeating: nil, count: 3)
    private var chosenTiles: [UIControl] = []
    private weak var activeSugarPictureTile: UIControl?
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
        buildSugarScrollShell(frostingGlow: frostingGlow)

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeSugarComposer), for: .touchUpInside)

        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = "P=o=sIt#".wevVPastryCrumbBloomRestored
        glazeTitleLabel.font = .systemFont(ofSize: 31, weight: .bold)
        glazeTitleLabel.textColor = .black
        glazeTitleLabel.textAlignment = .center

        let wevSugarRow = UIStackView()
        wevSugarRow.translatesAutoresizingMaskIntoConstraints = false
        wevSugarRow.axis = .horizontal
        wevSugarRow.distribution = .fillEqually
        wevSugarRow.spacing = 10

        for index in 0..<3 {
            let tile = makeSugarImageTile(index: index)
            chosenTiles.append(tile)
            wevSugarRow.addArrangedSubview(tile)
        }

        let contentSugarLabel = UILabel()
        contentSugarLabel.translatesAutoresizingMaskIntoConstraints = false
        contentSugarLabel.text = "C%oHnBt,eRnWtG".wevVPastryCrumbBloomRestored
        contentSugarLabel.font = .systemFont(ofSize: 29, weight: .bold)
        contentSugarLabel.textColor = .black

        tuneSugarTextInput()
        tuneSugarConfirmButton()
        placeSugarCanvasViews(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, imageRow: wevSugarRow, contentLabel: contentSugarLabel)
        pinSugarCanvasLayout(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, imageRow: wevSugarRow, contentLabel: contentSugarLabel)
        bindSugarCanvasTap()
    }

    private func buildSugarScrollShell(frostingGlow: UIView) {
        view.addSubview(frostingGlow)
        SugarscrollView.translatesAutoresizingMaskIntoConstraints = false
        SugarscrollView.keyboardDismissMode = .interactive
        SugarscrollView.alwaysBounceVertical = true
        view.addSubview(SugarscrollView)
        SugarcontentView.translatesAutoresizingMaskIntoConstraints = false
        SugarscrollView.addSubview(SugarcontentView)
        bottomConstraint = SugarcontentView.bottomAnchor.constraint(equalTo: SugarscrollView.contentLayoutGuide.bottomAnchor, constant: -34)
        NSLayoutConstraint.activate([
            frostingGlow.topAnchor.constraint(equalTo: view.topAnchor),
            frostingGlow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingGlow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingGlow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            SugarscrollView.topAnchor.constraint(equalTo: view.topAnchor),
            SugarscrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SugarscrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            SugarscrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            SugarcontentView.topAnchor.constraint(equalTo: SugarscrollView.contentLayoutGuide.topAnchor),
            SugarcontentView.leadingAnchor.constraint(equalTo: SugarscrollView.contentLayoutGuide.leadingAnchor),
            SugarcontentView.trailingAnchor.constraint(equalTo: SugarscrollView.contentLayoutGuide.trailingAnchor),
            bottomConstraint!,
            SugarcontentView.widthAnchor.constraint(equalTo: SugarscrollView.frameLayoutGuide.widthAnchor),
            SugarcontentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }

    private func tuneSugarTextInput() {
        SugartextView.translatesAutoresizingMaskIntoConstraints = false
        SugartextView.delegate = self
        SugartextView.backgroundColor = .white
        SugartextView.layer.cornerRadius = 22
        SugartextView.clipsToBounds = true
        SugartextView.font = .systemFont(ofSize: 28, weight: .regular)
        SugartextView.textColor = UIColor(red: 0.18, green: 0.14, blue: 0.16, alpha: 1)
        SugartextView.textContainerInset = UIEdgeInsets(top: 30, left: 28, bottom: 24, right: 24)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "S&aiyy eS.o~mveJtjhii@ntgN".wevVPastryCrumbBloomRestored
        placeholderLabel.font = .systemFont(ofSize: 20, weight: .regular)
        placeholderLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.7, alpha: 1)
        SugartextView.addSubview(placeholderLabel)
    }

    private func tuneSugarConfirmButton() {
        glazeConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        glazeConfirmButton.setTitle("CeovnmfeiMrvmV".wevVPastryCrumbBloomRestored, for: .normal)
        glazeConfirmButton.setTitleColor(.white, for: .normal)
        glazeConfirmButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        glazeConfirmButton.backgroundColor = UIColor(red: 1.0, green: 0.44, blue: 0.72, alpha: 1.0)
        glazeConfirmButton.layer.cornerRadius = 40
        glazeConfirmButton.addTarget(self, action: #selector(confirmSugarMoment), for: .touchUpInside)
    }

    private func placeSugarCanvasViews(doughBackButton: UIButton, glazeTitleLabel: UILabel, imageRow: UIStackView, contentLabel: UILabel) {
        [doughBackButton, glazeTitleLabel, imageRow, contentLabel, SugartextView, glazeConfirmButton].forEach {
            SugarcontentView.addSubview($0)
        }
    }

    private func pinSugarCanvasLayout(doughBackButton: UIButton, glazeTitleLabel: UILabel, imageRow: UIStackView, contentLabel: UILabel) {
        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: SugarcontentView.leadingAnchor, constant: 32),
            doughBackButton.topAnchor.constraint(equalTo: SugarcontentView.safeAreaLayoutGuide.topAnchor, constant: 48),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitleLabel.centerXAnchor.constraint(equalTo: SugarcontentView.centerXAnchor),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            glazeTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 18),
            imageRow.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 50),
            imageRow.leadingAnchor.constraint(equalTo: SugarcontentView.leadingAnchor, constant: 30),
            imageRow.trailingAnchor.constraint(equalTo: SugarcontentView.trailingAnchor, constant: -30),
            imageRow.heightAnchor.constraint(equalTo: imageRow.widthAnchor, multiplier: 0.25),
            contentLabel.topAnchor.constraint(equalTo: imageRow.bottomAnchor, constant: 48),
            contentLabel.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            SugartextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 22),
            SugartextView.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            SugartextView.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            SugartextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 235),
            placeholderLabel.topAnchor.constraint(equalTo: SugartextView.topAnchor, constant: 31),
            placeholderLabel.leadingAnchor.constraint(equalTo: SugartextView.leadingAnchor, constant: 50),
            glazeConfirmButton.leadingAnchor.constraint(equalTo: SugarcontentView.leadingAnchor, constant: 30),
            glazeConfirmButton.trailingAnchor.constraint(equalTo: SugarcontentView.trailingAnchor, constant: -30),
            glazeConfirmButton.heightAnchor.constraint(equalToConstant: 80),
            glazeConfirmButton.bottomAnchor.constraint(equalTo: SugarcontentView.safeAreaLayoutGuide.bottomAnchor, constant: -72)
        ])
    }

    private func bindSugarCanvasTap() {
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

        let sugarImageView = UIImageView()
        sugarImageView.translatesAutoresizingMaskIntoConstraints = false
        sugarImageView.tag = 99
        sugarImageView.contentMode = .scaleAspectFill
        sugarImageView.clipsToBounds = true

        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.translatesAutoresizingMaskIntoConstraints = false
        camera.tag = 100
        camera.tintColor = UIColor(red: 0.72, green: 0.72, blue: 0.73, alpha: 1)
        camera.contentMode = .scaleAspectFit

        let sugarMask = UIView()
        sugarMask.translatesAutoresizingMaskIntoConstraints = false
        sugarMask.tag = 101
        sugarMask.backgroundColor = UIColor.black.withAlphaComponent(0.38)
        sugarMask.isHidden = true

        let sugarSpinner = UIActivityIndicatorView(style: .medium)
        sugarSpinner.translatesAutoresizingMaskIntoConstraints = false
        sugarSpinner.tag = 102
        sugarSpinner.color = .white
        sugarSpinner.hidesWhenStopped = true

        let sugarStatus = UILabel()
        sugarStatus.translatesAutoresizingMaskIntoConstraints = false
        sugarStatus.tag = 103
        sugarStatus.text = "UzpZlvo@a+d;iun*gZ".wevVPastryCrumbBloomRestored
        sugarStatus.font = .systemFont(ofSize: 12, weight: .heavy)
        sugarStatus.textColor = .white
        sugarStatus.textAlignment = .center
        sugarStatus.isHidden = true

        placeSugarImageTile(tile: tile, sugarImageView: sugarImageView, camera: camera, sugarMask: sugarMask, sugarSpinner: sugarSpinner, sugarStatus: sugarStatus)
        pinSugarImageTile(tile: tile, sugarImageView: sugarImageView, camera: camera, sugarMask: sugarMask, sugarSpinner: sugarSpinner, sugarStatus: sugarStatus)
        return tile
    }

    private func placeSugarImageTile(tile: UIControl, sugarImageView: UIImageView, camera: UIImageView, sugarMask: UIView, sugarSpinner: UIActivityIndicatorView, sugarStatus: UILabel) {
        [sugarImageView, camera, sugarMask, sugarSpinner, sugarStatus].forEach {
            tile.addSubview($0)
        }
    }

    private func pinSugarImageTile(tile: UIControl, sugarImageView: UIImageView, camera: UIImageView, sugarMask: UIView, sugarSpinner: UIActivityIndicatorView, sugarStatus: UILabel) {
        NSLayoutConstraint.activate([
            sugarImageView.topAnchor.constraint(equalTo: tile.topAnchor),
            sugarImageView.leadingAnchor.constraint(equalTo: tile.leadingAnchor),
            sugarImageView.trailingAnchor.constraint(equalTo: tile.trailingAnchor),
            sugarImageView.bottomAnchor.constraint(equalTo: tile.bottomAnchor),
            camera.centerXAnchor.constraint(equalTo: tile.centerXAnchor),
            camera.centerYAnchor.constraint(equalTo: tile.centerYAnchor),
            camera.widthAnchor.constraint(equalToConstant: 56),
            camera.heightAnchor.constraint(equalToConstant: 56),
            sugarMask.topAnchor.constraint(equalTo: tile.topAnchor),
            sugarMask.leadingAnchor.constraint(equalTo: tile.leadingAnchor),
            sugarMask.trailingAnchor.constraint(equalTo: tile.trailingAnchor),
            sugarMask.bottomAnchor.constraint(equalTo: tile.bottomAnchor),
            sugarSpinner.centerXAnchor.constraint(equalTo: tile.centerXAnchor),
            sugarSpinner.centerYAnchor.constraint(equalTo: tile.centerYAnchor, constant: -8),
            sugarStatus.topAnchor.constraint(equalTo: sugarSpinner.bottomAnchor, constant: 6),
            sugarStatus.leadingAnchor.constraint(equalTo: tile.leadingAnchor, constant: 6),
            sugarStatus.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -6)
        ])
    }

    @objc private func chooseSugarImage(_ sender: UIControl) {
        view.endEditing(true)
        let sheet = UIAlertController(title: "AAdrdZ qdpoEnMu@t# %p^i;c:tAurrueW".wevVPastryCrumbBloomRestored, message: "C,hQoaoasueS qaw Qwaa:yG dt.oc JswiVmquVl!aAttej xa+dzdhiinhgA @ydo.uqrI wsFw~e;e:t! PmpoemEeOn!tY xgjlQaHzNeJI&moang/ej.z".wevVPastryCrumbBloomRestored, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "T=aYklei Oal ipliXc~tTu~r?em".wevVPastryCrumbBloomRestored, style: .default) { [weak self, weak sender] _ in
            guard let self, let sender else { return }
            self.openSugarPicturePicker(source: .camera, tile: sender)
        })
        sheet.addAction(UIAlertAction(title: "CZhdoCoxsrel CftrVoUmc Za=lDbLubmu".wevVPastryCrumbBloomRestored, style: .default) { [weak self, weak sender] _ in
            guard let self, let sender else { return }
            self.openSugarPicturePicker(source: .photoLibrary, tile: sender)
        })
        if chosenAssetSlots.indices.contains(sender.tag), chosenAssetSlots[sender.tag] != nil {
            sheet.addAction(UIAlertAction(title: "RxesmzoDvpee dpgiqcYtAu;rDeV".wevVPastryCrumbBloomRestored, style: .destructive) { [weak self, weak sender] _ in
                guard let self, let sender else { return }
                self.clearSugarPictureTile(sender)
            })
        }
        sheet.addAction(UIAlertAction(title: "CuaQn/cjehlR".wevVPastryCrumbBloomRestored, style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        present(sheet, animated: true)
    }

    private func openSugarPicturePicker(source: UIImagePickerController.SourceType, tile: UIControl) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showSugarHint(source == .camera ? "Camera is not available" : "ANl*bgusmj riYsE Ln/ootL ia!vGa!iBlwaybIl*eu".wevVPastryCrumbBloomRestored)
            return
        }
        activeSugarPictureTile = tile
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func beginSugarPictureUpload(tile: UIControl, assetName: String, glazeImage: UIImage? = nil) {
        tile.isUserInteractionEnabled = false
        let camera = tile.viewWithTag(100)
        let sugarMask = tile.viewWithTag(101)
        let sugarSpinner = tile.viewWithTag(102) as? UIActivityIndicatorView
        let sugarStatus = tile.viewWithTag(103)
        camera?.isHidden = true
        sugarMask?.isHidden = false
        sugarStatus?.isHidden = false
        sugarSpinner?.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self, weak tile] in
            guard let self, let tile else { return }
            self.finishSugarPictureUpload(tile: tile, assetName: assetName, glazeImage: glazeImage)
        }
    }

    private func finishSugarPictureUpload(tile: UIControl, assetName: String, glazeImage: UIImage? = nil) {
        let slotIndex = max(0, min(tile.tag, chosenAssetSlots.count - 1))
        chosenAssetSlots[slotIndex] = assetName
        chosenAsset = chosenAssetSlots.compactMap { $0 }.first
        let sugarImageView = tile.viewWithTag(99) as? UIImageView
        let camera = tile.viewWithTag(100)
        let sugarMask = tile.viewWithTag(101)
        let sugarSpinner = tile.viewWithTag(102) as? UIActivityIndicatorView
        let sugarStatus = tile.viewWithTag(103)
        sugarImageView?.image = glazeImage ?? WevVPastryImageVault.glazeImage(for: assetName)
        camera?.isHidden = true
        sugarMask?.isHidden = true
        sugarStatus?.isHidden = true
        sugarSpinner?.stopAnimating()
        tile.isUserInteractionEnabled = true
        tile.layer.borderColor = UIColor(red: 1.0, green: 0.18, blue: 0.58, alpha: 1).cgColor
        tile.layer.borderWidth = 3
        showSugarHint("PDi,c@tVusrbej %aLdqdaeDd!".wevVPastryCrumbBloomRestored)
    }

    private func clearSugarPictureTile(_ tile: UIControl) {
        let slotIndex = max(0, min(tile.tag, chosenAssetSlots.count - 1))
        chosenAssetSlots[slotIndex] = nil
        chosenAsset = chosenAssetSlots.compactMap { $0 }.first
        let sugarImageView = tile.viewWithTag(99) as? UIImageView
        let camera = tile.viewWithTag(100)
        sugarImageView?.image = nil
        camera?.isHidden = false
        tile.layer.borderWidth = 0
        showSugarHint("PJi^cNtZucrReJ Hrae,mkouvMeHdw".wevVPastryCrumbBloomRestored)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let pickedImage, let tile = activeSugarPictureTile else {
            picker.dismiss(animated: true)
            showSugarHint("PMiAcptWu;rXeG KcMo%urlSdj JnFovtv gbkeT nu.s^erd/".wevVPastryCrumbBloomRestored)
            return
        }
        guard let sugarDustKey = WevVPastryImageVault.store(pickedImage, purpose: "sKuKgiaurGMjormdeKndtq".wevVPastryCrumbBloomRestored) else {
            picker.dismiss(animated: true)
            showSugarHint("PQiWcSt~uprOeQ gcSofunlxdk tnlojt? Hbbey qsUaEvAeMd,".wevVPastryCrumbBloomRestored)
            return
        }
        picker.dismiss(animated: true) { [weak self, weak tile] in
            guard let self, let tile else { return }
            self.beginSugarPictureUpload(tile: tile, assetName: sugarDustKey, glazeImage: pickedImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        activeSugarPictureTile = nil
        picker.dismiss(animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func confirmSugarMoment() {
        guard glazeSession.isTasterReady else {
            showSugarHint("P&lreqa*sjeO msSihg~nQ BiJnT SfiinrDsMtc".wevVPastryCrumbBloomRestored)
            return
        }
        guard let asset = chosenAsset else {
            showSugarHint("CUhoovoQsXe, qaJ MdGodn#uJtR LpjixcCtQu.r%ed".wevVPastryCrumbBloomRestored)
            return
        }
        let sugarText = SugartextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sugarText.isEmpty else {
            showSugarHint("Szaeyt qsiohm,eWt+heiYnSgo ?s@wxele&tM".wevVPastryCrumbBloomRestored)
            return
        }
        glazeConfirmButton.isEnabled = false
        glazeConfirmButton.alpha = 0.72
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Pfuobcllims@hzi!n!gc fpcoPs:tq.l.Q.;".wevVPastryCrumbBloomRestored) { [weak self] in
            guard let self else { return }
            let packet = self.glazeSession.placeSugarMoment(donutBackdropAsset: asset, text: sugarText)
            self.onSugarMomentReady?(packet)
            self.dismiss(animated: true)
        }
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
        SugarscrollView.contentInset.bottom = bottomLift + 36
        SugarscrollView.verticalScrollIndicatorInsets.bottom = bottomLift + 36
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSugarCanvas(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        SugarscrollView.contentInset.bottom = 0
        SugarscrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showSugarHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }
}
