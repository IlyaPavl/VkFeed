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
    private var feedFetcher: SCFeedDataFetcherProtocol = SCFeedDataFetcher(network: SCNetworkService())
    private var userFetcher: SCUsersDataFetcherProtocol = SCUsersDataFetcher(network: SCNetworkService())
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var nextFromInProccess: String?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) async {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
        
        case .getNewsFeed:
            do {
                let feedResponse = try await feedFetcher.getFeed(nextBatchFrom: nil)
                self.feedResponse = feedResponse
                await self.presentFeed()
            } catch {
                print("Failed to fetch news feed: \(error.localizedDescription)")
            }
        
        case .getUser:
            do {
                let userResponse = try await userFetcher.getUser()
                await presenter?.presentData(response: .presentUserInfo(user: userResponse))
            } catch {
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        
        case .getNextBatch:
            nextFromInProccess = feedResponse?.nextFrom
            await presenter?.presentData(response: .presentFooterLoader)
            do {
                let feed = try await feedFetcher.getFeed(nextBatchFrom: nextFromInProccess)
                guard let feed, self.feedResponse?.nextFrom != feed.nextFrom else { return }
                updateFeedResponse(with: feed)
                await presentFeed()
            } catch {
                print("Failed to update news feed: \(error.localizedDescription)")
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
    
    private func updateFeedResponse(with feed: FeedResponse) {
        if self.feedResponse == nil {
            self.feedResponse = feed
        } else {
            self.feedResponse?.items.append(contentsOf: feed.items)
            var profiles = feed.profiles
            if let oldProfiles = self.feedResponse?.profiles {
                let oldProfilesFiltered = oldProfiles.filter({ (oldProfile) -> Bool in
                    !feed.profiles.contains(where: { $0.id == oldProfile.id })
                })
                profiles.append(contentsOf: oldProfilesFiltered)
            }
            self.feedResponse?.profiles = profiles
            
            var groups = feed.groups
            if let oldGroups = self.feedResponse?.groups {
                let oldGroupsFiltered = oldGroups.filter({ (oldGroup) -> Bool in
                    !feed.groups.contains(where: { $0.id == oldGroup.id })
                })
                groups.append(contentsOf: oldGroupsFiltered)
            }
            self.feedResponse?.groups = groups
            self.feedResponse?.nextFrom = feed.nextFrom
            
        }
    }
}
