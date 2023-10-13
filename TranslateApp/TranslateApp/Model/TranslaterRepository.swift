//
//  PapagoUseCase.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

import Foundation
import RxSwift

final class TranslaterRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func checkLanguage(for item: TranslateItem, completion: @escaping(Result<Languages, Error>) -> Void) {
        let query = [KeywordArgument(key: "query", value: item.text)]
        DispatchQueue.global(qos: .default).sync {
            networkManager.fetchData(.languageCheck(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let languageCheck: LanguageCheckDTO = try DecodingManager.shared.decode(data)
                        guard let sourceLanguage = Languages(rawValue: languageCheck.languageCode),
                              sourceLanguage.isTranslatable else {
                            throw TranslateError.languageNotAvailable
                        }
                        completion(.success(sourceLanguage))
                    } catch(let error) {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func translate(for item: TranslateItem, completion: @escaping(Result<TranslateItem, Error>) -> Void) {
        let query = [KeywordArgument(key: "source", value: item.source.rawValue),
                     KeywordArgument(key: "target", value: item.target.rawValue),
                     KeywordArgument(key: "text", value: item.text)]
        
        DispatchQueue.global(qos: .default).sync {
            networkManager.fetchData(.translater(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let translatedData: TranslaterDTO = try DecodingManager.shared.decode(data)
                        item.text = translatedData.message.result.translatedText
                        completion(.success(item))
                    } catch(let error) {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
