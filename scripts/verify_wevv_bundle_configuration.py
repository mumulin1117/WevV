#!/usr/bin/env python3
"""Offline verification of the actual Swift native-configuration loader.

Default: synthetic AES/zlib/archive/JSON and environment regression cases,
without real keys.
--actual: also verify the project's thin archive; derive its existing resource
seed only inside the probe, never print it, and never read the full H5 archive.
"""
import argparse
import ctypes
import ctypes.util
import hashlib
import json
import plistlib
import re
import shutil
import struct
import subprocess
import tempfile
import zlib
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'WevSweetgd/WevSweetgd'
MANIFEST = 'vanillaBeanIcingSdk2.manifest.json'
THIN_ARCHIVE = 'vanillaBeanIcingSdk2Network.data'

def make_fixtures(folder):
    SEED = 'synthetic-native-configuration-seed-only-v1'
    sha = lambda x: hashlib.sha256(x).hexdigest()
    methods = {x: x for x in ['host.getContext', 'host.setNavigation', 'host.close', 'payment.purchaseProduct', 'payment.syncTransactions']}
    app = {'schemaVersion': 18, 'app': {'appVersion': '1.3'}, 'build': {'buildId': 'synthetic-build'}, 'bridge': {'methods': methods}}
    paths = {'/_v2/config/open': '/test/open', **{f'/route/{i}': f'/alias/{i}' for i in range(166)}}
    fields = {f'field{i}': f'value{i}' for i in range(964)}
    headers = {x: 'header' + str(i) for (i, x) in enumerate(['appId', 'appVersion', 'deviceNo', 'language', 'refreshToken', 'one', 'two'])}
    profile = {'schemaVersion': 1, 'services': {'apiBaseUrl': 'https://test.invalid', 'apiClient': {'appId': '12211334', 'appVersion': '1.3', 'protocol': 'opi-v2-aes', 'encryptionKey': 'synthetic-key-16', 'encryptionIv': 'synthetic-iv-16!'}}, 'aliases': {'path': paths, 'field': fields, 'header': headers}}

    def marked(value, marker):
        return ('var synthetic = /*__' + marker + '_START__*/ ' + json.dumps(value) + ' /*__' + marker + '_END__*/;').encode()

    def configs(a=None, p=None):
        return {'config/app-config.js': marked(app if a is None else a, 'APP_CONFIG'), 'config/opi-profile.js': marked(profile if p is None else p, 'OPI_PROFILE')}

    def archive(items):
        return b'WVVROOM1' + b''.join((struct.pack('<IQ', len(name.encode() if isinstance(name, str) else name), len(data)) + (name.encode() if isinstance(name, str) else name) + data for (name, data) in items))
    lib = ctypes.CDLL(ctypes.util.find_library('System'))
    api = lib.CCCrypt
    api.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32, ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t, ctypes.POINTER(ctypes.c_size_t)]
    api.restype = ctypes.c_int32

    def encrypt(data):
        key = hashlib.sha256(SEED.encode()).digest()
        out = ctypes.create_string_buffer(len(data) + 16)
        count = ctypes.c_size_t()
        status = api(0, 0, 1, key[:16], 16, key[16:], data, len(data), out, len(out), ctypes.byref(count))
        if status != 0:
            raise RuntimeError('Synthetic fixture encryption failed')
        return out.raw[:count.value]

    def records(files):
        return [{'path': k, 'bytes': len(v), 'sha256': sha(v)} for (k, v) in sorted(files.items())]
    cases = []

    def case(name, accept=False, files=None, raw=None, layers=None, adjust=None, host='1.3', seed=SEED, expected_routing=None):
        files = configs() if files is None else files
        raw = archive(sorted(files.items())) if raw is None else raw
        compressed = zlib.compress(zlib.compress(raw)) if layers is None else layers(raw)
        encrypted = encrypt(compressed)
        r = records(files)
        full = records({**files, 'index.html': b'<html></html>'})
        m = {'schemaVersion': 1, 'archiveFormat': 'WVVROOM1', 'archiveFile': 'vanillaBeanIcingSdk2.data', 'compression': {'algorithm': 'zlib', 'layers': 2}, 'encryption': {'algorithm': 'AES-128-CBC', 'padding': 'PKCS7', 'keySource': 'existing-native-resource'}, 'sdkProtocolVersion': '2.0.0', 'appConfigSchemaVersion': 18, 'opiProfileRevision': 2, 'hostVersion': '1.3', 'contentVersion': 'sdk2-' + sha(json.dumps(full, sort_keys=True, separators=(',', ':')).encode()), 'appId': '12211334', 'h5BuildId': 'synthetic-build', 'fileCount': len(full), 'files': full, 'nativeConfiguration': {'archiveFile': 'vanillaBeanIcingSdk2Network.data', 'archiveBytes': len(encrypted), 'archiveSha256': sha(encrypted), 'files': r}}
        if adjust:
            adjust(m)
        b = folder / (name + '.bundle')
        resources = b / 'Contents/Resources'
        resources.mkdir(parents=True)
        (b / 'Contents/Info.plist').write_bytes(plistlib.dumps({'CFBundleIdentifier': 'com.wevv.synthetic.' + name, 'CFBundleVersion': '1', 'CFBundlePackageType': 'BNDL', 'CFBundleName': name}))
        (resources / 'vanillaBeanIcingSdk2Network.data').write_bytes(encrypted)
        (resources / 'vanillaBeanIcingSdk2.manifest.json').write_text(json.dumps(m))
        cases.append((accept, str(b), seed, host, m['appId'], expected_routing))
        return resources
    case('valid', True)
    case('wrong-host', host='1.4')
    case('wrong-seed', seed=SEED + '-wrong')
    case('cipher-hash', adjust=lambda x: x['nativeConfiguration'].update(archiveSha256='0' * 64))
    case('outer-trailing', layers=lambda raw: zlib.compress(zlib.compress(raw)) + b'junk')
    case('outer-second-stream', layers=lambda raw: zlib.compress(zlib.compress(raw)) + zlib.compress(b'junk'))
    case('inner-trailing', layers=lambda raw: zlib.compress(zlib.compress(raw) + b'junk'))
    case('inflate-over-limit', layers=lambda raw: zlib.compress(b'A' * (1024 * 1024 + 1)))
    case('truncated-zlib', layers=lambda raw: zlib.compress(zlib.compress(raw))[:-1])
    case('bad-magic', raw=b'WRONGHDR' + archive(sorted(configs().items()))[8:])
    case('archive-tail', raw=archive(sorted(configs().items())) + b'x')
    case('archive-truncated', raw=archive(sorted(configs().items()))[:-1])
    case('archive-huge-size', raw=b'WVVROOM1' + struct.pack('<IQ', 5, 2 ** 64 - 1) + b'hello')
    case('archive-zero-path', raw=b'WVVROOM1' + struct.pack('<IQ', 0, 0))
    case('archive-long-path', raw=archive([('x' * 4097, b'')]))
    case('archive-duplicate', raw=archive([('config/app-config.js', configs()['config/app-config.js'])] * 2))
    case('archive-case', raw=archive([('config/APP-config.js', b'{}'), ('config/opi-profile.js', b'{}')]))
    case('archive-traversal', raw=archive([('../config/app-config.js', b'{}'), ('config/opi-profile.js', b'{}')]))
    case('archive-backslash', raw=archive([('config\\app-config.js', b'{}'), ('config/opi-profile.js', b'{}')]))
    case('archive-absolute', raw=archive([('/config/app-config.js', b'{}'), ('config/opi-profile.js', b'{}')]))
    case('archive-invalid-utf8', raw=archive([(b'\xff', b'{}'), ('config/opi-profile.js', b'{}')]))
    case('archive-third-file', raw=archive(sorted({**configs(), 'index.html': b'html'}.items())))
    case('archive-one-file', raw=archive([('config/app-config.js', configs()['config/app-config.js'])]))
    case('archive-no-files', raw=b'WVVROOM1')
    case('file-content-mismatch', raw=archive([('config/app-config.js', b'changed'), ('config/opi-profile.js', configs()['config/opi-profile.js'])]))
    case('native-record-mismatch', adjust=lambda x: x['nativeConfiguration']['files'][0].update(sha256='0' * 64))
    case('native-record-duplicate', adjust=lambda x: x['nativeConfiguration']['files'].__setitem__(1, x['nativeConfiguration']['files'][0].copy()))
    f = configs()
    f['config/app-config.js'] += b'/*__APP_CONFIG_START__*/'
    case('duplicate-marker', files=f)
    f = configs()
    f['config/app-config.js'] = f['config/app-config.js'].replace(b'"schemaVersion": 18', b'"schemaVersion": 18,"schemaVersion":18')
    case('duplicate-json-key', files=f)
    f = configs()
    f['config/app-config.js'] = f['config/app-config.js'].replace(b'"schemaVersion": 18', b'"schemaVersion": 18,"\\u0073chemaVersion":18')
    case('escaped-duplicate-json-key', files=f)
    a = json.loads(json.dumps(app))
    a['schemaVersion'] = 17
    case('app-schema', files=configs(a=a))
    a = json.loads(json.dumps(app))
    a['schemaVersion'] = True
    case('boolean-schema', files=configs(a=a))
    a = json.loads(json.dumps(app))
    a['app']['appVersion'] = '1.4'
    case('app-version', files=configs(a=a))
    p = json.loads(json.dumps(profile))
    p['services']['apiClient']['appId'] = 'other'
    case('profile-id', files=configs(p=p))
    p = json.loads(json.dumps(profile))
    p['services']['apiClient']['appVersion'] = '1.4'
    case('profile-version', files=configs(p=p))
    p = json.loads(json.dumps(profile))
    p['aliases']['field'].pop('field0')
    case('profile-incomplete', files=configs(p=p))
    a = json.loads(json.dumps(app))
    a['bridge']['methods'].pop('host.close')
    case('bridge-methods', files=configs(a=a))
    case('metadata-compression', adjust=lambda x: x['compression'].update(layers=1))
    r = case('manifest-duplicate-key')
    path = r / 'vanillaBeanIcingSdk2.manifest.json'
    path.write_text(path.read_text().replace('"schemaVersion": 1', '"schemaVersion":1,"schemaVersion":1', 1))
    r = case('manifest-trailing-json')
    path = r / 'vanillaBeanIcingSdk2.manifest.json'
    path.write_text(path.read_text() + ' {}')
    r = case('manifest-nan')
    path = r / 'vanillaBeanIcingSdk2.manifest.json'
    path.write_text(path.read_text().replace('"schemaVersion": 1', '"schemaVersion":NaN', 1))

    production = json.loads(json.dumps(profile))
    production['services'].update(environment='production', apiBaseUrl='https://production.invalid')
    production['services']['apiClient']['appId'] = '39114002'
    production['aliases']['path'].update({f'/production/{i}': f'/new-alias/{i}' for i in range(18)})
    production['aliases']['field']['productionField'] = 'productionValue'
    production_counts = {'path': 185, 'field': 965, 'header': 7}

    def production_metadata(manifest):
        manifest.update(environment='production', appId='39114002', profileAliasCounts=production_counts.copy())

    def production_case(name, accept=False, p=None, adjust=None):
        def metadata(manifest):
            production_metadata(manifest)
            if adjust:
                adjust(manifest)
        return case(name, accept, files=configs(p=production if p is None else p), adjust=metadata)

    production_case('production-valid', True)
    case('explicit-test-valid', True, adjust=lambda m: m.update(environment='test', profileAliasCounts={'path': 167, 'field': 964, 'header': 7}))
    production_case('production-missing-counts', adjust=lambda m: m.pop('profileAliasCounts'))
    production_case('production-count-mismatch', adjust=lambda m: m['profileAliasCounts'].update(path=184))
    production_case('production-manifest-app-id-mismatch', adjust=lambda m: m.update(appId='different-project'))
    production_case('production-manifest-environment-mismatch', adjust=lambda m: m.update(environment='test'))
    production_case('production-manifest-environment-missing', adjust=lambda m: m.pop('environment'))
    production_case('production-manifest-environment-unknown', adjust=lambda m: m.update(environment='staging'))
    production_case('production-manifest-environment-number', adjust=lambda m: m.update(environment=1))
    production_case('production-manifest-environment-null', adjust=lambda m: m.update(environment=None))
    p = json.loads(json.dumps(production))
    p['services'].pop('environment')
    production_case('production-profile-environment-missing', p=p)
    p = json.loads(json.dumps(production))
    p['services']['environment'] = 'test'
    production_case('production-profile-environment-mismatch', p=p)
    p = json.loads(json.dumps(production))
    p['services']['environment'] = False
    production_case('production-profile-environment-boolean', p=p)
    p = json.loads(json.dumps(production))
    p['services']['apiClient']['appId'] = 'different-project'
    production_case('production-profile-app-id-mismatch', p=p)
    production_case('production-full-thin-profile-mismatch', adjust=lambda m: next(record for record in m['files'] if record['path'] == 'config/opi-profile.js').update(sha256='0' * 64))
    p = json.loads(json.dumps(production))
    p['aliases']['field']['productionField'] = p['aliases']['field']['field0']
    production_case('production-colliding-field-alias', p=p)
    p = json.loads(json.dumps(production))
    p['aliases']['path'].pop('/_v2/config/open')
    p['aliases']['path']['/irrelevant'] = '/irrelevant'
    production_case('production-required-open-missing', p=p)
    p = json.loads(json.dumps(production))
    p['aliases']['header'].pop('refreshToken')
    p['aliases']['header']['irrelevant'] = 'irrelevant'
    production_case('production-required-header-missing', p=p)
    p = json.loads(json.dumps(production))
    p['aliases']['extra'] = {}
    production_case('production-extra-alias-group', p=p)
    for label, value in [('boolean', True), ('fraction', 185.5), ('string', '185'), ('zero', 0), ('negative', -1), ('oversized', 20_001)]:
        production_case('production-count-' + label, adjust=lambda m, v=value: m['profileAliasCounts'].update(path=v))
    production_case('production-count-key-missing', adjust=lambda m: m['profileAliasCounts'].pop('header'))
    production_case('production-count-key-extra', adjust=lambda m: m['profileAliasCounts'].update(extra=1))
    production_case('production-counts-null', adjust=lambda m: m.update(profileAliasCounts=None))
    production_case('production-counts-array', adjust=lambda m: m.update(profileAliasCounts=[185, 965, 7]))

    # Actual SDK 2 H5 Profile services are strict: keep them byte-identical in
    # the complete and thin archives, and put only native routing in manifest.
    clean_production = json.loads(json.dumps(production))
    clean_production['services'].pop('environment')
    native_routing = {'environment': 'production', 'bootstrapBaseUrl': 'https://bootstrap.invalid', 'bootstrapAppId': '12211334'}

    def routed_case(name, accept=False, routing=None, p=None, adjust=None):
        def metadata(manifest):
            production_metadata(manifest)
            manifest['nativeRouting'] = json.loads(json.dumps(native_routing if routing is None else routing))
            if adjust:
                adjust(manifest)
        return case(name, accept, files=configs(p=clean_production if p is None else p), adjust=metadata,
                    expected_routing=native_routing if accept else None)

    routed_case('production-clean-profile-native-routing', True)
    routed_case('production-clean-profile-missing-native-routing', adjust=lambda m: m.pop('nativeRouting'))
    for key in native_routing:
        routing = native_routing.copy()
        routing.pop(key)
        routed_case('native-routing-missing-' + key, routing=routing)
    routed_case('native-routing-extra-key', routing={**native_routing, 'appId': '39114002'})
    for label, value in [('test', 'test'), ('unknown', 'staging'), ('number', 1), ('boolean', True), ('null', None)]:
        routed_case('native-routing-environment-' + label, routing={**native_routing, 'environment': value})
    for label, value in [('number', 12211334), ('boolean', True), ('null', None), ('empty', ''), ('space', ' '), ('letters', 'test'), ('padding', ' 12211334')]:
        routed_case('native-routing-id-' + label, routing={**native_routing, 'bootstrapAppId': value})
    for label, value in [('number', 1), ('null', None), ('http', 'http://bootstrap.invalid'), ('relative', '/bootstrap'), ('credentials', 'https://user:secret@bootstrap.invalid'), ('query', 'https://bootstrap.invalid?appId=1'), ('fragment', 'https://bootstrap.invalid#route')]:
        routed_case('native-routing-url-' + label, routing={**native_routing, 'bootstrapBaseUrl': value})
    routed_case('native-routing-null', adjust=lambda m: m.update(nativeRouting=None))
    routed_case('native-routing-array', adjust=lambda m: m.update(nativeRouting=[]))
    for key, value in {**native_routing, 'unknownNativeSetting': 'not-h5'}.items():
        p = json.loads(json.dumps(clean_production))
        p['services'][key] = value
        routed_case('native-routing-mixed-inline-' + key, p=p)
    return [dict(expected=accept, bundlePath=path, seed=seed, obfuscatedSeed=False, hostVersion=host, expectedAppID=app_id,
                 expectedRouting=routing) for (accept, path, seed, host, app_id, routing) in cases]

def actual_fixture(folder):
    manifest = json.loads((SOURCES / MANIFEST).read_text())
    controller = (SOURCES / 'UKGlazeActortroller.swift').read_text()
    match = re.search('static let vanillaCipher\\s*=\\s*"([^"\\\\]+)"\\.wevVPastryCrumbBloomRestored', controller)
    if match is None:
        raise ValueError('The existing native resource derivation declaration changed')
    bundle = folder / 'actual-project-resource.bundle'
    resources = bundle / 'Contents/Resources'
    resources.mkdir(parents=True)
    (bundle / 'Contents/Info.plist').write_bytes(plistlib.dumps({'CFBundleIdentifier': 'com.wevv.nativeconfiguration.actualprobe', 'CFBundleVersion': '1', 'CFBundlePackageType': 'BNDL'}))
    # Never read or copy the complete H5 resource.
    for name in (MANIFEST, THIN_ARCHIVE):
        shutil.copy2(SOURCES / name, resources / name)
    return dict(expected=True, bundlePath=str(bundle), seed=match.group(1), obfuscatedSeed=True, hostVersion=manifest['hostVersion'], contentVersion=manifest['contentVersion'], expectedAppID=manifest['appId'], expectedRouting=manifest.get('nativeRouting'))
SWIFT_PROBE = r'''
import Foundation
struct Fixture: Decodable {
    struct NativeRouting: Decodable {
        let environment: String
        let bootstrapBaseUrl: String
        let bootstrapAppId: String
    }
    let expected: Bool
    let bundlePath: String
    let seed: String
    let obfuscatedSeed: Bool
    let hostVersion: String
    let contentVersion: String?
    let expectedAppID: String
    let expectedRouting: NativeRouting?
}
@main struct NativeConfigurationProbe {
    @MainActor static func main() throws {
        let input = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))
        let cases = try JSONDecoder().decode([Fixture].self, from: input)
        var passed = 0
        for fixture in cases {
            guard let bundle = Bundle(url: URL(fileURLWithPath: fixture.bundlePath)) else {
                throw NSError(domain: "NativeConfigurationRegression", code: 1)
            }
            // Preserve the original resource derivation in memory only.
            let seed = fixture.obfuscatedSeed
                ? String(fixture.seed.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil })
                : fixture.seed
            var accepted = false
            do {
                let configuration = try WevVGlazeBundleConfiguration(bundle: bundle, seed: seed, hostVersion: fixture.hostVersion)
                accepted = true
                precondition(configuration.profile.appID == fixture.expectedAppID)
                if let routing = fixture.expectedRouting {
                    precondition(configuration.profile.environment == routing.environment)
                    precondition(configuration.profile.bootstrapAppID == routing.bootstrapAppId)
                    precondition(configuration.profile.bootstrapBaseURL.absoluteString == routing.bootstrapBaseUrl)
                }
                precondition(configuration.contentVersion.hasPrefix("sdk2-"))
                if let version = fixture.contentVersion { precondition(configuration.contentVersion == version) }
            } catch { }
            guard accepted == fixture.expected else {
                let label = URL(fileURLWithPath: fixture.bundlePath).lastPathComponent
                throw NSError(domain: "NativeConfigurationRegression", code: 2,
                              userInfo: [NSLocalizedDescriptionKey: "Unexpected result: " + label])
            }
            passed += 1
        }
        print("Native configuration source cases passed: \(passed)")
    }
}
'''

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--actual', action='store_true', help='Also verify the existing project thin archive, without displaying configuration or derivation input')
    arguments = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='wevv-bundle-configuration-') as temporary:
        folder = Path(temporary)
        cases = make_fixtures(folder)
        if arguments.actual:
            cases.append(actual_fixture(folder))
        case_file = folder / 'cases.json'
        case_file.write_text(json.dumps(cases))
        case_file.chmod(0o600)
        probe = folder / 'Probe.swift'
        probe.write_text(SWIFT_PROBE)
        executable = folder / 'probe'
        # Link the actual loader and OPI parser; fixture generation has no decoder.
        subprocess.run(['xcrun', 'swiftc', '-parse-as-library', '-swift-version', '5', '-default-isolation', 'MainActor', '-module-cache-path', str(folder / 'modules'), str(SOURCES / 'WevVGlazeNetworkFoundation.swift'), str(SOURCES / 'WevVGlazeBundleConfiguration.swift'), str(probe), '-o', str(executable)], check=True)
        subprocess.run([str(executable), str(case_file)], check=True, timeout=30)
    if arguments.actual:
        print('Actual project thin resource verified; full H5 archive was not read')
if __name__ == '__main__':
    main()
