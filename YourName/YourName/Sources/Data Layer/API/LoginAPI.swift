//
//  KaKaoLoginAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import Moya

struct LoginAPI: ServiceAPI {
    typealias Response = Entity.Authentication
    
    private let accessToken: AccessToken
    private let provider: Provider
    
    var path: String {
        switch provider {
        case .kakao:
            return "/kakao-login"
        case .apple:
            return "/apple-login"
        }
    }
    var headers: [String: String]? { nil }
    var method: Method { .post }
    var task: NetworkingTask {
        return .requestParameters(parameters: ["accessToken": accessToken],
                                  encoding: JSONEncoding.default)
    }
    
    init(accessToken: AccessToken, provider: Provider) {
        self.accessToken = accessToken
        self.provider = provider
    }
    
}
