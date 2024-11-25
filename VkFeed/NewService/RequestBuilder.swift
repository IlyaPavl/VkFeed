//
//  RequestBuilder.swift
//  VkFeed
//
//  Created by Илья Павлов on 20.11.2024.
//

public struct RequestDTO {
    private(set) var url: String
    private(set) var httpMethod: HTTPMethodType
    private(set) var requestType: NewsFeed.Model?
    private(set) var headers: [String: String]?
    private(set) var params: Any?
    private(set) var ruleAddingParams: RuleAddingParams?
}

public struct RequestBuilderAPI {
    public init(requestType: NewsFeed.Model) {
        self.requestType = requestType
    }
    
    private let requestType: NewsFeed.Model
    
//    public func build(params: Any? = nil, urlPathParams: Any? = nil) -> RequestDTO? {
//        do {
//
//        } catch {
//            assertionFailure("ANApiManager error")
//            return nil
//        }
//    }
}
