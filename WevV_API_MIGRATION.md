# WevV 正式环境 SDK2 接入记录

更新：2026-10-28。当前资源已经切换正式项目；下方折叠保留此前测试环境接入证据，不代表当前运行配置。原生一级页面、布局、样式和键盘逻辑保留；按用户最新要求，将有公开 H5 合同的现有二级入口切换到 SDK2。

## 首页 Live 卡片按直播状态显示右上条纹（2026-10-28）

此前 `makeHomeGlazeRoomCard` 对每条数据无条件创建 `WevVGlazzestyOrangeEssence`，控件挂入窗口后自动循环播放，房间数据中没有直播状态也会抖动。现按当前交付 H5 的直播状态合同处理：liveRoomState=2 为正在直播，1 为已结束；直播池返回的 id、人数或在线／关注状态不代替这一状态。

`pearFilling` 增加默认 false 的 `glazeIsLive`，房间 mapper 只有在 liveRoomState 为明确整数 2（兼容字符串“2”及首尾空格）时设为 true；缺失、null、结束、布尔值、非法字符串或非整数均为 false。首页卡片仅在 true 时创建右上角条纹控件及原有 17×17pt 约束，其他记录不创建该控件，也没有隐藏后仍运行的动画。语聊页的条纹控件及公共动画实现、原有卡片内容／样式／点击进入均保留。

本轮文件：`WevSweetgd/WevSweetgd/kettleGlazeSequence.swift`（房间状态字段）、`WevSweetgd/WevSweetgd/WevVGlazeRoomMapper.swift`（解析明确直播状态）、`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift`（首页按状态创建条纹）、`scripts/test_wevv_room_mapper.py`（状态合同回归）及本记录。没有修改网络请求、分页、登录注册、持久化、SafeArea 或键盘布局；没有新增资源。

无签名 Debug Simulator 构建、现有实际 mapper／model／H5 入口／repository 回归通过，新增 14 种直播状态输入及缺失状态、语聊默认状态断言。日志 `/private/tmp/wevv-home-live-signal-build.log`、`wevv-home-live-signal-mapper.log`；修改前源文件备份 `/private/tmp/wevv-home-live-signal-before/`。本轮没有操作用户设备或请求正式接口，未作新的全机型视觉／键盘实测。手动核对可刷新首页：liveRoomState=2 的卡片有右上角动态条纹，1 或缺少状态的卡片没有该控件；卡片仍可按原方式进入 H5。

## 设置页精简与功能分组（2026-10-28）

按用户最新清单保留 14 项，取代上一节历史版本中的单组 20 行方案；显示文案规范为 Level、Privacy Policy、System Message、Terms of Service、App Version。按常用设置功能划为以下 5 组：

- 个人与关系：Edit Profile、Level、Friends。
- 资产：Store、Backpack、Diamond Records。
- 消息与反馈：System Message、Feedback。
- 隐私与应用信息：Privacy Policy、Blacklist、Terms of Service、App Version。
- 账号操作（最后）：Delete Account、Log out。

前四组沿用原白色圆角列表卡片，组间距 16pt，每行字体、颜色、43pt 高度、分隔线和原有箭头规则均保留；整体粉色背景、顶部导航、安全区和滚动容器保留。最后的账号组使用透明竖向 StackView，距列表 32pt，两个按钮仍为原来的白底红字删除和粉底白字退出，48pt 高、24pt 圆角、16pt 间距及原有弹窗与动作。内容高度由约束和 StackView 决定，底部仍与滚动内容闭合。

H5 的 9 项入口继续共用原 `WevVGlazeH5Entry` 和 `WevVGlazeH5Navigation`，其中 Friends 对应 relations/1，商店／背包保留 tab=all。Edit Profile 和 Blacklist 改用同组 UIAction 后，删除重复的两个 selector 包装；移除 Clear Cache 栏目时一并删除其专用存储键、计数 Label、格式方法、点击方法及缓存专用的 `WevVGlazeSessionStore` 引用，旧键没有被清空或迁移。Privacy Policy／Terms of Service 仍打开现有原生条款页，App Version 仍读取 Bundle 版本，注销／退出业务方法及 H5 凭据、释放流程均未改。移出设置页的搜索、排行榜、创建房间、Likes You 和 CP Settings 只删除本页入口，其他模块及路由支持保留。

本轮文件：`WevSweetgd/WevSweetgd/DimSugarpistachioCreamCoating.swift`（分组、栏目精简及清理失用私有代码，较本轮修改前净减少 35 行）和 `WevV_API_MIGRATION.md`（当前分组及验证记录）。没有新增资源、修改签名版本、登录注册或持久化结构。修改前备份 `/private/tmp/wevv-settings-groups-before/`；最终设置页原文 SHA256 `b131f2dbb64c9a382d3392f56d909186cbfd476749b3bc9e3451e9730c787770`。

无签名 Debug Simulator 构建及 31 项现有导航／退出回归通过，日志 `/private/tmp/wevv-settings-groups-build.log`、`wevv-settings-groups-navigation.log`。实际 UIKit 离线验证使用相同哈希的设置页、真实路由 enum、原生隐私／条款控制器和原确认弹窗样式器，只替换网络／会话／H5 导航边界。320×568、393×852、430×932 三种视口共 651 项断言通过：分组为 3／3／2／4 行加最后 2 个按钮，14 项顺序正确；27 次 H5 栏目动作及 27 次关闭回调、6 次原生隐私／条款页打开返回、6 次真实删除／退出弹窗打开并取消均通过；每组内容高 740pt，底部按钮可见、可命中。核对原有行高／字体／颜色／圆角、组间距、约束及滚动边界；顶部／底部截图已查看，运行日志没有布局歧义、约束冲突或 overflow。没有执行删除、退出确认或任何账号变更，没有验证真实 H5 数据、登录或内购；原生设置页无输入框，键盘代码未修改。证据 `/private/tmp/wevv-settings-groups-uikit/results/`、`runtime.log` 和 `verification.json`；专用测试模拟器已关闭、删除并确认不存在，未操作用户现有模拟器或真机。

## 补齐设置页 H5 入口（2026-10-28）

按用户列出的 20 个独立入口核对实际原生按钮及动作，而非仅检查 enum 是否定义路由。已有 6 项：消息由首页／语聊／Explore 顶部按钮进入；编辑资料由个人头像和设置原栏目进入；充值由个人余额及现有钱包入口进入；黑名单由设置原栏目进入；粉丝和关注由个人中心统计栏进入。这些入口保留，不重复添加。

原来没有原生可点击入口的 14 项已加入设置第一组，位于 Edit Profile 后、Clear Cache 前，沿用现有白底栏目、字体、分隔线、箭头和点击样式：

- Live Search → `/live/search`
- Live Ranking → `/live/ranking`
- Create Room → `/party/create`
- Party Search → `/party/search`
- Party Ranking → `/party/ranking`
- System Messages → `/messages/system`
- Likes You → `/messages/likes`
- Store → `/profile/store?tab=all`
- Backpack → `/profile/backpack?tab=all`
- Diamond Records → `/profile/diamonds/records`
- Level → `/profile/level`
- Feedback → `/profile/feedback`
- CP Settings → `/profile/cp-settings`
- Friends → `/profile/relations/1`

其余已有入口仍分别使用 `/messages`、`/profile/edit`、`/profile/diamonds`、`/profile/blocklist`、`/profile/relations/2`（粉丝）、`/profile/relations/3`（关注）。地址均由现有 `WevVGlazeH5Entry` 统一构建，直接 URL 和 idle 激活共用同一参数；没有另建 WebView、重复网络层或 14 个单独的 selector 方法。新增栏目只保存 enum 并使用弱捕获的 UIAction，通过 `WevVGlazeH5Navigation` 继续执行登录拦截、当次 Open／context、进入与关闭释放流程；关闭后沿用现有资料刷新并通知设置页上级。CP 保留原有服务端功能开关，未绕过原生或 H5 的能力检查。

第一组从原 6 行变为 20 行，移除原写死的 258pt 总高度，交由现有竖向 StackView 和每行约束撑开；ScrollView 的内容链继续连接到底部 Delete account／Log out。没有新增图片资源、修改其他页面或签名版本，没有改登录注册及用户数据持久化。

本轮文件：`WevSweetgd/WevSweetgd/DimSugarpistachioCreamCoating.swift`（补入口与自适应组高度）及 `WevV_API_MIGRATION.md`（入口核对、范围及验证记录）。无签名 Debug Simulator 构建通过；31 项现有真实导航／退出源方法检查通过，含未登录拦截、重复 modal、账号／环境隔离和单次关闭回调。路由验证使用项目当前加密包真实解包内容，而非 Downloads 中的旧 dist；实际 SDK 接受全部 27 项原生入口（包含本次全部栏目），拒绝 13 项非法 SDK 入口，原生另拒绝 74 项非法参数／入口 URL，商店／背包和 relations 参数检查通过。构建与路由／导航日志为 `/private/tmp/wevv-settings-h5-build.log`、`wevv-settings-h5-entries.log`、`wevv-settings-h5-navigation.log`。

独立 iOS 26.5 Simulator 运行与产品 SHA256 相同的设置页原文及真实路由 enum，仅将会话／导航／提示依赖替换为无网络边界。320×568、393×852、430×932 三组窗口下共 549 项断言通过：每组 20 行、1036pt 内容高度，逐组以 UIControl.sendActions 触发 14 个新栏目及原编辑／黑名单共 16 次路由动作，合计 48 次动作、48 次关闭回调，目标路径／query 逐项匹配；底部 Delete Account／Log out 可滚动到、可命中，视图无歧义约束。顶部／底部截图已检查，运行日志没有 unsatisfiable／constraint conflict／overflow。此为程序化 UIKit 点击和离线边界验证，不代表正式后台数据、H5 内业务、支付或搜索输入键盘验收；原生设置页没有输入框。原文哈希 `d9befbf0f73d93909cac56902a5837888c3373254ad9fd86b62f864795c44eaa`，证据 `/private/tmp/wevv-settings-h5-uikit/results/` 和 `runtime.log`。没有安装到用户的现有模拟器或真机；专用测试模拟器已关闭、删除并核验不存在。

## 确认无用代码与资源清理（2026-10-28）

此前几轮优先修复接入和生命周期问题，没有完成系统性的未使用内容清理。本轮结合当前源码、动态图片名称解码、selector／Storyboard／配置引用、持久化写入和打包脚本检查，仅移除能确认没有调用或加载入口的内容；不据此宣称整个项目已无冗余。

清理 33 个未调用方法、1 个未用便利构造入口和 3 个只写不读的存储字段，共减少 479 行 Swift。移除 8 组无引用 imageset（22 张 PNG 及各自 Contents.json）和旧版 `vanillaBeanIcing.data`，源资源合计减少 10,440,670 字节。旧包此前仍因 Xcode 同步资源目录被复制进 App，当前运行及打包流程不再读取它的内容；SDK2 加密所依赖的原密钥派生常量和旧资源名保留保护仍保留。

本轮代码文件及用途（路径相对项目根目录）：

- `WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift`：删除 18 个无调用的旧 UI 构建、预取和动作方法，减少 271 行。
- `WevSweetgd/WevSweetgd/kettleGlazeSequence.swift`：删除 5 个未用映射辅助方法及 1 个未读取字段，减少 42 行。
- `WevSweetgd/WevSweetgd/DoughRingTasterProfile.swift`：删除 4 个未用旧资料编解码及键生成方法，减少 56 行；保留实际 JSON 凭据、资料持久化及旧键清理。
- `WevSweetgd/WevSweetgd/DimSugarpistachioCreamCoating.swift`：删除未调用的旧确认按钮构建方法，减少 11 行；保留当前确认框。
- `WevSweetgd/WevSweetgd/LmnTasterCardController.swift`：删除 5 个无入口的旧菜单辅助方法，减少 92 行；保留实际菜单、举报及拉黑回退。
- `WevSweetgd/WevSweetgd/UKGlazeActortroller.swift`：删除未用便利构造入口及请求对象内未读取的 fingerprint 字段，减少 5 行；保留实际请求去重字典、入口观察和关闭释放状态。
- `WevSweetgd/WevSweetgd/WevVGlazeBundleConfiguration.swift`：删除未读取的 appConfiguration 存储字段及赋值，减少 2 行；完整配置校验和 contentVersion 保留。
- `scripts/test_wevv_sdk2_host.py`：对应移除测试夹具中的 fingerprint 构造参数，原有断言保留。
- `scripts/wevv_room_bundle.py`：将旧包说明改为已退役的保留资源名，继续禁止 SDK2 输出复用该名称；加密派生和打包逻辑未改。
- `scripts/test_wevv_room_bundle.py`：将旧资源名保护测试重命名为 reserved，保留断言。
- `WevV_API_MIGRATION.md`：补齐本次清理范围、文件清单、体积和验证证据。

本轮删除的资源路径（imageset 整组删除）：

- `WevSweetgd/WevSweetgd/vanillaBeanIcing.data`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_room_stage_backdrop.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/donutArchiveCountLabel.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_home_activity_feature.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_home_activity_compact.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_discover_backdrop.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_challenge_recommend_title.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/wevv_discover_featured_title.imageset/`
- `WevSweetgd/WevSweetgd/Assets.xcassets/donutFrameAsset.imageset/`

保留实际动态图片引用、用户已修改的设置和火箭图片、AppIcon／启动图、完整 SDK2 资源及 Network 配置小包。未裁剪 SDK 内部资源、未修改 H5 源内容、正式配置或现有页面。工程外测试脚本不参与 App 打包；本轮也未清理用户的 zip 备份或其他未关联文件。没有改签名、版本、登录注册、持久化结构、SafeArea、约束或键盘逻辑，未操作用户设备或请求正式接口；未恢复此前已取消的全局文案清理。

使用全新 DerivedData 构建，避免旧复制资源残留。未压缩 Debug Simulator App 的文件大小总和从 97,132,880 降为 87,195,024 字节，减少 9,937,856 字节（约 9.94 MB）；Assets.car 从 34,122,664 降为 29,840,200 字节，旧包不再存在于构建产物。此为模拟器 Debug 产物的本地对照，不代表 App Store 下载或 IPA 大小。SDK2 完整包、配置小包、manifest 和受保护图片的哈希均与本轮清理前一致。

验证通过：无签名 Debug Simulator 全新构建；88 项原生集成场景、6 项骨架和 11 项接线检查；30 项会话 Runtime 回归；101 项配置检查；15 项打包工具测试；12 组实际资源／缓存／Bridge 回归；25 组 H5 生命周期回归。现有回归覆盖完整 1174 个 H5 文件还原、版本目录复用、损坏恢复、关闭等待释放及重复进入守卫。独立只读复核按原函数区段哈希重建删除结果，确认其余源码与清理前一致，无残留调用或 selector 依赖。本轮未作新的全机型视觉、键盘、真实账号或 IM／RTC 实测。

复核步骤：从新的 DerivedData 执行 Debug Simulator 构建；运行 `scripts/verify_wevv_native_integration.py`、`verify_wevv_session_runtime.py`、`verify_wevv_bundle_configuration.py`、`test_wevv_sdk2_host.py`、`verify_wevv_h5_lifecycle.py` 及 `python3 -m unittest discover -s scripts -p test_wevv_room_bundle.py`；检查产物无旧包、SDK2 哈希不变，运行 `git diff --check`。原文件、逐函数／逐资源清单和哈希、体积结果保存在 `/private/tmp/wevv-unused-cleanup-before/`（`removed-methods.json`、`asset-audit.json`、`verification.json`）；构建及各项回归日志为 `/private/tmp/wevv-unused-*.log`。下方历史记录中“保留旧包”描述属于本轮清理前状态。

## 加载中点击 H5 关闭按钮误报进入失败（2026-10-28）

实际 SDK 的加载页 X 会发起 requestSdkClose：先调用 host.setNavigation(reason:sdk-close)，随后中止启动／context 等待并释放资源，最后调用 host.close。尚未完成的 openEntry 因正常中止返回 SDK_ENTRY_STARTUP_FAILED／ok:false。原生激活 catch 仅检查 Task 取消与 generation，此时尚未收到 host.close、glazeExiting 仍为 false，因此误弹 Room unavailable / This page could not be prepared；已有可见 H5 加载内容时按钮为 Cancel／Retry。

现在关闭开始统一取消原生入口激活观察任务、停止进入计时并清除排队错误；activation 前后及进入错误展示／补发均检查关闭状态。取消的是原生观察，不取消共享 Open、SDK close、Bridge ACK，也不把取消当作资源已释放，仍按协议完成关闭。即使 sdk-close-failed 后解除关闭标志，旧 activation Task 的迟到失败仍因任务已取消而被拒绝。实际准备失败和释放失败保留原有恢复提示；sdk-close-failed、原生关闭失败后选择 Cancel 时恢复必要监测，新进入重新按 generation 准备。

本轮修改宿主、针对性回归及此记录，不修改 H5 包、正式配置、登录／会话存储或页面布局，正常等待仍没有原生自定义 Loading／关闭按钮。

验证：普通项目 Debug Simulator 无签名构建通过，日志 `/private/tmp/wevv-h5-cancel-entry-build.log`。25 组真实源方法生命周期回归、历史销毁逻辑反例、31 项导航、11 组 context 和 12 组 SDK2 资源／Bridge 回归通过。新增覆盖关闭清队列、sdk-close-failed 后迟到失败仍被拒绝、真实准备失败保留、未 released:true 不退出，以及释放失败 Cancel 后恢复监测。

专属模拟器使用真实加密包与 SDK、fake context 和远程网络栅栏，点击 H5 自己的可见 X，而非调用原生 QA close。旧版复现顺序：约 601ms 收到 sdk-close，611ms 收到 openEntry ok:false，614ms 误弹准备失败，736ms 才收到 host.close。最终源码 SHA256 `1012a36643d88ac68e3d3acf0061a8740bc4011d7c7c6ac526c9b6b5af496be3`；5 秒慢 Open 下点 X、1 秒 Open 近完成时点 X 均无进入错误（各 6 项通过），700ms 真失败且不点 X 仍显示错误（3 项通过），合计 15/15。未请求正式后台或发送消息，未操作用户原有设备；不将此验证视作真实媒体／房间业务验收。

对照原始记录位于 `/private/tmp/wevv-h5-pipeline-qa-zh4fug79/h5-loading-close-baseline/`、`h5-loading-close-fixed/`，后者 `comparison.json` 包含真实 DOM 点击、SDK 响应、原生取消状态和退出顺序，并核对最终源码哈希一致。

## 连续进退 H5 后紫色空白（2026-10-28）

隔离 iPhone 17 模拟器使用实际 SDK2 包、真实宿主及 UIKit fullScreen present/dismiss 复现：第二轮领取 idle 后约 6ms 已发送 openEntry，但 WebView 尚未挂窗；约 10ms 的中间 viewDidDisappear 带 isBeingDismissed=true，原代码立即 tearDown，随后约 516ms 同一控制器正式出现时 WebView 已为 nil。多轮重复留下纯紫背景。此前仅子控制器挂载的回归没有覆盖这个实际 modal 转场，不能用其通过结果排除此问题。

活动 WebView 现在仅在 SDK 释放确认及原生退出动画完成后统一销毁；删除依据 viewDidDisappear 的提前销毁，保留 standby 丢弃、重试重建及进程终止的显式清理。预加载激活移至已挂窗且有效布局之后，didAppear 恢复可见状态并保底激活，继续保持每个 WebView 只激活一次；Open 仍可并行准备。

真实 modal 回归还发现第二条留空路径：宿主上方有 UIAlert 时，self.dismiss 只关闭该 Alert，completion 却清掉仍在屏幕上的 H5。现改为从实际 presenting controller 关闭整个宿主层级，包含其上方弹窗，退出 completion 后再销毁。错误展示另以 didAppear 就绪状态排队，避免在进场转场中提前弹 Alert 被 UIKit 拒绝；该状态不在可见宿主原地重试／重建时重置。

同时修正静默失败通路：全高 .app-ui-provider／空 .main-scene 不能代表首绘；私有观察器检查实际可见文字、已解码图片／图标、骨架叶节点，并覆盖 body 上的 H5 Loading，持续只上报可见状态，不上传页面内容或凭据。持续空白 15 秒后显示现有失败与 Retry／Close；后台、不可见及 SDK 关闭期间暂停空白检查。有原生弹窗／转场暂不能显示错误时先排队，恢复可显示后补发。关闭中 WebContent 死亡保留退出意图，旧 generation 的晚到媒体授权只回 deny。

正常等待阶段继续没有原生自定义 Loading 或关闭按钮。用户 H5 包、正式配置、接口／登录注册、持久化及页面布局均不变。

验证：最终普通项目无签名 Debug Simulator 构建通过，日志 `/private/tmp/wevv-h5-repeat-fix-final-build.log`。新增 `scripts/verify_wevv_h5_lifecycle.py` 执行 17 组真实源方法回归；临时注入历史 viewDidDisappear 方法会在重挂载断言处准确失败。导航脚本修正 UIKit dismiss 层级边界，31 项通过，包含宿主及 Alert 均先离开层级、再清理／通知；原有 11 组 context 与 12 组 SDK2 资源／Bridge 回归通过，真实还原 1174 文件且验证缓存不被退出清理。

独立模拟器使用最终真实宿主、实际加密 H5 包、fake context 及先验通过的远程网络栅栏，完成 15 轮 fullScreen modal 和 5 轮快速进退，检查内容可见、SDK close、退出完成后单次 teardown、VC／WK 释放及补新 idle。实际 HTML 显示后移除 UI，持续空白 15 秒触发错误；有 Alert 遮挡时先保留错误、遮挡移除后补发，Retry 先释放旧实例再恢复新页面。此测试检验宿主／DOM／Bridge 及生命周期，离线业务错误反馈不代表正式房间数据或 IM／RTC 成功。本轮不修改布局，未作全机型键盘或真实媒体验收；未操作用户原有模拟器或真机。

最终运行记录 204 项：203 项通过，包含上述 20 轮进退、7 项真实观察器判据、空白 Close、关闭等待时 WebContent 终止委托回调和 standby 终止清理。另 1 项外部工具触发的真实前后台切换在编排窗口内超时，不算通过；不能据此宣称真实前后台恢复已验收。受控源方法的前台／后台和不可见守卫已通过。最终产品 UK SHA256 `02c01a5b124535cfcfbb8b423d05a25235cc76cd36e37ddbbec3bfab5b7cb25c`。

两条修复前复现、最终报告与截图保存在 `/private/tmp/wevv-h5-pipeline-qa-zh4fug79/live-loop-baseline/` 和 `live-loop-fixed/`；最终 `live-loop-fixed/evidence-final/QA-live-fixed-report.json`、`source-match.json` 和 `lifecycle-assertions.json` 可复核断言、源码一致性及清理顺序。普通项目构建不包含一次性 QA 驱动或网络栅栏。

## 移除 H5 前的原生加载占位（2026-10-28）

按用户最新要求，普通进入和领取预加载实例时均不创建原生 Loading、转圈、提示文字或 X 关闭按钮，直接显示 H5 自带的加载／骨架界面。删除 `UKGlazeActortroller.swift` 的原生占位视图和 UI 属性，保留加载超时计时、首绘观测、错误／超时后的重试与关闭处理；错误弹窗按钮使用显示时的首绘状态快照，避免首绘到来后按钮行为改变。

空 H5 预加载、并行 Open、版本资源缓存、context 去重及 SDK 释放流程未修改，用户提供的 H5 包和正式配置不变。下节原生 Loading 首帧测量是移除前的历史验证，不代表当前界面；本轮修改限于宿主与本记录，登录、持久化、SafeArea／键盘布局未改。

验证：无签名 Debug iOS Simulator 构建通过（`/private/tmp/wevv-h5-remove-native-loading-build.log`），11 组实际 context 协调回归和 `git diff --check` 通过。源码及独立复核确认正常加载 UI 的视图、控件、文案与 accessibility ID 已删除，资源 codec 未变。本轮未安装或操作用户设备，未做新的全机型视觉或键盘实测。

## H5 进入、首帧与空页预加载（2026-10-28）

此前资源虽已快速复用，原生仍在 `warmTastingParlor` 等待完整 Open／会话准备，再创建 WKWebView。H5 随后才开始解析 4.5 MB HTML／内联模块、读取 Profile、locale、router 并挂载 Vue；关闭后完整销毁，再进重复这些工作。旧流程在 WebView 创建前没有加载反馈，因此资源优化不等于整页等待优化。

第一轮优化曾先同步展示与 H5 深紫背景一致的原生加载反馈和关闭按钮，此占位现已按上节移除。资源准备与本入口 Open 并行，资源就绪立即创建／加载 WebView，不再把 HTML 初始化串在 Open 后。H5 的 `host.getContext` 等待同一入口任务；成功任务在当前 WebView generation 内复用，失败可重试，必要续期／Token 或账号变化才重新准备。按 generation、epoch、环境、账号和当前访问 Token 校验交付；自身 Open 保存凭据期间抑制重复通知，迟到任务的入口和清理不能操作新 generation。受限入口仍校验 fullFeaturesEnabled，冷态本地配置不再拿尚为空的 Runtime appID 误判。初始 H5 配置仍受版本、manifest 及 Profile 校验约束。

空页预加载使用交付文档第 7 节和当前实际 HTML 已支持的 `index.html#/sdk/idle`，没有改动用户提供的 HTML／加密资源包。主页面出现稳定、回到前台或 H5 关闭销毁后，在原生根视图后准备一个不可交互的待命宿主，收到并响应 `preload-ready` 后才可领取。idle 不准备凭据，只允许 target=0 的导航 Bridge 请求，不提供 context／支付能力；没有账号和房间 IM／RTC。全局最多一个待命或活动 WebView；未就绪、预热失败、内存警告或进程终止时销毁未激活实例，实际入口回退普通并行加载，不等待预热满 60 秒。

领取已就绪实例后用当次 Open／会话和同一个原生入口 builder 的 path／原始 query 发一次 `openEntry`，按协议等最多 65 秒并检查 `opened:true`。每个实例只激活一次；激活已发出或 context 已跨 Bridge 后，关闭和重试仍先等待 SDK 释放确认，退出动画完成后销毁 WebView，再补一份新的 idle。快速返回后若下一份 idle 还未就绪，则走普通并行加载。预热不保留上次账号页面／房间，不把已关闭实例再次换路由激活。静态资源版本缓存继续保留，关闭不删解包目录。

加载反馈只覆盖 H5 真正可见之前：私有、主 frame、文件目录及 generation 受限的绘制观察器，在非 idle 的 `#app` 有内容并完成两个 requestAnimationFrame 后通知原生撤下，交接给 H5 自己的加载／骨架；不等 Open 或业务数据才撤下，也不以 didFinish 冒充已绘制。未交付 context／未发激活命令时可立即取消；已进入 SDK 所有权后走原释放协议。准备过久给出失败与重试，最多两次 WebContent 恢复，第三次已死进程先清理再显示可关闭的错误页。DEBUG 阶段日志只含阶段和毫秒耗时，不含 URL、账号或凭据。

网络层新增成功 Open revision：只有真实请求成功解析才递增。冷态进入若本次启动准备期间已经取得匹配 refreshToken 的新 Open，则复用该响应，避免启动 Open 后紧接第二次 Open；正常已启动后的每次新入口仍获取 fresh Open。缓存 key、前后续期、Token 接受、epoch／scope 校验和生产配置均保留，未改 Keychain 或业务接口。

本轮文件：`UKGlazeActortroller.swift`（预热池、并行准备、context 协调、加载交接及生命周期），`WevVGlazeH5Entry.swift`（同源 URL／openEntry 参数），`WevVGlazeH5Navigation.swift`（领取宿主），`TvVDonutcreamapricotFillinger.swift`／`GimSprinkleSceneCoordinator.swift`（主首屏／前台预热），`WevVGlazeRuntime.swift`／`WevVGlazeNetworkFoundation.swift`（冷态 Open 复用）；回归 `scripts/test_wevv_sdk2_host.py`、`verify_wevv_h5_entries.py`、`verify_wevv_h5_navigation.py`、`verify_wevv_h5_loading.py`、`verify_wevv_session_runtime.py`、`WevVGlazeNetworkVerification.swift`，以及本记录。主页面业务布局、登录注册接口、存储结构、正式配置和用户提供的 H5 文件均未改。

最终验证：无签名 Debug iOS Simulator 构建与 `git diff --check` 通过，构建日志 `/private/tmp/wevv-h5-pipeline-final-build.log`。实际 SDK 校验 27 个原生直接 URL／idle 命令入口及 74 个原生非法参数、13 个 SDK 非法入口通过；26 项导航／退出检查、12 组资源／Bridge 回归、11 组真实 context 协调代码回归、30 项 Runtime 场景和真实 Foundation URLProtocol 夹具通过。新增准备前取消、同页并发请求只准备一次、成功复用、失败重试、Token 漂移、换号／环境／epoch、旧 generation 清理、fullFeatures 与 idle 不取凭据断言；三份受控旧逻辑变体分别被对应断言拒绝。源 H5 内容版本仍为 `sdk2-7a700f8adeb79ca1750f9d77530791c01988949dc0e793645ba4533fe1c4359d`。

独立 iPhone 17／iOS 26.5 Simulator 使用最终真实 UK 与实际产品 HTML，远程 transport 栅栏先确认 fetch／XHR／image／WebSocket 全拒绝，Open 使用延迟的假 context，无正式后台请求。56 项运行断言全部通过，另确认 5 个激活 generation 各仅发送一次 openEntry。首轮冷资源入口约 100ms 出现原生可见反馈、1789ms 出现 H5 可见预览，模拟 Open 在 3108ms 才完成；最终普通入口 H5 首绘约 1068ms，Open 3080ms。最终就绪预加载入口在 320pt／430pt 子控制器宽度下，原生可见反馈约 13.7／4.6ms，H5 骨架约 110／200ms；Open 均仍延迟约 3 秒，证明初始化和首屏反馈已与 Open 并行，不能把这些骨架时间解释为业务数据已加载。已发 openEntry、尚未交付 context 时取消，真实 SDK close 约 55.8ms 完成，未等待慢 Open；失败 Retry 先释放旧实例再用新 generation／context。关闭补新 idle、重复 context、取消、内存警告及进程终止委托回调均通过。320／393／430pt 使用同一 874pt 测试窗口，SafeArea 62／34pt，44×44pt 关闭按钮及首帧可见性通过，未冒充三种实际设备或真机键盘／媒体测试。

QA 原始 UK SHA256 `74d9d6591207b593a0f1a42df258df8bd5cef755a7cd5b7b7eaa637d65cfc2fb` 与最终源码一致；实际 H5 骨架截图已检查，原生 Loading 已撤下。证据 `/private/tmp/wevv-h5-pipeline-qa-zh4fug79/RESULTS.md` 与 `evidence-final/QA-report.json`。一次性 QA 模拟器已关闭并删除，没有操作用户现有模拟器或真机。此轮验证加载／交接／生命周期，未验收正式账号数据、消息发送、真实内购或房间 IM／RTC 媒体；业务耗时仍受 Open、正式网络和 H5 后续请求影响。

## 替换 H5 入口文件（2026-10-28）

用用户提供的 `/Users/linqian/Downloads/index.html` 原始字节替换 `vanillaBeanIcingSdk2.data` 内的 `index.html`，未二次编辑 HTML。入口从 4,507,856 字节更新为 4,509,115 字节，SHA256 为 `eb969fa0ffd226888afa6d465158ac1c708c5ddb75443183857c0aae1dc3b4f9`。包内 `webapp-manifest.json` 已把 index 列为 editable，因此该文件及其余 1173 个文件原样保留；正式 Profile、App 配置和 `vanillaBeanIcingSdk2Network.data` 均逐字节不变。

沿用自定义归档、双层 zlib、现有 AES 加密链路重新打包，更新外 manifest 的入口记录、总大小、包 SHA256、内容版本及替换来源记录。新版本为 `sdk2-7a700f8adeb79ca1750f9d77530791c01988949dc0e793645ba4533fe1c4359d`，重新运行新构建后使用独立版本目录，不会把旧版本 index 当作新资源复用。原生 Swift、启动预解包、快速复用、登录／Open／Bridge 及关闭保留目录逻辑未改。

暂存包与项目最终包均完成解密解压回读，确认仅 index 内容变化且与用户文件完全相同，原生 Swift 还原校验通过；HTML 中 3 段可执行内联 JavaScript 语法检查通过。独立静态核对 schema 18／五个 Bridge 方法／会话鉴权契约兼容，资源引用未变化且对应文件均存在。无签名 Debug iOS Simulator 构建通过，构建内完整包、外 manifest、网络小包与项目资源哈希完全一致；日志 `/private/tmp/wevv-index-replacement-build.log`。备份和验证证据位于 `/private/tmp/wevv-index-replacement-2ndx6imq/`。未操作用户设备或请求业务接口，未将静态检查视为新页面运行验收。

## 启动预解包与 H5 静态资源版本缓存（2026-10-28，进入等待修正）

App 启动回调现在调度后台资源预准备，启动回调本身不等待解包。H5 进入与启动预准备通过同一个在途 Task 协调，单个宿主取消／退出不会取消公共资源准备。成功后另存本进程已验证的版本及运行依赖元数据；失败结果不记忆，下次可重试。后台预准备使用 utility，尚无在途任务的前台进入使用 userInitiated，共用在途任务时不另开一份解包。

完整静态资源存放在 `Library/Caches/vanillaBeanIcingSdk2/<contentVersion>/`。每次 App 进程首次准备时，以 Bundle manifest 的内容版本、精确目录／文件集合、大小、SHA256、App／Profile 配置及入口验证；有效磁盘命中不读取、解密或解压 AES 包，不重写资源文件。缺失或损坏时在同级 staging 目录重新解包，完整校验后原子发布。保留路径边界、符号链接拒绝、Data Protection 和禁备份要求；线程／版本文件锁协调发布，旧版本目录不作为当前版本的回退。

修正原因：上一轮只保留磁盘目录，成功后清除在途任务，导致每次进入仍重新遍历并读取全部 1174 文件、约 49.2 MB 数据做 SHA256。上一轮回归确认了相同目录和文件时间不变，却没有约束成功后不得重复全量校验，遗漏了实际等待问题。现在成功后从 manifest 一次提取 HTML／JS／MJS／CJS／CSS／WASM 依赖清单；同进程后续只在后台 stat 这些文件及父目录（当前 13 项），比较目录类型／inode、文件类型／inode／大小／修改时间，不读文件内容、不重新解析 manifest、不获取资源发布锁。目录或运行依赖缺失、替换、元数据变化时才重新完整校验／必要时修复；主文档加载失败也清除快路状态，使 Retry 重新完整校验。同进程普通图片等非运行资源的单独损坏不承诺即时发现，下次进程启动仍会完整校验所有文件。

关闭 H5、准备 context 失败或旧 generation 返回时均不再删除静态目录；仍按协议释放房间、WebView、Bridge、计时任务和当前用户 context。资源归缓存层所有，不保存访问 Token、IM 会话或用户资料。每次进入仍按原流程重新 Open、检查／必要时续期凭据；API 合同、路由、五个 Bridge 方法、购买补单、页面布局及键盘均未改。H5 的 JavaScript 启动和 Open 等待仍存在，本轮没有增加原生加载占位或预创建 WebView。

本轮文件：`WevSweetgd/WevSweetgd/WevVGlazeApplication.swift` 接启动预准备；`UKGlazeActortroller.swift` 负责共享准备、版本校验／发布及宿主保留缓存；`WevVGlazeBundleConfiguration.swift` 更新薄配置读取注释；`scripts/test_wevv_sdk2_host.py` 与 `scripts/wevv_room_bundle.py` 适配实际缓存代码验证；本记录维护资源存储与生命周期边界。

首轮功能验证（未覆盖热入口重复全量校验成本）：无签名 Debug iOS Simulator 构建通过；实际 Swift 方法的 9 组资源／缓存／协调／Bridge 回归，以及打包工具的原生还原校验通过，覆盖完整 1174 文件、同进程和新进程复用、损坏／缺失重建、真实新版本隔离、残留 staging、坏包无旧版回退、符号链接边界和 `/private` 路径别名。共享 Task 验证覆盖启动与进入合并、单个等待者取消不影响公共准备、已完成成功／失败结果不会阻止下次重新校验或重试。命令与结果保留在 `/private/tmp/wevv-sdk2-cache-regression-results.txt`。

首轮独立离线 iOS 17.5 QA 提取当时的真实 codec 与共享 coordinator，使用自己的临时 App 和模拟器：启动预准备调用约 0.153ms 返回，返回时缓存尚未生成；后台完成后 1174 文件完整。第二进程复用同目录，全部文件的 size／mtime／inode 保持不变；故意损坏 index 后第三进程恢复全部 manifest 大小和 SHA256，无遗留 staging／invalid。namespace 与版本目录禁备份属性为 true；Simulator 未提供可读取的文件保护等级，因此不作为真机硬件保护验证。证据在 `/private/tmp/wevv-cache-ios-qa-znrgs4na/`，该专属模拟器已关闭并删除。没有操作用户现有设备、登录态或业务接口；UI、SafeArea、键盘逻辑未改，未做本轮全机型视觉与键盘实测。

本次热入口修复另做实际资源性能对照：相同完整 1174 文件包，旧／新 coordinator 原文及相同低层 codec，仅重定向 Bundle／Caches 到临时目录并省略 macOS 不支持的 iOS 保护属性。两版首次准备后各连续请求 5 次，旧版资源等待为 366.306／383.616／932.861／365.940／385.455ms（中位数 383.616ms），新版 1.659／1.443／1.424／1.560／1.474ms（中位数 1.474ms）。每次同目录、全部文件 inode／size／mtime 均不变，最终文件大小／SHA256 匹配；源码一致性检查通过，证据 `/private/tmp/wevv-resource-reuse-perf-rjy5tdak/summary.json`。这只是本机离线资源准备对照，不代表真机点击到 H5 可用的总耗时；首次准备受文件系统热缓存与测试顺序影响，没有用它比较速度。本次没有改提前 WK 加载或 Open／Bridge 交付顺序，没有操作设备或业务接口。

本次最终无签名 Debug iOS Simulator 构建通过，日志 `/private/tmp/wevv-h5-fast-reuse-final-build.log`。更新 `scripts/test_wevv_sdk2_host.py` 的执行断言：12 组完整回归通过；共享准备成功后额外 12 次连续／12 次并发入口保持完整 restore 调用次数为 1，临时移除 fixture manifest 也不影响热入口，证明没有重读 manifest；目录／入口／配置／运行脚本等依赖缺失、改写、符号链接使快路失效并合并一次修复；失败 nil 不记忆、可继续重试。保留完整 1174 文件的真实低层解密／压缩／目录验证、跨进程损坏恢复、版本隔离和 Bridge／关闭回归。`python3 scripts/wevv_room_bundle.py verify --bundle WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data --native` 再次通过，完整命令及 PASS 明细在 `/private/tmp/wevv-sdk2-success-memo-regression-results.txt`；本轮没有修改低层 codec、资源包内容、登录持久化、UI 或键盘逻辑。

## 首页、语聊与动态下拉刷新独立结束（2026-10-28）

三个模块此前共用一次全量加载，刷新控件等到直播、两组语聊和两组动态全部返回才结束；语聊还串在直播之后。独立 UIKit 对照在三种宽度、三个模块共 9 组慢请求场景中确认：当前页面数据已到，其他模块尚未结束时，刷新仍保持开启、顶部保留刷新间距。正常无延迟、失败和空内容最终可自行归位，本轮没有将正常收起动画的中间偏移误判为永久故障。

现在直播、语聊和动态独立请求，语聊／动态优先加载当前筛选；当前模块／筛选成功或失败即可结束本次下拉，其他数据继续更新。每轮内容加载使用独立 UUID 及刷新所属模块，匹配后只结束一次；旧任务、后台返回、取消及账号变化不能结束新一轮刷新。切换主 Tab 或语聊／动态筛选会清理旧刷新归属；语聊切筛选同步结束刷新间距后再重置位置。动态 New Post 状态继续只对应 Trending 数据。首次骨架仍等待原有两组数据完成，分页游标、接口参数、登录和持久化合同未改。

本轮修改 `TvVDonutcreamapricotFillinger.swift`、`scripts/verify_wevv_native_integration.py` 及本记录。最终无签名 iOS Simulator 构建通过；88 项执行场景（新增 14 组）、6 项骨架检查、11 项接线检查通过，覆盖当前 Follow 优先、隐藏请求阻塞、旧请求／取消／换号、分页恢复及 Trending 状态归属。独立离线 UIKit 验证 320／393／430pt 宽度共 63 组场景，覆盖成功、失败、启动失败、空短内容、无关模块慢请求、刷新中切 Tab 和转入个人中心；最终控件关闭、顶部 offset／contentInset／adjustedContentInset 均回到 0，正常刷新动画保留。慢请求场景在当前数据返回、其他 endpoint 仍挂起时即结束控件，个人中心自己的请求仍由其自身结束。测试程序化触发真实控件并使用离线请求，未视为手指手势或正式后台实测。证据位于 `/private/tmp/wevv-three-refresh-qa/final-evidence/`；页面布局、SafeArea 和键盘代码未改，没有操作现有真机或模拟器，临时 QA 模拟器已删除。

## 个人中心下拉刷新归位（2026-10-28）

个人中心与其他主模块共用滚动视图和刷新控件，但此前只禁用了个人中心的控件事件，仍将控件挂在滚动视图上；同时刷新入口只加载其他模块，个人资料请求没有对应的结束刷新流程。

保留刷新样式和页面布局，个人中心现在使用正常启用的刷新控件，并单独更新当前账号资料与个人动态。在途个人请求复用，成功、失败和取消均由匹配的请求收尾；游客立即收起，切 Tab 和换号结束当前刷新，其他模块的后台加载不得结束个人中心正在进行的刷新。登录注册、接口合同和持久化结构未改。上一项已取消的文案清理没有继续，取消前唯一的退出提示改动已恢复。

独立 UIKit 验证还发现，刷新中切 Tab 时立即读取 `adjustedContentInset` 可能取到收起动画的临时间距，留下负偏移。切 Tab 的结束刷新、布局更新及位置重置现在统一放入 `UIView.performWithoutAnimation`，等待刷新间距同步恢复后再计算目标位置；普通下拉完成保留动画，没有引入固定延时或手改 inset。

本轮文件：`TvVDonutcreamapricotFillinger.swift` 修复刷新路由与结束归属，`scripts/verify_wevv_native_integration.py` 新增 14 组真实方法异步回归及本记录。完整无签名 iOS Simulator 构建、74 项执行场景、6 项骨架检查、11 项原有接线检查通过；页面约束和键盘逻辑未改。

独立离线 UIKit 宿主抽取最终真实方法，在 320／393／430pt 宽度验证 30 组场景、270 项断言，另保留 3 组旧禁用状态对照。修复后成功、两类请求失败、游客、取消、切 Tab、后台请求交错及 420／600pt 短内容均完成归位：最终 `isRefreshing=false`，顶部 offset／contentInset／adjustedContentInset 均为 0，没有歧义布局。切 Tab 的最小方案另经三宽各 5 次专测通过。测试程序化启动实际控件并派发事件、请求使用离线边界，未视为真实手势或正式后台实测；键盘未做本轮实测。证据保留在 `/private/tmp/wevv-profile-refresh-qa/final-evidence/`，没有操作用户已有真机或模拟器。





## iPhonex 真机 H5 资源还原失败（2026-10-28）

在用户指定的 iPhonex（系统识别为 iPhone SE，iOS 26.5）上以指定测试账号完成真实登录。修复前原生动态列表和详情均成功，独立准备 H5 context 也成功；H5 宿主则没有创建 WebView，随后取消并行的 context 准备任务。真机分阶段采集确认：完整资源包大小／哈希、canonical manifest、AES、双层 zlib、目录保护和禁止备份均通过，逐文件还原在第一个文件的目录归属校验处失败。

根因是分别规范化“已存在目录”与“尚未写入目标文件”时，Foundation 对 `/private/var` 别名的处理不一致：目录变为 `/var/...`，目标仍为 `/private/var/...`，原前缀判断错误拒绝正常资源。修复在创建目录后先保存 `canonicalFolder`，所有目标文件、配置读取和返回目录统一从该 URL 生成，保留路径安全、大小、哈希、重复文件及配置版本校验。

本轮产品修改限于 `WevSweetgd/WevSweetgd/UKGlazeActortroller.swift`、实际资源还原回归 `scripts/test_wevv_sdk2_host.py` 和本记录。登录注册接口、Token 字段及 Header、会话隔离、H5 资源包内容、页面布局和持久化格式均未修改。真机诊断驱动与脱敏探针仅存在于 `/private/tmp` 的隔离副本，账号密码仅用于本次启动环境，不写入源码或资源包。

验证：指定真机完成真实登录、原生动态列表／详情加载及 20 个 H5 入口的正常原生入口打开、会话交付、业务响应和关闭握手，覆盖消息、他人主页、充值／记录、黑名单、粉丝／关注／好友、编辑资料、系统／点赞消息、等级、商城、背包、反馈、直播／语聊搜索与排行、CP 设置。75 次业务请求均返回 HTTP 200，OPI 业务码 0 或 SAPI 业务码 200；OPI 鉴权头均存在，未出现提前关闭或鉴权退回登录。验证范围为页面加载、鉴权和进退，不包含消息发送、真实购买或房间媒体通话。

新增 `/private/tmp` 真实目录别名回归可稳定区分旧实现失败、新实现成功；1174 个资源的实际还原、损坏／缺资源拒绝及原有 Bridge／关闭回归均通过。普通项目与隔离诊断副本的签名 iOS 真机构建均通过，普通二进制已核对不含临时测试驱动或探针标记。SafeArea、布局及键盘代码未改，本轮未进行全机型视觉或键盘实测。

真机最终已更新安装并启动普通项目修复版，不含临时诊断驱动；应用已保存的数据与登录凭据保留。

## 他人主页返回动态详情时保留页面（2026-10-28）

移除动态详情打开 H5 他人主页时附带的关闭刷新回调。返回时不再因此请求动态详情、重建评论或通知上层列表刷新，继续使用原详情实例，保留当前内容、滚动位置与未提交评论。首次进入详情以及点赞、收藏、关注、评论等原有操作完成后的更新保留；公共 H5 宿主的当前用户资料／余额同步及账号、环境校验不变。

本轮只修改 `WevSweetgd/WevSweetgd/KipoDonutMomentController.swift` 和本记录。登录注册、持久化、页面布局、SafeArea 和键盘处理均未改。完整无签名 Debug iOS Simulator 构建、26 项现有 H5 导航／退出回归及 git diff --check 通过；源码核对详情没有 viewWillAppear／viewDidAppear 或用户资料通知驱动的刷新，剩余详情请求仅在首次加载与真实操作完成后触发。未安装或操作用户模拟器，返回后的滚动位置、未提交评论和无骨架闪烁仍需运行新构建验证；本轮未做大小屏及键盘实测。

## 语聊卡片 Join 与右上箭头（2026-10-28）

语聊房卡片按钮文案从 Join in 改为 Join，右侧使用白色 `arrow.up.right` 小箭头（10×10pt），通过水平 UIStackView 设置文字与箭头的 6pt 间距，内容整体居中。继续使用原 15pt bold 字体、55×21pt 外框、10.5pt 圆角及背景颜色。三种卡片背景、Recommend／Follow 以及分页追加的卡片共用此实现；父容器不拦截触摸，整张卡片原有进房操作、登录门禁和 H5 路由保留。

本轮只修改 `WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 和本记录；骨架占位尺寸、其他页面的 Join、接口和本地数据均未改。验证：Auto Layout 源码自检，完整无签名 iOS Simulator 构建通过，git diff --check 通过。未新增重复常量的测试，未安装或重启用户当前模拟器；未进行全机型视觉及键盘实测，键盘逻辑未改。

## 语聊推荐／关注上拉加载更多（2026-10-28）

语聊 Recommend 与 Follow 接入与首页 Live room 一致的上拉交互：底部显示 Pull up to load more，继续上拉 52pt 后提示 Release to load more，松手请求下一批；加载中显示转圈与 Loading rooms，失败保留已有房间并允许上拉／点击原游标重试，结束显示 No more voice rooms。下拉刷新重新获取首批；首次骨架、顶部固定区域、房间卡片和 Join in 按钮保留。共用首页 footer 构建方法，继续使用 13pt semibold 字体、最小 52pt 高及 8pt 图文间距，语聊适配深紫背景与白色文字。共用组件采用固定上下内边距、最小高度及低优先级首选高度，修复原来的 footer／row 高度歧义；两份房间 stack 增加空内容高度偏好，有卡片时由真实卡片高度覆盖，空状态也有确定布局。

按当前实际 dist 与 api-party 文档接入 SAPI 游标分页，每批 10 条。推荐请求 `/party/room/list` 使用 `languageCode=""`，关注 `/party/room/followed/list` 使用 `languageCode=null`，均保留 `version="v2"`；首批省略 offset、snapshotId 和 ignoreRoomIds，后续 offset 使用**原始响应末行的 score**，同时传非空 snapshotId。score 按精确 Int64 解析，允许 0 和负数，不使用页码或累计条数。原生仍先以当前 legacyToken 换取 SAPI 凭据，保留票据复用、错误失效及账号／环境隔离。

推荐与关注分别持有分页状态和请求任务，按真实房号去重；短页、空页、无新增有效房间、缺少有效末行游标或游标不变时结束，防止重复请求。这里沿用 SDK 的无新增终止策略，不把被过滤的房间伪装成有效房间。追加失败不消耗游标，刷新取消旧分页并保持同账号已展示内容；刷新失败提示下拉重试，禁止使用旧快照继续下一页。请求 UUID、Task 取消和当前 owner 三重检查阻止刷新、换账号及环境变化后的迟到回包覆盖内容。某一筛选失败不会遮住另一筛选已成功的列表；追加页也不会误结束首次骨架或覆盖首页直播数据。

语聊横向 pager 高度改为当前筛选的实际卡片高度，空列表预留状态区域；底部提示紧接当前列表末尾，不再按两份列表的最大条数留下大块空白。切换筛选时完成布局并复位纵向位置，保留筛选条及横向分页接线；固定头不随列表或刷新移动。

本轮文件：`WevSweetgd/WevSweetgd/WevVGlazeVoicePagination.swift`、`WevSweetgd/WevSweetgd/WevVGlazeRuntime.swift`、`WevSweetgd/WevSweetgd/WevVGlazeRoomMapper.swift`、`WevSweetgd/WevSweetgd/kettleGlazeSequence.swift`、`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift`；回归脚本 `scripts/test_wevv_voice_pagination.py`、`scripts/test_wevv_room_mapper.py`、`scripts/verify_wevv_session_runtime.py`、`scripts/verify_wevv_native_integration.py`；本记录。登录注册接口、本地持久化格式、H5 包与路由未改。

验证：完整无签名 Debug iOS Simulator 构建通过；43 项真实语聊分页状态检查、60 项原生源码场景（含 9 组新增语聊分页）、20 项会话／SAPI 合同回归及 mapper／仓库合同检查通过，原有 31 项直播分页回归保留通过。独立离线 UIKit 宿主提取真实布局、分页状态及 UI 更新方法，在 320／393／430pt 宽度及实际 20／59pt SafeArea 下，36 场景、540 项检查全部通过，覆盖空／1／10／23 房、Recommend 23 与 Follow 3 来回切换、加载／松开／失败重试／刷新失败禁用／结束状态；当前页底部间距14pt，footer 可完整滚至模拟 TabBar 上方22pt，长文案可自适应增高至55.5pt／71pt，固定头不随正文移动。最终 QA 进程日志未检出布局歧义、约束冲突或 overflow。房间卡片和 TabBar 使用离线占位，Release 状态模拟 dragging，未将其视为实际手势访问正式后台的验证。一次性 QA 设备已关闭并删除；尚未以正式后台账号实测多页列表，没有安装或重启用户当前模拟器。

## 首页、语聊列表及 Explore 顶部固定（2026-10-28）

按用户要求将三个主页面的指定顶部区域移出纵向滚动内容，统一放入根视图的固定容器 `glazePinnedHeaders`：首页固定 WevV 标题、发布挑战及会话列表入口；语聊页面固定标题、消息入口、顶部横向房间条、Follow／Recommend 和选中条；Explore 固定标题、消息入口、Trending／Follow 及选中条。语聊 Recommend 下方的横排用户头像、房间卡片，以及 Explore 动态内容仍可正常纵向滚动。

顶部控件继续使用原尺寸、间距及点击处理，标题锚定根视图 SafeArea。首页标题下保留 10pt、语聊选中条下保留 18pt、Explore 选中条下保留 12pt，与原首屏内容间距一致。根滚动容器从当前固定头底部开始，列表不会穿到固定头或系统状态栏后面；原 UIRefreshControl 留在内容区，刷新时顶部不跟随下拉。保留内容底部闭环、110pt 底部 inset、Live room 上拉加载、筛选点击及横向分页处理。

固定容器按当前模块切换底部约束，只显示对应头部；个人中心高度为零，沿用原整页滚动。切换到不同模块时先完成顶部和内容底部约束布局，再复位纵向滚动位置，避免把上一页较长的偏移带入新页面。语聊背景图及 Explore 渐变移至固定根底层并随模块显隐，继续使用原素材和渐变参数；骨架仍覆盖整页，加载期间同步隐藏固定头的 VoiceOver 遍历。移除语聊旧的 `panel.height >= scroll.frame.height`，避免它与既有内容固定高度形成冲突。

本轮文件：`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 调整布局、背景与切页；`scripts/verify_wevv_native_integration.py` 补上新头部容器的骨架无障碍边界验证；本记录。登录注册、网络接口、H5 路由和本地数据结构均未改。完整无签名 iOS Simulator 构建、51 项原生源码场景、6 项骨架生命周期接线、11 项原有接线及 31 项直播分页回归通过；独立离线 UIKit 宿主提取当前真实构建／顶部切换方法，在 iOS 26.5 与 17.5 下覆盖 320／393／430pt 宽度及实际 20／59／62pt 顶部 SafeArea，24 个布局场景、6 组反复切页共 246 个聚合检查通过：正文上移 180pt、下拉 80pt 时顶部坐标不变，正文正常移动、首屏衔接无额外空白、只显示当前头部，横向 scroll／pager 约束正常，无歧义布局；两次运行日志未发现约束冲突或 overflow。测试业务内容采用固定卡片，筛选业务更新使用 stub，未将其视为真实数据或点击动画验收；选中条动画的布局目标已静态核对为新固定头。两个一次性 QA 模拟器已关闭并删除；未安装或重启用户当前模拟器。

## 他人主页消息按钮与原生 IM 凭据交付核验（2026-10-28）

本轮针对 Lisa（业务 ID 554，后端给出的云信账号 `39114002_554`）无法从 H5 他人主页进入会话的报告，检查当前实际加密资源包的还原内容、原生网络及 Bridge 链路。模拟器曾复现目标 305 的 CreatorDetail 消息按钮灰色、点击没有路由变化；本轮没有发送消息、创建账号或执行 NIM 登录。用户随后选择稍后自行验证，已停止模拟器界面操作。未取得该次目标详情的实时 `userType / yxAccid / blocked`，不能将某一条件直接认定为本次根因。

实际 H5 的按钮前置条件：`CreatorDetail` 要求目标 `imAccount` 非空，再调用 `relationships.canStartConversation`；后者复用 `canFollow`，要求目标类型 `userType` 为 2 或 3、不是当前用户、关系未拉黑；按钮还检查详情本身的 `blocked`。这条判定没有检查 NIM 在线状态。进入 `/conversation/:imAccount` 后，ConversationPage 才调用 `ensureMessagingReady` 初始化并登录 NIM。因此停留主页时后端查不到 IM 在线连接，与当前按需连接实现相符，不能单凭这一现象认定 IM 登录失败。若目标是普通用户（type 1），当前 SDK 会禁用该按钮；即使原生已提供正确 IM 凭据也会如此。

原生代码核验：每次实际进入 H5 先完成 fresh Open、检查／续期当前业务凭据，再提供 context；Open 的 `imAppKey` 已执行非空及 32 位十六进制校验。`session.realtime.imAccount / imToken` 来自登录响应的 `yxAccid / imToken`，与业务 accessToken 和 SAPI auth_token 分开；未拼接 yxAccid，未发现旧项目固定 IM AppKey。H5 每次由独立非持久化 WKWebView 承载，原生没有另建第二个 NIM 实例。以上为代码及资源核验，不是当前账号 NIM 登录成功的运行证明。

本轮增加仅 DEBUG 生效的 `H5IM` 原生日志：`native.open` 记录 Open 成功或安全错误类别、App ID、IM AppKey 是否存在／长度／校验结果及缓存标记；`native.context` 记录当前业务 ID、服务端 IM 账号、IM Token 是否存在／长度、是否误用 accessToken、系统及客户端版本；`native.bridge` 记录 context 回包实际交付结果及 WebView generation。日志不接收完整 Token 或 Key，不记录任意响应、错误 message、URL query 或 NSError userInfo，不新增日志文件或凭据持久化。日志可区分“原生已准备好／已交付”和“H5 SDK 已登录”，后者仍需 H5 的 SDK 回调提供真实结果。

同时修复宿主 `completeGlaze` 的状态错误：只有 `sendGlaze` 成功且 WebView generation 仍然一致时，才把 context 标记为已交付；发送失败、错误响应、超时及旧 WebView 的迟到回包均不会错误置位。此修复不视为灰色消息按钮的业务修复。

待 H5 核验／修复的具体项：读取问题目标的详情及关系状态，确认哪项禁用条件生效；如果业务允许普通用户私信，将消息资格与“可关注主播”的角色判断分开；确认详情返回真实 yxAccid，缺失或被限制时提供原因；在真实会话入口补齐 NIM 初始化／登录／连接状态及 P2P 发送失败的脱敏错误码。现交付包是编译产物，`NATIVE_INTEGRATION.md` 第 1 节要求“原生只允许修改以下两个文件；超出配置范围的需求联系 H5 修改源码，重新打包交付。”本轮不改编译后的业务 JS，不假造目标类型或 IM 账号，不以原生重复 NIM 登录掩盖 H5 的入口判断。

本轮文件：`WevSweetgd/WevSweetgd/WevVGlazeIMDiagnostics.swift`、`WevSweetgd/WevSweetgd/WevVGlazeNetworkFoundation.swift`、`WevSweetgd/WevSweetgd/WevVGlazeRuntime.swift`、`WevSweetgd/WevSweetgd/UKGlazeActortroller.swift`、`scripts/verify_wevv_im_diagnostics.py` 及本记录。登录注册接口、原生页面、布局、键盘和本地数据格式未改。

验证：完整无签名 Debug iOS Simulator 构建通过；实际诊断 helper、NetworkError 与宿主 `completeGlaze` 的离线回归在 DEBUG 和非 DEBUG 下各 31 项通过，覆盖字段白名单、错误脱敏、回包前不得置位、失败／超时／旧 generation／其他方法；原网络合同验证和 19 项会话源码回归通过。尚未完成当前 Lisa 账号的 NIM 登录及实际消息收发验收，未安装或重启用户正在使用的模拟器。后续重新运行构建后，可在 Xcode 控制台筛选 `H5IM` 核对三段原生记录，再由 H5 日志确认 SDK 阶段。临时还原资源与私有探针已清理。

## 语聊列表统一 Join in 按钮

用户已将火箭背景替换为无内嵌文字版本，当前保留其提供的 3x 素材及 Asset Catalog 配置，不恢复已删除的旧 2x 图。三种语聊房卡片统一显示原生 `Join in`，宽 55pt、高 21pt、圆角 10.5pt，颜色及字体沿用原按钮，推荐和关注列表共同生效。删除火箭卡隐藏原生按钮及为旧内嵌按钮保留区域的特殊拉伸分支，三张背景统一按原卡片 aspect-fill 加载。整个 124pt 高卡片仍处理进房点击，原登录门禁、房号及 H5 路由保持原逻辑。

本轮文件：`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 统一真实按钮展示与尺寸；`WevSweetgd/WevSweetgd/WevVGlazeSkeletonPanel.swift` 将语聊加载占位的按钮尺寸同步为 55×21pt；本文件记录。用户暂存的背景文件未作修改。小屏 320pt 对应 290pt 卡片时，Voice Room 标签与 Join in 保留 16pt 间隔，按钮使用 Auto Layout 靠右对齐；SafeArea、键盘、登录和持久化未改。

验证：已目视确认用户新火箭 3x 素材没有内嵌 Join 文字；最终完整无签名 iOS Simulator 构建及 `git diff --check` 通过。此轮仅调整视觉元素，没有新增重复实现常量的测试，也未重启当前用户模拟器；重新运行新构建后核对推荐/关注列表三种卡片的按钮一致即可。

## 首页、语聊列表及动态页首次骨架加载

本轮为三个一级内容页统一补齐首次真实数据加载效果。首页和动态页使用浅粉、薰衣草及柔白扫光，语聊列表沿用深紫背景和淡紫占位；骨架按对应页面的标题、横排卡片、头像、列表/图片结构展示，不改变实际业务页面布局。独立面板覆盖到 TabBar 上方，顶部按 SafeArea 布局，内部滚动保证小屏不挤压；TabBar 仍可正常切换。

取消原首页/动态页固定 1.8 秒结束的假加载。首页直播请求结束即收起首页骨架，语聊及动态各自在自身首轮请求完成后收起；成功空列表及失败同样结束骨架，显示原有空/错误状态。三个页面可以在后台预取：某页的数据先完成时，之后首次切过去直接显示内容。已完成页面的下拉刷新和分页不重播整页骨架；账号或环境变化时清除旧内容并重新执行首轮加载。继续沿用取消及 owner 校验，迟到旧请求不能结束新账号的加载状态。

骨架只在当前可见页面执行扫光；隐藏、离屏或 App 退到后台时停止动画，开启 Reduce Motion 时显示静态占位。切换页面或再次开始加载会作废旧淡出回调，避免新骨架被旧动画隐藏。保留其他二级页使用的旧 `WevVGlazeSheenView`，不影响它们现有占位。

本轮文件：`WevSweetgd/WevSweetgd/WevVGlazeSkeletonPanel.swift` 提供三种主题布局和动画生命周期；`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 接入实际首次请求状态及页面显隐；`scripts/verify_wevv_native_integration.py` 验证真实加载路径、取消和错误收尾；本文件记录行为。登录注册、原数据接口、凭据、活动/钱包及持久化未改。

验证：最终完整无签名 iOS Simulator 构建成功，`git diff --check` 通过。原生真实源方法回归 51 组、骨架生命周期接线 6 项及原有接线 11 项通过，覆盖 2 秒慢请求、三页独立结束、空/失败、刷新不重播、账号切换和迟到旧请求；VoiceOver 在覆盖期间只读取加载语义与底部导航，完成或离开后恢复原内容遍历。独立离线 UIKit Renderer 直接编译当前组件，对三种布局分别执行 320×568、393×852、430×932 的九组检查，未发现歧义、无效尺寸或横向/父层越界；正常模式验证隐藏、移出 window、后台停止及前台恢复，Reduce Motion 开启实测九组均没有扫光动画，快速反复显隐的三项终态断言通过。截图仅为骨架组件及测试宿主，不代表替换了 App 原 TabBar；一次性 QA 模拟器已关闭并删除。当前用户模拟器未重启、未安装测试宿主或执行账号操作；键盘逻辑未改。

## 发布挑战 Free 选项与 Activity 限时免费

按用户本轮要求，发布挑战原 50 档改为 Free，对应保存值为 0；100、300、500 及原默认选中档位保留。继续使用已有活动包格式保存/读取，0 可以正常解析，不重写已有活动数据。

两套原生活动详情统一显示 `Free for a limited time`，删除费用提示旁的金币图标，使用可换行的文本和相对约束避开 Join 按钮。当前活动参与按限时免费处理，保留登录门禁、重复参与保护、原参与动画及本地 `placeJoinedGlazeQuest` 记录；不检查金币余额，不调用缺少新版合同的活动扣费接口，也不修改钱包余额。原先“活动扣钻暂不支持”的接口限制仍然有效；免费参与并不代表启用了付费接口。

本轮文件：`WevSweetgd/WevSweetgd/GemTastingQuestComposerController.swift` 修改 Free 选项及其零值；同目录 `NmFrostingmuralSignalController.swift` 和 `BrostingmellowCoconutEssence.swift` 修改费用展示和免费参与；本文件记录当前活动规则。登录注册、会话凭据、原内购流程和已有活动存档保持原实现。

验证：完整无签名 iOS Simulator 构建成功，`git diff --check` 通过。提取两个详情的真实参与方法和按钮刷新方法，10 组 Swift 检查通过：游客登录门禁、登录后零余额参与、动画期连续点击防重、仅一次参与落盘与回调、已参与再次点击无重复记录，余额保持不变。Free 按钮沿用 tag 选择和原活动存储链，读取端 `Int` 解码接受 0。当前模拟器正在浏览其他模块，本轮未重启安装或代用户发布/参与；大小屏费用文案的视觉验收仍需运行新构建查看，SafeArea 和键盘处理未改。

## 首页 Live room 分页与标题修复

首页原先请求第一页后仅渲染 `prefix(4)`，标题还沿用了交付 dist 的错误 `anchorLevelName` 映射。本轮去掉四条上限，继续使用现有两列卡片；根据 `opiv1.5.html` 的 `discover.live.pool` 字段合同，标题改为 `liveName`，空值时依次回退 `liveDescribe`、主播 `nickname`、WevV，不再显示主播等级。

直播池按 `currentPage=1,2,3…`、`pageSize=10` 请求，其余筛选保持 `countryIds=""`、`ids=null`、`isMiddleEast=false`。保留后台 `total` 和过滤无效业务 ID 前的 `rows` 数量。按业务房号去重；收到空页、总数已读完或重复页不再继续；未提供合法 total 时以不足一页判断结束。文档将 ids 定义为指定房间筛选，交付 dist 却将其用作已见房号，故本次遵循文档页码合同，并加入重复页停止保护。

列表底部上拉后松手加载下一页，也可点击底部提示加载或重试。提示复用原下拉刷新的紫色、13pt semibold 字体、半透明白底和系统转圈；明确区分加载中、失败重试及没有更多数据。下拉刷新从第一页重新获取，失败保留同账号已有列表和页码；页请求不并发，刷新或账号/环境变化后的迟到回包不能写回。语聊请求较慢时，使用当前直播分页结果合并，避免旧第一页覆盖后续页。登录门禁、H5 路由、会话凭据和本地持久化不变。

本轮文件：`TvVDonutcreamapricotFillinger.swift` 接手势、底部样式和完整渲染；`WevVGlazeLivePagination.swift` 管理分页、去重和请求代次；`kettleGlazeSequence.swift` 传递页码；`WevVGlazeRoomMapper.swift` 解码真实标题及分页元数据（Swift 文件均位于 `WevSweetgd/WevSweetgd/`）；`scripts/test_wevv_room_mapper.py`、`scripts/test_wevv_live_pagination.py`、`scripts/verify_wevv_native_integration.py` 覆盖合同和并发回归。本节为当前规则，下方旧数据源修复中的第一页参数是当时实现记录。

验证：真实 Mapper/Repository 合同脚本通过；真实分页状态 31 项检查、原生接线 43 个实际源方法场景及 11 项守卫通过，覆盖失败同页重试、刷新取消、账号切换、重复回包和慢语聊回包。完整无签名 iOS Simulator 构建通过，新增 Swift 并发捕获警告已消除；仅有原有 AppIntents 元数据提示。修复版已保留数据覆盖安装并启动到当前 iPhone 17，真实首页读取到 6 个房间，6 个正确标题均在可访问性树中，底部状态为 No more live rooms；截图确认原两列卡片和 TabBar 样式保留。当前总量不足一页，因此实际网络第二页/失败重试由离线合同与源方法回归覆盖，没有在正式后台伪造直播间。本轮未做所有大小屏的视觉复测，未改输入框及键盘逻辑。

## 第二模块 Recommend 横排头像用户名

用户明确指定 Recommend 下方横排圆形头像下方展示对应用户的用户名。该位置原来读取语聊列表的 `ownerName`，不是房间 `roomName`。本次只读核验返回 9 条语聊记录均含 ownerName，抽查 3 位与个人名片 `nickName` 一致；不将其误报为房间名绑定错误。

为统一用户名来源，横排按每个头像对应的真实 `ownerId` 补取 `/_v2/user/personalCard` 的 `nickName`，不使用房间名代替用户名。轻量服务不加载关系接口，保留游客技术浏览及账号/环境边界检查。只补全当前显示的最多 8 位用户，昵称独立加载，不阻塞房间列表；失败保留已有 ownerName，不清空房间。房间大卡片的标题、封面、头像样式、点击路由和布局保持原逻辑。

本次文件：`WevSweetgd/WevSweetgd/WevVGlazeSocialService.swift` 新增只读取真实昵称的轻量个人名片请求；`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 将横排用户名绑定到对应 ownerId 的昵称结果，并管理请求去重、刷新及会话隔离；`scripts/verify_wevv_social_service.py` 验证昵称字段、目标 ID、无多余关系请求和迟到回包边界；`scripts/verify_wevv_native_integration.py` 同步实际昵称请求清理方法，验证下拉刷新保留显示缓存而换号清空旧绑定；本记录说明范围与验证。登录注册与本地持久化未修改。

验证：个人名片服务 61 项检查通过，原生接线 11 项守卫及 37 项实际源码场景通过，最终无签名 iOS Simulator 构建成功。当前正在使用的模拟器未重装或重启，修改将在下一次运行新构建时生效。字体、头像、宽高约束和键盘逻辑未改，本轮未做推荐列表的大小屏视觉复测。可重新运行后打开第二模块 Recommend，核对头像下方与对应个人资料昵称一致，下拉刷新后昵称保持正确，失败不丢失列表，换账号后不出现旧用户缓存。只读身份核验的私有探针已清理，没有在日志/文件保存昵称内容或访问凭据。

## 首页 Live room 数据源与空状态修复

新域名切换后，使用当前 iPhone 17 已有的稳定设备号和 App 原技术浏览流程，只输出字段结构与数量进行核验：`/_v2/discover/anchor/online` 成功返回 6 个在线主播，6 条 `agoraLiveSimpleVO` 均无直播快照；按交付 dist 相同条件调用 `/_v2/discover/live/pool` 成功返回 `total=0`、`rows=[]`。这是本次核验时的房间状态，不代表后台永久没有数据；不能将在线主播直接伪装为正在直播的房间。

客户端此前把 All 在线主播接口作为首页 Live 数据源，再从其中筛选嵌套直播快照，与 dist 的直播入口不同。当时按 dist 的 `getLivePoolPage` 改用 `/_v2/discover/live/pool`，第一页请求为 `countryIds=""`、`currentPage=1`、`ids=null`、`isMiddleEast=false`、`pageSize=10`。解码扁平 rows 的真实 `id` 房号、`userId` 主播业务 ID、`backgroundImgUrl/icon` 封面、`joinNum` 人数、`followFlag/followed` 关注状态；不使用 IM/RTC ID 代替业务房号。当时沿用的 `anchorLevelName/nickname` 标题现已按本文件顶部章节纠正为真实房间标题。

原生直播请求完成后立即更新首页，不再等待两次语聊请求；语聊失败不会覆盖直播结果。真实空列表使用现有状态 Label 显示 “No live rooms are open right now.”，请求失败保留同账号已有直播并提供原下拉重试提示。主页面布局、房间登录门禁和 H5 入口不变。

本次文件：`WevSweetgd/WevSweetgd/kettleGlazeSequence.swift` 改直播专用接口与参数；`WevSweetgd/WevSweetgd/WevVGlazeRoomMapper.swift` 改直播池扁平映射；`WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift` 独立直播更新及空状态；`scripts/test_wevv_room_mapper.py` 验证真实直播池字段并直接编译当前 H5Entry，修复旧宿主提取测试滞后；`scripts/verify_wevv_native_integration.py` 验证直播接口参数、语聊延迟/失败隔离、缓存和账号切换；本文件记录当前核验结果。

验证：真实 mapper/model/H5Entry 编译执行通过，覆盖 pool 扁平字段、Int64 精度、业务 ID 边界、关注状态、语聊兼容和空/错误结构；原生接线 11 项守卫与 36 个真实源码场景通过。最终无签名 iOS Simulator 构建成功，并安装、启动到此前 iPhone 17；截图确认真实空直播文案可见、原首页和 TabBar 保留。未代用户执行邮箱登录、进入房间、购买或新增开播；当前真实后台没有房间，非空列表仅做合同样例验证。未改约束或键盘逻辑，本轮未覆盖所有大小屏/键盘视觉验收。私有探针及临时文件已清理。

## 正式域名与启动接口更新（当前配置）

本次以用户提供的 `WevV-39114002-域名与启动接口.txt` 替换之前的独立 OPI 域名和临时测试启动 ID。OPI 初始域名、原生启动域名统一为 `https://getaway.wevvstream.online`；启动和业务 App ID 统一为 `39114002`。

实际启动请求：`GET https://getaway.wevvstream.online/sugary9/crumb/voice?treatWarmDelight=39114002`。原始合同为 `/client/bootstrap/route?appId=39114002`。启动的独立混淆映射为：`code→treatRecommendationPhoto`、`appId→treatWarmDelight`、`target→seasonalRingPhoto`、`message→sweetnessVisitRing`、`revision→visitFillingCheckin`、`apiBaseUrl→cozySeasonalGlaze`、`fullFeaturesEnabled→conversationTastingVisit`，不混入 OPI 的 aliases 表。

原生薄配置和完整 H5 资源同时重打包，只有 `config/opi-profile.js` 的业务域名变化；其余 1,173 个 H5 文件逐字节保留。当前内容版本为 `sdk2-bfe9bc94ec803289edbdc8395e4ed96c7c0df50b11dadc9a9880d3c3b42a5cef`，完整密文 39,277,616 字节、薄包 15,408 字节。正式业务 App ID、185/965/7 混淆表、接口 AES、SDK2 Bridge 和资源加密链保持当前正式参数，原生路由元数据继续独立放在 manifest，避免触发 H5 严格配置校验。

会话范围改为 `production|39114002|https://getaway.wevvstream.online`。旧域名凭据和待处理交易保留在原范围，不跨域自动读取或交付；用户需要在新范围重新登录。稳定设备号、本地店铺、活动、签到和协议偏好保留。此轮仅替换连接配置和启动协议，不修改页面、登录界面或上次核对发现的密码/昵称异常分支。

本次文件：`WevSweetgd/WevSweetgd/WevVGlazeNetworkFoundation.swift` 更新启动请求与响应映射；同目录 `vanillaBeanIcingSdk2.data`、`vanillaBeanIcingSdk2Network.data`、`vanillaBeanIcingSdk2.manifest.json` 更新完整 H5/薄配置域名、原生路由和完整性；`scripts/WevVGlazeNetworkVerification.swift` 更新启动合同回归；`scripts/verify_wevv_session_runtime.py` 覆盖新正式会话隔离；`WevV_API_MIGRATION.md` 记录当前配置及验证。下方同日旧域名/临时双 ID 的成功记录只用于追溯，不能作为当前运行参数。

本次验证：新启动 GET 实测 HTTP 200，App ID=39114002、target=REPLICA、revision=3、业务地址为新域名、完整功能开启；code/message 当前省略。实际 Swift 薄包加载器和 NetworkFoundation 联网完成启动及 Open，完整校验本次 runtimeConfig，未请求 device/email 登录，Open 未签发访问凭据。当前 Open 的 SAPI 地址仍为 `https://getaway.d9venk431vi8tyj0ubz5.shop`，继续按 Open 使用，不将 OPI 域名硬套到 SAPI/IM/RTC。

离线网络合同回归通过，涵盖新版映射、同一正式 ID、失败不 Open/不回退、严格字段类型及原 OPI/SAPI 协议；会话回归 19 项通过，含旧正式域名凭据隔离和本地收藏/活动/签到保留。薄配置 102 项及实际新包验证通过，H5 真实解析/动态加载 15 项通过，完整 1,174 文件经实际 Swift 还原校验通过。最终无签名 iOS Simulator 构建成功，构建包三份资源与仓库哈希一致；登录后消息、房间音视频和购买仍由用户自行验收。本轮没有页面约束/键盘改动，也未重做大小屏视觉验收。

最终版本已安装到此前的 iPhone 17 模拟器（B35DAB5E-225E-46CF-939B-ACCF625E3770）。安装前关闭旧进程，以便下次启动读取新配置；未清数据、代登录、自动同意协议或购买。临时私有连接输入和探针在核验后删除，不保留 API 密钥明文文件。

## 原生二级入口复用 H5（当前范围）

依据 Downloads 的 `NATIVE_INTEGRATION.md` 第 6 节与同批 `dist/index.html` 的实际 `SDK_PAGE_ENTRIES`、`validateSdkEntry` 实现接线。文档是路由合同依据，新增接线的授权来自用户本次请求。继续使用当前正式加密资源包，不修改 Downloads 源文件，不另建远程网页或新增一级 Tab。

- 主页面消息按钮 → `/messages`，由 H5 管理会话、私信及其内部跳转，不再依赖缺少合同的旧原生消息 REST 接口。
- 后台动态作者与真实关系用户 → `/user/{业务用户ID}`；房主 → `/creator/{业务用户ID}`，可选传真实 `yxAccid`。业务 ID 和 IM 账号分别保存；不会把本地人物 key 当作后台账号。
- 个人中心头像及设置的编辑资料 → `/profile/edit`。
- 个人中心关注、粉丝 → `/profile/relations/3`、`/profile/relations/2`；设置黑名单 → `/profile/blocklist`。
- 个人中心及两个现有活动钱包按钮 → `/profile/diamonds`。继续复用五方法 Bridge 和独立 StoreKit 交易箱；H5 创建业务订单，原生执行购买，未新增支付观察者。
- 旧远程名片的聊天按钮：有真实 IM 账号时 → `/conversation/{编码后的IM账号}?userId=...&yxAccid=...`；缺少 IM 账号时先进入 H5 用户资料，由 H5 查询。没有猜测账号、创建旧 REST 会话或放宽后台聊天权限。
- 原生直播/语聊列表 → 原有房间 H5 路由，与其他二级入口共用宿主和返回同步。

`WevVGlazeH5Entry.swift` 集中允许全部 27 类有效入口/变体（含已有房间）。消息子页、好友、充值记录、等级、反馈、商店、背包、搜索、榜单、语聊建房和 CP 设置均有类型入口，但没有现成按钮的位置不新增按钮。仅 CP 独立入口要求 fresh Open 的 `fullFeaturesEnabled=true`，其他二级入口不被此开关整体阻断。参数只含业务导航信息，访问凭据通过 Bridge context 交付，不放入 URL。

`WevVGlazeH5Navigation.swift` 统一原生呈现、登录拦截与返回同步：游客仍进入原欢迎页/EULA，技术设备会话不充当界面登录。每次真正进入重新准备 Open 和会话，独立全屏容器隐藏底部 Tab；容器之间不并发连接 IM/RTC。H5 根返回和原生退出继续使用 SDK 释放握手，动画退出及 teardown 后仅回调一次。随后只为原账号/环境/会话版本读取真实资料，再刷新原生余额、关系、列表或头像；旧页面不能更新新登录。

本地店铺、活动人物、签到、协议和没有公开 H5 路由的动态详情等保留原生；主设置仍保留退出、缓存、隐私与条款等原有功能，旧二级控制器源码不删除。新增入口不改变凭据落盘和环境隔离规则。

本次文件与用途（Swift 文件均位于 `WevSweetgd/WevSweetgd/`）：

- `WevVGlazeH5Entry.swift`：新增公开路由类型、必填 ID 校验和单次 URL 编码；凭据不进入 URL。
- `WevVGlazeH5Navigation.swift`：新增统一登录门禁、呈现防重、同账号返回资料同步。
- `UKGlazeActortroller.swift`：房间宿主支持任意已声明入口；复用包校验、五方法、购买和释放协议，退出动画完成后仅通知一次。
- `TvVDonutcreamapricotFillinger.swift`：主模块消息、作者/房主、个人头像、关系、钱包和房间按钮接到对应 H5；返回刷新原生资料/列表。
- `DimSugarpistachioCreamCoating.swift`：设置中的编辑资料、黑名单改到 H5，保留设置返回更新。
- `KipoDonutMomentController.swift`：真实后台作者到 H5，本地作者显式留在原生资料页。
- `XunSugarRosterbrownButterDrizzle.swift`：仍可到达的原生关系行使用真实用户 ID 与可选 IM 账号打开 H5 用户页。
- `LmnTasterCardController.swift`：远程聊天使用 H5 会话/用户入口，本地人物构造器不猜远程 ID。
- `BrostingmellowCoconutEssence.swift`、`NmFrostingmuralSignalController.swift`：两个既有活动钱包按钮打开 H5 钻石页，保留返回刷新。
- `scripts/verify_wevv_h5_entries.py`：执行真实 Swift URL 生成器，并交给 dist 的实际 JS 入口验证器校验。
- `scripts/verify_wevv_h5_navigation.py`：抽取实际 Swift 导航和关闭方法，验证门禁、隔离、动画顺序与回调次数。
- `scripts/verify_wevv_native_integration.py`：更新真实远程聊天接线守卫，其余原生兼容验证保留。
- `WevV_API_MIGRATION.md`：记录当前路由范围、数据边界、验证结果和待验收项目。

本轮验证：27 个合法入口通过真实 dist 校验，74 个非法原生输入被拒绝，13 个未公开/不完整 H5 地址被拒绝；26 项实际 Swift 导航/退出检查通过。原生接线 32 场景及 11 项源码守卫通过，宿主完整 1,174 文件还原/Hash、损坏拒绝与 close 握手回归通过。最终 Debug iOS Simulator 构建成功，只有无 AppIntents 依赖的系统元数据提示。最终构建已安装到此前 iPhone 17 模拟器（B35DAB5E-225E-46CF-939B-ACCF625E3770），未清数据、代登录或发起购买。本轮未重做正式账号消息/媒体/购买或大小屏键盘视觉验收。

验收步骤：游客点击受保护入口应仍出现欢迎页；正式登录后依次打开消息、作者/房主、关注/粉丝、黑名单、编辑与充值。H5 内部跳转使用同一容器，根返回关闭并恢复原生页面；编辑/关注/拉黑/购买后核对原生资料或余额同步。再检查前后台、重复进入、账号变化、键盘与大小屏 SafeArea，以及支付取消、迟到交易和补单。用户已选择稍后自行验证正式账号；构建和离线合同通过不代表上述线上写操作、真实消息收发、媒体或购买验收完成。

## 直播间 H5 配置故障修复

用户截图的顶部 “The app configuration is unavailable” 是 H5 初始化配置失败。正式切换时将原生的 `environment`、`bootstrapBaseUrl`、`bootstrapAppId` 放入了 H5 Profile；交付 SDK2 的真实 Zod 验证器对 `services` 使用严格对象，仅接受 `apiBaseUrl` 和 `apiClient`，因此在 Bridge/房间请求之前拒绝加载。185/965/7 混淆表本身兼容。

已将三个原生字段移到资源 manifest 的 `nativeRouting`。H5 Profile 恢复严格双字段结构；原生薄配置和完整 H5 的两个配置文件仍逐字节一致。原生加载器验证 manifest 后注入路由元数据。该次修复时启动仍用 12211334；此处仅记录当时的修复原因，当前启动和域名已按文首新合同替换。

本次修复文件：

- `WevSweetgd/WevSweetgd/WevVGlazeNetworkFoundation.swift`：通过独立原生路由参数构建 Profile，禁止向 H5 Profile 混入原生字段。
- `WevSweetgd/WevSweetgd/WevVGlazeBundleConfiguration.swift`：验证并注入 manifest.nativeRouting，检查环境一致。
- `scripts/wevv_room_bundle.py`、`scripts/test_wevv_room_bundle.py`：打包时分离原生元数据与 H5 配置，拒绝不符合 H5 的 services 结构。
- `scripts/verify_wevv_bundle_configuration.py`：新增清洁 Profile/原生路由、损坏/混合元数据的实际 Swift 回归。
- `scripts/verify_wevv_h5_configuration.py`：执行实际交付 index.html 中的 Zod、parseAppConfig、parseOpiProfile 和动态 Profile 加载器；复现旧包失败并验证修复，避免仅凭原生解密/构建通过判断 H5 可运行。
- `WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data`、`vanillaBeanIcingSdk2Network.data`、`vanillaBeanIcingSdk2.manifest.json`：重新封装并更新版本/完整性。
- `WevV_API_MIGRATION.md`：记录原因、修复与实际验证范围。

修复资源已通过实际 H5 解析/加载 15 项、原生薄配置 101 个合成案例加实际资源、归档 15 项、网络和 18 个会话场景，以及最终无签名 Simulator 构建。已安装到用户截图所在的 iPhone 17，原生列表正常；当前进入入口显示未登录欢迎页。用户明确选择稍后自行登录验证，因此完整正式账号的房间进入、退出及音视频运行尚未验收，不将构建/解析器通过写成房间整链成功。

## 当前配置与启动流程

- 正式业务域名：`https://getaway.wevvstream.online`；正式业务 App ID：`39114002`。
- 固定启动地址为同一新域名，混淆路径 `/sugary9/crumb/voice`，查询字段 `treatWarmDelight`，值 `39114002`。不再请求测试启动 ID。
- manifest 的 `nativeRouting.bootstrapAppId` 与 Profile 的 `services.apiClient.appId` 分别保存启动 ID、业务 ID；manifest/nativeRouting 的 `environment=production`。H5 Profile 仅含其 SDK 接受的字段。启动 GET 及回包身份核验只使用启动 ID。
- 使用新启动混淆字段校验 App ID、目标、版本、HTTPS 业务地址及布尔开关，再调用该正式路由的 Open。保留普通正式路由的域名一致检查；启动失败仍报错重试，不绕过启动、不回旧业务域名。
- 后续 Open、登录/注册、刷新、OPI/SAPI Header、H5 context、原生充值和交易归属均使用正式业务 ID。SAPI/IM/RTC/WebSocket 参数仍从正式 Open 读取，不复用测试 AES，也不把 OPI AES 当成 SAPI AES。
- 新 `opi-profile.txt` 为仅含 aliases 的严格 JSON，185 条路径、965 个字段、7 个 Header；已与正式连接参数组装成完整 schema 1 Profile。SDK2 schema 18、Host 1.3、已知 OPI 封装 revision 2 保留；未凭映射数量猜测新协议版本。
- 正式会话范围为 `production|39114002|https://getaway.wevvstream.online`。旧域名和测试凭据、未结交易保留在原范围，新范围不会读取或代为确认；稳定设备号和本地店铺、活动、签到、协议偏好保留。

## 本轮修改文件与用途

- `WevSweetgd/WevSweetgd/WevVGlazeNetworkFoundation.swift`：独立启动地址/ID、正式环境标记、显式双 ID 规则及普通正式路由域名校验；错误提示改为中性文案。
- `WevSweetgd/WevSweetgd/WevVGlazeRuntime.swift`：从 Profile 选择环境范围，使用正式业务 ID 管理会话与 H5 上下文。
- `WevSweetgd/WevSweetgd/WevVGlazeBundleConfiguration.swift`：验证 manifest/Profile 的实际 App ID、新映射计数及原生环境/路由，保留解密、哈希、文件和版本一致检查。
- `WevSweetgd/WevSweetgd/WevVGlazeServiceAvailability.swift`：原有缺少接口的提示去掉“test”措辞，功能合同边界保持不变。
- `WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data`：完整正式 H5 加密资源。
- `WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2Network.data`：与完整包字节一致的正式薄配置资源。
- `WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.manifest.json`：正式环境、App ID、映射计数、内容版本及完整性记录。
- `scripts/wevv_room_bundle.py`：支持裸 aliases + 仓库外私有连接 JSON，保留原 JS 全局名/标记和资源加密链，避免手工改混淆表。
- `scripts/test_wevv_room_bundle.py`：新增正式裸映射打包、双 ID、包装保留及环境混包回归。
- `scripts/WevVGlazeNetworkVerification.swift`：正式路由/双 ID/业务 Header/错误回包/404 不回退等离线验证。
- `scripts/verify_wevv_session_runtime.py`：正式与测试隔离、正式业务身份和 H5 context 回归。
- `scripts/verify_wevv_bundle_configuration.py`：正式 185/965/7 映射、混包和损坏配置校验；实际资源期望 App ID 不再绑定测试项目。
- `WevV_API_MIGRATION.md`：本次配置、证据、验证步骤和此前记录。

Downloads 原始 dist、新旧 Profile 和旧 `vanillaBeanIcing.data` 未修改。仓库内没有新增正式 AES 明文配置文件；私有输入仅在仓库外使用，资源包 AES 沿用原生资源链，与接口 AES 独立。

## 先前正式域名验证结果（历史证据）

- 使用实际 Swift NetworkFoundation 和新薄包 Profile 只读联调成功：固定启动查询 ID=12211334 → 正式 OPI host=opi.mbolw89a.link、业务 ID=39114002 → Open 成功且 runtimeConfig 所需字段完整；Open 未签发账号凭据。
- 原生/完整 H5 的 Profile 与 app-config 字节一致，新 aliases 与用户文件完全一致。
- 完整包 1,174 文件逐项长度/SHA 与源码还原通过，Downloads 托管资源未改变。完整密文 39277600 字节、薄包 15408 字节；内容版本 `sdk2-fb6c4ef2e1afce8523c13d88d71462a977007b3064b3c49f1237163a9bd73e08`。
- 归档回归 15 项通过；原生薄配置 101 个合成案例及 1 个实际正式包验证通过，实际 H5 解析/动态加载 15 项通过；网络合同、18 个会话场景及 32 个原生接线场景通过。
- 最终无签名 Debug iOS Simulator 构建通过；构建包中的三份正式资源须与仓库一致。仅有无 AppIntents 依赖的系统元数据提取提示。
- 正式切换初轮只读核验未启动 App；本次 H5 修复已在用户 iPhone 17 模拟器安装运行并查看原生列表。未代用户执行正式账号登录/注册、上传、发帖、充值或购买；用户选择稍后自行完成登录后的房间整链验收。无 UI 约束修改，本轮未重做大小屏和键盘视觉验收。

## 重复打包与验证

私有连接 JSON 放在仓库外，包含 `environment`、`apiBaseUrl`、`bootstrapBaseUrl`、`bootstrapAppId`、`appId`、`encryptionKey`、`encryptionIv`；环境为 production，启动 ID 与业务 ID 如上，其余 AES 值使用用户给出的正式参数。不要将该私有文件或完整内容输出到日志/提交到仓库。

```sh
python3 scripts/wevv_room_bundle.py pack --dist /Users/linqian/Downloads/dist --profile /Users/linqian/Downloads/opi-profile.txt --connection-config /path/to/private/connection.json --output WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data --host-version 1.3
python3 scripts/wevv_room_bundle.py verify --bundle WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data --dist /Users/linqian/Downloads/dist --profile /Users/linqian/Downloads/opi-profile.txt --connection-config /path/to/private/connection.json --native
python3 scripts/verify_wevv_bundle_configuration.py --actual
python3 scripts/verify_wevv_h5_configuration.py
python3 -m unittest discover -s scripts -p 'test_wevv_room_bundle.py' -v
python3 scripts/verify_wevv_network_foundation.py
python3 scripts/verify_wevv_session_runtime.py
python3 scripts/verify_wevv_native_integration.py
python3 scripts/verify_wevv_h5_entries.py
python3 scripts/verify_wevv_h5_navigation.py
xcodebuild -project WevSweetgd/WevSweetgd.xcodeproj -scheme WevSweetgd -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/wevv-production-build CODE_SIGNING_ALLOWED=NO build
```

设备验收顺序：新域名启动查询 39114002 → Open/列表使用新正式域名和同一业务 ID → 游客受保护动作进入原欢迎页 → 使用正式账号登录 → 退出/重启恢复 → 原生列表进入 H5 二级页/房间 → 返回/重进 → StoreKit 沙盒和补单。核对旧域名/测试账号不被当作新范围登录，旧范围交易不被当前范围交付。调试信息仅记录公共 ID/域名/状态，禁止输出凭据、AES 或私有响应。

<details>
<summary>此前测试环境 SDK2 接入记录（历史证据）</summary>

# WevV 测试环境 SDK2 接入记录

更新：2026-10-27。以下为当前实现和验证结果；末尾保留接入前基线，历史快照不代表当前运行状态。所有新配置均为用户确认的统一测试环境，无旧 Cover 线上回退。

## 本轮范围与现状

已接入测试启动路由/Open、邮箱登录注册与续期、原生直播/语聊列表、schema 18 SDK2 房间容器和 StoreKit 交易箱。本轮同时补齐动态、社交关系、图片上传及原生充值的新版接口接线。保留原生页面布局、组件、登录欢迎页、EULA、主 Tab 和既有入口；不将其他原生二级页替换成 H5，也未启用预加载。

`fullFeaturesEnabled` 透传给 H5 控制合同列明的运营能力；false 不会禁用整个直播/语聊入口。新环境缺少可靠合同的旧功能明确失败，不猜接口、不发送旧混淆路径、不回旧商业后台；这是本轮范围边界，不代表所有其他业务接口均已迁移。

## 本轮补查与修复

问题原因是旧原生调用没有全部迁移，而不只是替换域名：旧 Transport 会在本地拒绝不支持的旧路径；Discover 又过滤了没有图片的动态。对照最新 Profile、测试 OpenAPI 的 266 条路径和旧功能清单完成逐项核对后，已处理如下接线：

- 动态：改用真实 Feed 的 `cursorId/size`，保留纯文字；详情使用可见 Feed 内容和真实评论组成，点赞、取消点赞、评论、回复使用新版字段。关注页过滤实际 Feed 的关注标志，不伪造一个后端没有的 FOLLOW 请求。
- 发布：先读发布开关，图片经新 OSS 签名上传与图片检查后提交；业务码 2066 表示已进入审核，正常反馈待审核，避免再次发布。
- 社交：接通个人名片、好友/粉丝/关注、拉黑名单、关注/取关、拉黑/解除及针对明确用户的举报。聊天权限未知和互关未知保留为未知；新名片不含累计获赞数，原位置显示“—”，不把缺失值当作真实 0；举报动态时提交真实作者及 Post 上下文，不冒充专用动态举报接口。
- 上传：沿用选择图片及编辑页面，改用 `user/ossParam` 和 OSS multipart，不附带 OPI 凭据到 OSS，不发送旧上传完成路径。
- 列表与会话：房间和动态独立加载；同一账号刷新失败保留上次成功数据，真实空列表正常清空；主页、语聊、Discover 共用原有下拉重试；换号立即清理旧数据，发布、头像上传、资料保存和列表回包核对账号/环境/会话版本。关注任务在换号时立即释放；名片加载与操作任务分离，慢动态不阻断操作；旧头像下载不覆盖用户新选择。
- 原生充值：使用后台真实 Apple 套餐、业务订单、App Store receipt 和服务端余额；与 H5 共用原生持久交易箱，按订单来源分别交付，禁止按客户端钻石数量直接加余额。

用户已确认没有其他新版接口或原生 IM 约定。私信、动态收藏、账号注销、活动扣钻及短视频缺少对应合同，保留原入口并明确失败，不显示假成功、不发送旧接口、不修改本地余额或谎称账号已注销。本地店铺收藏、活动和签到记录保留。

新后台没有普通用户完整个人动态列表/专用动态详情接口。个人页目前从真实公开 Feed 有界扫描按作者筛选；详情优先使用该 Feed 的记录，并非完整历史、私密内容、已删除内容或任意深链接的权威查询。此限制须由后端补充合同后才能完全消除。

## 当前调用顺序

1. App 显示原有主模块；后台准备失败时，原有列表错误与刷新入口触发重试。
2. 从加密薄配置包验证并读取唯一 Revision 2 Profile。启动仅读约 16 KB 薄密文和版本清单，不解包约 39 MB 的完整 H5。
3. 固定测试 bootstrap GET（3 秒、无凭据、无磁盘或 HTTP 缓存）选出实际 HTTPS base URL 和开关。实际返回没有 code 包络，当前 revision=3，允许后续正整数版本。
4. 使用选中的地址调用 Open，严格校验本次 runtimeConfig；OPI 递归混淆/Hex AES 与 SAPI 原字段/Base64 AES 分别管理。
5. 按 App 和实际测试服务选择凭据 namespace，保留旧环境凭据但不读取为新登录。无正式登录时仅创建内存设备浏览会话，不写登录标记；用户敏感操作仍走原有登录拦截。
6. 邮箱登录与注册统一调用 `/_v2/auth/email/login`。邮箱 trim/lowercase；密码 6–64 位；`registered=false` 是本次新建正式账号。注册入口仅对新账号更新昵称。accessToken、refreshToken、legacyToken、IM 账号/Token 分别保存；资料接口缺少的身份从同账号会话合并。
7. OPI 原生直播列表使用真实业务房号与主播 ID。语聊列表先使用 legacyToken 换 SAPI token，再请求原始 SAPI 路径；不把 IM/RTC 房间标识当业务房号。
8. 每次房间入口重新 Open、检查/续期正式会话，再向 H5 提供完整 context；URL 只含房间路由参数，不含凭据、refreshToken 或有效期。

显式重新登录（含同一账号）增加会话版本；自动刷新不增加。请求在挂起前后核对环境和会话版本，旧 401 还核对本次凭据，避免迟到响应清掉新登录。退出先清本地当前环境会话，再独立撤销捕获的旧 Token；本地店铺、活动、签到和协议偏好保留。

## 房间宿主与退出

- 使用 `vanillaBeanIcingSdk2.data`，WVVROOM1 → 两层 zlib → AES 的逆序还原；逐文件长度/SHA、内容版本、App/Profile/Host 版本全部校验。每个实例在版本目录下使用独立 UUID 子目录，完整加载范围覆盖整个包。
- SDK2 默认 `sdkBridge` / `__SDK_BRIDGE_RECEIVE__`；五方法及 context 字段按包配置映射。只接受当前本地包主 frame，ID 去重、一次回包、截止时间与取消都受控。
- 直播路由 `/live/room/:id?hostId=...`；语聊 `/party/room/:id`。原生仅打开既有房间入口，不替换其他二级页。
- H5 主动 host.close：H5 已释放后，原生先 ACK，再动画退出并销毁。target=1 清登录并展示原有欢迎页，重新登录必须创建新 WebView。
- 原生返回/退出：发 back 或 close；close 必须收到 `released:true` 才退出。缺省、false、类型错误、超时均保留容器并允许重试。
- 初始关闭侧滑；target=1 为 Web 历史，target=2 为确认后释放并退出。第二个并发容器不会创建另一套房间连接。
- 错误重试不能绕过活进程的释放；WebContent 已终止可新建实例和 fresh Open。60 秒内最多自动重建两次，其后保留错误重试。
- 通过 visibilityChanged/contextChanged 同步可见性和新上下文；付款或错误弹框遮挡时同步可见性。房间由 H5 独占 IM/RTC；现原生工程没有另一个真实 IM/RTC 客户端连接。保留全屏、透明 WebView、包内背景与 TabBar 隐藏/恢复规则。
- 麦克风/相机由系统授权状态及受信任主 frame 控制；已保留用途说明并增加音频后台模式。

## 交易归属与补单

H5 创建业务订单，原生仅执行系统购买。买前将 orderCode/productId/owner/App/环境与 appAccountToken 原子保存；交易更新按该持久上下文归属，不依赖当前 WebView 或当前登录账号。宿主回包前再次核对原账号与会话版本。

交易箱位于独立 Application Support 私有目录，0700/0600、禁备份、Data Protection 和原子持久化。保存 Base64 App Store receipt/真实交易号后才 finish；不得将 StoreKit2 JWS 冒充 receipt。保存失败则保留 unfinished。服务端交付后由 H5 ACK 清理收据，保留幂等记录防止重复到账/重新出现。支持取消、pending、迟到交易、重启/首次解锁恢复、重复回调、账号/App/环境隔离、exclude、每批 20 笔及收据总长度上限。

原生充值页调用 `rechargeList`，只显示明确 Apple 渠道的真实 batchNo；当前 12 条目录记录中有 2 个 Apple 套餐。购买前调用 `createOrder` 并持久保存原生订单归属；购买材料交付到 `verifyIosPurchase`，确认交付后刷新真实资料余额再 ACK。原生订单和 H5 订单分别交付，原生补单不会抢先确认 H5 订单。保留原套餐卡片样式，按真实返回条目绑定；商品临时未就绪可再次点击准备，目录请求失败可下拉重试。旧 StoreKit observer 不得抢先 finish SDK2 交易。

购买异常不再统一停留在 pending：明确拒绝持久为 failed，可在核对原交易后重试；实际 Ask to Buy 保留 pending；网络/系统未知结果与旧 submitted 状态保留原 appAccountToken 并返回明确不可确认错误，不能据空交易列表再次扣款。迟到更新仍可按原 token 捕获交付。仅原生用户再次点击购买时可请求 App Store 同步，后台补单与 H5 默认不弹系统认证。依据：[Apple AppStore.sync](https://developer.apple.com/documentation/storekit/appstore/sync())、[Transaction.unfinished](https://developer.apple.com/documentation/storekit/transaction/unfinished)、[消耗品历史限制](https://developer.apple.com/documentation/BundleResources/Information-Property-List/SKIncludeConsumableInAppPurchaseHistory)。

当前测试后台为 TRUST_CLIENT 临时到账模式，不能等同生产商店服务端验单。本轮未发起真实购买，不把离线测试或模拟器交易箱测试记为支付验收。

## 文件清单

原生流程：

- `WevSweetgd/WevSweetgd/kettleGlazeSequence.swift`：凭据/登录响应、资料合并、已有 Repository/Transport 适配、业务房号入口模型。
- `WevSweetgd/WevSweetgd/WevVGlazeRuntime.swift`：启动、Open、正式/浏览会话、续期、SAPI 换票、H5 context 与迟到回包隔离。
- `WevSweetgd/WevSweetgd/WevVGlazeNetworkFoundation.swift`：Profile、路由、OPI/SAPI codec、Header 和严格响应。
- `WevSweetgd/WevSweetgd/WevVGlazeBundleConfiguration.swift`：薄配置解密、版本及完整性检查。
- `WevSweetgd/WevSweetgd/WevVGlazeRoomMapper.swift`：直播/语聊语义字段映射与不同 ID 的边界。
- `WevSweetgd/WevSweetgd/DoughRingTasterProfile.swift`、`glazeGalleryGuide.swift`：复用现有安全持久化，新增环境 namespace、撤销保护和会话版本。
- `WevSweetgd/WevSweetgd/UKGlazeActortroller.swift`：新版宿主、五方法、释放握手、可见性、权限与进程恢复。
- `WevSweetgd/WevSweetgd/WevVGlazePurchaseCoordinator.swift`：独立购买与持久补单。
- `WevSweetgd/WevSweetgd/WevVGlazeCommunityService.swift`：真实动态、评论、互动、发布开关与审核结果。
- `WevSweetgd/WevSweetgd/WevVGlazeSocialService.swift`：名片、关系、黑名单和明确对象的举报。
- `WevSweetgd/WevSweetgd/WevVGlazeMediaTransfer.swift`：新 OSS 签名与 multipart 图片上传。
- `WevSweetgd/WevSweetgd/WevVGlazeNativeRechargeService.swift`：真实 Apple 套餐/订单/验单及独立原生交付日记。
- `WevSweetgd/WevSweetgd/WevVGlazeServiceAvailability.swift`：缺少合同的功能返回明确失败。
- `WevSweetgd/WevSweetgd/TvVDonutcreamapricotFillinger.swift`：第三模块接真实动态、保留文字内容、独立加载与换号清理。
- `WevSweetgd/WevSweetgd/LmnTasterCardController.swift`：名片和动态独立加载、权限未知态及迟到回包保护。
- `WevSweetgd/WevSweetgd/CreamRingDellController.swift`、`SugarMomentEbuController.swift`：上传/资料/发布多阶段账号检查，正确反馈待审核。
- `WevSweetgd/WevSweetgd/WevVGlazeApplication.swift`：App 启动恢复交易监听。
- `WevSweetgd/WevSweetgd/GDonutdenCrumbCenterler.swift`、`DrawcreamScoutSugarStyle.swift`：充值页绑定真实目录与原生订单服务，旧 observer 归属保护，未更改布局样式。
- `WevSweetgd/WevSweetgd/Info.plist`：增加音频后台模式，保留原权限说明和其他设置。

资源：`vanillaBeanIcingSdk2.data`、`vanillaBeanIcingSdk2Network.data`、`vanillaBeanIcingSdk2.manifest.json`（均在原生源码目录）。完整包 1,174 个文件，39,277,680 字节密文，49,221,578 字节还原内容；薄包 15,824 字节。当前资源标记 integrated，内容版本 `sdk2-c0315d5783788de051428ab032b24c9bfa03fbc59964a3714ac1d86acf51a3b5`。Downloads 原始资料与旧 `vanillaBeanIcing.data` 保持字节一致。

工具：`scripts/wevv_room_bundle.py`、`test_wevv_room_bundle.py`、`test_wevv_sdk2_host.py`、`WevVGlazeNetworkVerification.swift`、`verify_wevv_network_foundation.py`、`verify_wevv_session_runtime.py`、`verify_wevv_purchase_coordinator.py`、`test_wevv_room_mapper.py`、`verify_wevv_bundle_configuration.py`、`scripts/.gitignore`。

本轮新增/补充验证文件：

- `scripts/verify_wevv_community_service.py`：Feed/评论/发布审核、官方动态边界及准备期间换号。
- `scripts/verify_wevv_social_service.py`：名片/关系/举报真实字段与完整分页。
- `scripts/verify_wevv_media_transfer.py`：OSS 签名、multipart、目录规则、图片与账号校验。
- `scripts/verify_wevv_native_recharge.py`：Apple 套餐/订单/收据、真实余额及原生/H5 交付隔离。
- `scripts/verify_wevv_native_integration.py`：Repository 与控制器实际数据方法、独立加载、失败保留和换号回包。
- `scripts/verify_wevv_purchase_retry.py`：实际 StoreKit 编排方法的拒绝/待批准/未知错误/迟到/对账恢复。
- `scripts/verify_wevv_purchase_coordinator.py`、`scripts/verify_wevv_session_runtime.py`：原有交易箱和会话回归，补充新增边界及依赖。
- `WevV_API_MIGRATION.md`：当前修复、缺失合同、验证证据、限制和复现步骤。

## 已完成验证与明确限制

- 无签名 Debug iOS Simulator 构建通过；构建后的三份 SDK2 资源与仓库对应文件逐字节一致，Host 版本为 1.3。
- 实际测试后台 bootstrap/Open/设备浏览会话/OPI 直播列表/SAPI 换票/语聊及关注列表通过：直播 3、语聊 3、关注 0。仅使用独立技术测试设备号，不输出 Token、个人资料或密钥。
- 使用实际 NetworkFoundation/Community/Social/NativeRecharge 服务只读联调通过：Feed 9 条（6 条图片、3 条纯文字），可见详情和评论 3 条，名片、关系、黑名单、发布开关及 OSS 签名均可解析；目录 12 条中正确解出 2 个 Apple 套餐。该独立技术账号的好友/粉丝/关注/黑名单确实为空。未执行发布、点赞、关注、举报、图片上传、创单或购买。
- 本轮离线实际源码验证通过：社交 46 例、上传 39 例、原生接线 32 例及 11 组接线检查；动态服务与充值服务合同/错误/隔离场景通过，原有 15 个会话场景仍通过。动态单次请求及点赞/评论的跨步骤准备同样覆盖中途换号，旧账号动作不得借新账号发出。
- iPhone 17 Pro 已安装运行，原生主页和语聊页显示测试数据；游客点击房间仍走原有欢迎页并显示 EULA。没有替用户接受协议，正式登录后房间音视频尚未做整链运行验收。
- 本轮模拟器实际 Discover 已显示真实测试动态与用户入口，保留原布局。两次启动曾收到 HTTP 502；随后同机独立临时探针用相同薄包、ATS 和真实 Foundation 的 shared/ephemeral 会话均成功，原始路由 HTTP 200，App 重启后主页/Discover 恢复。配置、包和 Profile 一致；临时网关/代理异常为推断，未修改网络安全或代理设置。临时探针已卸载。
- 归档 14 项异常/确定性测试通过；实际生产 Swift 完整还原 1,174 文件，逐文件长度/SHA 及元数据校验通过。
- URLProtocol 网络合同验证、15 个会话竞态场景、房间 ID 映射与宿主关闭/截止时间检查通过。
- 薄加载器 41 个正常/损坏资源案例通过；加上实际薄包/Profile验证，共 42 项通过。
- 交易箱 macOS 44 项、实际购买/对账/capture 方法的离线恢复验证 32 项通过；此前独立 iPhone 17 测试 App 39 项通过，后者覆盖真实 iOS 禁备份属性，测试 App 已卸载。模拟器无法提供硬件 Data Protection 元数据，真机保护级别仍需实测。
- 待验收：正式账号登录/重启恢复与真实 Keychain、真实 IM/RTC 进退/切房/媒体授权、网络中断和 401 的设备整链、SE/Max SafeArea/键盘、StoreKit 沙盒取消/Ask to Buy/迟到/收据交付与真实服务端验单。本次有限模拟器运行的日志筛选未检出约束冲突或 overflow；未修改既有原生页面约束，因此不将构建通过写成全机型视觉验收。

## 可重复验证

```sh
python3 scripts/wevv_room_bundle.py pack --dist /Users/linqian/Downloads/dist --profile '/Users/linqian/Downloads/生产test项目-前端对接资料-12211334 2/opi-profile-12211334.js' --output WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data --host-version 1.3
python3 scripts/wevv_room_bundle.py verify --bundle WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data --dist /Users/linqian/Downloads/dist --profile '/Users/linqian/Downloads/生产test项目-前端对接资料-12211334 2/opi-profile-12211334.js' --native
python3 -m unittest discover -s scripts -p 'test_wevv_room_bundle.py' -v
python3 scripts/test_wevv_sdk2_host.py
python3 scripts/verify_wevv_network_foundation.py
python3 scripts/verify_wevv_session_runtime.py
python3 scripts/test_wevv_room_mapper.py
python3 scripts/verify_wevv_bundle_configuration.py
python3 scripts/verify_wevv_purchase_coordinator.py
python3 scripts/verify_wevv_purchase_retry.py
python3 scripts/verify_wevv_community_service.py
python3 scripts/verify_wevv_social_service.py
python3 scripts/verify_wevv_media_transfer.py
python3 scripts/verify_wevv_native_recharge.py
python3 scripts/verify_wevv_native_integration.py
# 指定已有启动的测试模拟器；创建独立临时交易箱测试App并在结束后卸载：
python3 scripts/verify_wevv_purchase_coordinator.py --simulator <UDID>
xcodebuild -project WevSweetgd/WevSweetgd.xcodeproj -scheme WevSweetgd -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/wevv-h5-stage-build CODE_SIGNING_ALLOWED=NO build
```

设备黑盒验收顺序：游客浏览→受保护动作登录→邮箱登录/新建账号→杀进程恢复→资料/余额刷新→直播与语聊进入/退出/重进→原生返回/取消侧滑/切房→前后台/权限拒绝/断网/401/进程终止→StoreKit 沙盒及补单。每个失败场景都应核对当前账号、TabBar、残留音频/IM 连接和控制台，不继续扩展其他 H5 二级页或预加载。

本轮原生补接的快速回归步骤：

1. 游客启动后进入第三个 Discover Tab，核对后台实际 Feed 的图片和纯文字都能出现；网络失败下拉重试，同一账号已有内容不应被清空成“无数据”。9 条是本次只读观测值，不是客户端固定数量。
2. 打开动态作者名片、返回，核对原有 TabBar 隐藏/恢复；模拟个人动态慢请求，名片应先显示，关注操作不被慢列表占用。换号时旧列表/旧头像及迟到操作错误不能覆盖新账号。
3. 登录后分别试点赞/取消、评论/一级回复、关注/取关、拉黑/解除及用户举报，核对后端真实状态；游客受保护动作仍先进入原欢迎页。写接口本次仅用离线合同验证，未代替用户发出上述业务动作。
4. 选择图片后发布、编辑头像后保存，在上传中换号应取消后续写入；待审核码 2066 应提示已提交审核并退出发布流程，不重复提交。慢旧头像下载不得盖过新选择。
5. 充值页读取真实 Apple 套餐；商品准备暂时失败后点击原卡片重试，目录失败时下拉重试。后续使用 StoreKit 沙盒验收取消、Ask to Buy、交易迟到、重启补单、重复回调、余额刷新失败后重试和原生/H5 订单分别 ACK；不能将本次离线测试视为实际购买验收。
6. 私信、动态收藏、注销和活动扣钻均应显示明确暂不支持；不得显示消息发送/收藏成功、修改余额、清除登录并谎称已注销。其他本地记录保持原样。

<details>
<summary>接入前基线（历史快照）</summary>

# WevV 测试环境接入基线与首轮范围

核对日期：2026-10-27。以当前 Swift 代码与本次交付资料为准。代码中已有请求，只代表已有实现，不代表已通过本次测试环境联调。本文更正旧文档中将旧接口迁移、`room-dist.bundle` 和服务端真实验单标为已完成的描述。

## 1. 范围与依据

- 用户已确认：dist 自带 Profile 与独立 `opi-profile-12211334.js` 属于统一测试环境。说明和文件名中的“生产”措辞不改变本轮测试环境属性。
- 采用 `/Users/linqian/Downloads/生产test项目-前端对接资料-12211334 2/` 内 2026-10-27 的说明和 OPI Revision 2 Profile：167 条路径、964 个字段、7 个 Header；启动路由仍为 Revision 1。
- 新 H5 合同为 `/Users/linqian/Downloads/NATIVE_INTEGRATION.md` 和完整 `/Users/linqian/Downloads/dist/`，SDK 2.0.0、配置 schema 18。仓库 `room-shell-h5` 及 AGENTS.md 末尾的旧 URL/Bridge 示例不能替代新版合同。
- `Cover生产对接说明.md` 提供已有功能和业务行为参照；当前状态以代码为准。本文不保存密钥、密码、完整凭据或个人数据。
- **本次仅做基线盘点与资源重新封装。** 不切换环境，不启用新 H5，不调用服务器，不修改 Swift 或已有页面。
- 后续首轮目标：测试启动路由/Open、登录/续期、原生直播与语聊列表、H5 直播与语聊房。仅改变接口调用、数据映射和接入流程，保留页面布局、样式、文案、组件及现有入口。
- 其他原生二级页本轮不替换 H5、不增加入口、不启用预加载。店铺、活动挑战、签到、收藏及现有本地数据保留。

## 2. 当前流程

### 2.1 启动与游客

1. AppDelegate 启动直接返回；Scene 展示 `TvVDonutcreamapricotFillinger` 主容器，再异步恢复旧会话。
2. 主容器 `viewDidLoad` 构造页面并加载内容，不以登录成功为展示前提。
3. `filledShellSelection` 固定使用旧 Cover 域名、旧 App ID。当前没有 bootstrap 选择实际 base URL，也没有新版 Open 调用。
4. 游客读取由 Content/Social Repository 分别执行设备登录并在内存缓存 token，不写当前登录凭据。房间、点赞、发布等受保护动作仍检查 `isTasterReady`，然后展示原生欢迎页。

代码证据：`WevSweetgd/WevSweetgd/WevVGlazeApplication.swift:23`；`GimSprinkleSceneCoordinator.swift:8`；`TvVDonutcreamapricotFillinger.swift:316`、`:3186`、`:3800`；`kettleGlazeSequence.swift:738`、`:1476`、`:2440`。

### 2.2 登录、注册与恢复

- `UBakerytropicalMangoEssence` 在同一原生容器切换欢迎、登录、注册。未同意 EULA 时显示协议；勾选/同意双向绑定现有 UserDefaults 键。
- 登录校验邮箱和密码非空；注册校验昵称、邮箱格式、密码至少 6 位、确认密码一致，然后执行旧注册及资料更新。
- Session Repository 保存 user ID、邮箱、access/refresh token、过期时间及资料完成标记；加载当前资料后通知主页并关闭欢迎页。资料获取失败会清理新凭据。
- 冷启动恢复持久凭据；refresh 不可用则清理，access 临期先刷新。Transport 合并刷新任务，鉴权失败最多刷新重试一次。
- 当前没有本地密码/注册账号字典作为登录成功分支。AGENTS.md 的本地闭环要求与现服务端实现存在差异，后续迁移不能误报已满足固定本地账号准入。

证据：`UBakerytropicalMangoEssence.swift:46`、`:569`、`:586`、`:616`、`:850`；`kettleGlazeSequence.swift:8`、`:806`、`:839`、`:1042`、`:1187`、`:1257`；`DoughRingTasterProfile.swift:104`、`:142`、`:149`。

### 2.3 原生房间列表与旧容器

- 主容器通过 Content Repository 请求直播、推荐语聊、关注语聊及动态，更新现有卡片；网络房间不使用本地示例回填。
- 点击卡片按“类型:房号”查找 `pearFilling`，登录后全屏展示 `UKGlazeActortroller`，覆盖 TabBar；关闭后回原生主页。
- `pearFilling` 只有房号、类型、名称、封面等字段，**没有独立必填的直播主播业务 hostId**。新路由映射必须分别保存房号和主播 ID。
- 旧容器先检查/续期旧凭据，再还原旧资源、读配置，使用 URL 参数进入 `#/live/{roomId}` 或 `#/voice/{roomId}`。
- 旧退出直接停止 WebView、移除 handler、删除临时目录并 dismiss，没有 SDK2 `released:true` 握手及新生命周期命令。

证据：`TvVDonutcreamapricotFillinger.swift:3057`、`:3186`；`kettleGlazeSequence.swift:124`、`:1352`、`:1385`；`UKGlazeActortroller.swift:106`、`:158`、`:376`、`:492`、`:517`。

## 3. API 清单

当前普通请求经 `WevVGlazeTransport`：POST、旧字段编码、AES Hex、旧 Header、外层业务信封解密；上传另走 multipart。新接口须按最新 Profile 读取路径/字段/Header，不能只换域名。以下旧路径省略公共前缀 `/opi/e633f172`；行号除标明者外均指 `kettleGlazeSequence.swift`。新合同栏全部是待接入状态。

| 功能/所有者 | 当前旧实现 | 新合同/边界 | 代码证据 |
| --- | --- | --- | --- |
| bootstrap | 无实现，域名固定 | 独立固定路由协议，不能套 OPI | `:738` |
| Open | 无实现 | `/_v2/config/open` → Rev2 `/pastel2/diary/window`；每次 H5 入口重新请求 | `:1224` 仅检查旧会话 |
| 设备技术会话 / Content、Social | `/dipping/exploration-serving` | 新 `/_v2/auth/device/login`，补解析 legacy/IM 凭据 | `:1476`、`:2440` |
| 邮箱登录 / Session | `/visited/craftsmanship-adventure` | 新 `auth.email.login` 为邮箱密码登录/注册合流：未注册建号，已有账号校验密码；registered 表示登录前是否已有邮箱绑定 | `:1195`；交付 `opiv1.5.html` 的 auth.email.login |
| 注册 / Session | `/spirited/roasted-lists`，随后更新资料 | 保留原生注册 UI，后续接合流接口及资料更新；新 Profile 没有独立 email/register 映射，不构造旧注册路径 | `:1199`、`:1257` |
| 刷新 / Transport | `/shop/season-challenges` | 新 refresh 更新 access/refresh，保留同账号 legacy/IM，校验身份 | `:1042` |
| 当前资料/更新 / Session | `/comments/memory-cafe`、`/highlights/doughnut-laughter` | 新 user/info、user/update 已有映射；保持原生/H5 同身份 | `:1203`、`:1234` |
| 退出/注销 / Session | `/drops/cafe-outlet`、`/checkin/delicacies-batch` | 新 logout 有映射；独立注销合同未确认 | `:1242`、`:1249` |
| 直播列表 / Content | `/tray/club-colorful` | 新 anchor/online 等候选接口需核对真实合同，房号/主播 ID 分开 | `:1352` |
| 推荐/关注语聊 / Content | `/pillowy/route-plump`、`/direct/trying-launch`，仍走统一旧 Transport | 新独立 SAPI：Open→换票→原始 room/list、followed/list | `:110`、`:1385` |
| SAPI 换票 | 无独立通道/token | `/sapi/auth/v1/client/auth/exchangeToken`；legacyToken 换独立 auth_token | `:964` 为当前旧通道 |
| 动态/短视频 / Content | `/friendship/neighbors-circular`、`/dessert/sip-exploration` | 现有页面保留；后续逐项映射 | `:1421`、`:1449` |
| 动态详情/赞/收藏/评论 / Social | `/appetite/chocolate-discussion`、`/gather/dm-timeline`、`/baker/order-candied`、`/craftsmanship/memory-strawberry` | 保留原生页面；不能从新路径名称推断完整语义 | `:2199`、`:2229`、`:2234`、`:2239` |
| 回复/发布/上传 / Social、Transport | `/weekend/communityminded-tasting`、`/message/album-cup`、`oolongComplement` | 保留；后续核对上传/审核合同 | `:2246`、`:2254`、`:2272` |
| 用户动态/收藏/资料卡 / Social | `/cruller/snapshotting-review`、`/delicacy/circle-tempting`、`/treasurehunt/plate-sprinkle` | 保留原生二级页，后续确认合同 | `:2276`、`:2287`、`:2292` |
| 关系/黑名单/关注/举报 / Social | `/visit/serveware-shared`、`/venue/message-indulgent`、`/batter/sample-voices`、`/ringed/visiting-album`、`/discussion/shared-collection`、`/tried/limited-filling` | 新 Profile 有部分映射；保持登录及审核功能 | `:2319`—`:2347` |
| 会话/建会话/历史/发送/已读 / Social | `/fluffy/group-corner`、`/wishlist/sample-maple`、`/journal/checkin-comfort`、`/cruller/pretty-picnic`、`/try/map-soft` | 新 Profile 未列旧 message/* 合同；不擅自替换 H5 | `:2350`—`:2382` |
| 充值/消费 / Vault | `/dessert/enjoyment-hungry`，传 RECHARGE/CONSUME 和客户端数量 | 不是服务端真实验单；新订单/材料/ACK 未实现 | `:1315`、`:1329` |
| 店铺/活动/签到 | 本地模型与持久化 | 无已确认匹配接口，保留记录，不猜测迁移 | `DoughRingTasterProfile.swift:283`、`:406`、`:431` |

新 OPI 使用 Profile 混淆、AES Hex；SAPI 使用 Open 的独立地址/AES、原始路径/字段、请求 Base64、响应 Hex。accessToken、refreshToken、legacyToken、SAPI token、IM token 不能互换。目前只盘点，未修改 Transport。当前网络处理证据：`kettleGlazeSequence.swift:907`、`:964`、`:1101`。

## 4. 页面/路由清单

| 页面/入口 | 当前控制器及行为 | 本轮保护范围 |
| --- | --- | --- |
| 主模块/TabBar | `TvVDonutcreamapricotFillinger`，游客可见 | 保留所有一级页面及入口 |
| 欢迎/登录/注册 | `UBakerytropicalMangoEssence`；受保护动作 sheet；成功通知主页关闭 | 保留 UI/EULA/登录门槛，后续只换接口 |
| EULA/用户条款/隐私 | 欢迎页 EULA；`ZunugarPlainblackberryCreamler` 全屏条款 | 本地同意状态及返回链保留 |
| 直播房 | `UKGlazeActortroller`，旧 `#/live/{id}`，全屏 | 后续 `/live/room/:id` + hostId，本次未启用 |
| 语聊房 | 同容器，旧 `#/voice/{id}`，全屏 | 后续 `/party/room/:id`，本次未启用 |
| 用户卡片/关系 | 主容器、`LmnTasterCardController` 及原生关系页 | 不替换 H5，保留公开读取/登录保护 |
| 动态详情/发布/收藏 | `KipoDonutMomentController`、`SugarMomentEbuController`、`WevVGlazeFavoriteController` | 不替换 H5，写入仍登录保护 |
| 消息/聊天 | `LisenNoticepoplater`、`WevVGlazeMessageController` | 不替换 H5，保留原生键盘及全屏返回 |
| 充值 | `GDonutdenCrumbCenterler`；旧 H5 可弹原生充值页 | 保留页面；SDK2 支付后续接入 |
| 活动详情/参与/发布 | `BrostingmellowCoconutEssence`、`NmFrostingmuralSignalController`、`GemTastingQuestComposerController` | 保留本地记录及登录拦截 |
| 店铺详情/收藏/签到 | `IOpBakeryDetailController`、`CunBakerfvanillaBeanIcing`、`DailyDonutcherryCompote` | 保留全部本地行为 |
| 编辑资料/设置/反馈/视频通话 | `CreamRingDellController`、`DimSugarpistachioCreamCoating`、`EFlavorNoteController`、`WevVGlazeVideoDialController` | 不替换 H5、不增加入口 |

二级页面继续全屏覆盖 TabBar 并返回原页。入口证据：`TvVDonutcreamapricotFillinger.swift:3186`、`:3214`、`:3232`、`:3393`—`:3618`、`:3790`、`:3800`；聊天 `LisenNoticepoplater.swift:125`；新房间路由 `NATIVE_INTEGRATION.md:305`、`:322`。

## 5. 持久化清单

| 数据 | 当前所有者/存储/恢复行为 | 新流程要求及本轮边界 |
| --- | --- | --- |
| 显式登录凭据 | `almondPralineGlaze`→SessionStore→`glazeGalleryGuide`；真机 Keychain；refresh 有效才恢复 | 复用现工具，后续补 legacy/IM 并按 App/环境隔离 |
| 模拟器凭据例外 | `glazeGalleryGuide` 已有加密 UserDefaults 回退，无 Keychain entitlement 等场景使用 | 不能写成“始终仅存 Keychain”；本轮不改 |
| 稳定 deviceNo | 同 secure-store 工具，设备值含现项目标识；退出不删除 | 新 Open/登录/context 共用，迁移策略后续处理 |
| 当前资料/余额 | `glazeServerProfile` 内存，登录/更新/充值后从服务器资料刷新，退出置空 | 不把游客默认资料当登录成功 |
| 游客技术 token | Content/Social Repository 各自内存缓存，不写登录存储 | 与显式用户登录隔离；新授权待联调 |
| EULA/普通偏好 | 现有 UserDefaults，勾选/同意同步写入 | 保留原有键及状态 |
| 店铺收藏/活动参与/签到 | SessionStore、UserDefaults；普通退出只清登录字段，注销清理范围更广 | 本轮不删除/重置、不改变账号数据语义 |
| 本地活动/动态包、笔记、安全记录/权限标记 | SessionStore、UserDefaults；访客关系由 `VGuestSevenSweet` 按当前邮箱作用域存储 | 保留，不作为网络失败的示例回填 |
| 解包 H5 文件 | 旧容器 UUID 临时目录；关闭即删除 | 新包沿用资源链，本次不改运行解包器 |
| 新路由/Open/SAPI token | 当前没有对应新流程存储 | 路由缓存合同待统一；Open 按入口刷新，SAPI 按环境/账号隔离 |
| H5 凭据 | 旧容器读当前凭据生成初始 URL；旧 H5 清理行为未运行验证 | 新版通过 context，只在内存使用，不传 refresh token |
| 购买材料 | 充值控制器内存去重；StoreKit unfinished/updates 可枚举 | 没有 SDK2 持久交易箱/ACK；后续原生独立保存材料直至交付确认 |

证据：`DoughRingTasterProfile.swift:67`—`:158`、`:224`、`:238`、`:262`、`:268`、`:283`—`:436`；`glazeGalleryGuide.swift:60`—`:169`；`VGuestSevenSweet.swift:399`；`GDonutdenCrumbCenterler.swift:365`、`:429`。

## 6. Bridge 清单

### 6.1 当前旧 Bridge（保持活动）

配置提供 handler/receiver，默认 `roomBridge` / `__ROOM_H5_BRIDGE_RECEIVE__`。旧信封使用 protocolVersion=1、kind=command/event；原生验证 ID、时间字段、当前 room ID/type，内存去重。

| 名称 | 方向/输入 | 当前处理与失败行为 | 代码证据 |
| --- | --- | --- | --- |
| room.ready | H5→Native，房间信息 | 隐藏原生 Loading；无新版 response；无效/重复忽略 | `UKGlazeActortroller.swift:556`、`:578` |
| room.close | H5→Native，房间信息/允许的 reason | 刷新资料、直接 tearDown/dismiss；无 released 握手 | `:588`、`:517` |
| recharge.open | H5→Native，requestId/source/requiredDiamonds/房间信息 | 校验后弹原生充值页；非法值忽略 | `:592`、`:525` |
| recharge.succeeded | Native→H5，eventId/毫秒时间 | 原生充值成功回调发出；当前无 transactionId，不代表真实验单 | `:535` |

**支付现状纠正：** StoreKit 验证通过后，代码按客户端套餐 sugarCount 请求旧充值方法；后者发 RECHARGE 数量并刷新资料，没有将真实收据/交易材料提交服务器验单。去重集合仅在控制器内存，不提供 SDK2 跨重启交易箱。证据：`GDonutdenCrumbCenterler.swift:374`—`:392`、`:442`—`:466`；`kettleGlazeSequence.swift:1315`。

### 6.2 SDK2 目标（全部尚未实现）

默认 handler=sdkBridge、receiver=__SDK_BRIDGE_RECEIVE__；使用 bridge.methods/contextFields 映射。request/response 按 ID 匹配、去重；除系统购买外遵守 deadlineMs，错误仅返回标准 code。

| 方法 | 原生输入/响应责任 | 权限与失败边界 |
| --- | --- | --- |
| host.getContext | 空入参；等待本次 Open/凭据准备，回设备、实际域名、开关、Open、session/realtime 完整上下文 | 缺字段/准备失败不回残缺或旧环境数据；不传 refresh token |
| host.setNavigation | target 0/1/2，设置侧滑，回 null | 只接受合法整数；初始关闭侧滑 |
| host.close | target 0 返回原页；1 清登录并展示原生登录；先回 null 再关闭 | H5 先释放；鉴权失效销毁旧 WebView |
| payment.purchaseProduct | orderCode/ownerId/productId/purpose；等待购买结果并持久保存材料 | 校验身份和订单归属；无普通超时；取消/pending/成功分开 |
| payment.syncTransactions | ownerId、可选 ACK/排除列表；幂等 ACK 后回待确认交易 | 按账号/App/环境隔离；失败不伪装空交易箱 |

原生→H5：close 等待 released:true 后退出；visibilityChanged 传可见状态；contextChanged 在新账号/配置准备好后要求重取上下文。openEntry 属于可选预加载，本轮不启用。H5 的 OPI/SAPI 401 先释放资源再 host.close target=1，不静默续期恢复旧历史。

合同证据：`NATIVE_INTEGRATION.md:103`—`:135`、`:137`、`:189`、`:213`、`:231`、`:252`、`:277`。旧宿主没有上述方法，直接覆盖包不能完成接入。

## 7. 资源封装与版本切换

### 7.1 当前活动加载链

`vanillaBeanIcing.data`（App Bundle）→ 资源专用 AES 解密 → 两层 zlib 解压 → 自定义归档展开到 UUID 临时目录 → 读取旧配置/最低版本 → 注册旧 Bridge → loadFileURL 加载 index.html#旧路由，allowingReadAccessTo 覆盖完整临时目录。

自定义归档包含魔数和重复记录：小端 32 位路径字节数、64 位文件字节数、UTF-8 相对路径、原始内容。解包器校验长度、拒绝绝对路径和 . / ..，创建目录并要求 index.html 存在。资源 AES 与接口 AES 分开管理，不在文档或日志记录派生参数。

证据：`UKGlazeActortroller.swift:158`—`:198`、`:201`—`:335`。现有活动资源是 `.data`，不是旧文档中的 `room-dist.bundle`。

### 7.2 SDK2 包并列暂存，不启用

- 旧 `WevSweetgd/WevSweetgd/vanillaBeanIcing.data` 保持字节与运行选择不变。
- 新包已生成：`WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data`；侧车清单：`WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.manifest.json`；可重复脚本：`scripts/wevv_room_bundle.py`。
- 完整 dist 归档内采用最新独立 Rev2 Profile 替换 config/opi-profile.js；只在允许编辑的 JSON 区域将 app.appVersion 和 services.apiClient.appVersion 同步为原生 MARKETING_VERSION=1.3。Downloads 原始文件不改，不改 UI 字段。
- 清单记录原始/生效配置哈希、归档版本、SDK/schema、逐文件 SHA-256 和包哈希，供版本识别及重复验证；不记录密钥。
- **离线打包校验不等于 H5 运行接入。** 当前 SDK2 包的 build 仅含 buildId；旧 tastingBlueprint 强制解码 build.minimumHostVersion，直接替换会失败。旧凭据缺 legacy/IM，URL/信封也不兼容，必须先升级接入流程再切换活动包。

证据：`UKGlazeActortroller.swift:40`—`:67`、`:158`、`:396`；新 dist 配置 JSON；`WevSweetgd/WevSweetgd.xcodeproj/project.pbxproj:173`、`:217`。原生版本与 H5 原始 1.0 不同，因此封装内同步为 1.3，不修改工程版本。

## 8. 后续顺序与未知合同

后续顺序：测试配置/协议 → 启动路由获得实际域名和开关 → Open → 恢复显式登录或建立独立游客技术会话 → 原生真实列表 → 每次 H5 入口重新 Open/检查续期 → 完整 context/SDK2 Bridge → 房间释放/401/重建 → 支付材料及补单。各阶段验证后才能启用新包，本次只做盘点与封装。

不能推测的事项：

1. 路由缓存：新测试说明第五章要求“禁止缓存响应”，H5 2.1 要求首次保存后复用；需统一，本次不新增缓存。
2. appId Header：测试说明要求映射别名，H5 说明要求同时保留明文 appId；待确认兼容规则。
3. 旧注销/消息/部分动态操作：Profile 映射不等于完整业务合同，缺映射不能任意套旧请求。邮箱登录/注册合流语义已由交付接口文档说明，但资料完成状态、返回凭据及现有注册 UI 的数据映射仍需联调。
4. 新游客授权与技术身份转显式账号：需真实测试响应核验，设备登录不能直接显示用户已登录。
5. 直播 roomId/主播业务 ID 的新返回字段、分页、结束状态：必须按实际合同分别映射。
6. 支付：测试后台声明 TRUST_CLIENT 临时到账，真实商店服务端验单尚未连接；商品/业务订单/归属/收据/ACK 和 StoreKit 测试尚待实现。本轮不改充值页面、不购买。

## 9. 保护行为与验收记录

保持游客主模块可见、原生登录门槛、EULA 绑定、退出/重启恢复、原生/H5 用户身份与余额一致、店铺/活动/签到本地记录、二级 TabBar 返回规则、原生 SafeArea/键盘处理。新宿主未完成前旧包保持可用。

本轮已完成静态基线、本地资源封装与以下离线验证：

- 新资源完整 1,174 文件，解包文件总计 49,221,578 字节，密文包 39,277,680 字节。
- 内容版本 `sdk2-c0315d5783788de051428ab032b24c9bfa03fbc59964a3714ac1d86acf51a3b5`，状态 `staged`，明确标记 `sdk2-native-session-and-bridge-pending`。
- 包 SHA-256：`02d577623155e622ab21c1c0eaaf95e2c36c5f75960b994a6ceb13ecbd40dcb0`；清单保存每个文件的长度与 SHA-256。
- 使用从现有 `UKGlazeActortroller.swift` 提取的实际三个 Swift 解密/解压/展开函数编译运行，完整还原后逐文件一致；旧 `.data` 与 Git HEAD 字节一致。
- 无签名 Debug iOS 模拟器构建成功，App 产物同时包含旧 `.data`、新 SDK2 `.data` 和清单。首次受限沙箱构建因 Simulator 服务不可用失败，在获准的沙箱外执行同命令成功。
- 构建仍有旧 Swift 隔离警告，涉及 `UKGlazeActortroller` 的 nonisolated 字符串解码及 `DrawcreamScoutSugarStyle` 的 StoreKit observer；本次未修改这些 Swift 文件。
- 脚本 14 项测试通过：包括原生记录格式、截断/越界、路径冲突/穿越、非 UTF-8、符号链接、zlib 边界、密文破坏/错误密钥、严格 JSON、受管理资源篡改、禁止覆盖旧包、配置/版本/清单校验、失败目录清理及版本目录复用。
- 使用完整原始交付及 Rev2 Profile 在独立临时目录重复封包，密文 `.data` 与清单均逐字节一致；实际版本目录还原及再次复用通过，错误宿主版本被拒绝。构建后的三个资源文件与工作区对应文件逐字节一致。

没有执行服务器请求、登录、房间连接或购买；没有启动 App，未做模拟器/真机运行、大小屏视觉或键盘实测。构建和离线解包通过不能标成测试接口已接入或 H5 业务已验收。

可重复打包的命令（仅在归档内同步两份允许编辑的配置，不修改 Downloads）：

```sh
python3 scripts/wevv_room_bundle.py pack \
  --dist /Users/linqian/Downloads/dist \
  --profile '/Users/linqian/Downloads/生产test项目-前端对接资料-12211334 2/opi-profile-12211334.js' \
  --profile-revision 2 \
  --output WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data
```

脚本从现有原生代码读取资源专用派生输入，在内存调用 macOS CommonCrypto；不会把加密参数放入命令行或日志。依赖 Python 标准库，`--native` 额外需要当前 Xcode 的 Swift 编译器。默认从工程读取唯一 MARKETING_VERSION；原生版本变化后，旧清单校验失败，必须重新封包。

可复查资源的命令（逐文件校验并用现有原生 Swift 函数实际还原）：

```sh
python3 scripts/wevv_room_bundle.py verify \
  --bundle WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data \
  --dist /Users/linqian/Downloads/dist \
  --profile '/Users/linqian/Downloads/生产test项目-前端对接资料-12211334 2/opi-profile-12211334.js' \
  --native
```

可按内容版本解包到本地独立目录：

```sh
python3 scripts/wevv_room_bundle.py unpack \
  --bundle WevSweetgd/WevSweetgd/vanillaBeanIcingSdk2.data \
  --destination /private/tmp/wevv-room-versions
```

目标为 `<destination>/<contentVersion>`，先完整校验再从临时目录原子更名。同一版本仅在文件集合与字节一致时复用，目录混入旧文件即拒绝；不删除其他版本。这是封包工具的验证/还原能力，当前 App 仍使用旧容器的 UUID 临时目录，运行时切换和版本选择留待 SDK2 宿主阶段接入。

运行故障/格式测试：

```sh
python3 -m unittest discover -s scripts -p 'test_wevv_room_bundle.py' -v
```

后续运行验证：

1. 首装/旧会话冷启动，核对测试环境、失败重试和游客主模块展示。
2. 游客点击房间/受保护动作进入欢迎页；登录、注册、续期、退出和重启后身份一致。
3. 用真实列表验证房号/主播 ID；房间退出恢复 TabBar，无残留媒体或 IM/RTC 连接。
4. 覆盖权限拒绝、重复进入、切房、401、前后台、原生遮挡和 WebContent 进程终止。
5. 新资源完整还原、配置版本一致；损坏/不兼容包明确失败，不混用旧配置。
6. 在获准 StoreKit 测试环境覆盖取消/pending/成功、材料落盘、重启补单、账号隔离、交付确认/ACK，区分临时到账和真实验单。

</details>

</details>
