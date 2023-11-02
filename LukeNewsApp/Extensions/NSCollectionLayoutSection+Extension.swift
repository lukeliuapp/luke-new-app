//
//  NSCollectionLayoutSection+Extension.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

extension NSCollectionLayoutSection {
    /// Creates a full-width layout section for a UICollectionView.
    ///
    /// - Parameters:
    ///   - estimatedHeight: The estimated height for items in the section.
    ///   - topSpacing: The spacing from the top of the section. Default is 0.
    /// - Returns: A configured NSCollectionLayoutSection.
    static func createFullWidthLayout(estimatedHeight: CGFloat, topSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: topSpacing, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}
