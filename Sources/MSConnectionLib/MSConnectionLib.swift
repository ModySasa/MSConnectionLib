public actor MSConnectionLib{
    static let shared = MSConnectionLib()
    
    public let networkManager: NetworkManager = NetworkManager()
}
