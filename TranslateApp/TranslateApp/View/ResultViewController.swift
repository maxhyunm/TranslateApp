//
//  ResultViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/12.
//

import UIKit
import RxSwift

class ResultViewController: UIViewController {
    let viewModel: MainViewModelOutputsType
    private var disposeBag = DisposeBag()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        textView.textColor = .white
        textView.font = .preferredFont(forTextStyle: .title3)
        return textView
    }()
    
    init(_ viewModel: MainViewModelOutputsType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindOutput()
    }
    
    private func configureUI() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func bindOutput() {
        viewModel.outputItems
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] outputs in
                DispatchQueue.main.async {
                    self?.addLayerToScanner(outputs)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func addLayerToScanner(_ items: [Item]) {
        var newText = ""
        items.forEach { item in
            newText += item.text
        }
        textView.text = newText
    }
}
