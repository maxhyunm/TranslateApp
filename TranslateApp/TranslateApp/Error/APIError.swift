//
//  APIError.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidAPIKey
    case requestFailure
    case invalidData
    case invalidHTTPStatusCode
    case requestTimeOut
    
    var message: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .invalidAPIKey:
            return "유효하지 않은 API Key입니다."
        case .requestFailure:
            return "연결에 실패하였습니다"
        case .invalidData:
            return "잘못된 데이터입니다"
        case .invalidHTTPStatusCode:
            return "잘못된 응답입니다"
        case . requestTimeOut:
            return "시간 초과입니다"
        }
    }
}