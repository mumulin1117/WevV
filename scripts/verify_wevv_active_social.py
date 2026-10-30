#!/usr/bin/env python3
"""Exercise the active public-card/follow/report service with offline transport fixtures."""
from wevv_swift_source import STRING_HELPER
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/WevEnd/WevVGlazeRosterCell.swift'
CHECKS = r'''
import Foundation
@MainActor final class SocialFixture {
    enum FixtureError: Error { case failed }
    struct Call { let path: String; let body: [String: Any]; let browsing: Bool }
    var boundary = briocheCraftStudio(benchRestDetail: 1, beginvelvetyCrumbSheen: "offline", cancelGlazeLoading: 7)
    var calls: [Call] = []
    var response = Data("{}".utf8)
    var action: (() throws -> Void)?
    func service() -> WevVGlazeRosterCell {
        WevVGlazeRosterCell(avatarButton: { _ in self.boundary }, cinnamonVector: { path, body, browsing in
            self.calls.append(Call(path: path, body: body, browsing: browsing))
            try self.action?()
            return self.response
        }, bakeryPinKey: { expected in
            guard expected == self.boundary else { throw CancellationError() }
        })
    }
}
@main struct Probe {
    @MainActor static func main() async throws {
        var cases = 0
        func check(_ value: Bool) { precondition(value); cases += 1 }
        func rejects(_ operation: () async throws -> Void) async throws {
            do { try await operation() } catch { cases += 1; return }
            throw NSError(domain: "ActiveSocialVerification", code: 1)
        }
        let fixture = SocialFixture(), service = SocialFixture()
        let client = fixture.service()
        fixture.response = Data(#"{"userId":21,"nickName":" Alice ","roomName":"Different"}"#.utf8)
        check(try await client.beginGlazeNativeOverlay(cocoaWeekendFestival: 21) == "Alice")
        check(fixture.calls.last?.path == "/_v2/user/personalCard" && fixture.calls.last?.browsing == true)
        check(fixture.calls.last?.body["userId"] as? Int64 == 21)
        fixture.response = Data(#"{"roomName":"Not a user name"}"#.utf8)
        check(try await client.beginGlazeNativeOverlay(cocoaWeekendFestival: 21) == nil)
        for response in [#"{"userId":22,"nickName":"Wrong"}"#, #"{"userId":true}"#, "[]"] {
            fixture.response = Data(response.utf8)
            try await rejects { _ = try await client.beginGlazeNativeOverlay(cocoaWeekendFestival: 21) }
        }
        let before = fixture.calls.count
        try await rejects { _ = try await client.beginGlazeNativeOverlay(cocoaWeekendFestival: 0) }
        check(fixture.calls.count == before)
        fixture.response = Data("{}".utf8)
        try await client.citrusCounter(cocoaWeekendFestival: 21, blueberryCustard: true)
        check(fixture.calls.last?.path == "/_v2/user/followUser" && fixture.calls.last?.browsing == false)
        check(fixture.calls.last?.body["followType"] as? Int == 1)
        try await client.citrusCounter(cocoaWeekendFestival: 21, blueberryCustard: false)
        check(fixture.calls.last?.body["followType"] as? Int == 2)
        try await rejects { try await client.citrusCounter(cocoaWeekendFestival: 7, blueberryCustard: true) }
        try await client.cheesecakeMousse(cocoaWeekendFestival: 21, cocoaDrinkComplement: " spam ", beginGlazeContextPreparation: "detail", buildTastingReportSheet: 99)
        check(fixture.calls.last?.path == "/_v2/feedback/save")
        check(fixture.calls.last?.body["feedbackType"] as? String == "SPAM")
        check(fixture.calls.last?.body["suggestion"] as? String == "[Post#99] detail")
        try await client.cheesecakeMousse(cocoaWeekendFestival: 21, cocoaDrinkComplement: "OTHER", beginGlazeContextPreparation: String(repeating: "🍩", count: 300))
        check((fixture.calls.last?.body["suggestion"] as? String)?.utf16.count == 200)
        for type in ["", "UNKNOWN"] { try await rejects { try await client.cheesecakeMousse(cocoaWeekendFestival: 21, cocoaDrinkComplement: type, beginGlazeContextPreparation: nil) } }
        try await rejects { try await client.cheesecakeMousse(cocoaWeekendFestival: 7, cocoaDrinkComplement: "OTHER", beginGlazeContextPreparation: nil) }
        try await rejects { try await client.cheesecakeMousse(cocoaWeekendFestival: 21, cocoaDrinkComplement: "OTHER", beginGlazeContextPreparation: nil, buildTastingReportSheet: 0) }
        fixture.boundary = briocheCraftStudio(benchRestDetail: 2, beginvelvetyCrumbSheen: "offline", cancelGlazeLoading: nil)
        try await rejects { try await client.citrusCounter(cocoaWeekendFestival: 21, blueberryCustard: true) }
        fixture.response = Data(#"{"nickName":"Guest visible"}"#.utf8)
        check(try await client.beginGlazeNativeOverlay(cocoaWeekendFestival: 21) == "Guest visible")
        fixture.boundary = briocheCraftStudio(benchRestDetail: 3, beginvelvetyCrumbSheen: "offline", cancelGlazeLoading: 7)
        fixture.action = { fixture.boundary = briocheCraftStudio(benchRestDetail: 4, beginvelvetyCrumbSheen: "other", cancelGlazeLoading: 8) }
        do { try await client.citrusCounter(cocoaWeekendFestival: 21, blueberryCustard: true); preconditionFailure() }
        catch is CancellationError { cases += 1 }
        fixture.action = { throw SocialFixture.FixtureError.failed }
        do { try await client.citrusCounter(cocoaWeekendFestival: 21, blueberryCustard: true); preconditionFailure() }
        catch SocialFixture.FixtureError.failed { cases += 1 }
        check(service.calls.isEmpty)
        print("Active social source checks passed: \(cases)")
    }
}
'''

def main():
    with tempfile.TemporaryDirectory(prefix='wevv-active-social-') as temporary:
        folder = Path(temporary)
        probe = folder / 'Probe.swift'
        probe.write_text(CHECKS)
        binary = folder / 'probe'
        subprocess.run(['xcrun', 'swiftc', str(STRING_HELPER), '-swift-version', '5', '-parse-as-library', '-D',
                        'WEVV_DONUT_TESTING', '-module-cache-path', str(folder / 'modules'),
                        str(SOURCE), str(probe), '-o', str(binary)], check=True)
        subprocess.run([str(binary)], check=True)

if __name__ == '__main__':
    main()
