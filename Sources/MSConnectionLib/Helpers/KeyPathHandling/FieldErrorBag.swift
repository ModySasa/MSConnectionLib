//
//  FieldErrorBag.swift
//  MyTestProject
//
//  Created by Moha on 11/19/25.
//


public struct FieldErrorBag<Model> {
    private var storage: [PartialKeyPath<Model>: String] = [:]

    public subscript(_ keyPath: PartialKeyPath<Model>) -> String? {
        storage[keyPath]
    }

    public mutating func insert(_ keyPath: PartialKeyPath<Model>, _ error: String) {
        storage[keyPath] = error
    }
    
    public init(storage: [PartialKeyPath<Model> : String] = [:]) {
        self.storage = storage
    }
}
