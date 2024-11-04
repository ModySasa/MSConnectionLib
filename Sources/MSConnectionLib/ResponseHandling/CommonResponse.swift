//
//  CommonResponse.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

public struct CommonResponse<T: Codable>: Codable {
    public let status: Status
    public let message: String?
    public let data: T?
    public let error: ErrorResponse? // Single error string or error object
    public let errors: [String: [String]]? // Validation errors (map of lists)

    // Custom initializer
    public init(
        status: Status,
        message: String?,
        data: T?,
        error: ErrorResponse? = nil,
        errors: [String: [String]]? = nil
    ) {
        self.status = status
        self.message = message
        self.data = data
        self.error = error
        self.errors = errors
    }
    
    // Custom decoding logic to handle error and errors fields dynamically
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode status
        self.status = try container.decode(Status.self, forKey: .status)
        
        // Decode message
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        
        // Decode data
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
        
        // Handle "error" or "errors" dynamically
        if let errorString = try? container.decode(String.self, forKey: .error) {
            self.error = .single(errorString)
            self.errors = nil
        } else if let errorsMap = try? container.decode([String: [String]].self, forKey: .errors) {
            self.error = nil
            self.errors = errorsMap
        } else {
            self.error = nil
            self.errors = nil
        }
    }

    public func handleStatus(
        onSuccess: @escaping () -> Void,
        onFailure: ((String) -> Void)? = nil,
        onStringStatus: ((String?) -> Void)? = nil,
        handleErrors: ((ErrorResponse? , [String: [String]]??) -> Void)? = nil
    ) {
        switch self.status {
        case .boolean(let value):
            value ? onSuccess() : handleFailure(message: self.message, onFailure: onFailure, handleErrors: handleErrors)
        case .string(let value):
            print("String status: \(value)")
            if let onStringStatus {
                onStringStatus(value)
            }
            if let handleErrors {
                handleErrors(error , errors)
            }
        case .int(let value):
            print("Integer status: \(value)")
            if value == 1 {
                onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    onFailure(message)
                }
                if let handleErrors {
                    handleErrors(error , errors)
                }
            }
        case .yesNo(let value):
            print("Yes/No status: \(value)")
            if value {
                onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    onFailure(message)
                }
                if let handleErrors {
                    handleErrors(error , errors)
                }
            }
        case .oneZero(let value):
            if value {
                onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    onFailure(message)
                }
                if let handleErrors {
                    handleErrors(error , errors)
                }
            }
        case .unknown:
            print("Unknown status")
            if let onStringStatus {
                onStringStatus(self.message)
            }
            if let handleErrors {
                handleErrors(error , errors)
            }
        }
    }
    
    private func handleFailure(
         message: String?,
         onFailure: ((String) -> Void)?,
         handleErrors: ((ErrorResponse?, [String: [String]]??) -> Void)?
     ) {
         if let message = message, let onFailure {
             onFailure(message)
         }
         if let handleErrors {
             handleErrors(error, errors)
         }
     }
    
    public func handleStatus(
        onSuccess: @escaping () async -> Void,
        onFailure: ((String) async -> Void)? = nil,
        onStringStatus: ((String?) async -> Void)? = nil,
        handleErrors: ((ErrorResponse? , [String: [String]]??) async -> Void)? = nil
    ) async {
        switch self.status {
        case .boolean(let value):
            value ? await onSuccess() : await handleFailure(message: self.message, onFailure: onFailure, handleErrors: handleErrors)
        case .string(let value):
            print("String status: \(value)")
            if let onStringStatus {
                await onStringStatus(value)
            }
            if let handleErrors {
                await handleErrors(error , errors)
            }
        case .int(let value):
            print("Integer status: \(value)")
            if value == 1 {
                await onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    await onFailure(message)
                }
                if let handleErrors {
                    await handleErrors(error , errors)
                }
            }
        case .yesNo(let value):
            print("Yes/No status: \(value)")
            if value {
                await onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    await onFailure(message)
                }
                if let handleErrors {
                    await handleErrors(error , errors)
                }
            }
        case .oneZero(let value):
            if value {
                await onSuccess()
            } else {
                if let message = self.message , let onFailure {
                    await onFailure(message)
                }
                if let handleErrors {
                    await handleErrors(error , errors)
                }
            }
        case .unknown:
            print("Unknown status")
            if let onStringStatus {
                await onStringStatus(self.message)
            }
            if let handleErrors {
                await handleErrors(error , errors)
            }
        }
    }
    
    private func handleFailure(
         message: String?,
         onFailure: ((String) async -> Void)?,
         handleErrors: ((ErrorResponse?, [String: [String]]??) async -> Void)?
     ) async {
         if let message = message, let onFailure {
             await onFailure(message)
         }
         if let handleErrors {
             await handleErrors(error, errors)
         }
     }
}
