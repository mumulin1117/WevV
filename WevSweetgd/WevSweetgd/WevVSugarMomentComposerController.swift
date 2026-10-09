import UIKit

final class WevVSugarMomentComposerController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onSugarMomentReady: (() -> Void)?

    private let glazeSession = WevVGlazeSessionStore.shared
    private let SugarscrollView = UIScrollView()
    private let SugarcontentView = UIView()
    private let SugartextView = UITextView()
    private let placeholderLabel = UILabel()
    private let glazeConfirmButton = UIButton(type: .system)
    private let sugarBackdropLayer = CAGradientLayer()
    private let glazeConfirmSheen = CAGradientLayer()
    private let imageAssets = [
        "wevv_moment_one_bite_vibes",
        "wevv_moment_fresh_donut_scent",
        "wevv_moment_pink_sweetness"
    ]
    private var chosenAsset: String?
    private var chosenAssetSlots: [String?] = Array(repeating: nil, count: 3)
    private var chosenImageData: [Data?] = Array(repeating: nil, count: 3)
    private var chosenTiles: [UIControl] = []
    private weak var activeSugarPictureTile: UIControl?
    private var bottomConstraint: NSLayoutConstraint?
    private var glazeConfirmBottomConstraint: NSLayoutConstraint?
    private var publishTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildSugarCanvas()
        NotificationCenter.default.addObserver(self, selector: #selector(liftSugarCanvas(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropSugarCanvas(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sugarBackdropLayer.frame = view.bounds
        glazeConfirmSheen.frame = glazeConfirmButton.bounds
        glazeConfirmSheen.cornerRadius = glazeConfirmButton.bounds.height / 2
    }

    deinit {
        publishTask?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func buildSugarCanvas() {
        let frostingGlow = UIView()
        frostingGlow.translatesAutoresizingMaskIntoConstraints = false
        frostingGlow.backgroundColor = .clear
        sugarBackdropLayer.colors = [
            UIColor(red: 1, green: 222.0 / 255.0, blue: 238.0 / 255.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        sugarBackdropLayer.locations = [0, 1]
        sugarBackdropLayer.startPoint = CGPoint(x: -0.04, y: 0.14)
        sugarBackdropLayer.endPoint = CGPoint(x: 1, y: 1)
        frostingGlow.layer.insertSublayer(sugarBackdropLayer, at: 0)
        buildSugarScrollShell(frostingGlow: frostingGlow)

        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(named: "wevv_checkin_sugar_back_arrow"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.imageView?.contentMode = .scaleAspectFit
        doughBackButton.addTarget(self, action: #selector(closeSugarComposer), for: .touchUpInside)

        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = "P=o=sIt#".wevVPastryCrumbBloomRestored
        glazeTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        glazeTitleLabel.textColor = .black
        glazeTitleLabel.textAlignment = .center

        let wevSugarRow = UIStackView()
        wevSugarRow.translatesAutoresizingMaskIntoConstraints = false
        wevSugarRow.axis = .horizontal
        wevSugarRow.distribution = .fillEqually
        wevSugarRow.spacing = 5

        for index in 0..<3 {
            let tile = makeSugarImageTile(index: index)
            chosenTiles.append(tile)
            wevSugarRow.addArrangedSubview(tile)
        }

        let contentSugarLabel = UILabel()
        contentSugarLabel.translatesAutoresizingMaskIntoConstraints = false
        contentSugarLabel.text = "C%oHnBt,eRnWtG".wevVPastryCrumbBloomRestored
        contentSugarLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        contentSugarLabel.textColor = .black

        tuneSugarTextInput()
        tuneSugarConfirmButton()
        placeSugarCanvasViews(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, imageRow: wevSugarRow, contentLabel: contentSugarLabel)
        pinSugarCanvasLayout(doughBackButton: doughBackButton, glazeTitleLabel: glazeTitleLabel, imageRow: wevSugarRow, contentLabel: contentSugarLabel)
        bindSugarCanvasTap()
        refreshSugarConfirmAppearance()
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
        SugartextView.layer.cornerRadius = 12
        SugartextView.clipsToBounds = true
        SugartextView.font = .systemFont(ofSize: 14, weight: .regular)
        SugartextView.textColor = UIColor(red: 0.18, green: 0.14, blue: 0.16, alpha: 1)
        SugartextView.textContainerInset = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "S&aiyy eS.o~mveJtjhii@ntgN".wevVPastryCrumbBloomRestored
        placeholderLabel.font = .systemFont(ofSize: 14, weight: .regular)
        placeholderLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        SugartextView.addSubview(placeholderLabel)
    }

    private func tuneSugarConfirmButton() {
        glazeConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        glazeConfirmButton.setTitle("CeovnmfeiMrvmV".wevVPastryCrumbBloomRestored, for: .normal)
        glazeConfirmButton.setTitleColor(.white, for: .normal)
        glazeConfirmButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        glazeConfirmButton.backgroundColor = .clear
        glazeConfirmButton.layer.cornerRadius = 32
        glazeConfirmButton.clipsToBounds = true
        glazeConfirmButton.layer.insertSublayer(glazeConfirmSheen, at: 0)
        glazeConfirmButton.addTarget(self, action: #selector(confirmSugarMoment), for: .touchUpInside)
    }

    private func placeSugarCanvasViews(doughBackButton: UIButton, glazeTitleLabel: UILabel, imageRow: UIStackView, contentLabel: UILabel) {
        [doughBackButton, glazeTitleLabel, imageRow, contentLabel, SugartextView].forEach {
            SugarcontentView.addSubview($0)
        }
        view.addSubview(glazeConfirmButton)
    }

    private func pinSugarCanvasLayout(doughBackButton: UIButton, glazeTitleLabel: UILabel, imageRow: UIStackView, contentLabel: UILabel) {
        glazeConfirmBottomConstraint = glazeConfirmButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        )
        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: SugarcontentView.leadingAnchor, constant: 3),
            doughBackButton.topAnchor.constraint(equalTo: SugarcontentView.safeAreaLayoutGuide.topAnchor, constant: 3),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            glazeTitleLabel.centerXAnchor.constraint(equalTo: SugarcontentView.centerXAnchor),
            glazeTitleLabel.topAnchor.constraint(equalTo: SugarcontentView.safeAreaLayoutGuide.topAnchor, constant: 6),
            glazeTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            glazeTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 18),
            imageRow.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 19),
            imageRow.leadingAnchor.constraint(equalTo: SugarcontentView.leadingAnchor, constant: 15),
            imageRow.trailingAnchor.constraint(equalTo: SugarcontentView.trailingAnchor, constant: -15),
            imageRow.heightAnchor.constraint(equalToConstant: 86),
            contentLabel.topAnchor.constraint(equalTo: imageRow.bottomAnchor, constant: 21),
            contentLabel.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 25),
            SugartextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 9),
            SugartextView.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            SugartextView.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            SugartextView.heightAnchor.constraint(equalToConstant: 191),
            placeholderLabel.topAnchor.constraint(equalTo: SugartextView.topAnchor, constant: 18),
            placeholderLabel.leadingAnchor.constraint(equalTo: SugartextView.leadingAnchor, constant: 25),
            glazeConfirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            glazeConfirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            glazeConfirmButton.heightAnchor.constraint(equalToConstant: 64),
            glazeConfirmBottomConstraint!
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
        tile.backgroundColor = .clear
        tile.layer.cornerRadius = 14
        tile.clipsToBounds = true
        tile.addTarget(self, action: #selector(chooseSugarImage(_:)), for: .touchUpInside)

        let sugarImageView = UIImageView()
        sugarImageView.translatesAutoresizingMaskIntoConstraints = false
        sugarImageView.tag = 99
        sugarImageView.contentMode = .scaleAspectFill
        sugarImageView.clipsToBounds = true

        let camera = UIImageView(image: UIImage(named: "wevv_post_sugar_photo_placeholder"))
        camera.translatesAutoresizingMaskIntoConstraints = false
        camera.tag = 100
        camera.contentMode = .scaleToFill

        let sugarRemoveButton = UIButton(type: .custom)
        sugarRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        sugarRemoveButton.tag = 104
        sugarRemoveButton.setImage(UIImage(named: "wevv_post_sugar_remove"), for: .normal)
        sugarRemoveButton.isHidden = true
        sugarRemoveButton.accessibilityLabel = "Remove picture"
        sugarRemoveButton.addTarget(self, action: #selector(removeSugarPicture(_:)), for: .touchUpInside)

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

        placeSugarImageTile(tile: tile, sugarImageView: sugarImageView, camera: camera, sugarRemoveButton: sugarRemoveButton, sugarMask: sugarMask, sugarSpinner: sugarSpinner, sugarStatus: sugarStatus)
        pinSugarImageTile(tile: tile, sugarImageView: sugarImageView, camera: camera, sugarRemoveButton: sugarRemoveButton, sugarMask: sugarMask, sugarSpinner: sugarSpinner, sugarStatus: sugarStatus)
        return tile
    }

    private func placeSugarImageTile(tile: UIControl, sugarImageView: UIImageView, camera: UIImageView, sugarRemoveButton: UIButton, sugarMask: UIView, sugarSpinner: UIActivityIndicatorView, sugarStatus: UILabel) {
        [camera, sugarImageView, sugarMask, sugarSpinner, sugarStatus, sugarRemoveButton].forEach {
            tile.addSubview($0)
        }
    }

    private func pinSugarImageTile(tile: UIControl, sugarImageView: UIImageView, camera: UIImageView, sugarRemoveButton: UIButton, sugarMask: UIView, sugarSpinner: UIActivityIndicatorView, sugarStatus: UILabel) {
        NSLayoutConstraint.activate([
            camera.topAnchor.constraint(equalTo: tile.topAnchor),
            camera.leadingAnchor.constraint(equalTo: tile.leadingAnchor),
            camera.trailingAnchor.constraint(equalTo: tile.trailingAnchor),
            camera.bottomAnchor.constraint(equalTo: tile.bottomAnchor),
            sugarImageView.topAnchor.constraint(equalTo: tile.topAnchor),
            sugarImageView.leadingAnchor.constraint(equalTo: tile.leadingAnchor),
            sugarImageView.trailingAnchor.constraint(equalTo: tile.trailingAnchor),
            sugarImageView.bottomAnchor.constraint(equalTo: tile.bottomAnchor),
            sugarRemoveButton.topAnchor.constraint(equalTo: tile.topAnchor, constant: 4),
            sugarRemoveButton.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -4),
            sugarRemoveButton.widthAnchor.constraint(equalToConstant: 20),
            sugarRemoveButton.heightAnchor.constraint(equalToConstant: 20),
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

    @objc private func removeSugarPicture(_ sender: UIButton) {
        guard let tile = sender.superview as? UIControl else { return }
        clearSugarPictureTile(tile)
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
        let sugarRemoveButton = tile.viewWithTag(104)
        let sugarMask = tile.viewWithTag(101)
        let sugarSpinner = tile.viewWithTag(102) as? UIActivityIndicatorView
        let sugarStatus = tile.viewWithTag(103)
        camera?.isHidden = true
        sugarRemoveButton?.isHidden = true
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
        let sugarRemoveButton = tile.viewWithTag(104)
        let sugarMask = tile.viewWithTag(101)
        let sugarSpinner = tile.viewWithTag(102) as? UIActivityIndicatorView
        let sugarStatus = tile.viewWithTag(103)
        sugarImageView?.image = glazeImage
        camera?.isHidden = true
        sugarRemoveButton?.isHidden = false
        sugarMask?.isHidden = true
        sugarStatus?.isHidden = true
        sugarSpinner?.stopAnimating()
        tile.isUserInteractionEnabled = true
        tile.layer.borderWidth = 0
        refreshSugarConfirmAppearance()
        showSugarHint("PDi,c@tVusrbej %aLdqdaeDd!".wevVPastryCrumbBloomRestored)
    }

    private func clearSugarPictureTile(_ tile: UIControl) {
        let slotIndex = max(0, min(tile.tag, chosenAssetSlots.count - 1))
        chosenAssetSlots[slotIndex] = nil
        chosenImageData[slotIndex] = nil
        chosenAsset = chosenAssetSlots.compactMap { $0 }.first
        let sugarImageView = tile.viewWithTag(99) as? UIImageView
        let camera = tile.viewWithTag(100)
        let sugarRemoveButton = tile.viewWithTag(104)
        sugarImageView?.image = nil
        camera?.isHidden = false
        sugarRemoveButton?.isHidden = true
        tile.layer.borderWidth = 0
        refreshSugarConfirmAppearance()
        showSugarHint("PJi^cNtZucrReJ Hrae,mkouvMeHdw".wevVPastryCrumbBloomRestored)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let pickedImage, let tile = activeSugarPictureTile else {
            picker.dismiss(animated: true)
            showSugarHint("PMiAcptWu;rXeG KcMo%urlSdj JnFovtv gbkeT nu.s^erd/".wevVPastryCrumbBloomRestored)
            return
        }
        guard let imageData = pickedImage.jpegData(compressionQuality: 0.86) else {
            picker.dismiss(animated: true)
            showSugarHint("PQiWcSt~uprOeQ gcSofunlxdk tnlojt? Hbbey qsUaEvAeMd,".wevVPastryCrumbBloomRestored)
            return
        }
        let slotIndex = max(0, min(tile.tag, chosenImageData.count - 1))
        chosenImageData[slotIndex] = imageData
        picker.dismiss(animated: true) { [weak self, weak tile] in
            guard let self, let tile else { return }
            self.beginSugarPictureUpload(tile: tile, assetName: UUID().uuidString, glazeImage: pickedImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        activeSugarPictureTile = nil
        picker.dismiss(animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        refreshSugarConfirmAppearance()
    }

    private func refreshSugarConfirmAppearance() {
        let hasSugarText = !SugartextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasSugarPicture = chosenImageData.contains { $0 != nil }
        let canPublish = hasSugarText && hasSugarPicture && publishTask == nil
        glazeConfirmButton.isEnabled = canPublish
        glazeConfirmButton.alpha = 1
        if canPublish {
            let activeGlaze = UIColor(red: 1, green: 75.0 / 255.0, blue: 169.0 / 255.0, alpha: 1).cgColor
            glazeConfirmSheen.colors = [activeGlaze, activeGlaze]
            glazeConfirmSheen.locations = [0, 1]
            glazeConfirmSheen.startPoint = CGPoint(x: 0, y: 0.5)
            glazeConfirmSheen.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            glazeConfirmSheen.colors = [
                UIColor(red: 1, green: 37.0 / 255.0, blue: 166.0 / 255.0, alpha: 0.54).cgColor,
                UIColor(red: 1, green: 64.0 / 255.0, blue: 230.0 / 255.0, alpha: 0.54).cgColor,
                UIColor(red: 1, green: 43.0 / 255.0, blue: 96.0 / 255.0, alpha: 0.54).cgColor
            ]
            glazeConfirmSheen.locations = [0, 0.52, 1]
            glazeConfirmSheen.startPoint = CGPoint(x: 0, y: 0.5)
            glazeConfirmSheen.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }

    @objc private func confirmSugarMoment() {
        guard glazeSession.isTasterReady else {
            showSugarHint("P&lreqa*sjeO msSihg~nQ BiJnT SfiinrDsMtc".wevVPastryCrumbBloomRestored)
            return
        }
        let imageData = chosenImageData.compactMap { $0 }
        guard !imageData.isEmpty else {
            showSugarHint("CUhoovoQsXe, qaJ MdGodn#uJtR LpjixcCtQu.r%ed".wevVPastryCrumbBloomRestored)
            return
        }
        let sugarText = SugartextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sugarText.isEmpty else {
            showSugarHint("Szaeyt qsiohm,eWt+heiYnSgo ?s@wxele&tM".wevVPastryCrumbBloomRestored)
            return
        }
        guard publishTask == nil else { return }
        glazeConfirmButton.isEnabled = false
        glazeConfirmButton.alpha = 0.72
        WevvNertyuSugartastingCard.showSugarToast("Publishing post…")
        publishTask = Task { [weak self] in
            guard let self else { return }
            do {
                var uploadedURLs: [String] = []
                for (index, data) in imageData.enumerated() {
                    let url = try await WevVGlazeSocialRepository.pastryTrailDiary.boutiqueStudio(data, pastryCompendiumSeries: "wevv-moment-\(index + 1).jpg")
                    uploadedURLs.append(url)
                }
                _ = try await WevVGlazeSocialRepository.pastryTrailDiary.cornerBakery(caramelCurd: sugarText, passionfruitFilling: uploadedURLs)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    WevvNertyuSugartastingCard.clearSugarCrumbs()
                    self.publishTask = nil
                    self.onSugarMomentReady?()
                    self.dismiss(animated: true)
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    WevvNertyuSugartastingCard.clearSugarCrumbs()
                    self.publishTask = nil
                    self.refreshSugarConfirmAppearance()
                    self.showSugarHint(error.localizedDescription)
                }
            }
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
        let keyboardFrame = view.convert(frame, from: nil)
        let bottomLift = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)
        glazeConfirmBottomConstraint?.constant = -(20 + bottomLift)
        SugarscrollView.contentInset.bottom = bottomLift + 36
        SugarscrollView.verticalScrollIndicatorInsets.bottom = bottomLift + 36
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc private func dropSugarCanvas(_ note: Notification) {
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        glazeConfirmBottomConstraint?.constant = -20
        SugarscrollView.contentInset.bottom = 0
        SugarscrollView.verticalScrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    private func showSugarHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }
}
