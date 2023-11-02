//
//  SourcesRepository.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol SourcesRepository {
    func fetchSources() -> Observable<[Source]>
}

class SourcesRepositoryImpl: SourcesRepository {
    private let apiService: LKApiServiceProtocol
    
    init(apiService: LKApiServiceProtocol = LKApiService()) {
        self.apiService = apiService
    }
    
    func fetchSources() -> Observable<[Source]> {
        return apiService.fetchSources()
    }
}
