//
//  ErrorResponse.swift
//  MSConnectionLib
//
//  Created by Moha on 9/19/24.
//

import Foundation

public enum ErrorResponse: Codable {
    case single(String)  // For single string error messages
    case multiple([String: [String]])  // For complex error maps
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try decoding it as a string first
        if let singleError = try? container.decode(String.self) {
            self = .single(singleError)
        }
        // Otherwise, decode it as a map of lists
        else if let multipleErrors = try? container.decode([String: [String]].self) {
            self = .multiple(multipleErrors)
        } else {
            throw DecodingError.other(NSError(domain: "ErrorResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "ErrorResponse must be a String or a Dictionary"]))
        }
    }
}
