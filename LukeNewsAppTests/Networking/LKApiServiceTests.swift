//
//  LKApiServiceTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
@testable import LukeNewsApp

class LKApiServiceTests: XCTestCase {
    
    var subject: LKApiService!
    var urlSession: MockURLSession!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        urlSession = MockURLSession()
        disposeBag = DisposeBag()
        subject = LKApiService(with: LKHttpClient(session: urlSession))
    }
    
    func testFetchSourcesSuccess() {
        // Arrange
        let expectedSources = [
            Source(id: "test-id", name: "test-name", description: "test-description", url: "https://example.com/testsource", category: "test-category", language: "en", country: "au"),
            Source(id: "test-id-2", name: "test-name-2", description: "test-description-2", url: "https://example.com/testsource2", category: "test-category-2", language: "en", country: "au"),
        ]
        urlSession.nextData = try? JSONEncoder().encode(SourcesResponse(status: "success", sources: expectedSources))
        
        // Act & Assert
        let expectation = self.expectation(description: "Observable emits values and completes")
        
        subject.fetchSources().subscribe(onNext: { sources in
            XCTAssertEqual(sources.count, expectedSources.count)
            XCTAssertEqual(sources.first?.id, expectedSources.first?.id)
            expectation.fulfill()
        }, onError: { error in
            XCTFail("Expected success, but got error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchHeadlineArticlesSuccess() {
        // Arrange
        let expectedArticles = [Article(source: .init(id: "test-id", name: "test-name"), author: nil, title: "test-title-1", description: nil, url: "https://example.com/testarticle", urlToImage: nil, publishedAt: "2023-10-11T11:00:00Z", content: nil)]
        urlSession.nextData = try? JSONEncoder().encode(ArticlesResponse(status: "success", totalResults: 1, articles: expectedArticles))
        
        let sourceIds = ["test-id"]
        
        // Act & Assert
        let expectation = self.expectation(description: "Observable emits values and completes")
        
        subject.fetchHeadlineArticles(with: sourceIds).subscribe(onNext: { articles in
            XCTAssertEqual(articles.count, expectedArticles.count)
            XCTAssertEqual(articles.first?.title, expectedArticles.first?.title)
            expectation.fulfill()
        }, onError: { error in
            XCTFail("Expected success, but got error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

