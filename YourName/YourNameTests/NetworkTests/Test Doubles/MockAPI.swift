//
//  MockAPI.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/21.
//

@testable import YourName
import Foundation

final class MockAPI: API {
  typealias Response = TestResponse
    
  func asURLRequest() -> URLRequest {
    return URLRequest(url: URL(string: "https://www.naver.com")!)
  }
}
