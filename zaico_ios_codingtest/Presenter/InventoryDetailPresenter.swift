import Foundation

protocol InventoryDetailPresenterInput {
    var inventory: Inventory? { get }
    var numberOfItems: Int { get }
    func cellTitle(index: Int) -> String
    func fetchDetailData()
}

protocol InventoryDetailPresenterOutput: AnyObject {
    func reloadData()
}

final class InventoryDetailPresenter {
    private weak var output: InventoryDetailPresenterOutput?
    private let apiClient: APIClient
    private let inventoryId: Int
    private let cellTitles = ["ID", "在庫画像", "タイトル", "数量"]
    
    var inventory: Inventory?
    
    init(inventoryId: Int, output: InventoryDetailPresenterOutput, apiClient: APIClient = APIClient.shared) {
        self.inventoryId = inventoryId
        self.output = output
        self.apiClient = apiClient
    }
}

extension InventoryDetailPresenter: InventoryDetailPresenterInput {
    var numberOfItems: Int {
        cellTitles.count
    }
    
    func cellTitle(index: Int) -> String {
        cellTitles[index]
    }
    
    func fetchDetailData() {
        Task {
            do {
                let data = try await APIClient.shared.fetchInventorie(id: inventoryId)
                await MainActor.run {
                    inventory = data
                    output?.reloadData()
                }
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}
