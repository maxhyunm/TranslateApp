//
//  ResultViewController.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import UIKit
import Vision

class ResultViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            textView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            textView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        ])
    }
}

extension ResultViewController: RecognizedTextDataSourceType {
    func addText(recognizedText: [VNRecognizedTextObservation]) {
        var fullText = ""
        for text in recognizedText {
            guard let candidate = text.topCandidates(1).first else { continue }
            fullText.append(candidate.string + "\n")
        }
        textView.text = fullText
    }
}
