//
//  NetworkDataFetcher.swift
//  VkFeed
//
//  Created by Илья Павлов on 15.12.2023.
//

import Foundation

protocol DataFetcher {
    func getFeed(responseModel: @escaping (FeedResponse?) -> Void)
}


struct NetworkDataFetcher: DataFetcher {
    let network: NetworkServiceProtocol
    
    func getFeed(responseModel: @escaping (FeedResponse?) -> Void) {
        let parameters = URLRequestParamsBuilder()
            .setParameters(parameters: ["filters": "post, photo"])
        
        network.request(path: API.newsFeed,
                        method: .get,
                        parameters: parameters,
                        headers: nil) { (result: Result<FeedResponseWrapped, APIError>) in
            switch result {
                case .success(let feedResponseWrapped):
                    responseModel(feedResponseWrapped.response)
                case .failure(let error):
                    print(error.localizedDescription)
                    responseModel(nil)
            }
        }
    }
}
