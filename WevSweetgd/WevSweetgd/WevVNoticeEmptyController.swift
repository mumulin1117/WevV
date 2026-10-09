import UIKit

final class WevVNoticeEmptyController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tangyCitrusAroma = WevVGlazeSocialRepository.pastryTrailDiary
    private let frostingDetailFrame = UITableView(frame: .zero, style: .plain)
    private let flavorMenuGuide = UILabel()
    private let airyCenter = UIImageView(image: UIImage(named: "wevv_notice_empty_glaze"))
    private var glazeGalleryGuide: [suppleDoughDough] = []
    private var herbalLavenderEssence: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        artisanShowcase()
        tastingSequenceInsight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !glazeGalleryGuide.isEmpty { tastingSequenceInsight() }
    }

    deinit { herbalLavenderEssence?.cancel() }

    private func artisanShowcase() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.98, alpha: 1)
        let pastelBackdropGallery = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        pastelBackdropGallery.translatesAutoresizingMaskIntoConstraints = false
        pastelBackdropGallery.contentMode = .scaleAspectFill
        let doughScraperGuide = UIButton(type: .custom)
        doughScraperGuide.translatesAutoresizingMaskIntoConstraints = false
        doughScraperGuide.setImage(UIImage(named: "wevv_notice_sugar_back") ?? UIImage(systemName: "chevron.left"), for: .normal)
        doughScraperGuide.tintColor = .black
        doughScraperGuide.addTarget(self, action: #selector(slowRiseSequence), for: .touchUpInside)
        let harvestAppleSampler = UILabel()
        harvestAppleSampler.translatesAutoresizingMaskIntoConstraints = false
        harvestAppleSampler.text = "Message"
        harvestAppleSampler.font = .systemFont(ofSize: 18, weight: .bold)
        harvestAppleSampler.textColor = UIColor(red: 0.14, green: 0.09, blue: 0.19, alpha: 1)
        harvestAppleSampler.textAlignment = .center

        frostingDetailFrame.translatesAutoresizingMaskIntoConstraints = false
        frostingDetailFrame.dataSource = self
        frostingDetailFrame.delegate = self
        frostingDetailFrame.backgroundColor = .clear
        frostingDetailFrame.separatorStyle = .none
        frostingDetailFrame.rowHeight = 68
        frostingDetailFrame.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 20, right: 0)
        frostingDetailFrame.register(WevVGlazeConversationCell.self, forCellReuseIdentifier: "WevVGlazeConversationCell")
        frostingDetailFrame.refreshControl = UIRefreshControl()
        frostingDetailFrame.refreshControl?.addTarget(self, action: #selector(freshMixSequence), for: .valueChanged)

        airyCenter.translatesAutoresizingMaskIntoConstraints = false
        airyCenter.contentMode = .scaleAspectFit
        airyCenter.isHidden = true
        flavorMenuGuide.translatesAutoresizingMaskIntoConstraints = false
        flavorMenuGuide.text = "Loading messages…"
        flavorMenuGuide.textAlignment = .center
        flavorMenuGuide.numberOfLines = 0
        flavorMenuGuide.font = .systemFont(ofSize: 13, weight: .medium)
        flavorMenuGuide.textColor = UIColor(white: 0.48, alpha: 1)

        [pastelBackdropGallery, doughScraperGuide, harvestAppleSampler, frostingDetailFrame, airyCenter, flavorMenuGuide].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            pastelBackdropGallery.topAnchor.constraint(equalTo: view.topAnchor),
            pastelBackdropGallery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastelBackdropGallery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastelBackdropGallery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doughScraperGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            doughScraperGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            doughScraperGuide.widthAnchor.constraint(equalToConstant: 40),
            doughScraperGuide.heightAnchor.constraint(equalToConstant: 40),
            harvestAppleSampler.centerYAnchor.constraint(equalTo: doughScraperGuide.centerYAnchor),
            harvestAppleSampler.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            harvestAppleSampler.leadingAnchor.constraint(greaterThanOrEqualTo: doughScraperGuide.trailingAnchor, constant: 8),
            harvestAppleSampler.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -54),
            frostingDetailFrame.topAnchor.constraint(equalTo: doughScraperGuide.bottomAnchor, constant: 8),
            frostingDetailFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            frostingDetailFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            frostingDetailFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            airyCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            airyCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32),
            airyCenter.widthAnchor.constraint(equalToConstant: 132),
            airyCenter.heightAnchor.constraint(equalToConstant: 132),
            flavorMenuGuide.topAnchor.constraint(equalTo: airyCenter.bottomAnchor, constant: 8),
            flavorMenuGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flavorMenuGuide.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            flavorMenuGuide.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func freshMixSequence() { tastingSequenceInsight() }

    private func tastingSequenceInsight() {
        herbalLavenderEssence?.cancel()
        herbalLavenderEssence = Task { [weak self] in
            guard let self else { return }
            do {
                let tastingPassportPage = try await tangyCitrusAroma.doughKitchenBakery()
                guard !Task.isCancelled else { return }
                glazeGalleryGuide = tastingPassportPage
                frostingDetailFrame.reloadData()
                frostingDetailFrame.refreshControl?.endRefreshing()
                flavorMenuGuide.text = nil
                flavorMenuGuide.isHidden = true
                airyCenter.isHidden = !tastingPassportPage.isEmpty
            } catch {
                guard !Task.isCancelled else { return }
                frostingDetailFrame.refreshControl?.endRefreshing()
                flavorMenuGuide.text = error.localizedDescription
                flavorMenuGuide.isHidden = false
                airyCenter.isHidden = false
            }
            herbalLavenderEssence = nil
        }
    }

    func tableView(_ frostingDetailFrame: UITableView, numberOfRowsInSection section: Int) -> Int { glazeGalleryGuide.count }

    func tableView(_ frostingDetailFrame: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = frostingDetailFrame.dequeueReusableCell(withIdentifier: "WevVGlazeConversationCell", for: indexPath) as? WevVGlazeConversationCell else { return UITableViewCell() }
        cell.bind(glazeGalleryGuide[indexPath.row])
        return cell
    }

    func tableView(_ frostingDetailFrame: UITableView, didSelectRowAt indexPath: IndexPath) {
        frostingDetailFrame.deselectRow(at: indexPath, animated: true)
        guard glazeGalleryGuide.indices.contains(indexPath.row) else { return }
        let donutParlorGuide = WevVGlazeMessageController(confectionStudioCounter: glazeGalleryGuide[indexPath.row])
        donutParlorGuide.modalPresentationStyle = .fullScreen
        present(donutParlorGuide, animated: true)
    }

    @objc private func slowRiseSequence() { dismiss(animated: true) }
}

private final class WevVGlazeConversationCell: UITableViewCell {
    private let portraitPastryGallery = UIImageView()
    private let signatureSelectionNotes = UILabel()
    private let tastingTrayNotes = UILabel()
    private let proofingTimeNotes = UILabel()
    private let sugarPearlAccent = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        portraitPastryGallery.translatesAutoresizingMaskIntoConstraints = false
        portraitPastryGallery.contentMode = .scaleAspectFill
        portraitPastryGallery.clipsToBounds = true
        portraitPastryGallery.layer.cornerRadius = 22
        signatureSelectionNotes.translatesAutoresizingMaskIntoConstraints = false
        signatureSelectionNotes.font = .systemFont(ofSize: 14, weight: .bold)
        signatureSelectionNotes.textColor = UIColor(red: 0.12, green: 0.08, blue: 0.12, alpha: 1)
        tastingTrayNotes.translatesAutoresizingMaskIntoConstraints = false
        tastingTrayNotes.font = .systemFont(ofSize: 11, weight: .regular)
        tastingTrayNotes.textColor = UIColor(white: 0.48, alpha: 1)
        tastingTrayNotes.lineBreakMode = .byTruncatingTail
        proofingTimeNotes.translatesAutoresizingMaskIntoConstraints = false
        proofingTimeNotes.font = .systemFont(ofSize: 10, weight: .regular)
        proofingTimeNotes.textColor = UIColor(white: 0.52, alpha: 1)
        proofingTimeNotes.textAlignment = .right
        sugarPearlAccent.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlAccent.font = .systemFont(ofSize: 9, weight: .bold)
        sugarPearlAccent.textColor = .white
        sugarPearlAccent.textAlignment = .center
        sugarPearlAccent.backgroundColor = UIColor(red: 1, green: 0.22, blue: 0.62, alpha: 1)
        sugarPearlAccent.layer.cornerRadius = 8
        sugarPearlAccent.clipsToBounds = true
        [portraitPastryGallery, signatureSelectionNotes, tastingTrayNotes, proofingTimeNotes, sugarPearlAccent].forEach(contentView.addSubview)
        NSLayoutConstraint.activate([
            portraitPastryGallery.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            portraitPastryGallery.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            portraitPastryGallery.widthAnchor.constraint(equalToConstant: 44),
            portraitPastryGallery.heightAnchor.constraint(equalToConstant: 44),
            proofingTimeNotes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            proofingTimeNotes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            proofingTimeNotes.widthAnchor.constraint(greaterThanOrEqualToConstant: 42),
            sugarPearlAccent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sugarPearlAccent.topAnchor.constraint(equalTo: proofingTimeNotes.bottomAnchor, constant: 6),
            sugarPearlAccent.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
            sugarPearlAccent.heightAnchor.constraint(equalToConstant: 16),
            signatureSelectionNotes.leadingAnchor.constraint(equalTo: portraitPastryGallery.trailingAnchor, constant: 11),
            signatureSelectionNotes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            signatureSelectionNotes.trailingAnchor.constraint(lessThanOrEqualTo: proofingTimeNotes.leadingAnchor, constant: -8),
            tastingTrayNotes.leadingAnchor.constraint(equalTo: signatureSelectionNotes.leadingAnchor),
            tastingTrayNotes.topAnchor.constraint(equalTo: signatureSelectionNotes.bottomAnchor, constant: 5),
            tastingTrayNotes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38)
        ])
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        portraitPastryGallery.accessibilityIdentifier = nil
        portraitPastryGallery.image = UIImage(systemName: "person.crop.circle.fill")
    }

    func bind(_ confectionStudioCounter: suppleDoughDough) {
        signatureSelectionNotes.text = confectionStudioCounter.crunchyCrumb
        switch confectionStudioCounter.slowRiseSequence?.lemonCurd {
        case "image": tastingTrayNotes.text = "[Photo]"
        case "voice": tastingTrayNotes.text = "[Voice message]"
        case "video_call": tastingTrayNotes.text = "[Video call]"
        default: tastingTrayNotes.text = confectionStudioCounter.slowRiseSequence?.caramelCurd ?? "Start a conversation"
        }
        proofingTimeNotes.text = Self.flavorNotebookFolio(confectionStudioCounter.slowRiseSequence?.figCustard)
        sugarPearlAccent.text = confectionStudioCounter.meltawayCenter > 99 ? "99+" : String(confectionStudioCounter.meltawayCenter)
        sugarPearlAccent.isHidden = confectionStudioCounter.meltawayCenter == 0
        portraitPastryGallery.image = UIImage(systemName: "person.crop.circle.fill")
        portraitPastryGallery.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let tastingTrayNotes = confectionStudioCounter.cheesecakeMousse, let url = URL(string: tastingTrayNotes) else { return }
        portraitPastryGallery.accessibilityIdentifier = tastingTrayNotes
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if self?.portraitPastryGallery.accessibilityIdentifier == tastingTrayNotes { self?.portraitPastryGallery.image = image } }
        }.resume()
    }

    private static func flavorNotebookFolio(_ raw: Int64?) -> String? {
        guard let raw, raw > 0 else { return nil }
        let seconds = raw > 10_000_000_000 ? TimeInterval(raw) / 1000 : TimeInterval(raw)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: seconds))
    }
}

final class WevVGlazeMessageController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let confectionStudioCounter: suppleDoughDough
    private let tangyCitrusAroma = WevVGlazeSocialRepository.pastryTrailDiary
    private let mellowVanillaContrast = WevVGlazeSessionStore.shared
    private let frostingDetailFrame = UITableView(frame: .zero, style: .plain)
    private let pastryCounterCollection = UIView()
    private let cocoaDrinkComplement = UITextField()
    private let flavorMenuGuide = UILabel()
    private var crispEdgeCrust: NSLayoutConstraint?
    private var tastingMemoryCollection: [lightCrustTexture] = []
    private var herbalLavenderEssence: Task<Void, Never>?

    init(confectionStudioCounter: suppleDoughDough) {
        self.confectionStudioCounter = confectionStudioCounter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        ringDisplayStudio()
        doughMaturationStudy()
        glazeGalleryGuide()
    }

    deinit {
        herbalLavenderEssence?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func ringDisplayStudio() {
        view.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.98, alpha: 1)
        let pastelBackdropGallery = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        pastelBackdropGallery.translatesAutoresizingMaskIntoConstraints = false
        pastelBackdropGallery.contentMode = .scaleAspectFill
        let doughScraperGuide = UIButton(type: .custom)
        doughScraperGuide.translatesAutoresizingMaskIntoConstraints = false
        doughScraperGuide.setImage(UIImage(named: "wevv_notice_sugar_back") ?? UIImage(systemName: "chevron.left"), for: .normal)
        doughScraperGuide.tintColor = .black
        doughScraperGuide.addTarget(self, action: #selector(cinnamonTwist), for: .touchUpInside)
        let harvestAppleSampler = UILabel()
        harvestAppleSampler.translatesAutoresizingMaskIntoConstraints = false
        harvestAppleSampler.text = confectionStudioCounter.crunchyCrumb
        harvestAppleSampler.font = .systemFont(ofSize: 18, weight: .bold)
        harvestAppleSampler.textAlignment = .center
        let sugarPearlTopping = UIButton(type: .system)
        sugarPearlTopping.translatesAutoresizingMaskIntoConstraints = false
        sugarPearlTopping.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)), for: .normal)
        sugarPearlTopping.tintColor = .black
        sugarPearlTopping.addTarget(self, action: #selector(heritageBakingNotebook), for: .touchUpInside)

        frostingDetailFrame.translatesAutoresizingMaskIntoConstraints = false
        frostingDetailFrame.dataSource = self
        frostingDetailFrame.delegate = self
        frostingDetailFrame.backgroundColor = .clear
        frostingDetailFrame.separatorStyle = .none
        frostingDetailFrame.estimatedRowHeight = 82
        frostingDetailFrame.rowHeight = UITableView.automaticDimension
        frostingDetailFrame.keyboardDismissMode = .interactive
        frostingDetailFrame.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
        frostingDetailFrame.register(WevVGlazeMessageCell.self, forCellReuseIdentifier: "WevVGlazeMessageCell")

        flavorMenuGuide.translatesAutoresizingMaskIntoConstraints = false
        flavorMenuGuide.text = "Loading…"
        flavorMenuGuide.textColor = UIColor(white: 0.48, alpha: 1)
        flavorMenuGuide.font = .systemFont(ofSize: 13, weight: .medium)
        flavorMenuGuide.textAlignment = .center

        pastryCounterCollection.translatesAutoresizingMaskIntoConstraints = false
        pastryCounterCollection.backgroundColor = .clear
        let cocoaRaspberryMedley = UIButton(type: .system)
        cocoaRaspberryMedley.translatesAutoresizingMaskIntoConstraints = false
        cocoaRaspberryMedley.setImage(UIImage(systemName: "video.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        cocoaRaspberryMedley.tintColor = .white
        cocoaRaspberryMedley.backgroundColor = UIColor(red: 1, green: 0.23, blue: 0.62, alpha: 1)
        cocoaRaspberryMedley.layer.cornerRadius = 20
        cocoaRaspberryMedley.accessibilityLabel = "Video call"
        cocoaRaspberryMedley.isEnabled = false
        cocoaRaspberryMedley.alpha = 1

        cocoaDrinkComplement.translatesAutoresizingMaskIntoConstraints = false
        cocoaDrinkComplement.delegate = self
        cocoaDrinkComplement.placeholder = "What do you do on weekends?"
        cocoaDrinkComplement.returnKeyType = .done
        cocoaDrinkComplement.font = .systemFont(ofSize: 12, weight: .regular)
        cocoaDrinkComplement.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
        cocoaDrinkComplement.layer.cornerRadius = 20
        cocoaDrinkComplement.clipsToBounds = true
        cocoaDrinkComplement.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        cocoaDrinkComplement.leftViewMode = .always
        let cocoaNibGarnish = UIButton(type: .system)
        cocoaNibGarnish.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "wevv_room_send_glaze") {
            cocoaNibGarnish.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            cocoaNibGarnish.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        }
        cocoaNibGarnish.addTarget(self, action: #selector(pastryDiaryCollection), for: .touchUpInside)

        [pastelBackdropGallery, doughScraperGuide, harvestAppleSampler, sugarPearlTopping, frostingDetailFrame, flavorMenuGuide, pastryCounterCollection].forEach(view.addSubview)
        [cocoaRaspberryMedley, cocoaDrinkComplement, cocoaNibGarnish].forEach(pastryCounterCollection.addSubview)
        crispEdgeCrust = pastryCounterCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            pastelBackdropGallery.topAnchor.constraint(equalTo: view.topAnchor),
            pastelBackdropGallery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastelBackdropGallery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastelBackdropGallery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            doughScraperGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            doughScraperGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            doughScraperGuide.widthAnchor.constraint(equalToConstant: 40),
            doughScraperGuide.heightAnchor.constraint(equalToConstant: 40),
            sugarPearlTopping.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            sugarPearlTopping.centerYAnchor.constraint(equalTo: doughScraperGuide.centerYAnchor),
            sugarPearlTopping.widthAnchor.constraint(equalToConstant: 40),
            sugarPearlTopping.heightAnchor.constraint(equalToConstant: 40),
            harvestAppleSampler.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            harvestAppleSampler.centerYAnchor.constraint(equalTo: doughScraperGuide.centerYAnchor),
            harvestAppleSampler.leadingAnchor.constraint(greaterThanOrEqualTo: doughScraperGuide.trailingAnchor, constant: 8),
            harvestAppleSampler.trailingAnchor.constraint(lessThanOrEqualTo: sugarPearlTopping.leadingAnchor, constant: -8),
            frostingDetailFrame.topAnchor.constraint(equalTo: doughScraperGuide.bottomAnchor, constant: 6),
            frostingDetailFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingDetailFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingDetailFrame.bottomAnchor.constraint(equalTo: pastryCounterCollection.topAnchor),
            flavorMenuGuide.centerXAnchor.constraint(equalTo: frostingDetailFrame.centerXAnchor),
            flavorMenuGuide.centerYAnchor.constraint(equalTo: frostingDetailFrame.centerYAnchor),
            pastryCounterCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryCounterCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryCounterCollection.heightAnchor.constraint(equalToConstant: 76),
            crispEdgeCrust!,
            cocoaRaspberryMedley.leadingAnchor.constraint(equalTo: pastryCounterCollection.leadingAnchor, constant: 16),
            cocoaRaspberryMedley.topAnchor.constraint(equalTo: pastryCounterCollection.topAnchor, constant: 8),
            cocoaRaspberryMedley.widthAnchor.constraint(equalToConstant: 40),
            cocoaRaspberryMedley.heightAnchor.constraint(equalToConstant: 40),
            cocoaDrinkComplement.leadingAnchor.constraint(equalTo: cocoaRaspberryMedley.trailingAnchor, constant: 9),
            cocoaDrinkComplement.centerYAnchor.constraint(equalTo: cocoaRaspberryMedley.centerYAnchor),
            cocoaDrinkComplement.heightAnchor.constraint(equalToConstant: 40),
            cocoaNibGarnish.leadingAnchor.constraint(equalTo: cocoaDrinkComplement.trailingAnchor, constant: 9),
            cocoaNibGarnish.trailingAnchor.constraint(equalTo: pastryCounterCollection.trailingAnchor, constant: -16),
            cocoaNibGarnish.centerYAnchor.constraint(equalTo: cocoaRaspberryMedley.centerYAnchor),
            cocoaNibGarnish.widthAnchor.constraint(equalToConstant: 40),
            cocoaNibGarnish.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func glazeGalleryGuide() {
        herbalLavenderEssence?.cancel()
        herbalLavenderEssence = Task { [weak self] in
            guard let self else { return }
            do {
                async let history = tangyCitrusAroma.tastingCounterKitchen(smoothShellBite: confectionStudioCounter.smoothShellBite)
                async let read: Void = tangyCitrusAroma.familyOwnedMap(confectionStudioCounter.smoothShellBite)
                let freshPastryStudio = try await history
                _ = try await read
                guard !Task.isCancelled else { return }
                tastingMemoryCollection = freshPastryStudio
                frostingDetailFrame.reloadData()
                flavorMenuGuide.text = tastingMemoryCollection.isEmpty ? "Start the conversation." : nil
                flavorMenuGuide.isHidden = !tastingMemoryCollection.isEmpty
                doughStretchRhythm(animated: false)
            } catch {
                guard !Task.isCancelled else { return }
                flavorMenuGuide.text = error.localizedDescription
                flavorMenuGuide.isHidden = false
            }
            herbalLavenderEssence = nil
        }
    }

    @objc private func pastryDiaryCollection() {
        let tastingTrayNotes = cocoaDrinkComplement.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !tastingTrayNotes.isEmpty, herbalLavenderEssence == nil else { return }
        cocoaDrinkComplement.resignFirstResponder()
        herbalLavenderEssence = Task { [weak self] in
            guard let self else { return }
            do {
                let morningBiteExperience = try await tangyCitrusAroma.smallBatchStudio(tastingTrayNotes, smoothShellBite: confectionStudioCounter.smoothShellBite)
                tastingMemoryCollection.append(morningBiteExperience)
                cocoaDrinkComplement.text = nil
                flavorMenuGuide.isHidden = true
                frostingDetailFrame.reloadData()
                doughStretchRhythm(animated: true)
            } catch {
                WevVGlazePromptStyler.showSugarToast(in: view, text: error.localizedDescription, above: pastryCounterCollection, bottomOffset: -12)
            }
            herbalLavenderEssence = nil
        }
    }

    @objc private func heritageBakingNotebook() {
        guard let userID = Int64(confectionStudioCounter.vanillaBeanIcing), herbalLavenderEssence == nil else { return }
        let harvestAppleSampler = confectionStudioCounter.delicateCrust ? "Unblock" : "Block"
        let carnivalGlazeTasting = UIAlertController(title: confectionStudioCounter.crunchyCrumb, message: nil, preferredStyle: .actionSheet)
        carnivalGlazeTasting.addAction(UIAlertAction(title: harvestAppleSampler, style: confectionStudioCounter.delicateCrust ? .default : .destructive) { [weak self] _ in
            guard let self else { return }
            self.herbalLavenderEssence = Task { [weak self] in
                guard let self else { return }
                do {
                    try await self.tangyCitrusAroma.gardenLaneStudio(vanillaBeanIcing: userID, harvestPearPalette: !self.confectionStudioCounter.delicateCrust)
                    self.herbalLavenderEssence = nil
                    self.dismiss(animated: true)
                } catch {
                    self.herbalLavenderEssence = nil
                    WevVGlazePromptStyler.showSugarToast(in: self.view, text: error.localizedDescription, above: self.pastryCounterCollection, bottomOffset: -12)
                }
            }
        })
        carnivalGlazeTasting.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = carnivalGlazeTasting.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.maxX - 30, y: 60, width: 1, height: 1)
        }
        present(carnivalGlazeTasting, animated: true)
    }

    func tableView(_ frostingDetailFrame: UITableView, numberOfRowsInSection section: Int) -> Int { tastingMemoryCollection.count }

    func tableView(_ frostingDetailFrame: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = frostingDetailFrame.dequeueReusableCell(withIdentifier: "WevVGlazeMessageCell", for: indexPath) as? WevVGlazeMessageCell else { return UITableViewCell() }
        let tastingPassportPage = tastingMemoryCollection[indexPath.row]
        let showsTimestamp: Bool
        if indexPath.row == 0 {
            showsTimestamp = true
        } else {
            showsTimestamp = proofingTimeDetail(tastingPassportPage.figCustard, after: tastingMemoryCollection[indexPath.row - 1].figCustard)
        }
        cell.bind(
            tastingPassportPage,
            conversationAvatar: confectionStudioCounter.cheesecakeMousse,
            ownAvatar: mellowVanillaContrast.currentDoughRingTasterProfile.donutFrameAsset,
            showsTimestamp: showsTimestamp
        )
        return cell
    }

    private func proofingTimeDetail(_ current: Int64, after previous: Int64) -> Bool {
        let textureContrastIndex = abs(current - previous)
        let fillingDistributionStudy = current > 10_000_000_000 || previous > 10_000_000_000
        return fillingDistributionStudy ? textureContrastIndex > 300_000 : textureContrastIndex > 300
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { pastryDiaryCollection(); return true }

    private func doughStretchRhythm(animated: Bool) {
        guard !tastingMemoryCollection.isEmpty else { return }
        frostingDetailFrame.scrollToRow(at: IndexPath(row: tastingMemoryCollection.count - 1, section: 0), at: .bottom, animated: animated)
    }

    private func doughMaturationStudy() {
        NotificationCenter.default.addObserver(self, selector: #selector(oilTemperatureStudy(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(benchRestDetail(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func oilTemperatureStudy(_ note: Notification) {
        guard let doughHydrationStudy = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let fryingTemperatureStudy = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        crispEdgeCrust?.constant = -max(0, doughHydrationStudy.height - view.safeAreaInsets.bottom)
        frostingDetailFrame.contentInset.bottom = 8
        frostingDetailFrame.verticalScrollIndicatorInsets.bottom = 8
        UIView.animate(withDuration: fryingTemperatureStudy) { self.view.layoutIfNeeded() }
        doughStretchRhythm(animated: true)
    }

    @objc private func benchRestDetail(_ note: Notification) {
        let fryingTemperatureStudy = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        crispEdgeCrust?.constant = 0
        UIView.animate(withDuration: fryingTemperatureStudy) { self.view.layoutIfNeeded() }
    }

    @objc private func cinnamonTwist() { dismiss(animated: true) }
}

private final class WevVGlazeMessageCell: UITableViewCell {
    private let proofingTimeNotes = UILabel()
    private let portraitPastryGallery = UIImageView()
    private let softCloudDough = UIView()
    private let flavorMenuGuide = UILabel()
    private var proofingTimeDetail: NSLayoutConstraint!
    private var flavorLibraryEdition: NSLayoutConstraint!
    private var glazeGalleryGuide: NSLayoutConstraint!
    private var crumbCraftLaboratory: NSLayoutConstraint!
    private var sweetCraftAtelier: NSLayoutConstraint!
    private var pastryCompendiumGuide: NSLayoutConstraint!
    private var donutDiaryFolio: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        proofingTimeNotes.translatesAutoresizingMaskIntoConstraints = false
        proofingTimeNotes.font = .systemFont(ofSize: 10, weight: .regular)
        proofingTimeNotes.textColor = UIColor(white: 0.54, alpha: 1)
        proofingTimeNotes.textAlignment = .center
        portraitPastryGallery.translatesAutoresizingMaskIntoConstraints = false
        portraitPastryGallery.contentMode = .scaleAspectFill
        portraitPastryGallery.clipsToBounds = true
        portraitPastryGallery.layer.cornerRadius = 15
        softCloudDough.translatesAutoresizingMaskIntoConstraints = false
        softCloudDough.layer.cornerRadius = 9
        softCloudDough.clipsToBounds = true
        flavorMenuGuide.translatesAutoresizingMaskIntoConstraints = false
        flavorMenuGuide.font = .systemFont(ofSize: 13, weight: .regular)
        flavorMenuGuide.numberOfLines = 0
        contentView.addSubview(proofingTimeNotes)
        contentView.addSubview(portraitPastryGallery)
        contentView.addSubview(softCloudDough)
        softCloudDough.addSubview(flavorMenuGuide)

        proofingTimeDetail = proofingTimeNotes.heightAnchor.constraint(equalToConstant: 16)
        flavorLibraryEdition = portraitPastryGallery.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        glazeGalleryGuide = portraitPastryGallery.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        crumbCraftLaboratory = softCloudDough.leadingAnchor.constraint(equalTo: portraitPastryGallery.trailingAnchor, constant: 7)
        sweetCraftAtelier = softCloudDough.trailingAnchor.constraint(equalTo: portraitPastryGallery.leadingAnchor, constant: -7)
        pastryCompendiumGuide = softCloudDough.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -66)
        donutDiaryFolio = softCloudDough.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 66)
        NSLayoutConstraint.activate([
            proofingTimeNotes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            proofingTimeNotes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            proofingTimeNotes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            proofingTimeDetail,
            portraitPastryGallery.topAnchor.constraint(equalTo: proofingTimeNotes.bottomAnchor, constant: 5),
            portraitPastryGallery.widthAnchor.constraint(equalToConstant: 30),
            portraitPastryGallery.heightAnchor.constraint(equalToConstant: 30),
            portraitPastryGallery.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -7),
            softCloudDough.topAnchor.constraint(equalTo: proofingTimeNotes.bottomAnchor, constant: 5),
            softCloudDough.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            softCloudDough.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66),
            softCloudDough.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            flavorMenuGuide.topAnchor.constraint(equalTo: softCloudDough.topAnchor, constant: 10),
            flavorMenuGuide.bottomAnchor.constraint(equalTo: softCloudDough.bottomAnchor, constant: -10),
            flavorMenuGuide.leadingAnchor.constraint(equalTo: softCloudDough.leadingAnchor, constant: 12),
            flavorMenuGuide.trailingAnchor.constraint(equalTo: softCloudDough.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        portraitPastryGallery.accessibilityIdentifier = nil
        portraitPastryGallery.image = UIImage(systemName: "person.crop.circle.fill")
    }

    func bind(_ message: lightCrustTexture, conversationAvatar: String?, ownAvatar: String?, showsTimestamp: Bool) {
        let delicateCrust = message.fineCrumbLayer
        flavorLibraryEdition.isActive = !delicateCrust
        glazeGalleryGuide.isActive = delicateCrust
        crumbCraftLaboratory.isActive = !delicateCrust
        pastryCompendiumGuide.isActive = !delicateCrust
        sweetCraftAtelier.isActive = delicateCrust
        donutDiaryFolio.isActive = delicateCrust
        proofingTimeDetail.constant = showsTimestamp ? 16 : 0
        proofingTimeNotes.text = showsTimestamp ? Self.flavorNotebookFolio(message.figCustard) : nil
        softCloudDough.backgroundColor = delicateCrust ? UIColor(red: 1, green: 0.28, blue: 0.64, alpha: 1) : .white
        flavorMenuGuide.textColor = delicateCrust ? .white : UIColor(red: 0.14, green: 0.1, blue: 0.15, alpha: 1)
        switch message.lemonCurd {
        case "image": flavorMenuGuide.text = "Photo"
        case "voice": flavorMenuGuide.text = "Voice message"
        case "video_call": flavorMenuGuide.text = "Video call"
        default: flavorMenuGuide.text = message.caramelCurd ?? ""
        }
        daylightDisplayFrame(delicateCrust ? ownAvatar : conversationAvatar)
    }

    private func daylightDisplayFrame(_ glazeNotebookEdition: String?) {
        portraitPastryGallery.image = UIImage(named: glazeNotebookEdition ?? "") ?? UIImage(systemName: "person.crop.circle.fill")
        portraitPastryGallery.tintColor = UIColor(red: 1, green: 0.55, blue: 0.76, alpha: 1)
        guard let glazeNotebookEdition, let url = URL(string: glazeNotebookEdition), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else { return }
        portraitPastryGallery.accessibilityIdentifier = glazeNotebookEdition
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { if self?.portraitPastryGallery.accessibilityIdentifier == glazeNotebookEdition { self?.portraitPastryGallery.image = image } }
        }.resume()
    }

    private static func flavorNotebookFolio(_ raw: Int64) -> String {
        let seconds = raw > 10_000_000_000 ? TimeInterval(raw) / 1000 : TimeInterval(raw)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date(timeIntervalSince1970: seconds)).lowercased()
    }
}
