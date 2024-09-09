//
//  CommonResponse.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

public struct CommonResponse<T: Codable>: Codable {
    public let status: Status
    public let message: String
    public let data: T?
    
    public init(status: Status, message: String, data: T?) {
            self.status = status
            self.message = message
            self.data = data
        }
    
    public func handleStatus(onSuccess:@escaping ()->Void , onFailure:@escaping (String)->Void , onStringStatus : ((String?)->Void)? = nil) {
        switch self.status {
        case .boolean(let value):
            if(value) {
                onSuccess()
            } else {
                onFailure(self.message)
            }
        case .string(let value):
            print("String status: \(value)")
            if let onStringStatus {
                onStringStatus(value)
            }
        case .int(let value):
            print("Integer status: \(value)")
            if(value == 1) {
                onSuccess()
            } else {
                onFailure(self.message)
            }
        case .yesNo(let value):
            print("Yes/No status: \(value)")
            if(value) {
                onSuccess()
            } else {
                onFailure(self.message)
            }
        case .oneZero(let value):
            if(value) {
                onSuccess()
            } else {
                onFailure(self.message)
            }
        case .unknown:
            print("Unknown status")
            if let onStringStatus {
                onStringStatus(self.message)
            }
        }
    }
}
