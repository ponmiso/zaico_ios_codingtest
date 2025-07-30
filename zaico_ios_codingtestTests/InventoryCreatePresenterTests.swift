import Combine
import Foundation
import Testing
@testable import zaico_ios_codingtest

struct InventoryCreatePresenterTests {
    @Test func タイトルが入力されていると在庫データが作成できること() async {
        let output = InventoryCreatePresenterTestOutput()
        let api = Self.SuccessAPIClient()
        let presenter = InventoryCreatePresenter(output: output, api: api)
        
        presenter.didTapCreate(title: "test")
        let alertDetails = await output.alertDetailsPublisher
            .values
            .first(where: { result in
                result != nil
            })
        let result = if let alertDetails, case .success = alertDetails?.type {
            true
        } else {
            false
        }
        #expect(result)
    }
    
    @Test func タイトルが入力されていないと在庫データが作成できないこと() async {
        let output = InventoryCreatePresenterTestOutput()
        let api = Self.SuccessAPIClient()
        let presenter = InventoryCreatePresenter(output: output, api: api)
        
        presenter.didTapCreate(title: "")
        let alertDetails = await output.alertDetailsPublisher
            .values
            .first(where: { result in
                result != nil
            })
        let result = if let alertDetails, case .error = alertDetails?.type {
            true
        } else {
            false
        }
        #expect(result)
    }
    
    @Test func APIで失敗した場合は在庫データが作成できないこと() async {
        let output = InventoryCreatePresenterTestOutput()
        let api = Self.FailureAPIClient()
        let presenter = InventoryCreatePresenter(output: output, api: api)
        
        presenter.didTapCreate(title: "test")
        let alertDetails = await output.alertDetailsPublisher
            .values
            .first(where: { result in
                result != nil
            })
        let result = if let alertDetails, case .error = alertDetails?.type {
            true
        } else {
            false
        }
        #expect(result)
    }
}

extension InventoryCreatePresenterTests {
    class SuccessAPIClient: InventoriesAPIProtocol {
        func fetchInventories() async throws -> [zaico_ios_codingtest.Inventory] {
            []
        }
        
        func fetchInventorie(id: Int?) async throws -> zaico_ios_codingtest.Inventory {
            throw URLError(.badServerResponse)
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
        
        func createInventories(title: String) async throws {
            throw URLError(.badServerResponse)
        }
    }
    
    class InventoryCreatePresenterTestOutput: InventoryCreatePresenterOutput {
        /// データの取得が終わったときにAlertDetailsが渡される
        let alertDetailsPublisher = CurrentValueSubject<zaico_ios_codingtest.AlertDetails?, Never>(nil)
        
        func showAlert(alertDetails: zaico_ios_codingtest.AlertDetails) {
            alertDetailsPublisher.send(alertDetails)
        }
    }
}
