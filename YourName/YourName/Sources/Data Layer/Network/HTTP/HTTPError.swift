//
//  HTTPError.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

enum HTTPError: Error {
    case noData
    case client
    case server
    case unknown
}
