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

struct HomeResponse : Codable {
    let user: User?
    let notification_count : Int?
}

struct User: Codable {
    let id: Int?
    let nameFirst, nameLast, name: String?
    let username: String?
    let phone, email: String?
    let isAvailable, vip, countryID: Int?
    let cityID, branchID, groupID: Int?
    let addressID: Int?
//    let image, gender, genderName, birthDate: String?
    let wallet, point: Int?
    let locale: String?
//    let latitude, longitude, polygon: String?
    let active: Int?
    let lastActive, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameFirst = "name_first"
        case nameLast = "name_last"
        case name, username, phone, email
        case isAvailable = "is_available"
        case vip
        case countryID = "country_id"
        case cityID = "city_id"
        case branchID = "branch_id"
        case groupID = "group_id"
        case addressID = "address_id"
//        case image, gender
//        case genderName = "gender_name"
//        case birthDate = "birth_date"
        case wallet, point, locale, /*latitude, longitude, polygon,*/ active
        case lastActive = "last_active"
        case createdAt = "created_at"
    }
}
