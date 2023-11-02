//
//  LKHttpClient.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import RxCocoa
import RxSwift

class LKHttpClient: LKHttpClientProtocol {
    
    private let session: LKCodableURLSessionProtocol
    
    init(session: LKCodableURLSessionProtocol) {
        self.session = session
    }
    
    func request<T: Codable>(with requestData: LKRequestData) -> Observable<T> {
            return Observable.create { observer in
                guard let url = requestData.url else {
                    observer.onError(LKNetworkError.invalidURL)
                    return Disposables.create()
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = requestData.httpMethod.rawValue
                
                let task = self.session.codableDataTask(with: urlRequest) { (result: Result<T, LKNetworkError>) in
                    switch result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
}

extension URLSessionTask: LKURLSessionDataTaskProtocol { }

extension URLSession: LKCodableURLSessionProtocol {
    func codableDataTask<T: Codable>(with urlRequest: URLRequest, completed: @escaping (Result<T, LKNetworkError>) -> Void) -> LKURLSessionDataTaskProtocol {
        return self.dataTask(with: urlRequest) { (data, response, error) in
            // Handling HTTP errors and network errors
            if let error = error {
                completed(.failure(LKNetworkError.custom(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completed(.failure(.invalidData))
                return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                // Success responses
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data, let t = try? decoder.decode(T.self, from: data) {
                    completed(.success(t))
                } else {
                    completed(.failure(.decodeFailed))
                }
                
            default:
                // API error responses
                if let data = data {
                    let decoder = JSONDecoder()
                    if let apiError = try? decoder.decode(LKAPIError.self, from: data) {
                        completed(.failure(LKNetworkError.custom(apiError.message)))
                    } else {
                        completed(.failure(.invalidData))
                    }
                } else {
                    completed(.failure(.invalidData))
                }
            }
        }
    }
}

// MARK: - Protocols

protocol LKCodableURLSessionProtocol {
    func codableDataTask<T: Codable>(with urlRequest: URLRequest, completed: @escaping (Result<T, LKNetworkError>) -> Void) -> LKURLSessionDataTaskProtocol
}

protocol LKURLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol LKHttpClientProtocol {
    func request<T: Codable>(with requestData: LKRequestData) -> Observable<T>
}
