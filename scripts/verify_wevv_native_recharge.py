#!/usr/bin/env python3
"""Exercise actual native recharge orchestration without StoreKit or server mutations."""
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
APP=ROOT/'WevSweetgd/WevSweetgd'


def main():
    stubs='''import Foundation
struct RechargeAccount { let vanillaBeanIcing:Int64 }
struct RechargeProfile { let glazeVaultCount:Int }
@MainActor final class WevVGlazeRuntime {
 static let shared=WevVGlazeRuntime();var appID="fixture";var environmentID="fixture"
 func validSignedInSession()async throws->RechargeAccount{fatalError("Unexpected real session")}
 func opi(path:String,body:Data,authenticated:Bool)async throws->Data{fatalError("Unexpected real transport")}
}
@MainActor final class WevVGlazeSessionStore {
 static let shared=WevVGlazeSessionStore();var isTasterReady=true;var sessionEpoch=1;var currentGlazeCredentials:RechargeAccount?=nil
}
@MainActor final class WevVGlazeSessionRepository {
 static let pastryTrailDiary=WevVGlazeSessionRepository()
 func coldBrewTasting()async throws->RechargeProfile{fatalError("Unexpected real balance")}
}
@MainActor final class WevVGlazePurchaseCoordinator {
 static let shared=WevVGlazePurchaseCoordinator()
 func purchase(params:[String:Any],ownerID:String,appID:String,environmentID:String,allowStoreSyncRetry:Bool=false)async throws->[String:Any]{fatalError("Unexpected StoreKit purchase")}
 func syncTransactions(params:[String:Any],ownerID:String,appID:String,environmentID:String)async throws->[String:Any]{fatalError("Unexpected StoreKit sync")}
}
'''
    tests=r'''import Foundation
@MainActor final class RechargeProbe {
 typealias Service=WevVGlazeNativeRechargeService
 let directory:URL
 var context=Service.Context(ownerID:"7",appID:"fixture",environmentID:"test|fixture|https://example.invalid",sessionEpoch:1)
 var requests:[(String,[String:Any])]=[]
 var creates=0,storePurchases=0,verifyCalls=0,balanceCalls=0
 var mode="purchased",badCreateChannel=false,failBalance=false,failACK=false,failVerify=false,orderPendingAfterVerify=false,switchDuringPurchase=false
 var states:[String:Int]=[:],inbox:[[String:Any]]=[],acknowledgements:[String]=[],lastParams:[String:Any]=[:]
 let receipt=Data("fixture App Store receipt".utf8).base64EncodedString()
 init(_ name:String)throws{
  directory=FileManager.default.temporaryDirectory.appendingPathComponent("wevv-native-recharge-"+name+"-"+UUID().uuidString)
 }
 func packages()->[[String:Any]]{
  [["id":1,"batchNo":"fixture.100","diamondNum":100,"giveDiamondNum":10,"firstChargeGive":5,"bought":false,"recommend":true,"price":"0.99","currencySymbol":"$","channels":[["id":"101","channelType":"7","payMethodType":"SERVER_APPLE_TYPE","showType":2]]],
   ["id":2,"batchNo":"fixture.200","diamondNum":200,"price":1.99,"channels":[["id":102,"channelType":"IOS","payMethodType":"APPLEPAY","showType":1]]],
   ["id":3,"batchNo":"google.only","diamondNum":300,"price":2.99,"channels":[["id":103,"channelType":"8","payMethodType":"GOOGLEPAY"]]]]
 }
 func request(_ path:String,_ body:[String:Any])async throws->Data{
  requests.append((path,body));await Task.yield()
  let value:[String:Any]
  switch path{
  case "/_v2/pay/rechargeList":value=["rows":packages(),"total":3,"currencySymbol":"$"]
  case "/_v2/pay/createOrder":
   creates+=1;let code="NATIVE-\(creates)";states[code]=1
   precondition(Set(body.keys)==["vipFlag","skuInfoId","productId","paymentMethodType","showType"])
   precondition(body["vipFlag"] as? Int==0 && body["skuInfoId"] as? Int64==101 && body["paymentMethodType"] as? String=="SERVER_APPLE_TYPE")
   value=["orderCode":code,"channelType":badCreateChannel ? "8":"7","diamondNum":115]
  case "/_v2/pay/verifyIosPurchase":
   verifyCalls+=1;precondition(Set(body.keys)==["transactionId","payload","callbackResult"] && body["payload"] as? String==receipt)
   let callback=try JSONSerialization.jsonObject(with:Data((body["callbackResult"] as! String).utf8)) as! [String:Any]
   precondition(Set(callback.keys)==["orderCode"] && !(callback["orderCode"] as! String).hasPrefix("H5-"))
   if failVerify{throw WevVGlazeNetworkError.business(code:"999",message:"Fixture verification failure")}
   states[callback["orderCode"] as! String]=orderPendingAfterVerify ? 1:2
   value=["success":true]
  case "/_v2/pay/orderStatus":value=["state":states[body["orderCode"] as! String] ?? 1]
  default:fatalError("Unexpected endpoint")
  }
  return try JSONSerialization.data(withJSONObject:value)
 }
 func material(order:String,product:String="fixture.100",transaction:String)->[String:Any]{
  ["store":"apple","orderCode":order,"ownerId":"7","productId":product,"purpose":"diamonds","transactionId":transaction,"receipt":receipt,"state":"purchased"]
 }
 func purchase(_ params:[String:Any],_ context:Service.Context)async throws->[String:Any]{
  lastParams=params
  let journalURL=directory.appendingPathComponent(context.purchaseScope.storageKey+".json")
  let journal=try JSONSerialization.jsonObject(with:Data(contentsOf:journalURL)) as! [String:Any]
  precondition(journal["origin"] as? String=="native-recharge")
  let contents=try String(contentsOf:journalURL,encoding:.utf8)
  precondition(!contents.contains("receipt") && !contents.contains("accessToken") && contents.contains(params["orderCode"] as! String))
  if let known=inbox.first(where:{$0["orderCode"] as? String==params["orderCode"] as? String}){
   var result=known;result["status"]="purchased";return result
  }
  if mode != "purchased" {return ["status":mode,"productId":params["productId"]!]}
  storePurchases+=1
  let result=material(order:params["orderCode"] as! String,transaction:"native-tx-\(storePurchases)")
  inbox.append(result)
  if switchDuringPurchase{self.context=Service.Context(ownerID:"8",appID:"fixture",environmentID:self.context.environmentID,sessionEpoch:2)}
  var purchased=result;purchased["status"]="purchased";return purchased
 }
 func sync(_ params:[String:Any],_ context:Service.Context)async throws->[String:Any]{
  let a=params["acknowledgedTransactionIds"] as! [String],e=params["excludeTransactionIds"] as! [String]
  precondition(a.allSatisfy{!$0.hasPrefix("h5-")})
  if failACK && !a.isEmpty{failACK=false;throw WevVGlazePurchaseError.nativeFailed}
  acknowledgements.append(contentsOf:a);inbox.removeAll{a.contains($0["transactionId"] as! String)}
  return ["transactions":Array(inbox.filter{!e.contains($0["transactionId"] as! String)}.prefix(20))]
 }
 func balance()async throws->Int{
  balanceCalls+=1;if failBalance{failBalance=false;throw WevVGlazeNetworkError.http(503)}
  return 901 // Deliberately unrelated to the client's package amount.
 }
 func service()->Service{
  Service(request:{try await self.request($0,$1)},purchase:{try await self.purchase($0,$1)},sync:{try await self.sync($0,$1)},context:{self.context},isCurrent:{$0==self.context},balance:{try await self.balance()},storageDirectory:directory)
 }
 func cleanup(){try? FileManager.default.removeItem(at:directory)}
}
@main struct VerifyRecharge{
 @MainActor static func main()async throws{
  let p=try RechargeProbe("normal");defer{p.cleanup()};let service=p.service()
  let packages=try await service.packages()
  precondition(packages.count==2 && packages[0].productID=="fixture.100" && packages[0].channelID==101 && packages[0].diamonds==100 && packages[0].firstChargeDiamonds==5)
  p.inbox=[p.material(order:"H5-foreign",transaction:"h5-transaction")]
  guard case .credited(let value)=try await service.purchase(productID:"fixture.100")else{fatalError("Purchase not credited")}
  precondition(value==901 && p.creates==1 && p.storePurchases==1 && p.verifyCalls==1 && p.acknowledgements==["native-tx-1"])
  precondition(p.inbox.count==1 && p.inbox[0]["orderCode"] as? String=="H5-foreign")
  let recovered=try await p.service().recoverPending()
  precondition(recovered.skippedForeignTransactions==1 && recovered.failedCodes.isEmpty && p.verifyCalls==1 && p.acknowledgements==["native-tx-1"])
  let balanceFailure=try RechargeProbe("balance");defer{balanceFailure.cleanup()};let b=balanceFailure.service();balanceFailure.failBalance=true
  do{_=try await b.purchase(productID:"fixture.100");fatalError("Balance failure swallowed")}catch WevVGlazeNetworkError.http(503){}
  precondition(balanceFailure.acknowledgements.isEmpty && balanceFailure.inbox.count==1)
  guard case .credited(let balance)=try await balanceFailure.service().purchase(productID:"fixture.100")else{fatalError("Verified retry failed")}
  precondition(balance==901 && balanceFailure.creates==1 && balanceFailure.storePurchases==1 && balanceFailure.verifyCalls==1)
  let ackFailure=try RechargeProbe("ack");defer{ackFailure.cleanup()};ackFailure.failACK=true
  do{_=try await ackFailure.service().purchase(productID:"fixture.100");fatalError("ACK failure swallowed")}catch WevVGlazePurchaseError.nativeFailed{}
  _=try await ackFailure.service().purchase(productID:"fixture.100")
  precondition(ackFailure.creates==1 && ackFailure.storePurchases==1 && ackFailure.verifyCalls==1 && ackFailure.inbox.isEmpty)
  let cancelled=try RechargeProbe("cancel");defer{cancelled.cleanup()};cancelled.mode="cancelled"
  guard case .cancelled=try await cancelled.service().purchase(productID:"fixture.100")else{fatalError("Cancel misclassified")}
  precondition(cancelled.verifyCalls==0 && cancelled.acknowledgements.isEmpty)
  let pending=try RechargeProbe("pending");defer{pending.cleanup()};pending.mode="pending"
  guard case .pending=try await pending.service().purchase(productID:"fixture.100")else{fatalError("Pending misclassified")}
  precondition(pending.verifyCalls==0 && pending.acknowledgements.isEmpty)
  pending.inbox=[pending.material(order:pending.lastParams["orderCode"] as! String,transaction:"native-late")]
  let late=try await pending.service().recoverPending()
  precondition(late.creditedTransactions==1 && late.balance==901 && pending.inbox.isEmpty && pending.acknowledgements==["native-late"])
  let switched=try RechargeProbe("switch");defer{switched.cleanup()};switched.switchDuringPurchase=true
  do{_=try await switched.service().purchase(productID:"fixture.100");fatalError("Account switch accepted")}catch WevVGlazeNativeRechargeService.RechargeError.sessionChanged{}
  precondition(switched.verifyCalls==0 && switched.acknowledgements.isEmpty && switched.inbox.count==1)
  let other=try await switched.service().recoverPending();precondition(other.pendingOrders==0 && switched.inbox.count==1)
  switched.context=WevVGlazeNativeRechargeService.Context(ownerID:"7",appID:"fixture",environmentID:switched.context.environmentID,sessionEpoch:3)
  let original=try await switched.service().recoverPending();precondition(original.creditedTransactions==1 && switched.inbox.isEmpty)
  let rejected=try RechargeProbe("verify");defer{rejected.cleanup()};rejected.failVerify=true
  do{_=try await rejected.service().purchase(productID:"fixture.100");fatalError("Verification failure accepted")}catch WevVGlazeNetworkError.business("999",_){}
  precondition(rejected.acknowledgements.isEmpty && rejected.inbox.count==1)
  let retry=try await rejected.service().recoverPending();precondition(!retry.failedCodes.isEmpty && rejected.inbox.count==1 && rejected.acknowledgements.isEmpty)
  rejected.failVerify=false
  _=try await rejected.service().purchase(productID:"fixture.100")
  precondition(rejected.creates==1 && rejected.storePurchases==1 && rejected.inbox.isEmpty)
  let unknown=try RechargeProbe("unknown");defer{unknown.cleanup()}
  do{_=try await unknown.service().purchase(productID:"made-up");fatalError("Missing SKU fabricated")}catch WevVGlazeNativeRechargeService.RechargeError.unavailableProduct{}
  precondition(unknown.creates==0 && unknown.storePurchases==0)
  let malformed=try RechargeProbe("channel");defer{malformed.cleanup()};malformed.badCreateChannel=true
  do{_=try await malformed.service().purchase(productID:"fixture.100");fatalError("Wrong channel accepted")}catch WevVGlazeNativeRechargeService.RechargeError.invalidResponse{}
  precondition(malformed.storePurchases==0)
  print("PASS: exact server SKU/channel/order/receipt contracts; native-origin durable journal before StoreKit; true server balance; H5 orders never verified/ACKed; cancel/pending; late/restarted recovery; no duplicate purchase after balance/ACK failure; verification errors retained; account isolation; missing/wrong SKU rejection")
 }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-native-recharge-test-') as d:
        path=Path(d);(path/'Stubs.swift').write_text(stubs);(path/'Verify.swift').write_text(tests)
        exe=path/'Verify'
        subprocess.run(['xcrun','swiftc','-D','WEVV_PURCHASE_TESTING','-swift-version','5','-default-isolation','MainActor','-parse-as-library','-module-cache-path','/private/tmp/wevv-native-recharge-module-cache',str(path/'Stubs.swift'),str(APP/'WevEnd/WevVGlazeNetworkFoundation.swift'),str(APP/'WevEnd/WevVGlazePurchaseCoordinator.swift'),str(APP.parent/'WeeNo/Sources/WevEnd/WevVGlazeNativeRechargeService.swift'),str(path/'Verify.swift'),'-o',str(exe)],check=True)
        subprocess.run([str(exe)],check=True)


if __name__=='__main__':main()
