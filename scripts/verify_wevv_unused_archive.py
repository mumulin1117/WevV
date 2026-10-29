#!/usr/bin/env python3
"""Check archive integrity, runtime references, and exclusion from the App target."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "WevSweetgd/WevSweetgd"
ARCHIVE = ROOT / "WevSweetgd/WeeNo"


def main():
    entries = json.loads((ARCHIVE / "manifest.json").read_text())["entries"]
    active = list(APP.rglob("*.swift"))
    runtime = "\n".join(path.read_text() for path in active)
    for path in APP.rglob("*"):
        if path.suffix in {".storyboard", ".xib", ".plist"}:
            runtime += "\n" + path.read_text()
    # Include the project's alternating-character restored string literals.
    runtime += "\n" + "\n".join(
        text[::2] for text in re.findall(
            r'"([^"\n]*)"\.wevVPastryCrumbBloomRestored', runtime
        )
    )
    for entry in entries:
        path = ROOT / entry["archived"]
        assert path.is_file(), path
        assert hashlib.sha256(path.read_bytes()).hexdigest() == entry["sha256"], path
        if entry["kind"] != "extracted":
            assert not (ROOT / entry["original"]).exists(), entry["original"]
        if path.suffix == ".swift":
            types = re.findall(
                r"^(?:(?:final|private|public)\s+)*(?:class|struct|enum)\s+(\w+)",
                path.read_text(), re.MULTILINE,
            )
            for name in types:
                assert not re.search(r"\b" + re.escape(name) + r"\b", runtime), name
        elif path.name == "Contents.json" and path.parent.suffix == ".imageset":
            assert path.parent.stem not in runtime, path.parent.stem
    project = (ROOT / "WevSweetgd/WevSweetgd.xcodeproj/project.pbxproj").read_text()
    group = re.search(r'(\w+) /\* WeeNo \*/ = \{[^}]+path = WeeNo;', project)
    assert group, "WeeNo must remain visible in Xcode"
    for members in re.findall(r"fileSystemSynchronizedGroups = \((.*?)\);", project, re.S):
        assert group[1] not in members, "Archive cannot belong to the App target"
    # Retain real active H5 entry points and the StoreKit observer.
    settings = (APP / "DimSugarpistachioCreamCoating.swift").read_text()
    home = (APP / "TvVDonutcreamapricotFillinger.swift").read_text()
    for route in (".editProfile", ".blocklist", ".relations(.friends)"):
        assert route in settings, route
    for route in (".diamonds", ".messages"):
        assert route in home, route
    assert "WevVGlazePurchaseCoordinator.shared.startObserving()" in (
        APP / "WevVGlazeApplication.swift"
    ).read_text()
    if len(sys.argv) > 1:
        build = Path(sys.argv[1])
        lists = list(build.rglob("*.SwiftFileList"))
        assert lists, "No compiler input lists found"
        for path in lists:
            assert "/WeeNo/" not in path.read_text(), path
        assets = list((build / "Build/Products").rglob("Assets.car"))
        assert assets, "No compiled asset catalog found"
        for path in assets:
            metadata = json.loads(subprocess.check_output(
                ["/usr/bin/assetutil", "--info", str(path)], text=True
            ))
            assert not any(item.get("Name") == "wevv_notice_empty_glaze" for item in metadata)
            for name in ("wevv_notice_sugar_back", "wevv_room_send_glaze", "oldgem"):
                assert any(item.get("Name") == name for item in metadata), name
    print(f"Archive verified: {len(entries)} entries; no active type/resource references; H5 routes retained")


if __name__ == "__main__":
    main()
