//
//  NetworkConfiguration.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum NetworkConfiguration {
    case translator(body: [KeywordArgument])
    case languageDetector(body: [KeywordArgument])
    
    var url: String {
        switch self {
        case .translator:
            return "https://openapi.naver.com/v1/papago/n2mt"
        case .languageDetector:
            return "https://openapi.naver.com/v1/papago/detectLangs"
        }
    }
    
    var header: [KeywordArgument]? {
        guard let path = Bundle.main.url(forResource: "SecretKey", withExtension: "plist"),
        let plist = NSDictionary(contentsOf: path) else {
            return nil
        }
        
        switch self {
        case .translator, .languageDetector:
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
        case .translator(let body), .languageDetector(let body):
            var result = [URLQueryItem]()
            body.forEach {
                guard let value = $0.value as? String else { return }
                result.append(URLQueryItem(name: $0.key, value: value))
            }
            return result
        }
    }
    
    var httpMethod: String {
        switch self {
        case .translator, .languageDetector:
            return "POST"
        }
    }
}
