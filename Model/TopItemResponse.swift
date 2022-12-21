//
//  TopItem.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 07/12/2022.
//

import Foundation

struct TopItemResponse: Codable {
    let products: [TopItem]
    let total, skip, limit: Int
}

struct TopItem: Codable {
    let id: Int
        let title, productDescription: String
        let price: Int
        let discountPercentage, rating: Double
        let stock: Int
        let brand, category: String
        let thumbnail: String
        let images: [String]

        enum CodingKeys: String, CodingKey {
            case id, title
            case productDescription = "description"
            case price, discountPercentage, rating, stock, brand, category, thumbnail, images
        }
    
}

