//
//  AuthResponseType.swift
//  YourName
//
//  Created by 송서영 on 2021/09/12.
//

import Foundation

struct OAuthResponseType {
    
    private let accessToken: String
    private let refreshToken: String
    // + 추가 필요한 정보들..?
    
    init(accessToken: String,
         refreshToken: String) {

        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        저장()
    }
}

extension OAuthResponseType {
    private func 저장() {
        // Userdefault에 저장?
    }
}
