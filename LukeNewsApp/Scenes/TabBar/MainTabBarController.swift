//
//  MainTabBarController.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let viewModel = MainTabBarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .systemGray6
        tabBar.tintColor = .systemPink

        viewControllers = [
            viewModel.createHeadlinesViewController(),
            viewModel.createSourcesViewController(),
            viewModel.createSavedArticlesViewController()
        ]
    }
}

