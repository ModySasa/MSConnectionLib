//
//  Status.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

public enum Status: Codable {
    case boolean(Bool)
    case string(String)
    case int(Int)
    case yesNo(Bool)
    case oneZero(Bool)
    case unknown

    // Helper initializer to handle the "yes"/"no" and "1"/"0" strings
    public init(fromString value: String) {
        switch value.lowercased() {
        case "yes", "1":
            self = .yesNo(true)
        case "no", "0":
            self = .yesNo(false)
        default:
            self = .string(value)
        }
    }

    public init(fromInt value: Int) {
        switch value {
        case 1:
            self = .oneZero(true)
        case 0:
            self = .oneZero(false)
        default:
            self = .int(value)
        }
    }

    // Custom initializer to decode different types
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .init(fromInt: intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .init(fromString: stringValue)
        } else {
            self = .unknown
        }
    }

    // Encoding logic
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .boolean(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .yesNo(let value):
            try container.encode(value ? "yes" : "no")
        case .oneZero(let value):
            try container.encode(value ? "1" : "0")
        case .unknown:
            try container.encodeNil()
        }
    }

    // Helper methods to access boolean status more easily
    var boolValue: Bool? {
        switch self {
        case .boolean(let value):
            return value
        case .yesNo(let value), .oneZero(let value):
            return value
        default:
            return nil
        }
    }
}
