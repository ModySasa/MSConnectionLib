//
//  PaginationViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


import Foundation
import SwiftUI

public class PaginationViewModel : ObservableObject {
    @Published public var isLoadingMore : Bool = false
    @Published public var hasNextPage : Bool = false
    @Published public var shouldLoadMore : Bool = true
    @Published public var paginationModel : PaginationModel = .init()
    
    public var nextPageUrl : String = ""
    
    public func handlePaging(_ paginationModel : PaginationModel) {
        if let next_page_url = paginationModel.next_page_url , let total = paginationModel.total , let per_page = paginationModel.per_page , let current_page = paginationModel.current_page , let last_page = paginationModel.last_page{
            hasNextPage = !next_page_url.isEmpty || total > (current_page * per_page) || last_page > current_page
            nextPageUrl = next_page_url
        }
    }
}
