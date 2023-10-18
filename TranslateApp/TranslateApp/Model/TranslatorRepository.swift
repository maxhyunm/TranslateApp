//
//  PapagoUseCase.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

import Foundation
import RxSwift

final class TranslatorRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func detectLanguage(_ text: String) -> Observable<Languages> {
        let query = [KeywordArgument(key: "query", value: text)]
        
        return networkManager.fetchData(.languageDetector(body: query))
            .map { data in
                let languageCheck: LanguageDetectorDTO = try DecodingManager.shared.decode(data)
                guard let sourceLanguage = Languages(rawValue: languageCheck.languageCode),
                      sourceLanguage.isTranslatable else {
                    throw TranslateError.languageNotAvailable
                }
                return sourceLanguage
            }
    }
    
    func translate(source: Languages, target: Languages, text: String) -> Observable<String> {
        let query = [KeywordArgument(key: "source", value: source.rawValue),
                     KeywordArgument(key: "target", value: target.rawValue),
                     KeywordArgument(key: "text", value: text)]
        
        return networkManager.fetchData(.translator(body: query))
            .map { data in
                let translatedData: TranslatorDTO = try DecodingManager.shared.decode(data)
                return translatedData.message.result.translatedText
            }
    }
}
