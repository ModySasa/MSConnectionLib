//
//  JSONHelper.swift
//  MSConnectionLib
//
//  Created by Moha on 1/8/25.
//

import Foundation

public class JSONHelper {
    public static func createObjectFromJSON<Object:Codable>(_ jsonString: String) -> Object? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(Object.self, from: jsonData)
                return object
            } catch {
                print("Failed to decode JSON: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
}
