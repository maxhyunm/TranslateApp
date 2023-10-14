//
//  ColorNamespace.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/14.
//

import UIKit

enum ColorNamespace {
    enum CustomColors {
        static let yellow = UIColor(red: 0.94, green: 0.90, blue: 0.56, alpha: 1.00)
        static let darkBlue = UIColor(red: 0.16, green: 0.18, blue: 0.36, alpha: 1.00)
        static let pink = UIColor(red: 0.96, green: 0.32, blue: 0.89, alpha: 1.00)
        static let lightPurple = UIColor(red: 0.61, green: 0.62, blue: 0.98, alpha: 1.00)
    }
    
    static let background: UIColor = CustomColors.darkBlue
    static let textFieldBackground: UIColor = CustomColors.lightPurple
    static let textFieldText: UIColor = .white
    static let textFieldBorder: UIColor = CustomColors.lightPurple
    static let textFieldShadow: UIColor = CustomColors.pink
    static let buttonBackground: UIColor = CustomColors.pink
    static let buttonTint: UIColor = CustomColors.darkBlue
    static let iconTint: UIColor = CustomColors.yellow
    static let barButtonTitle: UIColor = CustomColors.lightPurple
    static let textViewBackground: UIColor = UIColor.darkGray.withAlphaComponent(0.8)
    static let textViewText: UIColor = .white
}
