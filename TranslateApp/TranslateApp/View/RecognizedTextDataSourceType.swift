//
//  RecognizedTextDataSourceType.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import UIKit
import Vision

protocol RecognizedTextDataSourceType: AnyObject {
    func addText(recognizedText: [VNRecognizedTextObservation])
}
