//
//  SourcesRepositoryTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
@testable import LukeNewsApp

class SourcesRepositoryTests: XCTestCase {
    private var repository: SourcesRepository!
    private var mockApiService: MockApiService!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mockApiService = MockApiService()
        repository = SourcesRepositoryImpl(apiService: mockApiService)
    }
    
    override func tearDown() {
        disposeBag = nil
        mockApiService = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchSourcesSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch sources succeeds")
        let mockSources = [
            Source(id: "test-id", name: "test-name", description: "test-description", url: "https://example.com/testsource", category: "test-category", language: "en", country: "au"),
            Source(id: "test-id-2", name: "test-name-2", description: "test-description-2", url: "https://example.com/testsource2", category: "test-category-2", language: "en", country: "au"),
        ]
        mockApiService.fetchSourcesResult = Observable.just(mockSources)
        
        // When
        repository.fetchSources()
            .subscribe(onNext: { sources in
                // Then
                XCTAssertEqual(sources.count, mockSources.count)
                XCTAssertEqual(sources[0].id, mockSources[0].id)
                XCTAssertEqual(sources[1].id, mockSources[1].id)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Wait for expectations
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchSourcesFailure() {
        // Given
        let expectation = self.expectation(description: "Fetch sources fails")
        let mockError = NSError(domain: "test", code: 0, userInfo: nil)
        mockApiService.fetchSourcesResult = Observable.error(mockError)
        
        // When
        repository.fetchSources()
            .subscribe(onNext: { _ in
                XCTFail("Expected error, got success")
            }, onError: { error in
                // Then
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Wait for expectations
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
