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

final class MainViewController: UIViewController, URLSessionDelegate, ToastShowable {
    private let sourceLanguage = LanguagePickerField(category: .source)
    private let targetLanguage = LanguagePickerField(category: .target)
    private let translateLabel = TextLabel()
    private var isTranslating = false {
        didSet {
            configureTranslateButton()
        }
    }
    
    private var translateButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: Constants.buttonTextSize)
        button.setImage(UIImage(systemName: Constants.buttonImageName, withConfiguration: config), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.tintColor = Colors.buttonTint
        button.backgroundColor = Colors.buttonBackground
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    private let arrowIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: Constants.iconImageName))
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
        addGestureRecognizer()
        bindTranslateButton()
        bindOutput()
        bindError()
        configureUI()
    }
}

extension MainViewController {
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = Colors.background
        view.addSubview(sourceLanguage)
        view.addSubview(arrowIcon)
        view.addSubview(targetLanguage)
        view.addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            sourceLanguage.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.spacing),
            sourceLanguage.widthAnchor.constraint(equalTo: targetLanguage.widthAnchor),
            sourceLanguage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            arrowIcon.leftAnchor.constraint(equalTo: sourceLanguage.rightAnchor, constant: Constants.spacing),
            arrowIcon.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            arrowIcon.heightAnchor.constraint(equalTo: sourceLanguage.heightAnchor),
            arrowIcon.widthAnchor.constraint(equalTo: arrowIcon.heightAnchor),
            
            targetLanguage.leftAnchor.constraint(equalTo: arrowIcon.rightAnchor, constant: Constants.spacing),
            targetLanguage.centerYAnchor.constraint(equalTo: sourceLanguage.centerYAnchor),
            targetLanguage.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -1 * Constants.spacing),
            
            translateButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            translateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: Constants.buttonBottomSpacing),
            translateButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            translateButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])
    }
    
    private func configureLanguagePicker() {
        sourceLanguage.bindPickerView(disposeBag: disposeBag)
        targetLanguage.bindPickerView(disposeBag: disposeBag)
    }
    
    private func configureScanner() {
        dataScanner.delegate = self
        
        addChild(dataScanner)
        view.addSubview(dataScanner.view)
        
        let top = sourceLanguage.intrinsicContentSize.height + Constants.spacing
        
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top),
            dataScanner.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dataScanner.didMove(toParent: self)
    }
    
    private func configureTranslateButton() {
        let config = UIImage.SymbolConfiguration(pointSize: Constants.buttonTextSize)
        switch isTranslating {
        case true:
            self.translateButton.backgroundColor = Colors.buttonReverseBackground
            self.translateButton.tintColor = Colors.buttonReverseTint
            self.translateButton.setImage(UIImage(systemName: Constants.buttonReverseImageName,
                                                  withConfiguration: config),
                                          for: .normal)
        case false:
            self.translateButton.backgroundColor = Colors.buttonBackground
            self.translateButton.tintColor = Colors.buttonTint
            self.translateButton.setImage(UIImage(systemName: Constants.buttonImageName,
                                                  withConfiguration: config),
                                          for: .normal)
        }
    }
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        translateLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func handleLongPress() {
        showToast(Constants.copyToastMessage, withDuration: 3.0, delay: 0.1)
        UIPasteboard.general.string = translateLabel.text
    }
}

extension MainViewController {
    private func bindTranslateButton() {
        translateButton.rx.tap.bind { [weak self] in
            guard let self,
                  let source = sourceLanguage.text,
                  let target = targetLanguage.text else { return }
            
            if isTranslating {
                try? self.dataScanner.startScanning()
            } else {
                self.dataScanner.stopScanning()
                self.viewModel.inputs.touchUpTranslate(source: source, target: target)
            }
            self.isTranslating = !self.isTranslating
        }.disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.outputs.outputItem
            .observe(on: MainScheduler.instance)
            .bind { [weak self] output in
                guard let self else { return }
                
                self.translateLabel.text = output
                self.view.addSubview(self.translateLabel)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.outputs.errorMessage
            .observe(on: MainScheduler.instance)
            .bind { [weak self] errorMessage in
                guard let self else { return }
                
                let alertBuilder = AlertBuilder(prefferedStyle: .alert)
                    .setMessage(errorMessage)
                    .addAction(.confirm) { action in
                        self.dismiss(animated: true)
                    }
                    .build()
                self.present(alertBuilder, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController,
                     didAdd addedItems: [RecognizedItem],
                     allItems: [RecognizedItem]) {
        translateLabel.removeFromSuperview()
        
        guard let item = addedItems.first,
              case .text(let text) = item else { return }
        
        let frame = CGRect(x: text.bounds.topLeft.x,
                           y: dataScanner.view.frame.origin.y + text.bounds.topLeft.y,
                           width: text.bounds.topRight.x - text.bounds.topLeft.x,
                           height: text.bounds.bottomRight.y - text.bounds.topRight.y)
        
        translateLabel.resetLabel(frame: frame)
        viewModel.inputs.scanText(text.transcript)
    }
}

extension MainViewController {
    struct Constants {
        static let spacing: CGFloat = 10
        static let buttonBottomSpacing: CGFloat = -80
        static let buttonSize: CGFloat = 100
        static let buttonTextSize: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 50
        static let buttonImageName: String = "arrow.left.arrow.right.circle"
        static let buttonReverseImageName: String = "arrow.uturn.backward.circle"
        static let iconImageName: String = "arrow.forward.circle.fill"
        static let copyToastMessage: String = String(format: NSLocalizedString("copyToastMessage", comment: "클립보드에 복사"))
    }
    
    struct Colors {
        static let background: UIColor = CustomColors.darkBlue
        static let buttonBackground: UIColor = CustomColors.yellow
        static let buttonReverseBackground: UIColor = CustomColors.darkBlue
        static let buttonTint: UIColor = CustomColors.darkBlue
        static let buttonReverseTint: UIColor = CustomColors.yellow
        static let iconTint: UIColor = CustomColors.pink
        static let labelBackground: UIColor = CustomColors.whiteWithAlpha
    }
}
