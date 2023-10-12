//
//  LanguageCode.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

enum Languages: String, CustomStringConvertible, CaseIterable {
    case korean = "ko"
    case english = "en"
    case japanese = "ja"
    case chineseSimple = "zh-CN"
    case chineseTraditional = "zh-TW"
    case vietnamese = "vi"
    case indonesian = "id"
    case thai = "th"
    case german = "de"
    case russian = "ru"
    case spanish = "es"
    case italian = "it"
    case french = "fr"
    case unknown = "unk"
    
    var description: String {
        switch self {
        case .korean:
            return "한국어"
        case .english:
            return "영어"
        case .japanese:
            return "일본어"
        case .chineseSimple:
            return "중국어(간체)"
        case .chineseTraditional:
            return "중국어(번체)"
        case .vietnamese:
            return "베트남어"
        case .indonesian:
            return "인도네시아어"
        case .thai:
            return "태국어"
        case .german:
            return "독일어"
        case .russian:
            return "러시아어"
        case .spanish:
            return "스페인어"
        case .italian:
            return "이탈리아어"
        case .french:
            return "프랑스어"
        case .unknown:
            return "알 수 없음"
        }
    }
    
    static let sourceMenu: [String] = {
        var result = Self.allCases.filter { $0 != .unknown }.map { $0.description }
        result.insert("언어 감지", at: 0)
        return result
    }()
    
    static let targetMenu: [String]  = {
        return Self.allCases.filter { $0 != .unknown }.map { $0.description }
    }()
    
    static let descriptionToLanguage: [String:Languages] = {
        var result = Self.allCases.reduce(into: [:]) { $0[$1.description] = $1 }
        return result
    }()
    
    static func getLanguageType(for name: String) -> Languages? {
        guard let language = descriptionToLanguage[name] else {
            return nil
        }
        return language
    }
}