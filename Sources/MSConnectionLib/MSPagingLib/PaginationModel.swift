//
//  PaginationModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

public struct PaginationModel : Codable  {
    public var current_page : Int?
    public var first_page_url : String?
    public var from : Int?
    public var last_page : Int?
    public var last_page_url : String?
    public var next_page_url : String?
    public var path : String?
    public var per_page : Int?
    public var prev_page_url : String?
    public var to : Int?
    public var total : Int?
    public var meta : Meta? {
        didSet {
            if let meta = meta {
                if let total = meta.total,
                    let count = meta.count,
                    let per_page = meta.per_page,
                    let current_page = meta.current_page,
                    let total_pages = meta.total_pages,
                    let from = meta.from,
                    let last_page = meta.last_page,
                    let path = meta.path,
                    let to = meta.to
                {
                    self.total = total
                    self.per_page = per_page
                    self.current_page = current_page
                    self.total = total_pages
                    self.from = from
                    self.last_page = last_page
                    self.path = path
                    self.to = to
                }
            }
        }
    }
    public var links : Links? {
        didSet {
            if let links = links {
                if let first = links.first,
                   let last = links.last,
                   let prev = links.prev,
                   let next = links.next
                {
                    self.first_page_url = first
                    self.last_page_url = last
                    self.prev_page_url = prev
                    self.next_page_url = next
                }
            }
        }
    }
}

public struct Meta : Codable {
    var total : Int?
    var count : Int?
    var per_page : Int?
    var current_page : Int?
    var total_pages : Int?
    var from : Int?
    var last_page : Int?
    var path : String?
    var to : Int?
}

public struct Links : Codable {
    var first : String?
    var last : String?
    var prev : String?
    var next : String?
}
