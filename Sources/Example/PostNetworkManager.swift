//
//  HomeNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//


import Foundation

actor PostNetworkManager {
    private let networkManager = NetworkManager()

    func getPostData() async -> Result<PostModel, MultipleDecodingErrors> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return .failure(MultipleDecodingErrors(errors: [.other(NSError(domain: "Invalid URL", code: 0, userInfo: nil))]))
        }
        return await networkManager.get(from: url, responseType: PostModel.self)
    }
}
