//
//  LKLoadingViewController.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit
import SnapKit

class LKLoadingViewController: UIViewController {
    lazy var containerView = UIView(frame: view.bounds)
    
    /// Displays a loading view overlay with an activity indicator.
    func showLoadingView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(containerView)
        }

        activityIndicator.startAnimating()
    }
    
    /// Removes the loading view overlay from the view hierarchy.
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
        }
    }
}
