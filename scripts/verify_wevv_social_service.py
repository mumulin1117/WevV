#!/usr/bin/env python3
"""Verify the production native social service with offline transport fixtures."""
from pathlib import Path
import re
import subprocess
import tempfile
from wevv_archive_source import read_archive


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/WevEnd/WevVGlazeRosterCell.swift'
MODELS = ROOT / "WevSweetgd/WevSweetgd/kettleGlazeSequence.swift"

TESTS = r'''
enum FixtureError: Error { case failed, noSession }

@MainActor
final class SocialFixture {
    struct Call { let path: String; let body: [String: Any]; let browsing: Bool }
    var boundary = glazeVaultGrid(epoch: 1, environmentID: "test-fixture", ownerID: 7)
    var calls: [Call] = []
    var responses: [Data] = []
    var action: ((String, [String: Any], Bool) throws -> Data)?
    func json(_ object: Any) throws -> Data { try JSONSerialization.data(withJSONObject: object, options: [.fragmentsAllowed]) }
    func service() -> WevVGlazeRosterCell {
        WevVGlazeRosterCell(begin: { authenticated in
            if authenticated, self.boundary.ownerID == nil { throw FixtureError.noSession }
            return self.boundary
        }, send: { path, body, browsing in
            self.calls.append(Call(path: path, body: body, browsing: browsing))
            if let action = self.action { return try action(path, body, browsing) }
            guard !self.responses.isEmpty else { throw FixtureError.failed }
            return self.responses.removeFirst()
        }, check: { expected in
            guard self.boundary == expected else { throw CancellationError() }
        })
    }
}

@main
struct SocialServiceVerification {
    @MainActor
    static func main() async throws {
        var passed = 0
        func check(_ value: @autoclosure () throws -> Bool, _ label: String) throws {
            guard try value() else { throw NSError(domain: "SocialVerification", code: 1, userInfo: [NSLocalizedDescriptionKey: label]) }
            passed += 1
        }
        func rejects(_ label: String, cancellation: Bool = false, _ body: () async throws -> Void) async throws {
            do { try await body() }
            catch {
                if cancellation, !(error is CancellationError) { throw error }
                passed += 1
                return
            }
            throw NSError(domain: "SocialVerification", code: 2, userInfo: [NSLocalizedDescriptionKey: label])
        }
        let fixture = SocialFixture()
        let service = fixture.service()
        fixture.responses = [try fixture.json(["userId": 21, "nickName": " Alice ", "roomName": "A different room"])]
        let beforeDisplayName = fixture.calls.count
        let displayName = try await service.displayName(userID: 21)
        try check(displayName == "Alice", "display name uses documented public nickName")
        try check(fixture.calls.count == beforeDisplayName + 1 && fixture.calls.last?.path == "/_v2/user/personalCard" && fixture.calls.last?.body["userId"] as? Int64 == 21 && fixture.calls.last?.browsing == true,
                  "display name uses one public card request and no relationship query for signed-in viewers")
        fixture.responses = [try fixture.json(["userId": 21, "nickName": " \n ", "roomName": "Room name", "ownerName": "Room owner field"])]
        let emptyDisplayName = try await service.displayName(userID: 21)
        try check(emptyDisplayName == nil, "blank username never falls back to room or placeholder names")
        fixture.responses = [try fixture.json(["nickName": "Documented optional identity"])]
        let optionalIdentityName = try await service.displayName(userID: 21)
        try check(optionalIdentityName == "Documented optional identity", "missing optional returned userId follows public card contract")
        fixture.responses = [try fixture.json(["userId": 21, "nickname": "Wrong spelling", "ownerInfo": ["nickname": "Nested room field"]])]
        let absentDisplayName = try await service.displayName(userID: 21)
        try check(absentDisplayName == nil, "missing nickName does not guess unrelated field aliases")
        fixture.responses = [try fixture.json(["userId": 22, "nickName": "Other user"])]
        try await rejects("display name rejects wrong returned identity") { _ = try await service.displayName(userID: 21) }
        fixture.responses = [try fixture.json(["userId": true, "nickName": "Invalid identity"])]
        try await rejects("display name rejects Boolean returned identity") { _ = try await service.displayName(userID: 21) }
        let beforeInvalidDisplayName = fixture.calls.count
        try await rejects("display name rejects invalid target") { _ = try await service.displayName(userID: 0) }
        try check(fixture.calls.count == beforeInvalidDisplayName, "invalid name target sends no request")
        fixture.responses = [try fixture.json(["userId": 21, "nickName": " Alice ", "icon": "https://example.invalid/a.png", "signature": "Sweet", "follow": "9", "fans": 8,
                                               "isFollow": true, "isBlocked": 1, "yxAccid": "nim-alice", "canChat": true, "isMutualFollow": true,
                                               "receivedLikeCount": 900, "photoList": [["photoUrl": "legacy"]], "city": "legacy"])]
        let profile = try await service.profile(userID: 21)
        try check(fixture.calls.first?.path == "/_v2/user/personalCard" && fixture.calls.first?.browsing == true && fixture.calls.first?.body["userId"] as? Int64 == 21, "public profile uses documented personalCard path and semantic body")
        try check(profile.gingerHoneyDrizzle == "Alice" && profile.yuzuHoneySwirl == "Sweet" && profile.tenderFinish == 9 && profile.crispyBite == 8 && profile.flakyLayer && profile.delicateCrust && profile.springyFinish == "nim-alice", "documented profile core mapped")
        try check(profile.backendCanChat == nil && profile.backendMutualFollow == nil && profile.fluffyTexture.isEmpty && profile.softCloudDough.isEmpty && profile.crunchyDough == 0, "Cover-only extensions do not create authoritative permission or data")
        fixture.responses = [try fixture.json(["userId": 21]), try fixture.json(["rows": [["userId": "21"], ["userId": 22]]])]
        let mutualProfile = try await service.profile(userID: 21)
        try check(mutualProfile.backendMutualFollow == true && mutualProfile.velvetyCrumb && mutualProfile.backendCanChat == nil, "real friends list derives mutual state without inventing chat permission")
        try check(fixture.calls.last?.path == "/_v2/user/relations" && fixture.calls.last?.body["type"] as? Int == 1 && fixture.calls.last?.browsing == false, "mutual check uses confirmed authenticated friends contract")
        fixture.responses = [try fixture.json(["userId": 21]), try fixture.json(["rows": []])]
        let nonmutualProfile = try await service.profile(userID: 21)
        try check(nonmutualProfile.backendMutualFollow == false && !nonmutualProfile.velvetyCrumb && nonmutualProfile.backendCanChat == nil, "successful empty friends list is authoritative nonmutual only")
        fixture.responses = [try fixture.json(["userId": 21])]
        let uncertainProfile = try await service.profile(userID: 21)
        try check(uncertainProfile.backendMutualFollow == nil && uncertainProfile.backendCanChat == nil, "optional friends network failure preserves card and unknown relationship")
        fixture.responses = [try fixture.json(["userId": 21]), try fixture.json(["rows": [["nickname": "invalid friend"]]])]
        let malformedFriends = try await service.profile(userID: 21)
        try check(malformedFriends.backendMutualFollow == nil, "malformed auxiliary friends list does not fabricate false")
        fixture.responses = [try fixture.json(["userId": 7])]
        let beforeSelf = fixture.calls.count
        let ownProfile = try await service.profile(userID: 7)
        try check(fixture.calls.count == beforeSelf + 1 && ownProfile.backendMutualFollow == nil, "own profile avoids unnecessary mutual query")
        let longID: Int64 = 9_007_199_254_740_993
        fixture.responses = [try fixture.json(["userId": String(longID), "nickName": ""])]
        let longProfile = try await service.profile(userID: longID)
        try check(longProfile.vanillaBeanIcing == longID && longProfile.gingerHoneyDrizzle == "WevV", "Long IDs remain exact with display fallback")
        fixture.responses = [try fixture.json(["userId": 22])]
        try await rejects("mismatched profile identity rejected") { _ = try await service.profile(userID: 21) }
        fixture.responses = [try fixture.json(["userId": true])]
        try await rejects("Boolean is not user ID") { _ = try await service.profile(userID: 21) }
        fixture.responses = [try fixture.json(["userId": "9223372036854775808"])]
        try await rejects("overflow user ID rejected") { _ = try await service.profile(userID: 21) }
        fixture.responses = [try fixture.json([])]
        try await rejects("malformed profile is not fabricated success") { _ = try await service.profile(userID: 21) }
        try await rejects("nonpositive profile target rejected") { _ = try await service.profile(userID: 0) }
        fixture.responses = [try fixture.json(["rows": [["userId": "21", "nickname": "Alice", "followed": true, "online": true], ["userId": 21, "nickname": "duplicate"]]])]
        let following = try await service.relations(type: 3)
        try check(following.count == 1 && following[0].flakyLayer && following[0].crispEdgeCrust && fixture.calls.last?.body["type"] as? Int == 3 && fixture.calls.last?.browsing == false, "relations semantic request and stable dedup")
        fixture.responses = [try fixture.json(["rows": [["userId": 30]]])]
        let defaultFollowing = try await service.relations(type: 3)
        try check(defaultFollowing.first?.flakyLayer == true, "following membership fallback follows documented list type")
        fixture.responses = [try fixture.json(["rows": [["userId": 30, "followed": 1]]])]
        try await rejects("relation Boolean cannot be numeric flag") { _ = try await service.relations(type: 2) }
        fixture.responses = [try fixture.json(["rows": [["nickname": "missing ID"]]])]
        try await rejects("invalid relationship cannot become a phantom user") { _ = try await service.relations(type: 1) }
        try await rejects("invalid relation type rejected") { _ = try await service.relations(type: 4) }
        fixture.responses = [try fixture.json(["total": 100, "rows": (100..<200).map { ["userId": $0, "nickname": "Blocked"] }]),
                             try fixture.json(["total": 2, "rows": [["userId": 199], ["userId": 200]]])]
        let beforePages = fixture.calls.count
        let blocked = try await service.blockedUsers()
        try check(blocked.count == 101 && fixture.calls.count == beforePages + 2, "blocked total is a page count and does not end pagination")
        try check(fixture.calls[beforePages].body["currentPage"] as? Int == 1 && fixture.calls[beforePages + 1].body["currentPage"] as? Int == 2 && fixture.calls[beforePages].body["pageSize"] as? Int == 100, "blacklist uses documented numbered pages")
        let repeated = try fixture.json(["rows": (100..<200).map { ["userId": $0] }])
        fixture.responses = [repeated, repeated]
        try await rejects("repeated full page is an error, not complete partial data") { _ = try await service.blockedUsers() }
        fixture.action = { _, body, _ in
            let page = body["currentPage"] as! Int
            return try fixture.json(["rows": (0..<100).map { ["userId": page * 100 + $0] }])
        }
        let beforeBound = fixture.calls.count
        try await rejects("endless distinct full pages hit bounded error") { _ = try await service.blockedUsers() }
        try check(fixture.calls.count == beforeBound + 100, "blacklist pagination bound applied")
        fixture.action = nil
        fixture.responses = [Data("null".utf8), Data("null".utf8)]
        try await service.setFollow(userID: 21, follow: true)
        try check(fixture.calls.last?.path == "/_v2/user/followUser" && fixture.calls.last?.body["followUserId"] as? Int64 == 21 && fixture.calls.last?.body["followType"] as? Int == 1, "follow uses exact documented selector")
        try await service.setFollow(userID: 21, follow: false)
        try check(fixture.calls.last?.body["followType"] as? Int == 2, "unfollow is followType two")
        try await rejects("self follow rejected without mutation") { try await service.setFollow(userID: 7, follow: true) }
        fixture.responses = [Data("null".utf8), Data("null".utf8)]
        try await service.setBlocked(userID: 21, blocked: true, imAccount: "nim-alice")
        try check(fixture.calls.last?.path == "/_v2/user/block/add" && fixture.calls.last?.body["type"] as? Int == 1 && fixture.calls.last?.body["yxAccid"] as? String == "nim-alice", "block body is documented userId type and optional IM")
        try await service.setBlocked(userID: 21, blocked: false)
        try check(fixture.calls.last?.path == "/_v2/user/block/remove" && fixture.calls.last?.body["yxAccid"] == nil, "unblock preserves user selector")
        try await rejects("self block rejected") { try await service.setBlocked(userID: 7, blocked: true) }
        try await rejects("invalid IM data rejected") { try await service.setBlocked(userID: 21, blocked: true, imAccount: "nim\ninvalid") }
        fixture.responses = [Data("null".utf8)]
        try await service.report(userID: 21, type: " other ", detail: String(repeating: "🍩", count: 200), momentID: longID)
        let report = fixture.calls.last!
        let suggestion = report.body["suggestion"] as! String
        try check(report.path == "/_v2/feedback/save" && report.body["targetUserId"] as? Int64 == 21 && report.body["feedbackType"] as? String == "OTHER", "report targets real user through feedback")
        try check(suggestion.hasPrefix("[Post#\(longID)]") && suggestion.utf16.count <= 200 && report.body["id"] == nil && report.body["momentId"] == nil && report.body["roomId"] == nil, "Post ID is bounded operator context, not an invented backend selector")
        fixture.responses = [Data("null".utf8)]
        try await service.report(userID: 21, type: "SPAM", detail: nil)
        try check(fixture.calls.last?.body["suggestion"] == nil, "empty optional report description omitted")
        try await rejects("unsupported report category rejected") { try await service.report(userID: 21, type: "IMPERSONATION", detail: nil) }
        try await rejects("self report rejected") { try await service.report(userID: 7, type: "OTHER", detail: nil) }
        try await rejects("invalid Post ID rejected") { try await service.report(userID: 21, type: "OTHER", detail: nil, momentID: -1) }
        fixture.action = { path, _, _ in
            if path == "/_v2/user/personalCard" { return try fixture.json(["userId": 21]) }
            fixture.boundary = glazeVaultGrid(epoch: 1, environmentID: "test-fixture", ownerID: 8)
            return try fixture.json(["rows": []])
        }
        try await rejects("account change during auxiliary friends read cannot return old card", cancellation: true) { _ = try await service.profile(userID: 21) }
        fixture.action = { _, _, _ in
            fixture.boundary = glazeVaultGrid(epoch: 2, environmentID: "test-fixture", ownerID: 8)
            return try fixture.json(["userId": 21])
        }
        try await rejects("late profile from old account rejected", cancellation: true) { _ = try await service.profile(userID: 21) }
        fixture.action = { _, _, _ in
            fixture.boundary = glazeVaultGrid(epoch: 3, environmentID: "another-environment", ownerID: 8)
            throw FixtureError.failed
        }
        try await rejects("stale network failure also observes identity boundary", cancellation: true) { _ = try await service.profile(userID: 21) }
        fixture.action = nil
        fixture.boundary = glazeVaultGrid(epoch: 4, environmentID: "test-fixture", ownerID: nil)
        fixture.responses = [try fixture.json(["userId": 21, "nickName": "Public user"])]
        let guestDisplayName = try await service.displayName(userID: 21)
        try check(guestDisplayName == "Public user" && fixture.calls.last?.browsing == true, "guest recommendation names remain technical browsing")
        var appliedDisplayName = "Current list name"
        fixture.action = { _, _, _ in
            fixture.boundary = glazeVaultGrid(epoch: 5, environmentID: "test-fixture", ownerID: 8)
            return try fixture.json(["userId": 21, "nickName": "Late previous account name"])
        }
        try await rejects("late display name cannot cross account boundary", cancellation: true) {
            appliedDisplayName = try await service.displayName(userID: 21) ?? ""
        }
        try check(appliedDisplayName == "Current list name", "late account result never reaches caller writeback")
        fixture.action = { _, _, _ in
            fixture.boundary = glazeVaultGrid(epoch: 6, environmentID: "another-environment", ownerID: 8)
            return try fixture.json(["userId": 21, "nickName": "Late other environment name"])
        }
        try await rejects("display name observes environment boundary", cancellation: true) { _ = try await service.displayName(userID: 21) }
        fixture.action = nil
        fixture.boundary = glazeVaultGrid(epoch: 7, environmentID: "test-fixture", ownerID: nil)
        let beforeNameCancellation = fixture.calls.count
        let cancelledName = Task { @MainActor in try await service.displayName(userID: 21) }
        cancelledName.cancel()
        try await rejects("cancelled display name sends no request", cancellation: true) { _ = try await cancelledName.value }
        try check(fixture.calls.count == beforeNameCancellation, "display name cancellation precedes transport")
        let beforeGuest = fixture.calls.count
        try await rejects("guest cannot mutate follow state") { try await service.setFollow(userID: 21, follow: true) }
        try check(fixture.calls.count == beforeGuest, "guest mutation sends no request")
        fixture.responses = [try fixture.json(["userId": 21])]
        _ = try await service.profile(userID: 21)
        try check(fixture.calls.last?.browsing == true, "guest profile remains technical browsing")
        let beforeCancel = fixture.calls.count
        let cancelled = Task { @MainActor in try await service.profile(userID: 21) }
        cancelled.cancel()
        try await rejects("cancelled caller sends no request", cancellation: true) { _ = try await cancelled.value }
        try check(fixture.calls.count == beforeCancel, "cancellation precedes transport")
        print("Native social service: \(passed) offline fixture checks passed; no server requests or mutations performed.")
    }
}
'''


def main() -> None:
    models = MODELS.read_text() + "\n" + read_archive(ROOT / "WevSweetgd/WeeNo/Sources/kettleGlazeSequence.legacy-models.swift")
    declarations = []
    for name in ("meltawayCrumb", "goldenCrumbCenter"):
        match = re.search(r"struct " + name + r": Sendable \{.*?\n\}", models, re.S)
        if match is None:
            raise RuntimeError("Production model not found: " + name)
        declarations.append(match.group())
    with tempfile.TemporaryDirectory(prefix="wevv-social-test-") as temporary:
        directory = Path(temporary)
        source = directory / "SocialVerification.swift"
        historical = read_archive(ROOT / "WevSweetgd/WeeNo/Sources/WevEnd/WevVGlazeRosterCell.legacy-profile.swift")
        source.write_text(SOURCE.read_text() + "\n" + historical + "\n" + "\n".join(declarations) + "\n" + TESTS)
        executable = directory / "verify-social"
        subprocess.run(["xcrun", "swiftc", "-parse-as-library", "-swift-version", "5", "-D", "WEVV_SOCIAL_TESTING",
                        "-module-cache-path", str(directory / "modules"), str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True)
        print("Includes commented historical profile/relations fixtures; active displayName/follow/report remain production source.")


if __name__ == "__main__":
    main()
