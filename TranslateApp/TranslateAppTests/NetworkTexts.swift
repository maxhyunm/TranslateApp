//
//  NetworkText.swift
//  TranslateAppTests
//
//  Created by Min Hyun on 2023/10/15.
//

import XCTest
@testable import TranslateApp

final class NetworkTexts: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
        setupSUT(type: .translator(body: []), statusCode: 200)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func setupSUT(type: NetworkConfiguration, statusCode: Int) {
        let assetName: String = {
            switch type {
            case .translator:
                return "translator_test"
            case .languageDetector:
                return "language_detector_test"
            }
        }()
        let stubSession = StubURLSession(statusCode: statusCode, assetName: assetName, type: type)
        sut.session = stubSession
    }
    
    func test_언어감지_네트워킹이_성공했을때_데이터가_정상적으로_반환된다() {
        // given
        let expectation = "ko"
        setupSUT(type: .languageDetector(body: []), statusCode: 200)
        
        // when & then
        sut.fetchData(.languageDetector(body: [])) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: LanguageDetectorDTO = try DecodingManager.shared.decode(data)!
                    XCTAssertEqual(expectation, decodedData.languageCode)
                } catch {
                    XCTFail("테스트 실패 - 디코딩 불가")
                }
            case .failure:
                XCTFail("테스트 실패 - 네트워크 오류")
            }
        }
    }
    
    func test_언어감지_네트워킹이_실패했을때_에러가_반환된다() {
        // given
        let statusCode = 400
        let expectation = String(format: NSLocalizedString("invalidHTTPStatusCode", comment: "네트워크 응답 코드 오류")) + "\(statusCode)"
        setupSUT(type: .languageDetector(body: []), statusCode: statusCode)
        
        // when & then
        sut.fetchData(.languageDetector(body: [])) { result in
            switch result {
            case .success:
                XCTFail("테스트 실패")
            case .failure(let error):
                let error = error as! APIError
                XCTAssertEqual(expectation, error.alertMessage)
            }
        }
    }
    
    func test_번역_네트워킹이_성공했을때_데이터가_정상적으로_반환된다() {
        // given
        let expectation = "Hello"
        setupSUT(type: .translator(body: []), statusCode: 200)
        
        // when & then
        sut.fetchData(.translator(body: [])) { result in
            switch result {
            case .success(let data):
                do {
                    guard let decodedData: TranslatorDTO = try DecodingManager.shared.decode(data) else {
                        XCTFail("테스트 실패 - 디코딩 불가")
                        return
                    }
                    XCTAssertEqual(expectation, decodedData.message.result.translatedText)
                } catch {
                    XCTFail("테스트 실패 - 디코딩 불가")
                }
            case .failure:
                XCTFail("테스트 실패 - 네트워크 오류")
            }
        }
    }
    
    func test_번역_네트워킹이_실패했을때_에러가_반환된다() {
        // given
        let statusCode = 400
        let expectation = String(format: NSLocalizedString("invalidHTTPStatusCode", comment: "네트워크 응답 코드 오류")) + "\(statusCode)"
        setupSUT(type: .translator(body: []), statusCode: statusCode)
        
        // when & then
        sut.fetchData(.translator(body: [])) { result in
            switch result {
            case .success:
                XCTFail("테스트 실패")
            case .failure(let error):
                let error = error as! APIError
                XCTAssertEqual(expectation, error.alertMessage)
            }
        }
    }
}
