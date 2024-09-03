//
//  GeneralViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI
import FirebaseRemoteConfig
import FirebaseDatabase
import OSLog
import CoreLocation

open class GeneralViewModel : ObservableObject {
    @Published public var firebaseViewModel : FireBaseViewModel
    
    @Published public var passedData : [AnyObject]
    
    @Published public var savedData : [String:Any]
    
    @Published public var drawerIndex : Int = 0
    @Published public var bottomNavIndex : Int = 0
    @Published public var shouldRestore : Bool = false
    
    public var isLoading = [Bool]()
    
    public init(
        isLoading: [Bool] = [Bool](),
        mainUrl: String = "https://jsonplaceholder.typicode.com/",
        testUrl: String = "https://jsonplaceholder.typicode.com/",
        passedData : [AnyObject] = .init() ,
        savedData : [String:Any] = .init() ,
        isFirstTime : Bool = true ,
        drawerIndex : Int = 0 ,
        bottomNavIndex : Int = 0 ,
        shouldRestore : Bool = false ,
        firebaseViewModel:FireBaseViewModel? = nil
    ) {
        self.isLoading = isLoading
        self.passedData = passedData
        self.savedData = savedData
        self.drawerIndex = drawerIndex
        self.bottomNavIndex = bottomNavIndex
        self.shouldRestore = shouldRestore
        if(isFirstTime){
            self.firebaseViewModel = .init()
        } else {
            self.firebaseViewModel = firebaseViewModel!
        }
    }
    
    //MARK: passing objects between pages
    public func passObject(_ obj:AnyObject , clearOlder:Bool = true) {
        if(clearOlder) {
            passedData = .init()
        }
        passedData.append(obj)
    }
    
    public func removeObj(_ obj:AnyObject) {
        passedData.removeAll { myObj in
            obj === myObj
        }
    }
    
    public func passString(_ text:String) {
        passObject(text as AnyObject, clearOlder: false)
    }
    
    public func passInt(_ num : Int) {
        passObject(num as AnyObject, clearOlder: false)
    }
    
    public func passBool(_ bool : Bool) {
        passObject(bool as AnyObject, clearOlder: false)
    }
    
    public func passObj(_ obj : any Identifiable) {
        passObject(obj as AnyObject, clearOlder: false)
    }
    
    //MAKE AN ENUM WITH THE KEYS AND FUNCTIONS TO USE THE ENUM INSTEAD
    public func saveData(_ key : String , value : Any) {
        savedData[key] = value
    }
    
    public func revomeData(_ key : String) {
        savedData.removeValue(forKey: key)
    }
    
    public var logger: Logger {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            let logger = Logger(subsystem: bundleIdentifier, category: String(describing: type(of: self)))
            return logger
        } else {
            let logger = Logger(subsystem: "bundleIdentifier", category: String(describing: type(of: self)))
            return logger
        }
    }
    
    public enum PasswordStrength {
        case VeryStrong
        case Strong
        case Medium
        case Weak
    }

    public func checkPasswordStrength(_ password: String) -> PasswordStrength {
        var score = 0

        // Check for the presence of different character types
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecialCharacter = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/")) != nil

        // Assign scores based on the criteria
        if hasUppercase {
            score += 2
        }
        if hasLowercase {
            score += 2
        }
        if hasDigit {
            score += 2
        }
        if hasSpecialCharacter {
            score += 2
        }

        // Check the total length of the password and assign a score
        let length = password.count
        if length >= 8 {
            score += 2
        } else if length >= 12 {
            score += 4
        }

        // Determine the password strength level based on the score
        switch score {
        case 8...10:
            return .VeryStrong
        case 6...7:
            return .Strong
        case 4...5:
            return .Medium
        default:
            return .Weak
        }
    }
    
    public enum LocationOptions : String {
        case justShowLocation = "justShowLocation"
        case isPickLocation = "isPickLocation"
        case shouldShowHome = "shouldShowHome"
        case canTapMap = "canTapMap"
        case currentLocation = "currentLocation"
        case currentLocationAddress = "currentLocationAddress"
    }

    open func saveLocationOptions(
        justShowLocation:Bool
        , isPickLocation:Bool
        , shouldShowHome:Bool
        , canTapMap:Bool = false
        , locations : [CLLocationCoordinate2D]? = nil
        , locationsAddresses : [String]? = nil
        , openMap : @escaping ()->Void
    ) {
        if let locations , let locationsAddresses{
            saveData(
                LocationOptions.currentLocation.rawValue
                , value: locations
            )
            saveData(
                LocationOptions.currentLocationAddress.rawValue
                , value: locationsAddresses
            )
        }
        saveData(LocationOptions.justShowLocation.rawValue, value: justShowLocation)
        saveData(LocationOptions.canTapMap.rawValue, value: canTapMap)
        saveData(LocationOptions.isPickLocation.rawValue, value: isPickLocation)
        saveData(LocationOptions.shouldShowHome.rawValue, value: shouldShowHome)
        openMap()
    }
}
