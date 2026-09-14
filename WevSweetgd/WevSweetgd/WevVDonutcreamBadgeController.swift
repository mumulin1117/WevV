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
    WevVFlavorNote(sugarDustKey: sugarDustKey, tastingCardTitle: sugarTitle, flavorNoteText: crumbNote)
}

final class WevVDonutcreamBadgeController: UIViewController {
    private let donutJournalStore = WevVGlazeSessionStore.shared
    private let bakeryTasterStore = WevVGuestGlazeStore.shared
    private let pastryTrailScroll = UIScrollView()
    private let donutCaseContent = UIView()
    private let bakeryAtlasCarousel = UIScrollView()
    private let bakeryAtlasPages = UIStackView()
    private let bakeryAtlasDots = UIPageControl()
    private let tastingQuestStrip = UIScrollView()
    private let tastingQuestRow = UIStackView()
    private let donutSnapshotStack = UIStackView()
    private let tastingJournalPanel = UIView()
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
        .tastingJournal: ("wevv_tab_discover_sprinkle_idle", "wevv_tab_discover_sprinkle_active"),
        .donutDiary: ("wevv_tab_profile_donut_idle", "wevv_tab_profile_donut_active")
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
        email: "wHeRvcvh@rgamoaHiLls.gcSoom?".wevVPastryCrumbBloomRestored,
        glazeNickname: "GelLaLzYe: oTnausstKemrm".wevVPastryCrumbBloomRestored,
        donutFrameAsset: "wevv_profile_avatar_piano_donut",
        tastingMarks: WevVTastingMark(glazeTrailCount: 12, sprinkleTasterCount: 28, bakeryShelfTotal: 7, donutArchiveTotal: 360),
        flavorNotes: [
            makeFlavorNoteEntry("s^t;rJa:w?bdeqr#r;yhR,ienJgYNSoatxeB".wevVPastryCrumbBloomRestored, "S!tRrTatwNbne,rkrIyB dgClta%zhe+ qmioPr,n,ivndgH".wevVPastryCrumbBloomRestored, "S@oefLtg SfLrSolsctNiBnQg%,Y .w=aurzmm #c+rBuOmYbb,C NblrBiGgShAt@ nsSurgra/rn.J".wevVPastryCrumbBloomRestored),
            makeFlavorNoteEntry("cvo?cioyakSDpkrHi/nIk!l&eMTFr=aui=lB".wevVPastryCrumbBloomRestored, "Cxo,cOoOaD Kstpkr#iznDk&lfe^ dtRaEsHtgiRn/gu".wevVPastryCrumbBloomRestored, "SpaJv!ead& saP XsfmyaOlvle KsxhNohpv wwMo^rMtChN dcoo?mfiHnSgT sb%a?cZkQ ttUoq.q".wevVPastryCrumbBloomRestored)
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        preloadFlavorNotes()
        preloadTastingQuests()
        buildDonutParlorBackdrop()
        buildPastryTrailScroll()
        buildTopDonutBar()
        buildBakeryVisitBand()
        buildTastingQuestBand()
        buildTastingJournalPanel()
        buildFlavorNotePanel()
        buildDonutDiaryPanel()
        buildDonutParlorFoot()
        buildDonutParlorTabBar()
        buildFlavorNoteEntryButton()
        buildInitialGlazeSheenPanels()
        switchDonutParlorSection(.donutCounter)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBakeryAtlasTimer()
        revealInitialGlazeSheenIfNeeded(for: activeDonutParlorSection)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBakeryAtlasTimer()
    }

    deinit {
        stopBakeryAtlasTimer()
    }

    private func buildDonutParlorBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.78, blue: 0.85, alpha: 1)

        let backdonutdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdonutdrop.translatesAutoresizingMaskIntoConstraints = false
        backdonutdrop.contentMode = .scaleAspectFill
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
        pastryTrailScroll.contentInsetAdjustmentBehavior = .never
        pastryTrailScroll.contentInset.bottom = 110
        pastryTrailScroll.verticalScrollIndicatorInsets.bottom = 110
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
        let logodonutWevvButton = makeImageButton(asset: "wevv_home_wevv_glaze_logo", action: #selector(openGlazeNoticeList))
        let noticedonutWevvButton = makeImageButton(asset: "wevv_top_sprinkle_inbox_entry", action: #selector(openGlazeNoticeList))

        donutCaseContent.addSubview(logodonutWevvButton)
        donutCaseContent.addSubview(noticedonutWevvButton)
        glazeHomePanels.append(contentsOf: [logodonutWevvButton, noticedonutWevvButton])

        NSLayoutConstraint.activate([
            logodonutWevvButton.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 26),
            logodonutWevvButton.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            logodonutWevvButton.widthAnchor.constraint(equalToConstant: 101),
            logodonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticedonutWevvButton.centerYAnchor.constraint(equalTo: logodonutWevvButton.centerYAnchor),
            noticedonutWevvButton.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            noticedonutWevvButton.widthAnchor.constraint(equalToConstant: 44),
            noticedonutWevvButton.heightAnchor.constraint(equalToConstant: 44)
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

        let checkinButton = makeDonutVisitButton(dailyDonutVisit)
        donutCaseContent.addSubview(checkinButton)
        glazeHomePanels.append(contentsOf: [bakeryAtlasCarousel, bakeryAtlasDots, checkinButton])

        let shopWidth = min(UIScreen.main.bounds.width * 0.55, 206)
//        let checkinWidth = min(UIScreen.main.bounds.width * 0.34, 124)

        NSLayoutConstraint.activate([
            bakeryAtlasCarousel.topAnchor.constraint(equalTo: donutCaseContent.safeAreaLayoutGuide.topAnchor, constant: 96),
            bakeryAtlasCarousel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            bakeryAtlasCarousel.widthAnchor.constraint(equalToConstant: shopWidth),
            bakeryAtlasCarousel.heightAnchor.constraint(equalTo: bakeryAtlasCarousel.widthAnchor, multiplier: 265.0 / 206.0),
            bakeryAtlasPages.topAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.topAnchor),
            bakeryAtlasPages.leadingAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.leadingAnchor),
            bakeryAtlasPages.trailingAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.trailingAnchor),
            bakeryAtlasPages.bottomAnchor.constraint(equalTo: bakeryAtlasCarousel.contentLayoutGuide.bottomAnchor),
            bakeryAtlasPages.heightAnchor.constraint(equalTo: bakeryAtlasCarousel.frameLayoutGuide.heightAnchor),
            bakeryAtlasDots.centerXAnchor.constraint(equalTo: bakeryAtlasCarousel.centerXAnchor),
            bakeryAtlasDots.bottomAnchor.constraint(equalTo: bakeryAtlasCarousel.bottomAnchor, constant: -12),
            checkinButton.topAnchor.constraint(equalTo: bakeryAtlasCarousel.topAnchor),
            checkinButton.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            checkinButton.leadingAnchor.constraint(equalTo: bakeryAtlasCarousel.trailingAnchor, constant: 15),
            checkinButton.heightAnchor.constraint(equalTo: bakeryAtlasCarousel.heightAnchor)
        ])
    }

    private func buildTastingQuestBand() {
        let titledonutWevvImage = UIImageView(image: UIImage(named: "wevv_challenge_recommend_title"))
        titledonutWevvImage.translatesAutoresizingMaskIntoConstraints = false
        titledonutWevvImage.contentMode = .scaleAspectFit
        donutCaseContent.addSubview(titledonutWevvImage)

        let postdonutWevvButton = UIButton(type: .system)
        postdonutWevvButton.translatesAutoresizingMaskIntoConstraints = false
        postdonutWevvButton.setTitle("PBojsvtP".wevVPastryCrumbBloomRestored, for: .normal)
        postdonutWevvButton.setTitleColor(.white, for: .normal)
        postdonutWevvButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        postdonutWevvButton.backgroundColor = .black
        postdonutWevvButton.layer.cornerRadius = 14
        postdonutWevvButton.addTarget(self, action: #selector(openTastingQuestComposer), for: .touchUpInside)
        donutCaseContent.addSubview(postdonutWevvButton)

        tastingQuestStrip.translatesAutoresizingMaskIntoConstraints = false
        tastingQuestStrip.showsHorizontalScrollIndicator = false
        donutCaseContent.addSubview(tastingQuestStrip)
        glazeHomePanels.append(contentsOf: [titledonutWevvImage, postdonutWevvButton, tastingQuestStrip])

        tastingQuestRow.translatesAutoresizingMaskIntoConstraints = false
        tastingQuestRow.axis = .horizontal
        tastingQuestRow.spacing = 10
        tastingQuestStrip.addSubview(tastingQuestRow)

        rebuildTastingQuestRow()

        NSLayoutConstraint.activate([
            titledonutWevvImage.topAnchor.constraint(equalTo: bakeryAtlasCarousel.bottomAnchor, constant: 24),
            titledonutWevvImage.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor, constant: 15),
            titledonutWevvImage.widthAnchor.constraint(equalToConstant: 212),
            titledonutWevvImage.heightAnchor.constraint(equalToConstant: 24),
            postdonutWevvButton.centerYAnchor.constraint(equalTo: titledonutWevvImage.centerYAnchor),
            postdonutWevvButton.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor, constant: -15),
            postdonutWevvButton.widthAnchor.constraint(equalToConstant: 62),
            postdonutWevvButton.heightAnchor.constraint(equalToConstant: 28),
            tastingQuestStrip.topAnchor.constraint(equalTo: titledonutWevvImage.bottomAnchor, constant: 28),
            tastingQuestStrip.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            tastingQuestStrip.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            tastingQuestStrip.heightAnchor.constraint(equalToConstant: 250),
            tastingQuestRow.topAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.topAnchor),
            tastingQuestRow.leadingAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.leadingAnchor, constant: 14),
            tastingQuestRow.trailingAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.trailingAnchor, constant: -14),
            tastingQuestRow.bottomAnchor.constraint(equalTo: tastingQuestStrip.contentLayoutGuide.bottomAnchor),
            tastingQuestRow.heightAnchor.constraint(equalTo: tastingQuestStrip.frameLayoutGuide.heightAnchor)
        ])
    }

    private func buildTastingJournalPanel() {
        bakeryAtlasPanel.translatesAutoresizingMaskIntoConstraints = false
        bakeryAtlasPanel.isHidden = true
        donutCaseContent.addSubview(bakeryAtlasPanel)

        let exploredonutWevvButton = makeImageButton(asset: "wevv_discover_explore_logo", action: #selector(openGlazeNoticeList))
        let noticeButton = makeImageButton(asset: "wevv_discover_notice_entry", action: #selector(openGlazeNoticeList))
        let featuredTitle = UIImageView(image: UIImage(named: "wevv_discover_featured_title"))
        featuredTitle.translatesAutoresizingMaskIntoConstraints = false
        featuredTitle.contentMode = .scaleAspectFit

        donutSnapshotStack.translatesAutoresizingMaskIntoConstraints = false
        donutSnapshotStack.axis = .vertical
        donutSnapshotStack.spacing = 10

        rebuildDonutSnapshotStack()

        bakeryAtlasPanel.addSubview(exploredonutWevvButton)
        bakeryAtlasPanel.addSubview(noticeButton)
        bakeryAtlasPanel.addSubview(featuredTitle)
        bakeryAtlasPanel.addSubview(donutSnapshotStack)
        frostingDiaryPanels.append(bakeryAtlasPanel)

        NSLayoutConstraint.activate([
            bakeryAtlasPanel.topAnchor.constraint(equalTo: donutCaseContent.topAnchor),
            bakeryAtlasPanel.leadingAnchor.constraint(equalTo: donutCaseContent.leadingAnchor),
            bakeryAtlasPanel.trailingAnchor.constraint(equalTo: donutCaseContent.trailingAnchor),
            exploredonutWevvButton.topAnchor.constraint(equalTo: bakeryAtlasPanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            exploredonutWevvButton.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 15),
            exploredonutWevvButton.widthAnchor.constraint(equalToConstant: 125),
            exploredonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticeButton.centerYAnchor.constraint(equalTo: exploredonutWevvButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -15),
            noticeButton.widthAnchor.constraint(equalToConstant: 44),
            noticeButton.heightAnchor.constraint(equalToConstant: 44),
            featuredTitle.topAnchor.constraint(equalTo: exploredonutWevvButton.bottomAnchor, constant: 26),
            featuredTitle.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 15),
            featuredTitle.widthAnchor.constraint(equalToConstant: 105),
            featuredTitle.heightAnchor.constraint(equalToConstant: 24),
            donutSnapshotStack.topAnchor.constraint(equalTo: featuredTitle.bottomAnchor, constant: 16),
            donutSnapshotStack.leadingAnchor.constraint(equalTo: bakeryAtlasPanel.leadingAnchor, constant: 15),
            donutSnapshotStack.trailingAnchor.constraint(equalTo: bakeryAtlasPanel.trailingAnchor, constant: -15),
            donutSnapshotStack.bottomAnchor.constraint(equalTo: bakeryAtlasPanel.bottomAnchor)
        ])
    }

    private func buildDonutParlorTabBar() {
        donutParlorTabBack.translatesAutoresizingMaskIntoConstraints = false
        donutParlorTabBack.backgroundColor = UIColor(red: 0.13, green: 0.0, blue: 0.27, alpha: 1)
        donutParlorTabBack.layer.cornerRadius = 18
        donutParlorTabBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(donutParlorTabBack)

        let donutRow = UIStackView(arrangedSubviews: [
            makeTabButton(section: .donutCounter, asset: "wevv_tab_home_glaze_active"),
            makeTabButton(section: .tastingJournal, asset: "wevv_tab_discover_sprinkle_idle"),
            makeTabButton(section: .donutDiary, asset: "wevv_tab_profile_donut_idle")
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
            donutRow.topAnchor.constraint(equalTo: donutParlorTabBack.topAnchor, constant: 20),
            donutRow.leadingAnchor.constraint(equalTo: donutParlorTabBack.leadingAnchor, constant: 50),
            donutRow.trailingAnchor.constraint(equalTo: donutParlorTabBack.trailingAnchor, constant: -50),
            donutRow.heightAnchor.constraint(equalToConstant: 44)
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

        donutParlorFootTopConstraints[.donutCounter] = donutParlorFoot.topAnchor.constraint(equalTo: tastingQuestStrip.bottomAnchor, constant: 28)
        donutParlorFootTopConstraints[.tastingJournal] = donutParlorFoot.topAnchor.constraint(equalTo: bakeryAtlasPanel.bottomAnchor, constant: 32)
        donutParlorFootTopConstraints[.donutDiary] = donutParlorFoot.topAnchor.constraint(equalTo: donutDiaryPanel.bottomAnchor, constant: 32)
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

        let glazeImage = UIImageView(image: UIImage(named: bakeryAtlas.bakeryFrameAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        treatCaseCard.addSubview(glazeImage)

        let titleBand = UIView()
        titleBand.translatesAutoresizingMaskIntoConstraints = false
        titleBand.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.78, alpha: 0.72)
        titleBand.layer.cornerRadius = 12
        titleBand.clipsToBounds = true
        treatCaseCard.addSubview(titleBand)

        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = "\(bakeryAtlas.bakeryTitle)\nrecommendations"
        glazeTitleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        glazeTitleLabel.textColor = .white
        glazeTitleLabel.textAlignment = .center
        glazeTitleLabel.numberOfLines = 2
        glazeTitleLabel.adjustsFontSizeToFitWidth = true
        glazeTitleLabel.minimumScaleFactor = 0.72
        titleBand.addSubview(glazeTitleLabel)
        let safetyButton = makeHomeSafetyButton(bakeryAtlas.donutPinKey, action: #selector(openGlazeShopSafety(_:)))
        treatCaseCard.addSubview(safetyButton)

        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: treatCaseCard.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor),
            titleBand.leadingAnchor.constraint(equalTo: treatCaseCard.leadingAnchor, constant: 14),
            titleBand.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -14),
            titleBand.bottomAnchor.constraint(equalTo: treatCaseCard.bottomAnchor, constant: -27),
            titleBand.heightAnchor.constraint(equalToConstant: 46),
            glazeTitleLabel.topAnchor.constraint(equalTo: titleBand.topAnchor, constant: 4),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: titleBand.leadingAnchor, constant: 8),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: titleBand.trailingAnchor, constant: -8),
            glazeTitleLabel.bottomAnchor.constraint(equalTo: titleBand.bottomAnchor, constant: -5),
            safetyButton.topAnchor.constraint(equalTo: treatCaseCard.topAnchor, constant: 10),
            safetyButton.trailingAnchor.constraint(equalTo: treatCaseCard.trailingAnchor, constant: -10),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
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

    private func makeTastingQuestCard(_ tastingQuest: WevVTastingQuest) -> UIControl {
        let treatCaseCard = UIControl()
        treatCaseCard.translatesAutoresizingMaskIntoConstraints = false
        treatCaseCard.accessibilityIdentifier = tastingQuest.sprinkleJarKey
        treatCaseCard.addTarget(self, action: #selector(openChallengeDetail(_:)), for: .touchUpInside)

        let heroImage = makeSprinkleQuestHeroImage(asset: tastingQuest.cardAsset)
        let frameImage = makeSprinkleQuestFrameImage()
        let glazeTitleLabel = makeSprinkleQuestNameLabel(tastingQuest.menuBoardTitle)
        let joinLabel = makeSprinkleQuestJoinLabel(tastingQuest.glazeSheenText)
        let arrowImage = makeSprinkleQuestArrowImage()
        let tasterAvatars = makeChallengeTasterStack(for: tastingQuest)
        let safetyButton = makeHomeSafetyButton(tastingQuest.sprinkleJarKey, action: #selector(openSprinkleQuestSafety(_:)))

        placeChallengeCardViews(treatCaseCard: treatCaseCard, heroImage: heroImage, frameImage: frameImage, glazeTitleLabel: glazeTitleLabel, tasterAvatars: tasterAvatars, joinLabel: joinLabel, arrowImage: arrowImage, safetyButton: safetyButton)
        pinChallengeCardLayout(treatCaseCard: treatCaseCard, heroImage: heroImage, frameImage: frameImage, glazeTitleLabel: glazeTitleLabel, tasterAvatars: tasterAvatars, joinLabel: joinLabel, arrowImage: arrowImage, safetyButton: safetyButton)
        return treatCaseCard
    }

    private func makeSprinkleQuestHeroImage(asset: String) -> UIImageView {
        let heroImage = UIImageView(image: WevVPastryImageVault.glazeImage(for: asset))
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
            treatCaseCard.widthAnchor.constraint(equalToConstant: 148),
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
        let glazeImage = UIImageView(image: WevVPastryImageVault.glazeImage(for: donutSnapshot.donutBackdropAsset) ?? makeFrostingHeroImage(seed: donutSnapshot.donutBackdropAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        return glazeImage
    }

    private func makeSprinkleMomentTextBand() -> UIView {
        let glazeBand = WevVSugarGradientBand()
        glazeBand.translatesAutoresizingMaskIntoConstraints = false
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

        let glazeImage = UIImageView(image: UIImage(named: asset))
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
        sprinkleButton.addTarget(self, action: #selector(selectDonutSection(_:)), for: .touchUpInside)

        let icon = makeTabIcon(asset)
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

    private func makeTabIcon(_ asset: String) -> UIImageView {
        let icon = UIImageView(image: UIImage(named: asset))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 44),
            icon.heightAnchor.constraint(equalToConstant: 44)
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
        let followingRosterCount = bakeryTasterStore.glazeFollowingProfiles.count
        let tastingMarks = isReady
            ? WevVTastingMark(
                glazeTrailCount: followingRosterCount,
                sprinkleTasterCount: baseStat.sprinkleTasterCount,
                bakeryShelfTotal: baseStat.bakeryShelfTotal + donutJournalStore.glazeShelfCount,
                donutArchiveTotal: donutJournalStore.glazeGoldCount
            )
            : WevVTastingMark(glazeTrailCount: 0, sprinkleTasterCount: 0, bakeryShelfTotal: 0, donutArchiveTotal: 0)
        donutDiaryNameLabel.text = isReady ? currentUser.glazeNickname : ""
        profileAvatarImageView?.image = UIImage(named: currentUser.donutFrameAsset)
        bakeryTrailCountLabel.text = "\(tastingMarks.glazeTrailCount)"
        tasterTrailCountLabel.text = "\(tastingMarks.sprinkleTasterCount)"
        bakeryShelfCountLabel.text = "\(tastingMarks.bakeryShelfTotal)"
        donutArchiveCountLabel.text = "\(tastingMarks.donutArchiveTotal)"

        flavorNoteStack.arrangedSubviews.forEach { sugarView in
            flavorNoteStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }

        emptyFlavorStack.isHidden = false
        flavorNoteStack.isHidden = true
    }

    private func currentFlavorNotes() -> [WevVFlavorNote] {
        let freshPosts = donutJournalStore.sugarMomentPackets.map {
            WevVFlavorNote(sugarDustKey: $0.sugarDustKey, tastingCardTitle: $0.citrusParlor, flavorNoteText: $0.lemonCutter)
        }
        return freshPosts + currentDonutDiaryTaster().flavorNotes
    }

    private func currentDonutDiaryTaster() -> WevVDonutDiaryTaster {
        let profile = donutJournalStore.currentDoughRingTasterProfile
        return WevVDonutDiaryTaster(
            ringCutterKey: profile.ringCutterKey,
            email: profile.email,
            glazeNickname: profile.glazeNickname.isEmpty ? defaultDonutDiaryTaster.glazeNickname : profile.glazeNickname,
            donutFrameAsset: profile.donutFrameAsset.isEmpty ? defaultDonutDiaryTaster.donutFrameAsset : profile.donutFrameAsset,
            tastingMarks: WevVTastingMark(
                glazeTrailCount: profile.glazeTrailCount,
                sprinkleTasterCount: profile.sprinkleTasterCount,
                bakeryShelfTotal: profile.bakeryShelfTotal,
                donutArchiveTotal: profile.glazeVaultCount
            ),
            flavorNotes: defaultDonutDiaryTaster.flavorNotes
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
        crumbNote.text = flavorNote.flavorNoteText
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
        controller.onWevvTastingQuestReady = { [weak self] packet in
            guard let self else { return }
            let quest = self.makeTastingQuest(from: packet)
            self.tastingQuests.removeAll { self.isSameTastingQuest($0, quest) }
            self.tastingQuests.insert(quest, at: 0)
            self.rebuildTastingQuestRow()
            self.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Prrje^pZa$rFiBnzg& =pUo@sVtq YtCrLa=yQ.B.e.k".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openFlavorNoteComposer() {
        guard donutJournalStore.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarMomentComposerController()
        controller.onSugarMomentReady = { [weak self] packet in
            guard let self else { return }
            let currentUser = self.currentDonutDiaryTaster()
            let freshMoment = WevVDonutSnapshot(
                sprinkleJarKey: packet.sugarDustKey,
                tasterBloom: WevVDonutTaster(donutPinKey: currentUser.ringCutterKey, name: currentUser.glazeNickname, donutFrameAsset: currentUser.donutFrameAsset),
                donutBackdropAsset: packet.donutBackdropAsset,
                tastingText: packet.lemonCutter,
                hasSprinkleDust: false,
                hasBakeryShelf: false,
                freshnessTagText: packet.citrusParlor
            )
            self.donutSnapshots.insert(freshMoment, at: 0)
            self.rebuildDonutSnapshotStack()
            self.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVGlazeCrackleOverlay.showGlazeCrackle(in: view, note: "Prrje^pZa$rFiBnzg& =pUo@sVtq YtCrLa=yQ.B.e.k".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func rebuildDonutSnapshotStack() {
        donutSnapshotStack.arrangedSubviews.forEach { sugarView in
            donutSnapshotStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        for donutSnapshot in donutSnapshots {
            guard !isSprinkleAuthorShielded(donutSnapshot) else { continue }
            donutSnapshotStack.addArrangedSubview(makeDonutSnapshotCard(donutSnapshot))
        }
    }

    private func rebuildTastingQuestRow() {
        tastingQuestRow.arrangedSubviews.forEach { sugarView in
            tastingQuestRow.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        let uniqueTastingQuestItems = uniqueTastingQuests(tastingQuests)
        tastingQuests = uniqueTastingQuestItems
        for tastingQuest in uniqueTastingQuestItems {
            tastingQuestRow.addArrangedSubview(makeTastingQuestCard(tastingQuest))
        }
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
        let controller = WevVDailyDonutStampController()
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
        let controller = WevVWevvBakeryShelfController(bakeryDetails: allBakeryAtlasDetails())
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
        let controller = WevVSugarRosterController(mode: mode)
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
        let controller = WevVSugarSettingsController()
        controller.onSugarSettingChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openDonutSnapshotDetail(_ sender: UIControl) {
        let sprinkleJarKey = sender.accessibilityIdentifier ?? donutSnapshots[0].sprinkleJarKey
        let donutSnapshot = donutSnapshots.first { $0.sprinkleJarKey == sprinkleJarKey } ?? donutSnapshots[0]
        let controller = WevVWevvDonutMomentController(donutSnapshot: donutSnapshot)
        controller.onWevvDonutMomentGuarded = { [weak self] in
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
        let sheet = WevVGlazeSafetySheet(bakeryPinKey: sugarDustKey, choices: sprinkleSafetyChoices())
        sheet.almondMixer = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.almondBench = { [weak self, weak sheet] packet in
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
        let sheet = WevVGlazeSafetySheet(bakeryPinKey: moment.tasterBloom.donutPinKey, choices: sprinkleSafetyChoices())
        sheet.almondMixer = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.almondBench = { [weak self, weak sheet] packet in
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

    private func sprinkleSafetyChoices() -> [WevVGlazeSafetyChoice] {
        [
            WevVGlazeSafetyChoice(sugarDustKey: "f.aikDevP=hGortBom".wevVPastryCrumbBloomRestored, almondCase: "FDaEkEeL ^pyhUoOtNo#".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "spcQavmUCNoLmVmJeLr?ciioaGlp".wevVPastryCrumbBloomRestored, almondCase: "S%cfaLmc Io/rq xcVoom=mpeSr=cGila@l%".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "nso!tUI#nBt+e*rIebsIt:e=dn".wevVPastryCrumbBloomRestored, almondCase: "NWoYtV ^irnxtkePrGemsAtQe%dG".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarDustKey: "ootchFeurzSku?g?airR".wevVPastryCrumbBloomRestored, almondCase: "OAt#hOegr^".wevVPastryCrumbBloomRestored, needsCreamText: true)
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
        let controller = WevVDonutVaultController()
        controller.onVaultChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openShopCarouselEntry(_ glazedSender: UIControl) {
        let donutPinKey = glazedSender.accessibilityIdentifier ?? bakeryAtlasItems[0].donutPinKey
        let bakeryAtlas = bakeryAtlasItems.first { $0.donutPinKey == donutPinKey } ?? bakeryAtlasItems[0]
        let shopShelf = allBakeryAtlasDetails()
        let detail = shopShelf.first { $0.donutPinKey == bakeryAtlas.donutPinKey } ?? makeBakeryAtlasDetail(bakeryAtlas)
        let controller = WevVWevvBakeryDetailController(detail: detail, bakeryShelf: shopShelf)
        controller.onWevvShelfChanged = { [weak self] in
            self?.refreshDonutDiaryPanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func makeBakeryAtlasDetail(_ bakeryAtlas: WevVBakeryAtlas) -> WevVWevvBakeryDetail {
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

    private func makeBerryCrumbBakeryDetail(_ bakeryAtlas: WevVBakeryAtlas) -> WevVWevvBakeryDetail {
        WevVWevvBakeryDetail(
            donutPinKey: bakeryAtlas.donutPinKey,
            sprinkleFlight: "BKeAr^rGyj ~RHiTnMgG ABZaVkBeqrfyc".wevVPastryCrumbBloomRestored,
            crumbFlight: "FcrLels@hP ^dPosn.uvt+sV &·z =b=eKr=rjy@ bf?lSa.vooUrYsU".wevVPastryCrumbBloomRestored,
            pastryFlight: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4g.r8,".wevVPastryCrumbBloomRestored,
            tastingNoteText: "(s1T8o6m greeDvHine#wRsy)o".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "8/6d OBIlXoxs,sLoOmm sAGvhe+nauVev,p jS#aLnL ZFBrFaWnrcRiasxcjon".wevVPastryCrumbBloomRestored,
            bakeryTags: [
                WevVWevvBakeryTag(donutPinKey: "sjtGrIaKwXbVe^rqrdy~T!aggB".wevVPastryCrumbBloomRestored, flavorFlight: "SXtDr&aow/bhezrxruy:".wevVPastryCrumbBloomRestored, tintHex: "f=fl4uaka%0G".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "hoadnHdcmGaMddeOT/aQgD".wevVPastryCrumbBloomRestored, flavorFlight: "H:a!n?d,mAamdoet".wevVPastryCrumbBloomRestored, tintHex: "fn5,bX4#3!1G".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, flavorFlight: "CCopzsyb".wevVPastryCrumbBloomRestored, tintHex: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored)
            ],
            tastingParlorTitle: "Byepr&rayW JDPojnQuot! PColPuubH".wevVPastryCrumbBloomRestored,
            tastingParlorLine: "SGhmairZeY ?f!r#upictOy, Wf@l=asvtoQr#s&,! Tspw@eWeFts =pQiecdkSsh,f basnldU Abza=kDecrcyW @s!tEo#r.ihessL.A".wevVPastryCrumbBloomRestored,
            tastingTableText: "2F4l MoTn,l+i*nweg".wevVPastryCrumbBloomRestored,
            crumbTastings: berryCrumbBakeryNotes(),
            bakeryFinds: berryCrumbBakerySelections()
        )
    }

    private func berryCrumbBakeryNotes() -> [WevVWevvCrumbTasting] {
        [
            WevVWevvCrumbTasting(sprinkleJarKey: "mjiRaNBZeSr^rPy/GRlCaszseN".wevVPastryCrumbBloomRestored, donutTasterName: "MniBac".wevVPastryCrumbBloomRestored, flavorRole: "D!ecsrskebrut; Uleo*v;e?ro".wevVPastryCrumbBloomRestored, crumbScoreNote: "4Z.*9I".wevVPastryCrumbBloomRestored, biteNoteText: "TYhCeR ^s!t+rRaJwWbMe!rfrRyR &gLl;ayzUet !wPa%sg gfprSehsGhz,X %sNmJowoXtdhw,o =a=n;dL vphebrwfEeJc~t#l*yc MscwdedeZta.z".wevVPastryCrumbBloomRestored, donutBadgeText: "BleRrnr:yR AFwatv:oErgi=twem".wevVPastryCrumbBloomRestored),
            WevVWevvCrumbTasting(sprinkleJarKey: "eUtWhDatn.CJoqz;yiBIackHe:r:yB".wevVPastryCrumbBloomRestored, donutTasterName: "E+tyhka~n#".wevVPastryCrumbBloomRestored, flavorRole: "Wke=etkceGnCdE Ze+xlpWlMo+raesr^".wevVPastryCrumbBloomRestored, crumbScoreNote: "4v.T7l".wevVPastryCrumbBloomRestored, biteNoteText: "Aj &cfo?zqyT bl#i#tytulzee ^sGh^ohp@ %wLiktuhD isaorfUth UdyoPnju%t/s/ YasnAd% NfJrRi&eHn:dfl=ys NshevrevXizc*eP.X".wevVPastryCrumbBloomRestored, donutBadgeText: "C@orzAyz HSPpsoHtt".wevVPastryCrumbBloomRestored)
        ]
    }

    private func berryCrumbBakerySelections() -> [WevVWevvBakeryPick] {
        [
            WevVWevvBakeryPick(sugarDustKey: "goldenDoughPick", treatFlight: "Golden Dough Studio", bakeryTrailLine: "215 Golden Lane, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_golden_dough_studio"),
            WevVWevvBakeryPick(sugarDustKey: "mellowDoughPick", treatFlight: "Mellow Dough", bakeryTrailLine: "212 Pine Ave, Oakland, CA", crumbScoreNote: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeGoldenDoughAtelierDetail(_ bakeryAtlas: WevVBakeryAtlas) -> WevVWevvBakeryDetail {
        WevVWevvBakeryDetail(
            donutPinKey: bakeryAtlas.donutPinKey,
            sprinkleFlight: "G+oplcddeanm ZD#oGueguhy SSxtEu?dtiWoo".wevVPastryCrumbBloomRestored,
            crumbFlight: "ADr&tPi#sEa~nY QdGo@n?uzt/s; X·t ysXmIaJljlO wbua,tgceh&eXsf".wevVPastryCrumbBloomRestored,
            pastryFlight: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4w.Z9a".wevVPastryCrumbBloomRestored,
            tastingNoteText: "(m3T1#2d prTeIvii:eowBsh)N".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "2W1P5e GGbo.l@dCexn# SL;afn@e.,* AS.a~nL sFdrxaOnLcyiQs.cKo*".wevVPastryCrumbBloomRestored,
            bakeryTags: [
                WevVWevvBakeryTag(donutPinKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, flavorFlight: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, tintHex: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "f%reeosJhsByaftlckhoT.aygV".wevVPastryCrumbBloomRestored, flavorFlight: "Fqrzems=hh".wevVPastryCrumbBloomRestored, tintHex: "fP5ebB4a3y1V".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "poozp!uwlIaJrJSeuCgJawrdT:aYgx".wevVPastryCrumbBloomRestored, flavorFlight: "PWoBpPuklJaqrV".wevVPastryCrumbBloomRestored, tintHex: "8Gba6k3=fFf%".wevVPastryCrumbBloomRestored)
            ],
            tastingParlorTitle: "GpoAlNdreTnW NDhoquogKh: ZR%oFoomF".wevVPastryCrumbBloomRestored,
            tastingParlorLine: "TXaolrk# oa?b,onuht@ EfRrdefsuhk Wb~aJtCc^h.e=sz,* ftWobpXp:iknCgosp,n la/n;dD Id.oJnruPtK opMaUifrtiXnIgtsl.U".wevVPastryCrumbBloomRestored,
            tastingTableText: "3&8T qoRnhleivnreg".wevVPastryCrumbBloomRestored,
            crumbTastings: goldenDoughAtelierNotes(),
            bakeryFinds: goldenDoughAtelierSelections()
        )
    }

    private func goldenDoughAtelierNotes() -> [WevVWevvCrumbTasting] {
        [
            WevVWevvCrumbTasting(sprinkleJarKey: "osl/iNv,iuaJGqoNlcdJeXnSF%r~aZmmee".wevVPastryCrumbBloomRestored, donutTasterName: "O=lFiavpipas".wevVPastryCrumbBloomRestored, flavorRole: "FPoEo@dI ~pfhjostwo/gAr/atpXhPearU".wevVPastryCrumbBloomRestored, crumbScoreNote: "5&.W0n".wevVPastryCrumbBloomRestored, biteNoteText: "EtvfekrDyY ddjofn@uptr Xl/o/o^kEe!dR qbhe#aZu?t#iYf,uKlm Xaxntd# LtZa;sOthewd* /eZvbeznx xbFe~tnt~e!rX.U".wevVPastryCrumbBloomRestored, donutBadgeText: "PYicc?tauJr:eU =Pie.rRfveFctti".wevVPastryCrumbBloomRestored),
            WevVWevvCrumbTasting(sprinkleJarKey: "nJovaBhADLozusgfh~TGerxEt/uMr,e!".wevVPastryCrumbBloomRestored, donutTasterName: "N^o*aXhI".wevVPastryCrumbBloomRestored, flavorRole: "DKoHnNuEt% JcBo.lXlheycotsoerY".wevVPastryCrumbBloomRestored, crumbScoreNote: "4c.Y8N".wevVPastryCrumbBloomRestored, biteNoteText: "TghZe? ndCozufgPh* xwEauss elBi:gVh?tR,, ;fqlHuBfCf+yQ,p laSnwdL CnueXvbeXrv ;tooXod &oaijl.yz..".wevVPastryCrumbBloomRestored, donutBadgeText: "BoeKsQt= *T.e%xitmuPrAex".wevVPastryCrumbBloomRestored)
        ]
    }

    private func goldenDoughAtelierSelections() -> [WevVWevvBakeryPick] {
        [
            WevVWevvBakeryPick(sugarDustKey: "pinkGlazePick", treatFlight: "Pink Glaze House", bakeryTrailLine: "128 Berry Street, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_berry_ring_bakery"),
            WevVWevvBakeryPick(sugarDustKey: "mellowDoughPick", treatFlight: "Mellow Dough", bakeryTrailLine: "212 Pine Ave, Oakland, CA", crumbScoreNote: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeMoonlightDonutCounterDetail(_ bakeryAtlas: WevVBakeryAtlas) -> WevVWevvBakeryDetail {
        WevVWevvBakeryDetail(
            donutPinKey: bakeryAtlas.donutPinKey,
            sprinkleFlight: "MxoLoInKlQiigChotI ;DPoon@uytR %BeaQr;".wevVPastryCrumbBloomRestored,
            crumbFlight: "L*aBtYeh-knNiHgJhVtV bdooXnmu:t=sU t·H ;cArIe=aotJiov:eG Fdvr%i.n^k^sh".wevVPastryCrumbBloomRestored,
            pastryFlight: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4W.w7N".wevVPastryCrumbBloomRestored,
            tastingNoteText: "(P2e0k4! rrve/v~iHe&wxsm)W".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "4t2& ECprFecs@c&ebn*t~ pS/t^rGeDeVth,M iS#aqni yF+rraunLczi?shcjoO".wevVPastryCrumbBloomRestored,
            bakeryTags: [
                WevVWevvBakeryTag(donutPinKey: "l%aWtWeqN:iLgQhdtlTcaNgA".wevVPastryCrumbBloomRestored, flavorFlight: "L%aptze: NN/isgshxtI".wevVPastryCrumbBloomRestored, tintHex: "8lbo6e3jfjfI".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "cGoofrfdeleBT+aMgK".wevVPastryCrumbBloomRestored, flavorFlight: "CAoNfifJereA".wevVPastryCrumbBloomRestored, tintHex: "7,b~4Db*2aal".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "cYrHeWaHtOivvkeIS;uFgCa=rxT*asgu".wevVPastryCrumbBloomRestored, flavorFlight: "C#rNeDajtLitvie~".wevVPastryCrumbBloomRestored, tintHex: "fIfJ4paua%0J".wevVPastryCrumbBloomRestored)
            ],
            tastingParlorTitle: "M=iCd!n?iWgDhbt* fDPoxn=u?th ST+aGl^kW".wevVPastryCrumbBloomRestored,
            tastingParlorLine: "AA Slkaft~eh-VnHi=gEhQtz Ur/oyoFmS KfWo&r^ ZdQo:nDuzty QfJabnYs. &agnbdA mc;oMfTfjeUe; rl:ozvSeer/sc.U".wevVPastryCrumbBloomRestored,
            tastingTableText: "3L1g *oZnZlyisnreI".wevVPastryCrumbBloomRestored,
            crumbTastings: moonlightDonutCounterNotes(),
            bakeryFinds: moonlightDonutCounterSelections()
        )
    }

    private func moonlightDonutCounterNotes() -> [WevVWevvCrumbTasting] {
        [
            WevVWevvCrumbTasting(sprinkleJarKey: "cYh+lQoneCNEi&gmhvtmC=aHfteW".wevVPastryCrumbBloomRestored, donutTasterName: "CJhJl.ooe+".wevVPastryCrumbBloomRestored, flavorRole: "NDiPgqhJtZ ycaa:fLef LfeamnI".wevVPastryCrumbBloomRestored, crumbScoreNote: "4y.f8@".wevVPastryCrumbBloomRestored, biteNoteText: "Thhzez xpHePrLfreTc;tc EpLldaocgeF BfFoHrH hav gsIw?eHectz al#aDtYeZ-jnoixgahYt. %cyotfFfteTeL aberfeiaCk+.R".wevVPastryCrumbBloomRestored, donutBadgeText: "NliygphktU OVUi,brePsl".wevVPastryCrumbBloomRestored),
            WevVWevvCrumbTasting(sprinkleJarKey: "lgiqaHm&CDoyfNf~e=eiWhasrcmatPh+".wevVPastryCrumbBloomRestored, donutTasterName: "Lzi&axmO".wevVPastryCrumbBloomRestored, flavorRole: "C:odf/fbeYeC YeBnItehruusViQawsDtV".wevVPastryCrumbBloomRestored, crumbScoreNote: "4~.S6z".wevVPastryCrumbBloomRestored, biteNoteText: "G&rqe#aitW yejsvpIr#ePsns=oI,Z qwfa/rmmX xdPosn#uatss.,E ?arnndn iaE Mr+eul;a*xMeHdH #awtcmko,s;pahKe~r%e@.U".wevVPastryCrumbBloomRestored, donutBadgeText: "CcotfcfoeWen CMqast+cShF".wevVPastryCrumbBloomRestored)
        ]
    }

    private func moonlightDonutCounterSelections() -> [WevVWevvBakeryPick] {
        [
            WevVWevvBakeryPick(sugarDustKey: "berryRingPick", treatFlight: "Berry Ring Bakery", bakeryTrailLine: "86 Blossom Avenue, San Francisco", crumbScoreNote: "4.8", coverAsset: "wevv_shop_berry_ring_bakery"),
            WevVWevvBakeryPick(sugarDustKey: "goldenDoughPick", treatFlight: "Golden Dough Studio", bakeryTrailLine: "215 Golden Lane, San Francisco", crumbScoreNote: "4.9", coverAsset: "wevv_shop_golden_dough_studio")
        ]
    }

    private func makeClassicGlazeParlorDetail(_ bakeryAtlas: WevVBakeryAtlas) -> WevVWevvBakeryDetail {
        return WevVWevvBakeryDetail(
            donutPinKey: bakeryAtlas.donutPinKey,
            sprinkleFlight: bakeryAtlas.donutPinKey == "sap%rUixnckjl*eBSRhUeBljf!".wevVPastryCrumbBloomRestored ? "Mellow Dough" : "Pxi;nDkl .Ggl+anzEeC dH,opuPsVe%".wevVPastryCrumbBloomRestored,
            crumbFlight: bakeryAtlas.flavorNoteLine,
            pastryFlight: bakeryAtlas.bakeryFrameAsset,
            crumbScoreNote: "4v.v9@".wevVPastryCrumbBloomRestored,
            tastingNoteText: "(#2M4n6P ?roeHvjiYe+wEs?)J".wevVPastryCrumbBloomRestored,
            bakeryTrailLine: "1W2X8~ .B.e*r.rwyX #SWtUrMebeyt/,o YSuahn* iFZrAaInMceif.U.D.P".wevVPastryCrumbBloomRestored,
            bakeryTags: [
                WevVWevvBakeryTag(donutPinKey: "bhe&rNrdywTeaFg^".wevVPastryCrumbBloomRestored, flavorFlight: "SWtHr/aDw/bJe@r^reyB".wevVPastryCrumbBloomRestored, tintHex: "fzfT4+a!a/0?".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, flavorFlight: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, tintHex: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                WevVWevvBakeryTag(donutPinKey: "lYaTt/eHTIaXgi".wevVPastryCrumbBloomRestored, flavorFlight: "LbaWthe+ qNuiAgShHto".wevVPastryCrumbBloomRestored, tintHex: "8lbp6H3uf?fx".wevVPastryCrumbBloomRestored)
            ],
            tastingParlorTitle: "DOobnFu^tm xL,oNvCerrjsQ ;RUoAokmN".wevVPastryCrumbBloomRestored,
            tastingParlorLine: "CDanfUeN ,sNo#f!t% yszh!osp^ EfVaen;sI,J XfIlGaEvjoEr! UtbaslckK,h +aonOdB /s,wte#e+tC ~pBiAc?kVsd".wevVPastryCrumbBloomRestored,
            tastingTableText: "2%8N =o!n/lQiLnyeA".wevVPastryCrumbBloomRestored,
            crumbTastings: [
                WevVWevvCrumbTasting(
                    sprinkleJarKey: "ahv~ajBdebrcrkyMBtiAtJey".wevVPastryCrumbBloomRestored,
                    donutTasterName: "Apvmav".wevVPastryCrumbBloomRestored,
                    flavorRole: "COaMfte@ Cegxhp.lEonr*e~rd".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4B.g8q".wevVPastryCrumbBloomRestored,
                    biteNoteText: "L;ohvoeSdv ZtXh=eZ es:t*r?abwLbWexrdrtyo XrWi!n~gk na@nUdl ytvhCe, ncao:zJyQ kp,innIk:.L.x.O".wevVPastryCrumbBloomRestored,
                    donutBadgeText: "Cguztce= WVuiObnePs;".wevVPastryCrumbBloomRestored
                ),
                WevVWevvCrumbTasting(
                    sprinkleJarKey: "jPa+sqo+nYCqlVaBsus%i^c!CCrauOmDbh".wevVPastryCrumbBloomRestored,
                    donutTasterName: "Jda.spoRn&".wevVPastryCrumbBloomRestored,
                    flavorRole: "DooSnNuhta Tc*oRl&lve+c/tGobrU".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4y.%6j".wevVPastryCrumbBloomRestored,
                    biteNoteText: "Tmhse@ KoHrQiLgkian%ael, qgvlValzHer wibss lbJultmt.e*rUy^ paJnGdv /fUlWunfUf,yO.; UFur;iyejnY.c.i.#".wevVPastryCrumbBloomRestored,
                    donutBadgeText: "BreLs%tk MCNlJarsLsui&cq".wevVPastryCrumbBloomRestored
                )
            ],
            bakeryFinds: [
                WevVWevvBakeryPick(
                    sugarDustKey: "cblpofu^dISVpvrliLnck^l,etPsiwc~kY".wevVPastryCrumbBloomRestored,
                    treatFlight: "CUlgo,uIds PS%p#rzi;nskIlne*".wevVPastryCrumbBloomRestored,
                    bakeryTrailLine: "4F5p rV?azlTepn;cpiOa. uSAt,,. ASHaInZ SF;roazn!cWiXsGc:og,C uCXAq".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4A.O6W".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_golden_dough_studio"
                ),
                WevVWevvBakeryPick(
                    sugarDustKey: "mneYlRlpoKw^DVo*ujgzhNPfinc/kA".wevVPastryCrumbBloomRestored,
                    treatFlight: "MLe@lOl?oOwJ kDhoRu%gMhs".wevVPastryCrumbBloomRestored,
                    bakeryTrailLine: "2H1E2g PP:iqnHek lAKvjeS,H ROoa=k;lSafnZdR,T :CgAm".wevVPastryCrumbBloomRestored,
                    crumbScoreNote: "4#.*8&".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_moonlight_donut_bar"
                )
            ]
        )
    }

    private func allBakeryAtlasDetails() -> [WevVWevvBakeryDetail] {
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
            let gate = WevVWevvBakeryGateController()
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
        if section == .donutDiary {
            refreshDonutDiaryPanel()
        }
        glazeHomePanels.forEach { $0.isHidden = !showHome }
        frostingDiaryPanels.forEach { $0.isHidden = section != .tastingJournal }
        tastingJournalPanel.isHidden = true
        flavorNoteEntryButton.isHidden = section != .tastingJournal
        donutDiaryPanel.isHidden = section != .donutDiary
        donutCounterGlazeSheen.isHidden = section != .donutCounter || didFinishDonutCounterGlazeSheen
        tastingJournalGlazeSheen.isHidden = section != .tastingJournal || didFinishTastingJournalGlazeSheen
        donutParlorFootTopConstraints.values.forEach { $0.isActive = false }
        donutParlorFootTopConstraints[section]?.isActive = true
        for (tabSection, icon) in donutParlorIcons {
            let tabAssets = donutParlorAssetTrail[tabSection]
            let asset = tabSection == section ? tabAssets?.active : tabAssets?.idle
            icon.image = UIImage(named: asset ?? "")
            icon.alpha = tabSection == section ? 1 : 0.5
            icon.transform = tabSection == section ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
        }
        if view.window != nil {
            revealInitialGlazeSheenIfNeeded(for: section)
        }
    }

    private func startBakeryAtlasTimer() {
        stopBakeryAtlasTimer()
        let timer = Timer(timeInterval: 1.5, target: self, selector: #selector(advanceBakeryAtlasCarousel), userInfo: nil, repeats: true)
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
        case .donutDiary:
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

extension WevVDonutcreamBadgeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === bakeryAtlasCarousel, bakeryAtlasCarousel.bounds.width > 0 else { return }
        let page = Int(round(bakeryAtlasCarousel.contentOffset.x / bakeryAtlasCarousel.bounds.width))
        bakeryAtlasDots.currentPage = max(0, min(bakeryAtlasItems.count - 1, page))
    }
}

private final class WevVGlazeSheenView: UIView {
    private let glazeSheenLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        glazeSheenLayer.colors = [
            UIColor.white.withAlphaComponent(0.14).cgColor,
            UIColor.white.withAlphaComponent(0.72).cgColor,
            UIColor.white.withAlphaComponent(0.14).cgColor
        ]
        glazeSheenLayer.locations = [0, 0.5, 1]
        glazeSheenLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glazeSheenLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(glazeSheenLayer)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        glazeSheenLayer.frame = bounds
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else {
            glazeSheenLayer.removeAllAnimations()
            return
        }
        beginGlazeSheen()
    }

    private func beginGlazeSheen() {
        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let crumbBloom = CABasicAnimation(keyPath: "locations")
        crumbBloom.fromValue = [-1.0, -0.5, 0.0]
        crumbBloom.toValue = [1.0, 1.5, 2.0]
        crumbBloom.duration = 1.1
        crumbBloom.repeatCount = .infinity
        glazeSheenLayer.add(crumbBloom, forKey: "glazeSheen")
    }
}
