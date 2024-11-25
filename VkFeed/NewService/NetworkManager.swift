//
//  NetworkManager.swift
//  VkFeed
//
//  Created by Илья Павлов on 20.11.2024.
//

protocol NetworkManagerProtocol {
    func makeRequest<T: Decodable>(with dto: RequestDTO, completion: @escaping (Result<T, APIError>) -> Void)
}

public final class CommonNetworkManager: NetworkManagerProtocol {
    
    private init() {}
    public static let shared = CommonNetworkManager()
    
    
    func makeRequest<T>(with dto: RequestDTO, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        print("makeRequest")
    }
}
