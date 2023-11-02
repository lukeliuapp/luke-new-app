//
//  HeadlinesViewModel.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import RxCocoa
import RxSwift

class HeadlinesViewModel {
    let title: Driver<String> = .just("My Headlines")
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let content: BehaviorRelay<Content?> = .init(value: nil)
    let errorMessage: BehaviorRelay<String?> = .init(value: nil)
    
    private let articlesRepository: ArticlesRepository
    private let articleSourceManager: ArticleSourceManager
    private let savedArticlesManager: SavedArticlesManager
    private var disposeBag = DisposeBag()
    
    init(
        articlesRepository: ArticlesRepository = ArticlesRepositoryImpl(),
        articleSourceManager: ArticleSourceManager,
        savedArticlesManager: SavedArticlesManager
    ) {
        self.articlesRepository = articlesRepository
        self.articleSourceManager = articleSourceManager
        self.savedArticlesManager = savedArticlesManager
        loadData()
    }
    
    func loadData() {
        disposeBag = DisposeBag()
        
        isLoading.accept(true)
        
        let sourceIds = articleSourceManager.getSelectedSourceIds()
        
        Observable.combineLatest(
            articlesRepository.fetchHeadlineArticles(with: sourceIds),
            savedArticlesManager.getObservableSavedArticles()
        )
        .subscribe(onNext: { [weak self] (headlines, savedArticles) in
            let articlesContents = headlines.map { headline in
                headline.toArticleCellContent(isSaved: savedArticles.contains(where: { $0.title == headline.title }))}
            self?.content.accept(Content(headlineContents: articlesContents))
            self?.isLoading.accept(false)
        }, onError: { [weak self] error in
            self?.isLoading.accept(false)
            if let error = error as? LKNetworkError {
                self?.errorMessage.accept(error.localizedDescription)
            }
        })
        .disposed(by: disposeBag)
    }
    
    func saveOrRemoveArticle(with article: ArticleCellContent) {
        let savedArticles = savedArticlesManager.getSavedArticles()
        let isArticleExisting = savedArticles.contains(where: { $0.title == article.title })
        isArticleExisting ? savedArticlesManager.removeArticle(with: article.title) : savedArticlesManager.add(article: article)
    }
}

extension HeadlinesViewModel {
    struct Content: Hashable {
        let headlineContents: [ArticleCellContent]
    }
}
