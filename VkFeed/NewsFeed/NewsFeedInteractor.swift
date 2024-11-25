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
    private var fetcher: DataFetcher = NetworkDataFetcher(network: NetworkService())
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
        case .getNewsFeed:
            print("getFeed interactor")
            fetcher.getFeed { [weak self] feedResponse in
                guard let feedResponse = feedResponse else {return}
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feedResponse))
            }
        }
    }
    
}
