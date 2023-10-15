//
//  TestDouble.swift
//  TranslateAppTests
//
//  Created by Min Hyun on 2023/10/15.
//

import UIKit
@testable import TranslateApp

struct DummyResponse {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: NetworkingCompletionHandler? = nil
    
    func completion() {
        completionHandler?(data, response, error)
    }
}

final class StubURLSession: URLSessionProtocol {
    var dummyResponse: DummyResponse?
    
    init(statusCode: Int, assetName: String, type: NetworkConfiguration) {
        let data = NSDataAsset(name: assetName)!.data
        let url = URL(string: type.url)!
        let response = HTTPURLResponse(url: url,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummy = DummyResponse(data: data, response: response, error: nil)
        self.dummyResponse = dummy
    }
    
    func dataTask(with: URLRequest, completionHandler: @escaping NetworkingCompletionHandler) -> URLSessionDataTaskProtocol {
        dummyResponse?.completionHandler = completionHandler
        
        return StubURLSessionDataTask(dummyResponse)
    }
}

final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var dummyResponse: DummyResponse?
    
    init(_ dummy: DummyResponse?) {
        self.dummyResponse = dummy
    }
    
    func resume() {
        dummyResponse?.completion()
    }
    
    func cancel() {
        return
    }
}


