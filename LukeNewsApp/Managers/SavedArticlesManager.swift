//
//  SavedArticlesManager.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol SavedArticlesManager {
    func add(article: ArticleCellContent)
    func removeArticle(with title: String)
    func getSavedArticles() -> [ArticleCellContent]
    func getObservableSavedArticles() -> Observable<[ArticleCellContent]>
}

class SavedArticlesManagerImpl: SavedArticlesManager {
    let addArticleUseCase: AddArticleUseCase
    let removeArticleUseCase: RemoveArticleUseCase
    let getSavedArticlesUseCase: GetSavedArticlesUseCase
    
    init(
        addArticleUseCase: AddArticleUseCase,
        removeArticleUseCase: RemoveArticleUseCase,
        getSavedArticlesUseCase: GetSavedArticlesUseCase
    ) {
        self.addArticleUseCase = addArticleUseCase
        self.removeArticleUseCase = removeArticleUseCase
        self.getSavedArticlesUseCase = getSavedArticlesUseCase
    }
    
    func add(article: ArticleCellContent) {
        addArticleUseCase.add(article: article)
    }
    
    func removeArticle(with title: String) {
        removeArticleUseCase.removeArticle(with: title)
    }
    
    func getSavedArticles() -> [ArticleCellContent] {
        return getSavedArticlesUseCase.getSavedArticles()
    }
    
    func getObservableSavedArticles() -> Observable<[ArticleCellContent]> {
        return getSavedArticlesUseCase.getObservableSavedArticles()
    }
}
