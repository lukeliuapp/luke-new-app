//
//  SourceCellContent.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

struct SourceCellContent: Hashable {
    let id: String
    let name: String
    let description: String
    let category: String
    let language: String
    let showCheckmark: Bool
}
