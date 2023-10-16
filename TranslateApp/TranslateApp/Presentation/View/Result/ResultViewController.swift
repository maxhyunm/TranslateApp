//
//  ResultViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/12.
//

import UIKit
import RxSwift

final class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType
    private var disposeBag = DisposeBag()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.textViewBackground
        textView.textColor = Colors.textViewText
        textView.font = .preferredFont(forTextStyle: .title3)
        textView.isEditable = false
        return textView
    }()
    
    init(_ viewModel: ResultViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutput()
        bindError()
        configureUI()
        configureBarItem()
    }
    
    private func configureUI() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func configureBarItem() {
        let close = UIAction(title: String(format: NSLocalizedString("close", comment: "닫기"))) { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }
        let copy = UIAction(title: String(format: NSLocalizedString("copy", comment: "복사"))) { [weak self] _ in
            guard let self else { return }
            UIPasteboard.general.string = self.textView.text
        }

        let closeButton = UIBarButtonItem(primaryAction: close)
        let copyButton = UIBarButtonItem(primaryAction: copy)
        
        closeButton.tintColor = Colors.barButtonTitle
        copyButton.tintColor = Colors.barButtonTitle
        
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.leftBarButtonItem = copyButton
    }
    
    private func bindOutput() {
        viewModel.outputItem
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] output in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.textView.text = output
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.errorMessage
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] errorMessage in
                guard let self else { return }
                let alertBuilder = AlertBuilder(prefferedStyle: .alert)
                    .setMessage(errorMessage)
                    .addAction(.confirm) { action in
                        self.dismiss(animated: true)
                    }
                    .build()
                DispatchQueue.main.async {
                    self.present(alertBuilder, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}


extension ResultViewController {
    struct Colors {
        static let barButtonTitle: UIColor = .tintColor
        static let textViewBackground: UIColor = CustomColors.grayWithAlpha
        static let textViewText: UIColor = .white
    }
}
