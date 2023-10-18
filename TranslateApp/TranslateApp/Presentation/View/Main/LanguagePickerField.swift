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
    private let pickerView = UIPickerView()
    var dataSource = BehaviorRelay<[String]>(value: [])
    
    private let toolbar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 35)))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Colors.barButtonTitle
        toolBar.sizeToFit()
        return toolBar
    }()
    
    init() {
        super.init(frame: .init())
        configureUI()
        configureToolbar()
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
        layer.borderWidth = 1
        layer.borderColor = Colors.textFieldBorder

        inputView = pickerView
    }
    
    func configureToolbar() {
        let cancel = UIAction(title: String(format: NSLocalizedString("cancel", comment: "취소"))) { [weak self] _ in
            guard let self else { return }
            self.resignFirstResponder()
        }

        let select = UIAction(title: String(format: NSLocalizedString("select", comment: "선택"))) { [weak self] _ in
            guard let self else { return }
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.text = self.dataSource.value[row]
            self.resignFirstResponder()
        }

        let cancelButton = UIBarButtonItem(primaryAction: cancel)
        let selectButton = UIBarButtonItem(primaryAction: select)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([cancelButton, flexibleSpace, selectButton], animated: true)
        toolbar.isUserInteractionEnabled = true

        self.inputAccessoryView = toolbar
    }

    func bindPickerView(disposeBag: DisposeBag) {
        dataSource.bind(to: pickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
        
        dataSource.bind { [weak self] source in
            guard let self else { return }
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
            self.text = dataSource.value.first
        }.disposed(by: disposeBag)
    }
}

extension LanguagePickerField {
    struct Colors {
        static let barButtonTitle: UIColor = .tintColor
        static let textFieldText: UIColor = .white
        static let textFieldBackground: UIColor = CustomColors.darkBlue
        static let textFieldBorder: CGColor = CustomColors.cyan.cgColor
    }
}
