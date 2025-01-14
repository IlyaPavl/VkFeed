//
//  Constants.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.05.2024.
//

import UIKit

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let commonPadding: CGFloat = 8
    
    static let topViewHeight: CGFloat = 50
    
    static let profileImageViewHeight: CGFloat = 30
    static let groupNameLabelHeight: CGFloat = 15

    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 16)
    static let postLabelViewHeight: CGFloat = 44
    
    static let postImageViewHeight: CGFloat = 100
    
    static let bottomViewHeight: CGFloat = 44
    static let bottomViewItemHeight: CGFloat = 42
    static let bottomViewItemMinWidth: CGFloat = 50
    static let bottomViewItemInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    static let bottomViewItemIconSize: CGFloat = 23
    
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    
    static let moreTextButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    static let moreTextButtonSize: CGSize = CGSize(width: 170, height: postLabelFont.lineHeight)
    
    static let imageViewCornerRadius: CGFloat = 10
    static let searchBarFont = UIFont.systemFont(ofSize: 14)
    static let profileAvatarInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

}
