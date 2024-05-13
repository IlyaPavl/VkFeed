//
//  NewsFeedTableViewCell.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.05.2024.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    static let cellIdentifier = "postIdentifier"
    private var postText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(postText: String) {
        self.postText.text = postText
    }
}

extension NewsFeedTableViewCell {
    private func setupCellUI() {
        contentView.addSubview(postText)
        setupConstraints()
        
        postText.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        postText.textColor = .systemGray
        postText.numberOfLines = 0
    }
    
    private func setupConstraints() {
        postText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 / 2),
            postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16 * 2)
        ])
    }
}
