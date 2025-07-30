import Foundation

protocol InventoryListPresenterInput {
    var numberOfItems: Int { get }
    func item(index: Int) -> Inventory
    func fetchListData()
    func didSelectCell(index: Int)
    func didTapAdd()
}

protocol InventoryListPresenterOutput: AnyObject {
    func reloadData()
    func showInventoryDetail(inventory: Inventory)
    func showInventoryCreate()
}

final class InventoryListPresenter {
    private weak var output: InventoryListPresenterOutput?
    private let apiClient: APIClient
    private var inventories: [Inventory] = []
    
    init(output: InventoryListPresenterOutput, apiClient: APIClient = APIClient.shared) {
        self.output = output
        self.apiClient = apiClient
    }
}

extension InventoryListPresenter: InventoryListPresenterInput {
    var numberOfItems: Int {
        inventories.count
    }
    
    func item(index: Int) -> Inventory {
        inventories[index]
    }
    
    func fetchListData() {
        Task {
            do {
                let data = try await apiClient.fetchInventories()
                await MainActor.run {
                    inventories = data
                    output?.reloadData()
                }
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    func didSelectCell(index: Int) {
        let inventory = item(index: index)
        output?.showInventoryDetail(inventory: inventory)
    }
    
    func didTapAdd() {
        output?.showInventoryCreate()
    }
}
