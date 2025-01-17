//
//  NewsFeedModels.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.12.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

public enum NewsFeed {
    
    public enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case getUser
                case getNextBatch
                case revealPostId(postId: Int)
                case logout
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case dispalyNewsFeed(feedViewModel: FeedViewModel)
                case displayUserInfo(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
    
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    let cells: [Cell]
    let footerTitle: String?
}

struct UserViewModel: TitleViewModel {
    var profileImageURL: String?
}
