//
//  MockURLSessionTask.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/19.
//

@testable import YourName
import Foundation

final class MockDataTask: DataTask {
  
  var url: URL
  var completionHandler: (Data?, URLResponse?, Error?) -> Void
  var calledResume: Bool = false
  
  init(
    url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    self.url = url
    self.completionHandler = completionHandler
  }
  
  func resume() {
    calledResume = true
  }
  
  func cancel() {
    
  }
  
  func whenCompletion(
    data: Data? = nil,
    statusCode: Int,
    error: Error? = nil
  ) {
    let response = HTTPURLResponse(
      url: url,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil
    )
    completionHandler(data, response, error)
  }
}
