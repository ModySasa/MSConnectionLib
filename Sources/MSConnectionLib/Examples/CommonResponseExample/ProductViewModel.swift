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
    private var networkManager = ProductNetworkManager()

    @MainActor
    func fetchData() async {
        self.product = nil
        let result = await networkManager.getProductsData()
        switch result {
        case .success(let response):
            // Process the successful response
            response.handleStatus {
                if let ps = response.data.data {
                    self.products = ps
                }
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st {
                    if(st == "success") {
                        if let ps = response.data.data {
                            self.products = ps
                        }
                    }
                }
            }
        case .failure(let error):
            // Handle the error
            print("Failed to fetch products: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchSingleProduct(_ id:Int) async {
        let result = await networkManager.getSingleProductsData(id: id)
        switch result {
        case .success(let response):
            // Process the successful response
            response.handleStatus {
                self.product = response.data.product
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st {
                    if(st == "success") {
                        self.product = response.data.product
                    }
                }
            }
        case .failure(let error):
            // Handle the error
            print("Failed to fetch products: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
}
