//
//  GetSelectedArticleSourcesUseCase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol GetSelectedArticleSourcesUseCase {
    func getSelectedSourceIDs() -> [String]
    func getObsavableSelectedSourceIDs() -> Observable<[String]>
}

final class GetSelectedArticleSourcesUseCaseImpl: GetSelectedArticleSourcesUseCase {
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func getSelectedSourceIDs() -> [String] {
        return userDefaultsRepository.selectedSourceIDs.value
    }
    
    func getObsavableSelectedSourceIDs() -> Observable<[String]> {
        return userDefaultsRepository.selectedSourceIDs.observable
    }
}
