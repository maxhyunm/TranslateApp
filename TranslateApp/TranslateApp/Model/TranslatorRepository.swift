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

    func detectLanguage(_ text: String, completion: @escaping(Result<Languages, Error>) -> Void) {
        let query = [KeywordArgument(key: "query", value: text)]
        DispatchQueue.global(qos: .default).sync {
            networkManager.fetchData(.languageDetector(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let languageCheck: LanguageDetectorDTO = try DecodingManager.shared.decode(data)
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
    
    func translate(source: Languages, target: Languages, text: String, completion: @escaping(Result<String, Error>) -> Void) {
        let query = [KeywordArgument(key: "source", value: source.rawValue),
                     KeywordArgument(key: "target", value: target.rawValue),
                     KeywordArgument(key: "text", value: text)]
        
        DispatchQueue.global(qos: .default).sync {
            networkManager.fetchData(.translator(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let translatedData: TranslatorDTO = try DecodingManager.shared.decode(data)
                        completion(.success(translatedData.message.result.translatedText))
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
