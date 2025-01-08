//
//  FeedCellLayoutCalculator.swift
//  VkFeed
//
//  Created by Илья Павлов on 25.11.2024.
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, attachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        let cardViewWidth: CGFloat = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        // MARK: Работа с postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = text.height(width: width, font: Constants.postLabelFont)
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        
        // MARK: Работа с attachmentFrame
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: CGSize.zero)
        
        if let attachment = attachment {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
        }

        // MARK: Работа с bottomViewFrame
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop + Constants.bottomViewItemInset.left),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        // MARK: Работа с totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom + 4
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomView: bottomViewFrame,
                     totalHeight: totalHeight)

    }
}
