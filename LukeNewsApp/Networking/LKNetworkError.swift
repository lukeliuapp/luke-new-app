//
//  LKNetworkError.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import Foundation

/// Networking request errors
enum LKNetworkError: Error {
    case invalidURL
    case invalidData
    case decodeFailed
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .invalidData:
            return "The data received from the server was invalid. Please try again."
        case .decodeFailed:
            return "Decode data failed. Please try again."
        case .custom(let message):
            return message
        }
    }
}
