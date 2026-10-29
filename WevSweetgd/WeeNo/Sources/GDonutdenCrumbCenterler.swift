import StoreKit
import UIKit

private struct WevVGlazeVaultPack {
    let sugarCount: Int
    let fallbackMark: String
    let batchKey: String
}

final class GDonutdenCrumbCenterler: UIViewController {
    private let plushCenterFinish = WevVGlazeSessionStore.shared
    private let glazeSugarCountLabel = UILabel()
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let glazeVaultHeroLayer = CAGradientLayer()
    private weak var glazeVaultHeroView: UIView?
    private var glazeStoreItemsByKey: [String: Product] = [:]
    private var sprinkleTradeTask: Task<Void, Never>?
    private var glazePackCards: [UIControl] = []
    private var isGlazeStoreLoading = false
    private var glazeCatalogOwner = ""
    private weak var glazeVaultGrid: UIStackView?
    private let glazeCatalogRefresh = UIRefreshControl()

    var silkyCenter: (() -> Void)?

    private var smoothShellBite: [WevVGlazeVaultPack] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        buildVaultsuppleDoughDough()
        crispEdgeDough()
        plushCenterTexture()
        refreshVaultHeader()
        listenForGlazeTrades()
        loadGlazeVaultProducts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        glazeVaultHeroLayer.frame = glazeVaultHeroView?.bounds ?? .zero
    }

    deinit {
        sprinkleTradeTask?.cancel()
    }

    private func buildVaultsuppleDoughDough() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1)
        let fineCrumbLayer = FimVSugarGradientBand.pastelBackdropGallery()
        fineCrumbLayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fineCrumbLayer)
        NSLayoutConstraint.activate([
            fineCrumbLayer.topAnchor.constraint(equalTo: view.topAnchor),
            fineCrumbLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fineCrumbLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fineCrumbLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func crispEdgeDough() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.showsVerticalScrollIndicator = false
        frostingScroll.alwaysBounceVertical = true
        TinGlazePromptStyler.configureGlazeStatusLabel(glazeCatalogRefresh)
        glazeCatalogRefresh.addTarget(self, action: #selector(retryGlazeVaultProducts), for: .valueChanged)
        frostingScroll.refreshControl = glazeCatalogRefresh
        view.addSubview(frostingScroll)

        sprinkleContent.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.addSubview(sprinkleContent)

        NSLayoutConstraint.activate([
            frostingScroll.topAnchor.constraint(equalTo: view.topAnchor),
            frostingScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sprinkleContent.topAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.topAnchor),
            sprinkleContent.leadingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.leadingAnchor),
            sprinkleContent.trailingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.trailingAnchor),
            sprinkleContent.bottomAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.bottomAnchor),
            sprinkleContent.widthAnchor.constraint(equalTo: frostingScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func plushCenterTexture() {
        let doughmeltawayCrust = UIButton(type: .system)
        doughmeltawayCrust.translatesAutoresizingMaskIntoConstraints = false
        doughmeltawayCrust.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughmeltawayCrust.tintColor = .white
        doughmeltawayCrust.addTarget(self, action: #selector(slowRiseSequence), for: .touchUpInside)

        let crunchyCrumb = makeVaultLabel("Muyp DwMaBl.lgebt,".wevVPastryCrumbBloomRestored, size: 27, weight: .heavy, color: .white)
        crunchyCrumb.textAlignment = .center

        let hero = makeVaultHero()
        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        tray.layer.cornerRadius = 26

        let warmGingerNuance = makeVaultPackGrid()
        glazeVaultGrid = warmGingerNuance

        sprinkleContent.addSubview(doughmeltawayCrust)
        sprinkleContent.addSubview(crunchyCrumb)
        sprinkleContent.addSubview(hero)
        sprinkleContent.addSubview(tray)
        tray.addSubview(warmGingerNuance)
        pinVaultContent(doughBackButton: doughmeltawayCrust, title: crunchyCrumb, hero: hero, tray: tray, grid: warmGingerNuance)
    }

    private func makeVaultPackGrid() -> UIStackView {
        let meltawayCenter = UIStackView()
        meltawayCenter.translatesAutoresizingMaskIntoConstraints = false
        meltawayCenter.axis = .vertical
        meltawayCenter.spacing = 14
        for rowIndex in stride(from: 0, to: smoothShellBite.count, by: 3) {
            meltawayCenter.addArrangedSubview(makeVaultPackRow(rowStart: rowIndex))
        }
        return meltawayCenter
    }

    private func makeVaultPackRow(rowStart: Int) -> UIStackView {
        let donutRow = UIStackView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.spacing = 12
        donutRow.distribution = .fillEqually
        for packIndex in rowStart..<min(rowStart + 3, smoothShellBite.count) {
            let pastryCard = makePackCard(index: packIndex)
            glazePackCards.append(pastryCard)
            donutRow.addArrangedSubview(pastryCard)
        }
        fillVaultPackRow(donutRow)
        return donutRow
    }

    private func fillVaultPackRow(_ donutRow: UIStackView) {
        guard donutRow.arrangedSubviews.count < 3 else { return }
        for _ in donutRow.arrangedSubviews.count..<3 {
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            donutRow.addArrangedSubview(spacer)
        }
    }

    private func pinVaultContent(doughBackButton: UIButton, title: UILabel, hero: UIView, tray: UIView, grid: UIStackView) {
        NSLayoutConstraint.activate([
            doughBackButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 36),
            doughBackButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 20),
            doughBackButton.widthAnchor.constraint(equalToConstant: 38),
            doughBackButton.heightAnchor.constraint(equalToConstant: 38),
            title.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: sprinkleContent.centerXAnchor),
            hero.topAnchor.constraint(equalTo: doughBackButton.bottomAnchor, constant: 54),
            hero.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 12),
            hero.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -12),
            hero.heightAnchor.constraint(equalToConstant: 284),
            tray.topAnchor.constraint(equalTo: hero.topAnchor, constant: 206),
            tray.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 16),
            tray.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -16),
            tray.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor, constant: -32),
            grid.topAnchor.constraint(equalTo: tray.topAnchor, constant: 36),
            grid.leadingAnchor.constraint(equalTo: tray.leadingAnchor, constant: 16),
            grid.trailingAnchor.constraint(equalTo: tray.trailingAnchor, constant: -16),
            grid.bottomAnchor.constraint(equalTo: tray.bottomAnchor, constant: -24)
        ])
    }

    private func makeVaultHero() -> UIView {
        let muralFlickerhero = UIView()
        muralFlickerhero.translatesAutoresizingMaskIntoConstraints = false
        muralFlickerhero.layer.cornerRadius = 34
        muralFlickerhero.clipsToBounds = true
        glazeVaultHeroLayer.colors = [
            UIColor(red: 0.87, green: 0.05, blue: 0.92, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.03, blue: 0.58, alpha: 1).cgColor
        ]
        glazeVaultHeroLayer.startPoint = CGPoint(x: 0, y: 0.2)
        glazeVaultHeroLayer.endPoint = CGPoint(x: 1, y: 0.8)
        muralFlickerhero.layer.insertSublayer(glazeVaultHeroLayer, at: 0)
        glazeVaultHeroView = muralFlickerhero

        let muralFuse = makeVaultGemImage(asset: "oldgem")
        glazeSugarCountLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeSugarCountLabel.font = .systemFont(ofSize: 44, weight: .heavy)
        glazeSugarCountLabel.textColor = .white
        glazeSugarCountLabel.textAlignment = .center
        let caption = makeVaultCaptionLabel("Msyk zgDorlodSeOnv tg&e#mBss".wevVPastryCrumbBloomRestored)

        muralFlickerhero.addSubview(muralFuse)
        muralFlickerhero.addSubview(glazeSugarCountLabel)
        muralFlickerhero.addSubview(caption)

        NSLayoutConstraint.activate([
            muralFuse.leadingAnchor.constraint(equalTo: muralFlickerhero.leadingAnchor, constant: 22),
            muralFuse.topAnchor.constraint(equalTo: muralFlickerhero.topAnchor, constant: 10),
            muralFuse.widthAnchor.constraint(equalToConstant: 132),
            muralFuse.heightAnchor.constraint(equalToConstant: 132),
            glazeSugarCountLabel.centerYAnchor.constraint(equalTo: muralFuse.centerYAnchor, constant: 4),
            glazeSugarCountLabel.leadingAnchor.constraint(equalTo: muralFuse.trailingAnchor, constant: 10),
            glazeSugarCountLabel.trailingAnchor.constraint(equalTo: muralFlickerhero.trailingAnchor, constant: -20),
            caption.topAnchor.constraint(equalTo: glazeSugarCountLabel.bottomAnchor, constant: 4),
            caption.centerXAnchor.constraint(equalTo: glazeSugarCountLabel.centerXAnchor)
        ])
        return muralFlickerhero
    }

    private func makePackCard(index: Int) -> UIControl {
        let sugarPack = smoothShellBite[index]
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.tag = index
        styleVaultPackCard(pastryCard)
        pastryCard.addTarget(self, action: #selector(addVaultmuralAura(_:)), for: .touchUpInside)

        let muralTrail = makeVaultGemImage(asset: "ervoldgem")
        let sugarCountLabel = makeVaultCountLabel("\(sugarPack.sugarCount)")
        let glazeMarkLabel = makeVaultMarkLabel(index: index, sugarPack: sugarPack)
        let sprinkleActionLabel = makeVaultActionLabel()

        pastryCard.addSubview(muralTrail)
        pastryCard.addSubview(sugarCountLabel)
        pastryCard.addSubview(glazeMarkLabel)
        pastryCard.addSubview(sprinkleActionLabel)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 190),
            muralTrail.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 14),
            muralTrail.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            muralTrail.widthAnchor.constraint(equalToConstant: 42),
            muralTrail.heightAnchor.constraint(equalToConstant: 42),
            sugarCountLabel.topAnchor.constraint(equalTo: muralTrail.bottomAnchor, constant: 2),
            sugarCountLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 8),
            sugarCountLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -8),
            glazeMarkLabel.topAnchor.constraint(equalTo: sugarCountLabel.bottomAnchor, constant: 12),
            glazeMarkLabel.leadingAnchor.constraint(equalTo: sugarCountLabel.leadingAnchor),
            glazeMarkLabel.trailingAnchor.constraint(equalTo: sugarCountLabel.trailingAnchor),
            sprinkleActionLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 7),
            sprinkleActionLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -7),
            sprinkleActionLabel.topAnchor.constraint(equalTo: glazeMarkLabel.bottomAnchor, constant: 12),
            sprinkleActionLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
        return pastryCard
    }

    private func styleVaultPackCard(_ pastryCard: UIControl) {
        pastryCard.backgroundColor = .white
        pastryCard.layer.cornerRadius = 20
        pastryCard.layer.borderColor = UIColor(red: 1, green: 0.15, blue: 0.56, alpha: 1).cgColor
        pastryCard.layer.borderWidth = 3
    }

    private func makeVaultGemImage(asset: String) -> UIImageView {
        let glazeView = UIImageView(image: UIImage(named: asset))
        glazeView.translatesAutoresizingMaskIntoConstraints = false
        glazeView.contentMode = .scaleAspectFit
        return glazeView
    }

    private func makeVaultCaptionLabel(_ sugarText: String) -> UILabel {
        let crumbLabel = makeVaultLabel(sugarText, size: 19, weight: .medium, color: .white)
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeVaultCountLabel(_ sugarText: String) -> UILabel {
        let crumbLabel = makeVaultLabel(sugarText, size: 23, weight: .heavy, color: UIColor(red: 0.16, green: 0.24, blue: 0.04, alpha: 1))
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeVaultMarkLabel(index: Int, sugarPack: WevVGlazeVaultPack) -> UILabel {
        let crumbLabel = makeVaultLabel(glazeStoreItemsByKey[sugarPack.batchKey]?.displayPrice ?? sugarPack.fallbackMark, size: 16, weight: .semibold, color: UIColor(red: 0.16, green: 0.24, blue: 0.04, alpha: 1))
        crumbLabel.accessibilityIdentifier = "glazeVaultMark\(index)"
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeVaultActionLabel() -> UILabel {
        let crumbLabel = makeVaultLabel("R%eCcchPaorJgDeF".wevVPastryCrumbBloomRestored, size: 14, weight: .heavy, color: .white)
        crumbLabel.textAlignment = .center
        crumbLabel.backgroundColor = UIColor(red: 1, green: 0.15, blue: 0.64, alpha: 1)
        crumbLabel.layer.cornerRadius = 19
        crumbLabel.clipsToBounds = true
        return crumbLabel
    }

    private func makeVaultLabel(_ sugarText: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarText
        crumbLabel.font = .systemFont(ofSize: size, weight: weight)
        crumbLabel.textColor = color
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func refreshVaultHeader() {
        glazeSugarCountLabel.text = "\(plushCenterFinish.glazeGoldCount)"
    }

    @objc private func addVaultmuralAura(_ sender: UIControl) {
        guard plushCenterFinish.isTasterReady else {
            plushCenterTexturerty("Please sign in first."); return
        }
        guard glazeCatalogOwner == currentGlazeWalletOwner(), smoothShellBite.indices.contains(sender.tag) else {
            loadGlazeVaultProducts(); return
        }
        guard SKPaymentQueue.canMakePayments() else {
            plushCenterTexturerty("Purchases are disabled on this device."); return
        }
        let package = smoothShellBite[sender.tag]
        guard let product = glazeStoreItemsByKey[package.batchKey] else {
            loadGlazeVaultProducts()
            plushCenterTexturerty("Store items are still preparing. Please try again shortly.")
            return
        }
        bakeGlazeVaultPack(package, storeItem: product, pastryCard: sender)
    }

    @objc private func retryGlazeVaultProducts() {
        loadGlazeVaultProducts()
    }

    private func loadGlazeVaultProducts() {
        guard !isGlazeStoreLoading else { glazeCatalogRefresh.endRefreshing(); return }
        isGlazeStoreLoading = true
        let owner = currentGlazeWalletOwner()
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.isGlazeStoreLoading = false
                self.glazeCatalogRefresh.endRefreshing()
            }
            do {
                let catalog = try await WevVGlazeNativeRechargeService.shared.packages()
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                self.smoothShellBite = catalog.map { package in
                    let price = formatter.string(from: NSDecimalNumber(decimal: package.price)) ?? NSDecimalNumber(decimal: package.price).stringValue
                    return WevVGlazeVaultPack(sugarCount: package.diamonds,
                        fallbackMark: package.currencySymbol + price, batchKey: package.productID)
                }
                self.glazeCatalogOwner = owner
                self.glazeStoreItemsByKey = [:]
                self.rebuildGlazeVaultCards()
                guard !catalog.isEmpty else {
                    self.plushCenterTexturerty("Store items are not ready yet. Please try again shortly.")
                    return
                }
                let products = try await Product.products(for: catalog.map(\.productID))
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                self.glazeStoreItemsByKey = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
                self.refreshVaultMarks()
                if products.isEmpty { self.plushCenterTexturerty("Store items are not ready yet. Please try again shortly.") }
            } catch {
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                self.plushCenterTexturerty(error.localizedDescription)
            }
        }
    }

    private func currentGlazeWalletOwner() -> String {
        (plushCenterFinish.activeEnvironmentID ?? "") + "|" + String(plushCenterFinish.sessionEpoch)
    }

    private func rebuildGlazeVaultCards() {
        guard let grid = glazeVaultGrid else { return }
        grid.arrangedSubviews.forEach { grid.removeArrangedSubview($0); $0.removeFromSuperview() }
        glazePackCards = []
        for row in stride(from: 0, to: smoothShellBite.count, by: 3) {
            grid.addArrangedSubview(makeVaultPackRow(rowStart: row))
        }
        refreshVaultMarks()
    }

    private func refreshVaultMarks() {
        for card in glazePackCards where smoothShellBite.indices.contains(card.tag) {
            let package = smoothShellBite[card.tag]
            let label = card.subviews.compactMap { $0 as? UILabel }.first { $0.accessibilityIdentifier == "glazeVaultMark\(card.tag)" }
            label?.text = glazeStoreItemsByKey[package.batchKey]?.displayPrice ?? package.fallbackMark
            // Missing StoreKit products use the existing tap-to-retry branch, never a purchase.
            card.isEnabled = glazeCatalogOwner == currentGlazeWalletOwner()
            card.alpha = glazeStoreItemsByKey[package.batchKey] != nil && card.isEnabled ? 1 : 0.62
        }
    }

    private func bakeGlazeVaultPack(_ sugarPack: WevVGlazeVaultPack, storeItem: Product, pastryCard: UIControl) {
        guard storeItem.id == sugarPack.batchKey else { return }
        pastryCard.isEnabled = false
        pastryCard.alpha = 0.62
        let owner = currentGlazeWalletOwner()
        Task { [weak self, weak pastryCard] in
            guard let self else { return }
            defer {
                if self.currentGlazeWalletOwner() == owner {
                    pastryCard?.isEnabled = true; pastryCard?.alpha = 1
                }
            }
            do {
                let outcome = try await WevVGlazeNativeRechargeService.shared.purchase(productID: storeItem.id)
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                switch outcome {
                case .cancelled: self.plushCenterTexturerty("Store sheet was closed.")
                case .pending: self.plushCenterTexturerty("Your purchase is still being confirmed.")
                case .credited(let balance):
                    self.glazeSugarCountLabel.text = String(balance)
                    self.silkyCenter?()
                    self.plushCenterTexturerty("Donut vault balance updated")
                }
            } catch {
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                self.plushCenterTexturerty(error.localizedDescription)
            }
        }
    }



    private func listenForGlazeTrades() {
        let owner = currentGlazeWalletOwner()
        sprinkleTradeTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await WevVGlazeNativeRechargeService.shared.recoverPending()
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                if let balance = result.balance { self.glazeSugarCountLabel.text = String(balance); self.silkyCenter?() }
                if !result.failedCodes.isEmpty || result.limitReached {
                    self.plushCenterTexturerty("Some purchases are still awaiting confirmation. Please try again later.")
                }
            } catch {
                guard !Task.isCancelled, self.currentGlazeWalletOwner() == owner else { return }
                self.plushCenterTexturerty(error.localizedDescription)
            }
        }
    }





    private func plushCenterTexturerty(_ text: String) {
        TinGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }

    @objc private func slowRiseSequence() {
        dismiss(animated: true)
    }
}

private enum GlazeVaultTradeError: Error {
    case unverified
}
