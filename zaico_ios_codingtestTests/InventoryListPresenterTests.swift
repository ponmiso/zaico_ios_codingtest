import Combine
import Testing
@testable import zaico_ios_codingtest

struct InventoryListPresenterTests {
    @Test func 在庫一覧の数が正しいこと() async {
        let output = SuccessInventoryListPresenterTestOutput()
        let api = Self.SuccessAPIClient()
        let presenter = InventoryListPresenter(output: output, api: api)
        
        presenter.fetchListData()
        let _ = await output.calledReloadDataPublisher
            .values
            .first(where: { result in
                result
            })

        #expect(presenter.numberOfItems == 3)
    }
    
    @Test func 在庫一覧から正しい在庫が取得できること() async {
        let output = SuccessInventoryListPresenterTestOutput()
        let api = Self.SuccessAPIClient()
        let presenter = InventoryListPresenter(output: output, api: api)
        
        presenter.fetchListData()
        let _ = await output.calledReloadDataPublisher
            .values
            .first(where: { result in
                result
            })
        
        let actual = presenter.item(index: 1).id
        let expected = 2
        #expect(actual == expected)
    }
}

extension InventoryListPresenterTests {
    class SuccessAPIClient: InventoriesAPIProtocol {
        func fetchInventories() async throws -> [zaico_ios_codingtest.Inventory] {
            [
                Inventory(id: 1, title: "あああ", quantity: "100", itemImage: nil),
                Inventory(id: 2, title: "いいい", quantity: nil, itemImage: nil),
                Inventory(id: 3, title: "ううう", quantity: "0", itemImage: nil),
            ]
        }
        
        func fetchInventorie(id: Int?) async throws -> zaico_ios_codingtest.Inventory {
            Inventory(id: 1, title: "あああ", quantity: "100", itemImage: nil)
        }
        
        func createInventories(title: String) async throws {}
    }
    
    class SuccessInventoryListPresenterTestOutput: InventoryListPresenterOutput {
        /// reloadData() が呼ばれたときtrueになる
        let calledReloadDataPublisher = CurrentValueSubject<Bool, Never>(false)

        func reloadData() {
            calledReloadDataPublisher.send(true)
        }

        func showInventoryDetail(inventory: Inventory) {}

        func showInventoryCreate() {}
    }
}
