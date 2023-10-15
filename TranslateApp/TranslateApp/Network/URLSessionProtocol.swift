//
//  URLSessionProtocol.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/15.
//

import Foundation

typealias NetworkingCompletionHandler = @Sendable (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping NetworkingCompletionHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping NetworkingCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: with, completionHandler: completionHandler) as URLSessionDataTask
    }
}
