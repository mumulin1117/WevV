# Cover（test 项目）生产对接说明

更新日期：2026-09-16。适用 H5、iOS、Android 原生客户端。接口快照取自生产 OpenAPI；最新字段以线上接口文档为准。

## 1. 环境与项目

- API 根地址：https://mobileapi.wevvstream.online
- 项目：Cover（test 项目），appId：39114002（字符串）；不要使用 OKLiv 或 Bomvi 的 appId。
- 线上 Knife4j：https://mobileapi.wevvstream.online/doc.html
- 线上 Swagger UI：https://mobileapi.wevvstream.online/swagger-ui/index.html
- 线上 OpenAPI：https://mobileapi.wevvstream.online/v3/api-docs
- 本次对接使用原始接口路径、原始字段名；需要混淆时，另取 Cover 对应方案导出的 JSON，不要混用多套方案。

Cover 客户端 AES 配置（仅提供给本项目对接人员，不公开发布）：

```json
{"appId":"39114002","aesKey":"91b9bkaq8lbkcjcu","aesIv":"a75ompx4wgdo9vv1"}
```

以上是客户端协议配置，不是 SSH、数据库或第三方服务密钥。本文件包含该配置，请仅内部转发。

## 2. 页面分工

- 个人中心、动态、短视频、消息及直播/语聊首页：原生或 H5 直接调用后端接口。
- 直播间、语聊房二级页面：使用程亮提供的 H5；请找程亮获取页面地址、版本和跳转/桥接参数约定。
- H5 交接需确认：roomId、appId、deviceNo、appVersion、语言、登录凭证的传递方式，以及返回原生、资料卡跳转、支付唤起和退出房间事件。
- 二级 H5 URL 和桥接协议尚未在本说明中验证，不凭空约定参数；不要直接把 accessToken 拼在公开 URL 中。
- 首页拿到房间 ID 后进入对应二级 H5，不重新创建另一套房间数据。用户登录态、项目和设备号必须保持一致。

## 3. 公共请求与加解密

Header：appId=39114002；deviceNo 为稳定设备唯一号；appVersion 为客户端版本。登录后 Authorization=Bearer {accessToken}。language 可传 zh-CN/en-US 等；各接口的具体必填 Header 见内嵌文档。

App 业务接口以文档中的解密后 JSON 为业务结构。实际请求：JSON UTF-8 → AES-128-CBC → PKCS7Padding → 十六进制字符串，Body 直接传该字符串，推荐 Content-Type: text/plain。不是 Base64，也不是 JSON 外层包装。Java 的 PKCS5Padding 对 AES 对应 PKCS7。

成功响应外层：

```json
{"code":"0","message":"success","requestId":"追踪ID","result":"AES密文的十六进制字符串"}
```

仅 code 字符串为 "0" 时解密 result：Hex → AES-CBC 解密 → UTF-8 → JSON。文档响应字段是解密后的 result，不是外层响应。失败时 result 可能为空，不要解密；记录 HTTP 状态、code、message、requestId。HTTP 200 不代表业务一定成功。

## 4. 首次联调顺序

1. POST /_v2/auth/phone/login：当前测试验证码为 668810，首次手机号登录自动注册。请求 phone、verificationCode、deviceNo；Body deviceNo 必须与 Header 相同。adId 是 Adjust ID，没有就不传，不要随机造值。
2. 保存 accessToken、refreshToken 和用户信息；访问接口使用 Bearer accessToken。过期调用 /_v2/auth/token/refresh；刷新失败才重新登录，避免无限重试。
3. /_v2/user/info 获取个人资料；查询列表分页字段按各接口定义使用，不自行统一 cursor/offset。
4. 接个人中心、动态、短视频、消息；再接直播/语聊首页，最后与程亮联调二级 H5。

手机号登录的解密前业务示例：

```json
{"phone":"+8613812345678","verificationCode":"668810","deviceNo":"cover-integration-device-001"}
```

固定验证码仅是当前测试方式，不视为正式短信安全方案。使用自己的测试手机号/设备号，勿冒用用户池中的用户。

## 5. 模块与业务注意

- 个人中心：资料、关系、拉黑、等级、签到、反馈、内购。普通反馈 targetUserId 可为空；举报填写真实目标，不把自己默认当被举报人。
- 私信：/_v2/message/get-or-create 和 /_v2/message/send 要求双方互相关注；单向关注返回 4032，拉黑返回 4031。取消关注后历史可查看但不能继续发送。发送携带唯一 clientMessageId 防重；按接口分页和 events 游标获取消息。
- 动态：支持文案、图片/语音、点赞、评论、举报/拉黑；具体组合及限制以接口字段说明为准。
- 短视频：feed、detail、publish、like、评论、播放上报、举报、删除；只操作当前项目/当前用户有权限的数据。
- 首页：All 从 /_v2/discover/anchor/online 接入，Live 从 /_v2/discover/live/list 接入；语聊 Party/Follow/Recent 对应 room/list、room/followed/list、room/recent/list。地区、语言、分页及排序条件按对应请求表，不照搬其他列表。
- 上传：先 /_v2/user/ossParam 获取 OSS 签名，再按返回字段上传；业务保存最终图片/音视频 URL，签名和过期时间不可长期缓存。原生同样可以使用此上传流程。
- 苹果内购：/_v2/pay/rechargeList 读取后台商品对应关系；StoreKit 完成购买后 /_v2/pay/verifyIosPurchase 同步 productId、transactionId、payload（签名凭证）。不得仅凭客户端数量发放钻石。
- 钻石：原生与 H5 流水查询分开；/_v2/user/diamond/consume 根据 recordType 执行 H5 收支，sync 不写新流水。避免客户端和原生业务重复记账；具体行为见接口说明。
- 已返回接口不等于本次 UI 必须开放全部入口（例如真实开播、视频通话和 AI 扩展）；按产品范围选择，不因文档存在就默认开启。

## 6. 交付与验收

HTML 内嵌线上全部 App 接口（不含后台管理接口），支持模块筛选、搜索和逐接口展开。Header、请求、响应说明保持 OpenAPI 原文；接口原始定义可展开核对，JSON 快照也一并交付。

验收：Cover 数据隔离正确；登录/刷新正常；加解密正确；分页不重复；上传有效；私信互关/拉黑限制有效；购买幂等；二级 H5 登录态一致；异常保留 requestId。联调问题提供接口、时间、appId、deviceNo、HTTP/业务码及脱敏后的入参，不转发令牌或服务器密码。
