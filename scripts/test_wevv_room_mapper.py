#!/usr/bin/env python3
"""Compile the production room mapper and exact project room model for offline contract checks."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'WevSweetgd/WevSweetgd'


def main():
    source = (APP / 'kettleGlazeSequence.swift').read_text()
    mode = source[source.index('enum chocolateCompote:'):source.index('struct pearFilling:')]
    model = source[source.index('struct pearFilling:'):source.index('struct butteryTexture:')]
    repository_start = source.index('    func steamExpansionStudy()')
    repository_methods = source[repository_start:source.index('    func starchGelatinizationStudy(', repository_start)]
    repository = '''import Foundation
@MainActor final class BrostingmellowCoconutEssence {
    static let shared = BrostingmellowCoconutEssence()
    var calls: [(String, [String: Any])] = []
    var voiceCalls: [(String, glazeVaultHeroLayer?, Int)] = []
    var prepareCount = 0
    func prepare() async throws { prepareCount += 1 }
    func browsingOPI(path: String, body: [String: Any]) async throws -> Data {
        calls.append((path, body))
        return Data("{\\"total\\":15,\\"rows\\":[{\\"id\\":9,\\"userId\\":5,\\"liveName\\":\\"Room title\\"}]}".utf8)
    }
    func voiceList(path: String, cursor: glazeVaultHeroLayer? = nil, pageSize: Int = 10) async throws -> Data {
        voiceCalls.append((path, cursor, pageSize))
        return Data(#"[{"id":5,"ownerId":7,"roomStatus":1,"score":-10,"snapshotId":"snapshot-next"}]"#.utf8)
    }
}
@MainActor final class WevVGlazeContentRepository {
''' + repository_methods + '\n}\n'
    checks = r'''import Foundation
@main struct RoomMapperVerification {
    static func data(_ value: Any) throws -> Data { try JSONSerialization.data(withJSONObject: value) }
    @MainActor static func main() async throws {
        let liveBody = Data("""
        {"total":1,"rows":[{"id":"9007199254740993","userId":9223372036854775807,"nickname":"Host","icon":"https://example.invalid/avatar.png","backgroundImgUrl":"https://example.invalid/cover.png","liveName":"Actual room title","liveDescribe":"Room description","anchorLevelName":"Lv 9","yxAccid":"host-im","followFlag":1,"followed":0,"liveRoomState":2,"yxRoomId":"111","agoraChannelId":"222","joinNum":"123"}]}
        """.utf8)
        let live = try XunSugarRosterbrownButterDrizzle.live(liveBody)
        precondition(live.count == 1)
        precondition(live[0].passionfruitMousse == "9007199254740993" && live[0].glazeHostID == "9223372036854775807")
        precondition(live[0].lemonCurd == .blueberryCustard && live[0].yuzuCustard == "9223372036854775807")
        precondition(live[0].pearCenter == "https://example.invalid/avatar.png" && live[0].glazeIMAccount == "host-im" && live[0].figFilling == 123)
        precondition(live[0].appleCompote == "https://example.invalid/cover.png" && live[0].peachCream == "Host")
        precondition(live[0].glazeFollowed == true)
        precondition(live[0].glazeIsLive)
        let liveStates: [Any] = [2, "2", " 2 ", 1, "1", 0, true, false, NSNull(), "true", "", "bad", 2.5, "2.5"]
        for (index, state) in liveStates.enumerated() {
            let rooms = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [["id": 9, "userId": 5, "liveRoomState": state]]]))
            precondition(rooms.count == 1 && rooms[0].glazeIsLive == (index < 3))
        }
        let noLiveState = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [["id": 9, "userId": 5, "liveFlag": 1, "joinNum": 100]]]))
        precondition(noLiveState.count == 1 && !noLiveState[0].glazeIsLive,
                     "Legacy live flags and audience counts must not imply a live room")
        precondition(live[0].limeJam == "Actual room title")
        let titleFallbacks = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [
            ["id": 1, "userId": 5, "liveName": "   ", "liveDescribe": " Description ", "nickname": "Host", "anchorLevelName": "Lv 1"],
            ["id": 2, "userId": 5, "liveName": NSNull(), "liveDescribe": "\n", "nickname": "Host", "anchorLevelName": "Lv 2"],
            ["id": 3, "userId": 5, "anchorLevelName": "Lv 3"],
            ["id": 4, "userId": 5, "liveName": " Title ", "liveDescribe": "Description", "nickname": "Host", "anchorLevelName": "Lv 4"]
        ]]))
        precondition(titleFallbacks.map(\.limeJam) == ["Description", "Host", "WevV", "Title"])
        let livePage = try XunSugarRosterbrownButterDrizzle.livePage(liveBody)
        precondition(livePage.total == 1 && livePage.rawCount == 1 && livePage.rooms.count == 1)
        let mixedPage = try XunSugarRosterbrownButterDrizzle.livePage(data(["total": "24", "rows": [
            ["id": 1, "userId": 5], ["id": 2], ["id": 3, "userId": 6]
        ]]))
        precondition(mixedPage.total == 24 && mixedPage.rawCount == 3 && mixedPage.rooms.count == 2)
        let invalidTotals: [Any] = [true, false, -1, "-1", NSNull(), "bad", 1.5, "2.5", "9223372036854775808", [], [:]]
        for total in invalidTotals {
            let page = try XunSugarRosterbrownButterDrizzle.livePage(data(["total": total, "rows": []]))
            precondition(page.total == nil && page.rawCount == 0 && page.rooms.isEmpty)
        }
        let absentTotal = try XunSugarRosterbrownButterDrizzle.livePage(data(["rows": []]))
        let zeroTotal = try XunSugarRosterbrownButterDrizzle.livePage(data(["total": 0, "rows": []]))
        precondition(absentTotal.total == nil && zeroTotal.total == 0)
        let special = pearFilling(passionfruitMousse: "9", lemonCurd: .blueberryCustard, limeJam: "A+B & C", yuzuCustard: "99", peachCream: "Host", pearCenter: "https://example.invalid/a+b.png", appleCompote: nil, figFilling: 0, custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false, glazeHostID: "99", glazeIMAccount: "im+a", glazeFollowed: true)
        let entry = chosenTiles.room(special).makeURL(indexURL: URL(fileURLWithPath: "/bundle/index.html"))!.absoluteString
        precondition(entry.contains("#/live/room/9?") && entry.contains("hostId=99") && entry.contains("displayName=A%2BB%20%26%20C"))
        precondition(entry.contains("avatarUrl=https%3A%2F%2Fexample.invalid%2Fa%2Bb.png") && entry.contains("imAccount=im%2Ba") && entry.contains("followed=1"))
        precondition(!entry.contains("token=") && !entry.contains("userId="))
        let invalidLive: [[String: Any]] = [
            ["userId": 5, "yxRoomId": "901", "agoraChannelId": "902"],
            ["userId": 5, "agoraLiveSimpleVO": ["id": 9, "userId": 5]],
            ["userId": 5, "agoraLiveSimpleVO": NSNull()],
            ["id": 9, "yxAccid": "5"],
            ["id": true, "userId": 5],
            ["id": "9223372036854775808", "userId": 5],
            ["id": -1, "userId": 5],
            ["id": 1.5, "userId": 5],
            ["id": "0", "userId": 5],
            ["id": 9, "userId": false],
            ["id": 9, "userId": "9223372036854775808"]
        ]
        let rejectedLive = try XunSugarRosterbrownButterDrizzle.live(data(["rows": invalidLive]))
        precondition(rejectedLive.isEmpty)
        let fallback = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [["id": 9, "userId": "5", "nickname": "Host", "icon": "avatar", "followed": "1", "joinNum": -1]]]))
        precondition(fallback.count == 1 && fallback[0].glazeHostID == "5" && fallback[0].passionfruitMousse == "9")
        precondition(fallback[0].appleCompote == "avatar" && fallback[0].limeJam == "Host" && fallback[0].figFilling == 0 && fallback[0].glazeFollowed == true)
        let flagInputs: [Any] = [true, false, 1, 0, "1", "0", 2, -1, "true", "2", NSNull(), 0.5]
        let expectedFlags: [Bool?] = [true, false, true, false, true, false, nil, nil, nil, nil, nil, nil]
        for (input, expected) in zip(flagInputs, expectedFlags) {
            let rows = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [["id": 9, "userId": 5, "followFlag": input]]]))
            precondition(rows.count == 1 && rows[0].glazeFollowed == expected)
        }
        let priority = try XunSugarRosterbrownButterDrizzle.live(data(["rows": [
            ["id": 1, "userId": 5, "followFlag": 0, "followed": 1],
            ["id": 2, "userId": 5, "followFlag": NSNull(), "followed": 1],
            ["id": 3, "userId": 5, "followFlag": 2, "followed": 1]
        ]]))
        precondition(priority.map(\.glazeFollowed) == [false, true, nil])
        let numericIDs = try XunSugarRosterbrownButterDrizzle.live(Data("{\"rows\":[{\"id\":9223372036854775807,\"userId\":\"9007199254740993\"}]}".utf8))
        precondition(numericIDs[0].passionfruitMousse == "9223372036854775807" && numericIDs[0].glazeHostID == "9007199254740993")
        let voiceBody = Data("""
        [{"id":9223372036854775807,"ownerId":"9007199254740993","roomName":"Voice A","roomStatus":1,"yxRoomId":"777","agoraChannelId":"888","heatValue":20,"roomAvatar":"https://example.invalid/room.png","onlineUserList":[{"avatar":"https://example.invalid/user.png"}]},
         {"id":"2","ownerId":3,"roomStatus":"3"},
         {"id":4,"ownerId":5,"roomStatus":0},
         {"id":6,"ownerId":7,"roomStatus":"2"}]
        """.utf8)
        let voice = try XunSugarRosterbrownButterDrizzle.voice(voiceBody, followed: false)
        precondition(voice.map(\.passionfruitMousse) == ["9223372036854775807", "2"])
        precondition(voice[0].glazeHostID == "9007199254740993" && voice[0].lemonCurd == .blackberryCream)
        precondition(voice[0].appleCompote == "https://example.invalid/room.png" && voice[0].custardCurd == ["https://example.invalid/user.png"])
        precondition(voice.allSatisfy { !$0.hazelnutCream && $0.glazeFollowed == false })
        precondition(voice.allSatisfy { !$0.glazeIsLive })
        precondition(voice[0].glazeOnlineCount == nil && voice[0].glazeAudienceText == "— online",
                     "Heat and sampled avatars cannot become an online total")
        let voiceCountCases: [([String: Any], Int64?)] = [
            (["audienceNum": 12, "onlineCount": 25, "heatValue": 999], 12),
            (["audienceNum": 0, "onlineCount": 25], 0),
            (["audienceNum": " 8 "], 8),
            (["onlineCount": 7], 7),
            (["audienceNum": NSNull(), "onlineCount": "9"], 9),
            (["audienceNum": -1, "onlineCount": 4], 4),
            (["onlineCount": 0, "onlineUserList": [["avatar": "a"], ["avatar": "b"]]], 0),
            (["heatValue": 999, "groveAttendance": 10], nil),
            ([:], nil)
        ]
        for (fields, expected) in voiceCountCases {
            var row: [String: Any] = ["id": 9, "ownerId": 5, "roomStatus": 1]
            row.merge(fields) { _, value in value }
            for followed in [false, true] {
                let rooms = try XunSugarRosterbrownButterDrizzle.voice(data([row]), followed: followed)
                precondition(rooms.count == 1 && rooms[0].glazeOnlineCount == expected)
                precondition(rooms[0].figFilling == (expected ?? 0))
                precondition(rooms[0].glazeAudienceText == (expected.map { "\($0) online" } ?? "— online"))
            }
        }
        for invalid: Any in [true, false, -1, 1.5, "2.5", "bad", "", NSNull(), "9223372036854775808"] {
            let rooms = try XunSugarRosterbrownButterDrizzle.voice(data([["id": 9, "ownerId": 5, "audienceNum": invalid, "onlineCount": invalid, "heatValue": 300]]), followed: false)
            precondition(rooms[0].glazeOnlineCount == nil && rooms[0].glazeAudienceText == "— online")
        }
        precondition(live[0].figFilling == 123 && live[0].glazeAudienceText == "123 online")
        precondition(chosenTiles.room(voice[0]).makeURL(indexURL: URL(fileURLWithPath: "/bundle/index.html"))!.absoluteString.hasSuffix("#/party/room/9223372036854775807"))
        let followed = try XunSugarRosterbrownButterDrizzle.voice(voiceBody, followed: true)
        precondition(followed.allSatisfy { $0.hazelnutCream && $0.glazeFollowed == true })
        let cursorPage = try XunSugarRosterbrownButterDrizzle.voicePage(data([
            ["id": 1, "ownerId": 5, "roomStatus": 1, "score": "9007199254740993"],
            ["id": 2, "ownerId": 6, "roomStatus": 0, "score": String(Int64.min), "snapshotId": "snapshot-last"]
        ]), followed: false)
        precondition(cursorPage.rawCount == 2 && cursorPage.rooms.map(\.passionfruitMousse) == ["1"])
        precondition(cursorPage.nextCursor == .init(offset: Int64.min, snapshotID: "snapshot-last"))
        let filteredLastPage = try XunSugarRosterbrownButterDrizzle.voicePage(data([
            ["id": 1, "ownerId": 5, "score": 4],
            ["id": false, "ownerId": 6, "score": "9007199254740993"]
        ]), followed: true)
        precondition(filteredLastPage.rawCount == 2 && filteredLastPage.rooms.count == 1)
        precondition(filteredLastPage.nextCursor == .init(offset: 9007199254740993, snapshotID: nil))
        for score: Int64 in [0, -1, Int64.min, Int64.max] {
            let page = try XunSugarRosterbrownButterDrizzle.voicePage(data([["id": 1, "ownerId": 5, "score": score, "snapshotId": "   "]]), followed: false)
            precondition(page.nextCursor == .init(offset: score, snapshotID: nil))
        }
        let numericSnapshot = try XunSugarRosterbrownButterDrizzle.voicePage(data([["id": 1, "ownerId": 5, "score": 0, "snapshotId": Int64.max]]), followed: false)
        precondition(numericSnapshot.nextCursor == .init(offset: 0, snapshotID: String(Int64.max)))
        let trimmedSnapshot = try XunSugarRosterbrownButterDrizzle.voicePage(data([["id": 1, "ownerId": 5, "score": 0, "snapshotId": "  snapshot-next  "]]), followed: false)
        precondition(trimmedSnapshot.nextCursor == .init(offset: 0, snapshotID: "snapshot-next"))
        let invalidScores: [Any] = [true, false, 1.5, "1.5", "9223372036854775808", "-9223372036854775809", NSNull(), "bad", [], [:]]
        for score in invalidScores {
            let page = try XunSugarRosterbrownButterDrizzle.voicePage(data([["id": 1, "ownerId": 5, "score": score]]), followed: false)
            precondition(page.rawCount == 1 && page.rooms.count == 1 && page.nextCursor == nil)
        }
        let missingLastScore = try XunSugarRosterbrownButterDrizzle.voicePage(data([["id": 1, "ownerId": 5, "score": 42], ["id": 2, "ownerId": 6]]), followed: false)
        precondition(missingLastScore.rawCount == 2 && missingLastScore.nextCursor == nil)
        let emptyVoicePage = try XunSugarRosterbrownButterDrizzle.voicePage(data([]), followed: false)
        precondition(emptyVoicePage.rooms.isEmpty && emptyVoicePage.rawCount == 0 && emptyVoicePage.nextCursor == nil)
        let invalidVoice: [[String: Any]] = [
            ["ownerId": 5, "yxRoomId": "1", "agoraChannelId": "2"],
            ["roomId": 4, "ownerId": 5], ["id": 1], ["id": true, "ownerId": 5],
            ["id": 1, "ownerId": false], ["id": "0", "ownerId": 5], ["id": 1.2, "ownerId": 5]
        ]
        let rejectedVoice = try XunSugarRosterbrownButterDrizzle.voice(data(invalidVoice), followed: false)
        precondition(rejectedVoice.isEmpty)
        do { _ = try XunSugarRosterbrownButterDrizzle.voice(data(["rows": []]), followed: false); fatalError("SAPI wrapped rows accepted") }
        catch GlazeVaultTradeError.invalidResponse { }
        do { _ = try XunSugarRosterbrownButterDrizzle.live(data([])); fatalError("OPI array accepted") }
        catch GlazeVaultTradeError.invalidResponse { }
        do { _ = try XunSugarRosterbrownButterDrizzle.live(data(["rows": "invalid"])); fatalError("Invalid pool rows accepted") }
        catch GlazeVaultTradeError.invalidResponse { }
        let emptyLive = try XunSugarRosterbrownButterDrizzle.live(data(["rows": []]))
        let emptyVoice = try XunSugarRosterbrownButterDrizzle.voice(data([]), followed: false)
        precondition(emptyLive.isEmpty && emptyVoice.isEmpty)
        let repository = WevVGlazeContentRepository()
        let pageTwo = try await repository.livePage(currentPage: 2, pageSize: 10)
        precondition(pageTwo.total == 15 && pageTwo.rawCount == 1 && pageTwo.rooms[0].limeJam == "Room title")
        let pageTwoCall = BrostingmellowCoconutEssence.shared.calls.last!
        precondition(pageTwoCall.0 == "/_v2/discover/live/pool")
        precondition(pageTwoCall.1["currentPage"] as? Int == 2 && pageTwoCall.1["pageSize"] as? Int == 10)
        precondition(pageTwoCall.1["ids"] is NSNull && pageTwoCall.1["countryIds"] as? String == "" && pageTwoCall.1["isMiddleEast"] as? Bool == false)
        _ = try await repository.livePage(currentPage: -2, pageSize: 100)
        precondition(BrostingmellowCoconutEssence.shared.calls.last!.1["currentPage"] as? Int == 1 && BrostingmellowCoconutEssence.shared.calls.last!.1["pageSize"] as? Int == 30)
        _ = try await repository.livePage(currentPage: 3, pageSize: 0)
        precondition(BrostingmellowCoconutEssence.shared.calls.last!.1["currentPage"] as? Int == 3 && BrostingmellowCoconutEssence.shared.calls.last!.1["pageSize"] as? Int == 1)
        let firstPage = try await repository.steamExpansionStudy()
        precondition(firstPage.count == 1 && BrostingmellowCoconutEssence.shared.calls.last!.1["currentPage"] as? Int == 1)
        precondition(BrostingmellowCoconutEssence.shared.prepareCount == 4)
        let voiceCursor = glazeVaultHeroLayer(offset: Int64.max, snapshotID: "request-snapshot")
        let nextVoicePage = try await repository.voicePage(carnivalGlazeShowcase: .cherryCenter, cursor: voiceCursor, pageSize: 8)
        let voiceCall = BrostingmellowCoconutEssence.shared.voiceCalls.last!
        precondition(voiceCall.0 == "/sapi/weidou/v1/client/party/room/followed/list" && voiceCall.1 == voiceCursor && voiceCall.2 == 8)
        precondition(nextVoicePage.rooms.count == 1 && nextVoicePage.rooms[0].hazelnutCream && nextVoicePage.rawCount == 1)
        precondition(nextVoicePage.nextCursor == .init(offset: -10, snapshotID: "snapshot-next"))
        let initialVoiceRooms = try await repository.batterConsistencyDetail()
        let initialVoiceCall = BrostingmellowCoconutEssence.shared.voiceCalls.last!
        precondition(initialVoiceRooms.count == 1 && !initialVoiceRooms[0].hazelnutCream)
        precondition(initialVoiceCall.0 == "/sapi/weidou/v1/client/party/room/list" && initialVoiceCall.1 == nil && initialVoiceCall.2 == 10)
        print("PASS: real pool/voice mapper, model, H5 entry and repository; exact cursor precision; raw-last-row score/snapshot; missing/invalid score termination; optional snapshots; filter-specific pagination; legacy first-page compatibility; live title/total/page limits and empty/error states")
    }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-room-mapper-') as output:
        destination = Path(output)
        models = destination / 'ProjectRoomModel.swift'
        repository_source = destination / 'ProjectLiveRepository.swift'
        tests = destination / 'MapperVerification.swift'
        models.write_text('import Foundation\n' + mode + model)
        repository_source.write_text(repository)
        tests.write_text(checks)
        executable = destination / 'MapperVerification'
        subprocess.run(['xcrun', 'swiftc', '-swift-version', '5', '-default-isolation', 'MainActor', '-parse-as-library', '-module-cache-path', '/private/tmp/wevv-room-mapper-module-cache', str(models), str(repository_source), str(APP / 'WevEnd/NertyuChoiceStackLayer.swift'), str(APP / 'WevEnd/honeyLavenderCombination.swift'), str(APP / 'WevEnd/glazeMarkLabel.swift'), str(APP / 'WevEnd/chosenTiles.swift'), str(tests), '-o', str(executable)], check=True)
        subprocess.run([str(executable)], check=True)


if __name__ == '__main__':
    main()
