//
//  ArticleSourceManager.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol ArticleSourceManager {
    func addSourceId(with sourceId: String)
    func removeSourceId(with sourceId: String)
    func getSelectedSourceIds() -> [String]
    func getObservableSelectedSourceIds() -> Observable<[String]>
}

class ArticleSourceManagerImpl: ArticleSourceManager {
    let addSourceUseCase: AddArticleSourceUseCase
    let removeSourceUseCase: RemoveArticleSourceUseCase
    let getSelectedSourcesUseCase: GetSelectedArticleSourcesUseCase
    
    init(
        addSourceUseCase: AddArticleSourceUseCase,
        removeSourceUseCase: RemoveArticleSourceUseCase,
        getSelectedSourcesUseCase: GetSelectedArticleSourcesUseCase
    ) {
        self.addSourceUseCase = addSourceUseCase
        self.removeSourceUseCase = removeSourceUseCase
        self.getSelectedSourcesUseCase = getSelectedSourcesUseCase
    }
    
    func addSourceId(with sourceId: String) {
        addSourceUseCase.add(id: sourceId)
    }
    
    func removeSourceId(with sourceId: String) {
        removeSourceUseCase.remove(id: sourceId)
    }
    
    func getSelectedSourceIds() -> [String] {
        return getSelectedSourcesUseCase.getSelectedSourceIDs()
    }
    
    func getObservableSelectedSourceIds() -> Observable<[String]> {
        return getSelectedSourcesUseCase.getObsavableSelectedSourceIDs()
    }
}
