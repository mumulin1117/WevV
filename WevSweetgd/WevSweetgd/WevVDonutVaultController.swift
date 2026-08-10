import StoreKit
import UIKit

private struct WevVGlazeVaultPack {
    let sugarCount: Int
    let fallbackMark: String
    let batchKey: String
}

final class WevVDonutVaultController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let glazeSugarCountLabel = UILabel()
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private var glazeStoreItemsByKey: [String: Product] = [:]
    private var sprinkleTradeTask: Task<Void, Never>?
    private var glazePackCards: [UIControl] = []
    private var isGlazeStoreLoading = false

    var onVaultChanged: (() -> Void)?

    private let glazePacks: [WevVGlazeVaultPack] = [
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
        buildVaultBackdrop()
        buildVaultScroll()
        buildVaultContent()
        refreshVaultHeader()
        listenForGlazeTrades()
        loadGlazeVaultProducts()
    }

    deinit {
        sprinkleTradeTask?.cancel()
    }

    private func buildVaultBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.82, blue: 0.9, alpha: 1)
        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        backdrop.alpha = 0.5
        view.addSubview(backdrop)
        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildVaultScroll() {
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

    private func buildVaultContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = .black
        doughBackButton.addTarget(self, action: #selector(closeVault), for: .touchUpInside)

        let glazeTitle = makeVaultLabel("Muyp DwMaBl.lgebt,".wevVPastryCrumbBloomRestored, size: 27, weight: .heavy, color: .black)
        glazeTitle.textAlignment = .center

        let hero = makeVaultHero()
        let tray = UIView()
        tray.translatesAutoresizingMaskIntoConstraints = false
        tray.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        tray.layer.cornerRadius = 26

        let grid = makeVaultPackGrid()

        sprinkleContent.addSubview(doughBackButton)
        sprinkleContent.addSubview(glazeTitle)
        sprinkleContent.addSubview(hero)
        sprinkleContent.addSubview(tray)
        tray.addSubview(grid)
        pinVaultContent(doughBackButton: doughBackButton, title: glazeTitle, hero: hero, tray: tray, grid: grid)
    }

    private func makeVaultPackGrid() -> UIStackView {
        let grid = UIStackView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 14
        for rowIndex in stride(from: 0, to: glazePacks.count, by: 3) {
            grid.addArrangedSubview(makeVaultPackRow(rowStart: rowIndex))
        }
        return grid
    }

    private func makeVaultPackRow(rowStart: Int) -> UIStackView {
        let donutRow = UIStackView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.spacing = 12
        donutRow.distribution = .fillEqually
        for packIndex in rowStart..<min(rowStart + 3, glazePacks.count) {
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
        let hero = UIView()
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.layer.cornerRadius = 34
        hero.clipsToBounds = true
        let glaze = CAGradientLayer()
        glaze.colors = [
            UIColor(red: 0.87, green: 0.05, blue: 0.92, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.03, blue: 0.58, alpha: 1).cgColor
        ]
        glaze.startPoint = CGPoint(x: 0, y: 0.2)
        glaze.endPoint = CGPoint(x: 1, y: 0.8)
        hero.layer.insertSublayer(glaze, at: 0)

        let gem = makeVaultGemImage(asset: "oldgem")
        glazeSugarCountLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeSugarCountLabel.font = .systemFont(ofSize: 44, weight: .heavy)
        glazeSugarCountLabel.textColor = .white
        glazeSugarCountLabel.textAlignment = .center
        let caption = makeVaultCaptionLabel("Msyk zgDorlodSeOnv tg&e#mBss".wevVPastryCrumbBloomRestored)

        hero.addSubview(gem)
        hero.addSubview(glazeSugarCountLabel)
        hero.addSubview(caption)

        NSLayoutConstraint.activate([
            gem.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 22),
            gem.topAnchor.constraint(equalTo: hero.topAnchor, constant: 10),
            gem.widthAnchor.constraint(equalToConstant: 132),
            gem.heightAnchor.constraint(equalToConstant: 132),
            glazeSugarCountLabel.centerYAnchor.constraint(equalTo: gem.centerYAnchor, constant: 4),
            glazeSugarCountLabel.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 10),
            glazeSugarCountLabel.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -20),
            caption.topAnchor.constraint(equalTo: glazeSugarCountLabel.bottomAnchor, constant: 4),
            caption.centerXAnchor.constraint(equalTo: glazeSugarCountLabel.centerXAnchor)
        ])
        DispatchQueue.main.async {
            glaze.frame = hero.bounds
        }
        return hero
    }

    private func makePackCard(index: Int) -> UIControl {
        let sugarPack = glazePacks[index]
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.tag = index
        styleVaultPackCard(pastryCard)
        pastryCard.addTarget(self, action: #selector(addVaultGold(_:)), for: .touchUpInside)

        let gem = makeVaultGemImage(asset: "ervoldgem")
        let sugarCountLabel = makeVaultCountLabel("\(sugarPack.sugarCount)")
        let glazeMarkLabel = makeVaultMarkLabel(index: index, sugarPack: sugarPack)
        let sprinkleActionLabel = makeVaultActionLabel()

        pastryCard.addSubview(gem)
        pastryCard.addSubview(sugarCountLabel)
        pastryCard.addSubview(glazeMarkLabel)
        pastryCard.addSubview(sprinkleActionLabel)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 190),
            gem.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 14),
            gem.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            gem.widthAnchor.constraint(equalToConstant: 42),
            gem.heightAnchor.constraint(equalToConstant: 42),
            sugarCountLabel.topAnchor.constraint(equalTo: gem.bottomAnchor, constant: 2),
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
        glazeSugarCountLabel.text = "\(glazeSession.glazeGoldCount)"
    }

    @objc private func addVaultGold(_ sender: UIControl) {
        guard glazeSession.isTasterReady else {
            showVaultHint("P%lUeua.s%e^ vsQiAglnx winn. %fbiRrJsCtA".wevVPastryCrumbBloomRestored)
            return
        }
        guard SKPaymentQueue.canMakePayments() else {
            showVaultHint("TOrTeeaTtC @cfhIehcGkIoYuGtG xiHsf mdGiVsCaTbGllecdl eoTnJ xtchtiPsV bdyePvXiVcEee.E".wevVPastryCrumbBloomRestored)
            return
        }
        let sugarPack = glazePacks[max(0, min(sender.tag, glazePacks.count - 1))]
        guard let storeItem = glazeStoreItemsByKey[sugarPack.batchKey] else {
            if !isGlazeStoreLoading {
                loadGlazeVaultProducts()
            }
            showVaultHint("SHtwoLrkep diFtieGmksZ naDrDed Dsxt@ihlGlf lpKrPebpna#reiTnhgo.D sPglKehaHszeG ltsrgyx FadgiaKidnn GiFnA QaN bmWovmPeNnOtX.c".wevVPastryCrumbBloomRestored)
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
                let ids = self.glazePacks.map(\.batchKey)
                let storeItems = try await Product.products(for: ids)
                await MainActor.run {
                    self.glazeStoreItemsByKey = Dictionary(uniqueKeysWithValues: storeItems.map { ($0.id, $0) })
                    self.refreshVaultMarks()
                    if storeItems.isEmpty {
                        self.showVaultHint("SAtnobreeF UiKtIeVmisL iaYrjeu RnooVtg PrgeravdByG nyseZtF.k FPjlgewaTsEe@ NtAr@yg BatgWaIiCno YszhPoRr?tClbyP.s".wevVPastryCrumbBloomRestored)
                    }
                }
            } catch {
                await MainActor.run {
                    self.showVaultHint("SAtnobreeF UiKtIeVmisL iaYrjeu RnooVtg PrgeravdByG nyseZtF.k FPjlgewaTsEe@ NtAr@yg BatgWaIiCno YszhPoRr?tClbyP.s".wevVPastryCrumbBloomRestored)
                }
            }
            await MainActor.run {
                self.isGlazeStoreLoading = false
            }
        }
    }

    private func refreshVaultMarks() {
        for pastryCard in glazePackCards {
            let index = max(0, min(pastryCard.tag, glazePacks.count - 1))
            let sugarPack = glazePacks[index]
            let crumbLabel = pastryCard.subviews.compactMap { $0 as? UILabel }.first { $0.accessibilityIdentifier == "glazeVaultMark\(index)" }
            crumbLabel?.text = glazeStoreItemsByKey[sugarPack.batchKey]?.displayPrice ?? sugarPack.fallbackMark
        }
    }

    private func bakeGlazeVaultPack(_ sugarPack: WevVGlazeVaultPack, storeItem: Product, pastryCard: UIControl) {
        pastryCard.isEnabled = false
        pastryCard.alpha = 0.62
        showVaultHint("ODp#e&nkiOnSgC :Adpgpq ASrtMoUrUe= zs/hjeQe#tL.Z.F.#".wevVPastryCrumbBloomRestored)
        Task { [weak self, weak pastryCard] in
            guard let self else { return }
            do {
                let result = try await storeItem.purchase()
                switch result {
                case .success(let verification):
                    let trade = try self.verifiedGlazeTrade(verification)
                    await trade.finish()
                    await MainActor.run {
                        self.completeGlazeVaultPack(sugarPack)
                    }
                case .pending:
                    await MainActor.run {
                        self.showVaultHint("SytUoGrXej ?r#egqnuOeksLtB ziRsQ opneNnUdzibnRgq.Z".wevVPastryCrumbBloomRestored)
                    }
                case .userCancelled:
                    await MainActor.run {
                        self.showVaultHint("SHtSoErpeE lshhIeHe?tw nwBaYsm ecWlEoBsweVdH.J".wevVPastryCrumbBloomRestored)
                    }
                @unknown default:
                    await MainActor.run {
                        self.showVaultHint("ShtMo?rHeD QcUhYejczkooOuytO kcxoqutlidN pndoutt VfNimnaiUsghg.# CPVl@edaLsFek Fthrjyy gaQguaeiNnI.I".wevVPastryCrumbBloomRestored)
                    }
                }
            } catch {
                await MainActor.run {
                    let crumbText = error is GlazeVaultTradeError
                        ? "SstWoPr@eG qr@enc#eviWpxtu scqoVuhldd? mn@oXtA Fbce@ Cvbeir?infGiSeRdn.H".wevVPastryCrumbBloomRestored
                        : "ShtMo?rHeD QcUhYejczkooOuytO kcxoqutlidN pndoutt VfNimnaiUsghg.# CPVl@edaLsFek Fthrjyy gaQguaeiNnI.I".wevVPastryCrumbBloomRestored
                    self.showVaultHint(crumbText)
                }
            }
            await MainActor.run {
                pastryCard?.isEnabled = true
                pastryCard?.alpha = 1
            }
        }
    }

    private func completeGlazeVaultPack(_ sugarPack: WevVGlazeVaultPack) {
        glazeSession.addGlazeGold(sugarPack.sugarCount)
        refreshVaultHeader()
        onVaultChanged?()
        showVaultHint("\(sugarPack.sugarCount) gems added")
    }

    private func listenForGlazeTrades() {
        sprinkleTradeTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let trade = try self.verifiedGlazeTrade(result)
                    if let sugarPack = self.glazePacks.first(where: { $0.batchKey == trade.productID }) {
                        self.completeGlazeVaultPack(sugarPack)
                    }
                    await trade.finish()
                } catch {
                    continue
                }
            }
        }
    }

    private func verifiedGlazeTrade<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let trade):
            return trade
        case .unverified:
            throw GlazeVaultTradeError.unverified
        }
    }

    private func showVaultHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -24)
    }

    @objc private func closeVault() {
        dismiss(animated: true)
    }
}

private enum GlazeVaultTradeError: Error {
    case unverified
}
