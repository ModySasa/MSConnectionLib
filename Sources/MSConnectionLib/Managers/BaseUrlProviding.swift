//
//  BaseUrlProviding.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//


public protocol BaseUrlProviding {
    var apiUrl: String { get }
    func getUrl(_ url:String) -> String
    func imageUrl(_ link: String , withApi : Bool) -> String
}

public extension BaseUrlProviding {
    func getUrl(_ url: String) -> String {
        return apiUrl + url
    }
    
    private var mainUrl: String {
        if let url = URLPrefHelper.shared.getUrl(key: .mainUrl) {
            return url
        } else {
            return ""
        }
    }
    
    private var testUrl: String {
        if let url = URLPrefHelper.shared.getUrl(key: .testUrl) {
            return url
        } else {
            return ""
        }
    }
    
    private var imgUrl: String {
        if let url = URLPrefHelper.shared.getUrl(key: .imageUrl) {
            return url
        } else {
            return ""
        }
    }
    
    func isTesting() -> Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    private func url() -> String {
        return isTesting() ? testUrl : mainUrl
    }
    
    var apiUrl: String {
        return url() + "/api/"
    }
    
    func imageUrl(_ link: String , withApi : Bool = false) -> String {
        if link.matches("^https?://") {
            return link
        } else {
            if(imgUrl.isEmpty) {
                let baseUrl = withApi ? apiUrl : url()
                return  baseUrl + link
            } else {
                return imgUrl + link
            }
        }
    }
}
