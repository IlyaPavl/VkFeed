//
//  SCFeedDataFetcher.swift
//  VkFeed
//
//  Created by Илья Павлов on 27.12.2024.
//

import Foundation

protocol SCFeedDataFetcherProtocol {
    func getFeed() async throws -> FeedResponse?
}

struct SCFeedDataFetcher: SCFeedDataFetcherProtocol {
    let network: SCNetworkServiceProtocol
    
    func getFeed() async throws -> FeedResponse? {
        let parameters = URLRequestParamsBuilder()
            .setParameters(parameters: ["filters": "post, photo"])
        
        let result: FeedResponseWrapped = try await network.request(
            path: API.newsFeed,
            method: .get,
            parameters: parameters,
            headers: nil
        )
        
        return result.response
    }
}
