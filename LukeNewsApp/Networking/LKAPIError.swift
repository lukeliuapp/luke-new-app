//
//  LKAPIError.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

struct LKAPIError: Decodable {
    let status: String
    let code: String
    let message: String
}
