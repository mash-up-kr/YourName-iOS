//
//  MockDecodingService.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/21.
//

@testable import YourName
import Foundation

final class MockDecodingService: Decoder {
  var calledDecode = false
  var passedTypeName: String = ""
  
  func decode<T: Decodable>(to type: T.Type, of data: Data) throws -> T {
    calledDecode = true
    passedTypeName = "\(type)"
    throw NSError(domain: "", code: -1)
  }
}
