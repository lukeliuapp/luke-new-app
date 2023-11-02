//
//  MainTabBarViewModel.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import UIKit

class MainTabBarViewModel {
    
    let userDefaults: UserDefaults
    let userDefaultsRepository: UserDefaultsRepository
    
    let addArticleUseCase: AddArticleUseCase
    let removeArticleUseCase: RemoveArticleUseCase
    let getSavedArticlesUseCase: GetSavedArticlesUseCase
    let savedArticlesManager: SavedArticlesManager
    
    let addSourceUseCase: AddArticleSourceUseCase
    let removeSourceUseCase: RemoveArticleSourceUseCase
    let getSelectedSourcesUseCase: GetSelectedArticleSourcesUseCase
    let articleSourceManager: ArticleSourceManager
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.userDefaultsRepository = UserDefaultsRepositoryImpl(userDefaults: userDefaults)
        
        self.addArticleUseCase = AddArticleUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.removeArticleUseCase = RemoveArticleUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.getSavedArticlesUseCase = GetSavedArticlesUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.savedArticlesManager = SavedArticlesManagerImpl(addArticleUseCase: addArticleUseCase, removeArticleUseCase: removeArticleUseCase, getSavedArticlesUseCase: getSavedArticlesUseCase)
        
        self.addSourceUseCase = AddArticleSourceUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.removeSourceUseCase = RemoveArticleSourceUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.getSelectedSourcesUseCase = GetSelectedArticleSourcesUseCaseImpl(userDefaultsRepository: userDefaultsRepository)
        self.articleSourceManager = ArticleSourceManagerImpl(addSourceUseCase: addSourceUseCase, removeSourceUseCase: removeSourceUseCase, getSelectedSourcesUseCase: getSelectedSourcesUseCase)
    }
    
    func createHeadlinesViewController() -> UIViewController {
        let headlinesViewModel = HeadlinesViewModel(articleSourceManager: articleSourceManager, savedArticlesManager: savedArticlesManager)
        let headlinesViewController = HeadlinesViewController(viewModel: headlinesViewModel)
        headlinesViewController.tabBarItem = UITabBarItem(title: "Headlines", image: UIImage(systemName: "newspaper"), tag: 0)
        return UINavigationController(rootViewController: headlinesViewController)
    }
    
    func createSourcesViewController() -> UIViewController {
        let sourcesViewModel = SourcesViewModel(articleSourceManager: articleSourceManager)
        let sourcesViewController = SourcesViewController(viewModel: sourcesViewModel)
        sourcesViewController.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        return UINavigationController(rootViewController: sourcesViewController)
    }
    
    func createSavedArticlesViewController() -> UIViewController {
        let savedArticlesViewModle = SavedArticlesViewModel(savedArticlesManager: savedArticlesManager)
        let savedArticlesViewController = SavedArticlesViewController(viewModel: savedArticlesViewModle)
        savedArticlesViewController.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 2)
        return UINavigationController(rootViewController: savedArticlesViewController)
    }
    
}
