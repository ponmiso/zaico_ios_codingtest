import Combine
import Foundation
import Testing
@testable import zaico_ios_codingtest

struct InventoryDetailPresenterTests {
    @Test func 在庫の詳細情報が正しいこと() async {
        let output = InventoryDetailPresenterTestOutput()
        let api = Self.SuccessAPIClient()
        let presenter = InventoryDetailPresenter(inventoryId: Self.inventory.id, output: output, api: api)
        
        presenter.fetchDetailData()
        let _ = await output.didFinishedFetchDetailDataPublisher
            .values
            .first(where: { result in
                result
            })

        #expect(presenter.inventory == Self.inventory)
    }
    
    @Test func 存在しない在庫情報が取得できないこと() async {
        let output = InventoryDetailPresenterTestOutput()
        let api = Self.FailureAPIClient()
        let presenter = InventoryDetailPresenter(inventoryId: 2, output: output, api: api)
        
        presenter.fetchDetailData()
        let _ = await output.didFinishedFetchDetailDataPublisher
            .values
            .first(where: { result in
                result
            })
        
        #expect(presenter.inventory == nil)
    }
}

extension InventoryDetailPresenterTests {
    static let inventory = Inventory(id: 1, title: "あああ", quantity: "100", itemImage: nil)
    
    class SuccessAPIClient: InventoriesAPIProtocol {
        func fetchInventories() async throws -> [zaico_ios_codingtest.Inventory] {
            []
        }
        
        func fetchInventorie(id: Int?) async throws -> zaico_ios_codingtest.Inventory {
            InventoryDetailPresenterTests.inventory
        }
        
        func createInventories(title: String) async throws {}
    }
    
    class FailureAPIClient: InventoriesAPIProtocol {
        func fetchInventories() async throws -> [zaico_ios_codingtest.Inventory] {
            []
        }
        
        func fetchInventorie(id: Int?) async throws -> zaico_ios_codingtest.Inventory {
            throw URLError(.badServerResponse)
        }
        
        func createInventories(title: String) async throws {}
    }
    
    class InventoryDetailPresenterTestOutput: InventoryDetailPresenterOutput {
        /// データの取得が終わったときtrueになる
        let didFinishedFetchDetailDataPublisher = CurrentValueSubject<Bool, Never>(false)

        func reloadData() {
            didFinishedFetchDetailDataPublisher.send(true)
        }
        
        func showAlert(message: String) {
            didFinishedFetchDetailDataPublisher.send(true)
        }

        func showInventoryDetail(inventory: Inventory) {}

        func showInventoryCreate() {}
    }
}
