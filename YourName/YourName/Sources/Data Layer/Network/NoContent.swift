//
//  NoContent.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

struct NoContent: Decodable {}

extension Data {
    static let emptyData = "{}".data(using: .utf8)!
}
