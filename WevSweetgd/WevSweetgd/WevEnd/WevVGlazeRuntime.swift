import Foundation

/// Owns the selected service environment and credentials independently of individual screens/WebViews.
@MainActor
final class WevVGlazeRuntime {
    static let shared = WevVGlazeRuntime()
    private var foundation: WevVGlazeNetworkFoundation?
    private var launchTask: Task<Void, Error>?
    private var refreshTask: (key: String, task: Task<almondPralineGlaze, Error>)?
    private var guestTask: Task<almondPralineGlaze, Error>?
    private var guestSession: almondPralineGlaze?
    private var guestGeneration = 0
    private var ticket: (key: String, value: WevVGlazeSAPITicket)?
    private var ticketTask: (key: String, task: Task<WevVGlazeSAPITicket, Error>)?
    private let store = WevVGlazeSessionStore.shared
    private(set) var environmentID = ""
    private(set) var appID = ""
    var apiBaseURL: URL? { foundation?.currentRoute?.apiBaseURL }
    var fullFeaturesEnabled: Bool { foundation?.currentRoute?.fullFeaturesEnabled == true }

    private init() {}

    func prepare() async throws {
        if let launchTask { return try await launchTask.value }
        if let foundation, foundation.currentRoute != nil, foundation.currentOpen != nil, !environmentID.isEmpty { return }
        let task = Task { @MainActor in
            let network: WevVGlazeNetworkFoundation
            if let configured = self.foundation { network = configured }
            else {
                let configuration = try WevVGlazeBundleConfiguration(seed: UKGlazeActortroller.glazeArchiveConfigurationSeed,
                                                                     hostVersion: filledShellSelection.tastingJourneyAtlas)
                network = WevVGlazeNetworkFoundation(profile: configuration.profile, deviceNo: filledShellSelection.glazeQuestTrail,
                                                     hostVersion: filledShellSelection.tastingJourneyAtlas, language: filledShellSelection.flavorJourneyJournal)
                self.foundation = network
            }
            self.appID = network.profile.appID
            let route = try await network.bootstrap()
            let scope = "\(network.profile.environment)|\(network.profile.appID)|\(route.apiBaseURL.absoluteString)"
            if self.environmentID != scope {
                self.clearTransientSessions()
                self.environmentID = scope
                self.appID = network.profile.appID
                self.store.selectGlazeEnvironment(scope)
            }
            let epoch = self.store.sessionEpoch
            let saved = self.store.currentGlazeCredentials
            do {
                let opened = try await network.open(refreshToken: saved?.maplePecanCoating)
                try self.assertCurrent(epoch: epoch, scope: scope)
                if let saved { try self.acceptOpenToken(opened, previous: saved) }
            } catch {
                guard Self.isAuthenticationFailure(error), self.store.sessionEpoch == epoch else { throw error }
                self.invalidateAuthentication()
                _ = try await network.open(refreshToken: nil, force: true)
            }
        }
        launchTask = task
        do { try await task.value; launchTask = nil }
        catch { launchTask = nil; throw error }
    }

    func opi(path: String, body: Data, authenticated: Bool, explicitToken: String? = nil) async throws -> Data {
        try await prepare()
        guard let foundation else { throw WevVGlazeNetworkError.invalidConfiguration }
        let epoch = store.sessionEpoch, scope = environmentID
        let session = authenticated ? try await validSignedInSession() : nil
        try assertCurrent(epoch: epoch, scope: scope)
        do {
            let data = try await foundation.opi(path: path, body: body, accessToken: explicitToken ?? session?.brownButterGlaze)
            try assertCurrent(epoch: epoch, scope: scope)
            return data
        } catch {
            guard authenticated, Self.isAuthenticationFailure(error) else { throw error }
            try assertCurrent(epoch: epoch, scope: scope)
            let renewed: almondPralineGlaze
            if let current = store.currentGlazeCredentials, current.brownButterGlaze != session?.brownButterGlaze {
                // Another request or Open may already have replaced the rejected token.
                renewed = try await validSignedInSession()
            } else {
                renewed = try await refreshSignedInSession()
            }
            try assertCurrent(epoch: epoch, scope: scope)
            do {
                let data = try await foundation.opi(path: path, body: body, accessToken: renewed.brownButterGlaze)
                try assertCurrent(epoch: epoch, scope: scope)
                return data
            } catch {
                if Self.isAuthenticationFailure(error), isCurrent(renewed, epoch: epoch, scope: scope) { invalidateAuthentication() }
                throw error
            }
        }
    }

    func validSignedInSession() async throws -> almondPralineGlaze {
        try await prepare()
        guard store.prepareGlazeJournal(), let current = store.currentGlazeCredentials else { throw miniRingFritter.cityBakeryTrail }
        if current.citrusZestShell <= Date().addingTimeInterval(30) { return try await refreshSignedInSession() }
        return current
    }

    private func refreshSignedInSession() async throws -> almondPralineGlaze {
        guard let previous = store.currentGlazeCredentials, previous.darkCocoaDrizzle > Date(), let foundation else {
            invalidateAuthentication(); throw miniRingFritter.cityBakeryTrail
        }
        let key = "\(environmentID)|\(store.sessionEpoch)|\(previous.vanillaBeanIcing)|\(previous.maplePecanCoating)"
        if let running = refreshTask, running.key == key { return try await running.task.value }
        let epoch = store.sessionEpoch, scope = environmentID
        let task = Task { @MainActor in
            let body = try JSONSerialization.data(withJSONObject: ["refreshToken": previous.maplePecanCoating])
            let data = try await foundation.opi(path: "/_v2/auth/token/refresh", body: body)
            let response = try JSONDecoder().decode(citrusZestIcing.self, from: data)
            let next = try WevVGlazeTransport.vanillaMilkCompanion(cherryBlossomCalendar: response, saltedCaramelFinish: previous.saltedCaramelFinish, previous: previous)
            try self.assertCurrent(epoch: epoch, scope: scope)
            guard self.store.currentGlazeCredentials?.maplePecanCoating == previous.maplePecanCoating else { throw CancellationError() }
            try self.store.persistGlazeCredentials(next)
            return next
        }
        refreshTask = (key, task)
        do {
            let value = try await task.value
            if refreshTask?.key == key { refreshTask = nil }
            return value
        } catch {
            if refreshTask?.key == key { refreshTask = nil }
            if Self.isAuthenticationFailure(error), !task.isCancelled, store.sessionEpoch == epoch,
               environmentID == scope, store.currentGlazeCredentials?.maplePecanCoating == previous.maplePecanCoating { invalidateAuthentication() }
            throw error
        }
    }

    func browsingSession() async throws -> almondPralineGlaze {
        try await prepare()
        if store.isTasterReady { return try await validSignedInSession() }
        if let guestSession, guestSession.citrusZestShell > Date().addingTimeInterval(30) { return guestSession }
        if let guestTask { return try await guestTask.value }
        guard let foundation else { throw WevVGlazeNetworkError.invalidConfiguration }
        let generation = guestGeneration, epoch = store.sessionEpoch, scope = environmentID
        let task = Task { @MainActor in
            let body = try JSONSerialization.data(withJSONObject: ["deviceNo": filledShellSelection.glazeQuestTrail])
            let data = try await foundation.opi(path: "/_v2/auth/device/login", body: body)
            let response = try JSONDecoder().decode(citrusZestIcing.self, from: data)
            let credentials = try WevVGlazeTransport.vanillaMilkCompanion(cherryBlossomCalendar: response, saltedCaramelFinish: "")
            try self.assertCurrent(epoch: epoch, scope: scope)
            guard self.guestGeneration == generation else { throw CancellationError() }
            self.guestSession = credentials // Technical browsing only: never stored or published as a UI login.
            return credentials
        }
        guestTask = task
        do {
            let value = try await task.value
            if guestGeneration == generation { guestTask = nil }
            return value
        } catch {
            if guestGeneration == generation { guestTask = nil }
            throw error
        }
    }

    func browsingOPI(path: String, body: [String: Any]) async throws -> Data {
        try await prepare()
        if store.isTasterReady {
            return try await opi(path: path, body: JSONSerialization.data(withJSONObject: body), authenticated: true)
        }
        let epoch = store.sessionEpoch, scope = environmentID
        let current = try await browsingSession()
        try assertCurrent(epoch: epoch, scope: scope)
        guard let foundation else { throw WevVGlazeNetworkError.invalidConfiguration }
        do {
            let data = try await foundation.opi(path: path, body: JSONSerialization.data(withJSONObject: body), accessToken: current.brownButterGlaze)
            try assertCurrent(epoch: epoch, scope: scope)
            return data
        } catch {
            guard Self.isAuthenticationFailure(error) else { throw error }
            try assertCurrent(epoch: epoch, scope: scope)
            clearTransientSessions()
            throw error // Existing pull-to-refresh retries with a new device session.
        }
    }

    func voiceList(path: String, cursor: WevVGlazeVoiceCursor? = nil, pageSize: Int = 10) async throws -> Data {
        try await prepare()
        let epoch = store.sessionEpoch, scope = environmentID
        let current = try await browsingSession()
        try assertCurrent(epoch: epoch, scope: scope)
        guard let foundation, let opened = foundation.currentOpen else { throw WevVGlazeNetworkError.invalidConfiguration }
        let key = "\(scope)|\(epoch)|\(current.vanillaBeanIcing)|\(current.legacyToken)|\(opened.runtimeConfig.sapiBaseURL)|\(opened.runtimeConfig.sapiAesKey)|\(opened.runtimeConfig.sapiAesIv)"
        let value: WevVGlazeSAPITicket
        if let ticket, ticket.key == key, ticket.value.expiresAt > Date().addingTimeInterval(30) { value = ticket.value }
        else if let running = ticketTask, running.key == key { value = try await running.task.value }
        else {
            let task = Task { try await foundation.exchange(legacyToken: current.legacyToken) }
            ticketTask = (key, task)
            do {
                value = try await task.value
                try assertCurrent(epoch: epoch, scope: scope)
                ticket = (key, value)
                if ticketTask?.key == key { ticketTask = nil }
            } catch {
                if ticketTask?.key == key { ticketTask = nil }
                throw error
            }
        }
        try assertCurrent(epoch: epoch, scope: scope)
        // SAPI pagination follows the last raw record's score/snapshot. Its
        // offset is not the number of rooms already displayed, and the first
        // request must omit both cursor fields.
        var body: [String: Any] = ["languageCode": "", "pageSize": max(1, pageSize), "version": "v2"]
        if path == "/sapi/weidou/v1/client/party/room/followed/list" { body["languageCode"] = NSNull() }
        if let cursor {
            body["offset"] = cursor.offset
            if let snapshot = cursor.snapshotID?.trimmingCharacters(in: .whitespacesAndNewlines), !snapshot.isEmpty {
                body["snapshotId"] = snapshot
            }
        }
        do {
            let data = try await foundation.sapi(path: path, body: JSONSerialization.data(withJSONObject: body), authToken: value.tokenValue)
            try assertCurrent(epoch: epoch, scope: scope)
            return data
        } catch {
            if Self.isAuthenticationFailure(error), ticket?.key == key { ticket = nil }
            throw error
        }
    }

    func prepareH5Context() async throws -> [String: Any] {
        let previousOpenRevision = foundation?.openRevision ?? 0
        try await prepare()
        let epoch = store.sessionEpoch, scope = environmentID
        _ = try await validSignedInSession()
        try assertCurrent(epoch: epoch, scope: scope)
        guard let foundation else { throw WevVGlazeNetworkError.invalidConfiguration }
        guard let before = store.currentGlazeCredentials else { throw miniRingFritter.cityBakeryTrail }
        do {
            // Startup may have just completed this account's Open. The foundation
            // still requires the refresh-token cache key to match before reuse.
            let opened = try await foundation.open(refreshToken: before.maplePecanCoating,
                                                   force: foundation.openRevision == previousOpenRevision)
            try assertCurrent(epoch: epoch, scope: scope)
            try acceptOpenToken(opened, previous: before)
            let current = try await validSignedInSession()
            try assertCurrent(epoch: epoch, scope: scope)
            guard let route = foundation.currentRoute else { throw WevVGlazeNetworkError.invalidConfiguration }
            #if DEBUG
            WevVGlazeIMDiagnostics.contextPrepared(appID: appID, accountID: current.vanillaBeanIcing,
                                                   imAccount: current.imAccount, imTokenLength: current.imToken.utf8.count,
                                                   imTokenMatchesAccessToken: current.imToken == current.brownButterGlaze)
            #endif
            return ["deviceNo": filledShellSelection.glazeQuestTrail,
                    "apiBaseUrl": route.apiBaseURL.absoluteString,
                    "fullFeaturesEnabled": route.fullFeaturesEnabled,
                    "open": ["runtimeConfig": opened.runtimeConfig.dictionary, "cdnDomainConfig": opened.cdnDomainConfig as Any? ?? NSNull()],
                    "session": ["accountId": String(current.vanillaBeanIcing), "accessToken": current.brownButterGlaze,
                                "legacyToken": current.legacyToken, "realtime": ["imAccount": current.imAccount, "imToken": current.imToken]]]
        } catch {
            #if DEBUG
            WevVGlazeIMDiagnostics.failure(stage: .context, error: error)
            #endif
            if Self.isAuthenticationFailure(error), isCurrent(before, epoch: epoch, scope: scope) { invalidateAuthentication() }
            throw error
        }
    }

    private func acceptOpenToken(_ opened: WevVGlazeOpenContext, previous: almondPralineGlaze) throws {
        guard let token = opened.accessToken else { return }
        guard store.currentGlazeCredentials?.maplePecanCoating == previous.maplePecanCoating else { throw CancellationError() }
        let updated = almondPralineGlaze(vanillaBeanIcing: previous.vanillaBeanIcing, saltedCaramelFinish: previous.saltedCaramelFinish,
                                        brownButterGlaze: token, maplePecanCoating: previous.maplePecanCoating,
                                        citrusZestShell: Date().addingTimeInterval(TimeInterval(opened.expiresIn ?? 1800)), darkCocoaDrizzle: previous.darkCocoaDrizzle,
                                        whiteChocolateRibbon: previous.whiteChocolateRibbon, legacyToken: previous.legacyToken,
                                        imAccount: previous.imAccount, imToken: previous.imToken, environmentID: previous.environmentID, registered: previous.registered)
        try store.persistGlazeCredentials(updated)
    }

    func invalidateAuthentication() { clearTransientSessions(); store.restGlazeTaster() }
    func clearTransientSessions() {
        foundation?.clearSugarCrumbs()
        guestGeneration += 1
        guestTask?.cancel(); guestTask = nil; guestSession = nil
        refreshTask?.task.cancel(); refreshTask = nil
        ticketTask?.task.cancel(); ticketTask = nil; ticket = nil
    }

    func assertCurrent(epoch: Int, scope: String) throws {
        try Task.checkCancellation()
        guard store.sessionEpoch == epoch, environmentID == scope, store.activeEnvironmentID == scope else { throw CancellationError() }
    }

    private func isCurrent(_ credentials: almondPralineGlaze, epoch: Int, scope: String) -> Bool {
        guard !Task.isCancelled, store.sessionEpoch == epoch, environmentID == scope,
              let current = store.currentGlazeCredentials else { return false }
        return current.vanillaBeanIcing == credentials.vanillaBeanIcing
            && current.maplePecanCoating == credentials.maplePecanCoating
            && current.brownButterGlaze == credentials.brownButterGlaze
    }

    static func isAuthenticationFailure(_ error: Error) -> Bool {
        (error as? WevVGlazeNetworkError)?.isAuthenticationFailure == true || (error as? miniRingFritter).map {
            if case .cityBakeryTrail = $0 { return true }; return false
        } == true
    }
}
