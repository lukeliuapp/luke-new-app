//
//  GetSavedArticlesUseCase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol GetSavedArticlesUseCase {
    func getSavedArticles() -> [ArticleCellContent]
    func getObservableSavedArticles() -> Observable<[ArticleCellContent]>
}

final class GetSavedArticlesUseCaseImpl: GetSavedArticlesUseCase {
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func getSavedArticles() -> [ArticleCellContent] {
        return userDefaultsRepository.savedArticles.value
            .compactMap { data in
                return try? JSONDecoder().decode(ArticleCellContent.self, from: data)
            }
    }
    
    func getObservableSavedArticles() -> Observable<[ArticleCellContent]> {
        return userDefaultsRepository.savedArticles.observable
            .compactMap { dataArray in
                return dataArray.compactMap { data in
                    return try? JSONDecoder().decode(ArticleCellContent.self, from: data)
                }
            }
    }
}
