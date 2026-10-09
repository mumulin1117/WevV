# Room Shell H5

从原项目独立出的直播间 / 语聊房 H5。保留原 Vue 3 + TypeScript + Vite + Pinia 分层结构、房内组件、样式、图片、私信、礼物、排行、举报、活动以及 Agora / 云信运行时；去除了登录、首页、动态、个人中心、VIP、独立充值页和外部业务路由。

## 路由

- `#/live/:roomId`：直播间
- `#/voice/:roomId`：语聊房

必填 URL 参数为 `token`、`userId`、`appVersion`、`deviceNo`，可选参数为 `locale`。`userId` 必须是当前 Token 对应的用户 ID；完整原生协议见 `public/config/app-config.js` 顶部。

## 开发与构建

要求 Node.js `>=22.22.0`、pnpm `11.8.0`。

```bash
pnpm install
pnpm dev
pnpm test
pnpm build
```

默认后台地址是 `http://localhost:8080`。开发时可访问：

```text
http://localhost:3200/#/live/1001?token=TOKEN&userId=2001&appVersion=1.0.0&deviceNo=browser-1
http://localhost:3200/#/voice/1001?token=TOKEN&userId=2001&appVersion=1.0.0&deviceNo=browser-1
```

生产产物位于 `dist/`。原生签名前只需修改外置的 `dist/config/app-config.js`；业务 JavaScript 和 CSS 内联在 `index.html`，其他资源保持相对路径，适用于 iOS 本地文件加载。

## 关键目录

- `src/core`：请求、AES、配置、Web 生命周期、精简 Bridge
- `src/features/rooms`：直播房间领域
- `src/features/party`：语聊房领域
- `src/features/messages`：房内私信
- `src/room`：直播间容器与 RTC 运行时
- `public/assets/live-room`、`public/assets/party`：房间资源

实时 RTC / IM 结构仍保留，但沿用原项目当前策略，默认关闭；切换到新后台和正式 SDK 凭证后再单独启用。
