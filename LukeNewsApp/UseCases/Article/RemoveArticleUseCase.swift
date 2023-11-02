//
//  RemoveArticleUsecase.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

protocol RemoveArticleUseCase {
    func removeArticle(with title: String) -> Result<Void, Error>
}

final class RemoveArticleUseCaseImpl: RemoveArticleUseCase {
    private var userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func removeArticle(with title: String) -> Result<Void, Error> {
        do {
            // Get the saved articles from UserDefaults
            var dataArray = userDefaultsRepository.savedArticles.value
            
            // Filter out the article to be removed
            dataArray = try dataArray.filter { data in
                let savedArticle = try JSONDecoder().decode(ArticleCellContent.self, from: data)
                return savedArticle.title != title
            }
            
            // Update UserDefaults with the modified array
            userDefaultsRepository.savedArticles.value = dataArray
            
            return .success(())
        } catch {
            print("Failed to remove the saved article:", error)
            return .failure(error)
        }
    }
}

