//
//  ProductResponse.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

struct ProductListResponse: Codable {
    let data: [Product]?
    let meta: Meta?
    let links: Links?
}

struct ProductResponse: Codable {
    let product: Product
    let similarProducts: SimilarProducts?

    enum CodingKeys: String, CodingKey {
        case product
        case similarProducts = "similar_products"
    }
}

struct SimilarProducts: Codable {
    let data: [Product]?
}
