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
    public let optionalBody = Optional<String>.none
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
        from url: String,
        lang: String = "en",
        parameters: U? = nil,
        responseType: T.Type,
        token: String? = nil
        , shouldDumpRequest : Bool = false
    ) async -> Result<T, MultipleDecodingErrors> {
        guard var components = URLComponents(string: url) else {
            return .failure(MultipleDecodingErrors(errors: [.other(URLError(.badURL))]))
        }
        
        if let body = parameters {
            let jsonData = try? JSONEncoder().encode(body)
            if let jsonData = jsonData,
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
               let parameters = jsonObject as? [String: Any] {
                
                components.queryItems = parameters.map { URLQueryItem(name: "\($0)", value: "\($1)") }
            }
        }
        
        guard let theUrl = components.url else {
            return .failure(MultipleDecodingErrors(errors: [.other(URLError(.badURL))]))
        }
        
        print("urlPrint ::: " , theUrl)
        print("urlPrint parameters ::: " , components.queryItems)
        
        var data: Data = Data() // Initialize data
        
        do {
            var request = URLRequest(url: theUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(lang, forHTTPHeaderField: "lang")
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            #if DEBUG
            if(shouldDumpRequest) {
                dump(request)
            }
            #else
            
            #endif
            
            (data, _) = try await URLSession.shared.data(for: request)
            
            logData(data)
            
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            
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
        to url: String,
        httpMethod: HTTPMethod = .post,
        lang: String = "en",
        body: U,
        responseType: T.Type,
        token: String? = nil // Added token parameter with default value
        , shouldDumpRequest : Bool = false
    ) async -> Result<T, MultipleDecodingErrors> {
        guard let theUrl = URL(string: url) else {
            return .failure(MultipleDecodingErrors(errors: [.other(URLError.init(.badURL))]))
        }
        print("URL IS : " , theUrl)
        
        var data: Data = Data() // Initialize data
        do {
            var request = URLRequest(url: theUrl)
            request.httpMethod = httpMethod.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(lang, forHTTPHeaderField: "lang")
            request.httpBody = try JSONEncoder().encode(body)
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            #if DEBUG
            if(shouldDumpRequest) {
                dump(request)
            }
            #else
            
            #endif
            (data, _) = try await URLSession.shared.data(for: request)
            
            logData(data)
            
            let decoder = JSONDecoder()
            //            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    
    public func fetchImage(from url: String) async throws -> UIImage{
        do {
            guard let theUrl = URL(string: url)
            else {
                throw URLError.init(.badURL)
            }
            
            let (data , _) = try await URLSession.shared.data(from: theUrl)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError.init(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    public func uploadImage<T: Decodable>(
        to url: String,
        httpMethod: HTTPMethod = .post,
        lang: String = "en",
        image: UIImage,
        imageName: String,
        key:String = "image",
        responseType: T.Type,
        token: String? = nil,
        maxSizeInMB : Double = 2
    ) async -> Result<T, MultipleDecodingErrors> {
        let theImage = compressImage(image, maxSizeInMB: maxSizeInMB)
        guard let theUrl = URL(string: url) else {
            return .failure(MultipleDecodingErrors(errors: [.other(URLError.init(.badURL))]))
        }
        
        var data: Data = Data()
        do {
            var request = URLRequest(url: theUrl)
            request.httpMethod = httpMethod.rawValue
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(lang, forHTTPHeaderField: "lang")
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            // Create multipart form data
            let imageData = theImage.jpegData(compressionQuality: 0.7) // Adjust compression quality as needed
            guard let imageData = imageData else {
                return .failure(MultipleDecodingErrors(errors: [.other(URLError(.cannotCreateFile))]))
            }
            
            var body = Data()
            
            // Append image data
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            // Close boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            (data, _) = try await URLSession.shared.data(for: request)
            
            
            
            logData(data)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            
            return .success(response)
            
        } catch let error as Swift.DecodingError {
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
            logError(error)
            return .failure(MultipleDecodingErrors(errors: [.other(error)]))
        }
    }
    
    public func uploadImagesWithBody<T: Decodable, U: Encodable>(
        to url: String,
        httpMethod: HTTPMethod = .post,
        lang: String = "en",
        images: [UIImage],
        imagesNames: [String],
        keys: [String],
        body: U,
        responseType: T.Type,
        token: String? = nil,
        maxSizeInMB: Double = 2
    ) async -> Result<T, MultipleDecodingErrors> {
        let theImages = images.map { compressImage($0, maxSizeInMB: maxSizeInMB) }
        
        guard let theUrl = URL(string: url) else {
            return .failure(MultipleDecodingErrors(errors: [.other(URLError(.badURL))]))
        }
        
        var data: Data = Data()
        do {
            var request = URLRequest(url: theUrl)
            request.httpMethod = httpMethod.rawValue
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(lang, forHTTPHeaderField: "lang")
            
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            // Start building multipart body
            var bodyData = Data()
            
            // Convert `body` to a dictionary and append each field individually
            let bodyDict = try body.toDictionary()
            for (key, value) in bodyDict {
                bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                bodyData.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            // Append image data
            let imagesData = theImages.map { $0.jpegData(compressionQuality: 0.7) }
            
            if imagesData.count != images.count {
                return .failure(MultipleDecodingErrors(errors: [.other(URLError(.cannotCreateFile))]))
            }
            
            for i in 0..<images.count {
                let imageName = imagesNames[i]
                let key = keys[i]
                bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                if let imageData = imagesData[i] {
                    bodyData.append(imageData)
                }
                bodyData.append("\r\n".data(using: .utf8)!)
            }
            
            // End boundary
            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Set the multipart form data as the request body
            request.httpBody = bodyData
            
            // Perform the request
            (data, _) = try await URLSession.shared.data(for: request)
            
            logData(data)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            
            return .success(response)
            
        } catch let error as Swift.DecodingError {
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
    
    func logData(_ data:Data) {
        if let dataString = String(data: data, encoding: .utf8) {
            errorLogger.debug("Server response is :\n\(dataString)")
        }
    }
    
    private func compressImage(_ image: UIImage, maxSizeInMB: Double) -> UIImage {
        let maxSizeInBytes = Int(maxSizeInMB * 1024 * 1024)
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)!
        if(imageData.count > maxSizeInBytes) {
            let sizeToBeCompressed = Double(maxSizeInBytes) / Double(imageData.count)
            compression = sizeToBeCompressed - 0.1
            let newWidth = CGFloat(image.size.width) * compression
            let newHeight = CGFloat(image.size.height) * compression
            let newSize = CGSize(width: newWidth, height: newHeight)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let compressedData = newImage?.jpegData(compressionQuality: compression) {
                imageData = compressedData
            }
        }
        
        return UIImage(data: imageData)!
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

public extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        return jsonObject as? [String: Any] ?? [:]
    }
}
