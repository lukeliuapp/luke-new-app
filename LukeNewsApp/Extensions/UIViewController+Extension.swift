//
//  UIViewController+Extension.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

extension UIViewController {
    func presentLKAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = LKAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
