#!/usr/bin/env python3
"""Run the shipping SDK2 codec, persistent cache, coordination and Bridge gates.

Only the Bundle/Caches I/O boundaries and iOS file-protection setting are
adapted to the macOS runner. Every cache is isolated under /private/tmp.
No service calls, user devices, credentials or cryptographic inputs are logged.
"""
import sys
sys.dont_write_bytecode = True

from pathlib import Path
import json
import re
import shutil
import subprocess
import tempfile

import wevv_room_bundle as bundletool

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'WevSweetgd/WevSweetgd/UKGlazeActortroller.swift'
RESOURCES = ROOT / 'WevSweetgd/WevSweetgd'


def method(source, declaration, next_declaration):
    return source[source.index(declaration):source.index(next_declaration, source.index(declaration))]


def check_run(command, stage):
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode:
        # Compiler diagnostics can quote generated source. Keep configuration,
        # key material and decrypted fixture contents out of test output.
        errors = [line.split('error:', 1)[1].strip() for line in result.stderr.splitlines() if 'error:' in line]
        raise RuntimeError(stage + ' failed' + (': ' + '; '.join(errors) if errors else ''))
    return result.stdout


def snapshot(folder):
    return {p.relative_to(folder).as_posix(): (p.stat().st_size, p.stat().st_mtime_ns)
            for p in folder.rglob('*') if p.is_file()}


def main():
    source = SOURCE.read_text()
    crypto = method(source, '    nonisolated private static func restorePastryArchive()', '    private func showGlazeError(')
    crypto = crypto.replace('Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".manifest", withExtension: "json")', 'resource(sugarPalette.sdkArchiveName + ".manifest.json")')
    crypto = crypto.replace('Bundle.main.url(forResource: sugarPalette.sdkArchiveName, withExtension: "data")', 'resource(sugarPalette.sdkArchiveName + ".data")')
    boundary = 'manager.urls(for: .cachesDirectory, in: .userDomainMask).first'
    if crypto.count(boundary) != 1:
        raise ValueError('Native archive Caches I/O boundary changed')
    crypto = crypto.replace(boundary, 'Optional(cacheRootOverride)')
    crypto = re.sub(r'^.*try manager.setAttributes\(\[\.protectionKey:.*\n', '', crypto, flags=re.M)
    cache_lock = re.search(r'^.*static let glazeArchiveCacheLock[^\n]*', source, flags=re.M)
    if cache_lock and cache_lock.group() not in crypto:
        crypto = cache_lock.group() + '\n' + crypto
    seed = re.search(r'nonisolated static let vanillaCipher = "[^"\n]+"\.wevVPastryCrumbBloomRestored', source).group()
    complete = method(source, '    @discardableResult\n    private func completeGlaze(', '    private func respondInvalidGlaze(')
    close = method(source, '    private func requestNativeGlazeClose(', '    private func performGlazeExit(')
    cancel_entry = method(source, '    private func cancelGlazeEntryPreparation()', '    private func resumeGlazeEntryMonitoring()')
    boolean = method(source, '    private static func jsonBoolean(', '    private func applyGlazeNavigation(')
    declarations = method(source, '    private struct GlazeRequest {', '    private struct GlazeCommand {')
    preparation = method(source, '    static func prewarmGlazeResources()', '    private func warmTastingParlor()')
    prepared_declarations = method(source, '    private struct GlazeArchiveStamp:', '    private enum sugarPalette')
    manifest_boundary = 'Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ".manifest", withExtension: "json")'
    if preparation.count(manifest_boundary) != 1:
        raise ValueError('Coordinator bootstrap manifest boundary changed')
    preparation = preparation.replace(manifest_boundary, 'Optional(fixtureManifestURL)')
    preparation += method(source, '    nonisolated private static func safeGlazePath(', '    nonisolated private static func readMarkedJSON(')
    swift = r'''import Foundation
import Darwin
import CoreFoundation
import CommonCrypto
import zlib
extension String {
    nonisolated var wevVPastryCrumbBloomRestored: String { String(enumerated().filter { $0.offset.isMultiple(of: 2) }.map { $0.element }) }
}
@MainActor final class CloseProbe {
    enum GlazeFailure: Error { case code(String) }
    var tastingWebView: Bool? = true
    var glazeExitTarget = 0
    var glazeExiting = false
    var glazeExitRequested = false
    var glazeNativeCloseTask: Task<Void, Never>?
    var glazeEntryActivationTask: Task<Void, Never>?
    var glazeLoadingTimeoutTask: Task<Void, Never>?
    var glazeBlankPageTimeoutTask: Task<Void, Never>?
    var glazeErrorPresentationTask: Task<Void, Never>?
    var glazePendingError: String?
    var glazeWebViewGeneration = UUID()
    var glazeContextDelivered = false
    var glazeContextDeliveryStarted = false
    func traceGlazeLoad(_ stage: String) {}
    var release: [String: Any]?
    var failure: Error?
    var commands = 0
    var exits: [Int] = []
    var failed = 0
    var responses: [[String: Any]] = []
    private var glazeRequests: [String: GlazeRequest] = [:]
    var glazeResponses: [String: [String: Any]] = [:]
    func sendGlazeCommand(_ name: String) async throws -> [String: Any]? {
        commands += 1
        await Task.yield()
        if let failure { throw failure }
        return release
    }
    func performGlazeExit(target: Int) { exits.append(target); glazeExiting = true }
    func showGlazeReleaseFailure() { failed += 1 }
    func sendGlaze(_ message: [String: Any]) async throws { responses.append(message) }
''' + declarations + complete + close + cancel_entry + boolean + r'''
    static func test() async {
        for result: [String: Any]? in [nil, ["released": false], ["released": "true"], ["released": 1]] {
            let probe = CloseProbe(); probe.release = result
            probe.requestNativeGlazeClose()
            await probe.glazeNativeCloseTask?.value
            precondition(probe.exits.isEmpty && probe.failed == 1)
        }
        let timedOut = CloseProbe(); timedOut.failure = GlazeFailure.code("TIMEOUT")
        timedOut.requestNativeGlazeClose()
        await timedOut.glazeNativeCloseTask?.value
        precondition(timedOut.exits.isEmpty && timedOut.failed == 1)
        let success = CloseProbe(); success.release = ["released": true]
        let activation = Task { _ = try? await Task.sleep(nanoseconds: 1_000_000_000) }
        success.glazeEntryActivationTask = activation
        success.glazeLoadingTimeoutTask = Task { _ = try? await Task.sleep(nanoseconds: 1_000_000_000) }
        success.glazeBlankPageTimeoutTask = Task { _ = try? await Task.sleep(nanoseconds: 1_000_000_000) }
        success.glazeErrorPresentationTask = Task { _ = try? await Task.sleep(nanoseconds: 1_000_000_000) }
        success.glazePendingError = "obsolete entry failure"
        success.requestNativeGlazeClose(); success.requestNativeGlazeClose(target: 1)
        precondition(activation.isCancelled && success.glazeLoadingTimeoutTask == nil && success.glazeBlankPageTimeoutTask == nil &&
                     success.glazeErrorPresentationTask == nil && success.glazePendingError == nil)
        await success.glazeNativeCloseTask?.value
        precondition(success.exits == [1] && success.commands == 1 && success.failed == 0)
        let noWebView = CloseProbe(); noWebView.tastingWebView = nil
        noWebView.requestNativeGlazeClose()
        precondition(noWebView.exits == [0] && noWebView.commands == 0)
        precondition(jsonInteger(true) == nil && jsonInteger("1") == nil && jsonInteger(1.2) == nil)
        precondition(jsonInteger(0) == 0 && jsonInteger(1) == 1 && jsonInteger(2) == 2 && jsonInteger(3) == nil)
        let response = CloseProbe()
        response.glazeRequests["once"] = GlazeRequest(method: "host.getContext", deadline: Date().timeIntervalSince1970 * 1000 + 1000)
        let first = await response.completeGlaze(id: "once", result: ["ready": true])
        let second = await response.completeGlaze(id: "once", result: ["ready": false])
        precondition(first && !second && response.responses.count == 1)
        response.glazeRequests["late"] = GlazeRequest(method: "host.getContext", deadline: Date().timeIntervalSince1970 * 1000 - 1)
        let late = await response.completeGlaze(id: "late", result: ["secret": "must not be returned"])
        precondition(!late && response.responses.last?["result"] == nil && (response.responses.last?["error"] as? [String: String])?["code"] == "TIMEOUT")
        response.glazeRequests["timeout"] = GlazeRequest(method: "host.getContext", deadline: Date().timeIntervalSince1970 * 1000 + 1000)
        _ = await response.completeGlaze(id: "timeout", error: "TIMEOUT", fromTimeout: true)
        _ = await response.completeGlaze(id: "timeout", result: ["secret": "late"])
        precondition(response.responses.filter { $0["id"] as? String == "timeout" }.count == 1)
        print("PASS: release false/missing/malformed/timeout never exit; close cancels entry observers without cancelling release; single-flight and target upgrade; strict target types; exactly-once deadline responses suppress late context")
    }
}

@MainActor final class CoordinatorProbe {
''' + prepared_declarations + r'''
    nonisolated private static let lock = NSLock()
    nonisolated(unsafe) private static var count = 0
    nonisolated(unsafe) private static var shouldFail = false
    nonisolated static var fixtureRoot: URL {
        URL(fileURLWithPath: CommandLine.arguments[3], isDirectory: true)
            .deletingLastPathComponent().appendingPathComponent("coordinator-fixture", isDirectory: true)
    }
    nonisolated static var cacheBase: URL { fixtureRoot.appendingPathComponent("cache", isDirectory: true) }
    nonisolated static var namespace: URL { cacheBase.appendingPathComponent("vanillaBeanIcingSdk2", isDirectory: true) }
    nonisolated static var folder: URL { namespace.appendingPathComponent("sdk2-fixture", isDirectory: true) }
    nonisolated static var fixtureManifestURL: URL { fixtureRoot.appendingPathComponent("fixture.manifest.json") }
    nonisolated static let requiredFiles = ["index.html", "config/app-config.js", "config/opi-profile.js",
        "assets/rtc.js", "assets/workers/cache-worker.mjs", "assets/logic/vendor.cjs",
        "assets/theme/main.css", "assets/engine/rtc.wasm"]
    // Control only the expensive restore boundary. Stamp checks below use the
    // actual shipping implementation against real isolated filesystem metadata.
    nonisolated static func restorePastryArchive() -> URL? {
        lock.lock(); count += 1; let failed = shouldFail; lock.unlock()
        Thread.sleep(forTimeInterval: 0.08)
        if failed { return nil }
        do {
            let manager = FileManager.default
            if (try? manager.attributesOfItem(atPath: cacheBase.path)) != nil {
                try manager.removeItem(at: cacheBase)
            }
            for path in requiredFiles {
                let file = folder.appendingPathComponent(path)
                try manager.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
                try Data("bootstrap fixture".utf8).write(to: file, options: .atomic)
            }
            return folder
        } catch { return nil }
    }
    nonisolated static func reads() -> Int { lock.lock(); defer { lock.unlock() }; return count }
    nonisolated static func fail(_ value: Bool) { lock.lock(); shouldFail = value; lock.unlock() }
''' + preparation + r'''
    static func entries(_ amount: Int = 6) async -> [URL] {
        let pending = (0..<amount).map { _ in Task { await prepareGlazeResources() } }
        var urls: [URL] = []
        for task in pending {
            let value = await task.value
            precondition(value == folder)
            urls.append(value!)
        }
        while glazeResourcePreparation != nil { await Task.yield() }
        return urls
    }
    static func repair(after mutation: () throws -> Void) async throws {
        let before = reads()
        try mutation()
        if let prepared = glazePreparedResources {
            precondition(glazeArchiveStamp(at: prepared.folder, files: prepared.bootstrapPaths) != prepared.stamp,
                         "A missing, replaced, changed or linked bootstrap must invalidate the real stamp")
        }
        _ = await entries()
        precondition(reads() == before + 1, "Invalidated concurrent entries must coalesce into one repair")
    }
    static func test() async throws {
        let manager = FileManager.default
        try manager.createDirectory(at: fixtureRoot, withIntermediateDirectories: true)
        defer { try? manager.removeItem(at: fixtureRoot) }
        let records = (requiredFiles + ["assets/photo.png"]).map { ["path": $0] }
        let manifestData = try JSONSerialization.data(withJSONObject: ["files": records])
        try manifestData.write(to: fixtureManifestURL)
        precondition(Set(glazeBootstrapPaths() ?? []) == Set(requiredFiles))
        prewarmGlazeResources()
        while reads() == 0 { await Task.yield() }
        let first = Task { await prepareGlazeResources() }
        let second = Task { await prepareGlazeResources() }
        await Task.yield()
        first.cancel()
        let firstURL = await first.value
        let secondURL = await second.value
        while glazeResourcePreparation != nil { await Task.yield() }
        precondition(reads() == 1 && firstURL == folder && secondURL == folder)
        // A successful warm entry must not reread the bundle manifest either.
        try manager.removeItem(at: fixtureManifestURL)
        for _ in 0..<12 {
            let reused = await prepareGlazeResources()
            precondition(reused == folder && reads() == 1)
        }
        _ = await entries(12)
        precondition(reads() == 1, "Successful same-process entries must not repeat the full restore")
        // The fast path checks bootstrap metadata, rather than walking assets.
        let assets = folder.appendingPathComponent("assets", isDirectory: true)
        try manager.createDirectory(at: assets, withIntermediateDirectories: true)
        try Data("unrelated asset".utf8).write(to: assets.appendingPathComponent("fixture.bin"))
        let reused = await prepareGlazeResources()
        precondition(reused == folder && reads() == 1)
        try manifestData.write(to: fixtureManifestURL)
        print("PASS: prewarm and cancelled/concurrent waiters share one restore; 24 later same-process entries reuse success without rescanning assets")

        try await repair { try manager.removeItem(at: folder) }
        for path in requiredFiles {
            try await repair { try manager.removeItem(at: folder.appendingPathComponent(path)) }
        }
        try await repair { try manager.removeItem(at: folder.appendingPathComponent("config", isDirectory: true)) }
        for path in requiredFiles {
            try await repair {
                let file = folder.appendingPathComponent(path)
                var contents = try Data(contentsOf: file); contents.append(contentsOf: " changed".utf8)
                try contents.write(to: file, options: .atomic)
            }
        }
        print("PASS: real directory/index/config/executable dependency deletion and rewrites invalidate the stamp and coalesce one repair")

        let outside = fixtureRoot.appendingPathComponent("outside", isDirectory: true)
        try manager.createDirectory(at: outside, withIntermediateDirectories: false)
        let marker = outside.appendingPathComponent("untouched.bin")
        let markerData = Data("unchanged external fixture".utf8)
        try markerData.write(to: marker)
        let markerDate = try manager.attributesOfItem(atPath: marker.path)[.modificationDate] as? Date
        let directories = [cacheBase, namespace, folder] + ["config", "assets", "assets/workers", "assets/logic", "assets/theme", "assets/engine"].map {
            folder.appendingPathComponent($0, isDirectory: true)
        }
        for directory in directories {
            try await repair {
                try manager.removeItem(at: directory)
                try manager.createSymbolicLink(at: directory, withDestinationURL: outside)
            }
            let unchangedData = try Data(contentsOf: marker)
            precondition(unchangedData == markerData)
            let unchangedDate = try manager.attributesOfItem(atPath: marker.path)[.modificationDate] as? Date
            precondition(unchangedDate == markerDate)
        }
        for path in requiredFiles {
            try await repair {
                let file = folder.appendingPathComponent(path)
                try manager.removeItem(at: file)
                try manager.createSymbolicLink(at: file, withDestinationURL: marker)
            }
            let unchangedData = try Data(contentsOf: marker)
            precondition(unchangedData == markerData)
        }
        print("PASS: outer/dependency directories and executable key-file symlinks invalidate reuse; external targets remain unchanged")

        try manager.removeItem(at: folder)
        let beforeFailure = reads()
        fail(true)
        let missing = await prepareGlazeResources()
        precondition(missing == nil && reads() == beforeFailure + 1 && glazePreparedResources == nil)
        let missingAgain = await prepareGlazeResources()
        precondition(missingAgain == nil && reads() == beforeFailure + 2)
        fail(false)
        let recovered = await prepareGlazeResources()
        precondition(recovered == folder && reads() == beforeFailure + 3)
        let successfulReuse = await prepareGlazeResources()
        precondition(successfulReuse == folder && reads() == beforeFailure + 3)
        print("PASS: nil is never memoized; invalid cache failures retry, recover, then reuse the successful result")
    }
}
@main struct ResourceProbe {
    private enum GlazeFailure: Error { case code(String) }
    private enum sugarPalette {
''' + seed + r'''
        nonisolated static let sdkArchiveName = "vanillaBeanIcingSdk2"
    }
    nonisolated static var cacheRootOverride: URL { URL(fileURLWithPath: CommandLine.arguments[3], isDirectory: true) }
    nonisolated static func resource(_ name: String) -> URL? { URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true).appendingPathComponent(name) }
''' + crypto + r'''
    static func main() async throws {
        if CommandLine.arguments[1] == "bridge" {
            await CloseProbe.test(); try await CoordinatorProbe.test(); return
        }
        if CommandLine.arguments[1] == "reject" {
            precondition(restorePastryArchive() == nil, "Invalid bundle/cache must fail without old-version fallback")
            print("rejected"); return
        }
        if CommandLine.arguments[1] == "alias" {
            precondition(cacheRootOverride.path != cacheRootOverride.standardizedFileURL.path,
                         "The fixture requires a real existing /private path alias")
        }
        guard let folder = restorePastryArchive() else { fatalError("Native SDK2 resource restoration failed") }
        let manager = FileManager.default
        let files = manager.enumerator(at: folder, includingPropertiesForKeys: [.isRegularFileKey])!.allObjects as! [URL]
        let regular = files.filter { (try? $0.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true }
        let manifest = try JSONSerialization.jsonObject(with: Data(contentsOf: resource("vanillaBeanIcingSdk2.manifest.json")!)) as! [String: Any]
        precondition(regular.count == manifest["fileCount"] as? Int && folder.lastPathComponent == manifest["contentVersion"] as? String)
        precondition(!safeGlazePath("../outside") && !safeGlazePath("a//b") && !safeGlazePath("C:/x") && !safeGlazePath("a\\b"))
        if CommandLine.arguments[1] == "hot" {
            let before = try regular.map { try $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate }
            precondition(restorePastryArchive() == folder)
            let after = try regular.map { try $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate }
            precondition(before == after)
        }
        let result = try JSONSerialization.data(withJSONObject: ["folder": folder.path, "fileCount": regular.count], options: [.sortedKeys])
        print(String(data: result, encoding: .utf8)!)
    }
}
'''
    with tempfile.TemporaryDirectory(prefix='wevv-sdk2-host-tests-', dir='/private/tmp') as output:
        root = Path(output)
        swift_path, executable = root / 'HostProbe.swift', root / 'HostProbe'
        swift_path.write_text(swift)
        check_run(['xcrun', 'swiftc', '-swift-version', '5', '-default-isolation', 'MainActor', '-parse-as-library',
                   '-module-cache-path', str(root / 'module-cache'), str(swift_path), '-o', str(executable)], 'Native host probe compilation')
        files, metadata = bundletool.verify(RESOURCES / 'vanillaBeanIcingSdk2.data',
                                             RESOURCES / 'vanillaBeanIcingSdk2.manifest.json', bundletool.host_version())
        assert len(files) == metadata['fileCount'] == 1174
        resources = root / 'resources'; resources.mkdir()
        for name in ('vanillaBeanIcingSdk2.data', 'vanillaBeanIcingSdk2.manifest.json'):
            shutil.copyfile(RESOURCES / name, resources / name)

        def run(mode='restore', resource_root=resources, cache_root=None):
            target = cache_root or root / 'cache'
            text = check_run([str(executable), mode, str(resource_root), str(target)], 'Native cache probe')
            return json.loads(text.splitlines()[-1]) if mode not in ('reject', 'bridge') else text

        first = run('hot')
        folder = Path(first['folder'])
        assert folder.resolve().is_relative_to((root / 'cache').resolve()) and folder.name == metadata['contentVersion']
        bundletool.verify_tree(folder, files)
        initial = snapshot(folder)
        cold = run()  # New executable process: no static Swift memo can satisfy this.
        assert cold == first and snapshot(folder) == initial
        print('PASS: all 1174 files restored; same-process and fresh-process cache reuse preserve URL and every file mtime')

        index = folder / 'index.html'
        damaged = bytearray(index.read_bytes()); damaged[0] ^= 1; index.write_bytes(damaged)
        assert run()['folder'] == str(folder)
        bundletool.verify_tree(folder, files)
        missing = folder / next(name for name in files if name != 'index.html' and not name.startswith('config/'))
        missing.unlink()
        assert run()['folder'] == str(folder)
        bundletool.verify_tree(folder, files)
        print('PASS: corrupted and missing cache files are fully revalidated and repaired from the real encrypted bundle')

        # Do not follow a symbolic link at either cache boundary. All targets
        # belong to this private fixture; no system or application data is used.
        outside = root / 'outside'; outside.mkdir()
        linked_base = root / 'linked-cache-base'; linked_base.symlink_to(outside, target_is_directory=True)
        run('reject', cache_root=linked_base)
        assert list(outside.iterdir()) == []
        namespace_base = root / 'linked-namespace'; namespace_base.mkdir()
        (namespace_base / 'vanillaBeanIcingSdk2').symlink_to(outside, target_is_directory=True)
        run('reject', cache_root=namespace_base)
        assert list(outside.iterdir()) == []

        outside_file = outside / 'unchanged.bin'
        outside_file.write_bytes(files['index.html'])
        untouched = outside_file.stat().st_mtime_ns
        index.unlink(); index.symlink_to(outside_file)
        assert run()['folder'] == str(folder) and not index.is_symlink()
        assert outside_file.stat().st_mtime_ns == untouched and outside_file.read_bytes() == files['index.html']
        bundletool.verify_tree(folder, files)
        shutil.rmtree(folder); folder.symlink_to(outside, target_is_directory=True)
        assert run()['folder'] == str(folder) and not folder.is_symlink()
        assert list(outside.iterdir()) == [outside_file] and outside_file.stat().st_mtime_ns == untouched
        bundletool.verify_tree(folder, files)
        print('PASS: cache-base/namespace symlinks are rejected without writes; version/tree links are repaired without touching their targets')

        # A different real encrypted archive gets a different contentVersion;
        # an older complete cache is retained but can never satisfy its request.
        version_files = dict(files); version_files['index.html'] += b'\n<!-- cache-version-fixture -->'
        records = bundletool.file_records(version_files)
        version_data = bundletool.crypt(bundletool.zlib.compress(bundletool.zlib.compress(bundletool.encode_archive(version_files), 9), 9))
        version_metadata = dict(metadata, files=records, fileCount=len(records), unpackedBytes=sum(map(len, version_files.values())),
                                contentVersion=bundletool.content_version(records), archiveBytes=len(version_data), archiveSha256=bundletool.sha256(version_data))
        version_resources = root / 'version-resources'; version_resources.mkdir()
        (version_resources / 'vanillaBeanIcingSdk2.data').write_bytes(version_data)
        (version_resources / 'vanillaBeanIcingSdk2.manifest.json').write_text(json.dumps(version_metadata))
        previous = snapshot(folder)
        second = run(resource_root=version_resources)
        second_folder = Path(second['folder'])
        assert second_folder != folder and second_folder.parent == folder.parent and snapshot(folder) == previous
        bundletool.verify_tree(second_folder, version_files)
        assert run()['folder'] == str(folder) and snapshot(folder) == previous
        print('PASS: real version change selects a separate validated directory and never overwrites or mixes the prior version')

        stage_cache = root / 'interrupted-cache'
        namespace = stage_cache / 'vanillaBeanIcingSdk2'
        staging = namespace / ('.staging-' + metadata['contentVersion'] + '-interrupted')
        staging.mkdir(parents=True); (staging / 'index.html').write_text('incomplete staging')
        staged_result = run(cache_root=stage_cache)
        assert Path(staged_result['folder']).name == metadata['contentVersion'] and Path(staged_result['folder']) != staging
        bundletool.verify_tree(Path(staged_result['folder']), files)
        print('PASS: interrupted staging is never treated as a published valid cache')

        corrupt_resources = root / 'corrupt-resources'; corrupt_resources.mkdir()
        corrupt_data = b'not-a-valid-encrypted-archive'
        corrupt_metadata = dict(version_metadata, archiveBytes=len(corrupt_data), archiveSha256=bundletool.sha256(corrupt_data))
        (corrupt_resources / 'vanillaBeanIcingSdk2.data').write_bytes(corrupt_data)
        (corrupt_resources / 'vanillaBeanIcingSdk2.manifest.json').write_text(json.dumps(corrupt_metadata))
        # No valid current-version cache, but the older version is still present.
        shutil.rmtree(second_folder)
        run('reject', corrupt_resources)
        assert folder.exists() and snapshot(folder) == previous
        run('reject', corrupt_resources, root / 'empty-corrupt-cache')
        (corrupt_resources / 'vanillaBeanIcingSdk2.data').unlink()
        run('reject', corrupt_resources, root / 'empty-missing-cache')
        print('PASS: corrupt/missing bundled resources without valid current cache fail closed; older cached versions are not fallback')

        alias_cache = root / 'private-alias-cache'; alias_cache.mkdir()
        # Use the unresolved /private spelling against an existing aliased root.
        alias_url = '/private' + str(alias_cache) if str(alias_cache).startswith('/tmp/') else str(alias_cache)
        alias_result = run('alias', cache_root=Path(alias_url))
        alias_folder = Path(alias_result['folder'])
        assert alias_folder.resolve().is_relative_to(alias_cache.resolve())
        bundletool.verify_tree(alias_folder, files)
        print('PASS: existing /private alias cache roots retain containment and restore all manifest files')
        print(run('bridge'), end='')


if __name__ == '__main__':
    main()
