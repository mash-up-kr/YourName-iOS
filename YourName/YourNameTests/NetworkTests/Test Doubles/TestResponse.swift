//
//  TestResponse.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/11.
//

import Foundation

@testable import YourName
import Foundation

struct TestResponse: Decodable {
    var test: Int
}
extension TestResponse {
    static var stub: TestResponse = TestResponse(test: 0)
}
