//
//  URLSessionDataTaskProtocol.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/15.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
