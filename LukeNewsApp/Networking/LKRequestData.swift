//
//  LKRequestData.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct LKRequestData {
    let httpMethod: HttpMethod
        var url: URL?
        
        init(httpMethod: HttpMethod, urlString: String, apiKey: String? = nil, parameters: [String: String]? = nil) {
            self.httpMethod = httpMethod
            
            var components = URLComponents(string: urlString)
            var queryItems = [URLQueryItem]()
            
            if let apiKey = apiKey {
                queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
            }
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
            }
            
            components?.queryItems = queryItems
            self.url = components?.url
        }
}
