//
//  ResultViewModel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/15.
//

import Foundation
import RxCocoa

final class ResultViewModel: ResultViewModelType, ViewModelWithError {
    var outputItem = PublishRelay<String>()
    var errorMessage = PublishRelay<String>()
}
