//
//  SwiftUIView.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var productViewModel: ProductViewModel = .init()
    @StateObject var productPagingViewModel: ProductsPagingViewModel = .init(lang: "en")
    @AppStorage("token") var token : String?
    
    var body: some View {
        VStack {
            if let p = productViewModel.product
                , let productName = p.name {
                Text(productName)
                    .foregroundStyle(.red)
                    .padding(.bottom , 50)
            } else {
                Spacer(minLength: 50)
            }
            ScrollView{
                LazyVStack(spacing:100) {
                    ForEach(productPagingViewModel.items, id: \.id) { product in
                        ProductRow(product: product)
                            .onTapGesture {
                                Task{
                                    await productViewModel.fetchSingleProduct(product.id!)
                                }
                            }
                            .onReachEnd(
                                item: product
                                , viewModel: productPagingViewModel
                            )
                    }
                }
            }
        }
        .task {
            //TODO : SET THE BASE URL NEEDED
            URLPrefHelper.shared.setUrls(mainUrl: "https://freshzone.manfazy.com", testUrl: "https://freshzone.manfazy.com")
            token = "73|6lrbq7MXMdal3TR182Nyr1iVH1VTYQ7DMkWawew07769fc4c"
            await productPagingViewModel.fetchInitialData(parameters: ProductRequest())
        }
    }
}

#Preview {
    ProductsView()
}
