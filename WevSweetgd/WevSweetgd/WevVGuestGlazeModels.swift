import Foundation

struct WevVGuestGlazePost {
    let sugarKey: String
    let title: String
    let crumbText: String
}

struct WevVGuestGlazeTie {
    var isGlazeFollowed: Bool
    var isSprinkleFan: Bool
    var isSugarShielded: Bool
}

struct WevVGuestGlazeProfile {
    let glazeKey: String
    let name: String
    let signature: String
    let donutAvatarAsset: String
    let sugarNotes: [WevVGuestGlazePost]
    let joinedChallenges: [String]
    let sweetMarkCount: Int
    let glazeFollowCount: Int
    let sprinkleFanCount: Int
    var sugarTie: WevVGuestGlazeTie
}

private func makeGuestSugarPost(_ sugarKey: String, _ sugarTitle: String, _ crumbText: String) -> WevVGuestGlazePost {
    WevVGuestGlazePost(sugarKey: sugarKey, title: sugarTitle, crumbText: crumbText)
}

private func makeGuestSugarTie(glazeFollowed: Bool, sprinkleFan: Bool, sugarShielded: Bool = false) -> WevVGuestGlazeTie {
    WevVGuestGlazeTie(isGlazeFollowed: glazeFollowed, isSprinkleFan: sprinkleFan, isSugarShielded: sugarShielded)
}

final class WevVGuestGlazeStore {
    static let shared = WevVGuestGlazeStore()

    private let frostingDefaults = UserDefaults.standard
    private let followedKey = "wzeyvIvF_bgpl:afzoe/_LgfuMessJt/_Qf:o?lOlboVwzeYdX".wevVPastryCrumbBloomRestored
    private let shieldedKey = "wleOvhvw_mgSlHa#zIe+_wgfuWers&tf_Lsxh&iheTldd%efdy".wevVPastryCrumbBloomRestored

    private let baseProfiles: [WevVGuestGlazeProfile] = [
        WevVGuestGlazeProfile(
            glazeKey: "jaaImOiPeoC+oslveh".wevVPastryCrumbBloomRestored,
            name: "JSawmVikeL kCQoHlKeC".wevVPastryCrumbBloomRestored,
            signature: "Stand-up Comedian\nBrooklyn · 6 years on stage",
            donutAvatarAsset: "wevv_guest_glaze_mira",
            sugarNotes: [
                makeGuestSugarPost("jnahmtiAe#PEoowFdneNrQOTnce&".wevVPastryCrumbBloomRestored, "PkoewRd+ehr~ @RPi!nDg= zSWpro^tmloibgVhat,".wevVPastryCrumbBloomRestored, "A~ PwUa@r%mi Mr~iWn!g% ^wUiOtHh! fcTlCeza=nb ks=uCg%ahr# Pd,uvshtg.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("j:admHi*eEB^epr+rny/TswToc".wevVPastryCrumbBloomRestored, "BpeurwrPyc fSytPa?gIeg cBci.tied".wevVPastryCrumbBloomRestored, "SQwleLeFtP @gtlka#zKea Wbwe^fSoerJew &aJ ut=iQnZyh !tyacs+tdimn+gc zsheHtV.k".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["N%e*wncPobmheirx CC^oemCe^dfy% sCYlduzb#".wevVPastryCrumbBloomRestored, "ShtloKr+ymttealYlXiynlg; RA:f/tUekrm UD?aKrkkA".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 60,
            glazeFollowCount: 33,
            sprinkleFanCount: 120,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "lPowuyiwsoeMS/aNnWtnoZsk".wevVPastryCrumbBloomRestored,
            name: "LXoGuPizs;eD cS;aqnWtboDsl".wevVPastryCrumbBloomRestored,
            signature: "GDoFl*dFetnV !rTidnvgDsD,b Hbie;ryrKyB tgPlAa#zfeo,k ;aNncds zcDoNzEyg us&hWo?pV jnUowthejs/.Q".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_luna",
            sugarNotes: [
                makeGuestSugarPost("l#oru@iUs=e&SHwyeQektyOcnZeQ".wevVPastryCrumbBloomRestored, "Orn&ea =ByidtKe+ zG*lKovwK".wevVPastryCrumbBloomRestored, "A? @bFrtiSgghStZ Fsbhxocp# ssxtKoXpJ RwAi;twhx gaM ,sBoXfPtQ Nszt&r&aUw,bvetrmrEyJ zrKimnMgh.L".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("l^o!uzifs=e*STwNeSeYtuT^wSoX".wevVPastryCrumbBloomRestored, "W~eDepkzeInid? %TyrgaCyD".wevVPastryCrumbBloomRestored, "FJrVeLsphj ~dmoNuygThl ymQaZd^ek ttmhKeI ow=h#oqljeR MmEoCrmnHidnZg/ fwWafrbmTeurx.A".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["POixn?kt SDuojn@upt, WDsaSyw".wevVPastryCrumbBloomRestored, "SDtgrnaNwwbSeXr@r%yf &WheVeLkg".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 214,
            glazeFollowCount: 58,
            sprinkleFanCount: 930,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "mgaBsaoyn~Gilfa=zheLSAmZiolheM".wevVPastryCrumbBloomRestored,
            name: "MPaSsao=nD PRqexeQd?".wevVPastryCrumbBloomRestored,
            signature: "SepVrtiGnAkklOe~ PjyoTkeewsV,! &b:rli^gyhWtD dpmh+ogtqoIsf,o Pa=nBd: osGoTf,tu CbFi!tyegsg.:".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_arlo",
            sugarNotes: [
                makeGuestSugarPost("mpaesgoYnwPTi/nbkMOnnfew".wevVPastryCrumbBloomRestored, "PpienCk^ @CTo%uJnmt=ezr% ETfrOiAcxkH".wevVPastryCrumbBloomRestored, "H:e=ltdR aai AtziPnhyb Hrii@nMgK GlzimkUeI zaF UtVryowpwh!yR.Z".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("mQazsao!nLPSi?nBkeTOwGoS".wevVPastryCrumbBloomRestored, "FNr+eYsVhD oTOrVajyc eSumIiMlQek".wevVPastryCrumbBloomRestored, "TThIe= ww:h=o&lueJ ^bxodxc Rs;mle~l^l@eAdO NlPitk%e= pw^ajr%ma EvoaOnFitlblaaF.W".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["D/odnkuTtx cohfY rt*hSeD hDsa#yh".wevVPastryCrumbBloomRestored, "Svp&rniEn^kplIew FSBtsyRlteq".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 365,
            glazeFollowCount: 76,
            sprinkleFanCount: 1420,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "aDvmaMCdo+ccosaBRTiynyge".wevVPastryCrumbBloomRestored,
            name: "A~vVaE dCLo.cSolaG".wevVPastryCrumbBloomRestored,
            signature: "C.hYo^c/oVlLaxtreD bgtlpaTzeeX rwiiPt*hn ysGuSnBsqhLiZn+ey Faon!dO =s:oGf=tW VcbrIuWm=bJs=.m".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_nova",
            sugarNotes: [
                makeGuestSugarPost("abvWa@C=oqcpoUa.Ojn^ej".wevVPastryCrumbBloomRestored, "CohYohctoVliaktHeA ED^adyO".wevVPastryCrumbBloomRestored, "Aq ngOluo,sEscy! ^twoGpp jajnWdU ~a# ^mWe?lel:o@wN qddo#uWgIhj Dfpign%iOsnh&.B".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("a@vwaYCJo=c%oMazTVwjon".wevVPastryCrumbBloomRestored, "OxrVacnpgdeK jW.awlLlp LTxrcewaVtN".wevVPastryCrumbBloomRestored, "Bjr%iog%hUt: dc#oklYo!rj emYaxdveq jtwhweJ .caoScAozaJ MsihCiVnSel.I".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["D@oLnMu/tX #&T +CkohftfKeSe~ UMZaCtSchhk".wevVPastryCrumbBloomRestored, "FZiIrHs*t/ CBai?tLeZ nRgeyazcotuivoWnR".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 188,
            glazeFollowCount: 44,
            sprinkleFanCount: 780,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "b&eKlvlMaCS~purYiKnVkHl!eI".wevVPastryCrumbBloomRestored,
            name: "B?eElolqae aSgpirii.ndkcllep".wevVPastryCrumbBloomRestored,
            signature: "W%eBefk@e;nhdg idEoWnFu@tQ ywWamlJlnsp oann&dj bc+o.l%ocrp-ffKi/l&l:eYdA VtGaPshtIiCnzgS mbioyacrNdlso.c".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_poppy",
            sugarNotes: [
                makeGuestSugarPost("b@eolSlYaSWfaxl#lqOVnxea".wevVPastryCrumbBloomRestored, "Woefe^koe^nZds ZR&iRnsgm HWsaKl%la".wevVPastryCrumbBloomRestored, "P.iwc~kceVdY qas qfVrceWs,h= mtBrIafyH DfQoRrk Zt!hOey *fni:rqs,tt ,sgufnNn?yx mbdrGega#km.R".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bXeqlZl,a#WUaClslcTRw,o@".wevVPastryCrumbBloomRestored, "COovnpfTestVtWig PB*oIxS".wevVPastryCrumbBloomRestored, "Exv!e/rGy? FtuoSp@pmi@nDgf gh+aHdV sar xtZiYnbyN +cDr&u?nvcChT.F".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["Smpmr=ibnxkIl,e* tSbtVyxlZeK".wevVPastryCrumbBloomRestored, "P%iYnxkq #DvoHnBuctK PDuaoyV".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 241,
            glazeFollowCount: 69,
            sprinkleFanCount: 1110,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "mfiMaKP?i=nSk@Svukg?acrK".wevVPastryCrumbBloomRestored,
            name: "MVi#aj qPmiRn/kc".wevVPastryCrumbBloomRestored,
            signature: "TOienMyx CphiEnwkC WsJwveYentanxexsnsc ZaMn.dA YsQorfsth FcXrie:a!mM-rfgi!lTlFeMd& ArjoyuZneddsD.e".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_rhea",
            sugarNotes: [
                makeGuestSugarPost("mJi@ajPrignYk%O!nje@".wevVPastryCrumbBloomRestored, "P=iKnXkV .S;wNeUeVtpnee#sdsr".wevVPastryCrumbBloomRestored, "AF ylpiJtDtjl@eF EgslGaJzbes Tt?u@rmnceud/ jt^hMeR Nd@a*ym kayrZoiuun+dI.x".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("m,iGaXPcixn*kcT^wnoq".wevVPastryCrumbBloomRestored, "CyrbedaSmk %R@oTuGnJdg".wevVPastryCrumbBloomRestored, "Ssm^o:oStKhX UfbiylSlhiCnGgX !wmiZtchA xaj ?gJe%nHtglcex YsHuUgpafr= JfQi.nQiNs/hz.T".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["F/i+rUsttN ~B,i,tSeL bRFeOa,c;tGiUoXn!".wevVPastryCrumbBloomRestored, "S:tTrYaxw!bKeOrGrCy* GW@ete%kY".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 173,
            glazeFollowCount: 35,
            sprinkleFanCount: 640,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "nTojr?anCorweSawm/R,i;n/gS".wevVPastryCrumbBloomRestored,
            name: "NHorrIad #CWrke:aWml".wevVPastryCrumbBloomRestored,
            signature: "CfrOe,ajmO-ofqislWluePd* &rXiSnMgXsO,Y lp=rDeJt@t*yn Zt^rwacyYsX,p jahnfdS *sNorfgtu ,plhNoatDoq bnsoltCejsu.!".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_berry",
            sugarNotes: [
                makeGuestSugarPost("nkotr:abC;rFeAa,mSOvnNeu".wevVPastryCrumbBloomRestored, "CCrOexa/mG-aFkijlKluepd+ ZTsanb&l.e,".wevVPastryCrumbBloomRestored, "SUw+e/extp LrziznlgHsc Am#aWdteG faM *tVirn+y= odJedsbs/e+rltw HpoaHrEt*y?.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("n,o#rha@CVrXe=aAmcTqwsoq".wevVPastryCrumbBloomRestored, "Sju,gkaPr# YPNapiKrZ".wevVPastryCrumbBloomRestored, "TEwGoG Bt,oqp*p,i?n?g/sK,h DoCnIe% iblrZiigNhltJ qayfSttefrCn:oYognv.j".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["D+okn;uYt@ Ro~fK GtDhfeu oDza:yO".wevVPastryCrumbBloomRestored, "D!osnxu~tt h&Y WC%orfkfzeRe! zMOartjc/hU".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 209,
            glazeFollowCount: 47,
            sprinkleFanCount: 870,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "m;i=rUaKPkuHrRpElEemG:lmaYzHes".wevVPastryCrumbBloomRestored,
            name: "Mjiwrta+ SV!aKlieW".wevVPastryCrumbBloomRestored,
            signature: "Puo.wMdqe@rBeOda Xrji^nZgdsE,Z aqRu#iPeTtd ,bUoyo.tXhRsx,& iaYnEd@ HbIewr~rxyr vgXl+aUzjex tn:oCtae/sK.t".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_mira",
            sugarNotes: [
                makeGuestSugarPost("mhilrVa:PRoCwjdIeSrcObnrei".wevVPastryCrumbBloomRestored, "PbuIr?pHleeN hSgmXimlEeT TRluPnt".wevVPastryCrumbBloomRestored, "FVoUujn?dz FaL nt?iMnMyx WsuhJoip@ owNiatdhj ll=asvfernFdCe@rC FiUcAi*nsgK.e".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("m~iZrBaUPCoiwqdWedrjTiwpos".wevVPastryCrumbBloomRestored, "LNa@tOeh TFOrkoPsIt,i!n/g+ lB#ibtveu".wevVPastryCrumbBloomRestored, "S.oXfDtx ldpoVukgDhc oaffItseMr& ssQu!n*sye,tJ ntyazsptqe*sn IboeNtWtgerrX.#".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["SmtQr*a/wob@ecrDrnyS GW~ebebk+".wevVPastryCrumbBloomRestored, "GRlMa=zVej qTEr?aNilly".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 128,
            glazeFollowCount: 42,
            sprinkleFanCount: 810,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "l;uSnBaHLFaIu:gPhsGOlVauzKeF".wevVPastryCrumbBloomRestored,
            name: "LTuhnta% DH,aErJta".wevVPastryCrumbBloomRestored,
            signature: "I+ Gr&aotEeL Ss&pbrVinnokSlHeBs* Zbdyr ^cVrAuRn:c^hI PaNn%d~ Gc=o~lzolrG.Q".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_luna",
            sugarNotes: [
                makeGuestSugarPost("l:u%nvatCjrFuBnOc~hCO^nwe~".wevVPastryCrumbBloomRestored, "PKi+nykE ?CDoQu,nStge%r& %JKo/yD".wevVPastryCrumbBloomRestored, "TMh=e= NsTt^rda+wpbaedrZr*yD WsehveYlJlD lcxr?aUcukSepdi rpTeKr^fdeHcdtxlMyN.n".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("liumnfaECMr#u^nFcdheTUw~of".wevVPastryCrumbBloomRestored, "C?r%eaalmn YT:rMaki^lN".wevVPastryCrumbBloomRestored, "MfaupNlPeU agplPaJz^eC usAt^i#l=lk Flte@aKdxsr smEyu %lRiasltN.?".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["M=aKpglmeM VDHapsIh~".wevVPastryCrumbBloomRestored, "SZu,gjaNr; EBVoYoVtWhw".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 232,
            glazeFollowCount: 65,
            sprinkleFanCount: 1240,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "n;oovzatBauSbVbjlde@G:lOavzceD".wevVPastryCrumbBloomRestored,
            name: "NqonvZad ,FbiSn#cRho".wevVPastryCrumbBloomRestored,
            signature: "TqiUnJyU +s:hDoKpKsD,T lbTrdiQgrhEtR /fziElolyirnegusi,% &nFeOa+tO qtzaMs:tGiZn@g= xnzogtbecsP.e".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_nova",
            sugarNotes: [
                makeGuestSugarPost("n@ofvEaVPbe~avrYl%OKnKew".wevVPastryCrumbBloomRestored, "Gzl@aLzKeJ JW:iDnFdvo:wa".wevVPastryCrumbBloomRestored, "AW qcclXaVsEs*iHc! Grfi.n%gd ?wHi/t@hT fr/aYswp:bLeKrxr&ye #dtuosxtO.N".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("nio^vlagPae^abrYlET^wsos".wevVPastryCrumbBloomRestored, "SZo+fVtt /Bcadtmc@hi".wevVPastryCrumbBloomRestored, "WYaRr@mF #dgoquwgIhQ VcahDaFnqg@etds ctShGeM KwXh,oBlHeV BsPcWo/r,eN.x".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["SUtUr%auwvb:eNr&r=y% VWseVewkS".wevVPastryCrumbBloomRestored, "CYo#cToCal xRioIu!nndz".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 94,
            glazeFollowCount: 28,
            sprinkleFanCount: 520,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "sko*rvaYCcrLePaSmLGnlya^zSeQ".wevVPastryCrumbBloomRestored,
            name: "S/oFrtau lLdaynqen".wevVPastryCrumbBloomRestored,
            signature: "CTuPsftxaprTdu if~iDrosRt=,r Yf%rPo~sat;i:nVgJ :sge^c@ocnPdQ,O !cPrOukmkb#s! IaoliwUakyJsZ octoFuZn.t+eMd?.S".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_sora",
            sugarNotes: [
                makeGuestSugarPost("s;o.rCaYCauosNt=ayrudiOPnyef".wevVPastryCrumbBloomRestored, "CQuhsot,akr:du QC@oLrznje&rw".wevVPastryCrumbBloomRestored, "VNaAnbiYl:lOak Zcle?nvtReCrA cwBaEsi dsqmco.oUtFhM oa@n!d& xlfi=g!hTty.Z".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("sXojr*aoCAu*sttKa%rMd;T.waop".wevVPastryCrumbBloomRestored, "G;oslTdceAnM kCBaqsGeI".wevVPastryCrumbBloomRestored, "Bae.s:t+ kbgaktNc*hw RsWaVtt Vofny Gt+h,ej jtoompP ~sjhWe#lmf+.J".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["CQuqszt!a&rTd: .M^a%pL".wevVPastryCrumbBloomRestored, "GtlXa;ztev STxroaNiTlm".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 76,
            glazeFollowCount: 19,
            sprinkleFanCount: 330,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "d%ovobdklUejMKiWnDt.GYlEa!zHeY".wevVPastryCrumbBloomRestored,
            name: "D*oOo^dYleeb QMaiunetl".wevVPastryCrumbBloomRestored,
            signature: "Cqa;r!t:o:oZnd EcQr:u:mXbosq paRnFdR zs%u?g&avr/ XsmkYeGtxc%hme@sb.Z".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_doodle",
            sugarNotes: [
                makeGuestSugarPost("dyoSobdblperSUkkeUtKcJh^O;n#eu".wevVPastryCrumbBloomRestored, "BOlsuMer .FkrcoFs#tZijn=ga gMNobogdz".wevVPastryCrumbBloomRestored, "DrrFe:wq ~tdhse! Vf;uSnTn+ixeZsLtU Od=o,nnuQto ;w,r#a=pJp;eorO.U".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("droBo.dflMedStkzestXc~hETGw^of".wevVPastryCrumbBloomRestored, "TciGnAy@ LB/iCtCe+ YL+oHgK".wevVPastryCrumbBloomRestored, "RNoYudn.d,,v ,sswze:egtI,T AaanhdY .n&iIcoeJlMyT Uugnke:vZe&nw.?".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["SLutgoaZrt TBAouoZtjhS".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 51,
            glazeFollowCount: 12,
            sprinkleFanCount: 244,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "aZrql:oQSOk*yeGSl/aczheW".wevVPastryCrumbBloomRestored,
            name: "AirSljo@ aRfe.e*d=".wevVPastryCrumbBloomRestored,
            signature: "BblnuJev-+s#kwy% VtMa~s/tQiNntgz /rzuHness aaanfdE ecfozcVoHaN sgplaaSz?eg JsrtEoDp.s%.J".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_arlo",
            sugarNotes: [
                makeGuestSugarPost("aDrTl+oNSGkXyUOanked".wevVPastryCrumbBloomRestored, "MCoxr,nniHnpga ,CNaHs#eX".wevVPastryCrumbBloomRestored, "Tshbe; vf,itrssltk JtLr;aXy. CwVa*sv SsWt.iVlBlx Rwva/r?mn.a".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("aqr%lpomSGklyjTlwIoz".wevVPastryCrumbBloomRestored, "CMoRcJoOaF GD.ufs^tr".wevVPastryCrumbBloomRestored, "DOatrikb rtnoOpSpTiknmgz,v ;s=o,fftk mcHe*n.t,eerF,c pcRl;eTa?ni =fUi?ndiMsph:.#".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["CJoQcsoda& URoonu~nmdT".wevVPastryCrumbBloomRestored, "MEaop@lteZ eDNa#schF".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 143,
            glazeFollowCount: 37,
            sprinkleFanCount: 690,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "p^olppp:yLSvu+nHGulWa?zveY".wevVPastryCrumbBloomRestored,
            name: "PTowpipByB bWleDlHllsO".wevVPastryCrumbBloomRestored,
            signature: "SVumnsn?yE FbYigtEeksV Iaynodv ks.o:uyrs Abwe+ryroyj &fgibljlyiAnegu Jh:uMnrtos^.,".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_poppy",
            sugarNotes: [
                makeGuestSugarPost("p,olpbp:yPSBuHnuOknIef".wevVPastryCrumbBloomRestored, "StkGyD !BBaWtGcghq".wevVPastryCrumbBloomRestored, "L,e~mQoUnb ?gdl:aNz:eM lw:a:s% =smh;aerQpG fidn: ba@ Pgfotomdl %wXaoyZ.c".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("pUoMpVpYy/SzuCnbTBwHo?".wevVPastryCrumbBloomRestored, "B;eXr*r*yC ?T,ibc^kMeCtV".wevVPastryCrumbBloomRestored, "T;hFez dfXiFlClSiJnkgj uh=amdh kal JbCr=i,gjh;t& rl+iwtctIl?eP +kgiKcdkW.E".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["L+egmVozny eLQoPoppt".wevVPastryCrumbBloomRestored, "SYtsrwa#wrbyexrRrsyC =Wxe#eKkJ".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 187,
            glazeFollowCount: 53,
            sprinkleFanCount: 980,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "ruhae=a=HgoynueYyJGbl#aJzpeB".wevVPastryCrumbBloomRestored,
            name: "R@hDeOa= AB.lwoFoxmt".wevVPastryCrumbBloomRestored,
            signature: "HsoTnlekyJ qr/i,n?gUsW,g ~s=o+fstp ;s~lkeqemvje#sE,y PaPnId+ dpIr:e:tFtBy~ Esuujg^aerM Mtargalinlusw.x".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_rhea",
            sugarNotes: [
                makeGuestSugarPost("rmhheca@H/oFnMePyqOkn:ea".wevVPastryCrumbBloomRestored, "HBoNnKefyF #P~aPiOr/".wevVPastryCrumbBloomRestored, "AQ Xm+iZlBd: JgblXahz/eu Qw,imt*hi DaV LfPlRo.rHaElG Xffi~nti!s&hD.w".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("rzhvejabHdornYehyQTVweoI".wevVPastryCrumbBloomRestored, "WTiBnJdvoewg VSAeBaXtY".wevVPastryCrumbBloomRestored, "As ^gHonoCdz +d/oanMuqtt Pd?e,s/ewrlvreasp vsUl*ouwB tn&oVtAeCs@.?".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["Hlo.nieVyH sW=eseVki".wevVPastryCrumbBloomRestored, "G/l:ajzdex VTFr+a^i@lk".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 205,
            glazeFollowCount: 73,
            sprinkleFanCount: 1510,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "b*lWa+i#rbBeljuPe&GvlsaJzbel".wevVPastryCrumbBloomRestored,
            name: "B?lWaZigr& NKtlRiVnwen".wevVPastryCrumbBloomRestored,
            signature: "BMlcuZeK Ah/onoHdy,? PwqafrRmO Dc&uFpY,: rcHiknPnLaumFo~nG ysWu@gva#rY.n".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_blair",
            sugarNotes: [
                makeGuestSugarPost("b+l+a#iFr!Ccu&p^Oenhe.".wevVPastryCrumbBloomRestored, "CiiMnVn:aNmcoqn^ qCwu:p;".wevVPastryCrumbBloomRestored, "COrtuOnicnh?yE peYdlgreQ,o taFifrUyK ycme,notTe=r!.=".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bcliaEiarDC&uEpETowUox".wevVPastryCrumbBloomRestored, "PyozwBdoevrj HSqtqoepi".wevVPastryCrumbBloomRestored, "THhOe? UsouWgia=rG XsBtruqczkD At*oj OeDv,e&royetEhMi!nKgG.?".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["CeiVnwn=aVmAoonk yPaaktxh;".wevVPastryCrumbBloomRestored, "Sgu&g^aQrt sBdoZo&tMhC".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 118,
            glazeFollowCount: 31,
            sprinkleFanCount: 730,
            sugarTie: makeGuestSugarTie(glazeFollowed: true, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "vCeWlpvAest.SutoaAgKefGpl=aDzxeR".wevVPastryCrumbBloomRestored,
            name: "Voegl^voeLtb lR*oeo.kY".wevVPastryCrumbBloomRestored,
            signature: "BpoVlddq vlBoaobk#sD,s kbMoOlRdL zfhrToksbtuiPn&gR,b rnBor adqumlUl/ ebHi=t+e&sa.g".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_velvet",
            sugarNotes: [
                makeGuestSugarPost("vTeylhv:e~teSYtnazgRehOgnde*".wevVPastryCrumbBloomRestored, "RPuhn&wlauyf ;R?iEnpg/".wevVPastryCrumbBloomRestored, "BhlraXccko Vs@e/s&aem#eh ygXlPa%zgeo ,wMansM bdbe/enpc gaRn;dD ssSmKoIo;tkhL.?".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("v.e^l;v*eQtlSJtPaNgte?T:wNog".wevVPastryCrumbBloomRestored, "SpploTtBl@idg@hBt! RBQijtkeg".wevVPastryCrumbBloomRestored, "A* Mc;rXi!sWp& qsRhJetl^lY !orvkeZrQ hs@oEfRtv VdVo;uBg/h..*".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["CvoXcJoSaJ aR#o#umnKd%".wevVPastryCrumbBloomRestored, "HtonnXejyA WW~exeaku".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 166,
            glazeFollowCount: 45,
            sprinkleFanCount: 860,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "cxarrJa:m+e=lbFRe?r~nFGGl+a%zDeM".wevVPastryCrumbBloomRestored,
            name: "CXaur?avmneOlZ #FyeBrynO".wevVPastryCrumbBloomRestored,
            signature: "CSa:rXaxmMeMlu rcru!r+lPs& FaMnGd? /n?uxtitQyO lgElCaSzleb ;nnoPtKecsu.w".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_caramel",
            sugarNotes: [
                makeGuestSugarPost("cUa*raaXmNeSlKCeuOr.lTONnUej".wevVPastryCrumbBloomRestored, "Bpr&oVwhnq =SguQgfaMrq =CIaHsJe~".wevVPastryCrumbBloomRestored, "SjtyilcskbyO Atroopo,Q JmGe%lDlUoEwC ofLi+nbiCsuhm.C".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("cuahrea&mxefleCDuhrHlDT+wnod".wevVPastryCrumbBloomRestored, "NWuLtJtFyB NBTooxJ".wevVPastryCrumbBloomRestored, "TioEaVsWtleYdF fpgihe+cfe?sv hmuamdVe~ VtJhaej vbia/tScehl rsYiKnqgw.A".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["MfabpAl=e/ %DBassohX".wevVPastryCrumbBloomRestored, "HHo?n~e,yf :W&eOe/k^".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 97,
            glazeFollowCount: 22,
            sprinkleFanCount: 410,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: true)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "bKeYrOrfy~CClMouujduG%lpajzXeb".wevVPastryCrumbBloomRestored,
            name: "Boe:rSrQym dC.loo&uyd,".wevVPastryCrumbBloomRestored,
            signature: "BilSuFewbQearvrPy^ dfsi#lolriynJgw,~ Evma,nPiYlnlBaq ?c=ree^afm?,Z XghernFtIl#eP #sIc,oMr?eisA.r".wevVPastryCrumbBloomRestored,
            donutAvatarAsset: "wevv_guest_glaze_berry",
            sugarNotes: [
                makeGuestSugarPost("b#e~rJr.yKC=lqo.ukd%ORnPeI".wevVPastryCrumbBloomRestored, "B!lOuReib;eerarByI KF,oRlKdf".wevVPastryCrumbBloomRestored, "TtaanwgryD bfwiHlelniznXgx PkKejpVtG ?tDhUe# Wb%iftdeQ ul~iqgEhlt,.*".wevVPastryCrumbBloomRestored),
                makeGuestSugarPost("bPeqrwr~y=CYlZo@uDd?T%wSo;".wevVPastryCrumbBloomRestored, "C*rJe~aOmY lDrrli~f.tg".wevVPastryCrumbBloomRestored, "Vga+nviilJl@an AcNr;e~ahmO Kwpa.sj EsjoofgtQ sa+nEd% PcTlpeRaLns.n".wevVPastryCrumbBloomRestored)
            ],
            joinedChallenges: ["B=ezror&yU ^LKocozpz".wevVPastryCrumbBloomRestored, "SotyrOa,wgbueArhrLy. &WHeieFkT".wevVPastryCrumbBloomRestored],
            sweetMarkCount: 152,
            glazeFollowCount: 39,
            sprinkleFanCount: 775,
            sugarTie: makeGuestSugarTie(glazeFollowed: false, sprinkleFan: false)
        )
    ]

    var allProfiles: [WevVGuestGlazeProfile] {
        baseProfiles.map { glazeProfile in
            var sugarProfile = glazeProfile
            sugarProfile.sugarTie.isGlazeFollowed = followedKeys.contains(glazeProfile.glazeKey)
            sugarProfile.sugarTie.isSugarShielded = shieldedKeys.contains(glazeProfile.glazeKey)
            return sugarProfile
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

    func profile(for glazeKey: String) -> WevVGuestGlazeProfile {
        allProfiles.first { $0.glazeKey == glazeKey } ?? allProfiles[0]
    }

    func profile(at index: Int) -> WevVGuestGlazeProfile {
        let profiles = allProfiles
        return profiles[abs(index) % profiles.count]
    }

    @discardableResult
    func toggleGlazeFollow(for glazeKey: String) -> Bool {
        var sugarKeys = followedKeys
        if sugarKeys.contains(glazeKey) {
            sugarKeys.remove(glazeKey)
        } else {
            sugarKeys.insert(glazeKey)
        }
        frostingDefaults.set(Array(sugarKeys).sorted(), forKey: followedKey)
        return sugarKeys.contains(glazeKey)
    }

    @discardableResult
    func toggleSugarShield(for glazeKey: String) -> Bool {
        var sugarKeys = shieldedKeys
        if sugarKeys.contains(glazeKey) {
            sugarKeys.remove(glazeKey)
        } else {
            sugarKeys.insert(glazeKey)
        }
        frostingDefaults.set(Array(sugarKeys).sorted(), forKey: shieldedKey)
        return sugarKeys.contains(glazeKey)
    }

    private var followedKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: followedKey) ?? [])
    }

    private var shieldedKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: shieldedKey) ?? [])
    }
}
