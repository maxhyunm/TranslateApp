//
//  TranslateError.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/13.
//

import Foundation

enum TranslateError: Error {
    case languageNotAvailable
    case unknown
    
    var alertMessage: String {
        switch self {
        case .languageNotAvailable:
            return String(format: NSLocalizedString("languageNotAvailable", comment: "변환 불가한 언어"))
        case .unknown:
            return String(format: NSLocalizedString("unknown", comment: "알 수 없는 오류"))
        }
    }
}
