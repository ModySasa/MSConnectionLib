//
//  PostModel.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//


import Foundation

struct PostModel: Codable , Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
