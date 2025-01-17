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
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) async {
        switch response {
            
        case .presentNewsFeed(feed: let feed, let revealedPostIds):
            print(revealedPostIds)
            let cells = feed.items.map { feedItem in
                cellViewModel(
                    from: feedItem,
                    profiles: feed.profiles,
                    groups: feed.groups,
                    revealedPostIds: revealedPostIds
                )
            }
            let footerTitle = String.localizedStringWithFormat(
                NSLocalizedString("%lld posts", comment: ""),
                cells.count
            )
            let feedViewModel = FeedViewModel(cells: cells, footerTitle: footerTitle)
            
            viewController?.displayData(viewModel: .dispalyNewsFeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel(profileImageURL: user?.photo100)
            viewController?.displayData(viewModel: .displayUserInfo(userViewModel: userViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem,
                               profiles: [Profile],
                               groups: [Group],
                               revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dtFormatter.string(from: date)
        let photoAttachments = photoAttachments(feedItem: feedItem)
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        let sizes = cellLayoutCalulator.sizes(
            postText: feedItem.text,
            attachments: photoAttachments,
            isFullSizedPost: isFullSized
        )
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       photoAttachments: photoAttachments,
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
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else {
            return []
        }
        return attachments.compactMap({ attachment in
            guard let photo = attachment.photo else {
                return nil
            }
            return .init(photoUrlString: photo.srcBig, width: photo.width, height: photo.height)
        })
    }
}
