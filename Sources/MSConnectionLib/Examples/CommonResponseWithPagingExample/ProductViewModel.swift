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
    @Published var pagingViewModel: PagingViewModel<Product> = .init(initialUrl: "https://systemira.online/api/products")
    
    private var networkManager = ProductNetworkManager()
    private var nextPageUrl: String? = nil
    private var isLoading = false

    @MainActor
    func fetchInitialData() async {
        await loadData()
    }

    @MainActor
    func fetchSingleProduct(_ id: Int) async {
        let result = await networkManager.getSingleProductsData(id: id)
        switch result {
        case .success(let response):
            response.handleStatus {
                self.product = response.data.product
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st, st == "success" {
                    self.product = response.data.product
                }
            }
        case .failure(let error):
            print("Failed to fetch product: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchNextPage() async {
        await loadData(false)
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
    
    private func handleResponse(_ response: CommonResponse<ProductListResponse>){
        if let prods = response.data.data {
            self.products.append(contentsOf: prods)
            print("Fetched \(prods.count) products")
            print("Total Fetched \(self.products.count) products")
        }
        self.nextPageUrl = response.data.links?.next
    }
}
