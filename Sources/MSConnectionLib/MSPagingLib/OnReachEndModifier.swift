//
//  Model.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

public struct OnReachEndModifier<Item : Identifiable & Codable , vm: PagingViewModel>: ViewModifier {
    public init(item: Item, viewModel:vm, action: (() -> Void)? = nil) {
        self.item = item
        self.viewModel = viewModel
        self.action = action
    }
    
    let item: Item
    let viewModel: PagingViewModel<Item , ProductRequest>
    let action: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if let last = viewModel.items.last {
                    if item.id == last.id {
                        if let action {
                            action()
                        }
                        Task {
                            await viewModel.fetchNextPage()
                        }
                    }
                }
            }
    }
}

public extension View {
//    func onReachEnd<Item: Identifiable & Codable>(item: Item, viewModel : PagingViewModel<Item , ProductRequest>, perform action: (() -> Void)? = nil) -> some View {
//        self.modifier(OnReachEndModifier(item: item, viewModel: viewModel, action: action))
//    }
    
    func onReachEnd<Item: Identifiable & Codable , vm: PagingViewModel>(item: Item, viewModel :  vm , perform action: (() -> Void)? = nil) -> some View {
            self.modifier(OnReachEndModifier(item: item, viewModel: viewModel, action: action))
        }
}
