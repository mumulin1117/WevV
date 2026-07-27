import Foundation

struct WevVGuestGlazePost {
    let sugarKey: String
    let title: String
    let crumbText: String
}

struct WevVGuestGlazeTie {
    var isGlazeFollowed: Bool
    var isSprinkleFan: Bool
    var isSugarShielded: Bool
}

struct WevVGuestGlazeProfile {
    let glazeKey: String
    let name: String
    let signature: String
    let avatarAsset: String
    let sugarPosts: [WevVGuestGlazePost]
    let joinedChallenges: [String]
    let sweetMarkCount: Int
    let followingCount: Int
    let followerCount: Int
    var sugarTie: WevVGuestGlazeTie
}

final class WevVGuestGlazeStore {
    static let shared = WevVGuestGlazeStore()

    private let frostingDefaults = UserDefaults.standard
    private let followedKey = "wevv_glaze_guest_followed"
    private let shieldedKey = "wevv_glaze_guest_shielded"

    private let baseProfiles: [WevVGuestGlazeProfile] = [
        WevVGuestGlazeProfile(
            glazeKey: "jamieCole",
            name: "Jamie Cole",
            signature: "Stand-up Comedian\nBrooklyn · 6 years on stage",
            avatarAsset: "wevv_guest_glaze_mira",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "jamiePowderOne", title: "Powder Ring Spotlight", crumbText: "A warm ring with clean sugar dust."),
                WevVGuestGlazePost(sugarKey: "jamieBerryTwo", title: "Berry Stage Bite", crumbText: "Sweet glaze before a tiny tasting set.")
            ],
            joinedChallenges: ["Newcomer Comedy Club", "Storytelling After Dark"],
            sweetMarkCount: 60,
            followingCount: 33,
            followerCount: 120,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "louiseSantos",
            name: "Louise Santos",
            signature: "Golden rings, berry glaze, and cozy shop notes.",
            avatarAsset: "wevv_guest_glaze_luna",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "louiseSweetOne", title: "One Bite Glow", crumbText: "A bright shop stop with a soft strawberry ring."),
                WevVGuestGlazePost(sugarKey: "louiseSweetTwo", title: "Weekend Tray", crumbText: "Fresh dough made the whole morning warmer.")
            ],
            joinedChallenges: ["Pink Donut Day", "Strawberry Week"],
            sweetMarkCount: 214,
            followingCount: 58,
            followerCount: 930,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: true, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "masonGlazeSmile",
            name: "Mason Reed",
            signature: "Sprinkle jokes, bright photos, and soft bites.",
            avatarAsset: "wevv_guest_glaze_arlo",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "masonPinkOne", title: "Pink Counter Trick", crumbText: "Held a tiny ring like a trophy."),
                WevVGuestGlazePost(sugarKey: "masonPinkTwo", title: "Fresh Tray Smile", crumbText: "The whole box smelled like warm vanilla.")
            ],
            joinedChallenges: ["Donut of the Day", "Sprinkle Style"],
            sweetMarkCount: 365,
            followingCount: 76,
            followerCount: 1420,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "avaCocoaRing",
            name: "Ava Cocoa",
            signature: "Chocolate glaze with sunshine and soft crumbs.",
            avatarAsset: "wevv_guest_glaze_nova",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "avaCocoaOne", title: "Chocolate Day", crumbText: "A glossy top and a mellow dough finish."),
                WevVGuestGlazePost(sugarKey: "avaCocoaTwo", title: "Orange Wall Treat", crumbText: "Bright color made the cocoa shine.")
            ],
            joinedChallenges: ["Donut & Coffee Match", "First Bite Reaction"],
            sweetMarkCount: 188,
            followingCount: 44,
            followerCount: 780,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "bellaSprinkle",
            name: "Bella Sprinkle",
            signature: "Weekend donut walls and color-filled tasting boards.",
            avatarAsset: "wevv_guest_glaze_poppy",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "bellaWallOne", title: "Weekend Ring Wall", crumbText: "Picked a fresh tray for the first sunny break."),
                WevVGuestGlazePost(sugarKey: "bellaWallTwo", title: "Confetti Box", crumbText: "Every topping had a tiny crunch.")
            ],
            joinedChallenges: ["Sprinkle Style", "Pink Donut Day"],
            sweetMarkCount: 241,
            followingCount: 69,
            followerCount: 1110,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: true, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "miaPinkSugar",
            name: "Mia Pink",
            signature: "Tiny pink sweetness and soft cream-filled rounds.",
            avatarAsset: "wevv_guest_glaze_rhea",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "miaPinkOne", title: "Pink Sweetness", crumbText: "A little glaze turned the day around."),
                WevVGuestGlazePost(sugarKey: "miaPinkTwo", title: "Cream Round", crumbText: "Smooth filling with a gentle sugar finish.")
            ],
            joinedChallenges: ["First Bite Reaction", "Strawberry Week"],
            sweetMarkCount: 173,
            followingCount: 35,
            followerCount: 640,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "noraCreamRing",
            name: "Nora Cream",
            signature: "Cream-filled rings, pretty trays, and soft photo notes.",
            avatarAsset: "wevv_guest_glaze_berry",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "noraCreamOne", title: "Cream-Filled Table", crumbText: "Sweet rings made a tiny dessert party."),
                WevVGuestGlazePost(sugarKey: "noraCreamTwo", title: "Sugar Pair", crumbText: "Two toppings, one bright afternoon.")
            ],
            joinedChallenges: ["Donut of the Day", "Donut & Coffee Match"],
            sweetMarkCount: 209,
            followingCount: 47,
            followerCount: 870,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "miraPurpleGlaze",
            name: "Mira Vale",
            signature: "Powdered rings, quiet booths, and berry glaze notes.",
            avatarAsset: "wevv_guest_glaze_mira",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "miraPowderOne", title: "Purple Smile Run", crumbText: "Found a tiny shop with lavender icing."),
                WevVGuestGlazePost(sugarKey: "miraPowderTwo", title: "Late Frosting Bite", crumbText: "Soft dough after sunset tastes better.")
            ],
            joinedChallenges: ["Strawberry Week", "Glaze Trail"],
            sweetMarkCount: 128,
            followingCount: 42,
            followerCount: 810,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "lunaLaughGlaze",
            name: "Luna Hart",
            signature: "I rate sprinkles by crunch and color.",
            avatarAsset: "wevv_guest_glaze_luna",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "lunaCrunchOne", title: "Pink Counter Joy", crumbText: "The strawberry shell cracked perfectly."),
                WevVGuestGlazePost(sugarKey: "lunaCrunchTwo", title: "Cream Trail", crumbText: "Maple glaze still leads my list.")
            ],
            joinedChallenges: ["Maple Dash", "Sugar Booth"],
            sweetMarkCount: 232,
            followingCount: 65,
            followerCount: 1240,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: true, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "novaBubbleGlaze",
            name: "Nova Finch",
            signature: "Tiny shops, bright fillings, neat tasting notes.",
            avatarAsset: "wevv_guest_glaze_nova",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "novaPearlOne", title: "Glaze Window", crumbText: "A classic ring with raspberry dust."),
                WevVGuestGlazePost(sugarKey: "novaPearlTwo", title: "Soft Batch", crumbText: "Warm dough changed the whole score.")
            ],
            joinedChallenges: ["Strawberry Week", "Cocoa Round"],
            sweetMarkCount: 94,
            followingCount: 28,
            followerCount: 520,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "soraCreamGlaze",
            name: "Sora Lane",
            signature: "Custard first, frosting second, crumbs always counted.",
            avatarAsset: "wevv_guest_glaze_sora",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "soraCustardOne", title: "Custard Corner", crumbText: "Vanilla center was smooth and light."),
                WevVGuestGlazePost(sugarKey: "soraCustardTwo", title: "Golden Case", crumbText: "Best batch sat on the top shelf.")
            ],
            joinedChallenges: ["Custard Map", "Glaze Trail"],
            sweetMarkCount: 76,
            followingCount: 19,
            followerCount: 330,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "doodleMintGlaze",
            name: "Doodle Mint",
            signature: "Cartoon crumbs and sugar sketches.",
            avatarAsset: "wevv_guest_glaze_doodle",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "doodleSketchOne", title: "Blue Frosting Mood", crumbText: "Drew the funniest donut wrapper."),
                WevVGuestGlazePost(sugarKey: "doodleSketchTwo", title: "Tiny Bite Log", crumbText: "Round, sweet, and nicely uneven.")
            ],
            joinedChallenges: ["Sugar Booth"],
            sweetMarkCount: 51,
            followingCount: 12,
            followerCount: 244,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "arloSkyGlaze",
            name: "Arlo Reed",
            signature: "Blue-sky tasting runs and cocoa glaze stops.",
            avatarAsset: "wevv_guest_glaze_arlo",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "arloSkyOne", title: "Morning Case", crumbText: "The first tray was still warm."),
                WevVGuestGlazePost(sugarKey: "arloSkyTwo", title: "Cocoa Dust", crumbText: "Dark topping, soft center, clean finish.")
            ],
            joinedChallenges: ["Cocoa Round", "Maple Dash"],
            sweetMarkCount: 143,
            followingCount: 37,
            followerCount: 690,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: true, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "poppySunGlaze",
            name: "Poppy Wells",
            signature: "Sunny bites and sour berry filling hunts.",
            avatarAsset: "wevv_guest_glaze_poppy",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "poppySunOne", title: "Sky Batch", crumbText: "Lemon glaze was sharp in a good way."),
                WevVGuestGlazePost(sugarKey: "poppySunTwo", title: "Berry Ticket", crumbText: "The filling had a bright little kick.")
            ],
            joinedChallenges: ["Lemon Loop", "Strawberry Week"],
            sweetMarkCount: 187,
            followingCount: 53,
            followerCount: 980,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "rheaHoneyGlaze",
            name: "Rhea Bloom",
            signature: "Honey rings, soft sleeves, and pretty sugar trails.",
            avatarAsset: "wevv_guest_glaze_rhea",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "rheaHoneyOne", title: "Honey Pair", crumbText: "A mild glaze with a floral finish."),
                WevVGuestGlazePost(sugarKey: "rheaHoneyTwo", title: "Window Seat", crumbText: "A good donut deserves slow notes.")
            ],
            joinedChallenges: ["Honey Week", "Glaze Trail"],
            sweetMarkCount: 205,
            followingCount: 73,
            followerCount: 1510,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "blairBlueGlaze",
            name: "Blair Kline",
            signature: "Blue hood, warm cup, cinnamon sugar.",
            avatarAsset: "wevv_guest_glaze_blair",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "blairCupOne", title: "Cinnamon Cup", crumbText: "Crunchy edge, airy center."),
                WevVGuestGlazePost(sugarKey: "blairCupTwo", title: "Powder Stop", crumbText: "The sugar stuck to everything.")
            ],
            joinedChallenges: ["Cinnamon Path", "Sugar Booth"],
            sweetMarkCount: 118,
            followingCount: 31,
            followerCount: 730,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: true, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "velvetStageGlaze",
            name: "Velvet Rook",
            signature: "Bold looks, bold frosting, no dull bites.",
            avatarAsset: "wevv_guest_glaze_velvet",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "velvetStageOne", title: "Runway Ring", crumbText: "Black sesame glaze was deep and smooth."),
                WevVGuestGlazePost(sugarKey: "velvetStageTwo", title: "Spotlight Bite", crumbText: "A crisp shell over soft dough.")
            ],
            joinedChallenges: ["Cocoa Round", "Honey Week"],
            sweetMarkCount: 166,
            followingCount: 45,
            followerCount: 860,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "caramelFernGlaze",
            name: "Caramel Fern",
            signature: "Caramel curls and nutty glaze notes.",
            avatarAsset: "wevv_guest_glaze_caramel",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "caramelCurlOne", title: "Brown Sugar Case", crumbText: "Sticky top, mellow finish."),
                WevVGuestGlazePost(sugarKey: "caramelCurlTwo", title: "Nutty Box", crumbText: "Toasted pieces made the batch sing.")
            ],
            joinedChallenges: ["Maple Dash", "Honey Week"],
            sweetMarkCount: 97,
            followingCount: 22,
            followerCount: 410,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: true, isSugarShielded: false)
        ),
        WevVGuestGlazeProfile(
            glazeKey: "berryCloudGlaze",
            name: "Berry Cloud",
            signature: "Blueberry filling, vanilla cream, gentle scores.",
            avatarAsset: "wevv_guest_glaze_berry",
            sugarPosts: [
                WevVGuestGlazePost(sugarKey: "berryCloudOne", title: "Blueberry Fold", crumbText: "Tangy filling kept the bite light."),
                WevVGuestGlazePost(sugarKey: "berryCloudTwo", title: "Cream Drift", crumbText: "Vanilla cream was soft and clean.")
            ],
            joinedChallenges: ["Berry Loop", "Strawberry Week"],
            sweetMarkCount: 152,
            followingCount: 39,
            followerCount: 775,
            sugarTie: WevVGuestGlazeTie(isGlazeFollowed: false, isSprinkleFan: false, isSugarShielded: false)
        )
    ]

    var allProfiles: [WevVGuestGlazeProfile] {
        baseProfiles.map { profile in
            var packet = profile
            packet.sugarTie.isGlazeFollowed = followedKeys.contains(profile.glazeKey)
            packet.sugarTie.isSugarShielded = shieldedKeys.contains(profile.glazeKey)
            return packet
        }
    }

    func profile(for glazeKey: String) -> WevVGuestGlazeProfile {
        allProfiles.first { $0.glazeKey == glazeKey } ?? allProfiles[0]
    }

    func profile(at index: Int) -> WevVGuestGlazeProfile {
        let profiles = allProfiles
        return profiles[abs(index) % profiles.count]
    }

    @discardableResult
    func toggleGlazeFollow(for glazeKey: String) -> Bool {
        var keys = followedKeys
        if keys.contains(glazeKey) {
            keys.remove(glazeKey)
        } else {
            keys.insert(glazeKey)
        }
        frostingDefaults.set(Array(keys).sorted(), forKey: followedKey)
        return keys.contains(glazeKey)
    }

    @discardableResult
    func toggleSugarShield(for glazeKey: String) -> Bool {
        var keys = shieldedKeys
        if keys.contains(glazeKey) {
            keys.remove(glazeKey)
        } else {
            keys.insert(glazeKey)
        }
        frostingDefaults.set(Array(keys).sorted(), forKey: shieldedKey)
        return keys.contains(glazeKey)
    }

    private var followedKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: followedKey) ?? [])
    }

    private var shieldedKeys: Set<String> {
        Set(frostingDefaults.stringArray(forKey: shieldedKey) ?? [])
    }
}
