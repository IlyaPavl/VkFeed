//
//  NetworkConstants.swift
//  VkFeed
//
//  Created by Илья Павлов on 14.12.2023.
//

import Foundation

public enum API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"

    static let newsFeed = "/method/newsfeed.get"
    static let usersGet = "/method/users.get"
}

public enum APIError: Error {
    case invalidURL
    case invalidRequest(Error)
    case invalidResponse
    case decodingError
    case serverError
    case invalidData
    case invalidToken
}

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RuleAddingParams {
    case addToUrl
    case addToBody
}
