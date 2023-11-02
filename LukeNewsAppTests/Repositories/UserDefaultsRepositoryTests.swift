//
//  UserDefaultsRepositoryTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
@testable import LukeNewsApp

class UserDefaultsRepositoryTests: XCTestCase {

    var userDefaultsRepository: UserDefaultsRepository!
    var userDefaults: UserDefaults!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "testUserDefaults")
        userDefaultsRepository = UserDefaultsRepositoryImpl(userDefaults: userDefaults)
        disposeBag = DisposeBag()
        userDefaults.removePersistentDomain(forName: "testUserDefaults")
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "testUserDefaults")
        super.tearDown()
    }
    
    func testSavedArticles() {
        let expectation = self.expectation(description: "savedArticles")
        let testData: [Data] = ["test1".data(using: .utf8)!]
        userDefaultsRepository.savedArticles.value = testData
        
        userDefaultsRepository.savedArticles.observable
            .take(1)
            .subscribe(onNext: { savedData in
                XCTAssertEqual(String(data: savedData.first!, encoding: .utf8), "test1")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSelectedSourceIDs() {
        let expectation = self.expectation(description: "selectedSourceIDs")
        let testIDs = ["test-id"]
        userDefaultsRepository.selectedSourceIDs.value = testIDs

        userDefaultsRepository.selectedSourceIDs.observable
            .take(1)
            .subscribe(onNext: { sourceIDs in
                XCTAssertEqual(sourceIDs, testIDs)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
