//
//  LKHttpClientTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import LukeNewsApp

final class LKHttpClientTests: XCTestCase {

    var subject: LKHttpClient!
    var urlSession: MockURLSession!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        urlSession = MockURLSession()
        subject = LKHttpClient(session: urlSession)
        disposeBag = DisposeBag()
    }
    
    func testRequestSuccess() {
        // Arrange
        let expectedData = Source(id: "test-id", name: "test-name", description: "test-description", url: "https://example.com/testsource", category: "test-category", language: "en", country: "au")
        urlSession.nextData = try? JSONEncoder().encode(expectedData)
        
        let requestData = LKRequestData(httpMethod: .get, urlString: "https://example.com")
        
        // Act & Assert
        let expectation = self.expectation(description: "Observable completed")
        
        subject.request(with: requestData).subscribe(onNext: { (data: Source) in
            XCTAssertEqual(data.id, expectedData.id)
            expectation.fulfill()
        }, onError: { error in
            XCTFail("Expected success, but got error: \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    struct DummyCodable: Codable { }

    func testRequestFailure() {
        // Arrange
        urlSession.nextError = NSError(domain: "", code: 0, userInfo: nil)
        
        let requestData = LKRequestData(httpMethod: .get, urlString: "https://example.com")
        
        // Act & Assert
        let expectation = self.expectation(description: "Observable completed")
        
        subject.request(with: requestData).subscribe(onNext: { (data: DummyCodable) in
            XCTFail("Expected error, but got success")
        }, onError: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// MARK: - Mock Classes

class MockURLSessionDataTask: LKURLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {}
}

class MockURLSession: LKCodableURLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func codableDataTask<T: Codable>(with urlRequest: URLRequest, completed: @escaping (Result<T, LKNetworkError>) -> Void) -> LKURLSessionDataTaskProtocol {
        
        if let error = nextError {
            completed(.failure(LKNetworkError.custom(error.localizedDescription)))
            return nextDataTask
        }
        
        if let data = nextData {
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completed(.success(decodedObject))
            } catch {
                completed(.failure(LKNetworkError.decodeFailed))
            }
        } else {
            completed(.failure(LKNetworkError.invalidData))
        }
        
        return nextDataTask
    }
}
