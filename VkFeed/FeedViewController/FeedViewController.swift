//
//  FeedViewController.swift
//  VkFeed
//
//  Created by ily.pavlov on 12.12.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        fetcher.getFeed { feedResponse in
            guard let feedResponse = feedResponse else {return}
            feedResponse.items.map { feedItem in
                print(feedItem.date)
            }
        }
    }
}
