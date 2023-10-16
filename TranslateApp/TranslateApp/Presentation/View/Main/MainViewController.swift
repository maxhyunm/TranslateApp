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

final class MainViewController: UIViewController, URLSessionDelegate {
    private let sourceLanguage = LanguagePickerField(category: .source)
    private let targetLanguage = LanguagePickerField(category: .target)
    
    private var translateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "arrow.left.arrow.right.circle",
                                withConfiguration: config), for: .normal)
        button.tintColor = Colors.buttonTint
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.backgroundColor = Colors.buttonBackground
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        return button
    }()
    
    private let arrowIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "arrow.forward.circle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = Colors.iconTint
        return icon
    }()
    
    private let dataScanner: DataScannerViewController = {
        let scanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                qualityLevel: .balanced,
                                                recognizesMultipleItems: false,
                                                isHighFrameRateTrackingEnabled: true,
                                                isHighlightingEnabled: true)
        scanner.view.translatesAutoresizingMaskIntoConstraints = false
        return scanner
    }()

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
        configureLanguagePicker()
        configureScanner()
        configureTranslateButton()
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = Colors.background
        view.addSubview(sourceLanguage)
        view.addSubview(arrowIcon)
        view.addSubview(targetLanguage)
        view.addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            sourceLanguage.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10),
            sourceLanguage.widthAnchor.constraint(equalTo: targetLanguage.widthAnchor),
            sourceLanguage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            arrowIcon.leftAnchor.constraint(equalTo: sourceLanguage.rightAnchor, constant: 10),
            arrowIcon.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            arrowIcon.heightAnchor.constraint(equalTo: sourceLanguage.heightAnchor),
            arrowIcon.widthAnchor.constraint(equalTo: arrowIcon.heightAnchor),
            
            targetLanguage.leftAnchor.constraint(equalTo: arrowIcon.rightAnchor, constant: 10),
            targetLanguage.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            targetLanguage.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10),

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
            let resultViewController = ResultViewController(self.viewModel.resultViewModel)
            let resultNavigationControllr = UINavigationController(rootViewController: resultViewController)
            DispatchQueue.main.async {
                self.present(resultNavigationControllr, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func configureLanguagePicker() {
        sourceLanguage.bindPickerView(disposeBag: disposeBag)
        targetLanguage.bindPickerView(disposeBag: disposeBag)
    }
}

extension MainViewController {
    private func configureScanner() {
        dataScanner.delegate = self
        
        addChild(dataScanner)
        view.addSubview(dataScanner.view)
        
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            dataScanner.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dataScanner.didMove(toParent: self)
    }
}

extension MainViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController,
                     didAdd addedItems: [RecognizedItem],
                     allItems: [RecognizedItem]) {
        guard let item = addedItems.first,
              case .text(let text) = item else { return }
        viewModel.inputs.scanText(text.transcript)
    }
}

extension MainViewController {
    struct Colors {
        static let background: UIColor = CustomColors.darkBlue
        static let buttonBackground: UIColor = CustomColors.yellow
        static let buttonTint: UIColor = CustomColors.darkBlue
        static let iconTint: UIColor = CustomColors.pink
    }
}
