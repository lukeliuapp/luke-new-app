//
//  RemoveArticleSourceUseCase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

protocol RemoveArticleSourceUseCase {
    func remove(id: String)
}

final class RemoveArticleSourceUseCaseImpl: RemoveArticleSourceUseCase {
    private var userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func remove(id: String) {
        userDefaultsRepository.selectedSourceIDs.value.removeAll(where: { $0 == id })
    }
}
