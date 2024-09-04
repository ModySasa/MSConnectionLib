//
//  Model.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

public struct OnReachEndModifier: ViewModifier {
    public init(item: AnyHashable, items: [AnyHashable], action: @escaping () -> Void) {
        self.item = item
        self.items = items
        self.action = action
    }
    
    let item: AnyHashable
    let items: [AnyHashable]
    let action: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if item == items.last {
                    action()
                }
            }
    }
}

public extension View {
    func onReachEnd<Item: Identifiable & Hashable>(item: Item, in items: [Item], perform action: @escaping () -> Void) -> some View {
        self.modifier(OnReachEndModifier(item: item, items: items.map { AnyHashable($0) }, action: action))
    }
}
