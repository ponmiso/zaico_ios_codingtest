import Foundation

protocol InventoriesAPIProtocol {
    func fetchInventories() async throws -> [Inventory]
    func fetchInventorie(id: Int?) async throws -> Inventory
    func createInventories(title: String) async throws
}

struct InventoriesAPI: InventoriesAPIProtocol {
    func fetchInventories() async throws -> [Inventory] {
        do {
            let response = try await request(httpMethod: "GET")
            return try JSONDecoder().decode([Inventory].self, from: response)
        } catch {
            throw error
        }
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        let path = if let id {
            "/\(id)"
        } else {
            ""
        }
        
        do {
            let response = try await request(httpMethod: "GET", path: path)
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
            try await request(httpMethod: "POST", headerFields: headerFields, httpBody: httpBody)
        } catch {
            throw error
        }
    }
}

extension InventoriesAPI {
    @discardableResult
    private func request(httpMethod: String, path: String = "", headerFields: [String: String] = [:], httpBody: Data? = nil) async throws -> Data {
        let endpoint = "/api/v1/inventories" + path
        
        guard let url = URL(string: APIClient.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(APIClient.token)", forHTTPHeaderField: "Authorization")
        headerFields.forEach { value, field in
            request.setValue(value, forHTTPHeaderField: field)
        }
        request.httpBody = httpBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            return data
        } catch {
            throw error
        }
    }
}
