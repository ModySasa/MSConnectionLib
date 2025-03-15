//
//  PaginationModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

public struct PaginatedResponse<Item: Codable, Result: Codable>: Codable {
    public let data: [Item]?
    public let meta: Meta?
    public let links: Links?
    public let additionalData: Result?

    private enum CodingKeys: String, CodingKey {
        case data, meta, links
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode known properties
        data = try container.decodeIfPresent([Item].self, forKey: .data)
        meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        if let linksObject = try? container.decode(Links.self, forKey: .links) {
            links = linksObject
        } else {
            links = nil
        }
//        links = try container.decodeIfPresent(Links.self, forKey: .links)

        // Decode additional data
        let additionalContainer = try decoder.singleValueContainer()
        additionalData = try? additionalContainer.decode(Result.self)
    }
}
