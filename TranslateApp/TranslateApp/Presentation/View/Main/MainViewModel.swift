//
//  MainViewModel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: MainViewModelType, MainViewModelOutputsType, ViewModelWithError {
    let repository: TranslaterRepository
    var inputs: MainViewModelInputsType { return self }
    var outputs: MainViewModelOutputsType { return self }
    var inputItem: Item? = nil
    var outputItem = BehaviorRelay<Item?>(value: nil)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    init(repository: TranslaterRepository) {
        self.repository = repository
    }
    
    func handle(error: Error) {
        DispatchQueue.main.async {
            switch error {
            case let errorType as APIError:
                self.errorMessage.accept(errorType.alertMessage)
            case let errorType as DecodingError:
                self.errorMessage.accept(errorType.alertMessage)
            case let errorType as TranslateError:
                self.errorMessage.accept(errorType.alertMessage)
            default:
                self.errorMessage.accept(TranslateError.unknown.alertMessage)
            }
        }
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: Item) {
        inputItem = input
    }
    
    func touchUpTranslate(source: String, target: String) {
        guard let item = inputItem,
              let targetLanguage = Languages.getLanguageType(for: target),
              let sourceLanguage = Languages.getLanguageType(for: source),
              targetLanguage != .auto || targetLanguage != .unknown else { return }
        
        if sourceLanguage == .auto || sourceLanguage == .unknown {
            self.repository.checkLanguage(item: item) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let language):
                    self.translateItem(source: language, target: targetLanguage, item: item)
                case .failure(let errorType):
                    self.outputItem.accept(item)
                    self.handle(error: errorType)
                    return
                }
            }
        } else {
            self.translateItem(source: sourceLanguage, target: targetLanguage, item: item)
        }
    }
    
    func translateItem(source: Languages, target: Languages, item: Item) {
        if source == target {
            self.outputItem.accept(item)
            return
        }
        
        self.repository.translate(source: source, target: target, item: item) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let newItem):
                self.outputItem.accept(newItem)
            case .failure(let errorType):
                self.outputItem.accept(item)
                self.handle(error: errorType)
            }
        }
    }
    
    func viewDidDisappear() {
        outputItem.accept(nil)
    }
}
