//
//  AddArticleSourceUseCase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

protocol AddArticleSourceUseCase {
    func add(id: String)
}

final class AddArticleSourceUseCaseImpl: AddArticleSourceUseCase {
    private var userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func add(id: String) {
        userDefaultsRepository.selectedSourceIDs.value.append(id)
    }
}
