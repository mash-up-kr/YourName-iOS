//
//  URLRequestConvertible.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}
