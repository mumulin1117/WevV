#!/usr/bin/env python3
"""Compile and exercise the actual community service with isolated semantic transport fixtures."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'WevSweetgd/WevSweetgd'


def main():
    source = (APP / 'kettleGlazeSequence.swift').read_text()
    models = source[source.index('struct butteryTexture:'):source.index('struct meltawayCrumb:')]
    stubs = '''import Foundation
@MainActor final class WevVGlazeRuntime {
 static let shared = WevVGlazeRuntime(); var environmentID = "fixture"
 func prepare() async throws {}
 func opi(path:String, body:Data, authenticated:Bool) async throws -> Data { fatalError("Unexpected real transport") }
 func browsingOPI(path:String, body:[String:Any]) async throws -> Data { fatalError("Unexpected real transport") }
}
@MainActor final class WevVGlazeSessionStore {
 static let shared = WevVGlazeSessionStore(); var isTasterReady = true; var sessionEpoch = 1
}
'''
    tests = r'''import Foundation
@MainActor final class SemanticProbe {
 var replies: [Result<Data, Error>] = []
 var requests: [(path:String, body:[String:Any], signedIn:Bool)] = []
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
 func service() -> WevVGlazeCommunityService {
  WevVGlazeCommunityService(request: { try await self.send($0,$1,$2) }, isSignedIn: { self.signedIn }, scope: { self.environment }, prepare: { try await self.prepare() })
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
  let feed = try await service.feed()
  precondition(feed.posts.count==9 && feed.isLastPage && feed.nextCursor==nil)
  precondition(!feed.posts[0].allowsInteraction && feed.posts[1].allowsInteraction)
  precondition(feed.posts[1].card.vanillaBeanIcing==Int64.max && feed.posts[1].card.limeCream==3 && feed.posts[1].card.cherryCompote)
  precondition(probe.requests[0].path=="/_v2/moments/feed" && Set(probe.requests[0].body.keys)==["cursorId","size"] && !probe.requests[0].signedIn)
  let count = probe.requests.count
  do { try await service.like(momentID:1,liked:true); fatalError("Official like allowed") } catch WevVGlazeCommunityService.CommunityError.interactionUnavailable {}
  do { try await service.comment(momentID:1,content:"Hello"); fatalError("Official comment allowed") } catch WevVGlazeCommunityService.CommunityError.interactionUnavailable {}
  precondition(probe.requests.count==count)
  probe.replies=[.success(try data(["success":true])),.success(try page(fixtures)),.success(try data(["success":true]))]
  try await service.like(momentID:2,liked:false)
  try await service.comment(momentID:2,content:"  Sweet!  ",parentID:11)
  precondition(probe.requests[count].path=="/_v2/moments/like" && probe.requests[count].body["optionType"] as? Int == 0)
  precondition(Set(probe.requests[count+2].body.keys)==["friendsCircleId","commentContent","parentCommentId"] && probe.requests[count+2].body["commentContent"] as? String=="Sweet!")
  probe.replies=[.success(try page(fixtures)),.success(try data(["total":1,"rows":[["id":"11","userId":5,"commentContent":"Parent","subComments":[["id":12,"userId":"6","parentCommentId":"11","commentContent":"Reply"]]]]]))]
  let comments = try await service.comments(momentID:2)
  precondition(comments.comments.map(\.blueberryCompote)==[11,12] && comments.comments[1].apricotFilling==11 && comments.total==1 && !comments.hasMore)
  probe.replies=[.success(try data(["publishEnabled":true,"imageUploadEnabled":false])),.success(try data(["success":true]))]
  let config = try await service.publishConfig(); precondition(config.publishEnabled && !config.imageUploadEnabled)
  try await service.imageCheck(urls:["https://example.invalid/upload.png"])
  precondition(probe.requests.last!.path=="/_v2/moments/imgCheck" && Set(probe.requests.last!.body.keys)==["imgUrls"])
  probe.replies=[.failure(WevVGlazeNetworkError.business(code:"2066",message:"Saved for review"))]
  guard case .pendingReview = try await service.create(content:"My tasting note",imageURLs:[]) else { fatalError("Review status misclassified") }
  precondition(probe.requests.last!.path=="/_v2/moments/create" && Set(probe.requests.last!.body.keys)==["textContent","imgUrls","displayRange"])
  probe.replies=[.success(try data(["published":true,"friendsCircleId":"9007199254740993"]))]
  guard case .published(let id) = try await service.create(content:"Published",imageURLs:[]) else { fatalError("Published status missing") }
  precondition(id==9_007_199_254_740_993)
  probe.replies=[.success(try data(["published":false,"currentLevel":1,"targetLevel":3]))]
  do { _ = try await service.create(content:"Level required",imageURLs:[]); fatalError("Rejected post accepted") }
  catch WevVGlazeCommunityService.CommunityError.publicationRejected(let current,let target,_) { precondition(current==1 && target==3) }
  probe.replies=[.failure(WevVGlazeNetworkError.business(code:"2065",message:"Rejected"))]
  do { _ = try await service.create(content:"Rejected",imageURLs:[]); fatalError("Ordinary error swallowed") } catch WevVGlazeNetworkError.business(let code,_) { precondition(code=="2065") }
  let beforeInvalid=probe.requests.count
  do { try await service.imageCheck(urls:Array(repeating:"https://example.invalid/x",count:10)); fatalError("Image limit ignored") } catch WevVGlazeCommunityService.CommunityError.invalidParameters {}
  do { try await service.comment(momentID:2,content:"   "); fatalError("Empty comment accepted") } catch WevVGlazeCommunityService.CommunityError.invalidParameters {}
  precondition(probe.requests.count==beforeInvalid)
  let followProbe=SemanticProbe();let followService=followProbe.service()
  let first=(100..<120).map { row(Int64($0),follow:$0==103 || $0==117) }
  followProbe.replies=[.success(try page(first,next:119)),.success(try page([row(120,follow:true),row(121)]))]
  let followed=try await followService.timeline(followedOnly:true,maxPages:2)
  precondition(followed.map(\.card.coconutCenter)==[103,117,120] && followProbe.requests.count==2)
  precondition(followProbe.requests[1].body["cursorId"] as? Int64==119 && followProbe.requests.allSatisfy{ Set($0.body.keys)==["cursorId","size"] })
  let guest=SemanticProbe(); guest.signedIn=false
  do { _ = try await guest.service().timeline(followedOnly:true); fatalError("Guest Follow requested") } catch WevVGlazeCommunityService.CommunityError.loginRequired {}
  precondition(guest.requests.isEmpty)
  let broken=SemanticProbe();let brokenService=broken.service()
  broken.replies=[.success(try page(first,next:119)),.failure(WevVGlazeNetworkError.http(500))]
  do { _ = try await brokenService.timeline(followedOnly:true,maxPages:2); fatalError("Partial follow feed swallowed failure") } catch WevVGlazeNetworkError.http(500) {}
  broken.replies=[.success(try data(["rows":[]]))]
  do { _ = try await brokenService.feed(); fatalError("Invalid feed treated as empty") } catch WevVGlazeNetworkError.invalidResponse {}
  broken.replies=[.success(try page([]))]
  let empty=try await brokenService.feed(); precondition(empty.posts.isEmpty && empty.isLastPage)
  let switched=SemanticProbe();let switchedService=switched.service()
  switched.replies=[.success(try page([row(1)]))];switched.changeEnvironment=true
  do { _ = try await switchedService.feed(); fatalError("Cross-account response accepted") } catch is CancellationError {}
  probe.environment="other|2";probe.replies=[.success(try page([]))]
  do { _ = try await service.moment(id:2); fatalError("Previous account cache leaked") } catch WevVGlazeCommunityService.CommunityError.momentUnavailable {}
  // Authenticated send must bind the initiating account before its first prepare.
  for operation in 0..<3 {
   let preparing=SemanticProbe();let preparingService=preparing.service()
   preparing.changeOnPrepare=1
   preparing.replies=[.success(try data(["publishEnabled":true,"imageUploadEnabled":true,"success":true,"published":true,"friendsCircleId":42]))]
   do {
    if operation==0 { _ = try await preparingService.publishConfig() }
    else if operation==1 { try await preparingService.imageCheck(urls:["https://example.invalid/upload.png"]) }
    else { _ = try await preparingService.create(content:"Account A note",imageURLs:[]) }
    fatalError("Action crossed accounts during prepare")
   } catch is CancellationError {}
   precondition(preparing.prepareCount==1 && preparing.requests.isEmpty && preparing.replies.count==1)
  }
  // Even an already cached post requires prepare. A -> B there must never send
  // A's reaction/comment after the lookup repopulates the cache from B's feed.
  for commenting in [false,true] {
   let cached=SemanticProbe();let cachedService=cached.service()
   cached.replies=[.success(try page([row(42)]))]
   _ = try await cachedService.feed()
   cached.changeOnPrepare=cached.prepareCount+1
   cached.replies=[.success(try page([row(42)])),.success(try data(["success":true]))]
   do {
    if commenting { try await cachedService.comment(momentID:42,content:"Account A comment") }
    else { try await cachedService.like(momentID:42,liked:true) }
    fatalError("Cached interaction crossed accounts")
   } catch is CancellationError {}
   precondition(cached.requests.count==2 && cached.requests.allSatisfy { $0.path=="/_v2/moments/feed" && !$0.signedIn })
   precondition(cached.replies.count==1)
  }
  let bootstrappingGuest=SemanticProbe();bootstrappingGuest.signedIn=false
  bootstrappingGuest.environment="unprepared|0";bootstrappingGuest.changeOnPrepare=1
  bootstrappingGuest.replies=[.success(try page([row(42)]))]
  let initialGuestFeed=try await bootstrappingGuest.service().feed()
  precondition(initialGuestFeed.posts.count==1 && bootstrappingGuest.requests.count==1 && !bootstrappingGuest.requests[0].signedIn)
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
        subprocess.run(['xcrun','swiftc','-swift-version','5','-default-isolation','MainActor','-parse-as-library','-module-cache-path','/private/tmp/wevv-community-module-cache',str(root/'Models.swift'),str(root/'RuntimeStubs.swift'),str(APP/'WevVGlazeNetworkFoundation.swift'),str(APP/'WevVGlazeCommunityService.swift'),str(root/'Verify.swift'),'-o',str(binary)],check=True)
        subprocess.run([str(binary)],check=True)


if __name__=='__main__':
    main()
