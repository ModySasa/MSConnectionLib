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
            parameters: networkManager.optionalBody,
            responseType: CommonResponse<ProductListResponse>.self
        )
    }
    
    func getSingleProductsData(id: Int) async -> Result<CommonResponse<ProductResponse>, MultipleDecodingErrors> {
        let url = getUrl(singleProductUrl) + "\(id)"
        let lang = "en"
        return await networkManager.get(
            from: url,
            lang: lang,
            parameters: networkManager.optionalBody,
            responseType: CommonResponse<ProductResponse>.self
        )
    }
}




