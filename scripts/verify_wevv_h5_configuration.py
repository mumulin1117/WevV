#!/usr/bin/env python3
"""Run the delivered H5's actual validators against its restored configuration.

Offline only. Restores the full encrypted archive in memory, then executes the
Zod implementation and parseAppConfig/parseOpiProfile functions extracted from
that same index.html in a Node VM. No mirrored schema, network, credentials in
output, or plaintext configuration files are used.
"""

import hashlib
import importlib.util
import json
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "WevSweetgd/WevSweetgd"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def delivered_validator_source(html):
    # These boundaries retain the delivery's entire Zod dependency chain and
    # both complete parser functions, stopping before application startup.
    start = "_a$1,NEVER=Object.freeze({status:`aborted`});function $constructor"
    stop = "function getRuntimeConfig(){"
    require(html.count(start) == 1 and html.count(stop) == 1,
            "Delivered validator boundaries changed; inspect the SDK before updating this test")
    code = "var " + html[html.index(start):html.index(stop)]
    for name in ("function parseOpiProfile(", "function parseAppConfig("):
        require(code.count(name) == 1, "Missing delivered configuration parser")
    loader_start = "async function loadOpiProfile(){"
    loader_stop = "var EXTERNAL_PROTOCOL="
    require(html.count(loader_start) == 1 and html.count(loader_stop) == 1,
            "Delivered Profile loader boundaries changed")
    loader = html[html.index(loader_start):html.index(loader_stop)]
    require("./config/opi-profile.js" in loader, "Unexpected delivered Profile URL")
    return code + ";" + loader


NODE_RUNNER = r"""
const vm = require('node:vm');
const assert = require('node:assert/strict');
const input = JSON.parse(require('node:fs').readFileSync(0, 'utf8'));
let checks = 0;
const sandbox = { TextEncoder, URL };
sandbox.window = sandbox;
const context = vm.createContext(sandbox, { name: 'delivered-h5-config' });
const run = (source) => vm.runInContext(source, context, { timeout: 10000 });
const plain = (value) => JSON.parse(JSON.stringify(value));
const copy = (value) => JSON.parse(JSON.stringify(value));
function check(name, body) {
  try { body(); checks++; }
  catch (_) { throw new Error('Configuration regression failed: ' + name); }
}
function accepted(name, expression) {
  check(name, () => assert.equal(run(expression).success, true));
}
function rejectedProfile(name, value, issueTest) {
  sandbox.fixture = value;
  check(name, () => {
    const result = run('opiProfileSchema.safeParse(fixture)');
    assert.equal(result.success, false);
    if (issueTest) assert.ok(result.error.issues.some(issueTest));
  });
}
(async () => {
  // Execute the original config scripts, including their real global names.
  run(input.appScript);
  run(input.profileScript);
  check('app script and marked JSON agree', () =>
    assert.deepEqual(plain(sandbox.__SOCIAL_APP_CONFIG__), input.appJSON));
  check('profile script and marked JSON agree', () =>
    assert.deepEqual(plain(sandbox.__SOCIAL_OPI_PROFILE__), input.profileJSON));
  run(input.validatorSource);
  accepted('actual app config parser', 'runtimeConfigSchema.safeParse(window.__SOCIAL_APP_CONFIG__)');
  accepted('actual profile parser', 'opiProfileSchema.safeParse(window.__SOCIAL_OPI_PROFILE__)');
  check('throwing parser functions', () => {
    run('parseAppConfig(window.__SOCIAL_APP_CONFIG__); parseOpiProfile(window.__SOCIAL_OPI_PROFILE__);');
  });
  check('H5 services contain only supported keys', () =>
    assert.deepEqual(Object.keys(input.profileJSON.services).sort(), ['apiBaseUrl', 'apiClient']));
  check('production aliases are retained as a supported superset', () =>
    assert.deepEqual(Object.fromEntries(Object.entries(input.profileJSON.aliases)
      .map(([key, value]) => [key, Object.keys(value).length])), input.aliasCounts));

  // Reproduce the released failure with synthetic routing values. Never echo
  // real Profile contents, keys, or individual alias values.
  const unsupported = {
    environment: 'production',
    bootstrapBaseUrl: 'https://bootstrap.invalid',
    bootstrapAppId: '12211334',
  };
  const broken = copy(input.profileJSON);
  Object.assign(broken.services, unsupported);
  rejectedProfile('original three extra services fields', broken, (issue) =>
    issue.code === 'unrecognized_keys' && issue.path.join('.') === 'services' &&
      Object.keys(unsupported).every((key) => issue.keys.includes(key)));
  for (const [name, value] of Object.entries(unsupported)) {
    const profile = copy(input.profileJSON);
    profile.services[name] = value;
    rejectedProfile('extra service ' + name, profile, (issue) =>
      issue.code === 'unrecognized_keys' && issue.path.join('.') === 'services' && issue.keys.includes(name));
  }
  const extraHeader = copy(input.profileJSON);
  extraHeader.aliases.header.unsupportedHeader = 'SyntheticUnsupportedHeader';
  rejectedProfile('headers retain exact supported semantic set', extraHeader);
  const appExtra = copy(input.appJSON);
  appExtra.unsupported = true;
  sandbox.fixture = appExtra;
  check('app config remains strict', () =>
    assert.equal(run('runtimeConfigSchema.safeParse(fixture)').success, false));

  // Exercise the SDK's actual async dynamic script loader without networking.
  // Its appendChild callback evaluates the same bundled Profile source.
  let loadedURL;
  sandbox.setTimeout = () => 1;
  sandbox.clearTimeout = () => {};
  sandbox.document = {
    createElement(tag) {
      assert.equal(tag, 'script');
      return { remove() {} };
    },
    head: {
      appendChild(script) {
        loadedURL = script.src;
        run(input.profileScript);
        script.onload();
      },
    },
  };
  await run('loadOpiProfile()');
  check('actual dynamic loader and global Profile', () => {
    assert.equal(loadedURL, './config/opi-profile.js');
    assert.deepEqual(plain(sandbox.__SOCIAL_OPI_PROFILE__), input.profileJSON);
  });
  delete sandbox.__SOCIAL_OPI_PROFILE__;
  sandbox.document.head.appendChild = (script) => { script.onload(); };
  let missingGlobalRejected = false;
  try { await run('loadOpiProfile()'); }
  catch (_) { missingGlobalRejected = true; }
  check('loader rejects a missing Profile global', () => assert.ok(missingGlobalRejected));
  process.stdout.write(JSON.stringify({ ok: true, checks }));
})().catch(() => {
  // Do not print validation errors: future SDK errors may embed input values.
  process.stdout.write(JSON.stringify({ ok: false, checks }));
  process.exitCode = 1;
});
"""


def main():
    node = shutil.which("node")
    require(node is not None, "Node.js is required to execute the delivered validators")
    spec = importlib.util.spec_from_file_location("wevv_room_bundle", ROOT / "scripts/wevv_room_bundle.py")
    packer = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(packer)
    manifest = packer.strict_json((RESOURCES / "vanillaBeanIcingSdk2.manifest.json").read_bytes())
    encrypted = (RESOURCES / manifest["archiveFile"]).read_bytes()
    require(hashlib.sha256(encrypted).hexdigest() == manifest["archiveSha256"],
            "Encrypted resource checksum mismatch")
    files = packer.decode_bundle(encrypted)
    require(packer.file_records(files) == manifest["files"], "Restored resource content differs from manifest")
    app_script = files["config/app-config.js"].decode("utf-8")
    profile_script = files["config/opi-profile.js"].decode("utf-8")
    app = packer.config_json(files["config/app-config.js"], "APP_CONFIG")[0]
    profile = packer.config_json(files["config/opi-profile.js"], "OPI_PROFILE")[0]
    # config_json enforces exactly one pair of markers and strict JSON.
    payload = {
        "validatorSource": delivered_validator_source(files["index.html"].decode("utf-8")),
        "appScript": app_script, "profileScript": profile_script,
        "appJSON": app, "profileJSON": profile,
        "aliasCounts": manifest["profileAliasCounts"],
    }
    result = subprocess.run([node, "-e", NODE_RUNNER], input=json.dumps(payload),
                            text=True, capture_output=True, timeout=30)
    # Ignore stderr and raw stdout on failure, preventing accidental secret leaks.
    try:
        summary = json.loads(result.stdout)
    except (ValueError, TypeError):
        summary = {}
    require(result.returncode == 0 and summary.get("ok") is True,
            "Delivered H5 configuration validation failed; configuration contents were withheld")
    counts = manifest["profileAliasCounts"]
    print(f"PASS: {summary['checks']} actual H5 validator and loader checks; "
          f"aliases {counts['path']}/{counts['field']}/{counts['header']}; "
          "original unsupported-services failure reproduced; no network or sensitive output")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        print("FAIL: bundled H5 configuration checks failed; configuration contents were withheld", file=sys.stderr)
        sys.exit(1)
