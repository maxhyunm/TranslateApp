//
//  ViewModelType.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import RxCocoa

protocol ViewModelWithError {
    var errorMessage: BehaviorRelay<String?> { get }
    func handle(error: Error)
}

protocol MainViewModelType {
    var inputs: MainViewModelInputsType { get }
    var outputs: any MainViewModelOutputsType { get }
}

protocol MainViewModelInputsType {
    func scanText(_ input: Item)
    func touchUpTranslate(source: String, target: String)
    func viewDidDisappear()
}

protocol MainViewModelOutputsType {
    var outputItem: BehaviorRelay<Item?> { get }
    var errorMessage: BehaviorRelay<String?> { get }
}
