//
//  ErrorLogger.swift
//  MSConnectionLib
//
//  Created by Moha on 9/1/24.
//

import OSLog

class ErrorLogger {
    static var shared:ErrorLogger = ErrorLogger()
    
     func debug(_ message:String , className : String = "") {
        let errorLogger : OSLog = .init(subsystem: "com.mohamed.MSConnectionLib", category: className)
        let logger = Logger(errorLogger)
        
         if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
             // Running in a SwiftUI Preview
             print("Debug: \(message)")
         } else {
             // Running on an actual device or simulator in DEBUG mode
             logger.debug("\(message)")
         }
    }
    
    func error(_ message:String , className : String = "") {
        let errorLogger : OSLog = .init(subsystem: "com.mohamed.MSConnectionLib", category: className)
        let logger = Logger(errorLogger)
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Running in a SwiftUI Preview
            print("Error: \(message)")
        } else {
            // Running on an actual device or simulator in DEBUG mode
            logger.debug("\(message)")
        }
    }
}
