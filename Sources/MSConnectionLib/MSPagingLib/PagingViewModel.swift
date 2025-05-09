//
//  PaginationViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

open class PagingViewModel<Item: Identifiable & Codable , U : Codable , Result : Codable , VM:BaseViewModel>: ObservableObject {
    @Published public var items: [Item] = []
    @Published public var errorMessages: [String] = []
    @Published public var result : Result? = nil
    @Published public var vm : VM? = nil
    
    private var nextPageUrl: String?
    @Published public var totalItemsCount: Int?
    @Published public var totalPagesCount: Int?
    private var isLoading = false
    private let endPoint: String
    private let networkManager: PagingNetworkManager<Item , Result> = .init()
    private let lang: String
    private let token: String
    private var parameters : U?
    private var isPost : Bool = false
    
    public init(endPoint: String , lang : String , isPost : Bool = false , parameters: U? = nil , vm: VM? = nil) {
        self.endPoint = endPoint
        self.lang = lang
        self.isPost = isPost
        if let tok = URLPrefHelper.shared.getToken() {
            self.token = tok
        } else {
            self.token = ""
        }
        self.parameters = parameters
        self.vm = vm
    }
    
    @MainActor
    public func fetchInitialData(parameters: U?) async {
        self.parameters = parameters
        await loadData(from: endPoint)
    }
    
    @MainActor
    public func fetchNextPage() async {
        guard let nextPageUrl = nextPageUrl, !isLoading else {
            return
        }
        await loadData(from: nextPageUrl)
    }
    
    @MainActor
    private func loadData(from url: String) async {
        isLoading = true
        defer { isLoading = false }

        let result = if(!isPost) {
            await networkManager.getData(url: url, lang: lang, token: token , parameters: parameters)
        } else {
            await networkManager.postData(url: url, lang: lang, token: token, parameters: parameters)
        }
        switch result {
        case .success(let response):
            response.handleStatus {
                if let newItems = response.data?.data {
                    self.items.append(contentsOf: newItems)
                }
                self.result = response.data?.additionalData
                self.nextPageUrl = response.data?.links?.next
                self.totalItemsCount = response.data?.meta?.total ?? 0
                self.totalPagesCount = response.data?.meta?.total_pages ?? 0
            } onFailure: { message in
                self.errorMessages.append(message)
            } onStringStatus: { st in
                if let st = st, st == "success" {
                    if let newItems = response.data?.data {
                        self.items.append(contentsOf: newItems)
                    }
                    self.result = response.data?.additionalData
                    self.nextPageUrl = response.data?.links?.next
                    self.totalItemsCount = response.data?.meta?.total ?? 0
                    self.totalPagesCount = response.data?.meta?.total_pages ?? 0
                }
            }
        case .failure(let error):
            print("Failed to fetch items: \(error)")
            self.errorMessages.append(error.localizedDescription)
        }
    }
}
