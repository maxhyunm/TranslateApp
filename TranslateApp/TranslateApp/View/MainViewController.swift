//
//  ViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/09.
//

import UIKit
import VisionKit
import Vision
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private var translateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "arrow.left.arrow.right.circle",
                                withConfiguration: config), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        button.clipsToBounds = true

        return button
    }()
    
    private let sourceLanguage: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "언어 선택"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    private let targetLanguage: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "언어 선택"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    private let arrowIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "arrow.forward.circle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemTeal
        return icon
    }()
    
    private let sourcePickerView = UIPickerView()
    private let targetPickerView = UIPickerView()
    
    private let dataScanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                        qualityLevel: .balanced,
                                                        recognizesMultipleItems: false,
                                                        isHighFrameRateTrackingEnabled: true,
                                                        isHighlightingEnabled: true)

    private let viewModel: MainViewModelType
    private var disposeBag = DisposeBag()

    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? dataScanner.startScanning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataScanner.stopScanning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScanner()
        configureLanguagePicker()
        configureTranslateButton()
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        view.addSubview(sourceLanguage)
        view.addSubview(arrowIcon)
        view.addSubview(targetLanguage)
        view.addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            sourceLanguage.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            sourceLanguage.widthAnchor.constraint(equalTo: targetLanguage.widthAnchor),
            sourceLanguage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            arrowIcon.leftAnchor.constraint(equalTo: sourceLanguage.rightAnchor),
            arrowIcon.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            arrowIcon.heightAnchor.constraint(equalTo: sourceLanguage.heightAnchor),
            arrowIcon.widthAnchor.constraint(equalTo: arrowIcon.heightAnchor),
            
            targetLanguage.leftAnchor.constraint(equalTo: arrowIcon.rightAnchor),
            targetLanguage.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            targetLanguage.rightAnchor.constraint(equalTo: safeArea.rightAnchor),

            translateButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            translateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
            translateButton.widthAnchor.constraint(equalToConstant: 100),
            translateButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureTranslateButton() {
        translateButton.rx.tap.bind { [weak self] in
            guard let self,
                  let source = sourceLanguage.text,
                  let target = targetLanguage.text else { return }
            self.viewModel.inputs.touchUpTranslate(source: source, target: target)
            let result = ResultViewController(self.viewModel)
            self.present(result, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func configureLanguagePicker() {
        sourceLanguage.inputView = sourcePickerView
        targetLanguage.inputView = targetPickerView
        
        Observable.just(Languages.sourceMenu).bind(to: sourcePickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
        
        Observable.just(Languages.targetMenu).bind(to: targetPickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
        
        sourcePickerView.rx.itemSelected.subscribe { [weak self] (row, _) in
            guard let self else { return }
            self.sourceLanguage.text = Languages.sourceMenu[row]
            self.sourceLanguage.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        targetPickerView.rx.itemSelected.subscribe { [weak self] (row, _) in
            guard let self else { return }
            self.targetLanguage.text = Languages.targetMenu[row]
            self.targetLanguage.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        sourcePickerView.selectRow(0, inComponent: 0, animated: false)
        targetPickerView.selectRow(0, inComponent: 0, animated: false)
        sourceLanguage.text = Languages.sourceMenu.first
        targetLanguage.text = Languages.targetMenu.first
    }
}

extension MainViewController {
    private func configureScanner() {
        dataScanner.delegate = self
        
        addChild(dataScanner)
        
        dataScanner.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataScanner.view)
        
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            dataScanner.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            dataScanner.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50
            ),
            dataScanner.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        
        dataScanner.didMove(toParent: self)
    }
}

extension MainViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard let item = addedItems.first else { return }
        if case .text(let text) = item {
            let newInput = Item(frame: CGRect(origin: text.bounds.bottomLeft,
                                              size: CGSize(width: text.bounds.topRight.x - text.bounds.topLeft.x,
                                                           height: text.bounds.topRight.y - text.bounds.topRight.y)),
                                text: text.transcript)
            viewModel.inputs.scanText(newInput)
        }
    }
}

