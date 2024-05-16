//
//  NewsFeedPresenter.swift
//  VkFeed
//
//  Created by ily.pavlov on 17.12.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
            
        case .presentNewsFeed(feed: let feed):
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem)
            }
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .dispalyNewsFeed(feedViewModel: feedViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        FeedViewModel.Cell.init(text: feedItem.text)
    }
}
