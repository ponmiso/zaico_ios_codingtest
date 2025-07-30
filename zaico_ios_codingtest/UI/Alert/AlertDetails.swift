import Foundation

struct AlertDetails: Identifiable {
    let id = UUID()
    let type: AlertType
}

enum AlertType {
    case success(String)
    case error(String)
}
