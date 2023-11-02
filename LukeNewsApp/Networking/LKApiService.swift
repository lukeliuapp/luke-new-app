//
//  LKApiService.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import RxSwift

protocol LKApiServiceProtocol {
    func fetchSources() -> Observable<[Source]>
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]>
}

struct LKApiService: LKApiServiceProtocol {
    
    static let baseURL = "https://newsapi.org/v2/"
    let apiKey = "c732a45447ba416f87855a5bee454c21"
    
    let httpClient: LKHttpClientProtocol
    
    init(with httpClient: LKHttpClientProtocol = LKHttpClient(session: URLSession.shared)) {
        self.httpClient = httpClient
    }
    
    func fetchSources() -> Observable<[Source]> {
        let url = "\(LKApiService.baseURL)sources"
        let requestData = LKRequestData(httpMethod: .get, urlString: url, apiKey: apiKey)
        
        return httpClient.request(with: requestData)
            .map { (response: SourcesResponse) -> [Source] in
                return response.sources
            }
    }
    
    func fetchHeadlineArticles(with sourceIds: [String]) -> Observable<[Article]> {
        let sourcesParameter = sourceIds.joined(separator: ",")
        let url = "\(LKApiService.baseURL)top-headlines"
        let requestData = LKRequestData(httpMethod: .get, urlString: url, apiKey: apiKey, parameters: ["sources": sourcesParameter])
        
        return httpClient.request(with: requestData)
            .map { (response: ArticlesResponse) -> [Article] in
                return response.articles
            }
    }
}
