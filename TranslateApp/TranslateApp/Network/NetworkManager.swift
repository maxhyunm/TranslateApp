//
//  NetworkManager.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private var dataTask: URLSessionDataTask?
    
    private init() {}
    
    func fetchData(_ networkType: NetworkConfiguration,
                   source: LanguageCode,
                   target: LanguageCode,
                   text: String,
                   completion: @escaping(Result<Data, APIError>) -> Void) {
        guard let header = networkType.header else {
            completion(.failure(APIError.invalidAPIKey))
            return
        }
        
        var urlComponents = URLComponents(string: networkType.url)
        
        networkType.getQuery(source: source, target: target, text: text).forEach {
            guard let value = $0.value as? String else { return }
            urlComponents?.queryItems = [URLQueryItem(name: $0.key, value: value)]
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        header.forEach {
            guard let value = $0.value as? String else { return }
            request.setValue(value, forHTTPHeaderField: $0.key)
        }
        
        dataTask?.suspend()
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailure))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        self.dataTask?.resume()
    }
}
