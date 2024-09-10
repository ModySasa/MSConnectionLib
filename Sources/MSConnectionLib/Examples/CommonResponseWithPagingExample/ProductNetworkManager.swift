//
//  PostNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

actor ProductNetworkManager : ProductNetworkManagerProtocol , BaseUrlProviding{
    private let networkManager = NetworkManager()
    
    func getProductsData() async -> Result<CommonResponse<ProductListResponse>, MultipleDecodingErrors> {
        let lang = "en"
        return await networkManager.get(
            from: getUrl(getProductsUrl),
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductListResponse>.self
        )
    }
    
    func getSingleProductsData(id: Int) async -> Result<CommonResponse<ProductResponse>, MultipleDecodingErrors> {
        let url = getUrl(singleProductUrl) + "\(id)"
        let lang = "en"
        return await networkManager.get(
            from: url,
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductResponse>.self
        )
    }
}

protocol ProductNetworkManagerProtocol {
    var getProductsUrl: String { get }
    var singleProductUrl: String { get }
    func getProductsData() async -> Result<CommonResponse<ProductListResponse>, MultipleDecodingErrors>
    func getSingleProductsData(id: Int) async -> Result<CommonResponse<ProductResponse>, MultipleDecodingErrors>
}

extension ProductNetworkManagerProtocol {
    var getProductsUrl: String { APIs.ProductAPIs.main.url() }
    var singleProductUrl: String { APIs.ProductAPIs.single.url() }
}

fileprivate extension APIs {
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
