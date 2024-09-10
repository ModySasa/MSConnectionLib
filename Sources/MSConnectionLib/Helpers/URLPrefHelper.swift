//
//  URLPrefHelper.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//

import Foundation

public class URLPrefHelper{
    public static let shared = URLPrefHelper.init()
    
    public func setUrls(mainUrl:String = "" , testUrl:String = "" , imageUrl:String = ""){
        setUrl(key: .mainUrl, value: mainUrl as AnyObject)
        setUrl(key: .testUrl, value: testUrl as AnyObject)
        setUrl(key: .imageUrl, value: imageUrl as AnyObject)
    }
    
    private func setUrl(key:URLKeys , value:AnyObject){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getUrl(key:URLKeys) -> String? {
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: key.rawValue) {
            return stringOne
        } else{
            return nil
        }
    }
}

public enum URLKeys:String {
    case mainUrl = "mainUrl"
    case testUrl = "testUrl"
    case imageUrl = "imageUrl"
}
