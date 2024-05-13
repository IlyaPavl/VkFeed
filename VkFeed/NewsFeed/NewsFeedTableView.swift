//
//  NewsFeedTableView.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.05.2024.
//

import UIKit

class NewsFeedTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        setupTableUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableUI() {
        self.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: NewsFeedTableViewCell.cellIdentifier)
        self.separatorStyle = .singleLine
        self.separatorColor = .systemGray5
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.cellIdentifier, for: indexPath) as! NewsFeedTableViewCell
        
        cell.configureCellWith(postText: "Cell \(indexPath.row)")
        
        return cell
    }
}
