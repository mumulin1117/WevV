import Foundation

/// Explicit gaps in the supplied test service, rather than a fake empty/success response.
enum glazeNameField: Error, LocalizedError, Sendable {
    case messaging, shortVideos, savedPosts, accountDeletion, activityPayment, postReporting
    nonisolated var errorDescription: String? {
        switch self {
        case .messaging: return "Messaging is not available on the current service."
        case .shortVideos: return "Videos are not available on the current service."
        case .savedPosts: return "Saved posts are not available on the current service."
        case .accountDeletion: return "Account deletion is not available on the current service. Your account has not been deleted."
        case .activityPayment: return "This activity payment is not available on the current service. Your balance has not changed."
        case .postReporting: return "This post could not be reported. Please try reporting its author instead."
        }
    }
}
