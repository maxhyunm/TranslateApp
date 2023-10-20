//
//  LanguageCheckDTO.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

struct LanguageDetectorDTO: Decodable {
    let languageCode: String
    
    enum CodingKeys: String, CodingKey {
        case languageCode = "langCode"
    }
}
