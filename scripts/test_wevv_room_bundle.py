import json
import struct
import sys
import tempfile
import unittest
import zlib
from pathlib import Path
from unittest.mock import patch

import wevv_room_bundle as bundle


class ArchiveTests(unittest.TestCase):
    def setUp(self):
        self.files = {"index.html": b"entry", "assets/nested/test.bin": bytes(range(256)),
                      "fonts/empty.otf": b""}

    def record(self, name, content=b""):
        path = name.encode()
        return struct.pack("<IQ", len(path), len(content)) + path + content

    def delivery(self, root):
        dist = root / "dist"
        (dist / "config").mkdir(parents=True)
        (dist / "assets").mkdir()
        (dist / "index.html").write_bytes(b"sdk entry")
        (dist / "assets/test.bin").write_bytes(b"managed")
        app = {"schemaVersion": 18, "build": {"buildId": "fixture"},
               "app": {"appVersion": "1.0"},
               "bridge": {"methods": {method: method for method in bundle.SDK_METHODS}}}
        profile = {"schemaVersion": 1,
                   "services": {"apiBaseUrl": "https://example.com", "apiClient": {
                       "appId": "12211334", "appVersion": "1.0.0", "protocol": "opi-v2-aes",
                       "encryptionKey": "k" * 16, "encryptionIv": "v" * 16}},
                   "aliases": {kind: {kind + str(i): "alias_" + kind + str(i) for i in range(count)}
                               for kind, count in (("path", 167), ("field", 964), ("header", 7))}}
        def js(value, marker):
            return ("window.fixture = /*__%s_START__*/ %s /*__%s_END__*/;" %
                    (marker, json.dumps(value), marker)).encode()
        (dist / "config/app-config.js").write_bytes(js(app, "APP_CONFIG"))
        (dist / "config/opi-profile.js").write_bytes(js(profile, "OPI_PROFILE"))
        profile_file = root / "revision2.js"
        profile_file.write_bytes(js(profile, "OPI_PROFILE"))
        manifest = {"schemaVersion": 2,
                    "editableFiles": ["index.html", "config/app-config.js", "config/opi-profile.js"],
                    "managedFiles": [{"file": "assets/test.bin", "bytes": 7,
                                      "sha256": bundle.sha256(b"managed")}]}
        (dist / "webapp-manifest.json").write_text(json.dumps(manifest))
        return dist, profile_file

    def test_native_record_layout_and_round_trip(self):
        encoded = bundle.encode_archive(self.files)
        self.assertEqual(encoded[:8], b"WVVROOM1")
        path_size, size = struct.unpack_from("<IQ", encoded, 8)
        self.assertEqual(encoded[20:20 + path_size], b"assets/nested/test.bin")
        self.assertEqual(size, 256)
        self.assertEqual(bundle.decode_archive(encoded), self.files)
        self.assertEqual(encoded, bundle.encode_archive(dict(reversed(list(self.files.items())))))

    def test_unsafe_duplicate_and_conflicting_paths(self):
        for name in ("../index.html", "/index.html", "a/../x", "a/./x", "a//x", "a\\x", "C:/x", "a\0x"):
            with self.subTest(name=name), self.assertRaises(bundle.BundleError):
                bundle.decode_archive(bundle.MAGIC + self.record(name))
        for names in (("index.html", "index.html"), ("index.html", "INDEX.html"),
                      ("index.html", "assets", "assets/x")):
            with self.subTest(names=names), self.assertRaises(bundle.BundleError):
                bundle.decode_archive(bundle.MAGIC + b"".join(self.record(name) for name in names))

    def test_corrupt_archive_records(self):
        for data in (b"bad", bundle.MAGIC + b"short", bundle.MAGIC + struct.pack("<IQ", 30, 1),
                     bundle.MAGIC + struct.pack("<IQ", 0, 0),
                     bundle.MAGIC + self.record("assets/x")):
            with self.subTest(length=len(data)), self.assertRaises(bundle.BundleError):
                bundle.decode_archive(data)
        with self.assertRaises(UnicodeDecodeError):
            bundle.decode_archive(bundle.MAGIC + struct.pack("<IQ", 1, 0) + b"\xff")

    def test_zlib_rejects_truncation_trailing_data_and_size_overflow(self):
        data = zlib.compress(b"payload")
        self.assertEqual(bundle.inflate(data), b"payload")
        for invalid in (data[:-1], data + b"tail", b"not-zlib"):
            with self.subTest(invalid=invalid), self.assertRaises((bundle.BundleError, zlib.error)):
                bundle.inflate(invalid)
        with patch.object(bundle, "MAX_BYTES", 8), self.assertRaises(bundle.BundleError):
            bundle.inflate(zlib.compress(b"a" * 100))

    def test_native_stream_limit_is_also_checked(self):
        with patch.object(bundle, "MAX_BYTES", 100000):
            self.assertEqual(bundle.inflate(zlib.compress(b"a" * 90000)), b"a" * 90000)
            with self.assertRaises(bundle.BundleError):
                bundle.inflate(zlib.compress(b"a" * 100001))

    def test_strict_config_and_marker_preservation(self):
        source = b"window.test = /*__APP_CONFIG_START__*/ {\"app\":{\"appVersion\":\"1.0\"}} /*__APP_CONFIG_END__*/;"
        updated = bundle.update_config(source, "APP_CONFIG", lambda value: value["app"].update(appVersion="1.3"))
        self.assertTrue(updated.startswith(b"window.test = /*__APP_CONFIG_START__*/"))
        self.assertTrue(updated.endswith(b"/*__APP_CONFIG_END__*/;"))
        self.assertEqual(bundle.config_json(updated, "APP_CONFIG")[0]["app"]["appVersion"], "1.3")
        for invalid in (b'{"a":1,"a":2}', b'{"a":NaN}', b'{"a":1,}'):
            with self.subTest(invalid=invalid), self.assertRaises((bundle.BundleError, ValueError)):
                bundle.strict_json(invalid)

    def test_content_version_changes_with_any_file(self):
        first = bundle.content_version(bundle.file_records(self.files))
        self.files["index.html"] = b"changed"
        self.assertNotEqual(first, bundle.content_version(bundle.file_records(self.files)))

    def test_versioned_restore_is_reusable_and_rejects_mixed_files(self):
        version = bundle.content_version(bundle.file_records(self.files))
        metadata = {"contentVersion": version}
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            restored = bundle.unpack(self.files, metadata, root)
            self.assertEqual(restored.name, version)
            self.assertEqual(restored, bundle.unpack(self.files, metadata, root))
            (restored / "stale.js").write_bytes(b"old")
            with self.assertRaises(bundle.BundleError):
                bundle.unpack(self.files, metadata, root)

    def test_failed_restore_removes_partial_directory(self):
        metadata = {"contentVersion": "sdk2-" + "a" * 64}
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            with patch.object(bundle, "verify_tree", side_effect=bundle.BundleError("injected failure")):
                with self.assertRaises(bundle.BundleError):
                    bundle.unpack(self.files, metadata, root)
            self.assertEqual(list(root.iterdir()), [])

    def test_restored_symlinks_are_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "index.html").symlink_to("outside")
            with self.assertRaises(bundle.BundleError):
                bundle.verify_tree(root, self.files)

    def test_source_delivery_rejects_symlinks_and_modified_managed_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            dist, profile = self.delivery(root)
            (dist / "link").symlink_to("index.html")
            with self.assertRaises(bundle.BundleError):
                bundle.source_files(dist, profile, "1.3")
            (dist / "link").unlink()
            (dist / "assets/test.bin").write_bytes(b"changed")
            with self.assertRaises(bundle.BundleError):
                bundle.source_files(dist, profile, "1.3")

    def test_pack_refuses_reserved_legacy_name(self):
        _, _, legacy_name = bundle.resource_material()
        with self.assertRaises(bundle.BundleError):
            bundle.pack(Path("unused"), Path("unused"), Path(legacy_name + ".data"), 2, "1.3")

    def test_bare_production_aliases_use_private_settings_and_preserve_wrapper(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            dist, original = self.delivery(root)
            aliases = bundle.config_json(original.read_bytes(), "OPI_PROFILE")[0]["aliases"]
            aliases["path"].update({"extraPath" + str(i): "/extra/" + str(i) for i in range(18)})
            aliases["field"]["messageEnableConfig"] = "messageSettingAlias"
            profile = root / "opi-profile.txt"
            profile.write_text(json.dumps(aliases))
            settings = root / "private-settings.json"
            settings.write_text(json.dumps({"environment": "production", "apiBaseUrl": "https://production.invalid",
                "bootstrapBaseUrl": "https://route.invalid", "bootstrapAppId": "12211334", "appId": "39114002",
                "encryptionKey": "k" * 16, "encryptionIv": "v" * 16}))
            files, provenance = bundle.source_files(dist, profile, "1.3", settings)
            value, source, start, end = bundle.config_json(files["config/opi-profile.js"], "OPI_PROFILE")
            self.assertEqual(value["aliases"], aliases)
            self.assertEqual(value["services"]["apiClient"]["appId"], "39114002")
            self.assertEqual(set(value["services"]), {"apiBaseUrl", "apiClient"})
            self.assertEqual(provenance["nativeRouting"], {"environment": "production",
                "bootstrapBaseUrl": "https://route.invalid", "bootstrapAppId": "12211334"})
            self.assertTrue(source.startswith("window.fixture = /*__OPI_PROFILE_START__*/"))
            self.assertTrue(source.endswith("/*__OPI_PROFILE_END__*/;"))
            self.assertIn("connectionConfigInputSha256", provenance)
            with self.assertRaises(bundle.BundleError):
                bundle.source_files(dist, profile, "1.3")
            output = root / "production.data"
            metadata = bundle.pack(dist, profile, output, 2, "1.3", settings)
            self.assertEqual(metadata["profileAliasCounts"], {"path": 185, "field": 965, "header": 7})
            self.assertEqual(metadata["environment"], "production")
            self.assertEqual(metadata["nativeRouting"], provenance["nativeRouting"])
            self.assertEqual(bundle.verify(output, output.with_suffix(".manifest.json"), "1.3")[0], files)
            metadata["environment"] = "test"
            output.with_suffix(".manifest.json").write_text(json.dumps(metadata))
            with self.assertRaises(bundle.BundleError):
                bundle.verify(output, output.with_suffix(".manifest.json"), "1.3")

    @unittest.skipUnless(sys.platform == "darwin", "macOS CommonCrypto required")
    def test_complete_package_is_deterministic_and_checks_manifest_and_host_version(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            dist, profile = self.delivery(root)
            original_app = (dist / "config/app-config.js").read_bytes()
            original_profile = profile.read_bytes()
            output = root / "sdk2.data"
            metadata = bundle.pack(dist, profile, output, 2, "1.3")
            encrypted = output.read_bytes()
            manifest = output.with_suffix(".manifest.json")
            original_manifest = manifest.read_bytes()
            files, checked = bundle.verify(output, manifest, "1.3")
            self.assertEqual(metadata, checked)
            self.assertEqual(files, bundle.source_files(dist, profile, "1.3")[0])
            self.assertEqual(original_app, (dist / "config/app-config.js").read_bytes())
            self.assertEqual(original_profile, profile.read_bytes())
            bundle.pack(dist, profile, output, 2, "1.3")
            self.assertEqual(encrypted, output.read_bytes())
            self.assertEqual(original_manifest, manifest.read_bytes())
            with self.assertRaises(bundle.BundleError):
                bundle.verify(output, manifest, "1.4")
            for field, changed in (("contentVersion", "sdk2-" + "0" * 64),
                                   ("sdkProtocolVersion", "1.0.0"),
                                   ("appId", "invalid")):
                altered = dict(metadata, **{field: changed})
                manifest.write_text(json.dumps(altered))
                with self.subTest(field=field), self.assertRaises(bundle.BundleError):
                    bundle.verify(output, manifest, "1.3")
            manifest.write_bytes(original_manifest)
            output.write_bytes(bytes([encrypted[0] ^ 1]) + encrypted[1:])
            with self.assertRaises(bundle.BundleError):
                bundle.verify(output, manifest, "1.3")

    @unittest.skipUnless(sys.platform == "darwin", "macOS CommonCrypto required")
    def test_resource_crypto_rejects_wrong_key_and_corruption(self):
        original = bundle.encode_archive(self.files)
        encrypted = bundle.crypt(zlib.compress(zlib.compress(original)))
        self.assertEqual(bundle.decode_bundle(encrypted), self.files)
        for invalid in (encrypted[:-1], encrypted[:16], bytes([encrypted[0] ^ 1]) + encrypted[1:]):
            with self.subTest(length=len(invalid)), self.assertRaises((bundle.BundleError, zlib.error)):
                bundle.decode_bundle(invalid)
        with patch.object(bundle, "resource_material", return_value=(b"x" * 16, b"y" * 16, "unused")):
            with self.assertRaises((bundle.BundleError, zlib.error)):
                bundle.decode_bundle(encrypted)


if __name__ == "__main__":
    unittest.main()
