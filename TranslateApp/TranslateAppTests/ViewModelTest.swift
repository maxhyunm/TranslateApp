//
//  ViewModelTest.swift
//  TranslateAppTests
//
//  Created by Min Hyun on 2023/10/15.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import TranslateApp

final class ViewModelTest: XCTestCase {
    var sut: MainViewModel!
    let repository = TranslatorRepository(networkManager: NetworkManager())

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_스캔된_텍스트가_정상적으로_input에_저장된다() {
        // given
        let expectation = "input"
        
        // when
        sut.scanText(expectation)
        let result = sut.inputText
        
        // then
        XCTAssertEqual(expectation, result)
    }
}
