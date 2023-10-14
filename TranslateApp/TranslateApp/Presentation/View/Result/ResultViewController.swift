//
//  ResultViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/12.
//

import UIKit
import RxSwift

final class ResultViewController: UIViewController {
    let viewModel: MainViewModelType
    private var disposeBag = DisposeBag()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = ColorNamespace.textViewBackground
        textView.textColor = ColorNamespace.textViewText
        textView.font = .preferredFont(forTextStyle: .title3)
        textView.isEditable = false
        return textView
    }()
    
    init(_ viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarItem()
        bindOutput()
        bindError()
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
        let close = UIAction(title: "닫기") { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }

        let closeButton = UIBarButtonItem(primaryAction: close)
        
        closeButton.tintColor = ColorNamespace.barButtonTitle
        
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func bindOutput() {
        viewModel.outputs.outputItem
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
        viewModel.outputs.errorMessage
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
