//
//  NewsFeedViewController.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.12.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit
import SafariServices

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController {
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    private let tableView = NewsFeedTableView()
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getNewsFeedData), for: .valueChanged)
        
        return refreshControl
    }()
    private let titleView = TitleView()
    private lazy var footerView = FooterView()
    
    // MARK: - Setup
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
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setup()
        setupTopBars()
        setupNewsFeedVCUI()
        getNewsFeedData()
        getUserData()
    }
}

// MARK: - NewsFeedDisplayLogic
extension NewsFeedViewController: NewsFeedDisplayLogic {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .dispalyNewsFeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            footerView.setDescription(feedViewModel.footerTitle ?? "Загружаем еще...")
            refreshControl.endRefreshing()
            tableView.reloadData()
        case .displayUserInfo(userViewModel: let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
}

// MARK: - NewsFeedTableViewCellDelegate
extension NewsFeedViewController: NewsFeedTableViewCellDelegate {
    func didTapMoreTextButton(cell: NewsFeedTableViewCell)  {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        Task {
            await interactor?.makeRequest(request: .revealPostId(postId: cellViewModel.postId))
        }
    }
    
    func didTapURL(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension NewsFeedViewController: TitleViewDelegate {
    func showLogoutAlert(with alert: UIAlertController) {
        self.present(alert, animated: true)
    }

    func didTapLogout() {
        Task {
            await interactor?.makeRequest(request: .logout)
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.cellIdentifier,
                                                 for: indexPath) as! NewsFeedTableViewCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.delegate = self
        cell.configureCellWith(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            Task {
                await interactor?.makeRequest(request: .getNextBatch)
            }
        }
    }
}

// MARK: - Setup UI
extension NewsFeedViewController {
    private func setupNewsFeedVCUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = footerView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func getNewsFeedData() {
        Task {
            await interactor?.makeRequest(request: .getNewsFeed)
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.beginRefreshing()
                }
            }
        }
    }
    
    private func getUserData() {
        Task {
            await interactor?.makeRequest(request: .getUser)
        }
    }
    
    private func setupTopBars() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
        titleView.delegate = self
    }
}
