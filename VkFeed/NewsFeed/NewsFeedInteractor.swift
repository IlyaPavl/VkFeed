//
//  NewsFeedInteractor.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.12.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    private var fetcher: SCFeedDataFetcherProtocol = SCFeedDataFetcher(network: SCNetworkService())
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
        case .getNewsFeed:
            print("getFeed interactor")
            Task {
                do {
                    let feedResponse = try await fetcher.getFeed()
                    guard let feedResponse else { return }
                    await presenter?.presentData(response: .presentNewsFeed(feed: feedResponse))
                } catch {
                    print("Failed to fetch news feed: \(error.localizedDescription)")
                }
            }
        }
    }
}
