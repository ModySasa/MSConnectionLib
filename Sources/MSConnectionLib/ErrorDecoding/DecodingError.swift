//
//  DecodingError.swift
//  MSConnectionLib
//
//  Created by Moha on 8/24/24.
//


import Foundation

public enum DecodingError: Error {
    case missingKey(String)
    case typeMismatch(String, expectedType: String)
    case dataCorrupted(String)
    case other(Error)
    
    var description: String {
        switch self {
        case .missingKey(let key):
            return "Missing key: \(key)"
        case .typeMismatch(let path, let expectedType):
            return "Type mismatch at path: \(path), expected type: \(expectedType)"
        case .dataCorrupted(let message):
            return "Data corrupted: \(message)"
        case .other(let error):
            return "Other error: \(error.localizedDescription)"
        }
    }
}
