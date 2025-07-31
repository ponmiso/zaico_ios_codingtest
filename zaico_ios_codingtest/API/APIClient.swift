//
//  APIClient.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import Foundation

struct APIClient {
    static let token = Secret.token // 実際のトークンに置き換える
}

extension APIClient {
    @discardableResult
    static func request(endpoint: Endpoint, headerFields: [String: String] = [:], httpBody: Data? = nil) async throws -> Data {
        guard let url = URL(string: endpoint.urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
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

