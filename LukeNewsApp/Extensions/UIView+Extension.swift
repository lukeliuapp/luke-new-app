//
//  UIView+Extension.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

extension UIView {
    /// Adds multiple subviews to the view.
    ///
    /// This function simplifies the process of adding multiple subviews
    /// by allowing the addition of a list of views in a single call.
    ///
    /// - Parameter views: A variadic parameter that accepts multiple UIView instances.
    func addSubViews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
