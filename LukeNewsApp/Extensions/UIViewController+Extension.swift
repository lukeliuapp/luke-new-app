//
//  UIViewController+Extension.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

extension UIViewController {
    /// Presents a custom LKAlertViewController on the main thread.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The descriptive text that provides more details about the reason for the alert.
    ///   - buttonTitle: The title of the action button on the alert.
    ///
    /// This method ensures that the alert is presented on the main thread, which is necessary
    /// for all UI updates in iOS. It configures the alert with full screen presentation and a cross dissolve
    /// transition to smoothly present the alert over the current view controller's content.
    func presentLKAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = LKAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
