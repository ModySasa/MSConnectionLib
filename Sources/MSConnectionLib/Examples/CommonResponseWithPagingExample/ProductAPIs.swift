//
//  ProductAPIs.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//


extension APIs {
    enum ProductAPIs : String {
        case main = "products"
        case single = "/"
        
        func url() -> String {
            if( self == .main) {
                return self.rawValue
            } else {
                return APIs.ProductAPIs.main.rawValue + self.rawValue
            }
        }
    }
}
