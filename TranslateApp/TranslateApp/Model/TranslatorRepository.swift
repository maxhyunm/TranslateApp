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
    let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func detectLanguage(_ text: String) -> Observable<Languages> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            let query = [KeywordArgument(key: "query", value: text)]
            
            let result = networkManager.fetchData(.languageDetector(body: query))
            result.subscribe(onNext: { data in
                do {
                    let languageCheck: LanguageDetectorDTO = try DecodingManager.shared.decode(data)
                    guard let sourceLanguage = Languages(rawValue: languageCheck.languageCode),
                          sourceLanguage.isTranslatable else {
                        observable.on(.error(TranslateError.languageNotAvailable))
                        return
                    }
                    observable.on(.next(sourceLanguage))
                    return
                } catch(let error) {
                    observable.on(.error(error))
                    return
                }
            }, onError: { error in
                observable.on(.error(error))
                return
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func translate(source: Languages, target: Languages, text: String) -> Observable<String> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            let query = [KeywordArgument(key: "source", value: source.rawValue),
                         KeywordArgument(key: "target", value: target.rawValue),
                         KeywordArgument(key: "text", value: text)]
            
            let result = networkManager.fetchData(.translator(body: query))
            result.subscribe(onNext: { data in
                do {
                    let translatedData: TranslatorDTO = try DecodingManager.shared.decode(data)
                    observable.on(.next(translatedData.message.result.translatedText))
                    return
                } catch(let error) {
                    observable.on(.error(error))
                    return
                }
            }, onError: { error in
                observable.on(.error(error))
                return
            })
            .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
