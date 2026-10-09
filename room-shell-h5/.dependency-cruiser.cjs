module.exports = {
  forbidden: [
    {
      name: 'no-circular',
      severity: 'error',
      from: {},
      to: { circular: true },
    },
    {
      name: 'shared-does-not-import-features',
      severity: 'error',
      from: { path: '^src/shared' },
      to: { path: '^src/features' },
    },
    {
      name: 'core-does-not-import-pages',
      severity: 'error',
      from: { path: '^src/core' },
      to: { path: '^src/(main/pages|features/.+/pages)' },
    },
    {
      name: 'ui-uses-domain-queries-and-actions',
      severity: 'error',
      from: { path: '^src/(main(?:/|$)|features/.+/components|room(?:/|$))' },
      to: { path: 'repository(?:\\.ts)?$' },
    },
    {
      name: 'repositories-do-not-own-realtime-sdks',
      severity: 'error',
      from: { path: 'repository(?:\\.ts)?$' },
      to: {
        path: '^src/(features/messages/nim-session|features/party/party-heartbeat|features/rooms/live-chatroom-controller|room/runtime/rtc-room-engine)',
      },
    },
  ],
  options: {
    doNotFollow: { path: 'node_modules' },
    tsConfig: { fileName: 'tsconfig.json' },
    enhancedResolveOptions: { exportsFields: ['exports'] },
  },
}
