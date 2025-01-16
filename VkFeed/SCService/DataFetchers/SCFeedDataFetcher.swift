//
//  SCFeedDataFetcher.swift
//  VkFeed
//
//  Created by Илья Павлов on 27.12.2024.
//

import Foundation

protocol SCFeedDataFetcherProtocol {
    func getFeed(nextBatchFrom: String?) async throws -> FeedResponse?
}

struct SCFeedDataFetcher: SCFeedDataFetcherProtocol {
    let network: SCNetworkServiceProtocol
    
    func getFeed(nextBatchFrom: String?) async throws -> FeedResponse? {
        let parameters = URLRequestParamsBuilder()
            .setParameters(parameters: ["filters": "post, photo"])
            .setParameter(key: "start_from", value: nextBatchFrom)
        
        let result: FeedResponseWrapped = try await network.request(
            path: API.newsFeed,
            method: .get,
            parameters: parameters,
            headers: nil
        )
        
        return result.response
    }
}
