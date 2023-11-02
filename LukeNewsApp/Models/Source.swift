//
//  Source.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import Foundation

struct Source: Codable {
    var id: String
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}
