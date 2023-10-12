//
//  ResultViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/12.
//

import UIKit
import RxSwift

class ResultViewController: UIViewController {
    let viewModel: MainViewModelType
    private var disposeBag = DisposeBag()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        textView.textColor = .white
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
        bindOutput()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputs.viewDidDisappear()
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
        viewModel.outputs.outputItem
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] output in
                guard let output else { return }
                DispatchQueue.main.async {
                    self?.changeText(output)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func changeText(_ item: Item) {
        textView.text = item.text
    }
}
