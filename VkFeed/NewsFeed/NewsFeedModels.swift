//
//  NewsFeedModels.swift
//  VkFeed
//
//  Created by ily.pavlov on 17.12.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewsFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case dispalyNewsFeed(feedViewModel: FeedViewModel)
            }
        }
    }
    
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var text: String?
        
    }
    let cells: [Cell]
}
