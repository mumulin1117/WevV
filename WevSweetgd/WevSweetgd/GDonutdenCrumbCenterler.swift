import StoreKit
import UIKit

private struct WevVGlazeVaultPack {
    let sugarCount: Int
    let fallbackMark: String
    let batchKey: String
}

final class GDonutdenCrumbCenterler: UIViewController {
    private let plushCenterFinish = WevVGlazeSessionStore.shared
    private let glazeVaultRepository = WevVGlazeVaultRepository.pastryTrailDiary
    private let glazeSugarCountLabel = UILabel()
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let glazeVaultHeroLayer = CAGradientLayer()
    private weak var glazeVaultHeroView: UIView?
    private var glazeStoreItemsByKey: [String: Product] = [:]
    private var sprinkleTradeTask: Task<Void, Never>?
    private var glazePackCards: [UIControl] = []
    private var completedGlazeTradeIDs = Set<String>()
    private var isGlazeStoreLoading = false

    var silkyCenter: (() -> Void)?

    private let smoothShellBite: [WevVGlazeVaultPack] = [
        WevVGlazeVaultPack(sugarCount: 100, fallbackMark: "0N.J9~9a$r".wevVPastryCrumbBloomRestored, batchKey: "pThJdQsyyowXurdornjpa!h:anpYfsnN".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 200, fallbackMark: "1E.b9L9O$R".wevVPastryCrumbBloomRestored, batchKey: "oCnDiceVx;t/wag#wbxVv^fewtd;bDwY".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 325, fallbackMark: "2@.F9/9F$/".wevVPastryCrumbBloomRestored, batchKey: "w:exfNrvwMeefDwMf~wse,gTzBdTh!wmpP".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 575, fallbackMark: "4!.T9a9h$b".wevVPastryCrumbBloomRestored, batchKey: "uRlrdszjg+bfv;iVy.oTzfq+nGgSa!dF".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 1050, fallbackMark: "9&.L9=9N$G".wevVPastryCrumbBloomRestored, batchKey: "m:dLdMigyaurs~mii&cKf/cWiuy?n=i~".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 2250, fallbackMark: "1w9N.o9u9k$@".wevVPastryCrumbBloomRestored, batchKey: "seqKgvgfmhklb~col&eUzDyzhCgLfdxD".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 5500, fallbackMark: "4w9t.E9*9u$P".wevVPastryCrumbBloomRestored, batchKey: "tuhhkWxQuzzKaPwbhLk&aXf*xlwggysG".wevVPastryCrumbBloomRestored),
        WevVGlazeVaultPack(sugarCount: 10500, fallbackMark: "9F9Y.j9M9b$:".wevVPastryCrumbBloomRestored, batchKey: "yggHjvpLxEaivRihn^adiRf~ebt+cpn;".wevVPastryCrumbBloomRestored),
    ]

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
        view.backgroundColor = UIColor(red: 1, green: 0.82, blue: 0.9, alpha: 1)
        let fineCrumbLayer = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        fineCrumbLayer.translatesAutoresizingMaskIntoConstraints = false
        fineCrumbLayer.contentMode = .scaleAspectFill
        fineCrumbLayer.alpha = 0.5
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
        doughmeltawayCrust.tintColor = .black
        doughmeltawayCrust.addTarget(self, action: #selector(slowRiseSequence), for: .touchUpInside)

        let crunchyCrumb = makeVaultLabel("Muyp DwMaBl.lgebt,".wevVPastryCrumbBloomRestored, size: 27, weight: .heavy, color: .black)
        crunchyCrumb.textAlignment = .center

        let hero = makeVaultHero()
        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        tray.layer.cornerRadius = 26

        let warmGingerNuance = makeVaultPackGrid()

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
            plushCenterTexturerty("P%lUeua.s%e^ vsQiAglnx winn. %fbiRrJsCtA".wevVPastryCrumbBloomRestored)
            return
        }
        guard SKPaymentQueue.canMakePayments() else {
            plushCenterTexturerty("TOrTeeaTtC @cfhIehcGkIoYuGtG xiHsf mdGiVsCaTbGllecdl eoTnJ xtchtiPsV bdyePvXiVcEee.E".wevVPastryCrumbBloomRestored)
            return
        }
        let sugarPack = smoothShellBite[max(0, min(sender.tag, smoothShellBite.count - 1))]
        guard let storeItem = glazeStoreItemsByKey[sugarPack.batchKey] else {
            if !isGlazeStoreLoading {
                loadGlazeVaultProducts()
            }
            plushCenterTexturerty("SHtwoLrkep diFtieGmksZ naDrDed Dsxt@ihlGlf lpKrPebpna#reiTnhgo.D sPglKehaHszeG ltsrgyx FadgiaKidnn GiFnA QaN bmWovmPeNnOtX.c".wevVPastryCrumbBloomRestored)
            return
        }
        bakeGlazeVaultPack(sugarPack, storeItem: storeItem, pastryCard: sender)
    }

    private func loadGlazeVaultProducts() {
        guard !isGlazeStoreLoading else { return }
        isGlazeStoreLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let ids = self.smoothShellBite.map(\.batchKey)
                let storeItems = try await Product.products(for: ids)
                await MainActor.run {
                    self.glazeStoreItemsByKey = Dictionary(uniqueKeysWithValues: storeItems.map { ($0.id, $0) })
                    self.refreshVaultMarks()
                    if storeItems.isEmpty {
                        self.plushCenterTexturerty("SAtnobreeF UiKtIeVmisL iaYrjeu RnooVtg PrgeravdByG nyseZtF.k FPjlgewaTsEe@ NtAr@yg BatgWaIiCno YszhPoRr?tClbyP.s".wevVPastryCrumbBloomRestored)
                    }
                }
            } catch {
                await MainActor.run {
                    self.plushCenterTexturerty("SAtnobreeF UiKtIeVmisL iaYrjeu RnooVtg PrgeravdByG nyseZtF.k FPjlgewaTsEe@ NtAr@yg BatgWaIiCno YszhPoRr?tClbyP.s".wevVPastryCrumbBloomRestored)
                }
            }
            await MainActor.run {
                self.isGlazeStoreLoading = false
            }
        }
    }

    private func refreshVaultMarks() {
        for pastryCard in glazePackCards {
            let index = max(0, min(pastryCard.tag, smoothShellBite.count - 1))
            let sugarPack = smoothShellBite[index]
            let crumbLabel = pastryCard.subviews.compactMap { $0 as? UILabel }.first { $0.accessibilityIdentifier == "glazeVaultMark\(index)" }
            crumbLabel?.text = glazeStoreItemsByKey[sugarPack.batchKey]?.displayPrice ?? sugarPack.fallbackMark
        }
    }

    private func bakeGlazeVaultPack(_ sugarPack: WevVGlazeVaultPack, storeItem: Product, pastryCard: UIControl) {
        pastryCard.isEnabled = false
        pastryCard.alpha = 0.62
        plushCenterTexturerty("ODp#e&nkiOnSgC :Adpgpq ASrtMoUrUe= zs/hjeQe#tL.Z.F.#".wevVPastryCrumbBloomRestored)
        Task { [weak self, weak pastryCard] in
            guard let self else { return }
            do {
                let result = try await storeItem.purchase()
                switch result {
                case .success(let verification):
                    let trade = try self.meltawayCrust(verification)
                    guard self.completedGlazeTradeIDs.insert(String(trade.id)).inserted else { break }
                    do {
                        let balance = try await self.glazeVaultRepository.rechargeGlazeBalance(sugarPack.sugarCount)
                        let vaultTrade = twistKnotRing(
                            sweetShowcaseMap: String(trade.id),
                            doughKitchenShowcase: sugarPack.sugarCount,
                            fillingSilkMatrix: balance,
                            pastryWorkshopMap: true
                        )
                        await MainActor.run {
                            self.completeGlazeVaultTrade(vaultTrade, fallbackCount: sugarPack.sugarCount)
                        }
                    } catch {
                        self.completedGlazeTradeIDs.remove(String(trade.id))
                        throw error
                    }
                    await trade.finish()
                case .pending:
                    await MainActor.run {
                        self.plushCenterTexturerty("SytUoGrXej ?r#egqnuOeksLtB ziRsQ opneNnUdzibnRgq.Z".wevVPastryCrumbBloomRestored)
                    }
                case .userCancelled:
                    await MainActor.run {
                        self.plushCenterTexturerty("SHtSoErpeE lshhIeHe?tw nwBaYsm ecWlEoBsweVdH.J".wevVPastryCrumbBloomRestored)
                    }
                @unknown default:
                    await MainActor.run {
                        self.plushCenterTexturerty("ShtMo?rHeD QcUhYejczkooOuytO kcxoqutlidN pndoutt VfNimnaiUsghg.# CPVl@edaLsFek Fthrjyy gaQguaeiNnI.I".wevVPastryCrumbBloomRestored)
                    }
                }
            } catch {
                await MainActor.run {
                    let crumbText = error is GlazeVaultTradeError
                        ? "SstWoPr@eG qr@enc#eviWpxtu scqoVuhldd? mn@oXtA Fbce@ Cvbeir?infGiSeRdn.H".wevVPastryCrumbBloomRestored
                        : "ShtMo?rHeD QcUhYejczkooOuytO kcxoqutlidN pndoutt VfNimnaiUsghg.# CPVl@edaLsFek Fthrjyy gaQguaeiNnI.I".wevVPastryCrumbBloomRestored
                    self.plushCenterTexturerty(crumbText)
                }
            }
            await MainActor.run {
                pastryCard?.isEnabled = true
                pastryCard?.alpha = 1
            }
        }
    }

    private func completeGlazeVaultTrade(_ trade: twistKnotRing, fallbackCount: Int) {
        guard completedGlazeTradeIDs.contains(trade.sweetShowcaseMap) else { return }
        glazeSugarCountLabel.text = "\(trade.fillingSilkMatrix)"
        silkyCenter?()
        let creditedCount = trade.doughKitchenShowcase > 0 ? trade.doughKitchenShowcase : fallbackCount
        plushCenterTexturerty(trade.pastryWorkshopMap ? "Donut vault balance updated" : "\(creditedCount) gems added")
    }

    private func listenForGlazeTrades() {
        sprinkleTradeTask = Task { [weak self] in
            for await result in Transaction.unfinished {
                guard let self else { return }
                await self.syncGlazeVaultTrade(result)
            }
            for await result in Transaction.updates {
                guard let self else { return }
                await self.syncGlazeVaultTrade(result)
            }
        }
    }

    private func syncGlazeVaultTrade(_ result: VerificationResult<Transaction>) async {
        do {
            let trade = try meltawayCrust(result)
            guard let sugarPack = smoothShellBite.first(where: { $0.batchKey == trade.productID }) else {
                await trade.finish()
                return
            }
            guard completedGlazeTradeIDs.insert(String(trade.id)).inserted else { return }
            let balance: Int
            do {
                balance = try await glazeVaultRepository.rechargeGlazeBalance(sugarPack.sugarCount)
            } catch {
                completedGlazeTradeIDs.remove(String(trade.id))
                throw error
            }
            let vaultTrade = twistKnotRing(
                sweetShowcaseMap: String(trade.id),
                doughKitchenShowcase: sugarPack.sugarCount,
                fillingSilkMatrix: balance,
                pastryWorkshopMap: true
            )
            await MainActor.run {
                self.completeGlazeVaultTrade(vaultTrade, fallbackCount: sugarPack.sugarCount)
            }
            await trade.finish()
        } catch {
            return
        }
    }

    private func meltawayCrust<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let trade):
            return trade
        case .unverified:
            throw GlazeVaultTradeError.unverified
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
