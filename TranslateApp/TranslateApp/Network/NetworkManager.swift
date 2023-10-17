//
//  NetworkManager.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation
import RxSwift

final class NetworkManager {
    var session: URLSessionProtocol?
    
    func fetchData(_ networkType: NetworkConfiguration) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            guard let self, let session else { return Disposables.create() }
            
            do {
                let request = try self.makeRequest(networkType)
                let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: request) { data, response, error in
                    
                    let result = self.checkResponse(data: data, response: response, error: error)
                    
                    switch result {
                    case .success(let data):
                        observer.on(.next(data))
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error))
                        return
                    }
                }
                dataTask.resume()
                
                return Disposables.create {
                    dataTask.cancel()
                }
                
            } catch(let error) {
                observer.on(.error(error))
                return Disposables.create()
            }
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
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(APIError.invalidHTTPStatusCode(statusCode: httpResponse.statusCode))
        }
        
        guard let data else {
            return .failure(APIError.invalidData)
        }
        
        return .success(data)
    }
}
