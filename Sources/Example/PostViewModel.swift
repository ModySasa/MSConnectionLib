//
//  HomeViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//


class PostViewModel: ObservableObject {
    @Published var data: [PostModel] = []
    @Published var errorMessages: [String] = []
    private var networkManager = PostNetworkManager()

    @MainActor
    func fetchData() async {
        let result = await networkManager.getPostData()
        switch result {
        case .success(let response):
            self.data = response
        case .failure(let errors):
            self.errorMessages = errors.errors.map { $0.description }
        }
    }
}
