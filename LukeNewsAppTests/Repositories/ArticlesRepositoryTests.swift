//
//  ArticlesRepositoryTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
@testable import LukeNewsApp

class MockApiService: LKApiServiceProtocol {
    var fetchSourcesResult: Observable<[Source]> = .empty()
    var fetchHeadlineArticlesResult: Observable<[Article]> = .empty()

    func fetchSources() -> Observable<[Source]> {
        return fetchSourcesResult
    }
    
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]> {
        return fetchHeadlineArticlesResult
    }
}

class ArticlesRepositoryTests: XCTestCase {
    
    var articlesRepository: ArticlesRepository!
    var mockApiService: MockApiService!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        articlesRepository = ArticlesRepositoryImpl(apiService: mockApiService)
        disposeBag = DisposeBag()
    }
    
    func testFetchHeadlineArticlesSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch headline articles succeeds")
        
        let mockArticles = [
            Article(source: .init(id: "test-id", name: "test-name"), author: nil, title: "test-title-1", description: nil, url: "https://example.com/testarticle", urlToImage: nil, publishedAt: "2023-10-11T11:00:00Z", content: nil),
            Article(source: .init(id: "test-id-2", name: "test-name-2"), author: nil, title: "test-title-2", description: nil, url: "https://example.com/testarticle2", urlToImage: nil, publishedAt: "2023-10-12T11:00:00Z", content: nil)
        ]
        mockApiService.fetchHeadlineArticlesResult = Observable.just(mockArticles)

        // When
        articlesRepository.fetchHeadlineArticles(with: ["source-id"])
            .subscribe(onNext: { articles in
                // Then
                XCTAssertEqual(articles.count, mockArticles.count)
                XCTAssertEqual(articles.first?.title, mockArticles.first?.title)
                XCTAssertEqual(articles.last?.title, mockArticles.last?.title)
                expectation.fulfill()
            }, onError: { _ in
                XCTFail("Expected successful result, got error")
            })
            .disposed(by: disposeBag)

        // Wait for expectations
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchHeadlineArticlesFailure() {
        // Given
        let expectation = self.expectation(description: "Fetch headline articles fails")
        let mockError = NSError(domain: "test", code: 0, userInfo: nil)
        mockApiService.fetchHeadlineArticlesResult = Observable.error(mockError)

        // When
        articlesRepository.fetchHeadlineArticles(with: ["source-id"])
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
