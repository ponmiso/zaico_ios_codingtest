//
//  Inventory.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import Foundation

struct Inventory: Codable, Equatable {
    let id: Int
    let title: String
    let quantity: String?
    let itemImage: ItemImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case quantity
        case itemImage = "item_image"
    }
}

struct ItemImage: Codable, Equatable {
    let url: String?
}
