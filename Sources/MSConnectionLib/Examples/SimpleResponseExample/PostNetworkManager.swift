//
//  PostNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//


import Foundation

actor PostNetworkManager : PostNetworkManagerProtocol , BaseUrlProviding {
    private let networkManager = NetworkManager()

    func getPostData() async -> Result<[PostModel], MultipleDecodingErrors> {
        let url = apiUrl + getPostUrl
        return await networkManager.get(from: url, body: Optional<String>.none, responseType: [PostModel].self)
    }
}

protocol PostNetworkManagerProtocol {
    var getPostUrl: String { get }
    func getPostData() async -> Result<[PostModel], MultipleDecodingErrors>
}

extension PostNetworkManagerProtocol {
    var getPostUrl: String { APIs.PostUrls.main.url() }
}

fileprivate extension APIs {
    enum PostUrls: String {
        case main = "/posts"
        case single = "/"
        
        func url()-> String {
            if(self == .main) {
                return self.rawValue
            } else {
                return APIs.PostUrls.main.rawValue + self.rawValue
            }
        }
    }
}
