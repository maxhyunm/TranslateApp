//
//  PapagoResult.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/09.
//

struct TranslaterDTO: Decodable {
    let message: Message
}

extension TranslaterDTO {
    struct Message: Decodable {
        let result: Result
    }
}

extension TranslaterDTO.Message {
    struct Result: Decodable {
        let sourceLanguageType: String
        let targetLanguageType: String
        let translatedText: String
        
        enum CodingKeys: String, CodingKey {
            case sourceLanguageType = "srcLangType"
            case targetLanguageType = "tarLangType"
            case translatedText = "translatedText"
        }
    }
}

