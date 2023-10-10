//
//  Input.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import Foundation

struct Input {
    let frame: CGRect
    let text: String
    
    init(frame: CGRect, text: String) {
        self.frame = frame
        self.text = text
    }
}
