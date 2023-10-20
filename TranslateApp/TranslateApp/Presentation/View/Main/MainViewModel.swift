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
                .subscribe(onNext: { self.outputItem.accept($0)},
                           onError: { self.handle(error: $0)})
                .disposed(by: disposeBag)
        } else {
            translate(source: sourceLanguage, target: targetLanguage)
                .subscribe(onNext: { self.outputItem.accept($0)},
                           onError: { self.handle(error: $0)})
                .disposed(by: disposeBag)
        }
    }
}

extension MainViewModel {
    func autoTranslate(source: Languages, target: Languages) -> Observable<String> {
        return repository.detectLanguage(outputItem.value)
            .flatMap { language -> Observable<String> in
                return self.translate(source: language, target: target)
            }
    }
    
    func translate(source: Languages, target: Languages) -> Observable<String> {
        guard source.canTranslate(to:target) else {
            return .error(TranslateError.languageNotAvailable)
        }
        return repository.translate(source: source, target: target, text: outputItem.value)
    }
}
