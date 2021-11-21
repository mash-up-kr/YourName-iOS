//
//  Environment.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

struct Environment {
    var network: NetworkServing
}

extension Environment {
    static var current = Environment(network: NetworkService())
}
