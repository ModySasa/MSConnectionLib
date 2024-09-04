//
//  PostNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation

actor ProductNetworkManager {
    private let networkManager = NetworkManager()

    func getProductsData() async -> Result<CommonResponse<ProductListResponse>, MultipleDecodingErrors> {
        // Define the URL and any other parameters
        let url = "https://systemira.online/api/products"
        let lang = "en"
//        let token = "your_token_here"

        // Call the `get` function
        return await networkManager.get(
            from: url,
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductListResponse>.self
        )
    }
    
    func getSingleProductsData(id:Int) async -> Result<CommonResponse<ProductResponse>, MultipleDecodingErrors> {
        // Define the URL and any other parameters
        let url = "https://systemira.online/api/products/\(id)"
        let lang = "en"
//        let token = "your_token_here"

        // Call the `get` function
        return await networkManager.get(
            from: url,
            lang: lang,
            body: networkManager.optionalBody,
            responseType: CommonResponse<ProductResponse>.self
        )
    }
}
