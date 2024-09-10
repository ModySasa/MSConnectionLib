//
//  ProductNetworkManagerProtocol.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//


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