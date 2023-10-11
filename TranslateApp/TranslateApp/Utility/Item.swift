//
//  Input.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

struct Item {
    let frame: CGRect?
    let text: String
    
    init(frame: CGRect? = nil, text: String) {
        self.frame = frame
        self.text = text
    }
}
