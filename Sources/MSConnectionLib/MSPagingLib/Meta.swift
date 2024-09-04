//
//  Meta.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

public struct Meta : Codable {
    public var total : Int?
    public var count : Int?
    public var per_page : Int?
    public var current_page : Int?
    public var total_pages : Int?
    public var from : Int?
    public var last_page : Int?
    public var path : String?
    public var to : Int?
}
