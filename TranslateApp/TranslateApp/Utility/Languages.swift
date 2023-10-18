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
    
    private var translatables: [Languages] {
        switch self {
        case .auto:
            return Self.allCases.filter { ![.auto, .unknown].contains($0) }
        case .unknown:
            return []
        case .korean:
            return Self.allCases.filter { ![.auto, .unknown, .korean].contains($0) }
        case .english:
            return [.korean, .japanese,.chineseSimple, .chineseTraditional, .french]
        case .japanese:
            return [.korean, .english, .chineseSimple, .chineseTraditional]
        case .chineseSimple:
            return [.korean, .english, .japanese, .chineseTraditional]
        case .chineseTraditional:
            return [.korean, .english, .japanese, .chineseSimple]
        case .french:
            return [.korean, .english]
        default:
            return [.korean]
        }
    }
    
    static let allMenu: [String] = Languages.allCases.filter { $0 != .unknown }.map { $0.description }
    
    var translatableMenu: [String] {
        return self.translatables.map { $0.description }
    }
    
    func canTranslate(to target: Languages) -> Bool {
        if !target.isTranslatable { return false }
        
        return self.translatables.contains(target) ? true : false
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

