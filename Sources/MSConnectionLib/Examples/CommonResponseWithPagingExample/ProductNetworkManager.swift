//
//  PostNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

actor ProductNetworkManager {
    private let networkManager = NetworkManager()
    
    func getProductsData(from url: String) async -> Result<CommonResponse<ProductListResponse>, MultipleDecodingErrors> {
        let lang = "en"
        return await networkManager.get(
            from: url,
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductListResponse>.self
        )
    }
    
    func getSingleProductsData(id: Int) async -> Result<CommonResponse<ProductResponse>, MultipleDecodingErrors> {
        let url = "https://systemira.online/api/products/\(id)"
        let lang = "en"
        return await networkManager.get(
            from: url,
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductResponse>.self
        )
    }
}
