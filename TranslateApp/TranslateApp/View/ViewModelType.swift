//
//  ViewModelType.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import RxCocoa

protocol MainViewModelType {
    var inputs: MainViewModelInputsType { get }
    var outputs: any MainViewModelOutputsType { get }
}

protocol MainViewModelInputsType {
    func scanText(_ input: [Item])
    func startTranslate(source: Languages?, target: Languages)
}

protocol MainViewModelOutputsType {
    var inputItems: BehaviorRelay<[Item]> { get }
    var outputItems: BehaviorRelay<[Item]> { get }
}
