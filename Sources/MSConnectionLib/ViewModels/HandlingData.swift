//
//  HandlingData.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

public class HandlingData{
    public static let shared = HandlingData.init()
    
    //// fetting Data from server
    public func getString(data:[String:AnyObject] , dataName: String) -> String {
        var value : String = ""
        
        if(data["\(dataName)"] is NSNull){
            value = ""
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is String) {
                    value = data["\(dataName)"] as! String
                    if ((data["\(dataName)"] as! String) == "null") {
                        value = ""
                    }
                }
            }
            
        }
        return value
    }
    
    public func getString(data:[AnyHashable:Any] , dataName: String) -> String {
        var value : String = ""
        
        if(data["\(dataName)"] is NSNull){
            value = ""
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is String) {
                    value = data["\(dataName)"] as! String
                    if ((data["\(dataName)"] as! String) == "null") {
                        value = ""
                    }
                }
            }
        }
        return value
    }
    
    public func getBool(data:[String:AnyObject] , dataName: String) -> Bool {
        var value : Bool = false
        
        if(data["\(dataName)"] is NSNull){
            value = false
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Bool) {
                    value = data["\(dataName)"] as! Bool
                }
            }
        }
        return value
    }
    
    public func getBool(data:[String:Any] , dataName: String) -> Bool {
        var value : Bool = false
        
        if(data["\(dataName)"] is NSNull){
            value = false
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Bool) {
                    value = data["\(dataName)"] as! Bool
                }
            }
        }
        return value
    }
    
    public func getInt(data:[String:AnyObject] , dataName: String) -> Int {
        var value : Int = 0
        if(data["\(dataName)"] is NSNull){
            value = 0
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Int) {
                    value = data["\(dataName)"] as! Int
                }
            }
        }
        return value
    }
    
    public func getInt(data:[AnyHashable:Any] , dataName: String) -> Int {
        var value : Int = 0
        if(data["\(dataName)"] is NSNull){
            value = 0
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Int) {
                    value = data["\(dataName)"] as! Int
                }
            }
        }
        return value
    }
    
    public func getNumber(data:[String:AnyObject] , dataName: String) -> NSNumber {
        var value : NSNumber = -1
        if(data["\(dataName)"] is NSNull){
            value = -1
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is NSNumber){
                    value = data["\(dataName)"] as! NSNumber
                }
            }
        }
        return value
    }
    
    public func getDouble(data:[String:AnyObject] , dataName: String) -> Double {
        var value : Double = -1.0
        
        if(data["\(dataName)"] is NSNull){
            value = -1.0
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Double){
                    value = data["\(dataName)"] as! Double
                }
            }
        }
        return value
    }
    
    public func getDouble(data:[AnyHashable:Any] , dataName: String) -> Double {
        var value : Double = -1.0
        
        if(data["\(dataName)"] is NSNull){
            value = -1.0
        } else {
            if(data["\(dataName)"] != nil){
                if(data["\(dataName)"] is Double){
                    value = data["\(dataName)"] as! Double
                }
            }
        }
        return value
    }
    
    public func getUnCertainNSNumber(data:[String:AnyObject] , dataName: String) -> NSNumber {
        var num = NSNumber.init(value:0)
        
        if(data[dataName] is NSNumber) {
            num = getNumber(data: data, dataName: dataName)
        } else if (data[dataName] is String) {
            let value = getString(data: data, dataName: dataName)
            if(!value.isEmpty){
                if(Double(value) != nil) {
                    num = NSNumber(value: Double(value)!)
                } else {
                    num = NSNumber(value: Int(value)!)
                }
            }
        }
        return num
    }
    
    public func getUnCertainInt(data:[String:AnyObject] , dataName: String) -> Int {
        var num = 0
        
        if(data[dataName] is NSNumber) {
            num = getInt(data: data, dataName: dataName)
        } else if (data[dataName] is String) {
            let value = getString(data: data, dataName: dataName)
            if(!value.isEmpty){
                if Int(value) != nil {
                    num = Int(value)!
                }
                
            }
        } else if(data["\(dataName)"] is Int) {
            num = data["\(dataName)"] as! Int
        }
        
        return num
    }
    
    public func getUnCertainInt(data:[AnyHashable:Any] , dataName: String) -> Int {
        var num = 0
        
        if(data[dataName] is NSNumber) {
            num = getInt(data: data, dataName: dataName)
        } else if (data[dataName] is String) {
            let value = getString(data: data, dataName: dataName)
            if(!value.isEmpty){
                if Int(value) != nil {
                    num = Int(value)!
                }
                
            }
        } else if(data["\(dataName)"] is Int) {
            num = data["\(dataName)"] as! Int
        }
        return num
    }
    
    public func getUnCertainDouble(data:[String:AnyObject] , dataName: String) -> Double {
        var num : Double = 0
        
        if(data[dataName] is NSNumber) {
            num = getDouble(data: data, dataName: dataName)
        } else if (data[dataName] is String) {
            let value = getString(data: data, dataName: dataName)
            if(!value.isEmpty){
                num = Double(value)!
            }
        }
        return num
    }
    
    public func getUnCertainDouble(data:[AnyHashable:Any] , dataName: String) -> Double {
        var num : Double = 0
        
        if(data[dataName] is NSNumber) {
            num = getDouble(data: data, dataName: dataName)
        } else if (data[dataName] is String) {
            let value = getString(data: data, dataName: dataName)
            if(!value.isEmpty){
                num = Double(value)!
            }
        }
        return num
    }
    
    public func fillListByName(jsonObject: [String : AnyObject] , jsonName : String , onObjGet: @escaping ([String:AnyObject])-> Void){
        if(jsonObject[jsonName] != nil){
            if(jsonObject[jsonName] is [[String:AnyObject]]) {
                if(!(jsonObject[jsonName] as! [[String:AnyObject]]).isEmpty){
                    for item in (jsonObject[jsonName] as! [[String:AnyObject]]) {
                        onObjGet(item)
                    }
                }
            }
        }
    }
    
    public func fillListByName(jsonObject: [String : Any] , jsonName : String , onObjGet: @escaping ([String:Any])-> Void){
        if(jsonObject[jsonName] != nil){
            if(jsonObject[jsonName] is [[String:Any]]) {
                if(!(jsonObject[jsonName] as! [[String:Any]]).isEmpty){
                    for item in (jsonObject[jsonName] as! [[String:Any]]) {
                        onObjGet(item)
                    }
                }
            }
        }
    }
    
    public func getObject(jsonObject: [String : AnyObject] , jsonName : String , onObjGet: @escaping ([String:AnyObject])-> Void){
        if(jsonObject[jsonName] != nil){
            if (jsonObject[jsonName] is [String:AnyObject]) {
                let item = jsonObject[jsonName] as! [String:AnyObject]
                onObjGet(item)
            }
        }
    }
    
    public func getTheSelectKeysAndValues(_ jsonResponseData:Data , key : String) -> (selectKeys:[String] , selectValues:[String]){
        // Convert Data to String
        let jsonResponse = String(data: jsonResponseData, encoding: .utf8)!
        // Extract the "event_select" part from the JSON string
        guard let selectString = extractSelectString(from: jsonResponse, key: key) else {
            print("Error: 'Select type \(key)' not found in JSON response.")
            return ([String]() , [String]())
        }
        // Create an empty array to store key-value pairs
        var selectKeys = [String]()
        var selectValues = [String]()
        // Use NSRegularExpression to extract keys and values
        let keyValuePattern = #""([^"]*)":\s*"([^"]*)""#

        do {
            let regex = try NSRegularExpression(pattern: keyValuePattern, options: [])
            
            let matches = regex.matches(in: selectString, options: [], range: NSRange(selectString.startIndex..., in: selectString))
            
            for match in matches {
                let keyRange = match.range(at: 1)
                let valueRange = match.range(at: 2)
                
                if let key = Range(keyRange, in: selectString),
                   let value = Range(valueRange, in: selectString) {
                    var keyString = String(selectString[key])
                    var valueString = String(selectString[value])
                    // Convert Unicode escape sequences to actual characters
                    keyString = keyString.replacingOccurrences(of: "\\u", with: "\\")
                    valueString = valueString.replacingOccurrences(of: "\\u", with: "\\")
                    
                    selectKeys.append(keyString)
//                    var arabicText = changeArabicQuery(from: convertToCurlyBraceSyntax(valueString))
                    selectValues.append(valueString)
                }
            }
            
            
//            eventSelect = orderOfKeys.compactMap { theKey in
//                        guard let value = eventSelectDict[theKey] else { return nil }
//                        return ["key": theKey, "value": value]
//                    }
            if let valsData = try JSONSerialization.jsonObject(with: jsonResponseData, options : .allowFragments) as? [String:AnyObject] {
                self.getObject(jsonObject: valsData, jsonName: "data", onObjGet: { obj in
                    let valsHelper_1 = obj
                    self.getObject(jsonObject: valsHelper_1, jsonName: "\(key)", onObjGet: { obj_2 in
                        let list = obj_2
                        var eventSelect: [(key: String, value: String)] = []
//                        var myValsUnSorted = [String]()
                        for (famKey , famVal) in list {
                            eventSelect.append((famKey, famVal as! String))
//                            myValsUnSorted.append(famVal as! String)
                        }
                        eventSelect = selectKeys.compactMap { key in
                            let value = list[key]
                            return (key,value) as! (key: String, value: String)
                        }
                        
                        selectValues = eventSelect.map({ (_, value) in
                            return value
                        })
                        
                        print("I AM HERE NOW::: selectValues are : : : : \(eventSelect)")
                    })
                })
            }
        } catch {
            print("Error while using regular expression.")
            exit(1)
        }
    //
    //        // Print the results
            print("I AM HERE NOW::: selectValues are : KEYSSSS", selectKeys)
            print("I AM HERE NOW::: selectValues are :", selectValues)
        
        return (selectKeys , selectValues)
    }

    // Create a helper function to find the range of "event_select" in the JSON string
    func extractSelectString(from jsonString: String  , key dictionaryName: String) -> String? {
        let pattern = #""\#(dictionaryName)"\s*:\s*\{[^}]+\}"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let range = NSRange(jsonString.startIndex..., in: jsonString)
        if let match = regex.firstMatch(in: jsonString, options: [], range: range) {
            return String(jsonString[Range(match.range, in: jsonString)!])
        }
        return nil
    }
    
    func convertToCurlyBraceSyntax(_ input: String) -> String {
        var result = ""
        var currentIndex = input.startIndex
        
        while currentIndex < input.endIndex {
            if input[currentIndex] == "\\" && input[input.index(after: currentIndex)] == "u" {
                let startIndex = input.index(currentIndex, offsetBy: 2)
                let endIndex = input.index(startIndex, offsetBy: 4)
                let hexString = input[startIndex..<endIndex]
                
                if let unicodeScalar = UnicodeScalar(UInt32(hexString, radix: 16)!) {
                    result.append("\\u{\(hexString)}")
                } else {
                    result.append("\\u\(hexString)")
                }
                
                currentIndex = endIndex
            } else {
                result.append(input[currentIndex])
                currentIndex = input.index(after: currentIndex)
            }
        }
        
        return result
    }
    
    func changeArabicQuery(from unicodeString:String) -> String{
        let convertedText = unicodeString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        return convertedText ?? ""
    }
}
