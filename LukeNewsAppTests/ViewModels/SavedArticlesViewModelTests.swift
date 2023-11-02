//
//  SavedArticlesViewModelTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import LukeNewsApp

class SavedArticlesViewModelTests: XCTestCase {
    
    var viewModel: SavedArticlesViewModel!
    var mockSavedArticlesManager: MockSavedArticlesManager!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mockSavedArticlesManager = MockSavedArticlesManager()
        viewModel = SavedArticlesViewModel(savedArticlesManager: mockSavedArticlesManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockSavedArticlesManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testLoadData_withSavedArticles() {
        // Given
        let savedArticles = [
            ArticleCellContent(title: "Article 1", description: "Description 1", content: nil, url: "https://example.com/1", urlToImage: nil, publishedAt: "2023-10-11T11:00:00Z", isSaved: true),
            ArticleCellContent(title: "Article 2", description: "Description 2", content: nil, url: "https://example.com/2", urlToImage: nil, publishedAt: "2022-10-11T11:00:00Z", isSaved: true)
        ]
        
        mockSavedArticlesManager.savedArticles = savedArticles
        
        let expectation = self.expectation(description: "Content loaded with saved articles")
        
        // When
        viewModel.content
            .skip(1)
            .subscribe(onNext: { content in
                // Then
                XCTAssertEqual(content?.headlineContents, savedArticles)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.loadData()
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRemoveSavedArticle() {
        // Given
        let articleToRemove = ArticleCellContent(title: "Article 1", description: "Description 1", content: nil, url: "https://example.com/1", urlToImage: nil, publishedAt: "2023-10-11T11:00:00Z", isSaved: true)
        mockSavedArticlesManager.savedArticles = [articleToRemove]
        
        // When
        viewModel.removeSavedArticle(with: articleToRemove)
        
        // Then
        XCTAssertTrue(mockSavedArticlesManager.savedArticles.isEmpty)
    }
}


