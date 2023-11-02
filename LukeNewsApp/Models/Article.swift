//
//  Headline.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import Foundation

struct Article: Codable {
    let source: SimpleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct SimpleSource: Codable {
    let id: String
    let name: String
}
