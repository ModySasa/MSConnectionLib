//
//  KeyPathCodable.swift
//  MyTestProject
//
//  Created by Moha on 11/19/25.
//

public protocol KeyPathCodable: Codable {
    static var keyPathCodingMap: [PartialKeyPath<Self>: String] { get }
}
