//
//  TextPickerField.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/13.
//

import UIKit
import RxSwift
import RxCocoa

final class LanguagePickerField: UITextField {
    let pickerView = UIPickerView()
    let category: Languages.Category
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.54, green: 0.67, blue: 0.98, alpha: 1.00)
        toolBar.sizeToFit()
        return toolBar
    }()
    
    init(category: Languages.Category) {
        self.category = category
        super.init(frame: .init())
        configureUI()
        configureToolBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        backgroundColor = .white
        tintColor = UIColor(red: 0.98, green: 0.63, blue: 0.73, alpha: 1.00)
        textAlignment = .center
        font = .preferredFont(forTextStyle: .headline)
        textColor = UIColor(red: 0.54, green: 0.67, blue: 0.98, alpha: 1.00)
        inputView = pickerView
    }
    
    func configureToolBar() {
        let cancel = UIAction(title: "취소") { [weak self] _ in
            guard let self else { return }
            self.resignFirstResponder()
        }
        
        let select = UIAction(title: "선택") { [weak self] _ in
            guard let self else { return }
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.text = self.category.menu[row]
            self.resignFirstResponder()
        }
        
        let cancelButton = UIBarButtonItem(primaryAction: cancel)
        let selectButton = UIBarButtonItem(primaryAction: select)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, flexibleSpace, selectButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }

    func bindWithPickerView(disposeBag: DisposeBag) {
        Observable.just(category.menu).bind(to: pickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)

        pickerView.selectRow(0, inComponent: 0, animated: false)
        self.text = category.menu.first
    }
}
