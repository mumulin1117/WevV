import Foundation

/// Explicit gaps in the supplied test service, rather than a fake empty/success response.
enum glazeNameField: Error, LocalizedError, Sendable {
    case apricotFilling, blueberryCustard, blackberryCream, LmnTasterCardController, WevVGlazeVideoDialController, autumnMaplePalette
    nonisolated var errorDescription: String? {
        switch self {
        case .apricotFilling: return "Messaging is not available on the current service."
        case .blueberryCustard: return "Videos are not available on the current service."
        case .blackberryCream: return "Saved posts are not available on the current service."
        case .LmnTasterCardController: return "Account deletion is not available on the current service. Your account has not been deleted."
        case .WevVGlazeVideoDialController: return "This activity payment is not available on the current service. Your balance has not changed."
        case .autumnMaplePalette: return "This post could not be reported. Please try reporting its author instead."
        }
    }
}
