//
//  KaKaoLoginAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import Moya

struct LoginAPI: ServiceAPI {

    private let accessToken: AccessToken
    private let provider: Provider
    
    init(accessToken: AccessToken,
         provider: Provider) {
        
        self.accessToken = accessToken
        self.provider = provider
    }
    
    typealias Response = Entity.Login
    var path: String {
        switch provider {
        case .kakao:
            return "/kakao-login"
        case .apple:
            return "/apple-login"
        }
    }
    var headers: [String: String]? { ["authorization": "Bearer \(accessToken)"] }
    var method: Moya.Method { .post }
    var task: Task { .requestPlain }
}
