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
    case invalidResponse
    case invalidHTTPStatusCode(statusCode: Int)
    case requestTimeOut
    
    var alertMessage: String {
        switch self {
        case .invalidURL:
            return String(format: NSLocalizedString("invalidURL", comment: "잘못된 URL"))
        case .invalidAPIKey:
            return String(format: NSLocalizedString("invalidAPIKey", comment: "API KEY 오류"))
        case .requestFailure:
            return String(format: NSLocalizedString("requestFailure", comment: "연결 실패"))
        case .invalidData:
            return String(format: NSLocalizedString("invalidData", comment: "데이터 형식 오류"))
        case .invalidResponse:
            return String(format: NSLocalizedString("invalidResponse", comment: "잘못된 응답"))
        case .invalidHTTPStatusCode(statusCode: let statusCode):
            return String(format: NSLocalizedString("invalidHTTPStatusCode", comment: "네트워크 응답 코드 오류")) + "\(statusCode)"
        case . requestTimeOut:
            return String(format: NSLocalizedString("requestTimeOut", comment: "시간 초과"))
        }
    }
}
