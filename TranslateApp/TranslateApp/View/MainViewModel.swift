//
//  MainViewModel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: MainViewModelType, MainViewModelOutputsType, ObservableObject {
    let repository: TranslaterRepository
    var inputs: MainViewModelInputsType { return self }
    var outputs: MainViewModelOutputsType { return self }
    var inputItems = [Item]()
    var outputItems = BehaviorRelay<[Item]>(value: [])
    let disposeBag = DisposeBag()
    
    init(repository: TranslaterRepository) {
        self.repository = repository
        bindOutput()
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: [Item]) {
        inputItems = input
    }
    
    func touchUpTranslate(source: String, target: String) {
        var sourceLanguage = Languages.getLanguageType(for: source)
        guard let targetLanguage = Languages.getLanguageType(for: target) else { return }
        
        inputItems.forEach { item in
            guard let sourceLanguage else {
                repository.autoTranslate(target: targetLanguage, item: item)
                return
            }
            repository.translate(source: sourceLanguage, target: targetLanguage, item: item)
        }
    }
    
    func viewDidDisappear() {
        repository.resetOutputItem()
    }
}

extension MainViewModel {
    func bindOutput() {
        repository.outputItems
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] outputs in
                self?.outputItems.accept(outputs)
            }
            .disposed(by: disposeBag)
    }
}
