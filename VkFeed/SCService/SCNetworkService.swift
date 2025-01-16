//
//  SCNetworkService.swift
//  VkFeed
//
//  Created by Илья Павлов on 27.12.2024.
//

import Foundation

protocol SCNetworkServiceProtocol {
    func request<T: Decodable>(path: String,
                               method: HTTPMethodType,
                               parameters: URLRequestParamsBuilder?,
                               headers: [String: String]?) async throws -> T
}

class SCNetworkService: SCNetworkServiceProtocol {
    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService ?? AuthService()) {
        self.authService = authService
    }
    
    func request<T: Decodable>(path: String,
                               method: HTTPMethodType,
                               parameters: URLRequestParamsBuilder?,
                               headers: [String: String]?) async throws -> T {
        guard let token = authService.token else {
            throw APIError.invalidToken
        }

        let allParameters = (parameters ?? URLRequestParamsBuilder())
            .setParameter(key: "access_token", value: token)
            .setParameter(key: "v", value: API.version)
            .build()
        
        guard let url = createURL(path: path, parameters: allParameters) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    private func createURL(path: String, parameters: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }

        return components.url
    }
}
