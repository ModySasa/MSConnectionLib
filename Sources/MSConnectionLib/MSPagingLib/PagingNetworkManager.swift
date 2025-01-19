//
//  PagingNetworkManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//

actor PagingNetworkManager<Item: Identifiable & Codable> : BaseUrlProviding{
    private let networkManager = NetworkManager()
    
    func getData<U:Encodable>(url: String , lang:String , token:String , parameters: U? = nil) async -> Result<CommonResponse<PaginatedResponse<Item>>, MultipleDecodingErrors> {
        let theUrl = if (url.matches("^https?://")) {
            print("`````` 1st url \(url)")
            return url
        } else {
            print("```````` heere else url  \(url)")
            return getUrl(url)
        }
        
        print("```````` theUrl \(theUrl)")
        if let parameters {
            return await networkManager.get(
                from: theUrl,
                lang: lang,
                parameters: parameters,
                responseType: CommonResponse<PaginatedResponse<Item>>.self,
                token: token
            )
        } else {
            return await networkManager.get(
                from: theUrl,
                lang: lang,
                parameters: networkManager.optionalBody,
                responseType: CommonResponse<PaginatedResponse<Item>>.self,
                token: token
            )
        }
        
    }
}
