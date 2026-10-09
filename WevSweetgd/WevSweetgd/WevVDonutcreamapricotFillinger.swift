import UIKit

private func makeBakeryAtlasEntry(_ donutPinKey: String, _ bakeryTitle: String, _ flavorNoteLine: String, _ coverAsset: String) -> WevVBakeryAtlas {
    WevVBakeryAtlas(donutPinKey: donutPinKey, bakeryTitle: bakeryTitle, flavorNoteLine: flavorNoteLine, bakeryFrameAsset: coverAsset)
}

private func makeDonutVisitEntry(_ ringCutterKey: String, _ sugarTitle: String, _ crumbCaption: String, _ cardAsset: String) -> WevVDailyDonutVisit {
    WevVDailyDonutVisit(ringCutterKey: ringCutterKey, bakeryFinder: sugarTitle, caption: crumbCaption, cardAsset: cardAsset)
}

private func makeDonutTasterEntry(_ donutPinKey: String, _ name: String, _ donutFrameAsset: String) -> WevVDonutTaster {
    WevVDonutTaster(donutPinKey: donutPinKey, name: name, donutFrameAsset: donutFrameAsset)
}

private func makeDonutSnapshotEntry(_ sprinkleJarKey: String, author: WevVDonutTaster, donutBackdropAsset: String, tastingText: String, hasSprinkleDust: Bool, hasBakeryShelf: Bool, freshnessTagText: String) -> WevVDonutSnapshot {
    WevVDonutSnapshot(sprinkleJarKey: sprinkleJarKey, tasterBloom: author, donutBackdropAsset: donutBackdropAsset, tastingText: tastingText, hasSprinkleDust: hasSprinkleDust, hasBakeryShelf: hasBakeryShelf, freshnessTagText: freshnessTagText)
}

private func makeFlavorNoteEntry(_ sugarDustKey: String, _ sugarTitle: String, _ crumbNote: String) -> WevVFlavorNote {
    WevVFlavorNote(sugarDustKey: sugarDustKey, tastingCardTitle: sugarTitle, sweetApricotNuance: crumbNote)
}

private final class WevVfigMoussepearJam: UIView {
    private let peachFilling = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 11
        clipsToBounds = true
        peachFilling.colors = [UIColor(red: 1, green: 0.61, blue: 0.38, alpha: 1).cgColor,
                           UIColor(red: 0.86, green: 0.05, blue: 0.86, alpha: 1).cgColor]
        peachFilling.startPoint = CGPoint(x: 0, y: 0.5)
        peachFilling.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(peachFilling, at: 0)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func layoutSubviews() { super.layoutSubviews(); peachFilling.frame = bounds }
}

private final class WevVInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

final class WevVDonutcreamapricotFillinger: UIViewController {
    static let homeChallengeParticipantKeys: Set<String> = [
        "joabmmite#Ciotl?eF".wevVPastryCrumbBloomRestored,
        "rQhfeJaQHVoCneeuyOGilpamz,eE".wevVPastryCrumbBloomRestored,
        "lzuinPaMLpaquogfhlG/luaXz#ev".wevVPastryCrumbBloomRestored,
        "njolvyaBBIuAbdbBlIe;GdlxaPzveD".wevVPastryCrumbBloomRestored
    ]
    private static let glazeImageCache = NSCache<NSString, UIImage>()
    private let donutJournalStore = WevVGlazeSessionStore.shared
    private let bakeryTasterStore = WevVGuestGlazeStore.shared
    private let glazeContentRepository = WevVGlazeContentRepository.pastryTrailDiary
    private let glazeSocialRepository = WevVGlazeSocialRepository.pastryTrailDiary
    private let pastryTrailScroll = UIScrollView()
    private let sprinkleRefresh = UIRefreshControl()
    private let donutCaseContent = UIView()
    private let bakeryAtlasCarousel = UIScrollView()
    private let bakeryAtlasPages = UIStackView()
    private let bakeryAtlasDots = UIPageControl()
    private let tastingQuestStrip = UIScrollView()
    private let tastingQuestRow = UIStackView()
    private let donutSnapshotStack = UIStackView()
    private let tastingJournalPanel = UIView()
    private let tastingJournalBackgroundLayer = CAGradientLayer()
    private let tastingParlorPanel = UIView()
    private let tastingParlorHotScroll = UIScrollView()
    private let tastingParlorHotRow = UIStackView()
    private let tastingParlorFollowButton = UIButton(type: .custom)
    private let tastingParlorRecommendButton = UIButton(type: .custom)
    private let tastingParlorSelectionBar = UIView()
    private let tastingParlorOwnerScroll = UIScrollView()
    private let tastingParlorOwnerRow = UIStackView()
    private let tastingParlorRoomPager = UIScrollView()
    private let tastingParlorRoomPages = UIStackView()
    private let tastingParlorFollowRoomStack = UIStackView()
    private let tastingParlorRoomStack = UIStackView()
    private let homeLiveRoomStack = UIStackView()
    private let tastingParlorStatusLabel = UILabel()
    private let homeLiveStatusLabel = UILabel()
    private let tastingJournalStatusLabel = UILabel()
    private let tastingJournalTrendingButton = UIButton(type: .custom)
    private let tastingJournalFollowButton = UIButton(type: .custom)
    private let tastingJournalSelectionBar = UIView()
    private let tastingJournalMomentPager = UIScrollView()
    private let tastingJournalMomentPages = UIStackView()
    private let tastingJournalTrendingMoments = UIView()
    private let tastingJournalFollowMoments = UIView()
    private let bakeryAtlasPanel = UIView()
    private let flavorNoteEntryButton = UIButton(type: .custom)
    private let donutDiaryPanel = UIView()
    private let donutDiaryNameLabel = UILabel()
    private let bakeryTrailCountLabel = UILabel()
    private let tasterTrailCountLabel = UILabel()
    private let bakeryShelfCountLabel = UILabel()
    private let donutArchiveCountLabel = UILabel()
    private let flavorNoteStack = UIStackView()
    private let emptyFlavorStack = UIStackView()
    private weak var profileAvatarImageView: UIImageView?
    private let donutParlorTabBack = UIView()
    private let donutParlorFoot = UIView()
    private let donutCounterGlazeSheen = UIView()
    private let tastingJournalGlazeSheen = UIView()
    private var bakeryAtlasTimer: Timer?
    private var glazeContentTask: Task<Void, Never>?
    private var glazeProfileTask: Task<Void, Never>?
    private var glazeJournalFollowTask: Task<Void, Never>?
    private var glazeRoomItems: [pearFilling] = []
    private var glazeRecommendedVoiceRooms: [pearFilling] = []
    private var glazeFollowedVoiceRooms: [pearFilling] = []
    private var glazeTrendingMomentItems: [butteryTexture] = []
    private var glazeFollowedMomentItems: [butteryTexture] = []
    private var glazeProfileMomentItems: [butteryTexture] = []
    private var tastingParlorShelf = mascarponeFilling.apricotCompote
    private var tastingJournalShelf = goldenCrumbDough.artisanFrySequence
    private var tastingParlorSelectionCenterConstraint: NSLayoutConstraint?
    private var tastingParlorRoomPagerHeightConstraint: NSLayoutConstraint?
    private var tastingJournalSelectionCenterConstraint: NSLayoutConstraint?
    private var didPlaceTastingParlorRoomPager = false
    private var didPlaceTastingJournalMomentPager = false
    private var didFinishDonutCounterGlazeSheen = false
    private var didFinishTastingJournalGlazeSheen = false
    private var isDonutCounterGlazeSheenActive = false
    private var isTastingJournalGlazeSheenActive = false
    private var donutParlorIcons: [WevVDonutParlorSection: UIImageView] = [:]
    private var donutParlorFootTopConstraints: [WevVDonutParlorSection: NSLayoutConstraint] = [:]
    private var glazeHomePanels: [UIView] = []
    private var frostingDiaryPanels: [UIView] = []
    private var activeDonutParlorSection = WevVDonutParlorSection.donutCounter

    private let donutParlorAssetTrail: [WevVDonutParlorSection: (idle: String, active: String)] = [
        .donutCounter: ("wevv_tab_home_glaze_idle", "wevv_tab_home_glaze_active"),
        .tastingParlor: ("wevv_tab_live_sprinkle_idle", "wevv_tab_live_sprinkle_active"),
        .tastingJournal: ("wevv_tab_discover_sprinkle_idle", "wevv_tab_discover_sprinkle_active"),
        .zestyOrangeHarmony: ("wevv_tab_profile_donut_idle", "wevv_tab_profile_donut_active")
    ]

    private let bakeryAtlasItems: [WevVBakeryAtlas] = [
        makeBakeryAtlasEntry("b,eMr~r:y+R:iunlgRBYaRkueFrYyc".wevVPastryCrumbBloomRestored, "BdeUrAr?ym HR~i#n*gd pBFaSkHe!r,yV".wevVPastryCrumbBloomRestored, "Fzrie~sHh: TdzofnSuDtssL c·e Rb;e^ror+yr of&lja#vIokrHsH".wevVPastryCrumbBloomRestored, "wevv_shop_berry_ring_bakery"),
        makeBakeryAtlasEntry("g%o%lZdje:nPDSohuugZhGS;tmuKd+izoP".wevVPastryCrumbBloomRestored, "GnoBlsdueHn; TDWouuog%hr USktCuxdJiQoP".wevVPastryCrumbBloomRestored, "ACr,tlibsWawnA uduo/nluTt=sW g·S esomiazl*l+ jbEastccyhmels:".wevVPastryCrumbBloomRestored, "wevv_shop_golden_dough_studio"),
        makeBakeryAtlasEntry("mMoFoLnhl:ixgWhEtND.oAn^u!tjB;alrm".wevVPastryCrumbBloomRestored, "MIoXoVnMlRijghhDt+ tDgoLn^uItj yB%alrh".wevVPastryCrumbBloomRestored, "L=aetfe&-ynViygSh&td Hdto,nLuItds! S·X kc;rueRa:t&iMvRei CdWrFiFnKkcsE".wevVPastryCrumbBloomRestored, "wevv_shop_moonlight_donut_bar")
    ]

    private let dailyDonutVisit = makeDonutVisitEntry("dvaAiwl.yIDXo:nYuit.Sot/aqm.p/".wevVPastryCrumbBloomRestored, "DMaSicl;yK".wevVPastryCrumbBloomRestored, "Cihkeic=kq-;imn,".wevVPastryCrumbBloomRestored, "wevv_checkin_donut_daily_card")

    private var tastingQuests: [WevVTastingQuest] = [
        WevVTastingQuest(
            sprinkleJarKey: "sBtGrzaswsbieMrsrUywWWelerk;".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "Snt:rxa%wbbne+r:rNyt hWYeleYkE".wevVPastryCrumbBloomRestored,
            caption: "TcrKyA MaC cmKyvsatHe*r*y+ pdIoNn&uZtU oawnxdt mg;uAeasqsE KtAhtev mfplqauvToMrx.?".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_strawberry_week",
            glazeSheenText: "JRoGi@nw".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "C:ogm/ppljePtneE qtJopd,a#yo'MsY wtsadsrt;irnfg% Rt@aQskk# XaFn+d# Aswh?aPrGek !aS FbceOrbrPy? +neo&t;eN.o".wevVPastryCrumbBloomRestored,
            freshnessTagText: "FkrUi=deajyP j·I ~8s:I0+0D bP!Me K-T u1M0!:h3~0P yPgMw".wevVPastryCrumbBloomRestored,
            bakeryStopText: "B~earkrmyw WRcivnSgN OBcaYkbe^rfyx,n BSkaYnW qFxria/n&cLi*sGc*oZ".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "joabmmite#Ciotl?eF".wevVPastryCrumbBloomRestored,
            tasterLine: "Vhe?r,i@fJi?e^dR ,hkoms;tk +·q d4b.P9= WrHaIt~iBnGg+".wevVPastryCrumbBloomRestored,
            tastingQuestText: "TsaAsUtLeG /a# HsqtIrwaLwpbiegr;rGyF ^rDi;nWgu,; @npa~mve& ptzhae. yh:iodVdqeCng RfqiCltlti^nYgI,B TaGnRdl .pzoas!t, ~yloru^rL SsTw/e;eUtkeLs:t^ qful?atvroprK @cMl:u=eE.k".wevVPastryCrumbBloomRestored,
            tastingTableText: "2x3K MpOezoepPlXe!".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 300
        ),
        WevVTastingQuest(
            sprinkleJarKey: "pkinnAkmDooqnOuWtJD:aNyh".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "PCiDnDk= eD:oznnu^tP +Dya%yB".wevVPastryCrumbBloomRestored,
            caption: "Sxh^ayrEe% Eab mpeianJkU #dvounYuftL ~aan:d& ncWr/eKartyeJ uyJoHumrT Lsgwte^eStWetsutA cpahKoztao^.M".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_pink_donut_day",
            glazeSheenText: "JMo@ianN".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "BguniJlfd+ UaD qb?rviBgehBtG !psi.nvkM wdQoVnIuLtp up;hMoat&oS #s#eutH %fto#rY HtAh,e? DdpaVy#.A".wevVPastryCrumbBloomRestored,
            freshnessTagText: "S=a?tiu^rgdma!yR E·p ;2=:N0H0Z LPuMu v-? #5T:&0n0@ qPEM!".wevVPastryCrumbBloomRestored,
            bakeryStopText: "GqoGlxdEeTnc cD,oQuBg+hg &SgtEu!dii;o#,F lSmafnn /Fcrba;nscGimsOcEoD".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "rQhfeJaQHVoCneeuyOGilpamz,eE".wevVPastryCrumbBloomRestored,
            tasterLine: "P:h!o&tMoc NhioIsSt/ R·= x4o.C8x rrZaMtNiGnxge".wevVPastryCrumbBloomRestored,
            tastingQuestText: "Cua;p%t.ulr!ek BaB SpeiTnvkS zdioAntu*t* am/oOmie!nGtR bw?int~hE YoDn?eg ?s&hWo.rMtj ntfapsQtni@nfgB SnToBtEes pa:nWdA Sa? cp:lia+yIfxuolo ytDo^p?pDipnPgK SiPd&e;ah.F".wevVPastryCrumbBloomRestored,
            tastingTableText: "3h1s DpWe/oOpAlme;".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 260
        ),
        WevVTastingQuest(
            sprinkleJarKey: "dOoNnCu,tLCPoafBfAeie!MWaht:cfhB".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "DdoHn.uUtB I&l PCio^f~fLeEeg SM^awt;cGhw".wevVPastryCrumbBloomRestored,
            caption: "Pcapi:rY ;ymohuJrd HfEa@vVoOr=iat,e+ EdIoDn*uTt+ mw&iCt+hq St@hTeG fpZenrJfFe/catF Hcoo%fEfte:ej.c".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_donut_coffee_match",
            glazeSheenText: "JIoaiInc".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "FUibn:db aaK jdDognvuWtq &p#a.i%rUiwn/gA EtJh?afth GmZa.kKehs. NcPo!fefleVeZ Pt!aas@t*et gbkeUtltlezrS.y".wevVPastryCrumbBloomRestored,
            freshnessTagText: "S;uen#d#akya j·~ j1.0,:j3b0k ~ARMR !-u P1@2g:&0l0J ^PNM#".wevVPastryCrumbBloomRestored,
            bakeryStopText: "McogoMn:lviDg~hStg RDKotnZuLtk NBra%rh,~ hSRaLnd ?FGrmafnccfiTs~c.oZ".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "aWr;l!ocSKkNyjGNlFaaz@et".wevVPastryCrumbBloomRestored,
            tasterLine: "PraviorXiYnkgs shlo#sotV s·U Y4G.i7/ lrqartJi~nQgS".wevVPastryCrumbBloomRestored,
            tastingQuestText: "P~imc*k. *an udToBnsuWtB EasnIdn laD icHoIfafIeRea &sntzydl?e/,z ct;hPeanU yeNxBpmlnani;nx Mwnh?yZ otqhSe~ /fnrxo?sNtRinn#gw DaGnmd% ^rNoGagsHtV swTopr@kO QtEoTgue=tQhNeIrt.k".wevVPastryCrumbBloomRestored,
            tastingTableText: "2Q8m Mp:ePoypKl,eJ".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 280
        ),
        WevVTastingQuest(
            sprinkleJarKey: "fGi*rys!tPB@iDtjemRCeJaCc:tpiso;nX".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "FXiHrfsTte qBIiCtQeU @Rze~aDctt,igo+n,".wevVPastryCrumbBloomRestored,
            caption: "C~aDpvttu~r.ek Eyco~uprD qrBezaglS erQe;arcptxiAoHn% aaDf+t+edr= Htqh,eI IfHiVrosRtq vb,ibtUed.@".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_first_bite_reaction",
            glazeSheenText: "JcodiDnz".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "S=haoCwF ~tjhPeQ EfTiOr?s=tC Jb~iHtkeY nfeacc#eD ;tbh?aZtA psRaJyjsm bedvVe!rmyXt@haiSnkgl.U".wevVPastryCrumbBloomRestored,
            freshnessTagText: "M&o%npdEaSy? T·z y6o:!3d0: +PMMU S-H :8P:C0k0M tPNMM".wevVPastryCrumbBloomRestored,
            bakeryStopText: "PWi.nrkW aGglxa=zweC dHdoIuEsneg,: vSjaJnh TFgr=a+n:cLiqsIckoA".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "nvoBvEa^B?ubbpbbl=ehGRl=a=z#eC".wevVPastryCrumbBloomRestored,
            tasterLine: "TaaxsWtqi^nSgL Phoo#sitj P·; .4h.a8e yrxa:tKiPn?gB".wevVPastryCrumbBloomRestored,
            tastingQuestText: "T?apkXep roRn&en abnibtceO,/ Aw!r;iwtSeP jtmhkeO bfaimrNsNt. htEh%rzerek mf*lnaovZo^rx !wqomr:d?sX,a ;a~n:d, =kPeuePp^ ;tChUef ?r*e,ancAt;iGornk Bn/aftvuuroahlZ.R".wevVPastryCrumbBloomRestored,
            tastingTableText: "1i9f dpJe^oPpLlBeD".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 240
        ),
        WevVTastingQuest(
            sprinkleJarKey: "dMoTnluzt*OIfpTrhAe&D:aVyA".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "DwoLn/umt~ SoGfE %tvhOen %D&agyt".wevVPastryCrumbBloomRestored,
            caption: "PHoIsetu TtHo^dha@y:'TsS .dOoVnUudtj +avn/dM PtPeOlZlj ceav%eSrAyJoenCes qwzhyys Vy@oRup fcYhBocsAeH viptM.h".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_donut_of_day",
            glazeSheenText: "J;ogiNn!".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "C*h&oLohslez DtNhCek Ao?nNeN GdjornKuptN ?tphaaDt@ cd@evsdevrRvEe&sh VtuocdJafyl'nsM is:pCoktklei:gOhJt~.s".wevVPastryCrumbBloomRestored,
            freshnessTagText: "WjegdhnLeuscdRacy! @·A m1D:j0F0K DPxMy f-Y V4e:q0&0Y /PYMq".wevVPastryCrumbBloomRestored,
            bakeryStopText: "CllXoluldz hSJpJrvijn#kwl#ew,j PSbaEn^ lFWrqaDnrc%iQsecrou".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "lYu:nuaMLFagu~g&hNG=l&aBzje;".wevVPastryCrumbBloomRestored,
            tasterLine: "D%aciVl,yC /h@oAsBth P·S Z4Q..9Z vr+artkiin,g~".wevVPastryCrumbBloomRestored,
            tastingQuestText: "POiecpkU ,yto%u^rH RdSo=nourtx %o=fL stqh&eI BdnaTy@,f Ua&dQdk :o:nteT CrHekaSs^ofn,,L LapnPdz =iUn*v%iJtXeM ~oJtuhyeMry otGaesgtpeArtsR ZtUoY ^c^oPmGpKakrge~ NcohPoIitc*ers#.Q".wevVPastryCrumbBloomRestored,
            tastingTableText: "3J6T /pTeWonpHl/eq".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 220
        ),
        WevVTastingQuest(
            sprinkleJarKey: "sPpArRi~ngkvlJeeSLtbylluej".wevVPastryCrumbBloomRestored,
            menuBoardTitle: "S?pUrciMnrkIlaeP =SetByGlweR".wevVPastryCrumbBloomRestored,
            caption: "DMe?c,ohr=a.tieQ VaI ydAoFn,udtL swBi;tUhs ;yrojuJrO ufDakv:odrUict@e? Pc,o/l:oirWfVu%l# Fsxp,rFirngkVlXeas^.F".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_sprinkle_style",
            glazeSheenText: "JXoSiTng".wevVPastryCrumbBloomRestored,
            glazeTrailLine: "Twu%r%nc At!o~pxp,iDnNg+s: =iBn~t,of Uay wtyizn%yM ;d.o*nkuFt% mf!aBschAivoPnK rs:hBoHwC.u".wevVPastryCrumbBloomRestored,
            freshnessTagText: "TPhMu#rCs:deawyT f·q o7q:s0p0= MPPMP g-D w9N:A0v0S .PJMV".wevVPastryCrumbBloomRestored,
            bakeryStopText: "MZe.lalzokwZ ODno+ukgZhV,M OObaIk#lCaNn/da".wevVPastryCrumbBloomRestored,
            tasterBadgeKey: "bvlDaKi/rHBjlUu,e&GSlHaxzCet".wevVPastryCrumbBloomRestored,
            tasterLine: "SOt+ygl,eh xhpoaskt= ?·F /4m.V6S PrMaKtdiLntg&".wevVPastryCrumbBloomRestored,
            tastingQuestText: "DTedsTi?gcnf nam msip+r=isnzkyljeo QlzoYoQk*,j odgeysSc#rIi.bme. Btwh+ey jcxoel:oArY Um@iKxc,+ ia!n^dQ ~vkocteet ffgoMrI HtQhDeX OshwaedeDtqeqs;tQ !sStxy%lOe+ #iWdSeLa;.A".wevVPastryCrumbBloomRestored,
            tastingTableText: "2t4y hp&etoJpcleeC".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: 250
        )
    ]

    private var donutSnapshots: [WevVDonutSnapshot] = [
        makeDonutSnapshotEntry(
            "o=nFeuBmiQtwe~VViHb;e/sf".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("lAoKuoipspepSMa@nvtko#sq".wevVPastryCrumbBloomRestored, "LeoTujiQsUez #Spatnet^oNss".wevVPastryCrumbBloomRestored, "louiseCream"),
            donutBackdropAsset: "wevv_moment_one_bite_vibes",
            tastingText: "OlnzeJ =bxiFtieM,@ paw Kw^h;ofl&eT %ddamyN aocf! cg=oBoAdz ,vbiWb#e#sE".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: false,
            hasBakeryShelf: false,
            freshnessTagText: "BBeTrkrsy; tnxo=tgec".wevVPastryCrumbBloomRestored
        ),
        makeDonutSnapshotEntry(
            "fBrYevsihvDroFnFu:tSSccwern,tu".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("m.aAssoFnPGHlxagz!e!SRm?iNldek".wevVPastryCrumbBloomRestored, "M/aCsyoBnj fC.oclXes".wevVPastryCrumbBloomRestored, "masonSugar"),
            donutBackdropAsset: "wevv_moment_fresh_donut_scent",
            tastingText: "F@rkexsoh^ gdPo~n?uztssB wsgmEevlWl= raJm%aWzlisndgE.S".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: true,
            hasBakeryShelf: false,
            freshnessTagText: "Fsrferschd @boaotqcUhn".wevVPastryCrumbBloomRestored
        ),
        makeDonutSnapshotEntry(
            "c~hRohcaoQlnaYtkerDPoRn.uvtRD!aHym".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("aZvmaBCyopc!oPaXR,iSn,g/".wevVPastryCrumbBloomRestored, "AIvraQ BBHrHoYwqnS".wevVPastryCrumbBloomRestored, "avaCocoa"),
            donutBackdropAsset: "wevv_moment_chocolate_donut_day",
            tastingText: "CQhjo!cyoFlsastfeF .d;ounauNtQsA ^mRaBdsew CmEyT Gdzagyt.f".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: false,
            hasBakeryShelf: true,
            freshnessTagText: "Cmo?c;ora: RmZo=oLdC".wevVPastryCrumbBloomRestored
        ),
        makeDonutSnapshotEntry(
            "wge:e,kYe%nJd.DtoenTuTtFSYt;aCrxtw".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("bFeilhlGarSlporvi~nUk+ller".wevVPastryCrumbBloomRestored, "BKeXlElvaR ZHla=r&tJ".wevVPastryCrumbBloomRestored, "bellaCream"),
            donutBackdropAsset: "wevv_moment_weekend_donut_start",
            tastingText: "S^ttatretdi~nYgh ~tqhAeD ZwPeCeKkfeLnpdG mwqiXtoho .dPoSnEuet+sA.q".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: false,
            hasBakeryShelf: false,
            freshnessTagText: "Wre?eUk:eUnwd% jpQi~cAkC".wevVPastryCrumbBloomRestored
        ),
        makeDonutSnapshotEntry(
            "p=i.nTk/S.w@eneVtGnDeEskstTUowdPasyQ".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("mpiNauPZifn.kfS!ujgVagr@".wevVPastryCrumbBloomRestored, "MKiuaM !Rce;eddq".wevVPastryCrumbBloomRestored, "miaPink"),
            donutBackdropAsset: "wevv_moment_pink_sweetness",
            tastingText: "Ai hl:iJtrtdl#e! QpoiEnmk= csIw%exeStjn;ewsyst JtSoYdiaQyc.T".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: true,
            hasBakeryShelf: true,
            freshnessTagText: "P%ignlkX EsepprfiunGkzlaee".wevVPastryCrumbBloomRestored
        ),
        makeDonutSnapshotEntry(
            "cYrneKaEmrF.i,lNleeWdwUYn.iKtje%".wevVPastryCrumbBloomRestored,
            author: makeDonutTasterEntry("nfoCrvaBC,rBeSaKmgR#i?nngx".wevVPastryCrumbBloomRestored, "NroErbaC uL~abnCeI".wevVPastryCrumbBloomRestored, "noraCream"),
            donutBackdropAsset: "wevv_moment_cream_filled_unite",
            tastingText: "C@rNePaumW-#fki,l^lIeKde CdVoon=uUtW ;lPoav#e,rYsm,K Ku=nMitt!ee.n".wevVPastryCrumbBloomRestored,
            hasSprinkleDust: false,
            hasBakeryShelf: false,
            freshnessTagText: "C&r=eVaSmB ,cViarpcYlXez".wevVPastryCrumbBloomRestored
        )
    ]

    private let defaultDonutDiaryTaster = WevVDonutDiaryTaster(
        ringCutterKey: "wpeCvavbS@ulgTaJrUTOalsutaepr&".wevVPastryCrumbBloomRestored,
        warmGingerFlavor: "wHeRvcvh@rgamoaHiLls.gcSoom?".wevVPastryCrumbBloomRestored,
        glazeNickname: "GelLaLzYe: oTnausstKemrm".wevVPastryCrumbBloomRestored,
        donutFrameAsset: "wevv_profile_avatar_piano_donut",
        tastingMarks: WevVTastingMark(glazeTrailCount: 12, sprinkleTasterCount: 28, bakeryShelfTotal: 7, donutArchiveTotal: 360),
        honeyedFigHarmony: [
            makeFlavorNoteEntry("s^t;rJa:w?bdeqr#r;yhR,ienJgYNSoatxeB".wevVPastryCrumbBloomRestored, "S!tRrTatwNbne,rkrIyB dgClta%zhe+ qmioPr,n,ivndgH".wevVPastryCrumbBloomRestored, "S@oefLtg SfLrSolsctNiBnQg%,Y .w=aurzmm #c+rBuOmYbb,C NblrBiGgShAt@ nsSurgra/rn.J".wevVPastryCrumbBloomRestored),
            makeFlavorNoteEntry("cvo?cioyakSDpkrHi/nIk!l&eMTFr=aui=lB".wevVPastryCrumbBloomRestored, "Cxo,cOoOaD Kstpkr#iznDk&lfe^ dtRaEsHtgiRn/gu".wevVPastryCrumbBloomRestored, "SpaJv!ead& saP XsfmyaOlvle KsxhNohpv wwMo^rMtChN dcoo?mfiHnSgT sb%a?cZkQ ttUoq.q".wevVPastryCrumbBloomRestored)
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshGlazeServerProfile),
            name: .bakeryTrailMap,
            object: nil
        )
        buildDonutParlorBackdrop()
        buildPastryTrailScroll()
        buildTopDonutBar()
        buildBakeryVisitBand()
        buildTastingQuestBand()
        buildHomeLiveRoomBand()
        buildTastingParlorPanel()
        buildTastingJournalPanel()
        buildFlavorNotePanel()
        buildDonutDiaryPanel()
        buildDonutParlorFoot()
        buildDonutParlorTabBar()
        buildFlavorNoteEntryButton()
        buildInitialGlazeSheenPanels()
        switchDonutParlorSection(.donutCounter)
        loadGlazeContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBakeryAtlasTimer()
        revealInitialGlazeSheenIfNeeded(for: activeDonutParlorSection)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tastingJournalBackgroundLayer.frame = bakeryAtlasPanel.bounds
        if !didPlaceTastingParlorRoomPager, tastingParlorRoomPager.bounds.width > 0 {
            didPlaceTastingParlorRoomPager = true
            tastingParlorRoomPager.setContentOffset(
                CGPoint(x: CGFloat(tastingParlorShelf.rawValue) * tastingParlorRoomPager.bounds.width, y: 0),
                animated: false
            )
        }
        if !didPlaceTastingJournalMomentPager, tastingJournalMomentPager.bounds.width > 0 {
            didPlaceTastingJournalMomentPager = true
            tastingJournalMomentPager.setContentOffset(
                CGPoint(x: CGFloat(tastingJournalShelf.rawValue) * tastingJournalMomentPager.bounds.width, y: 0),
                animated: false
            )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBakeryAtlasTimer()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stopBakeryAtlasTimer()
        glazeContentTask?.cancel()
        glazeProfileTask?.cancel()
        glazeJournalFollowTask?.cancel()
    }

    @objc private func refreshGlazeServerProfile() {
        refreshDonutDiaryPanel()
    }

    private func buildDonutParlorBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.78, blue: 0.85, alpha: 1)

        let backdonutdrop = UIImageView(image: UIImage(named: "wevv_home_version7_backdrop"))
        backdonutdrop.translatesAutoresizingMaskIntoConstraints = false
        backdonutdrop.contentMode = .scaleToFill
        view.addSubview(backdonutdrop)

        NSLayoutConstraint.activate([
            backdonutdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdonutdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdonutdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdonutdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildPastryTrailScroll() {
        pastryTrailScroll.translatesAutoresizingMaskIntoConstraints = false
        pastryTrailScroll.showsVerticalScrollIndicator = false
        pastryTrailScroll.alwaysBounceVertical = true
        pastryTrailScroll.contentInsetAdjustmentBehavior = .never
        pastryTrailScroll.contentInset.bottom = 110
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 110
        sprinkleRefresh.tintColor = UIColor(red: 0.18, green: 0.02, blue: 0.32, alpha: 1)
        sprinkleRefresh.backgroundColor = UIColor.white.withAlphaComponent(0.32)
        sprinkleRefresh.attributedTitle = NSAttributedString(
            string: "P#u#l#l# #t#o# #r#e#f#r#e#s#h#".wevVPastryCrumbBloomRestored,
            attributes: [
                .foregroundColor: UIColor(red: 0.18, green: 0.02, blue: 0.32, alpha: 1),
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ]
        )
        sprinkleRefresh.isEnabled = false
        sprinkleRefresh.addTarget(self, action: #selector(refreshSprinkleMoments), for: .valueChanged)
        pastryTrailScroll.refreshControl = sprinkleRefresh
        view.addSubview(pastryTrailScroll)

        donutCaseContent.translatesAutoresizingMaskIntoConstraints = false
        pastryTrailScroll.addSubview(donutCaseContent)

        NSLayoutConstraint.activate([
            pastryTrailScroll.topAnchor.constraint(equalTo: view.topAnchor),
            pastryTrailScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pastryTrailScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pastryTrailScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            donutCaseContent.topAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.topAnchor),
            donutCaseContent.leadingAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.leadingAnchor),
            donutCaseContent.trailingAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.trailingAnchor),
            donutCaseContent.bottomAnchor.constraint(equalTo: pastryTrailScroll.contentLayoutGuide.bottomAnchor),
            donutCaseContent.widthAnchor.constraint(equalTo: pastryTrailScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildTopDonutBar() {
        let wevvLogo = UIImageView(image: UIImage(named: "wevv_home_wevv_glaze_logo"))
        wevvLogo.translatesAutoresizingMaskIntoConstraints = false
        wevvLogo.contentMode = .scaleAspectFit

        let challengeDonutWevvButton = makeImageButton(
            asset: "wevv_home_challenge_entry",
            action: #selector(openTastingQuestComposer)
        )
        challengeDonutWevvButton.accessibilityLabel = "Publish challenge"

        let noticedonutWevvButton = makeImageButton(asset: "wevv_top_sprinkle_inbox_entry", action: #selector(openGlazeNoticeList))

        donutCaseContent.addSubview(wevvLogo)
        donutCaseContent.addSubview(challengeDonutWevvButton)
        donutCaseContent.addSubview(noticedonutWevvButton)
        glazeHomePanels.append(contentsOf: [challengeDonutWevvButton, noticedonutWevvButton])

        NSLayoutConstraint.activate([
            wevvLogo.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 24),
            wevvLogo.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            wevvLogo.widthAnchor.constraint(equalToConstant: 99),
            wevvLogo.heightAnchor.constraint(equalToConstant: 30),
            challengeDonutWevvButton.centerYAnchor.constraint(equalTo: wevvLogo.centerYAnchor),
            challengeDonutWevvButton.trailingAnchor.constraint(equalTo: noticedonutWevvButton.leadingAnchor, constant: -20),
            challengeDonutWevvButton.widthAnchor.constraint(equalToConstant: 102),
            challengeDonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticedonutWevvButton.centerYAnchor.constraint(equalTo: wevvLogo.centerYAnchor),
            noticedonutWevvButton.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            noticedonutWevvButton.widthAnchor.constraint(equalToConstant: 30),
            noticedonutWevvButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func buildBakeryVisitBand() {
        bakeryAtlasCarousel.translatesAutoresizingMaskIntoConstraints = false
        bakeryAtlasCarousel.isPagingEnabled = true
        bakeryAtlasCarousel.showsHorizontalScrollIndicator = false
        bakeryAtlasCarousel.delegate = self
        donutCaseContent.addSubview(bakeryAtlasCarousel)

        bakeryAtlasPages.translatesAutoresizingMaskIntoConstraints = false
        bakeryAtlasPages.axis = .horizontal
        bakeryAtlasPages.spacing = 0
        bakeryAtlasCarousel.addSubview(bakeryAtlasPages)

        for bakeryAtlas in bakeryAtlasItems {
            let treatCaseCard = makeBakeryAtlasCard(bakeryAtlas)
            bakeryAtlasPages.addArrangedSubview(treatCaseCard)
            treatCaseCard.widthAnchor.constraint(equalTo: bakeryAtlasCarousel.frameLayoutGuide.widthAnchor).isActive = true
        }

        bakeryAtlasDots.translatesAutoresizingMaskIntoConstraints = false
        bakeryAtlasDots.numberOfPages = bakeryAtlasItems.count
        bakeryAtlasDots.currentPage = 0
        bakeryAtlasDots.currentPageIndicatorTintColor = .white
        bakeryAtlasDots.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.55)
        donutCaseContent.addSubview(bakeryAtlasDots)

        glazeHomePanels.append(contentsOf: [bakeryAtlasCarousel, bakeryAtlasDots])

        NSLayoutConstraint.activate([
            bakeryAtlasCarousel.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 64),
            bakeryAtlasCarousel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            bakeryAtlasCarousel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            bakeryAtlasCarousel.heightAnchor.constraint(equalTo: bakeryAtlasCarousel.widthAnchor, multiplier: 95.0 / 345.0),
            bakeryAtlasPages.topAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.topAnchor),
            bakeryAtlasPages.leadingAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.leadingAnchor),
            bakeryAtlasPages.trailingAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.trailingAnchor),
            bakeryAtlasPages.bottomAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.bottomAnchor),
            bakeryAtlasPages.heightAnchor.constraint(equalTo: bakeryAtlasCarousel.frameLayoutGuide.heightAnchor),
            bakeryAtlasDots.trailingAnchor.constraint(equalTo: bakeryAtlasCarousel.trailingAnchor, constant: -14),
            bakeryAtlasDots.widthAnchor.constraint(equalToConstant: 48),
            bakeryAtlasDots.bottomAnchor.constraint(equalTo: bakeryAtlasCarousel.bottomAnchor, constant: 2),
            bakeryAtlasDots.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func buildTastingQuestBand() {
        tastingQuestStrip.translatesAutoresizingMaskIntoConstraints = false
        tastingQuestStrip.showsHorizontalScrollIndicator = false
        tastingQuestStrip.isScrollEnabled = false
        donutCaseContent.addSubview(tastingQuestStrip)
        glazeHomePanels.append(tastingQuestStrip)

        tastingQuestRow.translatesAutoresizingMaskIntoConstraints = false
        tastingQuestRow.axis = .horizontal
        tastingQuestRow.spacing = 10
        tastingQuestRow.distribution = .fill
        tastingQuestStrip.addSubview(tastingQuestRow)

        rebuildTastingQuestRow()

        NSLayoutConstraint.activate([
            tastingQuestStrip.topAnchor.constraint(equalTo: bakeryAtlasCarousel.bottomAnchor, constant: 10),
            tastingQuestStrip.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            tastingQuestStrip.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            tastingQuestStrip.heightAnchor.constraint(
                equalTo: tastingQuestStrip.widthAnchor,
                multiplier: 645.0 / 1041.0,
                constant: 20.0 - 28.0 * 645.0 / 1041.0
            ),
            tastingQuestRow.topAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.topAnchor),
            tastingQuestRow.leadingAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.leadingAnchor, constant: 14),
            tastingQuestRow.trailingAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.trailingAnchor, constant: -14),
            tastingQuestRow.bottomAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.bottomAnchor),
            tastingQuestRow.heightAnchor.constraint(equalTo: tastingQuestStrip.frameLayoutGuide.heightAnchor),
            tastingQuestRow.widthAnchor.constraint(equalTo: tastingQuestStrip.frameLayoutGuide.widthAnchor, constant: -28)
        ])
    }

    private func buildHomeLiveRoomBand() {
        let title = UIImageView(image: UIImage(named: "wevv_home_live_room_title"))
        title.translatesAutoresizingMaskIntoConstraints = false
        title.contentMode = .scaleAspectFit

        homeLiveRoomStack.translatesAutoresizingMaskIntoConstraints = false
        homeLiveRoomStack.axis = .vertical
        homeLiveRoomStack.spacing = 10

        configureGlazeStatusLabel(homeLiveStatusLabel, text: "Loading live rooms…")

        donutCaseContent.addSubview(title)
        donutCaseContent.addSubview(homeLiveRoomStack)
        donutCaseContent.addSubview(homeLiveStatusLabel)
        glazeHomePanels.append(contentsOf: [title, homeLiveRoomStack, homeLiveStatusLabel])

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: tastingQuestStrip.bottomAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            homeLiveRoomStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            homeLiveRoomStack.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            homeLiveRoomStack.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            homeLiveRoomStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            homeLiveStatusLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 26),
            homeLiveStatusLabel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 28),
            homeLiveStatusLabel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -28),
            homeLiveStatusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 96)
        ])
    }

    private func buildTastingParlorPanel() {
        tastingParlorPanel.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorPanel.backgroundColor = UIColor(red: 0.10, green: 0.0, blue: 0.23, alpha: 1)
        tastingParlorPanel.isHidden = true
        donutCaseContent.addSubview(tastingParlorPanel)

        let backdrop = UIImageView(image: UIImage(named: "wevv_voice_version4_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleToFill

        let title = UIImageView(image: UIImage(named: "wevv_voice_live_glaze_logo"))
        title.translatesAutoresizingMaskIntoConstraints = false
        title.contentMode = .scaleAspectFit

        let profileButton = UIButton(type: .custom)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.setImage(UIImage(named: "wevv_top_sprinkle_inbox_entry"), for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.addTarget(self, action: #selector(openGlazeNoticeList), for: .touchUpInside)

        tastingParlorHotScroll.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorHotScroll.showsHorizontalScrollIndicator = false
        tastingParlorHotScroll.alwaysBounceHorizontal = true
        tastingParlorHotScroll.isDirectionalLockEnabled = true
        tastingParlorHotRow.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorHotRow.axis = .horizontal
        tastingParlorHotRow.spacing = 10
        tastingParlorHotScroll.addSubview(tastingParlorHotRow)

        configureTastingParlorShelfButton(
            tastingParlorFollowButton,
            title: "Follow",
            shelf: .cherryCenter,
            action: #selector(selectTastingParlorFollow)
        )
        configureTastingParlorShelfButton(
            tastingParlorRecommendButton,
            title: "Recommend",
            shelf: .apricotCompote,
            action: #selector(selectTastingParlorRecommend)
        )
        tastingParlorSelectionBar.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorSelectionBar.backgroundColor = .white
        tastingParlorSelectionBar.layer.cornerRadius = 2

        tastingParlorOwnerScroll.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorOwnerScroll.showsHorizontalScrollIndicator = false
        tastingParlorOwnerScroll.alwaysBounceHorizontal = true
        tastingParlorOwnerScroll.isDirectionalLockEnabled = true
        tastingParlorOwnerRow.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorOwnerRow.axis = .horizontal
        tastingParlorOwnerRow.spacing = 18
        tastingParlorOwnerScroll.addSubview(tastingParlorOwnerRow)

        tastingParlorRoomPager.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorRoomPager.isPagingEnabled = true
        tastingParlorRoomPager.showsHorizontalScrollIndicator = false
        tastingParlorRoomPager.alwaysBounceHorizontal = true
        tastingParlorRoomPager.isDirectionalLockEnabled = true
        tastingParlorRoomPager.delegate = self
        tastingParlorRoomPages.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorRoomPages.axis = .horizontal
        tastingParlorRoomPages.spacing = 0
        tastingParlorRoomPager.addSubview(tastingParlorRoomPages)

        let followPage = UIView()
        let recommendPage = UIView()
        [followPage, recommendPage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            tastingParlorRoomPages.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalTo: tastingParlorRoomPager.frameLayoutGuide.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: tastingParlorRoomPager.frameLayoutGuide.heightAnchor).isActive = true
        }

        tastingParlorFollowRoomStack.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorFollowRoomStack.axis = .vertical
        tastingParlorFollowRoomStack.spacing = 14
        tastingParlorRoomStack.translatesAutoresizingMaskIntoConstraints = false
        tastingParlorRoomStack.axis = .vertical
        tastingParlorRoomStack.spacing = 14
        followPage.addSubview(tastingParlorFollowRoomStack)
        recommendPage.addSubview(tastingParlorRoomStack)

        configureGlazeStatusLabel(tastingParlorStatusLabel, text: "Loading rooms…")
        tastingParlorStatusLabel.textColor = UIColor.white.withAlphaComponent(0.78)

        [backdrop, title, profileButton, tastingParlorHotScroll, tastingParlorFollowButton,
         tastingParlorRecommendButton, tastingParlorSelectionBar, tastingParlorOwnerScroll,
         tastingParlorRoomPager, tastingParlorStatusLabel].forEach {
            tastingParlorPanel.addSubview($0)
        }

        tastingParlorRoomPagerHeightConstraint = tastingParlorRoomPager.heightAnchor.constraint(equalToConstant: 400)
        tastingParlorSelectionCenterConstraint = tastingParlorSelectionBar.centerXAnchor.constraint(
            equalTo: tastingParlorRecommendButton.centerXAnchor
        )

        NSLayoutConstraint.activate([
            tastingParlorPanel.topAnchor.constraint(equalTo: donutCaseContent.topAnchor),
            tastingParlorPanel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            tastingParlorPanel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            tastingParlorPanel.heightAnchor.constraint(greaterThanOrEqualTo: pastryTrailScroll.frameLayoutGuide.heightAnchor),
            backdrop.topAnchor.constraint(equalTo: tastingParlorPanel.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: tastingParlorPanel.bottomAnchor),
            title.topAnchor.constraint(equalTo: tastingParlorPanel.safeAreaLayoutGuide.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor, constant: 15),
            title.widthAnchor.constraint(equalToConstant: 86),
            title.heightAnchor.constraint(equalToConstant: 30),
            profileButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor, constant: -15),
            profileButton.widthAnchor.constraint(equalToConstant: 30),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor),
            tastingParlorHotScroll.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 22),
            tastingParlorHotScroll.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor),
            tastingParlorHotScroll.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor),
            tastingParlorHotScroll.heightAnchor.constraint(equalToConstant: 52),
            tastingParlorHotRow.topAnchor.constraint(equalTo: tastingParlorHotScroll.contentLayoutGuide.topAnchor),
            tastingParlorHotRow.leadingAnchor.constraint(equalTo: tastingParlorHotScroll.contentLayoutGuide.leadingAnchor, constant: 15),
            tastingParlorHotRow.trailingAnchor.constraint(equalTo: tastingParlorHotScroll.contentLayoutGuide.trailingAnchor, constant: -15),
            tastingParlorHotRow.bottomAnchor.constraint(equalTo: tastingParlorHotScroll.contentLayoutGuide.bottomAnchor),
            tastingParlorHotRow.heightAnchor.constraint(equalTo: tastingParlorHotScroll.frameLayoutGuide.heightAnchor),
            tastingParlorFollowButton.topAnchor.constraint(equalTo: tastingParlorHotScroll.bottomAnchor, constant: 18),
            tastingParlorFollowButton.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor, constant: 15),
            tastingParlorFollowButton.widthAnchor.constraint(equalToConstant: 58),
            tastingParlorFollowButton.heightAnchor.constraint(equalToConstant: 32),
            tastingParlorRecommendButton.centerYAnchor.constraint(equalTo: tastingParlorFollowButton.centerYAnchor),
            tastingParlorRecommendButton.leadingAnchor.constraint(equalTo: tastingParlorFollowButton.trailingAnchor, constant: 12),
            tastingParlorRecommendButton.widthAnchor.constraint(equalToConstant: 112),
            tastingParlorRecommendButton.heightAnchor.constraint(equalToConstant: 32),
            tastingParlorSelectionBar.topAnchor.constraint(equalTo: tastingParlorRecommendButton.bottomAnchor, constant: 2),
            tastingParlorSelectionBar.widthAnchor.constraint(equalToConstant: 22),
            tastingParlorSelectionBar.heightAnchor.constraint(equalToConstant: 4),
            tastingParlorSelectionCenterConstraint!,
            tastingParlorOwnerScroll.topAnchor.constraint(equalTo: tastingParlorSelectionBar.bottomAnchor, constant: 18),
            tastingParlorOwnerScroll.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor),
            tastingParlorOwnerScroll.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor),
            tastingParlorOwnerScroll.heightAnchor.constraint(equalToConstant: 78),
            tastingParlorOwnerRow.topAnchor.constraint(equalTo: tastingParlorOwnerScroll.contentLayoutGuide.topAnchor),
            tastingParlorOwnerRow.leadingAnchor.constraint(equalTo: tastingParlorOwnerScroll.contentLayoutGuide.leadingAnchor, constant: 15),
            tastingParlorOwnerRow.trailingAnchor.constraint(equalTo: tastingParlorOwnerScroll.contentLayoutGuide.trailingAnchor, constant: -15),
            tastingParlorOwnerRow.bottomAnchor.constraint(equalTo: tastingParlorOwnerScroll.contentLayoutGuide.bottomAnchor),
            tastingParlorOwnerRow.heightAnchor.constraint(equalTo: tastingParlorOwnerScroll.frameLayoutGuide.heightAnchor),
            tastingParlorRoomPager.topAnchor.constraint(equalTo: tastingParlorOwnerScroll.bottomAnchor, constant: 18),
            tastingParlorRoomPager.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor),
            tastingParlorRoomPager.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor),
            tastingParlorRoomPagerHeightConstraint!,
            tastingParlorRoomPager.bottomAnchor.constraint(equalTo: tastingParlorPanel.bottomAnchor),
            tastingParlorRoomPages.topAnchor.constraint(equalTo: tastingParlorRoomPager.contentLayoutGuide.topAnchor),
            tastingParlorRoomPages.leadingAnchor.constraint(equalTo: tastingParlorRoomPager.contentLayoutGuide.leadingAnchor),
            tastingParlorRoomPages.trailingAnchor.constraint(equalTo: tastingParlorRoomPager.contentLayoutGuide.trailingAnchor),
            tastingParlorRoomPages.bottomAnchor.constraint(equalTo: tastingParlorRoomPager.contentLayoutGuide.bottomAnchor),
            tastingParlorRoomPages.heightAnchor.constraint(equalTo: tastingParlorRoomPager.frameLayoutGuide.heightAnchor),
            tastingParlorFollowRoomStack.topAnchor.constraint(equalTo: followPage.topAnchor),
            tastingParlorFollowRoomStack.leadingAnchor.constraint(equalTo: followPage.leadingAnchor, constant: 15),
            tastingParlorFollowRoomStack.trailingAnchor.constraint(equalTo: followPage.trailingAnchor, constant: -15),
            tastingParlorRoomStack.topAnchor.constraint(equalTo: recommendPage.topAnchor),
            tastingParlorRoomStack.leadingAnchor.constraint(equalTo: recommendPage.leadingAnchor, constant: 15),
            tastingParlorRoomStack.trailingAnchor.constraint(equalTo: recommendPage.trailingAnchor, constant: -15),
            tastingParlorStatusLabel.topAnchor.constraint(equalTo: tastingParlorRoomPager.topAnchor, constant: 28),
            tastingParlorStatusLabel.leadingAnchor.constraint(equalTo: tastingParlorPanel.leadingAnchor, constant: 28),
            tastingParlorStatusLabel.trailingAnchor.constraint(equalTo: tastingParlorPanel.trailingAnchor, constant: -28),
            tastingParlorStatusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        updateTastingParlorShelf(.apricotCompote, animated: false, movesPager: false)
    }

    private func configureTastingParlorShelfButton(
        _ button: UIButton,
        title: String,
        shelf: mascarponeFilling,
        action: Selector
    ) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = shelf.rawValue
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    @objc private func selectTastingParlorFollow() {
        updateTastingParlorShelf(.cherryCenter, animated: true, movesPager: true)
    }

    @objc private func selectTastingParlorRecommend() {
        updateTastingParlorShelf(.apricotCompote, animated: true, movesPager: true)
    }

    private func updateTastingParlorShelf(
        _ shelf: mascarponeFilling,
        animated: Bool,
        movesPager: Bool
    ) {
        tastingParlorShelf = shelf
        tastingParlorFollowButton.titleLabel?.font = .systemFont(
            ofSize: shelf == .cherryCenter ? 18 : 16,
            weight: shelf == .cherryCenter ? .bold : .regular
        )
        tastingParlorRecommendButton.titleLabel?.font = .systemFont(
            ofSize: shelf == .apricotCompote ? 18 : 16,
            weight: shelf == .apricotCompote ? .bold : .regular
        )
        tastingParlorFollowButton.alpha = shelf == .cherryCenter ? 1 : 0.88
        tastingParlorRecommendButton.alpha = shelf == .apricotCompote ? 1 : 0.88

        tastingParlorSelectionCenterConstraint?.isActive = false
        let selectionAnchor = shelf == .cherryCenter
            ? tastingParlorFollowButton.centerXAnchor
            : tastingParlorRecommendButton.centerXAnchor
        tastingParlorSelectionCenterConstraint = tastingParlorSelectionBar.centerXAnchor.constraint(equalTo: selectionAnchor)
        tastingParlorSelectionCenterConstraint?.isActive = true

        rebuildTastingParlorOwners()
        updateTastingParlorStatus()
        if movesPager, tastingParlorRoomPager.bounds.width > 0 {
            tastingParlorRoomPager.setContentOffset(
                CGPoint(x: CGFloat(shelf.rawValue) * tastingParlorRoomPager.bounds.width, y: 0),
                animated: animated
            )
        }
        let changes = { self.tastingParlorPanel.layoutIfNeeded() }
        if animated {
            UIView.animate(withDuration: 0.22, animations: changes)
        } else {
            changes()
        }
    }

    private func tastingParlorRooms(for shelf: mascarponeFilling) -> [pearFilling] {
        switch shelf {
        case .cherryCenter:
            return glazeFollowedVoiceRooms
        case .apricotCompote:
            return glazeRecommendedVoiceRooms
        }
    }

    private func rebuildTastingParlorHotRooms() {
        tastingParlorHotRow.arrangedSubviews.forEach {
            tastingParlorHotRow.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for (index, room) in glazeRecommendedVoiceRooms.prefix(6).enumerated() {
            tastingParlorHotRow.addArrangedSubview(makeTastingParlorHotRoom(room, style: index))
        }
    }

    private func makeTastingParlorHotRoom(_ room: pearFilling, style: Int) -> UIControl {
        let palettes: [[UIColor]] = [
            [UIColor(red: 0.98, green: 0.54, blue: 0.26, alpha: 1), UIColor(red: 0.99, green: 0.91, blue: 0.43, alpha: 1)],
            [UIColor(red: 0.85, green: 0.03, blue: 0.50, alpha: 1), UIColor(red: 0.99, green: 0.26, blue: 0.70, alpha: 1)],
            [UIColor(red: 0.29, green: 0.59, blue: 0.93, alpha: 1), UIColor(red: 0.39, green: 0.88, blue: 0.96, alpha: 1)],
            [UIColor(red: 0.31, green: 0.32, blue: 0.91, alpha: 1), UIColor(red: 0.48, green: 0.62, blue: 0.99, alpha: 1)]
        ]
        let card = WevVGlazepillowyCrumb(chewyCrust: palettes[style % palettes.count])
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = "voice:\(room.passionfruitMousse)"
        card.isAccessibilityElement = true
        card.accessibilityLabel = "\(room.limeJam), \(room.figFilling) online"
        card.accessibilityTraits = .button
        card.layer.cornerRadius = 9
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(openGlazeRoom(_:)), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = room.limeJam
        title.textColor = .white
        title.font = .systemFont(ofSize: 14, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.72
        card.addSubview(title)

        let avatarRow = UIStackView()
        avatarRow.translatesAutoresizingMaskIntoConstraints = false
        avatarRow.axis = .horizontal
        avatarRow.spacing = -5
        let avatarURLs = room.custardCurd.isEmpty
            ? [room.pearCenter].compactMap { $0 }
            : Array(room.custardCurd.prefix(3))
        for (avatarIndex, avatarURL) in avatarURLs.prefix(3).enumerated() {
            avatarRow.addArrangedSubview(makeTastingParlorAvatar(url: avatarURL, diameter: 21, fallback: avatarIndex))
        }
        card.addSubview(avatarRow)

        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 92),
            card.heightAnchor.constraint(equalToConstant: 52),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 6),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 7),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -5),
            avatarRow.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 7),
            avatarRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -5),
            avatarRow.heightAnchor.constraint(equalToConstant: 21)
        ])
        return card
    }

    private func rebuildTastingParlorOwners() {
        tastingParlorOwnerRow.arrangedSubviews.forEach {
            tastingParlorOwnerRow.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        var seenOwners = Set<String>()
        let owners = tastingParlorRooms(for: tastingParlorShelf).filter { room in
            let ownerKey = room.yuzuCustard ?? "\(room.peachCream)|\(room.pearCenter ?? "")"
            return seenOwners.insert(ownerKey).inserted
        }
        for (index, room) in owners.prefix(8).enumerated() {
            tastingParlorOwnerRow.addArrangedSubview(makeTastingParlorOwner(room, fallback: index))
        }
    }

    private func makeTastingParlorOwner(_ room: pearFilling, fallback: Int) -> UIView {
        let owner = UIControl()
        owner.translatesAutoresizingMaskIntoConstraints = false
        if let hostID = room.yuzuCustard, let userID = Int64(hostID), userID > 0 {
            owner.accessibilityIdentifier = String(userID)
            owner.accessibilityLabel = "View \(room.peachCream)'s profile"
            owner.accessibilityTraits = .button
            owner.addTarget(self, action: #selector(openTastingParlorOwner(_:)), for: .touchUpInside)
        } else {
            owner.isUserInteractionEnabled = false
        }
        let avatar = makeTastingParlorAvatar(
            url: room.pearCenter ?? room.appleCompote,
            diameter: 50,
            fallback: fallback
        )
        avatar.layer.borderWidth = 1.5
        avatar.layer.borderColor = UIColor(red: 0.96, green: 0.07, blue: 0.73, alpha: 1).cgColor

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = room.peachCream
        name.textColor = .white
        name.font = .systemFont(ofSize: 13, weight: .medium)
        name.textAlignment = .center
        name.lineBreakMode = .byTruncatingTail
        owner.addSubview(avatar)
        owner.addSubview(name)

        NSLayoutConstraint.activate([
            owner.widthAnchor.constraint(equalToConstant: 58),
            owner.heightAnchor.constraint(equalToConstant: 78),
            avatar.topAnchor.constraint(equalTo: owner.topAnchor),
            avatar.centerXAnchor.constraint(equalTo: owner.centerXAnchor),
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: owner.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: owner.trailingAnchor),
            name.bottomAnchor.constraint(lessThanOrEqualTo: owner.bottomAnchor)
        ])
        return owner
    }

    private func makeTastingParlorAvatar(url: String?, diameter: CGFloat, fallback: Int) -> UIImageView {
        let fallbackAssets = [
            "wevv_guest_glaze_berry", "wevv_guest_glaze_luna", "wevv_guest_glaze_mira",
            "wevv_guest_glaze_arlo", "wevv_guest_glaze_nova"
        ]
        let avatar = UIImageView(image: UIImage(named: fallbackAssets[fallback % fallbackAssets.count]))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = diameter / 2
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: diameter),
            avatar.heightAnchor.constraint(equalToConstant: diameter)
        ])
        if let url, !url.isEmpty {
            setGlazeRemoteImage(url, on: avatar)
        }
        return avatar
    }

    @objc private func openTastingParlorOwner(_ sender: UIControl) {
        guard let hostID = sender.accessibilityIdentifier,
              let userID = Int64(hostID),
              userID > 0 else { return }
        let controller = WevVWevvTasterCardController(userID: userID)
        present(controller, animated: true)
    }

    private func updateTastingParlorStatus() {
        let rooms = tastingParlorRooms(for: tastingParlorShelf)
        tastingParlorStatusLabel.isHidden = !rooms.isEmpty
        tastingParlorStatusLabel.text = tastingParlorShelf == .cherryCenter
            ? "No followed voice rooms are open right now."
            : "No recommended voice rooms are open right now."
    }

    private func configureGlazeStatusLabel(_ label: UILabel, text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = UIColor(red: 0.34, green: 0.24, blue: 0.39, alpha: 1)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
    }

    private func buildTastingJournalPanel() {
        bakeryAtlasPanel.translatesAutoresizingMaskIntoConstraints = false
        bakeryAtlasPanel.isHidden = true
        bakeryAtlasPanel.backgroundColor = .clear
        tastingJournalBackgroundLayer.colors = [
            UIColor(red: 1, green: 0.93, blue: 0.99, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.65, blue: 0.98, alpha: 1).cgColor
        ]
        tastingJournalBackgroundLayer.locations = [0, 0.31, 0.76, 1]
        tastingJournalBackgroundLayer.startPoint = CGPoint(x: 0.68, y: -0.01)
        tastingJournalBackgroundLayer.endPoint = CGPoint(x: 0.96, y: 0.96)
        bakeryAtlasPanel.layer.insertSublayer(tastingJournalBackgroundLayer, at: 0)
        donutCaseContent.addSubview(bakeryAtlasPanel)

        let exploredonutWevvButton = makeImageButton(asset: "wevv_discover_explore_logo", action: #selector(openGlazeNoticeList))
        let noticeButton = makeImageButton(asset: "wevv_discover_notice_entry", action: #selector(openGlazeNoticeList))

        configureTastingJournalShelfButton(tastingJournalTrendingButton, title: "Trending", shelf: .artisanFrySequence)
        configureTastingJournalShelfButton(tastingJournalFollowButton, title: "Follow", shelf: .cherryCenter)
        tastingJournalSelectionBar.translatesAutoresizingMaskIntoConstraints = false
        tastingJournalSelectionBar.backgroundColor = UIColor(red: 1, green: 0.24, blue: 0.65, alpha: 1)
        tastingJournalSelectionBar.layer.cornerRadius = 2.5

        tastingJournalMomentPager.translatesAutoresizingMaskIntoConstraints = false
        tastingJournalMomentPager.isPagingEnabled = true
        tastingJournalMomentPager.showsHorizontalScrollIndicator = false
        tastingJournalMomentPager.alwaysBounceHorizontal = true
        tastingJournalMomentPager.delegate = self

        tastingJournalMomentPages.translatesAutoresizingMaskIntoConstraints = false
        tastingJournalMomentPages.axis = .horizontal
        tastingJournalMomentPages.spacing = 0
        tastingJournalMomentPager.addSubview(tastingJournalMomentPages)
        [tastingJournalTrendingMoments, tastingJournalFollowMoments].forEach { page in
            page.translatesAutoresizingMaskIntoConstraints = false
            tastingJournalMomentPages.addArrangedSubview(page)
            page.widthAnchor.constraint(equalTo: tastingJournalMomentPager.frameLayoutGuide.widthAnchor).isActive = true
        }

        let newPostTitle = UILabel()
        newPostTitle.translatesAutoresizingMaskIntoConstraints = false
        newPostTitle.text = "New Post"
        newPostTitle.textColor = .black
        newPostTitle.font = .systemFont(ofSize: 22, weight: .heavy)

        let newPostBand = UIView()
        newPostBand.translatesAutoresizingMaskIntoConstraints = false
        newPostBand.backgroundColor = UIColor(red: 1.0, green: 0.83, blue: 0.94, alpha: 1)

        donutSnapshotStack.translatesAutoresizingMaskIntoConstraints = false
        donutSnapshotStack.axis = .vertical
        donutSnapshotStack.spacing = 10

        configureGlazeStatusLabel(tastingJournalStatusLabel, text: "Loading community posts…")

        bakeryAtlasPanel.addSubview(newPostBand)
        bakeryAtlasPanel.addSubview(exploredonutWevvButton)
        bakeryAtlasPanel.addSubview(noticeButton)
        bakeryAtlasPanel.addSubview(tastingJournalTrendingButton)
        bakeryAtlasPanel.addSubview(tastingJournalFollowButton)
        bakeryAtlasPanel.addSubview(tastingJournalSelectionBar)
        bakeryAtlasPanel.addSubview(tastingJournalMomentPager)
        bakeryAtlasPanel.addSubview(newPostTitle)
        bakeryAtlasPanel.addSubview(donutSnapshotStack)
        bakeryAtlasPanel.addSubview(tastingJournalStatusLabel)
        frostingDiaryPanels.append(bakeryAtlasPanel)

        NSLayoutConstraint.activate([
            bakeryAtlasPanel.topAnchor.constraint(equalTo: donutCaseContent.topAnchor),
            bakeryAtlasPanel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            bakeryAtlasPanel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            exploredonutWevvButton.topAnchor.constraint(equalTo: bakeryAtlasPanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            exploredonutWevvButton.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 25),
            exploredonutWevvButton.widthAnchor.constraint(equalToConstant: 126),
            exploredonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticeButton.centerYAnchor.constraint(equalTo: exploredonutWevvButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -16),
            noticeButton.widthAnchor.constraint(equalToConstant: 44),
            noticeButton.heightAnchor.constraint(equalToConstant: 44),
            tastingJournalTrendingButton.topAnchor.constraint(equalTo: exploredonutWevvButton.bottomAnchor, constant: 25),
            tastingJournalTrendingButton.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 15),
            tastingJournalTrendingButton.heightAnchor.constraint(equalToConstant: 30),
            tastingJournalFollowButton.centerYAnchor.constraint(equalTo: tastingJournalTrendingButton.centerYAnchor),
            tastingJournalFollowButton.leadingAnchor.constraint(equalTo: tastingJournalTrendingButton.trailingAnchor, constant: 18),
            tastingJournalFollowButton.heightAnchor.constraint(equalToConstant: 30),
            tastingJournalSelectionBar.topAnchor.constraint(equalTo: tastingJournalTrendingButton.bottomAnchor, constant: 5),
            tastingJournalSelectionBar.widthAnchor.constraint(equalToConstant: 18),
            tastingJournalSelectionBar.heightAnchor.constraint(equalToConstant: 5),
            tastingJournalMomentPager.topAnchor.constraint(equalTo: tastingJournalSelectionBar.bottomAnchor, constant: 12),
            tastingJournalMomentPager.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 12),
            tastingJournalMomentPager.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -12),
            tastingJournalMomentPager.heightAnchor.constraint(equalToConstant: 374),
            tastingJournalMomentPages.topAnchor.constraint(equalTo: tastingJournalMomentPager.contentLayoutGuide.topAnchor),
            tastingJournalMomentPages.leadingAnchor.constraint(equalTo: tastingJournalMomentPager.contentLayoutGuide.leadingAnchor),
            tastingJournalMomentPages.trailingAnchor.constraint(equalTo: tastingJournalMomentPager.contentLayoutGuide.trailingAnchor),
            tastingJournalMomentPages.bottomAnchor.constraint(equalTo: tastingJournalMomentPager.contentLayoutGuide.bottomAnchor),
            tastingJournalMomentPages.heightAnchor.constraint(equalTo: tastingJournalMomentPager.frameLayoutGuide.heightAnchor),
            newPostBand.topAnchor.constraint(equalTo: tastingJournalMomentPager.bottomAnchor),
            newPostBand.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor),
            newPostBand.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor),
            newPostBand.bottomAnchor.constraint(equalTo: bakeryAtlasPanel.bottomAnchor),
            newPostTitle.topAnchor.constraint(equalTo: tastingJournalMomentPager.bottomAnchor, constant: 22),
            newPostTitle.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 15),
            donutSnapshotStack.topAnchor.constraint(equalTo: newPostTitle.bottomAnchor, constant: 16),
            donutSnapshotStack.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 12),
            donutSnapshotStack.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -12),
            donutSnapshotStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            donutSnapshotStack.bottomAnchor.constraint(equalTo: bakeryAtlasPanel.bottomAnchor),
            tastingJournalStatusLabel.topAnchor.constraint(equalTo: newPostTitle.bottomAnchor, constant: 24),
            tastingJournalStatusLabel.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 28),
            tastingJournalStatusLabel.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -28),
            tastingJournalStatusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        tastingJournalSelectionCenterConstraint = tastingJournalSelectionBar.centerXAnchor.constraint(equalTo: tastingJournalTrendingButton.centerXAnchor)
        tastingJournalSelectionCenterConstraint?.isActive = true
        rebuildTastingJournalMomentPages()
        updateTastingJournalShelf(.artisanFrySequence, animated: false, movesPager: false)
    }

    private func buildDonutParlorTabBar() {
        donutParlorTabBack.translatesAutoresizingMaskIntoConstraints = false
        donutParlorTabBack.backgroundColor = .white
        donutParlorTabBack.layer.cornerRadius = 30
        donutParlorTabBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(donutParlorTabBack)

        let donutRow = UIStackView(arrangedSubviews: [
            makeTabButton(section: .donutCounter, asset: "wevv_tab_home_glaze_active"),
            makeTabButton(section: .tastingParlor, asset: "wevv_tab_live_sprinkle_idle"),
            makeTabButton(section: .tastingJournal, asset: "wevv_tab_discover_sprinkle_idle"),
            makeTabButton(section: .zestyOrangeHarmony, asset: "wevv_tab_profile_donut_idle")
        ])
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.distribution = .equalSpacing
        donutParlorTabBack.addSubview(donutRow)

        NSLayoutConstraint.activate([
            donutParlorTabBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            donutParlorTabBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            donutParlorTabBack.heightAnchor.constraint(equalToConstant: 88),
            donutParlorTabBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            donutRow.topAnchor.constraint(equalTo: donutParlorTabBack.topAnchor, constant: 8),
            donutRow.leadingAnchor.constraint(equalTo: donutParlorTabBack.leadingAnchor, constant: 23),
            donutRow.trailingAnchor.constraint(equalTo: donutParlorTabBack.trailingAnchor, constant: -22),
            donutRow.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    private func buildFlavorNoteEntryButton() {
        flavorNoteEntryButton.translatesAutoresizingMaskIntoConstraints = false
        flavorNoteEntryButton.setImage(UIImage(named: "wevv_discover_post_frosting_entry"), for: .normal)
        flavorNoteEntryButton.imageView?.contentMode = .scaleAspectFit
        flavorNoteEntryButton.addTarget(self, action: #selector(openFlavorNoteComposer), for: .touchUpInside)
        flavorNoteEntryButton.isHidden = true
        view.addSubview(flavorNoteEntryButton)

        NSLayoutConstraint.activate([
            flavorNoteEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            flavorNoteEntryButton.bottomAnchor.constraint(equalTo: donutParlorTabBack.topAnchor, constant: -54),
            flavorNoteEntryButton.widthAnchor.constraint(equalToConstant: 62),
            flavorNoteEntryButton.heightAnchor.constraint(equalToConstant: 62)
        ])
    }

    private func buildDonutParlorFoot() {
        donutParlorFoot.translatesAutoresizingMaskIntoConstraints = false
        donutParlorFoot.isHidden = true
        donutCaseContent.addSubview(donutParlorFoot)

        NSLayoutConstraint.activate([
            donutParlorFoot.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            donutParlorFoot.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            donutParlorFoot.heightAnchor.constraint(equalToConstant: 1),
            donutParlorFoot.bottomAnchor.constraint(equalTo: donutCaseContent.bottomAnchor)
        ])

        donutParlorFootTopConstraints[.donutCounter] = donutParlorFoot.topAnchor.constraint(equalTo: homeLiveRoomStack.bottomAnchor, constant: 28)
        donutParlorFootTopConstraints[.tastingParlor] = donutParlorFoot.topAnchor.constraint(equalTo: tastingParlorPanel.bottomAnchor, constant: 32)
        donutParlorFootTopConstraints[.tastingJournal] = donutParlorFoot.topAnchor.constraint(equalTo: bakeryAtlasPanel.bottomAnchor, constant: 32)
        donutParlorFootTopConstraints[.zestyOrangeHarmony] = donutParlorFoot.topAnchor.constraint(equalTo: donutDiaryPanel.bottomAnchor, constant: 32)
        donutParlorFootTopConstraints[.donutCounter]?.isActive = true
    }

    private func buildInitialGlazeSheenPanels() {
        buildDonutCounterGlazeSheen()
        buildTastingJournalGlazeSheen()
    }

    private func makeGlazeSheenTile(cornerRadius: CGFloat) -> WevVGlazeSheenView {
        let glazeSheen = WevVGlazeSheenView()
        glazeSheen.translatesAutoresizingMaskIntoConstraints = false
        glazeSheen.layer.cornerRadius = cornerRadius
        glazeSheen.clipsToBounds = true
        return glazeSheen
    }

    private func buildDonutCounterGlazeSheen() {
        donutCounterGlazeSheen.translatesAutoresizingMaskIntoConstraints = false
        donutCounterGlazeSheen.backgroundColor = UIColor(red: 1, green: 0.78, blue: 0.85, alpha: 1)
        view.addSubview(donutCounterGlazeSheen)

        let glazeLogo = makeGlazeSheenTile(cornerRadius: 10)
        let bakeryShelf = UIStackView(arrangedSubviews: [
            makeGlazeSheenTile(cornerRadius: 20),
            makeGlazeSheenTile(cornerRadius: 20)
        ])
        bakeryShelf.translatesAutoresizingMaskIntoConstraints = false
        bakeryShelf.axis = .horizontal
        bakeryShelf.spacing = 14
        bakeryShelf.distribution = .fillEqually

        let sprinkleTitle = makeGlazeSheenTile(cornerRadius: 9)
        let treatCase = UIStackView(arrangedSubviews: [
            makeGlazeSheenTile(cornerRadius: 18),
            makeGlazeSheenTile(cornerRadius: 18)
        ])
        treatCase.translatesAutoresizingMaskIntoConstraints = false
        treatCase.axis = .horizontal
        treatCase.spacing = 12
        treatCase.distribution = .fillEqually

        [glazeLogo, bakeryShelf, sprinkleTitle, treatCase].forEach { donutCounterGlazeSheen.addSubview($0) }

        NSLayoutConstraint.activate([
            donutCounterGlazeSheen.topAnchor.constraint(equalTo: view.topAnchor),
            donutCounterGlazeSheen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            donutCounterGlazeSheen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            donutCounterGlazeSheen.bottomAnchor.constraint(equalTo: donutParlorTabBack.topAnchor),
            glazeLogo.topAnchor.constraint(equalTo: donutCounterGlazeSheen.safeAreaLayoutGuide.topAnchor, constant: 28),
            glazeLogo.leadingAnchor.constraint(equalTo: donutCounterGlazeSheen.leadingAnchor, constant: 16),
            glazeLogo.widthAnchor.constraint(equalTo: donutCounterGlazeSheen.widthAnchor, multiplier: 0.28),
            glazeLogo.heightAnchor.constraint(equalToConstant: 28),
            bakeryShelf.topAnchor.constraint(equalTo: glazeLogo.bottomAnchor, constant: 38),
            bakeryShelf.leadingAnchor.constraint(equalTo: donutCounterGlazeSheen.leadingAnchor, constant: 15),
            bakeryShelf.trailingAnchor.constraint(equalTo: donutCounterGlazeSheen.trailingAnchor, constant: -15),
            bakeryShelf.heightAnchor.constraint(equalTo: donutCounterGlazeSheen.heightAnchor, multiplier: 0.35),
            sprinkleTitle.topAnchor.constraint(equalTo: bakeryShelf.bottomAnchor, constant: 24),
            sprinkleTitle.leadingAnchor.constraint(equalTo: bakeryShelf.leadingAnchor),
            sprinkleTitle.widthAnchor.constraint(equalTo: donutCounterGlazeSheen.widthAnchor, multiplier: 0.42),
            sprinkleTitle.heightAnchor.constraint(equalToConstant: 24),
            treatCase.topAnchor.constraint(equalTo: sprinkleTitle.bottomAnchor, constant: 24),
            treatCase.leadingAnchor.constraint(equalTo: donutCounterGlazeSheen.leadingAnchor, constant: 15),
            treatCase.trailingAnchor.constraint(equalTo: donutCounterGlazeSheen.trailingAnchor, constant: -15),
            treatCase.heightAnchor.constraint(equalTo: donutCounterGlazeSheen.heightAnchor, multiplier: 0.28)
        ])
    }

    private func buildTastingJournalGlazeSheen() {
        tastingJournalGlazeSheen.translatesAutoresizingMaskIntoConstraints = false
        tastingJournalGlazeSheen.backgroundColor = UIColor(red: 1, green: 0.78, blue: 0.85, alpha: 1)
        tastingJournalGlazeSheen.isHidden = true
        view.addSubview(tastingJournalGlazeSheen)

        let glazeLogo = makeGlazeSheenTile(cornerRadius: 10)
        let sprinkleTitle = makeGlazeSheenTile(cornerRadius: 9)
        let pastryTray = UIStackView(arrangedSubviews: [
            makeGlazeSheenTile(cornerRadius: 18),
            makeGlazeSheenTile(cornerRadius: 18),
            makeGlazeSheenTile(cornerRadius: 18)
        ])
        pastryTray.translatesAutoresizingMaskIntoConstraints = false
        pastryTray.axis = .vertical
        pastryTray.spacing = 11
        pastryTray.distribution = .fillEqually

        [glazeLogo, sprinkleTitle, pastryTray].forEach { tastingJournalGlazeSheen.addSubview($0) }

        NSLayoutConstraint.activate([
            tastingJournalGlazeSheen.topAnchor.constraint(equalTo: view.topAnchor),
            tastingJournalGlazeSheen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tastingJournalGlazeSheen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tastingJournalGlazeSheen.bottomAnchor.constraint(equalTo: donutParlorTabBack.topAnchor),
            glazeLogo.topAnchor.constraint(equalTo: tastingJournalGlazeSheen.safeAreaLayoutGuide.topAnchor, constant: 28),
            glazeLogo.leadingAnchor.constraint(equalTo: tastingJournalGlazeSheen.leadingAnchor, constant: 16),
            glazeLogo.widthAnchor.constraint(equalTo: tastingJournalGlazeSheen.widthAnchor, multiplier: 0.32),
            glazeLogo.heightAnchor.constraint(equalToConstant: 28),
            sprinkleTitle.topAnchor.constraint(equalTo: glazeLogo.bottomAnchor, constant: 30),
            sprinkleTitle.leadingAnchor.constraint(equalTo: glazeLogo.leadingAnchor),
            sprinkleTitle.widthAnchor.constraint(equalTo: tastingJournalGlazeSheen.widthAnchor, multiplier: 0.26),
            sprinkleTitle.heightAnchor.constraint(equalToConstant: 22),
            pastryTray.topAnchor.constraint(equalTo: sprinkleTitle.bottomAnchor, constant: 18),
            pastryTray.leadingAnchor.constraint(equalTo: tastingJournalGlazeSheen.leadingAnchor, constant: 15),
            pastryTray.trailingAnchor.constraint(equalTo: tastingJournalGlazeSheen.trailingAnchor, constant: -15),
            pastryTray.bottomAnchor.constraint(equalTo: tastingJournalGlazeSheen.bottomAnchor, constant: -20)
        ])
    }

    private func buildFlavorNotePanel() {
        tastingJournalPanel.translatesAutoresizingMaskIntoConstraints = false
        tastingJournalPanel.isHidden = true
        donutCaseContent.addSubview(tastingJournalPanel)

        let donutStampTitle = makePanelTitle("DvoWn#urtS zD?ilaxr@y*".wevVPastryCrumbBloomRestored)
        let firstCard = makeTastingJournalCard(title: "SctYryarwabiehrvrCy= Qg?lTaezJem !t!aKsGtsiNnrgG".wevVPastryCrumbBloomRestored, caption: "Aa IsJoEfYto rrWiBnBgo Cw;i?tIh/ IpUienRkF Pf%rpo/sctviRnSgj hnJoxtqetsx.o".wevVPastryCrumbBloomRestored)
        let secondCard = makeTastingJournalCard(title: "CUrZeXahmj asYhXeYl/fR ?pbiqcGkg".wevVPastryCrumbBloomRestored, caption: "FgraeQs:h^ pb@aSkYejrMyp Ubpiktdej *sBa,vWezdG +fponrk glaaQt+eirs.p".wevVPastryCrumbBloomRestored)

        tastingJournalPanel.addSubview(donutStampTitle)
        tastingJournalPanel.addSubview(firstCard)
        tastingJournalPanel.addSubview(secondCard)

        NSLayoutConstraint.activate([
            tastingJournalPanel.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 112),
            tastingJournalPanel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 18),
            tastingJournalPanel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -18),
            tastingJournalPanel.heightAnchor.constraint(equalToConstant: 410),
            donutStampTitle.topAnchor.constraint(equalTo: tastingJournalPanel.topAnchor),
            donutStampTitle.leadingAnchor.constraint(equalTo: tastingJournalPanel.leadingAnchor),
            donutStampTitle.trailingAnchor.constraint(equalTo: tastingJournalPanel.trailingAnchor),
            firstCard.topAnchor.constraint(equalTo: donutStampTitle.bottomAnchor, constant: 22),
            firstCard.leadingAnchor.constraint(equalTo: tastingJournalPanel.leadingAnchor),
            firstCard.trailingAnchor.constraint(equalTo: tastingJournalPanel.trailingAnchor),
            secondCard.topAnchor.constraint(equalTo: firstCard.bottomAnchor, constant: 14),
            secondCard.leadingAnchor.constraint(equalTo: tastingJournalPanel.leadingAnchor),
            secondCard.trailingAnchor.constraint(equalTo: tastingJournalPanel.trailingAnchor)
        ])
    }

    private func buildDonutDiaryPanel() {
        donutDiaryPanel.translatesAutoresizingMaskIntoConstraints = false
        donutDiaryPanel.isHidden = true
        donutCaseContent.addSubview(donutDiaryPanel)

        let meButton = makeImageButton(asset: "wevv_profile_me_logo", action: #selector(openProfileSugarEntry))
        let gearButton = makeImageButton(asset: "wevv_profile_sugar_gear", action: #selector(openDonutDiarySettings))
        let statButton = makeProfileImageAction(asset: "wevv_profile_stat_glaze_band")
        statButton.addTarget(self, action: #selector(openGlazeFavoriteMoments), for: .touchUpInside)
        let avatarButton = makeProfileImageAction(asset: "wevv_profile_avatar_piano_donut")
        let shelfButton = makeProfileImageAction(asset: "wevv_profile_shop_shelf_card")
        shelfButton.removeTarget(nil, action: nil, for: .touchUpInside)
        shelfButton.addTarget(self, action: #selector(openBakeryShelf), for: .touchUpInside)
        let vaultdonutWevvButton = makeProfileImageAction(asset: "wevv_profile_donut_vault_card")
        vaultdonutWevvButton.removeTarget(nil, action: nil, for: .touchUpInside)
        vaultdonutWevvButton.addTarget(self, action: #selector(openDonutArchive), for: .touchUpInside)
        let postdonutWevvTitle = UIImageView(image: UIImage(named: "wevv_profile_sugar_post_title"))
        postdonutWevvTitle.translatesAutoresizingMaskIntoConstraints = false
        postdonutWevvTitle.contentMode = .scaleAspectFit

        donutDiaryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        donutDiaryNameLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        donutDiaryNameLabel.textAlignment = .center
        donutDiaryNameLabel.textColor = UIColor(red: 0.2, green: 0.07, blue: 0.26, alpha: 1)

        configureProfileCountLabel(bakeryTrailCountLabel)
        configureProfileCountLabel(tasterTrailCountLabel)
        configureProfileCardCountLabel(bakeryShelfCountLabel)
        configureProfileCardCountLabel(donutArchiveCountLabel)

        let folldonutWevvTitle = makeProfileTinyText("FGoUl+lio!wPibn=gL".wevVPastryCrumbBloomRestored)
        let foldonutWevvTitle = makeProfileTinyText("Frotl*lao@wsebrP".wevVPastryCrumbBloomRestored)
        let shelfTitle = makeProfileCardTitle("SOaOvie^ pSwhCotp/".wevVPastryCrumbBloomRestored)
        let vaultTitle = makeProfileCardTitle("WRaAlGlre?tQ".wevVPastryCrumbBloomRestored)
        let followingEntry = makeProfileRelationEntry(action: #selector(openBakeryTrailList))
        let followerEntry = makeProfileRelationEntry(action: #selector(openTasterTrailList))

        flavorNoteStack.translatesAutoresizingMaskIntoConstraints = false
        flavorNoteStack.axis = .vertical
        flavorNoteStack.spacing = 10

        emptyFlavorStack.translatesAutoresizingMaskIntoConstraints = false
        emptyFlavorStack.axis = .vertical
        emptyFlavorStack.alignment = .center
        emptyFlavorStack.spacing = 6
        let crumbEmptyImage = makeProfileCrumbEmptyImage()
        emptyFlavorStack.addArrangedSubview(crumbEmptyImage)

        placeSugarProfileViews(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton, followingTitle: folldonutWevvTitle, followerTitle: foldonutWevvTitle, followingEntry: followingEntry, followerEntry: followerEntry, shelfButton: shelfButton, vaultButton: vaultdonutWevvButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postdonutWevvTitle)
        pinSugarProfileLayout(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton, followingTitle: folldonutWevvTitle, followerTitle: foldonutWevvTitle, followingEntry: followingEntry, followerEntry: followerEntry, shelfButton: shelfButton, vaultButton: vaultdonutWevvButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postdonutWevvTitle, emptyImage: crumbEmptyImage)
        refreshDonutDiaryPanel()
    }

    private func makeProfileCrumbEmptyImage() -> UIImageView {
        let crumbEmptyImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        crumbEmptyImage.translatesAutoresizingMaskIntoConstraints = false
        crumbEmptyImage.contentMode = .scaleAspectFit
        return crumbEmptyImage
    }

    private func placeSugarProfileViews(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView) {
        donutDiaryPanel.addSubview(meButton)
        donutDiaryPanel.addSubview(gearButton)
        donutDiaryPanel.addSubview(statButton)
        donutDiaryPanel.addSubview(avatarButton)
        donutDiaryPanel.addSubview(donutDiaryNameLabel)
        donutDiaryPanel.addSubview(bakeryTrailCountLabel)
        donutDiaryPanel.addSubview(tasterTrailCountLabel)
        donutDiaryPanel.addSubview(followingTitle)
        donutDiaryPanel.addSubview(followerTitle)
        donutDiaryPanel.addSubview(followingEntry)
        donutDiaryPanel.addSubview(followerEntry)
        donutDiaryPanel.addSubview(shelfButton)
        donutDiaryPanel.addSubview(vaultButton)
        donutDiaryPanel.addSubview(bakeryShelfCountLabel)
        donutDiaryPanel.addSubview(donutArchiveCountLabel)
        donutDiaryPanel.addSubview(shelfTitle)
        donutDiaryPanel.addSubview(vaultTitle)
        donutDiaryPanel.addSubview(postTitle)
        donutDiaryPanel.addSubview(flavorNoteStack)
        donutDiaryPanel.addSubview(emptyFlavorStack)
    }

    private func pinSugarProfileLayout(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView, emptyImage: UIImageView) {
        pinSugarProfileTop(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton)
        pinSugarProfileRelations(statButton: statButton, followingTitle: followingTitle, followerTitle: followerTitle, followingEntry: followingEntry, followerEntry: followerEntry)
        pinSugarProfileCards(statButton: statButton, shelfButton: shelfButton, vaultButton: vaultButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postTitle, emptyImage: emptyImage)
    }

    private func pinSugarProfileTop(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl) {
        NSLayoutConstraint.activate([
            donutDiaryPanel.topAnchor.constraint(equalTo: donutCaseContent.topAnchor),
            donutDiaryPanel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            donutDiaryPanel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            meButton.topAnchor.constraint(equalTo: donutDiaryPanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            meButton.leadingAnchor.constraint(equalTo: donutDiaryPanel.leadingAnchor, constant: 25),
            meButton.widthAnchor.constraint(equalToConstant: 75),
            meButton.heightAnchor.constraint(equalToConstant: 30),
            gearButton.centerYAnchor.constraint(equalTo: meButton.centerYAnchor),
            gearButton.trailingAnchor.constraint(equalTo: donutDiaryPanel.trailingAnchor, constant: -15),
            gearButton.widthAnchor.constraint(equalToConstant: 44),
            gearButton.heightAnchor.constraint(equalToConstant: 44),
            statButton.topAnchor.constraint(equalTo: meButton.bottomAnchor, constant: 56),
            statButton.leadingAnchor.constraint(equalTo: donutDiaryPanel.leadingAnchor, constant: 20),
            statButton.trailingAnchor.constraint(equalTo: donutDiaryPanel.trailingAnchor, constant: -20),
            statButton.heightAnchor.constraint(equalTo: statButton.widthAnchor, multiplier: 60.0 / 335.0),
            avatarButton.centerXAnchor.constraint(equalTo: donutDiaryPanel.centerXAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: statButton.centerYAnchor, constant: -24),
            avatarButton.widthAnchor.constraint(equalToConstant: 108),
            avatarButton.heightAnchor.constraint(equalToConstant: 130),
            donutDiaryNameLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 4),
            donutDiaryNameLabel.centerXAnchor.constraint(equalTo: donutDiaryPanel.centerXAnchor),
            donutDiaryNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: donutDiaryPanel.leadingAnchor, constant: 36),
            donutDiaryNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: donutDiaryPanel.trailingAnchor, constant: -36)
        ])
    }

    private func pinSugarProfileRelations(statButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl) {
        NSLayoutConstraint.activate([
            bakeryTrailCountLabel.topAnchor.constraint(equalTo: statButton.topAnchor, constant: 12),
            bakeryTrailCountLabel.centerXAnchor.constraint(equalTo: statButton.leadingAnchor, constant: 70),
            followingTitle.topAnchor.constraint(equalTo: bakeryTrailCountLabel.bottomAnchor, constant: 2),
            followingTitle.centerXAnchor.constraint(equalTo: bakeryTrailCountLabel.centerXAnchor),
            followingEntry.leadingAnchor.constraint(equalTo: statButton.leadingAnchor),
            followingEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followingEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followingEntry.widthAnchor.constraint(equalToConstant: 132),
            tasterTrailCountLabel.topAnchor.constraint(equalTo: bakeryTrailCountLabel.topAnchor),
            tasterTrailCountLabel.centerXAnchor.constraint(equalTo: statButton.trailingAnchor, constant: -64),
            followerTitle.topAnchor.constraint(equalTo: tasterTrailCountLabel.bottomAnchor, constant: 2),
            followerTitle.centerXAnchor.constraint(equalTo: tasterTrailCountLabel.centerXAnchor),
            followerEntry.trailingAnchor.constraint(equalTo: statButton.trailingAnchor),
            followerEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followerEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followerEntry.widthAnchor.constraint(equalToConstant: 132)
        ])
    }

    private func pinSugarProfileCards(statButton: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView, emptyImage: UIImageView) {
        NSLayoutConstraint.activate([
            shelfButton.topAnchor.constraint(equalTo: statButton.bottomAnchor, constant: 28),
            shelfButton.leadingAnchor.constraint(equalTo: donutDiaryPanel.leadingAnchor, constant: 15),
            shelfButton.widthAnchor.constraint(equalTo: donutDiaryPanel.widthAnchor, multiplier: 0.434),
            shelfButton.heightAnchor.constraint(equalTo: shelfButton.widthAnchor, multiplier: 178.0 / 163.0),
            vaultButton.topAnchor.constraint(equalTo: shelfButton.topAnchor),
            vaultButton.trailingAnchor.constraint(equalTo: donutDiaryPanel.trailingAnchor, constant: -15),
            vaultButton.widthAnchor.constraint(equalTo: shelfButton.widthAnchor),
            vaultButton.heightAnchor.constraint(equalTo: shelfButton.heightAnchor),
            bakeryShelfCountLabel.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            bakeryShelfCountLabel.centerYAnchor.constraint(equalTo: shelfButton.centerYAnchor, constant: 18),
            shelfTitle.topAnchor.constraint(equalTo: bakeryShelfCountLabel.bottomAnchor, constant: 8),
            shelfTitle.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            shelfTitle.leadingAnchor.constraint(greaterThanOrEqualTo: shelfButton.leadingAnchor, constant: 10),
            shelfTitle.trailingAnchor.constraint(lessThanOrEqualTo: shelfButton.trailingAnchor, constant: -10),
            donutArchiveCountLabel.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            donutArchiveCountLabel.centerYAnchor.constraint(equalTo: vaultButton.centerYAnchor, constant: 18),
            vaultTitle.topAnchor.constraint(equalTo: donutArchiveCountLabel.bottomAnchor, constant: 8),
            vaultTitle.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            vaultTitle.leadingAnchor.constraint(greaterThanOrEqualTo: vaultButton.leadingAnchor, constant: 10),
            vaultTitle.trailingAnchor.constraint(lessThanOrEqualTo: vaultButton.trailingAnchor, constant: -10),
            postTitle.topAnchor.constraint(equalTo: shelfButton.bottomAnchor, constant: 20),
            postTitle.leadingAnchor.constraint(equalTo: donutDiaryPanel.leadingAnchor, constant: 15),
            postTitle.widthAnchor.constraint(equalToConstant: 97),
            postTitle.heightAnchor.constraint(equalToConstant: 24),
            flavorNoteStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 18),
            flavorNoteStack.leadingAnchor.constraint(equalTo: donutDiaryPanel.leadingAnchor, constant: 22),
            flavorNoteStack.trailingAnchor.constraint(equalTo: donutDiaryPanel.trailingAnchor, constant: -22),
            emptyFlavorStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 34),
            emptyFlavorStack.centerXAnchor.constraint(equalTo: donutDiaryPanel.centerXAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: 140),
            emptyImage.heightAnchor.constraint(equalToConstant: 153),
            emptyFlavorStack.bottomAnchor.constraint(equalTo: donutDiaryPanel.bottomAnchor),
            flavorNoteStack.bottomAnchor.constraint(lessThanOrEqualTo: donutDiaryPanel.bottomAnchor)
        ])
    }

    private func makeBakeryAtlasCard(_ bakeryAtlas: WevVBakeryAtlas) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.accessibilityIdentifier = bakeryAtlas.donutPinKey
        treatCaseCard.addTarget(self, action: #selector(openShopCarouselEntry(_:)), for: .touchUpInside)

        let carouselAsset: String
        switch bakeryAtlas.donutPinKey {
        case "berryRingBakery":
            carouselAsset = "wevv_shop_berry_ring_carousel"
        case "goldenDoughStudio":
            carouselAsset = "wevv_shop_golden_dough_carousel"
        case "moonlightDonutBar":
            carouselAsset = "wevv_shop_moonlight_donut_carousel"
        default:
            carouselAsset = bakeryAtlas.bakeryFrameAsset
        }
        let glazeImage = UIImageView(image: UIImage(named: carouselAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFit
        glazeImage.clipsToBounds = true
        treatCaseCard.addSubview(glazeImage)

        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor)
        ])
        return treatCaseCard
    }

    private func makeDonutVisitButton(_ dailyFrosting: WevVDailyDonutVisit) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = dailyFrosting.ringCutterKey
        sprinkleButton.addTarget(self, action: #selector(openDailyDonutStamp), for: .touchUpInside)

        let glazeImage = UIImageView(image: UIImage(named: dailyFrosting.cardAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleToFill
        glazeImage.clipsToBounds = true
        sprinkleButton.addSubview(glazeImage)

        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: sprinkleButton.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: sprinkleButton.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: sprinkleButton.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: sprinkleButton.bottomAnchor)
        ])
        return sprinkleButton
    }

    private func makeCompactDonutVisitButton(_ dailyFrosting: WevVDailyDonutVisit) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = dailyFrosting.ringCutterKey
        sprinkleButton.backgroundColor = UIColor(red: 1, green: 0.74, blue: 0.94, alpha: 1)
        sprinkleButton.layer.cornerRadius = 14
        sprinkleButton.clipsToBounds = true
        sprinkleButton.addTarget(self, action: #selector(openDailyDonutStamp), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Check-in"
        title.textColor = UIColor(red: 1, green: 0.16, blue: 0.76, alpha: 1)
        title.font = .systemFont(ofSize: 20, weight: .heavy)

        let daily = UILabel()
        daily.translatesAutoresizingMaskIntoConstraints = false
        daily.text = "Daily"
        daily.textColor = .white
        daily.font = .systemFont(ofSize: 13, weight: .bold)
        daily.textAlignment = .center
        daily.backgroundColor = UIColor(red: 1, green: 0.12, blue: 0.85, alpha: 1)
        daily.layer.cornerRadius = 7
        daily.clipsToBounds = true

        let ring = UIImageView(image: UIImage(named: "wevv_checkin_amazing_glaze_ring"))
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.contentMode = .scaleAspectFit

        sprinkleButton.addSubview(title)
        sprinkleButton.addSubview(daily)
        sprinkleButton.addSubview(ring)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: sprinkleButton.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: sprinkleButton.leadingAnchor, constant: 10),
            daily.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            daily.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            daily.widthAnchor.constraint(equalToConstant: 58),
            daily.heightAnchor.constraint(equalToConstant: 24),
            ring.trailingAnchor.constraint(equalTo: sprinkleButton.trailingAnchor, constant: -4),
            ring.centerYAnchor.constraint(equalTo: sprinkleButton.centerYAnchor),
            ring.widthAnchor.constraint(equalToConstant: 64),
            ring.heightAnchor.constraint(equalToConstant: 68)
        ])
        return sprinkleButton
    }

    private func makeCompactTastingQuestCard(_ tastingQuest: WevVTastingQuest) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.accessibilityIdentifier = tastingQuest.sprinkleJarKey
        treatCaseCard.accessibilityLabel = "\(tastingQuest.menuBoardTitle), \(tastingQuest.tastingTableText)"
        treatCaseCard.layer.cornerRadius = 14
        treatCaseCard.clipsToBounds = true
        treatCaseCard.addTarget(self, action: #selector(openChallengeDetail(_:)), for: .touchUpInside)

        let heroImage = UIImageView(image: WevVPastryImageVault.watercolorIcingDesign(for: tastingQuest.cardAsset))
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true

        let activity = makeActivityBadge()

        let participant = makeParticipantBadge(text: makeHomeTastingTableText(tastingQuest.tastingTableText))

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = tastingQuest.menuBoardTitle
        title.textColor = .white
        title.font = .systemFont(ofSize: 16, weight: .heavy)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.72

        treatCaseCard.addSubview(heroImage)
        treatCaseCard.addSubview(activity)
        treatCaseCard.addSubview(participant)
        treatCaseCard.addSubview(title)
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            heroImage.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor),
            activity.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 10),
            activity.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            activity.widthAnchor.constraint(equalToConstant: 66),
            activity.heightAnchor.constraint(equalToConstant: 22),
            participant.centerYAnchor.constraint(equalTo: activity.centerYAnchor),
            participant.leadingAnchor.constraint(greaterThanOrEqualTo: activity.trailingAnchor, constant: 4),
            participant.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -8),
            title.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -8),
            title.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor, constant: -12)
        ])
        return treatCaseCard
    }

    private func makeHomeGlazeRoomCard(_ room: pearFilling) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = "\(room.lemonCurd.rawValue):\(room.passionfruitMousse)"
        card.backgroundColor = UIColor(red: 0.25, green: 0.08, blue: 0.36, alpha: 1)
        card.layer.cornerRadius = 14
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(openGlazeRoom(_:)), for: .touchUpInside)

        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        setGlazeRemoteImage(room.appleCompote, on: cover)

        let liveBadge = UIImageView(image: UIImage(named: "wevv_home_live_badge"))
        liveBadge.translatesAutoresizingMaskIntoConstraints = false
        liveBadge.contentMode = .scaleAspectFit

        let signal = WevVGlazzestyOrangeEssence(glazeBarHeights: [7, 11, 16])
        signal.translatesAutoresizingMaskIntoConstraints = false

        let titleBand = UIView()
        titleBand.translatesAutoresizingMaskIntoConstraints = false
        titleBand.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = room.limeJam
        title.textColor = .white
        title.font = .systemFont(ofSize: 17, weight: .heavy)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7

        card.addSubview(cover)
        card.addSubview(liveBadge)
        card.addSubview(signal)
        card.addSubview(titleBand)
        titleBand.addSubview(title)
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.99),
            cover.topAnchor.constraint(equalTo: card.topAnchor),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            liveBadge.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            liveBadge.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            liveBadge.widthAnchor.constraint(equalToConstant: 54),
            liveBadge.heightAnchor.constraint(equalToConstant: 22),
            signal.topAnchor.constraint(equalTo: card.topAnchor, constant: 13),
            signal.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -11),
            signal.widthAnchor.constraint(equalToConstant: 17),
            signal.heightAnchor.constraint(equalToConstant: 17),
            titleBand.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            titleBand.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            titleBand.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            titleBand.heightAnchor.constraint(equalToConstant: 40),
            title.leadingAnchor.constraint(equalTo: titleBand.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: titleBand.trailingAnchor, constant: -8),
            title.centerYAnchor.constraint(equalTo: titleBand.centerYAnchor)
        ])
        return card
    }

    private func makeTastingParlorRoomCard(_ room: pearFilling, position: Int) -> UIControl {
        let paletteIndex = position % 3
        let palettes: [[UIColor]] = [
            [UIColor(red: 0.75, green: 0.57, blue: 0.99, alpha: 1), UIColor(red: 0.53, green: 0.70, blue: 0.98, alpha: 1)],
            [UIColor(red: 0.57, green: 0.13, blue: 0.98, alpha: 1), UIColor(red: 0.43, green: 0.47, blue: 0.97, alpha: 1)],
            [UIColor(red: 0.99, green: 0.35, blue: 0.72, alpha: 1), UIColor(red: 1.0, green: 0.86, blue: 0.55, alpha: 1)]
        ]
        let card = WevVGlazepillowyCrumb(chewyCrust: palettes[paletteIndex])
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = "\(room.lemonCurd.rawValue):\(room.passionfruitMousse)"
        card.isAccessibilityElement = true
        card.accessibilityLabel = "Join \(room.limeJam), \(room.figFilling) online"
        card.accessibilityTraits = .button
        card.layer.cornerRadius = 14
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(openGlazeRoom(_:)), for: .touchUpInside)

        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12
        if let coverURL = room.pearCenter ?? room.appleCompote {
            setGlazeRemoteImage(coverURL, on: cover)
        } else {
            cover.image = UIImage(named: "wevv_guest_glaze_arlo")
        }

        let ranking = WevVInsetLabel()
        ranking.translatesAutoresizingMaskIntoConstraints = false
        let rankingIndex = room.pistachioCustard.flatMap { $0 > 0 ? $0 : nil } ?? position + 1
        ranking.text = "Hourly Country Ranking No.\(rankingIndex)"
        ranking.textColor = .white
        ranking.font = UIFont(name: "Poppins-Medium", size: 11) ?? .systemFont(ofSize: 11, weight: .medium)
        ranking.textInsets = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
        ranking.backgroundColor = paletteIndex == 0
            ? UIColor(red: 1, green: 0.58, blue: 0.02, alpha: 1)
            : UIColor(red: 0.43, green: 0.15, blue: 0.75, alpha: 0.58)
        ranking.layer.cornerRadius = 4
        ranking.layer.maskedCorners = [.layerMaxXMaxYCorner]
        ranking.clipsToBounds = true
        ranking.textAlignment = .left

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = room.limeJam
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.72

        let audience = UILabel()
        audience.translatesAutoresizingMaskIntoConstraints = false
        audience.text = "\(room.figFilling) online"
        audience.textColor = .white
        audience.font = .systemFont(ofSize: 14, weight: .medium)

        let tasterRow = UIStackView()
        tasterRow.translatesAutoresizingMaskIntoConstraints = false
        tasterRow.axis = .horizontal
        tasterRow.spacing = -5
        let tasterURLs = room.custardCurd.isEmpty
            ? [room.pearCenter].compactMap { $0 }
            : Array(room.custardCurd.prefix(3))
        for (index, avatarURL) in tasterURLs.prefix(3).enumerated() {
            tasterRow.addArrangedSubview(makeTastingParlorAvatar(url: avatarURL, diameter: 21, fallback: index))
        }

        let kind = UILabel()
        kind.translatesAutoresizingMaskIntoConstraints = false
        kind.text = "Voice Room"
        kind.textColor = .white
        kind.font = UIFont(name: "Poppins-Medium", size: 11) ?? .systemFont(ofSize: 11, weight: .medium)
        kind.textAlignment = .center
        kind.backgroundColor = UIColor(red: 0.27, green: 0.04, blue: 0.55, alpha: 0.34)
        kind.layer.cornerRadius = 10.5
        kind.clipsToBounds = true

        let join = UILabel()
        join.translatesAutoresizingMaskIntoConstraints = false
        join.text = "Join ↗"
        join.textColor = .white
        join.font = .systemFont(ofSize: 15, weight: .bold)
        join.textAlignment = .center
        join.backgroundColor = UIColor(red: 0.20, green: 0.05, blue: 0.38, alpha: 0.26)
        join.layer.cornerRadius = 14
        join.clipsToBounds = true

        let signal = WevVGlazzestyOrangeEssence(glazeBarHeights: [7, 10, 13])
        signal.translatesAutoresizingMaskIntoConstraints = false

        [cover, ranking, title, tasterRow, audience, kind, join, signal].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 124),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            cover.widthAnchor.constraint(equalTo: cover.heightAnchor),
            ranking.topAnchor.constraint(equalTo: card.topAnchor),
            ranking.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            ranking.widthAnchor.constraint(lessThanOrEqualTo: card.widthAnchor, multiplier: 0.54),
            ranking.heightAnchor.constraint(equalToConstant: 24),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 34),
            title.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: signal.leadingAnchor, constant: -8),
            tasterRow.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            tasterRow.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            tasterRow.heightAnchor.constraint(equalToConstant: 21),
            audience.leadingAnchor.constraint(equalTo: tasterRow.trailingAnchor, constant: 8),
            audience.centerYAnchor.constraint(equalTo: tasterRow.centerYAnchor),
            audience.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -12),
            kind.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            kind.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
            kind.widthAnchor.constraint(equalToConstant: 78),
            kind.heightAnchor.constraint(equalToConstant: 21),
            join.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -9),
            join.centerYAnchor.constraint(equalTo: kind.centerYAnchor),
            join.widthAnchor.constraint(equalToConstant: 70),
            join.heightAnchor.constraint(equalToConstant: 28),
            signal.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            signal.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
            signal.widthAnchor.constraint(equalToConstant: 17),
            signal.heightAnchor.constraint(equalToConstant: 14)
        ])
        return card
    }

    private func configureTastingJournalShelfButton(_ button: UIButton, title: String, shelf: goldenCrumbDough) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.tag = shelf.rawValue
        button.accessibilityLabel = title
        button.addTarget(self, action: #selector(selectTastingJournalShelf(_:)), for: .touchUpInside)
    }

    @objc private func selectTastingJournalShelf(_ sender: UIButton) {
        guard let shelf = goldenCrumbDough(rawValue: sender.tag) else { return }
        updateTastingJournalShelf(shelf, animated: true, movesPager: true)
    }

    private func updateTastingJournalShelf(_ shelf: goldenCrumbDough, animated: Bool, movesPager: Bool) {
        tastingJournalShelf = shelf
        let selectedButton = shelf == .artisanFrySequence ? tastingJournalTrendingButton : tastingJournalFollowButton
        tastingJournalTrendingButton.titleLabel?.font = .systemFont(ofSize: 21, weight: shelf == .artisanFrySequence ? .heavy : .regular)
        tastingJournalFollowButton.titleLabel?.font = .systemFont(ofSize: 21, weight: shelf == .cherryCenter ? .heavy : .regular)
        tastingJournalSelectionCenterConstraint?.isActive = false
        tastingJournalSelectionCenterConstraint = tastingJournalSelectionBar.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        tastingJournalSelectionCenterConstraint?.isActive = true
        let changes = { self.bakeryAtlasPanel.layoutIfNeeded() }
        if animated {
            UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: changes)
        } else {
            changes()
        }
        if movesPager, tastingJournalMomentPager.bounds.width > 0 {
            tastingJournalMomentPager.setContentOffset(
                CGPoint(x: CGFloat(shelf.rawValue) * tastingJournalMomentPager.bounds.width, y: 0),
                animated: animated
            )
        }
    }

    private func rebuildTastingJournalMomentPages() {
        fillTastingJournalMomentPage(
            tastingJournalTrendingMoments,
            starchGelatinizationStudy: Array(glazeTrendingMomentItems.prefix(4)),
            emptyText: "Trending posts will appear here."
        )
        fillTastingJournalMomentPage(
            tastingJournalFollowMoments,
            starchGelatinizationStudy: Array(glazeFollowedMomentItems.prefix(4)),
            emptyText: donutJournalStore.isTasterReady
                ? "No posts from followed creators yet."
                : "Sign in to see posts from creators you follow."
        )
    }

    private func fillTastingJournalMomentPage(_ page: UIView, starchGelatinizationStudy: [butteryTexture], emptyText: String) {
        page.subviews.forEach { $0.removeFromSuperview() }
        guard let featuredMoment = starchGelatinizationStudy.first else {
            let empty = UILabel()
            empty.translatesAutoresizingMaskIntoConstraints = false
            empty.text = emptyText
            empty.textColor = UIColor(red: 0.34, green: 0.24, blue: 0.39, alpha: 1)
            empty.font = .systemFont(ofSize: 15, weight: .semibold)
            empty.textAlignment = .center
            empty.numberOfLines = 0
            page.addSubview(empty)
            NSLayoutConstraint.activate([
                empty.centerXAnchor.constraint(equalTo: page.centerXAnchor),
                empty.centerYAnchor.constraint(equalTo: page.centerYAnchor),
                empty.leadingAnchor.constraint(greaterThanOrEqualTo: page.leadingAnchor, constant: 24),
                empty.trailingAnchor.constraint(lessThanOrEqualTo: page.trailingAnchor, constant: -24)
            ])
            return
        }

        let featured = makeTastingJournalFeaturedMoment(featuredMoment)
        let sideColumn = UIStackView()
        sideColumn.translatesAutoresizingMaskIntoConstraints = false
        sideColumn.axis = .vertical
        sideColumn.spacing = 8
        sideColumn.distribution = .fillEqually
        sideColumn.backgroundColor = UIColor(red: 253.0 / 255.0, green: 236.0 / 255.0, blue: 1, alpha: 1)
        sideColumn.layer.cornerRadius = 18
        sideColumn.clipsToBounds = true
        sideColumn.isLayoutMarginsRelativeArrangement = true
        sideColumn.layoutMargins = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        for moment in starchGelatinizationStudy.dropFirst().prefix(3) {
            sideColumn.addArrangedSubview(makeTastingJournalSideMoment(moment))
        }
        while sideColumn.arrangedSubviews.count < 3 {
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            sideColumn.addArrangedSubview(spacer)
        }

        page.addSubview(featured)
        page.addSubview(sideColumn)
        NSLayoutConstraint.activate([
            featured.topAnchor.constraint(equalTo: page.topAnchor),
            featured.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            featured.bottomAnchor.constraint(equalTo: page.bottomAnchor),
            featured.widthAnchor.constraint(equalTo: page.widthAnchor, multiplier: 0.68),
            sideColumn.topAnchor.constraint(equalTo: page.topAnchor, constant: 1),
            sideColumn.leadingAnchor.constraint(equalTo: featured.trailingAnchor, constant: 10),
            sideColumn.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            sideColumn.bottomAnchor.constraint(equalTo: page.bottomAnchor, constant: -1)
        ])
    }

    private func makeTastingJournalFeaturedMoment(_ moment: butteryTexture) -> UIView {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = String(moment.coconutCenter)
        card.addTarget(self, action: #selector(openDonutSnapshotDetail(_:)), for: .touchUpInside)
        card.backgroundColor = UIColor(red: 1, green: 0.92, blue: 1, alpha: 0.94)
        card.layer.cornerRadius = 18
        card.clipsToBounds = true

        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.backgroundColor = UIColor(red: 0.96, green: 0.85, blue: 0.96, alpha: 1)
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 13
        setGlazeRemoteImage(moment.passionfruitFilling.first, on: cover)

        let shade = UIView()
        shade.translatesAutoresizingMaskIntoConstraints = false
        // The design keeps the hero image bright; the author row sits over its upper edge.
        shade.backgroundColor = UIColor.black.withAlphaComponent(0.04)

        let avatar = makeTastingJournalAvatarControl(moment, diameter: 31)
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = moment.gingerHoneyDrizzle
        name.textColor = .white
        name.font = .systemFont(ofSize: 15, weight: .semibold)
        name.lineBreakMode = .byTruncatingTail

        let followMark = makeTastingJournalFollowControl(moment, diameter: 30, fontSize: 22)

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = moment.caramelCurd
        caption.textColor = .black
        caption.font = .systemFont(ofSize: 16, weight: .semibold)
        caption.numberOfLines = 2
        caption.lineBreakMode = .byTruncatingTail

        [cover, shade, avatar, name, followMark, caption].forEach { card.addSubview($0) }
        let preferredCoverHeight = cover.heightAnchor.constraint(equalToConstant: 298)
        preferredCoverHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 11),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 11),
            cover.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -11),
            preferredCoverHeight,
            cover.heightAnchor.constraint(lessThanOrEqualTo: card.heightAnchor, constant: -70),
            shade.leadingAnchor.constraint(equalTo: cover.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: cover.trailingAnchor),
            shade.topAnchor.constraint(equalTo: cover.topAnchor),
            shade.heightAnchor.constraint(equalToConstant: 58),
            avatar.leadingAnchor.constraint(equalTo: cover.leadingAnchor, constant: 14),
            avatar.centerYAnchor.constraint(equalTo: shade.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            name.trailingAnchor.constraint(lessThanOrEqualTo: followMark.leadingAnchor, constant: -7),
            followMark.trailingAnchor.constraint(equalTo: cover.trailingAnchor, constant: -14),
            followMark.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            followMark.widthAnchor.constraint(equalToConstant: 30),
            followMark.heightAnchor.constraint(equalTo: followMark.widthAnchor),
            caption.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 10),
            caption.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            caption.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            caption.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -10)
        ])
        return card
    }

    private func makeTastingJournalSideMoment(_ moment: butteryTexture) -> UIView {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = String(moment.coconutCenter)
        card.addTarget(self, action: #selector(openDonutSnapshotDetail(_:)), for: .touchUpInside)
        card.backgroundColor = .clear
        card.layer.cornerRadius = 0
        card.clipsToBounds = true

        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.backgroundColor = UIColor(red: 0.96, green: 0.85, blue: 0.96, alpha: 1)
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 10
        setGlazeRemoteImage(moment.passionfruitFilling.first, on: cover)

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = moment.gingerHoneyDrizzle
        name.textColor = .black
        name.font = .systemFont(ofSize: 14, weight: .bold)
        name.lineBreakMode = .byTruncatingTail

        card.addSubview(cover)
        card.addSubview(name)
        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 7),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 7),
            cover.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -7),
            cover.bottomAnchor.constraint(equalTo: name.topAnchor, constant: -5),
            name.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 7),
            name.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -6),
            name.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -7),
            name.heightAnchor.constraint(equalToConstant: 18)
        ])
        return card
    }

    private func makeGlazeMomentCard(_ moment: butteryTexture, showsHotMark: Bool) -> UIView {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = String(moment.coconutCenter)
        card.addTarget(self, action: #selector(openDonutSnapshotDetail(_:)), for: .touchUpInside)
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.clipsToBounds = true

        let cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.backgroundColor = UIColor(red: 0.97, green: 0.88, blue: 0.96, alpha: 1)
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12
        setGlazeRemoteImage(moment.passionfruitFilling.first, on: cover)

        let avatar = makeTastingJournalAvatarControl(moment, diameter: 28)

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = moment.gingerHoneyDrizzle
        name.textColor = UIColor(red: 0.20, green: 0.17, blue: 0.21, alpha: 1)
        name.font = .systemFont(ofSize: 16, weight: .bold)
        name.lineBreakMode = .byTruncatingTail

        let followMark = makeTastingJournalFollowControl(moment, diameter: 28, fontSize: 21)

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = moment.caramelCurd
        caption.textColor = .black
        caption.font = .systemFont(ofSize: 15, weight: .semibold)
        caption.numberOfLines = 2
        caption.lineBreakMode = .byTruncatingTail

        let tagPalette = [
            UIColor(red: 0.72, green: 0.35, blue: 1, alpha: 1),
            UIColor(red: 1, green: 0.30, blue: 0.66, alpha: 1),
            UIColor(red: 0.98, green: 0.58, blue: 0.18, alpha: 1)
        ]
        let tags = makeTastingJournalTags(for: moment)
        let tagViews = tags.enumerated().map { index, tag in
            makeTastingJournalCountMark(tag, color: tagPalette[index % tagPalette.count])
        }
        let countRow = UIStackView(arrangedSubviews: tagViews)
        countRow.translatesAutoresizingMaskIntoConstraints = false
        countRow.axis = .horizontal
        countRow.spacing = 7

        let hotMark = UILabel()
        hotMark.translatesAutoresizingMaskIntoConstraints = false
        hotMark.text = "🔥Hot"
        hotMark.textColor = .white
        hotMark.font = .systemFont(ofSize: 13, weight: .medium)
        hotMark.textAlignment = .center
        hotMark.backgroundColor = UIColor(red: 1, green: 0.56, blue: 0.04, alpha: 1)
        hotMark.layer.cornerRadius = 9
        hotMark.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        hotMark.clipsToBounds = true
        hotMark.isHidden = !showsHotMark

        [cover, avatar, name, followMark, caption, countRow, hotMark].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 140),
            cover.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            cover.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            cover.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),
            cover.widthAnchor.constraint(equalToConstant: 96),
            avatar.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 7),
            name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            name.trailingAnchor.constraint(lessThanOrEqualTo: followMark.leadingAnchor, constant: -7),
            followMark.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            followMark.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            followMark.widthAnchor.constraint(equalToConstant: 28),
            followMark.heightAnchor.constraint(equalTo: followMark.widthAnchor),
            caption.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            caption.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            caption.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            countRow.leadingAnchor.constraint(equalTo: caption.leadingAnchor),
            countRow.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 7),
            countRow.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -11),
            hotMark.topAnchor.constraint(equalTo: card.topAnchor),
            hotMark.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            hotMark.widthAnchor.constraint(equalToConstant: 54),
            hotMark.heightAnchor.constraint(equalToConstant: 27)
        ])
        return card
    }

    private func makeTastingJournalCountMark(_ text: String, color: UIColor) -> UILabel {
        let mark = UILabel()
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.text = text
        mark.textColor = .white
        mark.textAlignment = .center
        mark.font = .systemFont(ofSize: 12, weight: .semibold)
        mark.backgroundColor = color
        mark.layer.cornerRadius = 10
        mark.clipsToBounds = true
        NSLayoutConstraint.activate([
            mark.widthAnchor.constraint(greaterThanOrEqualToConstant: max(50, CGFloat(text.count * 7 + 18))),
            mark.heightAnchor.constraint(equalToConstant: 22)
        ])
        return mark
    }

    private func makeTastingJournalTags(for moment: butteryTexture) -> [String] {
        let explicitTags = moment.caramelCurd
            .split(whereSeparator: { $0 == " " || $0 == "\n" })
            .map(String.init)
            .filter { $0.hasPrefix("#") && $0.count > 1 }
            .map { String($0.dropFirst()).trimmingCharacters(in: .punctuationCharacters) }
            .filter { !$0.isEmpty }
        if !explicitTags.isEmpty {
            return Array(explicitTags.prefix(2))
        }

        let lowercasedText = moment.caramelCurd.lowercased()
        let contextualTags: [(String, [String])] = [
            ("CoffeePairing", ["coffee", "latte", "espresso"]),
            ("GlazeLove", ["glaze", "frosting", "icing"]),
            ("SprinkleTime", ["sprinkle", "rainbow"]),
            ("BakeryFinds", ["bakery", "shop", "bakery"]),
            ("FreshlyBaked", ["fresh", "bake", "oven"])
        ]
        let matched = contextualTags.compactMap { tag, keywords in
            keywords.contains(where: { lowercasedText.contains($0) }) ? tag : nil
        }
        if !matched.isEmpty {
            return Array(matched.prefix(2))
        }

        // No server-side tag field exists in the current API. Keep fallback tags
        // deterministic per post so refreshes do not visibly reshuffle the UI.
        let fallbackTags = ["Sweet", "SweetTreats", "DoughnutDay", "DonutJoy", "TreatTime", "SugarRush"]
        let seed = Int(abs(moment.coconutCenter % Int64(fallbackTags.count)))
        return [fallbackTags[seed], fallbackTags[(seed + 1) % fallbackTags.count]]
    }

    private func makeTastingJournalAvatarControl(_ moment: butteryTexture, diameter: CGFloat) -> UIControl {
        let owner = UIControl()
        owner.translatesAutoresizingMaskIntoConstraints = false
        owner.isAccessibilityElement = true
        owner.accessibilityIdentifier = String(moment.vanillaBeanIcing)
        owner.accessibilityLabel = "Open \(moment.gingerHoneyDrizzle)'s profile"
        owner.isUserInteractionEnabled = moment.vanillaBeanIcing > 0
        owner.addTarget(self, action: #selector(openTastingParlorOwner(_:)), for: .touchUpInside)

        let avatar = makeTastingParlorAvatar(
            url: moment.cheesecakeMousse,
            diameter: diameter,
            fallback: Int(moment.vanillaBeanIcing % 3)
        )
        avatar.isUserInteractionEnabled = false
        owner.addSubview(avatar)
        NSLayoutConstraint.activate([
            owner.widthAnchor.constraint(equalToConstant: diameter),
            owner.heightAnchor.constraint(equalToConstant: diameter),
            avatar.topAnchor.constraint(equalTo: owner.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: owner.leadingAnchor),
            avatar.trailingAnchor.constraint(equalTo: owner.trailingAnchor),
            avatar.bottomAnchor.constraint(equalTo: owner.bottomAnchor)
        ])
        return owner
    }

    private func makeTastingJournalFollowControl(_ moment: butteryTexture, diameter: CGFloat, fontSize: CGFloat) -> UIButton {
        let followButton = UIButton(type: .custom)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.accessibilityIdentifier = String(moment.vanillaBeanIcing)
        followButton.accessibilityLabel = moment.mascarponeCream ? "Unfollow \(moment.gingerHoneyDrizzle)" : "Follow \(moment.gingerHoneyDrizzle)"
        followButton.setTitle(moment.mascarponeCream ? "✓" : "+", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .medium)
        followButton.backgroundColor = moment.mascarponeCream ? .black : UIColor(red: 1, green: 0.12, blue: 0.57, alpha: 1)
        followButton.layer.cornerRadius = diameter / 2
        followButton.clipsToBounds = true
        followButton.isEnabled = moment.vanillaBeanIcing > 0
        followButton.addTarget(self, action: #selector(toggleTastingJournalFollow(_:)), for: .touchUpInside)
        return followButton
    }

    @objc private func toggleTastingJournalFollow(_ sender: UIButton) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        guard glazeJournalFollowTask == nil,
              let identifier = sender.accessibilityIdentifier,
              let userID = Int64(identifier),
              userID > 0,
              let moment = (glazeTrendingMomentItems + glazeFollowedMomentItems).first(where: { $0.vanillaBeanIcing == userID }) else { return }

        sender.isEnabled = false
        let shouldFollow = !moment.mascarponeCream
        sender.accessibilityLabel = shouldFollow ? "Unfollow \(moment.gingerHoneyDrizzle)" : "Follow \(moment.gingerHoneyDrizzle)"
        sender.setTitle(shouldFollow ? "✓" : "+", for: .normal)
        sender.backgroundColor = shouldFollow ? .black : UIColor(red: 1, green: 0.12, blue: 0.57, alpha: 1)
        glazeJournalFollowTask = Task { [weak self, weak sender] in
            guard let self else { return }
            do {
                try await glazeSocialRepository.riversideBakery(vanillaBeanIcing: userID, autumnPecanCollection: shouldFollow)
                glazeJournalFollowTask = nil
                loadGlazeContent(showsLoading: false)
            } catch {
                glazeJournalFollowTask = nil
                sender?.isEnabled = true
                sender?.accessibilityLabel = moment.mascarponeCream ? "Unfollow \(moment.gingerHoneyDrizzle)" : "Follow \(moment.gingerHoneyDrizzle)"
                sender?.setTitle(moment.mascarponeCream ? "✓" : "+", for: .normal)
                sender?.backgroundColor = moment.mascarponeCream ? .black : UIColor(red: 1, green: 0.12, blue: 0.57, alpha: 1)
                showRootSugarHint(error.localizedDescription)
            }
        }
    }

    private func makeTastingQuestCard(_ tastingQuest: WevVTastingQuest) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.accessibilityIdentifier = tastingQuest.sprinkleJarKey
        treatCaseCard.accessibilityLabel = "\(tastingQuest.menuBoardTitle), \(tastingQuest.tastingTableText)"
        treatCaseCard.backgroundColor = UIColor(red: 0.80, green: 0.68, blue: 1.0, alpha: 1)
        treatCaseCard.layer.cornerRadius = 16
        treatCaseCard.clipsToBounds = true
        treatCaseCard.addTarget(self, action: #selector(openChallengeDetail(_:)), for: .touchUpInside)

        let heroImage = UIImageView(image: WevVPastryImageVault.watercolorIcingDesign(for: tastingQuest.cardAsset))
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        heroImage.layer.cornerRadius = 13
        let glazeTitleLabel = makeSprinkleQuestNameLabel(tastingQuest.menuBoardTitle)
        glazeTitleLabel.textAlignment = .left
        glazeTitleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        let tasterAvatars = makeChallengeTasterStack(for: tastingQuest)

        let activity = makeActivityBadge()

        let participant = makeParticipantBadge(text: makeHomeTastingTableText(tastingQuest.tastingTableText))

        let join = UILabel()
        join.translatesAutoresizingMaskIntoConstraints = false
        join.text = "Join ↗"
        join.textColor = .white
        join.font = .systemFont(ofSize: 15, weight: .bold)
        join.textAlignment = .center
        join.backgroundColor = UIColor(red: 0.69, green: 0.55, blue: 1, alpha: 0.9)
        join.layer.cornerRadius = 15
        join.clipsToBounds = true

        [heroImage, activity, participant, glazeTitleLabel, tasterAvatars, join].forEach {
            treatCaseCard.addSubview($0)
        }
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 9),
            heroImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 9),
            heroImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -9),
            heroImage.heightAnchor.constraint(equalTo: treatCaseCard.heightAnchor, multiplier: 150.0 / 215.0, constant: -15),
            activity.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 10),
            activity.leadingAnchor.constraint(equalTo: heroImage.leadingAnchor, constant: 10),
            activity.widthAnchor.constraint(equalToConstant: 67),
            activity.heightAnchor.constraint(equalToConstant: 23),
            participant.centerYAnchor.constraint(equalTo: activity.centerYAnchor),
            participant.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: -8),
            glazeTitleLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 9),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -8),
            tasterAvatars.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            tasterAvatars.centerYAnchor.constraint(equalTo: join.centerYAnchor),
            join.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -10),
            join.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor, constant: -20),
            join.widthAnchor.constraint(equalToConstant: 78),
            join.heightAnchor.constraint(equalToConstant: 31)
        ])
        return treatCaseCard
    }

    private func makeActivityBadge() -> UIView {
        let badge = WevVfigMoussepearJam()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.layer.cornerRadius = 11
        badge.clipsToBounds = true
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Activity"
        title.textColor = .white
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 12, weight: .bold)
        badge.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: badge.leadingAnchor), title.trailingAnchor.constraint(equalTo: badge.trailingAnchor),
            title.topAnchor.constraint(equalTo: badge.topAnchor), title.bottomAnchor.constraint(equalTo: badge.bottomAnchor)
        ])
        return badge
    }

    private func makeParticipantBadge(text: String) -> UIView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 4
        let count = UILabel()
        count.text = text.filter(\.isNumber)
        count.textColor = .white
        count.font = .systemFont(ofSize: 13, weight: .bold)
        let icon = UIImageView(image: UIImage(named: "wevv_home_activity_participant"))
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        row.addArrangedSubview(count); row.addArrangedSubview(icon)
        icon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return row
    }

    private func makeHomeTastingTableText(_ tastingTableText: String) -> String {
        let participantCount = tastingTableText.filter(\.isNumber)
        return participantCount.isEmpty ? tastingTableText : participantCount
    }

    private func makeSprinkleQuestHeroImage(asset: String) -> UIImageView {
        let heroImage = UIImageView(image: WevVPastryImageVault.watercolorIcingDesign(for: asset))
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        heroImage.layer.cornerRadius = 56
        heroImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return heroImage
    }

    private func makeSprinkleQuestFrameImage() -> UIImageView {
        let frameImage = UIImageView(image: UIImage(named: "wevv_challenge_donutjoy_card"))
        frameImage.translatesAutoresizingMaskIntoConstraints = false
        frameImage.contentMode = .scaleToFill
        frameImage.clipsToBounds = true
        return frameImage
    }

    private func makeSprinkleQuestNameLabel(_ sugarTitle: String) -> UILabel {
        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = sugarTitle
        glazeTitleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        glazeTitleLabel.textColor = .black
        glazeTitleLabel.textAlignment = .center
        glazeTitleLabel.adjustsFontSizeToFitWidth = true
        glazeTitleLabel.minimumScaleFactor = 0.7
        return glazeTitleLabel
    }

    private func makeSprinkleQuestJoinLabel(_ sugarText: String) -> UILabel {
        let joinLabel = UILabel()
        joinLabel.translatesAutoresizingMaskIntoConstraints = false
        joinLabel.text = sugarText
        joinLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        joinLabel.textColor = .white
        joinLabel.textAlignment = .right
        return joinLabel
    }

    private func makeSprinkleQuestArrowImage() -> UIImageView {
        let arrowImage = UIImageView(image: UIImage(named: "wevv_challenge_join_arrow"))
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.contentMode = .scaleAspectFit
        return arrowImage
    }

    private func makeHomeSafetyButton(_ sugarDustKey: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = sugarDustKey
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        sprinkleButton.layer.cornerRadius = 17
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func placeChallengeCardViews(treatCaseCard: UIControl, heroImage: UIImageView, frameImage: UIImageView, glazeTitleLabel: UILabel, tasterAvatars: UIView, joinLabel: UILabel, arrowImage: UIImageView, safetyButton: UIButton) {
        [heroImage, frameImage, glazeTitleLabel, tasterAvatars, joinLabel, arrowImage, safetyButton].forEach {
            treatCaseCard.addSubview($0)
        }
    }

    private func pinChallengeCardLayout(treatCaseCard: UIControl, heroImage: UIImageView, frameImage: UIImageView, glazeTitleLabel: UILabel, tasterAvatars: UIView, joinLabel: UILabel, arrowImage: UIImageView, safetyButton: UIButton) {
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 36),
            heroImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            heroImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -10),
            heroImage.heightAnchor.constraint(equalToConstant: 150),
            frameImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor),
            frameImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            frameImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            frameImage.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor),
            glazeTitleLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: -8),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 11),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -11),
            tasterAvatars.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 10),
            tasterAvatars.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            tasterAvatars.widthAnchor.constraint(equalToConstant: 58),
            tasterAvatars.heightAnchor.constraint(equalToConstant: 24),
            joinLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -7),
            joinLabel.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor, constant: -14),
            joinLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tasterAvatars.trailingAnchor, constant: 4),
            arrowImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -18),
            arrowImage.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 15),
            arrowImage.heightAnchor.constraint(equalToConstant: 15),
            safetyButton.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 38),
            safetyButton.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -16),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeChallengeTasterStack(for tastingQuest: WevVTastingQuest) -> UIView {
        let ringStack = UIView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        let keys = makeChallengeTasterKeys(for: tastingQuest)
        for (index, key) in keys.enumerated() {
            let avatar = makeChallengedonutWevvTasterAvatar(key: key)
            ringStack.addSubview(avatar)
            NSLayoutConstraint.activate([
                avatar.leadingAnchor.constraint(equalTo: ringStack.leadingAnchor, constant: CGFloat(index * 17)),
                avatar.centerYAnchor.constraint(equalTo: ringStack.centerYAnchor),
                avatar.widthAnchor.constraint(equalToConstant: 24),
                avatar.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        ringStack.widthAnchor.constraint(equalToConstant: CGFloat(max(keys.count - 1, 0) * 17 + 24)).isActive = true
        ringStack.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return ringStack
    }

    private func makeChallengeTasterKeys(for tastingQuest: WevVTastingQuest) -> [String] {
        let keys = [
            tastingQuest.tasterBadgeKey,
            "lzuinPaMLpaquogfhlG/luaXz#ev".wevVPastryCrumbBloomRestored,
            "njolvyaBBIuAbdbBlIe;GdlxaPzveD".wevVPastryCrumbBloomRestored,
            "aJrZl/oiSlk;yoG:lWaYzLej".wevVPastryCrumbBloomRestored,
            "rsh;eeaJHloOnPenyiGKlGaXzJei".wevVPastryCrumbBloomRestored
        ]
        var seenKeys = Set<String>()
        return keys.filter { donutPinKey in
            guard !seenKeys.contains(donutPinKey) else { return false }
            seenKeys.insert(donutPinKey)
            return true
        }.prefix(3).map { $0 }
    }

    private func makeChallengedonutWevvTasterAvatar(key: String) -> UIImageView {
        let profile = bakeryTasterStore.profile(for: key)
        let avatar = UIImageView(image: UIImage(named: profile.donutFrameAsset) ?? makeFrostingAvatarImage(seed: key))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 12
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        return avatar
    }

    private func makeDonutSnapshotCard(_ donutSnapshot: WevVDonutSnapshot) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.accessibilityIdentifier = donutSnapshot.sprinkleJarKey
        treatCaseCard.clipsToBounds = true
        treatCaseCard.layer.cornerRadius = 15
        treatCaseCard.addTarget(self, action: #selector(openDonutSnapshotDetail(_:)), for: .touchUpInside)

        let heroImage = makeSprinkleMomentHeroImage(donutSnapshot)
        let textBand = makeSprinkleMomentTextBand()
        let captionLabel = makeSprinkleMomentCaption(donutSnapshot.tastingText)
        let avatar = makeSprinkleMomentAvatar(donutSnapshot)
        let tasterNameLabel = makeSprinkleMomentName(donutSnapshot.tasterBloom.name)
        let safetyButton = makeSprinkleMomentSafetyButton(donutSnapshot.sprinkleJarKey)

        placeSprinkleMomentCardViews(treatCaseCard: treatCaseCard, heroImage: heroImage, textBand: textBand, captionLabel: captionLabel, avatar: avatar, tasterNameLabel: tasterNameLabel, safetyButton: safetyButton)
        pinSprinkleMomentCardLayout(treatCaseCard: treatCaseCard, heroImage: heroImage, textBand: textBand, captionLabel: captionLabel, avatar: avatar, tasterNameLabel: tasterNameLabel, safetyButton: safetyButton)
        return treatCaseCard
    }

    private func makeSprinkleMomentHeroImage(_ donutSnapshot: WevVDonutSnapshot) -> UIImageView {
        let glazeImage = UIImageView(image: WevVPastryImageVault.watercolorIcingDesign(for: donutSnapshot.donutBackdropAsset) ?? makeFrostingHeroImage(seed: donutSnapshot.donutBackdropAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        return glazeImage
    }

    private func makeSprinkleMomentTextBand() -> UIView {
        let glazeBand = WevVSugarGradientBand()
        glazeBand.translatesAutoresizingMaskIntoConstraints = false
        glazeBand.isUserInteractionEnabled = false
        return glazeBand
    }

    private func makeSprinkleMomentCaption(_ sugarText: String) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = sugarText
        sugarDustLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        sugarDustLabel.textColor = .white
        sugarDustLabel.numberOfLines = 2
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.82
        return sugarDustLabel
    }

    private func makeSprinkleMomentAvatar(_ donutSnapshot: WevVDonutSnapshot) -> UIImageView {
        let glazeAvatar = UIImageView(image: makeSprinkleAuthorAvatar(for: donutSnapshot))
        glazeAvatar.translatesAutoresizingMaskIntoConstraints = false
        glazeAvatar.contentMode = .scaleAspectFill
        glazeAvatar.clipsToBounds = true
        glazeAvatar.layer.cornerRadius = 15
        glazeAvatar.layer.borderWidth = 1.5
        glazeAvatar.layer.borderColor = UIColor.white.cgColor
        return glazeAvatar
    }

    private func makeSprinkleMomentName(_ sugarName: String) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = sugarName
        sugarDustLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        sugarDustLabel.textColor = .white
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.76
        return sugarDustLabel
    }

    private func makeSprinkleMomentSafetyButton(_ sugarDustKey: String) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = sugarDustKey
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        sprinkleButton.layer.cornerRadius = 17
        sprinkleButton.addTarget(self, action: #selector(openSprinkleMomentSafety(_:)), for: .touchUpInside)
        return sprinkleButton
    }

    private func placeSprinkleMomentCardViews(treatCaseCard: UIControl, heroImage: UIImageView, textBand: UIView, captionLabel: UILabel, avatar: UIImageView, tasterNameLabel: UILabel, safetyButton: UIButton) {
        treatCaseCard.addSubview(heroImage)
        treatCaseCard.addSubview(textBand)
        textBand.addSubview(captionLabel)
        treatCaseCard.addSubview(avatar)
        treatCaseCard.addSubview(tasterNameLabel)
        treatCaseCard.addSubview(safetyButton)
    }

    private func pinSprinkleMomentCardLayout(treatCaseCard: UIControl, heroImage: UIImageView, textBand: UIView, captionLabel: UILabel, avatar: UIImageView, tasterNameLabel: UILabel, safetyButton: UIButton) {
        NSLayoutConstraint.activate([
            treatCaseCard.heightAnchor.constraint(equalTo: treatCaseCard.widthAnchor, multiplier: 182.0 / 345.0),
            heroImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            heroImage.bottomAnchor.constraint(equalTo: textBand.topAnchor),
            textBand.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            textBand.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            textBand.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor),
            textBand.heightAnchor.constraint(equalToConstant: 50),
            captionLabel.topAnchor.constraint(equalTo: textBand.topAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: textBand.leadingAnchor, constant: 22),
            captionLabel.trailingAnchor.constraint(equalTo: textBand.trailingAnchor, constant: -18),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: textBand.bottomAnchor, constant: -7),
            avatar.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: heroImage.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 30),
            avatar.heightAnchor.constraint(equalToConstant: 30),
            tasterNameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            tasterNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            tasterNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -10),
            safetyButton.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 15),
            safetyButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: -15),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeSprinkleAuthorAvatar(for donutSnapshot: WevVDonutSnapshot) -> UIImage {
        if let profile = bakeryTasterStore.allProfiles.first(where: { $0.donutPinKey == donutSnapshot.tasterBloom.donutPinKey }),
           let glazeImage = UIImage(named: profile.donutFrameAsset) {
            return glazeImage
        }
        if let glazeImage = UIImage(named: donutSnapshot.tasterBloom.donutFrameAsset) {
            return glazeImage
        }
        return makeFrostingAvatarImage(seed: donutSnapshot.tasterBloom.donutFrameAsset)
    }

    private func makeProfileImageAction(asset: String) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.addTarget(self, action: #selector(openProfileSugarEntry), for: .touchUpInside)

        let glazeImage = UIImageView(
            image: UIImage(named: asset)
                ?? UIImage(named: "wevv_profile_avatar_piano_donut")
                ?? UIImage(systemName: "person.crop.circle.fill")
        )
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFit
        glazeImage.clipsToBounds = true
        if asset == "wevv_profile_avatar_piano_donut" {
            profileAvatarImageView = glazeImage
        }
        sprinkleButton.addSubview(glazeImage)

        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: sprinkleButton.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: sprinkleButton.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: sprinkleButton.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: sprinkleButton.bottomAnchor)
        ])
        return sprinkleButton
    }

    private func makeImageButton(asset: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .custom)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.setImage(UIImage(named: asset), for: .normal)
        sprinkleButton.imageView?.contentMode = .scaleAspectFit
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func makeTabButton(section: WevVDonutParlorSection, asset: String) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.tag = section.rawValue
        sprinkleButton.isAccessibilityElement = true
        switch section {
        case .donutCounter:
            sprinkleButton.accessibilityLabel = "Home"
        case .tastingParlor:
            sprinkleButton.accessibilityLabel = "Voice rooms"
        case .tastingJournal:
            sprinkleButton.accessibilityLabel = "Discover"
        case .zestyOrangeHarmony:
            sprinkleButton.accessibilityLabel = "Profile"
        }
        sprinkleButton.accessibilityTraits = .button
        sprinkleButton.addTarget(self, action: #selector(selectDonutSection(_:)), for: .touchUpInside)

        let icon = makeTabIcon(section: section, asset: asset)
        sprinkleButton.addSubview(icon)
        donutParlorIcons[section] = icon

        NSLayoutConstraint.activate([
            sprinkleButton.widthAnchor.constraint(equalToConstant: 54),
            sprinkleButton.heightAnchor.constraint(equalToConstant: 54),
            icon.centerXAnchor.constraint(equalTo: sprinkleButton.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: sprinkleButton.centerYAnchor)
        ])
        return sprinkleButton
    }

    private func makeTabIcon(section: WevVDonutParlorSection, asset: String) -> UIImageView {
        let icon = UIImageView(image: UIImage(named: asset))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        let iconSide: CGFloat = section == .tastingParlor ? 44 : 30
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: iconSide),
            icon.heightAnchor.constraint(equalToConstant: iconSide)
        ])
        return icon
    }

    private func configureProfileCountLabel(_ sugarDustLabel: UILabel) {
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.font = .systemFont(ofSize: 16, weight: .bold)
        sugarDustLabel.textColor = .white
        sugarDustLabel.textAlignment = .center
    }

    private func configureProfileCardCountLabel(_ sugarDustLabel: UILabel) {
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        sugarDustLabel.textColor = .white
        sugarDustLabel.textAlignment = .center
    }

    private func makeProfileCardTitle(_ text: String) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = text
        sugarDustLabel.font = .systemFont(ofSize: 23, weight: .heavy)
        sugarDustLabel.textColor = .white
        sugarDustLabel.textAlignment = .center
        sugarDustLabel.adjustsFontSizeToFitWidth = true
        sugarDustLabel.minimumScaleFactor = 0.72
        return sugarDustLabel
    }

    private func makeProfileTinyText(_ text: String) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = text
        sugarDustLabel.font = .systemFont(ofSize: 13, weight: .medium)
        sugarDustLabel.textColor = .white
        sugarDustLabel.textAlignment = .center
        return sugarDustLabel
    }

    private func makeProfileRelationEntry(action: Selector) -> UIControl {
        let pastryEntry = UIControl()
        pastryEntry.translatesAutoresizingMaskIntoConstraints = false
        pastryEntry.backgroundColor = .clear
        pastryEntry.addTarget(self, action: action, for: .touchUpInside)
        return pastryEntry
    }

    private func refreshDonutDiaryPanel() {
        let isReady = donutJournalStore.isTasterReady
        let currentUser = currentDonutDiaryTaster()
        let baseStat = currentUser.tastingMarks
        let tastingMarks = isReady
            ? WevVTastingMark(
                glazeTrailCount: baseStat.glazeTrailCount,
                sprinkleTasterCount: baseStat.sprinkleTasterCount,
                bakeryShelfTotal: donutJournalStore.glazeShelfCount,
                donutArchiveTotal: baseStat.donutArchiveTotal
            )
            : WevVTastingMark(glazeTrailCount: 0, sprinkleTasterCount: 0, bakeryShelfTotal: 0, donutArchiveTotal: 0)
        donutDiaryNameLabel.text = isReady ? currentUser.glazeNickname : ""
        if let profileAvatarImageView {
            let placeholder = UIImage(named: "wevv_profile_avatar_piano_donut")
            profileAvatarImageView.image = placeholder
            if let localAvatar = UIImage(named: currentUser.donutFrameAsset) {
                profileAvatarImageView.image = localAvatar
            } else {
                setGlazeRemoteImage(currentUser.donutFrameAsset, on: profileAvatarImageView, placeholder: placeholder)
            }
        }
        bakeryTrailCountLabel.text = "\(tastingMarks.glazeTrailCount)"
        tasterTrailCountLabel.text = "\(tastingMarks.sprinkleTasterCount)"
        bakeryShelfCountLabel.text = "\(tastingMarks.bakeryShelfTotal)"
        donutArchiveCountLabel.text = "\(tastingMarks.donutArchiveTotal)"

        flavorNoteStack.arrangedSubviews.forEach { sugarView in
            flavorNoteStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }

        if isReady, !glazeProfileMomentItems.isEmpty {
            glazeProfileMomentItems.forEach { flavorNoteStack.addArrangedSubview(makeGlazeMomentCard($0, showsHotMark: false)) }
            emptyFlavorStack.isHidden = true
            flavorNoteStack.isHidden = false
        } else {
            emptyFlavorStack.isHidden = false
            flavorNoteStack.isHidden = true
        }
    }

    private func loadGlazeProfileMoments() {
        guard donutJournalStore.isTasterReady,
              let userID = donutJournalStore.currentGlazeCredentials?.vanillaBeanIcing,
              glazeProfileTask == nil else { return }
        glazeProfileTask = Task { [weak self] in
            guard let self else { return }
            do {
                async let profile = WevVGlazeSessionRepository.pastryTrailDiary.coldBrewTasting()
                async let starchGelatinizationStudy = WevVGlazeSocialRepository.pastryTrailDiary.heritageMap(vanillaBeanIcing: userID)
                _ = try await profile
                glazeProfileMomentItems = try await starchGelatinizationStudy
                refreshDonutDiaryPanel()
            } catch {
                showRootSugarHint(error.localizedDescription)
            }
            glazeProfileTask = nil
        }
    }

    private func currentFlavorNotes() -> [WevVFlavorNote] {
        []
    }

    private func currentDonutDiaryTaster() -> WevVDonutDiaryTaster {
        let profile = donutJournalStore.currentDoughRingTasterProfile
        return WevVDonutDiaryTaster(
            ringCutterKey: profile.ringCutterKey,
            warmGingerFlavor: profile.email,
            glazeNickname: profile.glazeNickname.isEmpty ? defaultDonutDiaryTaster.glazeNickname : profile.glazeNickname,
            donutFrameAsset: profile.donutFrameAsset.isEmpty ? defaultDonutDiaryTaster.donutFrameAsset : profile.donutFrameAsset,
            tastingMarks: WevVTastingMark(
                glazeTrailCount: profile.glazeTrailCount,
                sprinkleTasterCount: profile.sprinkleTasterCount,
                bakeryShelfTotal: profile.bakeryShelfTotal,
                donutArchiveTotal: profile.glazeVaultCount
            ),
            honeyedFigHarmony: []
        )
    }

    private func makeFlavorNoteCard(_ flavorNote: WevVFlavorNote) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        treatCaseCard.layer.cornerRadius = 16
        treatCaseCard.addTarget(self, action: #selector(openProfileSugarEntry), for: .touchUpInside)

        let donutStampTitle = UILabel()
        donutStampTitle.translatesAutoresizingMaskIntoConstraints = false
        donutStampTitle.text = flavorNote.tastingCardTitle
        donutStampTitle.font = .systemFont(ofSize: 15, weight: .heavy)
        donutStampTitle.textColor = UIColor(red: 0.17, green: 0.08, blue: 0.22, alpha: 1)

        let crumbNote = UILabel()
        crumbNote.translatesAutoresizingMaskIntoConstraints = false
        crumbNote.text = flavorNote.sweetApricotNuance
        crumbNote.font = .systemFont(ofSize: 13, weight: .medium)
        crumbNote.textColor = UIColor(red: 0.54, green: 0.42, blue: 0.51, alpha: 1)
        crumbNote.numberOfLines = 2

        treatCaseCard.addSubview(donutStampTitle)
        treatCaseCard.addSubview(crumbNote)

        NSLayoutConstraint.activate([
            treatCaseCard.heightAnchor.constraint(equalToConstant: 64),
            donutStampTitle.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 10),
            donutStampTitle.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 14),
            donutStampTitle.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -14),
            crumbNote.topAnchor.constraint(equalTo: donutStampTitle.bottomAnchor, constant: 3),
            crumbNote.leadingAnchor.constraint(equalTo: donutStampTitle.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: donutStampTitle.trailingAnchor)
        ])
        return treatCaseCard
    }

    private func makeFrostingHeroImage(seed: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 690, height: 264))
        return renderer.image { context in
            let canvas = context.cgContext
            let baseColors = frostingHeroPalette(seed: seed)

            baseColors.0.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 690, height: 264)).fill()
            baseColors.1.withAlphaComponent(0.7).setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 96, width: 690, height: 168)).fill()

            UIColor.white.withAlphaComponent(0.22).setFill()
            UIBezierPath(ovalIn: CGRect(x: 440, y: -38, width: 210, height: 210)).fill()
            UIBezierPath(ovalIn: CGRect(x: -42, y: 142, width: 190, height: 150)).fill()

            baseColors.2.setFill()
            UIBezierPath(ovalIn: CGRect(x: 322, y: 54, width: 150, height: 150)).fill()
            UIColor(red: 1, green: 0.83, blue: 0.52, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 342, y: 74, width: 110, height: 110)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: 376, y: 108, width: 42, height: 42)).fill()

            let sprinkleColors = [
                UIColor.white,
                UIColor(red: 1, green: 0.89, blue: 0.13, alpha: 1),
                UIColor(red: 0.97, green: 0.2, blue: 0.61, alpha: 1),
                UIColor(red: 0.29, green: 0.7, blue: 0.96, alpha: 1)
            ]
            for index in 0..<38 {
                sprinkleColors[index % sprinkleColors.count].setFill()
                let x = CGFloat((index * 47) % 640) + 18
                let y = CGFloat((index * 31) % 210) + 18
                let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 22, height: 6), cornerRadius: 3)
                canvas.saveGState()
                canvas.translateBy(x: x + 11, y: y + 3)
                canvas.rotate(by: CGFloat(index % 7) * 0.34)
                canvas.translateBy(x: -(x + 11), y: -(y + 3))
                path.fill()
                canvas.restoreGState()
            }
        }
    }

    private func frostingHeroPalette(seed: String) -> (UIColor, UIColor, UIColor) {
        switch seed {
        case "brickSprinkle":
            return (
                UIColor(red: 0.91, green: 0.55, blue: 0.36, alpha: 1),
                UIColor(red: 0.99, green: 0.75, blue: 0.55, alpha: 1),
                UIColor(red: 1.0, green: 0.45, blue: 0.66, alpha: 1)
            )
        case "softKitchen":
            return (
                UIColor(red: 0.78, green: 0.72, blue: 0.68, alpha: 1),
                UIColor(red: 0.96, green: 0.84, blue: 0.78, alpha: 1),
                UIColor(red: 0.59, green: 0.42, blue: 0.74, alpha: 1)
            )
        default:
            return (
                UIColor(red: 0.43, green: 0.77, blue: 0.95, alpha: 1),
                UIColor(red: 0.98, green: 0.78, blue: 0.86, alpha: 1),
                UIColor(red: 0.95, green: 0.36, blue: 0.63, alpha: 1)
            )
        }
    }

    private func makeFrostingAvatarImage(seed: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 90, height: 90))
        return renderer.image { _ in
            let base: UIColor
            let accent: UIColor
            switch seed {
            case "louiseCream":
                base = UIColor(red: 0.83, green: 0.54, blue: 0.22, alpha: 1)
                accent = UIColor(red: 0.25, green: 0.69, blue: 0.9, alpha: 1)
            case "raymondSugar":
                base = UIColor(red: 0.58, green: 0.68, blue: 0.83, alpha: 1)
                accent = UIColor(red: 0.96, green: 0.91, blue: 0.84, alpha: 1)
            default:
                base = UIColor(red: 0.84, green: 0.58, blue: 0.67, alpha: 1)
                accent = UIColor(red: 0.96, green: 0.78, blue: 0.86, alpha: 1)
            }

            base.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 90, height: 90)).fill()
            accent.setFill()
            UIBezierPath(ovalIn: CGRect(x: 18, y: 12, width: 54, height: 54)).fill()
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 25, y: 54, width: 40, height: 24)).fill()
            UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 28, y: 31, width: 8, height: 8)).fill()
            UIBezierPath(ovalIn: CGRect(x: 54, y: 31, width: 8, height: 8)).fill()
        }
    }

    private func makePanelTitle(_ text: String) -> UILabel {
        let sugarDustLabel = UILabel()
        sugarDustLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarDustLabel.text = text
        sugarDustLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        sugarDustLabel.textColor = .black
        return sugarDustLabel
    }

    private func makeTastingJournalCard(title: String, caption: String) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        treatCaseCard.layer.cornerRadius = 22

        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = title
        glazeTitleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        glazeTitleLabel.textColor = .black

        let captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        captionLabel.textColor = UIColor(red: 0.42, green: 0.35, blue: 0.47, alpha: 1)
        captionLabel.numberOfLines = 0

        treatCaseCard.addSubview(glazeTitleLabel)
        treatCaseCard.addSubview(captionLabel)

        NSLayoutConstraint.activate([
            treatCaseCard.heightAnchor.constraint(equalToConstant: 112),
            glazeTitleLabel.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 18),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 20),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -20),
            captionLabel.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: glazeTitleLabel.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: glazeTitleLabel.trailingAnchor)
        ])
        return treatCaseCard
    }

    @objc private func openGlazeNoticeList() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVNoticeEmptyController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func selectDonutSection(_ glazeButton: UIControl) {
        guard let section = WevVDonutParlorSection(rawValue: glazeButton.tag) else { return }
        switchDonutParlorSection(section)
    }

    @objc private func refreshSprinkleMoments() {
        loadGlazeContent()
    }

    private func loadGlazeContent(showsLoading: Bool = true) {
        glazeContentTask?.cancel()
        if showsLoading {
            homeLiveStatusLabel.isHidden = false
            homeLiveStatusLabel.text = "Loading live rooms…"
            tastingParlorStatusLabel.isHidden = false
            tastingParlorStatusLabel.text = "Loading rooms…"
            tastingJournalStatusLabel.isHidden = false
            tastingJournalStatusLabel.text = "Loading community posts…"
        }

        glazeContentTask = Task { [weak self] in
            guard let self else { return }
            var steamExpansionStudy: [pearFilling] = []
            var recommendedVoiceRooms: [pearFilling] = []
            var followedVoiceRooms: [pearFilling] = []
            var roomError: Error?
            do {
                steamExpansionStudy = try await glazeContentRepository.steamExpansionStudy()
            } catch {
                roomError = error
            }
            if Task.isCancelled { return }
            do {
                recommendedVoiceRooms = try await glazeContentRepository.batterConsistencyDetail(carnivalGlazeShowcase: .apricotCompote)
            } catch {
                roomError = roomError ?? error
            }
            if Task.isCancelled { return }
            do {
                followedVoiceRooms = try await glazeContentRepository.batterConsistencyDetail(carnivalGlazeShowcase: .cherryCenter)
            } catch {
                roomError = roomError ?? error
            }
            if Task.isCancelled { return }

            var trendingMoments: [butteryTexture] = []
            var followedMoments: [butteryTexture] = []
            var momentError: Error?
            do {
                trendingMoments = try await glazeContentRepository.starchGelatinizationStudy(carnivalGlazeShowcase: .artisanFrySequence).filter { !$0.passionfruitFilling.isEmpty }
            } catch {
                momentError = error
            }
            if Task.isCancelled { return }
            do {
                followedMoments = try await glazeContentRepository.starchGelatinizationStudy(carnivalGlazeShowcase: .cherryCenter).filter { !$0.passionfruitFilling.isEmpty }
            } catch {
                momentError = momentError ?? error
            }
            if Task.isCancelled { return }

            glazeRecommendedVoiceRooms = recommendedVoiceRooms
            glazeFollowedVoiceRooms = followedVoiceRooms
            var seenRoomKeys = Set<String>()
            glazeRoomItems = (steamExpansionStudy + recommendedVoiceRooms + followedVoiceRooms).filter { room in
                seenRoomKeys.insert("\(room.lemonCurd.rawValue):\(room.passionfruitMousse)").inserted
            }
            glazeTrendingMomentItems = uniqueTastingJournalMoments(trendingMoments)
            glazeFollowedMomentItems = uniqueTastingJournalMoments(followedMoments)
            rebuildGlazeRoomStacks(error: roomError)
            rebuildTastingJournalMomentPages()
            rebuildDonutSnapshotStack()
            if trendingMoments.isEmpty {
                tastingJournalStatusLabel.isHidden = false
                tastingJournalStatusLabel.text = momentError == nil
                    ? "No trending posts yet."
                    : "Community posts could not be loaded. Pull down to retry."
            } else {
                tastingJournalStatusLabel.isHidden = true
            }
            sprinkleRefresh.endRefreshing()
        }
    }

    private func rebuildGlazeRoomStacks(error: Error?) {
        homeLiveRoomStack.arrangedSubviews.forEach {
            homeLiveRoomStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        tastingParlorRoomStack.arrangedSubviews.forEach {
            tastingParlorRoomStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        tastingParlorFollowRoomStack.arrangedSubviews.forEach {
            tastingParlorFollowRoomStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let steamExpansionStudy = Array(glazeRoomItems.filter { $0.lemonCurd == .blueberryCustard }.prefix(4))
        for start in stride(from: 0, to: steamExpansionStudy.count, by: 2) {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            row.distribution = .fillEqually
            row.addArrangedSubview(makeHomeGlazeRoomCard(steamExpansionStudy[start]))
            if start + 1 < steamExpansionStudy.count {
                row.addArrangedSubview(makeHomeGlazeRoomCard(steamExpansionStudy[start + 1]))
            } else {
                let spacer = UIView()
                row.addArrangedSubview(spacer)
            }
            homeLiveRoomStack.addArrangedSubview(row)
        }

        for (position, room) in glazeRecommendedVoiceRooms.enumerated() {
            tastingParlorRoomStack.addArrangedSubview(makeTastingParlorRoomCard(room, position: position))
        }
        for (position, room) in glazeFollowedVoiceRooms.enumerated() {
            tastingParlorFollowRoomStack.addArrangedSubview(makeTastingParlorRoomCard(room, position: position))
        }

        let roomCount = max(3, max(glazeRecommendedVoiceRooms.count, glazeFollowedVoiceRooms.count))
        tastingParlorRoomPagerHeightConstraint?.constant = CGFloat(roomCount * 124 + max(0, roomCount - 1) * 14)
        rebuildTastingParlorHotRooms()
        rebuildTastingParlorOwners()
        updateTastingParlorStatus()

        homeLiveStatusLabel.isHidden = error == nil || !steamExpansionStudy.isEmpty
        homeLiveStatusLabel.text = error == nil ? nil : "Rooms could not be loaded. Pull down to retry."
    }

    private func setGlazeRemoteImage(_ urlText: String?, on imageView: UIImageView, placeholder: UIImage? = nil) {
        imageView.image = placeholder
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        guard let urlText, let url = URL(string: urlText) else { return }
        imageView.accessibilityIdentifier = urlText
        if let cached = Self.glazeImageCache.object(forKey: urlText as NSString) {
            imageView.image = cached
            return
        }
        Task { [weak imageView] in
            guard let (data, response) = try? await URLSession.shared.data(from: url),
                  let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data) else { return }
            Self.glazeImageCache.setObject(image, forKey: urlText as NSString)
            guard imageView?.accessibilityIdentifier == urlText else { return }
            imageView?.image = image
        }
    }

    @objc private func openGlazeRoom(_ sender: UIControl) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        guard let identifier = sender.accessibilityIdentifier,
              let separator = identifier.firstIndex(of: ":") else { return }
        let kindText = String(identifier[..<separator])
        let roomID = String(identifier[identifier.index(after: separator)...])
        guard let kind = chocolateCompote(rawValue: kindText),
              let room = glazeRoomItems.first(where: { $0.lemonCurd == kind && $0.passionfruitMousse == roomID }) else { return }
        present(WevVGlazeActortroller(tastingRoom: room), animated: true)
    }

    @objc private func advanceBakeryAtlasCarousel() {
        guard activeDonutParlorSection == .donutCounter, bakeryAtlasItems.count > 1, bakeryAtlasCarousel.bounds.width > 0 else { return }
        let currentPage = Int(round(bakeryAtlasCarousel.contentOffset.x / bakeryAtlasCarousel.bounds.width))
        let nextPage = (currentPage + 1) % bakeryAtlasItems.count
        let nextOffset = CGPoint(x: CGFloat(nextPage) * bakeryAtlasCarousel.bounds.width, y: 0)
        bakeryAtlasCarousel.setContentOffset(nextOffset, animated: true)
        bakeryAtlasDots.currentPage = nextPage
    }

    @objc private func openProtectedGlazeAction() {
        presentProtectedGate()
    }

    @objc private func openTastingQuestComposer() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVWevvTastingQuestComposerController()
        controller.firstGlazeDelight = { [weak self] packet in
            guard let self else { return }
            let quest = self.makeTastingQuest(from: packet)
            self.tastingQuests.removeAll { self.isSameTastingQuest($0, quest) }
            self.tastingQuests.insert(quest, at: 0)
            self.rebuildTastingQuestRow()
            self.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openFlavorNoteComposer() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarMomentComposerController()
        controller.onSugarMomentReady = { [weak self] in self?.loadGlazeContent() }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func rebuildDonutSnapshotStack() {
        donutSnapshotStack.arrangedSubviews.forEach { sugarView in
            donutSnapshotStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        let featuredMomentIDs = Set(glazeTrendingMomentItems.prefix(4).map(\.coconutCenter))
        let newPostMoments = glazeTrendingMomentItems.filter { !featuredMomentIDs.contains($0.coconutCenter) }
        for (index, moment) in newPostMoments.enumerated() {
            donutSnapshotStack.addArrangedSubview(makeGlazeMomentCard(moment, showsHotMark: index == 0))
        }
    }

    private func uniqueTastingJournalMoments(_ starchGelatinizationStudy: [butteryTexture]) -> [butteryTexture] {
        var seenMomentIDs = Set<Int64>()
        return starchGelatinizationStudy.filter { seenMomentIDs.insert($0.coconutCenter).inserted }
    }

    private func rebuildTastingQuestRow() {
        tastingQuestRow.arrangedSubviews.forEach { sugarView in
            tastingQuestRow.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        let uniqueTastingQuestItems = uniqueTastingQuests(tastingQuests)
        tastingQuests = uniqueTastingQuestItems
        guard let firstQuest = uniqueTastingQuestItems.first else { return }
        let secondQuest = uniqueTastingQuestItems.dropFirst().first ?? firstQuest
        let mosaic = makeHomeTastingQuestMosaic(firstQuest: firstQuest, secondQuest: secondQuest)
        tastingQuestRow.addArrangedSubview(mosaic)
        mosaic.widthAnchor.constraint(equalTo: tastingQuestRow.widthAnchor).isActive = true
    }

    private func makeHomeTastingQuestMosaic(firstQuest: WevVTastingQuest, secondQuest: WevVTastingQuest) -> UIView {
        let mosaic = UIView()
        mosaic.translatesAutoresizingMaskIntoConstraints = false

        let featuredChallenge = makeTastingQuestCard(firstQuest)

        let checkin = UIControl()
        checkin.translatesAutoresizingMaskIntoConstraints = false
        checkin.accessibilityIdentifier = dailyDonutVisit.ringCutterKey
        checkin.accessibilityLabel = "Daily check-in"
        checkin.layer.cornerRadius = 14
        checkin.clipsToBounds = true
        checkin.addTarget(self, action: #selector(openDailyDonutStamp), for: .touchUpInside)

        let compactChallenge = makeCompactTastingQuestCard(secondQuest)

        [featuredChallenge, checkin, compactChallenge].forEach { mosaic.addSubview($0) }

        let checkinArtwork = UIImageView(image: UIImage(named: "wevv_home_checkin_compact"))
        checkinArtwork.translatesAutoresizingMaskIntoConstraints = false
        checkinArtwork.contentMode = .scaleToFill
        checkinArtwork.clipsToBounds = true
        checkin.addSubview(checkinArtwork)

        NSLayoutConstraint.activate([
            checkinArtwork.topAnchor.constraint(equalTo: checkin.topAnchor),
            checkinArtwork.leadingAnchor.constraint(equalTo: checkin.leadingAnchor),
            checkinArtwork.trailingAnchor.constraint(equalTo: checkin.trailingAnchor),
            checkinArtwork.bottomAnchor.constraint(equalTo: checkin.bottomAnchor),
            featuredChallenge.topAnchor.constraint(equalTo: mosaic.topAnchor),
            featuredChallenge.leadingAnchor.constraint(equalTo: mosaic.leadingAnchor),
            featuredChallenge.bottomAnchor.constraint(equalTo: mosaic.bottomAnchor),
            featuredChallenge.widthAnchor.constraint(equalTo: mosaic.widthAnchor, multiplier: 191.0 / 347.0),
            checkin.topAnchor.constraint(equalTo: mosaic.topAnchor),
            checkin.leadingAnchor.constraint(equalTo: featuredChallenge.trailingAnchor, constant: 8),
            checkin.trailingAnchor.constraint(equalTo: mosaic.trailingAnchor),
            checkin.heightAnchor.constraint(equalTo: mosaic.heightAnchor, multiplier: 82.0 / 215.0),
            compactChallenge.topAnchor.constraint(equalTo: checkin.bottomAnchor, constant: 8),
            compactChallenge.leadingAnchor.constraint(equalTo: checkin.leadingAnchor),
            compactChallenge.trailingAnchor.constraint(equalTo: mosaic.trailingAnchor),
            compactChallenge.bottomAnchor.constraint(equalTo: mosaic.bottomAnchor)
        ])
        return mosaic
    }

    private func preloadFlavorNotes() {
        let packets = donutJournalStore.sugarMomentPackets
        guard !packets.isEmpty else { return }
        let packetKeys = Set(donutSnapshots.map(\.sprinkleJarKey))
        let currentUser = currentDonutDiaryTaster()
        let freshMoments = packets
            .filter { !packetKeys.contains($0.sugarDustKey) }
            .map {
                WevVDonutSnapshot(
                    sprinkleJarKey: $0.sugarDustKey,
                    tasterBloom: WevVDonutTaster(donutPinKey: currentUser.ringCutterKey, name: currentUser.glazeNickname, donutFrameAsset: currentUser.donutFrameAsset),
                    donutBackdropAsset: $0.donutBackdropAsset,
                    tastingText: $0.lemonCutter,
                    hasSprinkleDust: false,
                    hasBakeryShelf: false,
                    freshnessTagText: $0.citrusParlor
                )
            }
        donutSnapshots.insert(contentsOf: freshMoments, at: 0)
    }

    private func preloadTastingQuests() {
        let packets = donutJournalStore.sprinkleQuestPackets
        guard !packets.isEmpty else { return }
        let questKeys = Set(tastingQuests.map(\.sprinkleJarKey))
        let freshQuests = packets
            .filter { !questKeys.contains($0.sugarDustKey) }
            .map { makeTastingQuest(from: $0) }
        tastingQuests.insert(contentsOf: freshQuests, at: 0)
    }

    private func uniqueTastingQuests(_ quests: [WevVTastingQuest]) -> [WevVTastingQuest] {
        var seenKeys = Set<String>()
        return quests.filter { quest in
            let key = tastingQuestIdentityKey(quest)
            guard !seenKeys.contains(key) else { return false }
            seenKeys.insert(key)
            return true
        }
    }

    private func isSameTastingQuest(_ left: WevVTastingQuest, _ right: WevVTastingQuest) -> Bool {
        tastingQuestIdentityKey(left) == tastingQuestIdentityKey(right)
    }

    private func tastingQuestIdentityKey(_ quest: WevVTastingQuest) -> String {
        [
            quest.menuBoardTitle,
            quest.freshnessTagText,
            quest.bakeryStopText,
            "\(quest.sprinkleDensityValue)"
        ]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .joined(separator: "|L".wevVPastryCrumbBloomRestored)
    }

    private func makeTastingQuest(from packet: WevVSprinkleQuestPacket) -> WevVTastingQuest {
        WevVTastingQuest(
            sprinkleJarKey: packet.sugarDustKey,
            menuBoardTitle: packet.citrusCounter,
            caption: packet.almondDuster,
            cardAsset: packet.coverAsset,
            glazeSheenText: "JaoIiln?".wevVPastryCrumbBloomRestored,
            glazeTrailLine: packet.almondDuster,
            freshnessTagText: packet.citrusParlor,
            bakeryStopText: packet.placeText,
            tasterBadgeKey: "jEa^m?iKeRCCo^ljey".wevVPastryCrumbBloomRestored,
            tasterLine: "FWrpeNsmh& NhFo?sAta H·Z G4#.W9t Yr=aFt#iqnbg%".wevVPastryCrumbBloomRestored,
            tastingQuestText: packet.almondDuster,
            tastingTableText: "1S bpleTrQsnodnZ".wevVPastryCrumbBloomRestored,
            sprinkleDensityValue: packet.sprinkleDensityValue
        )
    }

    @objc private func openDailyDonutStamp() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDailyDonutcherryCompote()
        controller.onDonutStampChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openProfileSugarEntry() {
        presentProtectedGate()
    }

    @objc private func openBakeryShelf() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVWevvBakerfvanillaBeanIcing(bakeryDetails: allBakeryAtlasDetails())
        controller.onWevvShelfChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "ORppegnSiFn=gG idoobnZugts GsIhmoWp^.r.P.I".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openBakeryTrailList() {
        openDonutTasterRoster(.glazeFollowing)
    }

    @objc private func openTasterTrailList() {
        openDonutTasterRoster(.sprinkleFollower)
    }

    private func openDonutTasterRoster(_ mode: WevVSugarRosterMode) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarRosterbrownButterDrizzle(mode: mode)
        controller.onRosterChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
            self?.rebuildDonutSnapshotStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openDonutDiarySettings() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarpistachioCreamCoating()
        controller.onSugarSettingChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openDonutSnapshotDetail(_ sender: UIControl) {
        if let identifier = sender.accessibilityIdentifier,
           let momentID = Int64(identifier),
           let moment = (glazeTrendingMomentItems + glazeFollowedMomentItems + glazeProfileMomentItems).first(where: { $0.coconutCenter == momentID }) {
            let controller = WevVWevvDonutMomentController(richCocoaFlavor: moment)
            controller.cocoaKissExperience = { [weak self] in self?.loadGlazeContent() }
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
            return
        }
        guard let donutSnapshot = donutSnapshots.first else { return }
        let controller = WevVWevvDonutMomentController(vanillaStrawberryDuet: donutSnapshot)
        controller.cocoaKissExperience = { [weak self] in
            self?.rebuildDonutSnapshotStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSprinkleMomentSafety(_ sender: UIControl) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sprinkleJarKey = sender.accessibilityIdentifier ?? ""
        guard let moment = donutSnapshots.first(where: { $0.sprinkleJarKey == sprinkleJarKey }) else { return }
        presentSprinkleSafetySheet(for: moment)
    }

    @objc private func openGlazeShopSafety(_ sender: UIControl) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sugarDustKey = sender.accessibilityIdentifier ?? ""
        guard bakeryAtlasItems.contains(where: { $0.donutPinKey == sugarDustKey }) else { return }
        presentHomeSafetySheet(for: sugarDustKey)
    }

    @objc private func openSprinkleQuestSafety(_ sender: UIControl) {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sugarDustKey = sender.accessibilityIdentifier ?? ""
        guard tastingQuests.contains(where: { $0.sprinkleJarKey == sugarDustKey }) else { return }
        presentHomeSafetySheet(for: sugarDustKey)
    }

    private func presentHomeSafetySheet(for sugarDustKey: String) {
        let sheet = WevVGlazeSafetySheet(shopPinKey: sugarDustKey, flavorChoices: sprinkleSafetyChoices())
        sheet.pralineDismissAction = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.pralineSubmitAction = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.donutJournalStore.placeGlazeSafetyCrumb(packet)
            self.hideSprinkleSafetySheet(sheet)
            self.showRootSugarHint("RyeqpDoWrzt@ FsxeCnnts".wevVPastryCrumbBloomRestored)
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func presentSprinkleSafetySheet(for moment: WevVDonutSnapshot) {
        let sheet = WevVGlazeSafetySheet(shopPinKey: moment.tasterBloom.donutPinKey, flavorChoices: sprinkleSafetyChoices())
        sheet.pralineDismissAction = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.pralineSubmitAction = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.donutJournalStore.placeGlazeSafetyCrumb(packet)
            self.placeSprinkleShield(for: moment.tasterBloom.donutPinKey)
            self.hideSprinkleSafetySheet(sheet)
            self.rebuildDonutSnapshotStack()
            self.showRootSugarHint("Hyild%dXe^nF Cf^rPoFm/ eysocu^r* OfJeaezdQ".wevVPastryCrumbBloomRestored)
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideSprinkleSafetySheet(_ sheet: WevVGlazeSafetySheet?) {
        UIView.animate(withDuration: 0.18, animations: {
            sheet?.alpha = 0
        }, completion: { _ in
            sheet?.removeFromSuperview()
        })
    }

    private func sprinkleSafetyChoices() -> [pastryCompendiumEdition] {
        [
            pastryCompendiumEdition(flavorLibraryEdition: "f.aikDevP=hGortBom".wevVPastryCrumbBloomRestored, pastryDisplayShowcase: "FDaEkEeL ^pyhUoOtNo#".wevVPastryCrumbBloomRestored, tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "spcQavmUCNoLmVmJeLr?ciioaGlp".wevVPastryCrumbBloomRestored, pastryDisplayShowcase: "S%cfaLmc Io/rq xcVoom=mpeSr=cGila@l%".wevVPastryCrumbBloomRestored, tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "nso!tUI#nBt+e*rIebsIt:e=dn".wevVPastryCrumbBloomRestored, pastryDisplayShowcase: "NWoYtV ^irnxtkePrGemsAtQe%dG".wevVPastryCrumbBloomRestored, tastingSequenceInsight: false),
            pastryCompendiumEdition(flavorLibraryEdition: "ootchFeurzSku?g?airR".wevVPastryCrumbBloomRestored, pastryDisplayShowcase: "OAt#hOegr^".wevVPastryCrumbBloomRestored, tastingSequenceInsight: true)
        ]
    }

    private func placeSprinkleShield(for donutPinKey: String) {
        guard bakeryTasterStore.allProfiles.contains(where: { $0.donutPinKey == donutPinKey }) else { return }
        if !bakeryTasterStore.profile(for: donutPinKey).sugarTie.isSugarShielded {
            _ = bakeryTasterStore.toggleSugarShield(for: donutPinKey)
        }
    }

    private func isSprinkleAuthorShielded(_ moment: WevVDonutSnapshot) -> Bool {
        guard bakeryTasterStore.allProfiles.contains(where: { $0.donutPinKey == moment.tasterBloom.donutPinKey }) else { return false }
        return bakeryTasterStore.profile(for: moment.tasterBloom.donutPinKey).sugarTie.isSugarShielded
    }

    private func showRootSugarHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: donutParlorTabBack, bottomOffset: -14)
    }

    @objc private func openDonutArchive() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDonutdenCrumbCenterler()
        controller.silkyCenter = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openGlazeFavoriteMoments() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVGlazeFavoriteController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openShopCarouselEntry(_ glazedSender: UIControl) {
        let donutPinKey = glazedSender.accessibilityIdentifier ?? bakeryAtlasItems[0].donutPinKey
        let bakeryAtlas = bakeryAtlasItems.first { $0.donutPinKey == donutPinKey } ?? bakeryAtlasItems[0]
        let shopShelf = allBakeryAtlasDetails()
        let detail = shopShelf.first { $0.donutPinKey == bakeryAtlas.donutPinKey } ?? makeBakeryAtlasDetail(bakeryAtlas)
        let controller = WevVWevvBakeryDetailController(detail: detail, bakeryShelf: shopShelf)
        controller.pastryShelfChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func makeBakeryAtlasDetail(_ bakeryAtlas: WevVBakeryAtlas) -> bakeryCollectionFolio {
        switch bakeryAtlas.donutPinKey {
        case "berryRingBakery":
            return makeBerryCrumbBakeryDetail(bakeryAtlas)
        case "goldenDoughStudio":
            return makeGoldenDoughAtelierDetail(bakeryAtlas)
        case "moonlightDonutBar":
            return makeMoonlightDonutCounterDetail(bakeryAtlas)
        default:
            return makeClassicGlazeParlorDetail(bakeryAtlas)
        }
    }

    private func makeBerryCrumbBakeryDetail(_ bakeryAtlas: WevVBakeryAtlas) -> bakeryCollectionFolio {
        bakeryCollectionFolio(
            donutPinKey: bakeryAtlas.donutPinKey,
            sweetShowcaseMap: "BKeAr^rGyj ~RHiTnMgG ABZaVkBeqrfyc".wevVPastryCrumbBloomRestored,
            flavorMenuGuide: "FcrLels@hP ^dPosn.uvt+sV &·z =b=eKr=rjy@ bf?lSa.vooUrYsU".wevVPastryCrumbBloomRestored,
            glazeGalleryGuide: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4g.r8,".wevVPastryCrumbBloomRestored,
            tastingSequenceInsight: "(s1T8o6m greeDvHine#wRsy)o".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "8/6d OBIlXoxs,sLoOmm sAGvhe+nauVev,p jS#aLnL ZFBrFaWnrcRiasxcjon".wevVPastryCrumbBloomRestored,
            seasonalMenuCollection: [
                artisanShowcase(donutPinKey: "sjtGrIaKwXbVe^rqrdy~T!aggB".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "SXtDr&aow/bhezrxruy:".wevVPastryCrumbBloomRestored, pastelPalettePattern: "f=fl4uaka%0G".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "hoadnHdcmGaMddeOT/aQgD".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "H:a!n?d,mAamdoet".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fn5,bX4#3!1G".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "CCopzsyb".wevVPastryCrumbBloomRestored, pastelPalettePattern: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored)
            ],
            tastingMemoryCollection: berryCrumbBakeryNotes(),
            shopHoppingTrail: berryCrumbBakerySelections()
        )
    }

    private func berryCrumbBakeryNotes() -> [tastingPassportPage] {
        [
            tastingPassportPage(sprinkleJarKey: "mjiRaNBZeSr^rPy/GRlCaszseN".wevVPastryCrumbBloomRestored, tastingJournalEntry: "MniBac".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "D!ecsrskebrut; Uleo*v;e?ro".wevVPastryCrumbBloomRestored, crumbScoreNote: "4Z.*9I".wevVPastryCrumbBloomRestored, textureContrastNotes: "TYhCeR ^s!t+rRaJwWbMe!rfrRyR &gLl;ayzUet !wPa%sg gfprSehsGhz,X %sNmJowoXtdhw,o =a=n;dL vphebrwfEeJc~t#l*yc MscwdedeZta.z".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "BleRrnr:yR AFwatv:oErgi=twem".wevVPastryCrumbBloomRestored),
            tastingPassportPage(sprinkleJarKey: "eUtWhDatn.CJoqz;yiBIackHe:r:yB".wevVPastryCrumbBloomRestored, tastingJournalEntry: "E+tyhka~n#".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "Wke=etkceGnCdE Ze+xlpWlMo+raesr^".wevVPastryCrumbBloomRestored, crumbScoreNote: "4v.T7l".wevVPastryCrumbBloomRestored, textureContrastNotes: "Aj &cfo?zqyT bl#i#tytulzee ^sGh^ohp@ %wLiktuhD isaorfUth UdyoPnju%t/s/ YasnAd% NfJrRi&eHn:dfl=ys NshevrevXizc*eP.X".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "C@orzAyz HSPpsoHtt".wevVPastryCrumbBloomRestored)
        ]
    }

    private func berryCrumbBakerySelections() -> [shopWindowCollection] {
        [
            shopWindowCollection(flavorLibraryEdition: "goldenDoughPick", pastryDisplayShowcase: "Golden Dough Studio", bakeryTrailLine: "215 Golden Lane, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_golden_dough_studio"),
            shopWindowCollection(flavorLibraryEdition: "mellowDoughPick", pastryDisplayShowcase: "Mellow Dough", bakeryTrailLine: "212 Pine Ave, Oakland, CA", crumbScoreNote: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeGoldenDoughAtelierDetail(_ bakeryAtlas: WevVBakeryAtlas) -> bakeryCollectionFolio {
        bakeryCollectionFolio(
            donutPinKey: bakeryAtlas.donutPinKey,
            sweetShowcaseMap: "G+oplcddeanm ZD#oGueguhy SSxtEu?dtiWoo".wevVPastryCrumbBloomRestored,
            flavorMenuGuide: "ADr&tPi#sEa~nY QdGo@n?uzt/s; X·t ysXmIaJljlO wbua,tgceh&eXsf".wevVPastryCrumbBloomRestored,
            glazeGalleryGuide: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4w.Z9a".wevVPastryCrumbBloomRestored,
            tastingSequenceInsight: "(m3T1#2d prTeIvii:eowBsh)N".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "2W1P5e GGbo.l@dCexn# SL;afn@e.,* AS.a~nL sFdrxaOnLcyiQs.cKo*".wevVPastryCrumbBloomRestored,
            seasonalMenuCollection: [
                artisanShowcase(donutPinKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, pastelPalettePattern: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "f%reeosJhsByaftlckhoT.aygV".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "Fqrzems=hh".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fP5ebB4a3y1V".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "poozp!uwlIaJrJSeuCgJawrdT:aYgx".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "PWoBpPuklJaqrV".wevVPastryCrumbBloomRestored, pastelPalettePattern: "8Gba6k3=fFf%".wevVPastryCrumbBloomRestored)
            ],
            tastingMemoryCollection: goldenDoughAtelierNotes(),
            shopHoppingTrail: goldenDoughAtelierSelections()
        )
    }

    private func goldenDoughAtelierNotes() -> [tastingPassportPage] {
        [
            tastingPassportPage(sprinkleJarKey: "osl/iNv,iuaJGqoNlcdJeXnSF%r~aZmmee".wevVPastryCrumbBloomRestored, tastingJournalEntry: "O=lFiavpipas".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "FPoEo@dI ~pfhjostwo/gAr/atpXhPearU".wevVPastryCrumbBloomRestored, crumbScoreNote: "5&.W0n".wevVPastryCrumbBloomRestored, textureContrastNotes: "EtvfekrDyY ddjofn@uptr Xl/o/o^kEe!dR qbhe#aZu?t#iYf,uKlm Xaxntd# LtZa;sOthewd* /eZvbeznx xbFe~tnt~e!rX.U".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "PYicc?tauJr:eU =Pie.rRfveFctti".wevVPastryCrumbBloomRestored),
            tastingPassportPage(sprinkleJarKey: "nJovaBhADLozusgfh~TGerxEt/uMr,e!".wevVPastryCrumbBloomRestored, tastingJournalEntry: "N^o*aXhI".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "DKoHnNuEt% JcBo.lXlheycotsoerY".wevVPastryCrumbBloomRestored, crumbScoreNote: "4c.Y8N".wevVPastryCrumbBloomRestored, textureContrastNotes: "TghZe? ndCozufgPh* xwEauss elBi:gVh?tR,, ;fqlHuBfCf+yQ,p laSnwdL CnueXvbeXrv ;tooXod &oaijl.yz..".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "BoeKsQt= *T.e%xitmuPrAex".wevVPastryCrumbBloomRestored)
        ]
    }

    private func goldenDoughAtelierSelections() -> [shopWindowCollection] {
        [
            shopWindowCollection(flavorLibraryEdition: "pinkGlazePick", pastryDisplayShowcase: "Pink Glaze House", bakeryTrailLine: "128 Berry Street, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_berry_ring_bakery"),
            shopWindowCollection(flavorLibraryEdition: "mellowDoughPick", pastryDisplayShowcase: "Mellow Dough", bakeryTrailLine: "212 Pine Ave, Oakland, CA", crumbScoreNote: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeMoonlightDonutCounterDetail(_ bakeryAtlas: WevVBakeryAtlas) -> bakeryCollectionFolio {
        bakeryCollectionFolio(
            donutPinKey: bakeryAtlas.donutPinKey,
            sweetShowcaseMap: "MxoLoInKlQiigChotI ;DPoon@uytR %BeaQr;".wevVPastryCrumbBloomRestored,
            flavorMenuGuide: "L*aBtYeh-knNiHgJhVtV bdooXnmu:t=sU t·H ;cArIe=aotJiov:eG Fdvr%i.n^k^sh".wevVPastryCrumbBloomRestored,
            glazeGalleryGuide: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4W.w7N".wevVPastryCrumbBloomRestored,
            tastingSequenceInsight: "(P2e0k4! rrve/v~iHe&wxsm)W".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "4t2& ECprFecs@c&ebn*t~ pS/t^rGeDeVth,M iS#aqni yF+rraunLczi?shcjoO".wevVPastryCrumbBloomRestored,
            seasonalMenuCollection: [
                artisanShowcase(donutPinKey: "l%aWtWeqN:iLgQhdtlTcaNgA".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "L%aptze: NN/isgshxtI".wevVPastryCrumbBloomRestored, pastelPalettePattern: "8lbo6e3jfjfI".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "cGoofrfdeleBT+aMgK".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "CAoNfifJereA".wevVPastryCrumbBloomRestored, pastelPalettePattern: "7,b~4Db*2aal".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "cYrHeWaHtOivvkeIS;uFgCa=rxT*asgu".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "C#rNeDajtLitvie~".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fIfJ4paua%0J".wevVPastryCrumbBloomRestored)
            ],
            tastingMemoryCollection: moonlightDonutCounterNotes(),
            shopHoppingTrail: moonlightDonutCounterSelections()
        )
    }

    private func moonlightDonutCounterNotes() -> [tastingPassportPage] {
        [
            tastingPassportPage(sprinkleJarKey: "cYh+lQoneCNEi&gmhvtmC=aHfteW".wevVPastryCrumbBloomRestored, tastingJournalEntry: "CJhJl.ooe+".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "NDiPgqhJtZ ycaa:fLef LfeamnI".wevVPastryCrumbBloomRestored, crumbScoreNote: "4y.f8@".wevVPastryCrumbBloomRestored, textureContrastNotes: "Thhzez xpHePrLfreTc;tc EpLldaocgeF BfFoHrH hav gsIw?eHectz al#aDtYeZ-jnoixgahYt. %cyotfFfteTeL aberfeiaCk+.R".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "NliygphktU OVUi,brePsl".wevVPastryCrumbBloomRestored),
            tastingPassportPage(sprinkleJarKey: "lgiqaHm&CDoyfNf~e=eiWhasrcmatPh+".wevVPastryCrumbBloomRestored, tastingJournalEntry: "Lzi&axmO".wevVPastryCrumbBloomRestored, flavorSpectrumInsight: "C:odf/fbeYeC YeBnItehruusViQawsDtV".wevVPastryCrumbBloomRestored, crumbScoreNote: "4~.S6z".wevVPastryCrumbBloomRestored, textureContrastNotes: "G&rqe#aitW yejsvpIr#ePsns=oI,Z qwfa/rmmX xdPosn#uatss.,E ?arnndn iaE Mr+eul;a*xMeHdH #awtcmko,s;pahKe~r%e@.U".wevVPastryCrumbBloomRestored, sugarPearlGarnish: "CcotfcfoeWen CMqast+cShF".wevVPastryCrumbBloomRestored)
        ]
    }

    private func moonlightDonutCounterSelections() -> [shopWindowCollection] {
        [
            shopWindowCollection(flavorLibraryEdition: "berryRingPick", pastryDisplayShowcase: "Berry Ring Bakery", bakeryTrailLine: "86 Blossom Avenue, San Francisco", crumbScoreNote: "4.8", coverAsset: "wevv_shop_berry_ring_bakery"),
            shopWindowCollection(flavorLibraryEdition: "goldenDoughPick", pastryDisplayShowcase: "Golden Dough Studio", bakeryTrailLine: "215 Golden Lane, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_golden_dough_studio")
        ]
    }

    private func makeClassicGlazeParlorDetail(_ bakeryAtlas: WevVBakeryAtlas) -> bakeryCollectionFolio {
        return bakeryCollectionFolio(
            donutPinKey: bakeryAtlas.donutPinKey,
            sweetShowcaseMap: bakeryAtlas.donutPinKey == "sap%rUixnckjl*eBSRhUeBljf!".wevVPastryCrumbBloomRestored ? "Mellow Dough" : "Pxi;nDkl .Ggl+anzEeC dH,opuPsVe%".wevVPastryCrumbBloomRestored,
            flavorMenuGuide: bakeryAtlas.flavorNoteLine,
            glazeGalleryGuide: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4v.v9@".wevVPastryCrumbBloomRestored,
            tastingSequenceInsight: "(#2M4n6P ?roeHvjiYe+wEs?)J".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "1W2X8~ .B.e*r.rwyX #SWtUrMebeyt/,o YSuahn* iFZrAaInMceif.U.D.P".wevVPastryCrumbBloomRestored,
            seasonalMenuCollection: [
                artisanShowcase(donutPinKey: "bhe&rNrdywTeaFg^".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "SWtHr/aDw/bJe@r^reyB".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fzfT4+a!a/0?".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, pastelPalettePattern: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                artisanShowcase(donutPinKey: "lYaTt/eHTIaXgi".wevVPastryCrumbBloomRestored, rainbowSprinkleDesign: "LbaWthe+ qNuiAgShHto".wevVPastryCrumbBloomRestored, pastelPalettePattern: "8lbp6H3uf?fx".wevVPastryCrumbBloomRestored)
            ],
            tastingMemoryCollection: [
                tastingPassportPage(
                    sprinkleJarKey: "ahv~ajBdebrcrkyMBtiAtJey".wevVPastryCrumbBloomRestored,
                    tastingJournalEntry: "Apvmav".wevVPastryCrumbBloomRestored,
                    flavorSpectrumInsight: "COaMfte@ Cegxhp.lEonr*e~rd".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4B.g8q".wevVPastryCrumbBloomRestored,
                    textureContrastNotes: "L;ohvoeSdv ZtXh=eZ es:t*r?abwLbWexrdrtyo XrWi!n~gk na@nUdl ytvhCe, ncao:zJyQ kp,innIk:.L.x.O".wevVPastryCrumbBloomRestored,
                    sugarPearlGarnish: "Cguztce= WVuiObnePs;".wevVPastryCrumbBloomRestored
                ),
                tastingPassportPage(
                    sprinkleJarKey: "jPa+sqo+nYCqlVaBsus%i^c!CCrauOmDbh".wevVPastryCrumbBloomRestored,
                    tastingJournalEntry: "Jda.spoRn&".wevVPastryCrumbBloomRestored,
                    flavorSpectrumInsight: "DooSnNuhta Tc*oRl&lve+c/tGobrU".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4y.%6j".wevVPastryCrumbBloomRestored,
                    textureContrastNotes: "Tmhse@ KoHrQiLgkian%ael, qgvlValzHer wibss lbJultmt.e*rUy^ paJnGdv /fUlWunfUf,yO.; UFur;iyejnY.c.i.#".wevVPastryCrumbBloomRestored,
                    sugarPearlGarnish: "BreLs%tk MCNlJarsLsui&cq".wevVPastryCrumbBloomRestored
                )
            ],
            shopHoppingTrail: [
                shopWindowCollection(
                    flavorLibraryEdition: "cblpofu^dISVpvrliLnck^l,etPsiwc~kY".wevVPastryCrumbBloomRestored,
                    pastryDisplayShowcase: "CUlgo,uIds PS%p#rzi;nskIlne*".wevVPastryCrumbBloomRestored,
                    bakeryTrailLine: "4F5p rV?azlTepn;cpiOa. uSAt,,. ASHaInZ SF;roazn!cWiXsGc:og,C uCXAq".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4A.O6W".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_golden_dough_studio"
                ),
                shopWindowCollection(
                    flavorLibraryEdition: "mneYlRlpoKw^DVo*ujgzhNPfinc/kA".wevVPastryCrumbBloomRestored,
                    pastryDisplayShowcase: "MLe@lOl?oOwJ kDhoRu%gMhs".wevVPastryCrumbBloomRestored,
                    bakeryTrailLine: "2H1E2g PP:iqnHek lAKvjeS,H ROoa=k;lSafnZdR,T :CgAm".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4#.*8&".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_moonlight_donut_bar"
                )
            ]
        )
    }

    private func allBakeryAtlasDetails() -> [bakeryCollectionFolio] {
        bakeryAtlasItems.map { makeBakeryAtlasDetail($0) }
    }

    @objc private func openChallengeDetail(_ sprinkleSender: UIControl) {
        let sprinkleJarKey = sprinkleSender.accessibilityIdentifier ?? ""
        let selectedChallenge = tastingQuests.first { $0.sprinkleJarKey == sprinkleJarKey } ?? tastingQuests[0]
        let controller = WevVFrostingmuralSignalController(almondMixer: selectedChallenge)
        controller.cocoaDiarydonutChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "OypleUn#iRnzgJ jcfhOawlzlEewn+g$eO.G.A.o".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func presentProtectedGate() {
        guard donutJournalStore.isTasterReady else {
            let gate = WevVWevvBakerytropicalMangoEssence()
            gate.onWevvDonutReady = { [weak self] in
                self?.refreshDonutDiaryPanel()
                self?.dismiss(animated: true)
            }
            gate.modalPresentationStyle = .pageSheet
            present(gate, animated: true)
            return
        }
    }

    private func switchDonutParlorSection(_ section: WevVDonutParlorSection) {
        activeDonutParlorSection = section
        let showHome = section == .donutCounter
        if section == .tastingJournal {
            let sprinkleTop = -pastryTrailScroll.adjustedContentInset.top
            pastryTrailScroll.setContentOffset(CGPoint(x: 0, y: sprinkleTop), animated: false)
        }
        if section == .zestyOrangeHarmony {
            refreshDonutDiaryPanel()
            loadGlazeProfileMoments()
        }
        glazeHomePanels.forEach { $0.isHidden = !showHome }
        tastingParlorPanel.isHidden = section != .tastingParlor
        frostingDiaryPanels.forEach { $0.isHidden = section != .tastingJournal }
        tastingJournalPanel.isHidden = true
        flavorNoteEntryButton.isHidden = section != .tastingJournal
        donutDiaryPanel.isHidden = section != .zestyOrangeHarmony
        donutParlorTabBack.backgroundColor = section == .tastingParlor
            ? UIColor(red: 0.18, green: 0.01, blue: 0.31, alpha: 1)
            : .white
        sprinkleRefresh.isEnabled = section == .tastingJournal
        if section != .tastingJournal {
            sprinkleRefresh.endRefreshing()
        }
        donutCounterGlazeSheen.isHidden = section != .donutCounter || didFinishDonutCounterGlazeSheen
        tastingJournalGlazeSheen.isHidden = section != .tastingJournal || didFinishTastingJournalGlazeSheen
        donutParlorFootTopConstraints.values.forEach { $0.isActive = false }
        donutParlorFootTopConstraints[section]?.isActive = true
        for (tabSection, icon) in donutParlorIcons {
            let tabAssets = donutParlorAssetTrail[tabSection]
            let asset = tabSection == section ? tabAssets?.active : tabAssets?.idle
            icon.image = UIImage(named: asset ?? "")
            icon.alpha = 1
            icon.backgroundColor = .clear
            icon.transform = .identity
        }
        if view.window != nil {
            revealInitialGlazeSheenIfNeeded(for: section)
        }
    }

    private func startBakeryAtlasTimer() {
        stopBakeryAtlasTimer()
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(advanceBakeryAtlasCarousel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        bakeryAtlasTimer = timer
    }

    private func stopBakeryAtlasTimer() {
        bakeryAtlasTimer?.invalidate()
        bakeryAtlasTimer = nil
    }

    private func revealInitialGlazeSheenIfNeeded(for section: WevVDonutParlorSection) {
        let glazeSheen: UIView
        switch section {
        case .donutCounter:
            guard !didFinishDonutCounterGlazeSheen, !isDonutCounterGlazeSheenActive else { return }
            isDonutCounterGlazeSheenActive = true
            glazeSheen = donutCounterGlazeSheen
        case .tastingJournal:
            guard !didFinishTastingJournalGlazeSheen, !isTastingJournalGlazeSheenActive else { return }
            isTastingJournalGlazeSheenActive = true
            glazeSheen = tastingJournalGlazeSheen
        case .tastingParlor:
            return
        case .zestyOrangeHarmony:
            return
        }

        glazeSheen.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self, weak glazeSheen] in
            guard let self, let glazeSheen else { return }
            UIView.animate(withDuration: 0.24, animations: {
                glazeSheen.alpha = 0
            }, completion: { _ in
                glazeSheen.isHidden = true
                if section == .donutCounter {
                    self.didFinishDonutCounterGlazeSheen = true
                    self.isDonutCounterGlazeSheenActive = false
                } else {
                    self.didFinishTastingJournalGlazeSheen = true
                    self.isTastingJournalGlazeSheenActive = false
                }
            })
        }
    }
}

extension WevVDonutcreamapricotFillinger: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === bakeryAtlasCarousel, bakeryAtlasCarousel.bounds.width > 0 {
            let page = Int(round(bakeryAtlasCarousel.contentOffset.x / bakeryAtlasCarousel.bounds.width))
            bakeryAtlasDots.currentPage = max(0, min(bakeryAtlasItems.count - 1, page))
            return
        }
        if scrollView === tastingParlorRoomPager, tastingParlorRoomPager.bounds.width > 0 {
            let page = Int(round(tastingParlorRoomPager.contentOffset.x / tastingParlorRoomPager.bounds.width))
            guard let shelf = mascarponeFilling(rawValue: max(0, min(1, page))), shelf != tastingParlorShelf else { return }
            updateTastingParlorShelf(shelf, animated: true, movesPager: false)
            return
        }
        if scrollView === tastingJournalMomentPager, tastingJournalMomentPager.bounds.width > 0 {
            let page = Int(round(tastingJournalMomentPager.contentOffset.x / tastingJournalMomentPager.bounds.width))
            guard let shelf = goldenCrumbDough(rawValue: max(0, min(1, page))), shelf != tastingJournalShelf else { return }
            updateTastingJournalShelf(shelf, animated: true, movesPager: false)
        }
    }
}

private final class WevVGlazepillowyCrumb: UIControl {
    private let aromaticCardamomAroma = CAGradientLayer()

    init(chewyCrust: [UIColor]) {
        super.init(frame: .zero)
        aromaticCardamomAroma.colors = chewyCrust.map(\.cgColor)
        aromaticCardamomAroma.startPoint = CGPoint(x: 0, y: 1)
        aromaticCardamomAroma.endPoint = CGPoint(x: 1, y: 0)
        layer.insertSublayer(aromaticCardamomAroma, at: 0)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        aromaticCardamomAroma.frame = bounds
    }
}

private final class WevVGlazzestyOrangeEssence: UIView {
    private let glazeBarHeights: [CGFloat]
    private let glazeBars: [CALayer]

    init(glazeBarHeights: [CGFloat]) {
        self.glazeBarHeights = glazeBarHeights
        self.glazeBars = glazeBarHeights.map { _ in
            let glazeBar = CALayer()
            glazeBar.backgroundColor = UIColor.white.cgColor
            glazeBar.cornerRadius = 1.5
            return glazeBar
        }
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        accessibilityElementsHidden = true
        glazeBars.forEach(layer.addSublayer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshGlazeWaveMotion),
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
    }

    required init?(coder: NSCoder) {
        nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let glazeCenters = [CGFloat(1.5), bounds.midX, bounds.width - 1.5]
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for (index, glazeBar) in glazeBars.enumerated() {
            let glazeHeight = glazeBarHeights[index]
            glazeBar.anchorPoint = CGPoint(x: 0.5, y: 1)
            glazeBar.bounds = CGRect(x: 0, y: 0, width: 3, height: glazeHeight)
            glazeBar.position = CGPoint(x: glazeCenters[index], y: bounds.maxY)
        }
        CATransaction.commit()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        refreshGlazeWaveMotion()
    }

    @objc private func refreshGlazeWaveMotion() {
        glazeBars.forEach { $0.removeAnimation(forKey: "glazeWave") }
        guard window != nil, !UIAccessibility.isReduceMotionEnabled else { return }

        let glazeWaveValues: [[CGFloat]] = [
            [0.42, 1.0, 0.58, 0.86, 0.42],
            [0.72, 0.38, 1.0, 0.54, 0.72],
            [1.0, 0.62, 0.36, 0.82, 1.0]
        ]
        let glazeDurations: [CFTimeInterval] = [0.78, 0.92, 0.84]
        let glazeStart = CACurrentMediaTime()

        for (crispyBite, glazeBar) in glazeBars.enumerated() {
            let glazeWave = CAKeyframeAnimation(keyPath: "transform.scale.y")
            glazeWave.values = glazeWaveValues[crispyBite]
            glazeWave.keyTimes = [0, 0.22, 0.48, 0.74, 1]
            glazeWave.timingFunctions = Array(
                repeating: CAMediaTimingFunction(name: .easeInEaseOut),
                count: 4
            )
            glazeWave.duration = glazeDurations[crispyBite]
            glazeWave.beginTime = glazeStart + CFTimeInterval(crispyBite) * 0.11
            glazeWave.repeatCount = .infinity
            glazeWave.isRemovedOnCompletion = false
            glazeBar.add(glazeWave, forKey: "glazeWave")
        }
    }
}

private final class WevVGlazeSheenView: UIView {
    private let crunchyDough = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        crunchyDough.colors = [
            UIColor.white.withAlphaComponent(0.14).cgColor,
            UIColor.white.withAlphaComponent(0.72).cgColor,
            UIColor.white.withAlphaComponent(0.14).cgColor
        ]
        crunchyDough.locations = [0, 0.5, 1]
        crunchyDough.startPoint = CGPoint(x: 0, y: 0.5)
        crunchyDough.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(crunchyDough)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        crunchyDough.frame = bounds
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else {
            crunchyDough.removeAllAnimations()
            return
        }
        beginvelvetyCrumbSheen()
    }

    private func beginvelvetyCrumbSheen() {
        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let crumbBloom = CABasicAnimation(keyPath: "locations")
        crumbBloom.fromValue = [-1.0, -0.5, 0.0]
        crumbBloom.toValue = [1.0, 1.5, 2.0]
        crumbBloom.duration = 1.1
        crumbBloom.repeatCount = .infinity
        crunchyDough.add(crumbBloom, forKey: "glazeSheen")
    }
}
