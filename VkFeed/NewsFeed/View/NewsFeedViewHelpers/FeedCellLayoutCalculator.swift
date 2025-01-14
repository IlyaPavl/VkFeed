//
//  FeedCellLayoutCalculator.swift
//  VkFeed
//
//  Created by Илья Павлов on 25.11.2024.
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, attachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        let cardViewWidth: CGFloat = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        var showMoreTextButton = false
        // MARK: Работа с postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: 0, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSizedPost && height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        
        // MARK: Работа с showMoreTextButton
        var moreTexButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTexButtonSize = CGSize(width: Constants.moreTextButtonSize.width,
                                       height: Constants.moreTextButtonSize.height)
        }
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTexButtonSize)
        
        // MARK: Работа с attachmentFrame
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: CGSize.zero)
        
        if let attachment = attachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            if attachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if attachments.count > 1 {
                var allPhotoSizes: [CGSize] = []
                
                for item in attachments {
                    let photoSize = CGSize(width: CGFloat(item.width), height: CGFloat(item.height))
                    allPhotoSizes.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photosArray: allPhotoSizes)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }

        // MARK: Работа с bottomViewFrame
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop + Constants.bottomViewItemInset.left),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        // MARK: Работа с totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom + 4
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attachmentFrame: attachmentFrame,
                     bottomView: bottomViewFrame,
                     totalHeight: totalHeight)

    }
}
