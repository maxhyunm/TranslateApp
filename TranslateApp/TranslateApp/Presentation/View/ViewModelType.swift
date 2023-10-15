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
    func scanText(_ input: String)
    func touchUpTranslate(source: String, target: String)
}

protocol MainViewModelOutputsType {
    var outputItem: PublishRelay<String> { get }
    var errorMessage: PublishRelay<String> { get }
}

protocol ViewModelWithError {
    var errorMessage: PublishRelay<String> { get }
    func handle(error: Error)
}

extension ViewModelWithError {
    func handle(error: Error) {
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
