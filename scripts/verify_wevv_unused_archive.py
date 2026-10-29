#!/usr/bin/env python3
"""Check archive integrity, runtime references, and exclusion from the App target."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
from wevv_archive_source import read_archive

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "WevSweetgd/WevSweetgd"
ARCHIVE = ROOT / "WevSweetgd/WeeNo"


def main():
    entries = json.loads((ARCHIVE / "manifest.json").read_text())["entries"]
    archived_assets = {
        Path(entry["archived"]).parent.stem for entry in entries
        if entry["kind"] == "resource" and Path(entry["archived"]).parent.suffix == ".imageset"
    }
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
    rename_file = ROOT / "WevEnd类型重命名记录.json"
    reused = {}
    if rename_file.exists():
        reused = {entry["new"]: entry for entry in json.loads(rename_file.read_text())["rules"]}
    for entry in entries:
        path = ROOT / entry["archived"]
        assert path.is_file(), path
        assert hashlib.sha256(path.read_bytes()).hexdigest() == entry["sha256"], path
        if entry.get("encoding") == "line-comments-v1":
            restored = read_archive(path)
            assert hashlib.sha256(restored.encode()).hexdigest() == entry["originalSha256"], path
            assert all(not line.strip() or line.startswith("//") for line in path.read_text().splitlines()), path
        if entry["kind"] != "extracted":
            assert not (ROOT / entry["original"]).exists(), entry["original"]
        if path.suffix == ".swift":
            types = re.findall(
                r"^(?:(?:final|private|public)\s+)*(?:class|struct|enum)\s+(\w+)",
                read_archive(path), re.MULTILINE,
            )
            for name in types:
                if name in reused:
                    # A retired name may now identify a different, explicitly renamed active type.
                    source = (ROOT / reused[name]["currentFile"]).read_text()
                    assert re.search(r"\b(?:class|struct|enum)\s+" + re.escape(name) + r"\b", source), name
                else:
                    assert not re.search(r"\b" + re.escape(name) + r"\b", runtime), name
        if entry.get("sourceRanges"):
            source = (ROOT / entry["original"]).read_text()
            for removed in entry["sourceRanges"]:
                assert removed["marker"] not in source, (entry["original"], removed["marker"])
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
    for route in (".cinnamonDustDust", ".autumnPecanAssortment", ".hideDialSafetyOverlay(.crispEdgeDough)"):
        assert route in settings, route
    for route in (".chooseDonutAvatar", ".firstStatCenter"):
        assert route in home, route
    assert 'DrawcreamScoutSugarStyle.donutCheckinCalendar.donutDiaryFolio()' in (
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
            assert not any(item.get("Name") in archived_assets for item in metadata), path
            for name in ("wevv_notice_sugar_back", "wevv_room_send_glaze", "oldgem"):
                assert any(item.get("Name") == name for item in metadata), name
    print(f"Archive verified: {len(entries)} entries; no active type/resource references; H5 routes retained")


if __name__ == "__main__":
    main()
