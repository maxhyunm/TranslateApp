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
    var inputItem: Item? = nil
    var outputItem = BehaviorRelay<Item?>(value: nil)
    let disposeBag = DisposeBag()
    
    init(repository: TranslaterRepository) {
        self.repository = repository
        bindOutput()
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: Item) {
        inputItem = input
    }
    
    func touchUpTranslate(source: String, target: String) {
        guard let item = inputItem,
              let targetLanguage = Languages.getLanguageType(for: target) else { return }
        guard let sourceLanguage = Languages.getLanguageType(for: source) else {
            repository.autoTranslate(target: targetLanguage, item: item)
            return
        }
        repository.translate(source: sourceLanguage, target: targetLanguage, item: item)
    }
    
    func viewDidDisappear() {
        repository.resetOutputItem()
    }
}

extension MainViewModel {
    func bindOutput() {
        repository.outputItem
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] output in
                self?.outputItem.accept(output)
            }
            .disposed(by: disposeBag)
    }
}
