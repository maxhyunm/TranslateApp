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
        button.setTitle("번역하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
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
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(startTranslate), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
        ])
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
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            dataScanner.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        
        dataScanner.didMove(toParent: self)
    }


    @objc private func startTranslate() {
        viewModel.inputs.startTranslate(source: Languages.korean, target: Languages.english)
        let result = ResultViewController(viewModel.outputs)
        present(result, animated: true)
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


