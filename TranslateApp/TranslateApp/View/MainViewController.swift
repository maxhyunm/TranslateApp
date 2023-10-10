//
//  ViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/09.
//

import UIKit
import VisionKit
import Vision

class MainViewController: UIViewController {
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("카메라 켜기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private var textRecognitionRequest = VNRecognizeTextRequest()
    private var resultViewController = ResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        view.addSubview(button)
        button.addTarget(self, action: #selector(startVisionKit), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
}

extension MainViewController {
    @objc private func startVisionKit() {
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                    qualityLevel: .fast,
                                                    recognizesMultipleItems: true,
                                                    isHighFrameRateTrackingEnabled: false,
                                                    isHighlightingEnabled: true)
        dataScanner.delegate = self
        self.present(dataScanner, animated: true)
        try? dataScanner.startScanning()
    }
}

extension MainViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        addedItems.forEach { item in
            switch item {
            case .text(let text):
                let input = Input(frame: CGRect(origin: text.bounds.bottomLeft,
                                                size: CGSize(width: text.bounds.topRight.x - text.bounds.topLeft.x,
                                                             height: text.bounds.topRight.y - text.bounds.topRight.y)),
                                  text: text.transcript)
            default:
                return
            }
        }
    }
}


