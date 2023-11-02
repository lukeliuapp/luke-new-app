//
//  LKRequestDataTests.swift
//  LukeNewsAppTests
//
//  Created by Luke Liu on 2/11/2023.
//

import XCTest
@testable import LukeNewsApp

final class LKRequestDataTests: XCTestCase {
    func testURLConstruction() {
        let requestData = LKRequestData(httpMethod: .get, urlString: "https://example.com", apiKey: "api_key", parameters: ["param": "value"])
        XCTAssertEqual(requestData.url?.absoluteString, "https://example.com?apiKey=api_key&param=value")
    }
}
