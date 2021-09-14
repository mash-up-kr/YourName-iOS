//
//  AuthResponse.swift
//  YourName
//
//  Created by 송서영 on 2021/09/12.
//

import Foundation

enum Provider: String {
    case apple
    case kaKao
}

struct OAuthResponse {
    let accessToken: String
    let provider: Provider
}
