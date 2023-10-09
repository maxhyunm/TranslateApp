//
//  PapagoResult.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/09.
//

struct PapagoDTO: Decodable {
    let sourceLanguageType: String
    let targetLanguageType: String
    let translatedText: String
    
    enum CodingKeys: String, CodingKey {
        case sourceLanguageType = "srcLangType"
        case targetLanguageType = "tarLangType"
        case translatedText = "translatedText"
    }
}
