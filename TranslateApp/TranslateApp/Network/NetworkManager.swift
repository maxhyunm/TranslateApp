//
//  NetworkManager.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

final class NetworkManager {
    private var dataTask: URLSessionDataTask?
    
    func fetchData(_ networkType: NetworkConfiguration, completion: @escaping(Result<Data, APIError>) -> Void) {
        guard let header = networkType.header else {
            completion(.failure(APIError.invalidAPIKey))
            return
        }

        var urlComponents = URLComponents(string: networkType.url)
        urlComponents?.queryItems = networkType.queryItem
        
        guard let url = urlComponents?.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        header.forEach {
            guard let value = $0.value as? String else { return }
            request.setValue(value, forHTTPHeaderField: $0.key)
        }
        
        request.httpMethod = networkType.httpMethod
        
        dataTask?.cancel()
                
        dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
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
        dataTask?.resume()
    }
}
