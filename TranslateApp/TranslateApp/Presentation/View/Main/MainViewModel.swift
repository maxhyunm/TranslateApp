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
    let repository: TranslatorRepository
    var inputs: MainViewModelInputsType { return self }
    var outputs: MainViewModelOutputsType { return self }
    var outputItem = BehaviorRelay<String>(value: "")
    var errorMessage = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    init(repository: TranslatorRepository) {
        self.repository = repository
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: String) {
        outputItem.accept(input)
    }
    
    func touchUpTranslate(source: String, target: String) {
        guard let sourceLanguage = Languages.getLanguageType(for: source),
              let targetLanguage = Languages.getLanguageType(for: target),
              targetLanguage.isTranslatable else {
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
        let result = repository.detectLanguage(outputItem.value)
        result.subscribe(
            onNext: { [weak self] language in
                self?.translate(source: language, target: target)
            },
            onError: {[weak self] error in
                self?.handle(error: error)
            })
        .disposed(by: disposeBag)
    }
    
    func translate(source: Languages, target: Languages) {
        if source == target { return }
        
        let result = repository.translate(source: source, target: target, text: outputItem.value)
        result.subscribe(
            onNext: { [weak self] output in
                self?.outputItem.accept(output)
            },
            onError: { [weak self] error in
                self?.handle(error: error)
            })
        .disposed(by: disposeBag)
    }
}
