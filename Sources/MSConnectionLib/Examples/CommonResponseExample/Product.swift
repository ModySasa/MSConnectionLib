//
//  Product.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

struct Product: Codable {
    let id: Int?
    let code: String?
    let link: String?
    let name: String?
    let content: String?
    let favorite: String?
    let inCart: String?
    let idInCart: Int?
    let countInCart: String?
    let background: String?
    let color: String?
    let video: String?
    let image: String?
    let rate: String?
    let rateCount: Int?
    let rateAll: String?
    let prepareTime: String?
    let price: String?
    let start: String?
    let skip: String?
    let orderLimit: String?
    let offer: String?
    let offerType: String?
    let offerPrice: String?
    let offerPercent: String?
    let offerAmount: String?
    let offerAmountAdd: String?
    let stockAmount: String?
    let maxAmount: String?
    let maxAdditionFree: Int?
    let maxAddition: Int?
    let active: Int?
    let feature: Int?
    let shipping: Int?
    let isFilter: Int?
    let isSale: Int?
    let isLate: Int?
    let isSize: Int?
    let isMax: Int?
    let isNew: Int?
    let isSpecial: Int?
    let isOffer: Int?
    let isStock: Int?
    let isNotify: Int?
    let flag: String?
    let flagName: String?
    let orderMax: String?
    let dateStart: String?
    let dateExpire: String?
    let dayStart: String?
    let dayEnd: String?
    let type: String?
    let status: String?
    let orderId: Int?
    let parentId: Int?
    let unitId: Int?
    let brandId: Int?
    let sizeId: Int?
    let createdAt: String?
    let updatedAt: String?
//    let unit: Unit
//    let categories: Categories?
//    let childrens: Children?
//    let additions: [String]?
//    let brand: String?

    enum CodingKeys: String, CodingKey {
        case id, code, link, name, content, favorite, inCart = "in_cart", idInCart = "id_in_cart", countInCart = "count_in_cart"
        case background, color, video, image, rate, rateCount = "rate_count", rateAll = "rate_all"
        case prepareTime = "prepare_time", price, start, skip, orderLimit = "order_limit", offer, offerType = "offer_type"
        case offerPrice = "offer_price", offerPercent = "offer_percent", offerAmount = "offer_amount", offerAmountAdd = "offer_amount_add"
        case stockAmount = "stock_amount", maxAmount = "max_amount", maxAdditionFree = "max_addition_free", maxAddition = "max_addition"
        case active, feature, shipping, isFilter = "is_filter", isSale = "is_sale", isLate = "is_late", isSize = "is_size"
        case isMax = "is_max", isNew = "is_new", isSpecial = "is_special", isOffer = "is_offer", isStock = "is_stock"
        case isNotify = "is_notify", flag, flagName = "flag_name", orderMax = "order_max", dateStart = "date_start", dateExpire = "date_expire"
        case dayStart = "day_start", dayEnd = "day_end", type, status, orderId = "order_id", parentId = "parent_id", unitId = "unit_id"
        case brandId = "brand_id", sizeId = "size_id", createdAt = "created_at", updatedAt = "updated_at"/*, unit, categories, childrens, additions, brand*/
    }
}

struct Categories: Codable {
    let data: [Category?]?
}

struct Category: Codable {
    let id : Int?
    let parent_id : Int?
    let link : String?
    let name : String?
    let content : String?
    let image : String?
    let type : String?
    let status : String?
    let background : String?
    let color : String?
    let products_count : Int?
    let order_id : Int?
    let active : Int?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case parent_id
        case link
        case name
        case content
        case image
        case type
        case status
        case background
        case color
        case products_count
        case order_id
        case active
        case created_at
        case updated_at
    }
}
    

struct Children: Codable {
    let data: [String]
}

struct Unit : Codable {
    let id : Int?
    let image : String?
    let name : String?
    let order_id : Int?
    let active : Int?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case order_id
        case active
        case created_at
        case updated_at
    }
}
