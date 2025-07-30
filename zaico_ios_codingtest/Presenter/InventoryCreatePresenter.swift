import Foundation

protocol InventoryCreatePresenterInput {
    func didTapCreate(title: String)
}

protocol InventoryCreatePresenterOutput: AnyObject {
    func showAlert(alertDetails: AlertDetails)
}

final class InventoryCreatePresenter {
    private weak var output: InventoryCreatePresenterOutput?
    private let api: InventoriesAPIProtocol
    
    init(output: InventoryCreatePresenterOutput, api: InventoriesAPIProtocol = InventoriesAPI()) {
        self.output = output
        self.api = api
    }
}

extension InventoryCreatePresenter: InventoryCreatePresenterInput {
    func didTapCreate(title: String) {
        if title.isEmpty {
            let alertDetails = AlertDetails(type: .error("タイトルを入力してください"))
            output?.showAlert(alertDetails: alertDetails)
            return
        }
        Task {
            do {
                try await api.createInventories(title: title)
                let alertDetails = AlertDetails(type: .success("在庫データの作成が完了しました"))
                output?.showAlert(alertDetails: alertDetails)
            } catch {
                let alertDetails = AlertDetails(type: .error("登録に失敗しました：\(error.localizedDescription)"))
                output?.showAlert(alertDetails: alertDetails)
            }
        }
    }
}
