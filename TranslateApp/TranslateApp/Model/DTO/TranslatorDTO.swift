//
//  PapagoResult.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/09.
//

struct TranslatorDTO: Decodable {
    let message: Message
}

extension TranslatorDTO {
    struct Message: Decodable {
        let result: Result
    }
}

extension TranslatorDTO.Message {
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

