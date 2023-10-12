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
    
    private let sourcePickerView = UIPickerView()
    private let targetPickerView = UIPickerView()
    
    private let dataScanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                        qualityLevel: .balanced,
                                                        recognizesMultipleItems: false,
                                                        isHighFrameRateTrackingEnabled: true,
                                                        isHighlightingEnabled: true)

    private let viewModel: MainViewModelType

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
        configureUI()
    }
    
    private func configureLanguagePicker() {
        let safeArea = view.safeAreaLayoutGuide
        
        sourceLanguage.inputView = sourcePickerView
        targetLanguage.inputView = targetPickerView
        sourcePickerView.delegate = self
        sourcePickerView.dataSource = self
        targetPickerView.delegate = self
        targetPickerView.dataSource = self
        
        let icon = UIImageView(image: UIImage(systemName: "arrow.forward.circle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemTeal
        
        view.addSubview(sourceLanguage)
        view.addSubview(icon)
        view.addSubview(targetLanguage)
        
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: <#T##Selector?#>)
        
        NSLayoutConstraint.activate([
            sourceLanguage.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            sourceLanguage.widthAnchor.constraint(equalTo: targetLanguage.widthAnchor),
            sourceLanguage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            icon.leftAnchor.constraint(equalTo: sourceLanguage.rightAnchor),
            icon.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            icon.heightAnchor.constraint(equalTo: sourceLanguage.heightAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
            targetLanguage.leftAnchor.constraint(equalTo: icon.rightAnchor),
            targetLanguage.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            targetLanguage.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        translateButton.addTarget(self, action: #selector(touchUpTranslate), for: .touchUpInside)
        view.addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            translateButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            translateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
            translateButton.widthAnchor.constraint(equalToConstant: 100),
            translateButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func touchUpTranslate() {
        guard let source = sourceLanguage.text, let target = targetLanguage.text else { return }
        viewModel.inputs.touchUpTranslate(source: source, target: target)
        let result = ResultViewController(viewModel)
        present(result, animated: true)
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
        
        var inputs = [Item]()
        addedItems.forEach { item in
            switch item {
            case .text(let text):
                inputs.append(Item(frame: CGRect(origin: text.bounds.bottomLeft,
                                                  size: CGSize(width: text.bounds.topRight.x - text.bounds.topLeft.x,
                                                               height: text.bounds.topRight.y - text.bounds.topRight.y)),
                                    text: text.transcript))
            default:
                return
            }
        }
        viewModel.inputs.scanText(inputs)
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sourcePickerView:
            return Languages.sourceMenu.count
        default:
            return Languages.targetMenu.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sourcePickerView:
            return Languages.sourceMenu[row]
        default:
            return Languages.targetMenu[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sourcePickerView:
            sourceLanguage.text = Languages.sourceMenu[row]
            sourceLanguage.resignFirstResponder()
        default:
            targetLanguage.text = Languages.targetMenu[row]
            targetLanguage.resignFirstResponder()
        }
    }
}
