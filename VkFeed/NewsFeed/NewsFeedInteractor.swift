//
//  NewsFeedInteractor.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.12.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType) async
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    private var fetcher: SCFeedDataFetcherProtocol = SCFeedDataFetcher(network: SCNetworkService())
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) async {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
            case .getNewsFeed:
                print("getFeed interactor")
                Task { [weak self] in
                    guard let self = self else { return }
                    do {
                        let feedResponse = try await self.fetcher.getFeed()
                        self.feedResponse = feedResponse
                        await self.presentFeed()
                    } catch {
                        print("Failed to fetch news feed: \(error.localizedDescription)")
                    }
                }
            case .revealPostId(postId: let postId):
                revealedPostIds.append(postId)
                await presentFeed()
        }
    }
    
    private func presentFeed() async {
        guard let feedResponse = feedResponse else { return }
        await presenter?.presentData(response: .presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
}
