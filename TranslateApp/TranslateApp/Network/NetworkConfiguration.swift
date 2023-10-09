//
//  NetworkConfiguration.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum NetworkConfiguration {
    case papagoAPI
    
    var url: String {
        switch self {
        case .papagoAPI:
            return "https://openapi.naver.com/v1/papago/n2mt"
        }
    }
    
    var header: [KeywordArgument]? {
        guard let path = Bundle.main.url(forResource: "SecretKey", withExtension: "plist"),
        let plist = NSDictionary(contentsOf: path) else {
            return nil
        }
        
        switch self {
        case .papagoAPI:
            guard let papagoId = plist.value(forKey: "PapagoClientId"),
                  let papagoSecret = plist.value(forKey: "PapagoClientSecret") else {
                return nil
            }
            return [KeywordArgument(key: "X-Naver-Client-Id", value: papagoId),
                    KeywordArgument(key: "X-Naver-Client-Secret", value: papagoSecret)]
        }
    }
    
    func getQuery(source: LanguageCode, target: LanguageCode, text: String) -> [KeywordArgument] {
        switch self {
        case .papagoAPI:
            return [KeywordArgument(key: "source", value: source.rawValue),
                    KeywordArgument(key: "target", value: target.rawValue),
                    KeywordArgument(key: "text", value: text)]
        }
    }
}
