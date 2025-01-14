//
//  SCUsersDataFetcher.swift
//  VkFeed
//
//  Created by Илья Павлов on 14.01.2025.
//

import Foundation

protocol SCUsersDataFetcherProtocol {
    func getUser() async throws -> UserResponse?
}

struct SCUsersDataFetcher: SCUsersDataFetcherProtocol {
    let network: SCNetworkService
    private let authService: AuthService
    
    init(network: SCNetworkService, authService: AuthService = SceneDelegate.shared().authService ?? AuthService()) {
        self.network = network
        self.authService = authService
    }
    
    func getUser() async throws -> UserResponse? {
        guard let userId = authService.userId else { return nil }
        let parameters = URLRequestParamsBuilder()
            .setParameters(parameters: ["user_ids": userId, "fields": "photo_100"])
        
        let result: UserResponseWrapped = try await network.request(
            path: API.usersGet,
            method: .get,
            parameters: parameters,
            headers: nil
        )
        
        print(result.response.first)
        return result.response.first
    }

    
}
