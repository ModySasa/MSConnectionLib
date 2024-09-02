//
//  PostNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//


import Foundation

actor PostNetworkManager {
    private let networkManager = NetworkManager()

    func getPostData() async -> Result<[PostModel], MultipleDecodingErrors> {
        let url = "https://jsonplaceholder.typicode.com/posts"
        return await networkManager.get(from: url, body: Optional<String>.none, responseType: [PostModel].self)
    }
}
