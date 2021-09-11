//
//  MockURLSession.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/19.
//

@testable import YourName
import Foundation

final class MockSession: Connectable {
  var calledDataTask: Bool = false
  var completedURLs: [URL] = []
  
  func dataTask(
    with urlRequestConvertible: URLRequestConvertible,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> DataTask {
    let url = urlRequestConvertible.asURLRequest().url!
    calledDataTask = true
    return MockDataTask(
      url: url,
      completionHandler: { data, urlResponse, error in
        if let httpResponse = urlResponse as? HTTPURLResponse,
           200...300 ~= httpResponse.statusCode,
           let completedURL = httpResponse.url {
          self.completedURLs.append(completedURL)
        }
        completionHandler(data, urlResponse, error)
      }
    )
  }
}
