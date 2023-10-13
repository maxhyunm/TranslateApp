//
//  MainViewModel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation
import RxCocoa

final class MainViewModel: MainViewModelType, MainViewModelOutputsType, ViewModelWithError {
    let repository: TranslaterRepository
    var inputs: MainViewModelInputsType { return self }
    var outputs: MainViewModelOutputsType { return self }
    var inputText: String = ""
    var translateItem: TranslateItem?
    var outputItem = PublishRelay<String>()
    var errorMessage = PublishRelay<String>()
    
    init(repository: TranslaterRepository) {
        self.repository = repository
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: String) {
        inputText = input
    }
    
    func touchUpTranslate(source: String, target: String) {
        setupTranslateItem(source: source, target: target)
        
        guard let item = translateItem,
              item.target.isTranslatable else {
            handle(error: TranslateError.languageNotAvailable)
            return
        }
        
        if !item.source.isTranslatable {
            autoTranslate(item)
        } else {
            self.translate(item)
        }
    }
}

extension MainViewModel {
    func setupTranslateItem(source: String, target: String) {
        guard let sourceLanguage = Languages.getLanguageType(for: source),
              let targetLanguage = Languages.getLanguageType(for: target) else {
            outputItem.accept(inputText)
            handle(error: TranslateError.languageNotAvailable)
            return
        }
        
        translateItem = TranslateItem(source: sourceLanguage,
                                      target: targetLanguage,
                                      text: inputText)
    }
    
    func autoTranslate(_ item: TranslateItem) {
        self.repository.checkLanguage(for: item) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let language):
                item.source = language
                self.translate(item)
            case .failure(let errorType):
                self.outputItem.accept(item.text)
                self.handle(error: errorType)
                return
            }
        }
    }
    func translate(_ item: TranslateItem) {
        if item.source == item.target {
            self.outputItem.accept(item.text)
            return
        }
        
        self.repository.translate(for: item) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let newItem):
                self.outputItem.accept(newItem.text)
            case .failure(let errorType):
                self.outputItem.accept(item.text)
                self.handle(error: errorType)
            }
        }
    }
}
