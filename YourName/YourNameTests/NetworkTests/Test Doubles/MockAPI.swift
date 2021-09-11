//
//  MockAPI.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/21.
//

@testable import YourName
import Foundation

final class MockAPI: API {
  struct Response: Decodable {
    var test: Int
  }
  
  func asURLRequest() -> URLRequest {
    return URLRequest(url: URL(string: "https://www.naver.com")!)
  }
}
