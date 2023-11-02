//
//  ArticlesRepository.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol ArticlesRepository {
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]>
}

class ArticlesRepositoryImpl: ArticlesRepository {
    private let apiService: LKApiServiceProtocol
    
    init(apiService: LKApiServiceProtocol = LKApiService()) {
        self.apiService = apiService
    }
    
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]> {
        return apiService.fetchHeadlineArticles(with: sourceIds)
    }
}
