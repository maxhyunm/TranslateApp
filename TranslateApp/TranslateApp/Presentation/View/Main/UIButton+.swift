//
//  UIButton+.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/14.
//

import UIKit

extension UIButton {
    func configureTranslateButton() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        setImage(UIImage(systemName: "arrow.left.arrow.right.circle",
                              withConfiguration: config), for: .normal)
        tintColor = UIColor(red: 0.54, green: 0.67, blue: 0.98, alpha: 1.00)
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        backgroundColor = .white
        layer.cornerRadius = 50
        clipsToBounds = true
        
        return self
    }
}
