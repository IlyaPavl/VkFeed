//
//  String + Height.swift
//  VkFeed
//
//  Created by Илья Павлов on 25.11.2024.
//

import UIKit
extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(size.height)
    }
}
