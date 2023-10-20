//
//  KeywordArgument.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

struct KeywordArgument {
    let key: String
    let value: Any?
    
    init(key: String, value: Any?) {
        self.key = key
        self.value = value
    }
}
