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
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("카메라 켜기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let dataScanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                        qualityLevel: .balanced,
                                                        recognizesMultipleItems: true,
                                                        isHighFrameRateTrackingEnabled: true,
                                                        isHighlightingEnabled: true)
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        textView.textColor = .white
        textView.font = .preferredFont(forTextStyle: .title3)
        return textView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return scrollView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private var textRecognitionRequest = VNRecognizeTextRequest()
    private let viewModel: MainViewModelType
    private var disposeBag = DisposeBag()

    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureScanner()
        bindScanner()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        view.addSubview(button)
        button.addTarget(self, action: #selector(startScan), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
}

extension MainViewController {
    private func configureScanner() {
        dataScanner.delegate = self
        scrollView.addSubview(textLabel)
        dataScanner.overlayContainerView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: dataScanner.overlayContainerView.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: dataScanner.overlayContainerView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: dataScanner.overlayContainerView.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: dataScanner.overlayContainerView.heightAnchor, multiplier: 0.3),
            textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            textLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            textLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func addLayerToScanner(_ items: [Item]) {
        var newText = ""
        items.forEach { item in
            newText += item.text
        }
        textLabel.text = newText
    }
    
    private func bindScanner() {
        viewModel.outputs.outputItems
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] outputs in
                DispatchQueue.main.async {
                    self?.addLayerToScanner(outputs)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func startScan() {
        self.present(dataScanner, animated: true)
        try? dataScanner.startScanning()
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
        viewModel.inputs.scanText(inputs, source: Languages.korean, target: Languages.english)
    }
}


