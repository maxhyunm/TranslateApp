//
//  LanguageCode.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

enum Languages: String, CustomStringConvertible, CaseIterable {
    case auto = "auto"
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
        case .auto:
            return String(format: NSLocalizedString("languageAuto", comment: "언어 감지"))
        case .korean:
            return String(format: NSLocalizedString("languageKorean", comment: "한국어"))
        case .english:
            return String(format: NSLocalizedString("languageEnglish", comment: "영어"))
        case .japanese:
            return String(format: NSLocalizedString("languageJapanese", comment: "일본어"))
        case .chineseSimple:
            return String(format: NSLocalizedString("languageChineseSimple", comment: "중국어(간체)"))
        case .chineseTraditional:
            return String(format: NSLocalizedString("languageChineseTraditional", comment: "중국어(번체)"))
        case .vietnamese:
            return String(format: NSLocalizedString("languageVietnamese", comment: "베트남어"))
        case .indonesian:
            return String(format: NSLocalizedString("languageIndonesian", comment: "인도네시아어"))
        case .thai:
            return String(format: NSLocalizedString("languageThai", comment: "태국어"))
        case .german:
            return String(format: NSLocalizedString("languageGerman", comment: "독일어"))
        case .russian:
            return String(format: NSLocalizedString("languageRussian", comment: "러시아어"))
        case .spanish:
            return String(format: NSLocalizedString("languageSpanish", comment: "스페인어"))
        case .italian:
            return String(format: NSLocalizedString("languageItalian", comment: "이탈리아어"))
        case .french:
            return String(format: NSLocalizedString("languageFrench", comment: "프랑스어"))
        case .unknown:
            return String(format: NSLocalizedString("languageUnknown", comment: "기타"))
        }
    }
    
    var isTranslatable: Bool {
        switch self {
        case .auto, .unknown:
            return false
        default:
            return true
        }
    }

    static func getLanguageType(for name: String?) -> Languages? {
        let descriptionToLanguage = Self.allCases.reduce(into: [:]) { $0[$1.description] = $1 }
        guard let name,
              let language = descriptionToLanguage[name] else {
            return nil
        }
        return language
    }
}

extension Languages {
    enum Category {
        case source
        case target
        
        var menu: [String] {
            switch self {
            case .source:
                return Languages.allCases.filter { $0 != .unknown }.map { $0.description }
            case .target:
                return Languages.allCases.filter { $0 != .auto && $0 != .unknown }.map { $0.description }
            }
        }
    }
}
