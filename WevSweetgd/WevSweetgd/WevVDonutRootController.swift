import UIKit

private func makeRootGlazeShop(_ glazeKey: String, _ shopTitle: String, _ flavorLine: String, _ coverAsset: String) -> WevVGlazeShop {
    WevVGlazeShop(glazeKey: glazeKey, shopTitle: shopTitle, flavorLine: flavorLine, coverAsset: coverAsset)
}

private func makeRootDailyCheckin(_ doughRingKey: String, _ sugarTitle: String, _ crumbCaption: String, _ cardAsset: String) -> WevVDailyCheckin {
    WevVDailyCheckin(doughRingKey: doughRingKey, title: sugarTitle, caption: crumbCaption, cardAsset: cardAsset)
}

private func makeRootGlazeAuthor(_ glazeKey: String, _ name: String, _ donutAvatarAsset: String) -> WevVGlazeAuthor {
    WevVGlazeAuthor(glazeKey: glazeKey, name: name, donutAvatarAsset: donutAvatarAsset)
}

private func makeRootSprinkleMoment(_ sprinkleKey: String, author: WevVGlazeAuthor, heroAsset: String, displayText: String, isSprinkled: Bool, isSaved: Bool, frostingTimeText: String) -> WevVSprinkleFeedItem {
    WevVSprinkleFeedItem(sprinkleKey: sprinkleKey, author: author, heroAsset: heroAsset, displayText: displayText, isSprinkled: isSprinkled, isSaved: isSaved, frostingTimeText: frostingTimeText)
}

private func makeRootSugarPost(_ sugarKey: String, _ sugarTitle: String, _ crumbNote: String) -> WevVSugarPost {
    WevVSugarPost(sugarKey: sugarKey, title: sugarTitle, note: crumbNote)
}

final class WevVDonutRootController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let shopCarousel = UIScrollView()
    private let shopPages = UIStackView()
    private let shopDots = UIPageControl()
    private let challengeStrip = UIScrollView()
    private let challengeRow = UIStackView()
    private let momentStack = UIStackView()
    private let frostingDiaryPanel = UIView()
    private let didonutWevvPanel = UIView()
    private let frostingPostEntryButton = UIButton(type: .custom)
    private let sugarProfilePanel = UIView()
    private let profileNameLabel = UILabel()
    private let profileFollowingCountLabel = UILabel()
    private let profileFollowerCountLabel = UILabel()
    private let profileShelfCountLabel = UILabel()
    private let profileVaultCountLabel = UILabel()
    private let profilePostStack = UIStackView()
    private let profileEmptyStack = UIStackView()
    private weak var profileAvatarImageView: UIImageView?
    private let donutTabBack = UIView()
    private let donutContentFoot = UIView()
    private var glazeCarouselTimer: Timer?
    private var didShowBakeryExchange = false
    private var donutTabIcons: [WevVDonutMainSection: UIImageView] = [:]
    private var donutContentFootTopConstraints: [WevVDonutMainSection: NSLayoutConstraint] = [:]
    private var glazeHomePanels: [UIView] = []
    private var frostingDiaryPanels: [UIView] = []
    private var activeDonutSection = WevVDonutMainSection.glazeHome

    private let donutTabAssetTrail: [WevVDonutMainSection: (idle: String, active: String)] = [
        .glazeHome: ("wevv_tab_home_glaze_idle", "wevv_tab_home_glaze_active"),
        .frostingDiary: ("wevv_tab_discover_sprinkle_idle", "wevv_tab_discover_sprinkle_active"),
        .sugarProfile: ("wevv_tab_profile_donut_idle", "wevv_tab_profile_donut_active")
    ]

    private let glazeShops: [WevVGlazeShop] = [
        makeRootGlazeShop("b,eMr~r:y+R:iunlgRBYaRkueFrYyc".wevVPastryCrumbBloomRestored, "BdeUrAr?ym HR~i#n*gd pBFaSkHe!r,yV".wevVPastryCrumbBloomRestored, "Fzrie~sHh: TdzofnSuDtssL c·e Rb;e^ror+yr of&lja#vIokrHsH".wevVPastryCrumbBloomRestored, "wevv_shop_berry_ring_bakery"),
        makeRootGlazeShop("g%o%lZdje:nPDSohuugZhGS;tmuKd+izoP".wevVPastryCrumbBloomRestored, "GnoBlsdueHn; TDWouuog%hr USktCuxdJiQoP".wevVPastryCrumbBloomRestored, "ACr,tlibsWawnA uduo/nluTt=sW g·S esomiazl*l+ jbEastccyhmels:".wevVPastryCrumbBloomRestored, "wevv_shop_golden_dough_studio"),
        makeRootGlazeShop("mMoFoLnhl:ixgWhEtND.oAn^u!tjB;alrm".wevVPastryCrumbBloomRestored, "MIoXoVnMlRijghhDt+ tDgoLn^uItj yB%alrh".wevVPastryCrumbBloomRestored, "L=aetfe&-ynViygSh&td Hdto,nLuItds! S·X kc;rueRa:t&iMvRei CdWrFiFnKkcsE".wevVPastryCrumbBloomRestored, "wevv_shop_moonlight_donut_bar")
    ]

    private let dailyCheckin = makeRootDailyCheckin("dvaAiwl.yIDXo:nYuit.Sot/aqm.p/".wevVPastryCrumbBloomRestored, "DMaSicl;yK".wevVPastryCrumbBloomRestored, "Cihkeic=kq-;imn,".wevVPastryCrumbBloomRestored, "wevv_checkin_donut_daily_card")

    private var sprinkleChallenges: [WevVSprinkleChallenge] = [
        WevVSprinkleChallenge(
            sprinkleKey: "sBtGrzaswsbieMrsrUywWWelerk;".wevVPastryCrumbBloomRestored,
            title: "Snt:rxa%wbbne+r:rNyt hWYeleYkE".wevVPastryCrumbBloomRestored,
            caption: "TcrKyA MaC cmKyvsatHe*r*y+ pdIoNn&uZtU oawnxdt mg;uAeasqsE KtAhtev mfplqauvToMrx.?".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_strawberry_week",
            joinedText: "JRoGi@nw".wevVPastryCrumbBloomRestored,
            glazeLine: "C:ogm/ppljePtneE qtJopd,a#yo'MsY wtsadsrt;irnfg% Rt@aQskk# XaFn+d# Aswh?aPrGek !aS FbceOrbrPy? +neo&t;eN.o".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "FkrUi=deajyP j·I ~8s:I0+0D bP!Me K-T u1M0!:h3~0P yPgMw".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "B~earkrmyw WRcivnSgN OBcaYkbe^rfyx,n BSkaYnW qFxria/n&cLi*sGc*oZ".wevVPastryCrumbBloomRestored,
            hostGuestKey: "joabmmite#Ciotl?eF".wevVPastryCrumbBloomRestored,
            hostLine: "Vhe?r,i@fJi?e^dR ,hkoms;tk +·q d4b.P9= WrHaIt~iBnGg+".wevVPastryCrumbBloomRestored,
            missionText: "TsaAsUtLeG /a# HsqtIrwaLwpbiegr;rGyF ^rDi;nWgu,; @npa~mve& ptzhae. yh:iodVdqeCng RfqiCltlti^nYgI,B TaGnRdl .pzoas!t, ~yloru^rL SsTw/e;eUtkeLs:t^ qful?atvroprK @cMl:u=eE.k".wevVPastryCrumbBloomRestored,
            crowdText: "2x3K MpOezoepPlXe!".wevVPastryCrumbBloomRestored,
            sugarCost: 300
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "pkinnAkmDooqnOuWtJD:aNyh".wevVPastryCrumbBloomRestored,
            title: "PCiDnDk= eD:oznnu^tP +Dya%yB".wevVPastryCrumbBloomRestored,
            caption: "Sxh^ayrEe% Eab mpeianJkU #dvounYuftL ~aan:d& ncWr/eKartyeJ uyJoHumrT Lsgwte^eStWetsutA cpahKoztao^.M".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_pink_donut_day",
            joinedText: "JMo@ianN".wevVPastryCrumbBloomRestored,
            glazeLine: "BguniJlfd+ UaD qb?rviBgehBtG !psi.nvkM wdQoVnIuLtp up;hMoat&oS #s#eutH %fto#rY HtAh,e? DdpaVy#.A".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "S=a?tiu^rgdma!yR E·p ;2=:N0H0Z LPuMu v-? #5T:&0n0@ qPEM!".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "GqoGlxdEeTnc cD,oQuBg+hg &SgtEu!dii;o#,F lSmafnn /Fcrba;nscGimsOcEoD".wevVPastryCrumbBloomRestored,
            hostGuestKey: "rQhfeJaQHVoCneeuyOGilpamz,eE".wevVPastryCrumbBloomRestored,
            hostLine: "P:h!o&tMoc NhioIsSt/ R·= x4o.C8x rrZaMtNiGnxge".wevVPastryCrumbBloomRestored,
            missionText: "Cua;p%t.ulr!ek BaB SpeiTnvkS zdioAntu*t* am/oOmie!nGtR bw?int~hE YoDn?eg ?s&hWo.rMtj ntfapsQtni@nfgB SnToBtEes pa:nWdA Sa? cp:lia+yIfxuolo ytDo^p?pDipnPgK SiPd&e;ah.F".wevVPastryCrumbBloomRestored,
            crowdText: "3h1s DpWe/oOpAlme;".wevVPastryCrumbBloomRestored,
            sugarCost: 260
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "dOoNnCu,tLCPoafBfAeie!MWaht:cfhB".wevVPastryCrumbBloomRestored,
            title: "DdoHn.uUtB I&l PCio^f~fLeEeg SM^awt;cGhw".wevVPastryCrumbBloomRestored,
            caption: "Pcapi:rY ;ymohuJrd HfEa@vVoOr=iat,e+ EdIoDn*uTt+ mw&iCt+hq St@hTeG fpZenrJfFe/catF Hcoo%fEfte:ej.c".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_donut_coffee_match",
            joinedText: "JIoaiInc".wevVPastryCrumbBloomRestored,
            glazeLine: "FUibn:db aaK jdDognvuWtq &p#a.i%rUiwn/gA EtJh?afth GmZa.kKehs. NcPo!fefleVeZ Pt!aas@t*et gbkeUtltlezrS.y".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "S;uen#d#akya j·~ j1.0,:j3b0k ~ARMR !-u P1@2g:&0l0J ^PNM#".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "McogoMn:lviDg~hStg RDKotnZuLtk NBra%rh,~ hSRaLnd ?FGrmafnccfiTs~c.oZ".wevVPastryCrumbBloomRestored,
            hostGuestKey: "aWr;l!ocSKkNyjGNlFaaz@et".wevVPastryCrumbBloomRestored,
            hostLine: "PraviorXiYnkgs shlo#sotV s·U Y4G.i7/ lrqartJi~nQgS".wevVPastryCrumbBloomRestored,
            missionText: "P~imc*k. *an udToBnsuWtB EasnIdn laD icHoIfafIeRea &sntzydl?e/,z ct;hPeanU yeNxBpmlnani;nx Mwnh?yZ otqhSe~ /fnrxo?sNtRinn#gw DaGnmd% ^rNoGagsHtV swTopr@kO QtEoTgue=tQhNeIrt.k".wevVPastryCrumbBloomRestored,
            crowdText: "2Q8m Mp:ePoypKl,eJ".wevVPastryCrumbBloomRestored,
            sugarCost: 280
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "fGi*rys!tPB@iDtjemRCeJaCc:tpiso;nX".wevVPastryCrumbBloomRestored,
            title: "FXiHrfsTte qBIiCtQeU @Rze~aDctt,igo+n,".wevVPastryCrumbBloomRestored,
            caption: "C~aDpvttu~r.ek Eyco~uprD qrBezaglS erQe;arcptxiAoHn% aaDf+t+edr= Htqh,eI IfHiVrosRtq vb,ibtUed.@".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_first_bite_reaction",
            joinedText: "JcodiDnz".wevVPastryCrumbBloomRestored,
            glazeLine: "S=haoCwF ~tjhPeQ EfTiOr?s=tC Jb~iHtkeY nfeacc#eD ;tbh?aZtA psRaJyjsm bedvVe!rmyXt@haiSnkgl.U".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "M&o%npdEaSy? T·z y6o:!3d0: +PMMU S-H :8P:C0k0M tPNMM".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "PWi.nrkW aGglxa=zweC dHdoIuEsneg,: vSjaJnh TFgr=a+n:cLiqsIckoA".wevVPastryCrumbBloomRestored,
            hostGuestKey: "nvoBvEa^B?ubbpbbl=ehGRl=a=z#eC".wevVPastryCrumbBloomRestored,
            hostLine: "TaaxsWtqi^nSgL Phoo#sitj P·; .4h.a8e yrxa:tKiPn?gB".wevVPastryCrumbBloomRestored,
            missionText: "T?apkXep roRn&en abnibtceO,/ Aw!r;iwtSeP jtmhkeO bfaimrNsNt. htEh%rzerek mf*lnaovZo^rx !wqomr:d?sX,a ;a~n:d, =kPeuePp^ ;tChUef ?r*e,ancAt;iGornk Bn/aftvuuroahlZ.R".wevVPastryCrumbBloomRestored,
            crowdText: "1i9f dpJe^oPpLlBeD".wevVPastryCrumbBloomRestored,
            sugarCost: 240
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "dMoTnluzt*OIfpTrhAe&D:aVyA".wevVPastryCrumbBloomRestored,
            title: "DwoLn/umt~ SoGfE %tvhOen %D&agyt".wevVPastryCrumbBloomRestored,
            caption: "PHoIsetu TtHo^dha@y:'TsS .dOoVnUudtj +avn/dM PtPeOlZlj ceav%eSrAyJoenCes qwzhyys Vy@oRup fcYhBocsAeH viptM.h".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_donut_of_day",
            joinedText: "J;ogiNn!".wevVPastryCrumbBloomRestored,
            glazeLine: "C*h&oLohslez DtNhCek Ao?nNeN GdjornKuptN ?tphaaDt@ cd@evsdevrRvEe&sh VtuocdJafyl'nsM is:pCoktklei:gOhJt~.s".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "WjegdhnLeuscdRacy! @·A m1D:j0F0K DPxMy f-Y V4e:q0&0Y /PYMq".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "CllXoluldz hSJpJrvijn#kwl#ew,j PSbaEn^ lFWrqaDnrc%iQsecrou".wevVPastryCrumbBloomRestored,
            hostGuestKey: "lYu:nuaMLFagu~g&hNG=l&aBzje;".wevVPastryCrumbBloomRestored,
            hostLine: "D%aciVl,yC /h@oAsBth P·S Z4Q..9Z vr+artkiin,g~".wevVPastryCrumbBloomRestored,
            missionText: "POiecpkU ,yto%u^rH RdSo=nourtx %o=fL stqh&eI BdnaTy@,f Ua&dQdk :o:nteT CrHekaSs^ofn,,L LapnPdz =iUn*v%iJtXeM ~oJtuhyeMry otGaesgtpeArtsR ZtUoY ^c^oPmGpKakrge~ NcohPoIitc*ers#.Q".wevVPastryCrumbBloomRestored,
            crowdText: "3J6T /pTeWonpHl/eq".wevVPastryCrumbBloomRestored,
            sugarCost: 220
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "sPpArRi~ngkvlJeeSLtbylluej".wevVPastryCrumbBloomRestored,
            title: "S?pUrciMnrkIlaeP =SetByGlweR".wevVPastryCrumbBloomRestored,
            caption: "DMe?c,ohr=a.tieQ VaI ydAoFn,udtL swBi;tUhs ;yrojuJrO ufDakv:odrUict@e? Pc,o/l:oirWfVu%l# Fsxp,rFirngkVlXeas^.F".wevVPastryCrumbBloomRestored,
            cardAsset: "wevv_challenge_sprinkle_style",
            joinedText: "JXoSiTng".wevVPastryCrumbBloomRestored,
            glazeLine: "Twu%r%nc At!o~pxp,iDnNg+s: =iBn~t,of Uay wtyizn%yM ;d.o*nkuFt% mf!aBschAivoPnK rs:hBoHwC.u".wevVPastryCrumbBloomRestored,
            sprinkleTimeText: "TPhMu#rCs:deawyT f·q o7q:s0p0= MPPMP g-D w9N:A0v0S .PJMV".wevVPastryCrumbBloomRestored,
            crumbPlaceText: "MZe.lalzokwZ ODno+ukgZhV,M OObaIk#lCaNn/da".wevVPastryCrumbBloomRestored,
            hostGuestKey: "bvlDaKi/rHBjlUu,e&GSlHaxzCet".wevVPastryCrumbBloomRestored,
            hostLine: "SOt+ygl,eh xhpoaskt= ?·F /4m.V6S PrMaKtdiLntg&".wevVPastryCrumbBloomRestored,
            missionText: "DTedsTi?gcnf nam msip+r=isnzkyljeo QlzoYoQk*,j odgeysSc#rIi.bme. Btwh+ey jcxoel:oArY Um@iKxc,+ ia!n^dQ ~vkocteet ffgoMrI HtQhDeX OshwaedeDtqeqs;tQ !sStxy%lOe+ #iWdSeLa;.A".wevVPastryCrumbBloomRestored,
            crowdText: "2t4y hp&etoJpcleeC".wevVPastryCrumbBloomRestored,
            sugarCost: 250
        )
    ]

    private var sprinkleMoments: [WevVSprinkleFeedItem] = [
        makeRootSprinkleMoment(
            "o=nFeuBmiQtwe~VViHb;e/sf".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("lAoKuoipspepSMa@nvtko#sq".wevVPastryCrumbBloomRestored, "LeoTujiQsUez #Spatnet^oNss".wevVPastryCrumbBloomRestored, "louiseCream"),
            heroAsset: "wevv_moment_one_bite_vibes",
            displayText: "OlnzeJ =bxiFtieM,@ paw Kw^h;ofl&eT %ddamyN aocf! cg=oBoAdz ,vbiWb#e#sE".wevVPastryCrumbBloomRestored,
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "BBeTrkrsy; tnxo=tgec".wevVPastryCrumbBloomRestored
        ),
        makeRootSprinkleMoment(
            "fBrYevsihvDroFnFu:tSSccwern,tu".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("m.aAssoFnPGHlxagz!e!SRm?iNldek".wevVPastryCrumbBloomRestored, "M/aCsyoBnj fC.oclXes".wevVPastryCrumbBloomRestored, "masonSugar"),
            heroAsset: "wevv_moment_fresh_donut_scent",
            displayText: "F@rkexsoh^ gdPo~n?uztssB wsgmEevlWl= raJm%aWzlisndgE.S".wevVPastryCrumbBloomRestored,
            isSprinkled: true,
            isSaved: false,
            frostingTimeText: "Fsrferschd @boaotqcUhn".wevVPastryCrumbBloomRestored
        ),
        makeRootSprinkleMoment(
            "c~hRohcaoQlnaYtkerDPoRn.uvtRD!aHym".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("aZvmaBCyopc!oPaXR,iSn,g/".wevVPastryCrumbBloomRestored, "AIvraQ BBHrHoYwqnS".wevVPastryCrumbBloomRestored, "avaCocoa"),
            heroAsset: "wevv_moment_chocolate_donut_day",
            displayText: "CQhjo!cyoFlsastfeF .d;ounauNtQsA ^mRaBdsew CmEyT Gdzagyt.f".wevVPastryCrumbBloomRestored,
            isSprinkled: false,
            isSaved: true,
            frostingTimeText: "Cmo?c;ora: RmZo=oLdC".wevVPastryCrumbBloomRestored
        ),
        makeRootSprinkleMoment(
            "wge:e,kYe%nJd.DtoenTuTtFSYt;aCrxtw".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("bFeilhlGarSlporvi~nUk+ller".wevVPastryCrumbBloomRestored, "BKeXlElvaR ZHla=r&tJ".wevVPastryCrumbBloomRestored, "bellaCream"),
            heroAsset: "wevv_moment_weekend_donut_start",
            displayText: "S^ttatretdi~nYgh ~tqhAeD ZwPeCeKkfeLnpdG mwqiXtoho .dPoSnEuet+sA.q".wevVPastryCrumbBloomRestored,
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "Wre?eUk:eUnwd% jpQi~cAkC".wevVPastryCrumbBloomRestored
        ),
        makeRootSprinkleMoment(
            "p=i.nTk/S.w@eneVtGnDeEskstTUowdPasyQ".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("mpiNauPZifn.kfS!ujgVagr@".wevVPastryCrumbBloomRestored, "MKiuaM !Rce;eddq".wevVPastryCrumbBloomRestored, "miaPink"),
            heroAsset: "wevv_moment_pink_sweetness",
            displayText: "Ai hl:iJtrtdl#e! QpoiEnmk= csIw%exeStjn;ewsyst JtSoYdiaQyc.T".wevVPastryCrumbBloomRestored,
            isSprinkled: true,
            isSaved: true,
            frostingTimeText: "P%ignlkX EsepprfiunGkzlaee".wevVPastryCrumbBloomRestored
        ),
        makeRootSprinkleMoment(
            "cYrneKaEmrF.i,lNleeWdwUYn.iKtje%".wevVPastryCrumbBloomRestored,
            author: makeRootGlazeAuthor("nfoCrvaBC,rBeSaKmgR#i?nngx".wevVPastryCrumbBloomRestored, "NroErbaC uL~abnCeI".wevVPastryCrumbBloomRestored, "noraCream"),
            heroAsset: "wevv_moment_cream_filled_unite",
            displayText: "C@rNePaumW-#fki,l^lIeKde CdVoon=uUtW ;lPoav#e,rYsm,K Ku=nMitt!ee.n".wevVPastryCrumbBloomRestored,
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "C&r=eVaSmB ,cViarpcYlXez".wevVPastryCrumbBloomRestored
        )
    ]

    private let defaultCreamRingTaster = WevVCreamRingTaster(
        doughRingKey: "wpeCvavbS@ulgTaJrUTOalsutaepr&".wevVPastryCrumbBloomRestored,
        email: "wHeRvcvh@rgamoaHiLls.gcSoom?".wevVPastryCrumbBloomRestored,
        glazeNickname: "GelLaLzYe: oTnausstKemrm".wevVPastryCrumbBloomRestored,
        donutAvatarAsset: "wevv_profile_avatar_piano_donut",
        creamStats: WevVCreamStat(glazeFollowCount: 12, sprinkleFanCount: 28, bakeryShelfCount: 7, vaultCount: 360),
        sugarNotes: [
            makeRootSugarPost("s^t;rJa:w?bdeqr#r;yhR,ienJgYNSoatxeB".wevVPastryCrumbBloomRestored, "S!tRrTatwNbne,rkrIyB dgClta%zhe+ qmioPr,n,ivndgH".wevVPastryCrumbBloomRestored, "S@oefLtg SfLrSolsctNiBnQg%,Y .w=aurzmm #c+rBuOmYbb,C NblrBiGgShAt@ nsSurgra/rn.J".wevVPastryCrumbBloomRestored),
            makeRootSugarPost("cvo?cioyakSDpkrHi/nIk!l&eMTFr=aui=lB".wevVPastryCrumbBloomRestored, "Cxo,cOoOaD Kstpkr#iznDk&lfe^ dtRaEsHtgiRn/gu".wevVPastryCrumbBloomRestored, "SpaJv!ead& saP XsfmyaOlvle KsxhNohpv wwMo^rMtChN dcoo?mfiHnSgT sb%a?cZkQ ttUoq.q".wevVPastryCrumbBloomRestored)
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        preloadSugarMoments()
        preloadSprinkleQuests()
        buildDonutBackdrop()
        buildGlazeScroll()
        buildTopGlazeBar()
        buildShopAndCheckinBand()
        builddonutWevvChallengeBand()
        builddonutWevvgDiaryDiscoverPanel()
        buildFrostingDiaryPanel()
        buildSugarProfilePanel()
        buildDonutContentFoot()
        buildDonutTabBar()
        buildFrostingPostEntryButton()
        switchDonutSection(.glazeHome)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGlazeCarouselTimer()
        showInitialBakeryExchangeIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGlazeCarouselTimer()
    }

    deinit {
        stopGlazeCarouselTimer()
    }

    private func buildDonutBackdrop() {
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

    private func buildGlazeScroll() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.showsVerticalScrollIndicator = false
        frostingScroll.contentInsetAdjustmentBehavior = .never
        frostingScroll.contentInset.bottom = 110
        frostingScroll.verticalScrollIndicatorInsets.bottom = 110
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

    private func buildTopGlazeBar() {
        let logodonutWevvButton = makeImageButton(asset: "wevv_home_wevv_glaze_logo", action: #selector(openGlazeNoticeList))
        let noticedonutWevvButton = makeImageButton(asset: "wevv_top_sprinkle_inbox_entry", action: #selector(openGlazeNoticeList))

        sprinkleContent.addSubview(logodonutWevvButton)
        sprinkleContent.addSubview(noticedonutWevvButton)
        glazeHomePanels.append(contentsOf: [logodonutWevvButton, noticedonutWevvButton])

        NSLayoutConstraint.activate([
            logodonutWevvButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 26),
            logodonutWevvButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            logodonutWevvButton.widthAnchor.constraint(equalToConstant: 101),
            logodonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticedonutWevvButton.centerYAnchor.constraint(equalTo: logodonutWevvButton.centerYAnchor),
            noticedonutWevvButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            noticedonutWevvButton.widthAnchor.constraint(equalToConstant: 44),
            noticedonutWevvButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildShopAndCheckinBand() {
        shopCarousel.translatesAutoresizingMaskIntoConstraints = false
        shopCarousel.isPagingEnabled = true
        shopCarousel.showsHorizontalScrollIndicator = false
        shopCarousel.delegate = self
        sprinkleContent.addSubview(shopCarousel)

        shopPages.translatesAutoresizingMaskIntoConstraints = false
        shopPages.axis = .horizontal
        shopPages.spacing = 0
        shopCarousel.addSubview(shopPages)

        for glazeShop in glazeShops {
            let pastryCard = makeShopCard(glazeShop)
            shopPages.addArrangedSubview(pastryCard)
            pastryCard.widthAnchor.constraint(equalTo: shopCarousel.frameLayoutGuide.widthAnchor).isActive = true
        }

        shopDots.translatesAutoresizingMaskIntoConstraints = false
        shopDots.numberOfPages = glazeShops.count
        shopDots.currentPage = 0
        shopDots.currentPageIndicatorTintColor = .white
        shopDots.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.55)
        sprinkleContent.addSubview(shopDots)

        let checkinButton = makeCheckinButton(dailyCheckin)
        sprinkleContent.addSubview(checkinButton)
        glazeHomePanels.append(contentsOf: [shopCarousel, shopDots, checkinButton])

        let shopWidth = min(UIScreen.main.bounds.width * 0.55, 206)
//        let checkinWidth = min(UIScreen.main.bounds.width * 0.34, 124)

        NSLayoutConstraint.activate([
            shopCarousel.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 96),
            shopCarousel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            shopCarousel.widthAnchor.constraint(equalToConstant: shopWidth),
            shopCarousel.heightAnchor.constraint(equalTo: shopCarousel.widthAnchor, multiplier: 265.0 / 206.0),
            shopPages.topAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.topAnchor),
            shopPages.leadingAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.leadingAnchor),
            shopPages.trailingAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.trailingAnchor),
            shopPages.bottomAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.bottomAnchor),
            shopPages.heightAnchor.constraint(equalTo: shopCarousel.frameLayoutGuide.heightAnchor),
            shopDots.centerXAnchor.constraint(equalTo: shopCarousel.centerXAnchor),
            shopDots.bottomAnchor.constraint(equalTo: shopCarousel.bottomAnchor, constant: -12),
            checkinButton.topAnchor.constraint(equalTo: shopCarousel.topAnchor),
            checkinButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            checkinButton.leadingAnchor.constraint(equalTo: shopCarousel.trailingAnchor, constant: 15),
            checkinButton.heightAnchor.constraint(equalTo: shopCarousel.heightAnchor)
        ])
    }

    private func builddonutWevvChallengeBand() {
        let titledonutWevvImage = UIImageView(image: UIImage(named: "wevv_challenge_recommend_title"))
        titledonutWevvImage.translatesAutoresizingMaskIntoConstraints = false
        titledonutWevvImage.contentMode = .scaleAspectFit
        sprinkleContent.addSubview(titledonutWevvImage)

        let postdonutWevvButton = UIButton(type: .system)
        postdonutWevvButton.translatesAutoresizingMaskIntoConstraints = false
        postdonutWevvButton.setTitle("PBojsvtP".wevVPastryCrumbBloomRestored, for: .normal)
        postdonutWevvButton.setTitleColor(.white, for: .normal)
        postdonutWevvButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        postdonutWevvButton.backgroundColor = .black
        postdonutWevvButton.layer.cornerRadius = 14
        postdonutWevvButton.addTarget(self, action: #selector(openSprinkleQuestComposer), for: .touchUpInside)
        sprinkleContent.addSubview(postdonutWevvButton)

        challengeStrip.translatesAutoresizingMaskIntoConstraints = false
        challengeStrip.showsHorizontalScrollIndicator = false
        sprinkleContent.addSubview(challengeStrip)
        glazeHomePanels.append(contentsOf: [titledonutWevvImage, postdonutWevvButton, challengeStrip])

        challengeRow.translatesAutoresizingMaskIntoConstraints = false
        challengeRow.axis = .horizontal
        challengeRow.spacing = 10
        challengeStrip.addSubview(challengeRow)

        rebuildSprinkleQuestRow()

        NSLayoutConstraint.activate([
            titledonutWevvImage.topAnchor.constraint(equalTo: shopCarousel.bottomAnchor, constant: 24),
            titledonutWevvImage.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            titledonutWevvImage.widthAnchor.constraint(equalToConstant: 212),
            titledonutWevvImage.heightAnchor.constraint(equalToConstant: 24),
            postdonutWevvButton.centerYAnchor.constraint(equalTo: titledonutWevvImage.centerYAnchor),
            postdonutWevvButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            postdonutWevvButton.widthAnchor.constraint(equalToConstant: 62),
            postdonutWevvButton.heightAnchor.constraint(equalToConstant: 28),
            challengeStrip.topAnchor.constraint(equalTo: titledonutWevvImage.bottomAnchor, constant: 28),
            challengeStrip.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            challengeStrip.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            challengeStrip.heightAnchor.constraint(equalToConstant: 250),
            challengeRow.topAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.topAnchor),
            challengeRow.leadingAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.leadingAnchor, constant: 14),
            challengeRow.trailingAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.trailingAnchor, constant: -14),
            challengeRow.bottomAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.bottomAnchor),
            challengeRow.heightAnchor.constraint(equalTo: challengeStrip.frameLayoutGuide.heightAnchor)
        ])
    }

    private func builddonutWevvgDiaryDiscoverPanel() {
        didonutWevvPanel.translatesAutoresizingMaskIntoConstraints = false
        didonutWevvPanel.isHidden = true
        sprinkleContent.addSubview(didonutWevvPanel)

        let exploredonutWevvButton = makeImageButton(asset: "wevv_discover_explore_logo", action: #selector(openGlazeNoticeList))
        let noticeButton = makeImageButton(asset: "wevv_discover_notice_entry", action: #selector(openGlazeNoticeList))
        let featuredTitle = UIImageView(image: UIImage(named: "wevv_discover_featured_title"))
        featuredTitle.translatesAutoresizingMaskIntoConstraints = false
        featuredTitle.contentMode = .scaleAspectFit

        momentStack.translatesAutoresizingMaskIntoConstraints = false
        momentStack.axis = .vertical
        momentStack.spacing = 10

        rebuildSprinkleMomentStack()

        didonutWevvPanel.addSubview(exploredonutWevvButton)
        didonutWevvPanel.addSubview(noticeButton)
        didonutWevvPanel.addSubview(featuredTitle)
        didonutWevvPanel.addSubview(momentStack)
        frostingDiaryPanels.append(didonutWevvPanel)

        NSLayoutConstraint.activate([
            didonutWevvPanel.topAnchor.constraint(equalTo: sprinkleContent.topAnchor),
            didonutWevvPanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            didonutWevvPanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            exploredonutWevvButton.topAnchor.constraint(equalTo: didonutWevvPanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            exploredonutWevvButton.leadingAnchor.constraint(equalTo: didonutWevvPanel.leadingAnchor, constant: 15),
            exploredonutWevvButton.widthAnchor.constraint(equalToConstant: 125),
            exploredonutWevvButton.heightAnchor.constraint(equalToConstant: 30),
            noticeButton.centerYAnchor.constraint(equalTo: exploredonutWevvButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: didonutWevvPanel.trailingAnchor, constant: -15),
            noticeButton.widthAnchor.constraint(equalToConstant: 44),
            noticeButton.heightAnchor.constraint(equalToConstant: 44),
            featuredTitle.topAnchor.constraint(equalTo: exploredonutWevvButton.bottomAnchor, constant: 26),
            featuredTitle.leadingAnchor.constraint(equalTo: didonutWevvPanel.leadingAnchor, constant: 15),
            featuredTitle.widthAnchor.constraint(equalToConstant: 105),
            featuredTitle.heightAnchor.constraint(equalToConstant: 24),
            momentStack.topAnchor.constraint(equalTo: featuredTitle.bottomAnchor, constant: 16),
            momentStack.leadingAnchor.constraint(equalTo: didonutWevvPanel.leadingAnchor, constant: 15),
            momentStack.trailingAnchor.constraint(equalTo: didonutWevvPanel.trailingAnchor, constant: -15),
            momentStack.bottomAnchor.constraint(equalTo: didonutWevvPanel.bottomAnchor)
        ])
    }

    private func buildDonutTabBar() {
        donutTabBack.translatesAutoresizingMaskIntoConstraints = false
        donutTabBack.backgroundColor = UIColor(red: 0.13, green: 0.0, blue: 0.27, alpha: 1)
        donutTabBack.layer.cornerRadius = 18
        donutTabBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(donutTabBack)

        let donutRow = UIStackView(arrangedSubviews: [
            makeTabButton(section: .glazeHome, asset: "wevv_tab_home_glaze_active"),
            makeTabButton(section: .frostingDiary, asset: "wevv_tab_discover_sprinkle_idle"),
            makeTabButton(section: .sugarProfile, asset: "wevv_tab_profile_donut_idle")
        ])
        donutRow.translatesAutoresizingMaskIntoConstraints = false
        donutRow.axis = .horizontal
        donutRow.distribution = .equalSpacing
        donutTabBack.addSubview(donutRow)

        NSLayoutConstraint.activate([
            donutTabBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            donutTabBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            donutTabBack.heightAnchor.constraint(equalToConstant: 88),
            donutTabBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            donutRow.topAnchor.constraint(equalTo: donutTabBack.topAnchor, constant: 20),
            donutRow.leadingAnchor.constraint(equalTo: donutTabBack.leadingAnchor, constant: 50),
            donutRow.trailingAnchor.constraint(equalTo: donutTabBack.trailingAnchor, constant: -50),
            donutRow.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildFrostingPostEntryButton() {
        frostingPostEntryButton.translatesAutoresizingMaskIntoConstraints = false
        frostingPostEntryButton.setImage(UIImage(named: "wevv_discover_post_frosting_entry"), for: .normal)
        frostingPostEntryButton.imageView?.contentMode = .scaleAspectFit
        frostingPostEntryButton.addTarget(self, action: #selector(openSugarMomentComposer), for: .touchUpInside)
        frostingPostEntryButton.isHidden = true
        view.addSubview(frostingPostEntryButton)

        NSLayoutConstraint.activate([
            frostingPostEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            frostingPostEntryButton.bottomAnchor.constraint(equalTo: donutTabBack.topAnchor, constant: -54),
            frostingPostEntryButton.widthAnchor.constraint(equalToConstant: 62),
            frostingPostEntryButton.heightAnchor.constraint(equalToConstant: 62)
        ])
    }

    private func buildDonutContentFoot() {
        donutContentFoot.translatesAutoresizingMaskIntoConstraints = false
        donutContentFoot.isHidden = true
        sprinkleContent.addSubview(donutContentFoot)

        NSLayoutConstraint.activate([
            donutContentFoot.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            donutContentFoot.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            donutContentFoot.heightAnchor.constraint(equalToConstant: 1),
            donutContentFoot.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor)
        ])

        donutContentFootTopConstraints[.glazeHome] = donutContentFoot.topAnchor.constraint(equalTo: challengeStrip.bottomAnchor, constant: 28)
        donutContentFootTopConstraints[.frostingDiary] = donutContentFoot.topAnchor.constraint(equalTo: didonutWevvPanel.bottomAnchor, constant: 32)
        donutContentFootTopConstraints[.sugarProfile] = donutContentFoot.topAnchor.constraint(equalTo: sugarProfilePanel.bottomAnchor, constant: 32)
        donutContentFootTopConstraints[.glazeHome]?.isActive = true
    }

    private func buildFrostingDiaryPanel() {
        frostingDiaryPanel.translatesAutoresizingMaskIntoConstraints = false
        frostingDiaryPanel.isHidden = true
        sprinkleContent.addSubview(frostingDiaryPanel)

        let glazeTitle = makePanelTitle("DvoWn#urtS zD?ilaxr@y*".wevVPastryCrumbBloomRestored)
        let firstCard = makeDiaryCard(title: "SctYryarwabiehrvrCy= Qg?lTaezJem !t!aKsGtsiNnrgG".wevVPastryCrumbBloomRestored, caption: "Aa IsJoEfYto rrWiBnBgo Cw;i?tIh/ IpUienRkF Pf%rpo/sctviRnSgj hnJoxtqetsx.o".wevVPastryCrumbBloomRestored)
        let secondCard = makeDiaryCard(title: "CUrZeXahmj asYhXeYl/fR ?pbiqcGkg".wevVPastryCrumbBloomRestored, caption: "FgraeQs:h^ pb@aSkYejrMyp Ubpiktdej *sBa,vWezdG +fponrk glaaQt+eirs.p".wevVPastryCrumbBloomRestored)

        frostingDiaryPanel.addSubview(glazeTitle)
        frostingDiaryPanel.addSubview(firstCard)
        frostingDiaryPanel.addSubview(secondCard)

        NSLayoutConstraint.activate([
            frostingDiaryPanel.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 112),
            frostingDiaryPanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 18),
            frostingDiaryPanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -18),
            frostingDiaryPanel.heightAnchor.constraint(equalToConstant: 410),
            glazeTitle.topAnchor.constraint(equalTo: frostingDiaryPanel.topAnchor),
            glazeTitle.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            glazeTitle.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor),
            firstCard.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 22),
            firstCard.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            firstCard.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor),
            secondCard.topAnchor.constraint(equalTo: firstCard.bottomAnchor, constant: 14),
            secondCard.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            secondCard.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor)
        ])
    }

    private func buildSugarProfilePanel() {
        sugarProfilePanel.translatesAutoresizingMaskIntoConstraints = false
        sugarProfilePanel.isHidden = true
        sprinkleContent.addSubview(sugarProfilePanel)

        let meButton = makeImageButton(asset: "wevv_profile_me_logo", action: #selector(openProfileSugarEntry))
        let gearButton = makeImageButton(asset: "wevv_profile_sugar_gear", action: #selector(openSugarSettings))
        let statButton = makeProfileImageAction(asset: "wevv_profile_stat_glaze_band")
        let avatarButton = makeProfileImageAction(asset: "wevv_profile_avatar_piano_donut")
        let shelfButton = makeProfileImageAction(asset: "wevv_profile_shop_shelf_card")
        shelfButton.removeTarget(nil, action: nil, for: .touchUpInside)
        shelfButton.addTarget(self, action: #selector(openSugarShelf), for: .touchUpInside)
        let vaultdonutWevvButton = makeProfileImageAction(asset: "wevv_profile_donut_vault_card")
        vaultdonutWevvButton.removeTarget(nil, action: nil, for: .touchUpInside)
        vaultdonutWevvButton.addTarget(self, action: #selector(openDonutVault), for: .touchUpInside)
        let postdonutWevvTitle = UIImageView(image: UIImage(named: "wevv_profile_sugar_post_title"))
        postdonutWevvTitle.translatesAutoresizingMaskIntoConstraints = false
        postdonutWevvTitle.contentMode = .scaleAspectFit

        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        profileNameLabel.textAlignment = .center
        profileNameLabel.textColor = UIColor(red: 0.2, green: 0.07, blue: 0.26, alpha: 1)

        configureProfileCountLabel(profileFollowingCountLabel)
        configureProfileCountLabel(profileFollowerCountLabel)
        configureProfileCardCountLabel(profileShelfCountLabel)
        configureProfileCardCountLabel(profileVaultCountLabel)

        let folldonutWevvTitle = makeProfileTinyText("FGoUl+lio!wPibn=gL".wevVPastryCrumbBloomRestored)
        let foldonutWevvTitle = makeProfileTinyText("Frotl*lao@wsebrP".wevVPastryCrumbBloomRestored)
        let shelfTitle = makeProfileCardTitle("SOaOvie^ pSwhCotp/".wevVPastryCrumbBloomRestored)
        let vaultTitle = makeProfileCardTitle("WRaAlGlre?tQ".wevVPastryCrumbBloomRestored)
        let followingEntry = makeProfileRelationEntry(action: #selector(openGlazeFollowingList))
        let followerEntry = makeProfileRelationEntry(action: #selector(openSprinkleFollowerList))

        profilePostStack.translatesAutoresizingMaskIntoConstraints = false
        profilePostStack.axis = .vertical
        profilePostStack.spacing = 10

        profileEmptyStack.translatesAutoresizingMaskIntoConstraints = false
        profileEmptyStack.axis = .vertical
        profileEmptyStack.alignment = .center
        profileEmptyStack.spacing = 6
        let crumbEmptyImage = makeProfileCrumbEmptyImage()
        profileEmptyStack.addArrangedSubview(crumbEmptyImage)

        placeSugarProfileViews(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton, followingTitle: folldonutWevvTitle, followerTitle: foldonutWevvTitle, followingEntry: followingEntry, followerEntry: followerEntry, shelfButton: shelfButton, vaultButton: vaultdonutWevvButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postdonutWevvTitle)
        pinSugarProfileLayout(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton, followingTitle: folldonutWevvTitle, followerTitle: foldonutWevvTitle, followingEntry: followingEntry, followerEntry: followerEntry, shelfButton: shelfButton, vaultButton: vaultdonutWevvButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postdonutWevvTitle, emptyImage: crumbEmptyImage)
        refreshSugarProfilePanel()
    }

    private func makeProfileCrumbEmptyImage() -> UIImageView {
        let crumbEmptyImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        crumbEmptyImage.translatesAutoresizingMaskIntoConstraints = false
        crumbEmptyImage.contentMode = .scaleAspectFit
        return crumbEmptyImage
    }

    private func placeSugarProfileViews(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView) {
        sugarProfilePanel.addSubview(meButton)
        sugarProfilePanel.addSubview(gearButton)
        sugarProfilePanel.addSubview(statButton)
        sugarProfilePanel.addSubview(avatarButton)
        sugarProfilePanel.addSubview(profileNameLabel)
        sugarProfilePanel.addSubview(profileFollowingCountLabel)
        sugarProfilePanel.addSubview(profileFollowerCountLabel)
        sugarProfilePanel.addSubview(followingTitle)
        sugarProfilePanel.addSubview(followerTitle)
        sugarProfilePanel.addSubview(followingEntry)
        sugarProfilePanel.addSubview(followerEntry)
        sugarProfilePanel.addSubview(shelfButton)
        sugarProfilePanel.addSubview(vaultButton)
        sugarProfilePanel.addSubview(profileShelfCountLabel)
        sugarProfilePanel.addSubview(profileVaultCountLabel)
        sugarProfilePanel.addSubview(shelfTitle)
        sugarProfilePanel.addSubview(vaultTitle)
        sugarProfilePanel.addSubview(postTitle)
        sugarProfilePanel.addSubview(profilePostStack)
        sugarProfilePanel.addSubview(profileEmptyStack)
    }

    private func pinSugarProfileLayout(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView, emptyImage: UIImageView) {
        pinSugarProfileTop(meButton: meButton, gearButton: gearButton, statButton: statButton, avatarButton: avatarButton)
        pinSugarProfileRelations(statButton: statButton, followingTitle: followingTitle, followerTitle: followerTitle, followingEntry: followingEntry, followerEntry: followerEntry)
        pinSugarProfileCards(statButton: statButton, shelfButton: shelfButton, vaultButton: vaultButton, shelfTitle: shelfTitle, vaultTitle: vaultTitle, postTitle: postTitle, emptyImage: emptyImage)
    }

    private func pinSugarProfileTop(meButton: UIButton, gearButton: UIButton, statButton: UIControl, avatarButton: UIControl) {
        NSLayoutConstraint.activate([
            sugarProfilePanel.topAnchor.constraint(equalTo: sprinkleContent.topAnchor),
            sugarProfilePanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            sugarProfilePanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            meButton.topAnchor.constraint(equalTo: sugarProfilePanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            meButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 25),
            meButton.widthAnchor.constraint(equalToConstant: 75),
            meButton.heightAnchor.constraint(equalToConstant: 30),
            gearButton.centerYAnchor.constraint(equalTo: meButton.centerYAnchor),
            gearButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -15),
            gearButton.widthAnchor.constraint(equalToConstant: 44),
            gearButton.heightAnchor.constraint(equalToConstant: 44),
            statButton.topAnchor.constraint(equalTo: meButton.bottomAnchor, constant: 56),
            statButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 20),
            statButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -20),
            statButton.heightAnchor.constraint(equalTo: statButton.widthAnchor, multiplier: 60.0 / 335.0),
            avatarButton.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: statButton.centerYAnchor, constant: -24),
            avatarButton.widthAnchor.constraint(equalToConstant: 108),
            avatarButton.heightAnchor.constraint(equalToConstant: 130),
            profileNameLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 4),
            profileNameLabel.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            profileNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: sugarProfilePanel.leadingAnchor, constant: 36),
            profileNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: sugarProfilePanel.trailingAnchor, constant: -36)
        ])
    }

    private func pinSugarProfileRelations(statButton: UIControl, followingTitle: UILabel, followerTitle: UILabel, followingEntry: UIControl, followerEntry: UIControl) {
        NSLayoutConstraint.activate([
            profileFollowingCountLabel.topAnchor.constraint(equalTo: statButton.topAnchor, constant: 12),
            profileFollowingCountLabel.centerXAnchor.constraint(equalTo: statButton.leadingAnchor, constant: 70),
            followingTitle.topAnchor.constraint(equalTo: profileFollowingCountLabel.bottomAnchor, constant: 2),
            followingTitle.centerXAnchor.constraint(equalTo: profileFollowingCountLabel.centerXAnchor),
            followingEntry.leadingAnchor.constraint(equalTo: statButton.leadingAnchor),
            followingEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followingEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followingEntry.widthAnchor.constraint(equalToConstant: 132),
            profileFollowerCountLabel.topAnchor.constraint(equalTo: profileFollowingCountLabel.topAnchor),
            profileFollowerCountLabel.centerXAnchor.constraint(equalTo: statButton.trailingAnchor, constant: -64),
            followerTitle.topAnchor.constraint(equalTo: profileFollowerCountLabel.bottomAnchor, constant: 2),
            followerTitle.centerXAnchor.constraint(equalTo: profileFollowerCountLabel.centerXAnchor),
            followerEntry.trailingAnchor.constraint(equalTo: statButton.trailingAnchor),
            followerEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followerEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followerEntry.widthAnchor.constraint(equalToConstant: 132)
        ])
    }

    private func pinSugarProfileCards(statButton: UIControl, shelfButton: UIControl, vaultButton: UIControl, shelfTitle: UILabel, vaultTitle: UILabel, postTitle: UIImageView, emptyImage: UIImageView) {
        NSLayoutConstraint.activate([
            shelfButton.topAnchor.constraint(equalTo: statButton.bottomAnchor, constant: 28),
            shelfButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 15),
            shelfButton.widthAnchor.constraint(equalTo: sugarProfilePanel.widthAnchor, multiplier: 0.434),
            shelfButton.heightAnchor.constraint(equalTo: shelfButton.widthAnchor, multiplier: 178.0 / 163.0),
            vaultButton.topAnchor.constraint(equalTo: shelfButton.topAnchor),
            vaultButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -15),
            vaultButton.widthAnchor.constraint(equalTo: shelfButton.widthAnchor),
            vaultButton.heightAnchor.constraint(equalTo: shelfButton.heightAnchor),
            profileShelfCountLabel.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            profileShelfCountLabel.centerYAnchor.constraint(equalTo: shelfButton.centerYAnchor, constant: 18),
            shelfTitle.topAnchor.constraint(equalTo: profileShelfCountLabel.bottomAnchor, constant: 8),
            shelfTitle.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            shelfTitle.leadingAnchor.constraint(greaterThanOrEqualTo: shelfButton.leadingAnchor, constant: 10),
            shelfTitle.trailingAnchor.constraint(lessThanOrEqualTo: shelfButton.trailingAnchor, constant: -10),
            profileVaultCountLabel.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            profileVaultCountLabel.centerYAnchor.constraint(equalTo: vaultButton.centerYAnchor, constant: 18),
            vaultTitle.topAnchor.constraint(equalTo: profileVaultCountLabel.bottomAnchor, constant: 8),
            vaultTitle.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            vaultTitle.leadingAnchor.constraint(greaterThanOrEqualTo: vaultButton.leadingAnchor, constant: 10),
            vaultTitle.trailingAnchor.constraint(lessThanOrEqualTo: vaultButton.trailingAnchor, constant: -10),
            postTitle.topAnchor.constraint(equalTo: shelfButton.bottomAnchor, constant: 20),
            postTitle.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 15),
            postTitle.widthAnchor.constraint(equalToConstant: 97),
            postTitle.heightAnchor.constraint(equalToConstant: 24),
            profilePostStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 18),
            profilePostStack.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 22),
            profilePostStack.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -22),
            profileEmptyStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 34),
            profileEmptyStack.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: 140),
            emptyImage.heightAnchor.constraint(equalToConstant: 153),
            profileEmptyStack.bottomAnchor.constraint(equalTo: sugarProfilePanel.bottomAnchor),
            profilePostStack.bottomAnchor.constraint(lessThanOrEqualTo: sugarProfilePanel.bottomAnchor)
        ])
    }

    private func makeShopCard(_ glazeShop: WevVGlazeShop) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = glazeShop.glazeKey
        pastryCard.addTarget(self, action: #selector(openShopCarouselEntry(_:)), for: .touchUpInside)

        let glazeImage = UIImageView(image: UIImage(named: glazeShop.coverAsset))
        glazeImage.translatesAutoresizingMaskIntoConstraints = false
        glazeImage.contentMode = .scaleAspectFill
        glazeImage.clipsToBounds = true
        pastryCard.addSubview(glazeImage)

        let titleBand = UIView()
        titleBand.translatesAutoresizingMaskIntoConstraints = false
        titleBand.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.78, alpha: 0.72)
        titleBand.layer.cornerRadius = 12
        titleBand.clipsToBounds = true
        pastryCard.addSubview(titleBand)

        let glazeTitleLabel = UILabel()
        glazeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        glazeTitleLabel.text = "\(glazeShop.shopTitle)\nrecommendations"
        glazeTitleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        glazeTitleLabel.textColor = .white
        glazeTitleLabel.textAlignment = .center
        glazeTitleLabel.numberOfLines = 2
        glazeTitleLabel.adjustsFontSizeToFitWidth = true
        glazeTitleLabel.minimumScaleFactor = 0.72
        titleBand.addSubview(glazeTitleLabel)
        let safetyButton = makeHomeSafetyButton(glazeShop.glazeKey, action: #selector(openGlazeShopSafety(_:)))
        pastryCard.addSubview(safetyButton)

        NSLayoutConstraint.activate([
            glazeImage.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            glazeImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            glazeImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            glazeImage.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            titleBand.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 14),
            titleBand.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14),
            titleBand.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -27),
            titleBand.heightAnchor.constraint(equalToConstant: 46),
            glazeTitleLabel.topAnchor.constraint(equalTo: titleBand.topAnchor, constant: 4),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: titleBand.leadingAnchor, constant: 8),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: titleBand.trailingAnchor, constant: -8),
            glazeTitleLabel.bottomAnchor.constraint(equalTo: titleBand.bottomAnchor, constant: -5),
            safetyButton.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 10),
            safetyButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -10),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        return pastryCard
    }

    private func makeCheckinButton(_ dailyFrosting: WevVDailyCheckin) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = dailyFrosting.doughRingKey
        sprinkleButton.addTarget(self, action: #selector(openDailyGlazeStamp), for: .touchUpInside)

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

    private func makeChallengeCard(_ sprinkleChallenge: WevVSprinkleChallenge) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = sprinkleChallenge.sprinkleKey
        pastryCard.addTarget(self, action: #selector(openChallengeDetail(_:)), for: .touchUpInside)

        let heroImage = makeSprinkleQuestHeroImage(asset: sprinkleChallenge.cardAsset)
        let frameImage = makeSprinkleQuestFrameImage()
        let glazeTitleLabel = makeSprinkleQuestNameLabel(sprinkleChallenge.title)
        let joinLabel = makeSprinkleQuestJoinLabel(sprinkleChallenge.joinedText)
        let arrowImage = makeSprinkleQuestArrowImage()
        let tasterAvatars = makeChallengeTasterStack(for: sprinkleChallenge)
        let safetyButton = makeHomeSafetyButton(sprinkleChallenge.sprinkleKey, action: #selector(openSprinkleQuestSafety(_:)))

        placeChallengeCardViews(pastryCard: pastryCard, heroImage: heroImage, frameImage: frameImage, glazeTitleLabel: glazeTitleLabel, tasterAvatars: tasterAvatars, joinLabel: joinLabel, arrowImage: arrowImage, safetyButton: safetyButton)
        pinChallengeCardLayout(pastryCard: pastryCard, heroImage: heroImage, frameImage: frameImage, glazeTitleLabel: glazeTitleLabel, tasterAvatars: tasterAvatars, joinLabel: joinLabel, arrowImage: arrowImage, safetyButton: safetyButton)
        return pastryCard
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

    private func makeHomeSafetyButton(_ sugarKey: String, action: Selector) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = sugarKey
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        sprinkleButton.layer.cornerRadius = 17
        sprinkleButton.addTarget(self, action: action, for: .touchUpInside)
        return sprinkleButton
    }

    private func placeChallengeCardViews(pastryCard: UIControl, heroImage: UIImageView, frameImage: UIImageView, glazeTitleLabel: UILabel, tasterAvatars: UIView, joinLabel: UILabel, arrowImage: UIImageView, safetyButton: UIButton) {
        [heroImage, frameImage, glazeTitleLabel, tasterAvatars, joinLabel, arrowImage, safetyButton].forEach {
            pastryCard.addSubview($0)
        }
    }

    private func pinChallengeCardLayout(pastryCard: UIControl, heroImage: UIImageView, frameImage: UIImageView, glazeTitleLabel: UILabel, tasterAvatars: UIView, joinLabel: UILabel, arrowImage: UIImageView, safetyButton: UIButton) {
        NSLayoutConstraint.activate([
            pastryCard.widthAnchor.constraint(equalToConstant: 148),
            heroImage.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 36),
            heroImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 10),
            heroImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -10),
            heroImage.heightAnchor.constraint(equalToConstant: 150),
            frameImage.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            frameImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            frameImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            frameImage.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            glazeTitleLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: -8),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 11),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -11),
            tasterAvatars.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 10),
            tasterAvatars.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            tasterAvatars.widthAnchor.constraint(equalToConstant: 58),
            tasterAvatars.heightAnchor.constraint(equalToConstant: 24),
            joinLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -7),
            joinLabel.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor, constant: -14),
            joinLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tasterAvatars.trailingAnchor, constant: 4),
            arrowImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -18),
            arrowImage.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 15),
            arrowImage.heightAnchor.constraint(equalToConstant: 15),
            safetyButton.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 38),
            safetyButton.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -16),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeChallengeTasterStack(for sprinkleChallenge: WevVSprinkleChallenge) -> UIView {
        let ringStack = UIView()
        ringStack.translatesAutoresizingMaskIntoConstraints = false
        let keys = makeChallengeTasterKeys(for: sprinkleChallenge)
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

    private func makeChallengeTasterKeys(for sprinkleChallenge: WevVSprinkleChallenge) -> [String] {
        let keys = [
            sprinkleChallenge.hostGuestKey,
            "lzuinPaMLpaquogfhlG/luaXz#ev".wevVPastryCrumbBloomRestored,
            "njolvyaBBIuAbdbBlIe;GdlxaPzveD".wevVPastryCrumbBloomRestored,
            "aJrZl/oiSlk;yoG:lWaYzLej".wevVPastryCrumbBloomRestored,
            "rsh;eeaJHloOnPenyiGKlGaXzJei".wevVPastryCrumbBloomRestored
        ]
        var seenKeys = Set<String>()
        return keys.filter { glazeKey in
            guard !seenKeys.contains(glazeKey) else { return false }
            seenKeys.insert(glazeKey)
            return true
        }.prefix(3).map { $0 }
    }

    private func makeChallengedonutWevvTasterAvatar(key: String) -> UIImageView {
        let profile = guestStore.profile(for: key)
        let avatar = UIImageView(image: UIImage(named: profile.donutAvatarAsset) ?? makeFrostingAvatarImage(seed: key))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 12
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        return avatar
    }

    private func makeSprinkleMomentCard(_ sprinkleMoment: WevVSprinkleFeedItem) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.accessibilityIdentifier = sprinkleMoment.sprinkleKey
        pastryCard.clipsToBounds = true
        pastryCard.layer.cornerRadius = 15
        pastryCard.addTarget(self, action: #selector(openSprinkleMomentDetail(_:)), for: .touchUpInside)

        let heroImage = makeSprinkleMomentHeroImage(sprinkleMoment)
        let textBand = makeSprinkleMomentTextBand()
        let captionLabel = makeSprinkleMomentCaption(sprinkleMoment.displayText)
        let avatar = makeSprinkleMomentAvatar(sprinkleMoment)
        let creamNameLabel = makeSprinkleMomentName(sprinkleMoment.author.name)
        let safetyButton = makeSprinkleMomentSafetyButton(sprinkleMoment.sprinkleKey)

        placeSprinkleMomentCardViews(pastryCard: pastryCard, heroImage: heroImage, textBand: textBand, captionLabel: captionLabel, avatar: avatar, creamNameLabel: creamNameLabel, safetyButton: safetyButton)
        pinSprinkleMomentCardLayout(pastryCard: pastryCard, heroImage: heroImage, textBand: textBand, captionLabel: captionLabel, avatar: avatar, creamNameLabel: creamNameLabel, safetyButton: safetyButton)
        return pastryCard
    }

    private func makeSprinkleMomentHeroImage(_ sprinkleMoment: WevVSprinkleFeedItem) -> UIImageView {
        let glazeImage = UIImageView(image: WevVPastryImageVault.glazeImage(for: sprinkleMoment.heroAsset) ?? makeFrostingHeroImage(seed: sprinkleMoment.heroAsset))
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
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarText
        crumbLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        crumbLabel.textColor = .white
        crumbLabel.numberOfLines = 2
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.82
        return crumbLabel
    }

    private func makeSprinkleMomentAvatar(_ sprinkleMoment: WevVSprinkleFeedItem) -> UIImageView {
        let glazeAvatar = UIImageView(image: makeSprinkleAuthorAvatar(for: sprinkleMoment))
        glazeAvatar.translatesAutoresizingMaskIntoConstraints = false
        glazeAvatar.contentMode = .scaleAspectFill
        glazeAvatar.clipsToBounds = true
        glazeAvatar.layer.cornerRadius = 15
        glazeAvatar.layer.borderWidth = 1.5
        glazeAvatar.layer.borderColor = UIColor.white.cgColor
        return glazeAvatar
    }

    private func makeSprinkleMomentName(_ sugarName: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = sugarName
        crumbLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        crumbLabel.textColor = .white
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.76
        return crumbLabel
    }

    private func makeSprinkleMomentSafetyButton(_ sugarKey: String) -> UIButton {
        let sprinkleButton = UIButton(type: .system)
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.accessibilityIdentifier = sugarKey
        sprinkleButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        sprinkleButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        sprinkleButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        sprinkleButton.layer.cornerRadius = 17
        sprinkleButton.addTarget(self, action: #selector(openSprinkleMomentSafety(_:)), for: .touchUpInside)
        return sprinkleButton
    }

    private func placeSprinkleMomentCardViews(pastryCard: UIControl, heroImage: UIImageView, textBand: UIView, captionLabel: UILabel, avatar: UIImageView, creamNameLabel: UILabel, safetyButton: UIButton) {
        pastryCard.addSubview(heroImage)
        pastryCard.addSubview(textBand)
        textBand.addSubview(captionLabel)
        pastryCard.addSubview(avatar)
        pastryCard.addSubview(creamNameLabel)
        pastryCard.addSubview(safetyButton)
    }

    private func pinSprinkleMomentCardLayout(pastryCard: UIControl, heroImage: UIImageView, textBand: UIView, captionLabel: UILabel, avatar: UIImageView, creamNameLabel: UILabel, safetyButton: UIButton) {
        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalTo: pastryCard.widthAnchor, multiplier: 182.0 / 345.0),
            heroImage.topAnchor.constraint(equalTo: pastryCard.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            heroImage.bottomAnchor.constraint(equalTo: textBand.topAnchor),
            textBand.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor),
            textBand.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor),
            textBand.bottomAnchor.constraint(equalTo: pastryCard.bottomAnchor),
            textBand.heightAnchor.constraint(equalToConstant: 50),
            captionLabel.topAnchor.constraint(equalTo: textBand.topAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: textBand.leadingAnchor, constant: 22),
            captionLabel.trailingAnchor.constraint(equalTo: textBand.trailingAnchor, constant: -18),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: textBand.bottomAnchor, constant: -7),
            avatar.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: heroImage.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 30),
            avatar.heightAnchor.constraint(equalToConstant: 30),
            creamNameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            creamNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            creamNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -10),
            safetyButton.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 15),
            safetyButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: -15),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeSprinkleAuthorAvatar(for sprinkleMoment: WevVSprinkleFeedItem) -> UIImage {
        if let profile = guestStore.allProfiles.first(where: { $0.glazeKey == sprinkleMoment.author.glazeKey }),
           let glazeImage = UIImage(named: profile.donutAvatarAsset) {
            return glazeImage
        }
        if let glazeImage = UIImage(named: sprinkleMoment.author.donutAvatarAsset) {
            return glazeImage
        }
        return makeFrostingAvatarImage(seed: sprinkleMoment.author.donutAvatarAsset)
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

    private func makeTabButton(section: WevVDonutMainSection, asset: String) -> UIControl {
        let sprinkleButton = UIControl()
        sprinkleButton.translatesAutoresizingMaskIntoConstraints = false
        sprinkleButton.tag = section.rawValue
        sprinkleButton.addTarget(self, action: #selector(selectDonutSection(_:)), for: .touchUpInside)

        let icon = makeTabIcon(asset)
        sprinkleButton.addSubview(icon)
        donutTabIcons[section] = icon

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

    private func configureProfileCountLabel(_ crumbLabel: UILabel) {
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.font = .systemFont(ofSize: 16, weight: .bold)
        crumbLabel.textColor = .white
        crumbLabel.textAlignment = .center
    }

    private func configureProfileCardCountLabel(_ crumbLabel: UILabel) {
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        crumbLabel.textColor = .white
        crumbLabel.textAlignment = .center
    }

    private func makeProfileCardTitle(_ text: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: 23, weight: .heavy)
        crumbLabel.textColor = .white
        crumbLabel.textAlignment = .center
        crumbLabel.adjustsFontSizeToFitWidth = true
        crumbLabel.minimumScaleFactor = 0.72
        return crumbLabel
    }

    private func makeProfileTinyText(_ text: String) -> UILabel {
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: 13, weight: .medium)
        crumbLabel.textColor = .white
        crumbLabel.textAlignment = .center
        return crumbLabel
    }

    private func makeProfileRelationEntry(action: Selector) -> UIControl {
        let pastryEntry = UIControl()
        pastryEntry.translatesAutoresizingMaskIntoConstraints = false
        pastryEntry.backgroundColor = .clear
        pastryEntry.addTarget(self, action: action, for: .touchUpInside)
        return pastryEntry
    }

    private func refreshSugarProfilePanel() {
        let isReady = glazeSession.isTasterReady
        let currentUser = currentCreamRingTaster()
        let baseStat = currentUser.creamStats
        let followingRosterCount = guestStore.glazeFollowingProfiles.count
        let followerRosterCount = guestStore.sprinkleFanProfiles.count
        let creamStats = isReady
            ? WevVCreamStat(
                glazeFollowCount: followingRosterCount,
                sprinkleFanCount: followerRosterCount,
                bakeryShelfCount: baseStat.bakeryShelfCount + glazeSession.glazeShelfCount,
                vaultCount: glazeSession.glazeGoldCount
            )
            : WevVCreamStat(glazeFollowCount: 0, sprinkleFanCount: 0, bakeryShelfCount: 0, vaultCount: 0)
        profileNameLabel.text = isReady ? currentUser.glazeNickname : ""
        profileAvatarImageView?.image = UIImage(named: currentUser.donutAvatarAsset)
        profileFollowingCountLabel.text = "\(creamStats.glazeFollowCount)"
        profileFollowerCountLabel.text = "\(creamStats.sprinkleFanCount)"
        profileShelfCountLabel.text = "\(creamStats.bakeryShelfCount)"
        profileVaultCountLabel.text = "\(creamStats.vaultCount)"

        profilePostStack.arrangedSubviews.forEach { sugarView in
            profilePostStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }

        profileEmptyStack.isHidden = false
        profilePostStack.isHidden = true
    }

    private func currentSugarPosts() -> [WevVSugarPost] {
        let freshPosts = glazeSession.sugarMomentPackets.map {
            WevVSugarPost(sugarKey: $0.sugarKey, title: $0.timeText, note: $0.text)
        }
        return freshPosts + currentCreamRingTaster().sugarNotes
    }

    private func currentCreamRingTaster() -> WevVCreamRingTaster {
        let profile = glazeSession.currentDoughRingTasterProfile
        return WevVCreamRingTaster(
            doughRingKey: profile.doughRingKey,
            email: profile.email,
            glazeNickname: profile.glazeNickname.isEmpty ? defaultCreamRingTaster.glazeNickname : profile.glazeNickname,
            donutAvatarAsset: profile.donutAvatarAsset.isEmpty ? defaultCreamRingTaster.donutAvatarAsset : profile.donutAvatarAsset,
            creamStats: WevVCreamStat(
                glazeFollowCount: profile.glazeFollowCount,
                sprinkleFanCount: profile.sprinkleFanCount,
                bakeryShelfCount: profile.bakeryShelfCount,
                vaultCount: profile.glazeVaultCount
            ),
            sugarNotes: defaultCreamRingTaster.sugarNotes
        )
    }

    private func makeSugarPostCard(_ sugarPost: WevVSugarPost) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        pastryCard.layer.cornerRadius = 16
        pastryCard.addTarget(self, action: #selector(openProfileSugarEntry), for: .touchUpInside)

        let glazeTitle = UILabel()
        glazeTitle.translatesAutoresizingMaskIntoConstraints = false
        glazeTitle.text = sugarPost.title
        glazeTitle.font = .systemFont(ofSize: 15, weight: .heavy)
        glazeTitle.textColor = UIColor(red: 0.17, green: 0.08, blue: 0.22, alpha: 1)

        let crumbNote = UILabel()
        crumbNote.translatesAutoresizingMaskIntoConstraints = false
        crumbNote.text = sugarPost.note
        crumbNote.font = .systemFont(ofSize: 13, weight: .medium)
        crumbNote.textColor = UIColor(red: 0.54, green: 0.42, blue: 0.51, alpha: 1)
        crumbNote.numberOfLines = 2

        pastryCard.addSubview(glazeTitle)
        pastryCard.addSubview(crumbNote)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 64),
            glazeTitle.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 10),
            glazeTitle.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 14),
            glazeTitle.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -14),
            crumbNote.topAnchor.constraint(equalTo: glazeTitle.bottomAnchor, constant: 3),
            crumbNote.leadingAnchor.constraint(equalTo: glazeTitle.leadingAnchor),
            crumbNote.trailingAnchor.constraint(equalTo: glazeTitle.trailingAnchor)
        ])
        return pastryCard
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
        let crumbLabel = UILabel()
        crumbLabel.translatesAutoresizingMaskIntoConstraints = false
        crumbLabel.text = text
        crumbLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        crumbLabel.textColor = .black
        return crumbLabel
    }

    private func makeDiaryCard(title: String, caption: String) -> UIControl {
        let pastryCard = UIControl()
        pastryCard.translatesAutoresizingMaskIntoConstraints = false
        pastryCard.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        pastryCard.layer.cornerRadius = 22

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

        pastryCard.addSubview(glazeTitleLabel)
        pastryCard.addSubview(captionLabel)

        NSLayoutConstraint.activate([
            pastryCard.heightAnchor.constraint(equalToConstant: 112),
            glazeTitleLabel.topAnchor.constraint(equalTo: pastryCard.topAnchor, constant: 18),
            glazeTitleLabel.leadingAnchor.constraint(equalTo: pastryCard.leadingAnchor, constant: 20),
            glazeTitleLabel.trailingAnchor.constraint(equalTo: pastryCard.trailingAnchor, constant: -20),
            captionLabel.topAnchor.constraint(equalTo: glazeTitleLabel.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: glazeTitleLabel.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: glazeTitleLabel.trailingAnchor)
        ])
        return pastryCard
    }

    @objc private func openGlazeNoticeList() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVNoticeEmptyController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func selectDonutSection(_ glazeButton: UIControl) {
        guard let section = WevVDonutMainSection(rawValue: glazeButton.tag) else { return }
        switchDonutSection(section)
    }

    @objc private func advanceGlazeCarousel() {
        guard activeDonutSection == .glazeHome, glazeShops.count > 1, shopCarousel.bounds.width > 0 else { return }
        let currentPage = Int(round(shopCarousel.contentOffset.x / shopCarousel.bounds.width))
        let nextPage = (currentPage + 1) % glazeShops.count
        let nextOffset = CGPoint(x: CGFloat(nextPage) * shopCarousel.bounds.width, y: 0)
        shopCarousel.setContentOffset(nextOffset, animated: true)
        shopDots.currentPage = nextPage
    }

    @objc private func openProtectedGlazeAction() {
        presentProtectedGate()
    }

    @objc private func openSprinkleQuestComposer() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSprinkleQuestComposerController()
        controller.onSprinkleQuestReady = { [weak self] packet in
            guard let self else { return }
            let quest = self.makeQuest(from: packet)
            self.sprinkleChallenges.removeAll { self.isSameSprinkleQuest($0, quest) }
            self.sprinkleChallenges.insert(quest, at: 0)
            self.rebuildSprinkleQuestRow()
            self.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "Prrje^pZa$rFiBnzg& =pUo@sVtq YtCrLa=yQ.B.e.k".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openSugarMomentComposer() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarMomentComposerController()
        controller.onSugarMomentReady = { [weak self] packet in
            guard let self else { return }
            let currentUser = self.currentCreamRingTaster()
            let freshMoment = WevVSprinkleFeedItem(
                sprinkleKey: packet.sugarKey,
                author: WevVGlazeAuthor(glazeKey: currentUser.doughRingKey, name: currentUser.glazeNickname, donutAvatarAsset: currentUser.donutAvatarAsset),
                heroAsset: packet.heroAsset,
                displayText: packet.text,
                isSprinkled: false,
                isSaved: false,
                frostingTimeText: packet.timeText
            )
            self.sprinkleMoments.insert(freshMoment, at: 0)
            self.rebuildSprinkleMomentStack()
            self.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "Prrje^pZa$rFiBnzg& =pUo@sVtq YtCrLa=yQ.B.e.k".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func rebuildSprinkleMomentStack() {
        momentStack.arrangedSubviews.forEach { sugarView in
            momentStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        for sprinkleMoment in sprinkleMoments {
            guard !isSprinkleAuthorShielded(sprinkleMoment) else { continue }
            momentStack.addArrangedSubview(makeSprinkleMomentCard(sprinkleMoment))
        }
    }

    private func rebuildSprinkleQuestRow() {
        challengeRow.arrangedSubviews.forEach { sugarView in
            challengeRow.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        let uniqueChallenges = uniqueSprinkleQuests(sprinkleChallenges)
        sprinkleChallenges = uniqueChallenges
        for sprinkleChallenge in uniqueChallenges {
            challengeRow.addArrangedSubview(makeChallengeCard(sprinkleChallenge))
        }
    }

    private func preloadSugarMoments() {
        let packets = glazeSession.sugarMomentPackets
        guard !packets.isEmpty else { return }
        let packetKeys = Set(sprinkleMoments.map(\.sprinkleKey))
        let currentUser = currentCreamRingTaster()
        let freshMoments = packets
            .filter { !packetKeys.contains($0.sugarKey) }
            .map {
                WevVSprinkleFeedItem(
                    sprinkleKey: $0.sugarKey,
                    author: WevVGlazeAuthor(glazeKey: currentUser.doughRingKey, name: currentUser.glazeNickname, donutAvatarAsset: currentUser.donutAvatarAsset),
                    heroAsset: $0.heroAsset,
                    displayText: $0.text,
                    isSprinkled: false,
                    isSaved: false,
                    frostingTimeText: $0.timeText
                )
            }
        sprinkleMoments.insert(contentsOf: freshMoments, at: 0)
    }

    private func preloadSprinkleQuests() {
        let packets = glazeSession.sprinkleQuestPackets
        guard !packets.isEmpty else { return }
        let questKeys = Set(sprinkleChallenges.map(\.sprinkleKey))
        let freshQuests = packets
            .filter { !questKeys.contains($0.sugarKey) }
            .map { makeQuest(from: $0) }
        sprinkleChallenges.insert(contentsOf: freshQuests, at: 0)
    }

    private func uniqueSprinkleQuests(_ quests: [WevVSprinkleChallenge]) -> [WevVSprinkleChallenge] {
        var seenKeys = Set<String>()
        return quests.filter { quest in
            let key = questIdentityKey(quest)
            guard !seenKeys.contains(key) else { return false }
            seenKeys.insert(key)
            return true
        }
    }

    private func isSameSprinkleQuest(_ left: WevVSprinkleChallenge, _ right: WevVSprinkleChallenge) -> Bool {
        questIdentityKey(left) == questIdentityKey(right)
    }

    private func questIdentityKey(_ quest: WevVSprinkleChallenge) -> String {
        [
            quest.title,
            quest.sprinkleTimeText,
            quest.crumbPlaceText,
            "\(quest.sugarCost)"
        ]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .joined(separator: "|L".wevVPastryCrumbBloomRestored)
    }

    private func makeQuest(from packet: WevVSprinkleQuestPacket) -> WevVSprinkleChallenge {
        WevVSprinkleChallenge(
            sprinkleKey: packet.sugarKey,
            title: packet.title,
            caption: packet.text,
            cardAsset: packet.coverAsset,
            joinedText: "JaoIiln?".wevVPastryCrumbBloomRestored,
            glazeLine: packet.text,
            sprinkleTimeText: packet.timeText,
            crumbPlaceText: packet.placeText,
            hostGuestKey: "jEa^m?iKeRCCo^ljey".wevVPastryCrumbBloomRestored,
            hostLine: "FWrpeNsmh& NhFo?sAta H·Z G4#.W9t Yr=aFt#iqnbg%".wevVPastryCrumbBloomRestored,
            missionText: packet.text,
            crowdText: "1S bpleTrQsnodnZ".wevVPastryCrumbBloomRestored,
            sugarCost: packet.sugarCost
        )
    }

    @objc private func openDailyGlazeStamp() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDailyGlazeStampController()
        controller.onStampChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openProfileSugarEntry() {
        presentProtectedGate()
    }

    @objc private func openSugarShelf() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarShelfController(shopDetails: allGlazeShopDetails())
        controller.onShelfChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "ORppegnSiFn=gG idoobnZugts GsIhmoWp^.r.P.I".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    @objc private func openGlazeFollowingList() {
        openSugarRoster(.glazeFollowing)
    }

    @objc private func openSprinkleFollowerList() {
        openSugarRoster(.sprinkleFollower)
    }

    private func openSugarRoster(_ mode: WevVSugarRosterMode) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarRosterController(mode: mode)
        controller.onRosterChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
            self?.rebuildSprinkleMomentStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSugarSettings() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarSettingsController()
        controller.onSugarSettingChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSprinkleMomentDetail(_ sender: UIControl) {
        let sprinkleKey = sender.accessibilityIdentifier ?? sprinkleMoments[0].sprinkleKey
        let sprinkleMoment = sprinkleMoments.first { $0.sprinkleKey == sprinkleKey } ?? sprinkleMoments[0]
        let controller = WevVSprinkleMomentDetailController(sprinkleMoment: sprinkleMoment)
        controller.onSugarMomentShielded = { [weak self] in
            self?.rebuildSprinkleMomentStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSprinkleMomentSafety(_ sender: UIControl) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sprinkleKey = sender.accessibilityIdentifier ?? ""
        guard let moment = sprinkleMoments.first(where: { $0.sprinkleKey == sprinkleKey }) else { return }
        presentSprinkleSafetySheet(for: moment)
    }

    @objc private func openGlazeShopSafety(_ sender: UIControl) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sugarKey = sender.accessibilityIdentifier ?? ""
        guard glazeShops.contains(where: { $0.glazeKey == sugarKey }) else { return }
        presentHomeSafetySheet(for: sugarKey)
    }

    @objc private func openSprinkleQuestSafety(_ sender: UIControl) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sugarKey = sender.accessibilityIdentifier ?? ""
        guard sprinkleChallenges.contains(where: { $0.sprinkleKey == sugarKey }) else { return }
        presentHomeSafetySheet(for: sugarKey)
    }

    private func presentHomeSafetySheet(for sugarKey: String) {
        let sheet = WevVGlazeSafetySheet(shopKey: sugarKey, choices: sprinkleSafetyChoices())
        sheet.onClose = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.onConfirm = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.glazeSession.placeGlazeSafetyCrumb(packet)
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

    private func presentSprinkleSafetySheet(for moment: WevVSprinkleFeedItem) {
        let sheet = WevVGlazeSafetySheet(shopKey: moment.author.glazeKey, choices: sprinkleSafetyChoices())
        sheet.onClose = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.onConfirm = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.glazeSession.placeGlazeSafetyCrumb(packet)
            self.placeSprinkleShield(for: moment.author.glazeKey)
            self.hideSprinkleSafetySheet(sheet)
            self.rebuildSprinkleMomentStack()
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
            WevVGlazeSafetyChoice(sugarKey: "f.aikDevP=hGortBom".wevVPastryCrumbBloomRestored, title: "FDaEkEeL ^pyhUoOtNo#".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "spcQavmUCNoLmVmJeLr?ciioaGlp".wevVPastryCrumbBloomRestored, title: "S%cfaLmc Io/rq xcVoom=mpeSr=cGila@l%".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "nso!tUI#nBt+e*rIebsIt:e=dn".wevVPastryCrumbBloomRestored, title: "NWoYtV ^irnxtkePrGemsAtQe%dG".wevVPastryCrumbBloomRestored, needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "ootchFeurzSku?g?airR".wevVPastryCrumbBloomRestored, title: "OAt#hOegr^".wevVPastryCrumbBloomRestored, needsCreamText: true)
        ]
    }

    private func placeSprinkleShield(for glazeKey: String) {
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == glazeKey }) else { return }
        if !guestStore.profile(for: glazeKey).sugarTie.isSugarShielded {
            _ = guestStore.toggleSugarShield(for: glazeKey)
        }
    }

    private func isSprinkleAuthorShielded(_ moment: WevVSprinkleFeedItem) -> Bool {
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == moment.author.glazeKey }) else { return false }
        return guestStore.profile(for: moment.author.glazeKey).sugarTie.isSugarShielded
    }

    private func showRootSugarHint(_ text: String) {
        WevVGlazePromptStyler.showSugarToast(in: view, text: text, above: donutTabBack, bottomOffset: -14)
    }

    @objc private func openDonutVault() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDonutVaultController()
        controller.onVaultChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openShopCarouselEntry(_ glazedSender: UIControl) {
        let glazeKey = glazedSender.accessibilityIdentifier ?? glazeShops[0].glazeKey
        let glazeShop = glazeShops.first { $0.glazeKey == glazeKey } ?? glazeShops[0]
        let shopShelf = allGlazeShopDetails()
        let detail = shopShelf.first { $0.glazeKey == glazeShop.glazeKey } ?? makeGlazeShopDetail(glazeShop)
        let controller = WevVGlazeShopDetailController(detail: detail, glazeShelf: shopShelf)
        controller.onShelfChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func makeGlazeShopDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        switch glazeShop.glazeKey {
        case "berryRingBakery":
            return makeBerryRingBakeryDetail(glazeShop)
        case "goldenDoughStudio":
            return makeGoldenDoughStudioDetail(glazeShop)
        case "moonlightDonutBar":
            return makeMoonlightDonutBarDetail(glazeShop)
        default:
            return makeClassicGlazeHouseDetail(glazeShop)
        }
    }

    private func makeBerryRingBakeryDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        WevVGlazeShopDetail(
            glazeKey: glazeShop.glazeKey,
            title: "BKeAr^rGyj ~RHiTnMgG ABZaVkBeqrfyc".wevVPastryCrumbBloomRestored,
            subtitle: "FcrLels@hP ^dPosn.uvt+sV &·z =b=eKr=rjy@ bf?lSa.vooUrYsU".wevVPastryCrumbBloomRestored,
            coverAsset: glazeShop.coverAsset,
            crumbScoreText: "4g.r8,".wevVPastryCrumbBloomRestored,
            reviewText: "(s1T8o6m greeDvHine#wRsy)o".wevVPastryCrumbBloomRestored,
            addressLine: "8/6d OBIlXoxs,sLoOmm sAGvhe+nauVev,p jS#aLnL ZFBrFaWnrcRiasxcjon".wevVPastryCrumbBloomRestored,
            tags: [
                WevVFrostingShopTag(glazeKey: "sjtGrIaKwXbVe^rqrdy~T!aggB".wevVPastryCrumbBloomRestored, title: "SXtDr&aow/bhezrxruy:".wevVPastryCrumbBloomRestored, tintHex: "f=fl4uaka%0G".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "hoadnHdcmGaMddeOT/aQgD".wevVPastryCrumbBloomRestored, title: "H:a!n?d,mAamdoet".wevVPastryCrumbBloomRestored, tintHex: "fn5,bX4#3!1G".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "cPodzhy%SfuwgxapriTVaDgT".wevVPastryCrumbBloomRestored, title: "CCopzsyb".wevVPastryCrumbBloomRestored, tintHex: "8Jb.6:3lfHfP".wevVPastryCrumbBloomRestored)
            ],
            parlorTitle: "Byepr&rayW JDPojnQuot! PColPuubH".wevVPastryCrumbBloomRestored,
            parlorLine: "SGhmairZeY ?f!r#upictOy, Wf@l=asvtoQr#s&,! Tspw@eWeFts =pQiecdkSsh,f basnldU Abza=kDecrcyW @s!tEo#r.ihessL.A".wevVPastryCrumbBloomRestored,
            parlorCrowdText: "2F4l MoTn,l+i*nweg".wevVPastryCrumbBloomRestored,
            reviews: berryRingBakeryReviews(),
            morePicks: berryRingBakeryPicks()
        )
    }

    private func berryRingBakeryReviews() -> [WevVSprinkleReview] {
        [
            WevVSprinkleReview(sprinkleKey: "mjiRaNBZeSr^rPy/GRlCaszseN".wevVPastryCrumbBloomRestored, tasterName: "MniBac".wevVPastryCrumbBloomRestored, tastingRole: "D!ecsrskebrut; Uleo*v;e?ro".wevVPastryCrumbBloomRestored, crumbScoreText: "4Z.*9I".wevVPastryCrumbBloomRestored, biteText: "TYhCeR ^s!t+rRaJwWbMe!rfrRyR &gLl;ayzUet !wPa%sg gfprSehsGhz,X %sNmJowoXtdhw,o =a=n;dL vphebrwfEeJc~t#l*yc MscwdedeZta.z".wevVPastryCrumbBloomRestored, badgeText: "BleRrnr:yR AFwatv:oErgi=twem".wevVPastryCrumbBloomRestored),
            WevVSprinkleReview(sprinkleKey: "eUtWhDatn.CJoqz;yiBIackHe:r:yB".wevVPastryCrumbBloomRestored, tasterName: "E+tyhka~n#".wevVPastryCrumbBloomRestored, tastingRole: "Wke=etkceGnCdE Ze+xlpWlMo+raesr^".wevVPastryCrumbBloomRestored, crumbScoreText: "4v.T7l".wevVPastryCrumbBloomRestored, biteText: "Aj &cfo?zqyT bl#i#tytulzee ^sGh^ohp@ %wLiktuhD isaorfUth UdyoPnju%t/s/ YasnAd% NfJrRi&eHn:dfl=ys NshevrevXizc*eP.X".wevVPastryCrumbBloomRestored, badgeText: "C@orzAyz HSPpsoHtt".wevVPastryCrumbBloomRestored)
        ]
    }

    private func berryRingBakeryPicks() -> [WevVSugarShopPick] {
        [
            WevVSugarShopPick(sugarKey: "goldenDoughPick", title: "Golden Dough Studio", addressLine: "215 Golden Lane, San Francisco", crumbScoreText: "4.9", coverAsset: "wevv_shop_golden_dough_studio"),
            WevVSugarShopPick(sugarKey: "mellowDoughPick", title: "Mellow Dough", addressLine: "212 Pine Ave, Oakland, CA", crumbScoreText: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeGoldenDoughStudioDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        WevVGlazeShopDetail(
            glazeKey: glazeShop.glazeKey,
            title: "G+oplcddeanm ZD#oGueguhy SSxtEu?dtiWoo".wevVPastryCrumbBloomRestored,
            subtitle: "ADr&tPi#sEa~nY QdGo@n?uzt/s; X·t ysXmIaJljlO wbua,tgceh&eXsf".wevVPastryCrumbBloomRestored,
            coverAsset: glazeShop.coverAsset,
            crumbScoreText: "4w.Z9a".wevVPastryCrumbBloomRestored,
            reviewText: "(m3T1#2d prTeIvii:eowBsh)N".wevVPastryCrumbBloomRestored,
            addressLine: "2W1P5e GGbo.l@dCexn# SL;afn@e.,* AS.a~nL sFdrxaOnLcyiQs.cKo*".wevVPastryCrumbBloomRestored,
            tags: [
                WevVFrostingShopTag(glazeKey: "aMrdtKiHs;annNTwazg*".wevVPastryCrumbBloomRestored, title: "AxrStsipskaWnm".wevVPastryCrumbBloomRestored, tintHex: "b=7x7+9o2G0^".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "f%reeosJhsByaftlckhoT.aygV".wevVPastryCrumbBloomRestored, title: "Fqrzems=hh".wevVPastryCrumbBloomRestored, tintHex: "fP5ebB4a3y1V".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "poozp!uwlIaJrJSeuCgJawrdT:aYgx".wevVPastryCrumbBloomRestored, title: "PWoBpPuklJaqrV".wevVPastryCrumbBloomRestored, tintHex: "8Gba6k3=fFf%".wevVPastryCrumbBloomRestored)
            ],
            parlorTitle: "GpoAlNdreTnW NDhoquogKh: ZR%oFoomF".wevVPastryCrumbBloomRestored,
            parlorLine: "TXaolrk# oa?b,onuht@ EfRrdefsuhk Wb~aJtCc^h.e=sz,* ftWobpXp:iknCgosp,n la/n;dD Id.oJnruPtK opMaUifrtiXnIgtsl.U".wevVPastryCrumbBloomRestored,
            parlorCrowdText: "3&8T qoRnhleivnreg".wevVPastryCrumbBloomRestored,
            reviews: goldenDoughStudioReviews(),
            morePicks: goldenDoughStudioPicks()
        )
    }

    private func goldenDoughStudioReviews() -> [WevVSprinkleReview] {
        [
            WevVSprinkleReview(sprinkleKey: "osl/iNv,iuaJGqoNlcdJeXnSF%r~aZmmee".wevVPastryCrumbBloomRestored, tasterName: "O=lFiavpipas".wevVPastryCrumbBloomRestored, tastingRole: "FPoEo@dI ~pfhjostwo/gAr/atpXhPearU".wevVPastryCrumbBloomRestored, crumbScoreText: "5&.W0n".wevVPastryCrumbBloomRestored, biteText: "EtvfekrDyY ddjofn@uptr Xl/o/o^kEe!dR qbhe#aZu?t#iYf,uKlm Xaxntd# LtZa;sOthewd* /eZvbeznx xbFe~tnt~e!rX.U".wevVPastryCrumbBloomRestored, badgeText: "PYicc?tauJr:eU =Pie.rRfveFctti".wevVPastryCrumbBloomRestored),
            WevVSprinkleReview(sprinkleKey: "nJovaBhADLozusgfh~TGerxEt/uMr,e!".wevVPastryCrumbBloomRestored, tasterName: "N^o*aXhI".wevVPastryCrumbBloomRestored, tastingRole: "DKoHnNuEt% JcBo.lXlheycotsoerY".wevVPastryCrumbBloomRestored, crumbScoreText: "4c.Y8N".wevVPastryCrumbBloomRestored, biteText: "TghZe? ndCozufgPh* xwEauss elBi:gVh?tR,, ;fqlHuBfCf+yQ,p laSnwdL CnueXvbeXrv ;tooXod &oaijl.yz..".wevVPastryCrumbBloomRestored, badgeText: "BoeKsQt= *T.e%xitmuPrAex".wevVPastryCrumbBloomRestored)
        ]
    }

    private func goldenDoughStudioPicks() -> [WevVSugarShopPick] {
        [
            WevVSugarShopPick(sugarKey: "pinkGlazePick", title: "Pink Glaze House", addressLine: "128 Berry Street, San Francisco", crumbScoreText: "4.9", coverAsset: "wevv_shop_berry_ring_bakery"),
            WevVSugarShopPick(sugarKey: "mellowDoughPick", title: "Mellow Dough", addressLine: "212 Pine Ave, Oakland, CA", crumbScoreText: "4.8", coverAsset: "wevv_shop_moonlight_donut_bar")
        ]
    }

    private func makeMoonlightDonutBarDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        WevVGlazeShopDetail(
            glazeKey: glazeShop.glazeKey,
            title: "MxoLoInKlQiigChotI ;DPoon@uytR %BeaQr;".wevVPastryCrumbBloomRestored,
            subtitle: "L*aBtYeh-knNiHgJhVtV bdooXnmu:t=sU t·H ;cArIe=aotJiov:eG Fdvr%i.n^k^sh".wevVPastryCrumbBloomRestored,
            coverAsset: glazeShop.coverAsset,
            crumbScoreText: "4W.w7N".wevVPastryCrumbBloomRestored,
            reviewText: "(P2e0k4! rrve/v~iHe&wxsm)W".wevVPastryCrumbBloomRestored,
            addressLine: "4t2& ECprFecs@c&ebn*t~ pS/t^rGeDeVth,M iS#aqni yF+rraunLczi?shcjoO".wevVPastryCrumbBloomRestored,
            tags: [
                WevVFrostingShopTag(glazeKey: "l%aWtWeqN:iLgQhdtlTcaNgA".wevVPastryCrumbBloomRestored, title: "L%aptze: NN/isgshxtI".wevVPastryCrumbBloomRestored, tintHex: "8lbo6e3jfjfI".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "cGoofrfdeleBT+aMgK".wevVPastryCrumbBloomRestored, title: "CAoNfifJereA".wevVPastryCrumbBloomRestored, tintHex: "7,b~4Db*2aal".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "cYrHeWaHtOivvkeIS;uFgCa=rxT*asgu".wevVPastryCrumbBloomRestored, title: "C#rNeDajtLitvie~".wevVPastryCrumbBloomRestored, tintHex: "fIfJ4paua%0J".wevVPastryCrumbBloomRestored)
            ],
            parlorTitle: "M=iCd!n?iWgDhbt* fDPoxn=u?th ST+aGl^kW".wevVPastryCrumbBloomRestored,
            parlorLine: "AA Slkaft~eh-VnHi=gEhQtz Ur/oyoFmS KfWo&r^ ZdQo:nDuzty QfJabnYs. &agnbdA mc;oMfTfjeUe; rl:ozvSeer/sc.U".wevVPastryCrumbBloomRestored,
            parlorCrowdText: "3L1g *oZnZlyisnreI".wevVPastryCrumbBloomRestored,
            reviews: moonlightDonutBarReviews(),
            morePicks: moonlightDonutBarPicks()
        )
    }

    private func moonlightDonutBarReviews() -> [WevVSprinkleReview] {
        [
            WevVSprinkleReview(sprinkleKey: "cYh+lQoneCNEi&gmhvtmC=aHfteW".wevVPastryCrumbBloomRestored, tasterName: "CJhJl.ooe+".wevVPastryCrumbBloomRestored, tastingRole: "NDiPgqhJtZ ycaa:fLef LfeamnI".wevVPastryCrumbBloomRestored, crumbScoreText: "4y.f8@".wevVPastryCrumbBloomRestored, biteText: "Thhzez xpHePrLfreTc;tc EpLldaocgeF BfFoHrH hav gsIw?eHectz al#aDtYeZ-jnoixgahYt. %cyotfFfteTeL aberfeiaCk+.R".wevVPastryCrumbBloomRestored, badgeText: "NliygphktU OVUi,brePsl".wevVPastryCrumbBloomRestored),
            WevVSprinkleReview(sprinkleKey: "lgiqaHm&CDoyfNf~e=eiWhasrcmatPh+".wevVPastryCrumbBloomRestored, tasterName: "Lzi&axmO".wevVPastryCrumbBloomRestored, tastingRole: "C:odf/fbeYeC YeBnItehruusViQawsDtV".wevVPastryCrumbBloomRestored, crumbScoreText: "4~.S6z".wevVPastryCrumbBloomRestored, biteText: "G&rqe#aitW yejsvpIr#ePsns=oI,Z qwfa/rmmX xdPosn#uatss.,E ?arnndn iaE Mr+eul;a*xMeHdH #awtcmko,s;pahKe~r%e@.U".wevVPastryCrumbBloomRestored, badgeText: "CcotfcfoeWen CMqast+cShF".wevVPastryCrumbBloomRestored)
        ]
    }

    private func moonlightDonutBarPicks() -> [WevVSugarShopPick] {
        [
            WevVSugarShopPick(sugarKey: "berryRingPick", title: "Berry Ring Bakery", addressLine: "86 Blossom Avenue, San Francisco", crumbScoreText: "4.8", coverAsset: "wevv_shop_berry_ring_bakery"),
            WevVSugarShopPick(sugarKey: "goldenDoughPick", title: "Golden Dough Studio", addressLine: "215 Golden Lane, San Francisco", crumbScoreText: "4.9", coverAsset: "wevv_shop_golden_dough_studio")
        ]
    }

    private func makeClassicGlazeHouseDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        return WevVGlazeShopDetail(
            glazeKey: glazeShop.glazeKey,
            title: glazeShop.glazeKey == "sap%rUixnckjl*eBSRhUeBljf!".wevVPastryCrumbBloomRestored ? "Mellow Dough" : "Pxi;nDkl .Ggl+anzEeC dH,opuPsVe%".wevVPastryCrumbBloomRestored,
            subtitle: glazeShop.flavorLine,
            coverAsset: glazeShop.coverAsset,
            crumbScoreText: "4v.v9@".wevVPastryCrumbBloomRestored,
            reviewText: "(#2M4n6P ?roeHvjiYe+wEs?)J".wevVPastryCrumbBloomRestored,
            addressLine: "1W2X8~ .B.e*r.rwyX #SWtUrMebeyt/,o YSuahn* iFZrAaInMceif.U.D.P".wevVPastryCrumbBloomRestored,
            tags: [
                WevVFrostingShopTag(glazeKey: "bhe&rNrdywTeaFg^".wevVPastryCrumbBloomRestored, title: "SWtHr/aDw/bJe@r^reyB".wevVPastryCrumbBloomRestored, tintHex: "fzfT4+a!a/0?".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "f~rze;s!h~TFaxgL".wevVPastryCrumbBloomRestored, title: "F,rdeSsDhb".wevVPastryCrumbBloomRestored, tintHex: "fj5Nbz4y3Y1%".wevVPastryCrumbBloomRestored),
                WevVFrostingShopTag(glazeKey: "lYaTt/eHTIaXgi".wevVPastryCrumbBloomRestored, title: "LbaWthe+ qNuiAgShHto".wevVPastryCrumbBloomRestored, tintHex: "8lbp6H3uf?fx".wevVPastryCrumbBloomRestored)
            ],
            parlorTitle: "DOobnFu^tm xL,oNvCerrjsQ ;RUoAokmN".wevVPastryCrumbBloomRestored,
            parlorLine: "CDanfUeN ,sNo#f!t% yszh!osp^ EfVaen;sI,J XfIlGaEvjoEr! UtbaslckK,h +aonOdB /s,wte#e+tC ~pBiAc?kVsd".wevVPastryCrumbBloomRestored,
            parlorCrowdText: "2%8N =o!n/lQiLnyeA".wevVPastryCrumbBloomRestored,
            reviews: [
                WevVSprinkleReview(
                    sprinkleKey: "ahv~ajBdebrcrkyMBtiAtJey".wevVPastryCrumbBloomRestored,
                    tasterName: "Apvmav".wevVPastryCrumbBloomRestored,
                    tastingRole: "COaMfte@ Cegxhp.lEonr*e~rd".wevVPastryCrumbBloomRestored,
                    crumbScoreText: "4B.g8q".wevVPastryCrumbBloomRestored,
                    biteText: "L;ohvoeSdv ZtXh=eZ es:t*r?abwLbWexrdrtyo XrWi!n~gk na@nUdl ytvhCe, ncao:zJyQ kp,innIk:.L.x.O".wevVPastryCrumbBloomRestored,
                    badgeText: "Cguztce= WVuiObnePs;".wevVPastryCrumbBloomRestored
                ),
                WevVSprinkleReview(
                    sprinkleKey: "jPa+sqo+nYCqlVaBsus%i^c!CCrauOmDbh".wevVPastryCrumbBloomRestored,
                    tasterName: "Jda.spoRn&".wevVPastryCrumbBloomRestored,
                    tastingRole: "DooSnNuhta Tc*oRl&lve+c/tGobrU".wevVPastryCrumbBloomRestored,
                    crumbScoreText: "4y.%6j".wevVPastryCrumbBloomRestored,
                    biteText: "Tmhse@ KoHrQiLgkian%ael, qgvlValzHer wibss lbJultmt.e*rUy^ paJnGdv /fUlWunfUf,yO.; UFur;iyejnY.c.i.#".wevVPastryCrumbBloomRestored,
                    badgeText: "BreLs%tk MCNlJarsLsui&cq".wevVPastryCrumbBloomRestored
                )
            ],
            morePicks: [
                WevVSugarShopPick(
                    sugarKey: "cblpofu^dISVpvrliLnck^l,etPsiwc~kY".wevVPastryCrumbBloomRestored,
                    title: "CUlgo,uIds PS%p#rzi;nskIlne*".wevVPastryCrumbBloomRestored,
                    addressLine: "4F5p rV?azlTepn;cpiOa. uSAt,,. ASHaInZ SF;roazn!cWiXsGc:og,C uCXAq".wevVPastryCrumbBloomRestored,
                    crumbScoreText: "4A.O6W".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_golden_dough_studio"
                ),
                WevVSugarShopPick(
                    sugarKey: "mneYlRlpoKw^DVo*ujgzhNPfinc/kA".wevVPastryCrumbBloomRestored,
                    title: "MLe@lOl?oOwJ kDhoRu%gMhs".wevVPastryCrumbBloomRestored,
                    addressLine: "2H1E2g PP:iqnHek lAKvjeS,H ROoa=k;lSafnZdR,T :CgAm".wevVPastryCrumbBloomRestored,
                    crumbScoreText: "4#.*8&".wevVPastryCrumbBloomRestored,
                    coverAsset: "wevv_shop_moonlight_donut_bar"
                )
            ]
        )
    }

    private func allGlazeShopDetails() -> [WevVGlazeShopDetail] {
        glazeShops.map { makeGlazeShopDetail($0) }
    }

    @objc private func openChallengeDetail(_ sprinkleSender: UIControl) {
        let sprinkleKey = sprinkleSender.accessibilityIdentifier ?? ""
        let selectedChallenge = sprinkleChallenges.first { $0.sprinkleKey == sprinkleKey } ?? sprinkleChallenges[0]
        let controller = WevVFrostingChallengeController(challenge: selectedChallenge)
        controller.onChallengedonutChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        WevVBakeryExchange.spin(in: view, note: "OypleUn#iRnzgJ jcfhOawlzlEewn+g$eO.G.A.o".wevVPastryCrumbBloomRestored) { [weak self] in
            self?.present(controller, animated: true)
        }
    }

    private func presentProtectedGate() {
        guard glazeSession.isTasterReady else {
            let gate = WevVFrostingGateController()
            gate.onGlazeReady = { [weak self] in
                self?.refreshSugarProfilePanel()
                self?.dismiss(animated: true)
            }
            gate.modalPresentationStyle = .pageSheet
            present(gate, animated: true)
            return
        }
    }

    private func switchDonutSection(_ section: WevVDonutMainSection) {
        activeDonutSection = section
        let showHome = section == .glazeHome
        if section == .sugarProfile {
            refreshSugarProfilePanel()
        }
        glazeHomePanels.forEach { $0.isHidden = !showHome }
        frostingDiaryPanels.forEach { $0.isHidden = section != .frostingDiary }
        frostingDiaryPanel.isHidden = true
        frostingPostEntryButton.isHidden = section != .frostingDiary
        sugarProfilePanel.isHidden = section != .sugarProfile
        donutContentFootTopConstraints.values.forEach { $0.isActive = false }
        donutContentFootTopConstraints[section]?.isActive = true
        for (tabSection, icon) in donutTabIcons {
            let tabAssets = donutTabAssetTrail[tabSection]
            let asset = tabSection == section ? tabAssets?.active : tabAssets?.idle
            icon.image = UIImage(named: asset ?? "")
            icon.alpha = tabSection == section ? 1 : 0.5
            icon.transform = tabSection == section ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
        }
    }

    private func startGlazeCarouselTimer() {
        stopGlazeCarouselTimer()
        let timer = Timer(timeInterval: 1.5, target: self, selector: #selector(advanceGlazeCarousel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        glazeCarouselTimer = timer
    }

    private func stopGlazeCarouselTimer() {
        glazeCarouselTimer?.invalidate()
        glazeCarouselTimer = nil
    }

    private func showInitialBakeryExchangeIfNeeded() {
        guard !didShowBakeryExchange else { return }
        didShowBakeryExchange = true
        WevVBakeryExchange.spin(in: view, note: "R?emfvrUe%sGhxisnbgG Tb;aCk:eqr!y& ?d#ahtIap.$.X.c".wevVPastryCrumbBloomRestored, delay: 0.42)
    }
}

extension WevVDonutRootController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === shopCarousel, shopCarousel.bounds.width > 0 else { return }
        let page = Int(round(shopCarousel.contentOffset.x / shopCarousel.bounds.width))
        shopDots.currentPage = max(0, min(glazeShops.count - 1, page))
    }
}
