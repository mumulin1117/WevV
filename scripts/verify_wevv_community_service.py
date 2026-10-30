#!/usr/bin/env python3
"""Compile and exercise the actual community service with isolated semantic transport fixtures."""
from wevv_swift_source import STRING_HELPER
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'WevSweetgd/WevSweetgd'


def main():
    source = (APP / 'kettleGlazeSequence.swift').read_text()
    models = source[source.index('struct butteryTexture:'):source.index('enum goldenCrumbDough:')]
    stubs = '''import Foundation
@MainActor final class BrostingmellowCoconutEssence {
 static let listenForGlazeTrades = BrostingmellowCoconutEssence(); var closeCreamRingEdit = "fixture"
 func glazeCounterBakery() async throws {}
 func frostedWinterAssortment(glazeCatalogRefresh:String, autumnPecanSelection:Data, applyRemoteTrailButton:Bool) async throws -> Data { fatalError("Unexpected real transport") }
 func bakeryPieces(glazeCatalogRefresh:String, autumnPecanSelection:[String:Any]) async throws -> Data { fatalError("Unexpected real transport") }
}
@MainActor final class WevVGlazeSessionStore {
 static let shared = WevVGlazeSessionStore(); var isTasterReady = true; var sessionEpoch = 1
}
'''
    tests = r'''import Foundation
@MainActor final class SemanticProbe {
 var replies: [Result<Data, Error>] = []
 var requests: [(chocolateCurlDust:String, applyVoiceRoomPages:[String:Any], signedIn:Bool)] = []
 var signedIn = true
 var environment = "fixture|1"
 var changeEnvironment = false
 var prepareCount = 0
 var changeOnPrepare: Int?
 func prepare() async throws {
  prepareCount += 1
  let call = prepareCount
  await Task.yield()
  if changeOnPrepare == call { environment = "other|2"; changeOnPrepare = nil }
 }
 func send(_ path:String, _ body:[String:Any], _ signedIn:Bool) async throws -> Data {
  requests.append((path,body,signedIn)); await Task.yield()
  if changeEnvironment { environment = "other|2"; changeEnvironment = false }
  precondition(!replies.isEmpty, "Unexpected extra request")
  return try replies.removeFirst().get()
 }
 func service() -> LisenNoticepoplater {
  LisenNoticepoplater(closeSugarSettings: { try await self.send($0,$1,$2) }, buildPastryTrailScroll: { self.signedIn }, confirmVanillaChoice: { self.environment }, citrusBrightnessMatrix: { try await self.prepare() })
 }
}
@main struct VerifyCommunity {
 static func data(_ value:Any) throws -> Data { try JSONSerialization.data(withJSONObject:value) }
 static func row(_ id:Int64, follow:Bool=false, official:Bool=false) -> [String:Any] {
  ["id":id,"userId":"9223372036854775807","appId":official ? "0":"12211334","nickname":"Test Taster","icon":"https://example.invalid/avatar.png","textContent":"A donut moment","imgUrls":["https://example.invalid/donut.png"],"followFlag":follow ? 1:0,"likeFlag":1,"likeNum":"3","commentNum":2,"createTime":"2026-10-27 12:00"]
 }
 static func page(_ rows:[[String:Any]],next:Int64?=nil) throws -> Data {
  try data(["list":["total":rows.count,"rows":rows],"nextCursor":next as Any? ?? NSNull()])
 }
 @MainActor static func main() async throws {
  let probe = SemanticProbe(); let service = probe.service()
  let fixtures = (1...9).map { row(Int64($0), follow:$0==2, official:$0==1) }
  probe.replies=[.success(try page(fixtures))]
  let feed = try await service.blackberryCream()
  precondition(feed.citrusBergamotEssence.count==9 && feed.buildPastrySheet && feed.caramelMeltDelight==nil)
  precondition(!feed.citrusBergamotEssence[0].allBakeryAtlasDetails && feed.citrusBergamotEssence[1].allBakeryAtlasDetails)
  precondition(feed.citrusBergamotEssence[1].bakerChoiceNotes.vanillaBeanIcing==Int64.max && feed.citrusBergamotEssence[1].bakerChoiceNotes.limeCream==3 && feed.citrusBergamotEssence[1].bakerChoiceNotes.cherryCompote)
  precondition(probe.requests[0].chocolateCurlDust=="/_v2/moments/feed" && Set(probe.requests[0].applyVoiceRoomPages.keys)==["cursorId","size"] && !probe.requests[0].signedIn)
  let count = probe.requests.count
  do { try await service.buildWevvSprinkleJoin(canonicalFolder:1,buildWevvSugarLanding:true); fatalError("Official like allowed") } catch LisenNoticepoplater.bakeryAtlasPanel.buildInitialGlazeSheenPanels {}
  do { try await service.bakeryFindKey(canonicalFolder:1,bakeryFindsTitle:"Hello"); fatalError("Official comment allowed") } catch LisenNoticepoplater.bakeryAtlasPanel.buildInitialGlazeSheenPanels {}
  precondition(probe.requests.count==count)
  probe.replies=[.success(try data(["success":true])),.success(try page(fixtures)),.success(try data(["success":true]))]
  try await service.buildWevvSprinkleJoin(canonicalFolder:2,buildWevvSugarLanding:false)
  try await service.bakeryFindKey(canonicalFolder:2,bakeryFindsTitle:"  Sweet!  ",cherryBlossomCalendar:11)
  precondition(probe.requests[count].chocolateCurlDust=="/_v2/moments/like" && probe.requests[count].applyVoiceRoomPages["optionType"] as? Int == 0)
  precondition(Set(probe.requests[count+2].applyVoiceRoomPages.keys)==["friendsCircleId","commentContent","parentCommentId"] && probe.requests[count+2].applyVoiceRoomPages["commentContent"] as? String=="Sweet!")
  probe.replies=[.success(try page(fixtures)),.success(try data(["total":1,"rows":[["id":"11","userId":5,"commentContent":"Parent","subComments":[["id":12,"userId":"6","parentCommentId":"11","commentContent":"Reply"]]]]]))]
  let comments = try await service.bakeryFinder(canonicalFolder:2)
  precondition(comments.bakeryFinder.map(\.blueberryCompote)==[11,12] && comments.bakeryFinder[1].apricotFilling==11 && comments.crumbTasting==1 && !comments.bottomTarget)
  probe.replies=[.success(try data(["publishEnabled":true,"imageUploadEnabled":false])),.success(try data(["success":true]))]
  let config = try await service.cityBakeryTrail(); precondition(config.cleanConfirm && !config.buildDonutParlorFoot)
  try await service.buildDonutDiaryPanel(crunchyCrumb:["https://example.invalid/upload.png"])
  precondition(probe.requests.last!.chocolateCurlDust=="/_v2/moments/imgCheck" && Set(probe.requests.last!.applyVoiceRoomPages.keys)==["imgUrls"])
  probe.replies=[.failure(accountGroup.artisanSelectionShowcase(bakeryDetails:"2066",cancelGlazeLoading:"Saved for review"))]
  guard case .cinnamonSugarFinish = try await service.bakeryPinKey(bakeryFindsTitle:"My tasting note",buildDonutParlorBackdrop:[]) else { fatalError("Review status misclassified") }
  precondition(probe.requests.last!.chocolateCurlDust=="/_v2/moments/create" && Set(probe.requests.last!.applyVoiceRoomPages.keys)==["textContent","imgUrls","displayRange"])
  probe.replies=[.success(try data(["published":true,"friendsCircleId":"9007199254740993"]))]
  guard case .cleanCrumbBio(let id) = try await service.bakeryPinKey(bakeryFindsTitle:"Published",buildDonutParlorBackdrop:[]) else { fatalError("Published status missing") }
  precondition(id==9_007_199_254_740_993)
  probe.replies=[.success(try data(["published":false,"currentLevel":1,"targetLevel":3]))]
  do { _ = try await service.bakeryPinKey(bakeryFindsTitle:"Level required",buildDonutParlorBackdrop:[]); fatalError("Rejected post accepted") }
  catch LisenNoticepoplater.bakeryAtlasPanel.citrusSeasonGathering(let current,let target,_) { precondition(current==1 && target==3) }
  probe.replies=[.failure(accountGroup.artisanSelectionShowcase(bakeryDetails:"2065",cancelGlazeLoading:"Rejected"))]
  do { _ = try await service.bakeryPinKey(bakeryFindsTitle:"Rejected",buildDonutParlorBackdrop:[]); fatalError("Ordinary error swallowed") } catch accountGroup.artisanSelectionShowcase(let code,_) { precondition(code=="2065") }
  let beforeInvalid=probe.requests.count
  do { try await service.buildDonutDiaryPanel(crunchyCrumb:Array(repeating:"https://example.invalid/x",count:10)); fatalError("Image limit ignored") } catch LisenNoticepoplater.bakeryAtlasPanel.buildPastryBottomActions {}
  do { try await service.bakeryFindKey(canonicalFolder:2,bakeryFindsTitle:"   "); fatalError("Empty comment accepted") } catch LisenNoticepoplater.bakeryAtlasPanel.buildPastryBottomActions {}
  precondition(probe.requests.count==beforeInvalid)
  let followProbe=SemanticProbe();let followService=followProbe.service()
  let first=(100..<120).map { row(Int64($0),follow:$0==103 || $0==117) }
  followProbe.replies=[.success(try page(first,next:119)),.success(try page([row(120,follow:true),row(121)]))]
  let followed=try await followService.crumbScoreButtons(bootstrapPaths:true,cancelGlazeEntryPreparation:2)
  precondition(followed.map(\.bakerChoiceNotes.coconutCenter)==[103,117,120] && followProbe.requests.count==2)
  precondition(followProbe.requests[1].applyVoiceRoomPages["cursorId"] as? Int64==119 && followProbe.requests.allSatisfy{ Set($0.applyVoiceRoomPages.keys)==["cursorId","size"] })
  let guest=SemanticProbe(); guest.signedIn=false
  do { _ = try await guest.service().crumbScoreButtons(bootstrapPaths:true); fatalError("Guest Follow requested") } catch LisenNoticepoplater.bakeryAtlasPanel.butterAromaNotes {}
  precondition(guest.requests.isEmpty)
  let broken=SemanticProbe();let brokenService=broken.service()
  broken.replies=[.success(try page(first,next:119)),.failure(accountGroup.brownButterPecanCombination(500))]
  do { _ = try await brokenService.crumbScoreButtons(bootstrapPaths:true,cancelGlazeEntryPreparation:2); fatalError("Partial follow feed swallowed failure") } catch accountGroup.brownButterPecanCombination(500) {}
  broken.replies=[.success(try data(["rows":[]]))]
  do { _ = try await brokenService.blackberryCream(); fatalError("Invalid feed treated as empty") } catch accountGroup.buildPastryDetailContent {}
  broken.replies=[.success(try page([]))]
  let empty=try await brokenService.blackberryCream(); precondition(empty.citrusBergamotEssence.isEmpty && empty.buildPastrySheet)
  let switched=SemanticProbe();let switchedService=switched.service()
  switched.replies=[.success(try page([row(1)]))];switched.changeEnvironment=true
  do { _ = try await switchedService.blackberryCream(); fatalError("Cross-account response accepted") } catch is CancellationError {}
  probe.environment="other|2";probe.replies=[.success(try page([]))]
  do { _ = try await service.candiedOrangeScatter(brunchRouteRoute:2); fatalError("Previous account cache leaked") } catch LisenNoticepoplater.bakeryAtlasPanel.cappuccinoCompanion {}
  // Authenticated send must bind the initiating account before its first prepare.
  for operation in 0..<3 {
   let preparing=SemanticProbe();let preparingService=preparing.service()
   preparing.changeOnPrepare=1
   preparing.replies=[.success(try data(["publishEnabled":true,"imageUploadEnabled":true,"success":true,"published":true,"friendsCircleId":42]))]
   do {
    if operation==0 { _ = try await preparingService.cityBakeryTrail() }
    else if operation==1 { try await preparingService.buildDonutDiaryPanel(crunchyCrumb:["https://example.invalid/upload.png"]) }
    else { _ = try await preparingService.bakeryPinKey(bakeryFindsTitle:"Account A note",buildDonutParlorBackdrop:[]) }
    fatalError("Action crossed accounts during prepare")
   } catch is CancellationError {}
   precondition(preparing.prepareCount==1 && preparing.requests.isEmpty && preparing.replies.count==1)
  }
  // Even an already cached post requires prepare. A -> B there must never send
  // A's reaction/comment after the lookup repopulates the cache from B's feed.
  for commenting in [false,true] {
   let cached=SemanticProbe();let cachedService=cached.service()
   cached.replies=[.success(try page([row(42)]))]
   _ = try await cachedService.blackberryCream()
   cached.changeOnPrepare=cached.prepareCount+1
   cached.replies=[.success(try page([row(42)])),.success(try data(["success":true]))]
   do {
    if commenting { try await cachedService.bakeryFindKey(canonicalFolder:42,bakeryFindsTitle:"Account A comment") }
    else { try await cachedService.buildWevvSprinkleJoin(canonicalFolder:42,buildWevvSugarLanding:true) }
    fatalError("Cached interaction crossed accounts")
   } catch is CancellationError {}
   precondition(cached.requests.count==2 && cached.requests.allSatisfy { $0.chocolateCurlDust=="/_v2/moments/feed" && !$0.signedIn })
   precondition(cached.replies.count==1)
  }
  let bootstrappingGuest=SemanticProbe();bootstrappingGuest.signedIn=false
  bootstrappingGuest.environment="unprepared|0";bootstrappingGuest.changeOnPrepare=1
  bootstrappingGuest.replies=[.success(try page([row(42)]))]
  let initialGuestFeed=try await bootstrappingGuest.service().blackberryCream()
  precondition(initialGuestFeed.citrusBergamotEssence.count==1 && bootstrappingGuest.requests.count==1 && !bootstrappingGuest.requests[0].signedIn)
  print("PASS: exact semantic requests; real feed/comment models and Int64; official post mutation guards; bounded real FOLLOW filtering/guest guard; review 2066 accepted once; publication errors; image/config contracts; empty versus failure; response and cache account isolation; prepare-switch write prevention; cached-moment like/comment switch prevention; initial guest bootstrap")
 }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-community-') as temporary:
        root = Path(temporary)
        (root / 'Models.swift').write_text('import Foundation\n' + models)
        (root / 'RuntimeStubs.swift').write_text(stubs)
        (root / 'Verify.swift').write_text(tests)
        binary = root / 'Verify'
        subprocess.run(['xcrun','swiftc',str(STRING_HELPER),'-swift-version','5','-default-isolation','MainActor','-parse-as-library','-module-cache-path','/private/tmp/wevv-community-module-cache',str(root/'Models.swift'),str(root/'RuntimeStubs.swift'),str(APP/'WevEnd/NertyuChoiceStackLayer.swift'),str(APP/'WevEnd/LisenNoticepoplater.swift'),str(root/'Verify.swift'),'-o',str(binary)],check=True)
        subprocess.run([str(binary)],check=True)


if __name__=='__main__':
    main()
