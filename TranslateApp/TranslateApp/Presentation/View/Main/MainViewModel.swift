//
//  MainViewModel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation
import RxCocoa

final class MainViewModel: MainViewModelType, MainViewModelOutputsType, ViewModelWithError {
    let repository: TranslatorRepository
    var inputs: MainViewModelInputsType { return self }
    var outputs: MainViewModelOutputsType { return self }
    var resultViewModel: ResultViewModelType = ResultViewModel()
    private(set) var inputText: String = ""
    var errorMessage = PublishRelay<String>()
    
    init(repository: TranslatorRepository) {
        self.repository = repository
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: String) {
        inputText = input
    }
    
    func touchUpTranslate(source: String, target: String) {
        guard let sourceLanguage = Languages.getLanguageType(for: source),
              let targetLanguage = Languages.getLanguageType(for: target),
              targetLanguage.isTranslatable else {
            resultViewModel.outputItem.accept(inputText)
            handle(error: TranslateError.languageNotAvailable)
            return
        }

        if !sourceLanguage.isTranslatable {
            autoTranslate(source: sourceLanguage, target: targetLanguage)
        } else {
            self.translate(source: sourceLanguage, target: targetLanguage)
        }
    }
}

extension MainViewModel {
    func autoTranslate(source: Languages, target: Languages) {
        self.repository.detectLanguage(inputText) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let language):
                self.translate(source: language, target: target)
            case .failure(let errorType):
                self.resultViewModel.outputItem.accept(inputText)
                self.handle(error: errorType)
                return
            }
        }
    }
    
    func translate(source: Languages, target: Languages) {
        if source == target {
            self.resultViewModel.outputItem.accept(inputText)
            return
        }
        
        self.repository.translate(source: source, target: target, text: inputText) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let outputText):
                self.resultViewModel.outputItem.accept(outputText)
            case .failure(let errorType):
                self.resultViewModel.outputItem.accept(inputText)
                self.handle(error: errorType)
            }
        }
    }
}
