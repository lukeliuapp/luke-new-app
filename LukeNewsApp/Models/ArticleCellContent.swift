//
//  ArticleCellContent.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

struct ArticleCellContent: Hashable, Codable {
    let title: String
    let description: String?
    let content: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var isSaved: Bool
}
