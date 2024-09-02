//
//  NetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 8/24/24.
//

import Foundation
import OSLog
import SwiftUI

public actor NetworkManager {
    let errorLogger: ErrorLogger = .shared
            
    private let parentClassName: String
        
    // Updated initializer without directly using 'self'
    public init(T: Any.Type = NetworkManager.self) {
        self.parentClassName = String(describing: T)
    }
    
    // Class name property returning the parent class name
    var className: String {
        return parentClassName
    }
    
    public func get<T: Decodable, U: Encodable>(
        from url: URL,
        lang: String = "en",
        loadingdata : Binding<Bool> ,
        body: U? = nil,
        responseType: T.Type,
        token: String? = nil // Added token parameter with default value
    ) async -> Result<T, MultipleDecodingErrors> {
        var data: Data = Data() // Initialize data
        do {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(lang, forHTTPHeaderField: "lang")
            
            if let body {
                request.httpBody = try JSONEncoder().encode(body)
            }
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            
            (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let response = try decoder.decode(T.self, from: data)
            return .success(response)
            
        } catch let error as Swift.DecodingError {
            // Handle decoding errors
            var decodingErrors: [DecodingError] = []
            switch error {
            case .keyNotFound(let key, _):
                decodingErrors.append(.missingKey(key.stringValue))
            case .typeMismatch(_, let context):
                decodingErrors.append(.typeMismatch(context.codingPath.map { $0.stringValue }.joined(separator: "."), expectedType: context.debugDescription))
            default:
                decodingErrors.append(.other(error))
            }
            logDecodingError(error, data: data)
            return .failure(MultipleDecodingErrors(errors: decodingErrors))
        } catch {
            // Handle other errors
            logError(error)
            return .failure(MultipleDecodingErrors(errors: [.other(error)]))
        }
    }
    
    public func post<T: Decodable, U: Encodable>(
        to url: URL,
        httpMethod: HTTPMethod = .post,
        lang: String = "en",
        loadingdata : Binding<Bool> ,
        body: U,
        responseType: T.Type,
        token: String? = nil // Added token parameter with default value
    ) async -> Result<T, MultipleDecodingErrors> {
        var data: Data = Data() // Initialize data
        do {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(lang, forHTTPHeaderField: "lang")
            request.httpBody = try JSONEncoder().encode(body)
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(T.self, from: data)
            return .success(response)
        } catch let error as Swift.DecodingError {
            // Handle decoding errors
            var decodingErrors: [DecodingError] = []
            switch error {
            case .keyNotFound(let key, _):
                decodingErrors.append(.missingKey(key.stringValue))
            case .typeMismatch(_, let context):
                decodingErrors.append(.typeMismatch(context.codingPath.map { $0.stringValue }.joined(separator: "."), expectedType: context.debugDescription))
            default:
                decodingErrors.append(.other(error))
            }
            logDecodingError(error, data: data)
            return .failure(MultipleDecodingErrors(errors: decodingErrors))
        } catch {
            // Handle other errors
            logError(error)
            return .failure(MultipleDecodingErrors(errors: [.other(error)]))
        }
    }
    
    private func logDecodingError(
        _ error: Swift.DecodingError,
        data: Data
    ) {
        let dataString = String(data: data, encoding: .utf8) ?? "Unable to convert data to string"
        errorLogger.debug("Decoding error: \(error)\nData: \(dataString)" , className: className)
    }
    
    private func logError(
        _ error: Error
    ) {
        errorLogger.error("Error: \(error)" , className: className)
    }
    
    func inspectRawJSON(
        data: Data
    ) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let message = "Raw JSON: \(jsonObject)"
            errorLogger.error("Raw JSON: \(message)" , className: className)
        } catch {
            errorLogger.error("Failed to convert data to JSON object: \(error)" , className: className)
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    // Add other methods as needed
}
