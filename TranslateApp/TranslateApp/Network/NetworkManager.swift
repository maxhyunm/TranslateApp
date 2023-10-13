//
//  NetworkManager.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

final class NetworkManager {
    private var dataTask: URLSessionDataTask?
 
    func fetchData(_ networkType: NetworkConfiguration, completion: @escaping(Result<Data, Error>) -> Void) {
        do {
            let request = try makeRequest(networkType)
            
            dataTask?.cancel()
            
            dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                let result = self.checkResponse(data: data, response: response, error: error)
                completion(result)
            }
            
            dataTask?.resume()
            
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    private func makeRequest(_ networkType: NetworkConfiguration) throws -> URLRequest {
        var urlComponents = URLComponents(string: networkType.url)
        urlComponents?.queryItems = networkType.queryItem
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        guard let header = networkType.header else {
            throw APIError.invalidAPIKey
        }
        
        header.forEach {
            guard let value = $0.value as? String else { return }
            request.setValue(value, forHTTPHeaderField: $0.key)
        }
        
        request.httpMethod = networkType.httpMethod
        
        return request
    }
    
    private func checkResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if error != nil {
            return .failure(APIError.requestFailure)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return .failure(APIError.invalidHTTPStatusCode)
        }
        
        guard let data else {
            return .failure(APIError.invalidData)
        }
        
        return .success(data)
    }
}
