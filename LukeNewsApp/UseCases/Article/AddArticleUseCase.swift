//
//  AddArticleUseCase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

protocol AddArticleUseCase {
    func add(article: ArticleCellContent)
}

final class AddArticleUseCaseImpl: AddArticleUseCase {
    private var userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func add(article: ArticleCellContent) {
        do {
            let data = try JSONEncoder().encode(article)
            userDefaultsRepository.savedArticles.value.append(data)
        } catch {
            print("Failed to save HeadlineContent:", error)
        }
    }
}
