//
//  DecodingError.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

enum DecodingError: Error {
    case decodingFailure
    
    var description: String {
        switch self {
        case .decodingFailure:
            return "디코딩 오류입니다."
        }
    }
}
