# WevV API Migration Matrix

This file records the server ownership of the existing UIKit modules. Server data is authoritative. A failed request must render a loading, empty, error, or authentication-required state; it must not restore sample records from `UserDefaults`.

| Existing WevV module | Server contract | Ownership | Status |
|---|---|---|---|
| Welcome, login and registration | `/_v2/auth/email/login`, `/_v2/auth/email/register` | `WevVGlazeSessionRepository` | Integrated |
| Session restore and refresh | `/_v2/auth/token/refresh` | `WevVGlazeTransport`, `WevVGlazeSessionStore` | Integrated |
| Current profile and profile editing | `/_v2/user/info`, `/_v2/user/update` | `WevVGlazeSessionRepository` | Integrated |
| Logout and account deletion | `/_v2/auth/logout`, `/_v2/auth/account/delete` | `WevVGlazeSessionRepository` | Integrated |
| Tasting Journal feed | `/_v2/moments/feed` | `WevVGlazeContentRepository` | Integrated |
| Tasting Journal detail | `/_v2/moments/detail` | `WevVGlazeSocialRepository` | Integrated |
| Publish photo and tasting note | `/_v2/resource/upload`, `/_v2/moments/create` | `WevVGlazeSocialRepository` | Integrated |
| Short-video feed | `/_v2/short-video/feed` | `WevVGlazeContentRepository` | Contract integrated; screen wiring pending |
| Like, favorite and comment | `/_v2/moments/like`, `/_v2/moments/favorite`, `/_v2/moments/favorites`, `/_v2/moments/comment` | `WevVGlazeSocialRepository` | Integrated |
| User profile and relationships | `/_v2/user/personalCard`, `/_v2/user/relations`, `/_v2/user/followUser`, `/_v2/user/block/*` | `WevVGlazeSocialRepository` | Integrated for current user's lists |
| Report and feedback | `/_v2/moments/report` | `WevVGlazeSocialRepository` | Moment report integrated |
| Live list | `/_v2/discover/anchor/online` | `WevVGlazeContentRepository` | Integrated |
| Voice room list | `/sapi/weidou/v1/client/party/room/list`, `/sapi/weidou/v1/client/party/room/followed/list` | `WevVGlazeContentRepository` | Integrated |
| Live and voice room detail | Bundled Room H5 | `WevVGlazeRoomController` | Integrated; real-device acceptance pending |
| Conversations and messages | `/_v2/message/conversations`, `/_v2/message/get-or-create`, `/_v2/message/history`, `/_v2/message/send`, `/_v2/message/read` | `WevVGlazeSocialRepository` | Integrated for text conversations |
| Recharge and balance | `/_v2/pay/verifyIosPurchase`, `/_v2/user/diamond/consume`, `/_v2/user/info` | `WevVGlazeVaultRepository` | Integrated; StoreKit Sandbox acceptance pending |
| Donut shop shelf, local challenge and daily shop stamp | No confirmed matching WevV endpoint | None | Do not migrate by guessing |

## Persistence ownership

| Data | Owner |
|---|---|
| Access token and refresh token | Keychain through `WevvNertyuDoughSession` |
| Stable device number | Keychain through `WevvNertyuDoughSession` |
| Current user profile and diamond balance | Server, held in memory by `WevVGlazeSessionStore` |
| EULA acceptance and non-sensitive preferences | `UserDefaults` |
| Password and local account records | Not stored |
| H5 token | Memory only; regenerated for every WebView load |
| Anonymous browsing token | Memory only; created by device login and never changes the visible login state |
| Activity challenges, daily check-in and shop recommendations | Existing local WevV storage and model layer |

## Confirmed test-environment behavior

- HTTPS transport, required headers, encrypted request body, encrypted result body, and the business envelope were exercised on 2026-09-23.
- The documented fixed local review account is not accepted by the server environment. A valid server test account is required for authenticated flow verification.
- The feed endpoint returned business code `40101` without a token even though its OpenAPI header marks authorization as optional. The client therefore treats business codes `40101` through `40105` as authentication failures for authenticated requests and retries once after a coalesced refresh.
- The home feed obtains an in-memory device-login token when the visitor is signed out. Protected interactions still route to the existing welcome flow.
- Moment detail, public user cards and public user moments use the same in-memory device-login pattern while signed out. Mutations, saved posts, relationship lists and messaging still require the real signed-in session.

## Known contract boundaries

- `/_v2/user/relations` accepts only `type`; it has no target user ID. The app can therefore load the signed-in user's friends, followers and following, but it must not fabricate another user's following list.
- The API exposes a user's received-like count and individual like mutations, but no endpoint for “posts this user liked”. `/_v2/moments/favorites` is presented as Saved Posts and is not relabeled as likes.
- Chat history currently integrates documented text send/read behavior. Image and voice attachment transport remain available in the API contract but need recording/picker UI plus media acceptance testing before exposure.

## Homepage 2.0 data ownership

| Homepage block | Data source | Failure behavior |
|---|---|---|
| Shop carousel | Local `bakeryAtlas` plus supplied `wevv_shop_*_carousel` slices | Preserve the local cards; never substitute network mock data |
| Activity challenge cards | Local `donutChallenges` | Preserve participation and completion state |
| Daily check-in | Local `donutStampState` | Preserve the existing day/progress persistence |
| Live-room cards | `/_v2/discover/anchor/online` | Loading, empty, and retryable error text; no local sample rooms |
| Voice-room cards | `/sapi/weidou/v1/client/party/room/list` | Loading, empty, and retryable error text; no local sample rooms |
| Image/text moments | `/_v2/moments/feed` | Loading, empty, and retryable error text; no `donutSnapshots` fallback |
| Video moments | `/_v2/short-video/feed` | No local fallback; screen integration remains a separate slice |

## Voice-room homepage version 4

| UI block | Endpoint/field ownership | Interaction and failure behavior |
|---|---|---|
| Hot voice rooms | Recommend list: `/sapi/weidou/v1/client/party/room/list` | Horizontal scroll; tapping a room uses the existing login gate and bundled H5 room route |
| Follow category | `/sapi/weidou/v1/client/party/room/followed/list` | Button or horizontal room-list swipe selects the category; an empty server result renders an explicit empty state |
| Recommend category | `/sapi/weidou/v1/client/party/room/list` | Default category; button or horizontal room-list swipe selects the category |
| Host strip | `ownerId`, `ownerName`, `ownerAvatar` from the currently selected category | Deduplicated by owner ID and rebuilt whenever the category changes |
| Room cards | `roomName`, `ownerAvatar`, `onlineUserList`, `audienceNum`, `rangIndex` | Server content only; missing/zero ranking falls back to visible list order, never to local sample rooms |
| Room entry | `WevVGlazeRoomController` and `roomID` | Signed-out users see the existing welcome gate; signed-in users enter `#/voice/{roomId}` and the global TabBar is hidden by the full-screen route |

## Bundled Room H5 bridge

The app ships the complete `room-shell-h5/dist` as `room-dist.bundle`. Native reads the bridge names and minimum host version from the signed `config/app-config.js`, then loads `index.html` with read access limited to that bundle directory.

| Message | Direction | Required payload | Native behavior | Failure behavior |
|---|---|---|---|---|
| `room.close` | H5 → Native | `roomId`, `roomType`, `reason` | Validate protocol, command ID and current room identity; tear down the WebView and close the full-screen room | Unknown, duplicate or mismatched commands are ignored |
| `recharge.open` | H5 → Native | `requestId`, `roomId`, `roomType`, `source`, `requiredDiamonds` | Validate the payload and present `WevVDonutVaultController` | Malformed payloads and duplicate command IDs are ignored |
| `recharge.succeeded` | Native → H5 | `eventId`, `occurredAt`; optional `transactionId` | Sent only after the server verifies the Apple transaction and the native user balance refresh completes | If the H5 receiver is unavailable, no arbitrary JavaScript or native route is executed |

- Live route: `#/live/{roomId}`; voice route: `#/voice/{roomId}`.
- `token`, `userId`, `appVersion`, `deviceNo`, and optional `locale` are percent encoded for every initial load and process recovery.
- The access token is never logged or written by the room controller; H5 removes it from the visible route after initialization.
- Inline playback is enabled. Camera and microphone grants require both a trusted local-file main frame and the matching iOS system authorization.
- Navigation outside `room-dist.bundle` is rejected; API calls continue through H5 networking rather than top-level navigation.

## Reusable Codex instruction for pixel-accurate UIKit work

Use the following structure for the next Lanhu implementation request. Replace only the screen name, Lanhu version, and supplied assets; keep project vocabulary unchanged.

```text
Use $ios-app-v2-rebuild. First read AGENTS.md completely and inspect the Git worktree. Do not overwrite unrelated changes.

Target screen: <screen name>; Lanhu source: <project URL + exact page/version>. Treat that version as the sole visual source of truth. Before editing, produce:
1. a layer/measurement matrix (safe-area offsets, component frames, spacing, corner radii, font size/weight/color, image content mode);
2. a data-ownership matrix (local/API/session-only);
3. an interaction and route matrix (guest behavior, login gating, secondary-page TabBar visibility, loading/empty/error/retry states).

Implementation constraints:
- UIKit, Auto Layout and safeAreaLayoutGuide only; verify iPhone SE, 375x812 and Pro Max.
- Use supplied @2x/@3x slices directly whenever they already contain gradients, typography or icons. Do not redraw or replace those assets.
- Keep these modules local: activity challenges, daily check-in and shop recommendations.
- Load moments, video moments, voice rooms and live rooms only from their documented APIs. Do not fall back to sample arrays or UserDefaults.
- Main content remains visible while signed out. Gate protected interactions through the existing welcome/login route.
- All secondary screens hide the custom TabBar and restore it on return.
- Reuse only existing WevV names, components, colors and architecture. Do not import naming from another app.
- Implement explicit loading, empty, error and retry states, cancellation on deinit, main-thread UI updates and image reuse/caching.
- Build the app, run `git diff --check`, launch the target screen, and visually compare screenshots against Lanhu at the three required device sizes.

After the analysis, implement the screen in the same task and report modified files, data-source boundaries, routes, verification evidence and any missing assets/contracts.
```
