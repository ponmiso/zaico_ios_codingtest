import Combine

/// SwiftUI から Presenter を観測するための Adapter
@MainActor
final class InventoryCreateAdapter: ObservableObject {
    @Published var title: String = ""
    @Published var isPresentedAlert = false
    @Published var alertDetails: AlertDetails?

    private var input: InventoryCreatePresenter?
    func inject() {
        self.input = InventoryCreatePresenter(output: self)
    }
}

extension InventoryCreateAdapter {
    func didTapCreate() {
        input?.didTapCreate(title: title)
    }
}

extension InventoryCreateAdapter: InventoryCreatePresenterOutput {
    nonisolated func showAlert(alertDetails: AlertDetails) {
        Task {
            await MainActor.run {
                self.alertDetails = alertDetails
                isPresentedAlert = true
            }
        }
    }
}
