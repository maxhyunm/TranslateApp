//
//  ToastShowable.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/17.
//

import UIKit

protocol ToastShowable where Self: UIViewController {}

extension ToastShowable {
    func showToast(_ message: String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: 100, width: 170, height: 35))
        toastLabel.backgroundColor = CustomColors.blackWithAlpha
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 3
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
