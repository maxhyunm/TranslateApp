//
//  TranslateError.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/13.
//

enum TranslateError: Error {
    case languageNotAvailable
    case unknown
    
    var alertMessage: String {
        switch self {
        case .languageNotAvailable:
            return "변환 불가한 언어입니다."
        case .unknown:
            return "알 수 없는 오류입니다"
        }
    }
}
