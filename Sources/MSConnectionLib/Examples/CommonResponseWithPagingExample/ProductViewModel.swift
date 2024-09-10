//
//  ProductViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var product: Product? = nil
    @Published var errorMessages: [String] = []
    @Published var pagingViewModel: PagingViewModel<Product> = .init(endPoint: "products" , lang: "en")
    
    private var networkManager = ProductNetworkManager()
    private var nextPageUrl: String? = nil
    private var isLoading = false

    @MainActor
    func fetchSingleProduct(_ id: Int) async {
        let result = await networkManager.getSingleProductsData(id: id)
        switch result {
        case .success(let response):
            response.handleStatus {
                self.product = response.data?.product
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st, st == "success" {
                    self.product = response.data?.product
                }
            }
        case .failure(let error):
            print("Failed to fetch product: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
    
    private func loadData(_ isInitial:Bool = true) async {
        self.product = nil
        if(isInitial) {
            await pagingViewModel.fetchInitialData()
        } else {
            await pagingViewModel.fetchNextPage()
        }
        self.products = pagingViewModel.items
    }
}

class ProductsPagingViewModel: PagingViewModel<Product> {
//    @Published var products: [Product] = []
//    @Published var product: Product? = nil
//    @Published var errorMessages: [String] = []
//    @Published var pagingViewModel: PagingViewModel<Product> = .init(endPoint: "products" , lang: "en")
    
    init(lang: String) {
        super.init(endPoint: APIs.ProductAPIs.main.url(), lang: lang)
    }
    
    private var networkManager = ProductNetworkManager()
    private var nextPageUrl: String? = nil
    private var isLoading = false
    
    private func loadData(_ isInitial:Bool = true) async {
        if(isInitial) {
            await fetchInitialData()
        } else {
            await fetchNextPage()
        }
//        self.products = pagingViewModel.items
    }
}
