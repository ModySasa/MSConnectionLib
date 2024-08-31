//
//  MultipleDecodingErrors.swift
//  MSConnectionLib
//
//  Created by Moha on 8/24/24.
//

import Foundation

public struct MultipleDecodingErrors: Error {
    let errors: [DecodingError]
    
    var description: String {
        errors.map { $0.description }.joined(separator: "\n")
    }
}
