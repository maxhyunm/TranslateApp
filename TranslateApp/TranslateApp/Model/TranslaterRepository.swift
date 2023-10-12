//
//  PapagoUseCase.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/11.
//

import RxCocoa

final class TranslaterRepository {
    let networkManager: NetworkManager
    var outputItem = BehaviorRelay<Item?>(value: nil)
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func autoTranslate(target: Languages, item: Item) {
        let query = [KeywordArgument(key: "query", value: item.text)]
        networkManager.fetchData(.languageCheck(body: query)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let languageCheck: LanguageCheckDTO = try DecodingManager.shared.decode(data)
                    guard let sourceLanguage = Languages(rawValue: languageCheck.languageCode) else {
                        self.outputItem.accept(item)
                        return
                    }
                    self.translate(source: sourceLanguage, target: target, item: item)
                } catch(let error) {
                    self.outputItem.accept(item)
                    print(error)
                }
            case .failure(let error):
                self.outputItem.accept(item)
                print(error)
            }
        }
        
    }
    
    func translate(source: Languages, target: Languages, item: Item) {
        var item = item

        guard source != .unknown else {
            self.outputItem.accept(item)
            return
        }
        
        let query = [KeywordArgument(key: "source", value: source.rawValue),
                     KeywordArgument(key: "target", value: target.rawValue),
                     KeywordArgument(key: "text", value: item.text)]
        networkManager.fetchData(.translater(body: query)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let translatedData: TranslaterDTO = try DecodingManager.shared.decode(data)
                    item.text = translatedData.message.result.translatedText
                    self.outputItem.accept(item)
                } catch(let error) {
                    self.outputItem.accept(item)
                    print(error)
                }
            case .failure(let error):
                self.outputItem.accept(item)
                print(error)
            }
        }
    }
    
    func resetOutputItem() {
        self.outputItem.accept(nil)
    }
}
