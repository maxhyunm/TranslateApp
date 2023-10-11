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
    var inputItems = BehaviorRelay<[Item]>(value: [])
    var outputItems = BehaviorRelay<[Item]>(value: [])
    let disposeBag = DisposeBag()
    
    init(repository: TranslaterRepository) {
        self.repository = repository
        bindItems()
    }
}

extension MainViewModel: MainViewModelInputsType {
    func scanText(_ input: [Item]) {
        inputItems.accept(input)
        
    }
    
    func startTranslate(source: Languages?, target: Languages) {
        inputItems.value.forEach {
            repository.translate(source: source, target: target, text: $0.text)
        }
    }
}

extension MainViewModel {
    func bindItems() {
        repository.outputItems
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] outputs in
                self?.outputItems.accept(outputs)
            }
            .disposed(by: disposeBag)
    }
}
