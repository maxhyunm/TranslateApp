//
//  TextLabel.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/17.
//

import UIKit

final class TextLabel: UILabel {
    init() {
        super.init(frame: .init())
        textColor = .black
        textAlignment = .center
        backgroundColor = Colors.labelBackground
        numberOfLines = 0
        layer.cornerRadius = 10
        adjustsFontSizeToFitWidth = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetLabel(frame: CGRect) {
        self.frame = frame
        self.text = ""
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    struct Colors {
        static let labelBackground: UIColor = CustomColors.whiteWithAlpha
    }
}
