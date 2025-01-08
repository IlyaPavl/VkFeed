//
//  NewsFeedPresenter.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.12.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType) async
}

@MainActor
class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    var cellLayoutCalulator: FeedCellLayoutCalculator = FeedCellLayoutCalculator()
    
    let dtFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMM 'в' HH:mm"
        return df
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
                
            case .presentNewsFeed(feed: let feed):
                let cells = feed.items.map { feedItem in
                    cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
                }
                let feedViewModel = FeedViewModel(cells: cells)
                
                self.viewController?.displayData(viewModel: .dispalyNewsFeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        let profile = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dtFormatter.string(from: date)
        let photoAttachment = photoAttacchment(feedItem: feedItem)
        let sizes = cellLayoutCalulator.sizes(postText: feedItem.text, attachment: photoAttachment)
        
        return FeedViewModel.Cell.init(iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       photoAttachment: photoAttachment,
                                       sizes: sizes)
    }
    
    private func profile(for sourceID: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
        
        let profilesOrGroups: [ProfileRepresenatable] = sourceID >= 0 ? profiles : groups
        let normalSourceID = sourceID >= 0 ? sourceID : -sourceID
        let profileRepresenatable = profilesOrGroups.first { myprofileRepresentable in
            myprofileRepresentable.id == normalSourceID
        }
        return profileRepresenatable!
    }
    
    private func photoAttacchment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return .init(photoUrlString: firstPhoto.srcBig, width: firstPhoto.width, height: firstPhoto.height)
    }
}
