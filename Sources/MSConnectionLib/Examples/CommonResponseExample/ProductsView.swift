//
//  SwiftUIView.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var productViewModel: ProductViewModel = .init()
    
    var body: some View {
        VStack{
            ScrollView{
                VStack {
                    ForEach(productViewModel.products , id: \.id) { product in
                        ProductRow(product: product)
                            .onTapGesture {
                                Task {
                                    if let id = product.id {
                                        await productViewModel.fetchSingleProduct(id)
                                    }
                                }
                            }
                    }
                }
            }
            
            if let p = productViewModel.product
             , let productName = p.name{
                Text(productName)
                    .foregroundStyle(.red)
                    .padding(.top , 100)
            }
        }
        .task {
            await productViewModel.fetchData()
        }
    }
}

#Preview {
    ProductsView()
}

struct ProductRow : View {
    let product: Product
    
    var body: some View {
        HStack {
            if let productName = product.name {
                Text(productName)
            }
            Spacer()
            if let productPrice = product.price {
                Text(String(productPrice))
            }
        }
    }
}
