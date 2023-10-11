//
//  PapagoUseCase.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

import RxCocoa

final class TranslaterRepository {
    let networkManager: NetworkManager
    var outputItems = BehaviorRelay<[Item]>(value: [])
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func translate(source: Languages? = nil, target: Languages, text: String) {
        var source = source
        if source == nil {
            let query = [KeywordArgument(key: "query", value: text)]
            networkManager.fetchData(.languageCheck(body: query)) { result in
                switch result {
                case .success(let data):
                    do {
                        let languageCheck: LanguageCheckDTO = try DecodingManager.shared.decode(data)
                        source = Languages(rawValue: languageCheck.languageCode)
                    } catch(let error) {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        guard let source else { return }
        
        let query = [KeywordArgument(key: "source", value: source.rawValue),
                     KeywordArgument(key: "target", value: target.rawValue),
                     KeywordArgument(key: "text", value: text)]
        networkManager.fetchData(.translater(body: query)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let translatedData: TranslaterDTO = try DecodingManager.shared.decode(data)
                    var allItem = outputItems.value
                    let newItem = Item(text: translatedData.message.result.translatedText)
                    allItem.append(newItem)
                    outputItems.accept(allItem)
                } catch(let error) {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
