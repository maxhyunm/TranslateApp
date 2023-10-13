//
//  TextPickerField.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/13.
//

import UIKit
import RxSwift
import RxCocoa

class TextPickerField: UITextField {
    let pickerView = UIPickerView()
    let disposeBag = DisposeBag()
    
    init(placeholder: String) {
        super.init(frame: .init())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.textAlignment = .center
        self.font = .preferredFont(forTextStyle: .headline)
        self.inputView = pickerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindWithPickerView(dataSource: [String]) {
        Observable.just(dataSource).bind(to: pickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)

        pickerView.rx.itemSelected.subscribe { [weak self] (row, _) in
            guard let self else { return }
            DispatchQueue.main.async {
                self.text = dataSource[row]
                self.resignFirstResponder()
            }
        }.disposed(by: disposeBag)
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        self.text = dataSource.first
    }
}
