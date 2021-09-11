//
//  API.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

public protocol API: URLRequestConvertible {
    associatedtype Response: Decodable
}
