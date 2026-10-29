#!/usr/bin/env python3
"""Compile the real native entry builder and validate every URL with the delivered SDK JS."""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
from urllib.parse import parse_qsl, unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WevSweetgd/WevSweetgd"

SWIFT_FIXTURES = r'''
import Foundation

func room(_ id: String, _ type: chocolateCompote, host: String? = "10001", followed: Bool? = true) -> pearFilling {
    pearFilling(passionfruitMousse: id, lemonCurd: type, limeJam: "Alice & Bob + 甜甜圈", yuzuCustard: nil,
                peachCream: "", pearCenter: "https://example.com/avatar?a=1&b=two+words#crop", appleCompote: nil,
                figFilling: 0, custardCurd: [], vanillaJam: [], pistachioCustard: nil, hazelnutCream: false,
                glazeHostID: host, glazeIMAccount: "anchor+im/account", glazeFollowed: followed)
}

let index = URL(fileURLWithPath: "/tmp/WevV room dist/index.html")
let account = "target+im/空 帐&#?%"
let name = "Alice & Bob + 甜甜圈"
let avatar = "https://example.com/photo?a=1&b=two+words#crop"
let fixtures: [(String, chosenTiles)] = [
    ("messages", .messages), ("systemMessages", .systemMessages), ("likedMessages", .likedMessages),
    ("user", .user(userID: "20002", imAccount: "target-im-account")),
    ("creator", .creator(userID: "10001", imAccount: nil)),
    ("conversation", .conversation(userID: "20002", imAccount: account, name: name, avatarURL: avatar)),
    ("editProfile", .editProfile), ("diamonds", .diamonds), ("diamondRecords", .diamondRecords),
    ("blocklist", .blocklist), ("feedback", .feedback), ("level", .level),
    ("store", .store), ("backpack", .backpack),
    ("friends", .relations(.friends)), ("fans", .relations(.fans)), ("following", .relations(.following)),
    ("liveSearch", .liveSearch), ("liveRanking", .liveRanking), ("partyCreate", .partyCreate),
    ("partySearch", .partySearch), ("partyRanking", .partyRanking), ("cpSettings", .cpSettings),
    ("liveRoom", .room(room("901", .blueberryCustard))),
    ("liveHostLookup", .room(room("", .blueberryCustard, followed: nil))),
    ("voiceRoom", .room(room("902", .blackberryCream))),
    ("largeUserID", .user(userID: "9223372036854775807", imAccount: nil))
]
var records: [[String: Any]] = []
for (label, entry) in fixtures {
    guard let url = entry.makeURL(indexURL: index) else { fatalError("Missing URL for \(label)") }
    guard let bridgeEntry = entry.bridgeEntry else { fatalError("Missing idle activation entry for \(label)") }
    records.append(["label": label, "url": url.absoluteString, "bridgeEntry": bridgeEntry, "requiresFullFeatures": entry.requiresFullFeatures])
    precondition(entry.requiresFullFeatures == (label == "cpSettings"))
}
var rejected = 0
func rejects(_ entry: chosenTiles) {
    precondition(entry.makeURL(indexURL: index) == nil)
    precondition(entry.bridgeEntry == nil)
    rejected += 1
}
for invalid in ["", "0", "00", "01", "-1", "+1", "1.5", "1/2", "1?token=x", " 1", "1 ", "１２", "١٢"] {
    rejects(.user(userID: invalid, imAccount: nil))
    rejects(.creator(userID: invalid, imAccount: nil))
    rejects(.conversation(userID: invalid, imAccount: "target", name: nil, avatarURL: nil))
    rejects(.room(room(invalid, .blackberryCream)))
    rejects(.room(room("901", .blueberryCustard, host: invalid)))
}
rejects(.room(room("901", .blueberryCustard, host: nil)))
rejects(.conversation(userID: "2", imAccount: "", name: nil, avatarURL: nil))
rejects(.conversation(userID: "2", imAccount: " \n\t", name: nil, avatarURL: nil))
rejects(.conversation(userID: "2", imAccount: String(repeating: "a", count: 2048), name: nil, avatarURL: nil))
rejects(.conversation(userID: "2", imAccount: "target", name: String(repeating: "a", count: 4097), avatarURL: nil))
rejects(.conversation(userID: "2", imAccount: "target", name: String(repeating: "🍩", count: 2049), avatarURL: nil))
precondition(chosenTiles.messages.makeURL(indexURL: URL(string: "https://example.com/index.html")!) == nil)
precondition(chosenTiles.messages.makeURL(indexURL: URL(string: index.absoluteString + "#old")!) == nil)
precondition(chosenTiles.messages.makeURL(indexURL: URL(string: index.absoluteString + "?token=old")!) == nil)
let payload: [String: Any] = ["records": records, "rejected": rejected + 3]
print(String(data: try JSONSerialization.data(withJSONObject: payload, options: [.sortedKeys]), encoding: .utf8)!)
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dist", type=Path, default=Path.home() / "Downloads/dist")
    args = parser.parse_args()
    sdk = (args.dist / "index.html").read_text()
    whitelist = sdk.split("SDK_PAGE_ENTRIES=", 1)[1].split(",SDK_INTERNAL_PAGE_ENTRIES=", 1)[0]
    lookup = sdk.split("function sdkPageEntry(_)", 1)[1].split("var cacheablePageComponentNames", 1)[0]
    validators = sdk.split("function entryQueryText(_", 1)[1].split("function sdkEntryFromUrl", 1)[0]
    contract = ("const SDK_PAGE_ENTRIES=" + whitelist + ";function sdkPageEntry(_)" + lookup
                + "function entryQueryText(_" + validators)
    models = (SOURCE / "kettleGlazeSequence.swift").read_text()
    room_types = ("import Foundation\n" + models.split("enum chocolateCompote", 1)[1].split("enum mascarponeFilling", 1)[0])
    room_types = room_types.replace("import Foundation\n", "import Foundation\nenum chocolateCompote", 1)
    room_types += "struct pearFilling" + models.split("struct pearFilling", 1)[1].split("struct butteryTexture", 1)[0]
    swiftc = shutil.which("swiftc")
    node = shutil.which("node")
    if not swiftc or not node:
        raise SystemExit("swiftc and node are required")
    with tempfile.TemporaryDirectory(prefix="wevv-h5-entries-") as temporary:
        temp = Path(temporary)
        (temp / "Models.swift").write_text(room_types)
        (temp / "main.swift").write_text(SWIFT_FIXTURES)
        process = subprocess.run([
            swiftc, "-module-cache-path", str(temp / "module-cache"),
            str(temp / "Models.swift"), str(SOURCE / 'WevEnd/chosenTiles.swift'), str(temp / "main.swift"),
            "-o", str(temp / "verify-entries")
        ], text=True, capture_output=True)
        if process.returncode:
            raise SystemExit(process.stderr)
        payload = json.loads(subprocess.check_output([str(temp / "verify-entries")], text=True))
        records = payload["records"]
        for item in records:
            assert item["url"].startswith("file:///tmp/WevV%20room%20dist/index.html#/")
            fragment = item["url"].split("#", 1)[1]
            parsed = urlsplit(fragment)
            query = dict(parse_qsl(parsed.query, strict_parsing=True)) if parsed.query else {}
            assert item["bridgeEntry"] == {"path": parsed.path, "query": query}, item["label"]
            assert not any(secret in key.lower() for key in query for secret in ("token", "password", "receipt"))
            if item["label"] in ("store", "backpack"):
                assert query == {"tab": "all"}
            elif item["label"] == "conversation":
                assert unquote(parsed.path.split("/")[-1]) == "target+im/空 帐&#?%"
                assert query == {"userId": "20002", "yxAccid": "target+im/空 帐&#?%",
                                 "name": "Alice & Bob + 甜甜圈", "avatar": "https://example.com/photo?a=1&b=two+words#crop"}
            elif item["label"] == "liveRoom":
                assert parsed.path == "/live/room/901" and query["hostId"] == "10001"
                assert query["displayName"] == "Alice & Bob + 甜甜圈" and query["followed"] == "1"
                assert query["avatarUrl"] == "https://example.com/avatar?a=1&b=two+words#crop"
                assert query["imAccount"] == "anchor+im/account"
            elif item["label"] == "liveHostLookup":
                assert parsed.path == "/live/room" and "followed" not in query
            elif item["label"] == "voiceRoom":
                assert parsed.path == "/party/room/902" and not query
        node_test = contract + r'''
const records=JSON.parse(require('fs').readFileSync(0,'utf8'));
for(const row of records){
 const hash=new URL(row.url).hash.slice(1), url=new URL(hash,'https://sdk.invalid/');
 const entry={path:url.pathname,query:Object.fromEntries(url.searchParams)};
 const parsed=validateSdkEntry(entry);
 if(parsed.path!==entry.path)throw Error('Unexpected path replacement: '+row.label);
 const activated=validateSdkEntry(row.bridgeEntry);
 if(activated.path!==entry.path||Object.keys(activated.query).length!==Object.keys(parsed.query).length||Object.keys(parsed.query).some(key=>activated.query[key]!==parsed.query[key]))throw Error('Idle entry differs: '+row.label);
}
for(const path of ['/home','/profile','/party','/moments/create','/profile/vip','/customer-service','/profile/game-center']){
 let rejected=false;try{validateSdkEntry({path,query:{}})}catch{rejected=true}
 if(!rejected)throw Error('Internal page accepted: '+path);
}
for(const entry of [{path:'/conversation/target',query:{userId:'2'}},{path:'/conversation/target',query:{yxAccid:'target'}},
 {path:'/messages',query:{accessToken:'forbidden'}},{path:'/party/room',query:{}},
 {path:'/live/room/901',query:{}},{path:'/live/room/901',query:{hostId:'2',followed:'true'}}]){
 let rejected=false;try{validateSdkEntry(entry)}catch{rejected=true}
 if(!rejected)throw Error('Invalid entry accepted');
}
console.log('Delivered SDK accepted '+records.length+' native URLs; rejected 13 forbidden or malformed entries.');
'''
        output = subprocess.check_output([node, "-e", node_test], input=json.dumps(records), text=True)
        assert "D.path===`/profile/cp-settings`&&!getProductCapabilities().cp" in sdk
        assert "if(!N.authenticated)return Z(`session-required`),!1" in sdk
        assert "if(!C.canGoBack()){await requestSdkClose(`back`);return}" in sdk
        print(output.strip())
        print(f"Native route checks passed: {len(records)} valid entries, {payload['rejected']} invalid values/index URLs rejected.")
        print("Encoding round trips, room compatibility, CP-only feature gate, authenticated entry and root-close contracts passed.")


if __name__ == "__main__":
    main()
