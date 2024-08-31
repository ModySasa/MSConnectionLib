//
//  SafeDecodable.swift
//  MSConnectionLib
//
//  Created by Moha on 8/24/24.
//

import Foundation

public protocol SafeDecodable: Decodable {
    init(from decoder: Decoder) throws
    static func decode(from decoder: Decoder) throws -> Result<Self, MultipleDecodingErrors>
}

public extension SafeDecodable {
    static func decode(from decoder: Decoder) throws -> Result<Self, MultipleDecodingErrors> {
        do {
            let model = try Self(from: decoder)
            return .success(model)
        } catch let error as Swift.DecodingError {
            let decodingError = mapDecodingError(error, decoder: decoder)
            return .failure(MultipleDecodingErrors(errors: [decodingError]))
        } catch {
            return .failure(MultipleDecodingErrors(errors: [.other(error)]))
        }
    }
    
    private static func mapDecodingError(_ error: Swift.DecodingError, decoder: Decoder) -> DecodingError {
        switch error {
        case .keyNotFound(let key, _):
            return .missingKey(key.stringValue)
        case .typeMismatch(_, let context):
            return .typeMismatch(
                context.codingPath.map { $0.stringValue }.joined(separator: "."),
                expectedType: context.debugDescription
            )
        case .valueNotFound(_, let context):
            return .typeMismatch(
                context.codingPath.map { $0.stringValue }.joined(separator: "."),
                expectedType: "Value not found"
            )
        case .dataCorrupted(let context):
            return .dataCorrupted(context.debugDescription)
        default:
            return .other(error)
        }
    }
}
