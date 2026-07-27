import UIKit

final class WevVDonutRootController: UIViewController {
    private let glazeSession = WevVGlazeSessionStore.shared
    private let guestStore = WevVGuestGlazeStore.shared
    private let frostingScroll = UIScrollView()
    private let sprinkleContent = UIView()
    private let shopCarousel = UIScrollView()
    private let shopPages = UIStackView()
    private let shopDots = UIPageControl()
    private let challengeStrip = UIScrollView()
    private let challengeRow = UIStackView()
    private let momentStack = UIStackView()
    private let frostingDiaryPanel = UIView()
    private let discoverPanel = UIView()
    private let frostingPostEntryButton = UIButton(type: .custom)
    private let sugarProfilePanel = UIView()
    private let profileNameLabel = UILabel()
    private let profileFollowingCountLabel = UILabel()
    private let profileFollowerCountLabel = UILabel()
    private let profileShelfCountLabel = UILabel()
    private let profileVaultCountLabel = UILabel()
    private let profilePostStack = UIStackView()
    private let profileEmptyStack = UIStackView()
    private let donutTabBack = UIView()
    private let donutContentFoot = UIView()
    private var glazeCarouselTimer: Timer?
    private var donutTabIcons: [WevVDonutMainSection: UIImageView] = [:]
    private var donutContentFootTopConstraints: [WevVDonutMainSection: NSLayoutConstraint] = [:]
    private var glazeHomePanels: [UIView] = []
    private var frostingDiaryPanels: [UIView] = []
    private var activeDonutSection = WevVDonutMainSection.glazeHome

    private let donutTabAssetTrail: [WevVDonutMainSection: (idle: String, active: String)] = [
        .glazeHome: ("wevv_tab_home_glaze_idle", "wevv_tab_home_glaze_active"),
        .frostingDiary: ("wevv_tab_discover_sprinkle_idle", "wevv_tab_discover_sprinkle_active"),
        .sugarProfile: ("wevv_tab_profile_donut_idle", "wevv_tab_profile_donut_active")
    ]

    private let glazeShops: [WevVGlazeShop] = [
        WevVGlazeShop(glazeKey: "berryRingBakery", shopTitle: "Berry Ring Bakery", flavorLine: "Fresh donuts · berry flavors", coverAsset: "wevv_shop_berry_ring_bakery"),
        WevVGlazeShop(glazeKey: "goldenDoughStudio", shopTitle: "Golden Dough Studio", flavorLine: "Artisan donuts · small batches", coverAsset: "wevv_shop_golden_dough_studio"),
        WevVGlazeShop(glazeKey: "moonlightDonutBar", shopTitle: "Moonlight Donut Bar", flavorLine: "Late-night donuts · creative drinks", coverAsset: "wevv_shop_moonlight_donut_bar")
    ]

    private let dailyCheckin = WevVDailyCheckin(
        frostingKey: "dailyDonutStamp",
        title: "Daily",
        caption: "Check-in",
        cardAsset: "wevv_checkin_donut_daily_card"
    )

    private var sprinkleChallenges: [WevVSprinkleChallenge] = [
        WevVSprinkleChallenge(
            sprinkleKey: "strawberryWeek",
            title: "Strawberry Week",
            caption: "Try a mystery donut and guess the flavor.",
            cardAsset: "wevv_challenge_strawberry_week",
            joinedText: "Join",
            glazeLine: "Complete today's tasting task and share a berry note.",
            sprinkleTimeText: "Friday · 8:00 PM - 10:30 PM",
            crumbPlaceText: "Berry Ring Bakery, San Francisco",
            hostGuestKey: "jamieCole",
            hostLine: "Verified host · 4.9 rating",
            missionText: "Taste a strawberry ring, name the hidden filling, and post your sweetest flavor clue.",
            crowdText: "23 people",
            sugarCost: 300
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "pinkDonutDay",
            title: "Pink Donut Day",
            caption: "Share a pink donut and create your sweetest photo.",
            cardAsset: "wevv_challenge_pink_donut_day",
            joinedText: "Join",
            glazeLine: "Build a bright pink donut photo set for the day.",
            sprinkleTimeText: "Saturday · 2:00 PM - 5:00 PM",
            crumbPlaceText: "Golden Dough Studio, San Francisco",
            hostGuestKey: "rheaHoneyGlaze",
            hostLine: "Photo host · 4.8 rating",
            missionText: "Capture a pink donut moment with one short tasting note and a playful topping idea.",
            crowdText: "31 people",
            sugarCost: 260
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "donutCoffeeMatch",
            title: "Donut & Coffee Match",
            caption: "Pair your favorite donut with the perfect coffee.",
            cardAsset: "wevv_challenge_donut_coffee_match",
            joinedText: "Join",
            glazeLine: "Find a donut pairing that makes coffee taste better.",
            sprinkleTimeText: "Sunday · 10:30 AM - 12:00 PM",
            crumbPlaceText: "Moonlight Donut Bar, San Francisco",
            hostGuestKey: "arloSkyGlaze",
            hostLine: "Pairing host · 4.7 rating",
            missionText: "Pick a donut and a coffee style, then explain why the frosting and roast work together.",
            crowdText: "28 people",
            sugarCost: 280
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "firstBiteReaction",
            title: "First Bite Reaction",
            caption: "Capture your real reaction after the first bite.",
            cardAsset: "wevv_challenge_first_bite_reaction",
            joinedText: "Join",
            glazeLine: "Show the first bite face that says everything.",
            sprinkleTimeText: "Monday · 6:30 PM - 8:00 PM",
            crumbPlaceText: "Pink Glaze House, San Francisco",
            hostGuestKey: "novaBubbleGlaze",
            hostLine: "Tasting host · 4.8 rating",
            missionText: "Take one bite, write the first three flavor words, and keep the reaction natural.",
            crowdText: "19 people",
            sugarCost: 240
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "donutOfTheDay",
            title: "Donut of the Day",
            caption: "Post today's donut and tell everyone why you chose it.",
            cardAsset: "wevv_challenge_donut_of_day",
            joinedText: "Join",
            glazeLine: "Choose the one donut that deserves today's spotlight.",
            sprinkleTimeText: "Wednesday · 1:00 PM - 4:00 PM",
            crumbPlaceText: "Cloud Sprinkle, San Francisco",
            hostGuestKey: "lunaLaughGlaze",
            hostLine: "Daily host · 4.9 rating",
            missionText: "Pick your donut of the day, add one reason, and invite other tasters to compare choices.",
            crowdText: "36 people",
            sugarCost: 220
        ),
        WevVSprinkleChallenge(
            sprinkleKey: "sprinkleStyle",
            title: "Sprinkle Style",
            caption: "Decorate a donut with your favorite colorful sprinkles.",
            cardAsset: "wevv_challenge_sprinkle_style",
            joinedText: "Join",
            glazeLine: "Turn toppings into a tiny donut fashion show.",
            sprinkleTimeText: "Thursday · 7:00 PM - 9:00 PM",
            crumbPlaceText: "Mellow Dough, Oakland",
            hostGuestKey: "blairBlueGlaze",
            hostLine: "Style host · 4.6 rating",
            missionText: "Design a sprinkle look, describe the color mix, and vote for the sweetest style idea.",
            crowdText: "24 people",
            sugarCost: 250
        )
    ]

    private var sprinkleMoments: [WevVSprinkleFeedItem] = [
        WevVSprinkleFeedItem(
            sprinkleKey: "oneBiteVibes",
            author: WevVGlazeAuthor(glazeKey: "louiseSantos", name: "Louise Santos", avatarAsset: "louiseCream"),
            heroAsset: "wevv_moment_one_bite_vibes",
            displayText: "One bite, a whole day of good vibes",
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "Berry note"
        ),
        WevVSprinkleFeedItem(
            sprinkleKey: "freshDonutScent",
            author: WevVGlazeAuthor(glazeKey: "masonGlazeSmile", name: "Mason Cole", avatarAsset: "masonSugar"),
            heroAsset: "wevv_moment_fresh_donut_scent",
            displayText: "Fresh donuts smell amazing.",
            isSprinkled: true,
            isSaved: false,
            frostingTimeText: "Fresh batch"
        ),
        WevVSprinkleFeedItem(
            sprinkleKey: "chocolateDonutDay",
            author: WevVGlazeAuthor(glazeKey: "avaCocoaRing", name: "Ava Brown", avatarAsset: "avaCocoa"),
            heroAsset: "wevv_moment_chocolate_donut_day",
            displayText: "Chocolate donuts made my day.",
            isSprinkled: false,
            isSaved: true,
            frostingTimeText: "Cocoa mood"
        ),
        WevVSprinkleFeedItem(
            sprinkleKey: "weekendDonutStart",
            author: WevVGlazeAuthor(glazeKey: "bellaSprinkle", name: "Bella Hart", avatarAsset: "bellaCream"),
            heroAsset: "wevv_moment_weekend_donut_start",
            displayText: "Starting the weekend with donuts.",
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "Weekend pick"
        ),
        WevVSprinkleFeedItem(
            sprinkleKey: "pinkSweetnessToday",
            author: WevVGlazeAuthor(glazeKey: "miaPinkSugar", name: "Mia Reed", avatarAsset: "miaPink"),
            heroAsset: "wevv_moment_pink_sweetness",
            displayText: "A little pink sweetness today.",
            isSprinkled: true,
            isSaved: true,
            frostingTimeText: "Pink sprinkle"
        ),
        WevVSprinkleFeedItem(
            sprinkleKey: "creamFilledUnite",
            author: WevVGlazeAuthor(glazeKey: "noraCreamRing", name: "Nora Lane", avatarAsset: "noraCream"),
            heroAsset: "wevv_moment_cream_filled_unite",
            displayText: "Cream-filled donut lovers, unite.",
            isSprinkled: false,
            isSaved: false,
            frostingTimeText: "Cream circle"
        )
    ]

    private let frostingUser = WevVFrostingUser(
        frostingKey: "wevvSugarTaster",
        email: "wevv@gmail.com",
        nickname: "Glaze Taster",
        avatarAsset: "wevv_profile_avatar_piano_donut",
        creamStat: WevVCreamStat(followingCount: 12, followerCount: 28, shopShelfCount: 7, vaultCount: 360),
        sugarPosts: [
            WevVSugarPost(sugarKey: "strawberryRingNote", title: "Strawberry glaze morning", note: "Soft frosting, warm crumb, bright sugar."),
            WevVSugarPost(sugarKey: "cocoaSprinkleTrail", title: "Cocoa sprinkle tasting", note: "Saved a small shop worth coming back to.")
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        preloadSugarMoments()
        preloadSprinkleQuests()
        buildDonutBackdrop()
        buildGlazeScroll()
        buildTopGlazeBar()
        buildShopAndCheckinBand()
        buildChallengeBand()
        buildFrostingDiaryDiscoverPanel()
        buildFrostingDiaryPanel()
        buildSugarProfilePanel()
        buildDonutContentFoot()
        buildDonutTabBar()
        buildFrostingPostEntryButton()
        switchDonutSection(.glazeHome)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGlazeCarouselTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGlazeCarouselTimer()
    }

    deinit {
        stopGlazeCarouselTimer()
    }

    private func buildDonutBackdrop() {
        view.backgroundColor = UIColor(red: 1, green: 0.78, blue: 0.85, alpha: 1)

        let backdrop = UIImageView(image: UIImage(named: "wevv_donut_sprinkle_backdrop"))
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.contentMode = .scaleAspectFill
        view.addSubview(backdrop)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildGlazeScroll() {
        frostingScroll.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.showsVerticalScrollIndicator = false
        frostingScroll.contentInsetAdjustmentBehavior = .never
        frostingScroll.contentInset.bottom = 110
        frostingScroll.verticalScrollIndicatorInsets.bottom = 110
        view.addSubview(frostingScroll)

        sprinkleContent.translatesAutoresizingMaskIntoConstraints = false
        frostingScroll.addSubview(sprinkleContent)

        NSLayoutConstraint.activate([
            frostingScroll.topAnchor.constraint(equalTo: view.topAnchor),
            frostingScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frostingScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frostingScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sprinkleContent.topAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.topAnchor),
            sprinkleContent.leadingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.leadingAnchor),
            sprinkleContent.trailingAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.trailingAnchor),
            sprinkleContent.bottomAnchor.constraint(equalTo: frostingScroll.contentLayoutGuide.bottomAnchor),
            sprinkleContent.widthAnchor.constraint(equalTo: frostingScroll.frameLayoutGuide.widthAnchor)
        ])
    }

    private func buildTopGlazeBar() {
        let logoButton = makeImageButton(asset: "wevv_home_wevv_glaze_logo", action: #selector(openGlazeNoticeList))
        let noticeButton = makeImageButton(asset: "wevv_top_sprinkle_inbox_entry", action: #selector(openGlazeNoticeList))

        sprinkleContent.addSubview(logoButton)
        sprinkleContent.addSubview(noticeButton)
        glazeHomePanels.append(contentsOf: [logoButton, noticeButton])

        NSLayoutConstraint.activate([
            logoButton.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 26),
            logoButton.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            logoButton.widthAnchor.constraint(equalToConstant: 101),
            logoButton.heightAnchor.constraint(equalToConstant: 30),
            noticeButton.centerYAnchor.constraint(equalTo: logoButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            noticeButton.widthAnchor.constraint(equalToConstant: 44),
            noticeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildShopAndCheckinBand() {
        shopCarousel.translatesAutoresizingMaskIntoConstraints = false
        shopCarousel.isPagingEnabled = true
        shopCarousel.showsHorizontalScrollIndicator = false
        shopCarousel.delegate = self
        sprinkleContent.addSubview(shopCarousel)

        shopPages.translatesAutoresizingMaskIntoConstraints = false
        shopPages.axis = .horizontal
        shopPages.spacing = 0
        shopCarousel.addSubview(shopPages)

        for glazeShop in glazeShops {
            let card = makeShopCard(glazeShop)
            shopPages.addArrangedSubview(card)
            card.widthAnchor.constraint(equalTo: shopCarousel.frameLayoutGuide.widthAnchor).isActive = true
        }

        shopDots.translatesAutoresizingMaskIntoConstraints = false
        shopDots.numberOfPages = glazeShops.count
        shopDots.currentPage = 0
        shopDots.currentPageIndicatorTintColor = .white
        shopDots.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.55)
        sprinkleContent.addSubview(shopDots)

        let checkinButton = makeCheckinButton(dailyCheckin)
        sprinkleContent.addSubview(checkinButton)
        glazeHomePanels.append(contentsOf: [shopCarousel, shopDots, checkinButton])

        let shopWidth = min(UIScreen.main.bounds.width * 0.55, 206)
//        let checkinWidth = min(UIScreen.main.bounds.width * 0.34, 124)

        NSLayoutConstraint.activate([
            shopCarousel.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 96),
            shopCarousel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            shopCarousel.widthAnchor.constraint(equalToConstant: shopWidth),
            shopCarousel.heightAnchor.constraint(equalTo: shopCarousel.widthAnchor, multiplier: 265.0 / 206.0),
            shopPages.topAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.topAnchor),
            shopPages.leadingAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.leadingAnchor),
            shopPages.trailingAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.trailingAnchor),
            shopPages.bottomAnchor.constraint(equalTo: shopCarousel.contentLayoutGuide.bottomAnchor),
            shopPages.heightAnchor.constraint(equalTo: shopCarousel.frameLayoutGuide.heightAnchor),
            shopDots.centerXAnchor.constraint(equalTo: shopCarousel.centerXAnchor),
            shopDots.bottomAnchor.constraint(equalTo: shopCarousel.bottomAnchor, constant: -12),
            checkinButton.topAnchor.constraint(equalTo: shopCarousel.topAnchor),
            checkinButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            checkinButton.leadingAnchor.constraint(equalTo: shopCarousel.trailingAnchor, constant: 15),
            checkinButton.heightAnchor.constraint(equalTo: shopCarousel.heightAnchor)
        ])
    }

    private func buildChallengeBand() {
        let titleImage = UIImageView(image: UIImage(named: "wevv_challenge_recommend_title"))
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.contentMode = .scaleAspectFit
        sprinkleContent.addSubview(titleImage)

        let postButton = UIButton(type: .system)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        postButton.backgroundColor = .black
        postButton.layer.cornerRadius = 14
        postButton.addTarget(self, action: #selector(openSprinkleQuestComposer), for: .touchUpInside)
        sprinkleContent.addSubview(postButton)

        challengeStrip.translatesAutoresizingMaskIntoConstraints = false
        challengeStrip.showsHorizontalScrollIndicator = false
        sprinkleContent.addSubview(challengeStrip)
        glazeHomePanels.append(contentsOf: [titleImage, postButton, challengeStrip])

        challengeRow.translatesAutoresizingMaskIntoConstraints = false
        challengeRow.axis = .horizontal
        challengeRow.spacing = 10
        challengeStrip.addSubview(challengeRow)

        rebuildSprinkleQuestRow()

        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: shopCarousel.bottomAnchor, constant: 24),
            titleImage.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 15),
            titleImage.widthAnchor.constraint(equalToConstant: 212),
            titleImage.heightAnchor.constraint(equalToConstant: 24),
            postButton.centerYAnchor.constraint(equalTo: titleImage.centerYAnchor),
            postButton.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -15),
            postButton.widthAnchor.constraint(equalToConstant: 62),
            postButton.heightAnchor.constraint(equalToConstant: 28),
            challengeStrip.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 28),
            challengeStrip.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            challengeStrip.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            challengeStrip.heightAnchor.constraint(equalToConstant: 250),
            challengeRow.topAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.topAnchor),
            challengeRow.leadingAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.leadingAnchor, constant: 14),
            challengeRow.trailingAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.trailingAnchor, constant: -14),
            challengeRow.bottomAnchor.constraint(equalTo: challengeStrip.contentLayoutGuide.bottomAnchor),
            challengeRow.heightAnchor.constraint(equalTo: challengeStrip.frameLayoutGuide.heightAnchor)
        ])
    }

    private func buildFrostingDiaryDiscoverPanel() {
        discoverPanel.translatesAutoresizingMaskIntoConstraints = false
        discoverPanel.isHidden = true
        sprinkleContent.addSubview(discoverPanel)

        let exploreButton = makeImageButton(asset: "wevv_discover_explore_logo", action: #selector(openGlazeNoticeList))
        let noticeButton = makeImageButton(asset: "wevv_discover_notice_entry", action: #selector(openGlazeNoticeList))
        let featuredTitle = UIImageView(image: UIImage(named: "wevv_discover_featured_title"))
        featuredTitle.translatesAutoresizingMaskIntoConstraints = false
        featuredTitle.contentMode = .scaleAspectFit

        momentStack.translatesAutoresizingMaskIntoConstraints = false
        momentStack.axis = .vertical
        momentStack.spacing = 10

        rebuildSprinkleMomentStack()

        discoverPanel.addSubview(exploreButton)
        discoverPanel.addSubview(noticeButton)
        discoverPanel.addSubview(featuredTitle)
        discoverPanel.addSubview(momentStack)
        frostingDiaryPanels.append(discoverPanel)

        NSLayoutConstraint.activate([
            discoverPanel.topAnchor.constraint(equalTo: sprinkleContent.topAnchor),
            discoverPanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            discoverPanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            exploreButton.topAnchor.constraint(equalTo: discoverPanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            exploreButton.leadingAnchor.constraint(equalTo: discoverPanel.leadingAnchor, constant: 15),
            exploreButton.widthAnchor.constraint(equalToConstant: 125),
            exploreButton.heightAnchor.constraint(equalToConstant: 30),
            noticeButton.centerYAnchor.constraint(equalTo: exploreButton.centerYAnchor),
            noticeButton.trailingAnchor.constraint(equalTo: discoverPanel.trailingAnchor, constant: -15),
            noticeButton.widthAnchor.constraint(equalToConstant: 44),
            noticeButton.heightAnchor.constraint(equalToConstant: 44),
            featuredTitle.topAnchor.constraint(equalTo: exploreButton.bottomAnchor, constant: 26),
            featuredTitle.leadingAnchor.constraint(equalTo: discoverPanel.leadingAnchor, constant: 15),
            featuredTitle.widthAnchor.constraint(equalToConstant: 105),
            featuredTitle.heightAnchor.constraint(equalToConstant: 24),
            momentStack.topAnchor.constraint(equalTo: featuredTitle.bottomAnchor, constant: 16),
            momentStack.leadingAnchor.constraint(equalTo: discoverPanel.leadingAnchor, constant: 15),
            momentStack.trailingAnchor.constraint(equalTo: discoverPanel.trailingAnchor, constant: -15),
            momentStack.bottomAnchor.constraint(equalTo: discoverPanel.bottomAnchor)
        ])
    }

    private func buildDonutTabBar() {
        donutTabBack.translatesAutoresizingMaskIntoConstraints = false
        donutTabBack.backgroundColor = UIColor(red: 0.13, green: 0.0, blue: 0.27, alpha: 1)
        donutTabBack.layer.cornerRadius = 18
        donutTabBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(donutTabBack)

        let row = UIStackView(arrangedSubviews: [
            makeTabButton(section: .glazeHome, asset: "wevv_tab_home_glaze_active"),
            makeTabButton(section: .frostingDiary, asset: "wevv_tab_discover_sprinkle_idle"),
            makeTabButton(section: .sugarProfile, asset: "wevv_tab_profile_donut_idle")
        ])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .equalSpacing
        donutTabBack.addSubview(row)

        NSLayoutConstraint.activate([
            donutTabBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            donutTabBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            donutTabBack.heightAnchor.constraint(equalToConstant: 88),
            donutTabBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            row.topAnchor.constraint(equalTo: donutTabBack.topAnchor, constant: 20),
            row.leadingAnchor.constraint(equalTo: donutTabBack.leadingAnchor, constant: 50),
            row.trailingAnchor.constraint(equalTo: donutTabBack.trailingAnchor, constant: -50),
            row.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func buildFrostingPostEntryButton() {
        frostingPostEntryButton.translatesAutoresizingMaskIntoConstraints = false
        frostingPostEntryButton.setImage(UIImage(named: "wevv_discover_post_frosting_entry"), for: .normal)
        frostingPostEntryButton.imageView?.contentMode = .scaleAspectFit
        frostingPostEntryButton.addTarget(self, action: #selector(openSugarMomentComposer), for: .touchUpInside)
        frostingPostEntryButton.isHidden = true
        view.addSubview(frostingPostEntryButton)

        NSLayoutConstraint.activate([
            frostingPostEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            frostingPostEntryButton.bottomAnchor.constraint(equalTo: donutTabBack.topAnchor, constant: -54),
            frostingPostEntryButton.widthAnchor.constraint(equalToConstant: 62),
            frostingPostEntryButton.heightAnchor.constraint(equalToConstant: 62)
        ])
    }

    private func buildDonutContentFoot() {
        donutContentFoot.translatesAutoresizingMaskIntoConstraints = false
        donutContentFoot.isHidden = true
        sprinkleContent.addSubview(donutContentFoot)

        NSLayoutConstraint.activate([
            donutContentFoot.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            donutContentFoot.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            donutContentFoot.heightAnchor.constraint(equalToConstant: 1),
            donutContentFoot.bottomAnchor.constraint(equalTo: sprinkleContent.bottomAnchor)
        ])

        donutContentFootTopConstraints[.glazeHome] = donutContentFoot.topAnchor.constraint(equalTo: challengeStrip.bottomAnchor, constant: 28)
        donutContentFootTopConstraints[.frostingDiary] = donutContentFoot.topAnchor.constraint(equalTo: discoverPanel.bottomAnchor, constant: 32)
        donutContentFootTopConstraints[.sugarProfile] = donutContentFoot.topAnchor.constraint(equalTo: sugarProfilePanel.bottomAnchor, constant: 32)
        donutContentFootTopConstraints[.glazeHome]?.isActive = true
    }

    private func buildFrostingDiaryPanel() {
        frostingDiaryPanel.translatesAutoresizingMaskIntoConstraints = false
        frostingDiaryPanel.isHidden = true
        sprinkleContent.addSubview(frostingDiaryPanel)

        let title = makePanelTitle("Donut Diary")
        let firstCard = makeDiaryCard(title: "Strawberry glaze tasting", caption: "A soft ring with pink frosting notes.")
        let secondCard = makeDiaryCard(title: "Cream shelf pick", caption: "Fresh bakery bite saved for later.")

        frostingDiaryPanel.addSubview(title)
        frostingDiaryPanel.addSubview(firstCard)
        frostingDiaryPanel.addSubview(secondCard)

        NSLayoutConstraint.activate([
            frostingDiaryPanel.topAnchor.constraint(equalTo: sprinkleContent.safeAreaLayoutGuide.topAnchor, constant: 112),
            frostingDiaryPanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor, constant: 18),
            frostingDiaryPanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor, constant: -18),
            frostingDiaryPanel.heightAnchor.constraint(equalToConstant: 410),
            title.topAnchor.constraint(equalTo: frostingDiaryPanel.topAnchor),
            title.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor),
            firstCard.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 22),
            firstCard.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            firstCard.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor),
            secondCard.topAnchor.constraint(equalTo: firstCard.bottomAnchor, constant: 14),
            secondCard.leadingAnchor.constraint(equalTo: frostingDiaryPanel.leadingAnchor),
            secondCard.trailingAnchor.constraint(equalTo: frostingDiaryPanel.trailingAnchor)
        ])
    }

    private func buildSugarProfilePanel() {
        sugarProfilePanel.translatesAutoresizingMaskIntoConstraints = false
        sugarProfilePanel.isHidden = true
        sprinkleContent.addSubview(sugarProfilePanel)

        let meButton = makeImageButton(asset: "wevv_profile_me_logo", action: #selector(openProfileSugarEntry))
        let gearButton = makeImageButton(asset: "wevv_profile_sugar_gear", action: #selector(openSugarSettings))
        let statButton = makeProfileImageAction(asset: "wevv_profile_stat_glaze_band")
        let avatarButton = makeProfileImageAction(asset: "wevv_profile_avatar_piano_donut")
        let shelfButton = makeProfileImageAction(asset: "wevv_profile_shop_shelf_card")
        shelfButton.removeTarget(nil, action: nil, for: .touchUpInside)
        shelfButton.addTarget(self, action: #selector(openSugarShelf), for: .touchUpInside)
        let vaultButton = makeProfileImageAction(asset: "wevv_profile_donut_vault_card")
        vaultButton.removeTarget(nil, action: nil, for: .touchUpInside)
        vaultButton.addTarget(self, action: #selector(openDonutVault), for: .touchUpInside)
        let postTitle = UIImageView(image: UIImage(named: "wevv_profile_sugar_post_title"))
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        postTitle.contentMode = .scaleAspectFit

        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        profileNameLabel.textAlignment = .center
        profileNameLabel.textColor = UIColor(red: 0.2, green: 0.07, blue: 0.26, alpha: 1)

        configureProfileCountLabel(profileFollowingCountLabel)
        configureProfileCountLabel(profileFollowerCountLabel)
        configureProfileCardCountLabel(profileShelfCountLabel)
        configureProfileCardCountLabel(profileVaultCountLabel)

        let followingTitle = makeProfileTinyText("Following")
        let followerTitle = makeProfileTinyText("Follower")
        let shelfTitle = makeProfileCardTitle("Save Shop")
        let vaultTitle = makeProfileCardTitle("Wallet")
        let followingEntry = makeProfileRelationEntry(action: #selector(openGlazeFollowingList))
        let followerEntry = makeProfileRelationEntry(action: #selector(openSprinkleFollowerList))

        profilePostStack.translatesAutoresizingMaskIntoConstraints = false
        profilePostStack.axis = .vertical
        profilePostStack.spacing = 10

        profileEmptyStack.translatesAutoresizingMaskIntoConstraints = false
        profileEmptyStack.axis = .vertical
        profileEmptyStack.alignment = .center
        profileEmptyStack.spacing = 6
        let emptyImage = UIImageView(image: UIImage(named: "wevv_profile_empty_sugar_note"))
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.contentMode = .scaleAspectFit
//        let emptyText = UILabel()
//        emptyText.translatesAutoresizingMaskIntoConstraints = false
//        emptyText.text = "No Data"
//        emptyText.font = .systemFont(ofSize: 15, weight: .medium)
//        emptyText.textColor = UIColor(red: 0.63, green: 0.48, blue: 0.55, alpha: 1)
        profileEmptyStack.addArrangedSubview(emptyImage)
//        profileEmptyStack.addArrangedSubview(emptyText)

        sugarProfilePanel.addSubview(meButton)
        sugarProfilePanel.addSubview(gearButton)
        sugarProfilePanel.addSubview(statButton)
        sugarProfilePanel.addSubview(avatarButton)
        sugarProfilePanel.addSubview(profileNameLabel)
        sugarProfilePanel.addSubview(profileFollowingCountLabel)
        sugarProfilePanel.addSubview(profileFollowerCountLabel)
        sugarProfilePanel.addSubview(followingTitle)
        sugarProfilePanel.addSubview(followerTitle)
        sugarProfilePanel.addSubview(followingEntry)
        sugarProfilePanel.addSubview(followerEntry)
        sugarProfilePanel.addSubview(shelfButton)
        sugarProfilePanel.addSubview(vaultButton)
        sugarProfilePanel.addSubview(profileShelfCountLabel)
        sugarProfilePanel.addSubview(profileVaultCountLabel)
        sugarProfilePanel.addSubview(shelfTitle)
        sugarProfilePanel.addSubview(vaultTitle)
        sugarProfilePanel.addSubview(postTitle)
        sugarProfilePanel.addSubview(profilePostStack)
        sugarProfilePanel.addSubview(profileEmptyStack)

        NSLayoutConstraint.activate([
            sugarProfilePanel.topAnchor.constraint(equalTo: sprinkleContent.topAnchor),
            sugarProfilePanel.leadingAnchor.constraint(equalTo: sprinkleContent.leadingAnchor),
            sugarProfilePanel.trailingAnchor.constraint(equalTo: sprinkleContent.trailingAnchor),
            meButton.topAnchor.constraint(equalTo: sugarProfilePanel.safeAreaLayoutGuide.topAnchor, constant: 26),
            meButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 25),
            meButton.widthAnchor.constraint(equalToConstant: 75),
            meButton.heightAnchor.constraint(equalToConstant: 30),
            gearButton.centerYAnchor.constraint(equalTo: meButton.centerYAnchor),
            gearButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -15),
            gearButton.widthAnchor.constraint(equalToConstant: 44),
            gearButton.heightAnchor.constraint(equalToConstant: 44),
            statButton.topAnchor.constraint(equalTo: meButton.bottomAnchor, constant: 56),
            statButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 20),
            statButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -20),
            statButton.heightAnchor.constraint(equalTo: statButton.widthAnchor, multiplier: 60.0 / 335.0),
            avatarButton.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: statButton.centerYAnchor, constant: -24),
            avatarButton.widthAnchor.constraint(equalToConstant: 108),
            avatarButton.heightAnchor.constraint(equalToConstant: 130),
            profileNameLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 4),
            profileNameLabel.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            profileNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: sugarProfilePanel.leadingAnchor, constant: 36),
            profileNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: sugarProfilePanel.trailingAnchor, constant: -36),
            profileFollowingCountLabel.topAnchor.constraint(equalTo: statButton.topAnchor, constant: 12),
            profileFollowingCountLabel.centerXAnchor.constraint(equalTo: statButton.leadingAnchor, constant: 70),
            followingTitle.topAnchor.constraint(equalTo: profileFollowingCountLabel.bottomAnchor, constant: 2),
            followingTitle.centerXAnchor.constraint(equalTo: profileFollowingCountLabel.centerXAnchor),
            followingEntry.leadingAnchor.constraint(equalTo: statButton.leadingAnchor),
            followingEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followingEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followingEntry.widthAnchor.constraint(equalToConstant: 132),
            profileFollowerCountLabel.topAnchor.constraint(equalTo: profileFollowingCountLabel.topAnchor),
            profileFollowerCountLabel.centerXAnchor.constraint(equalTo: statButton.trailingAnchor, constant: -64),
            followerTitle.topAnchor.constraint(equalTo: profileFollowerCountLabel.bottomAnchor, constant: 2),
            followerTitle.centerXAnchor.constraint(equalTo: profileFollowerCountLabel.centerXAnchor),
            followerEntry.trailingAnchor.constraint(equalTo: statButton.trailingAnchor),
            followerEntry.topAnchor.constraint(equalTo: statButton.topAnchor),
            followerEntry.bottomAnchor.constraint(equalTo: statButton.bottomAnchor),
            followerEntry.widthAnchor.constraint(equalToConstant: 132),
            shelfButton.topAnchor.constraint(equalTo: statButton.bottomAnchor, constant: 28),
            shelfButton.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 15),
            shelfButton.widthAnchor.constraint(equalTo: sugarProfilePanel.widthAnchor, multiplier: 0.434),
            shelfButton.heightAnchor.constraint(equalTo: shelfButton.widthAnchor, multiplier: 178.0 / 163.0),
            vaultButton.topAnchor.constraint(equalTo: shelfButton.topAnchor),
            vaultButton.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -15),
            vaultButton.widthAnchor.constraint(equalTo: shelfButton.widthAnchor),
            vaultButton.heightAnchor.constraint(equalTo: shelfButton.heightAnchor),
            profileShelfCountLabel.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            profileShelfCountLabel.centerYAnchor.constraint(equalTo: shelfButton.centerYAnchor, constant: 18),
            shelfTitle.topAnchor.constraint(equalTo: profileShelfCountLabel.bottomAnchor, constant: 8),
            shelfTitle.centerXAnchor.constraint(equalTo: shelfButton.centerXAnchor),
            shelfTitle.leadingAnchor.constraint(greaterThanOrEqualTo: shelfButton.leadingAnchor, constant: 10),
            shelfTitle.trailingAnchor.constraint(lessThanOrEqualTo: shelfButton.trailingAnchor, constant: -10),
            profileVaultCountLabel.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            profileVaultCountLabel.centerYAnchor.constraint(equalTo: vaultButton.centerYAnchor, constant: 18),
            vaultTitle.topAnchor.constraint(equalTo: profileVaultCountLabel.bottomAnchor, constant: 8),
            vaultTitle.centerXAnchor.constraint(equalTo: vaultButton.centerXAnchor),
            vaultTitle.leadingAnchor.constraint(greaterThanOrEqualTo: vaultButton.leadingAnchor, constant: 10),
            vaultTitle.trailingAnchor.constraint(lessThanOrEqualTo: vaultButton.trailingAnchor, constant: -10),
            postTitle.topAnchor.constraint(equalTo: shelfButton.bottomAnchor, constant: 20),
            postTitle.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 15),
            postTitle.widthAnchor.constraint(equalToConstant: 97),
            postTitle.heightAnchor.constraint(equalToConstant: 24),
            profilePostStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 18),
            profilePostStack.leadingAnchor.constraint(equalTo: sugarProfilePanel.leadingAnchor, constant: 22),
            profilePostStack.trailingAnchor.constraint(equalTo: sugarProfilePanel.trailingAnchor, constant: -22),
            profileEmptyStack.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 34),
            profileEmptyStack.centerXAnchor.constraint(equalTo: sugarProfilePanel.centerXAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: 140),
            emptyImage.heightAnchor.constraint(equalToConstant: 153),
            profileEmptyStack.bottomAnchor.constraint(equalTo: sugarProfilePanel.bottomAnchor),
            profilePostStack.bottomAnchor.constraint(lessThanOrEqualTo: sugarProfilePanel.bottomAnchor)
        ])
        refreshSugarProfilePanel()
    }

    private func makeShopCard(_ glazeShop: WevVGlazeShop) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = glazeShop.glazeKey
        card.addTarget(self, action: #selector(openShopCarouselEntry(_:)), for: .touchUpInside)

        let image = UIImageView(image: UIImage(named: glazeShop.coverAsset))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        card.addSubview(image)

        let titleBand = UIView()
        titleBand.translatesAutoresizingMaskIntoConstraints = false
        titleBand.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.78, alpha: 0.72)
        titleBand.layer.cornerRadius = 12
        titleBand.clipsToBounds = true
        card.addSubview(titleBand)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "\(glazeShop.shopTitle)\nrecommendations"
        titleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.72
        titleBand.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: card.topAnchor),
            image.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            titleBand.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            titleBand.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            titleBand.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -27),
            titleBand.heightAnchor.constraint(equalToConstant: 46),
            titleLabel.topAnchor.constraint(equalTo: titleBand.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: titleBand.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleBand.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: titleBand.bottomAnchor, constant: -5)
        ])
        return card
    }

    private func makeCheckinButton(_ dailyFrosting: WevVDailyCheckin) -> UIControl {
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = dailyFrosting.frostingKey
        button.addTarget(self, action: #selector(openDailyGlazeStamp), for: .touchUpInside)

        let image = UIImageView(image: UIImage(named: dailyFrosting.cardAsset))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        button.addSubview(image)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        return button
    }

    private func makeChallengeCard(_ sprinkleChallenge: WevVSprinkleChallenge) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = sprinkleChallenge.sprinkleKey
        card.addTarget(self, action: #selector(openChallengeDetail(_:)), for: .touchUpInside)

        let heroImage = UIImageView(image: UIImage(named: sprinkleChallenge.cardAsset))
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        heroImage.layer.cornerRadius = 56
        heroImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let frameImage = UIImageView(image: UIImage(named: "wevv_challenge_donutjoy_card"))
        frameImage.translatesAutoresizingMaskIntoConstraints = false
        frameImage.contentMode = .scaleToFill
        frameImage.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = sprinkleChallenge.title
        titleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7

        let joinLabel = UILabel()
        joinLabel.translatesAutoresizingMaskIntoConstraints = false
        joinLabel.text = sprinkleChallenge.joinedText
        joinLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        joinLabel.textColor = .white
        joinLabel.textAlignment = .right

        let arrowImage = UIImageView(image: UIImage(named: "wevv_challenge_join_arrow"))
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.contentMode = .scaleAspectFit

        let tasterAvatars = makeChallengeTasterStack(for: sprinkleChallenge)

        card.addSubview(heroImage)
        card.addSubview(frameImage)
        card.addSubview(titleLabel)
        card.addSubview(tasterAvatars)
        card.addSubview(joinLabel)
        card.addSubview(arrowImage)

        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 148),
            heroImage.topAnchor.constraint(equalTo: card.topAnchor, constant: 36),
            heroImage.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            heroImage.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            heroImage.heightAnchor.constraint(equalToConstant: 112),
            frameImage.topAnchor.constraint(equalTo: card.topAnchor),
            frameImage.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            frameImage.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            frameImage.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 11),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -11),
            tasterAvatars.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            tasterAvatars.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            tasterAvatars.widthAnchor.constraint(equalToConstant: 58),
            tasterAvatars.heightAnchor.constraint(equalToConstant: 24),
            joinLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -7),
            joinLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14),
            joinLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tasterAvatars.trailingAnchor, constant: 4),
            arrowImage.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            arrowImage.centerYAnchor.constraint(equalTo: joinLabel.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 15),
            arrowImage.heightAnchor.constraint(equalToConstant: 15)
        ])
        return card
    }

    private func makeChallengeTasterStack(for sprinkleChallenge: WevVSprinkleChallenge) -> UIView {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        let keys = makeChallengeTasterKeys(for: sprinkleChallenge)
        for (index, key) in keys.enumerated() {
            let avatar = makeChallengeTasterAvatar(key: key)
            stack.addSubview(avatar)
            NSLayoutConstraint.activate([
                avatar.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: CGFloat(index * 17)),
                avatar.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
                avatar.widthAnchor.constraint(equalToConstant: 24),
                avatar.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        return stack
    }

    private func makeChallengeTasterKeys(for sprinkleChallenge: WevVSprinkleChallenge) -> [String] {
        let keys = [
            sprinkleChallenge.hostGuestKey,
            "lunaLaughGlaze",
            "novaBubbleGlaze",
            "arloSkyGlaze",
            "rheaHoneyGlaze"
        ]
        var seenKeys = Set<String>()
        return keys.filter { glazeKey in
            guard !seenKeys.contains(glazeKey) else { return false }
            seenKeys.insert(glazeKey)
            return true
        }.prefix(3).map { $0 }
    }

    private func makeChallengeTasterAvatar(key: String) -> UIImageView {
        let profile = guestStore.profile(for: key)
        let avatar = UIImageView(image: UIImage(named: profile.avatarAsset) ?? makeFrostingAvatarImage(seed: key))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 12
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        return avatar
    }

    private func makeSprinkleMomentCard(_ sprinkleMoment: WevVSprinkleFeedItem) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.accessibilityIdentifier = sprinkleMoment.sprinkleKey
        card.clipsToBounds = true
        card.layer.cornerRadius = 15
        card.addTarget(self, action: #selector(openSprinkleMomentDetail(_:)), for: .touchUpInside)

        let heroImage = UIImageView(image: UIImage(named: sprinkleMoment.heroAsset) ?? makeFrostingHeroImage(seed: sprinkleMoment.heroAsset))
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true

        let textBand = WevVSugarGradientBand()
        textBand.translatesAutoresizingMaskIntoConstraints = false

        let captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.text = sprinkleMoment.displayText
        captionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        captionLabel.textColor = .white
        captionLabel.numberOfLines = 2
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.minimumScaleFactor = 0.82

        let avatar = UIImageView(image: makeSprinkleAuthorAvatar(for: sprinkleMoment))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 15
        avatar.layer.borderWidth = 1.5
        avatar.layer.borderColor = UIColor.white.cgColor

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = sprinkleMoment.author.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.76

        let safetyButton = UIButton(type: .system)
        safetyButton.translatesAutoresizingMaskIntoConstraints = false
        safetyButton.accessibilityIdentifier = sprinkleMoment.sprinkleKey
        safetyButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        safetyButton.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.58, alpha: 1)
        safetyButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        safetyButton.layer.cornerRadius = 17
        safetyButton.addTarget(self, action: #selector(openSprinkleMomentSafety(_:)), for: .touchUpInside)

        card.addSubview(heroImage)
        card.addSubview(textBand)
        textBand.addSubview(captionLabel)
        card.addSubview(avatar)
        card.addSubview(nameLabel)
        card.addSubview(safetyButton)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 182.0 / 345.0),
            heroImage.topAnchor.constraint(equalTo: card.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            heroImage.bottomAnchor.constraint(equalTo: textBand.topAnchor),
            textBand.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            textBand.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            textBand.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            textBand.heightAnchor.constraint(equalToConstant: 50),
            captionLabel.topAnchor.constraint(equalTo: textBand.topAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: textBand.leadingAnchor, constant: 22),
            captionLabel.trailingAnchor.constraint(equalTo: textBand.trailingAnchor, constant: -18),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: textBand.bottomAnchor, constant: -7),
            avatar.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: heroImage.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 30),
            avatar.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: safetyButton.leadingAnchor, constant: -10),
            safetyButton.topAnchor.constraint(equalTo: heroImage.topAnchor, constant: 15),
            safetyButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: -15),
            safetyButton.widthAnchor.constraint(equalToConstant: 34),
            safetyButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        return card
    }

    private func makeSprinkleAuthorAvatar(for sprinkleMoment: WevVSprinkleFeedItem) -> UIImage {
        if let profile = guestStore.allProfiles.first(where: { $0.glazeKey == sprinkleMoment.author.glazeKey }),
           let image = UIImage(named: profile.avatarAsset) {
            return image
        }
        if let image = UIImage(named: sprinkleMoment.author.avatarAsset) {
            return image
        }
        return makeFrostingAvatarImage(seed: sprinkleMoment.author.avatarAsset)
    }

    private func makeProfileImageAction(asset: String) -> UIControl {
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openProfileSugarEntry), for: .touchUpInside)

        let image = UIImageView(image: UIImage(named: asset))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        button.addSubview(image)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        return button
    }

    private func makeImageButton(asset: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: asset), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeTabButton(section: WevVDonutMainSection, asset: String) -> UIControl {
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = section.rawValue
        button.addTarget(self, action: #selector(selectDonutSection(_:)), for: .touchUpInside)

        let icon = makeTabIcon(asset)
        button.addSubview(icon)
        donutTabIcons[section] = icon

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 54),
            button.heightAnchor.constraint(equalToConstant: 54),
            icon.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        return button
    }

    private func makeTabIcon(_ asset: String) -> UIImageView {
        let icon = UIImageView(image: UIImage(named: asset))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 44),
            icon.heightAnchor.constraint(equalToConstant: 44)
        ])
        return icon
    }

    private func configureProfileCountLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
    }

    private func configureProfileCardCountLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
    }

    private func makeProfileCardTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 23, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.72
        return label
    }

    private func makeProfileTinyText(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }

    private func makeProfileRelationEntry(action: Selector) -> UIControl {
        let entry = UIControl()
        entry.translatesAutoresizingMaskIntoConstraints = false
        entry.backgroundColor = .clear
        entry.addTarget(self, action: action, for: .touchUpInside)
        return entry
    }

    private func refreshSugarProfilePanel() {
        let isReady = glazeSession.isTasterReady
        let baseStat = frostingUser.creamStat
        let creamStat = isReady
            ? WevVCreamStat(
                followingCount: baseStat.followingCount,
                followerCount: baseStat.followerCount,
                shopShelfCount: baseStat.shopShelfCount + glazeSession.glazeShelfCount,
                vaultCount: baseStat.vaultCount
            )
            : WevVCreamStat(followingCount: 0, followerCount: 0, shopShelfCount: 0, vaultCount: 0)
        profileNameLabel.text = isReady ? frostingUser.nickname : ""
        profileFollowingCountLabel.text = "\(creamStat.followingCount)"
        profileFollowerCountLabel.text = "\(creamStat.followerCount)"
        profileShelfCountLabel.text = "\(creamStat.shopShelfCount)"
        profileVaultCountLabel.text = isReady ? "\(glazeSession.glazeGoldCount)" : "\(creamStat.vaultCount)"

        profilePostStack.arrangedSubviews.forEach { sugarView in
            profilePostStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }

        let sugarPosts = currentSugarPosts()
        profileEmptyStack.isHidden = isReady && !sugarPosts.isEmpty
        profilePostStack.isHidden = !isReady || sugarPosts.isEmpty
        guard isReady else { return }

        for sugarPost in sugarPosts {
            profilePostStack.addArrangedSubview(makeSugarPostCard(sugarPost))
        }
    }

    private func currentSugarPosts() -> [WevVSugarPost] {
        let freshPosts = glazeSession.sugarMomentPackets.map {
            WevVSugarPost(sugarKey: $0.sugarKey, title: $0.timeText, note: $0.text)
        }
        return freshPosts + frostingUser.sugarPosts
    }

    private func makeSugarPostCard(_ sugarPost: WevVSugarPost) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        card.layer.cornerRadius = 16
        card.addTarget(self, action: #selector(openProfileSugarEntry), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = sugarPost.title
        title.font = .systemFont(ofSize: 15, weight: .heavy)
        title.textColor = UIColor(red: 0.17, green: 0.08, blue: 0.22, alpha: 1)

        let note = UILabel()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.text = sugarPost.note
        note.font = .systemFont(ofSize: 13, weight: .medium)
        note.textColor = UIColor(red: 0.54, green: 0.42, blue: 0.51, alpha: 1)
        note.numberOfLines = 2

        card.addSubview(title)
        card.addSubview(note)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 64),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            note.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            note.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            note.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ])
        return card
    }

    private func makeFrostingHeroImage(seed: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 690, height: 264))
        return renderer.image { context in
            let canvas = context.cgContext
            let baseColors: (UIColor, UIColor, UIColor)
            switch seed {
            case "brickSprinkle":
                baseColors = (
                    UIColor(red: 0.91, green: 0.55, blue: 0.36, alpha: 1),
                    UIColor(red: 0.99, green: 0.75, blue: 0.55, alpha: 1),
                    UIColor(red: 1.0, green: 0.45, blue: 0.66, alpha: 1)
                )
            case "softKitchen":
                baseColors = (
                    UIColor(red: 0.78, green: 0.72, blue: 0.68, alpha: 1),
                    UIColor(red: 0.96, green: 0.84, blue: 0.78, alpha: 1),
                    UIColor(red: 0.59, green: 0.42, blue: 0.74, alpha: 1)
                )
            default:
                baseColors = (
                    UIColor(red: 0.43, green: 0.77, blue: 0.95, alpha: 1),
                    UIColor(red: 0.98, green: 0.78, blue: 0.86, alpha: 1),
                    UIColor(red: 0.95, green: 0.36, blue: 0.63, alpha: 1)
                )
            }

            baseColors.0.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 690, height: 264)).fill()
            baseColors.1.withAlphaComponent(0.7).setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 96, width: 690, height: 168)).fill()

            UIColor.white.withAlphaComponent(0.22).setFill()
            UIBezierPath(ovalIn: CGRect(x: 440, y: -38, width: 210, height: 210)).fill()
            UIBezierPath(ovalIn: CGRect(x: -42, y: 142, width: 190, height: 150)).fill()

            baseColors.2.setFill()
            UIBezierPath(ovalIn: CGRect(x: 322, y: 54, width: 150, height: 150)).fill()
            UIColor(red: 1, green: 0.83, blue: 0.52, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 342, y: 74, width: 110, height: 110)).fill()
            UIColor.white.withAlphaComponent(0.92).setFill()
            UIBezierPath(ovalIn: CGRect(x: 376, y: 108, width: 42, height: 42)).fill()

            let sprinkleColors = [
                UIColor.white,
                UIColor(red: 1, green: 0.89, blue: 0.13, alpha: 1),
                UIColor(red: 0.97, green: 0.2, blue: 0.61, alpha: 1),
                UIColor(red: 0.29, green: 0.7, blue: 0.96, alpha: 1)
            ]
            for index in 0..<38 {
                sprinkleColors[index % sprinkleColors.count].setFill()
                let x = CGFloat((index * 47) % 640) + 18
                let y = CGFloat((index * 31) % 210) + 18
                let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 22, height: 6), cornerRadius: 3)
                canvas.saveGState()
                canvas.translateBy(x: x + 11, y: y + 3)
                canvas.rotate(by: CGFloat(index % 7) * 0.34)
                canvas.translateBy(x: -(x + 11), y: -(y + 3))
                path.fill()
                canvas.restoreGState()
            }
        }
    }

    private func makeFrostingAvatarImage(seed: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 90, height: 90))
        return renderer.image { _ in
            let base: UIColor
            let accent: UIColor
            switch seed {
            case "louiseCream":
                base = UIColor(red: 0.83, green: 0.54, blue: 0.22, alpha: 1)
                accent = UIColor(red: 0.25, green: 0.69, blue: 0.9, alpha: 1)
            case "raymondSugar":
                base = UIColor(red: 0.58, green: 0.68, blue: 0.83, alpha: 1)
                accent = UIColor(red: 0.96, green: 0.91, blue: 0.84, alpha: 1)
            default:
                base = UIColor(red: 0.84, green: 0.58, blue: 0.67, alpha: 1)
                accent = UIColor(red: 0.96, green: 0.78, blue: 0.86, alpha: 1)
            }

            base.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 90, height: 90)).fill()
            accent.setFill()
            UIBezierPath(ovalIn: CGRect(x: 18, y: 12, width: 54, height: 54)).fill()
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 25, y: 54, width: 40, height: 24)).fill()
            UIColor(red: 0.18, green: 0.11, blue: 0.2, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 28, y: 31, width: 8, height: 8)).fill()
            UIBezierPath(ovalIn: CGRect(x: 54, y: 31, width: 8, height: 8)).fill()
        }
    }

    private func makePanelTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .black
        return label
    }

    private func makeDiaryCard(title: String, caption: String) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        card.layer.cornerRadius = 22

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .black

        let captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        captionLabel.textColor = UIColor(red: 0.42, green: 0.35, blue: 0.47, alpha: 1)
        captionLabel.numberOfLines = 0

        card.addSubview(titleLabel)
        card.addSubview(captionLabel)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 112),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        return card
    }

    @objc private func openGlazeNoticeList() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVNoticeEmptyController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func selectDonutSection(_ glazeButton: UIControl) {
        guard let section = WevVDonutMainSection(rawValue: glazeButton.tag) else { return }
        switchDonutSection(section)
    }

    @objc private func advanceGlazeCarousel() {
        guard activeDonutSection == .glazeHome, glazeShops.count > 1, shopCarousel.bounds.width > 0 else { return }
        let currentPage = Int(round(shopCarousel.contentOffset.x / shopCarousel.bounds.width))
        let nextPage = (currentPage + 1) % glazeShops.count
        let nextOffset = CGPoint(x: CGFloat(nextPage) * shopCarousel.bounds.width, y: 0)
        shopCarousel.setContentOffset(nextOffset, animated: true)
        shopDots.currentPage = nextPage
    }

    @objc private func openProtectedGlazeAction() {
        presentProtectedGate()
    }

    @objc private func openSprinkleQuestComposer() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSprinkleQuestComposerController()
        controller.onSprinkleQuestReady = { [weak self] packet in
            guard let self else { return }
            let quest = self.makeQuest(from: packet)
            self.sprinkleChallenges.removeAll { self.isSameSprinkleQuest($0, quest) }
            self.sprinkleChallenges.insert(quest, at: 0)
            self.rebuildSprinkleQuestRow()
            self.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSugarMomentComposer() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarMomentComposerController()
        controller.onSugarMomentReady = { [weak self] packet in
            guard let self else { return }
            let freshMoment = WevVSprinkleFeedItem(
                sprinkleKey: packet.sugarKey,
                author: WevVGlazeAuthor(glazeKey: self.frostingUser.frostingKey, name: self.frostingUser.nickname, avatarAsset: self.frostingUser.avatarAsset),
                heroAsset: packet.heroAsset,
                displayText: packet.text,
                isSprinkled: false,
                isSaved: false,
                frostingTimeText: packet.timeText
            )
            self.sprinkleMoments.insert(freshMoment, at: 0)
            self.rebuildSprinkleMomentStack()
            self.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func rebuildSprinkleMomentStack() {
        momentStack.arrangedSubviews.forEach { sugarView in
            momentStack.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        for sprinkleMoment in sprinkleMoments {
            guard !isSprinkleAuthorShielded(sprinkleMoment) else { continue }
            momentStack.addArrangedSubview(makeSprinkleMomentCard(sprinkleMoment))
        }
    }

    private func rebuildSprinkleQuestRow() {
        challengeRow.arrangedSubviews.forEach { sugarView in
            challengeRow.removeArrangedSubview(sugarView)
            sugarView.removeFromSuperview()
        }
        let uniqueChallenges = uniqueSprinkleQuests(sprinkleChallenges)
        sprinkleChallenges = uniqueChallenges
        for sprinkleChallenge in uniqueChallenges {
            challengeRow.addArrangedSubview(makeChallengeCard(sprinkleChallenge))
        }
    }

    private func preloadSugarMoments() {
        let packets = glazeSession.sugarMomentPackets
        guard !packets.isEmpty else { return }
        let packetKeys = Set(sprinkleMoments.map(\.sprinkleKey))
        let freshMoments = packets
            .filter { !packetKeys.contains($0.sugarKey) }
            .map {
                WevVSprinkleFeedItem(
                    sprinkleKey: $0.sugarKey,
                    author: WevVGlazeAuthor(glazeKey: frostingUser.frostingKey, name: frostingUser.nickname, avatarAsset: frostingUser.avatarAsset),
                    heroAsset: $0.heroAsset,
                    displayText: $0.text,
                    isSprinkled: false,
                    isSaved: false,
                    frostingTimeText: $0.timeText
                )
            }
        sprinkleMoments.insert(contentsOf: freshMoments, at: 0)
    }

    private func preloadSprinkleQuests() {
        let packets = glazeSession.sprinkleQuestPackets
        guard !packets.isEmpty else { return }
        let questKeys = Set(sprinkleChallenges.map(\.sprinkleKey))
        let freshQuests = packets
            .filter { !questKeys.contains($0.sugarKey) }
            .map { makeQuest(from: $0) }
        sprinkleChallenges.insert(contentsOf: freshQuests, at: 0)
    }

    private func uniqueSprinkleQuests(_ quests: [WevVSprinkleChallenge]) -> [WevVSprinkleChallenge] {
        var seenKeys = Set<String>()
        return quests.filter { quest in
            let key = questIdentityKey(quest)
            guard !seenKeys.contains(key) else { return false }
            seenKeys.insert(key)
            return true
        }
    }

    private func isSameSprinkleQuest(_ left: WevVSprinkleChallenge, _ right: WevVSprinkleChallenge) -> Bool {
        questIdentityKey(left) == questIdentityKey(right)
    }

    private func questIdentityKey(_ quest: WevVSprinkleChallenge) -> String {
        [
            quest.title,
            quest.sprinkleTimeText,
            quest.crumbPlaceText,
            "\(quest.sugarCost)"
        ]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .joined(separator: "|")
    }

    private func makeQuest(from packet: WevVSprinkleQuestPacket) -> WevVSprinkleChallenge {
        WevVSprinkleChallenge(
            sprinkleKey: packet.sugarKey,
            title: packet.title,
            caption: packet.text,
            cardAsset: "wevv_challenge_strawberry_week",
            joinedText: "Join",
            glazeLine: packet.text,
            sprinkleTimeText: packet.timeText,
            crumbPlaceText: packet.placeText,
            hostGuestKey: "jamieCole",
            hostLine: "Fresh host · 4.9 rating",
            missionText: packet.text,
            crowdText: "1 person",
            sugarCost: packet.sugarCost
        )
    }

    @objc private func openDailyGlazeStamp() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDailyGlazeStampController()
        controller.onStampChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openProfileSugarEntry() {
        presentProtectedGate()
    }

    @objc private func openSugarShelf() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarShelfController(shopDetails: allGlazeShopDetails())
        controller.onShelfChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openGlazeFollowingList() {
        openSugarRoster(.glazeFollowing)
    }

    @objc private func openSprinkleFollowerList() {
        openSugarRoster(.sprinkleFollower)
    }

    private func openSugarRoster(_ mode: WevVSugarRosterMode) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarRosterController(mode: mode)
        controller.onRosterChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
            self?.rebuildSprinkleMomentStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSugarSettings() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVSugarSettingsController()
        controller.onSugarSettingChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSprinkleMomentDetail(_ sender: UIControl) {
        let sprinkleKey = sender.accessibilityIdentifier ?? sprinkleMoments[0].sprinkleKey
        let sprinkleMoment = sprinkleMoments.first { $0.sprinkleKey == sprinkleKey } ?? sprinkleMoments[0]
        let controller = WevVSprinkleMomentDetailController(sprinkleMoment: sprinkleMoment)
        controller.onSugarMomentShielded = { [weak self] in
            self?.rebuildSprinkleMomentStack()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openSprinkleMomentSafety(_ sender: UIControl) {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let sprinkleKey = sender.accessibilityIdentifier ?? ""
        guard let moment = sprinkleMoments.first(where: { $0.sprinkleKey == sprinkleKey }) else { return }
        presentSprinkleSafetySheet(for: moment)
    }

    private func presentSprinkleSafetySheet(for moment: WevVSprinkleFeedItem) {
        let sheet = WevVGlazeSafetySheet(shopKey: moment.author.glazeKey, choices: sprinkleSafetyChoices())
        sheet.onClose = { [weak self, weak sheet] in
            self?.hideSprinkleSafetySheet(sheet)
        }
        sheet.onConfirm = { [weak self, weak sheet] packet in
            guard let self else { return }
            self.glazeSession.placeGlazeSafetyCrumb(packet)
            self.placeSprinkleShield(for: moment.author.glazeKey)
            self.hideSprinkleSafetySheet(sheet)
            self.rebuildSprinkleMomentStack()
            self.showRootSugarHint("Hidden from your feed")
        }
        view.addSubview(sheet)
        NSLayoutConstraint.activate([
            sheet.topAnchor.constraint(equalTo: view.topAnchor),
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideSprinkleSafetySheet(_ sheet: WevVGlazeSafetySheet?) {
        UIView.animate(withDuration: 0.18, animations: {
            sheet?.alpha = 0
        }, completion: { _ in
            sheet?.removeFromSuperview()
        })
    }

    private func sprinkleSafetyChoices() -> [WevVGlazeSafetyChoice] {
        [
            WevVGlazeSafetyChoice(sugarKey: "fakePhoto", title: "Fake photo", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "scamCommercial", title: "Scam or commercial", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "notInterested", title: "Not interested", needsCreamText: false),
            WevVGlazeSafetyChoice(sugarKey: "otherSugar", title: "Other", needsCreamText: true)
        ]
    }

    private func placeSprinkleShield(for glazeKey: String) {
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == glazeKey }) else { return }
        if !guestStore.profile(for: glazeKey).sugarTie.isSugarShielded {
            _ = guestStore.toggleSugarShield(for: glazeKey)
        }
    }

    private func isSprinkleAuthorShielded(_ moment: WevVSprinkleFeedItem) -> Bool {
        guard guestStore.allProfiles.contains(where: { $0.glazeKey == moment.author.glazeKey }) else { return false }
        return guestStore.profile(for: moment.author.glazeKey).sugarTie.isSugarShielded
    }

    private func showRootSugarHint(_ text: String) {
        let toast = UILabel()
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.text = text
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .semibold)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        toast.layer.cornerRadius = 18
        toast.clipsToBounds = true
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: donutTabBack.topAnchor, constant: -14),
            toast.heightAnchor.constraint(equalToConstant: 36),
            toast.widthAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
        UIView.animate(withDuration: 0.2, delay: 1.15, options: []) {
            toast.alpha = 0
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }

    @objc private func openDonutVault() {
        guard glazeSession.isTasterReady else {
            presentProtectedGate()
            return
        }
        let controller = WevVDonutVaultController()
        controller.onVaultChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    @objc private func openShopCarouselEntry(_ glazedSender: UIControl) {
        let glazeKey = glazedSender.accessibilityIdentifier ?? glazeShops[0].glazeKey
        let glazeShop = glazeShops.first { $0.glazeKey == glazeKey } ?? glazeShops[0]
        let controller = WevVGlazeShopDetailController(detail: makeGlazeShopDetail(glazeShop))
        controller.onShelfChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func makeGlazeShopDetail(_ glazeShop: WevVGlazeShop) -> WevVGlazeShopDetail {
        if glazeShop.glazeKey == "berryRingBakery" {
            return WevVGlazeShopDetail(
                glazeKey: glazeShop.glazeKey,
                title: "Berry Ring Bakery",
                subtitle: "Fresh donuts · berry flavors",
                coverAsset: glazeShop.coverAsset,
                crumbScoreText: "4.8",
                reviewText: "(186 reviews)",
                addressLine: "86 Blossom Avenue, San Francisco",
                tags: [
                    WevVFrostingShopTag(glazeKey: "strawberryTag", title: "Strawberry", tintHex: "ff4aa0"),
                    WevVFrostingShopTag(glazeKey: "handmadeTag", title: "Handmade", tintHex: "f5b431"),
                    WevVFrostingShopTag(glazeKey: "cozySugarTag", title: "Cozy", tintHex: "8b63ff")
                ],
                parlorTitle: "Berry Donut Club",
                parlorLine: "Share fruity flavors, sweet picks, and bakery stories.",
                parlorCrowdText: "24 online",
                reviews: [
                    WevVSprinkleReview(
                        sprinkleKey: "miaBerryGlaze",
                        tasterName: "Mia",
                        tastingRole: "Dessert lover",
                        crumbScoreText: "4.9",
                        biteText: "The strawberry glaze was fresh, smooth, and perfectly sweet.",
                        badgeText: "Berry Favorite"
                    ),
                    WevVSprinkleReview(
                        sprinkleKey: "ethanCozyBakery",
                        tasterName: "Ethan",
                        tastingRole: "Weekend explorer",
                        crumbScoreText: "4.7",
                        biteText: "A cozy little shop with soft donuts and friendly service.",
                        badgeText: "Cozy Spot"
                    )
                ],
                morePicks: [
                    WevVSugarShopPick(
                        sugarKey: "goldenDoughPick",
                        title: "Golden Dough Studio",
                        addressLine: "215 Golden Lane, San Francisco",
                        crumbScoreText: "4.9",
                        coverAsset: "wevv_shop_golden_dough_studio"
                    ),
                    WevVSugarShopPick(
                        sugarKey: "mellowDoughPick",
                        title: "Mellow Dough",
                        addressLine: "212 Pine Ave, Oakland, CA",
                        crumbScoreText: "4.8",
                        coverAsset: "wevv_shop_glaze_carousel_card"
                    )
                ]
            )
        }
        if glazeShop.glazeKey == "goldenDoughStudio" {
            return WevVGlazeShopDetail(
                glazeKey: glazeShop.glazeKey,
                title: "Golden Dough Studio",
                subtitle: "Artisan donuts · small batches",
                coverAsset: glazeShop.coverAsset,
                crumbScoreText: "4.9",
                reviewText: "(312 reviews)",
                addressLine: "215 Golden Lane, San Francisco",
                tags: [
                    WevVFrostingShopTag(glazeKey: "artisanTag", title: "Artisan", tintHex: "b77920"),
                    WevVFrostingShopTag(glazeKey: "freshBatchTag", title: "Fresh", tintHex: "f5b431"),
                    WevVFrostingShopTag(glazeKey: "popularSugarTag", title: "Popular", tintHex: "8b63ff")
                ],
                parlorTitle: "Golden Dough Room",
                parlorLine: "Talk about fresh batches, toppings, and donut pairings.",
                parlorCrowdText: "38 online",
                reviews: [
                    WevVSprinkleReview(
                        sprinkleKey: "oliviaGoldenFrame",
                        tasterName: "Olivia",
                        tastingRole: "Food photographer",
                        crumbScoreText: "5.0",
                        biteText: "Every donut looked beautiful and tasted even better.",
                        badgeText: "Picture Perfect"
                    ),
                    WevVSprinkleReview(
                        sprinkleKey: "noahDoughTexture",
                        tasterName: "Noah",
                        tastingRole: "Donut collector",
                        crumbScoreText: "4.8",
                        biteText: "The dough was light, fluffy, and never too oily.",
                        badgeText: "Best Texture"
                    )
                ],
                morePicks: [
                    WevVSugarShopPick(
                        sugarKey: "pinkGlazePick",
                        title: "Pink Glaze House",
                        addressLine: "128 Berry Street, San Francisco",
                        crumbScoreText: "4.9",
                        coverAsset: "wevv_shop_glaze_carousel_card"
                    ),
                    WevVSugarShopPick(
                        sugarKey: "mellowDoughPick",
                        title: "Mellow Dough",
                        addressLine: "212 Pine Ave, Oakland, CA",
                        crumbScoreText: "4.8",
                        coverAsset: "wevv_shop_glaze_carousel_card"
                    )
                ]
            )
        }
        if glazeShop.glazeKey == "moonlightDonutBar" {
            return WevVGlazeShopDetail(
                glazeKey: glazeShop.glazeKey,
                title: "Moonlight Donut Bar",
                subtitle: "Late-night donuts · creative drinks",
                coverAsset: glazeShop.coverAsset,
                crumbScoreText: "4.7",
                reviewText: "(204 reviews)",
                addressLine: "42 Crescent Street, San Francisco",
                tags: [
                    WevVFrostingShopTag(glazeKey: "lateNightTag", title: "Late Night", tintHex: "8b63ff"),
                    WevVFrostingShopTag(glazeKey: "coffeeTag", title: "Coffee", tintHex: "7b4b2a"),
                    WevVFrostingShopTag(glazeKey: "creativeSugarTag", title: "Creative", tintHex: "ff4aa0")
                ],
                parlorTitle: "Midnight Donut Talk",
                parlorLine: "A late-night room for donut fans and coffee lovers.",
                parlorCrowdText: "31 online",
                reviews: [
                    WevVSprinkleReview(
                        sprinkleKey: "chloeNightCafe",
                        tasterName: "Chloe",
                        tastingRole: "Night cafe fan",
                        crumbScoreText: "4.8",
                        biteText: "The perfect place for a sweet late-night coffee break.",
                        badgeText: "Night Vibes"
                    ),
                    WevVSprinkleReview(
                        sprinkleKey: "liamCoffeeWarmth",
                        tasterName: "Liam",
                        tastingRole: "Coffee enthusiast",
                        crumbScoreText: "4.6",
                        biteText: "Great espresso, warm donuts, and a relaxed atmosphere.",
                        badgeText: "Coffee Match"
                    )
                ],
                morePicks: [
                    WevVSugarShopPick(
                        sugarKey: "berryRingPick",
                        title: "Berry Ring Bakery",
                        addressLine: "86 Blossom Avenue, San Francisco",
                        crumbScoreText: "4.8",
                        coverAsset: "wevv_shop_berry_ring_bakery"
                    ),
                    WevVSugarShopPick(
                        sugarKey: "goldenDoughPick",
                        title: "Golden Dough Studio",
                        addressLine: "215 Golden Lane, San Francisco",
                        crumbScoreText: "4.9",
                        coverAsset: "wevv_shop_golden_dough_studio"
                    )
                ]
            )
        }
        return WevVGlazeShopDetail(
            glazeKey: glazeShop.glazeKey,
            title: glazeShop.glazeKey == "sprinkleShelf" ? "Mellow Dough" : "Pink Glaze House",
            subtitle: glazeShop.flavorLine,
            coverAsset: glazeShop.coverAsset,
            crumbScoreText: "4.9",
            reviewText: "(246 reviews)",
            addressLine: "128 Berry Street, San Franci...",
            tags: [
                WevVFrostingShopTag(glazeKey: "berryTag", title: "Strawberry", tintHex: "ff4aa0"),
                WevVFrostingShopTag(glazeKey: "freshTag", title: "Fresh", tintHex: "f5b431"),
                WevVFrostingShopTag(glazeKey: "lateTag", title: "Late Night", tintHex: "8b63ff")
            ],
            parlorTitle: "Donut Lovers Room",
            parlorLine: "Cafe soft shop fans, flavor talk, and sweet picks",
            parlorCrowdText: "28 online",
            reviews: [
                WevVSprinkleReview(
                    sprinkleKey: "avaBerryBite",
                    tasterName: "Ava",
                    tastingRole: "Cafe explorer",
                    crumbScoreText: "4.8",
                    biteText: "Loved the strawberry ring and the cozy pink...",
                    badgeText: "Cute Vibes"
                ),
                WevVSprinkleReview(
                    sprinkleKey: "jasonClassicCrumb",
                    tasterName: "Jason",
                    tastingRole: "Donut collector",
                    crumbScoreText: "4.6",
                    biteText: "The original glaze is buttery and fluffy. Frien...",
                    badgeText: "Best Classic"
                )
            ],
            morePicks: [
                WevVSugarShopPick(
                    sugarKey: "cloudSprinklePick",
                    title: "Cloud Sprinkle",
                    addressLine: "45 Valencia St, San Francisco, CA",
                    crumbScoreText: "4.6",
                    coverAsset: "wevv_shop_glaze_carousel_card"
                ),
                WevVSugarShopPick(
                    sugarKey: "mellowDoughPick",
                    title: "Mellow Dough",
                    addressLine: "212 Pine Ave, Oakland, CA",
                    crumbScoreText: "4.8",
                    coverAsset: "wevv_shop_glaze_carousel_card"
                )
            ]
        )
    }

    private func allGlazeShopDetails() -> [WevVGlazeShopDetail] {
        glazeShops.map { makeGlazeShopDetail($0) }
    }

    @objc private func openChallengeDetail(_ sprinkleSender: UIControl) {
        let sprinkleKey = sprinkleSender.accessibilityIdentifier ?? ""
        let selectedChallenge = sprinkleChallenges.first { $0.sprinkleKey == sprinkleKey } ?? sprinkleChallenges[0]
        let controller = WevVFrostingChallengeController(challenge: selectedChallenge)
        controller.onChallengeChanged = { [weak self] in
            self?.refreshSugarProfilePanel()
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func presentProtectedGate() {
        guard glazeSession.isTasterReady else {
            let gate = WevVFrostingGateController()
            gate.onGlazeReady = { [weak self] in
                self?.refreshSugarProfilePanel()
                self?.dismiss(animated: true)
            }
            gate.modalPresentationStyle = .pageSheet
            present(gate, animated: true)
            return
        }
    }

    private func switchDonutSection(_ section: WevVDonutMainSection) {
        activeDonutSection = section
        let showHome = section == .glazeHome
        if section == .sugarProfile {
            refreshSugarProfilePanel()
        }
        glazeHomePanels.forEach { $0.isHidden = !showHome }
        frostingDiaryPanels.forEach { $0.isHidden = section != .frostingDiary }
        frostingDiaryPanel.isHidden = true
        frostingPostEntryButton.isHidden = section != .frostingDiary
        sugarProfilePanel.isHidden = section != .sugarProfile
        donutContentFootTopConstraints.values.forEach { $0.isActive = false }
        donutContentFootTopConstraints[section]?.isActive = true
        for (tabSection, icon) in donutTabIcons {
            let tabAssets = donutTabAssetTrail[tabSection]
            let asset = tabSection == section ? tabAssets?.active : tabAssets?.idle
            icon.image = UIImage(named: asset ?? "")
            icon.alpha = tabSection == section ? 1 : 0.5
            icon.transform = tabSection == section ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
        }
    }

    private func startGlazeCarouselTimer() {
        stopGlazeCarouselTimer()
        let timer = Timer(timeInterval: 1.5, target: self, selector: #selector(advanceGlazeCarousel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        glazeCarouselTimer = timer
    }

    private func stopGlazeCarouselTimer() {
        glazeCarouselTimer?.invalidate()
        glazeCarouselTimer = nil
    }
}

extension WevVDonutRootController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === shopCarousel, shopCarousel.bounds.width > 0 else { return }
        let page = Int(round(shopCarousel.contentOffset.x / shopCarousel.bounds.width))
        shopDots.currentPage = max(0, min(glazeShops.count - 1, page))
    }
}
