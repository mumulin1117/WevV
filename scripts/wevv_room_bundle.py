#!/usr/bin/env python3
"""Package the SDK 2 H5 delivery using WevV's existing native archive format.

Uses only Python's standard library and macOS CommonCrypto. No network access.
The SDK 2 resource is loaded by the native SDK 2 session and Bridge integration.
The legacy resource name remains reserved in this packaging tool; key derivation uses the retained native seed.
"""

from wevv_swift_source import STRING_HELPER
import argparse
import ctypes
import ctypes.util
import hashlib
import json
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from pathlib import Path
from urllib.parse import urlsplit


ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "WevSweetgd/WevSweetgd/UKGlazeActortroller.swift"
PROJECT = ROOT / "WevSweetgd/WevSweetgd.xcodeproj/project.pbxproj"
MAGIC = b"WVVROOM1"
MAX_BYTES = 256 * 1024 * 1024
MAX_FILES = 20000
SDK_METHODS = {
    "host.getContext", "host.setNavigation", "host.close",
    "payment.purchaseProduct", "payment.syncTransactions",
}


class BundleError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise BundleError(message)


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def strict_json(data):
    def object_pairs(pairs):
        result = {}
        for key, value in pairs:
            require(key not in result, "Duplicate JSON object key")
            result[key] = value
        return result

    def invalid_constant(_):
        raise BundleError("Non-JSON numeric constant")

    return json.loads(data, object_pairs_hook=object_pairs, parse_constant=invalid_constant)


def safe_path(name):
    require(isinstance(name, str) and 0 < len(name.encode("utf-8")) <= 4096,
            "Invalid archive path length")
    require("\\" not in name and "\x00" not in name
            and all(part not in ("", ".", "..") for part in name.split("/")),
            "Unsafe archive path")
    require(not name.startswith("/") and not re.match(r"^[A-Za-z]:", name),
            "Absolute archive path is forbidden")
    return name


def check_paths(names):
    folded = set()
    all_names = set(names)
    require(0 < len(all_names) <= MAX_FILES, "Invalid archive file count")
    for name in names:
        safe_path(name)
        require(name.casefold() not in folded, "Duplicate or case-colliding archive path")
        folded.add(name.casefold())
        parts = name.split("/")
        require(not any("/".join(parts[:i]) in all_names for i in range(1, len(parts))),
                "Archive path collides with a parent file")


def config_json(data, marker):
    text = data.decode("utf-8")
    start, end = "/*__%s_START__*/" % marker, "/*__%s_END__*/" % marker
    require(text.count(start) == text.count(end) == 1, "Invalid configuration markers")
    first, last = text.index(start) + len(start), text.index(end)
    require(first < last, "Invalid configuration marker order")
    value = strict_json(text[first:last])
    require(isinstance(value, dict), "Configuration must be a JSON object")
    return value, text, first, last


def update_config(data, marker, change):
    value, text, first, last = config_json(data, marker)
    change(value)
    body = json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False)
    return (text[:first] + " " + body + " " + text[last:]).encode("utf-8")


def host_version():
    values = set(re.findall(r"MARKETING_VERSION\s*=\s*([^;]+);", PROJECT.read_text()))
    require(len(values) == 1, "Debug and Release must have one shared host version")
    version = values.pop().strip().strip('"')
    require(re.fullmatch(r"\d+(?:\.\d+){1,2}", version), "Invalid host version")
    return version


def resource_material():
    # Read the existing resource derivation input; never copy API encryption keys.
    source = CONTROLLER.read_text()
    values = {}
    for field in ("vanillaCipher",):
        match = re.search(r"static let " + field + r'\s*=\s*"([^"\\]+)"'
                          r"\.wevVPastryCrumbBloomRestored", source)
        require(match is not None, "Native resource key declaration has changed")
        values[field] = match.group(1)[::2]
    digest = hashlib.sha256(values["vanillaCipher"].encode("utf-8")).digest()
    return digest[:16], digest[16:], "vanillaBeanIcing"


def crypt(data, decrypt=False):
    key, iv, _ = resource_material()
    library = ctypes.util.find_library("System")
    require(library is not None, "macOS CommonCrypto is required")
    api = ctypes.CDLL(library).CCCrypt
    api.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32,
                    ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p,
                    ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p,
                    ctypes.c_size_t, ctypes.POINTER(ctypes.c_size_t)]
    api.restype = ctypes.c_int32
    source = ctypes.create_string_buffer(data)
    key_buffer, iv_buffer = ctypes.create_string_buffer(key), ctypes.create_string_buffer(iv)
    output = ctypes.create_string_buffer(len(data) + 16)
    written = ctypes.c_size_t()
    result = api(1 if decrypt else 0, 0, 1, key_buffer, 16, iv_buffer,
                 source, len(data), output, len(output), ctypes.byref(written))
    require(result == 0, "Resource AES operation failed")
    return output.raw[:written.value]


def encode_manifest(metadata):
    data = (json.dumps(metadata, ensure_ascii=False, indent=2, allow_nan=False) + "\n").encode()
    require(0 < len(data) <= 2 * 1024 * 1024, "Resource manifest exceeds its size limit")
    encrypted = crypt(zlib.compress(zlib.compress(data, 9), 9))
    require(len(encrypted) <= 2 * 1024 * 1024, "Encrypted manifest exceeds its size limit")
    return encrypted


def decode_manifest(data):
    limit = 2 * 1024 * 1024
    require(0 < len(data) <= limit, "Invalid encrypted manifest size")
    data = crypt(data, decrypt=True)
    for _ in range(2):
        stream = zlib.decompressobj()
        data = stream.decompress(data, limit + 1)
        require(stream.eof and not stream.unused_data and not stream.unconsumed_tail
                and 0 < len(data) <= limit, "Invalid compressed manifest")
    metadata = strict_json(data)
    require(isinstance(metadata, dict), "Resource manifest must be an object")
    return metadata


def encode_archive(files):
    check_paths(files)
    parts = [MAGIC]
    for name in sorted(files):
        path, content = name.encode("utf-8"), files[name]
        parts.extend((struct.pack("<IQ", len(path), len(content)), path, content))
    result = b"".join(parts)
    require(len(result) <= MAX_BYTES, "Archive exceeds the native decompression limit")
    return result


def decode_archive(data, require_entry=True):
    require(len(data) <= MAX_BYTES and data.startswith(MAGIC), "Invalid archive header or size")
    cursor, files = len(MAGIC), {}
    while cursor < len(data):
        require(len(data) - cursor >= 12, "Truncated archive record")
        path_size, size = struct.unpack_from("<IQ", data, cursor)
        cursor += 12
        require(0 < path_size <= 4096 and path_size + size <= len(data) - cursor,
                "Invalid archive record length")
        name = safe_path(data[cursor:cursor + path_size].decode("utf-8"))
        cursor += path_size
        require(name not in files, "Duplicate archive record")
        files[name] = data[cursor:cursor + size]
        cursor += size
        require(len(files) <= MAX_FILES, "Archive contains too many files")
    check_paths(files)
    require(not require_entry or "index.html" in files, "Archive has no index.html")
    return files


def inflate(data):
    decoder = zlib.decompressobj()
    result = decoder.decompress(data, MAX_BYTES + 1)
    require(len(result) <= MAX_BYTES and decoder.eof and not decoder.unused_data
            and not decoder.unconsumed_tail, "Invalid or oversized zlib stream")
    return result


def decode_bundle(data, require_entry=True):
    require(0 < len(data) <= MAX_BYTES, "Invalid encrypted resource size")
    return decode_archive(inflate(inflate(crypt(data, decrypt=True))), require_entry=require_entry)


def file_records(files):
    return [{"path": name, "bytes": len(files[name]), "sha256": sha256(files[name])}
            for name in sorted(files)]


def content_version(records):
    canonical = json.dumps(records, sort_keys=True, separators=(",", ":")).encode()
    return "sdk2-" + sha256(canonical)


def validate_sdk(files, version):
    app = config_json(files["config/app-config.js"], "APP_CONFIG")[0]
    profile = config_json(files["config/opi-profile.js"], "OPI_PROFILE")[0]
    require(app.get("schemaVersion") == 18, "SDK 2 requires app-config schema 18")
    require(profile.get("schemaVersion") == 1, "Unsupported OPI Profile schema")
    require(set(app["bridge"]["methods"]) == SDK_METHODS, "Unexpected SDK Bridge method set")
    require(app["app"]["appVersion"] == version
            and profile["services"]["apiClient"]["appVersion"] == version,
            "Native and H5 versions do not match")
    client = profile["services"]["apiClient"]
    require(isinstance(client["appId"], str) and client["appId"].isdigit()
            and client["protocol"] == "opi-v2-aes", "Invalid project or OPI protocol")
    require(all(len(client[key].encode("utf-8")) == 16
                for key in ("encryptionKey", "encryptionIv")), "Invalid OPI AES lengths")
    require(set(profile["aliases"]) == {"path", "field", "header"}, "Invalid alias groups")
    for values in profile["aliases"].values():
        require(isinstance(values, dict), "Invalid alias mapping")
        require(all(isinstance(k, str) and isinstance(v, str) and k and v
                    for k, v in values.items()), "Invalid alias mapping")
        require(len(set(values.values())) == len(values), "Colliding alias mapping")
    counts = {key: len(value) for key, value in profile["aliases"].items()}
    require(counts["path"] >= 167 and counts["field"] >= 964 and counts["header"] == 7,
            "Incomplete OPI Profile")
    services = profile["services"]
    # The shipped SDK validates this object with a strict schema. Host-only
    # routing settings belong in the native manifest, never the H5 Profile.
    require(set(services) == {"apiBaseUrl", "apiClient"}, "H5 Profile contains native-only service fields")
    url = urlsplit(services["apiBaseUrl"])
    require(url.scheme == "https" and url.hostname and not url.username and not url.password
            and not url.query and not url.fragment, "Invalid secure service URL")
    return app, profile


def validate_native_routing(value):
    require(isinstance(value, dict) and set(value) == {"environment", "bootstrapBaseUrl", "bootstrapAppId"},
            "Invalid native routing fields")
    require(value["environment"] in ("test", "production"), "Invalid service environment")
    require(isinstance(value["bootstrapAppId"], str) and value["bootstrapAppId"].isdigit(),
            "Invalid bootstrap project identifier")
    url = urlsplit(value["bootstrapBaseUrl"])
    require(url.scheme == "https" and url.hostname and not url.username and not url.password
            and not url.query and not url.fragment, "Invalid secure bootstrap URL")
    return value


def source_files(dist, profile_path, version, connection_config=None):
    require(dist.is_dir() and not dist.is_symlink(), "Missing or symbolic-link dist directory")
    files = {}
    for path in sorted(dist.rglob("*")):
        require(not path.is_symlink(), "Symbolic links are forbidden in dist")
        if path.is_file():
            name = safe_path(path.relative_to(dist).as_posix())
            files[name] = path.read_bytes()
    check_paths(files)
    manifest = strict_json(files["webapp-manifest.json"])
    require(manifest.get("schemaVersion") == 2, "Unsupported delivery manifest")
    managed = manifest["managedFiles"]
    require(len({record["file"] for record in managed}) == len(managed),
            "Duplicate delivery manifest entry")
    for record in managed:
        name = safe_path(record["file"])
        content = files.get(name)
        require(content is not None and len(content) == record["bytes"]
                and sha256(content) == record["sha256"], "Delivery manifest verification failed")
    allowed = {record["file"] for record in managed} | set(manifest["editableFiles"]) | {"webapp-manifest.json"}
    require(not (set(files) - allowed), "Unlisted files in delivery directory")
    original_app = files["config/app-config.js"]
    replacement_profile = profile_path.read_bytes()
    settings_data = None
    if replacement_profile.lstrip().startswith(b"{"):
        aliases = strict_json(replacement_profile)
        require(isinstance(aliases, dict) and set(aliases) == {"path", "field", "header"},
                "Expected a complete aliases JSON object")
        require(connection_config is not None, "Bare aliases require a private --connection-config file")
        settings_data = connection_config.read_bytes()
        settings = strict_json(settings_data)
        required_settings = {
            "environment", "apiBaseUrl", "bootstrapBaseUrl", "appId", "encryptionKey", "encryptionIv"
        }
        require(isinstance(settings, dict) and required_settings <= set(settings)
                and set(settings) <= required_settings | {"bootstrapAppId"}, "Invalid connection configuration fields")
        template = files["config/opi-profile.js"]

        def configure(value):
            value["aliases"] = aliases
            value["services"] = {
                "environment": settings["environment"],
                "apiBaseUrl": settings["apiBaseUrl"],
                "bootstrapBaseUrl": settings["bootstrapBaseUrl"],
                "apiClient": {key: settings[key] for key in ("appId", "encryptionKey", "encryptionIv")},
            }
            value["services"]["apiClient"].update(appVersion=version, protocol="opi-v2-aes")
            if "bootstrapAppId" in settings:
                require(isinstance(settings["bootstrapAppId"], str) and settings["bootstrapAppId"].isdigit(),
                        "Invalid bootstrap project identifier")
                value["services"]["bootstrapAppId"] = settings["bootstrapAppId"]

        profile_source = update_config(template, "OPI_PROFILE", configure)
    else:
        require(connection_config is None, "Connection override requires a bare aliases JSON input")
        profile_source = replacement_profile
    profile_object = config_json(profile_source, "OPI_PROFILE")[0]
    services = profile_object["services"]
    require(set(services) <= {"apiBaseUrl", "apiClient", "environment", "bootstrapBaseUrl", "bootstrapAppId"},
            "Unsupported source service fields")
    native_routing = validate_native_routing({
        "environment": services.get("environment", "test"),
        "bootstrapBaseUrl": services.get("bootstrapBaseUrl", services["apiBaseUrl"]),
        "bootstrapAppId": services.get("bootstrapAppId", services["apiClient"]["appId"]),
    })

    def configure_h5(value):
        service = value["services"]
        value["services"] = {"apiBaseUrl": service["apiBaseUrl"], "apiClient": service["apiClient"]}
        value["services"]["apiClient"]["appVersion"] = version

    files["config/app-config.js"] = update_config(
        original_app, "APP_CONFIG", lambda value: value["app"].update(appVersion=version))
    files["config/opi-profile.js"] = update_config(
        profile_source, "OPI_PROFILE",
        configure_h5)
    validate_sdk(files, version)
    provenance = {
        "deliveryManifestSha256": sha256(files["webapp-manifest.json"]),
        "profileInputSha256": sha256(replacement_profile),
        "appConfigInputSha256": sha256(original_app),
        "modifiedDeliveryFiles": ["config/app-config.js", "config/opi-profile.js"],
        "nativeRouting": native_routing,
    }
    if settings_data is not None:
        provenance["connectionConfigInputSha256"] = sha256(settings_data)
    return files, provenance


def atomic_write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    require(not path.is_symlink(), "Refusing to overwrite a symbolic link")
    with tempfile.NamedTemporaryFile(dir=path.parent, prefix=".wevv-bundle-", delete=False) as stream:
        temporary = Path(stream.name)
        try:
            stream.write(data)
            stream.flush()
            temporary.chmod(0o644)
            temporary.replace(path)
        finally:
            temporary.unlink(missing_ok=True)


def pack(dist, profile_path, output, revision, version, connection_config=None):
    _, _, legacy_name = resource_material()
    require(output.name != legacy_name + ".data", "SDK 2 must not reuse the retired legacy resource name")
    require(not output.resolve().is_relative_to(dist.resolve()), "Output must be outside the source dist")
    require(revision == 2, "This stage accepts the confirmed OPI Revision 2 only")
    files, provenance = source_files(dist, profile_path, version, connection_config)
    encrypted = crypt(zlib.compress(zlib.compress(encode_archive(files), 9), 9))
    require(decode_bundle(encrypted) == files, "Encrypted archive round-trip failed")
    app, profile = validate_sdk(files, version)
    records = file_records(files)
    network_files = {name: files[name] for name in ("config/app-config.js", "config/opi-profile.js")}
    network_data = crypt(zlib.compress(zlib.compress(encode_archive(network_files), 9), 9))
    require(decode_bundle(network_data, require_entry=False) == network_files,
            "Native configuration round-trip failed")
    network_path = output.with_name(output.stem + "Network.data")
    metadata = {
        "schemaVersion": 1, "archiveFormat": MAGIC.decode(),
        "compression": {"algorithm": "zlib", "layers": 2},
        "encryption": {"algorithm": "AES-128-CBC", "padding": "PKCS7", "keySource": "existing-native-resource"},
        "status": "integrated",
        "contentVersion": content_version(records), "sdkProtocolVersion": "2.0.0",
        "appConfigSchemaVersion": 18, "opiProfileRevision": revision,
        "hostVersion": version, "appId": profile["services"]["apiClient"]["appId"],
        "environment": provenance["nativeRouting"]["environment"],
        "nativeRouting": provenance["nativeRouting"],
        "profileAliasCounts": {key: len(value) for key, value in profile["aliases"].items()},
        "h5BuildId": app["build"]["buildId"], "entryPoint": "index.html",
        "archiveFile": output.name, "archiveBytes": len(encrypted), "archiveSha256": sha256(encrypted),
        "fileCount": len(records), "unpackedBytes": sum(len(value) for value in files.values()),
        "source": provenance, "files": records,
        "nativeConfiguration": {"archiveFile": network_path.name, "archiveBytes": len(network_data),
                                "archiveSha256": sha256(network_data), "files": file_records(network_files)},
    }
    manifest_path = output.with_suffix(".manifest.data")
    atomic_write(output, encrypted)
    atomic_write(network_path, network_data)
    atomic_write(manifest_path, encode_manifest(metadata))
    output.with_suffix(".manifest.json").unlink(missing_ok=True)
    return metadata


def verify(bundle, manifest_path, version):
    metadata, encrypted = decode_manifest(manifest_path.read_bytes()), bundle.read_bytes()
    require(metadata.get("schemaVersion") == 1 and metadata.get("archiveFormat") == MAGIC.decode(),
            "Unsupported resource manifest")
    require(metadata.get("compression") == {"algorithm": "zlib", "layers": 2},
            "Unexpected resource compression")
    require(metadata.get("encryption") == {"algorithm": "AES-128-CBC", "padding": "PKCS7",
                                           "keySource": "existing-native-resource"},
            "Unexpected resource encryption")
    require(metadata.get("status") == "integrated" and metadata.get("sdkProtocolVersion") == "2.0.0"
            and metadata.get("appConfigSchemaVersion") == 18 and metadata.get("opiProfileRevision") == 2,
            "Unexpected SDK version or activation state")
    require(metadata["hostVersion"] == version, "Resource was built for a different native version")
    require(metadata["archiveFile"] == bundle.name and metadata["archiveBytes"] == len(encrypted)
            and metadata["archiveSha256"] == sha256(encrypted), "Encrypted resource checksum mismatch")
    files = decode_bundle(encrypted)
    records = file_records(files)
    require(records == metadata["files"] and len(records) == metadata["fileCount"]
            and sum(len(value) for value in files.values()) == metadata["unpackedBytes"]
            and content_version(records) == metadata["contentVersion"], "Resource file or version mismatch")
    app, profile = validate_sdk(files, version)
    require(metadata["appId"] == profile["services"]["apiClient"]["appId"]
            and metadata["h5BuildId"] == app["build"]["buildId"]
            and metadata["entryPoint"] == "index.html", "Resource metadata does not match its configuration")
    routing = validate_native_routing(metadata.get("nativeRouting", {
        "environment": "test", "bootstrapBaseUrl": profile["services"]["apiBaseUrl"],
        "bootstrapAppId": profile["services"]["apiClient"]["appId"],
    }))
    require(metadata.get("environment", "test") == routing["environment"]
            and ("nativeRouting" not in metadata or metadata["source"]["nativeRouting"] == routing)
            and metadata.get("profileAliasCounts", {"path": 167, "field": 964, "header": 7})
            == {key: len(value) for key, value in profile["aliases"].items()},
            "Resource environment or alias counts do not match its configuration")
    network = metadata["nativeConfiguration"]
    require(network["archiveFile"] == bundle.stem + "Network.data", "Invalid native configuration resource name")
    network_data = bundle.with_name(network["archiveFile"]).read_bytes()
    require(len(network_data) == network["archiveBytes"] and sha256(network_data) == network["archiveSha256"],
            "Native configuration resource checksum mismatch")
    network_files = decode_bundle(network_data, require_entry=False)
    require(network_files == {name: files[name] for name in ("config/app-config.js", "config/opi-profile.js")}
            and file_records(network_files) == network["files"], "Native and H5 configuration differ")
    return files, metadata


def verify_tree(root, files):
    require(root.is_dir() and not root.is_symlink(), "Invalid restored directory")
    actual = {}
    for path in root.rglob("*"):
        require(not path.is_symlink(), "Symbolic link in restored directory")
        if path.is_file():
            actual[path.relative_to(root).as_posix()] = path.read_bytes()
    require(actual == files, "Restored files differ from the archive")


def unpack(files, metadata, destination):
    require(re.fullmatch(r"sdk2-[0-9a-f]{64}", metadata["contentVersion"]), "Invalid content version")
    require(not destination.is_symlink(), "Invalid restoration root")
    destination.mkdir(parents=True, exist_ok=True)
    target = destination / metadata["contentVersion"]
    if target.exists() or target.is_symlink():
        verify_tree(target, files)
        return target
    staging = Path(tempfile.mkdtemp(prefix=".wevv-restore-", dir=destination))
    try:
        for name, data in files.items():
            path = staging / safe_path(name)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        verify_tree(staging, files)
        staging.rename(target)
    finally:
        if staging.exists():
            shutil.rmtree(staging)
    return target


def swift_block(source, marker):
    start = source.index(marker)
    opening, depth = source.index("{", start), 1
    cursor = opening + 1
    while depth:
        require(cursor < len(source), "Native restore declaration is incomplete")
        depth += (source[cursor] == "{") - (source[cursor] == "}")
        cursor += 1
    return source[start:cursor]


def native_verify(bundle, files, metadata):
    # Execute the actual SDK 2 restore implementation. Only the platform-specific
    # file-protection attribute is omitted on the macOS verification host.
    source = CONTROLLER.read_text()
    # Keep the complete shipping restore/cache/validation section, including its
    # synchronization fields and helpers. Only the filesystem root is redirected.
    start = source.index("    nonisolated private static func restorePastryArchive()")
    end = source.index("    private func showGlazeError(", start)
    archive = source[start:end]
    boundary = "manager.urls(for: .cachesDirectory, in: .userDomainMask).first"
    require(archive.count(boundary) == 1, "Native archive cache boundary changed")
    archive = archive.replace(boundary, "Optional(probeCacheRoot)")
    archive = re.sub(r"^.*try manager.setAttributes\(\[\.protectionKey:.*\n", "", archive, flags=re.M)
    blocks = [swift_block(source, "private enum sugarPalette"), archive]
    blocks = [block.replace("Bundle.main", "probeBundle") for block in blocks]
    runner = """import Foundation
import CommonCrypto
import zlib
enum WevVArchiveProbe {
    static let probeBundle = Bundle(path: CommandLine.arguments[1])!
    static let probeCacheRoot = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true)
    private enum GlazeFailure: Error { case code(String) }
%s
    static func run() throws {
        guard let folder = restorePastryArchive() else { throw NSError(domain: "WevVArchiveProbe", code: 1) }
        print(folder.path)
    }
}
try WevVArchiveProbe.run()
""" % "\n".join(blocks)
    with tempfile.TemporaryDirectory(prefix="wevv-native-probe-", dir="/private/tmp") as temporary:
        root = Path(temporary)
        swift, binary = root / "main.swift", root / "probe"
        resource_bundle = root / "SDK2.bundle"
        resource_bundle.mkdir()
        (resource_bundle / bundle.name).symlink_to(bundle.resolve())
        manifest = resource_bundle / "vanillaBeanIcingDonut.manifest.data"
        manifest.write_bytes(encode_manifest(metadata))
        swift.write_text(runner)
        command = ["xcrun", "swiftc", str(STRING_HELPER), "-module-cache-path", str(root / "module-cache"), str(swift), "-o", str(binary)]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        require(result.returncode == 0, "Native archive probe compilation failed")
        result = subprocess.run([str(binary), str(resource_bundle), str(root / "cache")], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        require(result.returncode == 0, "Native archive restore failed")
        restored = Path(result.stdout.decode().strip())
        try:
            verify_tree(restored, files)
        finally:
            shutil.rmtree(restored, ignore_errors=True)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    package = commands.add_parser("pack", help="Build an SDK 2 resource and version manifest")
    package.add_argument("--dist", type=Path, required=True)
    package.add_argument("--profile", type=Path, required=True)
    package.add_argument("--connection-config", type=Path,
                         help="Private connection JSON outside the repository; required for a bare aliases input")
    package.add_argument("--output", type=Path, required=True)
    package.add_argument("--profile-revision", type=int, choices=[2], default=2)
    package.add_argument("--host-version")
    for name in ("verify", "unpack"):
        command = commands.add_parser(name)
        command.add_argument("--bundle", type=Path, required=True)
        command.add_argument("--manifest", type=Path)
        command.add_argument("--host-version")
        if name == "verify":
            command.add_argument("--dist", type=Path)
            command.add_argument("--profile", type=Path)
            command.add_argument("--connection-config", type=Path)
            command.add_argument("--native", action="store_true", help="Also run the actual Swift restore functions")
        else:
            command.add_argument("--destination", type=Path, required=True)
    args = parser.parse_args(argv)
    try:
        version = args.host_version or host_version()
        require(re.fullmatch(r"\d+(?:\.\d+){1,2}", version), "Invalid host version")
        if args.command == "pack":
            metadata = pack(args.dist, args.profile, args.output, args.profile_revision, version, args.connection_config)
        else:
            files, metadata = verify(args.bundle, args.manifest or args.bundle.with_suffix(".manifest.data"), version)
            if args.command == "unpack":
                restored = unpack(files, metadata, args.destination)
                print("Restored:", restored)
            else:
                require(bool(args.dist) == bool(args.profile), "Source verification requires both --dist and --profile")
                if args.dist:
                    expected, provenance = source_files(args.dist, args.profile, version, args.connection_config)
                    require(files == expected and metadata["source"] == provenance,
                            "Resource does not match the supplied delivery/Profile")
                if args.native:
                    native_verify(args.bundle, files, metadata)
                    print("Native Swift restore: passed")
        print("%s: %d files, %d encrypted bytes, version %s, status %s" % (
            args.command, metadata["fileCount"], metadata["archiveBytes"],
            metadata["contentVersion"], metadata["status"]))
        return 0
    except (BundleError, OSError, ValueError, KeyError, TypeError, zlib.error) as error:
        # Do not include JSON values, decrypted bodies, or cryptographic inputs in logs.
        message = str(error) if isinstance(error, BundleError) else type(error).__name__
        print("Bundle operation failed: " + message, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
