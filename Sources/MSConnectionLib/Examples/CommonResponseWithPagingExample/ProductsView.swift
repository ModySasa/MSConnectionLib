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
        VStack {
            if let p = productViewModel.product
                , let productName = p.name{
                Text(productName)
                    .foregroundStyle(.red)
                    .padding(.bottom , 50)
            } else {
                Spacer(minLength: 50)
            }
            ScrollView{
                LazyVStack(spacing:100) {
                    ForEach(productViewModel.products, id: \.id) { product in
                        ProductRow(product: product)
                            .onTapGesture {
                                Task{
                                    await productViewModel.fetchSingleProduct(product.id!)
                                }
                            }
                            .onReachEnd(item: product, in: productViewModel.pagingViewModel.items) {
                                Task {
                                    await productViewModel.fetchNextPage()
                                }
                            }
                            
                    }
                }
            }
            
            
        }
        .task {
            await productViewModel.fetchInitialData()
        }
    }
}

#Preview {
    ProductsView()
}
