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
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 35)))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Colors.barButtonTitle
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
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        textAlignment = .center
        font = .preferredFont(forTextStyle: .headline)
        backgroundColor = Colors.textFieldBackground
        tintColor = Colors.textFieldBackground
        textColor = Colors.textFieldText
        borderStyle = .roundedRect
        clipsToBounds = true
        layer.cornerRadius = 15

        inputView = pickerView
    }
    
    func configureToolBar() {
        let cancel = UIAction(title: String(format: NSLocalizedString("cancel", comment: "취소"))) { [weak self] _ in
            guard let self else { return }
            self.resignFirstResponder()
        }

        let select = UIAction(title: String(format: NSLocalizedString("select", comment: "선택"))) { [weak self] _ in
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

extension LanguagePickerField {
    enum Colors {
        static let barButtonTitle: UIColor = CustomColors.lightPurple
        static let textFieldText: UIColor = .white
        static let textFieldBackground: UIColor = CustomColors.lightPurple
    }
}
