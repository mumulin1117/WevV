#!/usr/bin/env python3
"""Run the shipping footer timer with fake views; no network or account actions."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift'


def main():
    source = SOURCE.read_text()
    method = source.split('    private func hideSugarLoading(', 1)[1].split('    private func homeLivePullDistance()', 1)[0]
    harness = '''import Foundation
@MainActor final class UIControl { var isHidden = false }
@MainActor final class Fixture {
    var deadline: [String: TimeInterval] = [:]
    let live = UIControl()
    let voice = UIControl()
    let moments = UIControl()
    var liveLoading = false
    var liveMore = false
    var liveFailed = false
    var voiceKey = "voice-0"
    func updateHomeLiveLoadMoreFooter() {
        live.isHidden = false
        hideSugarLoading(live, id: "live", isLoading: liveLoading, hasMore: liveMore, failed: liveFailed)
    }
    func updateVoiceRoomLoadMoreFooter() {
        voice.isHidden = false
        hideSugarLoading(voice, id: voiceKey, isLoading: false, hasMore: false, failed: false)
    }
    func refreshTastingRow() {
        moments.isHidden = false
        hideSugarLoading(moments, id: "moments", isLoading: false, hasMore: false, failed: false)
    }
    func tick() { updateHomeLiveLoadMoreFooter(); updateVoiceRoomLoadMoreFooter(); refreshTastingRow() }
    private func hideSugarLoading(''' + method + '''
}
@main struct Checks {
    @MainActor static func main() async throws {
        let fixture = Fixture()
        fixture.tick()
        precondition(!fixture.live.isHidden && !fixture.voice.isHidden && !fixture.moments.isHidden)
        let original = fixture.deadline["live"]!
        fixture.tick()
        precondition(fixture.deadline["live"] == original, "Scrolling must not restart the timer")
        fixture.voiceKey = "voice-1"
        fixture.updateVoiceRoomLoadMoreFooter()
        precondition(fixture.deadline.count == 4, "Voice filters and moments must retain separate windows")
        fixture.liveLoading = true
        fixture.updateHomeLiveLoadMoreFooter()
        precondition(fixture.deadline["live"] == nil)
        try await Task.sleep(nanoseconds: 2_150_000_000)
        precondition(!fixture.live.isHidden, "Stale expiry must not hide a new request")
        precondition(fixture.voice.isHidden, "No more must hide without another scroll event")
        precondition(fixture.moments.isHidden, "The Discover footer must also expire without scrolling")
        fixture.voiceKey = "voice-0"
        fixture.updateVoiceRoomLoadMoreFooter()
        precondition(fixture.voice.isHidden, "Returning to an expired filter must not replay the message")
        fixture.liveLoading = false
        fixture.updateHomeLiveLoadMoreFooter()
        precondition(!fixture.live.isHidden && fixture.deadline["live"]! > original)
        fixture.deadline["live"] = ProcessInfo.processInfo.systemUptime - 1
        fixture.updateHomeLiveLoadMoreFooter()
        precondition(fixture.live.isHidden)
        fixture.liveMore = true
        fixture.updateHomeLiveLoadMoreFooter()
        precondition(fixture.deadline["live"] == nil)
        fixture.liveMore = false
        fixture.liveFailed = true
        fixture.updateHomeLiveLoadMoreFooter()
        precondition(!fixture.live.isHidden && fixture.deadline["live"] == nil, "Failure must remain retryable")
        print("PASS: two-second expiry, repeated scroll, independent filters, refresh reset, stale callbacks and failure retry")
    }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-footer-') as temporary:
        folder = Path(temporary)
        swift = folder / 'Verification.swift'
        swift.write_text(harness)
        executable = folder / 'verification'
        subprocess.run(['xcrun', 'swiftc', '-parse-as-library', '-swift-version', '5',
                        '-module-cache-path', str(folder / 'modules'), str(swift), '-o', str(executable)], check=True)
        subprocess.run([str(executable)], check=True, timeout=15)


if __name__ == '__main__':
    main()
