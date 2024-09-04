//
//  ProductRow.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import SwiftUI

struct ProductRow : View {
    let product: Product
    
    var body: some View {
        HStack {
            Image(systemName: "cart")
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
