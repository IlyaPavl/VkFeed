//
//  NewsFeedTableView.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.05.2024.
//

import UIKit

class NewsFeedTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableUI() {
        self.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: NewsFeedTableViewCell.cellIdentifier)
        self.separatorStyle = .none
        self.separatorColor = .systemGray5
        
    }
}
