//
//  NewsFeedDataFetcher.swift
//  VkFeed
//
//  Created by Илья Павлов on 20.11.2024.
//

protocol NewsFeedServiceProtocol {
    func getFeed(responseModel: @escaping (FeedResponse?) -> Void)
}

class NewsFeedServices {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = CommonNetworkManager.shared) {
        self.networkManager = networkManager
    }
}

extension NewsFeedServices: NewsFeedServiceProtocol {
    func getFeed(responseModel: @escaping (FeedResponse?) -> Void) {
        
    }
    
    
}
