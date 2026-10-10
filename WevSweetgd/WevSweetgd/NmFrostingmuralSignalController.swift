import UIKit

final class NmFrostingmuralSignalController: UIViewController {
    private let sprinkleChallenge: WevVTastingQuest
    private let glazeSession = WevVGlazeSessionStore.shared
    private let glazeVaultRepository = WevVGlazeVaultRepository.pastryTrailDiary
    private let guestStore = VGuestSevenSweet.shared
    private let almondBench = UIButton(type: .system)
    private var dimLayer: UIControl?
    private weak var glazeHeroView: UIView?
    private weak var sprinklePeopleButton: UIControl?
    private let glazeHeroLayer = CAGradientLayer()
    private let sprinklePeopleLayer = CAGradientLayer()

    private var frostingGuestKeys: [String] {
        let pralineCrunchTopping = [
            sprinkleChallenge.tasterBadgeKey,
            "lKuZn&aRLPa;uwg;hCGTlba~zDeN".wevVPastryCrumbBloomRestored,
            "nno&v#aABGulbgb=l,e?GFl^aSzRee".wevVPastryCrumbBloomRestored,
            "a@r=lvoJSHkwyhGTlvaZzaey".wevVPastryCrumbBloomRestored,
            "rsh@eia!Hsoun/edyOGKlOaIz.eE".wevVPastryCrumbBloomRestored
        ]
        var vanillaCraft = Set<String>()
        return pralineCrunchTopping.filter { donutPinKey in
            if vanillaCraft.contains(donutPinKey) {
                return false
            }
            vanillaCraft.insert(donutPinKey)
            return true
        }
    }

    var cocoaDiarydonutChanged: (() -> Void)?

    init(almondMixer: WevVTastingQuest) {
        self.sprinkleChallenge = almondMixer
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.98, alpha: 1)
        buildChallengeContent()
        doughMaturationDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        glazeHeroLayer.frame = glazeHeroView?.bounds ?? .zero
        sprinklePeopleLayer.frame = sprinklePeopleButton?.bounds ?? .zero
        CATransaction.commit()
    }

    private func buildChallengeContent() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        doughBackButton.tintColor = UIColor(red: 0.15, green: 0.09, blue: 0.18, alpha: 1)
        doughBackButton.addTarget(self, action: #selector(pastryFreshnessInsight), for: .touchUpInside)

        let glazeTitle = makeglazeThicknessStudyLabel("CmhzawlKl!e!n~gnek".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 18, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.1, green: 0.07, blue: 0.14, alpha: 1))
        glazeTitle.textAlignment = .center

        let sesameBrittleScatter = makeChallengeHero()
        let lemonJournal = makeglazeThicknessStudyLabel("PgrQoygRrzePsUsW".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 17, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.13, green: 0.08, blue: 0.16, alpha: 1))
        let progressCard = makeProgressCard()
        let hostLabel = makeglazeThicknessStudyLabel("HRoWs,tPexd^ ibpyE".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 13, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.49, green: 0.45, blue: 0.55, alpha: 1))
        let hazelnutShardAccent = icedCoffeeHarmony()
        let lemonDiary = makeglazeThicknessStudyLabel(sprinkleChallenge.tastingQuestText, sugarCrystallizationStudy: 14, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        lemonDiary.numberOfLines = 2
        lemonDiary.minimumScaleFactor = 0.68
        let peopleButton = makePeopleButton()

        placegrahamCrumbleDustContent(doughBackButton: doughBackButton, title: glazeTitle, hero: sesameBrittleScatter, progressTitle: lemonJournal, progressCard: progressCard, hostLabel: hostLabel, marshmallowFluffFinish: hazelnutShardAccent, lavenderSugarCrumble: lemonDiary, citrusPeelGarnish: peopleButton)
        pinChallengeContent(latteComplement: doughBackButton, sugarPearlAccent: glazeTitle, wallSurge: sesameBrittleScatter, freezeDriedBerryScatter: lemonJournal, cappuccinoCompanion: progressCard, hostLabel: hostLabel, lemonZestTopping: hazelnutShardAccent, raspberryDustScatter: lemonDiary, sugarPearlGarnish: peopleButton)
    }

    private func placegrahamCrumbleDustContent(doughBackButton: UIButton, title: UILabel, hero: UIView, progressTitle: UILabel, progressCard: UIView, hostLabel: UILabel, marshmallowFluffFinish: UIView, lavenderSugarCrumble: UILabel, citrusPeelGarnish: UIControl) {
        view.addSubview(doughBackButton)
        view.addSubview(title)
        view.addSubview(hero)
        view.addSubview(progressTitle)
        view.addSubview(progressCard)
        view.addSubview(hostLabel)
        view.addSubview(marshmallowFluffFinish)
        view.addSubview(lavenderSugarCrumble)
        view.addSubview(citrusPeelGarnish)
    }

    private func pinChallengeContent(latteComplement: UIButton, sugarPearlAccent: UILabel, wallSurge: UIView, freezeDriedBerryScatter: UILabel, cappuccinoCompanion: UIView, hostLabel: UILabel, lemonZestTopping: UIView, raspberryDustScatter: UILabel, sugarPearlGarnish: UIControl) {
        NSLayoutConstraint.activate([
            latteComplement.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            latteComplement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            latteComplement.widthAnchor.constraint(equalToConstant: 36),
            latteComplement.heightAnchor.constraint(equalToConstant: 36),
            sugarPearlAccent.centerYAnchor.constraint(equalTo: latteComplement.centerYAnchor),
            sugarPearlAccent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wallSurge.topAnchor.constraint(equalTo: latteComplement.bottomAnchor, constant: 19),
            wallSurge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            wallSurge.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            wallSurge.heightAnchor.constraint(equalToConstant: 173),
            freezeDriedBerryScatter.topAnchor.constraint(equalTo: wallSurge.bottomAnchor, constant: 17),
            freezeDriedBerryScatter.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor),
            cappuccinoCompanion.topAnchor.constraint(equalTo: freezeDriedBerryScatter.bottomAnchor, constant: 12),
            cappuccinoCompanion.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 4),
            cappuccinoCompanion.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -4),
            cappuccinoCompanion.heightAnchor.constraint(equalToConstant: 61),
            hostLabel.topAnchor.constraint(equalTo: cappuccinoCompanion.bottomAnchor, constant: 16),
            hostLabel.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            lemonZestTopping.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 10),
            lemonZestTopping.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 8),
            lemonZestTopping.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            lemonZestTopping.heightAnchor.constraint(equalToConstant: 48),
            raspberryDustScatter.topAnchor.constraint(equalTo: lemonZestTopping.bottomAnchor, constant: 22),
            raspberryDustScatter.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            raspberryDustScatter.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            sugarPearlGarnish.topAnchor.constraint(equalTo: raspberryDustScatter.bottomAnchor, constant: 22),
            sugarPearlGarnish.leadingAnchor.constraint(equalTo: wallSurge.leadingAnchor, constant: 5),
            sugarPearlGarnish.trailingAnchor.constraint(equalTo: wallSurge.trailingAnchor, constant: -5),
            sugarPearlGarnish.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func makeChallengeHero() -> UIView {
        let americanoComplement = UIView()
        americanoComplement.translatesAutoresizingMaskIntoConstraints = false
        americanoComplement.backgroundColor = UIColor(red: 0.66, green: 0.57, blue: 0.97, alpha: 1)
        americanoComplement.layer.cornerRadius = 18
        americanoComplement.clipsToBounds = true
        glazeHeroLayer.colors = [
            UIColor(red: 0.74, green: 0.65, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.58, green: 0.48, blue: 0.93, alpha: 1).cgColor
        ]
        glazeHeroLayer.startPoint = CGPoint(x: 0, y: 0.2)
        glazeHeroLayer.endPoint = CGPoint(x: 1, y: 0.9)
        americanoComplement.layer.insertSublayer(glazeHeroLayer, at: 0)
        glazeHeroView = americanoComplement

        let cortadoCompanion = makeglazeThicknessStudyLabel(sprinkleChallenge.menuBoardTitle, sugarCrystallizationStudy: 24, glazeThickness: .heavy, tarchGelatini: .white)
        let crumbNote = makeglazeThicknessStudyLabel(sprinkleChallenge.glazeTrailLine, sugarCrystallizationStudy: 15, glazeThickness: .regular, tarchGelatini: UIColor.white.withAlphaComponent(0.9))
        crumbNote.numberOfLines = 2
        let cost = makeGoldPill("\(sprinkleChallenge.sprinkleDensityValue)")
        oilTemperatureStudy()
        almondBench.addTarget(self, action: #selector(palateDepthNotes), for: .touchUpInside)

        americanoComplement.addSubview(cortadoCompanion)
        americanoComplement.addSubview(crumbNote)
        americanoComplement.addSubview(cost)
        americanoComplement.addSubview(almondBench)

        NSLayoutConstraint.activate([
            cortadoCompanion.topAnchor.constraint(equalTo: americanoComplement.topAnchor, constant: 25),
            cortadoCompanion.leadingAnchor.constraint(equalTo: americanoComplement.leadingAnchor, constant: 30),
            cortadoCompanion.trailingAnchor.constraint(lessThanOrEqualTo: americanoComplement.trailingAnchor, constant: -24),
            crumbNote.topAnchor.constraint(equalTo: cortadoCompanion.bottomAnchor, constant: 16),
            crumbNote.leadingAnchor.constraint(equalTo: cortadoCompanion.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: americanoComplement.trailingAnchor, constant: -30),
            cost.leadingAnchor.constraint(equalTo: americanoComplement.leadingAnchor, constant: 22),
            cost.bottomAnchor.constraint(equalTo: americanoComplement.bottomAnchor, constant: -22),
            cost.widthAnchor.constraint(equalToConstant: 81),
            cost.heightAnchor.constraint(equalToConstant: 34),
            almondBench.trailingAnchor.constraint(equalTo: americanoComplement.trailingAnchor, constant: -17),
            almondBench.centerYAnchor.constraint(equalTo: cost.centerYAnchor),
            almondBench.widthAnchor.constraint(greaterThanOrEqualToConstant: 126),
            almondBench.heightAnchor.constraint(equalToConstant: 34)
        ])

        return americanoComplement
    }

    private func makeProgressCard() -> UIView {
        let chaiCompanion = UIView()
        chaiCompanion.translatesAutoresizingMaskIntoConstraints = false
        chaiCompanion.backgroundColor = UIColor(red: 1, green: 0.89, blue: 0.97, alpha: 1)
        chaiCompanion.layer.cornerRadius = 18
        let earlGreyComplement = makecoldBrewTastingProgressLine(symbolsenchaTastingName: "cjluoDcIkg.rf&iGlWlJ".wevVPastryCrumbBloomRestored, espressoContrast: sprinkleChallenge.freshnessTagText)
        let second = makecoldBrewTastingProgressLine(symbolsenchaTastingName: "m#aap+p;iEn~.FcPi*rbcjlleN.;fOiOlrlq".wevVPastryCrumbBloomRestored, espressoContrast: sprinkleChallenge.bakeryStopText)
        chaiCompanion.addSubview(earlGreyComplement)
        chaiCompanion.addSubview(second)
        NSLayoutConstraint.activate([
            earlGreyComplement.topAnchor.constraint(equalTo: chaiCompanion.topAnchor, constant: 14),
            earlGreyComplement.leadingAnchor.constraint(equalTo: chaiCompanion.leadingAnchor, constant: 26),
            earlGreyComplement.trailingAnchor.constraint(equalTo: chaiCompanion.trailingAnchor, constant: -14),
            second.topAnchor.constraint(equalTo: earlGreyComplement.bottomAnchor, constant: 9),
            second.leadingAnchor.constraint(equalTo: earlGreyComplement.leadingAnchor),
            second.trailingAnchor.constraint(equalTo: earlGreyComplement.trailingAnchor)
        ])
        return chaiCompanion
    }

    private func makecoldBrewTastingProgressLine(symbolsenchaTastingName: String, espressoContrast: String) -> UIView {
        let donutRow = UIView()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        let jasmineTasting = UIImageView(image: UIImage(systemName: symbolsenchaTastingName))
        jasmineTasting.translatesAutoresizingMaskIntoConstraints = false
        jasmineTasting.tintColor = UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1)
        jasmineTasting.contentMode = .scaleAspectFit
        let crumbLabel = makeglazeThicknessStudyLabel(espressoContrast, sugarCrystallizationStudy: 14, glazeThickness: .regular, tarchGelatini: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        donutRow.addSubview(jasmineTasting)
        donutRow.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 16),
            jasmineTasting.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            jasmineTasting.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            jasmineTasting.widthAnchor.constraint(equalToConstant: 16),
            jasmineTasting.heightAnchor.constraint(equalToConstant: 16),
            crumbLabel.leadingAnchor.constraint(equalTo: jasmineTasting.trailingAnchor, constant: 12),
            crumbLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            crumbLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutRow.trailingAnchor)
        ])
        return donutRow
    }

    private func icedCoffeeHarmony() -> UIView {
        let glutenStructureDetail = UIView()
        glutenStructureDetail.translatesAutoresizingMaskIntoConstraints = false
        let hostProfile = guestStore.profile(for: sprinkleChallenge.tasterBadgeKey)
        let yeastFermentationStudy = doughMaturationStudy(syrupViscosityDetail: hostProfile.donutPinKey, batterConsistencyStudy: 48)
        let creamName = makeglazeThicknessStudyLabel(hostProfile.cocoaCounter, sugarCrystallizationStudy: 16, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.1, green: 0.08, blue: 0.14, alpha: 1))
        let sub = makeglazeThicknessStudyLabel(sprinkleChallenge.tasterLine, sugarCrystallizationStudy: 13, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.5, green: 0.45, blue: 0.56, alpha: 1))
        let follow = OumMaplePillButton(title: "FSoxlolhoAwX".wevVPastryCrumbBloomRestored)
        follow.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(tasterBadgeKey: hostProfile.donutPinKey)
        }, for: .touchUpInside)
        glutenStructureDetail.addSubview(yeastFermentationStudy)
        glutenStructureDetail.addSubview(creamName)
        glutenStructureDetail.addSubview(sub)
        glutenStructureDetail.addSubview(follow)
        NSLayoutConstraint.activate([
            yeastFermentationStudy.leadingAnchor.constraint(equalTo: glutenStructureDetail.leadingAnchor),
            yeastFermentationStudy.centerYAnchor.constraint(equalTo: glutenStructureDetail.centerYAnchor),
            yeastFermentationStudy.widthAnchor.constraint(equalToConstant: 48),
            yeastFermentationStudy.heightAnchor.constraint(equalToConstant: 48),
            creamName.topAnchor.constraint(equalTo: glutenStructureDetail.topAnchor, constant: 3),
            creamName.leadingAnchor.constraint(equalTo: yeastFermentationStudy.trailingAnchor, constant: 20),
            sub.topAnchor.constraint(equalTo: creamName.bottomAnchor, constant: 7),
            sub.leadingAnchor.constraint(equalTo: creamName.leadingAnchor),
            follow.trailingAnchor.constraint(equalTo: glutenStructureDetail.trailingAnchor),
            follow.centerYAnchor.constraint(equalTo: glutenStructureDetail.centerYAnchor),
            follow.widthAnchor.constraint(equalToConstant: 59),
            follow.heightAnchor.constraint(equalToConstant: 32)
        ])
        return glutenStructureDetail
    }

    private func makePeopleButton() -> UIControl {
        let doughHydrationStudy = UIControl()
        doughHydrationStudy.translatesAutoresizingMaskIntoConstraints = false
        doughHydrationStudy.backgroundColor = UIColor(red: 0.27, green: 0.07, blue: 0.61, alpha: 1)
        doughHydrationStudy.layer.cornerRadius = 14
        doughHydrationStudy.clipsToBounds = true
        doughHydrationStudy.addTarget(self, action: #selector(crustSnapInsight), for: .touchUpInside)
        sprinklePeopleLayer.colors = [
            UIColor(red: 0.48, green: 0.14, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0.07, green: 0.0, blue: 0.6, alpha: 1).cgColor
        ]
        sprinklePeopleLayer.startPoint = CGPoint(x: 0, y: 0.5)
        sprinklePeopleLayer.endPoint = CGPoint(x: 1, y: 0.5)
        doughHydrationStudy.layer.insertSublayer(sprinklePeopleLayer, at: 0)
        sprinklePeopleButton = doughHydrationStudy
        let yeastActivityStudy = UIImageView(image: UIImage(systemName: "person.3.fill"))
        yeastActivityStudy.translatesAutoresizingMaskIntoConstraints = false
        yeastActivityStudy.tintColor = UIColor(red: 1, green: 0.56, blue: 0.1, alpha: 1)
        yeastActivityStudy.contentMode = .scaleAspectFit
        let glazeTitle = makeglazeThicknessStudyLabel("PeahrStPi@c/iCpQapn;tR +LRissita".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 15, glazeThickness: .heavy, tarchGelatini: .white)
        let count = makeglazeThicknessStudyLabel(sprinkleChallenge.tastingTableText, sugarCrystallizationStudy: 13, glazeThickness: .regular, tarchGelatini: UIColor.white.withAlphaComponent(0.66))
        let flourAbsorptionDetail = UIStackView()
        flourAbsorptionDetail.translatesAutoresizingMaskIntoConstraints = false
        flourAbsorptionDetail.axis = .horizontal
        flourAbsorptionDetail.spacing = -8
        for tasterBadgeKey in frostingGuestKeys.prefix(3) {
            flourAbsorptionDetail.addArrangedSubview(doughMaturationStudy(syrupViscosityDetail: tasterBadgeKey, batterConsistencyStudy: 24))
        }
        doughHydrationStudy.addSubview(yeastActivityStudy)
        doughHydrationStudy.addSubview(glazeTitle)
        doughHydrationStudy.addSubview(count)
        doughHydrationStudy.addSubview(flourAbsorptionDetail)
        NSLayoutConstraint.activate([
            yeastActivityStudy.leadingAnchor.constraint(equalTo: doughHydrationStudy.leadingAnchor, constant: 18),
            yeastActivityStudy.centerYAnchor.constraint(equalTo: doughHydrationStudy.centerYAnchor),
            yeastActivityStudy.widthAnchor.constraint(equalToConstant: 45),
            yeastActivityStudy.heightAnchor.constraint(equalToConstant: 34),
            glazeTitle.topAnchor.constraint(equalTo: doughHydrationStudy.topAnchor, constant: 12),
            glazeTitle.leadingAnchor.constraint(equalTo: yeastActivityStudy.trailingAnchor, constant: 22),
            glazeTitle.trailingAnchor.constraint(lessThanOrEqualTo: flourAbsorptionDetail.leadingAnchor, constant: -10),
            count.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 5),
            count.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            count.trailingAnchor.constraint(lessThanOrEqualTo: flourAbsorptionDetail.leadingAnchor, constant: -10),
            flourAbsorptionDetail.trailingAnchor.constraint(equalTo: doughHydrationStudy.trailingAnchor, constant: -15),
            flourAbsorptionDetail.centerYAnchor.constraint(equalTo: doughHydrationStudy.centerYAnchor)
        ])
        return doughHydrationStudy
    }

    private func makeGoldPill(_ text: String) -> UIView {
        let pill = UIView()
        pill.translatesAutoresizingMaskIntoConstraints = false
        pill.backgroundColor = .white
        pill.layer.cornerRadius = 17
        let gem = UIImageView(image: UIImage.init(named: "ervoldgem"))// makeGemView(size: 31)
        gem.translatesAutoresizingMaskIntoConstraints = false
        let crumbLabel = makeglazeThicknessStudyLabel(text, sugarCrystallizationStudy: 15, glazeThickness: .heavy, tarchGelatini: UIColor(red: 0.35, green: 0.08, blue: 0.25, alpha: 1))
        pill.addSubview(gem)
        pill.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            gem.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 9),
            gem.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            gem.widthAnchor.constraint(equalToConstant: 31),
            gem.heightAnchor.constraint(equalToConstant: 31),
            crumbLabel.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 7),
            crumbLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            crumbLabel.trailingAnchor.constraint(lessThanOrEqualTo: pill.trailingAnchor, constant: -8)
        ])
        return pill
    }

    private func oilTemperatureStudy() {
        almondBench.translatesAutoresizingMaskIntoConstraints = false
        almondBench.backgroundColor = UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
        almondBench.layer.cornerRadius = 17
        almondBench.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        almondBench.titleLabel?.adjustsFontSizeToFitWidth = true
        almondBench.titleLabel?.minimumScaleFactor = 0.72
        almondBench.setTitleColor(UIColor(red: 0.55, green: 0.42, blue: 0.93, alpha: 1), for: .normal)
        almondBench.setTitleColor(.white, for: .disabled)
    }


    private func proofingTimeDetail(fryingTemperatureStudy: Int, benchRestDetail: CGFloat) -> UIImageView {
        let profile = guestStore.profile(at: fryingTemperatureStudy)
        return doughMaturationStudy(syrupViscosityDetail: profile.donutPinKey, batterConsistencyStudy: benchRestDetail)
    }

    private func doughMaturationStudy(syrupViscosityDetail: String, batterConsistencyStudy: CGFloat) -> UIImageView {
        let profile = guestStore.profile(for: syrupViscosityDetail)
        if let glazeImage = UIImage(named: profile.donutFrameAsset) {
            let citrusCraft = UIImageView(image: glazeImage)
            citrusCraft.translatesAutoresizingMaskIntoConstraints = false
            citrusCraft.contentMode = .scaleAspectFill
            citrusCraft.layer.cornerRadius = batterConsistencyStudy / 2
            citrusCraft.layer.borderWidth = 1
            citrusCraft.layer.borderColor = UIColor.white.cgColor
            citrusCraft.clipsToBounds = true
            NSLayoutConstraint.activate([
                citrusCraft.widthAnchor.constraint(equalToConstant: batterConsistencyStudy),
                citrusCraft.heightAnchor.constraint(equalToConstant: batterConsistencyStudy)
            ])
            return citrusCraft
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: batterConsistencyStudy, height: batterConsistencyStudy))
        let glazeImage = renderer.image { _ in
            let colors = [
                UIColor(red: 0.25, green: 0.08, blue: 0.12, alpha: 1),
                UIColor(red: 0.95, green: 0.55, blue: 0.62, alpha: 1),
                UIColor(red: 0.76, green: 0.58, blue: 0.38, alpha: 1),
                UIColor(red: 0.5, green: 0.35, blue: 0.78, alpha: 1)
            ]
            colors[abs(syrupViscosityDetail.hashValue) % colors.count].setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: batterConsistencyStudy, height: batterConsistencyStudy)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: batterConsistencyStudy * 0.32, y: batterConsistencyStudy * 0.2, width: batterConsistencyStudy * 0.36, height: batterConsistencyStudy * 0.36)).fill()
            UIBezierPath(ovalIn: CGRect(x: batterConsistencyStudy * 0.22, y: batterConsistencyStudy * 0.57, width: batterConsistencyStudy * 0.56, height: batterConsistencyStudy * 0.27)).fill()
        }
        let wevvlineBurst = UIImageView(image: glazeImage)
        wevvlineBurst.translatesAutoresizingMaskIntoConstraints = false
        wevvlineBurst.contentMode = .scaleAspectFill
        wevvlineBurst.layer.cornerRadius = batterConsistencyStudy / 2
        wevvlineBurst.layer.borderWidth = 1
        wevvlineBurst.layer.borderColor = UIColor.white.cgColor
        wevvlineBurst.clipsToBounds = true
        NSLayoutConstraint.activate([
            wevvlineBurst.widthAnchor.constraint(equalToConstant: batterConsistencyStudy),
            wevvlineBurst.heightAnchor.constraint(equalToConstant: batterConsistencyStudy)
        ])
        return wevvlineBurst
    }

    private func makeglazeThicknessStudyLabel(_ text: String, sugarCrystallizationStudy: CGFloat, glazeThickness: UIFont.Weight, tarchGelatini: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: sugarCrystallizationStudy, weight: glazeThickness)
        crumbLabel.textColor = tarchGelatini
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.76
        return crumbLabel
    }

    private func doughMaturationDetail() {
        let joined = glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleJarKey)
        almondBench.setTitle(joined ? "Joined" : "JIo.i^nY bCqhsaql,lCebnMgreE".wevVPastryCrumbBloomRestored, for: .normal)
        almondBench.isEnabled = !joined
        almondBench.backgroundColor = joined ? UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1) : UIColor(red: 1, green: 0.94, blue: 1, alpha: 1)
    }

    @objc private func palateDepthNotes() {
        guard glazeSession.isTasterReady else {
            mouthfeelHarmonyInsight()
            return
        }
        guard !glazeSession.hasJoinedGlazeQuest(sprinkleChallenge.sprinkleJarKey) else {
            doughMaturationDetail()
            return
        }
        guard glazeSession.glazeGoldCount >= sprinkleChallenge.sprinkleDensityValue else {
            flavorIntensityNotes()
            return
        }
        almondBench.isEnabled = false
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.glazeVaultRepository.flourBlendDetail(self.sprinkleChallenge.sprinkleDensityValue)
                await MainActor.run {
                    AoVGlazeCrackleOverlay.showGlazeCrackle(in: self.view, note: "SZyMnxcCifnfgO HsEwZe;eUt= QdQahtuaO.@.&.x".wevVPastryCrumbBloomRestored) { [weak self] in
                        guard let self else { return }
                        self.glazeSession.placeJoinedGlazeQuest(self.sprinkleChallenge.sprinkleJarKey)
                        self.doughMaturationDetail()
                        self.cocoaDiarydonutChanged?()
                    }
                }
            } catch {
                await MainActor.run {
                    self.almondBench.isEnabled = true
                    TinGlazePromptStyler.showSugarToast(in: self.view, text: error.localizedDescription)
                }
            }
        }
    }

    private func mouthfeelHarmonyInsight() {
        let gate = UBakerytropicalMangoEssence()
        gate.onWevvDonutReady = { [weak self] in
            self?.dismiss(animated: true) {
                self?.doughMaturationDetail()
            }
        }
        gate.modalPresentationStyle = .pageSheet
        present(gate, animated: true)
    }

    private func flavorIntensityNotes() {
        let layer = makeChallengeDimLayer(alpha: 0.5)
        view.addSubview(layer)

        let pastryCard = makeGoldShortageCard()
        layer.addSubview(pastryCard)

        let wevvletterForm = UIImageView(image: UIImage.init(named: "ervoldgem"))
        wevvletterForm.translatesAutoresizingMaskIntoConstraints = false
        let glazeTitle = makeglazeThicknessStudyLabel("NSoCtz qeLnCosujgoh= sgloWlKdn".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 17, glazeThickness: .heavy, tarchGelatini: TinGlazePromptStyler.inkTone)
        glazeTitle.textAlignment = .center
        let crumbNote = makeglazeThicknessStudyLabel("Sorry, your donut vault is short.\nRecharge to join this sweet challenge.", sugarCrystallizationStudy: 12, glazeThickness: .semibold, tarchGelatini: TinGlazePromptStyler.mutedTone)
        crumbNote.textAlignment = .center
        crumbNote.numberOfLines = 2
        let wevv = OumMaplePillButton(title: "BGu;yq".wevVPastryCrumbBloomRestored)
        wevv.addTarget(self, action: #selector(openVaultFromPopup), for: .touchUpInside)
        pastryCard.addSubview(wevvletterForm)
        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(crumbNote)
        pastryCard.addSubview(wevv)

        pinGoldShortageLayer(layer: layer, pastryCard: pastryCard, gem: wevvletterForm, glazeTitle: glazeTitle, crumbNote: crumbNote, wevvfillPattern: wevv)
        dimLayer = layer
    }

    private func makeChallengeDimLayer(alpha: CGFloat) -> UIControl {
        let glazeLayer = UIControl()
        glazeLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeLayer.backgroundColor = UIColor(red: 0.12, green: 0.06, blue: 0.12, alpha: alpha)
        glazeLayer.addTarget(self, action: #selector(butterAromaNotes), for: .touchUpInside)
        return glazeLayer
    }

    private func makeGoldShortageCard() -> UIView {
        let pastryCard = UIView()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = TinGlazePromptStyler.creamTone
        pastryCard.layer.cornerRadius = 24
        pastryCard.layer.shadowColor = UIColor(red: 0.56, green: 0.05, blue: 0.28, alpha: 1).cgColor
        pastryCard.layer.shadowOpacity = 0.22
        pastryCard.layer.shadowRadius = 22
        pastryCard.layer.shadowOffset = CGSize(width: 0, height: 12)
        return pastryCard
    }

    private func pinGoldShortageLayer(layer: UIView, pastryCard: UIView, gem: UIImageView, glazeTitle: UILabel, crumbNote: UILabel, wevvfillPattern: UIView) {
        NSLayoutConstraint.activate([
            layer.topAnchor.constraint(equalTo: view.topAnchor),
            layer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pastryCard.centerXAnchor.constraint(equalTo: layer.centerXAnchor),
            pastryCard.centerYAnchor.constraint(equalTo: layer.centerYAnchor),
            pastryCard.widthAnchor.constraint(equalTo: layer.widthAnchor, multiplier: 0.68),
            pastryCard.widthAnchor.constraint(lessThanOrEqualToConstant: 294),
            pastryCard.heightAnchor.constraint(equalToConstant: 176),
            gem.centerXAnchor.constraint(equalTo: pastryCard.centerXAnchor),
            gem.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: -54),
            gem.widthAnchor.constraint(equalToConstant: 98),
            gem.heightAnchor.constraint(equalToConstant: 72),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 40),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 18),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            crumbNote.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 12),
            crumbNote.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor),
            wevvfillPattern.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 22),
            wevvfillPattern.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -22),
            wevvfillPattern.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -14),
            wevvfillPattern.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func crustSnapInsight() {
        let wevvstrokeWeightlayer = makePeopleDimLayer()
        view.addSubview(wevvstrokeWeightlayer)

        let sheet = makePeopleSheetPanel()
        wevvstrokeWeightlayer.addSubview(sheet)

        let glazeTitle = makeglazeThicknessStudyLabel("PfaProtdiucniMpkaMnYtf GLsi?sTtz".wevVPastryCrumbBloomRestored, sugarCrystallizationStudy: 13, glazeThickness: .heavy, tarchGelatini: .black)
        glazeTitle.textAlignment = .center
        let doughClose = makePeopleSheetCloseButton()
        let ringStack = makePeopleSheetStack()

        sheet.addSubview(glazeTitle)
        sheet.addSubview(doughClose)
        sheet.addSubview(ringStack)

        pinPeopleSheetLayer(            wevvsprayBloom: wevvstrokeWeightlayer, cocoaDepthNotes: sheet, glazeTitle: glazeTitle, doughClose: doughClose, ringStack: ringStack)
        dimLayer = wevvstrokeWeightlayer
    }

    private func makePeopleDimLayer() -> UIControl {
        let glazeLayer = UIControl()
        glazeLayer.translatesAutoresizingMaskIntoConstraints = false
        glazeLayer.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        glazeLayer.addTarget(self, action: #selector(butterAromaNotes), for: .touchUpInside)
        return glazeLayer
    }

    private func makePeopleSheetPanel() -> UIView {
        let fillingSilkNotes = UIView()
        fillingSilkNotes.translatesAutoresizingMaskIntoConstraints = false
        fillingSilkNotes.backgroundColor = .white
        fillingSilkNotes.layer.cornerRadius = 16
        fillingSilkNotes.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return fillingSilkNotes
    }

    private func makePeopleSheetCloseButton() -> UIButton {
        let doughClose = UIButton(type: .system)
        doughClose.translatesAutoresizingMaskIntoConstraints = false
        doughClose.setImage(UIImage(systemName: "xmark"), for: .normal)
        doughClose.tintColor = .black
        doughClose.addTarget(self, action: #selector(butterAromaNotes), for: .touchUpInside)
        return doughClose
    }

    private func makePeopleSheetStack() -> UIStackView {
        let citrusBrightnessInsight = UIStackView()
        citrusBrightnessInsight.translatesAutoresizingMaskIntoConstraints = false
        citrusBrightnessInsight.axis = .vertical
        citrusBrightnessInsight.spacing = 18
        for tasterBadgeKey in frostingGuestKeys {
            citrusBrightnessInsight.addArrangedSubview(makePersonRow(profile: guestStore.profile(for: tasterBadgeKey)))
        }
        return citrusBrightnessInsight
    }

    private func pinPeopleSheetLayer(            wevvsprayBloom: UIView, cocoaDepthNotes: UIView, glazeTitle: UILabel, doughClose: UIButton, ringStack: UIStackView) {
        NSLayoutConstraint.activate([
                        wevvsprayBloom.topAnchor.constraint(equalTo: view.topAnchor),
                        wevvsprayBloom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        wevvsprayBloom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        wevvsprayBloom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cocoaDepthNotes.leadingAnchor.constraint(equalTo:             wevvsprayBloom.leadingAnchor),
            cocoaDepthNotes.trailingAnchor.constraint(equalTo:             wevvsprayBloom.trailingAnchor),
            cocoaDepthNotes.bottomAnchor.constraint(equalTo:             wevvsprayBloom.bottomAnchor),
            cocoaDepthNotes.heightAnchor.constraint(equalTo:             wevvsprayBloom.heightAnchor, multiplier: 0.45),
            glazeTitle.topAnchor.constraint(equalTo: cocoaDepthNotes.topAnchor, constant: 16),
            glazeTitle.centerXAnchor.constraint(equalTo: cocoaDepthNotes.centerXAnchor),
            doughClose.centerYAnchor.constraint(equalTo: glazeTitle.centerYAnchor),
            doughClose.trailingAnchor.constraint(equalTo: cocoaDepthNotes.trailingAnchor, constant: -14),
            doughClose.widthAnchor.constraint(equalToConstant: 32),
            doughClose.heightAnchor.constraint(equalToConstant: 32),
            ringStack.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 22),
            ringStack.leadingAnchor.constraint(equalTo: cocoaDepthNotes.leadingAnchor, constant: 34),
            ringStack.trailingAnchor.constraint(equalTo: cocoaDepthNotes.trailingAnchor, constant: -34)
        ])
    }

    private func makePersonRow(profile: WevVGuestGlazeProfile) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.addAction(UIAction { [weak self] _ in
            self?.openPersonProfile(tasterBadgeKey: profile.donutPinKey)
        }, for: .touchUpInside)
        let floralLiftNotes = doughMaturationStudy(syrupViscosityDetail: profile.donutPinKey, batterConsistencyStudy: 42)
        let crumbLabel = makeglazeThicknessStudyLabel(profile.cocoaCounter, sugarCrystallizationStudy: 13, glazeThickness: .heavy, tarchGelatini: .black)
        donutRow.addSubview(floralLiftNotes)
        donutRow.addSubview(crumbLabel)
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 44),
            floralLiftNotes.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor),
            floralLiftNotes.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            floralLiftNotes.widthAnchor.constraint(equalToConstant: 42),
            floralLiftNotes.heightAnchor.constraint(equalToConstant: 42),
            crumbLabel.leadingAnchor.constraint(equalTo: floralLiftNotes.trailingAnchor, constant: 16),
            crumbLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor)
        ])
        return donutRow
    }

    @objc private func openVaultFromPopup() {
        butterAromaNotes()
        let nuttyFinishInsight = GDonutdenCrumbCenterler()
        nuttyFinishInsight.silkyCenter = { [weak self] in
            self?.cocoaDiarydonutChanged?()
        }
        nuttyFinishInsight.modalPresentationStyle = .fullScreen
        present(nuttyFinishInsight, animated: true)
    }

    private func openPersonProfile(tasterBadgeKey: String) {
        butterAromaNotes()
        let controller = LmnTasterCardController(tasterBadgeKey: tasterBadgeKey)
        present(controller, animated: true)
    }

    @objc private func butterAromaNotes() {
        dimLayer?.removeFromSuperview()
        dimLayer = nil
    }

    @objc private func pastryFreshnessInsight() {
        dismiss(animated: true)
    }
}
