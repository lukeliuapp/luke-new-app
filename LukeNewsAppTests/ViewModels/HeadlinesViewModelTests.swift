//
//  HeadlinesViewModelTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import LukeNewsApp

class HeadlinesViewModelTests: XCTestCase {

    var viewModel: HeadlinesViewModel!
    var mockArticlesRepository: MockArticlesRepository!
    var mockArticleSourceManager: MockArticleSourceManager!
    var mockSavedArticlesManager: MockSavedArticlesManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockArticlesRepository = MockArticlesRepository()
        mockArticleSourceManager = MockArticleSourceManager()
        mockSavedArticlesManager = MockSavedArticlesManager()
        viewModel = HeadlinesViewModel(
            articlesRepository: mockArticlesRepository,
            articleSourceManager: mockArticleSourceManager,
            savedArticlesManager: mockSavedArticlesManager
        )
        disposeBag = DisposeBag()
    }

    func testLoadDataSuccess() {
        // Given
        let article = Article(source: .init(id: "test-source-id", name: "test-source-name"), author: nil, title: "test-title", description: nil, url: "https://test.com/article", urlToImage: nil, publishedAt: "2023-10-11T11:00:00Z", content: nil)
        let savedArticleContent = article.toArticleCellContent(isSaved: true)
        mockArticlesRepository.fetchHeadlineArticlesReturnValue = Observable.just([article])
        mockArticleSourceManager.sourceIds = ["test-source-id"]
        mockSavedArticlesManager.savedArticles = [savedArticleContent]

        let expectation = self.expectation(description: "Data loaded and articles marked as saved")

        // When
        viewModel.content
            .skip(1) // Skip initial nil value
            .subscribe(onNext: { content in
                guard let content = content else {
                    XCTFail("Content should not be nil")
                    return
                }

                XCTAssertTrue(!content.headlineContents.isEmpty, "Content should not be empty")
                XCTAssertEqual(content.headlineContents.first?.title, savedArticleContent.title, "First content title should match saved article title")
                XCTAssertTrue(content.headlineContents.first?.isSaved == true, "First content should be marked as saved")

                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.loadData()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testLoadDataFailed() {
        // Given
        let testError = LKNetworkError.custom("test error message")
        mockArticlesRepository.fetchHeadlineArticlesReturnValue = Observable.error(testError)
        let expectationErrorMessage = expectation(description: "Error message is set")
        let expectationLoadingFalse = expectation(description: "isLoading is set to false")

        // When
        viewModel.errorMessage
            .skip(1)
            .subscribe(onNext: { errorMessage in
                XCTAssertNotNil(errorMessage, "Error message should not be nil")
                XCTAssertEqual(errorMessage, testError.localizedDescription)
                expectationErrorMessage.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.isLoading
            .skip(1)
            .subscribe(onNext: { isLoading in
                if !isLoading {
                    expectationLoadingFalse.fulfill()
                }
            })
            .disposed(by: disposeBag)

        viewModel.loadData()

        // Then
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }

    override func tearDown() {
        // Deinitialize all the objects and set them to nil
        viewModel = nil
        mockArticlesRepository = nil
        mockArticleSourceManager = nil
        mockSavedArticlesManager = nil
        disposeBag = nil
        super.tearDown()
    }

}


// Mock classes

class MockArticlesRepository: ArticlesRepository {
    var fetchHeadlineArticlesReturnValue: Observable<[Article]> = Observable.just([])
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]> {
        return fetchHeadlineArticlesReturnValue
    }
}

class MockArticleSourceManager: ArticleSourceManager {
    var sourceIds: [String] = []
    
    func addSourceId(with sourceId: String) {
        sourceIds.append(sourceId)
    }
    
    func removeSourceId(with sourceId: String) {
        sourceIds.removeAll(where: { $0 == sourceId })
    }
    
    func getObservableSelectedSourceIds() -> Observable<[String]> {
        return Observable.just(sourceIds)
    }
    
    func getSelectedSourceIds() -> [String] {
        return sourceIds
    }
}

class MockSavedArticlesManager: SavedArticlesManager {
    var savedArticles: [ArticleCellContent] = []
    
    func add(article: ArticleCellContent) {
        savedArticles.append(article)
    }
    
    func removeArticle(with title: String) {
        savedArticles.removeAll(where: { $0.title == title })
    }
    
    func getSavedArticles() -> [ArticleCellContent] {
        return savedArticles
    }
    
    func getObservableSavedArticles() -> Observable<[ArticleCellContent]> {
        return Observable.just(savedArticles)
    }
}
