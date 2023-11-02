//
//  SourcesViewModelTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import LukeNewsApp

final class SourcesViewModelTests: XCTestCase {
    var viewModel: SourcesViewModel!
    var mockSourcesRepository: MockSourcesRepository!
    var mockArticleSourceManager: MockArticleSourceManager!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        mockSourcesRepository = MockSourcesRepository()
        mockArticleSourceManager = MockArticleSourceManager()
        
        viewModel = SourcesViewModel(articleSourceRepository: mockSourcesRepository, articleSourceManager: mockArticleSourceManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockSourcesRepository = nil
        mockArticleSourceManager = nil
        disposeBag = nil
    }

    func testLoadDataSuccess() {
        // Given
        let source = Source(id: "source-1", name: "Source One", description: "Description", url: "https://test.com/source1", category: "general", language: "en", country: "au")
        mockSourcesRepository.fetchSourcesReturnValue = Observable.just([source])
        mockArticleSourceManager.sourceIds = ["source-1"]

        let expectContent = expectation(description: "Content is loaded")

        // When
        viewModel.content
            .skip(1) // Skip the initial value
            .subscribe(onNext: { content in
                // Assert
                XCTAssertNotNil(content)
                XCTAssertEqual(content?.sourceContents.count, 1)
                XCTAssertEqual(content?.sourceContents.first?.id, "source-1")
                expectContent.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.loadData()

        // Then
        waitForExpectations(timeout: 5.0)
    }

    func testLoadDataFailure() {
        // Given
        mockSourcesRepository.shouldReturnError = true

        let expectError = expectation(description: "Error message is set")

        // When
        viewModel.errorMessage
            .skip(1)
            .subscribe(onNext: { errorMessage in
                // Assert
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage, "test error message")
                expectError.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.loadData()

        // Then
        waitForExpectations(timeout: 5.0)
    }
}

class MockSourcesRepository: SourcesRepository {
    var shouldReturnError = false
    var fetchSourcesCalled = false
    
    var fetchSourcesReturnValue: Observable<[Source]> = Observable.just([])
    var fetchSourcesErrorValue: Error = LKNetworkError.custom("test error message")
    
    func fetchSources() -> Observable<[Source]> {
        fetchSourcesCalled = true
        if shouldReturnError {
            return Observable.error(fetchSourcesErrorValue)
        }
        return fetchSourcesReturnValue
    }
}
