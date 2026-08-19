import Foundation

struct WevVGuestGlazePost {
    let sugarDustKey: String
    let glazeScoutline: String
    let crumbText: String
}

struct WevVGuestGlazeTie {
    var isGlazeFollowed: Bool
    var isSprinkleFan: Bool
    var isSugarShielded: Bool
}

struct WevVGuestGlazeProfile {
    let donutPinKey: String
    let cocoaCounter: String
    let trailQuest: String
    let donutFrameAsset: String
    let flavorNotes: [WevVGuestGlazePost]
    let counterScout: [String]
    let sweetMarkCount: Int
    let glazeTrailCount: Int
    let sprinkleTasterCount: Int
    var sugarTie: WevVGuestGlazeTie
}

private func makeGuestSugarPost(_ sugarDustKey: String, _ sugarTitle: String, _ crumbText: String) -> WevVGuestGlazePost {
    WevVGuestGlazePost(sugarDustKey: sugarDustKey, glazeScoutline: sugarTitle, crumbText: crumbText)
}

private func makeGuestSugarTie(glazeFollowed: Bool, sprinkleFan: Bool, sugarShielded: Bool = false) -> WevVGuestGlazeTie {
    WevVGuestGlazeTie(isGlazeFollowed: glazeFollowed, isSprinkleFan: sprinkleFan, isSugarShielded: sugarShielded)
}

final class WevVGuestGlazeStore {
    static let shared = WevVGuestGlazeStore()

    private let frostingDefaults = UserDefaults.standard
    private let crullerScout = "wzeyvIvF_bgpl:afzoe/_LgfuMessJt/_Qf:o?lOlboVwzeYdX".wevVPastryCrumbBloomRestored
    private let shieldedKey = "wleOvhvw_mgSlHa#zIe+_wgfuWers&tf_Lsxh&iheTldd%efdy".wevVPastryCrumbBloomRestored

    private let basefillingSample: [WevVGuestGlazeProfile] = [
        WevVGuestGlazeProfile(
            donutPinKey: "jaaImOiPeoC+oslveh".wevVPastryCrumbBloomRestored,
            cocoaCounter: "JSawmVikeL kCQoHlKeC".wevVPastryCrumbBloomRestored,
            trailQuest: "Stand-up Comedian\nBrooklyn · 6 years on stage",
            donutFrameAsset: "wevv_guest_glaze_mira",
            flavorNotes: [
                makeGuestSugarPost("jnahmtiAe#PEoowFdneNrQOTnce&".wevVPastryCrumbBloomRestored, "PkoewRd+ehr~ @RPi!nDg= zSWpro^tmloibgVhat,".wevVPastryCrumbBloomRestored, "A~ PwUa@r%mi Mr~iWn!g% ^wUiOtHh! fcTlCeza=nb ks=uCg%ahr# Pd,uvshtg.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("j:admHi*eEB^epr+rny/TswToc".wevVPastryCrumbBloomRestored, "BpeurwrPyc fSytPa?gIeg cBci.tied".wevVPastryCrumbBloomRestored, "SQwleLeFtP @gtlka#zKea Wbwe^fSoerJew &aJ ut=iQnZyh !tyacs+tdimn+gc zsheHtV.k".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["N%e*wncPobmheirx CC^oemCe^dfy% sCYlduzb#".wevVPastryCrumbBloomRestored, "ShtloKr+ymttealYlXiynlg; RA:f/tUekrm UD?aKrkkA".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 60,
            glazeTrailCount: 33,
            sprinkleTasterCount: 120,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "lPowuyiwsoeMS/aNnWtnoZsk".wevVPastryCrumbBloomRestored,
            cocoaCounter: "LXoGuPizs;eD cS;aqnWtboDsl".wevVPastryCrumbBloomRestored,
            trailQuest: "GDoFl*dFetnV !rTidnvgDsD,b Hbie;ryrKyB tgPlAa#zfeo,k ;aNncds zcDoNzEyg us&hWo?pV jnUowthejs/.Q".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_luna",
            flavorNotes: [
                makeGuestSugarPost("l#oru@iUs=e&SHwyeQektyOcnZeQ".wevVPastryCrumbBloomRestored, "Orn&ea =ByidtKe+ zG*lKovwK".wevVPastryCrumbBloomRestored, "A? @bFrtiSgghStZ Fsbhxocp# ssxtKoXpJ RwAi;twhx gaM ,sBoXfPtQ Nszt&r&aUw,bvetrmrEyJ zrKimnMgh.L".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("l^o!uzifs=e*STwNeSeYtuT^wSoX".wevVPastryCrumbBloomRestored, "W~eDepkzeInid? %TyrgaCyD".wevVPastryCrumbBloomRestored, "FJrVeLsphj ~dmoNuygThl ymQaZd^ek ttmhKeI ow=h#oqljeR MmEoCrmnHidnZg/ fwWafrbmTeurx.A".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["POixn?kt SDuojn@upt, WDsaSyw".wevVPastryCrumbBloomRestored, "SDtgrnaNwwbSeXr@r%yf &WheVeLkg".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 214,
            glazeTrailCount: 58,
            sprinkleTasterCount: 930,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "mgaBsaoyn~Gilfa=zheLSAmZiolheM".wevVPastryCrumbBloomRestored,
            cocoaCounter: "MPaSsao=nD PRqexeQd?".wevVPastryCrumbBloomRestored,
            trailQuest: "SepVrtiGnAkklOe~ PjyoTkeewsV,! &b:rli^gyhWtD dpmh+ogtqoIsf,o Pa=nBd: osGoTf,tu CbFi!tyegsg.:".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_arlo",
            flavorNotes: [
                makeGuestSugarPost("mpaesgoYnwPTi/nbkMOnnfew".wevVPastryCrumbBloomRestored, "PpienCk^ @CTo%uJnmt=ezr% ETfrOiAcxkH".wevVPastryCrumbBloomRestored, "H:e=ltdR aai AtziPnhyb Hrii@nMgK GlzimkUeI zaF UtVryowpwh!yR.Z".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("mQazsao!nLPSi?nBkeTOwGoS".wevVPastryCrumbBloomRestored, "FNr+eYsVhD oTOrVajyc eSumIiMlQek".wevVPastryCrumbBloomRestored, "TThIe= ww:h=o&lueJ ^bxodxc Rs;mle~l^l@eAdO NlPitk%e= pw^ajr%ma EvoaOnFitlblaaF.W".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["D/odnkuTtx cohfY rt*hSeD hDsa#yh".wevVPastryCrumbBloomRestored, "Svp&rniEn^kplIew FSBtsyRlteq".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 365,
            glazeTrailCount: 76,
            sprinkleTasterCount: 1420,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "aDvmaMCdo+ccosaBRTiynyge".wevVPastryCrumbBloomRestored,
            cocoaCounter: "A~vVaE dCLo.cSolaG".wevVPastryCrumbBloomRestored,
            trailQuest: "C.hYo^c/oVlLaxtreD bgtlpaTzeeX rwiiPt*hn ysGuSnBsqhLiZn+ey Faon!dO =s:oGf=tW VcbrIuWm=bJs=.m".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_nova",
            flavorNotes: [
                makeGuestSugarPost("abvWa@C=oqcpoUa.Ojn^ej".wevVPastryCrumbBloomRestored, "CohYohctoVliaktHeA ED^adyO".wevVPastryCrumbBloomRestored, "Aq ngOluo,sEscy! ^twoGpp jajnWdU ~a# ^mWe?lel:o@wN qddo#uWgIhj Dfpign%iOsnh&.B".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("a@vwaYCJo=c%oMazTVwjon".wevVPastryCrumbBloomRestored, "OxrVacnpgdeK jW.awlLlp LTxrcewaVtN".wevVPastryCrumbBloomRestored, "Bjr%iog%hUt: dc#oklYo!rj emYaxdveq jtwhweJ .caoScAozaJ MsihCiVnSel.I".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["D@oLnMu/tX #&T +CkohftfKeSe~ UMZaCtSchhk".wevVPastryCrumbBloomRestored, "FZiIrHs*t/ CBai?tLeZ nRgeyazcotuivoWnR".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 188,
            glazeTrailCount: 44,
            sprinkleTasterCount: 780,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "b&eKlvlMaCS~purYiKnVkHl!eI".wevVPastryCrumbBloomRestored,
            cocoaCounter: "B?eElolqae aSgpirii.ndkcllep".wevVPastryCrumbBloomRestored,
            trailQuest: "W%eBefk@e;nhdg idEoWnFu@tQ ywWamlJlnsp oann&dj bc+o.l%ocrp-ffKi/l&l:eYdA VtGaPshtIiCnzgS mbioyacrNdlso.c".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_poppy",
            flavorNotes: [
                makeGuestSugarPost("b@eolSlYaSWfaxl#lqOVnxea".wevVPastryCrumbBloomRestored, "Woefe^koe^nZds ZR&iRnsgm HWsaKl%la".wevVPastryCrumbBloomRestored, "P.iwc~kceVdY qas qfVrceWs,h= mtBrIafyH DfQoRrk Zt!hOey *fni:rqs,tt ,sgufnNn?yx mbdrGega#km.R".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bXeqlZl,a#WUaClslcTRw,o@".wevVPastryCrumbBloomRestored, "COovnpfTestVtWig PB*oIxS".wevVPastryCrumbBloomRestored, "Exv!e/rGy? FtuoSp@pmi@nDgf gh+aHdV sar xtZiYnbyN +cDr&u?nvcChT.F".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["Smpmr=ibnxkIl,e* tSbtVyxlZeK".wevVPastryCrumbBloomRestored, "P%iYnxkq #DvoHnBuctK PDuaoyV".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 241,
            glazeTrailCount: 69,
            sprinkleTasterCount: 1110,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "mfiMaKP?i=nSk@Svukg?acrK".wevVPastryCrumbBloomRestored,
            cocoaCounter: "MVi#aj qPmiRn/kc".wevVPastryCrumbBloomRestored,
            trailQuest: "TOienMyx CphiEnwkC WsJwveYentanxexsnsc ZaMn.dA YsQorfsth FcXrie:a!mM-rfgi!lTlFeMd& ArjoyuZneddsD.e".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_rhea",
            flavorNotes: [
                makeGuestSugarPost("mJi@ajPrignYk%O!nje@".wevVPastryCrumbBloomRestored, "P=iKnXkV .S;wNeUeVtpnee#sdsr".wevVPastryCrumbBloomRestored, "AF ylpiJtDtjl@eF EgslGaJzbes Tt?u@rmnceud/ jt^hMeR Nd@a*ym kayrZoiuun+dI.x".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("m,iGaXPcixn*kcT^wnoq".wevVPastryCrumbBloomRestored, "CyrbedaSmk %R@oTuGnJdg".wevVPastryCrumbBloomRestored, "Ssm^o:oStKhX UfbiylSlhiCnGgX !wmiZtchA xaj ?gJe%nHtglcex YsHuUgpafr= JfQi.nQiNs/hz.T".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["F/i+rUsttN ~B,i,tSeL bRFeOa,c;tGiUoXn!".wevVPastryCrumbBloomRestored, "S:tTrYaxw!bKeOrGrCy* GW@ete%kY".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 173,
            glazeTrailCount: 35,
            sprinkleTasterCount: 640,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "nTojr?anCorweSawm/R,i;n/gS".wevVPastryCrumbBloomRestored,
            cocoaCounter: "NHorrIad #CWrke:aWml".wevVPastryCrumbBloomRestored,
            trailQuest: "CfrOe,ajmO-ofqislWluePd* &rXiSnMgXsO,Y lp=rDeJt@t*yn Zt^rwacyYsX,p jahnfdS *sNorfgtu ,plhNoatDoq bnsoltCejsu.!".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_berry",
            flavorNotes: [
                makeGuestSugarPost("nkotr:abC;rFeAa,mSOvnNeu".wevVPastryCrumbBloomRestored, "CCrOexa/mG-aFkijlKluepd+ ZTsanb&l.e,".wevVPastryCrumbBloomRestored, "SUw+e/extp LrziznlgHsc Am#aWdteG faM *tVirn+y= odJedsbs/e+rltw HpoaHrEt*y?.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("n,o#rha@CVrXe=aAmcTqwsoq".wevVPastryCrumbBloomRestored, "Sju,gkaPr# YPNapiKrZ".wevVPastryCrumbBloomRestored, "TEwGoG Bt,oqp*p,i?n?g/sK,h DoCnIe% iblrZiigNhltJ qayfSttefrCn:oYognv.j".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["D+okn;uYt@ Ro~fK GtDhfeu oDza:yO".wevVPastryCrumbBloomRestored, "D!osnxu~tt h&Y WC%orfkfzeRe! zMOartjc/hU".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 209,
            glazeTrailCount: 47,
            sprinkleTasterCount: 870,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "m;i=rUaKPkuHrRpElEemG:lmaYzHes".wevVPastryCrumbBloomRestored,
            cocoaCounter: "Mjiwrta+ SV!aKlieW".wevVPastryCrumbBloomRestored,
            trailQuest: "Puo.wMdqe@rBeOda Xrji^nZgdsE,Z aqRu#iPeTtd ,bUoyo.tXhRsx,& iaYnEd@ HbIewr~rxyr vgXl+aUzjex tn:oCtae/sK.t".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_mira",
            flavorNotes: [
                makeGuestSugarPost("mhilrVa:PRoCwjdIeSrcObnrei".wevVPastryCrumbBloomRestored, "PbuIr?pHleeN hSgmXimlEeT TRluPnt".wevVPastryCrumbBloomRestored, "FVoUujn?dz FaL nt?iMnMyx WsuhJoip@ owNiatdhj ll=asvfernFdCe@rC FiUcAi*nsgK.e".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("m~iZrBaUPCoiwqdWedrjTiwpos".wevVPastryCrumbBloomRestored, "LNa@tOeh TFOrkoPsIt,i!n/g+ lB#ibtveu".wevVPastryCrumbBloomRestored, "S.oXfDtx ldpoVukgDhc oaffItseMr& ssQu!n*sye,tJ ntyazsptqe*sn IboeNtWtgerrX.#".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["SmtQr*a/wob@ecrDrnyS GW~ebebk+".wevVPastryCrumbBloomRestored, "GRlMa=zVej qTEr?aNilly".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 128,
            glazeTrailCount: 42,
            sprinkleTasterCount: 810,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "l;uSnBaHLFaIu:gPhsGOlVauzKeF".wevVPastryCrumbBloomRestored,
            cocoaCounter: "LTuhnta% DH,aErJta".wevVPastryCrumbBloomRestored,
            trailQuest: "I+ Gr&aotEeL Ss&pbrVinnokSlHeBs* Zbdyr ^cVrAuRn:c^hI PaNn%d~ Gc=o~lzolrG.Q".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_luna",
            flavorNotes: [
                makeGuestSugarPost("l:u%nvatCjrFuBnOc~hCO^nwe~".wevVPastryCrumbBloomRestored, "PKi+nykE ?CDoQu,nStge%r& %JKo/yD".wevVPastryCrumbBloomRestored, "TMh=e= NsTt^rda+wpbaedrZr*yD WsehveYlJlD lcxr?aUcukSepdi rpTeKr^fdeHcdtxlMyN.n".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("liumnfaECMr#u^nFcdheTUw~of".wevVPastryCrumbBloomRestored, "C?r%eaalmn YT:rMaki^lN".wevVPastryCrumbBloomRestored, "MfaupNlPeU agplPaJz^eC usAt^i#l=lk Flte@aKdxsr smEyu %lRiasltN.?".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["M=aKpglmeM VDHapsIh~".wevVPastryCrumbBloomRestored, "SZu,gjaNr; EBVoYoVtWhw".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 232,
            glazeTrailCount: 65,
            sprinkleTasterCount: 1240,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "n;oovzatBauSbVbjlde@G:lOavzceD".wevVPastryCrumbBloomRestored,
            cocoaCounter: "NqonvZad ,FbiSn#cRho".wevVPastryCrumbBloomRestored,
            trailQuest: "TqiUnJyU +s:hDoKpKsD,T lbTrdiQgrhEtR /fziElolyirnegusi,% &nFeOa+tO qtzaMs:tGiZn@g= xnzogtbecsP.e".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_nova",
            flavorNotes: [
                makeGuestSugarPost("n@ofvEaVPbe~avrYl%OKnKew".wevVPastryCrumbBloomRestored, "Gzl@aLzKeJ JW:iDnFdvo:wa".wevVPastryCrumbBloomRestored, "AW qcclXaVsEs*iHc! Grfi.n%gd ?wHi/t@hT fr/aYswp:bLeKrxr&ye #dtuosxtO.N".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("nio^vlagPae^abrYlET^wsos".wevVPastryCrumbBloomRestored, "SZo+fVtt /Bcadtmc@hi".wevVPastryCrumbBloomRestored, "WYaRr@mF #dgoquwgIhQ VcahDaFnqg@etds ctShGeM KwXh,oBlHeV BsPcWo/r,eN.x".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["SUtUr%auwvb:eNr&r=y% VWseVewkS".wevVPastryCrumbBloomRestored, "CYo#cToCal xRioIu!nndz".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 94,
            glazeTrailCount: 28,
            sprinkleTasterCount: 520,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "sko*rvaYCcrLePaSmLGnlya^zSeQ".wevVPastryCrumbBloomRestored,
            cocoaCounter: "S/oFrtau lLdaynqen".wevVPastryCrumbBloomRestored,
            trailQuest: "CTuPsftxaprTdu if~iDrosRt=,r Yf%rPo~sat;i:nVgJ :sge^c@ocnPdQ,O !cPrOukmkb#s! IaoliwUakyJsZ octoFuZn.t+eMd?.S".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_sora",
            flavorNotes: [
                makeGuestSugarPost("s;o.rCaYCauosNt=ayrudiOPnyef".wevVPastryCrumbBloomRestored, "CQuhsot,akr:du QC@oLrznje&rw".wevVPastryCrumbBloomRestored, "VNaAnbiYl:lOak Zcle?nvtReCrA cwBaEsi dsqmco.oUtFhM oa@n!d& xlfi=g!hTty.Z".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("sXojr*aoCAu*sttKa%rMd;T.waop".wevVPastryCrumbBloomRestored, "G;oslTdceAnM kCBaqsGeI".wevVPastryCrumbBloomRestored, "Bae.s:t+ kbgaktNc*hw RsWaVtt Vofny Gt+h,ej jtoompP ~sjhWe#lmf+.J".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["CQuqszt!a&rTd: .M^a%pL".wevVPastryCrumbBloomRestored, "GtlXa;ztev STxroaNiTlm".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 76,
            glazeTrailCount: 19,
            sprinkleTasterCount: 330,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "d%ovobdklUejMKiWnDt.GYlEa!zHeY".wevVPastryCrumbBloomRestored,
            cocoaCounter: "D*oOo^dYleeb QMaiunetl".wevVPastryCrumbBloomRestored,
            trailQuest: "Cqa;r!t:o:oZnd EcQr:u:mXbosq paRnFdR zs%u?g&avr/ XsmkYeGtxc%hme@sb.Z".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_doodle",
            flavorNotes: [
                makeGuestSugarPost("dyoSobdblperSUkkeUtKcJh^O;n#eu".wevVPastryCrumbBloomRestored, "BOlsuMer .FkrcoFs#tZijn=ga gMNobogdz".wevVPastryCrumbBloomRestored, "DrrFe:wq ~tdhse! Vf;uSnTn+ixeZsLtU Od=o,nnuQto ;w,r#a=pJp;eorO.U".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("droBo.dflMedStkzestXc~hETGw^of".wevVPastryCrumbBloomRestored, "TciGnAy@ LB/iCtCe+ YL+oHgK".wevVPastryCrumbBloomRestored, "RNoYudn.d,,v ,sswze:egtI,T AaanhdY .n&iIcoeJlMyT Uugnke:vZe&nw.?".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["SLutgoaZrt TBAouoZtjhS".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 51,
            glazeTrailCount: 12,
            sprinkleTasterCount: 244,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "aZrql:oQSOk*yeGSl/aczheW".wevVPastryCrumbBloomRestored,
            cocoaCounter: "AirSljo@ aRfe.e*d=".wevVPastryCrumbBloomRestored,
            trailQuest: "BblnuJev-+s#kwy% VtMa~s/tQiNntgz /rzuHness aaanfdE ecfozcVoHaN sgplaaSz?eg JsrtEoDp.s%.J".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_arlo",
            flavorNotes: [
                makeGuestSugarPost("aDrTl+oNSGkXyUOanked".wevVPastryCrumbBloomRestored, "MCoxr,nniHnpga ,CNaHs#eX".wevVPastryCrumbBloomRestored, "Tshbe; vf,itrssltk JtLr;aXy. CwVa*sv SsWt.iVlBlx Rwva/r?mn.a".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("aqr%lpomSGklyjTlwIoz".wevVPastryCrumbBloomRestored, "CMoRcJoOaF GD.ufs^tr".wevVPastryCrumbBloomRestored, "DOatrikb rtnoOpSpTiknmgz,v ;s=o,fftk mcHe*n.t,eerF,c pcRl;eTa?ni =fUi?ndiMsph:.#".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["CJoQcsoda& URoonu~nmdT".wevVPastryCrumbBloomRestored, "MEaop@lteZ eDNa#schF".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 143,
            glazeTrailCount: 37,
            sprinkleTasterCount: 690,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "p^olppp:yLSvu+nHGulWa?zveY".wevVPastryCrumbBloomRestored,
            cocoaCounter: "PTowpipByB bWleDlHllsO".wevVPastryCrumbBloomRestored,
            trailQuest: "SVumnsn?yE FbYigtEeksV Iaynodv ks.o:uyrs Abwe+ryroyj &fgibljlyiAnegu Jh:uMnrtos^.,".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_poppy",
            flavorNotes: [
                makeGuestSugarPost("p,olpbp:yPSBuHnuOknIef".wevVPastryCrumbBloomRestored, "StkGyD !BBaWtGcghq".wevVPastryCrumbBloomRestored, "L,e~mQoUnb ?gdl:aNz:eM lw:a:s% =smh;aerQpG fidn: ba@ Pgfotomdl %wXaoyZ.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("pUoMpVpYy/SzuCnbTBwHo?".wevVPastryCrumbBloomRestored, "B;eXr*r*yC ?T,ibc^kMeCtV".wevVPastryCrumbBloomRestored, "T;hFez dfXiFlClSiJnkgj uh=amdh kal JbCr=i,gjh;t& rl+iwtctIl?eP +kgiKcdkW.E".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["L+egmVozny eLQoPoppt".wevVPastryCrumbBloomRestored, "SYtsrwa#wrbyexrRrsyC =Wxe#eKkJ".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 187,
            glazeTrailCount: 53,
            sprinkleTasterCount: 980,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "ruhae=a=HgoynueYyJGbl#aJzpeB".wevVPastryCrumbBloomRestored,
            cocoaCounter: "R@hDeOa= AB.lwoFoxmt".wevVPastryCrumbBloomRestored,
            trailQuest: "HsoTnlekyJ qr/i,n?gUsW,g ~s=o+fstp ;s~lkeqemvje#sE,y PaPnId+ dpIr:e:tFtBy~ Esuujg^aerM Mtargalinlusw.x".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_rhea",
            flavorNotes: [
                makeGuestSugarPost("rmhheca@H/oFnMePyqOkn:ea".wevVPastryCrumbBloomRestored, "HBoNnKefyF #P~aPiOr/".wevVPastryCrumbBloomRestored, "AQ Xm+iZlBd: JgblXahz/eu Qw,imt*hi DaV LfPlRo.rHaElG Xffi~nti!s&hD.w".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("rzhvejabHdornYehyQTVweoI".wevVPastryCrumbBloomRestored, "WTiBnJdvoewg VSAeBaXtY".wevVPastryCrumbBloomRestored, "As ^gHonoCdz +d/oanMuqtt Pd?e,s/ewrlvreasp vsUl*ouwB tn&oVtAeCs@.?".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["Hlo.nieVyH sW=eseVki".wevVPastryCrumbBloomRestored, "G/l:ajzdex VTFr+a^i@lk".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 205,
            glazeTrailCount: 73,
            sprinkleTasterCount: 1510,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "b*lWa+i#rbBeljuPe&GvlsaJzbel".wevVPastryCrumbBloomRestored,
            cocoaCounter: "B?lWaZigr& NKtlRiVnwen".wevVPastryCrumbBloomRestored,
            trailQuest: "BMlcuZeK Ah/onoHdy,? PwqafrRmO Dc&uFpY,: rcHiknPnLaumFo~nG ysWu@gva#rY.n".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_blair",
            flavorNotes: [
                makeGuestSugarPost("b+l+a#iFr!Ccu&p^Oenhe.".wevVPastryCrumbBloomRestored, "CiiMnVn:aNmcoqn^ qCwu:p;".wevVPastryCrumbBloomRestored, "COrtuOnicnh?yE peYdlgreQ,o taFifrUyK ycme,notTe=r!.=".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bcliaEiarDC&uEpETowUox".wevVPastryCrumbBloomRestored, "PyozwBdoevrj HSqtqoepi".wevVPastryCrumbBloomRestored, "THhOe? UsouWgia=rG XsBtruqczkD At*oj OeDv,e&royetEhMi!nKgG.?".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["CeiVnwn=aVmAoonk yPaaktxh;".wevVPastryCrumbBloomRestored, "Sgu&g^aQrt sBdoZo&tMhC".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 118,
            glazeTrailCount: 31,
            sprinkleTasterCount: 730,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "vCeWlpvAest.SutoaAgKefGpl=aDzxeR".wevVPastryCrumbBloomRestored,
            cocoaCounter: "Voegl^voeLtb lR*oeo.kY".wevVPastryCrumbBloomRestored,
            trailQuest: "BpoVlddq vlBoaobk#sD,s kbMoOlRdL zfhrToksbtuiPn&gR,b rnBor adqumlUl/ ebHi=t+e&sa.g".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_velvet",
            flavorNotes: [
                makeGuestSugarPost("vTeylhv:e~teSYtnazgRehOgnde*".wevVPastryCrumbBloomRestored, "RPuhn&wlauyf ;R?iEnpg/".wevVPastryCrumbBloomRestored, "BhlraXccko Vs@e/s&aem#eh ygXlPa%zgeo ,wMansM bdbe/enpc gaRn;dD ssSmKoIo;tkhL.?".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("v.e^l;v*eQtlSJtPaNgte?T:wNog".wevVPastryCrumbBloomRestored, "SpploTtBl@idg@hBt! RBQijtkeg".wevVPastryCrumbBloomRestored, "A* Mc;rXi!sWp& qsRhJetl^lY !orvkeZrQ hs@oEfRtv VdVo;uBg/h..*".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["CvoXcJoSaJ aR#o#umnKd%".wevVPastryCrumbBloomRestored, "HtonnXejyA WW~exeaku".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 166,
            glazeTrailCount: 45,
            sprinkleTasterCount: 860,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "cxarrJa:m+e=lbFRe?r~nFGGl+a%zDeM".wevVPastryCrumbBloomRestored,
            cocoaCounter: "CXaur?avmneOlZ #FyeBrynO".wevVPastryCrumbBloomRestored,
            trailQuest: "CSa:rXaxmMeMlu rcru!r+lPs& FaMnGd? /n?uxtitQyO lgElCaSzleb ;nnoPtKecsu.w".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_caramel",
            flavorNotes: [
                makeGuestSugarPost("cUa*raaXmNeSlKCeuOr.lTONnUej".wevVPastryCrumbBloomRestored, "Bpr&oVwhnq =SguQgfaMrq =CIaHsJe~".wevVPastryCrumbBloomRestored, "SjtyilcskbyO Atroopo,Q JmGe%lDlUoEwC ofLi+nbiCsuhm.C".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("cuahrea&mxefleCDuhrHlDT+wnod".wevVPastryCrumbBloomRestored, "NWuLtJtFyB NBTooxJ".wevVPastryCrumbBloomRestored, "TioEaVsWtleYdF fpgihe+cfe?sv hmuamdVe~ VtJhaej vbia/tScehl rsYiKnqgw.A".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["MfabpAl=e/ %DBassohX".wevVPastryCrumbBloomRestored, "HHo?n~e,yf :W&eOe/k^".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 97,
            glazeTrailCount: 22,
            sprinkleTasterCount: 410,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            donutPinKey: "bKeYrOrfy~CClMouujduG%lpajzXeb".wevVPastryCrumbBloomRestored,
            cocoaCounter: "Boe:rSrQym dC.loo&uyd,".wevVPastryCrumbBloomRestored,
            trailQuest: "BilSuFewbQearvrPy^ dfsi#lolriynJgw,~ Evma,nPiYlnlBaq ?c=ree^afm?,Z XghernFtIl#eP #sIc,oMr?eisA.r".wevVPastryCrumbBloomRestored,
            donutFrameAsset: "wevv_guest_glaze_berry",
            flavorNotes: [
                makeGuestSugarPost("b#e~rJr.yKC=lqo.ukd%ORnPeI".wevVPastryCrumbBloomRestored, "B!lOuReib;eerarByI KF,oRlKdf".wevVPastryCrumbBloomRestored, "TtaanwgryD bfwiHlelniznXgx PkKejpVtG ?tDhUe# Wb%iftdeQ ul~iqgEhlt,.*".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bPeqrwr~y=CYlZo@uDd?T%wSo;".wevVPastryCrumbBloomRestored, "C*rJe~aOmY lDrrli~f.tg".wevVPastryCrumbBloomRestored, "Vga+nviilJl@an AcNr;e~ahmO Kwpa.sj EsjoofgtQ sa+nEd% PcTlpeRaLns.n".wevVPastryCrumbBloomRestored)
            ],
            counterScout: ["B=ezror&yU ^LKocozpz".wevVPastryCrumbBloomRestored, "SotyrOa,wgbueArhrLy. &WHeieFkT".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 152,
            glazeTrailCount: 39,
            sprinkleTasterCount: 775,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        )
    ]

    var allProfiles: [WevVGuestGlazeProfile] {
        basefillingSample.map { glazeProfile in
            var donutDiary = glazeProfile
            donutDiary.sugarTie.isGlazeFollowed = nuttyQuestwevv.contains(glazeProfile.donutPinKey)
            donutDiary.sugarTie.isSugarShielded = shieldeddoughScoutline.contains(glazeProfile.donutPinKey)
            return donutDiary
        }
    }

    var glazeFollowingProfiles: [WevVGuestGlazeProfile] {
        allProfiles.filter { $0.sugarTie.isGlazeFollowed && !$0.sugarTie.isSugarShielded }
    }

    var sprinkleFanProfiles: [WevVGuestGlazeProfile] {
        allProfiles.filter { $0.sugarTie.isSprinkleFan && !$0.sugarTie.isSugarShielded }
    }

    var sugarShieldProfiles: [WevVGuestGlazeProfile] {
        allProfiles.filter { $0.sugarTie.isSugarShielded }
    }

    func profile(for donutPinKey: String) -> WevVGuestGlazeProfile {
        allProfiles.first { $0.donutPinKey == donutPinKey } ?? allProfiles[0]
    }

    func profile(at index: Int) -> WevVGuestGlazeProfile {
        let profiles = allProfiles
        return profiles[abs(index) % profiles.count]
    }

    @discardableResult
    func toggleGlazeFollow(for donutPinKey: String) -> Bool {
        var sugarKeys = nuttyQuestwevv
        if sugarKeys.contains(donutPinKey) {
            sugarKeys.remove(donutPinKey)
        } else {
            sugarKeys.insert(donutPinKey)
        }
        frostingDefaults.set(Array(sugarKeys).sorted(), forKey: crullerScout)
        return sugarKeys.contains(donutPinKey)
    }

    @discardableResult
    func toggleSugarShield(for donutPinKey: String) -> Bool {
        var sugarKeys = shieldeddoughScoutline
        if sugarKeys.contains(donutPinKey) {
            sugarKeys.remove(donutPinKey)
        } else {
            sugarKeys.insert(donutPinKey)
        }
        frostingDefaults.set(Array(sugarKeys).sorted(), forKey: shieldedKey)
        return sugarKeys.contains(donutPinKey)
    }

    private var nuttyQuestwevv: Set<String> {
        Set(frostingDefaults.stringArray(forKey: crullerScout) ?? [])
    }

    private var shieldeddoughScoutline: Set<String> {
        Set(frostingDefaults.stringArray(forKey: shieldedKey) ?? [])
    }
}
