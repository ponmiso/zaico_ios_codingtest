import Foundation

protocol InventoriesAPIProtocol {
    func fetchInventories() async throws -> [Inventory]
    func fetchInventorie(id: Int?) async throws -> Inventory
    func createInventories(title: String) async throws
}

struct InventoriesAPI: InventoriesAPIProtocol {
    func fetchInventories() async throws -> [Inventory] {
        do {
            let response = try await APIClient.request(endpoint: .inventories)
            return try JSONDecoder().decode([Inventory].self, from: response)
        } catch {
            throw error
        }
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        guard let id else {
            throw NSError(domain: "Missing ID", code: 1)
        }
        
        do {
            let response = try await APIClient.request(endpoint: .inventory(id: id))
            return try JSONDecoder().decode(Inventory.self, from: response)
        } catch {
            throw error
        }
    }
    
    func createInventories(title: String) async throws {
        let headerFields = ["application/json": "Content-Type"]
        
        let payload = CreateInventoriesBody(title: title)
        guard let httpBody = try? JSONEncoder().encode(payload) else {
            throw NSError(domain: "JSON encoding failure", code: 1)
        }
        
        do {
            try await APIClient.request(endpoint: .createInventory, headerFields: headerFields, httpBody: httpBody)
        } catch {
            throw error
        }
    }
}
