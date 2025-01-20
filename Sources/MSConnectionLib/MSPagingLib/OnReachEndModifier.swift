//
//  Model.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

public struct OnReachEndModifier<Item: Identifiable & Codable, U: Codable , R: Codable , VM:BaseViewModel>: ViewModifier {
    public init(item: Item, viewModel: PagingViewModel<Item, U , R , VM>, action: (() -> Void)? = nil) {
        self.item = item
        self.viewModel = viewModel
        self.action = action
    }
    
    let item: Item
    let viewModel: PagingViewModel<Item, U , R , VM>
    let action: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if let last = viewModel.items.last {
                    if item.id == last.id {
                        action?()
                        Task {
                            await viewModel.fetchNextPage()
                        }
                    }
                }
            }
    }
}

public extension View {
    func onReachEnd<Item: Identifiable & Codable, U: Codable , R:Codable , VM:BaseViewModel>(item: Item, viewModel: PagingViewModel<Item, U , R , VM>, perform action: (() -> Void)? = nil) -> some View {
        self.modifier(OnReachEndModifier(item: item, viewModel: viewModel, action: action))
    }
}
