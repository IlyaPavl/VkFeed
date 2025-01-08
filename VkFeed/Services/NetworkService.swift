//
//  NetworkService.swift
//  VkFeed
//
//  Created by Илья Павлов on 14.12.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(path: String,
                               method: HTTPMethodType,
                               parameters: URLRequestParamsBuilder?,
                               headers: [String: String]?,
                               completion: @escaping (Result<T, APIError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService ?? AuthService()) {
        self.authService = authService
    }
    
    func request<T: Decodable>(path: String,
                               method: HTTPMethodType,
                               parameters: URLRequestParamsBuilder? = nil,
                               headers: [String: String]?,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        guard let token = authService.token else { return }

        let allParameters = (parameters ?? URLRequestParamsBuilder())
            .setParameter(key: "access_token", value: token)
            .setParameter(key: "v", value: API.version)
            .build()
        
        guard let url = createURL(path: path, parameters: allParameters) else {
            let error = APIError.invalidURL
            return completion(.failure(error))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach({ key, value in
            request.setValue(value, forHTTPHeaderField: key)
        })
        
        let task = createDataTask(from: request) { data, response, error in
            if let error = error {
                completion(.failure(.invalidRequest(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                let error = APIError.invalidResponse
                completion(.failure(error))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                let error = APIError.decodingError
                completion(.failure(error))
                return
            }
        }
        
        task.resume()
    }
    
    private func createURL(path: String, parameters: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }

        return components.url
    }
    
    private func createDataTask(from urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
}
