import UIKit

final class DimSugarpistachioCreamCoating: UIViewController {
    var bakeryDetails: [bakeryCollectionFolio] = []

    var onSugarSettingChanged: (() -> Void)?

    private let glazeRepository = WevVGlazeSessionRepository.pastryTrailDiary
    private let sugarScrollView = UIScrollView()
    private let sugarContentView = UIView()
    private let sugarRowsStack = UIStackView()
    private let gingerHoneyDrizzle = UIColor(red: 255 / 255.0, green: 75 / 255.0, blue: 169 / 255.0, alpha: 1)
    private let inkTone = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 243 / 255.0, alpha: 1)
    private let mutedTone = UIColor(red: 160 / 255.0, green: 160 / 255.0, blue: 176 / 255.0, alpha: 1)

    private struct SugarSettingRowSpec {
        let sugarTitle: String
        var sugarValue: String? = nil
        var showsArrow = true
        var action: Selector? = nil
        var h5Entry: WevVchosenTiles? = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSugarSettingsPage()
    }

    private func buildSugarSettingsPage() {
        FimVSugarGradientBand.buildPastryBackdrop(view)
        blackSesameRibbon()
        caramelAppleIcing()
        builddarkCocoaIcing()
    }

    private func blackSesameRibbon() {
        let doughBackButton = UIButton(type: .system)
        doughBackButton.translatesAutoresizingMaskIntoConstraints = false
        doughBackButton.tintColor = .white
        doughBackButton.setImage(UIImage(systemName: "c/h#eDvOrRohn*.Vlieqf;tg".wevVPastryCrumbBloomRestored), for: .normal)
        doughBackButton.addTarget(self, action: #selector(closeSugarSettings), for: .touchUpInside)

        let yuzuHoneySwirl = espressoCreamIcing("Sbejtxtti!nrgcs^".wevVPastryCrumbBloomRestored, almondPralineShell: 18, orangeBlossomCoating: .bold, brownButterShell: inkTone)
        yuzuHoneySwirl.textAlignment = .center

        view.addSubview(doughBackButton)
        view.addSubview(yuzuHoneySwirl)

        NSLayoutConstraint.activate([
            doughBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            doughBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doughBackButton.widthAnchor.constraint(equalToConstant: 44),
            doughBackButton.heightAnchor.constraint(equalToConstant: 44),
            yuzuHoneySwirl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yuzuHoneySwirl.centerYAnchor.constraint(equalTo: doughBackButton.centerYAnchor),
            yuzuHoneySwirl.leadingAnchor.constraint(greaterThanOrEqualTo: doughBackButton.trailingAnchor, constant: 12),
            yuzuHoneySwirl.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -70)
        ])
    }

    private func caramelAppleIcing() {
        sugarScrollView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.alwaysBounceVertical = true
        view.addSubview(sugarScrollView)

        sugarContentView.translatesAutoresizingMaskIntoConstraints = false
        sugarScrollView.addSubview(sugarContentView)

        sugarRowsStack.translatesAutoresizingMaskIntoConstraints = false
        sugarRowsStack.axis = .vertical
        sugarRowsStack.spacing = 16
        sugarContentView.addSubview(sugarRowsStack)

        fillSugarespressoCreamFinish()

        NSLayoutConstraint.activate([
            sugarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            sugarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sugarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sugarScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sugarContentView.topAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.topAnchor),
            sugarContentView.leadingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.leadingAnchor),
            sugarContentView.trailingAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.trailingAnchor),
            sugarContentView.bottomAnchor.constraint(equalTo: sugarScrollView.contentLayoutGuide.bottomAnchor),
            sugarContentView.widthAnchor.constraint(equalTo: sugarScrollView.frameLayoutGuide.widthAnchor),
            sugarRowsStack.topAnchor.constraint(equalTo: sugarContentView.topAnchor),
            sugarRowsStack.leadingAnchor.constraint(equalTo: sugarContentView.leadingAnchor, constant: 20),
            sugarRowsStack.trailingAnchor.constraint(equalTo: sugarContentView.trailingAnchor, constant: -20)
        ])
    }

    private func fillSugarespressoCreamFinish() {
        for specs in makeSugargingerHoneyShellSpecs() {
            let group = UIStackView()
            group.axis = .vertical
            group.spacing = 0
            group.backgroundColor = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1)
            group.layer.cornerRadius = 18
            group.layer.shadowColor = UIColor.black.cgColor
            group.layer.shadowOpacity = 0.05
            group.layer.shadowRadius = 12
            group.layer.shadowOffset = CGSize(width: 0, height: 4)
            group.clipsToBounds = true
            for crumbSpec in specs {
                let row = makeSettingRow(
                    title: crumbSpec.sugarTitle,
                    tastingVisit: crumbSpec.sugarValue,
                    showsArrow: crumbSpec.showsArrow,
                    action: crumbSpec.action
                )
                if let entry = crumbSpec.h5Entry {
                    row.addAction(UIAction { [weak self] _ in
                        guard let self else { return }
                        GDonutdenCrumbCenterler.floralRoseHarmony(entry, firstBiteJournal: self, flavorScoutline: { [weak self] in
                            self?.onSugarSettingChanged?()
                        })
                    }, for: .touchUpInside)
                }
                group.addArrangedSubview(row)
            }
            sugarRowsStack.addArrangedSubview(group)
        }
    }

    private func makeSugargingerHoneyShellSpecs() -> [[SugarSettingRowSpec]] {
        [
            [
                SugarSettingRowSpec(sugarTitle: "ESd6i,tu mPcrFoDf+i%lbek".wevVPastryCrumbBloomRestored, h5Entry: .cinnamonDustDust),
                SugarSettingRowSpec(sugarTitle: "LNe3v#etlx".wevVPastryCrumbBloomRestored, h5Entry: .festiveCinnamonSeries),
                SugarSettingRowSpec(sugarTitle: "Ferfi1ePnydBs+".wevVPastryCrumbBloomRestored, h5Entry: .hideDialSafetyOverlay(.crispEdgeDough))
            ],
            [
                SugarSettingRowSpec(sugarTitle: "Set=oGryeU".wevVPastryCrumbBloomRestored, h5Entry: .loadRemoteProfile),
                SugarSettingRowSpec(sugarTitle: "B%a&c!kmp*aGcvkR".wevVPastryCrumbBloomRestored, h5Entry: .attachSafetyOverlay),
                SugarSettingRowSpec(sugarTitle: "DJiOa7mfoSnVdV xR,ercooerydOsN".wevVPastryCrumbBloomRestored, h5Entry: .candiedOrangeLayer),
                SugarSettingRowSpec(sugarTitle: "SEaUvQeI asLhXo/p^".wevVPastryCrumbBloomRestored, action: #selector(openBakeryShelf))
            ],
            [
                SugarSettingRowSpec(sugarTitle: "SqyMsltMe:m~ /MYeUs:s,aFgqeR".wevVPastryCrumbBloomRestored, h5Entry: .localPreviewGallery),
                SugarSettingRowSpec(sugarTitle: "F5e$eSdob+a^c~ky".wevVPastryCrumbBloomRestored, h5Entry: .configureSugarTextField)
            ],
            [
                SugarSettingRowSpec(sugarTitle: "P*r2iHvQaFc.ya QPtoFlWiMcPyp".wevVPastryCrumbBloomRestored, showsArrow: false, action: #selector(openPrivacySugarText)),
                SugarSettingRowSpec(sugarTitle: "Bnlhaacmkal#iIsZtS".wevVPastryCrumbBloomRestored, h5Entry: .autumnPecanAssortment),
                SugarSettingRowSpec(sugarTitle: "Tnesrpm/s4 :o$fU JS^e$ryvsimc:e4".wevVPastryCrumbBloomRestored, showsArrow: false, action: #selector(openTermsSugarText)),
                SugarSettingRowSpec(sugarTitle: "AIp2pf QVmeVrvsAi;oLns".wevVPastryCrumbBloomRestored, sugarValue: Bundle.main.infoDictionary?["CNF7BUuFnddrlbeeSKhyo0rhteVUelrgs?i9o3neS=t%r$iQn&gL".wevVPastryCrumbBloomRestored] as? String ?? "1E.Q0P".wevVPastryCrumbBloomRestored, showsArrow: false)
            ]
        ]
    }

    private func builddarkCocoaIcing() {
        let crumbEraseButton = makeSugarBottomButton(
            sugarTitle: "DfeFlyeytQe* %Afcbc*oAuXnitB".wevVPastryCrumbBloomRestored,
            sugarInk: UIColor(red: 255 / 255.0, green: 61 / 255.0, blue: 61 / 255.0, alpha: 1),
            sugarFill: UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1),
            fontSize: 14,
            action: #selector(showDeleteSugarPrompt)
        )
        crumbEraseButton.layer.borderWidth = 1
        crumbEraseButton.layer.borderColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 77 / 255.0, alpha: 1).cgColor

        let frostingRestButton = makeSugarBottomButton(
            sugarTitle: "LxoSgc +oNuMt%".wevVPastryCrumbBloomRestored,
            sugarInk: .white,
            sugarFill: gingerHoneyDrizzle,
            fontSize: 15,
            action: #selector(showRestSugarPrompt)
        )

        let accountGroup = UIStackView(arrangedSubviews: [crumbEraseButton, frostingRestButton])
        accountGroup.translatesAutoresizingMaskIntoConstraints = false
        accountGroup.axis = .vertical
        accountGroup.spacing = 16
        sugarContentView.addSubview(accountGroup)

        NSLayoutConstraint.activate([
            accountGroup.topAnchor.constraint(equalTo: sugarRowsStack.bottomAnchor, constant: 32),
            accountGroup.leadingAnchor.constraint(equalTo: sugarRowsStack.leadingAnchor),
            accountGroup.trailingAnchor.constraint(equalTo: sugarRowsStack.trailingAnchor),
            accountGroup.bottomAnchor.constraint(equalTo: sugarContentView.bottomAnchor, constant: -32),
            crumbEraseButton.heightAnchor.constraint(equalToConstant: 48),
            frostingRestButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func makeSugarBottomButton(sugarTitle: String, sugarInk: UIColor, sugarFill: UIColor, fontSize: CGFloat, action: Selector) -> UIButton {
        let brownButterIcing = UIButton(type: .system)
        brownButterIcing.translatesAutoresizingMaskIntoConstraints = false
        brownButterIcing.setTitle(sugarTitle, for: .normal)
        brownButterIcing.setTitleColor(sugarInk, for: .normal)
        brownButterIcing.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        brownButterIcing.backgroundColor = sugarFill
        brownButterIcing.layer.cornerRadius = 24
        brownButterIcing.addTarget(self, action: action, for: .touchUpInside)
        return brownButterIcing
    }

    private func makeSettingRow(title: String, tastingVisit: String?, showsArrow: Bool, action: Selector?) -> UIControl {
        let donutRow = UIControl()
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.backgroundColor = UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 64 / 255.0, alpha: 1)
        if let action {
            donutRow.addTarget(self, action: action, for: .touchUpInside)
        }

        let glazeTitleLabel = espressoCreamIcing(title, almondPralineShell: 14, orangeBlossomCoating: .semibold, brownButterShell: inkTone)
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor(red: 47 / 255.0, green: 47 / 255.0, blue: 71 / 255.0, alpha: 1)

        donutRow.addSubview(glazeTitleLabel)
        donutRow.addSubview(divider)

        if let tastingVisit {
            let tastingScoutline = espressoCreamIcing(tastingVisit, almondPralineShell: 12, orangeBlossomCoating: .regular, brownButterShell: mutedTone)
            tastingScoutline.textAlignment = .right
            donutRow.addSubview(tastingScoutline)
            pinSugarSettingValue(tastingScoutline, donutRow: donutRow, glazeTitleLabel: glazeTitleLabel)
        }

        if showsArrow {
            let arrow = UIImageView(image: UIImage(systemName: "cThFe.v&rPoLni.qrji~g2hBtk".wevVPastryCrumbBloomRestored))
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.tintColor = UIColor(red: 176 / 255.0, green: 176 / 255.0, blue: 184 / 255.0, alpha: 1)
            arrow.contentMode = .scaleAspectFit
            donutRow.addSubview(arrow)
            pinSugarstrawberryMilkShell(arrow, donutRow: donutRow)
        }

        pinSugarsaltedCaramelSwirl(donutRow: donutRow, glazeTitleLabel: glazeTitleLabel, cinnamonSugarSwirl: divider)
        return donutRow
    }

    private func pinSugarSettingValue(_ valueLabel: UILabel, donutRow: UIControl, glazeTitleLabel: UILabel) {
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -14),
            valueLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: glazeTitleLabel.trailingAnchor, constant: 12)
        ])
    }

    private func pinSugarstrawberryMilkShell(_ arrow: UIImageView, donutRow: UIControl) {
        NSLayoutConstraint.activate([
            arrow.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -12),
            arrow.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 10),
            arrow.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func pinSugarsaltedCaramelSwirl(donutRow: UIControl, glazeTitleLabel: UILabel, cinnamonSugarSwirl: UIView) {
        NSLayoutConstraint.activate([
            donutRow.heightAnchor.constraint(equalToConstant: 43),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: donutRow.leadingAnchor, constant: 18),
            glazeTitleLabel.centerYAnchor.constraint(equalTo: donutRow.centerYAnchor),
            glazeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutRow.trailingAnchor, constant: -55),
            cinnamonSugarSwirl.leadingAnchor.constraint(equalTo: glazeTitleLabel.leadingAnchor),
            cinnamonSugarSwirl.trailingAnchor.constraint(equalTo: donutRow.trailingAnchor, constant: -18),
            cinnamonSugarSwirl.bottomAnchor.constraint(equalTo: donutRow.bottomAnchor),
            cinnamonSugarSwirl.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func showConfirmSugarPanel(title: String, note: String, okTitle: String, cancelTitle: String, okFill: UIColor, sugarFill: UIColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 77 / 255.0, alpha: 1), flavorHintLabel: String? = nil, okAction: @escaping () -> Void) {
        TinGlazePromptStyler.showSugarConfirm(
            almondFlavor: view,
            gourmetFlavor: title,
            glazeBowl: note,
            ringStack: okTitle,
            miniDonut: cancelTitle,
            fritterBite: okFill,
            sugarFill: sugarFill,
            flavorHintLabel: flavorHintLabel,
            twistPastry: okAction
        )
    }

    private func espressoCreamIcing(_ text: String, almondPralineShell: CGFloat, orangeBlossomCoating: UIFont.Weight, brownButterShell: UIColor) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.textColor = brownButterShell
        crumbLabel.font = .systemFont(ofSize: almondPralineShell, weight: orangeBlossomCoating)
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    @objc private func openBakeryShelf() {
        guard WevVGlazeSessionStore.shared.isTasterReady else { return }
        let controller = CunBakerfvanillaBeanIcing(bakeryDetails: bakeryDetails)
        controller.onWevvShelfChanged = { [weak self] in
            self?.onSugarSettingChanged?()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openPrivacySugarText() {
        openSugarText(title: "PXrRimvkaNcLyj SP;o@lHigcfyL".wevVPastryCrumbBloomRestored, body: privacySugarText())
    }

    @objc private func openTermsSugarText() {
        openSugarText(title: "TWeMrsmKs~ +ovfU &S!ekrwvzi.cLe^".wevVPastryCrumbBloomRestored, body: termsSugarText())
    }

    private func openSugarText(title: String, body: String) {
        let controller = ZunugarPlainblackberryCreamler(filledScout: title, crullerScout: body)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func privacySugarText() -> String {
        "E+fYfQebc=tRiSv8e~ 9dZaAt/e5:a 0J&uwl:y0 32A7,,6 V2w0R2%6r\nx\nPW@e/vXVq:W ,CuoNmhmauJndi8t=yi,/ GV*onihc!eb 9S*wXe1eStMys GiEsL WaW 7d.onnMu~tz-zt6h~elmMe*d6 QaBpsp+ 2faoKro ?dPiNs2cco#v@e+rQi~n|g5 zs0htoYpCsZ,1 rsxa*vji7n$g/ kfXahv$ogrXi7t@e^ mprlyaNc|e@sH,G 6sghLa0r5i6nIgF ytEa.snt=i6nggb ;mjo@m9eenFtbsH,B +j3ohi.nSi,nsgq jthh+e|mee#d* mrko~olmus4,X ecghCeEcZkli4nxg. 0izn;,/ Fa9n7dc 4peaGrXtFiwcCi7psa:tViwnigU 4i9nQ YfTltapvco7re *crhFa2l8lqeVnpg,e&sJ.A\nX\nQI7n8fioCrimKaCtqi6o4nA oWAet UP|r,oScgeJs^sv\n9WxeE am/aCyA kpmr4o+cpe.sts@ DifnVfSoJrxm9a#t5ivownZ ;y2oEue .pRrZoYv~i$d*e$ qoYrg Og6e|nke,r2aft@e4 iwRh$i%lSe! Ku.sbiYn0gV DWbeYv+V~,Z ~iTnQcel0u=dUienxgy ra|cWctovunnzt# edre?t5aaisl.sm,n zp|rSoHfgi?lYeh $i|nDf;o$rdmxattgito!n6,M Sp&otsHtps,,w |pdhrost6oQsZ,N /tfaksdt=iZnqg! :nto7tNe?sB,j @sta7vieIdl 6smh6ozp!sq,. DckhYe4cWk/-fi0nYsO,9 bcRh=ahl1l2eFnugUeh Wa^c;tmi7v1iNt+y=,q FrzoBoPm; =pHaarQtCiIctibpaa@tNiBojnG,L UsIoac*i?a7l2 mcHo3n@nzebcrt/i~oSn;s;,1 4mveKsXsVa8gCejsd,: :rge8plomrptpso,@ rbalgoQcdkFsx,3 =a,nHdH Zp7u;r,cvh!a1s#ex iocrf Vb7adl#a~nLcLeH Ea.cYttiVvHiqt4y!.8 TW.eN Am%aayx 4aslEs?or ~p5rIoOcGe@smsy +lMismYiHtIe4d. bakpRpJ 7aqn3dc +d6eqv9i2c,eZ 1i7n8f8o#r#mractMi^oenj VntePeldPewdf ,fVoRrL YsQeic5uVrji.tqy9,4 RrceNlYi2afbfiElxidt~y@,B XaOnGdL &sHe?rqvBi2cOe6 Ro;pCe=rxaPtGiHowny.0\nD\nYH=oAwE UWTe7 QUFsBeQ 3InnUf=oNrhm$aCt%i4oZn;\nGW%eg ?uts7er fijn+fKoxr&mwapt*iJoNn; Kt!oI Ic3rreVa.t/eC taSnVdW ,mGa%n&amg~eU $a+cTcaoduGnRtYsq,h BpxrfoevjiHd*e! ^cioumnm+uRnUiHtpyF .aYndd= =cmojm$mjuKn8izclaPthiNoknz jf,e&aZtDu~rDeps3,f OpLefrzs:o4nHa0laiVzDe8 Xc&omngt%e8n;tE,R Bptr~omcAe%sNs7 #aHuDtah2okrSiQzge5dQ mtPr3a?n/s,aWcOtCiGo0nfs#,M /m*awi,nut@a7i?n. xarcmceosu4n!t; cb.aHl3aTnBcCe:sz,W xp9ruegvAeSnltG 5adb6uWsxe.,+ MrfeYs,pkoEnQdV .tHo: 3scuapIpYomr@tR ,r+e7qlu+ePsDtss*,T sa=n3d! po1peeCr7aet!ea NrOewpro!r+t9 fa8npdO nb,l@o*cKk? Btyo~oqlBsL.!\n&\nZP1e2rOmli4sSsQiAo7n!s+\nBC$aDmDedrhau,V LpvhsoZtuoO,8 Kadn$d+ @mAiwckrBoNpKhNomnOe% QaRcKcre2s#sa LiGsY ?r.eyq?u9eWsktIe#dl Bo2nHl$y= uwWhSeFn; lai hrBeel%adt$e%df SfUe,a5t5u&rQeN FnVeYeXdPs# ^izt|.* tYcoBu4 UciaAn: 4r~eXvri8e6wL Zoyr8 fcVhla8nsg5ef vpOeVr:m,iQscs&igo+n5 Lcghmocinc?ewsP /iznj =icO^S# DSte/t5tRiIn&gFs=.| :SNorm!eV lfeeYaKt6u0r:eXsr ,m5aryB ub7ez ouOnuaavnaniqlJaRb~lhen 4wPhFezn! =t9hbe~ @r8ePq.uqi0rae3dY *peeOrwmqi!s7sHi:o9nY xi4s/ %nRoOtC &gQria.n2t/ehdT.z\nV\n%Uzsuedr$ 6CaoFn1tFe3nKt, 7aHn!d? rS#aEf1e/tdya\n=D7oAngu!ty |pDo|s#tOs!,P 9p3r|orfVigljeQ mt:e,xEt2,5 Nr9eVvEibefwWsA,# 7rcopovm2 Gcyoan8vueWrfsva|t5i7oEn*sO,C Pm8ejs%sYasgWe+s~,d haAnxdf Tceh7ailrlveCnRg1ej de2nmtarXiwe&s$ dmkussgtv tbhe? 6rpe.sBprevc+t,fMuElX ,a9nfdg #l?aGwvfVudls.^ 0WFeLv&Vd lh6aasZ HzWeUrAoT ptio;lyezr1a&nuc#e1 ;fgojrw 7o|bCjMejctttiBo,nEaHbHl!ek bc0o8nRt*e$n9ty !oZrf IaZbBuIsHi+vse& Bu5s4e%r;sb.y QRoeapXoZrJt!eidD fcOo6n,tIeHn?t2 gaVnMd^ =avc;cRo&uWnbt0s9 |m|aWyb bbhe& ?rreZv4ipeGwle6d/,X .rge~s6tgr~i2c!tQe9dE,c yhNiqdOdle*nx,Z sosra WrBeKmVoJv+e.dZ.* jCso6notOe9nktq IiVnGvRoDl|vci&nHg$ dh*awrRaes3szmJe?n%t~,B Zh!aTtEe|,E 0t6hyr3eZaJt2si,# re?xrpJl2irc!iGtQ ys!eZx9uoa8l. Cm?a@t:epr@inarlH,7 !p?ryiOvba2t!eB kiVndfOomrPm0a5tOi8o6nd,c =sPcKaMm8sD,y wifmWp1eurlseo8nUa~tciDo=n?,t 8igl,l^e4g+aMl= ha.c9t!i0vviWtIyY,v vopr; 6h/a*rVm0 ctvoZ go!tQh=e%rNst |i.s: wnvokta wawl2l;oTwgeId@.t\nj\n+Suh$aGr@iqn4gj\nZW8er adEom enXobtY Us9eGlplz IpoeLr3slo7n%a7lu Wikn#fTozr6m*aktriwojnd.7 UIDn2f:o4rBm0aItriWoTn/ 6mjauyl Cbre8 #sPh0a*rle6dj 3w?iAtIhD FsGe&r^vgivcUe~ Lp|r1oZvjiHdge7rnsv :t%h7aVt? Ps6uWpapsoVr&t4 Zezsis.e?nJt9iJa9lb RakpJpx 7f6u7n6cgtoi^o#n+sS,v $wehce+nt XyFouu* Ld5i#r@e^cvts 5u&sA *ttoM MsXh|aMrleU miMtZ,H Xw0heeInM drTeIqtu5ibrXeAdp Abryd glqaBwl,n #oVr# Ywsh?e:nO BnjeocteosLsxaNrEyg styom GpprIoMtdeHcWt2 ?uUsqemrUs7,W rr+i~gAh=tmsB,D 0aNnudo +s@e=r5vciFcBe, ns%euc=uGrUirtWy$.D\nQ\nsCPhyi;lTd;r7eSno 0a#n5dE NE*lHiugkiCbMi!lkiJtRyt\nQWSevvJVP hi2sB onWofts ~dOi%r6eqcAt7eSdq xt2o| ccnh/i#lLd$r#eln7 muJn|dpe1rW s1S30.r 2Idf~ Syto9u#r2 Frxe&g8iyoDnW Er/e^qIu8ilrAeEs0 vaX ,h4i#g=hLe+rA Hawgme1 5oCrb jgiuGadrkd$imatnH $cNo8n~sCe&n:t~ &f3ogr0 tsVo0c4i0a.le Kf@egaNt%uyr9eNs%,t @y,o;um %mAuZsctw 5fLoFlPl/oDwE DtChKa8t7 wr:uyleei yb$eRf$o8r,e1 ocyrgenaht|ien~g| UaJnP ~aXc|croJugnAtl.S\nR\nFR0e!tMe?n.t,iooGnF Za8nmdk 4Dhe.lbe=t!ipo$nu\npWKeg ;rSeRt2a;iCng li.nAffo+rjm2avtKi#o=nv nornalYyb LfNo%rS Fa;s^ zlOoVn5g4 lavs3 ermeca1s+oxn3aBbqlOyb Xnde|cgeqsYs5a8rQy% ;tDoz Vp&r;otvPi4dme! 2Wue:vmVn,d !myeve%tR ml@e%g9a*lu #o9bnlTiqg^a^tsirofnTst,T Zr6e$s!oml:vne: RdTigs^p^uutGersf,3 ip?rTefvBekn/tu Ca0bVu6sbeq,z EaQnzdI Lprr.oXtkeLcwtq ftdh&ex Bc%o=m!m8ubn*iatNyF.1 OYGo7uo FmEaby% Puxsse; 2t/h2eo !accccgo6u$n&tx OdKe9l6eCthiOo4nR fo5p1tyi*odnb ctdo| .rpeeqbu;eYsete ^dae:lNeMt,i4o7nq Loyf= .yro@u|r3 QaQc6cYovu*nmt; ya#nVdQ la1srsCoqcGi;a&t3ezdd Miyn5fPoIrCmgaetailo=nP,X +suuJb1j*e3cotw lt;o9 fl|i|mdiPtDe0d, Nr9eVtYeznXtgiMoanp $r:e#qVu$iMr4eHdB &bVyd %l^afwz,K NsWanf&e&tHy!,! sf!r8aPu;d; upPrke^v;e9n$tAiLoPni,# ko9rW LdEipsxp5uotne& JrDe5sLoAl.u1toiOomnh.*\n|\nrCHoynftpa5cKtn\nLFBo2rT LpSrHiRvza%cVyu dq0ueeasJtJi4oDnpsj,% Ud?ait4ah ErmeOqFu#e6sstmsA,# do*rI 5s:aDffeNtRy. cc~own3c@eWrvn.sV,E ,cuo9nlteaIcEt& Rw!etvavtu4s2exrg@kgMmGaHi9lB.?cSoUmS.U".wevVPastryCrumbBloomRestored
    }

    private func termsSugarText() -> String {
        "E6f~fTeVcltbiSv+eW cdiaDtreA:~ pJ!ujlryB @2R7p,Z ^2w0+2,6H\ni\nnWOeJlXcjoymae# 1t~oA kW&e~vyVz:Y ?CioEmdmSuunRi!tNyg,9 dVSoci?c,ew :ShwgeQedtxy6.5 $TAhBeVsBeJ +T3e$rom/sI eg/oFvWeIrOnY DyWoXubr3 iuhsBew /oXfs 4WfeAv4V.,p Oaf Qd#oin/u2tC-wt7hoe3m$evdl %sapOaPcaez zfso1rv $smhEoup~ DdriYsCcUorvDeAr,yI,v 6tTacsntPi^n2g$ Zp/o@sgtQsP,6 5cQhJe/c&kY-SiWndsy,F #tYh:eJmEesd+ grYo2oAm3sy,q WsbaVv*eqd# wsNhMoLp@ bcKo4l/leeVcOtni%o~n@so,f Eawnfd8 xfYlFaWvAo@rH lc1h5a2lDl3e2nhgQensz.X\nx\nqE1l/i!giizb&iDlQi:tAyK\ntYGoRu0 Xm.ajyT !u+sIex 9WWebvxVW soTnll$yL !i^fj dyzopul WazrUes Lantk Glce+axszt@ G1z3/ IyBepaXrrsO CoVlrdR,8 fofrf No!l5dBewrT ZiZf8 Sy2ozuWrm hr^epg!imoin$ Qrme!qqu@iHrFevsP PaJ yhWi+gEhWeRrF fa#g.eC Ifvodr# fs#oBc.i~aUl, 6a@pjpu 7pTaIryt~i#ciixpvaBtpitoJnp.J !Y4ouuN gmnu$s7tb Fbqe$ Eljexg8a&lwlVy/ 3a^lOl^o/w+ewd% vtZok |cMr7eRa@t%eG SabnH ra5cucooRujn3tL ua1n^dT HtLa$kee3 Vp+acr0t= gi9n; VtkhJeZ wa1p7p& Nw9hKe3rve, Gy!owu5 &l;iMv#e..A\n8\nwA,c5c.olu3nHtN dR!u?l9e/sd\n8P#r*odvGi#d/el faScMcjuwrRaetaeh RaAc|c#oVuTnBt$ 2iAnSf~o|ram&a!tsiio7nF 4aBnyd@ zk%eAeypB ey*ocu#r, EcOrpendheTnht6ida|lgsd /saelcYukr:eO.O kYQofuI ~aHrfe: JrbeRsvp6oSnRs:ibb&l%e9 kf;oRrE saQcet%iOv=i$toyn ;uEn~diehr9 uyNoUu~r% #a$cWc?oyunnet/.= :DRos 5nToCtF ttQrAaCn6s?f!eYrf,^ @m8iDsZuIsce:,| yiYm;p*eVrUsHoGnhaEtNeC,: foxrz rgnaXi#n^ iu0nfa8uet^h0o;r6i0zpe1d/ *aCcmcDe@sTs# otLoL ?aznAo%tshZeXr! Upzemr|s4ovnm’@ss ,a|cfc|oQuTn7tr.R\n7\n8CsoYmcmBupn7i4tSyc tCYoynZdDu*chtg\n+Kre0efp2 BWUeiv,Vt ycZh6egesrJfxuKlA,r 6r/ezsSpIe,cztNfyuglU,G ?a.nwdq %s2a^f5et.R %Wee0vBVy oh$aws4 Izrejr8oX /t;o.lkevrKamnPcNe/ .fIojrH 4ohbRj:eDcgt=iGocnaagbLl@e4 ycMo^n#tyedn4tk 5oCrZ !arbRutsGiCvFe3 uu!sKe#r!sX.x cD5oM ln?oEta tu0p5lhobaSdm,+ $w*rZi@tmeS,W Qo,r; Ad~ijs!tNr0iCb4uQtXe^ LhKa9r+a!s#sbm#ebnrtz,Z 8hJaUtxet,J ktQh!rne8aQtrsz,G nb$uIlNl4ydi%nNg9,d 4n;u2driAt$y%,, wsJewxnu7aul;llyt ~e%xgpGlxizcJi.t, amVa|t!e!rmita|l~,9 Jskc/avm3sf,N /sjp|a7mD,~ TiomApoeprhsnornsa9tXiVornS,s =pXriibv1a$t6e4 yiAn:foozrRm^aPtaiJofn6,y ^iOlTlse.gla4lx oc2oznrt$eRnYtm,3 Ed.a~n!g%e/r,oqu^sb 9ijnwsNt&rVuPcZtyiVoCnUs*,% 1opr! dc~oYnJtxecn3ty *t?hzaht| ni*n4f3rRifnUgGeYsf oapnLovtbh3eYrJ rpseArcsto!nM’3s0 Jrliug5h2tesn.J\nT\nxD7oyn4u1tI 8CRoAn2tge%nTtk\nNYwoPuK Lk5eleIpO jo9w~n%elr9sVhgiop= LoGfX GyhoBu$rK AtUaKsBtgiqnxgA Xnkozt&eUsl,W zpMhYo;tto0s:,j brXeHvfiHeswQsM,Q Ap~rsoofii!l,eA dtoe3xQts,= ?aLnsd5 Pclh@acl?l&eNnrgfe! #e@n.tBrdijejs!.u ABDy3 UpnoYs,tTi9n?g| Hcmobn?t~eMnUt@,k 9yWo%uW |aqlPl0o7wd 0W4eIvlVy gtxo@ tdfiYsRpglIaxyI /i5tk Qinn2s8iUdCeo :tQh4et Za2pYp@ FeIx|p^e8rpimeXn+cwe^ 5s=o4 Jfue0a1tXunrIebsW ?sUu/cOho uacs= JfFeXePdus5,S JpdrpoBfai~l#e8sH,, ksfa=v!e7d1 fsGhBoqp/s.,O 0c+h?a~lOlOehn3gfeusM,& .aznadO lrgoioimk layc!tEi#vvijtSyT Uc6aAnL |w5oOr~k=.t\nI\nzR6eBp2oZr7tNsW,$ $Bel/orcmk/sZ,Y GaUnLd; #MiohdVekrHaftiiJoen5\n+Wdeov.Vu 2iMnwcGlOu@doe2sJ Brleopdo/rxtQ /a/nLd/ TbclRoMc2kl 8t.o5oulpsW ftyoH xhge#l.pI PpOr@outne6cyt, puvsIe6r!sv.S 2Uns9e3rssS VcPasnV +fYlKa#g4 Vorb!jpejcotHifopn.aNbil^eg Xc5o0nbtHesnitN Pa7nsdu Vb1lXo5c+kb Tacb$ufs4iyv%eJ 0u!s*esrPsi xf;r#o5mD Mp*r4o8fzisl8e# raxn|d$ Ac/oUnltfe0nltV rsycirOe&ejn8sC.j ORVeOpBoBrgtSeId* XcIodnyt6eBnztf sa0nmdt !aycWc$ojuWnzt,s^ ~mzaJyA 2bceR irye~vwipexwae9dR,h ghYi0dNdte!n2,o 7rXexm+ozvte3du,b ^l*iIm/i7t?e4d;,; Ko%rE Ct3ejr5mwiRnta=tPetd2.d sWFe1 =mna9y; @atcWtd yaMgSa*irnPs^t7 XsGeIvce1rMe? sv7iaotl4a!tiiPoUnys6 Gi&mHmBe#d4ica7t@e;l!ys 5a%nldu amea:y% krreTs9tFrTiGcwt1 pr^enp+eta%t:e2dg PvVifoSlzaEtRi%o5n5s2 2w=i%tRh?owuwtF lpPrcisoYrW :nooStkinc?ef.b\nG\nvC/hJa@lwlzeAnpg9e= maQn%dn ISThoo0pr yFpeDakt,uzr!eZs/\n?S$h$otpY ei+nff9o5rOm=aptNiQownq,| OrZe0cVo1m#mTe?nFdWaGtbirofn/s*,$ Bs&c@hzeAdZu&lzeRsE,~ AaOv+afibl~aUb~i2l/idt$y.,& ^a4nBd9 5c%hhaSlulJezn^gpes 0dGegt6aPirl8sU omCaiy6 XcJhCa8njgWed.i %Y^o;uX 1sgh5oPuZl|dz Kc1oQn+fii4r/mq Iiimdp4oOrItmaLnltj Li^ntf@o6r,mhaitEino@n+ kwWiOtThU 7thh%e; *rgeVl$e&voasnFt8 ts8h;o$pI :o~r# ;oxrrgMa6nfi=zkeCr4.3 ?D8itsfpDl@aYyMi6nRgX ia3 %s6hGoKpE 4osr~ wamc,tFigvqi0tOyr ?d#o6e%st *nAo6te xg2uRaRr;ahnatFexeB za6vwa?iPl^amb%ialriatSyl Po9rz ;c+oSnasStbipt4u!tpeH saOn4 9e:njdJo2r=sIeSmIe~nmts.L\n#\nhSNaUfGettgyr Xafnwdv !LRe~gQaNlC ZCMo;mHpYl0i=aRnYc6eN\n3Yqoiua baQgProe=eq +tEoW $fZo%lWlhoIw= :aclQl/ 8aGpvpjlti#ceaHbll@ey %lya!w0sm.U &DqoV gnio.tG ;uCsyeQ TWae0vHVk jtxoV /cVoAo,rndSitnyaRtVeH |h%aprImX,/ wcjosldl?e+cqtV ap~rYi9vLantAed tdDa1tSaR,s Gewv^a8d=eA rmHoFdpeOrQabt*iJoVn=,| 5o1rW 8iVnMtOeFrrf,enr7e5 +w=i8tMhE wa+pcpx msqefcyu;rJixtMyp.n\n;\nICThGaZn#g,eDss\nMW3e+ mmBa*yi ru&p|d7a5toe8 pt8h3e@sAeZ 1Twe%rKm.sa ;tto+ Hr^ePfAlle5cZt/ kf7e=aPtau~rke~,, os!a7f&ept8yn,j Zo!rU %l~e=g4aPlz +c%hzaTnygLedsr.t .CFoxnCtdiCn@uAezdL 2u3soeH /a|fnt?eXrk Ea+nW Jucp@d*a6t!eJ Nmmekaznwsz eyhoRuy Pa+c?cMeLpWti stth.eN qu#p0d#aCtHe5de kTmeurBm6so.l\nk\nHCrocnPt|ancgtp\n.QAu/e+sitmi3oRnFs+ KaCbeoHuhtJ dtNhqe.she0 QTGe|rdmas0 ro;rA 4uasde;rA Lsoa9f6e=tFy= Mm.a9y0 Hb8e7 *syeQn|t8 st9oM bw*ezvTvDuSsbeGrr@bgIm9abiCl&.^cwoJmM.I".wevVPastryCrumbBloomRestored
    }

    private func showTinySugarHint(_ text: String) {
        TinGlazePromptStyler.showSugarToast(in: view, text: text, bottomOffset: -18)
    }

    @objc private func showDeleteSugarPrompt() {
        showConfirmSugarPanel(
            title: "DieulLe%tfeE OA#cqcAoFuFnQtl".wevVPastryCrumbBloomRestored,
            note: "YJo+u!r1 :a/cNc@o.u&nfti aainvdo MaClnlb zd&a*tCaj nwdiUlZlP kbyeM Kp4e0rRmca?nZefnyt0l9y@ /rHe?m.oFvMe0ds Cagn5d5 FcLaZn=nCo|tq nb5e, 8rEevchoyv4eGr7eodk.C\n@TohKi7s& Fa7c3tEicolnK CcAaBn#nvoMtc VbCe1 ;uanpd9oUnveD.n".wevVPastryCrumbBloomRestored,
            okTitle: "SSu7r8eo".wevVPastryCrumbBloomRestored,
            cancelTitle: "CYawn^cqe=lL".wevVPastryCrumbBloomRestored,
            okFill: UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 77 / 255.0, alpha: 1),
            sugarFill: gingerHoneyDrizzle,
            flavorHintLabel: "TvhEiqsj ta+c#tmiiojnm Yc?aFnInho0tk &b#es uu9nLd;oDn4e|..".wevVPastryCrumbBloomRestored
        ) { [weak self] in
            self?.performGlazeAccountAction(sugarText: "".wevVPastryCrumbBloomRestored)
        }
    }

    @objc private func showRestSugarPrompt() {
        showConfirmSugarPanel(
            title: "LRo@gX Qoxu+t%".wevVPastryCrumbBloomRestored,
            note: "A^rYeh Ty,osu; isEugr?e= *yzoIu& PwZaVnqto HtUod %lko!gy :oBunt~?Y".wevVPastryCrumbBloomRestored,
            okTitle: "LJo%gN JohuwtA".wevVPastryCrumbBloomRestored,
            cancelTitle: "CmavnscXeSlM".wevVPastryCrumbBloomRestored,
            okFill: gingerHoneyDrizzle
        ) { [weak self] in
            self?.performGlazeAccountAction(sugarText: "LFoGgOg#iwnJgO .ofuitQ…F".wevVPastryCrumbBloomRestored)
        }
    }

    private func performGlazeAccountAction(sugarText: String) {
        NOticeNertyuSugartastingCard.showSugarToast(sugarText)
        Task { [weak self, glazeRepository] in
            await glazeRepository.starchGelatinizationDetail()
            await MainActor.run {
                guard let self else { return }
                NOticeNertyuSugartastingCard.clearSugarCrumbs()
                self.onSugarSettingChanged?()
                self.dismiss(animated: true)
            }
        }
    }

    @objc private func closeSugarSettings() {
        dismiss(animated: true)
    }
}
