//
//  PapagoUseCase.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

import Foundation
import RxCocoa

final class TranslaterRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func checkLanguage(item: Item, completion: @escaping(Result<Languages, Error>) -> Void) {
        let query = [KeywordArgument(key: "query", value: item.text)]
        DispatchQueue.global(qos: .default).sync {
            networkManager.fetchData(.languageCheck(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let languageCheck: LanguageCheckDTO = try DecodingManager.shared.decode(data)
                        guard let sourceLanguage = Languages(rawValue: languageCheck.languageCode),
                              sourceLanguage != .auto  && sourceLanguage != .unknown else {
                            completion(.failure(TranslateError.languageNotAvailable))
                            return
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
    
    func translate(source: Languages, target: Languages, item: Item, completion: @escaping(Result<Item, Error>) -> Void) {
        var item = item
        let query = [KeywordArgument(key: "source", value: source.rawValue),
                     KeywordArgument(key: "target", value: target.rawValue),
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
