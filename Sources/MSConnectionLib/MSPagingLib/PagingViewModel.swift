//
//  PaginationViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

public class PagingViewModel<Item: Identifiable & Codable>: ObservableObject {
    @Published public var items: [Item] = []
    @Published public var errorMessages: [String] = []
    
    private var nextPageUrl: String?
    private var isLoading = false
    private let endPoint: String
    private let networkManager: PagingNetworkManager<Item> = .init()
    private let lang: String
    private let token: String
    
    public init(endPoint: String , lang : String) {
        self.endPoint = endPoint
        self.lang = lang
        if let tok = URLPrefHelper.shared.getToken() {
            self.token = tok
        } else {
            self.token = ""
        }
    }
    
    @MainActor
    public func fetchInitialData() async {
        await loadData(from: endPoint)
    }
    
    @MainActor
    public func fetchNextPage() async {
        guard let nextPageUrl = nextPageUrl, !isLoading else {
            return
        }
        await loadData(from: nextPageUrl)
    }
    
    private func loadData(from url: String) async {
        isLoading = true
        defer { isLoading = false }
        let result = await networkManager.getData(url: url, lang: lang, token: token)
        switch result {
        case .success(let response):
            response.handleStatus {
                if let newItems = response.data?.data {
                    self.items.append(contentsOf: newItems)
                }
                self.nextPageUrl = response.data?.links?.next
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st, st == "success" {
                    if let newItems = response.data?.data {
                        self.items.append(contentsOf: newItems)
                    }
                    self.nextPageUrl = response.data?.links?.next
                }
            }
        case .failure(let error):
            print("Failed to fetch items: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
}
