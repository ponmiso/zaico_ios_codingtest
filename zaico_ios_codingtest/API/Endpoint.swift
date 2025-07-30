enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Endpoint {
    let urlString: String
    let method: HTTPMethod
}

extension Endpoint {
    private static let baseURL = "https://web.zaico.co.jp"
    private static let inventoriesBaseURL = "\(baseURL)/api/v1/inventories"
    
    static let inventories = Endpoint(urlString: inventoriesBaseURL, method: .get)
    
    static func inventory(id: Int) -> Endpoint {
        .init(urlString: "\(inventoriesBaseURL)/\(id)",  method: .get)
    }
    
    static let createInventory = Endpoint(urlString: inventoriesBaseURL, method: .post)
}
