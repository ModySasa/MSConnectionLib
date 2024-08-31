//
//  NetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 8/24/24.
//

import Foundation

public actor NetworkManager {
    
    public func get<T: Decodable>(from url: URL, responseType: T.Type) async -> Result<T, MultipleDecodingErrors> {
        var data: Data = Data() // Initialize data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
//            inspectRawJSON(data: data)
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

    public func post<T: Decodable, U: Encodable>(to url: URL, body: U, responseType: T.Type) async -> Result<T, MultipleDecodingErrors> {
        var data: Data = Data() // Initialize data
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
            
            (data, _) = try await URLSession.shared.data(for: request)
//            inspectRawJSON(data: data)
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

    private func logDecodingError(_ error: Swift.DecodingError, data: Data) {
        let dataString = String(data: data, encoding: .utf8) ?? "Unable to convert data to string"
        print("Decoding error: \(error)\nData: \(dataString)")
    }

    private func logError(_ error: Error) {
        print("Error: \(error)")
    }
    
    func inspectRawJSON(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print("Raw JSON: \(jsonObject)")
        } catch {
            print("Failed to convert data to JSON object: \(error)")
        }
    }
}
