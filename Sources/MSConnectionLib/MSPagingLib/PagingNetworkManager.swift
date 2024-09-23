//
//  PagingNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//

actor PagingNetworkManager<Item: Identifiable & Codable> : BaseUrlProviding{
    private let networkManager = NetworkManager()
    
    func getData(url: String , lang:String , token:String) async -> Result<CommonResponse<PaginatedResponse<Item>>, MultipleDecodingErrors> {
        let theUrl = if (url.matches("^https?://")) {
            url
        } else {
            getUrl(url)
        }
            
        return await networkManager.get(
            from: theUrl,
            lang: lang,
            parameters: networkManager.optionalBody,
            responseType: CommonResponse<PaginatedResponse<Item>>.self,
            token: token
        )
    }
}
