//
//  ReusableView.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    /// Registers a UICollectionViewCell subclass for reuse.
    ///
    /// This generic method uses the type's name for the reusable identifier, avoiding hard-coded strings.
    ///
    /// - Parameter _: The type of the cell to register, which must conform to ReusableView.
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Dequeues a reusable UICollectionViewCell with the specified index path.
    ///
    /// This generic method dequeues a cell of the specified type, which must conform to ReusableView.
    /// It will crash if a cell with the correct identifier cannot be dequeued, indicating a configuration error.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell in the collection view.
    /// - Returns: A UICollectionViewCell of the specified type.
    func dequeueCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
