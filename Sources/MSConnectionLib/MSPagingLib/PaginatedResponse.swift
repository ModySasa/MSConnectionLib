//
//  PaginationModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

public struct PaginatedResponse<Item: Codable>: Codable {
    public let data: [Item]?
    public let meta: Meta?
    public let links: Links?
}
