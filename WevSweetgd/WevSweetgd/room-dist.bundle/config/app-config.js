/**
 * Room H5 原生接入（Swift / Flutter iOS）
 *
 * 1. 将完整 dist 目录放进 App Bundle，并使用 loadFileURL 加载 index.html；
 *    allowingReadAccessTo 必须覆盖整个 dist 目录。
 * 2. 直播：index.html#/live/{roomId}?token={token}&userId={userId}&appVersion={version}&deviceNo={deviceNo}
 *    语聊：index.html#/voice/{roomId}?token={token}&userId={userId}&appVersion={version}&deviceNo={deviceNo}
 *    token、userId、appVersion、deviceNo 必填，locale 可选；appVersion 不得低于
 *    build.minimumHostVersion。所有参数必须进行 URL 编码。
 * 3. token 是不含 "Bearer " 前缀的访问 Token；userId 是该 Token 对应的当前用户 ID。
 *    H5 只在内存中使用 token 并会从地址栏移除；禁止记录或持久化 token，WebView
 *    重载时原生必须重新传入。后台返回 userId 时，H5 会校验它必须与 URL 一致。
 * 4. 加载前注册 bridge.handler。H5 -> Native 消息统一为：
 *    {protocolVersion:1,kind:"command",id,name,occurredAt,payload}。
 *    room.close payload：{roomId,roomType:"live|voice",reason:"user|ended|fatal|auth-invalid"}；
 *    recharge.open payload：{requestId,roomId,roomType,source:"live|party",requiredDiamonds}。
 *    Swift 使用 WKScriptMessageHandler；Flutter 使用同名 JavaScriptChannel，收到 room.close
 *    后由原生关闭 WebView，收到 recharge.open 后打开原生充值页。
 * 5. Native -> H5：充值成功后执行 window[bridge.receiver](message)，message 为对象或 JSON：
 *    {protocolVersion:1,kind:"event",name:"recharge.succeeded",
 *     payload:{eventId:"全局唯一",occurredAt:毫秒时间戳,transactionId:"可选"}}。
 *    H5 会去重并重新拉取用户资料/余额；前后台状态完全使用 Web 标准事件，不设生命周期桥接。
 * 6. 真机上的 localhost 指向手机自身。真机联调/上线前必须把 api.baseUrl 替换为
 *    手机可访问的 LAN 地址或 HTTPS 地址（生产必须使用 HTTPS）；HTTP 联调需配置 iOS ATS。
 *    后台须允许 Origin: null 及 Authorization、
 *    appId、appVersion、deviceNo、language、Content-Type Header。
 * 7. WKWebView/Flutter WebView 需允许内联媒体播放；语聊麦克风需配置
 *    NSMicrophoneUsageDescription 和 WebView 媒体授权。
 * 8. 签名前只修改两个 APP_CONFIG 标记之间的严格 JSON。不要修改全局变量名、标记，
 *    不要加入函数、注释或尾逗号。
 */
window.__ROOM_APP_CONFIG__ = /*__APP_CONFIG_START__*/ {
  "schemaVersion": 1,
  "build": {
    "buildId": "2026.09.13",
    "minimumHostVersion": "1.0.0"
  },
  "app": {
    "appId": "39114002",
    "documentTitle": "Live Room",
    "defaultLocale": "en"
  },
  "api": {
    "baseUrl": "https://mobileapi.wevvstream.online",
    "encryptionKey": "91b9bkaq8lbkcjcu",
    "encryptionIv": "a75ompx4wgdo9vv1",
    "timeoutMs": 15000
  },
  "theme": {
    "primary": "#FF3079",
    "secondary": "#E57EFF",
    "accent": "#A846EE"
  },
  "bridge": {
    "handler": "roomBridge",
    "receiver": "__ROOM_H5_BRIDGE_RECEIVE__",
    "commands": {
      "closeRoom": "room.close",
      "openRecharge": "recharge.open"
    },
    "events": {
      "rechargeSucceeded": "recharge.succeeded"
    }
  },
  "debug": {
    "vConsoleEnabled": false
  }
} /*__APP_CONFIG_END__*/
