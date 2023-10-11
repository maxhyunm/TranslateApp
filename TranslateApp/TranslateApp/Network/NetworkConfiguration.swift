//
//  NetworkConfiguration.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum NetworkConfiguration {
    case translater(query: [KeywordArgument])
    case languageCheck(query: [KeywordArgument])
    
    var url: String {
        switch self {
        case .translater:
            return "https://openapi.naver.com/v1/papago/n2mt"
        case .languageCheck:
            return "https://openapi.naver.com/v1/papago/detectLangs"
        }
    }
    
    var header: [KeywordArgument]? {
        guard let path = Bundle.main.url(forResource: "SecretKey", withExtension: "plist"),
        let plist = NSDictionary(contentsOf: path) else {
            return nil
        }
        
        switch self {
        case .translater, .languageCheck:
            guard let papagoId = plist.value(forKey: "PapagoClientId"),
                  let papagoSecret = plist.value(forKey: "PapagoClientSecret") else {
                return nil
            }
            return [KeywordArgument(key: "X-Naver-Client-Id", value: papagoId),
                    KeywordArgument(key: "X-Naver-Client-Secret", value: papagoSecret),
                    KeywordArgument(key: "Content-Type", value: "application/x-www-form-urlencoded;charset=UTF-8")]
        }
    }
    
    var queryItem: [URLQueryItem] {
        switch self {
        case .translater(let query), .languageCheck(let query):
            var result = [URLQueryItem]()
            query.forEach {
                guard let value = $0.value as? String else { return }
                result.append(URLQueryItem(name: $0.key, value: value))
            }
            return result
        }
    }
    
    var httpMethod: String {
        switch self {
        case .translater, .languageCheck:
            return "POST"
        }
    }
}
