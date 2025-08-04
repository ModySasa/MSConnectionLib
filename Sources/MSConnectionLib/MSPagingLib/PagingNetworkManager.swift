//
//  PagingNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//

actor PagingNetworkManager<Item: Identifiable & Codable , R: Codable> : BaseUrlProviding{
    private let networkManager = NetworkManager()
    
    func getData<U:Encodable>(url: String , lang:String , token:String , parameters: U? = nil) async -> Result<CommonResponse<PaginatedResponse<Item , R>>, MultipleDecodingErrors> {
        let theUrl = if (url.matches("^https?://")) {
            url
        } else {
            getUrl(url)
        }
        if let parameters {
            return await networkManager.get(
                from: theUrl,
                lang: lang,
                parameters: parameters,
                responseType: CommonResponse<PaginatedResponse<Item , R>>.self,
                token: token
            )
        } else {
            return await networkManager.get(
                from: theUrl,
                lang: lang,
                parameters: networkManager.optionalBody,
                responseType: CommonResponse<PaginatedResponse<Item , R>>.self,
                token: token
            )
        }
        
    }
    
    func postData<U:Encodable>(url: String , lang:String , token:String , parameters: U? = nil) async -> Result<CommonResponse<PaginatedResponse<Item , R>>, MultipleDecodingErrors> {
        let theUrl = if (url.matches("^https?://")) {
            url
        } else {
            getUrl(url)
        }
        if let parameters {
            return await networkManager.post(
                to: theUrl,
                httpMethod: .post,
                lang: lang,
                body: parameters,
                responseType: CommonResponse<PaginatedResponse<Item , R>>.self,
                token: token
            )
        } else {
            return await networkManager.post(
                to: theUrl,
                httpMethod: .post,
                lang: lang,
                body: networkManager.optionalBody,
                responseType: CommonResponse<PaginatedResponse<Item , R>>.self,
                token: token
            )
        }
        
    }
}
