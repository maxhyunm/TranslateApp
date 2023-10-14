//
//  DecodingError.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum DecodingError: Error {
    case decodingFailure
    
    var alertMessage: String {
        switch self {
        case .decodingFailure:
            return String(format: NSLocalizedString("decodingFailure", comment: "디코딩 오류"))
        }
    }
}
