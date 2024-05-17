//
//  NewsFeedViewController.swift
//  VkFeed
//
//  Created by ily.pavlov on 17.12.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    private let tableView = NewsFeedTableView()
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setup()
        setupNewsFeedVCUI()
        
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
            
        case .dispalyNewsFeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            tableView.reloadData()
        }
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.cellIdentifier, for: indexPath) as! NewsFeedTableViewCell
//        let cellViewModel = feedViewModel.cells[indexPath.row]
//        cell.configureCellWith(viewModel: cellViewModel)
        cell.textLabel?.text = "index \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}

extension NewsFeedViewController {
    private func setupNewsFeedVCUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
