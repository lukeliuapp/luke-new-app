//
//  SavedArticlesViewModel.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import RxCocoa
import RxSwift

class SavedArticlesViewModel {
    let title: Driver<String> = .just("Saved Articles")
    let content: BehaviorRelay<HeadlinesViewModel.Content?> = .init(value: nil)
    
    private let savedArticlesManager: SavedArticlesManager
    private var disposeBag = DisposeBag()
    
    init(savedArticlesManager: SavedArticlesManager) {
        self.savedArticlesManager = savedArticlesManager
        loadData()
    }
    
    func loadData() {
        disposeBag = DisposeBag()
        
        savedArticlesManager.getObservableSavedArticles()
            .subscribe(
                onNext: { [weak self] contents in
                    let contents = contents.map { content in
                        var content = content
                        content.isSaved = true
                        return content
                    }
                    self?.content.accept(HeadlinesViewModel.Content(headlineContents: contents))
                },
                onError: { error in
                    
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeSavedArticle(with article: ArticleCellContent) {
        savedArticlesManager.removeArticle(with: article.title)
    }
}
