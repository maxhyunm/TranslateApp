//
//  Input.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

final class TranslateItem {
    var source: Languages
    var target: Languages
    var text: String
    
    init(source: Languages, target: Languages, text: String) {
        self.source = source
        self.target = target
        self.text = text
    }
}
