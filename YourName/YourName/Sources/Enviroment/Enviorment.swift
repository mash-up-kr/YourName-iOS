//
//  Enviorment.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

struct Enviorment {
    var network: Network
}

extension Enviorment {
    static var current = Enviorment(network: HTTPClient.shared)
}
