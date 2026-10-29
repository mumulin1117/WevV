# WeeNo 停用实现归档

此目录在 Xcode 中可见，但未加入 App Target，不参与 Swift 编译或资源打包。只归档当前没有调用方的实现；App 的页面入口和数据存储不变。

## 归档清单

- `Sources/GDonutdenCrumbCenterler.swift`：旧原生充值页及其专属模型。现在使用 H5 充值入口。
- `Sources/CreamRingDellController.swift`：旧原生编辑资料页。设置使用 H5 编辑资料入口。
- `Sources/LisenNoticepoplater.swift`：旧原生会话列表、聊天详情及两种 Cell。消息和私信入口使用 H5。
- `Sources/XunSugarRosterbrownButterDrizzle.swift`：从原混合文件拆出的旧关注、粉丝、黑名单列表及私有 Cell。原文件保留公共关系枚举和仍有入口的动态收藏页。
- `Sources/WevEnd/WevVGlazeNativeRechargeService.swift`：只服务于旧原生充值页的订单服务。没有更改或清理任何已保存交易数据。
- `Sources/DrawcreamScoutSugarStyle.swift`：没有调用方的旧 StoreKit 1 辅助类。现用 H5 购买及补单由 `WevVGlazePurchaseCoordinator` 执行，继续保留在 App Target。
- `Sources/BrostingmellowCoconutEssence.swift`：无入口的旧挑战详情。当前 Challenge 详情使用 `NmFrostingmuralSignalController`。
- `Sources/NertyuChoiceStackLayer.swift`：没有调用方的旧网络辅助类。
- `Resources/Assets.xcassets/wevv_notice_empty_glaze.imageset`：仅被旧原生消息列表使用的空状态图片。

共享头像、返回图标、发送图标、H5 加密资源、网络 Runtime、登录状态与当前购买协调器均未移动。初次归档时曾保留被本地动态分支引用的原生他人主页及视频通话页；随后已移除动态详情中的本地人物跳转分支。

### 动态详情兜底清理

- `Fragments/TvVDonutcreamapricotFillinger.local-detail.swift.txt`：旧示例数组、工厂方法、专属卡片和本地举报辅助，以及原详情兜底方法的源代码片段。
- `Fragments/KipoDonutMomentController.local-detail.swift.txt`：旧示例详情初始化、localAuthorKey 和本地人物页跳转片段。
- 片段按原代码保留在排除目录中，不参与编译或打包。当前详情入口只接受当前接口列表中存在且 ID 为正数的动态，否则提示 `This content is no longer available.`，不替换为其他内容。

## 校验与恢复

`manifest.json` 记录原路径、归档路径、归档原因和每个文件的 SHA-256。整文件按当前工作区内容原样移动，保留整理前的未提交修改。拆分文件的公共枚举和收藏实现仍在原文件中。

运行 `python3 scripts/verify_wevv_unused_archive.py` 检查归档内容、活动引用和 Target 排除关系；附加 DerivedData 目录参数可检查实际 Swift 编译输入。旧充值的离线回归脚本改为读取归档源码，属于历史验证，不意味着恢复 App 入口。

如需恢复，先根据 manifest 将整文件移回原路径；拆分内容需并回保留文件，避免重复类型。资源必须移回活动 Asset Catalog。恢复调用入口前重新编译并回归验证；不要直接把整个 WeeNo 加入 App Target。

## 本轮验证结果

- 使用全新 DerivedData 目录完成 Debug 模拟器构建；Swift 编译输入不含 WeeNo。
- 实际 Assets.car 中不含归档空状态图，公共返回、发送和钱包图标仍存在。
- 归档 SHA-256、活动源码类型引用、还原后的字符串引用和工程 Target 归属检查通过。
- 原生数据离线回归 88 项、H5 导航及退出检查 31 项、加载尾部两秒隐藏回归、旧充值服务离线回归通过。
- 原生数据测试同步补齐此前加载尾部新增的 deadline 状态，并将禁止延时的断言限定于数据加载；保留尾部两秒隐藏的独立验证。没有为通过测试修改 App 业务逻辑。
- 未操作真实账号、真实购买或手机上的本地数据；尚未逐页进行真机点击回归。
